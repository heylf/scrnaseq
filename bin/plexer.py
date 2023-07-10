#!/usr/bin/env python
import argparse
import muon as mu
import pandas as pd
import anndata as ad
import numpy as np

if __name__ == "__main__":

    print("[START]")

    parser = argparse.ArgumentParser(description="Generate the lib.csv for cellranger-arc.")

    parser.add_argument("-c", "--cellranger", dest="cellranger", help="Input path from cellranger-arc.")
    parser.add_argument("-v", "--vireo", dest="vireo", help="Input path from vireo.")
    parser.add_argument("-o", "--out", dest="out", help="Output path.", default = "./demultiplexed_gex.h5ad")

    args = vars(parser.parse_args())

    print(args)

    #######################
    ###### LOAD DATA ######
    #######################
    # This will get us the data from cellranger-arc
    print("[TASK] Load data")

    # /home/florian/Documents/tmp_data_folder/output/cellrangerarc/count/test_scARC/outs/filtered_feature_bc_matrix.h5
    h5 = mu.read_10x_h5(args["cellranger"])
    rna = h5["rna"]
    #atac = h5["atac"]

    ############################
    ###### DEMULTIPLEXING ######
    ############################
    print("[TASK] Demultiplexing")

    # "/home/florian/Documents/tmp_data_folder/output/vireo/test_scARC/donor_ids.tsv"
    ass = pd.read_table(args["vireo"])[["cell", "donor_id"]]
    ass.set_index("cell", inplace=True)

    rna.obs = rna.obs.join(ass, how="left")
    #atac.obs = atac.obs.join(ass, how="left")

    # /home/florian/Documents/tmp_data_folder/output/test_ARC_demultiplexed_gex.h5ad
    rna.write_h5ad(args["out"], compression="gzip", compression_opts=9)

    # TOFLO atac content cannot be demultiplexed right now because of 
    # TypeError: No method has been defined for writing <class 'collections.OrderedDict'> elements to <class 'h5py._hl.group.Group'>
    # atac.write_h5ad(f"/home/florian/Documents/tmp_data_folder/output/test_ARC_demultiplexed_atac.h5ad", compression="gzip", compression_opts=9)
    print("[FINISH] Wrote out h5ad")