
rule targets:
    input:
        "ghcnd_all.tar.gz",
        "ghcnd_all_files.txt",
        "ghcnd-inventory.txt",
        "ghcnd-stations.txt",
        "ghcnd_tidy.tsv.gz",
        "ghcnd_cat.gz",
        "ghcnd_regions.tsv",
        "ghcnd_regions_years.tsv",
        "visuals/world_drought_on_2025_data.png",
         "index.html"

rule get_all_archive:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
         "ghcnd_all.tar.gz"
    conda:
        "environment.yml"
    params:
        file = "ghcnd_all.tar.gz"
    shell:
        """
        {input.script} {params.file}
        """
rule pipe:
    input:
        script = "code/pipe.bash",
        tarball = "data/ghcnd_all.tar.gz"
    output:
        "ghcnd_cat.gz"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """

rule get_all_filenames:
    input:
        script = "code/get_ghcnd_all_files.bash",
        archive = "ghcnd_all.tar.gz"
    output:
        "ghcnd_all_files.txt"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """

rule get_inventory:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
        "ghcnd-inventory.txt"
    conda:
        "environment.yml"
    params:
        file = "ghcnd-inventory.txt"
    shell:
        """
        {input.script} {params.file}
        """

rule get_station_data:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
        "ghcnd-stations.txt"
    conda:
        "environment.yml"
    params:
        file = "ghcnd-stations.txt"
    shell:
        """
        {input.script} {params.file}
        """

rule concatenate_dly_files:
    input:
        script = "code/concatenate_dly.bash",
        tarball = "ghcnd_all.tar.gz"
    output:
        "ghcnd_cat.fwf.gz"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}

        """
rule summarize_dly_files:
    input:
        bash_script = "code/concatenate_dly.bash",
        r_script = "code/read_split_dly_files.R",
        tarball = "ghcnd_all.tar.gz"
    output:
        "ghcnd_tidy.tsv.gz"
    conda:
        "environment.yml"
    shell:
        """
        {input.bash_script}
        """

rule aggregate_stations:
    input:
        r_script = "code/merge_lat_long.R",
        data = "data/ghcnd-stations.txt",
    output:
        "ghcnd_regions.tsv"
    conda:
        "environment.yml"
    shell:
        """
        {input.r_script}
        """
rule get_regions_years:
    input:
        r_script = "code/get_regions_years.R",
        data = "data/ghcnd-inventory.txt",
    output:
        "ghcnd_regions_years.tsv"
    conda:
        "environment.yml"
    shell:
        """
        {input.r_script}
        """
rule plot_drought_by_region:
    input:
        r_script = "code/merge_weather_station_data.R",
        prcp_data = "data/ghcnd_tidy.tsv.gz",
        station_data = "data/gchnd_regions_years.tsv"
    output:
        "visuals/world_drought_on_2025_data.png"
    conda:
        "environment.yml"
    shell:
        """
        {input.r_script}
        """

rule render_index:
    input:
        rmd = "index.Rmd",
        png = "visuals/world_drought_on_2025_data.png",
    output:
        "index.html"
    conda:
        "environment.yml"
    shell:
        """
        R -e "library(rmarkdown); render('{input.rmd}')"
        """
