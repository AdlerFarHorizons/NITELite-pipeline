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

# Create the mapmaker
from night_horizons.mapmake import create_mapmaker
mapmaker = create_mapmaker(args.config_filepath)
def validate(self):

    print('Validating pipeline setup...')
    io_manager = self.container.get_service('io_manager')
    print(io_manager)

    # print('Counting input filepaths...')
    # input_fp_count = {
    #     key: len(val) for key, val
    #     in io_manager.input_filepaths.items()
    # }
    # total_fp_count = 0
    # for key, count in input_fp_count.items():
    #     print(f'    {key}: {count} filepaths')
    #     total_fp_count += count
    # print(f'    ------------\n    Total: {total_fp_count} filepaths')
    # if total_fp_count == 0:
    #     print('WARNING: No input filepaths found.')
validate(mapmaker)
