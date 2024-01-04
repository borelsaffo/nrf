# Copyright 2020 (C), Oracle and/or its affiliates. All rights reserved.

{{/* vim: set filetype=mustache: */}}

{{/*--------------------------------------Debug Tool Container---------------------------------------------------*/}}
{{- define "extraContainers" -}}
  {{- if (eq .Values.extraContainers "ENABLED") -}}
    {{- tpl ( .Values.global.extraContainersTpl) . }}
  {{- else if (eq .Values.extraContainers "USE_GLOBAL_VALUE") -}}
    {{- if (eq .Values.global.extraContainers "ENABLED") -}}
      {{- tpl ( .Values.global.extraContainersTpl) . }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*--------------------------------------Debug Tool Container Volume Mount---------------------------------------------------*/}}
{{- define "igw-extraContainersVolume" -}}
  {{- if (eq .Values.extraContainers "ENABLED") -}}
- name: debug-tools-dir
  emptyDir:
    medium: Memory
    sizeLimit: 4Gi
  {{- else if (eq .Values.extraContainers "USE_GLOBAL_VALUE") -}}
    {{- if (eq .Values.global.extraContainers "ENABLED") -}}
- name: debug-tools-dir
  emptyDir:
    medium: Memory
    sizeLimit: 4Gi
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*--------------------Expand the name of the chart.-------------------------------------------------------------*/}}
{{- define "chart.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Perf Info Service Name-------------------------------------------------------------*/}}
{{- define "service.perfInfoServiceFullName" -}}
{{- if .Values.global.perfInfoConfig.serviceName -}}
{{- $name := .Values.global.perfInfoConfig.serviceName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.global.perfInfoConfig.host | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Create chart name and version as used by the chart label.---------------------------------*/}}
{{- define "chart.fullnameandversion" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Common Service Account Name---------------------------------------------------------------*/}}
{{- define "ingressgateway.serviceaccount" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s-%s" .Release.Name .Values.prefix "ingressgateway-serviceaccount" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "ingressgateway-serviceaccount" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------IGW Service Type---------------------------------------------------------------*/}}
{{- define "ingressgateway.serviceType" }}
  {{- .Values.global.type }}
{{- end }}

{{/*--------------------Common ROLE-------------------------------------------------------------------------------*/}}
{{- define "ingressgateway.role" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-ingressgateway-role
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}-ingressgateway-role
{{- end -}}
{{- end -}}


{{/*--------------------Common ROLE BINDING----------------------------------------------------------------------*/}}
{{- define "ingressgateway.rolebinding" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-ingressgateway-rolebinding
{{- else -}}
{{ .Release.Name | trunc 63 | trimSuffix "-" -}}-ingressgateway-rolebinding
{{- end -}}
{{- end -}}

{{/*-------------------get prefix.-------------------------------------------------------------*/}}
{{- define "getprefix" -}}
{{  default "" .Values.global.k8sResource.container.prefix | lower }}
{{- end -}}

{{/*-------------------getsuffix.-------------------------------------------------------------*/}}
{{- define "getsuffix" -}}
{{  default "" .Values.global.k8sResource.container.suffix | lower }}
{{- end -}}

{{/*--------------------Expand the name of the container.-------------------------------------------------------------*/}}
{{- define "container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s" $prefix (include "chart.fullname" . ) $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Ephemeral Storage---------------------------------------------------------------*/}}
{{- define "ingress-gateway-ephemeral-storage-request" -}}
 {{- div (mul (add .Values.global.logStorage .Values.global.crictlStorage) 11) 10 -}}Mi
{{- end -}}

{{- define "ingress-gateway-ephemeral-storage-limit" -}}
 {{- .Values.global.ephemeralStorageLimit -}}Mi
{{- end -}}



{{/*--------------------Service Name-----------------------------------------------------------------------------*/}}
{{/***************************************************************************************************************
     NOTE: 1. Engineering Configuration:  Micro-Service routes (.Values.ingressgateway.routesConfig) must be updated
              if there is any change in service.fullname template.
   ***************************************************************************************************************/}}
{{- define "service.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-{{- .Chart.Name }}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*--------------------Common Config server Service Name------------------------------------------------------------*/}}
{{- define "service.ConfigServerSvcFullname" -}}
{{- if .Values.commonCfgServer.configServerSvcName -}}
{{- $name := .Values.commonCfgServer.configServerSvcName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.commonCfgServer.host | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Coherence Service Name------------------------------------------------------------*/}}
{{- define "service.igw.CoherenceSvcFullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s-%s" .Release.Name .Values.prefix "igw-cache" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "igw-cache" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Alternate route Service Name-------------------------------------------------------------*/}}
{{- define "service.alternateRouteSvcFullname" -}}
{{- if .Values.dnsSrv.alternateRouteSvcName -}}
{{- $name := .Values.dnsSrv.alternateRouteSvcName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.dnsSrv.host | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Metric prefix for adding custom prefix to metric name------------------------------------------------------------*/}}
{{- define "metric.prefix" -}}
{{- if .Values.metricPrefix -}}
{{- .Values.metricPrefix -}}
{{- else if .Values.global.metricPrefix -}}
{{- .Values.global.metricPrefix -}}
{{- end -}}
{{- end -}}
{{/*--------------------Metric suffix for adding custom suffix to metric name------------------------------------------------------------*/}}
{{- define "metric.suffix" -}}
{{- if .Values.metricSuffix -}}
{{- .Values.metricSuffix -}}
{{- else if .Values.global.metricSuffix -}}
{{- .Values.global.metricSuffix -}}
{{- end -}}
{{- end -}}

{{/*-------------------- Persistent configuration --------------------------------------------------------------------*/}}
{{- define "defaultconfig-igw.labels" -}}
{{- $loggingJson := tpl ( .Files.Get "config/logging.json" ) . }}
logging:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "logging" .Values.nfSpecificConfig.featureList) ($loggingJson) }}
{{ $loggingJson | indent 2 }}
{{- else }}
  appLogLevel: {{ .Values.log.level.ingress }}
  packageLogLevel:
  - packageName: root
    logLevelForPackage: {{ .Values.log.level.root }}
  - packageName: oauth
    logLevelForPackage: {{ .Values.log.level.oauth }}
{{- end }}
{{- else }}
  appLogLevel: {{ .Values.log.level.ingress }}
  packageLogLevel:
  - packageName: root
    logLevelForPackage: {{ .Values.log.level.root }}
  - packageName: oauth
    logLevelForPackage: {{ .Values.log.level.oauth }}
{{- end }}
{{- $oauthValidatorConfigurationJson := tpl ( .Files.Get "config/oauthvalidatorconfiguration.json" ) . }}
oauthvalidatorconfiguration:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "oauthvalidatorconfiguration" .Values.nfSpecificConfig.featureList) ($oauthValidatorConfigurationJson) }}
{{ $oauthValidatorConfigurationJson | indent 2 }}
{{- else }}
  keyIdList: []
  instanceIdList: []
  oauthValidationMode: INSTANCEID_ONLY
{{- end }}
{{- else }}
  keyIdList: []
  instanceIdList: []
  oauthValidationMode: INSTANCEID_ONLY
{{- end }}
{{- $errorCodeProfilesJson := tpl ( .Files.Get "config/errorcodeprofiles.json" ) . }}
errorcodeprofiles:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "errorcodeprofiles" .Values.nfSpecificConfig.featureList) ($errorCodeProfilesJson) }}
{{ $errorCodeProfilesJson | indent 2 }}
{{- else }}
{{- if .Values.errorCodeProfiles }}
{{- range .Values.errorCodeProfiles }}
  - name: {{ .name }}
    errorCode: {{ .errorCode }}
  {{- if .errorCause }}
    errorCause: {{ .errorCause }}
  {{- end }}
  {{- if .errorTitle }}
    errorTitle: {{ .errorTitle }}
  {{- end }}
  {{- if .errorDescription }}
    errorDescription: {{ .errorDescription }}
  {{- end }}
  {{- if .retryAfter }}
    retryAfter: {{ .retryAfter | quote }}
  {{- end }}
  {{- if .redirectUrl }}
    redirectUrl: {{ .redirectUrl | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- else }}
{{- range .Values.errorCodeProfiles }}
  - name: {{ .name }}
    errorCode: {{ .errorCode }}
  {{- if .errorCause }}
    errorCause: {{ .errorCause }}
  {{- end }}
  {{- if .errorTitle }}
    errorTitle: {{ .errorTitle }}
  {{- end }}
  {{- if .errorDescription }}
    errorDescription: {{ .errorDescription }}
  {{- end }}
  {{- if .retryAfter }}
    retryAfter: {{ .retryAfter | quote }}
  {{- end }}
  {{- if .redirectUrl }}
    redirectUrl: {{ .redirectUrl | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- $configErrorCodesFlag := true }}
{{- if .Values.configurableErrorCodes }}
{{- range .Values.configurableErrorCodes.errorScenarios }}
{{- if .errorCode }}
{{- $configErrorCodesFlag = false }}
{{- end }}
{{- end }}
{{- end }}

