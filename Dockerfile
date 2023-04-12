# Define custom function directory
ARG FUNCTION_DIR="/var/task/"

FROM python:3.11-slim-buster as build-image

ARG FUNCTION_DIR
RUN mkdir -p ${FUNCTION_DIR}

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

# Install the dependencies
RUN pip install --target ${FUNCTION_DIR} awslambdaric

FROM python:3.11-slim-buster

ARG FUNCTION_DIR
# Set working directory to function directory
WORKDIR ${FUNCTION_DIR}

# Copy in the built dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
