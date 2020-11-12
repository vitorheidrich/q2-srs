# q2-srs

QIIME2 plugin for microbiome count data normalization by scaling with ranked subsampling (SRS).

Read more about the normalization method in the SRS [paper](https://doi.org/10.7717/peerj.9593) (Beule and Karlovsky, PeerJ 2020).
<!---To more details on the usage of SRS, take a look at the practical guide [paper]() ().--->

## Installing

Activate your `qiime2` environment by running (or equivalent):
```
conda activate qiime2-2020.8
```
To install q2-srs plugin from conda, run:
```
conda install -c vitorheidrich q2_srs
```
To install manually, clone this repository to your computer, `cd` into the main directory, and run:
```
python setup.py install
```
Check for a sucessful installation by running `qiime srs`. A description of the q2-srs plugin should show up.

## Using

q2-srs features two `qiime` commands:
* `qiime srs SRS` - performs SRS normalization at a user-defined number of reads per sample
* `qiime srs SRScurve` - draws alpha diversity rarefaction curves for SRS-normalized data (instead of rarefied data) at varying sequencing depths

To see the full options of each command run `qiime srs SRS --help` or `qiime srs SRScurve --help`.

We also encourage you to explore the [SRS Shiny app](), that is specifically designed for q2-srs users.

### Normalizing your data using SRS
In the following examples we are going to use the ASV table (DADA2 output) from the Moving Pictures [tutorial](https://docs.qiime2.org/2020.8/tutorials/moving-pictures/). This table is summarized below:
<!---INCLUDE OUTPUT--->

In order to normalize your samples to the same number of reads per sample using SRS, we recommend running `SRScurve` first in order to determine a good normalization cut-off for your data. This normalization cut-off is called C<sub>min</sub> (check the SRS [paper](https://doi.org/10.7717/peerj.9593) for details). Once you have chosen an adequate C<sub>min</sub>, run `SRS` with the C<sub>min</sub> that suits your data. The output of `SRS` will be an OTU/ASV table SRS-normalized at C<sub>min</sub> reads per sample that is ready for the next steps of your pipeline.

Alternatively (and complementarily), we strongly advise for the use of the [SRS Shiny app for the determination of C<sub>min</sub>]() <!-- (check the SRS practical guide [paper](https://doi.org/10.7717/peerj.9593) for details)--> to help with your decision. Just upload your ASV/OTU table (.qza) and the app will provide:
* A rug plot of the read counts per sample
* A simpler SRScurve plot (use the q2-srs SRScurve for the full experience)
* Summary statistics on trade-offs between C<sub>min</sub> and the number of retained samples
* Summary statistics on trade-offs between C<sub>min</sub> and the diversity retained per sample

#### 1) Running SRScurve
To run `SRScurve` the only required input is the OTU/ASV table. However, `SRScurve` is highly customizable, allowing different alpha diversity indices, a comparison with repeated rarefying and many other analytical/aesthetic options<!-- (check the SRS practical guide [paper](https://doi.org/10.7717/peerj.9593) for details)-->. Please run `qiime srs SRScurve --help` to see the full options.

`SRScurve` usage example with the `table.qza` from the `example_data` folder (check `table.qzv` for details):
```
qiime srs SRScurve \
  --i-table example_data/table.qza \
  --p-metric 'shannon' \
  --p-rarefy-comparison \
  --p-SRS-color 'blue' \
  --p-rarefy-color 'grey' \
  --p-sample 1103 \
  --o-visualization example_data/SRScurve-plot.qzv
```
<!---INCLUDE OUTPUT--->
In the Moving Pictures [tutorial](https://docs.qiime2.org/2020.8/tutorials/moving-pictures/) the samples were normalized by rarefying to 1103 reads, that is why we are comparing rarefying with SRS normalization at this specific sequencing depth by using `--p-rarefy-comprison` and `--p-sample 1103`. In particular, we see that, in this example, SRS normalization consistently retain a higher level of diversity in comparison with rarefying. Therefore, if 1103 reads was considered a good normalization cut-off previously for normalization by rarefying, when normalizing by SRS this cut-off will be even better! So let's use it as our C<sub>min</sub>.

#### 2) Running SRS
To run `SRS` the only required input is the OTU/ASV table and the chosen C<sub>min</sub>. Please run `qiime srs SRS --help` to see the full options.

`SRS` usage example with the `table.qza` from the `example_data` folder and the C<sub>min</sub> as determined above:
```
qiime srs SRS \
  --i-table example_data/table.qza \
  --p-c-min XXX \
  --o-normalized-table example_data/norm-table.qza
```
Finally, we can confirm that all samples ended up with the same number of reads in the SRS-normalized artifact by running:
```
qiime feature-table summarize \
  --i-table example_data/norm-table.qza \
  --o-visualization example_data/norm-table.qzv
```
<!---INCLUDE OUTPUT--->
##### Citing
If you use this plugin in your research paper, please cite as:

Beule L, Karlovsky P. 2020. Improved normalization of species count data in ecology by scaling with ranked subsampling (SRS): application to microbial communities. [*PeerJ* 8:e9593](https://doi.org/10.7717/peerj.9593)
<!---Change the proposed cite to the practical guide later--->

##### Thanking
We would like to thank Claire Duvallet (@cduvallet) for her great [tutorial](https://cduvallet.github.io/posts/2018/03/qiime2-plugin) on how to build a QIIME2 plugin.
