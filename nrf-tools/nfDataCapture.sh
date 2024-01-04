#!/bin/bash

# Copyright 2020 (C), Oracle and/or its affiliates. All rights reserved.

# Tool Version: 1.1.1
localSudo=''

# Constants for paths and file name
readonly DESCRIPTION_LOG_FILE='description.log'
readonly LOG_FILE_PATH="./nfDataCaptureToolLogs.`date +"%Y.%m.%d_%H.%M.%S"`.log"
readonly ECHO_CMD="$localSudo echo"
readonly GREP_CMD="$localSudo grep"
readonly TAR_CMD="$localSudo tar"
readonly SPLIT_CMD="$localSudo split"
readonly MKDIR_CMD="$localSudo mkdir"
readonly AWK_CMD="$localSudo awk"
readonly LS_CMD="$localSudo ls"
readonly POD_LOG_FILE='logs.log'
readonly LOG="log"
readonly HELM_DATA="HelmData"
readonly HELM_STATUS="HelmStatus"
readonly helm3true="true"
readonly helm3false="false"

# Set Global Variables
kubeValue=""
helmValue=""
sizeOfTar=""
k8Namespace=""
DEBUG_DATA_DIR=""
DEBUG_DATA_DIR_PATH=""
helmType3=""


function printUsage()
{
    $ECHO_CMD -e "  \n  Please try again with correct format:\n" | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e "  \n  Usage:\n" | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e "  ./nfDataCapture.sh -n|--k8Namespace=[K8 Namespace] -k|--kubectl=[KUBE_SCRIPT_NAME] -h|--helm=[HELM_SCRIPT_NAME]  -s|--size=[SIZE_OF_EACH_TARBALL] -o|--toolOutputPath -helm3=false \n\n" | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e "  Examples:="   | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e '  ./nfDataCapture.sh -k="kubectl --kubeconfig=admin.conf" -h="helm --kubeconfig admin.conf" -n=ocnrf -s=5M -o=/tmp/'  | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e '  ./nfDataCapture.sh -n=ocnrf -s=5M -o=/tmp/'  | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e '  ./nfDataCapture.sh -n=ocnrf'  | tee -a $LOG_FILE_PATH 
    $ECHO_CMD -e '  ./nfDataCapture.sh -n=ocnrf -helm3=true'  | tee -a $LOG_FILE_PATH 
    $ECHO_CMD 
    $ECHO_CMD -e '  Note:- Default size of tarball generated will be 10M, if not provided and default location of output will be tool working directory'  | tee -a $LOG_FILE_PATH
    $ECHO_CMD -e '  By default helm2 is used. Use proper argument in command to use helm3'  | tee -a $LOG_FILE_PATH 
    $ECHO_CMD 
    exit 1
}

function printInfo()
{
    # Adding date with logs data
    $ECHO_CMD -e "$@"
    $ECHO_CMD -e "$@" >> $LOG_FILE_PATH
    $ECHO_CMD -e "" >> $LOG_FILE_PATH
}

function convertBytes()
{
   number=$($ECHO_CMD "$sizeOfTar" | $GREP_CMD -o -E '[0-9]+')
   if [[ "$sizeOfTar" =~ ([. 0-9]+(KB)) ]]
    then
      sizeOfTar=$(($number*1000))
   elif [[ "$sizeOfTar" =~ ([. 0-9]+(K)) ]] 
   then
      sizeOfTar=$(($number*1024))
   elif [[ "$sizeOfTar" =~ ([. 0-9]+(MB)) ]] 
   then
      sizeOfTar=$(($number*1000*1000))
   elif [[ "$sizeOfTar" =~ ([. 0-9]+(M)) ]] 
   then
      sizeOfTar=$(($number*1024*1024))
   elif [[ "$sizeOfTar" =~ ([. 0-9]+(GB)) ]] 
   then
      sizeOfTar=$(($number*1000*1000*1000))
   elif [[ "$sizeOfTar" =~ ([. 0-9]+(G)) ]]
   then      
       sizeOfTar=$(($number*1024*1024*1024))
   else
       sizeOfTar=$number    
   fi      
}

