# We use miniconda as a base image
# We use this instead of the simpler python image because gdal is difficult to
# install without conda.
FROM continuumio/miniconda3

# The base postgis image does not include any CLI tools, so we install them
# We also install a few other essential packages
RUN apt-get update -y && \
    apt-get install -y git libgl1 && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists

# Copy over the pipeline code and move into its directory
COPY . /NITELite-pipeline-for-docker-build
WORKDIR /NITELite_pipeline-for_docker-build

# Install the python environment
RUN conda env create -f ./docker/conda-env.yaml

# Install night-horizons
# The conda run command is required,
# since there are issues with conda activate
WORKDIR /NITELite-pipeline-for-docker-build/night-horizons-mapmaker
RUN conda run -n nitelite-pipeline-conda \
   pip install -e .

WORKDIR /

# # Validate the install
# WORKDIR /NITELite_pipeline
# RUN conda run -n nitelite-pipeline-conda \
#     python -c "import night_horizons"
