#!/bin/bash
testing_script="/home/vboxuser/lb_1.sh"
testing_path="/home/vboxuser/stand_size"
backup_dir="/home/vboxuser/Dackup"

sudo umount "$testing_path"
sudo mkfs.ext4 -F "$loop_im"
sudo mount -t ext4 -o loop "$loop_im" "$testing_path"
sudo chown -R $(id -u) "$testing_path"

#298 21 250 186 81
sudo dd if=/dev/zero of="$testing_path/check_1" bs=1K count=298	#old 4
if [[ $? -ne 0 ]]; then
    echo "error: folder is full"
    exit 1
fi
sudo dd if=/dev/zero of="$testing_path/check_2" bs=1K count=21	#old 1
if [[ $? -ne 0 ]]; then
    echo "error: folder is full"
    exit 1
fi
sudo dd if=/dev/zero of="$testing_path/check_3" bs=1K count=250	#old 5
if [[ $? -ne 0 ]]; then
    echo "error: folder is full"
    exit 1
fi
sudo dd if=/dev/zero of="$testing_path/check_4" bs=1K count=186	#old 3
if [[ $? -ne 0 ]]; then
    echo "error: folder is full"
    exit 1
fi
sudo dd if=/dev/zero of="$testing_path/check_5" bs=1K count=81	#old 2
if [[ $? -ne 0 ]]; then
    echo "error: folder is full"
    exit 1
fi

sudo touch -d "5 hours ago" "$testing_path/check_2"
sudo touch -d "4 hours ago" "$testing_path/check_5"
sudo touch -d "3 hours ago" "$testing_path/check_4"
sudo touch -d "2 hours ago" "$testing_path/check_1"
sudo touch -d "1 hours ago" "$testing_path/check_3"

echo "files before the test"
ls -lth "$testing_path"

echo -e "$testing_path\n$backup_dir" | $testing_script
script_status=$?
if [[ script_status -eq 0 ]]; then
    echo "everything ok"
else
    echo "error with number $script_status"
fi

archive_count=$(ls -1 "$backup_dir"/*.tar.gz 2>/dev/null | wc -l)
if [[ "$archive_count" -gt 0 ]]; then
    echo "archive in Dackup"
    echo "files in archive is:"
    tar -tzf /home/vboxuser/Dackup/archive_1.tar.gz
else
    echo "no archive or your directory is perfect"
fi
