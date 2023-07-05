/*
 * Demultiplex h5ad
 */

include {CELLSNPLITE} from "../../modules/local/cellsnplite/main.nf"
include {VIREO} from "../../modules/local/vireo/main.nf"

// Define workflow to demultplex a h5ad file
workflow DEMULTIPLEX {
    take:
        ch_mtx_matrices

    main:
        ch_versions = Channel.empty()

        CELLSNPLITE( ch_mtx_matrices )
        ch_versions = ch_versions.mix(CELLSNPLITE.out.versions)

        VIREO( CELLSNPLITE.out.outs )
        ch_versions = ch_versions.mix(VIREO.out.versions)

        /*
        DEMULTIPLEXING
        ch_versions = ch_versions.mix(DEMULTIPLEXING.out.versions)
        */
    emit:
        ch_versions
        demultiplex_out  = VIREO.out.outs
}

/*

WARN: Access to undefined parameter `enable_conda` -- Initialise it to a default value eg. `params.enable_conda = some_value`
WARN: There's no process matching config selector: NFCORE_SCRNASEQ:SCRNASEQ:SCRNASEQ_ALEVIN:ALEVINQC
WARN: Failed to publish file: /home/florian/Documents/GHGA/work/05/c4f501dafe24b3e9311717fd182772/config; to: /home/florian/Documents/tmp_data_folder/output/cellrangerarc/config/config [copy] -- See log file for details
WARN: Failed to publish file: /home/florian/Documents/GHGA/work/05/c4f501dafe24b3e9311717fd182772/versions.yml; to: /home/florian/Documents/tmp_data_folder/output/cellrangerarc/config/versions.yml [copy] -- See log file for details

*/