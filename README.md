# q2-srs

QIIME2 plugin for microbiome count data normalization by scaling with ranked subsampling (SRS).

Read more about the normalization method in the SRS [paper](https://doi.org/10.7717/peerj.9593) (Beule and Karlovsky, PeerJ 2020).
<!---To more details on the usage of SRS, take a look at the practical guide [paper]() ().--->

# Installing

To install q2-srs plugin from conda, run:
```
conda install -c vitorheidrich q2_srs
```
To install manually, clone this repository to your computer, `cd` into the main directory, and run:
```
python setup.py install
```
Check for a sucessful installation by running `qiime srs` from an active `qiime2` environment. A description of the q2-srs plugin and its commands should show up.

# Using

q2-srs features two `qiime` commands:
* `qiime srs SRS` - performs SRS normalization at a user-defined number of reads per sample
* `qiime srs SRScurve` - draws alpha diversity rarefaction curves for SRS normalized data (instead of rarefied data) at varying sequencing depths

To see the full options of each command run `qiime srs SRS --help` or `qiime srs SRScurve --help`.

## Normalizing your data using SRS

In order to normalize your samples to the same number of reads per sample using SRS, we recommend running `SRScurve` first in order to determine a good normalization cut-off for your data. This normalization cut-off is called C<sub>min</sub> (check the SRS [paper](https://doi.org/10.7717/peerj.9593) for details). Once you have chosen an adequate C<sub>min</sub>, run `SRS` with the C<sub>min</sub> that suits your data. The output of `SRS` will be an OTU/ASV table SRS normalized at C<sub>min</sub> reads per sample ready for the next steps of your pipeline.

### Running SRScurve
To run `SRScurve` the only required input is the OTU/ASV table. However, `SRScurve` is highly customizable, allowing different alpha diversity indices, a comparison with repeated rarefying and many other analytical/aesthetic features <!---(check the SRS practical guide [paper](https://doi.org/10.7717/peerj.9593) for details)--->. Please run `qiime srs SRScurve --help` to see the full options. 
Usage example with the `table.qza` from the `test_data` folder:
```
qiime srs SRScurve \
  --i-table test_data/table.qza \
  --p-metric "shannon" \
  --p-rarefy-comparison \
  --p-SRS-color "blue" \
  --p-rarefy-color "grey \
  --o-output-dir test_data/results
```
### Running SRS
To run `SRS` the only required input is the OTU/ASV table and the chosen C<sub>min</sub> (based on SRScurve output). Please run `qiime srs SRS --help` to see the full options.  
Usage example with the `table.qza` from the `test_data` folder:
```
qiime srs SRS \
  --i-table test_data/table.qza \
  --p-c-min 450 \
  --o-normalized test_data/norm-table.qza
```
#### Citing
If you use this plugin in your research paper, please cite as:

Beule L, Karlovsky P. 2020. Improved normalization of species count data in ecology by scaling with ranked subsampling (SRS): application to microbial communities. [*PeerJ* 8:e9593](https://doi.org/10.7717/peerj.9593)
<!---Change the proposed cite to the practical guide later--->

#### Thanking
We would like to thank Claire Duvallet (@cduvallet) for her great [tutorial](https://cduvallet.github.io/posts/2018/03/qiime2-plugin) on how to build a QIIME2 plugin.
