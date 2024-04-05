if __name__ == '__main__':

    filepath = '/installed_dependencies.txt'

    with open(filepath, 'r') as f:
        lines = f.readlines()

    print(lines[0])
