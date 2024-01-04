# Copyright 2018 (C), Oracle and/or its affiliates. All rights reserved.

# NFRegistration

## Introduction

This chart runs a pod of ocnrf-nfregistration.

## Installing the Chart

This Chart is subchart under `ocnrf` Umbrella Chart. 
It is present in repository path  cne-repo/nfregistration and 
installed as part of `ocnrf` Umbrella Chart

## Configuration

The following table lists the configurable parameters of the ocnrf-nfregistration chart and their default values.

| Parameter                              | Description                                  | Default                            |
| ---------------------------------------| -------------------------------------------- | ---------------------------------- |
| `image`                                | `ocnrf-nfregistration` image repository.     | `ocnrf-nfregistration`             |
| `imageTag`                             | `ocnrf-nfregistration` image tag.            | `latest`                           |
| `imagePullPolicy`                      | Image pull policy                            | `Always`                           |







