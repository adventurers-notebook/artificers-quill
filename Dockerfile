# Use an official Debian-based pandoc image.
# We use pandoc/core and will install TeX Live manually.
FROM pandoc/core:3.8-debian

# Set a working directory inside the container
WORKDIR /data

# Use apt, the Debian package manager.
# First, update the package lists. Then install git and the necessary TeX Live packages.
# `texlive-xetex` is needed for the --pdf-engine=xelatex option.
# `texlive-latex-extra` contains required packages like hanging, tcolorbox, etc.
# `texlive-fonts-recommended` provides additional font support.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    texlive-xetex \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lmodern \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

# Set the TeX user tree environment variable. This ensures kpsewhich finds our custom files at runtime.

# Install the dnd-5e-latex-template from GitHub into the user's TEXMF tree.
# This single RUN command does the following:
# 1. Creates the target directory for the template.
# 2. Clones the repository contents directly into it.
# 3. Copies the fonts to the system font directory.
# 4. Copies the main template to Pandoc's template directory.
# 5. Updates the TeX and font caches.
RUN TEXMFHOME=$(kpsewhich -var-value TEXMFHOME) \
    git clone https://github.com/rpgtex/DND-5e-LaTeX-Template.git "${TEXMFHOME}/tex/latex/dnd" && \
    DND_FINAL_PATH="$TEXMFHOME/tex/latex/dnd" && \
    find "$DND_FINAL_PATH" -name "*.ttf" -o -name "*.otf" -exec cp {} /usr/local/share/fonts/ \; && \
    mkdir -p /root/.pandoc/templates && \
    cp "$DND_FINAL_PATH/dnd-template.tex" /root/.pandoc/templates/ && \
    texhash && fc-cache -fv

# Copy the local project files into the container's working directory
COPY . .

# Make the build script executable
RUN chmod +x ./build.sh

# Set the entrypoint to our build script
ENTRYPOINT ["sh", "./build.sh"]