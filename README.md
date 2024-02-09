# NITELite-pipeline
Code to process images and data taken with the HAB NITELite instrument.

## Analysis Preparations

There are three things you need to do prior to running the pipeline.
1. **Locate your data.** [Limited-access georeferenced images from a NITELite
flight is available here.][FH135-drive] You are encouraged to run the pipeline
on this data first as a validation of the pipeline and your setup.
2. **Clone this repository.**
(`git clone git@github.com:AdlerFarHorizons/NITELite-pipeline.git`)
3. **Create a docker account and download docker desktop.**
[Link here.](https://www.docker.com/products/docker-desktop/)

## Configuration


## FAQ

#### The program terminated unexpectedly and no Python error was raised. Why?

Nine times out of ten this is because the analysis ran out of memory.
Increasing the resources available to the docker container will typically
resolve this. To do so, on Docker Desktop go to "settings" (gear icon)
and then select "resources". There should be a slider for Memory.

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