# Copyright 2020 (C), Oracle and/or its affiliates. All rights reserved.

{{/* vim: set filetype=mustache: */}}

{{/*--------------------Expand the name of the chart.-------------------------------------------------------------*/}}
{{- define "chart.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Create chart name and version as used by the chart label.---------------------------------*/}}
{{- define "chart.fullnameandversion" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Common Service Account Name---------------------------------------------------------------*/}}
{{- define "egressgateway.serviceaccount" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s-%s" .Release.Name .Values.prefix "egressgateway-serviceaccount" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "egressgateway-serviceaccount" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*--------------------Common ROLE-------------------------------------------------------------------------------*/}}
{{- define "egressgateway.role" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-egressgateway-role
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}-egressgateway-role
{{- end -}}
{{- end -}}


{{/*--------------------Common ROLE BINDING----------------------------------------------------------------------*/}}
{{- define "egressgateway.rolebinding" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-egressgateway-rolebinding
{{- else -}}
{{ .Release.Name | trunc 63 | trimSuffix "-" -}}-egressgateway-rolebinding
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

{{/*------------------Ephemeral Storage-----------------------------------------------------------------------*/}}
{{- define "egress-gateway-ephemeral-storage-request" -}}
 {{- div (mul (add .Values.global.logStorage .Values.global.crictlStorage) 11) 10 -}}Mi
{{- end -}}

{{- define "egress-gateway-ephemeral-storage-limit" -}}
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
{{- else if .Values.serviceNameOverride -}}
{{- $name := .Values.serviceNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
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

{{/*--------------------Metric prefix------------------------------------------------------------*/}}
{{- define "metric.prefix" -}}
{{- if .Values.metricPrefix -}}
{{- .Values.metricPrefix -}}
{{- else if .Values.global.metricPrefix -}}
{{- .Values.global.metricPrefix -}}
{{- end -}}
{{- end -}}
{{/*--------------------Metric suffix------------------------------------------------------------*/}}
{{- define "metric.suffix" -}}
{{- if .Values.metricSuffix -}}
{{- .Values.metricSuffix -}}
{{- else if .Values.global.metricSuffix -}}
{{- .Values.global.metricSuffix -}}
{{- end -}}
{{- end -}}

{{/*--------------------NRF Client Service Name-------------------------------------------------------------*/}}
{{- define "service.nrfClientServiceFullName" -}}
{{- if .Values.oauthClient.nrfClientConfig.serviceName -}}
{{- $name := .Values.oauthClient.nrfClientConfig.serviceName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.oauthClient.nrfClientConfig.host | trunc 63 | trimSuffix "-" -}}
{{- end -}}
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
{{- define "service.egw.CoherenceSvcFullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s-%s" .Release.Name .Values.prefix "egw-cache" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "egw-cache" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*-------------------- Persistent configuration --------------------------------------------------------------------*/}}
{{- define "defaultconfig-egw.labels" -}}
{{- $loggingJson := tpl ( .Files.Get "config/logging.json" ) . }}
logging:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "logging" .Values.nfSpecificConfig.featureList) ($loggingJson) }}
{{ $loggingJson | indent 2 }}
{{- else }}
  appLogLevel: {{ .Values.log.level.egress }}
  packageLogLevel:
  - packageName: root
    logLevelForPackage: {{ .Values.log.level.root }}
  - packageName: oauth
    logLevelForPackage: {{ .Values.log.level.oauth }}
{{- end }}
{{- else }}
  appLogLevel: {{ .Values.log.level.egress }}
  packageLogLevel:
  - packageName: root
    logLevelForPackage: {{ .Values.log.level.root }}
  - packageName: oauth
    logLevelForPackage: {{ .Values.log.level.oauth }}
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

{{- $retryprofileJson := tpl ( .Files.Get "config/retryprofileJson" ) . }}
retryprofile:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "retryprofile" .Values.nfSpecificConfig.featureList) ($retryprofileJson) }}
{{ $retryprofileJson | indent 2 }}
{{- else }}
{{- if  .Values.defaultRouteRetryProfile }}
  retryCount: {{ .Values.defaultRetryProfile.retryCount }}
  requestTimeout: {{ .Values.defaultRetryProfile.requestTimeout }}
  statuses:
  {{- range .Values.defaultRetryProfile.statuses }}
    - {{.}}
  {{- end }}
  exceptions:
    {{- range .Values.defaultRetryProfile.exceptions }}
      - {{.}}
    {{- end }}
{{- else }}
  retryCount: 3
  requestTimeout: 3000
  statuses: ["4xx","5xx"]
  exceptions: ["java.net.ConnectException"]
{{- end }}
{{- end }}
{{- else }}
{{- if  .Values.defaultRouteRetryProfile }}
  retryCount: {{ .Values.defaultRetryProfile.retryCount }}
  requestTimeout: {{ .Values.defaultRetryProfile.requestTimeout }}
  statuses:
  {{- range .Values.defaultRetryProfile.statuses }}
    - {{.}}
  {{- end }}
  exceptions:
    {{- range .Values.defaultRetryProfile.exceptions }}
      - {{.}}
    {{- end }}
{{- else }}
  retryCount: 3
  requestTimeout: 3000
  statuses: ["4xx","5xx"]
  exceptions: ["java.net.ConnectException"]
{{- end }}
{{- end }}
{{- $forwardHeaderDetailsJson := tpl ( .Files.Get "config/forwardheaderdetails.json" ) . }}
forwardheaderdetails:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "forwardheaderdetails" .Values.nfSpecificConfig.featureList) ($forwardHeaderDetailsJson) }}
{{ $forwardHeaderDetailsJson | indent 2 }}
{{- else }}
  enabled: false
  forwardHeaderValue: ""
{{- end }}
{{- else }}
  enabled: false
  forwardHeaderValue: ""
{{- end }}
{{- $serverheaderJson := tpl ( .Files.Get "config/serverheader.json" ) . }}
serverheader:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "serverheader" .Values.nfSpecificConfig.featureList) ($serverheaderJson) }}
{{ $serverheaderJson | indent 2 }}
{{- else }}
  autoBlackListProxy:
    enabled: false
{{- end }}
{{- else }}
  autoBlackListProxy:
    enabled: false
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
{{- $peerConfigurationJson := tpl ( .Files.Get "config/peerconfiguration.json" ) . }}
peerconfiguration:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.sbiRouting.peerConfiguration) }}
  {{- range .Values.sbiRouting.peerConfiguration }}
    - id: {{ .id }}
    {{- if .host }}
      host: {{ .host }}
    {{- end }}
    {{- if .virtualHost }}
      virtualHost: {{ .virtualHost }}
    {{- end }}
    {{- if .port }}
      port: {{ .port | quote }}
    {{- end }}
    {{- if .apiPrefix }}
      apiPrefix: {{ .apiPrefix }}
    {{- end }}
    {{- if .healthApiPath }}
      healthApiPath: {{ .healthApiPath }}
    {{- end }}
  {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "peerconfiguration" .Values.nfSpecificConfig.featureList) ($peerConfigurationJson) }}
{{ $peerConfigurationJson | indent 2 }}
{{- end }}
{{- end }}
{{- end }}
{{- $peerSetConfigurationJson := tpl ( .Files.Get "config/peersetconfiguration.json" ) . }}
peersetconfiguration:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.sbiRouting.peerSetConfiguration) }}
  {{- range .Values.sbiRouting.peerSetConfiguration }}
    - id: {{ .id }}
    {{- if .httpConfiguration }}
      httpConfiguration:
      {{- range .httpConfiguration }}
        - priority: {{ .priority }}
          peerIdentifier: {{ .peerIdentifier }}
      {{- end }}
    {{- end }}
    {{- if .httpsConfiguration }}
      httpsConfiguration:
      {{- range .httpsConfiguration }}
        - priority: {{ .priority }}
          peerIdentifier: {{ .peerIdentifier }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "peersetconfiguration" .Values.nfSpecificConfig.featureList) ($peerSetConfigurationJson) }}
{{ $peerSetConfigurationJson | indent 2 }}
{{- end }}
{{- end }}
{{- end }}
{{- $sbiRoutingErrorCriteriaSetJson := tpl ( .Files.Get "config/sbiRoutingErrorCriteriaSets.json" ) . }}
sbiroutingerrorcriteriasets:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.sbiRoutingErrorCriteriaSets) }}
 {{- range .Values.sbiRoutingErrorCriteriaSets }}
 - id: {{ .id}}
   method:
   {{- range .method }}
   - {{ . }}
   {{- end }}
   {{- if .response }}
   response:
    statuses:
    {{- range .response.statuses }}
     - statusSeries: {{ .statusSeries }}
       status:
       {{- range .status }}
       - {{ . }}
       {{- end }}
    {{- end }}
    {{- if .response.headersMatchingScript }}
    headersMatchingScript: {{ .response.headersMatchingScript }}
    {{- end }}
   {{- end }}
   {{- if .exceptions }}
   exceptions:
   {{- range .exceptions }}
    - {{ . }}
   {{- end }}
   {{- end }}
 {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "sbiroutingerrorcriteriasets" .Values.nfSpecificConfig.featureList) ($sbiRoutingErrorCriteriaSetJson) }}
{{ $sbiRoutingErrorCriteriaSetJson | indent 2 }}
{{- end }}
{{- end }}
{{- end }}
{{- $sbiRoutingErrorActionSetsJson := tpl ( .Files.Get "config/sbiRoutingErrorActionSets.json" ) . }}
sbiroutingerroractionsets:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.sbiRoutingErrorActionSets) }}
 {{- range .Values.sbiRoutingErrorActionSets }}
 - id: {{ .id }}
   action: {{ .action }}
   attempts: {{ .attempts }}
   {{- if .blackList }}
   blackList:
    enabled: {{ .blackList.enabled }}
    duration: {{ .blackList.duration }}
   {{- end }}
 {{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "sbiroutingerroractionsets" .Values.nfSpecificConfig.featureList) ($sbiRoutingErrorActionSetsJson) }}
{{ $sbiRoutingErrorActionSetsJson | indent 2 }}
{{- end }}
{{- end }}
{{- end }}

