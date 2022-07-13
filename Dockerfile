FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    apt-get install -y libprotobuf-dev protobuf-compiler

FROM base AS final 
ARG TAGS
RUN addgroup --gid 1000 renan 
RUN adduser --gecos renan --uid 1000 --gid 1000 --disabled-password renan 
USER renan 
WORKDIR /home/renan

FROM final
COPY . .
USER renan 
RUN apt-get update && apt-get install build-essential cmake --no-install-recommends
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

