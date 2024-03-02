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
args = parser.parse_args()
print(args.config_filepath)
