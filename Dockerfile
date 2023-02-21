FROM ubuntu:jammy

# Install the conda environment
RUN apt-get update && apt-get install build-essential cmake git curl -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

RUN git clone https://github.com/Singular-Genomics/singular-demux.git
RUN cd /singular-demux && cargo install --path /singular-demux --locked
