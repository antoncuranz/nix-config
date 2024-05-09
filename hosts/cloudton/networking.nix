{ secrets, ... }:

{
  networking = {
    interfaces.ens3 = {
      ipv4.addresses = [{
        address = "${secrets.cloudton.networking.ip}";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "${secrets.cloudton.networking.ip6}";
        prefixLength = 64;
      }];
    };
    defaultGateway.address = "${secrets.cloudton.networking.gateway}";
    defaultGateway6 = {
      address = "${secrets.cloudton.networking.gateway6}";
      interface = "ens3";
    };
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };
}
