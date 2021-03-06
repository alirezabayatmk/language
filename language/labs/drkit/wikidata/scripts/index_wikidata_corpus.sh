# coding=utf-8
# Copyright 2018 The Google AI Language Team Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash

BERT_BASE_DIR="wwm_uncased_L-24_H-1024_A-16/"
PRETRAIN_DIR="models/pretraining"
DEV_ENTS="data/pretraining/dev_entities.json"

for HOP in "onehop" "twohop" "threehop"; do
  DATA_DIR="data/$HOP"

  # Index training corpus.
  python -m language.labs.drkit.wikidata.index \
    --vocab_file=$BERT_BASE_DIR/vocab.txt \
    --bert_config_file=$BERT_BASE_DIR/bert_config.json \
    --paragraphs_file=$DATA_DIR/train/paragraphs.json \
    --queries_file=$DATA_DIR/train/queries.json \
    --multihop_output_dir=$DATA_DIR/train/indexed \
    --predict_batch_size=32 \
    --output_dir=$PRETRAIN_DIR \
    --projection_dim=200 \
    --dev_entities_file=$DEV_ENTS \
    --pretrain_dir=$PRETRAIN_DIR \
    --logtostderr

  # Index test corpus. Don't specify dev entities so all queries are put in dev.
  python -m language.labs.drkit.wikidata.index \
    --vocab_file=$BERT_BASE_DIR/vocab.txt \
    --bert_config_file=$BERT_BASE_DIR/bert_config.json \
    --paragraphs_file=$DATA_DIR/test/paragraphs.json \
    --queries_file=$DATA_DIR/test/queries.json \
    --multihop_output_dir=$DATA_DIR/test/indexed \
    --predict_batch_size=32 \
    --output_dir=$PRETRAIN_DIR \
    --projection_dim=200 \
    --pretrain_dir=$PRETRAIN_DIR \
    --logtostderr

done
