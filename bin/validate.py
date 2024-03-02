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

    return constructor, args, kwargs


print('Before IOManager')
from io_manager import IOManager
from night_horizons.mapmake import create_mapmaker
mapmaker = create_mapmaker(args.config_filepath)
constructor, args, kwargs = mapmaker.container.get_service('io_manager')
print('\nargs:')
print(args)
print('\nkwargs:')
print(kwargs)
# io_manager = IOManager(*args, **kwargs)

# io_manager = IOManager(
#     input_dir='/data/referenced_images',
#     input_description={},
#     output_dir='/data/nitelite_pipeline_output',
#     output_description={},
# )
# print(io_manager.input_filepaths)
print('After IO manager')
