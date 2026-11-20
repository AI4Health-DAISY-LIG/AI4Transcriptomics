# Course 2: The Anatomy of a Cell: Where mRNA Lives, and Why Sampling Destroys

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 2, Anatomy of a Cell (20:38), SandrineTeach channel [https://www.youtube.com/watch?v=CaqPlpyIklM](https://www.youtube.com/watch?v=CaqPlpyIklM)

**Sources and further reading**

- Lander E., 7.016 Introductory Biology, MIT OpenCourseWare: lectures on cell structure. [https://ocw.mit.edu/courses/7-016-introductory-biology-fall-2018/](https://ocw.mit.edu/courses/7-016-introductory-biology-fall-2018/)
- Alberts B. et al. *Molecular Biology of the Cell*, chapters 12 (intracellular compartments) and 14 (mitochondria).
- van den Brink S.C. et al. Single-cell sequencing reveals dissociation-induced gene expression in tissue subpopulations. *Nature Methods* 14:935–936 (2017). A short paper on the stress response induced by enzymatic dissociation.
- Denisenko E. et al. Systematic assessment of tissue dissociation and storage biases in single-cell and single-nucleus RNA-seq workflows. *Genome Biology* 21:130 (2020). Source of two figures of this course.
- Newman A.M. et al. Determining cell type abundance and expression from bulk tissues with digital cytometry (CIBERSORTx). *Nature Biotechnology* 37:773–782 (2019). The first two figures make the composition problem concrete.
- Wang X., Park J., Susztak K., Zhang N.R., Li M. Bulk tissue cell type deconvolution with multi-subject single-cell expression reference (MuSiC). *Nature Communications* 10:380 (2019).
- Esteva-Socias M. et al. Impact of different stabilization methods on RT-qPCR results using human lung tissue samples. *Scientific Reports* 10:3579 (2020).
- Luecken M.D., Theis F.J. Current best practices in single-cell RNA-seq analysis: a tutorial. *Molecular Systems Biology* 15:e8746 (2019). The best practical starting point for quality control in single-cell data.

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=CaqPlpyIklM&t=0s) |
| 2. A tour of the cell, oriented towards RNA | [1:19](https://www.youtube.com/watch?v=CaqPlpyIklM&t=79s) |
| 3. Where RNA sits: three pools | [3:05](https://www.youtube.com/watch?v=CaqPlpyIklM&t=185s) |
| 4. RNA extraction: five steps, one irreversible outcome | [5:20](https://www.youtube.com/watch?v=CaqPlpyIklM&t=320s) |
| 5. Dissociation: an under-reported bias | [7:40](https://www.youtube.com/watch?v=CaqPlpyIklM&t=460s) |
| 6. Cell composition: the master confounder | [9:34](https://www.youtube.com/watch?v=CaqPlpyIklM&t=574s) |
| 7. RNA quality: RIN, degradation, FFPE | [12:43](https://www.youtube.com/watch?v=CaqPlpyIklM&t=763s) |
| 8. Three quality-control metrics | [15:29](https://www.youtube.com/watch?v=CaqPlpyIklM&t=929s) |
| 9. Vocabulary | [17:29](https://www.youtube.com/watch?v=CaqPlpyIklM&t=1049s) |
| 10. Summary and next course | [19:39](https://www.youtube.com/watch?v=CaqPlpyIklM&t=1179s) |

---

## 1. Introduction

Course 1 defined the transcriptome as the set of RNA molecules present in a cell at a given moment. This course answers a more concrete question: **what physically happens between a piece of tissue and the first number in the matrix?** A reader who can answer it can judge the methods and the figures of a paper instead of taking them on trust.

The question matters because public data look clean. A count matrix downloaded from a repository is a rectangle of integers. It does not record that a surgeon removed the tissue at nine in the morning, that the tissue stayed on ice for forty minutes, that an enzyme digested it for half an hour at 37 °C, or that roughly a third of the cells did not survive. All of these events are nevertheless present in the numbers, and this course shows where.

The course is optional for students with a biology background. Engineers should follow it, because it prevents the most common errors of interpretation.

## 2. A tour of the cell, oriented towards RNA

We describe here only the compartments that matter for RNA.

- **Plasma membrane.** The boundary of the cell, a double layer of lipids. To reach the contents, we break this membrane with detergents, and careless handling carries those detergents over into the reagents.
- **Cytoplasm.** A crowded, water-based compartment. Translation takes place here: ribosomes read messenger RNA (mRNA) to make proteins. Mature mRNA resides in the cytoplasm.
- **Nucleus.** It has its own double membrane and holds the genome. Transcription takes place here, as does splicing, which removes the introns. The cell also adds a cap at one end of the messenger and a poly-A tail at the other. The dense body inside the nucleus, the nucleolus, produces ribosomal RNA, which explains the abundance of this RNA in the cell.
- **Rough endoplasmic reticulum.** Its surface carries ribosomes that translate the messengers of secreted proteins and membrane proteins.
- **Mitochondria.** The power plants of the cell. Each mitochondrion has a small circular genome of about 16,500 bases in humans, with thirty-seven genes that the mitochondrion transcribes itself. In the data, thirteen of them appear as a separate block of protein-coding genes whose names start with `MT-`. Section 8 uses them as a quality metric.

## 3. Where RNA sits: three pools

RNA sits in three pools. The pool that a protocol measures determines the choice of protocol.

1. **The nuclear pool** holds transcripts that the cell is still making or processing. It is enriched in unspliced precursor RNA, and therefore in intronic sequence. It represents a small share of the total RNA of the cell.
2. **The cytoplasmic pool** holds mature mRNA: spliced, capped and tailed, ready for translation. Most bulk RNA-seq and most single-cell RNA-seq measure this pool.
3. **The mitochondrial pool** sits in its own compartment, and the mitochondria transcribe it independently.

By mass, ribosomal RNA represents 80 to 90 % of the RNA in a cell. If we sequence total RNA without any selection, nine reads in ten report the existence of ribosomes. Each protocol therefore does one of two things: it captures poly-A tails, which mature messengers have and ribosomal RNA does not, or it removes ribosomal RNA chemically. Both approaches work, and they give different results. They should not be mixed within one study.

The three pools have a practical consequence. Some tissues cannot be dissociated into intact single cells. Frozen post-mortem brain is the classic example: neurons have long extensions that tear, and the cell bodies do not survive. For brain tissue, researchers often use single-nucleus RNA-seq. They isolate the nuclei, which are robust, and sequence the nuclear pool. The measurement then concerns a different compartment. Single-nucleus data contain far more intronic reads, fewer transcripts per cell, and almost no mitochondrial reads, because the mitochondria remained outside the nucleus. A comparison of a single-cell dataset with a single-nucleus dataset that ignores this difference returns hundreds of "differentially expressed" genes that come from the protocol alone.

## 4. RNA extraction: five steps, one irreversible outcome

The extraction chain has five steps. Denisenko and colleagues (2020) applied three versions of it to mouse kidney.

1. **Obtain the material:** a biopsy, a post-mortem block, a blood draw, or a culture dish.
2. **Dissociate the tissue**, if the protocol needs single cells or nuclei, with enzymes such as collagenase or papain, or mechanically.
3. **Lyse the cells:** break the membranes with a detergent or a chaotropic salt, in the presence of an RNase inhibitor.
4. **Purify the RNA:** separate it from DNA, protein and lipid, usually with a phenol-chloroform reagent such as TRIzol, or on a silica column.
5. **Control the quality** (section 7).

The RNase inhibitor of step 3 deserves a comment. RNases are the enzymes that degrade RNA. They are present on skin and in dust, they are very stable, and unlike most enzymes they need no cofactor. From the moment the cell breaks, they attack the RNA. The experimenter therefore works on ice, fast, and with dedicated consumables, to extract the RNA before it degrades.

In the study of Denisenko and colleagues, the authors dissociated the tissue at 37 °C and then sequenced it fresh, fixed it in methanol, or froze it. They dissociated the same tissue in the cold. They also processed frozen tissue without dissociation. Each route gives a slightly different picture of the same organ, and the paper quantifies these differences.

This is the destruction named in the title of the course. A cell that has been broken open is gone, and no further question can be put to it. Each sample yields one measurement. An engineer can usually re-image the same object or re-run the same benchmark; a biologist cannot re-measure the same cell. Biological replicates are therefore expensive, rare-disease studies have small samples, and statistical care matters more here than in fields where more data can be collected on demand.

## 5. Dissociation: an under-reported bias

Dissociation changes the sample in two ways.

**Selective survival.** Cell types survive dissociation at very different rates. Neurons are fragile, and glial cells are tougher. Large fat cells, the adipocytes, float away. Fibroblasts detach with ease, and some epithelial cells do not. The cells that reach the tube are a biased sample of the tissue, and the bias favours the robust cell types.

**Induced stress.** Thirty minutes at 37 °C with a protease trigger an immediate stress response in the cells under study, with genes such as *FOS*, *JUN* and the heat-shock family. Denisenko and colleagues compared dissociation at 37 °C with dissociation in the cold, using a protease from a cold-adapted organism. After warm dissociation, these stress genes are among those that increase. Van den Brink and colleagues (2017) had already shown this effect in single-cell data.

Partial remedies exist: dissociation in the cold, a cold-active protease, or the removal of these stress genes during the analysis. They reduce the stress signal, and some of it remains.

Consider a published study in which a nearby hospital processed the patient samples fresh, while the controls came frozen from a biobank three hundred kilometres away. A difference between the two groups may then reflect the processing as much as the biology. This situation occurs in real papers. Students should check for it when they choose the paper for the second assignment.

## 6. Cell composition: the master confounder

This section is the most important of the first half of the block.

Take a bulk sample of tissue with a hundred thousand cells of five types. For each gene, the measurement is an average of its expression across the five types, weighted by the abundance of each type. Suppose now that one cell type dies in the disease, for example neurons in a neurodegenerative disease. The share of glial cells then rises.

We then observe that each neuronal marker gene goes down and each glial gene goes up. Hundreds, sometimes thousands, of genes pass any significance threshold. Yet no cell has changed its behaviour, and the transcriptional program of each individual cell could be identical in both groups. The experiment has measured a change in proportions and reported it as a change in expression.

A numerical example makes this concrete. Take a gene expressed only in glial cells, at 100 units per glial cell.

| | Share of glia | Bulk value of the gene |
|---|---|---|
| Healthy tissue | 30 % | 30 |
| Diseased tissue, after neuronal loss | 45 % | 45 |

The bulk value increases 1.5-fold, and with enough samples the increase is highly significant. Each glial cell still expresses 100 units.

A large fraction of published bulk signatures in tissue diseases come, wholly or in part, from this effect. Such signatures can remain valid, because a shift in cell composition is a real finding, and often a clinically meaningful one. The problem lies in the usual interpretation. "Gene X is up-regulated in patients" and "patients have more of the cells that express gene X" are different claims, and bulk data alone cannot separate them.

Two solutions exist.

1. **Single-cell or single-nucleus sequencing** measures composition directly.
2. **Computational deconvolution** estimates the cell-type proportions inside bulk samples from a reference of cell-type expression profiles. MuSiC (Wang and colleagues, 2019) builds the reference from single-cell data of several individuals, then estimates the proportion of each cell type in healthy and diseased bulk samples. CIBERSORTx (Newman and colleagues, 2019) is the other tool cited most often. The analyst then reports the proportions as a result in their own right, or includes them as covariates in the model.

For the second assignment: a bulk tissue study that never mentions composition has a first real limitation, and the report should state it.

## 7. RNA quality: RIN, degradation, FFPE

RNA reaches the tube more or less intact, and a number measures this. The RNA Integrity Number (RIN) runs from 1 to 10. It derives from an electrophoresis trace: in simplified terms, it compares the sharpness of the two ribosomal RNA peaks with the background of fragments. A RIN of 10 indicates intact RNA. Below about 6, degradation is substantial.

Electrophoresis moves the RNA through a gel with an electric field. Small fragments travel faster than large ones, so the trace is a size distribution. Intact RNA gives two sharp peaks, which correspond to the two large ribosomal RNAs. Degraded RNA gives a smear of short fragments that arrive early.

Esteva-Socias and colleagues (2020) stored the same lung sample in four ways. The frozen sample embedded in OCT shows two sharp peaks and a RIN of 9.1. The snap-frozen piece without embedding has a RIN of 6.8 and a rising smear. The formalin-fixed sample has a RIN of 1.0, with no peaks and only fragments.

Degradation does not affect a transcript evenly. Most library preparations start from the poly-A tail at the three-prime end. A degraded transcript still gives reads near that end and loses coverage towards the other end. This is three-prime bias, and it has two consequences. First, long transcripts lose proportionally more signal than short ones, so gene length interacts with degradation. Second, if two groups differ in average RIN, this interaction produces a length-dependent artefact that resembles coordinated biology.

The analyst should examine RIN for each public dataset. Well-curated series record it in the sample metadata. If the patients have an average RIN of 6.2 and the controls 8.4, RIN belongs in the statistical model, and the reader should check whether the authors included it.

A last case is FFPE, formalin-fixed paraffin-embedded tissue. Hospital pathology departments store their archives in this form, so FFPE is a large and clinically precious resource, with decades of annotated samples. Formalin cross-links and chemically modifies nucleic acids, and FFPE RNA is heavily fragmented. Adapted protocols can process it, and a comparison with fresh-frozen RNA requires care.

## 8. Three quality-control metrics

Three numbers appear in the quality reports of the practicals.

**RIN.** The integrity of the input RNA, described in section 7.

**Percentage of mitochondrial reads.** Mitochondria have their own genome (section 2). When a cell is dying or damaged, its cytoplasmic mRNA leaks through the broken membrane, while the mitochondria keep their RNA behind their own membranes. The proportion of mitochondrial reads therefore rises. In single-cell work, a high mitochondrial fraction is the standard flag for a stressed or dying cell; Luecken and Theis (2019) show the usual quality plots, with each cell coloured by that fraction. Typical filters sit between 5 and 20 % according to the tissue, and this range is a convention. Heart muscle cells are full of mitochondria, and a threshold that ignores the tissue discards the best heart cells.

**Ribosomal fraction and duplication rate.** The ribosomal fraction measures how well the enrichment step removed ribosomal RNA. The duplication rate is the share of reads that are exact copies of each other. Some copies are expected for highly expressed genes. A high rate usually means that the library started from too few molecules and that PCR copied the same ones many times. Such a library has low complexity.

None of these numbers is a pass-or-fail criterion. They are continuous values, and each of them can differ systematically between groups. Each technical number is a potential confounder.

## 9. Vocabulary

The terms of this course for the mind map:

- **Cell anatomy:** plasma membrane, cytoplasm, nucleus, nucleolus, endoplasmic reticulum, ribosome, mitochondrion, mitochondrial genome.
- **RNA pools:** nuclear RNA, cytoplasmic RNA, pre-mRNA, mature mRNA.
- **Enrichment:** poly-A selection, ribosomal depletion.
- **Dissociation:** dissociation, single-nucleus RNA-seq, dissociation stress response.
- **Extraction:** lysis, RNase, TRIzol, RNA extraction.
- **Quality:** RIN, RNA degradation, three-prime bias, FFPE.
- **Design:** cell composition, deconvolution, confounder, post-mortem interval, biobank, batch effect.

On the mind map, *confounder* should be one of the most connected nodes. A map in which it has a single edge shows that the course is not yet understood.

## 10. Summary and next course

Between the tissue and the matrix, the experiment breaks the cell open, sorts it, stresses it and degrades it, and the matrix records none of these events. A change in cell composition can produce thousands of differentially expressed genes while no cell changes its behaviour. Each technical number, such as RIN, the mitochondrial fraction or the processing site, is a potential confounder.

Course 3 changes subject and covers Git and GitHub. It is optional for students who already work in a terminal each day, and essential for the others, because from Course 5 onwards each submission is a repository. Course 4 is compulsory for all students, and the first assessment is a hand-drawn mind map that covers Courses 1 to 4.
