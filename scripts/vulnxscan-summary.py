#!/usr/bin/env python3
"""Highlight critical findings with scanner-reported fixes and runtime parents."""

import csv
import json
import sys
from collections import defaultdict
from pathlib import Path

report, evidence_path, graph_path = map(Path, sys.argv[1:])
evidence = json.loads(evidence_path.read_text())
fixes = defaultdict(set)
for observation in evidence["observations"]:
    if observation.get("fix_state") == "fixed" and observation.get("fix_versions"):
        fixes[observation["finding_id"]].add(observation["fix_versions"])

components = defaultdict(set)
for component in evidence["components"]:
    components[component["finding_id"]].update(component.get("output_paths", []))

parents = defaultdict(set)
with graph_path.open(newline="") as file:
    for edge in csv.DictReader(file):
        parents[edge["src_path"]].add(edge["target_pname"])

rows = []
if report.exists():
    with report.open(newline="") as file:
        reader = csv.DictReader(file)
        required = {"finding_id", "vuln_id", "package", "version_local", "severity", "grype", "osv", "vulnix"}
        if not required.issubset(reader.fieldnames or []):
            sys.exit("vulnxscan CSV is missing expected columns")
        rows = list(reader)

def critical(row):
    try:
        return float(row["severity"]) >= 9
    except ValueError:
        return False

def cell(value):
    return str(value).replace("|", "\\|").replace("\n", " ")

critical_rows = [row for row in rows if critical(row)]
selected = [row for row in critical_rows if fixes[row["finding_id"]]]
print("## Serverton vulnerability scan")
print()
print("Critical matches with a scanner-reported fixed version. These are candidates, "
      "not confirmed vulnerabilities or confirmed fixes for the pinned Nixpkgs. "
      "Parents are direct runtime references, not necessarily the only paths.")
print()
print(f"{len(selected)} shown; {len(critical_rows) - len(selected)} other critical matches "
      f"lack scanner-reported fix versions. All {len(rows)} findings, evidence and the "
      "dependency graph are in the serverton-vulnxscan artifact.")
print()
if selected:
    print("| Vulnerability | Package | Severity | Scanner-reported fixed versions | Direct dependents |")
    print("| --- | --- | --- | --- | --- |")
    for row in selected:
        finding_id = row["finding_id"]
        dependent_names = sorted({name for path in components[finding_id] for name in parents[path]})
        displayed = ", ".join(dependent_names[:5]) or "Not resolved; see graph"
        if len(dependent_names) > 5:
            displayed += f" (+{len(dependent_names) - 5} more)"
        print("| " + " | ".join(map(cell, [
            row["vuln_id"], f'{row["package"]} {row["version_local"]}', row["severity"],
            "; ".join(sorted(fixes[finding_id])), displayed,
        ])) + " |")
else:
    print("No matches meet both criteria. Review the full artifact for other findings.")
