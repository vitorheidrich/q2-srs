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


TEMPLATES = pkg_resources.resource_filename('q2_srs', 'assets')

def run_commands(cmds, verbose=True):
    if verbose:
        print("Running external command line application(s). This may print "
              "messages to stdout and/or stderr.")
        #print("The command(s) being run are below. These commands cannot "
        #      "be manually re-run as they will depend on temporary files that "
        #      "no longer exist.")
    for cmd in cmds:
        #if verbose:
        #    print("\nCommand:", end=' ')
        #    print(" ".join(cmd), end='\n\n')
        subprocess.run(cmd, check=True)
        
def SRScurve(table: biom.Table, metric: str = 'richness', step: int = 50,
            sample: int = 0, max.sample.size: int = 0, rarefy.comparison: bool = False,
            rarefy.repeats: int = 10, rarefy.comparison.legend: bool = False, SRS.color: str = 'black', 
            rarefy.color: str = 'red', SRS.linetype: str = 'solid', rarefy.linetype: str = 'solid', label: bool = False) -> None:
    if table.is_empty():
        raise ValueError("The provided table object is empty")
    
    #normalized_table = biom.Table()
    
    ## run the R script on the file
    with tempfile.TemporaryDirectory() as temp_dir_name:

        ## write the biom table to file
        input_name = os.path.join(temp_dir_name, 'table.tsv')
        with open(input_name, 'w') as fh:
            fh.write(table.to_tsv())

        cmd = ['SRScurve.R', input_name, str(metric), str(step), str(sample),
              str(max.sample.size), str(rarefy.comparison), str(rarefy.repeats),
              str(rarefy.comparison.legend), str(SRS.color), str(label)]
        run_commands([cmd])
        #norm_table_df = pd.read_csv(input_name, sep='\t')
        
    #norm_table_biom = biom.Table(data=norm_table_df.values,
                                 observation_ids=norm_table_df.index,
                                 sample_ids=norm_table_df.columns)
    #return norm_table_biom
