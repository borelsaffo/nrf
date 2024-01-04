#!/bin/bash
#
#  OCNRF Scenario Testing test suite
#  OCNRF release supported - 1.10.0
#
#  Revision : 1.2
#  For any issues, please Email kawal.sapra@oracle.com
#

localSudo='sudo'

if [[ $EUID -eq 0 ]]
then
    # If we are already root, don't sudo.
    # You'll get "root is not in the sudoers file.  This incident will be reported."
    localSudo=''
fi

# Commands
readonly logPath="/tmp"
readonly logDir="$logPath/OCNRFScenarioTestLogs"
readonly logFilePath="$logDir/ocnrfScenarioTestResults.log"
readonly echo_cmd="$localSudo echo"
readonly touch_cmd_local="$localSudo touch"
readonly mv_cmd="$localSudo mv"
readonly mkdir_cmd="$localSudo mkdir"
readonly chmod_cmd="$localSudo chmod"


#Global Variables
timestamp=`date +"%s"`
kubectlCommandValue="kubectl"
getPod=""
kubeCommand=""
executiveSummary="Executive Summary of results:- \n"
k8NamespaceValue="ocnrf"
contentTypeHeader="Content-Type:"
applicationJson="application/json"
patchJson="application/json-patch+json"
formUrlEncoded="application/x-www-form-urlencoded"
configEndPoint=""
nfRegisterUri=""
nfRegisterPayload=""
nfHeartBeatURI=""
nfHeartBeatPayload=""
signalingEndPoint=""
signalingIP=""
signalingPort=""
nfListRetrivalURI=""
nfSubscribeUri=""
nfSubscribePayload=""
nfProfileRetrivalURI=""
nfAccessTokenSigningPayload=""
nfDiscoveryURI=""
nfPartialUpdateURI=""
nfPartialUpdatePayload=""
nfAccessTokenURI=""
nfAccessTokenPayload=""
nfAccessTokenRegisterPayload=""
nfAccessTokenRegisterURI=""
nfHeartBeatPayloadWithLoadChange=""
subscriptionId=""
nfUnSubscribeUri=""
profileFromList=""
nfConfigurationURI=""
nfConfigurationUpdatePayload=""
checkDeploymentValue="false"
subscriptionExpiry=`date -d "+1 hour" -u +"%Y-%m-%dT%H:%M:%SZ"`

function setupLogging()
{
    $echo_cmd " "
    $echo_cmd "Preparing log directory ..."
    $echo_cmd " "

    # Check log directory exists or not 
    if [ -d "$logDir" ];
    then
        $echo_cmd "Log directory $logDir already created. Taking backup of log directory... "
        $echo_cmd " "
        $echo_cmd "CAUTION:- Backup directories are getting created in $logPath." 
        $echo_cmd "          Please do cleanup of obsolete directories as per need."
        $echo_cmd " "

        # Taking the backup of log directory
        $mv_cmd $logDir $logDir.$timestamp
        if [ $? -eq 0 ]; then
            $echo_cmd "Successfully backup taken of log directory to $logDir.$timestamp"
        else
            $echo_cmd "Failed to take backup of log directory $logDir."
            exit
        fi
    fi

    $echo_cmd "Creating log directory..."

    $mkdir_cmd -p $logDir
    if [ $? -eq 0 ]; then
        # After creating directory create log file and provide it permission.
        $touch_cmd_local $logFilePath
        $chmod_cmd a+rwx $logDir
        $chmod_cmd a+rw $logFilePath
        $echo_cmd "Log directory successfully created."  > $logFilePath
        printInfo "Logging is started in $logFilePath"
    else
        $echo_cmd "Failed to create log directory."
        exit
    fi
    
    $echo_cmd "Preparation of log directory done."
}

