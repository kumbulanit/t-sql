#!/usr/bin/env python3
"""Schema-aware lab fixer.

This utility performs three key tasks:
1. Parses the TechCorp master SQL file to discover every table and column
2. Emits a markdown summary of the schema for quick reference
3. Walks every markdown-based lab in `tech company/untitled/`, fixing column
   references that do not line up with the authoritative schema. The fixer
   understands table aliases, performs fuzzy matching, and applies special
   handlers for the tricky Customers table (ContactName, Email, etc.).
"""

from __future__ import annotations

import argparse
import difflib
import re
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple

ROOT = Path(__file__).resolve().parent
MASTER_SQL = ROOT / "tech company" / "00_TechCorp_MASTER_Setup.sql"
LABS_DIR = ROOT / "tech company" / "untitled"
SCHEMA_SUMMARY = ROOT / "tech company" / "schema_summary.md"
REPORT_PATH = ROOT / "tech company" / "sql_validation_report.md"

CREATE_PATTERN = re.compile(r"^\s*CREATE\s+TABLE\s+([A-Za-z0-9_\[\]\.]+)\s*\(", re.IGNORECASE)
ALIAS_PATTERN = re.compile(
    r"\b(FROM|JOIN)\s+([A-Za-z_][A-Za-z0-9_\[\]]*)(?:\s+(?:AS\s+)?([A-Za-z_][A-Za-z0-9_\[\]]*))?",
    re.IGNORECASE,
)
COLUMN_TOKEN_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)\b")
CUSTOMER_STATEMENT_PATTERN = re.compile(
    r"SELECT[\s\S]+?FROM\s+Customers\b(?!\s+(?:AS\s+)?[A-Za-z_])[\s\S]*?(?=;|$)",
    re.IGNORECASE,
)

SPECIAL_COLUMN_HANDLERS = {
    "customers": {
        "companyname": lambda alias: f"{alias}.CustomerName",
        "contactname": lambda alias: f"CONCAT({alias}.ContactFirstName, ' ', {alias}.ContactLastName)",
        "email": lambda alias: f"{alias}.PrimaryEmail",
        "emailaddress": lambda alias: f"{alias}.PrimaryEmail",
        "phone": lambda alias: f"{alias}.PrimaryPhone",
        "phonenumber": lambda alias: f"{alias}.PrimaryPhone",
        "country": lambda alias: f"{alias}.CountryID",
        "address": lambda alias: f"{alias}.StreetAddress",
    }
}

BARE_CUSTOMER_REPLACEMENTS = [
    (re.compile(r"(?<!\.)\bCompanyName\b", re.IGNORECASE), "CustomerName", "CompanyName -> CustomerName"),
    (
        re.compile(r"(?<!\.)\bContactName\b", re.IGNORECASE),
        "CONCAT(ContactFirstName, ' ', ContactLastName)",
        "ContactName -> ContactFirstName+LastName",
    ),
    (re.compile(r"(?<!\.)\bEmail\b", re.IGNORECASE), "PrimaryEmail", "Email -> PrimaryEmail"),
    (re.compile(r"(?<!\.)\bPhone\b", re.IGNORECASE), "PrimaryPhone", "Phone -> PrimaryPhone"),
    (re.compile(r"(?<!\.)\bCountry\b", re.IGNORECASE), "CountryID", "Country -> CountryID"),
]


@dataclass
class BlockReport:
    file: Path
    block_index: int
    start_line: int
    status: str
    issues: List[str]
    sql_preview: str


def calculate_line_number(content: str, start_index: int) -> int:
    """Return the 1-based line number for the regex match start."""
    return content.count('\n', 0, start_index) + 1


def build_sql_preview(body: str, max_lines: int = 3) -> str:
    """Create a compact preview of the SQL block for reporting."""
    stripped_lines = [line.strip() for line in body.strip().splitlines() if line.strip()]
    if not stripped_lines:
        return "(empty block)"
    return " / ".join(stripped_lines[:max_lines])


def normalize_identifier(raw: str) -> str:
    """Return a lower-cased identifier stripped of schema/brackets."""
    cleaned = raw.strip().strip('[]')
    if '.' in cleaned:
        cleaned = cleaned.split('.')[-1]
    return cleaned.lower()


