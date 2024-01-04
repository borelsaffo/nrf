# Copyright 2020 (C), Oracle and/or its affiliates. All rights reserved.

# Oracle NFs Deployment Data collector

## Introduction
nfDataCapture.sh is a script which can be used for collecting all required logs from NF deployment 
for debugging issues. The script will collect logs from all Micro-Service PODs of specified helm input, helm deployment details,
the status and description of all the pods, services and events.

## Script usage

 Usage:

  ./nfDataCapture.sh -n|--k8Namespace=[K8 Namespace] -k|--kubectl=[KUBE_SCRIPT_NAME] -h|--helm=[HELM_SCRIPT_NAME]  -s|--size=[SIZE_OF_EACH_TARBALL] -o|--toolOutputPath -helm3=false


  Examples:=
  ./nfDataCapture.sh -k="kubectl --kubeconfig=admin.conf" -h="helm --kubeconfig admin.conf" -n=ocnrf -s=5M -o=/tmp/
  ./nfDataCapture.sh -n=ocnrf -s=5M -o=/tmp/
  ./nfDataCapture.sh -n=ocnrf
  ./nfDataCapture.sh -n=ocnrf -helm3=true

  Note:- Default size of tarball generated will be 10M, if not provided and default location of output will be tool working directory
  By default helm2 is used. Use proper argument in command to use helm3


Only if the size of the tar [example: ocnrf.debugData.2020.06.08_12.02.39.tar.gz] generated is greater than "SIZE_OF_EACH_TARBALL" specified in the command ,tar is split into several tarball based on the size specified.

Note: Please make sure that the above script has all the permissions of execution in the environment.
	  chmod 777 nfDataCapture.sh can be used in order to grant all the permissions.
	  Please make sure that tar package and split package is installed in the environment

After execution of command in case of example no.1 and example no.2, tar-balls will created based on size specified in the following format:

<namespace>.debugData.<timestamp>

For example:- ocnrf.debugData.2020.06.08_12.02.39-part01
	  
Each tarball can be then combined into one tarball with the following command:
cat ocnrf.debugData.2020.06.08_12.02.39-part* > ocnrfDebugData.2020.06.08_12.02.39-combined.tar.gz	  
