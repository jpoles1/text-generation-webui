#!/bin/bash

DEFAULT_MODEL_NAME="stable-vicuna-13B-GPTQ"
DEFAULT_MODEL_URL="https://huggingface.co/TheBloke/stable-vicuna-13B-GPTQ"
DEFAULT_BOOGA_PARAM="--chat --wbits 4 --groupsize 128 --extensions api --verbose"

MODEL_NAME=${MODEL_NAME:-"$DEFAULT_MODEL_NAME"}
MODEL_URL=${MODEL_URL:-"$DEFAULT_MODEL_URL"}
BOOGA_PARAM=${BOOGA_PARAM:-"$DEFAULT_BOOGA_PARAM"}

MODEL_DIR="/app/models/$MODEL_NAME"

echo "Model name/dir (MODEL_NAME) = $MODEL_NAME"
echo "Git LFS Model URL (MODEL_URL) = $MODEL_URL"
echo "Booga Param (BOOGA_PARAM) = $BOOGA_PARAM"

# Check if the user is using the default values
if [ "$MODEL_NAME" = "$DEFAULT_MODEL_NAME" ] && [ "$MODEL_URL" = "$DEFAULT_MODEL_URL" ]; then
  # Alert the user that custom values can be set using environment variables
  echo "You can set a custom model name and URL using the following environment variables:"
  echo "  - MODEL_NAME: set the name of the model (this also sets the model dir name)"
  echo "  - MODEL_URL: set the Git LFS URL of the model"
  echo "  - BOOGA_PARAM: set the params used when running booga's server.py"
  echo ""
fi

if [ -d "$MODEL_DIR" ]; then
  echo "Repository already cloned. Skipping."
else
    git lfs install
    git clone $MODEL_URL $MODEL_DIR
fi    

source /app/venv/bin/activate
python3 server.py --auto-devices --listen-host 0.0.0.0 --listen --model $MODEL_NAME $BOOGA_PARAM