def parse_master_sql(path: Path) -> Dict[str, Dict[str, object]]:
    """Parse the master SQL file and build a table -> columns map."""
    if not path.exists():
        raise FileNotFoundError(f"Master SQL not found: {path}")

    tables: Dict[str, Dict[str, object]] = {}
    lines = path.read_text(encoding="utf-8").splitlines()
    i = 0

    while i < len(lines):
        line = lines[i]
        match = CREATE_PATTERN.match(line)
        if not match:
            i += 1
            continue

        raw_name = match.group(1)
        table_key = normalize_identifier(raw_name)
        table_display = raw_name.strip().strip('[]').split('.')[-1]
        i += 1

        column_order: List[str] = []
        column_lookup: Dict[str, str] = {}

        while i < len(lines):
            current = lines[i].strip()
            if current.startswith(')'):
                break
            if not current or current.startswith('--'):
                i += 1
                continue

            leading = current.split()[0].upper()
            if leading in {"CONSTRAINT", "PRIMARY", "FOREIGN", "UNIQUE", "CHECK"}:
                i += 1
                continue

            col_match = re.match(r"(\[?[A-Za-z0-9_]+\]?)(\s+.+)", current)
            if col_match:
                col_name = col_match.group(1).strip().strip('[]')
                column_order.append(col_name)
                column_lookup[col_name.lower()] = col_name

            i += 1

        tables[table_key] = {
            "name": table_display,
            "columns": column_lookup,
            "order": column_order,
        }

        while i < len(lines) and not lines[i].strip().startswith('CREATE TABLE'):
            if lines[i].strip().startswith(')'):
                i += 1
                break
            i += 1

    return tables


def write_schema_summary(schema: Dict[str, Dict[str, object]], output: Path) -> None:
    """Persist a markdown summary of every table/column."""
    lines: List[str] = ["# TechCorp Master Schema", ""]
    for table_key in sorted(schema.keys()):
        table = schema[table_key]
        lines.append(f"## {table['name']}")
        for column in table["order"]:
            lines.append(f"- {column}")
        lines.append("")

    output.write_text("\n".join(lines), encoding="utf-8")


def build_alias_map(sql: str, schema: Dict[str, Dict[str, object]]) -> Dict[str, str]:
    alias_map: Dict[str, str] = {}
    for match in ALIAS_PATTERN.finditer(sql):
        table_raw = match.group(2)
        alias_raw = match.group(3)
        table_key = normalize_identifier(table_raw)
        if table_key not in schema:
            continue
        alias = alias_raw if alias_raw else schema[table_key]["name"]
        alias_map[normalize_identifier(alias)] = table_key

    for table_key in schema.keys():
        alias_map.setdefault(table_key, table_key)

    return alias_map


def pick_best_column(table_key: str, column: str, schema: Dict[str, Dict[str, object]]) -> Tuple[str, str] | Tuple[None, None]:
    table = schema.get(table_key)
    if not table:
        return None, None

    lookup = table["columns"]
    column_lower = column.lower()
    if column_lower in lookup:
        return lookup[column_lower], "exact"

    special = SPECIAL_COLUMN_HANDLERS.get(table_key, {})
    if column_lower in special:
        handler = special[column_lower]
        return handler, "special"

    candidates = difflib.get_close_matches(column_lower, lookup.keys(), n=1, cutoff=0.8)
    if candidates:
        best = candidates[0]
        return lookup[best], "fuzzy"

    return None, None


def fix_alias_columns(sql: str, alias_map: Dict[str, str], schema: Dict[str, Dict[str, object]]) -> Tuple[str, List[str]]:
    changes: List[str] = []

    def replacer(match: re.Match) -> str:
        alias, column = match.group(1), match.group(2)
        alias_key = alias.lower()
        if alias_key not in alias_map:
            return match.group(0)

        table_key = alias_map[alias_key]
        table = schema.get(table_key)
        if not table:
            return match.group(0)

        lookup = table["columns"]
        column_lower = column.lower()

        if column_lower in lookup:
            canonical = lookup[column_lower]
            if canonical != column:
                changes.append(f"{alias}.{column} -> {alias}.{canonical} ({table['name']})")
            return f"{alias}.{canonical}"

        special = SPECIAL_COLUMN_HANDLERS.get(table_key, {})
        if column_lower in special:
            handler = special[column_lower]
            replacement = handler(alias)
            changes.append(f"{alias}.{column} -> {replacement} ({table['name']} special)")
            return replacement

        candidates = difflib.get_close_matches(column_lower, lookup.keys(), n=1, cutoff=0.8)
        if candidates:
            canonical = lookup[candidates[0]]
            changes.append(f"{alias}.{column} -> {alias}.{canonical} ({table['name']} fuzzy)")
            return f"{alias}.{canonical}"

        return match.group(0)

    new_sql = COLUMN_TOKEN_PATTERN.sub(replacer, sql)
    return new_sql, changes


def apply_bare_customer_replacements(segment: str) -> Tuple[str, List[str]]:
    changes: List[str] = []
    updated = segment
    for pattern, replacement, description in BARE_CUSTOMER_REPLACEMENTS:
        updated, count = pattern.subn(replacement, updated)
        if count:
            changes.append(f"Customers (no alias): {description} x{count}")
    return updated, changes


def fix_bare_customer_segments(sql: str) -> Tuple[str, List[str]]:
    changes: List[str] = []

    def repl(match: re.Match) -> str:
        segment = match.group(0)
        updated, seg_changes = apply_bare_customer_replacements(segment)
        changes.extend(seg_changes)
        return updated

    new_sql = CUSTOMER_STATEMENT_PATTERN.sub(repl, sql)
    return new_sql, changes


