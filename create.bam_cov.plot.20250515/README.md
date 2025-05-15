## using pixi
```
#install pixi
bash install.pixi.sh 

#create environment
pixi init bam_cov
cd bam_cov/
pixi add minimap2 samtools vega-lite-cli alignoth

#get test data
git clone https://www.github.com/erinyoung/CirculoCov

#map reads to ref and generate sorted bam file
pixi run minimap2 -x sr --sam -t 15 CirculoCov/tests/data/test.fasta CirculoCov/tests/data/test_R1.fastq.gz CirculoCov/tests/data/test_R2.fastq.gz | pixi run samtools view -b - | pixi run samtools sort -O BAM -o test.sorted.bam

#create bam_cov plot
pixi run samtools faidx CirculoCov/tests/data/test.fasta 
pixi run alignoth -b test.sorted.bam -r CirculoCov/tests/data/test.fasta -g 3:1-10000 >test.json
pixi run vl2svg test.json >test.svg
```

## using docker
```
docker pull community.wave.seqera.io/library/alignoth_vega-lite-cli:8ee850663b95c06d
git clone https://github.com/alignoth/alignoth
cd alignoth/tests/sample_1/
docker run -v $PWD:/home/work --rm community.wave.seqera.io/library/alignoth_vega-lite-cli:8ee850663b95c06d alignoth -b /home/work/reads.bam -r /home/work/reference.fa -g chr1:1-30 >sample_1.json
docker run -v $PWD:/home/work --rm community.wave.seqera.io/library/alignoth_vega-lite-cli:8ee850663b95c06d vl2svg /home/work/sample_1.json >sample_1.svg
```
