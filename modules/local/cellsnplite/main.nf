process CELLSNPLITE {
    tag "$meta.id"
    label 'process_low' //TOFLO set to medium

    conda "bioconda::cellsnp-lite=1.2.3"
    container "quay.io/heylf/cellsnp-lite:1.2.3" //TOFLO Remove quay.io

    input:
    tuple val(meta), path("${meta.id}/outs/*")

    output:
    tuple val(meta), path("cellsnp_lite/${meta.id}"), emit: outs
    path  "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def umitag = params.umitag ? "--UMItag ${params.umitag}" : ""
    def genotpyes =  params.umitag ? "-R ${params.genotypes}" : ""
    """
    zcat '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv.gz > '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv

    mkdir -p cellsnp_lite/'${meta.id}'

    cellsnp-lite -s '${meta.id}'/outs/gex_possorted_bam.bam \\
        -b '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv \\
        -O cellsnp_lite/'${meta.id}' \\
        $genotpyes \\
        $umitag \\
        -p $task.cpus \\
        --gzip \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellsnp-lite: \$(echo \$( cellsnp-lite --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """

    stub:
    """
    mkdir -p cellsnp_lite/'${meta.id}'
    touch cellsnp_lite/'${meta.id}'/fake_file.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellsnp-lite: \$(echo \$( cellsnp-lite --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}
