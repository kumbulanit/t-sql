#!/usr/bin/env python3
"""Schema-driven column reference fixer for TechCorp markdown labs.

This utility performs three coordinated steps:
1. Loads the authoritative table/column list from Results.json
2. Scans every markdown file for SQL code blocks and inventories the
   table.column references it finds
3. Corrects column names (and redundant qualifiers) so they align with
   the schema, producing an audit report along the way

Run with --help to see all options. The script defaults to in-place fixes
under tech company/untitled using the co-located Results.json file.
"""

from __future__ import annotations

import argparse
import difflib
import json
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

SQL_LANGS = {"", "sql", "tsql"}
CODE_BLOCK_PATTERN = re.compile(r"```(?P<lang>[^\n]*)\n(?P<body>[\s\S]*?)```", re.IGNORECASE)
REFERENCE_PATTERN = re.compile(
    r"(?<![\w])([A-Za-z_][\w]*|\[[^\]]+\])\.([A-Za-z_][\w]*|\[[^\]]+\])(?:\.([A-Za-z_][\w]*|\[[^\]]+\]))?",
    re.MULTILINE,
)
ALIAS_PATTERN = re.compile(
    r"\b(?:FROM|JOIN|INNER\s+JOIN|LEFT\s+(?:OUTER\s+)?JOIN|RIGHT\s+(?:OUTER\s+)?JOIN|FULL\s+(?:OUTER\s+)?JOIN|CROSS\s+JOIN)\s+"
    r"([A-Za-z0-9_\[\]\.]+)(?:\s+(?:AS\s+)?([A-Za-z_][A-Za-z0-9_\[\]]*))?",
    re.IGNORECASE,
)


def strip_brackets(token: str) -> str:
    """Return token without surrounding brackets."""
    token = token.strip()
    if token.startswith("[") and token.endswith("]"):
        return token[1:-1]
    return token


def normalize_identifier(token: str) -> str:
    """Normalize identifier for case-insensitive comparisons."""
    if token is None:
        return ""
    cleaned = strip_brackets(token)
    if "." in cleaned:
        cleaned = cleaned.split(".")[-1]
    return cleaned.lower()


def format_identifier(original: str, canonical: str) -> str:
    """Format canonical identifier to mirror original quoting when practical."""
    original = original.strip()
    if original.startswith("[") and original.endswith("]"):
        return f"[{canonical}]"
    if re.search(r"[^A-Za-z0-9_]", canonical):
        return f"[{canonical}]"
    return canonical


def line_number_for(text: str, offset: int) -> int:
    """Return 0-based line offset for a char position within text."""
    return text.count("\n", 0, offset)


def is_within_comment(sql: str, match_start: int) -> bool:
    """Cheap check for inline (--) or block (/* */) comments."""
    line_start = sql.rfind("\n", 0, match_start)
    line_end = sql.find("\n", match_start)
    if line_end == -1:
        line_end = len(sql)
    line_text = sql[line_start + 1 : line_end]
    inline_pos = line_text.find("--")
    rel_index = match_start - (line_start + 1)
    if inline_pos != -1 and rel_index >= inline_pos:
        return True

    before = sql[:match_start]
    open_idx = before.rfind("/*")
    close_idx = before.rfind("*/")
    return open_idx != -1 and (close_idx == -1 or close_idx < open_idx)


@dataclass
class ReferenceContext:
    tokens: List[str]
    column_index: int
    table_key: str
    drop_first: bool = False

    @property
    def column_token(self) -> str:
        return self.tokens[self.column_index]

    def render(self, new_column: str) -> str:
        tokens = self.tokens.copy()
        tokens[self.column_index] = new_column
        rendered = tokens[1:] if (self.drop_first and len(tokens) > 2) else tokens
        return ".".join(rendered)


@dataclass
class ChangeRecord:
    file: Path
    line: int
    before: str
    after: str
    reason: str


class SchemaIndex:
    """Utility wrapper around Results.json."""

    def __init__(self, schema_path: Path):
        raw = json.loads(schema_path.read_text(encoding="utf-8"))
        table_map: Dict[str, Dict[str, str]] = defaultdict(dict)
        table_names: Dict[str, str] = {}
        column_lookup: Dict[str, List[str]] = defaultdict(list)

        for entry in raw:
            table = strip_brackets(entry["TableName"].strip())
            column = strip_brackets(entry["ColumnName"].strip())
            table_key = normalize_identifier(table)
            column_key = normalize_identifier(column)
            table_map[table_key][column_key] = column
            table_names[table_key] = table
            column_lookup[column_key].append(table_key)

        self.tables = table_map
        self.table_names = table_names
        self.column_lookup = column_lookup

    def has_table(self, table_key: str) -> bool:
        return table_key in self.tables

    def canonicalize(self, table_key: str, raw_column: str) -> Tuple[Optional[str], Optional[str]]:
        """Return canonical column + reason (case/fuzzy) if known."""
        table = self.tables.get(table_key)
        if not table:
            return None, None

        column_key = normalize_identifier(raw_column)
        if column_key in table:
            canonical = table[column_key]
            if canonical != strip_brackets(raw_column):
                return canonical, "case"
            return canonical, None

        matches = difflib.get_close_matches(column_key, table.keys(), n=1, cutoff=0.78)
        if matches:
            return table[matches[0]], "fuzzy"
        return None, None

    def display_table(self, table_key: str) -> str:
        return self.table_names.get(table_key, table_key)


