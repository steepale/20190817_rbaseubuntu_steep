#===============================================================================
#
#         FILE: Dockerfile
#    DEV USAGE: docker run -it -v /Users/Alec/Documents/Bioinformatics/MDV_Project/p0100_music/data:/mnt/data --name rbaseubuntu --rm ubuntu:latest
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

# Set working directory
WORKDIR /

# Add this command to ensure no interactive builds
# This docker file uses Eastern Standard Time, you can adjust the RUN command below to something that suits you if needed, but you probably can just leave it as is.
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
ENV DEBIAN_FRONTEND=noninteractive

# Update the apt-get in the Ubuntu image
# Install the rbase package
# We add the "sudo DEBIAN_FRONTEND=noninteractive" argument so that the rbase installation is not interactive
# Note: use 'apt-cache policy <package-name>' to determine which package is installed
RUN apt-get update \
    && apt-get install -y sudo=1.8.21p2-3ubuntu1 \
    && sudo apt-get install -y --no-install-recommends build-essential=12.4ubuntu1 \
    git=1:2.17.1-1ubuntu0.4 \
    cmake \
    wget=1.19.4-1ubuntu2.2 \
    r-base \
    && dpkg-reconfigure --frontend noninteractive tzdata

# This is the CMD command from the Ubuntu:18.04 image we FROM'ed
CMD ["/bin/bash"]