{{- $peerMonitoringConfigurationJson := tpl ( .Files.Get "config/peermonitoringconfiguration.json" ) . }}
peermonitoringconfiguration:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "peermonitoringconfiguration" .Values.nfSpecificConfig.featureList) ($peerMonitoringConfigurationJson) }}
{{ $peerMonitoringConfigurationJson | indent 2 }}
{{- else }}
{{- if .Values.sbiRouting.peerMonitoringConfiguration }}
  enabled: {{ .Values.sbiRouting.peerMonitoringConfiguration.enabled }}
  timeout: {{ .Values.sbiRouting.peerMonitoringConfiguration.timeout }}
  frequency: {{ .Values.sbiRouting.peerMonitoringConfiguration.frequency }}
  failureThreshold: {{ .Values.sbiRouting.peerMonitoringConfiguration.failureThreshold }}
  successThreshold: {{ .Values.sbiRouting.peerMonitoringConfiguration.successThreshold }}
{{- end }}
{{- end }}
{{- else }}
{{- if .Values.sbiRouting.peerMonitoringConfiguration }}
  enabled: {{ .Values.sbiRouting.peerMonitoringConfiguration.enabled }}
  timeout: {{ .Values.sbiRouting.peerMonitoringConfiguration.timeout }}
  frequency: {{ .Values.sbiRouting.peerMonitoringConfiguration.frequency }}
  failureThreshold: {{ .Values.sbiRouting.peerMonitoringConfiguration.failureThreshold }}
  successThreshold: {{ .Values.sbiRouting.peerMonitoringConfiguration.successThreshold }}
{{- end }}
{{- end }}

