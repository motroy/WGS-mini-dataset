rule all:
    input: # here's where you should list the FINAL files you're working toward
        'groupf.mst.png', '15.dist.tab', '15.metadata.tsv',

rule getDistanceMatrix:
    output:
        '15.dist.tab',
    container:
        'docker://quay.io/biocontainers/cgmlst-dists:0.4.0--h031d066_4'
    threads: 1
    resources:
        mem_mb=500,
        runtime=480,
    params:
        url='https://github.com/tseemann/cgmlst-dists/raw/master/test/100.tab',
    shell:
        """
            wget -q {params.url} && head -n 16 100.tab >15.tab
            cgmlst-dists 15.tab >15.dist.tab
        """
rule getClusters:
    input:
        distance_matrix='15.dist.tab', # you can name inputs and outputs
    output:
        '15.dist.gas.mcluster.output/thresholds.json', '15.dist.gas.mcluster.output/clusters.text',
    container:
        'docker://quay.io/biocontainers/genomic_address_service:0.1.1--pyh7cba7a3_1'
    threads: 4
    resources:
        mem_mb=2000,
        runtime=480,
    shell: # you can use multi-line commands if you need to
        """
            gas mcluster -i {input.distance_matrix} -o 15.dist.gas.mcluster.output -t 2000,1000,500,200,100,50,10,5,0
        """

rule getMetadata:
    input:
        clusters='15.dist.gas.mcluster.output/clusters.text', # you can name inputs and outputs
    output:
        '15.metadata.tsv',
    threads: 1
    resources:
        mem_mb=2000,
        runtime=480,
    shell: # you can use multi-line commands if you need to
        """
            cut -f 1,3 {input.clusters} | sed -e 's@id\tlevel_1@sample\tgroup@g' >15.metadata.tsv
        """

rule getMST:
    input:
        distance_matrix='15.dist.tab', # you can name inputs and outputs
        metadata='15.metadata.tsv',
    output:
        'groupf.mst.png',
    container:
        'docker://tomkellygenetics/r-igraph:latest'
    threads: 1
    resources:
        mem_mb=2000,
        runtime=480,
    shell: # you can use multi-line commands if you need to
        """
            Rscript createMST.R
        """

rule test_melon:
    input:
        assembly='example.fa.gz', # you can name inputs and outputs
    output:
        speciesID = "example.melon_output",
    container:
        'docker://quay.io/biocontainers/melon:0.1.3--pyhdfd78af_0'
    threads: 4
    resources:
        mem_mb=2000,
        runtime=480,
    shell:
        """
        melon -d /workspace/sandbox-2024/WGS-mini-dataset/databases/melon/database -o {output.speciesID} {input.assembly}
        """