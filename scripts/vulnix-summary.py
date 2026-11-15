#!/usr/bin/env python3
"""Validate vulnix output and render an informational Actions summary."""

import json
import sys
from pathlib import Path

report_path = Path(sys.argv[1])
status = int(sys.argv[2])
if status not in (0, 2):
    sys.exit(f"vulnix failed with exit code {status}")

try:
    findings = json.loads(report_path.read_text())
except (OSError, json.JSONDecodeError) as error:
    sys.exit(f"vulnix did not produce a valid JSON report: {error}")

if not isinstance(findings, list) or (status == 2 and not findings):
    sys.exit("vulnix failed without producing a valid findings report")

print("## Serverton vulnerability scan")
print()
print("vulnix matches package names and versions against NVD; review results for false positives and missing derivations.")
print()
if not findings:
    print("No matches reported.")
else:
    print("| Severity (CVSS v3) | CVE | Package |")
    print("| --- | --- | --- |")
    rows = []
    for finding in findings:
        scores = finding.get("cvssv3_basescore") or {}
        for cve in finding["affected_by"]:
            score = scores.get(cve)
            if not isinstance(score, (int, float)) or not 0 <= score <= 10:
                score = None
            rows.append((score, cve, finding["name"]))
    for score, cve, package in sorted(rows, key=lambda row: (-(row[0] if row[0] is not None else -1), row[1], row[2])):
        severity = ("Unknown" if score is None else
                    "Critical" if score >= 9 else "High" if score >= 7 else
                    "Medium" if score >= 4 else "Low" if score > 0 else "None")
        display = severity if score is None else f"{severity} ({score:.1f})"
        print(f"| {display} | [{cve}](https://nvd.nist.gov/vuln/detail/{cve}) | {package} |")
