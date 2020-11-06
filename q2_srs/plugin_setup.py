
import qiime2.plugin
from q2_types.feature_table import FeatureTable, Frequency

import q2_srs

from q2_srs._SRS import SRS

cites = qiime2.plugin.Citations.load('citations.bib',
    package='q2_srs')

plugin = qiime2.plugin.Plugin(
    name='SRS',
    version=q2_srs.__version__,
    website='http://www.github.com/vitorheidrich/q2-srs',
    package='q2_srs',
    citations=qiime2.plugin.Citations.load('citations.bib', package='q2_srs'),
    description=('This QIIME 2 plugin performs scaling with ranked subsampling (SRS) for the normalization of ecological count data (frequency feature tables)'),
    short_description='Scaling with ranked subsampling (SRS) for the normalization of ecological count data.',
    user_support_text=('Raise an issue on the github repo (https://github.com/vitorheidrich/q2-srs) or contact us on the QIIME 2 forum (@vheidrich; @lukasbeule)')
)

# Registering the SRS function
plugin.methods.register_function(
    function=SRS,
    inputs={'data': FeatureTable[Frequency]},
    outputs={'norm_data': FeatureTable[Frequency]},
    parameters={'Cmin': qiime2.plugin.Int},
    input_descriptions={
        'data': ('The feature table containing the samples to be normalized by SRS')
    },
    output_descriptions={
        'norm_table': 'SRS normalized feature table to Cmin (integer) reads per sample'
    },
    parameter_descriptions={
        'Cmin': 'The number of reads to which all samples will be normalized. Samples whose number of reads are lower than Cmin will be discarded'
    },
    name='SRS',
    description='Performs scaling with ranked subsampling (SRS) normalization of feature tables'
)
