### On x86_64-linux, NixOS
If you're running NixOS and want to build the Raspberry Pi 4 Image, you'll need to
emulate an arm64 machine by adding the following to your NixOS configuration.

```
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
```

Then you will be able to run `nix build .#images.pi` and get a result you can
flash to an SD Card and boot.

### On x86_64-linux non NixOS

If you are not running NixOS, you will have to follow complicated guides such as
the following for your distribution of choice, to enable binfmt for your
distribution:

- https://wiki.debian.org/QemuUserEmulation

Then you will be able to run `nix build .#images.pi` in the same way and get a
result you can flahs to an SD Card and boot.

### On aarch64-linux any distribution

If you are actually running `nix` on a Pi, you can just `nix build .#images.pi`
and no binfmt stuff is necessary.

### What is binfmt and why is it needed?

To avoid the need to cross-compile anything, and make use of cache.nixos.org,
`nix build .#images.pi` will actually spin up QEMU and emulate an arm64 machine
for every package/derivation that needs to be compiled. Binfmt is a kernel
feature that will transparently spin up a QEMU VM whenever any program tries to
spawn a process for a foreign architecture.

###  Will there be a cross-compilation option?

Yes, soon. But there are some quirks with Python cross-compilation that need to
be worked out first.
