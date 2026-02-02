#!/bin/sh

pandoc $1 \
  --from markdown+yaml_metadata_block \
  --lua-filter=dnd_pro.lua \
  --pdf-engine=xelatex \
  -o adventure.pdf
