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
        
def SRScurve(output_dir: str, table: biom.Table, metric: str = 'richness', step: int = 50,
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
              str(rarefy.comparison.legend), str(SRS.color), str(label), str(output_dir)]
        run_commands([cmd])
        
    #plot = os.path.join(output_dir,'plot.png')
    index = os.path.join(output_dir, 'index.html')
        
    with open(index, 'w') as fh:
        fh.write('<!DOCTYPE html><head></head><body><img src="SRScurve_plot.png" style="max-width: 100vw;max-height: 100vh;object-fit: contain" /></body></html>')
