## install pigz and use for combining of LR runs
#sudo apt update && sudo apt install -y pigz
#zcat fastq/SAMEA3181514/LR/ERR1341570/ERR1341570.fastq.gz fastq/SAMEA3181514/LR/ERR1341571/ERR1341571.fastq.gz >fastq/SAMEA3181514/LR/combined.fastq && pigz fastq/SAMEA3181514/LR/combined.fastq
#zcat fastq/SAMEA3726392/LR/ERR1341572/ERR1341572.fastq.gz fastq/SAMEA3726392/LR/ERR1341573/ERR1341573.fastq.gz >fastq/SAMEA3726392/LR/combined.fastq && pigz fastq/SAMEA3726392/LR/combined.fastq

## flye with polishing
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/dragonflye:1.1.1--hdfd78af_0 dragonflye --threads 10 --gsize 5.5M --reads /data/fastq/SAMEA3181514/LR/combined.fastq.gz --R1 /data/fastq/SAMEA3181514/SR/ERR885453/ERR885453_1.fastq.gz --R2 /data/fastq/SAMEA3181514/SR/ERR885453/ERR885453_2.fastq.gz --outdir /data/test.data.results/SAMEA3181514.dragonflye.polished --pilon 2 --force
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/dragonflye:1.1.1--hdfd78af_0 dragonflye --threads 10 --gsize 5.5M --reads /data/fastq/SAMEA3726392/LR/combined.fastq.gz --R1 /data/fastq/SAMEA3726392/SR/ERR1539195/ERR1539195_1.fastq.gz --R2 /data/fastq/SAMEA3726392/SR/ERR1539195/ERR1539195_2.fastq.gz --outdir /data/test.data.results/SAMEA3726392.dragonflye.polished --pilon 2
## split flye polished assemblies' contigs
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit split -i /data/test.data.results/SAMEA3181514.dragonflye.polished/contigs.fa
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit split -i /data/test.data.results/SAMEA3726392.dragonflye.polished/contigs.fa

## compare flye polished assemblies to eachother using mashtree
#find test.data.results/*.dragonflye.polished/contigs.fa.split/ -type f | sort >fof.list
#sed -i 's@^@/data/@g' fof.list
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit stat -a -T --infile-list /data/fof.list > dragonflye.polished.contigs.stats.tsv

#docker run --rm -v $PWD:/data/ quay.io/biocontainers/mashtree:1.2.0--pl5321h031d066_2 mashtree --file-of-files /data/fof.list --numcpus 8 --genomesize 50000 --outtree /data/test.tre --outmatrix /data/test.matrix.tsv 

## miniasm without polishing
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/dragonflye:1.1.1--hdfd78af_0 dragonflye --assembler miniasm --cpus 10 --gsize 5.5M --reads /data/fastq/SAMEA3181514/LR/combined.fastq.gz --outdir /data/test.data.results/SAMEA3181514.dragonflye.miniasm
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/dragonflye:1.1.1--hdfd78af_0 dragonflye --assembler miniasm --cpus 10 --gsize 5.5M --reads /data/fastq/SAMEA3726392/LR/combined.fastq.gz --outdir /data/test.data.results/SAMEA3726392.dragonflye.miniasm
## split miniasm assemblies' contigs
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit split -i /data/test.data.results/SAMEA3181514.dragonflye.miniasm/contigs.fa --by-id-prefix SAMEA3181514.dragonflye.miniasm.
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit split -i /data/test.data.results/SAMEA3726392.dragonflye.miniasm/contigs.fa --by-id-prefix SAMEA3726392.dragonflye.miniasm.
##contig stats
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit stat -a -T test.data.results/SAMEA3181514.dragonflye.miniasm/contigs.fa.split/*.fa > test.data.results/SAMEA3181514.dragonflye.miniasm.contigs.stats.tsv
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit stat -a -T test.data.results/SAMEA3726392.dragonflye.miniasm/contigs.fa.split/*.fa > test.data.results/SAMEA3726392.dragonflye.miniasm.contigs.stats.tsv

#find test.data.results/*.dragonflye.miniasm/contigs.fa.split/ -type f | sort >miniasm.fof.list
#sed -i 's@^@/data/@g' miniasm.fof.list
#docker run --rm -v $PWD:/data/ quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0 seqkit stat -a -T --infile-list /data/miniasm.fof.list > miniasm.contigs.stats.tsv

##resistome and plasmidome
#docker run -v $PWD:/data/ quay.io/biocontainers/abricate:1.0.1--ha8f3691_1 abricate --db card --minid 60 --mincov 60 --fofn /data/miniasm.fof.list > miniasm.contigs.abr.card.60.60.tsv
#docker run -v $PWD:/data/ quay.io/biocontainers/abricate:1.0.1--ha8f3691_1 abricate --db plasmidfinder --minid 60 --mincov 60 --fofn /data/miniasm.fof.list > miniasm.contigs.abr.plasmidfinder.60.60.tsv

#docker run --rm -v $PWD:/data/ quay.io/biocontainers/mashtree:1.2.0--pl5321h031d066_2 mashtree --file-of-files /data/miniasm.fof.list --numcpus 8 --genomesize 50000 --outtree /data/miniasm.tre --outmatrix /data/miniasm.matrix.tsv 