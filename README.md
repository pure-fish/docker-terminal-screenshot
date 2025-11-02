# docker-terminal-screenshot [![ci-status]][ci-link] [![sponsors]][sponsor-link] [![docker-pull]][hub] [![docker-size]][hub] [![MIT-img]][MIT]

> Pre-built Docker image with **[terminal-screenshot CLI][tss]** for automated terminal screenshot generation.

> :warning: Default shell is **`Fish`** (see help for [Bash users][4bash].)

## What's Included

- Base image: [`purefish/docker-fish`][docker-fish] ;
- [Fish shell][alpine-fish] and [Bash][alpine-bash] ;
- Chromium with fonts (Noto, Noto-emoji) ;
- Node.js (as provided by [alpine image][alpine-node]);
- Yarn `1.22.22` ;
- Puppeteer `21.10.0` ;
- [terminal-screenshot][tss] CLI (globally available)

## Usage

### Standalone

```sh
# screenshot `ls -lah` output
docker run \
   --rm \
   --volume $(pwd):/home/nemo \
   purefish/terminal-screenshot:latest \
      'ls -lah | terminal-screenshot --output foo.png'
```

### As a multi-stage builds

Pull `purefish/terminal-screenshot` image as a stage, then copy what you need for screenshot generation (see [usage on `pure` project][tss-usage]):

```dockerfile
FROM purefish/terminal-screenshot:latest
USER nemo
# screenshot `ls -lah` output
RUN ls -lah | terminal-screenshot --output foo.png
```

### Default command

```sh
terminal-screenshot --help
```

### Default entrypoint

Is [`fish -c`](https://fishshell.com/), see help for [Bash users][4bash], you can [override it using `--entrypoint`][entrypoint] argument:

```sh
docker run \
   --rm \
   --volume $(pwd):/home/nemo \
   --entrypoint /bin/bash \
   purefish/terminal-screenshot:latest \
      -c 'ls -lah | terminal-screenshot --output bar.png';
```

### Tag

Default, `latest`, you can specify another based on [fish version][alpine-fish]:

```sh
docker pull purefish/terminal-screenshot:fish-<tag>
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

[ci-link]: <https://github.com/pure-fish/terminal-screenshot/actions> "Github CI"
[ci-status]: https://img.shields.io/github/actions/workflow/status/pure-fish/terminal-screenshot/.github/workflows/ci.yml?style=flat-square
[sponsors]: https://img.shields.io/github/sponsors/edouard-lopez?label=💖&style=flat-square "GitHub Sponsors"
[sponsor-link]: https://github.com/sponsors/edouard-lopez/ "Become a sponsor"
[docker-pull]: https://img.shields.io/docker/pulls/purefish/terminal-screenshot.svg "Docker Pulls"
[docker-size]: https://img.shields.io/docker/image-size/purefish/terminal-screenshot/latest?label=size "Docker Image Size"
[hub]: https://hub.docker.com/r/purefish/terminal-screenshot "Docker Hub"
[MIT]: LICENSE.md "MIT License"
[MIT-img]: https://img.shields.io/badge/license-MIT-blue.svg

[tss]: https://github.com/OmarTawfik/terminal-screenshot/pull/11
[tss-usage]: https://github.com/pure-fish/pure/blob/master/docker/Dockerfile
[docker-fish]: https://hub.docker.com/r/purefish/docker-fish
[entrypoint]: http://stackoverflow.com/questions/64017612/#64018098
[4bash]: https://fishshell.com/docs/current/fish_for_bash_users.html
[alpine-node]: https://pkgs.alpinelinux.org/packages?name=nodejs&branch=v3.22&repo=&arch=&origin=&flagged=&maintainer=
[alpine-fish]: https://pkgs.alpinelinux.org/packages?name=fish&branch=v3.22&repo=&arch=&origin=&flagged=&maintainer=
[alpine-bash]: https://pkgs.alpinelinux.org/packages?name=bash&branch=v3.22&repo=&arch=&origin=&flagged=&maintainer=
