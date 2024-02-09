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

[FH135-drive]: https://drive.google.com/drive/folders/1RVNJydEQZ29ElqbNvxbMS5cBAw2bMShU?usp=drive_link