function parseCmdLine()
{
    #
    # Check if user has provided valid arguments
    #
    printInfo -e "  Parsing and verifying passed arguments ...."

    isSizeTarBallValuePassed="false"
    totalArgs=$# 
    counter=1
    while [[ $counter -le $totalArgs ]] ; do
    counter=$((counter+1))
    if [[ ! $1 =~ "=" ]]
    then
       printInfo "  Invalid format of arguments. Correct format -- see below"
       printUsage
       exit
    else
       argument=$1  
       argumentKey=`$ECHO_CMD $argument | cut -d '=' -f 1`
       if [ -z $argumentKey ]
       then
          printInfo "  Invalid arguments"
          printUsage
          exit
       fi
       argumentValue=`$ECHO_CMD $argument | cut -d '=' -f 2`
       if [ -z $argumentValue ]
       then
          printInfo "  Invalid arguments"
          printUsage
          exit
       fi
    fi
    
    case $argumentKey in
       -k | --kubectl) 
           if [ -z $kubeValue ]
           then
              kubeValue="$localSudo $argumentValue"
           else
              printInfo "  kubectl tag  is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;; 
       -h | --helm) 
           if [ -z $helmValue ]
           then
              helmValue="$localSudo $argumentValue"
           else
              printInfo "  helm tag is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;; 
       -s | --size) 
           if [ -z $sizeOfTar ]
           then
              sizeOfTar=$argumentValue       
           else
              printInfo " sizeofTar tag is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;; 
       -n | --k8Namespace) 
           if [ -z $k8Namespace ]
           then
              k8Namespace=$argumentValue       
              DEBUG_DATA_DIR="$k8Namespace.debugData.`date +"%Y.%m.%d_%H.%M.%S"`"
           else
              printInfo " k8Namespace tag is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;;            
        -o | --toolOutputPath)
           if [ -z $DEBUG_DATA_DIR_PATH ]
           then
              DEBUG_DATA_DIR_PATH=$argumentValue       
           else
              printInfo " toolOutputPath tag is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;; 
        -helm3)
           if [ -z $helmType3 ]
           then
              helmType3=$argumentValue
           else
              printInfo " helm3 tag is present more than once. Invalid arguments"
              printUsage
              exit
           fi
           ;;
   
          *) 
           printInfo "  Invalid arguments. Please try again..."
           printUsage
           exit
    esac
    shift
    done
    
    if [ -z $sizeOfTar ]
    then
       isSizeTarBallValuePassed="false"
       sizeOfTar=1048576
    else
       isSizeTarBallValuePassed="true"
    fi

    if [ -z $k8Namespace ]
    then
       printInfo "  K8 Namespace is mandatory value. Invalid arguments"
       printUsage
       exit
    fi
    if [ -z $kubeValue ]
    then
      kubeValue=kubectl
    fi

    if [ -z $DEBUG_DATA_DIR_PATH ]
    then
      DEBUG_DATA_DIR_PATH="."
    fi

    if [ -z $helmType3 ]
    then
        helmType3=$helm3false
    else
        if [ $helmType3 != $helm3true -a  $helmType3 != $helm3false ]
        then
          printInfo "Invalid Helm3 value. It can be either true or false."
          exit
        fi
    fi
    if [ -z $helmValue  ]
    then
      if [ $helmType3 == "true" ]
      then
        helmValue=helm3
      else
        helmValue=helm
      fi
    fi
   
    DEBUG_DATA_DIR_WITH_PATH=$DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR
    printInfo 
    printInfo -e "  Values getting used:- "
    printInfo "  =============================="
    printInfo -e "  Kubectl command: $kubeValue"
    printInfo -e "  Helm command: $helmValue"
    printInfo -e "  K8 Namespace: $k8Namespace"  
    printInfo -e "  Output directory path: $DEBUG_DATA_DIR_PATH"  
    printInfo -e "  Helm3: $helmType3"  
    if [ $isSizeTarBallValuePassed == "true" ]; then
        printInfo -e "  Maximum size of each tarball: $sizeOfTar"  
    fi
}

function createDebugDataDir()
{
    # Create $DEBUG_DATA_DIR  directory
    $MKDIR_CMD $DEBUG_DATA_DIR_WITH_PATH
    if [ ! $? == 0 ]; then
        $ECHO_CMD -e "  Unable to create directory $DEBUG_DATA_DIR_WITH_PATH" | tee -a $LOG_FILE_PATH
        exit 1
    fi
}

