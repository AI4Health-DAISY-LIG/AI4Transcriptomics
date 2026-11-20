# Course 4: From Biology to Digital Counts

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 4, From Biology to Digital Counts (20:19), SandrineTeach channel [https://www.youtube.com/watch?v=jYPFTpsbMX4](https://www.youtube.com/watch?v=jYPFTpsbMX4)

**Sources and further reading**

- Stark R., Grzelak M., Hadfield J. RNA sequencing: the teenage years. *Nature Reviews Genetics* 20:631–656 (2019). The best single review of the technology, and the first text to read after this course.
- Conesa A. et al. A survey of best practices for RNA-seq data analysis. *Genome Biology* 17:13 (2016). A practical paper on analysis.
- Leek J.T. et al. Tackling the widespread and critical impact of batch effects in high-throughput data. *Nature Reviews Genetics* 11:733–739 (2010). The paper that named the problem for the field.
- Svensson V. Droplet scRNA-seq is not zero-inflated. *Nature Biotechnology* 38:147–150 (2020). Three pages, and a model of how to question a consensus.
- Luecken M.D., Theis F.J. Current best practices in single-cell RNA-seq analysis: a tutorial. *Molecular Systems Biology* 15:e8746 (2019).
- MIT 7.91J / 20.490, Foundations of Computational and Systems Biology, MIT OpenCourseWare, with lecture videos. The algorithmic companion to the introductory biology course of Eric Lander. [https://ocw.mit.edu/courses/7-91j-foundations-of-computational-and-systems-biology-spring-2014/](https://ocw.mit.edu/courses/7-91j-foundations-of-computational-and-systems-biology-spring-2014/)

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=0s) |
| 2. From tube to table: six steps, six biases | [0:57](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=57s) |
| 3. The output of a sequencer | [4:10](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=250s) |
| 4. Bulk, single-cell and spatial: different questions | [6:14](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=374s) |
| 5. Barcodes and UMIs | [9:00](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=540s) |
| 6. Stochasticity, dropout, and the ambiguous zero | [11:25](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=685s) |
| 7. Batch effects and experimental design | [14:22](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=862s) |
| 8. Vocabulary | [17:26](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=1046s) |
| 9. Summary and next course | [19:47](https://www.youtube.com/watch?v=jYPFTpsbMX4&t=1187s) |

---

## 1. Introduction

This course is where the two halves of the class meet. It is compulsory for all students, biologists and engineers, for opposite reasons.

Biologists know the bench protocol. They may not have asked which step introduces which statistical property, and the answer decides whether an analysis is valid.

Engineers know how to fit a model to a matrix. They have not yet seen that this matrix results from a long physical process, with a dozen points where bias can enter. In this field, most of the interesting failures occur upstream of the model, when the analyst does not know what the matrix represents.

The course follows one arrow, from a molecule in a cell to an integer in a table.

## 2. From tube to table: six steps, six biases

An RNA-seq experiment has six steps. Each one introduces a bias.

**1. Extraction.** The experimenter breaks the cells open and releases their RNA into a buffer that contains an RNase inhibitor, because RNA degrades fast. Cell types break open at different rates, and lysis is itself a stress for the cell (Course 2).

**2. Selection.** Ribosomal RNA, the structural RNA of the ribosome, makes up 80 to 90 % of the RNA in a cell and carries no information on gene expression. The protocol either captures messenger RNAs by their poly-A tail, the string of adenines at their end, or removes the ribosomal RNA. The two routes keep different molecules and give different results. They should not be mixed within one study.

**3. Complementary DNA (cDNA) synthesis.** This step runs the central dogma backwards. The enzyme reverse transcriptase copies RNA into DNA, because DNA is stable and sequencers read DNA. The copy starts from a primer: either oligo-dT, a short string of thymines that binds the poly-A tail, or random hexamers, short random sequences that bind anywhere. The step is inefficient, and the enzyme never converts a large fraction of the molecules. In bulk data, with millions of cells, the loss averages out. In single-cell data, where a gene may have three copies in a cell, it does not. This is the origin of dropout (section 6).

**4. Library preparation.** This step groups three operations.

- *Fragmentation.* A long transcript gives more fragments than a short one, so counts grow with gene length, and the analysis must correct for this.
- *Adapter ligation.* Adapters are the handles that attach a fragment to the sequencer and carry the sample barcode. Their attachment efficiency depends on the sequence.
- *PCR.* PCR copies each fragment many times, exponentially and unevenly: fragments with a high or a low share of G and C bases amplify less well. After PCR, ten molecules cannot be told apart from one molecule copied ten times. Section 5 gives the solution.

**5. Sequencing.** The sequencer reads the flow cell, a glass slide covered with millions of fragments, base by base and in parallel. One run produces millions to billions of reads.

**6. Data analysis.** The reads carry no gene names. The assignment of each read to a gene is a computational step with its own choices, and the subject of Course 5.

Each step filters or distorts. **The count matrix measures what survived this chain.** This statement holds for the rest of the block.

## 3. The output of a sequencer

The instrument delivers a collection of short strings in a text format named FASTQ, with four lines per read:

1. an identifier that starts with `@`;
2. the sequence of bases: A, C, G and T;
3. a separator, `+`;
4. a quality string, with one character per base that encodes the confidence of the instrument in that base.

This confidence is a Phred score. Phred 30 means one chance in a thousand that the base is wrong. Phred 20 means one in a hundred.

Two parameters appear in the methods section of each RNA-seq paper.

**Read length and layout.** Reads typically have 50 to 150 bases and are single-end or paired-end. In paired-end sequencing, the instrument reads the fragment from both ends, which helps with splice junctions and with isoforms, the different transcripts made from one gene.

**Depth.** Depth is the number of reads per sample. For bulk differential expression, the usual range is 20 to 50 million reads per sample. Extra depth adds little for highly expressed genes, which are already well measured. It allows the detection of lowly expressed genes, so depth extends the dynamic range downwards. A related term is coverage: the average number of reads that fall on each base. Depth is counted per sample, and coverage per position.

The first line of each read records the instrument, the run, the flow cell and the lane. The batch is therefore written into each read, a fact used in section 7.

For engineers, the key observation is that reads carry no gene labels. Nothing in a FASTQ file says *ACTB*, the name of the actin gene. The conversion of anonymous strings into counts per gene is a computational problem, named alignment and quantification, and the subject of Course 5.

## 4. Bulk, single-cell and spatial: different questions

Three technologies answer different questions. An analogy with fruit helps to remember them: the smoothie, the fruit salad and the tart.

| | Bulk RNA-seq (smoothie) | Single-cell RNA-seq (fruit salad) | Spatial transcriptomics (tart) |
|---|---|---|---|
| Principle | The tissue is blended and the average is measured | The cells are separated and each one is profiled | The arrangement of the cells is kept |
| Gain | One deep profile per sample, with little noise, for about 100 € per sample | Cell types, rare populations, cell states | Position in the tissue |
| Cost | No information on which cells contributed | Shallow and noisy measurement of each cell; a dissociation step that stresses the cells | Lower resolution, or fewer genes |
| Matrix | About 20,000 genes × a few dozen samples | 20,000 genes × thousands to millions of cells, mostly zeros | Genes × spots or cells |

In bulk data, a disease that changes what a cell type does and a disease that only changes the number of those cells give the same picture. This is the main confounder of Course 2: proportions versus programs.

In single-cell data, the same sequencing budget is split across thousands of cells, which explains the shallow measurement of each one.

Spatial methods form two families. Sequencing-based methods such as Visium measure the whole transcriptome on spots of 55 µm that hold one to ten cells each, so the resolution is close to, but above, the single cell. Imaging-based methods such as MERFISH or Xenium reach single cells and even locations inside the cell, for a panel of a few hundred to a few thousand genes chosen in advance.

The video lecture shows a study that applied all three technologies to the same disease, the progression from inflammatory bowel disease to colorectal cancer. The bulk analysis includes 415 patients, the single-cell analysis 18, and the spatial analysis a few tissue sections. The number of individuals falls at each finer resolution.

The question determines the technology, with the trade-off that matches it. For "which pathway differs between responders and non-responders in a hundred patients", bulk RNA-seq is the right instrument, and its sample size gives its statistical power. For "which cell type is responsible", bulk data cannot answer at any depth.

## 5. Barcodes and UMIs

The aim is to sequence thousands of cells at once and still know which read came from which cell. Zheng and colleagues introduced the 10x Genomics droplet system for this purpose in 2017.

The instrument captures each cell in a small droplet of oil together with one gel bead. Each short DNA strand (oligonucleotide) on that bead carries three elements: the same cell barcode, a random UMI, and an oligo-dT that binds the poly-A tail of the messenger RNA, as in step 3 of section 2.

**The cell barcode** labels the droplet, and therefore the cell. In the current version-3 chemistry it has sixteen bases, chosen from a known list. (The figure of the original paper shows the 2017 chemistry, with other lengths.) Sorting the reads by barcode is called demultiplexing, and it gives one column per cell in the matrix.

**The UMI**, unique molecular identifier, is a random sequence of twelve bases in version 3. Reverse transcription attaches it to each molecule before amplification. Twelve bases with four possible letters give 4^12, about 16.7 million combinations. This number far exceeds the number of molecules in one cell, so each original molecule receives its own tag.

**Worked example.** Five reads come from the same gene in the same cell. Three share one UMI, and the other two each have their own. The cell therefore contained three molecules. The three identical reads are PCR copies of one molecule, and the analysis collapses them into one. This operation is deduplication, and it converts read counts into molecule counts.

One point is essential. UMIs correct amplification noise and do nothing about capture. The protocol captures and converts only 10 to 20 % of the molecules. A molecule that was never reverse-transcribed has no UMI and stays invisible. Deduplication cannot restore it, and UMI data still contain dropout.

## 6. Stochasticity, dropout, and the ambiguous zero

Engineers often find this section the most disorienting of the block.

Take a gene with five mRNA copies in one cell. Droplet protocols capture about 10 to 20 % of the molecules. At 10 %, the expected capture is half a molecule. The number captured follows, to a good approximation, a Poisson distribution, so the probability of capturing none is e^(−0.5), about 61 %. For a gene that the cell does express, the most likely observation is therefore zero. This phenomenon is called dropout. It results from sampling, and the instrument works as designed.

A zero in a count matrix can therefore have three meanings (Jiang and colleagues illustrate the first two).

1. **Biological zero.** The cell contains no mRNA for this gene: the gene is not transcribed, or the cell degrades the messenger faster than it makes it. This is the information that the experiment seeks.
2. **Technical or sampling zero.** The messenger is present and was not counted. Either the library preparation lost it (a technical zero), or the sequencing did not reach it (a sampling zero). This case is far more frequent than beginners assume.
3. **Assignment failure.** The sequencer read the molecule, and the software could not assign the read to a gene, for example because it fell in a repetitive region of the genome. This case arises after sequencing and belongs to Course 5.

Nothing in the matrix indicates which of the three applies. In droplet data, 90 % or more of the entries are typically zeros. This property is called sparsity, and it shapes the storage and the modelling of the data.

For years, researchers added a zero-inflation component to their statistical models, on the assumption that the data contained more zeros than a count model predicts. In 2020, Valentine Svensson showed that for UMI droplet data a plain negative binomial distribution already predicts these zeros. The zeros remain ambiguous, and their number is the number that a count model expects. Course 6 builds this model.

Two rules follow.

- **Zeros are never imputed without an explicit statement.** Imputation fills in values and can create structure, and downstream tests then report that structure as significant.
- **Raw counts are never given to a method that assumes constant variance.** In count data, the variance grows faster than the mean. This is overdispersion, and it is the reason for negative binomial models and log transformations.

## 7. Batch effects and experimental design

This last technical section matters most for the design of an experiment.

A **batch effect** is any systematic technical difference between samples processed separately: a different day, reagent lot, operator, sequencing run or hospital. These effects are large. In many datasets, the first principal component separates the batches and not the biological conditions. Leek and colleagues made this point for the whole field in 2010.

The video lecture illustrates the effect with simulated data. Each sample is placed on its first two principal components (the usual PCA, applied to samples described by their gene expression). Colour gives the condition, patient or control, and shape gives the processing batch.

**Confounded design.** All patients are processed in batch 1 and all controls in batch 2. Two clean clusters appear along PC1, and it is tempting to call this the disease signature. On PC1, however, batch and disease are the same vector. No method can separate them: not ComBat, not limma, not Harmony, not a variational autoencoder. Removing the batch removes the disease with it.

**Blocked design.** Each batch contains patients and controls. Batch now spreads the samples along PC1 and disease along PC2. The two effects point in different directions, so batch can enter the model as a covariate and the biology is kept.

A real case shows the stakes. In 2014, the Mouse ENCODE consortium reported that human and mouse tissues clustered by species and not by tissue type. Gilad and Mizrahi-Man then read the FASTQ headers (section 3) and found that the samples of the two species had largely been sequenced on different lanes. After correction for that batch, the samples clustered by tissue. Those data cannot show whether the correction also removed real differences between species.

The remedy has three parts: **randomise, block, record.**

- Randomise the assignment of samples to batches.
- Block, by placing part of each group in each batch.
- Record each technical variable: date, operator, reagent lot, RNA quality, sequencing run.

A recorded batch can be modelled as a covariate. An unrecorded batch becomes noise that the analysis attributes to biology.

For the second assignment, the first step is to open the sample metadata and check the design. Confounding is more frequent than expected, including in good journals. A language model asked to "analyse this dataset" does not check the design unless the user knows to ask.

## 8. Vocabulary

The terms of this course for the mind map. This is the densest vocabulary list of the block, and the first assignment relies on it most, because biology and statistics meet here.

- **Library construction:** reverse transcription, complementary DNA, oligo-dT, random hexamer, library preparation, adapter, PCR amplification, GC bias, fragmentation.
- **Sequencing output:** FASTQ, read, Phred score, read length, single-end, paired-end, sequencing depth, coverage.
- **Technologies:** bulk RNA-seq, single-cell RNA-seq, spatial transcriptomics, Visium, resolution.
- **Molecular labels:** cell barcode, unique molecular identifier, demultiplexing, deduplication.
- **Count statistics:** capture efficiency, dropout, sparsity, zero inflation, negative binomial, overdispersion.
- **Design:** batch effect, confounding, randomisation, blocking, covariate, experimental design.

## 9. Summary and next course

Six steps separate a molecule from a count, and each one filters or distorts. A FASTQ file contains anonymous reads with a quality score and a record of the batch. Bulk, single-cell and spatial methods trade the number of individuals against resolution. Barcodes and UMIs identify cells and molecules, and they do not correct capture losses, so zeros stay ambiguous. A design that confounds batch and condition cannot be repaired by analysis.

The next tutorial presents the overview of Part 2, forms the groups, and introduces the three project papers. Course 5 opens Part 2 and the practical work. It converts the anonymous reads into a matrix: alignment, pseudo-alignment, and the choice between them.
