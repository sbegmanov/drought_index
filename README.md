# drought_index
Study on world drought. Based on Riffomonas Project YouTube Channel


## data sources (noaa ghcn daily)
https://www.ncei.noaa.gov/pub/data/ghcn/daily/

## Useful commands used in this project
# creating yml environment (called drought):
mamba env create -f environment.yml
conda activate drought
conda env list
conda deactivate
mamba env remove --name drought

mamba install -c conda-forge m2-wget=1.25.0.1 (Windows, but wget did nott work, used curl -L -o data\ghcnd_all.tar.gz https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd_all.tar.gz)

# bash commands (windows):
# check commands workable in bash format files
bash code/get_ghcnd_all.bash 

# execute bash file in the current directory
./driver.bash 

# check extracted file head
head data/ghcnd_all_files.txt

# check line length
wc -l data/ghcnd_all_files.txt 

# make files executable
chmod +x code/get_ghcnd_all.bash
chmod +x code/get_ghcnd_stations.bash

# check if files executable
ls -lth code 

## Snakemake cmds
mamba install -c conda-forge -c bioconda snakemake
snakemake --dry-run get_all_archive
snakemake -np get_all_archive
snakemake -np get_all_filenames
snakemake -np get_inventory
snakemake -np (for ouput targets)
snakemake -c 1 (what jobs executed in the project)
mamba install -c conda-forge graphviz
snakemake --dag targets | dot -Tpng > dag.png
rm dag.png

## Useful Git commands
git status
git add . (commit all, use rarely)
git add environment.yml
git commit -m "Comment"
git commit --amend (for change comments)
touch data/text.txt (add text file)
rm data/text.txt
git push
# used to remove .snakemake from github website.
git rm -r --cached .snakemake/
git commit -m "Remove .snakemake"
git push origin main

