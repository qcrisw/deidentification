FROM mambaorg/micromamba:1.5.5
LABEL maintainer="Ummar Abbas <uabbas@hbku.edu.qa>"


USER root
RUN apt-get update && apt-get install --assume-yes git
RUN apt update && apt install -y jq && apt install -y moreutils && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/qcrisw/ehr_deidentification.git
USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER ehr_deidentification/deid.yml /tmp/env.yaml
WORKDIR /ehr_deidentification

RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# RUN echo "source activate deid_cpu" > ~/.bashrc
RUN echo "source activate base" > ~/.bashrc

ENV PATH /opt/conda/envs/base/bin:$PATH
RUN pip install robust-deid

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