{{- if $configErrorCodesFlag }}
{{- $configurableErrorCodesJson := tpl ( .Files.Get "config/configurableerrorcodes.json" ) . }}
configurableerrorcodes:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.configurableErrorCodes) (has "configurableerrorcodes" .Values.nfSpecificConfig.featureList) ($configurableErrorCodesJson) }}
{{ $configurableErrorCodesJson | indent 2 }}
{{- else }}
{{- if .Values.configurableErrorCodes }}
  enabled: {{ .Values.configurableErrorCodes.enabled }}
  errorScenarios:
{{- range .Values.configurableErrorCodes.errorScenarios }}
{{- if .exceptionType }}
  - exceptionType: {{ .exceptionType }}
{{- end }}
{{- if .errorProfileName }}
    errorProfileName: {{ .errorProfileName }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- else }}
{{- if .Values.configurableErrorCodes }}
  enabled: {{ .Values.configurableErrorCodes.enabled }}
  errorScenarios:
{{- range .Values.configurableErrorCodes }}
{{- if .exceptionType }}
  - exceptionType: {{ .exceptionType }}
{{- end }}
{{- if .errorProfileName }}
    errorProfileName: {{ .errorProfileName }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- $ocDiscardPoliciesJson := tpl ( .Files.Get "config/ocdiscardpolicies.json" ) . }}
