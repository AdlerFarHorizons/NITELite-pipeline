import importlib
import json

if __name__ == '__main__':

    filepath = '/conda-env.yaml'
    with open(filepath, 'r') as f:
        lines = f.readlines()

    with open('module_names.json') as f:
        module_names = json.load(f)

    in_dependencies = False
    failed = []
    for line in lines:

        # Skip until we get to dependencies
        if line == 'dependencies:':
            in_dependencies = True
        if not in_dependencies:
            continue

        # Get the name of the module to import
        module = line.split('  - ')[1]
        if module in module_names:
            module = module_names[module]

        # Test import
        try:
            importlib.import_module(module)
        except ImportError:
            failed.append(module)

    # Check for key dependencies
    if len(failed) > 0:
        raise ImportError(
            'Could not import all modules.\n'
            f'{len(lines)} attempts, {len(failed)} failures.\n'
            f'Failures: {failed}'
        )
