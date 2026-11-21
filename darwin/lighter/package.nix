# lighter is not in nixpkgs yet. This mirrors the upstream Homebrew formula
# (fieldwork-ai/homebrew-tap) and scripts/install.sh: unpack the notarized
# release archive as-is. The binaries carry a Developer ID signature with the
# hypervisor (and VM networking) entitlements, so nothing in the payload may be
# modified -- hence no fixup phase (no strip, no patching). The payload lives
# untouched under libexec/lighter; bin/lighter is a small wrapper (wrapper.sh).
{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lighter";
  version = "0.13.11";

  src = fetchurl {
    url = "https://github.com/fieldwork-ai/lighter/releases/download/v${finalAttrs.version}/lighter-${finalAttrs.version}-arm64.tar.gz";
    hash = "sha256-jgET69l+6MjL3P17xZk6PPf06t1taDEWw1Jw9NB72e8=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    # Same layout as the release archive / Homebrew keg: bin/lighter finds its
    # guest image and app bundle at ../share/lighter.
    mkdir -p $out/libexec/lighter $out/bin $out/share/doc/lighter
    cp -R bin share $out/libexec/lighter/
    cp LICENSE-MIT LICENSE-APACHE NOTICE THIRD-PARTY-NOTICES README.md $out/share/doc/lighter/

    substitute ${./wrapper.sh} $out/bin/lighter \
      --subst-var-by real $out/libexec/lighter/bin/lighter
    chmod +x $out/bin/lighter

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    /usr/bin/codesign --verify --strict $out/libexec/lighter/bin/lighter
    /usr/bin/codesign --verify --strict --deep $out/libexec/lighter/share/lighter/lighter.app
    $out/bin/lighter --version
  '';

  meta = {
    description = "Container engine for macOS on Hypervisor.framework, a drop-in Docker backend";
    homepage = "https://github.com/fieldwork-ai/lighter";
    license = with lib.licenses; [ mit asl20 ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "lighter";
  };
})
