# What is this?

This repo stores the code to create an EMR Inference pipeline on AWS, the pipeline is designed to learn the digits in the MNIST dataset.

The MNIST dataset will be fragmented in `S3` like so (filenames are random, but will be the same except for the extension for any digit):

```
FORMAT A:
  /
  |--random-unique-name1/
  |----<filename for image for digit 1>.png
  |----<filename for label for digit 1>.txt
  |----<filename for image for digit 2>.png
  |----<filename for label for digit 2>.txt
  ...
  |----<filename for image for digit n>.png
  |----<filename for label for digit n>.txt
  |-random-unique-name2/
  |----<filename for image for digit n+1>.png
  |----<filename for label for digit n+1>.txt
  |----<filename for image for digit n+2>.png
  |----<filename for label for digit n+2>.txt
  ...
  |----<filename for image for digit n+m>.png
  |----<filename for label for digit n+m>.txt
  ...
  |--random-unique-nameL/
  |----<filename for image for digit n+m+k>.png
  |----<filename for label for digit n+m+k>.txt
  |----<filename for image for digit n+m+k+1>.png
  |----<filename for label for digit n+m+k+1>.txt
  ...
  |----<filename for image for digit n+m+k+p>.png
  |----<filename for label for digit n+m+k+p>.txt
```

Where <div style="width:100px; overflow:hidden; display:inline-block;"><img src="http://www.sciweavers.org/tex2img.php?eq=n%2Cm%2Ck%2Cp%20%5Cin%20%20%5Cmathbb%7BN%7D&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0" align="center" border="0" alt="n,m,k,p \in  \mathbb{N}" width="207" height="19" /></div>

This repo will store the Terraform setup scripts to load the data into the following S3 destinations:

```
SOURCE_MNIST_DATA --> FORMAT_A
```
