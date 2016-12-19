#!/bin/bash

if [[ "${#@}" == 0 ]]; then
  echo "usage: $0 [tensor directory] [build_tensor.py ARGS]"
  exit 1;
fi

BUILD_ARGS=""

# Check for template directory
if [[ -d $1 ]]; then
  TEMPLATE_DIR=$1
  echo "Using template dir: ${TEMPLATE_DIR}"

  # Consruct output name whether we are in root or scripts/
  OUT_DIR=""
  if [[ $(pwd) =~ .*scripts$ ]]; then
    OUT_DIR=$(dirname $(pwd))/_tensors
  else
    OUT_DIR=$(pwd)/_tensors
  fi

  BUILD_ARGS="${BUILD_ARGS} -o ${OUT_DIR}/$(basename ${TEMPLATE_DIR}).md"

  # check title -- may contain spaces!
  if [[ -f ${TEMPLATE_DIR}/title.txt ]]; then
    BUILD_ARGS="${BUILD_ARGS} --title=\"$(cat ${TEMPLATE_DIR}/title.txt)\""
  fi

  # check nnz
  if [[ -f ${TEMPLATE_DIR}/nnz.txt ]]; then
    BUILD_ARGS="${BUILD_ARGS} --nnz $(cat ${TEMPLATE_DIR}/nnz.txt)"
  fi

  # check dims
  if [[ -f ${TEMPLATE_DIR}/dims.txt ]]; then
    BUILD_ARGS="${BUILD_ARGS} --dims $(cat ${TEMPLATE_DIR}/dims.txt)"
  fi

  # check tags
  if [[ -f ${TEMPLATE_DIR}/tags.txt ]]; then
    BUILD_ARGS="${BUILD_ARGS} --tag $(cat ${TEMPLATE_DIR}/tags.txt)"
  fi

  # check desc
  if [[ -f ${TEMPLATE_DIR}/description.md ]]; then
    BUILD_ARGS="${BUILD_ARGS} --desc ${TEMPLATE_DIR}/description.md"
  fi

  # check cite
  if [[ -f ${TEMPLATE_DIR}/cite.bib ]]; then
    BUILD_ARGS="${BUILD_ARGS} --cite ${TEMPLATE_DIR}/cite.bib"
  fi

  # check files
  if [[ -f ${TEMPLATE_DIR}/files.txt ]]; then
    BUILD_ARGS="${BUILD_ARGS} --files ${TEMPLATE_DIR}/files.txt"
  fi

  BUILD_ARGS="${BUILD_ARGS} ${@:2}"
else
  BUILD_ARGS="${BUILD_ARGS} ${@:1}"
fi

# xargs handles quoted args (such as title) gracefully
echo ${BUILD_ARGS} | xargs $(dirname $0)/build_tensor.py