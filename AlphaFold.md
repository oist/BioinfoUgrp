# Alphafold 2.0 @ SAION

*Disclaimer: this implementation was made for general use with the help of Jan Moren of SCS. I do take no responsibility for bugs or errors, but if you could report them, I will gladly try to fix on my extra time. Nonetheless, the AF2 predictions appear to be working. Feel free but not obligated to acknowledge me or at least the SCS if this work was helpful for your research.*

In order to use AF2, you need [SAION access](https://oist.service-now.com/sp?id=sc_category&sys_id=9c71871fdbcdeb806885f00ebf961928) and have basic knowledge of the [terminal](https://groups.oist.jp/scs/basic-linux-commands) and [slurm submission commands](https://groups.oist.jp/scs/use-slurm).  
AF2 is part of the OIST [Bioinfo User group] (https://github.com/oist/BioinfoUgrp).  
AF2 was implemented using the [docker image](https://hub.docker.com/r/uvarc/alphafold) made by the University of Virginia, that here we gratefully acknowledge.
## AF2 content
* 'alphafold_2.0.0.sif': singularity image created from the previously mentioned docker file
* 'run_alphafold.sh': AF2 run script. Contains the default parameters (except input file and output folder). DO NOT MODIFY
* 'alphafold_example_script.sh': AF2 sbatch example. Copy to your folder and modify (add input file and output folder paths).
* 'get_plddt_attribfile.py': Chimera attribute file generator. Automatically generates an attribute file for plddt coloring in chimera.


## Example run
Assume to have a folder in /work with the input single protein sequence: example.fasta and a test output folder: test_out/ .  
Copy the example script:
> cp /apps/unit/BioinfoUgrp/alphafold/2.0.0/bin/alphafold_example_script.sh .  

Change the file name and modify the input and output folder paths, using your favourite text editor:  

> mv alphafold_example_script.sh AF2_testrun.sh  
> vim AF2_testrun.sh 
> (change input file and output folder, save and exit)  

OPTIONAL: CHECK IF THE RESOURCES YOU ARE REQUESTING VIA SLURM ARE ENOUGH (by default 8cpu cores and 100GB)    
   
Submit the job: 

> sbatch AF2_testrun.sh 

The job is expected to take 5+ hours for long proteins, so try to run overnight and check the results the next day.

## Output
A description of the output can be found in [AlphaFold 2 Github page](https://github.com/deepmind/alphafold/blob/main/README.md#alphafold-output).  
However, for lazy people, ranked_0.pdb is the highest scoring model.

## Example script
For convenience, we report here the example script content. 

> #!/bin/bash  
> #SBATCH --job-name=test_af  
> #SBATCH -c 8  
> #SBATCH --mem=100G  
> #SBATCH --partition=gpu  
> #SBATCH -t 4-0  
> #SBATCH --gres=gpu:1  
>   
> module load bioinfo-ugrp-modules  
> module load alphafold/2.0.0 
>   
> run_alphafold.sh --fasta_paths nvec_nrxn.fa --output_dir test_output  

## Attrib file
If you use Chimera to visualize the pdb file, you might be interested to per-residue plddt coloring. plddt is the self-evaluated confidence measure of the prediction of alphafold2. It goes from 0 (low confidence) to 100 (high confidence). A low value indicates either badly predicted regions or disordered regions.   
To automatically generate a chimera attribute file for coloring by plddt, you can use the python script I made:
> python /apps/unit/BioinfoUgrp/alphafold/2.0.0/bin/get_plddt_attribfile.py <result_model_X.pkl> <outfile.txt>   
The text file generated can be used in Chimera (Tools > Structure Analysis > Define Attribute) after opening the same pdb model.   

## Appendix: parameters
This is a list of all the default parameters in the run_alphafold script. If you want to modify them, do not change the default script. Instead, provide them to the example run script just like the input fasta and output folder.
Default parameters:
> MAX_TEMPLATE_DATE=2030-09-09   
> MODEL_NAMES=model_1,model_2,model_3,model_4,model_5   
> DATA_DIR=/apps/unit/BioinfoUgrp/alphafold/database/   
> UNIREF90_PATH=$DATA_DIR/uniref90/uniref90.fasta   
> MGNIFY_PATH=$DATA_DIR/mgnify/mgy_clusters.fa   
> UNICLUST30_PATH=$DATA_DIR/uniclust30/uniclust30_2018_08/uniclust30_2018_08   
> BFD_PATH=$DATA_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt   
> PDB70_PATH=$DATA_DIR/pdb70/pdb70   
> TEMPLATE_PATH=$DATA_DIR/pdb_mmcif/mmcif_files/   
> OBSOLETE_PATH=$DATA_DIR/pdb_mmcif/obsolete.dat   

## Appendix: contact
Stefano Pascarelli, PhD, Laurino unit
