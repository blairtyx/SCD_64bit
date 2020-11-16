import os, sys
from PIL import Image

folder = '/Users/blair/Documents/workspace/blairtyx/blair-personal/EC605/EC605-LAB-5/project_1/Screenshot'
i = 0
# for infile in os.listdir(folder):
    
#     f, e = os.path.splitext(infile)
#     if e == ".png":
#         outfile = str(i) + ".png"
#         if infile != outfile:
#             try:
#                 with Image.open(infile) as im:
#                     box = (1740, 140, 2530, 1060)
#                     region = im.crop(box)
#                     region.save(outfile)
#             except OSError:
#                 print("cannot convert", infile)
#     i = i +1


im = Image.open('./Screenshot from 2020-11-17 04-42-03.png')
outfile = str(10) + ".png"
box = (1740, 140, 2530, 1060)
region = im.crop(box)
region.save(outfile)