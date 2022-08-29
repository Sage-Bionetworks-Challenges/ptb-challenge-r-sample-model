# Preterm Birth Prediction - Microbiome: Sample R Model

## Overview
This repository contains a sample Dockerfile and related files to build a model for the
[Preterm Birth Prediction - Microbiome DREAM Challenge](https://www.synapse.org/preterm_birth_microbiome).
The goal of this DREAM Challenge is to develop models that take as input vaginal microbiome
data and outputs the probability preterm and early preterm birth.

## Build the model
1) Run `fit_model.R` to generate and save your fitted model

> Note that the input files for this script will require training data provided by the 
challenge.  You can [download the training data here](https://www.synapse.org/#!Synapse:syn35279796) (challenge registration required). 

2) If you changed `fit_model.R`, edit `run_model.R` to reflect the new types of data used
and changes to the prediction model
3) Dockerize the model:

```
docker build -t docker.synapse.org/<project id>/my-model:v1 .
```

where:

* `<project id>`: Synapse ID of your project
* `my-model`: name of your model
* `v1`: version of your model
* `.`: filepath to the Dockerfile

4) (optional but recommended) Locally run the model to ensure it can run successfully:

```
docker run \
  --rm \
  --network none \
  -v $PWD/training_data:/input:ro \
  -v $PWD/output:/output:rw \
  docker.synapse.org/<project id>/my-model:v1
```

5) Use `docker push` to push the model up to your project on Synapse, then submit it to the challenge.

For more information on how to submit, refer to [Step 6 of the Submission Tutorial](https://www.synapse.org/#!Synapse:syn26133770/wiki/618028).