function populateData 
{
    #getPod=`$kubectlCommandValue -n $k8NamespaceValue  get pods  | grep -i end | cut -d ' ' -f 1 | head -1`
    #kubeCommand="$kubectlCommandValue -n $k8NamespaceValue exec $getPod -c ambassador"
    
    nfConfigurationURI="http://$configEndPoint/nrf-configuration/v1/"
    nfGeneralConfigurationURI="http://$configEndPoint/nrf-configuration/v1/generalOptions"
    nfGeneralConfigurationUpdatePayload="{\"nrfPlmnList\":[{\"mcc\":\"310\",\"mnc\":\"14\"}],\"ocnrfHost\":\"$signalingIP\",\"ocnrfPort\":$signalingPort}"
    
    nfAccessTokenConfigurationURI="http://$configEndPoint/nrf-configuration/v1/nfAccessTokenOptions"
    ocnrfConfigurationStatusURI="http://$configEndPoint/nrf-status-data/v1/accessTokenSigningDataStatus"
    ocnrfstateDataQuery1URI="http://$configEndPoint/nrf-state-data/v1/nf-details"
    ocnrfstateDataQuery2URI="http://$configEndPoint/nrf-state-data/v1/nf-details?nf-instance-id=6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c"
    ocnrfstateDataQuery3URI="http://$configEndPoint/nrf-state-data/v1/nf-details?nf-instance-id=6faf1bbc-6e4a-4454-a507-a14ef8e1bc5a"
    ocnrfstateDataQuery4URI="http://$configEndPoint/nrf-state-data/v1/nf-details?nf-instance-id=6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c&result-attributes=nfStatus"
    ocnrfstateDataQuery5URI="http://$configEndPoint/nrf-state-data/v1/nf-details?nf-instance-id=6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c&result-attributes=fqdn,status"
    ocnrfstateDataQuery6URI="http://$configEndPoint/nrf-state-data/v1/nf-details?nf-instance-id=6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c&result-attributes=fqdn,nfStatus"
    ocnrfstateDataQuery7URI="http://$configEndPoint/nrf-state-data/v1/subscription-details?result-attributes=reqNfFqdn,reqNfType,nfStatusNotificationUri"


    nfAccessTokenSigningPayload="{\"tokenSigningDetails\":{\"keyDetailsList\":[{\"keyID\":\"OCNRF-Key-01\",\"algorithm\":\"ES256\",\"privateKey\":{\"k8SecretName\":\"ocnrfaccesstoken-secret\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_private_key.pem\"},\"certificate\":{\"k8SecretName\":\"ocnrfaccesstoken-secret\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_certificate.crt\"}}]}}"
    
    nfAccessTokenSigningCurrentKeyIdPayload="{\"tokenSigningDetails\":{\"currentKeyID\":\"OCNRF-Key-01\",\"addkeyIDInAccessToken\":false}}"
    nfAccessTokenSigningCurrentKeyIdAndAddKeyIdPayload="{\"tokenSigningDetails\":{\"currentKeyID\":\"OCNRF-Key-01\",\"addkeyIDInAccessToken\":true}}"

    nfAccessTokenSigningBadPayload="{\"tokenSigningDetails\":{\"keyDetailsList\":[{\"keyID\":\"OCNRF-Key-01\",\"algorithm\":\"ES256\",\"privateKey\":{\"k8SecretName\":\"ocnrfaccesstoken-secret\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_private_key.pem\"},\"certificate\":{\"k8SecretName\":\"ocnrfaccesstoken-secret\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_certificate.crt\"}},{\"keyID\":\"OCNRF-Key-02\",\"algorithm\":\"ES256\",\"privateKey\":{\"k8SecretName\":\"ocnrfaccesstoken-secret-new\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_private_key.pem\"},\"certificate\":{\"k8SecretName\":\"ocnrfaccesstoken-secret\",\"k8SecretNameSpace\":\"ocnrf\",\"fileName\":\"ecdsa_certificate1.crt\"}}]}}"

    nfRegisterUri="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/13515195-c537-4645-9b97-96ec797fbbbf"
    nfRegisterPayload="{\"nfInstanceId\":\"13515195-c537-4645-9b97-96ec797fbbbf\",\"fqdn\":\"smf1.oracle.com\",\"nfType\":\"SMF\",\"plmnList\":[{\"mcc\":\"310\",\"mnc\":\"14\"}],\"nfStatus\":\"REGISTERED\",\"ipv4Addresses\":[\"172.23.45.53\"],\"capacity\":100,\"load\":10,\"smfInfo\":{\"sNssaiSmfInfoList\":[{\"sNssai\":{\"sst\":1,\"sd\":\"000001\"},\"dnnSmfInfoList\":[{\"dnn\":\"vision\"}]}],\"taiList\":[{\"plmnId\":{\"mcc\":\"450\",\"mnc\":\"05\"},\"tac\":\"004743\"}]},\"nfServices\":[{\"serviceInstanceId\":\"aaaa-bbbb-cccc-dddd\",\"serviceName\":\"nsmf-pdusession\",\"versions\":[{\"apiVersionInUri\":\"v1\",\"apiFullVersion\":\"1.1.0\",\"expiry\":\"2019-07-30T12:09:55.65Z\"}],\"scheme\":\"http\",\"nfServiceStatus\":\"REGISTERED\",\"ipEndPoints\":[{\"ipv4Address\":\"172.23.45.53\",\"transport\":\"TCP\",\"port\":80}],\"allowedPlmns\":[{\"mcc\":\"450\",\"mnc\":\"05\"}],\"allowedNfTypes\":[\"AMF\",\"PCF\"],\"allowedNssais\":[{\"sst\":1,\"sd\":\"000001\"}]},{\"serviceInstanceId\":\"bbbb-cccc-dddd-ffff\",\"serviceName\":\"nsmf-event-exposure\",\"versions\":[{\"apiVersionInUri\":\"v1\",\"apiFullVersion\":\"1.1.0\"}],\"scheme\":\"http\",\"nfServiceStatus\":\"REGISTERED\",\"ipEndPoints\":[{\"ipv4Address\":\"172.23.45.54\",\"transport\":\"TCP\",\"port\":80}],\"allowedPlmns\":[{\"mcc\":\"450\",\"mnc\":\"05\"}],\"allowedNfTypes\":[\"AMF\",\"NEF\"],\"allowedNssais\":[{\"sst\":1,\"sd\":\"000001\"}]}]}"
    
    
    nfSubscribeUri="http://$signalingEndPoint/nnrf-nfm/v1/subscriptions" 
    nfSubscribePayload="{\"nfStatusNotificationUri\":\"http://$signalingEndPoint/test\",\"subscrCond\":{\"nfType\":\"SMF\"},\"validityTime\":\"$subscriptionExpiry\"}"
    
    nfHeartBeatURI="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/13515195-c537-4645-9b97-96ec797fbbbf"
    nfHeartBeatPayload="[{\"op\":\"replace\",\"path\":\"/nfStatus\",\"value\":\"REGISTERED\"},{\"op\":\"replace\",\"path\":\"/load\",\"value\":10}]"
    nfHeartBeatPayloadWithLoadChange="[{\"op\":\"replace\",\"path\":\"/nfStatus\",\"value\":\"REGISTERED\"},{\"op\":\"replace\",\"path\":\"/load\",\"value\":50}]"
    
    nfPartialUpdateURI="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/13515195-c537-4645-9b97-96ec797fbbbf"
    nfPartialUpdatePayload="[{\"op\":\"replace\",\"path\":\"/load\",\"value\":10},{\"op\":\"replace\",\"path\":\"/capacity\",\"value\":50}]"
    
    nfListRetrivalURI="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/"
    nfProfileRetrivalURI="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/13515195-c537-4645-9b97-96ec797fbbbf"
    nfDiscoveryURI="http://$signalingEndPoint/nnrf-disc/v1/nf-instances?requester-nf-type=AMF&target-nf-type=SMF"

    nfAccessTokenURI="http://$signalingEndPoint/oauth2/token"
    nfAccessTokenPayload="grant_type=client_credentials&nfInstanceId=13515195-c537-4645-9b97-96ec797fbbbf&scope=namf-mt&nfType=SMF&targetNfType=AMF"
    nfAccessTokenRegisterPayload="{\"nfInstanceId\":\"6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c\",\"nfType\":\"AMF\",\"nfStatus\":\"REGISTERED\",\"plmnList\":[{\"mcc\":\"310\",\"mnc\":\"14\"}],\"sNssais\":[{\"sd\":\"4ebaaa\",\"sst\":124},{\"sd\":\"dc8aaa\",\"sst\":54},{\"sd\":\"f46aaa\",\"sst\":73}],\"nsiList\":[\"slice-1\",\"slice-2\"],\"fqdn\":\"AMF.d5g.oracle.com\",\"interPlmnFqdn\":\"AMF-d5g.oracle.com\",\"ipv4Addresses\":[\"192.168.2.100\",\"192.168.3.100\",\"192.168.2.110\",\"192.168.3.110\"],\"ipv6Addresses\":[\"2001:0db8:85a3:0000:0000:8a2e:0370:7334\"],\"capacity\":2000,\"load\":0,\"locality\":\"USEast\",\"amfInfo\":{\"amfSetId\":\"1ab\",\"amfRegionId\":\"23\",\"guamiList\":[{\"plmnId\":{\"mcc\":\"594\",\"mnc\":\"75\"},\"amfId\":\"947d18\"}],\"taiList\":[{\"plmnId\":{\"mcc\":\"641\",\"mnc\":\"72\"},\"tac\":\"ccc0\"}],\"backupInfoAmfFailure\":[{\"plmnId\":{\"mcc\":\"290\",\"mnc\":\"62\"},\"amfId\":\"742c11\"}],\"backupInfoAmfRemoval\":[{\"plmnId\":{\"mcc\":\"290\",\"mnc\":\"62\"},\"amfId\":\"742c11\"}],\"n2InterfaceAmfInfo\":{\"ipv4EndpointAddress\":[\"192.168.2.100\"],\"ipv6EndpointAddress\":[\"2001:db8:85a3::8a2e:370:7334\"],\"amfName\":\"amf1.cluster1.net2.amf.5gc.mnc012.mcc345.3gppnetwork.org\"}},\"nfServices\":[{\"serviceInstanceId\":\"fe137ab7-740a-46ee-aa5c-951806d77b0d\",\"serviceName\":\"namf-mt\",\"versions\":[{\"apiVersionInUri\":\"v1\",\"apiFullVersion\":\"1.0.0\",\"expiry\":\"2018-12-03T18:55:08.871+0000\"}],\"nfServiceStatus\":\"REGISTERED\",\"scheme\":\"http\",\"fqdn\":\"AMF.d5g.oracle.com\",\"interPlmnFqdn\":\"AMF-d5g.oracle.com\",\"apiPrefix\":\"\",\"defaultNotificationSubscriptions\":[{\"notificationType\":\"LOCATION_NOTIFICATION\",\"callbackUri\":\"http://somehost.oracle.com/callback-uri\"},{\"notificationType\":\"N1_MESSAGES\",\"callbackUri\":\"http://somehost.oracle.com/callback-uri\",\"n1MessageClass\":\"SM\"},{\"notificationType\":\"N2_INFORMATION\",\"callbackUri\":\"http://somehost.oracle.com/callback-uri\",\"n2InformationClass\":\"NRPPa\"}],\"allowedPlmns\":[{\"mcc\":\"904\",\"mnc\":\"47\"},{\"mcc\":\"743\",\"mnc\":\"47\"},{\"mcc\":\"222\",\"mnc\":\"23\"},{\"mcc\":\"521\",\"mnc\":\"11\"}],\"allowedNfTypes\":[\"NRF\",\"AMF\",\"AUSF\",\"BSF\",\"UDM\",\"UDR\",\"PCF\"],\"allowedNfDomains\":[\"oracle.com\",\"att.com\"],\"allowedNssais\":[{\"sd\":\"dbaaaa\",\"sst\":14},{\"sd\":\"3caaa9\",\"sst\":153},{\"sd\":\"5faaad\",\"sst\":132}],\"capacity\":500,\"load\":0,\"supportedFeatures\":\"80000000\"}]}"
    nfAccessTokenRegisterURI="http://$signalingEndPoint/nnrf-nfm/v1/nf-instances/6faf1bbc-6e4a-4454-a507-a14ef8e1bc5c"
}

