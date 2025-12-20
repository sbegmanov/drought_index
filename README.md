# drought_index
Study on world drought. Based on Riffomonas Project YouTube Channel


## data sources
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
