#!/bin/bash

while getopts ":h:u:p:f" opt; do
  case $opt in
    h) host=$OPTARG ;;
    u) user=$OPTARG ;;
    p) password=$OPTARG ;;
    f) file=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

ssh-key-gen-and-cp-to-host() {
    host=$1
    user=$2
    passwd=$3
    echo $host $user $passwd

    file=$(echo $host $HOME | sed 's/\./\-/g' | awk '{print $2"/.ssh/"$1}')
    pub_file=$(echo $file | awk '{print $1.".pub"}')

    ssh-keygen -t ed25519 -C "ssh login" -f $file;

    if [[ -z $passwd ]];
    then
      ssh-copy-id -i $file $user@$host;
    else
      sshpass -p $passwd ssh-copy-id -i $file $user@$host;
    fi

    cat >> ~/.ssh/config << EOF
Host $host
  HostName $host
  PreferredAuthentications publickey
  IdentityFile $file
EOF
}

if [[ -z $user || -z $host ]]; then
  echo "Usage: script.sh -u <user> -h <host>"
  exit 1
fi

ssh-key-gen-and-cp-to-host $host $user $password
