print('Testing...')

import os
print(os.getcwd())
print(os.listdir('/data/'))

# Set up the argparser
import argparse
parser = argparse.ArgumentParser()
parser.add_argument(
    'config_filepath',
    type=str,
    help='Location of config file.',
)
parser.add_argument(
    '--validate_only',
    action='store_true',
    help='If True, only validate the config file.'
)
args = parser.parse_args()
print(args.config_filepath)
print(args.validate_only)

print('Before IOManager')
from io_manager import IOManager
from night_horizons.mapmake import create_mapmaker
mapmaker = create_mapmaker(args.config_filepath)
io_manager = mapmaker.container.get_service('io_manager')

# io_manager = IOManager(
#     input_dir='/data/referenced_images',
#     input_description={},
#     output_dir='/data/nitelite_pipeline_output',
#     output_description={},
# )
print(io_manager.input_filepaths)
print('After IO manager')