function checkCNEEnvironment
{
   printInfo "Checking CNE Environment basic tools ...."   
   kubectlOutput=`$kubectlCommandValue version`

   if [[ ! $kubectlOutput =~ "Server" ]]
   then 
      printError "CNE Environment check failed. Halting execution here."
      exit 
   fi
   
   printInfo "CNE Environment basic tools verification passed."
}

function printInfo
{
    # Adding date with logs data
    $echo_cmd -e ""
    $echo_cmd -e "$@"
    $echo_cmd -e "$@" >> $logFilePath
    $echo_cmd -e "" >> $logFilePath
}

function printError
{
    # Adding date with logs data
    $echo_cmd -e ""
    $echo_cmd -e "\e[0;31m$@\e[0m"
    $echo_cmd -e "$@" >> $logFilePath
    $echo_cmd -e "" >> $logFilePath
}

function testServiceOperation
{
    serviceOperation=$1
    uri=$2
    expectedResultCode=$3
    payload=$4
    profile=$5

    httpMethod=""
    header=""
    caseTestSummary=""
    testCasePassed=":- Passed"
    testCaseFailed=":- Failed"

    clear
    printInfo "Test Scenario:- $1"
    printInfo "Service Operation:- $serviceOperation"
    printInfo "HTTP Method:- $httpMethod"
    printInfo "URI:- $uri"
    printInfo "PAYLOAD:- $payload"
    printInfo "Expected ResultCode:- $expectedResultCode"
    case $1 in 
        NFConfigurationRetrieval)
            printInfo "Retrieving Default System Options"
            httpMethod="GET"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            ;;
        NFConfigurationUpdate)
            printInfo "Configuring OCNRF preconditions"
            httpMethod="PUT"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            ;;
        NFOptionsRetrieval)
            printInfo "NF Options retrieval operation"
            httpMethod="OPTIONS"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            printInfo "Headers in OPTIONS response are as follows:-"
            printInfo ""
            response=`curl --http2-prior-knowledge -s -v -X $httpMethod "$uri"`
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            ;;
        NFRegister)
            printInfo "New registration scenario"
            httpMethod="PUT"
            header=$applicationJson
            caseTestSummary="Test case for $1 of $5 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            #echo $response | awk '{split($0, a, "RESPONSE-CODE:"); print a[2]}'
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
        NFSubscribe)
            printInfo "NF Subscribe - New Subscription"
            httpMethod="POST"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            subscriptionId=`awk -F 'subscriptionId":"' '{print $2}' $logFilePath | awk '{print $1}' | awk '{print $1}' | cut -d '"' -f 1 |xargs`
            nfUnSubscribeUri="http://$signalingEndPoint/nnrf-nfm/v1/subscriptions/$subscriptionId" 

            #echo $response | awk '{split($0, a, "RESPONSE-CODE:"); print a[2]}'
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
        NFUpdate)
            printInfo "Update exisiting registration scenario - Full replacement"
            httpMethod="PUT"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            #actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            ;;
        NFListRetrieval)
            printInfo "NF List retrieval operation"
            httpMethod="GET"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl --http2-prior-knowledge -s -X $httpMethod "$uri"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            profileFromList=`echo $response | awk '{split($0, a, ":"); print a[5]":"a[6]}' | cut -d '}' -f 1 | cut -d '"' -f 1`
            ;;
        NFProfileRetrieval)
            actualResultCode=100
            printInfo "NF Profile retrieval operation"
            httpMethod="GET"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            updatedURI=`echo http:$uri`
            echo $updatedURI
            response=`curl --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" $updatedURI`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            #actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            ;;
        NFHeartBeat)
            printInfo "NF Heartbeat"
            httpMethod="PATCH"
            header=$patchJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            ;;
        NFHeartBeatWithLoadChange)
            printInfo "NF Heartbeat with Load Change"
            httpMethod="PATCH"
            header=$patchJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
        NFUpdatePartial)
            printInfo "NF Update Partial"
            httpMethod="PATCH"
            header=$patchJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            echo $response | awk '{print $2}' | cut -d ':' -f 2
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
        NFDiscover)
            printInfo "NF Discover"
            httpMethod="GET"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is "
            response=`curl --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
	NFAccessToken)
            printInfo "NFAccessToken scenario"
            httpMethod="POST"
            header=$formUrlEncoded
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response
            actualResultCode=`echo $response | awk '{print $2}' | cut -d ':' -f 2`
            ;;
        NFUnSubscribe)
            printInfo "NF UnSubscribe"
            httpMethod="DELETE"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is "
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            ;;
        NFDeregister)
            printInfo "NF Deregister"
            httpMethod="DELETE"
            caseTestSummary="Test case for $1 of $5 with expected result code $expectedResultCode is "
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            ;;
        AccessTokenConfiguration)
            printInfo "Configuring Access Token"
            httpMethod="PUT"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
             ;;
        AccessTokenUpdateCurrentKeyId)
            printInfo "Configuring Access Token Current Key Id"
            httpMethod="PUT"
            header=$applicationJson
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is  "
            response=`curl  --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
            printInfo "Response:-"
            printInfo $response 
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri" -H "$contentTypeHeader $header"  -d "$payload"`
          ;;
        AccessTokenStatus)
            printInfo "Access Token Status"
            httpMethod="GET"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is "
            response=`curl --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri"`
            printInfo "Response:-"
            printInfo $response
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            curl --http2-prior-knowledge -s -X $httpMethod "$uri" |  python -mjson.tool
            ;;
        NrfStateData)
            printInfo "OCNRF State data"
            httpMethod="GET"
            caseTestSummary="Test case for $1 with expected result code $expectedResultCode is "
            response=`curl --http2-prior-knowledge -s -X $httpMethod -w " RESPONSE-CODE:%{http_code}" "$uri"`
            printInfo "Response:-"
            printInfo $response
            actualResultCode=`curl --http2-prior-knowledge -s -o /dev/null -w "%{http_code}" -X $httpMethod "$uri"`
            curl --http2-prior-knowledge -s -X $httpMethod "$uri" |  python -mjson.tool
            ;;
        *)
            printError "Not Supported Service Operation"
            ;;
    esac
    
    printInfo "Actual ResultCode:- $actualResultCode"

    if [  $expectedResultCode -eq $actualResultCode ] 
    then
       printInfo "Result  $testCasePassed"
       caseTestSummary="$caseTestSummary                 $testCasePassed"
    else
       printInfo "Result  $testCaseFailed"
       caseTestSummary="$caseTestSummary                 $testCaseFailed"
    fi
    executiveSummary="$executiveSummary $caseTestSummary \n"
}

