/*
 * Demultiplex h5ad
 */

include {CELLSNPLITE} from "../../modules/local/cellsnplite/main.nf"

// Define workflow to demultplex a h5ad file
workflow DEMULTIPLEX {
    take:
        ch_mtx_matrices

    main:
        CELLSNPLITE( ch_mtx_matrices )
        ch_versions = ch_versions.mix(CELLSNP.out.versions)

        /*
        VIREO( count_folder )
        ch_versions = ch_versions.mix(VIREO.out.versions)

        DEMULTIPLEXING
        ch_versions = ch_versions.mix(DEMULTIPLEXING.out.versions)
        */
    }
    emit:
        ch_versions
        demultiplex_out  = CELLSNPLITE.out.outs
}