# Copyright 2018 (C), Oracle and/or its affiliates. All rights reserved.

# NrfConfiguration

## Introduction

This chart runs a pod of ocnrf-nrfconfiguration.

## Installing the Chart

This Chart is subchart under `ocnrf` Umbrella Chart. 
It is present in repository path  cne-repo/nrfconfiguration and 
installed as part of `ocnrf` Umbrella Chart

## Configuration

The following table lists the configurable parameters of the ocnrf-nfregistration chart and their default values.

| Parameter                              | Description                                  | Default                            |
| ---------------------------------------| -------------------------------------------- | ---------------------------------- |
| `image`                                | `ocnrf-nrfconfiguration` image repository.     | `ocnrf-nrfconfiguration`             |
| `imageTag`                             | `ocnrf-nrfconfiguration` image tag.            | `latest`                           |
| `imagePullPolicy`                      | Image pull policy                            | `Always`                           |







