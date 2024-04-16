mkdir -p databases/melon
wget -q --show-progress https://figshare.com/ndownloader/files/42694969/database.tar.gz
tar -zxvf database.tar.gz -C databases/melon
# If you encounter memory issue please consider manually lowering cpu_count or simply set cpu_count=1
cpu_count=$(python -c 'import os; print(os.cpu_count())')
conda install -c bioconda -y minimap2
conda install -c bioconda -y diamond
diamond makedb --in databases/melon/database/prot.fa --db databases/melon/database/prot --quiet
ls databases/melon/database/nucl.*.fa | sort | xargs -P $cpu_count -I {} bash -c '
    filename=${1%.fa*}; \
    filename=${filename##*/}; \
    minimap2 -x map-ont -d databases/melon/database/$filename.mmi ${1} 2> /dev/null' - {}

## remove unnecessary files to save space
rm -rf databases/melon/database/*.fa
rm -rf database.tar.gz

## get example data
wget -q --show-progress https://figshare.com/ndownloader/files/42847672/example.fa.gz