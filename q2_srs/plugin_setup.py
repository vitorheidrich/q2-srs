
import qiime2.plugin
from qiime2.plugin import (Int, Range, Bool, Str, Choices)
from q2_types.feature_table import FeatureTable, Frequency

import q2_srs

from q2_srs._SRS import SRS
from q_srs._SRScurve import SRScurve

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
                 'count data (frequency feature tables).'),
    short_description=('Scaling with ranked subsampling (SRS) for the '
                        'normalization of ecological count data.'),
    user_support_text=('Raise an issue on the github repo (github.com/vitorheidrich/q2-srs) '
                       'or contact us on the QIIME 2 forum (@vheidrich; @lukasbeule).')
)

# Registering the SRS function
plugin.methods.register_function(
    function=SRS,
    inputs={'table': FeatureTable[Frequency]},
    outputs=[('normalized_table', FeatureTable[Frequency])],
    parameters={'c_min': Int % Range(1, None),
               'set_seed': Bool,
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
        'seed': ('Specify the integer seed to be used. ' 
                 'Only used if set_seed is true.')
    },
    name='SRS normalization',
    description=('Performs scaling with ranked subsampling (SRS) for '
                 'the normalization of ecological/microbiome count data.')
)

# Registering the SRScurve function
plugin.visualizers.register_function(
    function=SRScurve,
    inputs={'table': FeatureTable[Frequency]},
    #outputs=[('normalized_table', FeatureTable[Frequency])],
    parameters={'metric': Str % Choices(['richness', 'shannon', 'simpson', 'invsimpson']),
               'step': Int % Range(1, None),
               'sample': Int % Range(1, None),
               'max_sample_size': Int % Range(1, None),
               'rarefy_comparison': Bool,
               'rarefy_repeats': Int % Range(1, None),
               'rarefy_comparison.legend': Bool,
               'SRS_color': Str,
               'rarefy_color': Str,
               'SRS_linetype': Str,
               'label': Bool}
    input_descriptions={
        'table': ('The feature table containing the '
                  'samples to be evaluated by SRScurve.')
    },
    #output_descriptions={
    #    'normalized_table': ('SRS normalized feature table to '
    #                   'Cmin (integer) reads per sample.')
    #},
    parameter_descriptions={
        'metric': ('Alpha diversity index. Use "richness" for species richness '
                   '(observed OTUs/ASVs) or "shannon", "simpson" or "invsimpson" '
                   'for common diversity indices.'),
        'step': ('Specify the step to vary the sample size.'),
        'sample': ('Specify the cutoff-level to visualize trade-offs between '
                   'cutoff-level and alpha diversity.'),
        'max_sample_size': ('Specify the maximum sample size to which SRS curves '
                            'are drawn. Default does not limit the maximum sample '
                            'size.'),
        'rarefy_comparison': ('Median values of rarefy with n repeats specified by '
                              'rarefy.repeats will be drawn for comparison.'),
        'rarefy_repeats': ('Specify the number of repeats used to obtain median 
                           'values for rarefying. Only used if rarefy.comparison '
                           'is true'),
        'rarefy_comparison_legend': ('Show legend indicating SRS and rarefy derived curves. 
                                     'Only used if rarefy.comparison is true.'),
        'SRS_color': ('Color to be used for SRScurves. Check R documentation '
                     'for options.'),
        'rarefy_color': ('Color to be used for rarefaction curves. Only used if 
                         'rarefy.comparison is true. Check R documentation for 
                         'options.'),
        'SRS_linetype': ('Line type to be used for SRScurves. Check R documentation '
                         'for options.'),
        'rarefy_linetype': ('Line type to be used for rarefaction curves. Only '
                            'used if rarefy.comparison is true. Check R documentation '
                            'for options.'),
        'label': ('Include sample id labels')
    },
    name='SRS normalization',
    description=('For each sample, draws a line plot of alpha diversity '
                 'indices at different sample sizes (specified by step) '
                 'normalized by scaling with ranked subsampling. Minimum '
                 'sample size (cutoff-level) can be evaluated by specifying '
                 'sample. The function further allows to visualize trade-offs '
                 'between cutoff-level and alpha diversity and enables direct '
                 'comparison of SRS and repeated rarefying.')
)

