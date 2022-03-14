# Sinox
Sinox v1 is a pipeline built for Linux.



## Prerequisites
A number of external programs are requiered to be in global directory and can be accessible from any working directory.
  1. PAML, available from http://abacus.gene.ucl.ac.uk/software/paml.html  (used version 4.9j). [Click to doawnload](http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz).
  2. ParaAT, available from https://github.com/wonaya/ParaAT (used version 2.0). [Click to doawnload](https://github.com/wonaya/ParaAT/archive/refs/heads/master.zip).    
      ParaAT requiere have at least one of the following sequence aligner clustalw2, t_coffee, mafft or     muscle. Some of them can be installed from Linux command line. Example:
```
-bash-4.4$ sudo apt-get install mafft
```
So program can be accessible from any working directory add is in your PATH variable. In bash can add in ~/.bash_profile using of following commands:
```
-bash-4.4$ nano ~/.bash_profile
```
Type and save the following lines:
```
export PATH=$PATH:~/your/path/directory/paml4.9j/src/
export PATH=$PATH:~/your/path/directory/ParaAT-master/
```
Then, execute in the command line:
```
-bash-4.4$ source ~/.bash_profile
```

## Main Options  
  - `-p` Directory containing protein(s) file(s) in Fasta format. If you ran OMA to obtain orthologous information, it can be used the "DB" file, only with the Fasta file. Required parameter.  
  - `-n` Directory containing nucleotido(s) file(s) in Fasta format. Required parameter.    
  - `-o` Directory containing information of the ortologous groups. If you ran OMA, you can use "PairwiseOrthologs" file. However, it can used tab-delimited text file(s) with each row representing an orthologous group with two column. See example in Input data section. Required parameter.  
  - `-z` Process number used during alignment. It is used by the ParAT program. Required Parameter.  
  - `-a` Aligner used. Depending on which alignment program you have installed, you can choose one of the following: "clustalw2", "t_coffee", "mafft" or "muscle"). Default: mafft. Optional parameter.  
  - `-g` Genetic Code used. Default: 1. 1 represent "The Standard Code". For more information see documentation of [ParaAT](https://ngdc.cncb.ac.cn/tools/paraat/doc). Optional parameter.    
  - `-t` Type of format of the file(s) containing information of the orthologous groups. You can chose one of the following: "OMA" or "other". If two information of the ortologous groups correspond to the "PairwiseOrthologs" file chose "OMA". Requerid parameter.     
  - `-s` You can choose between the parameters: "single-copy" or "multiple-copy". Allows you to choose if you want to perform the analysis using only the information of orthologous genes with a 1:1 ratio ("single-copy"), or orthologous groups of multiple copies, such as 1:many, many:1, and many:many ("multiple-copy"). Useful parameter if your information comes from OMA. If your information does not have the OMA "PairwiseOrthologs" format, you can choose any. Required parameter.  
  - `-h` Help  
  
**Import note:** Each gene must have the same code in its nucleotide and amino acid sequence. However, the code from one gene should not be repeated in another gene. Don't use "@" in sequence codes.


## Input data  
The pipeline requires four files. See Examples.  
    - Directory with file(s) containing multiple amino acid sequences.  
    - Directory with file(s) containing multiple nucleotide sequences.   
    - Control files that specify the models and options for the analysis. No need to modify anything. Modifying some parameters in the control file can lead to error.  
    - Directory with file(s) containing orthologous groups. 
      - Example of "PairwiseOrthologs" OMA format, for the option "-t OMA":
```
-bash-4.4$ genes_speciesA-genes_speciesB.txt 
# Format: Protein 1<tab>Protein 2<tab>Protein ID1<tab>ProteinID2<tab>Orthology type<tab>OMA group (if any)
# Every pair is listed only once, and in no particular order.
# The map between sequence number and ID are given
# in the file "Map-SeqNum-ID.map
1	1	atp6_Echinococcus_multilocularis_AB018440	atp6_Eudiplozoon_nipponicum_MW704020	1:1	11
2	2	cox1_Echinococcus_multilocularis_AB018440	cox1_Eudiplozoon_nipponicum_MW704020	1:1	1
3	3	cox2_Echinococcus_multilocularis_AB018440	cox2_Eudiplozoon_nipponicum_MW704020	1:1	1
4	4	cox3_Echinococcus_multilocularis_AB018440	cox3_Eudiplozoon_nipponicum_MW704020	1:1	8
5	5	cytb_Echinococcus_multilocularis_AB018440	cytb_Eudiplozoon_nipponicum_MW704020	1:1	2
6	6	nad1_Echinococcus_multilocularis_AB018440	nad1_Eudiplozoon_nipponicum_MW704020	1:1	5
```
- Example of other format, for the option "-t other":
```
-bash-4.4$ head -n 6 genes_speciesA-genes_speciesB.txt 
atp6_Echinococcus_multilocularis_AB018440	atp6_Eudiplozoon_nipponicum_MW704020
cox1_Echinococcus_multilocularis_AB018440	cox1_Eudiplozoon_nipponicum_MW704020
cox2_Echinococcus_multilocularis_AB018440	cox2_Eudiplozoon_nipponicum_MW704020
cox3_Echinococcus_multilocularis_AB018440	cox3_Eudiplozoon_nipponicum_MW704020
cytb_Echinococcus_multilocularis_AB018440	cytb_Eudiplozoon_nipponicum_MW704020
nad1_Echinococcus_multilocularis_AB018440	nad1_Eudiplozoon_nipponicum_MW704020
```

## Starting

  - **Directory**  
  Your directory should contain the following files before running

```
-bash-4.4$ tree
.
├── protein_directory
│   ├── speciesA.fa
│   ├── speciesB.fa
│   └── speciesC.fa
├── nucleotide_directory
│   ├── speciesA.fa
│   ├── speciesB.fa
│   └── speciesC.fa
├── codeml.ctl
└── Orthologs
    ├── genes_speciesA-genes_speciesB.txt
    ├── genes_speciesA-genes_speciesC.txt
    └── genes_speciesB-genes_speciesC.txt
```

or

```
-bash-4.4$ tree
.
├── protein_directory
│   └── speciesABC.fa
├── nucleotide_directory
│   └── speciesABC.fa
├── codeml.ctl
└── Orthologs
    ├── genes_speciesA-genes_speciesB.txt
    ├── genes_speciesA-genes_speciesC.txt
    └── genes_speciesB-genes_speciesC.txt
```
  
 - **Running Sinox**  
```
-bash-4.4$ ~/path/Sinox.sh -p protein_directory/ -n nucleotide_directory/ -o Orthologs/ -z 4 -a mafft -g 1 -t OMA -s single-copy
```
  
  - **Output**  
If you choe the option "-s single-copy" the key output files include:   
    - **single-copy** directory.  
    - **Todos_resultados_single-copy**  file.
If you choe the option "-s multiple-copy" the key output files include: 
    - **multiple-copy** directory if you chose the option "-s multiple-copy".
    - **Todos_resultados_multiple-copy**  file.
The **single-copy** or **multiple-copy** directory has information for each pairwise comparison of species. Example. If the analysis performed the pairwise comparison of the genes of three species (genes_speciesA vs genes_speciesB; genes_speciesB vs genes_speciesC; genes_speciesA vs genes_speciesC), the directory will contain the following subdirectories "genes_speciesA-genes_speciesB", "genes_speciesB-genes_speciesC" and "genes_speciesA-genes_speciesC".
  
Then of run Sinox.sh your directory should look similar to this:

```
-bash-4.4$ tree
.
├── all.cds
├── all.pep
├── codeml.ctl
├── nucleotide_directory
│   └── speciesABC.fa
├── Orthologs
│   ├── genes_speciesA-genes_speciesB.txt
│   ├── genes_speciesA-genes_speciesC.txt
│   └── genes_speciesB-genes_speciesC.txt
├── proc
├── protein_directory
│   └── speciesABC.fa
├── single-copy
│   ├── genes_speciesA-genes_speciesB.txt.carpeta
│   │   ├── codeml.ctl
│   │   ├── genes_speciesA-genes_speciesB.txt.homologos
│   │   ├── guia.ctl
│   │   ├── output
│   │   │   ├── nad4_Echinococcus_multilocularis_AB018440-nad4_Eudiplozoon_nipponicum_MW704020.cds_aln.paml
│   │   │   ├── nad4_Echinococcus_multilocularis_AB018440-nad4_Eudiplozoon_nipponicum_MW704020.cds_aln.paml.mlc
│   │   │   ├── nad4L_Echinococcus_multilocularis_AB018440-nad4L_Eudiplozoon_nipponicum_MW704020.cds_aln.paml
│   │   │   ├── nad4L_Echinococcus_multilocularis_AB018440-nad4L_Eudiplozoon_nipponicum_MW704020.cds_aln.paml.mlc
│   │   │   ├── nad5_Echinococcus_multilocularis_AB018440-nad5_Eudiplozoon_nipponicum_MW704020.cds_aln.paml
│   │   │   ├── nad5_Echinococcus_multilocularis_AB018440-nad5_Eudiplozoon_nipponicum_MW704020.cds_aln.paml.mlc
│   │   │   ├── nad6_Echinococcus_multilocularis_AB018440-nad6_Eudiplozoon_nipponicum_MW704020.cds_aln.paml
│   │   │   └── nad6_Echinococcus_multilocularis_AB018440-nad6_Eudiplozoon_nipponicum_MW704020.cds_aln.paml.mlc
│   │   ├── Resultados.genes_speciesA-genes_speciesB.txt.vic
│   │   └── Resultados.genes_speciesA-genes_speciesB.txt.vic2
│   ├── genes_speciesA-genes_speciesC.txt.carpeta
│   │   ├── codeml.ctl
│   │   ├── genes_speciesA-genes_speciesC.txt.homologos
│   │   ├── guia.ctl
│   │   ├── output
│   │   │   ├── nad4_Echinococcus_multilocularis_AB018440-nad4_Fasciola_hepatica_AF216697.cds_aln.paml
│   │   │   ├── nad4_Echinococcus_multilocularis_AB018440-nad4_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│   │   │   ├── nad4L_Echinococcus_multilocularis_AB018440-nad4L_Fasciola_hepatica_AF216697.cds_aln.paml
│   │   │   ├── nad4L_Echinococcus_multilocularis_AB018440-nad4L_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│   │   │   ├── nad5_Echinococcus_multilocularis_AB018440-nad5_Fasciola_hepatica_AF216697.cds_aln.paml
│   │   │   ├── nad5_Echinococcus_multilocularis_AB018440-nad5_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│   │   │   ├── nad6_Echinococcus_multilocularis_AB018440-nad6_Fasciola_hepatica_AF216697.cds_aln.paml
│   │   │   └── nad6_Echinococcus_multilocularis_AB018440-nad6_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│   │   ├── Resultados.genes_speciesA-genes_speciesC.txt.vic
│   │   └── Resultados.genes_speciesA-genes_speciesC.txt.vic2
│   └── genes_speciesB-genes_speciesC.txt.carpeta
│       ├── codeml.ctl
│       ├── genes_speciesB-genes_speciesC.txt.homologos
│       ├── guia.ctl
│       ├── output
│       │   ├── nad4_Eudiplozoon_nipponicum_MW704020-nad4_Fasciola_hepatica_AF216697.cds_aln.paml
│       │   ├── nad4_Eudiplozoon_nipponicum_MW704020-nad4_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│       │   ├── nad4L_Eudiplozoon_nipponicum_MW704020-nad4L_Fasciola_hepatica_AF216697.cds_aln.paml
│       │   ├── nad4L_Eudiplozoon_nipponicum_MW704020-nad4L_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│       │   ├── nad5_Eudiplozoon_nipponicum_MW704020-nad5_Fasciola_hepatica_AF216697.cds_aln.paml
│       │   ├── nad5_Eudiplozoon_nipponicum_MW704020-nad5_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│       │   ├── nad6_Eudiplozoon_nipponicum_MW704020-nad6_Fasciola_hepatica_AF216697.cds_aln.paml
│       │   └── nad6_Eudiplozoon_nipponicum_MW704020-nad6_Fasciola_hepatica_AF216697.cds_aln.paml.mlc
│       ├── Resultados.genes_speciesB-genes_speciesC.txt.vic
│       └── Resultados.genes_speciesB-genes_speciesC.txt.vic2
└── Todos_resultados_single-copy
```

## Citation
XXXX  

Please, cite the dependencies used:  
PAML:  [Yang, Z. (2007). PAML 4: Phylogenetic Analysis by Maximum Likelihood, Molecular Biology and Evolution, 24(8), 1586-1591.](https://academic.oup.com/mbe/article/24/8/1586/1103731)  
ParaAT: [Zhang, Z., Xiao, J., Wu, J., Zhang, H., Liu, G., Wang, X., & Dai, L. (2012). ParaAT: a parallel tool for constructing multiple protein-coding DNA alignments. Biochemical and biophysical research communications, 419(4), 779-781.](https://www.sciencedirect.com/science/article/pii/S0006291X12003518)    
  
  
Please also cite the dependencies if used:  
MAFFT: [Katoh, K., & Standley, D. M. (2013). MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Molecular biology and evolution, 30(4), 772-780.](https://academic.oup.com/mbe/article/30/4/772/1073398)  
MUSCLE: [Edgar, R. C. (2004). MUSCLE: multiple sequence alignment with high accuracy and high throughput. Nucleic acids research, 32(5), 1792-1797.](https://academic.oup.com/nar/article/32/5/1792/2380623)  
T-Coffee:  [Notredame, C., Higgins, D. G., & Heringa, J. (2000). T-Coffee: A novel method for fast and accurate multiple sequence alignment. Journal of molecular biology, 302(1), 205-217.](https://www.sciencedirect.com/science/article/pii/S0022283600940427)  
Clustal W: [Larkin, M. A., Blackshields, G., Brown, N. P., Chenna, R., McGettigan, P. A., McWilliam, H., Valentin, F., Wallace, I.M., Wilm, A., Lopez, R., Thompson, J.D., Gibson, T.J., & Higgins, D. G. (2007). Clustal W and Clustal X version 2.0. bioinformatics, 23(21), 2947-2948.](https://academic.oup.com/bioinformatics/article/23/21/2947/371686)
  
  
## Flowchart
![flowchart](Pipeline.png)


## Test
### Example_1  
This example have information about orthologous group obtained from OMA software.  

To run execute  
```
-bash-4.4$ ~/path/Sinox.sh -p protein_directory/ -n nucleotide_directory/ -o Orthologs/ -z 4 -a mafft -g 1 -t OMA -s single-copy
```


### Example_2  
This example have information about orthologous group obtained from a tab-delimited text file generated manually.   
To run execute  
```
-bash-4.4$ ~/path/Sinox.sh -p protein_directory/ -n nucleotide_directory/ -o Orthologs/ -z 4 -a mafft -g 1 -t OMA -s single-copy
```


