#!/bin/bash

function helpPanel(){
	echo -e "Welcome to PANAS v.1: Pipeline for the Analysis of Nonsynonymous And Synonymous substitutions."
	echo -e "For more detailed usage information, please review the README file provided with this distribution."
	echo -e "\t-p:\t Directory containing the protein file(s) in Fasta format. [required]"
	echo -e "\t-n:\t Directory containing the nucleotide file(s) in Fasta format. [required]"
	echo -e "\t-o:\t Directory containing information on orthologous groups. If you ran OMA, you can use the PairwiseOrthologs file. [required]"
	echo -e "\t-z:\t Process number used during alignment. It is used by the ParaAT program. [required]"
	echo -e "\t-a:\t Aligner used (clustalw2 | t_coffee | mafft | muscle). Default mafft. [optional]"
	echo -e "\t-g:\t Genetic Code used. Default is 1 (The Standard Code). For more information see ParaAT documentation [optional]"
	echo -e "\t-t:\t Format type of the file(s) containing orthologous group (OMA | other).  If the data of the orthologous groups correspond to the PairwiseOrthologs format (of OMA), choose OMA [required]"
	echo -e "\t-s:\t (single-copy|multiple-copy)[required]. Allows you to choose wheter to perform the analysis using only the information from single copy or multiple copy orthologous groups. [required]" 
	echo -e "\t-h:\t Help"
	echo -e "Example:\t ~/path/PANAS.sh -p protein_directory/ -n nucleotide_directory/ -o Orthologs/ -z 4 -a mafft -g 1 -t OMA -s single-copy"
	tput cnorm; exit 1
}
#####Main Function
declare -i parameter_counter=0; while getopts ":p:n:o:z:a:g:t:s:h:" arg; do
	case $arg in
		p) Protein=$OPTARG; let parameter_counter+=1 ;;
		n) Nucleotide=$OPTARG; let parameter_counter+=1 ;;
		o) OG=$OPTARG; let parameter_counter+=1 ;;
		z) Procces=$OPTARG; let parameter_counter+=1 ;;
		a) Aligner=$OPTARG; let parameter_counter+=1 ;;
		g) codegenetic=$OPTARG; let parameter_counter+=1 ;;
		t) type=$OPTARG; let parameter_counter+=1 ;;
		s) single_multiple=$OPTARG; let parameter_counter+=1 ;;
		h) helpPanel ;;
	esac
done


function sinonimo(){
##Search for incorrectly entered parameters or directory names
if [ "$(echo $type)" == "OMA" ] || [ "$(echo $type)" == "other" ] ; then
	if [ "$(timeout 2 wc $single_multiple 2>/dev/null | wc -l)" == "0" ]; then	
		if [ "$(echo $single_multiple)" == "single-copy" ]; then
			echo " "
		else
			if [ "$(echo $single_multiple)" == "multiple-copy" ]; then
				echo " "
			else 
				echo "Correctly specify the -s parameter (single-copy|multiple-copy)"
				exit 1;
			fi
		fi
	else 
		echo "$single_multiple directory already exists. Delete or rename the directory"
		exit 1;
	fi
else
	echo "Correctly specify the type of ortholog files in the -t option (OMA | other)"
	exit 1;	
fi

if [ "$(ls $Protein 2>/dev/null| wc -l )" != "0" ]; then
	if [ "$(ls $Nucleotide 2>/dev/null| wc -l )" != "0" ]; then
		if [ "$(ls $OG 2>/dev/null| wc -l )" != "0" ]; then
			if [[ "$(echo $Procces)" -ge "1"  ]]; then
				which $Aligner > /dev/null
				if [ "$(echo $?)" == "0" ]; then
					if [ "$(echo $Aligner)" == "mafft" ] || [ "$(echo $Aligner)" == "muscle" ] || [ "$(echo $Aligner)" == "clustalw2" ] || [ "$(echo $Aligner)" == "t_coffee" ]; then
						if [ "$(wc codeml.ctl 2>/dev/null| wc -l )" != "0" ]; then
							cat $Protein/* | sed 's/ .*//'| sed 's/-/]/g' | sed 's/*//' > all.pep
							cat $Nucleotide/* | sed 's/ .*//' | sed 's/-/]/g' | sed 's/*//' > all.cds
							echo $Procces > proc
							mkdir $single_multiple
						else
							echo "Missing codeml.ctl file in directory. Copy codeml.ctl to the same directory where the protein, nucleotide and ortholog files are located"
							exit 1;
							fi
					else
						echo "Invalid alignment program. Check that the program is available or your name is spelled correctly"
						exit 1;
						fi		
				else
					echo "Invalid alignment program. Check that the program is available or your name is spelled correctly"
					exit 1;
					fi
			else
				echo "Correctly specify the number of processes"
				exit 1;	
			fi
		else
			echo "Correctly specify the directory containing the ortholog groups"
			exit 1;	
		fi
	else
		echo "Correctly specify the directory containing the nucleotide file(s)"
		exit 1;					
	fi
else
	echo "Correctly specify the directory containing the aminoacid file(s)"
	exit 1;		
fi


codegenetic=$1
echo $Procces > proc
	


hog_individual=$(ls $OG)
### A for loop to start comparing proteins between a pair of species at a time
for i in $hog_individual; do

### A folder will be generated for each species pairwise comparison
	cd $single_multiple
	mkdir $i.carpeta

###Enter the folder of the first pair of species and all the corresponding analyzes will be generated inside
	cd $i.carpeta

###The "PairwiseOrthologs" file where the ortholog information is needs to be modified in order to be used by the following program ParaAT.pl
###Something very important is that if I remove the -v from grep, the analysis will be performed for proteins with paralogs.
	if [ "$(echo $type)" == "OMA" ]; then
		if [ "$(echo $single_multiple)" == "single-copy" ]; then
			grep -v "many" ../../$OG/$i |grep -v "#" | cut -f 3,4 | sed 's/ .*\t/\t/ ; s/ .*//' | sed 's/-/]/g' >  $i.homologos
		else
			if [ "$(echo $single_multiple)" == "multiple-copy" ]; then
				grep "many" ../../$OG/$i |grep -v "#" | cut -f 3,4 | sed 's/ .*\t/\t/ ; s/ .*//' | sed 's/-/]/g' >  $i.homologos
			else
				echo "especifique correctamente parametro -s"
				exit 1;
			fi
		fi
	else
		if [ "$(echo $type)" == "other" ]; then
			cat ../../$OG/$i | sed 's/ .*\t/\t/ ; s/ .*//' | sed 's/-/]/g' >  $i.homologos
		fi
	fi

