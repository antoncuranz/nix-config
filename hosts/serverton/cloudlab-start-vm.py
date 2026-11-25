"""Start the fixed Cloudlab domain, recovering its definition when needed."""

import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import libvirt

DOMAIN_NAME = "cloudlab"
DOMAIN_XML = Path("@domain_xml@")


def recover_domain(connection):
    xml = DOMAIN_XML.read_text()
    storage = {
        Path(source.attrib["file"])
        for source in ET.fromstring(xml).findall("./devices/disk/source")
    }
    for path in sorted(storage):
        if path.is_symlink() or not path.is_file():
            raise RuntimeError(f"Recovery requires an existing regular file at {path}")

    for other in connection.listAllDomains():
        for source in ET.fromstring(other.XMLDesc(0)).findall("./devices/disk/source"):
            if (filename := source.get("file")) and Path(filename).resolve() in storage:
                raise RuntimeError(f"{filename} is already attached to {other.name()}")

    return connection.defineXML(xml)


def main():
    if len(sys.argv) != 1:
        raise SystemExit("cloudlab-start-vm accepts no arguments.")

    connection = libvirt.open("qemu:///system")
    try:
        try:
            domain = connection.lookupByName(DOMAIN_NAME)
        except libvirt.libvirtError as error:
            if error.get_error_code() != libvirt.VIR_ERR_NO_DOMAIN:
                raise
            domain = recover_domain(connection)

        if domain.state()[0] == libvirt.VIR_DOMAIN_PAUSED:
            domain.resume()
        elif not domain.isActive():
            domain.create()
        else:
            print("Cloudlab VM is already running.")
            return
        print("Cloudlab VM started.")
    finally:
        connection.close()


if __name__ == "__main__":
    try:
        main()
    except (libvirt.libvirtError, OSError, RuntimeError) as error:
        raise SystemExit(str(error)) from error
