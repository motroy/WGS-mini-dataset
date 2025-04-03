#install pixi and initialise env (use provided pixi.toml for quick setup)
#curl -fsSL https://pixi.sh/install.sh | sh

#download test data (chewBBACA extractCgMLST output)
wget -q https://github.com/tseemann/cgmlst-dists/raw/master/test/100.tab
#generate distance matrix
pixi run cgmlst-dists 100.tab | sed -e 's@^cgmlst-dists@@1' > 100.distance.tab
#assign clusters
pixi run gas mcluster -i 100.distance.tab -o 100.dist.gas.mcluster.output -t 2000,1000,500,200,100,50,10,5,0
#generate metadata from assigned clusters
cut -f 1,3 100.dist.gas.mcluster.output/clusters.text >100.metadata.tsv
sed -i 's@id\tlevel_1@sample\tgroup@g' 100.metadata.tsv

#generate cgMLST MST plot (as png)
pixi run python create.MST.v1.py -d 100.distance.tab -m 100.metadata.tsv -o 100.dist.gas.mcluster.MST.v2.png