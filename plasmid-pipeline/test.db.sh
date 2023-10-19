mkdir -p databases/plassembler-db
docker run -v $PWD:/data/ quay.io/biocontainers/plassembler:1.1.0--pyhdfd78af_0 plassembler download -d /data/databases/plassembler-db