{{- $controlledShutdownErrorMappingJson := tpl ( .Files.Get "config/controlledshutdownerrormapping.json" ) . }}
controlledshutdownerrormapping:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "controlledshutdownerrormapping" .Values.nfSpecificConfig.featureList) ($controlledShutdownErrorMappingJson) }}
{{ $controlledShutdownErrorMappingJson | indent 2 }}
{{- else }}
  routeErrorProfileList: []
{{- end }}
{{- else }}
  routeErrorProfileList: []
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
  - id: egress_route_proxy
    order: 100
    uri: egress://request.uri
    predicates:
      - args:
          pattern: /**
        name: Path
    filters:
      - name: DefaultRouteRetry
{{- if .Values.subLog.enabled }}
  - id: sub_act_log
    order: 99
    uri: egress://request.uri
    predicates:
      - args:
          pattern: /**
        name: Path
      - args:
          enable: true
        name: ReadBodyForLog
    filters:
      - name: SubActLog
{{- end }}
{{- range .Values.routesConfig }}
{{- if .filterName1 }}
  - id: {{ .id }}
    order: {{ .order }}
    uri: {{ tpl ( .uri ) $ }}
    predicates:
      {{- if .path }}
        - args:
            pattern: {{ .path }}
          name: Path
      {{- end }}
      {{- if .header }}
        - args:
            name: {{ trim (split "," .header)._0 }}
            regexp: {{ trim (split "," .header)._1 }}
          name: Header
      {{- end }}
      {{- if $.Values.subLog.enabled }}
        - args:
            enable: true
          name: ReadBodyForLog
      {{- end }}
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
      {{- if .metadata.httpRuriOnly }}
        httpRuriOnly: {{ .metadata.httpRuriOnly }}
      {{- end }}
      {{- if eq (toString .metadata.httpRuriOnly) "false" }}
        httpRuriOnly: {{ .metadata.httpRuriOnly }}
      {{- end }}
      {{- if .metadata.httpsTargetOnly }}
        httpsTargetOnly: {{ .metadata.httpsTargetOnly }}
      {{- end }}
      {{- if eq (toString .metadata.httpsTargetOnly) "false" }}
        httpsTargetOnly: {{ .metadata.httpsTargetOnly }}
      {{- end }}
      {{- if .metadata.sbiRoutingEnabled }}
        sbiRoutingEnabled: {{ .metadata.sbiRoutingEnabled }}
      {{- end }}
      {{- if eq (toString .metadata.sbiRoutingEnabled) "false" }}
        sbiRoutingEnabled: {{ .metadata.sbiRoutingEnabled }}
      {{- end }}
      {{- if .metadata.sbiRoutingWeightBasedEnabled }}
        sbiRoutingWeightBasedEnabled: {{ .metadata.sbiRoutingWeightBasedEnabled }}
      {{- end }}
      {{- if eq (toString .metadata.sbiRoutingWeightBasedEnabled) "false" }}
        sbiRoutingWeightBasedEnabled: {{ .metadata.sbiRoutingWeightBasedEnabled }}
      {{- end }}
    {{- end }}
    {{- if or .filterName1 $.Values.subLog.enabled}}
    filters:
    {{- if .filterNameReqEntry }}
      - name: CustomReqHeaderEntryFilter
        args:
          {{- if .filterNameReqEntry.args.headers }}
          headers:
            {{- range .filterNameReqEntry.args.headers }}
            - methods:
                {{- range .methods }}
                - {{ . }}
                {{- end }}
              headersList:
                {{- range .headersList }}
                - headerName: {{ .headerName }}
                  defaultVal: {{ .defaultVal }}
                  source: {{ .source }}
                  sourceHeader: {{ .sourceHeader }}
                  {{- if .override }}
                  override: {{ .override }}
                  {{- else }}
                  override: false
                  {{- end }}
                {{- end }}
            {{- end }}
          {{- end }}
    {{- end }}
    {{- if .filterNameReqExit }}
      - name: CustomReqHeaderExitFilter
        args:
          {{- if .filterNameReqExit.args.headers }}
          headers:
            {{- range .filterNameReqExit.args.headers }}
            - methods:
                {{- range .methods }}
                - {{ . }}
                {{- end }}
              headersList:
                {{- range .headersList }}
                - headerName: {{ .headerName }}
                  defaultVal: {{ .defaultVal }}
                  source: {{ .source }}
                  sourceHeader: {{ .sourceHeader }}
                  {{- if .override }}
                  override: {{ .override }}
                  {{- else }}
                  override: false
                  {{- end }}
                {{- end }}
            {{- end }}
          {{- end }}
    {{- end }}
    {{- if.filterNameResEntry }}
      - name: CustomResHeaderEntryFilter
        args:
          {{- if .filterNameResEntry.args.headers }}
          headers:
            {{- range .filterNameResEntry.args.headers }}
            - methods:
                {{- range .methods }}
                - {{ . }}
                {{- end }}
              headersList:
                {{- range .headersList }}
                - headerName: {{ .headerName }}
                  defaultVal: {{ .defaultVal }}
                  source: {{ .source }}
                  sourceHeader: {{ .sourceHeader }}
                  {{- if .override }}
                  override: {{ .override }}
                  {{- else }}
                  override: false
                  {{- end }}
                {{- end }}
            {{- end }}
          {{- end }}
    {{- end }}
    {{- if.filterNameResExit }}
      - name: CustomResHeaderExitFilter
        args:
          {{- if .filterNameResExit.args.headers }}
          headers:
            {{- range .filterNameResExit.args.headers }}
            - methods:
                {{- range .methods }}
                - {{ . }}
                {{- end }}
              headersList:
                {{- range .headersList }}
                - headerName: {{ .headerName }}
                  defaultVal: {{ .defaultVal }}
                  source: {{ .source }}
                  sourceHeader: {{ .sourceHeader }}
                  {{- if .override }}
                  override: {{ .override }}
                  {{- else }}
                  override: false
                  {{- end }}
                {{- end }}
            {{- end }}
          {{- end }}
    {{- end }}

{{/*--------------------Start of New SBI Routing Configuration----------------------------------------------------------------------------*/}}
    {{- if .filterName1 }}
      - name: {{ .filterName1.name }}
        args:
    {{- if .filterName1.args }}
    {{- if .filterName1.args.peerSetIdentifier }}
           peerSetIdentifier: {{ .filterName1.args.peerSetIdentifier }}
    {{- end }}
    {{- if .filterName1.args.customPeerSelectorEnabled }}
           customPeerSelectorEnabled: {{ .filterName1.args.customPeerSelectorEnabled }}
    {{- else }}
           customPeerSelectorEnabled: false
    {{- end }}
           errorHandling:
    {{- if .filterName1.args.errorHandling }}
     {{- range .filterName1.args.errorHandling }}
            - errorCriteriaSet: {{ .errorCriteriaSet }}
              actionSet: {{ .actionSet }}
              priority: {{ .priority }}
     {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}

