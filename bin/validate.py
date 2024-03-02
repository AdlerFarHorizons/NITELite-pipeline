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
def get_service(self, name, *args, **kwargs):
    '''
    TODO: Add parameter validation.
    '''

    # Get parameters for constructing the service
    constructor_dict = self._services.get(name)
    if not constructor_dict:
        raise ValueError(f'Service {name} not registered')

    # Parse constructor parameters
    if constructor_dict['singleton'] and name in self.services:
        return self.services[name]
    constructor = constructor_dict['constructor']

    # Get the used arguments
    if constructor_dict['args_key'] is None:
        args_key = name
    else:
        args_key = constructor_dict['args_key']
    kwargs = self.get_service_args(args_key, constructor, **kwargs)

    print('At constructor.')
    print(constructor(*args, **kwargs))

def validate(self):

    print('Validating pipeline setup...')
    print(self.container)
    # io_manager = self.container.get_service('io_manager')
    # print(io_manager)
    get_service(self.container, 'io_manager')

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
