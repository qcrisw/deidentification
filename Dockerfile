FROM continuumio/miniconda3
LABEL maintainer="Ummar Abbas <uabbas@hbku.edu.qa>"

RUN apt-get update && apt-get install --assume-yes git

# COPY ./ehr_deidentification /ehr_deidentification
RUN git clone https://github.com/qcrisw/ehr_deidentification.git
WORKDIR /ehr_deidentification

RUN conda env create -f /ehr_deidentification/deid.yml
RUN echo "source activate deid" > ~/.bashrc
ENV PATH /opt/conda/envs/deid/bin:$PATH
RUN pip install robust-deid
RUN apt update && apt install -y jq && apt install -y moreutils && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]