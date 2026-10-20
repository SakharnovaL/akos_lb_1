#!/bin/bash
read -p 'enter your directory path: ' path
percent=$(df "$path" | awk 'NR>1 {gsub(/%/, ""); print $5}')
echo "percent is $percent"
max_size=75
if [[ "$percent" -le "$max_size" ]]; then
    echo "your directory is perfect"
else
    read -p 'enter your back up directory: ' back_up_dir
    arc_name="archive_$(date +%Y%m%d_%H%M%S).tar"
    arc_path="$back_up_dir/$arc_name"
    cd "$path"
    mapfile -d '' files < <(find . -maxdepth 1 -type f -printf '%T@ %f\0' | sort -z -n | cut -z -d' ' -f2-)
    for i in "${files[@]}"; do
        tar -rf "$arc_path" "$i" --remove-files
        if [[ $(df "$path" | awk 'NR>1 {gsub(/%/, ""); print $5}') -le "$max_size" ]]; then
            break
        fi
    done
    gzip "$arc_path"
fi

#sudo mount -t ext4 -o loop /userdisk.fs /home/vboxuser/stand_size
#df -h see all mounted disks
