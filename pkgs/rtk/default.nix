{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "rtk";
  version = "0.42.2";

  src = fetchurl {
    url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-F64lkv5tz8YtC8T66onOUg2BiAFYH/CoOUM19yyRFU0=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp rtk $out/bin/rtk
  '';

  meta = {
    description = "High-performance CLI proxy to minimize LLM token consumption";
    homepage = "https://github.com/rtk-ai/rtk";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rtk";
  };
}
