rule targets:
    input:
        "ghcnd_all.tar.gz",
        "ghcnd_all_files.txt",
        "ghcnd-inventory.txt",
        "ghcnd-stations.txt"

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