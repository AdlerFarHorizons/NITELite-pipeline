#!/bin/bash

# Base directories
mkdir /data
mkdir /data/input
mkdir /data/output

# Specific input directories
mkdir /data/input/referenced_images
mount-s3 nitelite.referenced-images /data/input/referenced_images
mkdir /data/input/metadata
mount-s3 nitelite.metadata /data/input/metadata
mkdir /data/input/images
mount-s3 nitelite.images /data/input/images
mkdir /data/input/existing_output
mount-s3 nitelite.pipeline-output /data/input/existing_output