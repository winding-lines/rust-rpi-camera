### Building

The project should compile both on Mac OS and cross compile to Raspberry Pi.

The cross-compilation instructions are from
[Ragnaroek](https://github.com/Ragnaroek/rust-on-raspberry-docker), forked.

The docker tag below is referenced form `cross.sh`, adjust both accordingly.

```
docker build -t windinglines19/rpi-local .
sh cross.sh
```


### Deploying

See `upload.sh`.

### Executing

To execute edit `run.sh` to point to your rpi and possibly change the command you want to run