ocdiscardpolicies:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "ocdiscardpolicies" .Values.nfSpecificConfig.featureList) ($ocDiscardPoliciesJson) }}
{{ $ocDiscardPoliciesJson | indent 2 }}
{{- end }}
{{- end }}

{{- $controlledShutdownErrorMappingJson := tpl ( .Files.Get "config/controlledshutdownerrormapping.json" ) . }}
controlledshutdownerrormapping:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "Controlledshutdownerrormapping" .Values.nfSpecificConfig.featureList) ($controlledShutdownErrorMappingJson) }}
{{ $controlledShutdownErrorMappingJson | indent 2 }}
{{- else }}
  routeErrorProfileList: []
{{- end }}
{{- else }}
  routeErrorProfileList: []
{{- end }}

{{- $ccaheaderJson := tpl ( .Files.Get "config/ccaheaderJson" ) . }}
ccaheader:
{{- if and (.Values.nfSpecificConfig) (.Values.nfSpecificConfig.featureList) (has "ccaheader" .Values.nfSpecificConfig.featureList) ($ccaheaderJson) }}
{{ $ccaheaderJson | indent 2 }}
{{- else }}
{{- if  .Values.ccaHeaderValidation }}
  enabled: {{ .Values.ccaHeaderValidation.enabled }}
  minExpiryTime: {{ .Values.ccaHeaderValidation.minExpiryTime }}
  maxTokenAge: {{ .Values.ccaHeaderValidation.maxTokenAge }}
  role: {{ .Values.ccaHeaderValidation.role }}
  subKey: {{ .Values.ccaHeaderValidation.subKey }}
  validationRule: {{ .Values.ccaHeaderValidation.validationRule }}
{{- else }}
  enabled: false
  minExpiryTime: 0
  maxTokenAge: 0
  role: "NRF"
  subKey: "subjectAltName"
  validationRule: "strict"
{{- end }}
{{- end }}

