# artificers-quill
A collection of scripts and instructions to write professionally looking 5e compatible content

# Install
Before using this script you must have LaTeX and PanDoc installed on you system.
As a matter of fact the powers of the command line are ruling this process.


pandoc adventure.md --lua-filter=dnd_pro.lua --template=dnd-template.tex -o adventure.pdf
