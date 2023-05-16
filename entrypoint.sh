#!/bin/bash

DEFAULT_MODEL="TheBloke/stable-vicuna-13B-GPTQ"
DEFAULT_BOOGA_PARAM="--chat --wbits 4 --groupsize 128 --extensions api --verbose"

HF_MODEL=${HF_MODEL:-"$DEFAULT_MODEL"}
BOOGA_PARAM=${BOOGA_PARAM:-"$DEFAULT_BOOGA_PARAM"}
MODEL_NAME=${HF_MODEL//\//_}

echo "Hugging Face Model (HF_MODEL) = $HF_MODEL"
echo "Booga Param (BOOGA_PARAM) = $BOOGA_PARAM"

# Check if the user is using the default values
if [ "$HF_MODEL" = "$DEFAULT_MODEL" ]; then
  # Alert the user that custom values can be set using environment variables
  echo "You can set a custom model name and URL using the following environment variables:"
  echo "  - HF_MODEL: set the hugging face model (eg: organization/model)"
  echo "  - BOOGA_PARAM: set the params used when running booga's server.py"
  echo ""
fi

source /app/venv/bin/activate

if [ ! -d "/app/models/$MODEL_NAME" ]; then
  echo "Downloadingh HF model..."
  python3 download-model.py $HF_MODEL
  echo "Model downloaded successfully!"
else
  echo "Model folder already exists, skipping download..."
fi

python3 server.py --auto-devices --listen-host 0.0.0.0 --listen --model "$MODEL_NAME" $BOOGA_PARAM
