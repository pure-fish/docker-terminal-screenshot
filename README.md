# docker-terminal-screenshot

> Pre-built Docker image with **[terminal-screenshot CLI][tss]** for automated terminal screenshot generation.

```sh
docker pull purefish/terminal-screenshot
```

## What's Included

- Base image: [`purefish/docker-fish`][docker-fish] ;
- Chromium with fonts (Noto, emoji) ;
- Node.js ;
- Yarn `1.22.22` ;
- Puppeteer `21.10.0` ;
- [terminal-screenshot][tss] CLI (globally available)

## Usage

### As a docker multi-stage builds

```dockerfile
# in a dockerfile
FROM purefish/terminal-screenshot:latest AS with-terminal-screenshot-installed
```

### Standalone

```fish
docker run \
   --rm \
   --volume $(pwd):/home/nemo \
   purefish/terminal-screenshot:latest \
   <command>
```

## Development

### Build

```fish
make build
```

### Test

```fish
make test # show versions
```

### Push to Docker Hub

```fish
docker login
make push
```

## [MIT][MIT] License

[MIT]: LICENSE.md
[tss]: https://github.com/OmarTawfik/terminal-screenshot/pull/11
[docker-fish]: https://hub.docker.com/r/purefish/docker-fish
