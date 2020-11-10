
import qiime2.plugin
from qiime2.plugin import Int, Range, Bool
from q2_types.feature_table import FeatureTable, Frequency

import q2_srs

from q2_srs._SRS import SRS

cites = qiime2.plugin.Citations.load('citations.bib',
    package='q2_srs')

plugin = qiime2.plugin.Plugin(
    name='srs',
    version=q2_srs.__version__,
    website='http://www.github.com/vitorheidrich/q2-srs',
    package='q2_srs',
    citations=[cites['SRS2020beule']],
    description=('This QIIME 2 plugin performs scaling with ranked '
                 'subsampling (SRS) for the normalization of ecological '
                 'count data (frequency feature tables)'),
    short_description=('Scaling with ranked subsampling (SRS) for the '
                        'normalization of ecological count data.'),
    user_support_text=('Raise an issue on the github repo (github.com/vitorheidrich/q2-srs) '
                       'or contact us on the QIIME 2 forum (@vheidrich; @lukasbeule)')
)

# Registering the SRS function
plugin.methods.register_function(
    function=SRS,
    inputs={'table': FeatureTable[Frequency]},
    outputs=[('normalized_table', FeatureTable[Frequency])],
    parameters={'c_min': Int % Range(1, None),
               'seet_seed: Bool,
               'seed': Int % Range(1, None)},
    input_descriptions={
        'table': ('The feature table containing the '
                 'samples to be normalized by SRS.')
    },
    output_descriptions={
        'normalized_table': ('SRS normalized feature table to '
                       'Cmin (integer) reads per sample.')
    },
    parameter_descriptions={
        'c_min': ('The number of reads to which all samples will '
                 'be normalized. Samples whose number of reads '
                 'are lower than c_min will be discarded.'),
        'set_seed': ('Set a seed to enable reproducibility of SRS.'),
        'seed': ('Specify the integer seed to be used.')
    },
    name='SRS normalization',
    description=('Performs scaling with ranked subsampling (SRS) normalization')
)
