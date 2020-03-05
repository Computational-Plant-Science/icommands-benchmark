#!/bin/bash

positional=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--host)
    host="$2"
    shift
    shift
    ;;
    -p|--port)
    port="$2"
    shift
    shift
    ;;
    -z|--zone)
    zone="$2"
    shift
    shift
    ;;
    -u|--user)
    user="$2"
    shift
    shift
    ;;
    -w|--password)
    password="$2"
    shift
    shift
    ;;
    *)
    positional+=("$1")
    shift
    ;;
esac
done
set -- "${positional[@]}"

echo "Benchmarking against IRODS server at '$host:$port', zone '$zone'..."

sleep 5

echo "Configuring IRODS client..."
printf "%s\n%s\n%s\n%s\n%s\n" "$host" "$port" "$user" "$zone" "$password" | iinit

path="/$zone/home/$user/samples"

echo "Timing uncompressed..."
time iput -vr samples "$path"

echo "Cleaning up..."
irm -vr "$path"

echo "Timing compressed..."
time (iput -v -Dtar samples.tar "$path.tar" && ibun -x "$path.tar" "$path")

echo "Cleaning up..."
irm -vr "$path.tar"
irm -vr "$path"
