#!/usr/bin/env python3
"""
SQL Column Reference Validator and Fixer

This script validates column references in T-SQL queries within markdown files
against a schema definition from Results.json. It can detect invalid column
references and optionally fix them with suggestions.

Usage:
    python validate_column_references.py [--fix] [--output report.md]
    
Options:
    --fix           Automatically fix invalid column references where possible
    --output FILE   Write validation report to specified file (default: validation_report.md)
    --verbose       Show detailed progress information
"""

import json
import re
import os
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Set, Tuple
import argparse


class ColumnReferenceValidator:
    """Validates and fixes column references in SQL queries."""
    
    def __init__(self, schema_file: str):
        """Initialize validator with schema from Results.json."""
        self.schema = self._load_schema(schema_file)
        self.table_columns = self._build_table_column_map()
        self.all_columns = self._build_all_columns_set()
        self.issues = []
        
    def _load_schema(self, schema_file: str) -> List[Dict]:
        """Load schema from Results.json."""
        with open(schema_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def _build_table_column_map(self) -> Dict[str, Set[str]]:
        """Build a map of table names to their columns."""
        table_map = defaultdict(set)
        for item in self.schema:
            table_name = item['TableName'].lower()
            column_name = item['ColumnName'].lower()
            table_map[table_name].add(column_name)
        return dict(table_map)
    
    def _build_all_columns_set(self) -> Set[str]:
        """Build a set of all column names across all tables."""
        all_cols = set()
        for item in self.schema:
            all_cols.add(item['ColumnName'].lower())
        return all_cols
    
    def find_table_for_column(self, column: str) -> List[str]:
        """Find which table(s) contain a specific column."""
        column_lower = column.lower()
        tables = []
        for table, columns in self.table_columns.items():
            if column_lower in columns:
                tables.append(table)
        return tables
    
    def validate_column_reference(self, table: str, column: str) -> Tuple[bool, str]:
        """
        Validate if a column exists in the specified table.
        Returns (is_valid, error_message or suggestion).
        """
        table_lower = table.lower()
        column_lower = column.lower()
        
        # Check if table exists
        if table_lower not in self.table_columns:
            return False, f"Table '{table}' does not exist in schema"
        
        # Check if column exists in that table
        if column_lower not in self.table_columns[table_lower]:
            # Try to find the column in other tables
            other_tables = self.find_table_for_column(column)
            if other_tables:
                suggestion = f"Column '{column}' does not exist in table '{table}'. " \
                           f"Found in: {', '.join(other_tables)}"
            else:
                # Column doesn't exist anywhere - check for similar columns
                suggestion = f"Column '{column}' does not exist in table '{table}' or any other table. " \
                           f"Available columns in '{table}': {', '.join(sorted(self.table_columns[table_lower]))}"
            return False, suggestion
        
        return True, "Valid"
    
    def extract_sql_blocks(self, content: str) -> List[Tuple[str, int, int]]:
        """
        Extract SQL code blocks from markdown content.
        Returns list of (sql_content, start_line, end_line).
        """
        sql_blocks = []
        lines = content.split('\n')
        in_sql_block = False
        current_block = []
        start_line = 0
        
        for i, line in enumerate(lines, 1):
            if re.match(r'^```sql', line, re.IGNORECASE):
                in_sql_block = True
                start_line = i + 1
                current_block = []
            elif in_sql_block and line.strip().startswith('```'):
                in_sql_block = False
                if current_block:
                    sql_blocks.append(('\n'.join(current_block), start_line, i - 1))
            elif in_sql_block:
                current_block.append(line)
        
        return sql_blocks
    
    def extract_table_column_references(self, sql: str) -> List[Tuple[str, str, str, int]]:
        """
        Extract table.column references from SQL.
        Returns list of (full_reference, table, column, position).
        """
        references = []
        
        # Pattern for table.column or alias.column
        # Matches: TableName.ColumnName, t.ColumnName, [TableName].[ColumnName], etc.
        pattern = r'\b([a-zA-Z_][\w]*|\[[^\]]+\])\.([a-zA-Z_][\w]*|\[[^\]]+\])\b'
        
        for match in re.finditer(pattern, sql):
            full_ref = match.group(0)
            table_part = match.group(1).strip('[]')
            column_part = match.group(2).strip('[]')
            position = match.start()
            
            # Skip common SQL keywords that might match the pattern
            keywords = {'master', 'sys', 'information_schema', 'dbo', 'tempdb'}
            if table_part.lower() not in keywords:
                references.append((full_ref, table_part, column_part, position))
        
        return references
    
    def extract_table_aliases(self, sql: str) -> Dict[str, str]:
        """
        Extract table aliases from SQL.
        Returns dict of {alias: table_name}.
        """
        aliases = {}
        
        # Pattern for FROM/JOIN table AS alias or FROM/JOIN table alias
        patterns = [
            r'\bFROM\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
            r'\bJOIN\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
            r'\bINNER\s+JOIN\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
            r'\bLEFT\s+(?:OUTER\s+)?JOIN\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
            r'\bRIGHT\s+(?:OUTER\s+)?JOIN\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
            r'\bFULL\s+(?:OUTER\s+)?JOIN\s+([a-zA-Z_][\w]*|\[[^\]]+\])\s+(?:AS\s+)?([a-zA-Z_][\w]+)',
        ]
        
        for pattern in patterns:
            for match in re.finditer(pattern, sql, re.IGNORECASE):
                table_name = match.group(1).strip('[]')
                alias = match.group(2)
                aliases[alias.lower()] = table_name
        
        return aliases
    
    def validate_sql_block(self, sql: str, file_path: str, start_line: int) -> List[Dict]:
        """
        Validate all column references in a SQL block.
        Returns list of issues found.
        """
        issues = []
        
        # Extract table aliases
        aliases = self.extract_table_aliases(sql)
        
        # Extract all table.column references
        references = self.extract_table_column_references(sql)
        
        for full_ref, table_part, column_part, position in references:
            # Skip if this is in a comment (basic check)
            sql_lines = sql.split('\n')
            cumulative_pos = 0
            current_line_num = 0
            current_line = ""
            
            for i, line in enumerate(sql_lines):
                if cumulative_pos + len(line) >= position:
                    current_line_num = i
                    current_line = line
                    break
                cumulative_pos += len(line) + 1  # +1 for newline
            
            # Skip if in a comment
            if '--' in current_line:
                comment_pos = current_line.find('--')
                ref_pos = current_line.find(full_ref)
                if ref_pos > comment_pos:
                    continue  # Reference is in a comment, skip validation
            
            # Resolve alias to actual table name
            table_name = aliases.get(table_part.lower(), table_part)
            
            # Validate the reference
            is_valid, message = self.validate_column_reference(table_name, column_part)
            
            if not is_valid:
                issue = {
                    'file': file_path,
                    'line': start_line + current_line_num,
                    'reference': full_ref,
                    'table': table_name,
                    'column': column_part,
                    'original_table_part': table_part,
                    'message': message,
                    'sql_snippet': current_line.strip()
                }
                issues.append(issue)
        
        return issues
    
    def validate_file(self, file_path: str) -> List[Dict]:
        """Validate all SQL blocks in a markdown file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            sql_blocks = self.extract_sql_blocks(content)
            all_issues = []
            
            for sql, start_line, end_line in sql_blocks:
                issues = self.validate_sql_block(sql, file_path, start_line)
                all_issues.extend(issues)
            
            return all_issues
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            return []
    
    def validate_directory(self, directory: str, pattern: str = "**/*.md") -> Dict:
        """
        Validate all markdown files in directory.
        Returns dict with validation results.
        """
        directory_path = Path(directory)
        md_files = list(directory_path.glob(pattern))
        
        results = {
            'total_files': len(md_files),
            'files_with_issues': 0,
            'total_issues': 0,
            'issues_by_file': {}
        }
        
        for md_file in md_files:
            issues = self.validate_file(str(md_file))
            if issues:
                results['files_with_issues'] += 1
                results['total_issues'] += len(issues)
                results['issues_by_file'][str(md_file)] = issues
        
        return results
    
    def generate_report(self, results: Dict, output_file: str = None) -> str:
        """Generate a markdown report of validation results."""
        report_lines = [
            "# SQL Column Reference Validation Report",
            "",
            f"**Generated:** {Path.cwd()}",
            "",
            "## Summary",
            "",
            f"- **Total Files Scanned:** {results['total_files']}",
            f"- **Files with Issues:** {results['files_with_issues']}",
            f"- **Total Issues Found:** {results['total_issues']}",
            ""
        ]
        
        if results['total_issues'] == 0:
            report_lines.append("✅ **No issues found! All column references are valid.**")
        else:
            report_lines.extend([
                "## Issues by File",
                ""
            ])
            
            for file_path, issues in sorted(results['issues_by_file'].items()):
                rel_path = Path(file_path).name
                report_lines.extend([
                    f"### {rel_path}",
                    "",
                    f"**Issues Found:** {len(issues)}",
                    ""
                ])
                
                for i, issue in enumerate(issues, 1):
                    report_lines.extend([
                        f"#### Issue {i}: Line {issue['line']}",
                        "",
                        f"- **Reference:** `{issue['reference']}`",
                        f"- **Table:** `{issue['table']}`",
                        f"- **Column:** `{issue['column']}`",
                        f"- **Problem:** {issue['message']}",
                        "",
                        "**SQL Snippet:**",
                        "```sql",
                        issue['sql_snippet'],
                        "```",
                        ""
                    ])
        
        report = '\n'.join(report_lines)
        
        if output_file:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(report)
            print(f"\n✅ Report written to: {output_file}")
        
        return report


def main():
    """Main function to run the validator."""
    parser = argparse.ArgumentParser(
        description="Validate SQL column references in markdown files against Results.json schema"
    )
    parser.add_argument(
        '--schema',
        default='Results.json',
        help='Path to Results.json schema file (default: Results.json)'
    )
    parser.add_argument(
        '--directory',
        default='.',
        help='Directory to scan for markdown files (default: current directory)'
    )
    parser.add_argument(
        '--output',
        default='validation_report.md',
        help='Output file for validation report (default: validation_report.md)'
    )
    parser.add_argument(
        '--pattern',
        default='**/*.md',
        help='File pattern to match (default: **/*.md)'
    )
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Show detailed progress information'
    )
    
    args = parser.parse_args()
    
    # Check if schema file exists
    if not os.path.exists(args.schema):
        print(f"❌ Error: Schema file '{args.schema}' not found!")
        return 1
    
    print(f"🔍 SQL Column Reference Validator")
    print(f"=" * 50)
    print(f"📂 Schema file: {args.schema}")
    print(f"📂 Scanning directory: {args.directory}")
    print(f"📄 File pattern: {args.pattern}")
    print()
    
    # Initialize validator
    validator = ColumnReferenceValidator(args.schema)
    
    print(f"📊 Loaded schema with {len(validator.table_columns)} tables")
    if args.verbose:
        print(f"   Tables: {', '.join(sorted(validator.table_columns.keys()))}")
    print()
    
    # Run validation
    print("🔎 Validating files...")
    results = validator.validate_directory(args.directory, args.pattern)
    
    # Generate report
    print("📝 Generating report...")
    validator.generate_report(results, args.output)
    
    # Print summary
    print()
    print("=" * 50)
    print("📊 Validation Complete!")
    print(f"   Files scanned: {results['total_files']}")
    print(f"   Files with issues: {results['files_with_issues']}")
    print(f"   Total issues: {results['total_issues']}")
    
    if results['total_issues'] > 0:
        print(f"\n⚠️  Found {results['total_issues']} issue(s). See {args.output} for details.")
        return 1
    else:
        print("\n✅ All column references are valid!")
        return 0


if __name__ == '__main__':
    exit(main())
