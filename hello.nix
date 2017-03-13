with (import <nixpkgs> {});
derivation {
  name = "hello";
  builder = "${bash}/bin/bash";
  args = [ ./simple_builder.sh ];
  inherit ghc;
  src = ./hello.hs;
  system = builtins.currentSystem;
}