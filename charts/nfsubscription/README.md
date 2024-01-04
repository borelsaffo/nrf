# Copyright 2018 (C), Oracle and/or its affiliates. All rights reserved.

# NFSubscription

## Introduction

This chart runs a pod of ocnrf-subscription

## Installing the Chart

This Chart is subchart under `ocnrf` Umbrella Chart. 
It is present in repository path  cne-repo/nfsubscription and 
installed as part of `ocnrf` Umbrella Chart

## Configuration

The following table lists the configurable parameters of the ocnrf-subscription chart and their default values.

| Parameter                              | Description                                  | Default                            |
| ---------------------------------------| -------------------------------------------- | ---------------------------------- |
| `image`                                | `ocnrf-subscription` image repository.       | `ocnrf-subscription`               |
| `imageTag`                             | `ocnrf-subscription` image tag.              | `latest`                           |
| `imagePullPolicy`                      | Image pull policy                            | `Always`                           |







