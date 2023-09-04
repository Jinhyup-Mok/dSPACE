import os

IMAGE_PATH = "D:\\PoC_offline\\Images"

def open():
    for f in os.listdir(IMAGE_PATH): # change path to your own images path
        print(load(os.path.join(IMAGE_PATH, f))) # set absolute path
        
def load(image):
    load = f'docker load -i {image}'
    os.system(load)
    return load    

if __name__ == "__main__":
    open()