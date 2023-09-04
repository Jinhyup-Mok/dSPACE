import os
import re

def create():
    os.chdir("C:\SVN\install\PoC_offline\simphera") # change to your 'helmchart.txt' path 
    cmd = 'helm template simphera-release ./simphera-quickstart -n mynamespace -f ./custom-values.yaml --debug > helmchart.txt'
    os.system(cmd)
    
def search():
    cmd = 'find "image:" helmchart.txt >> image.txt'
    os.system(cmd)

def image():
    ignore = []
    imglist = []
    with open("image.txt", "r") as file:
        for line in file:
            line = line.split()
            if 'image:' in line: 
                image = line[1].strip('"')
                imglist.append(image)
            
        imglist = list(set(imglist))
        
        for img in imglist:
            if img in ['__AURELION_DOCKER_IMAGE__', '__SUT_IMAGE_NAME__', 'registry.dspace.cloud/IMAGE:TAG']:
                ignore.append(img)
                continue
            download(img)
    return ignore

def download(img):
    tar = re.sub('[/:\\*<>?"|]', "_", img) # throw out file name exception
    pull = f'docker pull {img}'
    save = f'docker save -o {tar}.tar {img}'
    
    print(pull)
    os.system(pull)
    
    print(save)
    os.system(save)


if __name__ == "__main__":
    create()
    search()
    print("Ignore Image : ", image())