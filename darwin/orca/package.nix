# Orca from my fork (antoncuranz/orca, branch `fork`): an Orca release plus a few plugin host API
# changes, until they land upstream. The fork's CI publishes an ad-hoc signed Apple Silicon build,
# so this only unpacks it. Nothing in the bundle may change or its signature breaks: no fixup
# phase. The fork's FORK.md describes how it follows Orca releases.
{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orca";
  version = "1.4.281-fork.1";

  src = fetchurl {
    url = "https://github.com/antoncuranz/orca/releases/download/v${finalAttrs.version}/orca-macos-arm64.zip";
    hash = "sha256-l4JlAJDHU0W8uw5C7ZuUodO7AmmstQYZp7SLKkDJv/E=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -R Orca.app $out/Applications/
    # The launcher resolves this symlink back to the app bundle.
    ln -s $out/Applications/Orca.app/Contents/Resources/bin/orca $out/bin/orca

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    /usr/bin/codesign --verify --deep --strict $out/Applications/Orca.app
  '';

  meta = {
    description = "Orca, an agent workspace app, with fork-only plugin API changes";
    homepage = "https://github.com/antoncuranz/orca";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "orca";
  };
})
