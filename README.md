# Dockerfile instructions
- *cpu*: docker build -t ehr_deid .
- *gpu*: docker build -t ehr_deid -f Dockerfile-gpu .

# Run script
bash deidentify.sh --input <input_folder>

# Specifics
Docker container mounts input and output folders under /mnt/