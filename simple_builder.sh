export PATH="$coreutils/bin:$ghc/bin"
mkdir $out
ghc -o $out/hello $src