###Program that aligns paired ortholog proteins. This program needs the orthologous group, amino acid sequence, nucleotide sequence, and process number (proc) files that were generated in the above steps of the script.
	ParaAT.pl -h *.homologos -n ../../all.cds -a ../../all.pep -p ../../proc -o output -f paml -m $Aligner -g -t -c $codegenetic

###The codeml.ctl control file contains information that will be used by the codeml program. The codeml file can only have information about one pair of proteins, so for each paired analysis of genes, the codeml.ctl control file must be modified. The modification is made in the guia.ctl file.
	cp ../../codeml.ctl .
	cd output
	contador=1
	for f in *cds_aln.paml; do
		sed 's/xxxx/'"$f"'/g' ../codeml.ctl |sed 's/yyyy/'"$f"'.mlc/g'  > ../guia.ctl
		echo "Alieneamiento $contador: $f"
		let contador+=1
		codeml ../guia.ctl
		rm rst rst1 rub 2ML.dN 2ML.dS 2ML.t 2NG.dN 2NG.dS 2NG.t   ;
	done
	cd ..

###Step to filter and order the information generated in the analysis.
	tail -q -n1 output/*mlc | grep  "dN/dS"  | sed 's/ S=/\tS=\t/g' | sed 's/ N=/\tN=\t/g'|sed 's/ dN\/dS=/\tdN\/dS=\t/g'| sed 's/ dN =/\tdN=\t/g'   |sed 's/ dS =/\tdS=\t/g' | sed 's/t=/'"$i"'\t/g' | cut -f 1,7,8,9,10,11,12 > Resultados.$i.vic  
	grep "CODONML (in paml version 4.9j, February 2020)  " output/*mlc | sed 's/CODONML (in paml version 4.9j, February 2020)  //g' | sed 's/.cds_aln.paml//g'|sed 's/.*mlc://'  > borrar
	paste borrar Resultados.$i.vic |sed 's/output\///g' | awk  -F"\t"   '{print $1"\t"$2"\t"$2"\t"$4"\t"$6"\t"$8"\t'"$single_multiple"' OGs"}'| sed 's/-/\t/ ; s/-/\t/ ; s/]/-/g'|  sed  '1i ID_1\tID_2\tSpecies_1\tSpecies_2\tPairwiseOrthologs\tKa_Ks\tKa\tKs\tHOG' > Resultados.$i.vic2 
	rm borrar
	cd ..;
done

###In the main directory we will join all the information of the results files that were generated. Let us remember that for each paired comparison of species, a results file will be generated. With this step we join all the information.
cat *carpeta/*.vic2 | grep -v 'Ka_Ks'| sed  '1i ID_1\tID_2\tSpecies_1\tSpecies_2\tPairwiseOrthologs\tKa_Ks\tKa\tKs\tHOG' > ../Todos_resultados_$single_multiple
}



## Execution of the sinonimo function
if [ $parameter_counter -eq 0 ]; then 
	echo "Enter mandatory parameters"
	helpPanel
else
	if [ ! "$Protein" ]; then
		echo "Some required parameters are empty"
		helpPanel; exit
	else
		if [ ! "$Nucleotide" ]; then
			echo "Correctly enter the name of the directory of the nucleotide sequences"
			helpPanel; exit
		else
			if [ ! "$OG" ]; then
				echo "Correctly enter the name of the directory of the orthologous groups"
				helpPanel; exit
			else
				if [ ! "$Procces" ]; then
					echo "Correctly enter number of processors"
					helpPanel; exit
				else
					if [ ! "$codegenetic" ]; then
						echo "Missing genetic code. Standard code 1 will be used"
						codegenetic=1
						sinonimo $codegenetic
					else
						if [ $codegenetic -gt "0" ] && [ $codegenetic -lt "22" ] ; then
							sinonimo $codegenetic
						else
							echo "Correctly enter the genetic code (1-21), or do not specify -g parameter"
							helpPanel; exit	
						fi							
					fi
				fi
			fi
		fi
	fi	
fi


