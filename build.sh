#!/bin/sh

pandoc $1 -o adventure.pdf --lua-filter=dnd_pro.lua -H header.tex --pdf-engine=xelatex