{{/*--------------------End of New SBI Routing Configuration----------------------------------------------------------------------------*/}}

    {{- if $.Values.subLog.enabled }}
      - name: SubActLog
    {{- end}}
    {{- if .removeRequestHeader }}
      - name: RemoveRequestHeader
        args:
        {{- range .removeRequestHeader }}
          - name: {{ .name }}
        {{- end }}
    {{- end }}
    {{- if .removeResponseHeader }}
      - name: RemoveResponseHeader
        args:
        {{- range .removeResponseHeader }}
          - name: {{ .name }}
        {{- end }}
    {{- end }}
    {{ else }}
    {{- if or .removeRequestHeader .removeResponseHeader $.Values.subLog.enabled}}
    {{- if $.Values.subLog.enabled }}
      - name: SubActLog
    {{- end}}
    {{- if .removeRequestHeader }}
       - name: RemoveRequestHeader
         args:
         {{- range .removeRequestHeader }}
           - name: {{ .name }}
         {{- end }}
    {{- end }}
    {{- if .removeResponseHeader }}
      - name: RemoveResponseHeader
        args:
        {{- range .removeResponseHeader }}
          - name: {{ .name }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{ else }}
  - id: {{ .id }}
    order: {{ .order }}
    uri: egress://request.uri
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
  {{- if .metadata.httpRuriOnly }}
      httpRuriOnly: {{ .metadata.httpRuriOnly }}
  {{- end }}
  {{- if eq (toString .metadata.httpRuriOnly) "false" }}
      httpRuriOnly: {{ .metadata.httpRuriOnly }}
  {{- end }}
  {{- if .metadata.httpsTargetOnly }}
      httpsTargetOnly: {{ .metadata.httpsTargetOnly }}
  {{- end }}
  {{- if eq (toString .metadata.httpsTargetOnly) "false" }}
      httpsTargetOnly: {{ .metadata.httpsTargetOnly }}
  {{- end }}
  {{- end }}
    predicates:
      - args:
          pattern: {{ .path }}
        name: Path
  {{- if $.Values.subLog.enabled }}
      - args:
          enable: true
        name: ReadBodyForLog
  {{- end }}
  {{- if or .removeRequestHeader .removeResponseHeader $.Values.subLog.enabled}}
    filters:
  {{- if $.Values.subLog.enabled }}
      - name: SubActLog
  {{- end}}
  {{- if .removeRequestHeader }}
    - name: RemoveRequestHeader
      args:
      {{- range .removeRequestHeader }}
        - name: {{ .name }}
      {{- end }}
  {{- end }}
  {{- if .removeResponseHeader }}
    - name: RemoveResponseHeader
      args:
      {{- range .removeResponseHeader }}
        - name: {{ .name }}
      {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "routesconfiguration" .Values.nfSpecificConfig.featureList) ($routesConfigurationJson) }}
{{ $routesConfigurationJson | indent 2 }}
{{- else }}
{{- if and ($.Values.configureDefaultRoute) (eq ($.Values.routeConfigMode) "REST")}}
  - id: default_route
    order: 100
    uri: egress://request.uri
    predicates:
      - name: Path
        args:
          pattern: /**
    filters:
      - name: DefaultRouteRetry

{{- end }}
{{- end }}
{{- else }}
{{- if and ($.Values.configureDefaultRoute) (eq ($.Values.routeConfigMode) "REST")}}
  - id: default_route
    order: 100
    uri: egress://request.uri
    predicates:
      - name: Path
        args:
          pattern: /**
    filters:
      - name: DefaultRouteRetry
{{- end }}
{{- end }}
{{- $userAgentHeader := tpl ( .Files.Get "config/useragentheader.json" ) . }}
useragentheader:
{{- if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.enabled) (.Values.userAgentHeader) }}
  enabled: {{ .Values.userAgentHeader.enabled }}
  overwriteHeader: false
  nfType: ""
  nfInstanceId: ""
  addFqdnToHeader: false
  nfFqdn: ""
{{- else if .Values.nfSpecificConfig }}
{{- if and (.Values.nfSpecificConfig.featureList) (has "useragentheader" .Values.nfSpecificConfig.featureList) ($userAgentHeader) }}
{{ $userAgentHeader | indent 2 }}
{{- else }}
  enabled: false
  overwriteHeader: false
  nfType: ""
  nfInstanceId: ""
  addFqdnToHeader: false
  nfFqdn: ""
{{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{/*----------INIT CONTAINER ENABLE CHECK-------------*/}}
{{- define "initcontainer.enabled" -}}
 {{- if or .Values.initssl (and .Values.messageCopy.enabled .Values.messageCopy.security.enabled) -}}
  {{- printf "true" -}}
 {{- else -}}
  {{- printf "false" -}}
 {{- end -}}
{{- end -}}

