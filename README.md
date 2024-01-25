# HPA Single Cell Classification Development

This repository porvide scripts for developing single cell classification model for HPA dataset. Pipelines are prepared using [snakemake](https://snakemake.readthedocs.io/en/stable/) for workflow management and depending on conda and pip for dependency control.

For development purpose, we do not provide ".yml" file for one step installation. Please follow the instruction below to install dependencies.

Snakemake does not have to be installed in the same conda environment as the one used for running the pipeline. It can switch between existing conda environments by specifying the `--use-conda` option and add the "conda" variable to the Snakefile. For more information, please refer to [snakemake doc: Using already existing named conda environments](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#using-already-existing-named-conda-environments)

## Installation

1. [Create conda environment](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#managing-environments):
    1. Create conda environment: `conda env --name <my-env> python=3.9`
    2. Activate conda environment: `conda activate <my-env>`
2. Install dependencies
    1. [Install snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html):
        1. Install snakemake: `conda install -c conda-forge mamba`
        2. Install snakemake: `mamba install -c conda-forge -c bioconda snakemake`
    2. [Install cellpose](https://cellpose.readthedocs.io/en/latest/installation.html):
        1. Install cellpose 2.2.2: `pip install "cellpose[gui]"==2.2.2`
        2. "cyto2" is the model used in cell segmentation. If cellpose fails to download the model, please download the model manually and put it in the cellpose model directory. The model can be downloaded from [here](https://drive.google.com/file/d/1zHGFYCqRCTwTPwgEUMNZu0EhQy2zaovg/view)
3. git clone this repository

## Run Snakemake

In my environment, I directy run the Snakemake on our Linux machince (CentOS), so I haven't tested its function sending commands to cluster. Please refer to [snakemake doc: Cluster Execution](https://snakemake.readthedocs.io/en/stable/tutorial/additional_features.html#cluster-execution) for more information.

I created three conda environment for running the pipeline.

1. "mssm" for hosting Snakemake
2. "mscp03" for running cellpose
3. "mspytorch" for running basic image processing

Three rules are in the current version of Snakefile:

1. convert: using conda env "mspytorch"
2. merge: using conda env "mspytorch"
3. cellpose: using conda env "mscp03"

Note: mscp03 supposed to be able to handle basic image processing. However, it failed to run rule "convert" and "merge", so I pointed the Snakefile to mspytorch to saving time from debuging.

Please change the conda env according to your environment.

## Reference

1. Snakemake: scalable bioinformatics workflows. Johannes Köster and Sven Rahmann. Bioinformatics 2012. [doi:10.1093/bioinformatics/bts480](https://doi.org/10.1093/bioinformatics/bts480)
2. Conda: A package manager for any language. [https://conda.io/docs/](https://conda.io/docs/)
3. Cellpose: generalist nuclei segmentation using learned representations of microscopy images. Carsen Stringer, Tim Wang, Michalis Michaelos, Marius Pachitariu, and Lynn K. Lu. bioRxiv 2020. [doi:10.1101/2020.02.02.931238](https://doi.org/10.1101/2020.02.02.931238)

## Links

1. snakemake:
    1. website: [snakemake.github.io](snakemake.github.io)
    2. doc: [snakemake.readthedocs.io](https://snakemake.readthedocs.io/en/stable/)
2. [conda](https://conda.io/)
3. cellpose:
    1. website: [www.cellpose.org](https://www.cellpose.org/)
    2. github: [cellpose](https://github.com/MouseLand/cellpose)