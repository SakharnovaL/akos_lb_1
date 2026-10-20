#!/bin/bash
testing_script="/home/vboxuser/lb_1.sh"
testing_path="/home/vboxuser/stand_sizes"
backup_dir="/home/vboxuser/Dackup"

sudo umount "$testing_path"
sudo mkfs.ext4 -F "$loop_im"
sudo mount -t ext4 -o loop "$loop_im" "$testing_path"
sudo chown -R $(id -u) "$testing_path"

if [[ ! -d "$testing_path" ]]; then
    echo "error: not found your directory $testing_path"
    exit 1
else
   echo "everything ok"
fi
