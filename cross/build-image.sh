# Dependencies needed in the host environment (x86_64) to compile build scripts.
sudo apt-get install -y libcurl4-openssl-dev 


# Dependencies needed in the host environment for tflite-rs' build file
sudo apt-get install -y \
  clang \
  libc6-dev-i386 \
  libclang-dev \
  libssl-dev \
  libstdc++ \
  libz-dev \
  llvm \
  llvm-dev \
  make

# Make life easier for dev in the container, start with
#   sh cross.sh run
sudo apt-get install -y \
  file \
  vim 
