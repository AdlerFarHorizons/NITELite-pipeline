from tqdm import tqdm
from time import sleep

print('Starting...')

for i in tqdm(range(100)):
    sleep(0.1)

print('Done!')
