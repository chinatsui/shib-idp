#!/bin/bash

if [ "$1" == '-y' ]; then
  response="Y"
else
  read -r -p "Are you sure you want to remove the test idp and data images/containers? [y/N] " response
fi

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  #kill, if running, and remove idp container
  docker ps | grep shib-train_idp &>/dev/null
  if [  $? == '0' ]; then
    #get container ID
    export contid=$(docker ps | grep shib-train_idp | cut -f 1 -d ' ')
    docker kill ${contid} &>/dev/null
    docker rm ${contid} &>/dev/null
  else
    #check if an old container is present, rm if needed
    docker container ls -a | grep shib-train_idp &>/dev/null
    if [  $? == '0' ]; then
        #get container ID
          export contid=$(docker container ls -a | grep shib-train_idp | cut -f 1 -d ' ')
          docker kill ${contid} &>/dev/null
          docker rm ${contid} &>/dev/null
    fi
  fi

  #kill, if running, and remove data container
  docker ps | grep shib-train_data &>/dev/null
  if [  $? == '0' ]; then
    #get container ID
    export contid2=$(docker ps | grep shib-train_data | cut -f 1 -d ' ')
    docker kill ${contid2} &>/dev/null
    docker rm ${contid2} &>/dev/null
  else
    #check if an old container is present, rm if needed
    docker container ls -a | grep shib-train_data &>/dev/null
    if [  $? == '0' ]; then
        #get container ID
          export contid2=$(docker container ls -a | grep shib-train_data | cut -f 1 -d ' ')
          docker kill ${contid2} &>/dev/null
          docker rm ${contid2} &>/dev/null
    fi
  fi

  #remove images
  docker rmi -f shib-train_idp &>/dev/null
  docker rmi -f shib-train_data &>/dev/null

else
    echo "Terminating..."
    exit 0
fi