function executeBussinessLogic()
{
    
    $helmValue version > /dev/null 2>&1
    if [ ! $? == 0 ]; then
        printInfo "  $helmValue does not exist or could not be found\n"  
        exit 1
    fi

    $kubeValue version > /dev/null 2>&1
    if [ ! $? == 0 ]; then
        printInfo -e "  $kubeValue does not exist or could not be found\n"  
        exit 1
    fi
    k8ResourceList=`$kubeValue get all -n $k8Namespace  | $GREP_CMD -v NAME |  $AWK_CMD '{ print $(1) }' | grep -v '^$'`

    while IFS= read -r k8ResourceElement; do
        resourceName=`$ECHO_CMD $k8ResourceElement  | $AWK_CMD -F'[/]' '{ print $(1) }' | $AWK_CMD -F'[.]' '{ print $(1) }'`
        resourceValue=`$ECHO_CMD $k8ResourceElement | $AWK_CMD -F'[/]' '{ print $(2) }'`
        printInfo -e "  Executing '$kubeValue describe $resourceName $resourceValue -n $k8Namespace'"  
        $kubeValue describe $resourceName $resourceValue -n $k8Namespace > $DEBUG_DATA_DIR_WITH_PATH/$resourceName-$resourceValue-$DESCRIPTION_LOG_FILE
        if [[ $resourceName == "pod" ]]; then
            containerCount=`$kubeValue get pods -n $k8Namespace | $GREP_CMD -i $resourceValue | $AWK_CMD '{print $2}' | cut -d '/' -f 2`

            initialContainerIndex=1
            containerNames=`$kubeValue get pods -n $k8Namespace -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.name}{", "}{end}{end}' |sort | $GREP_CMD -i $resourceValue | cut -d ':' -f 2`
            if [[ ! -z $containerNames ]]; then
                while [ $initialContainerIndex -le $containerCount ]; do
                     containerNameAtIndex=`$ECHO_CMD $containerNames | $AWK_CMD -v internalVar="$initialContainerIndex" '{print $internalVar}' | cut -d ',' -f 1`
                     if [ ! -z $containerNameAtIndex ]; then
                          printInfo -e "  Executing '$kubeValue logs $resourceValue -c $containerNameAtIndex -n $k8Namespace'"  
                          $kubeValue logs $resourceValue -c $containerNameAtIndex -n $k8Namespace >> $DEBUG_DATA_DIR_WITH_PATH/$resourceName-$resourceValue-$containerNameAtIndex-$POD_LOG_FILE 2>&1
                     fi
                     initialContainerIndex=`expr $initialContainerIndex + 1`
                done
            fi
         fi
    done <<< "$k8ResourceList"   
   
    printInfo -e "  Executing '$kubeValue get events -n $k8Namespace'"
    $kubeValue get events -n $k8Namespace >> $DEBUG_DATA_DIR_WITH_PATH/kubernetes_get_events-$k8Namespace.$LOG  2>&1

    printInfo -e "  Executing '$kubeValue get all -n $k8Namespace -owide'"  
    $kubeValue get all -n $k8Namespace -owide > $DEBUG_DATA_DIR_WITH_PATH/kubenetes_get_all-$k8Namespace.$LOG

    if [ $helmType3 = $helm3false ]
    then
        # Find helm data
        printInfo -e "  Executing helm commands"
        # Find all helm releases of k8Namespace
        helmReleaseList=`$helmValue  ls | $AWK_CMD '{print $1 ',' $10}' | $GREP_CMD -i $k8Namespace | $AWK_CMD '{print $1}'`
        if [[ ! -z $helmReleaseList ]]; then
            helmReleaseListFull=`$helmValue  ls` 
            printInfo -e "  Executing '$helmValue ls'"  
            $ECHO_CMD "$helmReleaseListFull" >> $DEBUG_DATA_DIR_WITH_PATH/helmReleases.log 

            while IFS= read -r helmRelease; do
               printInfo -e "  Executing '$helmValue get $helmRelease'"
               $helmValue get $helmRelease > $DEBUG_DATA_DIR_WITH_PATH/$HELM_DATA-$helmRelease.$LOG
            
               printInfo -e "  Executing '$helmValue status $helmRelease'"  
               $helmValue status $helmRelease > $DEBUG_DATA_DIR_WITH_PATH/$HELM_STATUS-$helmRelease.$LOG
            done <<< "$helmReleaseList"
        else
            printInfo -e "  No helm2 based deployment in this namespace"
        fi
    elif [ $helmType3 = $helm3true ]
    then
        # Find helm data
        printInfo -e "  Executing helm3 commands"
        # Find all helm releases of k8Namespace
        helmReleaseList=`$helmValue  ls -n $k8Namespace | $AWK_CMD '{print $1 ',' $10}' | $GREP_CMD -i $k8Namespace | $AWK_CMD '{print $1}'`
        if [[ ! -z $helmReleaseList ]]; then
            helmReleaseListFull=`$helmValue  ls -n $k8Namespace `
            printInfo -e "  Executing '$helmValue ls -n $k8Namespace'"
            $ECHO_CMD "$helmReleaseListFull" >> $DEBUG_DATA_DIR_WITH_PATH/helmReleases.log

            while IFS= read -r helmRelease; do
               printInfo -e "  Executing '$helmValue get all $helmRelease -n $k8Namespace'"
               $helmValue get all $helmRelease -n $k8Namespace > $DEBUG_DATA_DIR_WITH_PATH/$HELM_DATA-$helmRelease.$LOG

               printInfo -e "  Executing '$helmValue status $helmRelease -n $k8Namespace'"
               $helmValue status $helmRelease -n $k8Namespace  > $DEBUG_DATA_DIR_WITH_PATH/$HELM_STATUS-$helmRelease.$LOG
            done <<< "$helmReleaseList"
        fi
     fi
 }