function readNext
{
    $echo_cmd  ""
    $echo_cmd -n "Hit enter to continue."
    read
    clear
}

function displayUsage
{
    $echo_cmd ""
    $echo_cmd "OCNRF Scenario Testing Execution Suite"
    $echo_cmd ""
    $echo_cmd "Usage:"
    $echo_cmd ""
    $echo_cmd " $0 --signalingEndPoint=<OCNRF signalingEndPoint> --configEndPoint=<OCNRF configEndPort>"
    $echo_cmd ""
    $echo_cmd "Possible arguments:-"
    $echo_cmd "[Mandatory] --signalingEndPoint=<OCNRF signalingEndPoint> | -s=<OCNRF signalingEndPoint>"
    $echo_cmd "[Mandatory] --configEndPoint=<OCNRF configEndPoint> | -c=<OCNRF configEndPoint> "
    $echo_cmd ""
    $echo_cmd "Examples:-"
    $echo_cmd "./OCNRF_SCENARIO_TEST_TOOL.sh -s=10.75.203.88:31142 -c=10.75.224.241:30076"

}


function parseCmdLine()
{
    #
    # Check if user has provided valid arguments
    #
    printInfo "Parsing and verifying passed arguments ...."

    totalArgs=$#

    if [ $totalArgs -gt 5 ]
    then
        printError "Invalid arguments count. Maximum arguments can be 5."
        displayUsage
        exit
    fi

    if [ $totalArgs -lt 2 ]
    then
        printError "Invalid arguments count. Two mandatory arguments are needed."
        displayUsage
        exit
    fi

    counter=1
    while [[ $counter -le $totalArgs ]] ; do
        counter=$((counter+1))
        if [[ ! $1 =~ "=" ]]
        then
           printError "Bad arguments"
           displayUsage
           exit
        else
           argument=$1
           argumentKey=`echo $argument | cut -d '=' -f 1`
           if [ -z $argumentKey ]
           then
              printError "Invalid arguments"
              displayUsage
              exit
           fi
           argumentValue=`echo $argument | cut -d '=' -f 2`
           if [ -z $argumentValue ]
           then
              printError "Invalid arguments"
              displayUsage
              exit
           fi
        fi

        case $argumentKey in
            --k8Namespace | -k8Namespace | -n)
               k8NamespaceValue=$argumentValue
               ;;
            --kubectlCommand | -kubectlCommand | -k)
               kubectlCommandValue=$argumentValue
               ;;
            --checkDeployment | -checkDeployment | -d)
               if [ $argumentValue == "true" ] || [ $argumentValue == "false" ]
               then
                  checkDeploymentValue=$argumentValue
               else
                  printError "checkDeployment argument value should be either true or false"
                  displayUsage
                  exit
               fi
               ;;
            --signalingEndPoint | -signalingEndPoint | -s)
               if [ -z $signalingEndPoint ]
               then
                  signalingEndPoint=$argumentValue
                  signalingIP=${argumentValue%%:*}
                  argumentValue=${argumentValue#*:*}
                  signalingPort=${argumentValue%%:*}
               else
                  printError "OCNRF Signaling EndPoint option is present more than once. Invalid arguments"
                  displayUsage
                  exit
               fi
               ;;
            --configEndPoint | -configEndPoint | -c)
               if [ -z $configEndPoint ]
               then
                  configEndPoint=$argumentValue
               else
                  printError "OCNRF Config EndPoint option is present more than once. Invalid arguments"
                  displayUsage
                  exit
               fi
               ;;
            *)
             displayUsage
             exit
        esac
        shift
    done

    if [ -z $signalingEndPoint ]
    then
       printError "OCNRF Signaling EndPoint is a mandatory argument. Invalid arguments"
       displayUsage
       exit
    fi
    if [ -z $configEndPoint ]
    then
       printError "OCNRF Config EndPoint is a mandatory argument. Invalid arguments"
       displayUsage
       exit
    fi
    printInfo "Arguments passed are valid"
}

