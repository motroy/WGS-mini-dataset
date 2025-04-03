cp ../Basespace.download.20250319/04.chewie.Pfungorum_Israel.NCBI/03.extractCgMLST4/cgMLST100.tsv .
pixi run cgmlst-dists cgMLST100.tsv | sed -e 's@^cgmlst-dists@@1' > cgMLST100.distance.tab
cut -f 1,2 Basespace.download.20250114.Pfungorum_Israel.updated.metadata.v2.txt >Basespace.download.20250114.Pfungorum_Israel.updated.metadata.v2.cut.tsv
sed -i 's@ID\tgroup@sample\tgroup@g' Basespace.download.20250114.Pfungorum_Israel.updated.metadata.v2.cut.tsv 
pixi run python create.MST.v2.py -d cgMLST100.distance.tab -m Basespace.download.20250114.Pfungorum_Israel.updated.metadata.v2.cut.tsv -o cgMLST100.MST.png
