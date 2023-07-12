process PLEXER {
    tag "demultiplexing"
    label 'process_low'

    //TOFLO no conda package for vireo yet!
    container "quay.io/heylf/plexer:0.1.0" //TOFLO Remove quay.io

    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "PLEXER module does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    input:
    tuple val(meta), path("${meta.id}/outs/*")
    tuple val(meta), path("${meta.id}")

    output:
    tuple val(meta), path("${meta.id}_demultiplexed_gex.h5ad"), emit: outs
    path  "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    plexer.py -c ${meta.id}/outs/filtered_feature_bc_matrix.h5 \\
        -i ${meta.id}/${meta.id}/donor_ids.tsv \\
        -o ${meta.id}_demultiplexed_gex.h5ad \\
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        plexer: \$(echo \$( plexer.py --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """

    stub:
    """
    touch '${meta.id}_fake_file.txt'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        plexer: \$(echo \$( plexer.py --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}
