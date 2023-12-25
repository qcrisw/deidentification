# Prerequisites
- [Docker installed](https://docs.docker.com/engine/install/ubuntu/)

# Dockerfile instructions
- `docker build -t ehr_deid .`
- Or pull the built image with `docker pull ghcr.io/qcrisw/deidentification:master`
    - Note that you will need to login to ghcr and to make sure that you are authorized to download the container
    - `docker login ghcr.io -u <user_name> -p <token_key>`. The token can be generated from [here](https://github.com/settings/tokens)

# Run script
- Create input directory `mkdir dataset`
- Add your identified dataset with the name `input.jsonl`.
- `bash deidentify.sh --input dataset` in Windows or `./deidentify.sh --input ./dataset` in Linux

# Specifics
- Docker clones sub repository https://github.com/qcrisw/ehr_deidentification.git
- Docker container mounts input and output folders under /mnt/

# `input.jsonl` format

Each discharge summary should follow the following format in `dataset/input.jsonl`

```
{
    "text": "Physician Discharge Summary Admit date: 10/12/1982 Discharge date: 10/22/1982 Patient Information Jack Reacher, 54 y.o. male (DOB = 1/21/1928). Home Address: 123 Park Drive, San Diego, CA, 03245. Home Phone: 202-555-0199 (home). Hospital Care Team Service: Orthopedics Inpatient Attending: Roger C Kelly, MD Attending phys phone: (634)743-5135 Discharge Unit: HCS843 Primary Care Physician: Hassan V Kim, MD 512-832-5025.", 
    "meta": {
        "note_id": "note_1", 
        "patient_id": "patient_1"
    }, 
    "spans": []
}
{
    "text": ...
    ...
    "meta": {
        "note_id": "note_<id>", 
        "patient_id": "patient_<id>"
    },
    "spans": []
}
```