class ColumnReferenceFixer:
    def __init__(self, schema_path: Path, dry_run: bool = False, verbose: bool = False):
        self.schema = SchemaIndex(schema_path)
        self.dry_run = dry_run
        self.verbose = verbose
        self.change_log: List[ChangeRecord] = []
        self.unresolved: List[Dict[str, object]] = []
        self.usage_counts: Dict[Tuple[str, str], int] = defaultdict(int)
        self.references_seen = 0

    def run(self, directory: Path, pattern: str) -> Dict[str, object]:
        md_files = sorted(directory.glob(pattern))
        total_files = len(md_files)
        files_changed = 0

        for md_file in md_files:
            changed = self._process_markdown_file(md_file)
            if changed:
                files_changed += 1
                if self.verbose:
                    print(f"✔ Fixed {md_file.relative_to(directory)}")

        return {
            "total_files": total_files,
            "files_changed": files_changed,
            "changes": len(self.change_log),
            "unresolved": len(self.unresolved),
        }

    def _process_markdown_file(self, path: Path) -> bool:
        if not path.is_file():
            return False
        original = path.read_text(encoding="utf-8")
        rebuilt: List[str] = []
        last_index = 0
        file_changed = False

        for match in CODE_BLOCK_PATTERN.finditer(original):
            rebuilt.append(original[last_index : match.start()])
            lang = match.group("lang").strip().lower()
            body = match.group("body")

            if lang not in SQL_LANGS:
                rebuilt.append(match.group(0))
            else:
                block_start_line = line_number_for(original, match.start()) + 2
                alias_map = self._build_alias_map(body)
                updated_body, block_changes = self._fix_sql_block(body, alias_map, path, block_start_line)
                if block_changes:
                    file_changed = True
                rebuilt.append(f"```{match.group('lang')}\n{updated_body}```")
            last_index = match.end()

        rebuilt.append(original[last_index:])
        new_content = "".join(rebuilt)

        if file_changed and not self.dry_run:
            path.write_text(new_content, encoding="utf-8")
        return file_changed

    def _build_alias_map(self, sql: str) -> Dict[str, str]:
        aliases: Dict[str, str] = {}
        for match in ALIAS_PATTERN.finditer(sql):
            table_token = match.group(1)
            alias_token = match.group(2)
            if table_token.startswith("("):
                continue  # skip derived tables
            table_name = strip_brackets(table_token.split(".")[-1])
            table_key = normalize_identifier(table_name)
            if not self.schema.has_table(table_key):
                continue
            aliases[table_key] = table_key
            if alias_token:
                aliases[normalize_identifier(alias_token)] = table_key
        return aliases

    def _reference_context(self, tokens: List[str], alias_map: Dict[str, str]) -> Optional[ReferenceContext]:
        if len(tokens) == 2:
            left = normalize_identifier(tokens[0])
            table_key = alias_map.get(left) or (left if self.schema.has_table(left) else None)
            if not table_key:
                return None
            return ReferenceContext(tokens=tokens, column_index=1, table_key=table_key)

        if len(tokens) == 3:
            first = normalize_identifier(tokens[0])
            second = normalize_identifier(tokens[1])
            if second in alias_map and alias_map[second] == first:
                return ReferenceContext(tokens=tokens, column_index=2, table_key=alias_map[second], drop_first=True)
            if second in alias_map and first not in self.schema.tables:
                return ReferenceContext(tokens=tokens, column_index=2, table_key=alias_map[second], drop_first=True)
            if second in self.schema.tables:
                return ReferenceContext(tokens=tokens, column_index=2, table_key=second, drop_first=True)
            if first in self.schema.tables:
                return ReferenceContext(tokens=tokens, column_index=1, table_key=first)
        return None

    def _fix_sql_block(
        self,
        body: str,
        alias_map: Dict[str, str],
        file_path: Path,
        block_start_line: int,
    ) -> Tuple[str, List[ChangeRecord]]:
        parts: List[str] = []
        last_index = 0
        block_changes: List[ChangeRecord] = []
        modified = False

        for match in REFERENCE_PATTERN.finditer(body):
            start, end = match.span()
            parts.append(body[last_index:start])

            if is_within_comment(body, start):
                parts.append(match.group(0))
                last_index = end
                continue

            tokens = [match.group(1), match.group(2)]
            if match.group(3):
                tokens.append(match.group(3))
            context = self._reference_context(tokens, alias_map)
            if not context:
                parts.append(match.group(0))
                last_index = end
                continue

            self.references_seen += 1
            canonical, reason = self.schema.canonicalize(context.table_key, context.column_token)
            usage_column = canonical or strip_brackets(context.column_token)
            self.usage_counts[(context.table_key, normalize_identifier(usage_column))] += 1

            column_changed = False
            formatted_column = context.column_token
            if canonical:
                formatted_column = format_identifier(context.column_token, canonical)
                column_changed = formatted_column != context.column_token
            else:
                self.unresolved.append(
                    {
                        "file": str(file_path),
                        "line": block_start_line + line_number_for(body, start),
                        "table": self.schema.display_table(context.table_key),
                        "column": context.column_token,
                        "snippet": match.group(0),
                    }
                )

            new_text = context.render(formatted_column)
            parts.append(new_text)
            last_index = end

            if new_text != match.group(0):
                modified = True
                reason_bits: List[str] = []
                if context.drop_first:
                    reason_bits.append("removed duplicate qualifier")
                if column_changed:
                    if reason == "fuzzy":
                        reason_bits.append(f"column -> {canonical} (fuzzy)")
                    elif reason == "case":
                        reason_bits.append(f"column -> {canonical}")
                    else:
                        reason_bits.append("column normalized")
                change = ChangeRecord(
                    file=file_path,
                    line=block_start_line + line_number_for(body, start),
                    before=match.group(0),
                    after=new_text,
                    reason=", ".join(reason_bits) or "format tweak",
                )
                block_changes.append(change)
                self.change_log.append(change)

        parts.append(body[last_index:])
        updated_body = "".join(parts) if modified else body
        return updated_body, block_changes

    def report(self) -> str:
        lines: List[str] = ["# Column Reference Fix Report", ""]
        lines.append(f"- Total references inspected: {self.references_seen}")
        lines.append(f"- Changes applied: {len(self.change_log)}")
        lines.append(f"- Unresolved references: {len(self.unresolved)}")
        lines.append("")

        if self.change_log:
            lines.append("## Changes")
            grouped: Dict[str, List[ChangeRecord]] = defaultdict(list)
            for change in self.change_log:
                grouped[str(change.file)].append(change)
            for file_path in sorted(grouped.keys()):
                lines.append(f"### {file_path}")
                for change in grouped[file_path]:
                    lines.append(f"- Line {change.line}: `{change.before}` → `{change.after}` ({change.reason})")
                lines.append("")

        if self.unresolved:
            lines.append("## Unresolved References")
            for issue in self.unresolved:
                lines.append(
                    f"- {issue['file']} (line {issue['line']}): `{issue['snippet']}` — no column named "
                    f"`{issue['column']}` in table `{issue['table']}`"
                )
            lines.append("")

        if self.usage_counts:
            lines.append("## Column Usage (top 20)")
            sorted_usage = sorted(self.usage_counts.items(), key=lambda item: item[1], reverse=True)[:20]
            for (table_key, column_key), count in sorted_usage:
                table_name = self.schema.display_table(table_key)
                column_name = self.schema.tables[table_key].get(column_key, column_key)
                lines.append(f"- {table_name}.{column_name}: {count}")
            lines.append("")

        return "\n".join(lines).strip() + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate and fix column references using Results.json")
    parser.add_argument(
        "--schema",
        type=Path,
        default=Path("tech company/untitled/Results.json"),
        help="Path to Results.json",
    )
    parser.add_argument(
        "--directory",
        type=Path,
        default=Path("tech company/untitled"),
        help="Root directory to scan for markdown files",
    )
    parser.add_argument(
        "--pattern",
        default="**/*.md",
        help="Glob pattern (relative to directory) identifying markdown files",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Scan and report without modifying any files",
    )
    parser.add_argument(
        "--report",
        type=Path,
        help="Optional path to save a detailed markdown report",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print per-file updates",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    fixer = ColumnReferenceFixer(args.schema, dry_run=args.dry_run, verbose=args.verbose)
    summary = fixer.run(args.directory, args.pattern)

    print("Summary")
    print("------")
    print(f"Files scanned : {summary['total_files']}")
    print(f"Files changed : {summary['files_changed']}")
    print(f"References    : {fixer.references_seen}")
    print(f"Changes       : {summary['changes']}")
    print(f"Unresolved    : {summary['unresolved']}")

    if args.report:
        report_text = fixer.report()
        args.report.write_text(report_text, encoding="utf-8")
        print(f"Report written to {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
