#!/bin/sh
# lighter copies the guest rootfs from its install into $LIGHTER_HOME with
# copyfile(3), which keeps the source's mode. From the Nix store that is 0444,
# so the machine then fails to open its own disk read-write ("console:
# Permission denied"). Make the copy writable and, if that was why start
# failed, try once more. Only the first start after a new rootfs is affected.
real=@real@
home="${LIGHTER_HOME:-$HOME/.lighter}"

fix_rootfs() {
  fixed=1
  for f in "$home/rootfs.ext4" "$home/.rootfs.next"; do
    if [ -f "$f" ] && [ ! -w "$f" ]; then
      chmod u+w "$f" && fixed=0
    fi
  done
  return $fixed
}

fix_rootfs

case "${1:-}" in
  start | restart)
    "$real" "$@" && exit 0
    status=$?
    fix_rootfs && exec "$real" "$@"
    exit $status
    ;;
  *)
    exec "$real" "$@"
    ;;
esac