function prepareTarBall(){
   
   printInfo "  Data collection work completed. Packing data collected ...."
   $TAR_CMD -cvzf $DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR.tar.gz $DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR/*  > /dev/null 2>&1
   debugDataDir="$DEBUG_DATA_DIR.tar.gz"
   printInfo "  Data collected to :- $DEBUG_DATA_DIR_PATH/$debugDataDir"
   printInfo "  ----------------------------------------"

   FILESIZE=$(stat -c%s "$DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR.tar.gz")
   if [ $FILESIZE -gt $sizeOfTar ];then
      printInfo "  Data tarball created size is $FILESIZE bytes which is greater than $sizeOfTar bytes."
      printInfo "  Splitting tarball to files with maximum size upto $sizeOfTar bytes." 
      $ECHO_CMD 
      $SPLIT_CMD -b $sizeOfTar -d $DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR.tar.gz $DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR-part
      printInfo "  Splitting tarball to files is done. Splitted files are:- "
      $LS_CMD -ltr $DEBUG_DATA_DIR_PATH/$DEBUG_DATA_DIR-part*
      
      $ECHO_CMD 
      printInfo "  After transferring files to required destination, plese combine the files back to single tarball."
      printInfo "  Please use command below."
      printInfo "  Command:-  cat <splitted files*>  <combinedTarBall>.tar.gz"
      $ECHO_CMD 
      printInfo "  Command to combine the files created in above step is:-"
      printInfo "  cat $DEBUG_DATA_DIR-part* > $DEBUG_DATA_DIR-combined.tar.gz"
   fi
}

function checkSystem()
{
   $TAR_CMD --help > /dev/null 2>&1
   if [ $? -ne 0 ];then 
       printInfo "  tar package not installed on the environment! Please try again after installing tar package."
       exit 1
   fi

   $SPLIT_CMD --help > /dev/null 2>&1
   if [ $? -ne 0 ];then 
       printInfo "  split package not installed on the environment! Please try again after installing split package."
       exit 1
   fi 

}

# Entry point of tool
function main()
{
    clear
    printInfo 
    printInfo -e "  `date +"%Y.%m.%d_%H.%M.%S"` :: Data capture tool execution started"
    printInfo "  ----------------------------------------"

    printInfo -e "  Data capture tool logs are available at $LOG_FILE_PATH"
    printInfo
    # Check basic tools
    checkSystem

    parseCmdLine $*

    printInfo "  ----------------------------------------"
    printInfo

    # Output data directory
    createDebugDataDir $*

    # Tool logic
    executeBussinessLogic $*

    printInfo "  ----------------------------------------"
    printInfo

    # Data size calculation 
    convertBytes $sizeOfTar

    # Tar ball creation
    prepareTarBall $*
    printInfo "  ----------------------------------------"

    $ECHO_CMD 
    printInfo -e "  `date +"%Y.%m.%d_%H.%M.%S"` :: Data capture tool execution completed !\n"
    printInfo "  ----------------------------------------"
}

main $*


