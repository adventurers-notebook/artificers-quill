FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# 1. Install Basic Tools, Pandoc, and TeX Live
# We use texlive-latex-extra for the D&D packages and texlive-xetex for the engine
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    pandoc \
    texlive-xetex \
    texlive-latex-extra \
    texlive-fonts-recommended \
    wget \
    git \
    make \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# 2. Install the D&D 5e LaTeX Template Globally
# This allows you to use the package without having files in every folder
RUN mkdir -p /usr/local/share/texmf/tex/latex/dnd \
    && git clone https://github.com/rpgtex/DND-5e-LaTeX-Template.git /tmp/dnd-template \
    && cp -r /tmp/dnd-template/lib/* /usr/local/share/texmf/tex/latex/dnd/ \
    && mktexlsr

# 3. Install tinyyaml for Lua (Fixing your specific Lua error globally)
RUN mkdir -p /usr/local/share/lua/5.3/ \
    && wget -O /usr/local/share/lua/5.3/tinyyaml.lua https://raw.githubusercontent.com/peposso/lua-tinyyaml/master/tinyyaml.lua

# Create the Pandoc templates directory and download the D&D template
RUN mkdir -p /home/vscode/.local/share/pandoc/templates \
    && wget -O /home/vscode/.local/share/pandoc/templates/dnd-template.tex https://raw.githubusercontent.com/rpgtex/DND-5e-LaTeX-Template/master/template.tex \
    && chown -R vscode:vscode /home/vscode/.local/share/pandoc

# 4. (Optional) Set up an alias or simple script if you want
RUN echo 'alias build-dnd="pandoc $1 --lua-filter=dnd.lua --template=dnd-template.tex --pdf-engine=xelatex -o ${1%.*}.pdf"' >> /home/vscode/.bashrc