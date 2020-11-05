
import qiime2.plugin
from q2_types.feature_table import FeatureTable, Frequency

import q2_SRS

cites = qiime2.plugin.Citations.load('citations.bib',
    package='q2_perc_norm')

plugin = qiime2.plugin.Plugin(
    name='SRS',
    version=q2_SRS.__version__,
    website='http://www.github.com/vitorheidrich/q2-SRS',
    package='q2_SRS',
    citations=qiime2.plugin.Citations.load('citations.bib', package='q2_SRS'),
    description=('This QIIME 2 plugin performs scaling with ranked subsampling (SRS) for the normalization of ecological count data (frequency feature tables)'),
    short_description='Scaling with ranked subsampling (SRS) for the normalization of ecological count data.',
    user_support_text=('Raise an issue on the github repo (https://github.com/vitorheidrich/q2-SRS) or contact us on the QIIME 2 forum (@vheidrich; @lukasbeule)')
)

# Registering the SRS function
plugin.methods.register_function(
    function=q2_SRS.SRS,
    inputs={'table': FeatureTable[Frequency]},
    outputs=['norm_table': FeatureTable[Frequency]],
    parameters={'Cmin': qiime2.plugin.Int},
    input_descriptions={
        'table': ('The feature table containing the samples to be normalized by SRS')
    },
    output_descriptions={
        'norm_table': 'SRS normalized feature table to Cmin reads per sample'
    },
    parameter_descriptions={
        'Cmin': 'The number of reads to which all samples will be normalized. Samples whose number of reads are lower than Cmin will be discarded'
    },
    name='SRS',
    description='Performs scaling with ranked subsampling (SRS) normalization of feature tables'
)
