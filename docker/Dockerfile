# We use postgis as a base image
FROM postgis/postgis

# The base image does not include any CLI tools, so we install them
# We also install git
RUN apt-get update -y && \
    apt-get install -y postgis git && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists