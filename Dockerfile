# Use a base image with essential tools
FROM debian:bullseye-slim

# Set frontend to noninteractive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: wget, unzip for downloading files, and pandoc.
# Install a full TeX Live distribution. While large, it guarantees all
# necessary LaTeX packages and fonts are available.
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    pandoc \
    texlive-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- Install Fonts for the D&D Template ---
# Create a directory for custom fonts
RUN mkdir -p /usr/local/share/fonts/truetype/dnd

RUN wget https://github.com/rpgtex/DND-5e-LaTeX-Template/archive/refs/heads/stable.zip && \
    unzip stable.zip && \
    mkdir -p "$(kpsewhich -var-value TEXMFHOME)/tex/latex/dnd" && \
    mv DND-5e-LaTeX-Template-stable "$(kpsewhich -var-value TEXMFHOME)/tex/latex/dnd" && \
    rm stable.zip

# Refresh the font cache
RUN fc-cache -f -v

# Refresh the TeX file database
RUN texhash

COPY adventure.md dnd.sty dndbook.cls dndoptions.clo header.tex dnd_pro.lua build.sh .

RUN chmod a+x build.sh

ENV TARGET_FILE="adventure.md"

ENTRYPOINT ./build.sh ${TARGET_FILE}