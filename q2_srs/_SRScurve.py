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

# We used the q2-breakaway/q2_breakaway/_alphas.py as inspiration to learn how to make a R script be triggered by a python command. So thank you Amy Willis

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
            sample: int = 0, max_sample_size: int = 0, rarefy_comparison: bool = False,
            rarefy_repeats: int = 10, rarefy_comparison_legend: bool = False, SRS_color: str = 'black', 
            rarefy_color: str = 'red', SRS_linetype: str = 'solid', rarefy_linetype: str = 'longdash', label: bool = False) -> None:
    if table.is_empty():
        raise ValueError("The provided table object is empty")
    
    ## run the R script on the file
    with tempfile.TemporaryDirectory() as temp_dir_name:

        ## write the biom table to file
        input_name = os.path.join(temp_dir_name, 'table.tsv')
        with open(input_name, 'w') as fh:
            fh.write(table.to_tsv())

        cmd = ['SRScurve.R', input_name, str(metric), str(step), str(sample),
              str(max_sample_size), str(rarefy_comparison), str(rarefy_repeats),
              str(rarefy_comparison_legend), str(SRS_color), str(rarefy_color), 
              str(SRS_linetype), str(rarefy_linetype), str(label), str(output_dir)]
        run_commands([cmd])
        
    #plot = os.path.join(output_dir,'plot.png')
    index = os.path.join(output_dir, 'index.html')
        
    with open(index, 'w') as fh:
        fh.write('<!DOCTYPE html><head></head><body><img src="SRScurve_plot.png" style="max-width: 100vw;max-height: 100vh;object-fit: contain" /></body></html>')
