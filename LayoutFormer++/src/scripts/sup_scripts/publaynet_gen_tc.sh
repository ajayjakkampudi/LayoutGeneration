#!/bin/bash

# Script for Single-Node multi-GPU training

MODE=$1
DATA_DIR=$2
OUT_DIR=$3
TRAINER=$4
NUM_GPU=$5
EVAL_CKPT_TAG=$6

if [[ $TRAINER = "deepspeed" ]]
then
    # DeepSpeed
    COMMAND="deepspeed --master_port 60005"
else
    # Data Parallel
    TRAINER="basic"
    COMMAND="python"
fi

echo $COMMAND

$COMMAND main.py --${MODE} --dataset publaynet \
--tasks gen_tc \
--max_num_elements 20 \
--data_dir ${DATA_DIR} \
--out_dir ${OUT_DIR} \
--num_layers 8 \
--nhead 8 \
--d_model 512 \
--dropout 0.1 \
--share_embedding \
--epoch 60 \
--batch_size 100 \
--eval_batch_size 100 \
--decode_max_length 150 \
--num_pos_embed 400 \
--lr 1e-04 \
--warmup_num_steps 4000 \
--gradient_accumulation 1 \
--bbox_format ltwh \
--discrete_x_grid 128 \
--discrete_y_grid 128 \
--trainer ${TRAINER} \
--deepscale_config ./scripts/ds_config.json \
--eval_seed 100 \
--enable_task_measure \
--eval_interval 50 \
--eval_ckpt_tag ${EVAL_CKPT_TAG} \
--add_sep_token \
--sort_by_dict
