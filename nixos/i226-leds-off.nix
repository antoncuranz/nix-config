{ pkgs, ... }:

{
  systemd.services.i226-leds-off = {
    description = "Disable Intel I226 Ethernet LEDs";

    wantedBy = [ "multi-user.target" ];

    # Wait until udev has created the LED class devices.
    after = [
      "systemd-udev-settle.service"
    ];
    wants = [
      "systemd-udev-settle.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      for led in /sys/class/leds/igc-*-led*; do
        if [ ! -e "$led/trigger" ]; then
          continue
        fi

        echo none > "$led/trigger"
        echo 0 > "$led/brightness"
      done
    '';
  };
}