{{- $copyHeaderJson := tpl ( .Files.Get "config/copyHeaderJson" ) . }}
copyHeaderOnGatewayError:
{{- if and (.Values.nfSpecificConfig) (.Values.nfSpecificConfig.featureList) (has "copyHeaderOnGatewayError" .Values.nfSpecificConfig.featureList) ($copyHeaderJson) }}
{{ $copyHeaderJson | indent 2 }}
{{- else }}
{{- if  ( eq (.Values.copyHeaderConfigMode) "REST" ) }}
  enabled: {{ .Values.copyHeaderOnGatewayError.enabled }}
  requestToResponse:
    requestHeaderNames:
    {{- range .Values.copyHeaderOnGatewayError.requestToResponse.requestHeaderNames }}
    - {{ . }}
    {{- end }}
 {{- else }}
  enabled: false
  requestToResponse:
   requestHeaderNames:
    - defaultHeader
{{- end }}
{{- end }}

{{- $applicationParamsJson := tpl ( .Files.Get "config/applicationparams.json" ) . }}
applicationparams:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "applicationparams" .Values.nfSpecificConfig.featureList) ($applicationParamsJson) }}
{{ $applicationParamsJson | indent 2 }}
{{- else if .Values.defaultConfig.controlledShutdown.operationalState }}
  operationalState: {{ .Values.defaultConfig.controlledShutdown.operationalState }}
{{- else }}
  operationalState: NORMAL
{{- end }}
{{- else if .Values.defaultConfig.controlledShutdown.operationalState }}
  operationalState: {{ .Values.defaultConfig.controlledShutdown.operationalState }}
{{- else }}
  operationalState: NORMAL
{{- end }}


