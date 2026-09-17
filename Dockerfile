# SuperMetroidDS — Custom DevkitARM Docker Image
# Optional: Pre-installs common dependencies for faster CI builds
# Base: devkitpro/devkitarm (official)

FROM devkitpro/devkitarm:latest

# Install additional tools for development/CI
RUN dkp-pacman -Syu --noconfirm \
    nds-dev \
    cppcheck \
    clang \
    git \
    make \
    && rm -rf /var/cache/pacman/pkg/*

# Create non-root user for security (optional)
# ARG UID=1000
# ARG GID=1000
# RUN groupadd -g ${GID} builder && useradd -u ${UID} -g ${GID} -m builder
# USER builder

WORKDIR /source

# Default command: build
CMD ["make"]