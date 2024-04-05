import importlib
import json

if __name__ == '__main__':

    filepath = '/installed_dependencies.json'

    with open(filepath, 'r') as f:
        packages = json.load(f)

    skipped = []
    failed = []
    for package in packages:
        name = package['name']

        # Skip packages with dashes
        if '-' in name:
            skipped.append(name)
            continue

        # Test import
        try:
            importlib.import_module(name)
        except ImportError:
            failed.append(name)

    # Check for key dependencies
    if len(failed) > 0:
        raise ImportError(
            'Could not import all modules.\n'
            f'{len(packages)} attempts, {len(failed)} failures.\n'
            f'Failures: {failed}'
        )
