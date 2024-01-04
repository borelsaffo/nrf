# Copyright 2020 (C), Oracle and/or its affiliates. All rights reserved.

{{/* vim: set filetype=mustache: */}}

{{/*--------------------Expand the name of the chart.------------------------------------------------*/}}
{{- define "chart.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Create chart name and version as used by the chart label.--------------------*/}}
{{- define "chart.fullnameandversion" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Create chart appVersion as used by the chart label.--------------------------*/}}
{{- define "chart.appversion" -}}
{{- printf "%s-%s" .Chart.Name .Chart.AppVersion | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Common Service Account Name--------------------------------------------------*/}}
{{- define "ocnrf.serviceaccount" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-serviceaccount" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Common ROLE------------------------------------------------------------------*/}}
{{- define "ocnrf.role" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-role" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Common ROLE BINDING----------------------------------------------------------*/}}
{{- define "ocnrf.rolebinding" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-rolebinding" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Debug Tool ROLE------------------------------------------------------------------*/}}
{{- define "ocnrf.debug.role" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-debug-tool-role" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Debug Tool ROLE BINDING----------------------------------------------------------*/}}
{{- define "ocnrf.debug.rolebinding" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-debug-tool-rolebinding" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Debug Tool Pod Security Policy-----------------------------------------------------*/}}
{{- define "ocnrf.debug.psp" -}}
{{- printf "%s-%s" .Release.Name "ocnrf-debug-tool-psp" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Install .--------------------------------*/}}
{{- define "preinstall.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-install" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Post-Install .--------------------------------*/}}
{{- define "postinstall.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-install" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Upgrade .--------------------------------*/}}
{{- define "preupgrade.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-upgrade" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Post-Upgrade .--------------------------------*/}}
{{- define "postupgrade.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-upgrade" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Rollback .--------------------------------*/}}
{{- define "prerollback.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-rollback" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Post-Rollback .--------------------------------*/}}
{{- define "postrollback.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-rollback" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Delete .--------------------------------*/}}
{{- define "predelete.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-delete" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Post-Delete .--------------------------------*/}}
{{- define "postdelete.job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-delete" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Helm-Test .----------------------------------------------------------*/}}
{{- define "helmtest.job.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Values.global.test.nfName "helm-test" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------------get docker registry name .-------------------------------------------------------------*/}}
{{- define "getdockerregistry.name" -}}
{{  default "" .Values.global.dockerRegistry -}}
{{- end -}}

{{/*-------------------------get oc debug tools version .-------------------------------------------------------------*/}}
{{- define "getocdebugtool.version" -}}
{{  default "" .Values.global.debugToolTag -}}
{{- end -}}

{{/*-------------------------get prefix.-------------------------------------------------------------*/}}
{{- define "getprefix" -}}
{{  default "" .Values.global.k8sResource.container.prefix | lower }}
{{- end -}}

{{/*--------------------------getsuffix.-------------------------------------------------------------*/}}
{{- define "getsuffix" -}}
{{  default "" .Values.global.k8sResource.container.suffix | lower }}
{{- end -}}

{{/*--------------------Expand the name of the Application container.--------------------------------*/}}
{{- define "container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s" $prefix (include "chart.fullname" . ) $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-install container.--------------------------------*/}}
{{- define "preinstall.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-install" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-install container.-------------------------------*/}}
{{- define "postinstall.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-install" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-upgrade container.--------------------------------*/}}
{{- define "preupgrade.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-upgrade" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-upgrade container.-------------------------------*/}}
{{- define "postupgrade.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-upgrade" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-rollback container.-------------------------------*/}}
{{- define "prerollback.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-rollback" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-rollback container.------------------------------*/}}
{{- define "postrollback.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-rollback" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-delete container.-------------------------------*/}}
{{- define "predelete.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-delete" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-delete container.------------------------------*/}}
{{- define "postdelete.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-delete" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the helm test container.-------------------------------*/}}
{{- define "helmtest.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s-%s" $prefix .Release.Name .Values.global.test.nfName "helm-test" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*-------------------------------------Service Name-----------------------------------------------------------------*/}}
{{/********************************************************************************************************************
    NOTE:- 1. Template registration.service.fullname, subscription.service.fullname, configuration.service.fullname
    must be updated if there is any change in service.fullname template.
           2. Engineering Configuration:  Micro-Service routes (.Values.ingressgateway.routesConfig) 
              must be updated
              if there is any change in service.fullname template.
   ********************************************************************************************************************/}}
{{- define "service.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}




{{/*--------------------Deployment Name--------------------------------------------------------------*/}}
{{- define "deployment.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*--------------------ConfigMap Name---------------------------------------------------------------*/}}
{{- define "configmap.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*--------------------Horizontal Pod Autoscalar Name-----------------------------------------------*/}}
{{- define "hpautoscalar.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*--------------------Subscription service fullname------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "subscription.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nfsubscription" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Registration service fullname------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This parameter must be updated if there is any change in service.fullname template
   ***************************************************************************************************/}}
{{- define "registration.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nfregistration" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Configuration service fullname------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This parameter must be updated if there is any change in service.fullname template
   ***************************************************************************************************/}}
{{- define "configuration.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nrfconfiguration" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------EgressGateway service fullname-----------------------------------------------*/}}
{{- define "egressgateway.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "egressgateway" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------IngressGateway service fullname-----------------------------------------------*/}}
{{- define "ingressgateway.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "ingressgateway" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Accesstoken service fullname-------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "accesstoken.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nfaccesstoken" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Auditor service fullname-----------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "auditor.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nrfauditor" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Discovery service fullname-----------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "discovery.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nfdiscovery" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Appinfo service fullname-----------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "appinfo.service.fullname" -}}
{{- if .Values.global.appinfoFullname -}}
{{- printf "%s" .Values.global.appinfoFullname -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name .Values.global.nfName "app-info" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Artisan service fullname-----------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "artisan.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "nrfartisan" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Alternate route service fullname-----------------------------------------------------*/}}
{{/******************************************************************************************************
            NOTE:- This template must be updated if there is any change in  service.fullname template.
   ***************************************************************************************************/}}
{{- define "alternateroute.service.fullname" -}}
{{- printf "%s-%s" .Release.Name "alternate-route" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Registration service port------------------------------------------------*/}}
{{- define "registration.service.port" -}}
{{ .Values.global.nfregistration.portConfiguration.servicePort | default 8080 }}
{{- end -}}

{{/*--------------------Subscription service port------------------------------------------------*/}}
{{- define "subscription.service.port" -}}
{{ .Values.global.nfsubscription.portConfiguration.servicePort | default 8080 }}
{{- end -}}


{{/*--------------------Discovery service port------------------------------------------------*/}}
{{- define "discovery.service.port" -}}
{{ .Values.global.nfdiscovery.portConfiguration.servicePort | default 8080 }}
{{- end -}}

{{/*--------------------Accesstoken service port------------------------------------------------*/}}
{{- define "accesstoken.service.port" -}}
{{ .Values.global.nfaccesstoken.portConfiguration.servicePort | default 8080 }}
{{- end -}}

{{/*--------------------Ingressgateway service port------------------------------------------------*/}}
{{- define "ingressgateway.service.port" -}}
{{- if .Values.global.enableIncomingHttp -}}
{{ .Values.global.publicHttpSignalingPort | default 80 }}
{{- else if .Values.global.enableIncomingHttps -}}
{{ .Values.global.publicHttpsSignallingPort | default 443 }}
{{- end -}}
{{- end -}}

{{/*--------------------Artisan service port------------------------------------------------*/}}
{{- define "artisan.service.port" -}}
{{ .Values.global.nrfartisan.portConfiguration.servicePort | default 8080 }}
{{- end -}}

{{/*--------------------Alternate route service port------------------------------------------------*/}}
{{- define "alternateroute.service.port" -}}
{{ .Values.global.alternateroute.portConfiguration.servicePort | default 8080 }}
{{- end -}}

{{/*--------------------Service mesh check flag------------------------------------------------*/}}
{{- define "servicemesh.check" -}}
{{ .Values.global.serviceMeshCheck | quote }}
{{- end -}}

{{/*--------------------istioProxy ready URL------------------------------------------------*/}}
{{- define "istioproxy.ready.url" -}}
{{ .Values.global.istioSidecarReadyUrl | quote}}
{{- end -}}

{{/*--------------------istioProxy quit URL------------------------------------------------*/}}
{{- define "istioproxy.quit.url" -}}
{{ .Values.global.istioSidecarQuitUrl | quote}}
{{- end -}}

{{/*--------------------Engineering Labels common for all microservices------------------------------*/}}
{{- define "engineering.labels" -}}
app.kubernetes.io/name: {{ template "chart.fullname" . }}
helm.sh/chart: {{ template "chart.fullnameandversion" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ template "chart.appversion" . }}
app.kubernetes.io/part-of: ocnrf
application: {{ .Values.global.app_name }}
microservice: {{ template "service.fullname" . }}
engVersion: {{.Chart.Version}}
mktgVersion: {{.Chart.AppVersion}}
vendor: {{ .Values.global.vendor }}
{{- end -}}

{{/*--------------------Engineering Annotations common for all microservices-------------------------*/}}
{{- define "engineering.annotations" -}}
{{- end -}}

{{/*--------------------Egress Gateway port commonly used by all microservices-----------------------*/}}
{{- define "egressgateway.port" -}}
{{ .Values.global.egressGateway.port | default 8080 }}
{{- end -}}

{{/*--------------------Egress Gateway HTTPS port commonly used by all microservices-----------------------*/}}
{{- define "egressgateway.sslPort" -}}
{{ .Values.global.egressGateway.sslPort | default 80 }}
{{- end -}}

{{/*##################################################################################################################
############################    CustomExtension LABELS section START       ###########################################*/}}

{{/*--------------------CustomExtension labels for lb services-----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.lbServices" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- $global_lbServices_labels := .Values.global.customExtension.lbServices.labels -}}
  {{- $service_specific_labels := .Values.service.customExtension.labels -}}
  {{- $result := dict }}
  {{- $result := merge $result $service_specific_labels }}
  {{- $result := merge $result $global_lbServices_labels }}
  {{- $result := merge $result $global_allResources_labels }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}


{{/*--------------------CustomExtension labels for non lb services-----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.nonlbServices" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- $global_nonlbServices_labels := .Values.global.customExtension.nonlbServices.labels -}}
  {{- $service_specific_labels := .Values.service.customExtension.labels -}} 
  {{- $result := dict }}
  {{- $result := merge $result $service_specific_labels }}
  {{- $result := merge $result $global_nonlbServices_labels }}
  {{- $result := merge $result $global_allResources_labels }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*--------------------CustomExtension labels for lb deployments-----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.lbDeployments" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- $global_lbDeployment_labels := .Values.global.customExtension.lbDeployments.labels -}}
  {{- $deployment_specific_labels := .Values.deployment.customExtension.labels -}}
  {{- $result := dict }}
  {{- $result := merge $result $deployment_specific_labels }}
  {{- $result := merge $result $global_lbDeployment_labels }}
  {{- $result := merge $result $global_allResources_labels }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}


{{/*--------------------CustomExtension labels for non lb deployments-----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.nonlbDeployments" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- $global_nonlbDeployment_labels := .Values.global.customExtension.nonlbDeployments.labels -}}
  {{- $deployment_specific_labels := .Values.deployment.customExtension.labels -}}
  {{- $result := dict }}
  {{- $result := merge $result $deployment_specific_labels }}
  {{- $result := merge $result $global_nonlbDeployment_labels }}
  {{- $result := merge $result $global_allResources_labels }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*--------------------CustomExtension labels for all kubernetes resources-----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.allResources" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- range $key, $value := $global_allResources_labels }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*##############################           CustomExtension LABELS section END    ################################################
###################################################################################################################################*/}}


{{/*###############################################################################################################################
############################    CustomExtension ANNOTATIONS section START        ##################################################*/}}

{{/*--------------------CustomExtension annotations for lb services-----------------------------------------------------------*/}}
{{- define "custom.extensions.annotations.lbServices" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- $global_lbServices_annotations := .Values.global.customExtension.lbServices.annotations -}}
  {{- $service_specific_annotations := .Values.service.customExtension.annotations -}}
  {{- $result := dict }}
  {{- $result := merge $result $service_specific_annotations }} 
  {{- $result := merge $result $global_lbServices_annotations }}
  {{- $result := merge $result $global_allResources_annotations }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}


{{/*--------------------CustomExtension annotations for non lb services-----------------------------------------------------------*/}}
{{- define "custom.extensions.annotations.nonlbServices" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- $global_nonlbServices_annotations := .Values.global.customExtension.nonlbServices.annotations -}}
  {{- $service_specific_annotations := .Values.service.customExtension.annotations -}}
  {{- $result := dict }}
  {{- $result := merge $result $service_specific_annotations }}
  {{- $result := merge $result $global_nonlbServices_annotations }}
  {{- $result := merge $result $global_allResources_annotations }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*--------------------CustomExtension annotations for lb deployments-----------------------------------------------------------*/}}
{{- define "custom.extensions.annotations.lbDeployments" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- $global_lbDeployment_annotations := .Values.global.customExtension.lbDeployments.annotations -}}
  {{- $deployment_specific_annotations := .Values.deployment.customExtension.annotations -}}
  {{- $result := dict }}
  {{- $result := merge $result $deployment_specific_annotations }}
  {{- $result := merge $result $global_lbDeployment_annotations }}
  {{- $result := merge $result $global_allResources_annotations }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*--------------------CustomExtension annotations for non lb deployments-----------------------------------------------------------*/}}
{{- define "custom.extensions.annotations.nonlbDeployments" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- $global_nonlbDeployment_annotations := .Values.global.customExtension.nonlbDeployments.annotations -}}
  {{- $deployment_specific_annotations := .Values.deployment.customExtension.annotations -}}
  {{- $result := dict }}
  {{- $result := merge $result $deployment_specific_annotations }}
  {{- $result := merge $result $global_nonlbDeployment_annotations }}
  {{- $result := merge $result $global_allResources_annotations }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}


{{/*--------------------CustomExtension annotations for all kubernetes resources-----------------------------------------------------------*/}}
{{- define "custom.extensions.annotations.allResources" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- range $key, $value := $global_allResources_annotations }}
    {{- $key | toYaml | trimSuffix "\n" | nindent 4 }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end }}
{{- end -}}

{{/*##############################           CustomExtension ANNOTATIONS section END       #############################################
########################################################################################################################################*/}}

{{/*###############################################################################################################################
##################################       Merged LABELS section START             ##################################################*/}}

{{/*-----------Labels for Lb Services-----------------*/}}
{{- define "labels.lbServices" -}}
{{- include "custom.extensions.labels.lbServices" . }}
{{- include "engineering.labels" . | nindent 4 }}
{{- end -}}

{{/*-----------Labels for NonLb Services-----------------*/}}
{{- define "labels.nonlbServices" -}}
{{- include "custom.extensions.labels.nonlbServices" . }}
{{- include "engineering.labels" . | nindent 4 }}
{{- end -}}

{{/*-----------Labels for Lb Deployments-----------------*/}}
{{- define "labels.lbDeployments" -}}
{{- include "custom.extensions.labels.lbDeployments" . }}
{{- include "engineering.labels" . | nindent 4 }}
{{- end -}}

{{/*-----------Labels for nonlb Deployments-----------------*/}}
{{- define "labels.nonlbDeployments" -}}
{{- include "custom.extensions.labels.nonlbDeployments" . }}
{{- include "engineering.labels" . | nindent 4 }}
{{- end -}}

{{/*-----------Labels for All kubernetes resources-----------------*/}}
{{- define "labels.allResources" -}}
{{- include "custom.extensions.labels.allResources" . }}
{{- include "engineering.labels" . | nindent 4 }}
{{- end -}}

{{/*##############################    Merged LABELS section END            #############################################################
########################################################################################################################################*/}}

{{/*###############################################################################################################################
##################################       Merged ANNOTATIONS section START        ##################################################*/}}
{{/*-----------Annotations for Lb Services-----------------*/}}
{{- define "annotations.lbServices" -}}
{{- include "custom.extensions.annotations.lbServices" . }}
{{- include "engineering.annotations" . | nindent 4 }}
{{- end -}}

{{/*-----------Annotations for NonLb Services-----------------*/}}
{{- define "annotations.nonlbServices" -}}
{{- include "custom.extensions.annotations.nonlbServices" . }}
{{- include "engineering.annotations" . | nindent 4 }}
{{- end -}}

{{/*-----------Annotations for Lb Deployments-----------------*/}}
{{- define "annotations.lbDeployments" -}}
{{- include "custom.extensions.annotations.lbDeployments" . }}
{{- include "engineering.annotations" . | nindent 4 }}
{{- end -}}

{{/*-----------Annotations for nonLb Deployments-----------------*/}}
{{- define "annotations.nonlbDeployments" -}}
{{- include "custom.extensions.annotations.nonlbDeployments" . }}
{{- include "engineering.annotations" . | nindent 4 }}
{{- end -}}

{{/*-----------Annotations for All kubernetes resources-----------------*/}}
{{- define "annotations.allResources" -}}
{{- include "custom.extensions.annotations.allResources" . }}
{{- include "engineering.annotations" . | nindent 4 }}
{{- end -}}

{{/*##############################   Merged ANNOTATIONS section END       #############################################################
########################################################################################################################################*/}}

{{/*###############################################################################################################################
##################################       Template function for injecting Debug tool Container    ##################################################*/}}

{{- define "extraContainers" -}}
  {{- if (eq .Values.extraContainers "ENABLED") -}}
    {{- tpl (default .Values.global.extraContainersTpl .Values.extraContainersTpl) . }}
  {{- else if (eq .Values.extraContainers "USE_GLOBAL_VALUE") -}}
    {{- if (eq .Values.global.extraContainers "ENABLED") -}}
      {{- tpl (default .Values.global.extraContainersTpl .Values.extraContainersTpl) . }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "extraVolumes" -}}
  {{- if (eq .Values.extraContainers "ENABLED") -}}
    {{- tpl (default .Values.global.extraContainersVolumesTpl .Values.extraContainersVolumesTpl) . }}
  {{- else if (eq .Values.extraContainers "USE_GLOBAL_VALUE") -}}
    {{- if (eq .Values.global.extraContainers "ENABLED") -}}
      {{- tpl (default .Values.global.extraContainersVolumesTpl .Values.extraContainersVolumesTpl) . }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*####################################################################################################################################
########################################################################################################################################*/}}


{{/*--------------------------Ephemeral Storage Request-------------------------------------------*/}}
{{- define "ocnrf-ephemeral-storage-request" -}}
{{- if ne (add .Values.global.logStorage .Values.global.crictlStorage)  0 }}
  {{- $result := dict "ephemeral-storage" (printf "%s%s" (toString (div (mul (add .Values.global.logStorage .Values.global.crictlStorage) 11) 10)) "Mi") }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*--------------------------Ephemeral Storage Limit------------------------------------------*/}}
{{- define "ocnrf-ephemeral-storage-limit" -}}
{{- if ne (int .Values.global.ephemeralStorageLimit)  0 }}
  {{- $result := dict "ephemeral-storage" (printf "%s%s" (toString .Values.global.ephemeralStorageLimit) "Mi") }}
  {{- range $key, $value := $result }}
    {{- $key | toYaml | trimSuffix "\n" }}: {{ $value | trimSuffix "\n" | quote }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*--------------------Common NodeSelector----------------------------------------------------------------------*/}}
{{- define "ocnf.nodeselector" }}
 {{- $localNodeSelection := .Values.nodeSelection | default "USE_GLOBAL_VALUE" }}
 {{- $globalNodeSelection := .Values.global.nodeSelection | default "DISABLED" }}
 {{- $nodeselector := "" }}

 {{- if (eq $localNodeSelection "ENABLED") }}
   {{- $nodeselector =  .Values.nodeSelector }}
 {{- else if (eq $localNodeSelection "USE_GLOBAL_VALUE") }}
   {{- if (eq $globalNodeSelection "ENABLED")}}
     {{- $nodeselector = .Values.global.nodeSelector }}
   {{- end }}
 {{- end }}

 {{- if $nodeselector }}
{{- toYaml $nodeselector }}
 {{- end }}
{{- end }}

{{/*--------------------Common Tolerations----------------------------------------------------------------------*/}}
{{- define "ocnf.tolerations" }}
 {{- $localTolerationsSetting := .Values.tolerationsSetting | default "USE_GLOBAL_VALUE" }}
 {{- $globalTolerationsSetting := .Values.global.tolerationsSetting | default "DISABLED" }}
 {{- $tolerations := "" }}

 {{- if (eq $localTolerationsSetting "ENABLED") }}
   {{- $tolerations =  .Values.tolerations }}
 {{- else if (eq $localTolerationsSetting "USE_GLOBAL_VALUE") }}
   {{- if (eq $globalTolerationsSetting "ENABLED")}}
     {{- $tolerations = .Values.global.tolerations }}
   {{- end }}
 {{- end }}

 {{- if $tolerations }}
{{- toYaml $tolerations }}
 {{- end }}
{{- end }}
