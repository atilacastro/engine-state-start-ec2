#!/bin/bash
# alias green-grep="GREP_COLOR='1;32' grep --color=always"
# aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='AppName'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter Name=tag:app-name,Values=e-Log --output text
LIST=$(aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='app-name'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter "Name=tag:app-name,Values=e-Log" "Name=tag:auto-onoff,Values=true" --output text | grep stopped)
if [ -z "$LIST" ];
  then
    echo "All instances are running, try loggin there or contact the administrator"
    echo "Instances state: "
    aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='app-name'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter "Name=tag:app-name,Values=e-Log" "Name=tag:auto-onoff,Values=true" --output text | grep running
elif [ "$LIST" != "NULL" ];
  then 
  aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='app-name'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter "Name=tag:app-name,Values=e-Log" "Name=tag:auto-onoff,Values=true" --output text | grep stopped --color=always
fi