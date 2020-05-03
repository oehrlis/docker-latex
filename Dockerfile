# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.03.19
# Revision...: 1.0
# Purpose....: Dockerfile to build a JSON utilities image
# Notes......: --
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as
#              shown at http://oss.oracle.com/licenses/upl.
# ----------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ----------------------------------------------------------------------

# Pull base image
# ----------------------------------------------------------------------
FROM alpine

# Maintainer
# ----------------------------------------------------------------------
LABEL maintainer="stefan.oehrli@trivadis.com"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV WORKDIR="/workdir" \
    PATH=/usr/local/texlive/2020/bin/x86_64-linuxmusl:$PATH

# copy the texlife profile
COPY texlive.profile /tmp/texlive.profile

# RUN as user root
# ----------------------------------------------------------------------
# install additional alpine packages 
# - ugrade system
# - install wget tar gzip perl perl-core
RUN apk update && apk upgrade && apk add --update --no-cache \
        wget msttcorefonts-installer xz curl ghostscript perl \
        tar gzip zip unzip fontconfig python py-pip && \
    rm -rf /var/cache/apk/*

# RUN as user root
# ----------------------------------------------------------------------
# install basic texlive and additonal packages
# - download texlive installer
# - initiate basic texlive installation
# - add a couple of custom package via tlmgr
# - clean up tlmgr, apk and other stuff
# search for package tlmgr search --global --file
RUN mkdir /tmp/texlive && \
    curl -Lsf http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        | tar zxvf - --strip-components 1 -C /tmp/texlive/ && \
    /tmp/texlive/install-tl --profile /tmp/texlive.profile && \
    tlmgr install \
        ttfutils fontinst \
        fvextra footnotebackref times pdftexcmds \
        helvetic symbol grffile zapfding ly1 lm-math \
        soul titlesec xetex ec mweights \
        sourcecodepro titling csquotes  \
        mdframed draftwatermark mdwtools \
        everypage minitoc breakurl lastpage \
        datetime fmtcount blindtext fourier textpos \
        needspace sourcesanspro pagecolor epstopdf \
        letltxmacro zref \
        adjustbox collectbox ulem bidi upquote xecjk xurl && \
    tlmgr backup --clean --all && \
    curl -f http://tug.org/fonts/getnonfreefonts/install-getnonfreefonts \
        -o /tmp/install-getnonfreefonts && \
    texlua /tmp/install-getnonfreefonts && \
    getnonfreefonts --sys arial-urw && \ 
    rm -rv /tmp/texlive /tmp/texlive.profile /tmp/install* && \
    rm -rv /usr/local/texlive/*/tlpkg/texlive.tlpdb.* && \
    rm -rv /usr/local/texlive/2020/bin/x86_64-linux && \
    find / -name *.exe -exec rm -rv {} \; && \
    find / -name *.log -exec rm -rv {} \; && \
    update-ms-fonts && \
    fc-cache -f 

# Define /texlive as volume
VOLUME ["${WORKDIR}"]

# set workding directory
WORKDIR "${WORKDIR}"

# Define default command for pandoc
CMD ["/bin/sh"]
# --- EOF --------------------------------------------------------------