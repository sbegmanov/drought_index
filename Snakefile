
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
        "visuals/world_drought_on_2025_data.png"

rule get_all_archive:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
         "ghcnd_all.tar.gz"
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
    shell:
        """
        {input.script}
        """

rule get_inventory:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
        "ghcnd-inventory.txt"
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
    shell:
        """
        {input.r_script}
        """