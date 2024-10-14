ansible_shell() {
    local nodes=${1:-'all'}
    local cmd=${2:-'hostname'}
    echo "ansible -i $INVENTORY_FILE $nodes -m shell -a \"$cmd\""
    ansible -i $INVENTORY_FILE $nodes -m shell -a "$cmd"
}

create_user_volume() {
    local username=$1
    local cluster=${2:-'stairwai'}
    local volumes_dir=''
    local node=''
    echo "Creating volume for $username onto $cluster"
    if [[ "$cluster" == "stairwai" ]]; then
        volumes_dir=/mnt/data1/volumes
        node='storage1'
    elif [[ "$cluster" == "ai4health" ]]; then
        volumes_dir=/mnt/data9/ai4health-volumes/docker-volumes
        node='inference7'
    else
        echo "Cluster $cluster not supported"
        return 1
    fi
    echo "Creating volume on node $node, inside $volumes_dir"
    local rand=$(python -c "import uuid; print(uuid.uuid4(), end='')")
    local volume_path="$volumes_dir/$username#$rand/_data"
    local volume_name=$username-volume
    echo "Volume name: $volume_name to be created in $volume_path"
    ansible_shell $node "mkdir -p $volume_path" 
    ansible_shell $node "chmod a+rw $volume_path"
    ansible_shell $cluster "docker volume create -d local -o type=none -o o=bind -o device=$volume_path $volume_name"
}
