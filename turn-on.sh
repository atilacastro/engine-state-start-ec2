#!/bin/bash

LIST=$(aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='app-name'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter "Name=tag:app-name,Values=e-Log" "Name=tag:auto-onoff,Values=true" --output text | grep stopped | awk '{print $2}')
LIST=(${LIST})

for line in ${LIST[@]}; do
    aws ec2 start-instances --region "${AWS_REGION}" --instance-ids $line --output text
done

# Wait Instance Status OK
aws ec2 wait instance-status-ok --region "${AWS_REGION}" --instance-ids $line
echo "Instances state: "
aws ec2 describe-instances --region "${AWS_REGION}" --query "Reservations[].Instances[].{AppName: Tags[?Key=='app-name'].Value [] | [0], instances: [ { InstanceId: InstanceId, state: State.Name} ] } | {AppName: [0].AppName, Instances: [].instances}" --filter "Name=tag:app-name,Values=e-Log" "Name=tag:auto-onoff,Values=true" --output text