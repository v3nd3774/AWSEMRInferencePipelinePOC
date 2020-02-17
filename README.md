# What is this?

This repo stores the code to create an EMR Inference pipeline on AWS, the pipeline is designed to learn the digits in the MNIST dataset.

The MNIST dataset will be fragmented in `S3` like so (filenames are random, but will be the same except for the extension for any digit):

```
FORMAT A:
  /
  |--random-unique-name1/
  |----<filename for image for digit 1>.png
  |----<filename for label for digit 1>.txt
  |----random-unique-name2/
  |------<filename for image for digit 2>.png
  |------<filename for label for digit 2>.txt
  ...
  |------<filename for image for digit n>.png
  |------<filename for label for digit n>.txt
  |-random-unique-name3/
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
<p align="center">Figure 1: Directory structure for folder <tt>FORMAT A</tt></p>

Where <img src="http://www.sciweavers.org/tex2img.php?eq=n%2Cm%2CL%2Ck%2Cp%20%5Cin%20%20%5Cmathbb%7BN%7D&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0" align="center" border="0" alt="n,m,L,k,p \in  \mathbb{N}" width="208" height="19" />.

Folders may be arbitrarily nested.

This repo will store the Terraform setup scripts to load the data into `SOURCE_MNIST_DATA` in the following diagram:

```
S3 Interaction Points: (S3|x) where x is the location of the data in the computational DAG
                                                                ---->(S3|3)Model Performance Report
                                                               /            ▲
                                                              /             |
                                                             /              |
                                                            /               ▼
  (S3|1)SOURCE_MNIST_DATA ---------->(S3|2)FORMAT A------------------>(S3|4)Serialized Model
                   ▲                          ▲                             ▲
                   |                          |                             |
                   |                           \                            / 
                   |                            \                          / 
Tech Catalyst: Terraform                         ---------▶ EMR ◀---------
                    |                                        ▲
                    |                                        |
                     \                                      /
                      --------------------------------------
```
<p align="center">Figure 2: Diagram of System Topology</p>

The repo contains the Terraform code to initialize each node in Figure 2 that is reachable from Terraform.

After this is complete, I will add code to connect nodes 1 and 2 in the computational DAG from the EMR cluster.

Learnings:

  1. You can download external files to work with in the Terraform script as described [here](https://stackoverflow.com/questions/45317910/how-to-download-a-file-from-github-enterprise-using-terraform).
  2. You need to use an internet gateway for the nodes, not doing this will prevent the cluster from turning on. More info [here](https://aws.amazon.com/blogs/big-data/launching-and-running-an-amazon-emr-cluster-inside-a-vpc/).
