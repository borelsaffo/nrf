# Copyright 2018 (C), Oracle and/or its affiliates. All rights reserved.

# NrfController

## Introduction

This chart runs a pod of ocnrf-nrfauditor.

## Installing the Chart

This Chart is subchart under `ocnrf` Umbrella Chart. 
It is present in repository path  cne-repo/nrfauditor and 
installed as part of `ocnrf` Umbrella Chart

## Configuration

The following table lists the configurable parameters of the ocnrf-nrfauditor chart and their default values.

| Parameter                              | Description                                  | Default                            |
| ---------------------------------------| -------------------------------------------- | ---------------------------------- |
| `image`                                | `ocnrf-nrfauditor` image repository.         | `ocnrf-nrfauditor`                 |
| `imageTag`                             | `ocnrf-nrfauditor` image tag.                | `latest`                           |
| `imagePullPolicy`                      | Image pull policy                            | `Always`                           |







