#Make sure to rename the file name to dockerfile to use it
# Use the latest Arch Linux as the base image
FROM archlinux:latest

# Update the system and install necessary packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm  git sudo curl wget base-devel openh264 archlinux-keyring pacman-contrib vifm bat 

# Create the 'builder' user with no password
RUN useradd -m builder && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#Create Workspace directory
RUN mkdir -p /github/workspace && chown -R builder:builder /github

# Switch to the 'builder' user
USER builder

# Set the working directory to the builder's home
WORKDIR /github/workspace 

# Ensure the copied files have the correct permissions
RUN sudo chown -R builder:builder /home/builder

RUN git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm && \
    cd .. && sudo rm -rf aurutils

# Adding local repo for Aurutils
RUN echo -e "[aur-prebuilt]\nSigLevel = Optional TrustAll\nServer = file:///github/workspace/aur-prebuilt/x86_64/" | sudo tee -a /etc/pacman.conf
#Annonations
LABEL org.opencontainers.image.source=https://github.com/xeroxero8x/repo-builder/tree/main/docker 
LABEL org.opencontainers.image.description="My container image for building Arch Repository"
LABEL org.opencontainers.image.licenses=MIT

# Provide default command (this can be adjusted as needed)
CMD ["/bin/bash"]

