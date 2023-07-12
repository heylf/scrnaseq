#!/usr/bin/env python
import argparse
import muon as mu
import pandas as pd

if __name__ == "__main__":
    
    ####################
    ##   ARGS INPUT   ##
    ####################

    tool_description = """
    The tool adds demultiplexing information to the output of cellranger-arc (h5) by using output from cellsnp-lite+vireo.
    """

    # parse command line arguments
    parser = argparse.ArgumentParser(description=tool_description,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    # version
    parser.add_argument(
        "-v", "--version", action="version", version="%(prog)s 0.1.0")

    parser.add_argument("-c", "--cellranger", 
                        dest="cellranger", 
                        metavar='*.h5', 
                        required=True, 
                        help="Input path from cellranger-arc.")
    parser.add_argument("-i", "--vireo", 
                        metavar='*.tsv', 
                        required=True, 
                        dest="vireo", 
                        help="Input path from vireo.")
    parser.add_argument("-o", "--out", 
                        metavar='*.h5/*.h5ad', 
                        required=True, 
                        dest="out", 
                        help="Output path.", 
                        default = "./demultiplexed_gex.h5ad")

    args = vars(parser.parse_args())

    print(args)

    #######################
    ###### LOAD DATA ######
    #######################
    # This will get us the data from cellranger-arc
    print("[START]")
    print("[TASK] Load data")

    h5 = mu.read_10x_h5(args["cellranger"])
    rna = h5["rna"]
    #atac = h5["atac"]

    ############################
    ###### DEMULTIPLEXING ######
    ############################
    print("[TASK] Demultiplexing")

    ass = pd.read_table(args["vireo"])[["cell", "donor_id"]]
    ass.set_index("cell", inplace=True)

    rna.obs = rna.obs.join(ass, how="left")
    #atac.obs = atac.obs.join(ass, how="left")

    rna.write_h5ad(args["out"], compression="gzip", compression_opts=9)

    # TOFLO atac content cannot be demultiplexed right now because of 
    # TypeError: No method has been defined for writing <class 'collections.OrderedDict'> elements to <class 'h5py._hl.group.Group'>
    #atac.write_h5ad("output/test_ARC_demultiplexed_atac.h5ad", compression="gzip", compression_opts=9)
    print("[FINISH] Wrote out h5ad")