{{- $routesConfigurationJson := tpl ( .Files.Get "config/routesconfiguration.json" ) . }}
routesconfiguration:
{{- if and ( eq (.Values.routeConfigMode) "REST" ) (.Values.convertHelmRoutesToREST) }}
{{- range .Values.routesConfig }}
  - id: {{ .id }}
    uri: {{ tpl ( .uri ) $ }}
    {{- if .order }}
    order: {{ .order }}
    {{- end}}
    predicates:
      - name: Path
        args:
          pattern: {{ .path }}
        {{- if .method }}
      - name: Method
        args:
          methods: {{ .method }}
        {{- end}}
        {{- if .readBodyForLog }}
      - name: ReadBodyForLog
        args:
          enable: {{ .readBodyForLog }}
        {{- end}}
  {{- if .metadata }}
    metadata:
  {{- if .metadata.configurableErrorCodes }}
      configurableErrorCodes:
        enabled: {{ .metadata.configurableErrorCodes.enabled }}
  {{- if .metadata.configurableErrorCodes.errorScenarios }}
        errorScenarios:
  {{- range .metadata.configurableErrorCodes.errorScenarios }}
        - exceptionType: {{ .exceptionType | quote }}
          errorProfileName: {{ .errorProfileName | quote }}
  {{- end }}
  {{- end }}
  {{- end }}
    {{- if .metadata.requestTimeout }}
        - requestTimeout: {{ .metadata.requestTimeout }}
    {{- end }}
    {{- if .metadata.xfccHeaderValidation }}
        - xfccHeaderValidation:
            validationEnabled: {{ .metadata.xfccHeaderValidation.validationEnabled }}
    {{- end }}
    {{- if .metadata.oauthValidator }}
        - oauthValidator:
            enabled: {{ .metadata.oauthValidator.enabled }}
    {{- end }}
    {{- if .metadata.svcName }}
        - svcName: {{ .metadata.svcName }}
    {{- end }}
    {{- if .metadata.serverHeaderDetails }}
        - serverHeaderDetails:
            enabled: {{ .metadata.serverHeaderDetails.enabled }}
        {{- if .metadata.serverHeaderDetails.errorCodeSeriesId }}
            errorCodeSeriesId: {{ .metadata.serverHeaderDetails.errorCodeSeriesId }}
        {{- end }}
    {{- end }}
  {{- end }}
  {{- if .filters }}
    filters:
    {{- if .filters.invalidRouteFilter }}
      - name: InvalidRouteFilter
        args:
        {{- range .filters.invalidRouteFilter }}
          errorCodeOnInvalidRoute: {{ .errorCodeOnInvalidRoute | default 503 | quote }}
          errorCauseOnInvalidRoute: {{ .errorCauseOnInvalidRoute | default "" | quote }}
          errorTitleOnInvalidRoute: {{ .errorTitleOnInvalidRoute | default "" | quote }}
          errorDescriptionOnInvalidRoute: {{ .errorDescriptionOnInvalidRoute | default "" | quote }}
          redirectUrl: {{ .redirectUrl | default "" | quote }}
        {{- end }}
    {{- end }}
    {{- if .filters.subLog }}
      - name: SubLog
        args:
          pattern: {{ .filters.subLog }}
    {{- end }}
    {{- if .removeResponseHeader }}
      - name: RemoveResponseHeader
        args:
      {{- range .removeResponseHeader }}
          - name: {{ .name }}
      {{- end }}
    {{- end }}
    {{- if .removeRequestHeader }}
      - name: RemoveRequestHeader
        args:
      {{- range .removeRequestHeader }}
          - name: {{ .name }}
      {{- end }}
    {{- end }}
    {{- if .filters.rewritePath }}
      - name: RewritePath
        args:
          regexp: {{ trim (split "," .filters.rewritePath)._0 }}
          replacement: {{ trim (split "," .filters.rewritePath)._1 }}
    {{- end }}
    {{- if .filters.prefixPath }}
      - name: PrefixPath
        args:
          prefix: {{ .filters.prefixPath }}
    {{- end }}
    {{- if .filters.addRequestHeader }}
      - name: AddRequestHeader
        args:
      {{- range .filters.addRequestHeader }}
          - name: {{ .name }}
          - value: {{ .value }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "routesconfiguration" .Values.nfSpecificConfig.featureList) ($routesConfigurationJson) }}
{{ $routesConfigurationJson | indent 2 }}
{{- end }}
{{- else }}
routesconfiguration:
{{- end }}
{{- $ocPolicyMappingJson := tpl ( .Files.Get "config/ocpolicymapping.json" ) . }}
ocpolicymapping:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "ocpolicymapping" .Values.nfSpecificConfig.featureList) ($ocPolicyMappingJson) }}
{{ $ocPolicyMappingJson | indent 2 }}
{{- else }}
  enabled: false
  samplingPeriod: {{ .Values.defaultConfig.overloadControl.samplingPeriod }}
  mappings:
{{- end }}
{{- else }}
  enabled: false
  samplingPeriod: {{ .Values.defaultConfig.overloadControl.samplingPeriod }}
  mappings:
{{- end }}
{{- $routeLevelRateLimitingJson := tpl ( .Files.Get "config/routelevelratelimiting.json" ) . }}
routelevelratelimiting:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "routelevelratelimiting" .Values.nfSpecificConfig.featureList) ($routeLevelRateLimitingJson) }}
{{ $routeLevelRateLimitingJson | indent 2 }}
{{- else }}
  enabled: false
  samplingPeriod: {{ .Values.defaultConfig.rateLimiting.samplingPeriod }}
  rateLimitPolicies:
{{- end }}
{{- else }}
  enabled: false
  samplingPeriod: {{ .Values.defaultConfig.rateLimiting.samplingPeriod }}
  rateLimitPolicies:
{{- end }}
{{- $serverHeaderDetailsJson := tpl ( .Files.Get "config/serverheaderdetails.json" ) . }}
serverheaderdetails:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.serverHeaderDetails) }}
  enabled: {{ .Values.serverHeaderDetails.enabled }}
  {{- if .Values.serverHeaderDetails.errorCodeSeriesId }}
  errorCodeSeriesId: {{ .Values.serverHeaderDetails.errorCodeSeriesId }}
  {{- end }}
  configuration:
    {{- if .Values.serverHeaderDetails.configuration.nfType }}
    nfType: {{ .Values.serverHeaderDetails.configuration.nfType }}
    {{- end }}
    {{- if .Values.serverHeaderDetails.configuration.nfInstanceId }}
    nfInstanceId: {{ .Values.serverHeaderDetails.configuration.nfInstanceId }}
    {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "serverheaderdetails" .Values.nfSpecificConfig.featureList) ($serverHeaderDetailsJson) }}
{{ $serverHeaderDetailsJson | indent 2 }}
{{- else }}
  enabled: false
  configuration:
    nfType: ""
{{- end }}
{{- else }}
  enabled: false
  configuration:
    nfType: ""
{{- end }}
{{- else }}
  enabled: false
  configuration:
    nfType: ""
{{- end }}
{{- $messageLoggingJson := tpl ( .Files.Get "config/messagelogging.json" ) . }}
messagelogging:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "messagelogging" .Values.nfSpecificConfig.featureList) ($messageLoggingJson) }}
{{ $messageLoggingJson | indent 2 }}
{{- else }}
  enabled: false
{{- end }}
{{- else }}
  enabled: false
{{- end }}
{{- $errorCodeSeriesListJson := tpl ( .Files.Get "config/errorcodeserieslist.json" ) . }}
errorcodeserieslist:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.errorCodeSeriesList) }}
  {{- range .Values.errorCodeSeriesList }}
  - id: {{ .id }}
    errorCodeSeries:
    {{- range .errorCodeSeries }}
    - errorSet: {{ .errorSet }}
      errorCodes:
      {{- range .errorCodes }}
      - {{.}}
      {{- end }}
    {{- end }}
  {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "errorcodeserieslist" .Values.nfSpecificConfig.featureList) ($errorCodeSeriesListJson) }}
{{ $errorCodeSeriesListJson | indent 2 }}
{{- end }}
{{- end }}
{{- end }}
{{- $trafficRejectModeJson := tpl ( .Files.Get "config/trafficrejectmode.json" ) . }}
trafficrejectmode:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "trafficrejectmode" .Values.nfSpecificConfig.featureList) ($trafficRejectModeJson) }}
{{ $trafficRejectModeJson | indent 2 }}
{{- else }}
  enabled: false
{{- end }}
{{- else }}
  enabled: false
{{- end }}
{{- $podProtectionJson := tpl ( .Files.Get "config/podprotection.json" ) . }}
podprotection:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.podProtection) }}
  enabled: {{ .Values.podProtection.enabled }}
  monitoringInterval: {{ .Values.podProtection.monitoringInterval }}
  congestionControl:
    enabled: {{ .Values.podProtection.congestionControl.enabled }}
    stateChangeSampleCount: {{ .Values.podProtection.congestionControl.stateChangeSampleCount }}
    actionSamplingPeriod: {{ .Values.podProtection.congestionControl.actionSamplingPeriod }}
    states:
     {{- range .Values.podProtection.congestionControl.states }}
     - name: {{ .name }}
       weight: {{ .weight }}
       {{- if  .resourceThreshold }}
       resourceThreshold:
         {{- if .resourceThreshold.cpu }}
         cpu: {{ .resourceThreshold.cpu }}
         {{- end }}
         {{- if .resourceThreshold.memory }}
         memory: {{ .resourceThreshold.memory }}
         {{- end }}
         {{- if .resourceThreshold.pendingMessage }}
         pendingMessage: {{ .resourceThreshold.pendingMessage }}
         {{- end }}
       {{- end}}
       entryAction:
       {{- range .entryAction }}
         - action: {{ .action }}
           args:
           {{- range $key, $value := .args }}
             {{ $key }}: {{ $value }}
           {{- end}}
       {{- end }}
     {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "podprotection" .Values.nfSpecificConfig.featureList) ($podProtectionJson) }}
{{ $podProtectionJson | indent 2 }}
{{- else }}
  enabled: false
{{- end }}
{{- else }}
  enabled: false
{{- end }}
{{- else }}
  enabled: false
{{- end }}
{{- $readinessConfigJson := tpl ( .Files.Get "config/readinessconfig.json" ) . }}
readinessconfig:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.readinessConfig) }}
  {{- if eq (toString .Values.readinessCheckEnabled) "true" }}
  serviceProfiles:
  {{- range .Values.readinessConfig.serviceProfiles }}
  - id: {{ .id | quote }}
    url: {{ .url | quote }}
    responseCode: {{ .responseCode | quote }}
    responseBody: {{ .responseBody | quote }}
    onExceptionUsePreviousState: {{ .onExceptionUsePreviousState }}
    initialState: {{ .initialState | quote }}
    {{- if .requestTimeout }}
    requestTimeout: {{ .requestTimeout | quote }}
    {{- end}}
  {{- end }}
  {{- else }}
  serviceProfiles:
  {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "readinessconfig" .Values.nfSpecificConfig.featureList) ($readinessConfigJson) }}
{{ $readinessConfigJson | indent 2 }}
{{- else }}
  serviceProfiles:
{{- end }}
{{- else }}
  serviceProfiles:
{{- end }}
{{- else }}
  serviceProfiles:
{{- end }}
{{- if .Values.userAgentHeaderValidation }}
{{- $userAgentHeaderValidation := tpl ( .Files.Get "config/useragentheadervalidation.json" ) . }}
useragentheadervalidation:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.userAgentHeaderValidation) }}
  enabled: {{ .Values.userAgentHeaderValidation.enabled }}
  validationType: {{ .Values.userAgentHeaderValidation.validationType }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "useragentheadervalidation" .Values.nfSpecificConfig.featureList) ($userAgentHeaderValidation) }}
{{ $userAgentHeaderValidation | indent 2 }}
{{- else }}
  enabled: false
  validationType: strict
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
{{/*--------------------Hook ConfigMap Name----------------------------------------------------------------------------*/}}
{{- define "hook-configmap.igw.fullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-hook-configmap-igw
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}-hook-configmap-igw
{{- end -}}
{{- end -}}


{{/*--------------------Deployment Name---------------------------------------------------------------------------*/}}
{{- define "deployment.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-{{- .Chart.Name }}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*--------------------ConfigMap Name----------------------------------------------------------------------------*/}}
{{- define "configmap.fullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-{{- .Chart.Name }}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*--------------------Horizontal Pod Autoscalar Name------------------------------------------------------------*/}}
{{- define "hpautoscalar.fullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-{{- .Chart.Name }}
{{- else -}}
{{ .Release.Name | trunc 63 | trimSuffix "-" -}}-{{- .Chart.Name }}
{{- end -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Install .--------------------------------*/}}
{{- define "pre-install-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-install" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-install container.--------------------------------*/}}
{{- define "pre-install-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-install" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Upgrade .--------------------------------*/}}
{{- define "pre-upgrade-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-upgrade" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Upgrade-oAuth-Validator .--------------------------------*/}}
{{- define "pre-upgrade-oauth-validator-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-upgrade" | trunc 47 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-upgrade container.--------------------------------*/}}
{{- define "pre-upgrade-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-upgrade" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Rollback .--------------------------------*/}}
{{- define "pre-rollback-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-rollback" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-rollback container.--------------------------------*/}}
{{- define "pre-rollback-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-rollback" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Pre-Delete .--------------------------------*/}}
{{- define "pre-delete-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "pre-delete" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the pre-delete container.--------------------------------*/}}
{{- define "pre-delete-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "pre-delete" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}
 
{{/*-------------------- Job Name for Post-Upgrade .--------------------------------*/}}
{{- define "post-upgrade-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-upgrade" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-upgrade container.--------------------------------*/}}
{{- define "post-upgrade-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-upgrade" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*-------------------- Job Name for Post-Rollback .--------------------------------*/}}
{{- define "post-rollback-job.fullname" -}}
{{- printf "%s-%s" (include "service.fullname" .) "post-rollbck" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-rollback container.--------------------------------*/}}
{{- define "post-rollback-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-rollback" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Engineering Labels common for all microservices--------------------------------------------*/}}
{{- define "engineering.labels" -}}
app.kubernetes.io/name: {{ template "chart.fullname" . }}
helm.sh/chart: {{ template "chart.fullnameandversion" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/part-of: ocingress-gateway
app.kubernetes.io/vendor: {{ .Values.global.vendor }}
app.kubernetes.io/mktgVersion: {{ .Chart.AppVersion }}
app.kubernetes.io/engVersion: {{ .Chart.Version }}
app.kubernetes.io/application: {{ .Values.global.app_name }}
app.kubernetes.io/microservice: ocingress-gateway
{{- end -}}

{{/*--------------------Engineering Annotations common for all microservices---------------------------------------*/}}
{{- define "engineering.annotations" -}}
{{- end -}}

{{/*--------------------Service mesh check flag------------------------------------------------*/}}
{{- define "servicemesh.check" -}}
{{ .Values.serviceMeshCheck | quote}}
{{- end -}}

{{/*--------------------istioProxy ready URL------------------------------------------------*/}}
{{- define "istioproxy.ready.url" -}}
{{ .Values.istioSidecarReadyUrl | quote}}
{{- end -}}

{{/*--------------------istioProxy quit URL------------------------------------------------*/}}
{{- define "istioproxy.quit.url" -}}
{{ .Values.istioSidecarQuitUrl | quote}}
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

{{/*--------------------CustomExtension labels for non lb cache services----------------------------------------------------------*/}}
{{- define "custom.extensions.labels.nonlbCacheServices" -}}
  {{- $global_allResources_labels := .Values.global.customExtension.allResources.labels -}}
  {{- $global_nonlbServices_labels := .Values.global.customExtension.nonlbServices.labels -}}
  {{- $result := dict }}
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

{{/*--------------------CustomExtension annotations for non lb cache services-----------------------------------------------------*/}}
{{- define "custom.extensions.annotations.nonlbCacheServices" -}}
  {{- $global_allResources_annotations := .Values.global.customExtension.allResources.annotations -}}
  {{- $global_nonlbServices_annotations := .Values.global.customExtension.nonlbServices.annotations -}}
  {{- $result := dict }}
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

{{/*-----------Labels for NonLb Cache Services-----------------*/}}
{{- define "labels.nonlbCacheServices" -}}
{{- include "custom.extensions.labels.nonlbCacheServices" . }}
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

{{/*-----------Annotations for NonLb Cache Services-----------------*/}}
{{- define "annotations.nonlbCacheServices" -}}
{{- include "custom.extensions.annotations.nonlbCacheServices" . }}
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

{{/*----------INIT CONTAINER ENABLE CHECK-------------*/}}
{{- define "initcontainer.enabled" -}}
 {{- if or .Values.initssl (and .Values.messageCopy.enabled .Values.messageCopy.security.enabled) -}}
  {{- printf "true" -}}
 {{- else -}}
  {{- printf "false" -}}
 {{- end -}}
{{- end -}}


{{/*------------------- CNCC sections starts -------------------------------------------------------------*/}}
{{/***************************************************************************************************************
     Any custom lables/variables related to CNCC will be defined here.
   ***************************************************************************************************************/}}
{{- define "cncc.servicemesh.httpsEnabled" -}}
  {{- true | quote }}
{{- end -}}

{{- define "cncc.primaryIssuer" -}}
  {{ index .Values.cncc.iam.issuers 0 }}
{{- end -}}

{{- define "cncc.iam.userId" -}}
  {{- "UNKNOWN" }}
{{- end -}}

{{- define "cncc.iam.userName" -}}
  {{- "UNKNOWN" }}
{{- end -}}

{{- define "cncc.onlyResourceServerEnabled" -}}
  {{ .Values.cncc.onlyResourceServerEnabled | default false }}
{{- end -}}

{{- define "cncc.iam.issuers" -}}
        {{- $prefix := .Values.cncc.iam.prefix }}
        {{- $realm := .Values.cncc.iam.realm }}
        {{- range .Values.cncc.iam.issuers }}
          - {{.}}{{ $prefix }}/realms/{{ $realm }}
        {{- end -}}
{{- end -}}

{{- define "cncc.mimcConfig" -}}
    multi-instance-multi-cluster-config:
      multiClusterMultiInstanceEnabled: false
      siteBasedAuthorizationEnabled: false
      cnccIdHeader: oc-cncc-id
      instanceIdHeader: oc-cncc-instance-id	  
      mCnccCores: []
      aCnccs: []
      instances: []
{{- end -}}

{{- define "cncc.loggingFilters" -}}
    logging-filters:
      headers:
      {{- range $val := .Values.log.level.cncc.loggingFilters }}
        - header: {{ .headerName }}
          {{- if $val.headerValues }}
          value:
          {{- range  $val.headerValues }}
            - {{ . }}
          {{- end -}}
          {{- end -}}
      {{- end -}}
{{- end -}}

{{- define "cncc.loggingMasks" -}}
    logging-masks:
      masks:
      {{- range $val := .Values.log.level.cncc.loggingMasks }}
        - uri: {{ .uri }}
          {{- if .regexUri }}
          regexUri: {{ .regexUri }}
          {{- end -}}
          {{- if $val.keys }}
          keys:
          {{- range  $val.keys }}
            - {{ . }}
          {{- end -}}
          {{- end -}}
      {{- end -}}
{{- end -}}

{{/*------------------- CNCC sections ends -------------------------------------------------------------*/}}