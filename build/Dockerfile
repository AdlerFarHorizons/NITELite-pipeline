# We use miniconda as a base image
# We use this instead of the simpler python image because gdal is difficult to
# install without conda.
FROM continuumio/miniconda3
# Last known good tag: 23.10.0-1

# The base postgis image does not include any CLI tools, so we install them
# We also install a few other essential packages
RUN apt-get update -y && \
    apt-get install -y git libgl1 && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists

# Install the python environment
COPY ./build/conda-env.yaml /conda-env.yaml
RUN conda env create -f /conda-env.yaml

# Copy over the code
COPY . /NITELite-pipeline

# Install night-horizons
# The conda run command is required,
# since there are issues with conda activate
WORKDIR /NITELite-pipeline/night-horizons-mapmaker
RUN conda run -n nitelite-pipeline-conda \
   pip install -e .

# Set up the workdir
# TODO: Avoid root
WORKDIR /NITELite-pipeline

# Ensure that the conda environment is act:vated whenever the user logs in
# Entrypoints don't work with conda activate, so we add it to the bashrc
# This still doesn't work for one-offs. conda run is required for those.
RUN echo "conda activate nitelite-pipeline-conda" >> ~/.bashrc
