process VIREO {
    tag "$meta.id"
    label 'process_low' //TOFLO set to medium

    //TOFLO no conda package for vireo yet!
    container "quay.io/heylf/vireo:0.5.8" //TOFLO Remove quay.io

    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "VIREO module does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    input:
    tuple val(meta), path("cellsnp_lite/${meta.id}")

    output:
    tuple val(meta), path("${meta.id}"), emit: outs
    path  "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def num_samples = params.num_samples ? params.num_samples : "2"
    def genotype =  params.genotype ? "-d ${params.genotype}" : ""
    """
    vireo -c cellsnp_lite/${meta.id} \\
        -o ${meta.id} \\
        -N $num_samples \\
        $genotype \\
        -p $task.cpus \\
        $args
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vireo: \$(echo \$( vireo --version 2>&1) | sed -E 's/.*v\\([0-9]+\\.[0-9]+\\.[0-9]+\\).*\$/\\1/' )
    END_VERSIONS
    """

    stub:
    """
    mkdir -p '${meta.id}'
    touch '${meta.id}'/fake_file.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vireo: \$(echo \$( vireo --version 2>&1) | sed -E 's/.*v\\([0-9]+\\.[0-9]+\\.[0-9]+\\).*\$/\\1/' )
    END_VERSIONS
    """
}
