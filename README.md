## The advantage of the *lac* operon in *E. coli* - Analysis Pipeline

This repository contains the microbiota analysis pipeline used in the study “The Selective Advantage of the *lac* Operon for *Escherichia coli* Is Conditional on Diet and Microbiota Composition” published in Frontiers in Microbiology (https://doi.org/10.3389/fmicb.2021.709259). 
This repository contains scripts and workflows for microbiota analysis using QIIME2 and R, as well as statistical modeling using mixed models.

## Requirements for the microbiota analysis

-   QIIME2 (version used in the study: 2020.8)
-   Conda (for environment management)
-   Python (required for QIIME2)
-   FASTQ files (paired-end reads from Illumina sequencing)
-  R (version used in the study: 3.6.3)

### 1. Microbiota Analysis in QIIME2

#### **Workflow Overview**

1.  **Importing Data**
    
    -   Sequence data is imported into QIIME2 and demultiplexed.
        
2.  **Quality Control & Denoising**
    
    -   `Deblur` is used to filter and denoise sequences, remove chimeras, and infer amplicon sequence variants (ASVs).
        
3.  **Taxonomic Classification**
    
    -   ASVs are classified using a pre-trained classifier based on the Greengenes database.
        
4.  **Diversity Analysis**
    
    -   Alpha and beta diversity metrics are computed and visualized.
        
5.  **Differential Abundance Analysis**
    
    -   Statistical tests (e.g., LEfSe, ANCOM) are used to identify differentially abundant taxa between groups (not used in this particular paper).

#### **Command Examples**
```
qiime tools import --type SampleData[PairedEndSequencesWithQuality] --input-path manifest.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33V2
qiime dada2 denoise-paired --i-demultiplexed-seqs demux.qza --p-trunc-len-f 200 --p-trunc-len-r 200 --o-representative-sequences rep-seqs.qza --o-table table.qza
```

### **2. Microbiota Analysis in R**

#### **Workflow Overview**

1.  **Data Import & Preprocessing**
    
    -   Microbiota data tables from QIIME2 (`table.qza`) are imported into R.
        
    -   ASV tables and metadata are merged for analysis.
        
2.  **Beta Diversity Calculations**
 
    -   Beta diversity visualized via NMDS plots.

    
## Mixed Model Analysis

This repository also contains an R script for mixed model analysis of bacterial load data across multiple treatment groups and time points. The analysis is performed using linear mixed-effects models with the `lme4` package. The script follows a standardized workflow for different datasets.

### **Workflow Overview**

1.  **Load Data**
    
    -   The dataset is assigned to `data1` for analysis.
        
    -   The dataset used in the example is `Average_total_loads_E_coli_per_treatment_ANOVA`.
        
2.  **Model Fitting**
    
    -   The model is defined using `lmer(loads ~ group * day + (1|id), data = dataset)`, where:
        
        -   `loads` is the dependent variable.
            
        -   `group` and `day` are fixed effects.
            
        -   `(1|id)` is a random intercept for individual subjects.
            
    -   The model is fitted using the `lmer()` function from `lme4`.
        
3.  **Statistical Analysis**
    
    -   Type III ANOVA is performed using the `Anova()` function from `car`.
    -   Model quality is assessed using `r.squaredGLMM()` from `MuMIn`.

    -   Residuals are extracted and assessed for normality using Q-Q plots.
        
4.  **Post-hoc Comparisons**
    
    -   Estimated marginal means are computed using `lsmeans()`.
    -   Specific contrasts between factor levels are defined manually in `ContrastVec`.
    -   Pairwise comparisons are performed using the `contrast()` function with Bonferroni adjustment.
        
5.  **Exporting Results**
    
    -   The reference table for comparisons (`ref1`) is saved as an Excel file using `write.xlsx()`.
        

### **Dependencies**

Ensure the following R packages are installed before running the script:

-   `lme4`
    
-   `car`
    
-   `MuMIn`
    
-   `gmodels`
    
-   `lsmeans`
    
-   `xlsx`
    

## Source

This analysis was performed by Rita Melo-Miranda and results in the data presented in:  
Pinto C, Melo-Miranda R, Gordo I and Sousa A (2021) The Selective Advantage of the *lac* Operon for *Escherichia coli I*s Conditional on Diet and Microbiota Composition. Front. Microbiol. 12:709259.
