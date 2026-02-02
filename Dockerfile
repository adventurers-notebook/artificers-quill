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

# Download and unzip the fonts from the rpgtex repository
RUN wget https://github.com/rpgtex/DND-5e-LaTeX-Template/raw/master/fonts/fonts.zip -O /tmp/fonts.zip && \
    unzip /tmp/fonts.zip -d /usr/local/share/fonts/truetype/dnd && \
    rm /tmp/fonts.zip

# Refresh the font cache
RUN fc-cache -f -v

# --- Install D&D 5e LaTeX Template ---
# Create a directory for the LaTeX style files in the TeX tree
RUN mkdir -p /usr/share/texmf/tex/latex/dnd5e

# Download the style file and images
RUN wget https://raw.githubusercontent.com/rpgtex/DND-5e-LaTeX-Template/master/dnd.sty -O /usr/share/texmf/tex/latex/dnd5e/dnd.sty && \
    wget https://raw.githubusercontent.com/rpgtex/DND-5e-LaTeX-Template/master/backgrounds/PHB-background.png -O /usr/share/texmf/tex/latex/dnd5e/PHB-background.png

# Refresh the TeX file database
RUN texhash