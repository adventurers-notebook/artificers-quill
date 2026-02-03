#!/bin/sh
for f in *.md; do pandoc "$f" -s --css theme.css --lua-filter=links.lua -o "${f%.md}.html"; done
