# Use the official Alpine-based pandoc image.
# It includes a comprehensive TeX Live installation.
FROM pandoc/latex:3.8

# Set a working directory inside the container
WORKDIR /data

# Install git and unzip, which are needed to fetch the dnd style from GitHub.
# We also install curl to download the template as a zip archive, which is faster.
# We use apk, the Alpine Linux package manager. The --no-cache option is a best practice.
RUN apk add --no-cache \
    git

# Set the TeX user tree environment variable. This ensures kpsewhich finds our custom files at runtime.
ENV TEXMFHOME=/root/texmf

# Install LaTeX packages and the dnd-5e-latex-template from GitHub.
# Combining these into a single RUN command improves Docker layer caching.
RUN tlmgr update --self && \
    tlmgr install enumitem gensymb hanging numprint tcolorbox && \
    mkdir -p "$TEXMFHOME/tex/latex/dnd" && \
    git clone --depth 1 https://github.com/rpgtex/DND-5e-LaTeX-Template.git "$TEXMFHOME/tex/latex/dnd" && \
    echo "TeX packages and template installed successfully."

# Copy the local project files into the container's working directory
COPY . .

# Make the build script executable
RUN chmod +x ./build.sh

# Set the entrypoint to our build script
ENTRYPOINT ["sh", "./build.sh"]