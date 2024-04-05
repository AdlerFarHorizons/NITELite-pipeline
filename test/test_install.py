import importlib

if __name__ == '__main__':

    filepath = '/installed_dependencies.txt'

    with open(filepath, 'r') as f:
        lines = f.readlines()

    skipped = []
    failed = []
    for line in lines:
        package = line.split('=')[0]

        # Skip packages with dashes
        if '-' in package:
            skipped.append(line)
            continue

        # Test import
        try:
            importlib.import_module(package)
        except ImportError:
            failed.append(package)

    if len(failed) > 0:
        raise ImportError(
            'Could not import all modules.\n'
            f'{len(lines)} attempts, {len(failed)} failures.\n'
            f'Failures: {failed}'
        )
