NIC=eno1
HOST_NAME=ee-kraken
export MASTER_ADDR=146.179.4.23

export NCCL_DEBUG=INFO
# # this is use to print more debug information
#export NCCL_IB_HCA=mlx5_0,mlx5_1
# # set all of your IB HCA that you want to use
#if [ $(hostname) == "gpu-9" ] ; then
#    NIC=enp195s0f0np0
#else
#    NIC=enp195s0np0
#fi
# 
export NCCL_SOCKET_IFNAME=$NIC
# # assuming you don't have other NIC that you don't want to use, otherwise you need to exclude them
# export NCCL_IB_GID_INDEX=3
# # assuminfg IPoIB is using GID index 3, you may want to change this
export MASTER_PORT=51205
export TORCH_DISTRIBUTED_DEBUG=DETAIL
# 
export GLOO_SOCKET_IFNAME=$NIC

# this gloo_socket_ifname is required eventhough youn think you are using NCCL!

# you also need to make sure that `/etc/hosts` file on each machine has the corresponding IP address and hostname.

# then you can use torchrun to run the code on multiple nodes with `torchrun` command.

# On Machine 1 (with GPUs 0-3)
echo $NCCL_SOCKET_IFNAME
if [ $(hostname) == "$HOST_NAME" ] ; then
    torchrun --nnodes=2 --nproc_per_node=4 --node_rank=0 --rdzv_id=456 --rdzv_backend=c10d --rdzv_endpoint=$MASTER_ADDR:$MASTER_PORT main.py 50 10
else
    torchrun --nnodes=2 --nproc_per_node=4 --node_rank=1 --rdzv_id=456 --rdzv_backend=c10d --rdzv_endpoint=$MASTER_ADDR:$MASER_PORT main.py 50 10
fi


