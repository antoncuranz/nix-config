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
    print("| Package | Potential CVEs |")
    print("| --- | --- |")
    for finding in findings:
        cves = ", ".join(
            f"[{cve}](https://nvd.nist.gov/vuln/detail/{cve})"
            for cve in finding["affected_by"]
        )
        print(f"| {finding['name']} | {cves} |")
