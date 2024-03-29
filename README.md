# The NITELite data pipeline
Code to process images and data taken with the HAB NITELite instrument.

## Installation

Installation requires a few steps.
These are a one-time thing.

First, if you are using windows you will need to download and install
[Windows Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4).
This will enable you to treat your windows computer like a unix-based system,
which is what Linux, Mac, and cloud systems typically use.

Second, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), if you don't have it installed already.

Next, clone this repository,  i.e.
```shell
git clone https://github.com/AdlerFarHorizons/NITELite-pipeline.git
```

Second, download and run
[docker desktop](https://www.docker.com/products/docker-desktop/).

To download the docker image (the pre-packaged pipeline) and verify installation,
run the following
```shell
cd NITELite-pipeline # Move into the pipeline
./bin/validate.sh # Validation script
```

## Running the pipeline

To run the pipeline, navigate to the main directory for this repository (the
directory containing this README), and execute the following command.
```shell
./bin/mapmake.sh -c CONFIG_FILEPATH -d DATA_DIR
```
You must pass in two arguments, described below.

### Test dataset

For this and subsequent steps it is recommended you use an example dataset,
prior to applying the pipeline to new data.
[Limited-access georeferenced images from a NITELite flight are available
here][FH135-drive], and are a good option.

### The data directory

Ensure your data is contained in a single directory, and identify its filepath.
For example, your data might be in `/Users/Shared/data`.
In the above command, replace `DATA_DIR` with this directory.

### The configuration file

The configuration file specifies the parameters of the analysis.
There are template config files in `./config` which have sensible defaults.
The are...

- `./config/mosaic.yml`: Produce a mosaic out of images that are already
georeferenced.
- `./config/sequential-mosaic.yml`: Perform georeferencing on raw images,
using a set of existing georeferenced images as a base.
- `./config/test-sequential-mosaic.yml`: Evaluate georeferencing accuracy by
splitting a set of referenced images into a training sample and a test sample,
and using the training sample as a base to georeference the test sample.

In any config file, you will have to edit it to ensure that it points to your
data. Inside the config file, this is the "io_manager" section. The provided
template configs describe the parameters in detail.

### A Note on Filepaths

During typical execution the user passes the directory containing all their
data to `./bin/mapmake.sh` as the `-d` argument.
That directory is then mounted to the docker image at `/data`.
The user then specifies in the config where the input and output are
inside the mounted directory.

Example:
The directory containing all data is `/Users/Shared/shared_data`.
and the input data is at `/Users/Shared/shared_data/nitelite/220513-FH135`.
In this case the user would specify `-d /Users/Shared/shared_data` when
executing `./bin/mapmake.sh`, and would set the `input_dir` option in the
configuration files to `/data/nitelite/220513-FH135`.

### Example command

After identifying and editing the above, our command might look like

```shell
./bin/mapmake.sh -c ./config/mosaic.yml -d /Users/Shared/data
```

## FAQ

#### The program terminated unexpectedly and no Python error was raised. Why?

Nine times out of ten this is because the analysis ran out of memory.
Increasing the resources available to the docker container will typically
resolve this. To do so, on Docker Desktop go to "settings" (gear icon)
and then select "resources". There should be a slider for Memory.


#### Why can't I push my edits to Git?
You cloned with https (as recommended earlier). This is simpler, but doesn't enable you to publish your changes. Clone with ssh instead, after setting up ssh.

## Editing the Code

If you want to edit the pipeline code and see the changes take effect, you
have to build the image yourself. To do this, from the main directory
run `./bin/build.sh`. Then run `./bin/mapmake.sh` as you usually would,
but include the option `-f ./build/dev-docker-compose.yaml`.
For example,

```shell
./bin/mapmake.sh -c ./config/mosaic.yml -d my/data -f ./build/dev-docker-compose.yaml
```


[FH135-drive]: https://drive.google.com/drive/folders/1RVNJydEQZ29ElqbNvxbMS5cBAw2bMShU?usp=drive_link
[docker-image]: https://hub.docker.com/r/zhafen/nitelite-pipeline?uuid=9849f18b-9995-486b-9d5a-7a35f69d0c72%0A