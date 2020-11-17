# q2-srs

QIIME2 plugin for microbiome count data normalization by scaling with ranked subsampling (SRS).

Read more about the normalization method in the SRS [paper](https://doi.org/10.7717/peerj.9593) (Beule and Karlovsky, PeerJ 2020).
<!---To more details on the usage of SRS, take a look at the practical guide [paper]() ().--->

## Installing

Activate your `qiime2` environment by running (or equivalent):
```
conda activate qiime2-2020.8
```
* Option 1: To install q2-srs plugin from conda, run:
```
conda install -c vitorheidrich q2_srs
```
* Option 2: To install manually, clone this repository to your computer, `cd` into the main directory, and run the python installation:
```
git repo https://github.com/vitorheidrich/q2-srs
cd q2-srs
python setup.py install
```
Check for a sucessful installation by running `qiime srs`. A description of the q2-srs plugin should show up.

## Using

q2-srs features two `qiime` commands:
* `qiime srs SRS` - performs SRS normalization at a user-defined number of reads per sample
* `qiime srs SRScurve` - draws alpha diversity rarefaction curves for SRS-normalized data (instead of rarefied data) at varying sequencing depths

To see the full options of each command run `qiime srs SRS --help` or `qiime srs SRScurve --help`.

We also encourage you to explore the [SRS Shiny app](), that is specifically designed for q2-srs users.

### Usage recommendations

In order to normalize your samples to the same number of reads using SRS, we recommend running `SRScurve` first so you can determine a good normalization cut-off for your data. This normalization cut-off is called C<sub>min</sub> (check the SRS [paper](https://doi.org/10.7717/peerj.9593) for details). 

Alternatively (and complementarily) to `SRScurve`, we strongly advise for the use of the [SRS Shiny app for the determination of C<sub>min</sub>]()<!-- (check the SRS practical guide [paper](https://doi.org/10.7717/peerj.9593) for details)-->. Just upload your ASV/OTU table (.qza) and the app will provide:
* A rug plot of the read counts per sample
* A simpler SRScurve plot (use the q2-srs SRScurve for the full experience)
* Summary statistics on trade-offs between C<sub>min</sub> and the number of retained samples
* Summary statistics on trade-offs between C<sub>min</sub> and the diversity retained per sample

Once you have chosen an adequate C<sub>min</sub>, run `SRS` with the C<sub>min</sub> that suits your data. 
The output of `SRS` will be an OTU/ASV table SRS-normalized at C<sub>min</sub> reads per sample that is ready for the next steps of your pipeline.

### Usage examples

In the following examples we are going to use the ASV table (DADA2 output) from the Moving Pictures [tutorial](https://docs.qiime2.org/2020.8/tutorials/moving-pictures/). This table is summarized below:

<center><img src = "https://github.com/vitorheidrich/q2-srs/blob/main/example_data/example_data/table.png?raw=true"></center>
#### 1) Running SRScurve
To run `SRScurve` the only required input is the OTU/ASV table. However, `SRScurve` is highly customizable, allowing different alpha diversity indices, a comparison with repeated rarefying and many other analytical/aesthetic options<!-- (check the SRS practical guide [paper](https://doi.org/10.7717/peerj.9593) for details)-->. Please run `qiime srs SRScurve --help` to see the full options.

`SRScurve` usage example with the `table.qza` from the `example_data` folder (check `table.qzv` for details):
```
qiime srs SRScurve \
  --i-table example_data/table.qza \
  --p-step 100 \
  --p-max-sample-size 3500 \
  --p-rarefy-comparison \
  --p-rarefy-comparison-legend \
  --p-rarefy-repeats 100 \
  --p-SRS-color 'blue' \
  --p-rarefy-color '#333333' \
  --o-visualization example_data/SRScurve-plot.qzv
```
You can see the plot output by running:
```
qiime tools view example_data/SRScurve-plot.qzv
```
<center><img src = "https://github.com/vitorheidrich/q2-srs/blob/main/example_data/example_data/SRScurve-plot.png?raw=true"></center>

Notice we are comparing rarefying with SRS normalization by using `--p-rarefy-comparison`. We see that, in this example, SRS normalization consistently retains a higher level of diversity in comparison with rarefying, so that the SRS curves level out way before the rarefy curves. For example, we see that for SRS-normalized samples, 3000 reads is a good choice of normalization cut-off, while this wouldn't be true for rarefy-normalized data. 

Anyway, let's use 3000 as our C<sub>min</sub>.

#### 2) Running SRS
To run `SRS` the only required input are the OTU/ASV table and the chosen C<sub>min</sub>. Please run `qiime srs SRS --help` to see the full options.

`SRS` usage example with the `table.qza` from the `example_data` folder and the C<sub>min</sub> as determined above:
```
qiime srs SRS \
  --i-table example_data/table.qza \
  --p-c-min 3000 \
  --o-normalized-table example_data/norm-table.qza
```
After running `SRS`, the samples with less sequence counts than the chosen C<sub>min</sub> will have been discarded. 
Finally, we can confirm that all samples ended up with the same number of reads in the SRS-normalized artifact by running:
```
qiime feature-table summarize \
  --i-table example_data/norm-table.qza \
  --o-visualization example_data/norm-table.qzv
```
<center><img src = "https://github.com/vitorheidrich/q2-srs/blob/main/example_data/example_data/norm-table.png?raw=true"></center>
##### Citation
If you use this plugin in your research paper, please cite as:

Beule L, Karlovsky P. 2020. Improved normalization of species count data in ecology by scaling with ranked subsampling (SRS): application to microbial communities. [*PeerJ* 8:e9593](https://doi.org/10.7717/peerj.9593)
<!---Change the proposed cite to the practical guide later--->

##### Acknowledgement
We would like to thank Claire Duvallet (@cduvallet) for her great tutorials ([I](https://cduvallet.github.io/posts/2018/03/qiime2-plugin); [II](https://cduvallet.github.io/posts/2018/06/qiime2-plugin-conda)) on how to build a QIIME2 plugin.
