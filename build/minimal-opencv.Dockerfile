# We use miniconda as a base image
# We use this instead of the simpler python image because gdal is difficult to
# install without conda.
FROM continuumio/miniconda3:23.10.0-1
# Last known good tag: 23.10.0-1

# The base postgis image does not include any CLI tools, so we install them
# We also install a few other essential packages
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update -y && \
    apt-get install git -y && \
    apt-get install libavcodec-dev libavformat-dev libswscale-dev -y && \
    apt-get install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev -y && \
    apt-get install libgtk2.0-dev -y && \
    apt-get install libgtk-3-dev -y && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists

RUN conda create -n debug
RUN conda install -c conda-forge -y -n debug opencv
# RUN conda run -n debug python -c "import cv2; print('Imported!')"

# Build from source
RUN git clone https://github.com/opencv/opencv.git
RUN conda run -n debug python -c "import cv2; print('Imported!')"