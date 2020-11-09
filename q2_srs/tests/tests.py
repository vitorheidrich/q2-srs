import os
import tempfile
import hashlib
import subprocess
import pkg_resources

import biom
import skbio
import qiime2.util
import pandas as pd
import q2templates

def check_format(table: biom.Table):
    
    ## run the R script on the file
    #with tempfile.TemporaryDirectory() as temp_dir_name:

        ## write the biom table to file
    #input_name = os.path.join('q2_srs/tests/', 'table.tsv')
    with open('q2_srs/tests/table.tsv', 'w') as fh:
        fh.write(table.to_tsv())
            
    return()
            
          
check_format(biom.load_table("q2_srs/tests/feature-table.biom"))
