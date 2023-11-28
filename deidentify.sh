#!/bin/bash

# Parse input
while [ $# -gt 0 ]; do
    if [[ $1 == "--help" ]]; then
        usage
        exit 0
    elif [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

# Set default values
programname=$0

function usage {
    echo ""
    echo "Deidentifies ehr data."
    echo ""
    echo "usage: $programname --input path [--output path]"
    echo ""
    echo "  --input path            Input folder"
    echo "                          (example: ./data/notes/)"
    echo "  --output path           Output folder"
    echo "                          (example: ./data/predictions/)"
    echo ""
}

function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}


if [[ -z $input ]]; then
    usage
    die "Missing parameter --input"
fi

# Check if input is a folder
if [[ ! -d $input ]]; then
    usage
    die "$input is not a folder or does not exist."
fi

# Check if input.jsonl is not in input folder
if [[ ! -f $input/input.jsonl ]]; then
    usage
    die "Input folder does not contain input.jsonl. Please rename your input dataset to input.jsonl"
fi

# Check if output folder is not set, set it to equal input folder
if [[ -z $output ]]; then
    output=$input
fi



# Check if docker container with name ehr_deid is built
# If not, return help message
if [[ "$(docker images -q ehr_deid 2> /dev/null)" == "" ]]; then
    echo "Docker container ehr_deid not found. Please build the container with tag ehr_deid first."
    echo "Run the following command to build the container:"
    echo "docker build -t ehr_deid ."
    exit 1
fi

# Cache huggingface models to _cache directory
if [[ ! -d _cache ]]; then
    echo "Creating model cache directory _cache..."
    mkdir -p _cache/transformers
    mkdir -p _cache/datasets
fi

# Run the docker container with the stored input and output as volumes
echo "Starting container ehr_deid..."
echo "Mounting input directory: ./$input"
echo "Mounting output ./$output"

echo "Running container ehr_deid..."
container_id=$(docker run -v ./"$input":/mnt/"$input" \
                          -v ./"$output":/mnt/"$output" \
                          -v ./ehr_deidentification:/ehr_deidentification \
                          -v "$(pwd)"/_cache/transformers:/root/.cache/huggingface/transformers \
                          -v "$(pwd)"/_cache/datasets:/root/.cache/huggingface/datasets \
                          --gpus 1 \
                          -d ehr_deid tail -f /dev/null)

# Run the forward pass on the input file using docker exec
echo "Executing deidentification process on container $container_id..."
docker exec -it "$container_id" /bin/bash -c "./steps/forward_pass/forward_pass.sh \
        --INPUT_FILE /mnt/"$input"/input.jsonl \
        --NER_DATASET_FILE ./data/ner_datasets/test.jsonl \
        --PREDICTIONS_FILE ./data/predictions/predictions.jsonl \
        --DEID_FILE /mnt/"$output"/output.jsonl \
        --MODEL_CONFIG ./steps/forward_pass/run/i2b2/predict_i2b2.json"

# Stop the container
echo "Done."
# echo "Stopping container $container_id"
# docker container kill "$container_id"