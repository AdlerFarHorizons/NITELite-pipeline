import importlib
import json

def main():

    filepath = '/conda-env.yaml'
    with open(filepath, 'r') as f:
        lines = f.readlines()

    with open('/NITELite-pipeline/test/module_names.json') as f:
        module_names = json.load(f)

    in_dependencies = False
    failed = []
    succeeded = []
    for line in lines:
        # Remove endline char
        line = line[:-1]

        # Skip until we get to dependencies
        if line == 'dependencies:':
            in_dependencies = True
        if not in_dependencies:
            continue

        # Get the name of the module to import
        if not ('  - ' in line):
            continue
        module = line.split('  - ')[1]
        if module in module_names:
            module = module_names[module]

        # Test import
        try:
            importlib.import_module(module)
            succeeded.append(module)
        except ImportError:
            failed.append(module)

    # Check for key dependencies
    if len(failed) > 0:
        raise ImportError(
            'Could not import all modules.\n'
            f'{len(lines)} attempts, {len(failed)} failures.\n'
            f'Failures: {failed}'
        )
    print('Install validated successfully.')


if __name__ == '__main__':
    main()
