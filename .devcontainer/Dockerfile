# We use postgis as a base image
FROM postgis/postgis

# # The base image does not include any CLI tools, so we install them
# We also install git
RUN apt-get update -y && \
    apt-get install -y postgis git wget && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists

# Install Miniconda
ENV CONDA_DIR /opt/conda
ENV PATH=${CONDA_DIR}/bin:${PATH}
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
# To avoid downloading miniconda every time we copy it from the host
# TODO: Change this when we are done with the development
COPY ./downloads/miniconda.sh ~/miniconda.sh
RUN /bin/bash ~/miniconda.sh -b -p ${CONDA_DIR} && \
    rm ~/miniconda.sh
