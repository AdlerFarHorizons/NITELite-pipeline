# We use miniconda as a base image
# We use this instead of the simpler python image because gdal is difficult to
# install without conda.
FROM continuumio/miniconda3
# Last known good tag: 23.10.0-1

# Install the python environment
RUN conda env create -n nitelite-pipeline-conda

# Install the python environment
COPY ./validate/conda-env.yaml /conda-env.yaml
RUN conda env create -f /conda-env.yaml

# Copy over the code
COPY . /NITELite-pipeline

# Install night-horizons
# The conda run command is required,
# since there are issues with conda activate
WORKDIR /NITELite-pipeline/night-horizons-mapmaker
RUN conda run -n nitelite-pipeline-conda \
   pip install -e .
