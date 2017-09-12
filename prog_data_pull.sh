#!/bin/bash

CONFIG_PATH=./config
#read download config
conf_cnt=0
for file in $CONFIG_PATH/*.cfg
do
    if test -f $file; then
        conf_list[$conf_cnt]=$file
        conf_cnt=$((conf_cnt+1))
    fi
done
echo ${conf_list[*]}

for((i=0; i<${#conf_list[@]}; i++))
do
    echo "processing ${conf_list[$i]}"
    while read line; do
        eval "$line"
    done<${conf_list[$i]}

    if [[ $scp_list -eq "default" ]]; then
        scp_list="${conf_list[$i]}.scp.list"
    fi

    if [[ $local_dl_root -eq "default" ]]; then
        local_dl_root="./download/$server_name"
        echo $local_dl_root
    fi

    while read scp_file; do
        remote_path="$ssh_user@$server_ip:$scp_file"
        echo $remote_path
        local_path="$local_dl_root${scp_file%/*}"
        if [[ ! -d $local_path ]]; then
            mkdir -p $local_path
            if [[ $? == 0 ]]; then
                echo "create local path: $local_path"
            else
                echo "create local path failed!: $local_path"
                exit 1
            fi
        fi
        local_path="$local_path/${scp_file##*/}"
        expect scp_dl.exp $remote_path $local_path $ssh_password
        $SHELL prog_data_handler.sh $local_path $server_name
    done<$scp_list

done
