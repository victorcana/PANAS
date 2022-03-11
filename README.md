# Sinox
Sinox v1 is a pipeline built for Linux.

## Prerequisites
A number of external programs are requiered to be in global directory and can be accessible from any working directory.
  1. PAML, available from http://abacus.gene.ucl.ac.uk/software/paml.html  (used version 4.9j). [Click to doawnload](http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz).
  2. ParaAT, available from https://github.com/wonaya/ParaAT (used version 2.0). [Click to doawnload](https://github.com/wonaya/ParaAT/archive/refs/heads/master.zip).    
      ParaAT requiere have at least one of the following sequence aligner clustalw2, t_coffee, mafft or     muscle. Some of them can be installed from Linux command line. Example:
```
sudo apt-get install mafft
```
So program can be accessible from any working directory add is in your PATH variable. In bash can add in ~/.bash_profile using of following commands:
```
nano ~/.bash_profile
```
Type and save the following lines:
```
export PATH=$PATH:~/your/path/directory/paml4.9j/src/
export PATH=$PATH:~/your/path/directory/ParaAT-master/
```
Then, execute in the command line:
```
source ~/.bash_profile
```
## Starting from Reads

## Instruction

- Input data
The pipeline requires four files. See Examples.  
    - Directory with file(s) containing multiple amino acid sequences.  
    - Directory with file(s) containing multiple nucleotide sequences.  
    - Directory with file(s) containing orthologous groups.  
    - Control files that specify the models and options for the analysis. No need to modify anything. Modifying some parameters in the control file can lead to error.  

Your directory should contain the following files before running
```
tree
.
├── CDS_AA
│   ├── speciesA.fa
│   ├── speciesB.fa
│   └── speciesC.fa
├── CDS_NUC
│   ├── speciesA.fa
│   ├── speciesB.fa
│   └── speciesC.fa
├── codeml.ctl
└── PairwiseOrthologs
    ├── genes_speciesA-genes_speciesB.txt
    ├── genes_speciesA-genes_speciesC.txt
    └── genes_speciesB-genes_speciesC.txt
```

or

```
tree
.
├── CDS_AA
│   └── speciesABC.fa
├── CDS_NUC
│   └── speciesABC.fa
├── codeml.ctl
└── PairwiseOrthologs
    ├── genes_speciesA-genes_speciesB.txt
    ├── genes_speciesA-genes_speciesC.txt
    └── genes_speciesB-genes_speciesC.txt
```

- Main Options  
  - `-p` Directory containing protein(s) file(s) in Fasta format. If you ran OMA to obtain orthologous information, it can be used the "DB" file, only with the Fasta file. Required parameter.  
  - `-n` Directory containing nucleotido(s) file(s) in Fasta format. Required parameter.    
  - `-o` Directory containing information of the ortologous groups. If you ran OMA, you can use "PairwiseOrthologs" file. However, it can be used tab-delimited text file(s) with each row representing a homologous group with two column. See example in Input data section. Required parameter.  
  - `-z` Process number used during alignment. It is used by the ParAT program. Required Parameter.  
  - `-a` Aligner used. Depending on which alignment program you have installed, you can choose one of the following: "clustalw2", "t_coffee", "mafft" or "muscle"). Default: mafft. Optional parameter.  
  - `-g` Genetic Code used. Default: 1. 1 represent "The Standard Code". For more information see documentation of [ParaAT](https://ngdc.cncb.ac.cn/tools/paraat/doc). Optional parameter.    
  - `-t` Type of format of the file(s) containing information of the orthologous groups. You can chose one of the following: "OMA" or "other". If two information of the ortologous groups correspond to the "PairwiseOrthologs" file chose "OMA". Requerid parameter.     
  - `-s` You can choose between the parameters: "single-copy" or "multiple-copy". Allows you to choose if you want to perform the analysis using only the information of orthologous genes with a 1:1 ratio ("single-copy"), or orthologous groups of multiple copies, such as 1:many, many:1, and many:many ("multiple-copy"). Useful parameter if your information comes from OMA. If your information does not have the OMA "PairwiseOrthologs" format, you can choose any. Required parameter.  
  - `-h` Help  
  
**Import note:** Each gene must have the same code in its nucleotide and amino acid sequence. However, the code from one gene should not be repeated in another gene. Don't use "@" in sequence codes.

  - Output
If you choe the option "-s single-copy" the key output files include:   
    - **single-copy** directory.  
    - **Todos_resultados_single-copy**  file.
If you choe the option "-s multiple-copy" the key output files include: 
    - **multiple-copy** directory if you chose the option "-s multiple-copy".
    - **Todos_resultados_multiple-copy**  file.
The **single-copy** or **multiple-copy** directory has information for each pairwise comparison of species. Example. If the analysis performed the pairwise comparison of the genes of three species (genes_speciesA vs genes_speciesB; genes_speciesB vs genes_speciesC; genes_speciesA vs genes_speciesC), the directory will contain the following subdirectories "genes_speciesA-genes_speciesB", "genes_speciesB-genes_speciesC" and "genes_speciesA-genes_speciesC".


## Running Sinox
```
./Sinox.sh -p protein_directory/ -n nucleotide_directory/ -o PairwiseOrthologs_example/ -z 4 -a mafft -g 1 -t OMA -s single-copy
```
---
## Test
--
## Instruction
--
## Citation
--
##

