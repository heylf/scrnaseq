process CELLSNPLITE {
    tag "$meta.id"
    label 'process_medium' //TOFLO set to medium

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
    def genotpye =  params.genotpye ? "-R ${params.genotype}" : ""
    def chrom =  params.chrom ? "--chrom ${params.chrom}" : ""
    """
    zcat '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv.gz > '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv

    mkdir -p cellsnp_lite/'${meta.id}'

    cellsnp-lite -s '${meta.id}'/outs/gex_possorted_bam.bam \\
        -b '${meta.id}'/outs/filtered_feature_bc_matrix/barcodes.tsv \\
        -O cellsnp_lite/'${meta.id}' \\
        $genotpye \\
        $umitag \\
        $chrom \\
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
