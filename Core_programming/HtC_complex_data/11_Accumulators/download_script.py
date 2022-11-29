from os import system
from sys import argv

def downloadFile( name, url = 'https://s3.amazonaws.com/edx-course-spdx-kiczales/HTC/', ext = 'rkt'):
    command = f"curl {url}{name}-starter.{ext} > {name}.{ext}"
    system(command)

if __name__ == "__main__":
    args = len(argv)
    if (args == 2):
        downloadFile(argv[1])
    elif (args > 2):
        downloadFile(argv[1], argv[2], argv[3])
    else:
        print(f"Usage: download_script.py <file-name> (opt)<url> <extension>")
    pass