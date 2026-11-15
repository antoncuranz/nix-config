#!/usr/bin/env python3
"""Render vulnxscan's CSV as an informational Actions summary."""

import csv
import sys
from pathlib import Path

report = Path(sys.argv[1])
print("## Serverton vulnerability scan")
print()
print("Potential findings from vulnxscan; scanner matches require review. "
      "See the serverton-vulnxscan artifact for full results and evidence.")
print()

if not report.exists():
    if not report.with_name("evidence.json").exists():
        sys.exit("vulnxscan produced neither a report nor evidence")
    print("No findings reported. Check the scan log for warnings.")
    sys.exit(0)

with report.open(newline="") as file:
    reader = csv.DictReader(file)
    required = {"vuln_id", "package", "version", "severity", "grype", "osv", "vulnix"}
    if not required.issubset(reader.fieldnames or []):
        sys.exit("vulnxscan CSV is missing expected columns")
    rows = list(reader)

print(f"{len(rows)} findings. Scanner columns show which scanner reported each match.")
print()
print("| Vulnerability | Package | Version | Severity | Grype | OSV | Vulnix |")
print("| --- | --- | --- | --- | --- | --- | --- |")
for row in rows:
    def cell(key):
        return (row.get(key) or "").replace("|", "\\|").replace("\n", " ")
    print("| " + " | ".join(cell(key) for key in (
        "vuln_id", "package", "version", "severity", "grype", "osv", "vulnix"
    )) + " |")