def process_sql_block(block: str, schema: Dict[str, Dict[str, object]]) -> Tuple[str, List[str]]:
    alias_map = build_alias_map(block, schema)
    updated, changes = fix_alias_columns(block, alias_map, schema)
    updated, bare_changes = fix_bare_customer_segments(updated)
    changes.extend(bare_changes)
    return updated, changes


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate and fix TechCorp SQL labs.")
    parser.add_argument(
        "--mode",
        choices={"fix", "report"},
        default="fix",
        help="Run in 'fix' mode to auto-correct files or 'report' mode to generate a validation report.",
    )
    parser.add_argument(
        "--report-path",
        type=Path,
        default=REPORT_PATH,
        help="Destination markdown file for validation results (report mode only).",
    )
    return parser.parse_args()


def write_validation_report(rows: List[BlockReport], output_path: Path) -> None:
    total = len(rows)
    passed = sum(1 for row in rows if row.status == "pass")
    failed = total - passed

    lines: List[str] = [
        "# SQL Validation Report",
        "",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"- Total SQL blocks: {total}",
        f"- ✅ Passed: {passed}",
        f"- ❌ Failed: {failed}",
        "",
    ]

    for row in rows:
        rel_path = row.file.relative_to(ROOT)
        icon = "✅" if row.status == "pass" else "❌"
        lines.append(f"{icon} **{rel_path}** (block {row.block_index}, line {row.start_line})")
        lines.append(f"> {row.sql_preview}")
        if row.issues:
            lines.append("Errors:")
            for issue in row.issues:
                lines.append(f"- {issue}")
        lines.append("")

    output_path.write_text("\n".join(lines).strip() + "\n", encoding="utf-8")


def print_console_report(rows: List[BlockReport]) -> None:
    for row in rows:
        rel_path = row.file.relative_to(ROOT)
        icon = "✅" if row.status == "pass" else "❌"
        print(f"{icon} {rel_path} (block {row.block_index}, line {row.start_line})")
        if row.issues:
            for issue in row.issues:
                print(f"    - {issue}")


def process_markdown_file(
    path: Path,
    schema: Dict[str, Dict[str, object]],
    *,
    mode: str = "fix",
    reporter: List[BlockReport] | None = None,
) -> Tuple[bool, List[str]]:
    content = path.read_text(encoding="utf-8")
    block_pattern = re.compile(r"```(?P<lang>[^\n]*)\n(?P<body>[\s\S]*?)```", re.IGNORECASE)
    file_changes: List[str] = []
    block_counter = 0
    file_was_changed = False

    def replace_block(match: re.Match) -> str:
        nonlocal block_counter, file_was_changed
        lang = match.group("lang").strip().lower()
        body = match.group("body")
        if lang not in {"", "sql", "tsql"}:
            return match.group(0)

        block_counter += 1
        updated_body, changes = process_sql_block(body, schema)
        start_line = calculate_line_number(content, match.start())
        status = "pass" if not changes else "fail"

        if reporter is not None:
            reporter.append(
                BlockReport(
                    file=path,
                    block_index=block_counter,
                    start_line=start_line,
                    status=status,
                    issues=list(changes),
                    sql_preview=build_sql_preview(body),
                )
            )

        if mode == "fix" and changes:
            file_changes.extend([f"[block {block_counter}] {change}" for change in changes])
            file_was_changed = True
            return f"```{match.group('lang')}\n{updated_body}```"

        return match.group(0)

    updated_content = block_pattern.sub(replace_block, content)
    if mode == "fix" and file_was_changed:
        path.write_text(updated_content, encoding="utf-8")
    return file_was_changed, file_changes


def main() -> None:
    args = parse_args()
    schema = parse_master_sql(MASTER_SQL)
    write_schema_summary(schema, SCHEMA_SUMMARY)
    print(f"Captured schema for {len(schema)} tables. Summary saved to {SCHEMA_SUMMARY.relative_to(ROOT)}")

    if not LABS_DIR.exists():
        raise FileNotFoundError(f"Labs directory missing: {LABS_DIR}")

    md_files = sorted(LABS_DIR.rglob('*.md'))
    print(f"Scanning {len(md_files)} markdown labs for schema alignment...")

    if args.mode == "fix":
        total_changes = 0
        for md_file in md_files:
            changed, change_list = process_markdown_file(md_file, schema, mode="fix")
            if changed:
                total_changes += 1
                print(f"  ✓ {md_file.relative_to(LABS_DIR)} -> {len(change_list)} fixes")
        print(f"Completed. Updated {total_changes} files.")
    else:
        report_rows: List[BlockReport] = []
        for md_file in md_files:
            process_markdown_file(md_file, schema, mode="report", reporter=report_rows)
        write_validation_report(report_rows, args.report_path)
        print_console_report(report_rows)
        try:
            relative_report = args.report_path.relative_to(ROOT)
        except ValueError:
            relative_report = args.report_path
        print(f"Validation report saved to {relative_report}")


if __name__ == "__main__":
    main()
