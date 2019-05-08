# Latex Docker Images

Docker scripts to build an image to provide a minimal [texlive 2018](https://www.tug.org/texlive/) installation to support simple PDF transformations. Additional texlive packages have to be installed be extending this images. 

## Run

The pre build image is availabe via [Dockerhub](https://hub.docker.com/r/oehrlis/latex/). The installation and use is straightforward. Install [Docker](https://www.docker.com/get-started) and pull the image.

```bash
docker pull oehrlis/latex
```

Either you copy the files into the container, which is obviously not really handy, or you mount your local document folder as volume.

```bash
docker run --rm -v $PWD:/workdir:z oehrlis/latex pdflatex <OPTIONS>
```

Conversion of the sample tex file into a PDF.

```bash
cd sample
docker run --rm -v $PWD:/workdir:z oehrlis/latex pdflatex sample.tex sample.pdf
```

Since the container includes a reduced [texlive 2018](https://www.tug.org/texlive/) installation, you may also use a bunch of latex tools.

```bash
docker run --rm -v $PWD:/workdir:z oehrlis/latex \
    pdflatex <TEX_FILE> 
    --t
```

alternatively you can open a shell in the container and use the miscellanies tex tools interactively.

```bash
docker run -it --rm -v $PWD:/workdir:z oehrlis/pdflatex bash
```

## Build and add new packages

If you plan to alter or extend this Docker image you could get the corresponding files from [GitHub](https://github.com/oehrlis/docker-latex) and build the image manually.

```bash
git clone git@github.com:oehrlis/docker-latex.git
$ cd docker-latex
$ docker build -t oehrlis/latex .
```

Optionally you can add additional texlive package to the `tlmgr` command in the Dockerfile.

## Issues

Please file your bug reports, enhancement requests, questions and other support requests within [Github's issue tracker](https://help.github.com/articles/about-issues/):

* [Existing issues](https://github.com/oehrlis/docker-latex/issues)
* [submit new issue](https://github.com/oehrlis/docker-latex/issues/new)

## References

* [pandoc](https://pandoc.org)
* [texlive 2018](https://www.tug.org/texlive/)
* [GitHub Google Fonts](https://github.com/google/fonts)