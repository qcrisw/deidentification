# Prerequisites
- [Docker installed](https://docs.docker.com/engine/install/ubuntu/)

# Dockerfile instructions
- *cpu*: `docker build -t ehr_deid .`
- *gpu*: `docker build -t ehr_deid -f Dockerfile-gpu .`

# Run script
- Create input directory `mkdir dataset`
- Add your identified dataset with the name `input.jsonl`
- `bash deidentify.sh --input dataset` in Windows or `./deidentify.sh --input ./dataset` in Linux

# Specifics
- Docker clones sub repository https://github.com/qcrisw/ehr_deidentification.git
- Docker container mounts input and output folders under /mnt/
