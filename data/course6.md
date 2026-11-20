# Course 6: The Count Matrix as a Data Structure: Sparsity and Containers

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 6, The Count Matrix as a data structure: sparsity and containers (19:30), SandrineTeach channel [https://www.youtube.com/watch?v=XDuqaoQBzH8](https://www.youtube.com/watch?v=XDuqaoQBzH8)

**Sources and further reading**

- Wolf F.A., Angerer P., Theis F.J. SCANPY: large-scale single-cell gene expression data analysis. *Genome Biology* 19:15 (2018). The practical entry point, with well-written tutorials.
- Virshup I., Rybakov S., Theis F.J., Angerer P., Wolf F.A. anndata: Access and store annotated data matrices. *Journal of Open Source Software* 9:4371 (2024), with online documentation. [https://anndata.readthedocs.io/](https://anndata.readthedocs.io/)
- Huber W. et al. Orchestrating high-throughput genomic analysis with Bioconductor. *Nature Methods* 12:115–121 (2015). See the SummarizedExperiment vignette, needed to read R-based methods sections.
- Amezquita R.A. et al. Orchestrating single-cell analysis with Bioconductor. *Nature Methods* 17:137–145 (2020).
- SciPy sparse matrix documentation: short and sufficient for COO, CSR and CSC. [https://docs.scipy.org/doc/scipy/reference/sparse.html](https://docs.scipy.org/doc/scipy/reference/sparse.html)
- Muzellec B., Teleńczuk M., Cabeli V., Andreux M. PyDESeq2: a python package for bulk RNA-seq differential expression analysis. *Bioinformatics* 39:btad547 (2023). To read before the practicals.
- Gayoso A. et al. A Python library for probabilistic analysis of single-cell omics data (scvi-tools). *Nature Biotechnology* 40:163–166 (2022). To read before the practicals.
- Zappia L., Theis F.J. Over 1000 tools reveal trends in the single-cell RNA-seq analysis landscape. *Genome Biology* 22:301 (2021).
- Bacher R., Kendziorski C. Design and computational analysis of single-cell RNA-sequencing experiments. *Genome Biology* 17:63 (2016).
- Ahlmann-Eltze C., Huber W. Comparison of transformations for single-cell RNA-seq data. *Nature Methods* 20:665–672 (2023).
- Lazic S.E. The problem of pseudoreplication in neuroscientific studies: is it affecting your analysis? *BMC Neuroscience* 11:5 (2010). Short, and recommended for any project with several samples per individual.
- Eraslan G. et al. Single-cell RNA-seq denoising using a deep count autoencoder. *Nature Communications* 10:390 (2019).
- Gold I., Fischer F., Arnoldt L., Wolf F.A., Theis F.J. annbatch unlocks terabyte-scale training of biological data in anndata. arXiv:2604.01949.

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=0s) |
| 2. The object: shape, orientation, dtype | [0:57](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=57s) |
| 3. How sparse are the data? | [3:03](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=183s) |
| 4. Three sparse formats: COO, CSR, CSC | [5:05](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=305s) |
| 5. The container: AnnData and its relatives | [7:13](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=433s) |
| 6. Metadata hold the study design | [9:37](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=577s) |
| 7. Operations that destroy sparsity | [11:57](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=717s) |
| 8. From matrix to tensor | [14:13](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=853s) |
| 9. Vocabulary | [17:01](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=1021s) |
| 10. Summary and next course | [18:41](https://www.youtube.com/watch?v=XDuqaoQBzH8&t=1121s) |

---

## 1. Introduction

This course is devoted to a single data structure, the count matrix.

In most machine learning courses, the data matrix is given. It is dense, it fits in memory, and the interesting work starts afterwards. None of this holds in transcriptomics. The matrix determines which algorithms can run and how much memory they need. It also determines which preprocessing steps are affordable, a fact that often surprises newcomers.

A second reason is practical. In student projects, a large share of the time is lost to transposed matrices, mismatched gene identifiers, and metadata that no longer correspond to the data. Twenty minutes on these questions now save a weekend later.

## 2. The object: shape, orientation, dtype

The object is a table of counts, and the two software ecosystems disagree on the meaning of its axes.

Zappia and Theis (2021) catalogued more than a thousand single-cell analysis tools. Almost all are written in R or in Python, and the share of new tools written in Python increases while the share of R decreases. Students work in both: the methods sections of papers often use R, and the practicals use Python.

| Ecosystem | Tools | Rows | Columns |
|---|---|---|---|
| R / Bioconductor | DESeq2, edgeR | genes | samples |
| Python | AnnData, scanpy, PyDESeq2 | observations (cells or samples) | variables (genes) |

Almost all count matrices deposited in GEO follow the R convention, because the authors exported them from R. The Python convention matches machine learning, where a row is an example and a column is a feature.

PyDESeq2 follows the Python convention, so each matrix downloaded from GEO must be transposed. Omitting this step is the most common error of the first practical. The result is a shape error or, worse, no error and a meaningless result.

Two checks come before any other operation.

1. **The shape.** 60 × 20,000 indicates a bulk study, and 50,000 × 20,000 a single-cell study.
2. **The dtype** (data type). Raw counts are integers, and integers show that nobody has normalised the data.

In code, the whole section takes three lines:

```python
counts = pd.read_csv("GSE_counts.tsv", sep="\t", index_col=0)  # genes as index
counts = counts.T                                               # samples as rows
dds = DeseqDataSet(counts=counts, metadata=metadata, design="~condition")
```

The index of the metadata table must match the new row names exactly. If the names do not match, the analysis stops until the cause is found.

## 3. How sparse are the data?

Two observations make sparse storage necessary.

**Zeros dominate single-cell data.** Bacher and Kendziorski (2016) show, for each gene, the proportion of samples in which it is zero, for a bulk dataset and a single-cell dataset. In bulk data, most genes are rarely zero. In single-cell data, most genes are zero in most cells, for the reasons given in Course 4: a modest number of molecules per cell, a capture efficiency of about 10 %, and twenty thousand genes that share them. Bulk data usually contain 10 to 40 % zeros, and fewer after the removal of lowly expressed genes. For a bulk study of sixty samples, a dense table is adequate.

**Studies grow.** The single-cell studies database of Svensson, da Veiga Beltrame and Pachter records the number of cells per study, by technology. This number has grown by orders of magnitude, and studies with hundreds of thousands of cells are now common.

The arithmetic follows. A dense matrix of 32-bit floats uses four bytes per entry.

| Matrix | Dense storage |
|---|---|
| 20,000 genes × 10,000 cells | 800 MB |
| 20,000 genes × 500,000 cells | 40 GB |

Forty gigabytes exceed the memory of a laptop. A sparse format stores only the non-zero entries, each with its index: about eight bytes per non-zero (four for the value and four for the index) instead of four bytes for each entry. At a density of 5 %, the gain is a factor of ten, and 40 GB become 4 GB.

A habit follows: after loading a dataset, print the type of `X`. If it is a SciPy sparse matrix, it should stay sparse as long as possible. A dense array on a single-cell object means that someone has already densified it, and the reason should be found.

## 4. Three sparse formats: COO, CSR, CSC

Consider a 4 × 4 matrix with three non-zero values: 5, 2 and 7.

**COO**, the coordinate format, is the simplest. Three parallel arrays give, for each non-zero, its row, its column and its value. It is cheap to build and to extend, so file readers produce it. Its entries have no order, so computation with it is slow.

**CSR**, compressed sparse row, sorts the non-zeros by row and replaces the repetitive row array with a pointer array, `indptr`, which gives the start of each row. Row *i* is the data between `indptr[i]` and `indptr[i+1]`: a contiguous slice of memory. For an empty row, `indptr` repeats the same value. Row extraction is immediate, and column extraction requires a search through each row.

**CSC**, compressed sparse column, applies the same construction by column: fast columns, slow rows.

The practical rule derives from the orientation of AnnData, where rows are cells.

| Task | Direction | Format |
|---|---|---|
| Minibatches for a neural network, per-cell quality control | cell by cell | CSR |
| Per-gene variance, gene filtering | gene by gene | CSC |

Scanpy converts between the two when needed, without notice. On a large object, this hidden conversion can explain why a step took forty minutes instead of a few seconds.

One warning applies each year: a CSR or CSC matrix must never be written element by element, because each insertion shifts all the arrays. The matrix is built in COO, or in a dense block, and then converted.

In SciPy, the formats are `coo_matrix`, `csr_matrix` and `csc_matrix`, or their newer array equivalents, and the conversions are the methods `tocsr()` and `tocsc()`.

## 5. The container: AnnData and its relatives

A count has no meaning without its metadata, so a bare matrix is insufficient and a container is needed. In Python, the standard is AnnData, stored on disk as an `.h5ad` file, which uses HDF5.

| Element | Content | Aligned with |
|---|---|---|
| `X` | the matrix: observations (cells, or samples in bulk) × variables (genes) | both axes |
| `obs_names`, `var_names` | labels of the rows and the columns | |
| `obs` | one row per observation: condition, patient, batch, cell type | rows of `X` |
| `var` | one row per gene: stable identifier, gene biotype, highly variable flag | columns of `X` |
| `layers` | other matrices with the shape of `X`, for example raw counts and normalised values | both axes |
| `obsm`, `varm` | multi-dimensional annotations: PCA coordinates per cell, loadings per gene | rows or columns |
| `obsp`, `varp` | pairwise relations, such as the nearest-neighbour graph between cells | rows or columns |
| `uns` | unstructured dictionary for all other content, including the parameters of the steps run | none |

The design principle is alignment. When the observations are subset, each aligned element follows. The result is a view in which `obs`, `obsm` and `layers` still correspond to `X`. Anyone who has kept counts in one file and a sample sheet in another, and then sorted only one of them, knows the error that this design prevents.

In practice, `adata.obs` and `adata.var` are pandas DataFrames, `adata.X` is the matrix, and a subset by condition is one line that returns such a view.

Other ecosystems express the same idea: SummarizedExperiment and SingleCellExperiment in Bioconductor, the Seurat object, loom files, and MuData for multi-modal data. Conversion between them is routine and rarely lossless. `uns` and some layers are often lost.

## 6. Metadata hold the study design

In this block, `obs` is where the essential reasoning takes place. In a typical table, the `condition` column is the variable of interest. Each other column is either a covariate that may require adjustment or a confounder not yet identified: patient, sex, age, brain region, batch, RIN (RNA quality) and PMI (post-mortem interval).

The `patient_id` column deserves particular attention. Suppose that each individual provides two samples, one from the temporal cortex and one from the cingulate cortex. The table then has six rows and only three people. Only the `patient_id` column tells the model which rows belong together.

Lazic (2010) shows the consequence of ignoring this structure. Take two rats with ten measurements each, and a true population mean of fifty. If the twenty measurements are treated as twenty independent observations, the 90 % confidence interval is narrow, with nineteen degrees of freedom, and it does not contain the true mean. The correct analysis recognises two rats, so one degree of freedom, and gives a very wide interval, because ten measurements of the same rat still count as one rat.

This error is **pseudoreplication**: it inflates the sample size, and the confidence with it. It is one of the most common errors in the literature, and at least one of the papers proposed for the project contains it. Students are invited to find which one.

Two further habits complete the section.

**Cross-tabulate before any analysis.** `pd.crosstab(adata.obs["condition"], adata.obs["batch"])` displays the design. If the table is diagonal, with each patient in one batch and each control in another, the design is confounded, as in Course 4. It is better to find this on the first day of the project than on the last.

**Keep `obs` inside the object**, and not in a separate spreadsheet. PyDESeq2 requires this pair: a counts table and a metadata table with matching sample names. Building it correctly once is worth the time.

## 7. Operations that destroy sparsity

This section explains a convention that most users learn by rote. Ahlmann-Eltze and Huber (2023) compared the main transformations of single-cell counts: raw counts, the shifted logarithm, Pearson residuals, and a Bayesian method named Sanity.

**The shifted logarithm** is the logarithm of the normalised count plus one, a function named `log1p`. The addition of one avoids the logarithm of zero, and it has a second property that matters more here: `log1p(0) = 0`. Because the transformation maps zero to zero, it applies to the stored non-zero values alone, and the sparsity pattern is unchanged.

**Pearson residuals** replace each count by its deviation from the value expected by a model, divided by the expected spread. A zero count becomes a negative number, each entry is now non-zero, and the matrix is dense.

**Centring** has the same effect in a cruder way. Subtracting the mean of each gene turns each zero into minus that mean. At scale, 4 GB become 40 GB again. For this reason, the `scale` function of scanpy allows centring to be switched off for sparse input, with `zero_center=False`. The PCA of scanpy on sparse data uses implicit centring for the same reason: it keeps the mean vector aside and corrects the products, so it computes the components of the centred matrix while it operates on the sparse one.

The paper also reports a reassuring result. In its benchmarks, the plain logarithm with a pseudo-count, followed by PCA, performed as well as or better than the more sophisticated alternatives. The cheap option that preserves sparsity is also a good one.

The rule to remember: **an operation preserves sparsity if and only if it maps zero to zero.** When code that ran on a subset exhausts the memory on the full object, the question is which operation moved the zeros.

## 8. From matrix to tensor

This section links the matrix to the second half of the block: how does this object reach a neural network?

It arrives in small pieces. Deep learning on transcriptomes uses minibatches: at each step, a few hundred cells go to the GPU. The full object never needs to be in memory. It can remain sparse in RAM, or remain on disk in backed mode (`read_h5ad(..., backed="r")`), in which case only the indexed part is loaded. A loader selects a minibatch, which is a row slice and therefore cheap in CSR, and converts that slice alone into a dense tensor. A minibatch of 128 cells × 20,000 genes in float32 occupies about 10 MB.

The deep count autoencoder of Eraslan and colleagues (2019), one of the first deep models for single-cell data, shows what happens next. A block of the matrix, cells × genes, enters the network. The network compresses it through a narrow bottleneck layer and expands it again. For each gene, the output layer predicts the parameters of a count distribution in place of the counts themselves: a mean, a dispersion and a dropout probability. This model used a zero-inflated negative binomial distribution. As Course 4 explained, a plain negative binomial is usually sufficient for UMI droplet data. scvi-tools offers both.

At large scale, another bottleneck appears. The authors of annbatch, a loader built on anndata, observe that with large models, data loading often limits training more than the GPU. Reading random rows scattered across a disk is slow. Modern loaders therefore read contiguous chunks of pre-shuffled data, which keeps the minibatches random enough and the disk access fast.

One general principle applies: GPUs compute on dense tensors. For this class of models, sparsity serves to store and transport the data. Densification takes place late, and on small pieces only.

A last warning concerns vocabulary, which confuses students in examinations. A **minibatch** is a set of cells drawn for one gradient step, a setting of the loader. A **batch effect** is a technical artefact that results from separate processing of samples, an experimental variable. In scvi-tools, the argument `batch_key` refers to the second. When asked whether a model corrects for batch, one should first establish which meaning is intended.

## 9. Vocabulary

The terms of this course for the mind map:

- **Matrix:** count matrix, dense, sparse, sparsity, density, dtype, transpose, orientation.
- **Sparse formats:** COO, CSR, CSC, indptr, indices, data.
- **Containers:** AnnData, h5ad, obs, var, layers, obsm, uns, SummarizedExperiment, SingleCellExperiment, Seurat, MuData.
- **Design:** metadata, covariate, patient_id, pseudoreplication, cross-tabulation.
- **Transformations and scale:** log1p, centring, scaling, implicit centring, backed mode, chunking.
- **Deep learning:** minibatch, dataloader, tensor.
- **A pair connected by an edge labelled "do not confuse":** minibatch and batch effect.

## 10. Summary and next course

Three practices summarise the course. Check the orientation and the data type of each matrix after loading. Keep single-cell data sparse as long as possible, and know which operations move the zeros. Keep the metadata inside the object, with a `patient_id` column, and cross-tabulate them before any analysis.

For the project, this gives three concrete steps: transpose the GEO matrix for PyDESeq2, build `obs` with a `patient_id` column, and run the cross-tabulation.

Course 7 leaves the technical layer for another kind of question: where these data are stored, who may use them, and what is required for a piece of work to remain usable in ten years.
