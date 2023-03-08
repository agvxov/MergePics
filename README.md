# MergePics.sh
Merge seqentually named (1.png 2.png) images in $PWD to a single image horizontally or vertically while sesizing to fill empty space and avoid "borders".

# Example
	$ ls -1
	a.jpeg
	b.png

a.jpeg (640x480):
![](example/a.jpeg)
b.png (256x256):
![](example/b.png)

	$ MergePics.sh -h

output:
![](example/hFS9IIslYX.png)
