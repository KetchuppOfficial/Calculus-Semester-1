#!/bin/bash

function compiler
{
    local input_name=${input_file##*/}
    echo "input_name = ${input_name}"

    local input_dir
    if [ ${input_name} = ${input_file} ]
    then
        input_dir=.
    else
        input_dir=${input_file%/*}
    fi
    echo "input_dir = ${input_dir}"

    local service_dir=.${input_name/.tex/_service}
    echo "service_dir = ${service_dir}"

    local initial_dir=$PWD
    echo "initial directory = ${initial_dir}"
    cd ${input_dir}
    mkdir -p ${service_dir}
    pdflatex -output-directory=${service_dir} ${input_name}
    cd ${initial_dir}

    local output_name=${input_name/.tex/.pdf}
    echo "output_name = $output_name"

    mv ${input_dir}/${service_dir}/${output_name} .
    open ./${output_name}
}

if [ $# -eq 1 ]
then
    input_file=$1
    echo "input_file = ${input_file}"
    if [ -f ${input_file} ]
    then
        if [ -r ${input_file} ]
        then
            if [ -s ${input_file} ]
            then
                compiler
            else
                echo "File \"${input_file}\" is empty"
            fi
        else
            echo "File \"${input_file}\" is not readable"
        fi
    else
        echo "File \"${input_file}\" does not exist"
    fi
else
    echo "Script requires exactly 1 argument"
fi
