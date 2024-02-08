# We use postgis as a base image
FROM postgis/postgis

# The base postgis image does not include any CLI tools, so we install them
RUN apt-get update -y && \
    apt-get install -y postgis && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists