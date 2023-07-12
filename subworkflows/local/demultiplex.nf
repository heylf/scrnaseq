/*
 * Demultiplex h5ad
 */

include {CELLSNPLITE} from "../../modules/local/cellsnplite/main.nf"
include {VIREO} from "../../modules/local/vireo/main.nf"
include {PLEXER} from "../../modules/local/plexer/main.nf"

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

        PLEXER( ch_mtx_matrices, 
                VIREO.out.outs )
        ch_versions = ch_versions.mix(PLEXER.out.versions)
    emit:
        ch_versions
        demultiplex_out  = PLEXER.out.outs
}