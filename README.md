# Sinox
Sinox v1 is a pipeline built for Linux.

## Prerequisites
A number of external programs are requiered to be in global directory and can be accessible from any working directory.
  1. PAML, available from http://abacus.gene.ucl.ac.uk/software/paml.html  (used version 4.9j). [Click to doawnload](http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz).
  2. ParaAT, available from https://github.com/wonaya/ParaAT (used version 2.0). [Click to doawnload](https://github.com/wonaya/ParaAT/archive/refs/heads/master.zip).
   - ParaAT requiere have at least one of the following sequence aligner clustalw2, t_coffee, mafft,     muscle. Some of them can be installed from Linux command line. Example:
```
sudo apt-get install mafft
```
To program can be accessible from any working directory add is in your PATH variable. In bash can add in ~/.bash_profile using of following commands:
```
nano ~/.bash_profile
```
Type and save the following lines:
```
export PATH=$PATH:~/your/path/directory/paml4.9j/src/
export PATH=$PATH:~/your/path/directory/ParaAT-master/
```
Then, in the command line execute:
```
source ~/.bash_profile
```
---
**Starting from Reads**
- Input data

## Running Sinox
```
./Sinox -p Protein_example/ -n Nucleotide_example/ -o PairwiseOrthologs_example/ -z 8 -a mafft -g 1 -t OMA -s single-copy
```
---
## Test
--
## Instruction
--
## Citation
--
##

