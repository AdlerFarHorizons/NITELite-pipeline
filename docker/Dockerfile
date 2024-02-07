# We use postgis as a base image
FROM postgis/postgis

# The base postgis image does not include any CLI tools, so we install them
# We also install a few other essential packages
RUN apt-get update -y && \
    apt-get install -y wget git libgl1 postgis && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists

# Copy over the pipeline code
COPY . /NITELite_pipeline
WORKDIR /NITELite_pipeline/docker

# Install Miniconda
ENV CONDA_DIR /opt/conda
ENV PATH=${CONDA_DIR}/bin:${PATH}
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash /miniconda.sh -b -p ${CONDA_DIR} && \
#     rm /miniconda.sh
# To avoid downloading miniconda every time we copy it from the host
# TODO: Change this when we are done with the development
RUN /bin/bash ./downloads/miniconda.sh -b -p ${CONDA_DIR}

# Install python environment
RUN conda env create -f ./conda-env.yaml

# Install night-horizons
# The conda run command (and /bin/bash) is required,
# since there are issues with conda activate
WORKDIR /NITELite_pipeline/night-horizons-mapmaker
RUN conda run -n nitelite-pipeline /bin/bash -c \
    pip install -e .

# Validate the install
RUN conda run -n nitelite-pipeline /bin/bash -c \
    python -c "import night_horizons"

