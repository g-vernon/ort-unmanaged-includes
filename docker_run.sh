#!/usr/bin/env bash
set -eu

rm -f analyzer-result.yml
rm -f scan-result.yml
rm -f reporter-result.yml
rm -f NOTICE_DEFAULT.yml

function run_ort {
    docker run \
        -v /etc/group:/etc/group:ro \
        -v /etc/passwd:/etc/passwd:ro \
        -v $HOME:$HOME \
        -u $(id -u):$(id -g) \
        -e HOME=$HOME \
        -v $PWD:/workdir \
        -w /workdir \
        ort \
        $@
}

run_ort analyze -i . -o .
run_ort scan -i analyzer-result.yml -o .
run_ort report \
    -f PlainTextTemplate,WebApp \
    -O PlainTextTemplate=template.id=NOTICE_DEFAULT \
    -i scan-result.yml -o .
