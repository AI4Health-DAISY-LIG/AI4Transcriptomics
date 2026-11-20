# Course 1: Biological Hierarchy, the Central Dogma, and the Nucleus

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 1, Central Dogma and the Nucleus (20:09), SandrineTeach channel [https://www.youtube.com/watch?v=nj9_u-AGybI](https://www.youtube.com/watch?v=nj9_u-AGybI)

**Sources and further reading**

- Lander E., 7.012 Introduction to Biology (Fall 2004) and 7.016 Introductory Biology (Fall 2018), MIT OpenCourseWare. The lecture videos on transcription and translation treat the content of this course in more depth. [https://ocw.mit.edu/courses/7-016-introductory-biology-fall-2018/](https://ocw.mit.edu/courses/7-016-introductory-biology-fall-2018/)
- MITx 7.00x, Introduction to Biology, The Secret of Life (E. Lander), self-paced. [https://learn.mit.edu/courses/course-v1:MITxT+7.00x](https://learn.mit.edu/courses/course-v1:MITxT+7.00x)
- Crick F. Central dogma of molecular biology. *Nature* 227:561–563 (1970).
- Schwanhäusser B. et al. Global quantification of mammalian gene expression control. *Nature* 473:337–342 (2011). Source for the half-lives of messenger RNA and proteins.
- Liu Y., Beyer A., Aebersold R. On the dependency of cellular protein levels on mRNA abundance. *Cell* 165:535–550 (2016). Source for the relation between RNA and protein levels.
- Alberts B. et al. *Molecular Biology of the Cell*, chapters 6–7.
- yourgenome (Wellcome Sanger Institute), animation *From DNA to protein: 3D*, shown in section 4.

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=nj9_u-AGybI&t=0s) |
| 2. The ladder of scales | [1:26](https://www.youtube.com/watch?v=nj9_u-AGybI&t=86s) |
| 3. The central dogma | [3:17](https://www.youtube.com/watch?v=nj9_u-AGybI&t=197s) |
| 4. From DNA to proteins (animation) | [5:31](https://www.youtube.com/watch?v=nj9_u-AGybI&t=331s) |
| 5. Anatomy of a gene | [8:45](https://www.youtube.com/watch?v=nj9_u-AGybI&t=525s) |
| 6. One genome, many transcriptomes | [11:00](https://www.youtube.com/watch?v=nj9_u-AGybI&t=660s) |
| 7. The transcriptome is a snapshot | [12:28](https://www.youtube.com/watch?v=nj9_u-AGybI&t=748s) |
| 8. RNA sequencing in numbers | [14:31](https://www.youtube.com/watch?v=nj9_u-AGybI&t=871s) |
| 9. Consequences for the data | [16:01](https://www.youtube.com/watch?v=nj9_u-AGybI&t=961s) |
| 10. Blind spots of the transcriptome | [16:52](https://www.youtube.com/watch?v=nj9_u-AGybI&t=1012s) |
| 11. Vocabulary | [18:32](https://www.youtube.com/watch?v=nj9_u-AGybI&t=1112s) |
| 12. Summary and next course | [19:45](https://www.youtube.com/watch?v=nj9_u-AGybI&t=1185s) |

---

## 1. Introduction

This course opens the transcriptomics block of AI for Omics. Over eight courses, the block follows one path, from a molecule inside a nucleus to a matrix that a neural network can learn from. Courses 1 to 4 cover the biology and the way a molecule becomes a count. Courses 5 to 8 cover the data: the quantification pipeline, the sparse matrix, data stewardship, and dimensionality reduction.

Course 1 is optional for students with a biology background, who already know the central dogma. It still fixes the vocabulary used in the rest of the block, and the first assessment asks students to connect these terms themselves. For students from computer science, mathematics or engineering, this course is the foundation of the block.

One statement summarises the course: **a data point is a physical molecule.** Each number in an expression matrix counts molecules that sat in a real cell, at a real moment, and that the experiment destroyed in order to count them. The zeros, the skew and the batch effects described in later courses follow from this statement.

## 2. The ladder of scales

Biology moves between scales all the time, so we fix them first.

| Level | Typical size |
|---|---|
| Organism | about 1 m |
| Organ (brain, liver) | centimetres |
| Tissue (a biopsy) | about 1 mm |
| Cell | about 10 µm |
| Nucleus | about 5 µm |
| Genome | 3.2 billion letters of DNA on 23 pairs of chromosomes |
| Gene | about 10,000 letters |
| Nucleotide | about 0.33 nm |

Unwound, the DNA of one cell measures about two metres. At human scale, this equals forty kilometres of fishing line packed into a tennis ball. From the patient to the single letter, we cross nine orders of magnitude.

Two consequences follow for the data.

First, DNA does not float loose in the nucleus. The cell winds it around proteins called histones and folds it into chromatin. The transcription machinery cannot read a region that is packed tight, so accessibility comes before expression. The epigenomics block covers this subject.

Second, a one-millimetre biopsy holds between a hundred thousand and a million cells, of a dozen different types, in proportions that the experimenter does not know. If we grind the biopsy and measure its RNA, each number is an average weighted by those unknown proportions. Consider a biopsy from a patient that contains more immune cells than the control biopsy: the immune genes go up, and no single cell has changed its behaviour. Course 4 shows that this effect is the main confounder of the field.

## 3. The central dogma

Francis Crick formulated the central dogma in 1958 and restated it in *Nature* in 1970. It describes how sequence information flows in a cell. The cell copies DNA into RNA; this step is transcription, and the enzyme that performs it is RNA polymerase II. The ribosome then reads the RNA and builds a protein; this step is translation.

The encoding is simple. DNA uses four letters: A, C, G and T. RNA uses the same four, with U in place of T. The ribosome reads RNA three letters at a time. Each triplet, called a codon, stands for one amino acid, and a chain of amino acids folds into a protein.

Crick's claim was a negative one, and it is often misquoted: once information has gone into a protein, it cannot come back to DNA or RNA. The dogma does allow RNA to go back to DNA, through reverse transcription. Retroviruses such as HIV use it to copy themselves into the host genome. Course 4 shows that reverse transcription is the first step of each RNA-sequencing protocol: the method borrows a viral enzyme to turn biology into data.

Three definitions structure the rest of the block.

- **Genome.** The complete DNA sequence. Nearly all the cells of one body carry the same genome, from birth to death. In computing terms, it is the hard drive.
- **Transcriptome.** The set of RNA molecules present in a cell, or a group of cells, at a given moment. Neurons and liver cells have different transcriptomes, and the transcriptome of one cell changes between morning and evening or during an infection. In computing terms, it is the list of running processes.
- **Proteome.** The set of proteins, the molecules that do most of the work in the cell. Another block of the programme covers it.

The genome describes what a cell could do. The transcriptome describes what the cell appears to be doing at the time of measurement. Transcriptomics studies the gap between the two.

## 4. From DNA to proteins (animation)

The video lecture shows at this point the animation *From DNA to protein: 3D*, produced by yourgenome at the Wellcome Sanger Institute (in the video from 5:50 to 8:32). Two events deserve attention: RNA polymerase opens the DNA double helix and builds the RNA copy, and the ribosome then reads that RNA three letters at a time. Cells perform these operations millions of times per second. The following sections add the details that shape the data.

## 5. Anatomy of a gene

The structure of a gene explains several laboratory choices that otherwise look arbitrary.

Upstream of the gene sits the promoter, where the transcription machinery binds. RNA polymerase II starts there and makes a first copy of the whole region, the pre-messenger RNA. This copy contains two kinds of segments: exons, which the cell keeps, and introns, which it removes.

The cell then processes the copy in three steps:

1. it adds a cap at the five-prime end, the start of the molecule;
2. it adds a tail of one to two hundred adenines at the three-prime end, the poly-A tail;
3. it cuts out the introns and joins the exons, an operation called splicing.

The result is the mature messenger RNA (mRNA), which leaves the nucleus for the ribosome. At each end, the mRNA keeps untranslated regions (UTRs). The ribosome does not translate them; they control how long the messenger survives.

Two of these steps change the data.

**The poly-A tail is a chemical handle.** Most protocols capture mRNA with a probe made of thymines, which binds the adenines. This convenience is also a filter. RNAs without a poly-A tail, such as many long non-coding RNAs, histone messengers and most bacterial RNA, are absent from the dataset by design. The gene was present, and the protocol did not capture it.

**Splicing does not always give the same result.** One gene can produce several mature messengers, called isoforms, by keeping or skipping exons. "The expression of gene X" therefore sums isoforms that can have different, sometimes opposite, functions. This block works at gene level, like most of the literature. This is a choice, and it costs information.

One number anchors the section: the human genome contains about twenty thousand protein-coding genes. Each matrix handled in this block has about twenty thousand gene features.

## 6. One genome, many transcriptomes

If each cell in a body carries the same genome, why is a neuron different from a liver cell? The answer is regulation, which acts at three levels:

- transcription factors are proteins that bind short DNA motifs and switch genes on or off;
- chromatin state decides whether the DNA is open enough to read;
- non-coding RNAs tune how much transcript the cell makes and keeps.

Together, these mechanisms decide which genes the cell reads, and how often. The code is the same, and the running program differs. Albumin, the main protein in blood, gives a concrete case: liver cells make large amounts of albumin messenger, neurons make almost none, and both carry the albumin gene.

A transcriptome only has meaning relative to a reference. Suppose that gene X receives 1,250 reads in one sample. We cannot say whether this value is high or low. A gene is high compared with another tissue, another time point, or another group of patients. Each analysis in this block is a comparison. The composition of group A, the composition of group B, and any other difference between them deserve more attention than the choice of statistical test. The second assessment relies on this point.

## 7. The transcriptome is a snapshot

Most over-interpretation in transcriptomics starts with a misreading of the word *snapshot*.

RNA molecules do not last. The cell makes and destroys them continuously. Schwanhäusser and colleagues (2011) measured this genome-wide in mouse fibroblasts and reported a median half-life of about nine hours for mRNA, against forty-six hours for proteins. Some transcripts last minutes, others more than a day.

Sequencing photographs a process in motion with zero exposure time, and the photograph destroys the subject: we break the cell open to extract its RNA. The same cell cannot be measured twice. Each time series in a publication comes from different cells, sacrificed at different moments and assembled afterwards.

An RNA-seq experiment has six steps, from extraction to the count matrix. Course 4 describes each of them. Step three, cDNA synthesis, is the reverse transcription introduced in section 3.

Two practical warnings follow.

First, the time between the death of the tissue and its freezing changes the transcriptome: stress genes and low-oxygen genes go up. If two hospitals collected the patients and the controls with different delays, that difference sits in the data and looks like biology.

Second, a higher RNA level does not explain itself. The level in a water tank rises if we open the inlet or if we close the outlet, and the level alone does not tell which. A transcript behaves the same way: it accumulates because the cell makes it faster or destroys it more slowly, and standard RNA-seq cannot separate the two. The statement "gene X is up-regulated in patients" describes a concentration. It does not establish a mechanism.

## 8. RNA sequencing in numbers

Four numbers predict the shape of each dataset in this block.

1. **About 20,000 protein-coding genes.** This is the number of features.
2. **10 to 30 picograms of RNA per mammalian cell.** Ribosomal RNA, the structural RNA of the ribosome, makes up 80 to 90 % of that mass. Each cell contains it, and it carries almost no information on cell state. Messenger RNA makes up a few percent. Each protocol therefore enriches the sample, either by capturing poly-A tails or by removing ribosomal RNA, and each enrichment introduces a bias.
3. **A few hundred thousand mRNA molecules per cell**, all genes together. Divided by twenty thousand genes, this gives a few dozen copies per gene on average, and a handful or zero for many regulatory genes at a given moment. With numbers this small, sampling noise dominates. If the mRNA of one cell were a library of three hundred thousand books, a typical gene would own a dozen copies, and many genes would own none on the day of the visit.
4. **A dynamic range of more than five orders of magnitude** within one sample. A few abundant genes take a large share of the reads, while thousands of genes sit at the edge of detection.

## 9. Consequences for the data

Together, these four numbers predict the properties of the data before we open the file:

- **Integer counts.** We count molecules; we do not measure a continuous signal.
- **Strong skew.** The analysis works in log space.
- **Variance that grows with the mean.** This property violates the assumptions of ordinary least squares and of the t-test. Course 5 and the practicals replace them with count models based on the negative binomial distribution, fitted in Python with PyDESeq2.
- **Many zeros.** Course 4 examines what a zero means: a silent gene, or a molecule that the protocol missed.

These four properties also explain why raw counts fed to a standard neural network give poor results. The following courses address each property in turn.

## 10. Blind spots of the transcriptome

Four limits apply to any interpretation of transcriptomic data.

1. **RNA is not protein.** In studies that measure both in the same cells, mRNA explains roughly 40 to 60 % of the variance in protein levels (Liu, Beyer and Aebersold, 2016). Translation rate and protein stability account for much of the rest. A transcript can double while its protein level stays flat.
2. **Abundance is not activity.** A kinase, an enzyme that activates other proteins, does nothing until another enzyme phosphorylates it. RNA sequencing detects none of these post-translational modifications.
3. **Bulk measurements have no spatial information.** Two neighbouring cells with opposite behaviours are averaged into one number.
4. **Differential expression is not causation.** A comparison of diseased and healthy tissue may return eight hundred changed genes. Most of them are consequences of inflammation, of cell death, or of a shift in the cell types present, and a small minority are causes. "Signature" is an accurate word for such a list. "Driver" requires causal evidence: a knock-out, a genetic association, or an intervention. A comparison of two groups of tissue cannot provide it.

The second assessment asks students to reproduce a published differential expression analysis, and then to state what it shows and what it leaves open. These four limits are the basis of that discussion.

## 11. Vocabulary

The twenty-seven terms of this course must appear on the mind map of the first assessment. The assessment does not ask for definitions: students draw the terms by hand and connect them. A term with no edge to the others is a term not yet understood. A practical method is to place the central dogma in the middle of the page and to grow outwards. Clarity matters more than exhaustiveness, and creative productions receive a bonus.

- **Molecular inventories:** genome, transcriptome, proteome.
- **Information flow:** central dogma, transcription, translation, reverse transcription, RNA polymerase II.
- **Gene structure:** promoter, exon, intron, splicing, isoform, 5′ cap, poly-A tail, untranslated region.
- **Regulation:** chromatin, transcription factor, gene regulation.
- **RNA classes:** mRNA, rRNA, non-coding RNA.
- **Measurement:** mRNA half-life, snapshot in time, post-mortem interval, dynamic range, count data.

## 12. Summary and next course

A transcriptomic data point counts physical molecules. The measurement is an average over an unknown mixture of cells, taken at one moment and at the cost of the sample. It describes a concentration of RNA; it says nothing direct about proteins, activity, spatial organisation or causes.

Course 2 moves one level down, to the anatomy of the cell: where messenger RNA sits, how we extract it, and why the extraction cannot be undone.
