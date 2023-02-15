#!/bin/sh

asciidoctor -b pdf \
 -v \
 -r asciidoctor-diagram \
 -r asciidoctor-pdf \
 -r asciidoctor-lists \
 -a pdf-theme=basic \
 -a pdf-themesdir=documentation/resources/themes \
 -a pdf-fontsdir=documentation/resources/fonts \
 -D documentation/out \
 documentation/kibon-system.adoc