function checkDeployment
{
    local k8NamespaceValue=$1

    printInfo "Checking deployment"
    
    checkDeploy=`$kubectlCommandValue -n $k8NamespaceValue get svc  | grep -i end | cut -d ' ' -f 1 | head -1`

    if [ -z $checkDeploy ]
    then
       printError "Deployment not exist with '$k8NamespaceValue' namespace. Please try with correct name-space."
       displayUsage
       exit
    fi

    printInfo "Deployment Exists. Verifying if it doing good."

    ARR=$($kubectlCommandValue -n $k8NamespaceValue get pods |grep -Po "\d\/\d")
    COUNT=1
    for i in ${ARR[@]}; do
      COUNT=$(( COUNT * $(( ${i} )) ))
    done

    if [[ $COUNT < 1 ]]   
    then
       printError "Deployment is not proper. Some pods mayn't be UP."
       printInfo "Current State of deployment:-"   
       $kubectlCommandValue -n $k8NamespaceValue get pods
       exit
    else
       printInfo "Deployment is proper."
       printInfo "Current State of deployment:-"   
       $kubectlCommandValue -n $k8NamespaceValue get pods
    fi


    printInfo "Checking Image details"
    imageDetails=`$kubectlCommandValue get deployment -n $k8NamespaceValue -owide | grep -v IMAGES | awk '{print "Container "$6 " is using image: "$7}'`
    printInfo "$imageDetails"
}

