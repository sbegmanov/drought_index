## Useful commands used in this project (used git bash command, parallelly cmd on VS code)
# creating yml environment (called drought):
mamba env create -f environment.yml
conda activate drought
conda env list
conda deactivate
mamba env remove --name drought
mamba env update -f environment.yml
# Worked on Windows
conda install -c conda-forge m2-coreutils
mamba install -c conda-forge m2-wget=1.25.0.1 (Windows, but wget did not work, used curl -L -o data\ghcnd_all.tar.gz https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd_all.tar.gz)
mamba install -c conda-forge r-showtext
# split tar.gz files
split -n 40 data/ghcnd_all.tar.gz
rm x*
split -b 40000000 data/ghcnd_all.tar.gz
ls x*
wc -l x*
ls x* | wc -l
ls ./map_tempdir/| wc -l
ls -lht x*
ls -lth x*
split -l 1000 data/ghcnd_all_files.txt
head xaa or xaab
cat README.md
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
chmod +x code/read_split_dly_files.R

# number of temp files
ls -lth data/temp | wc -l
grep "ANN ARBOR" data/ghcnd-stations.txt

# check if files executable
ls -lth code/get_ghcnd_stations.bash

## Snakemake cmds
mamba install -c conda-forge -c bioconda snakemake
snakemake --dry-run get_all_archive
snakemake -np get_all_archive
snakemake -np get_all_filenames
snakemake -np get_inventory
# for ouput targets
snakemake -np 
# what jobs executed in the project
snakemake -c 1 
mamba install -c conda-forge graphviz
snakemake --dag targets | dot -Tpng > dag.png
rm dag.png
snakmake -R get_all_archive get_inventory get_station_data -c1

# Work with tar.gz with a sample
tar xvzf data/ghcnd_all.tar.gz ghcnd_all/US1IACW005.dly
ls ghcnd_all/US1IACW005.dly 
tar cvzf practice.tar.gz ghcnd_all
tar tvf practice.tar.gz
head ghcnd_all/US1IACW005.dly
tar Oxvzf practive.tar.gz > practice.ouput

gzip -f practice.output
gzip -k practice.output
gunzip practice.output.gz
wc ghcnd_all/US1IACW005.dly
ls ghcnd_all/ | wc -l

## Useful Git commands
git status
# commit all, use rarely
git add . 
git add environment.yml
git commit -m "Comments"
# change comments in project
git commit --amend 
# add text file
touch data/text.txt 
rm data/text.txt
git push
git push --force
git log
git log --online
git log --pretty=oneline
git log --pretty=format:"%h"
git log --pretty=format:"%H"
git log --pretty=format:"%h %ai"
git log --pretty=format:"%h %ai %s"
git log --pretty=format:"%h %ai %s" --after "2025-12-30" visuals/world_drought.png > logt.txt
git rebase -i a811842 #commited id (pick squash)
# used to remove .snakemake from github website.
git rm -r --cached .snakemake/
git commit -m "Remove .snakemake"
git push origin main
git cat-file -p cd835d7:visuals/world_drought_on_2025_data.png > map_tempdir/2025-03-01.png
# remove folder
rm -rf folder/

# rename the file:
git mv code/read_dly_files.R code/read_split_dly_files.R
## File extraction
tar xvzf data/ghcnd_all.tar.gz -C data/
rm -rf data/ghcnd_all
# extract only 3 dly files
tar xvzf data/ghcnd_all.tar.gz -C data/ ghcnd_all/ASN00010727.dly ghcnd_all/ASN00010732.dly ghcnd_all/ASN00010738.dly
ls data/ghcnd_all

# some trick on R
composite <- .Last.value
count(composite, ID)

# for HTML page
mamba install -c conda-forge r-markdown
R -e "library(rmarkdown); render('index.Rmd')"
open index.html