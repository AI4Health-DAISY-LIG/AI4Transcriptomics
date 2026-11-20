# Course 5: The Quantification Pipeline: Alignment and Counting

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 5, The Quantification Pipeline (20:29), SandrineTeach channel [https://www.youtube.com/watch?v=5Y9MOAkUVHQ](https://www.youtube.com/watch?v=5Y9MOAkUVHQ)

**Sources and further reading**

- Dobin A. et al. STAR: ultrafast universal RNA-seq aligner. *Bioinformatics* 29:15–21 (2013).
- Kim D., Langmead B., Salzberg S.L. HISAT: a fast spliced aligner with low memory requirements. *Nature Methods* 12:357–360 (2015).
- Patro R. et al. Salmon provides fast and bias-aware quantification of transcript expression. *Nature Methods* 14:417–419 (2017).
- Bray N.L. et al. Near-optimal probabilistic RNA-seq quantification (kallisto). *Nature Biotechnology* 34:525–527 (2016).
- Liao Y., Smyth G.K., Shi W. featureCounts: an efficient general purpose program for assigning sequence reads to genomic features. *Bioinformatics* 30:923–930 (2014).
- Soneson C., Love M.I., Robinson M.D. Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences. *F1000Research* 4:1521 (2015).
- Srivastava A. et al. Alignment and mapping methodology influence transcript abundance estimation (salmon selective alignment). *Genome Biology* 21:239 (2020).
- Zhao S., Zhang B. A comprehensive evaluation of Ensembl, RefSeq, and UCSC annotations in the context of RNA-seq read mapping and gene quantification. *BMC Genomics* 16:97 (2015).
- Liao Y., Shi W. Read trimming is not required for mapping and quantification of RNA-seq reads at the gene level. *NAR Genomics and Bioinformatics* 2:lqaa068 (2020).
- Ewels P. et al. MultiQC: summarize analysis results for multiple tools and samples in a single report. *Bioinformatics* 32:3047–3048 (2016).
- nf-core/rnaseq: a community, versioned, containerised RNA-seq pipeline, and an example of a fully specified pipeline. [https://nf-co.re/rnaseq](https://nf-co.re/rnaseq)
- Galaxy Training Network: hands-on RNA-seq tutorials on Galaxy; the French national server is UseGalaxy.fr (IFB). [https://training.galaxyproject.org](https://training.galaxyproject.org)
- MIT 7.91J, Foundations of Computational and Systems Biology, MIT OpenCourseWare: suffix arrays, the Burrows–Wheeler transform, alignment as dynamic programming. [https://ocw.mit.edu/courses/7-91j-foundations-of-computational-and-systems-biology-spring-2014/](https://ocw.mit.edu/courses/7-91j-foundations-of-computational-and-systems-biology-spring-2014/)

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=0s) |
| 2. Read quality control and trimming | [1:06](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=66s) |
| 3. Alignment: more than string matching | [2:53](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=173s) |
| 4. The reference and the annotation | [5:33](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=333s) |
| 5. Gene identifiers: one gene, many RNAs, many names | [7:14](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=434s) |
| 6. Counting: from alignments to genes | [9:28](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=568s) |
| 7. The light path: salmon and kallisto | [11:19](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=679s) |
| 8. Reading the QC report (1): FastQC flags and MultiQC | [13:52](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=832s) |
| 9. Reading the QC report (2): four numbers, by group | [15:19](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=919s) |
| 10. Provenance of a count matrix | [16:43](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=1003s) |
| 11. Vocabulary | [18:24](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=1104s) |
| 12. Summary and next course | [19:51](https://www.youtube.com/watch?v=5Y9MOAkUVHQ&t=1191s) |

---

## 1. Introduction

This course opens Part 2 of the block, which covers the computational side.

Course 4 ended with a collection of short, anonymous strings produced by the sequencer. This course converts them into a matrix. The problem can be stated as any computational problem.

- **Input:** fifty million reads of about a hundred bases each, and a reference genome of three billion bases annotated with about twenty thousand genes.
- **Output:** for each gene, the number of reads that came from it.

Students do not run this step in the practicals. Their work starts from count matrices, because the second assignment concerns the analysis. A count matrix downloaded from a public repository nevertheless carries each decision described in this course, made by someone else. These decisions shape the numbers, and the analyst needs to know them.

## 2. Read quality control and trimming

The reads are examined before any alignment. The standard tool is FastQC, and two of its plots are read most often.

**Per-base quality.** A gentle decline towards the three-prime end of the read is normal. An abrupt drop, for example after cycle seventy, indicates a problem with the sequencing run.

**Adapter content.** Adapters are the handles that attach a fragment to the sequencer (Course 4). If a fragment is shorter than the read, the sequencer reads through it and into the adapter. With fragments of about 120 bases and reads of 100 bases, a third of the reads end in adapter sequence, a technical addition with no biological origin. A third plot, over-represented sequences, often reveals residual ribosomal RNA or a technical artefact.

Should the reads be trimmed? Tools exist: cutadapt, Trim Galore, fastp. The first instinct is to remove each part that looks bad. Modern aligners, however, soft-clip: they ignore read ends that do not align, adapters included. Liao and Shi (2020) found that untrimmed reads quantify genes as well as trimmed ones, or slightly better. Williams and colleagues showed that aggressive quality trimming can shift expression estimates. Light adapter trimming therefore does little harm, and aggressive quality trimming can do some. Researchers still disagree on this point, and no single answer is established.

## 3. Alignment: more than string matching

At first sight, alignment is a search problem: find where a string of a hundred characters occurs in a text of three billion characters. Two facts make it harder.

**The reference is not the sample.** A patient carries genetic variants, including small insertions and deletions, and the sequencer makes errors. The search therefore requires approximate matching, performed fifty million times per sample.

**The reads come from spliced RNA.** Reads derive from mature messenger RNA, from which the cell has removed the introns. The reference is genomic DNA, which still contains them. Consider a read whose first forty bases match the end of exon 3 and whose last sixty match the start of exon 4, with twelve thousand bases of intron between the two in the genome. No contiguous match exists. In human tissues, about a quarter of all mapped reads have this form.

Splice-aware aligners solve this problem: STAR (Dobin and colleagues) and HISAT2. They place one read across a gap of tens of kilobases and record the alignment in a compact code, the CIGAR string: forty matched, twelve thousand skipped, sixty matched (`40M12000N60M`).

The two aligners differ in cost.

| | Speed | Memory |
|---|---|---|
| STAR | more than 500 million read pairs per hour on a twelve-core server, so 5 to 10 minutes for a sample of 50 million reads | about 32 GB; the human index is built once, in about an hour |
| HISAT2 | similar | 4 to 8 GB |

For fifty samples, either of them calls for a server.

The output is a SAM file, or its compressed binary form, BAM, handled with samtools. Each read receives one line with its position, its strand, its CIGAR string and a mapping quality.

One category of reads causes the most difficulty: the **multi-mapping read**, which aligns equally well to a gene and to a close relative elsewhere in the genome, a paralogue. STAR encodes this in the mapping quality: 255 for a unique position, 3 for two possible positions, 1 for three or four, 0 for more. The treatment of these reads is one of the main reasons why two pipelines disagree.

## 4. The reference and the annotation

Alignment needs three inputs, and the first two are often confused.

- **The reference genome** is a FASTA file: the sequence of the chromosomes. For human, the standard is GRCh38, and T2T-CHM13 is the newer, complete assembly.
- **The annotation** is a GTF or GFF file: a table which states that a gene occupies given coordinates and has given transcripts, made of given exons. It contains no sequence, only labels placed on the genome.
- **The index** is the precomputed data structure of the aligner, built once and reused for each sample.

The human genome has more than one annotation. Ensembl and GENCODE are in practice the same gene set, released together. The alternative is RefSeq, from the NCBI, a more conservative catalogue. Zhao and Zhang (2015) compared three catalogues: about 22,000 genes are common to all three, more than 33,000 exist only in Ensembl, and a few thousand more exist only in RefGene or only in UCSC. In their study, the choice of annotation had a large effect on gene quantification and on differential expression.

The same BAM file counted against two annotations gives two different matrices. A methods section that states only "reads were mapped to the human genome" cannot be reproduced. For the assignment, students check that the paper names the genome build, the annotation source and its release number.

## 5. Gene identifiers: one gene, many RNAs, many names

A distinction is needed each time a count matrix is opened: a gene is not an RNA molecule.

A gene is a location on the DNA. *SEPTIN9*, on chromosome 17, has one permanent identifier, ENSG00000184640. The cell transcribes this one locus into many different RNA molecules, named transcripts or isoforms, through alternative promoters and alternative splicing. Each has its own ENST identifier, and Ensembl lists dozens for this gene. Ribosomes translate some of them into proteins, each with an ENSP identifier; UniProt names the main one Septin-9. Sequencing measures the RNA molecules, and a gene-level count sums over all of them.

This one gene carries about twenty other names, with two origins.

**Names from biology.** They describe the protein, or the circumstances of its discovery, and were transferred to the gene. MSF (MLL septin-like fusion) and AF17q25 both come from a leukaemia in which this gene, on band 17q25, is fused to the gene *MLL*. "Ovarian/breast septin" comes from cancer studies. "Peanut-like 4" refers to its resemblance to a fruit-fly gene named *peanut*.

**Names from bioinformatics.** KIAA0991 is a clone number from a large cDNA sequencing project. Naming conventions add variants: human gene symbols are written in upper case and italics (*SEPTIN9*), the mouse gene is *Septin9*, and the protein is written upright.

Symbols also change over time. This gene was named *SEPT9* until spreadsheet software repeatedly converted it into the ninth of September, and the nomenclature committee renamed it. Its Ensembl identifier never changed. The recommendation follows: work with stable identifiers, and convert to symbols only at the end, for display. A merge of two tables on gene symbols loses genes without any warning.

## 6. Counting: from alignments to genes

At this stage we have a BAM file of positioned reads and a GTF file of gene coordinates. Counting intersects the two: for each read, it determines which gene's exons the read overlaps. The standard tools are featureCounts, from the Subread package, which counts a sample in minutes, and HTSeq-count, which gives the same result much more slowly.

Oshlack and colleagues illustrate the reads that a counting rule must sort. For the gene *RBM39*, real data show many reads in regions where no exon is annotated. Reads from a region can originate from coding sequence, exons, introns or splice junctions, and each counting rule keeps a different subset.

Each edge case is a parameter that someone chose.

- Most pipelines do not count intronic reads.
- A read that overlaps two genes is ambiguous. The default mode of HTSeq, named *union*, and featureCounts both discard it.
- Default settings discard multi-mapping reads, so large gene families are undercounted.
- With paired-end data, the unit is the fragment and not the read; otherwise each fragment counts twice.

Each of these choices shifts the counts, because the discarded reads depend on gene family, gene length and repeat content.

The output is a table of raw integer counts. DESeq2 and edgeR require this input, as does PyDESeq2 in the practicals. TPM and FPKM are not acceptable inputs for differential expression. They are within-sample normalisations: they remove the count nature of the data and the variance model on which the tests rely. If a public dataset provides only FPKM, the report must state it and discuss it.

## 7. The light path: salmon and kallisto

Since the mid-2010s, a second route has dominated simple expression studies. If the only question is the abundance of each transcript, the genomic coordinate of each read is unnecessary: the set of transcripts with which the read is compatible suffices. Salmon and kallisto therefore index the transcriptome instead of the genome. Kallisto names this pseudo-alignment; the current method of salmon is selective alignment.

A toy example shows the next step. A gene has two isoforms, T1 and T2. Thirty reads fall in an exon that only T1 has, ten span a junction that only T2 has, and sixty fall in exons common to both. Discarding the sixty shared reads loses most of the data. Splitting them equally ignores the evidence. The tools use the **expectation-maximisation** algorithm: estimate the abundance of each isoform, reassign the shared reads in proportion to it, and repeat until the numbers stabilise. T1 has three times the unique evidence, so it receives three quarters of the shared reads (45) and T2 one quarter (15), for final estimates of 75 and 25 reads. With real data, transcript length also enters the calculation, as the effective length, and salmon corrects in addition for GC content and positional bias.

These tools cost far less. The authors of kallisto quantified thirty million reads in under three minutes on a desktop computer, with an index built in under ten minutes. The analysis takes minutes on a laptop where STAR needs a server. In exchange, the genomic coordinates are lost: novel transcripts, gene fusions and variants cannot be detected, and the result depends entirely on the annotation. A transcript absent from the annotation cannot be found.

The estimates are at transcript level and are fractional numbers. To obtain gene-level input for differential expression, the standard tool is tximport (Soneson, Love and Robinson, 2015). It sums transcripts to genes and passes a length offset to the statistical model, so that the model does not mistake a switch between isoforms for a change in expression.

A rule of thumb: for standard differential expression, salmon or kallisto lose nothing. For splicing, fusions or variants, alignment to the genome is required. In both cases, the report names the tool and its version.

## 8. Reading the QC report (1): FastQC flags and MultiQC

Each pipeline run leaves quality reports, whether the analyst, a core facility or the authors of a paper ran it. FastQC produces one report per sample. MultiQC collects them, together with the logs of STAR, featureCounts or salmon, into a single report for the whole study. When a dataset includes a MultiQC report, it should be opened.

In the FastQC summary, each module receives a green tick, a yellow warning or a red cross. These marks indicate where to look, and they do not replace judgement. The developers calibrated them for random genomic DNA, and some are triggered by good RNA-seq data:

- *per-base sequence content* fails because random-hexamer priming is not fully random over the first bases of the read;
- *duplication* is high because abundant transcripts produce many identical reads.

Neither warning indicates bad data.

Two patterns do deserve concern. A gentle decline in quality towards the end of the read is expected: the fluorescent signal decays, and the molecules in a cluster gradually fall out of phase. A sudden collapse at some cycles, or low quality along the whole read, indicates a problem with the run, and the sequencing facility should be informed.

## 9. Reading the QC report (2): four numbers, by group

From the aligner and the counter, MultiQC reports four further numbers.

1. **Total reads**, the library size. The spread across samples matters: in a sample with a fifth of the reads, zeros have a different meaning.
2. **Percentage uniquely mapped.** Values of 70 to 90 % are usual for human RNA-seq. Much lower values suggest contamination, the wrong species, or degraded RNA.
3. **Percentage assigned to genes.** High mapping with low assignment is the signature of DNA contamination, or of pre-messenger RNA that still carries its introns.
4. **Duplication rate**, which reflects library complexity. Samples are compared with each other, and not with a fixed threshold.

The essential habit is to read these numbers as variables and to ask the question of Course 4: are they balanced across the groups? In the simulated study shown in the video lecture, the patients map less well and are assigned less than the controls. A technical difference is then aligned with the biological contrast. This is confounding, and no downstream result can be trusted. The corresponding plot takes one line of code, and it is the most valuable line of this block.

## 10. Provenance of a count matrix

The practicals start from count matrices by design, so that the effort goes into analysis and reasoning.

Each matrix nevertheless carries the following decisions:

- the quality control and trimming applied;
- the genome build and the annotation release;
- the aligner or quantifier, and its version;
- the counting mode;
- the treatment of multi-mapping reads.

If the authors documented these choices, the study can be reproduced. If they did not, only a similar study can be produced.

Students who wish to run the pipeline, for a project or for the experience, need no installation. Galaxy is a free web platform on which FastQC, STAR, featureCounts and salmon are available as graphical tools that can be chained into workflows. The French Institute of Bioinformatics operates the national server, UseGalaxy.fr, and the Galaxy Training Network provides step-by-step RNA-seq tutorials. On a computing cluster, the community pipeline nf-core/rnaseq does the same with each tool versioned.

For the assignment, students reconstruct the pipeline from the methods section, item by item, and record what could not be determined. A partly undocumented pipeline is a realistic situation, and a precise description of the gaps earns marks.

## 11. Vocabulary

The terms of this course for the mind map:

- **Read QC:** FastQC, adapter trimming, soft clipping.
- **Alignment:** alignment, splice-aware aligner, STAR, HISAT2, splice junction, SAM, BAM, CIGAR, mapping quality, multi-mapping.
- **Reference:** reference genome, GRCh38, annotation, GTF, GENCODE, Ensembl, RefSeq, index, gene identifier, gene symbol.
- **Counting:** featureCounts, HTSeq, union mode, ambiguous read, raw counts.
- **Transcript quantification:** pseudo-alignment, selective alignment, salmon, kallisto, expectation-maximisation, transcript-level, tximport, effective length.
- **Units:** TPM, FPKM, library size.
- **Reports:** MultiQC, mapping rate, assignment rate, duplication rate.
- **Linking concepts:** provenance and reproducibility, the two ideas that connect all the others.

## 12. Summary and next course

Between the sequencer and the count matrix stand a reference genome, an annotation, an aligner or a quantifier, and a counting rule, and each of them changes the numbers. Raw integer counts are the only valid input for differential expression. Before any matrix is trusted, its quality metrics are plotted by group.

Course 6 examines the matrix as a data structure: why it is sparse, how it is stored, and what this implies when it enters a model.