function main
{
    clear
    # Setup the log directory
    setupLogging
    readNext

    # Parse the command line arguments
    printInfo "============= OCNRF Scenario Testing Pre-Checks  ==============="
    parseCmdLine $*
    readNext

    if [ $checkDeploymentValue = "true" ]
    then
       printInfo "============= OCNRF Scenario Testing Pre-Checks  ==============="
       checkCNEEnvironment
       readNext
    
       printInfo "============= OCNRF Scenario Testing Pre-Checks  ==============="
       checkDeployment $k8NamespaceValue
       readNext   
    fi
 

    populateData
   
    printInfo "============= OCNRF Scenario Testing Execution Started  ==============="
    printInfo "OCNRF Signaling EndPoint:- $signalingEndPoint"
    printInfo "OCNRF Config EndPoint:- $configEndPoint"
    readNext
    
    testServiceOperation NFConfigurationRetrieval $nfConfigurationURI 200 
    readNext
    
    testServiceOperation NFConfigurationUpdate  $nfGeneralConfigurationURI 200 "$nfGeneralConfigurationUpdatePayload"
    readNext
    
    testServiceOperation NFOptionsRetrieval  $nfListRetrivalURI 200
    readNext
    
    testServiceOperation NFRegister  $nfRegisterUri 201 $nfRegisterPayload profile1
    readNext
    
    testServiceOperation NFRegister  $nfAccessTokenRegisterURI 201 $nfAccessTokenRegisterPayload profile2
    readNext
   
    testServiceOperation NFSubscribe  $nfSubscribeUri 201 $nfSubscribePayload
    readNext
    
    testServiceOperation NFUpdate  $nfRegisterUri 200 $nfRegisterPayload
    readNext
    
    testServiceOperation NFListRetrieval  $nfListRetrivalURI 200
    readNext
    
    testServiceOperation NFProfileRetrieval  $profileFromList 200
    readNext
    
    testServiceOperation NFHeartBeat  $nfHeartBeatURI 204 $nfHeartBeatPayload
    readNext
    
    testServiceOperation NFUpdatePartial $nfPartialUpdateURI 200 $nfPartialUpdatePayload
    readNext
    
    testServiceOperation NFDiscover  $nfDiscoveryURI 200
    readNext
    
    testServiceOperation NFHeartBeatWithLoadChange $nfHeartBeatURI 200 $nfHeartBeatPayloadWithLoadChange
    readNext

    testServiceOperation AccessTokenConfiguration $nfAccessTokenConfigurationURI 200 $nfAccessTokenSigningPayload
    readNext

    testServiceOperation AccessTokenStatus $ocnrfConfigurationStatusURI 200
    readNext
    
    testServiceOperation AccessTokenUpdateCurrentKeyId $nfAccessTokenConfigurationURI 200 $nfAccessTokenSigningCurrentKeyIdPayload
    readNext

    testServiceOperation AccessTokenStatus $ocnrfConfigurationStatusURI 200
    readNext

    testServiceOperation NFAccessToken $nfAccessTokenURI 200 $nfAccessTokenPayload
    readNext
    
    testServiceOperation AccessTokenUpdateCurrentKeyId $nfAccessTokenConfigurationURI 200 $nfAccessTokenSigningCurrentKeyIdAndAddKeyIdPayload
    readNext
    
    testServiceOperation NFAccessToken $nfAccessTokenURI 200 $nfAccessTokenPayload
    readNext

    testServiceOperation AccessTokenConfiguration $nfAccessTokenConfigurationURI 200 $nfAccessTokenSigningBadPayload
    readNext
    
    testServiceOperation AccessTokenStatus $ocnrfConfigurationStatusURI 200
    readNext

   
    testServiceOperation NrfStateData $ocnrfstateDataQuery1URI 200
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery2URI 200
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery3URI 404
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery4URI 200
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery5URI 400
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery6URI 200
    readNext
    testServiceOperation NrfStateData $ocnrfstateDataQuery7URI 200
    readNext

    testServiceOperation NFDeregister $nfRegisterUri 204 empty profile1
    readNext

    testServiceOperation NFDeregister $nfAccessTokenRegisterURI 204 empty profile2
    readNext

    testServiceOperation NFUnSubscribe $nfUnSubscribeUri 204
    readNext

    printInfo $executiveSummary

    printInfo "Results and logs are available at $logFilePath"

    printInfo "============= OCNRF Scenario Testing Execution Completed  ==============="
    printInfo ""
}


main $*
