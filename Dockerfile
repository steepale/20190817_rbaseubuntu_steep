#===============================================================================
#
#         FILE: Dockerfile
#    DEV USAGE: docker run -it -v /Users/Alec/Documents/Bioinformatics/MDV_Project/p0100_music/data:/mnt/data --name rbaseubuntu --rm steepale/20190817_rbaseubuntu:1.0
#        USAGE: docker image build -t steepale/20190817_rbaseunbuntu:1.0 . # local image build
#
#  DESCRIPTION:  This Dockerfile will build an R environemtn in an Ubuntu OS
# REQUIREMENTS:  ---
#        NOTES:  ---
#       AUTHOR:  Alec Steep, alec.steep@gmail.com
#  AFFILIATION:  Michigan State University (MSU), East Lansing, MI, United States
#				         USDA ARS Avian Disease and Oncology Lab (ADOL), East Lansing, MI, United States
#				         Technical University of Munich (TUM), Weihenstephan, Germany
#      VERSION:  1.0
#      CREATED:  2019.08.17
#     REVISION:  ---
#===============================================================================

# Pull the Ubuntu OS image
FROM ubuntu:18.04

MAINTAINER "Alec Steep" alec.steep@gmail.com

# Set working directory
WORKDIR /

# Add this command to ensure no interactive builds
# This docker file uses Eastern Standard Time, you can adjust the RUN command below to something that suits you if needed, but you probably can just leave it as is.
# We add the "DEBIAN_FRONTEND=noninteractive" argument so that the rbase installation is not interactive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
ENV DEBIAN_FRONTEND=noninteractive

# Update the apt-get in the Ubuntu image
# Install the rbase package
# Note: use 'apt-cache policy <package-name>' to determine which package is installed
# We add "root" to the "staff" group to allow R dependency installations
RUN apt-get update -qq \
    && apt-get install -y sudo=1.8.21p2-3ubuntu1 \
    && sudo apt-get install -y --no-install-recommends build-essential=12.4ubuntu1 \
    git=1:2.17.1-1ubuntu0.4 \
    cmake \
    wget=1.19.4-1ubuntu2.2 \
    gnupg \
    apt-transport-https \
    software-properties-common \
    && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
    && sudo apt-get update -qq \
    && sudo apt install -y --no-install-recommends r-base \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && sudo usermod -a -G staff root

# Install R packages from the command line using littler
RUN R -e "install.packages('docopt', dependencies = TRUE, repos='https://cloud.r-project.org/')" \
    && sudo apt-get install -y r-cran-littler

# Set an environemtnal variable to add littler to PATH
ENV PATH="/usr/lib/R/site-library/littler/examples:${PATH}"

# Now we install R packages with "littler", but first install R package dependencies
RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libmariadb-client-lgpl-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libsasl2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsodium-dev \
    && install2.r \
    --deps TRUE \
    tidyverse \
    dplyr \
    devtools \
    formatR \
    remotes \
    selectr \
    caTools \
    BiocManager

# This is the CMD command from the Ubuntu:18.04 image we FROM'ed
CMD ["/bin/bash"]