{{/*--------------------Hook ConfigMap Name----------------------------------------------------------------------------*/}}
{{- define "hook-configmap.egw.fullname" -}}
{{- if $.Values.prefix -}}
{{- printf "%s-%s" .Release.Name .Values.prefix | trunc 63 | trimSuffix "-" -}}-hook-configmap-egw
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}-hook-configmap-egw
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
{{- printf "%s-%s" (include "service.fullname" .) "post-rollback" | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}

{{/*--------------------Expand the name of the post-rollback container.--------------------------------*/}}
{{- define "post-rollback-job.container.fullname" -}}
{{- $prefix := default "" .Values.global.k8sResource.container.prefix | lower -}}
{{- $suffix := default "" .Values.global.k8sResource.container.suffix | lower -}}
{{- printf "%s-%s-%s-%s" $prefix (include "service.fullname" .) "post-rollback" $suffix | trunc 63 | trimPrefix "-"|trimSuffix "-" -}}
{{- end -}}


{{/*--------------------Deployment Name---------------------------------------------------------------------------*/}}
{{- define "deployment.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.deploymentNameOverride -}}
{{- $name := .Values.deploymentNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
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

{{/*--------------------Egress Gateway port --------------------------------------------------------------*/}}
{{- define "egressgateway.port" -}}
{{ .Values.serviceEgressGateway.port | default 8080 }}
{{- end -}}

{{/*--------------------Egress Gateway HTTPS port --------------------------------------------------------*/}}
{{- define "egressgateway.sslPort" -}}
{{ .Values.serviceEgressGateway.sslPort | default 8442 }}
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



{{/*--------------------Engineering Labels common for all microservices--------------------------------------------*/}}
{{- define "engineering.labels" -}}
app.kubernetes.io/name: {{ template "chart.fullname" . }}
helm.sh/chart: {{ template "chart.fullnameandversion" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/part-of: ocegress-gateway
app.kubernetes.io/vendor: {{ .Values.global.vendor }}
app.kubernetes.io/mktgVersion: {{ .Chart.AppVersion }}
app.kubernetes.io/engVersion: {{ .Chart.Version }}
app.kubernetes.io/application: {{ .Values.global.app_name }}
app.kubernetes.io/microservice: ocingress-gateway
{{- end -}}

{{/*--------------------Engineering Annotations common for all microservices---------------------------------------*/}}
{{- define "engineering.annotations" -}}
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
  {{- $result := merge  $result $deployment_specific_annotations }}
  {{- $result := merge  $result $global_lbDeployment_annotations }}
  {{- $result := merge  $result $global_allResources_annotations }}
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

{{/*--------------------------------------Debug Tool Container--------------------------------------*/}}
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
{{- define "egw-extraContainersVolume" -}}
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