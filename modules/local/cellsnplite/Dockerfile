# Start with the base image
FROM continuumio/miniconda3

# Set the environment variables
ARG PATH=/cellsnp-lite/miniconda3/bin:/cellsnp-lite/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH=$PATH:/cellsnp-lite/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install wget
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Add Conda channels
RUN conda config --add channels conda-forge && \
    conda config --add channels bioconda

# Download and install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir -p /cellsnp-lite/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /cellsnp-lite/miniconda3 -b && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Install cellsnp-lite
RUN conda install -y cellsnp-lite

# Set the default command
CMD ["bash"]
