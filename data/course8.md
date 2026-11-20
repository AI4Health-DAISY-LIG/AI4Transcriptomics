# Course 8: Dimensionality Reduction and Visualisation: The Bridge to AI

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 8, Dimensionality reduction and visualisation: the bridge to AI (20:39), SandrineTeach channel [https://www.youtube.com/watch?v=TejykYTAYMM](https://www.youtube.com/watch?v=TejykYTAYMM)

**Sources and further reading**

- Kobak D., Berens P. The art of using t-SNE for single-cell transcriptomics. *Nature Communications* 10:5416 (2019). Practical and excellent; the first text to read.
- Chari T., Pachter L. The specious art of single-cell genomics. *PLoS Computational Biology* 19(8):e1011288 (2023). The critique.
- Lause J., Berens P., Kobak D. The art of seeing the elephant in the room: 2D embeddings of single-cell data do make sense. *PLoS Computational Biology* 20(10):e1012403 (2024). The reply, to read together with the critique.
- Huang H., Wang Y., Rudin C., Browne E.P. Towards a comprehensive evaluation of dimension reduction methods for transcriptomic data visualization. *Communications Biology* 5:719 (2022). The benchmark.
- Jeon H., Park J., Shin S., Seo J. Stop misusing t-SNE and UMAP for visual analytics. arXiv:2506.08725 (2025). A checklist of when to use these plots, and when not.
- Luecken M.D., Theis F.J. Current best practices in single-cell RNA-seq analysis: a tutorial. *Molecular Systems Biology* 15:e8746 (2019). The closest equivalent of a textbook chapter in this field.
- Lopez R. et al. Deep generative modeling for single-cell transcriptomics (scVI). *Nature Methods* 15:1053–1058 (2018).
- Eraslan G. et al. Single-cell RNA-seq denoising using a deep count autoencoder. *Nature Communications* 10:390 (2019).
- Zhang Y., Parmigiani G., Johnson W.E. ComBat-seq: batch effect adjustment for RNA-seq count data. *NAR Genomics and Bioinformatics* 2:lqaa078 (2020).
- Heiser C.N., Lau K.S. A quantitative framework for evaluating single-cell data structure preservation by dimensionality reduction techniques. *Cell Reports* 31:107576 (2020).
- McInnes L., Healy J., Melville J. UMAP: Uniform Manifold Approximation and Projection. arXiv:1802.03426 (2018).
- van der Maaten L., Hinton G. Visualizing data using t-SNE. *JMLR* 9:2579–2605 (2008).
- Strang G., 18.06 Linear Algebra, MIT OpenCourseWare. The best treatment of the singular value decomposition. [https://ocw.mit.edu/courses/18-06-linear-algebra-spring-2010/](https://ocw.mit.edu/courses/18-06-linear-algebra-spring-2010/)

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=TejykYTAYMM&t=0s) |
| 2. Why reduce: three reasons | [0:53](https://www.youtube.com/watch?v=TejykYTAYMM&t=53s) |
| 3. Preprocessing before projection | [3:04](https://www.youtube.com/watch?v=TejykYTAYMM&t=184s) |
| 4. Principal component analysis | [5:23](https://www.youtube.com/watch?v=TejykYTAYMM&t=323s) |
| 5. PCA as the first diagnostic | [7:53](https://www.youtube.com/watch?v=TejykYTAYMM&t=473s) |
| 6. t-SNE and UMAP | [10:09](https://www.youtube.com/watch?v=TejykYTAYMM&t=609s) |
| 7. The critique | [12:36](https://www.youtube.com/watch?v=TejykYTAYMM&t=756s) |
| 8. The bridge: autoencoders and scVI | [15:35](https://www.youtube.com/watch?v=TejykYTAYMM&t=935s) |
| 9. Vocabulary | [17:43](https://www.youtube.com/watch?v=TejykYTAYMM&t=1063s) |
| 10. Conclusion of the block | [19:32](https://www.youtube.com/watch?v=TejykYTAYMM&t=1172s) |

---

## 1. Introduction

This is the last course of the block. Here the biology and the machine learning appear in the same equation.

Each sample, or each cell, is a vector in a space of about twenty thousand dimensions, one per gene. This space cannot be seen, and intuition fails in it. Many statistical instincts about distance and neighbourhood are wrong there, as section 2 shows.

In practice, the whole field starts with a reduction of that space: to between ten and fifty dimensions for computation, and to two for display. This course covers the method, its benefits and its costs. The costs matter most, and they are part of the examination.

## 2. Why reduce: three reasons

Three distinct reasons justify a reduction.

**Noise.** Most of the twenty thousand genes carry no information on the contrast of interest. They are constant, or they are pure measurement noise. Keeping them wastes computation and dilutes the signal: in the full space, the many uninformative coordinates dominate each distance.

**Correlation.** Genes do not act alone. They act in pathways, modules and co-regulated programs. The intrinsic dimensionality of a transcriptome, the number of underlying processes that vary, is perhaps a few tens. Dimensionality reduction attempts to recover those processes.

**The curse of dimensionality.** In high dimension, distances concentrate: the distance from a point to its nearest neighbour becomes almost equal to the distance to its furthest neighbour. Any method built on distances or neighbourhoods suffers, for example k-nearest neighbours, most clustering methods and kernel methods. They degrade in the raw space and work much better after projection. For this reason, the standard pipeline clusters cells in PCA space and not in gene space.

A short experiment illustrates the third reason. Draw a thousand random points in two dimensions: the nearest neighbour of a point is much closer than its furthest one. Repeat in twenty thousand dimensions: the ratio of the two distances approaches one, and each point sits at about the same distance from all the others.

Heiser and Lau (2020) show how to measure what a reduction preserves. They compute all cell-to-cell distances and the nearest-neighbour graph in the full gene space, repeat the computation after reduction, and compare the two. Sections 6 and 7 use this idea again.

## 3. Preprocessing before projection

Four steps precede any projection (see the workflow of Luecken and Theis, 2019). If one is skipped, the first principal component turns out to be a technical artefact.

**1. Filter.** Remove the genes detected in almost no samples. For single-cell data, also remove the cells with very few genes or a high mitochondrial fraction, the quality metrics of Course 2.

**2. Normalise for library size.** A sample sequenced twice as deeply has about twice the counts for each gene, for no biological reason. Without correction, sequencing depth becomes the dominant axis. The simplest method is counts per million (CPM), which scales each sample to a total of one million. In single-cell work, each cell is scaled to a common total: scanpy uses the median library size by default, and many tutorials use ten thousand. In bulk work, more careful estimators apply, the median-of-ratios of DESeq2 or the TMM of edgeR. Both remain robust when a few very highly expressed genes take most of the library.

A point for the practicals: DESeq2 and PyDESeq2 take raw counts and normalise them internally, as part of their model. They must not receive normalised values. The normalisation described here serves visualisation and PCA, and not the differential test.

**3. Apply log1p.** Expression spans five orders of magnitude, so on a linear scale a few highly expressed genes dominate each distance. The logarithm compresses this range. It also roughly stabilises the variance, which then depends less on the mean. As Course 6 showed, log1p maps zero to zero, so the matrix stays sparse.

**4. Select highly variable genes.** Keep the genes whose variance exceeds the value that their mean predicts, typically the top two thousand. This step is the one most often skipped, and it improves an embedding more than any hyperparameter tuned afterwards.

## 4. Principal component analysis

**Definition.** The matrix is centred, so that each gene has mean zero. PCA then finds an orthogonal basis. The first axis points in the direction of greatest variance. The second axis takes the greatest remaining variance, orthogonal to the first, and so on. The computation is the singular value decomposition of the centred matrix, and the eigenvalue attached to each component is the variance that the component explains.

**Three outputs.**

- The **scores** are the samples expressed in the new basis. They are plotted, and clustering runs on them.
- The **loadings** are the weights of each gene on each component, and they are used far too little. The genes with the largest weights on PC1 often reveal at once what PC1 is: a cell-cycle program, an inflammatory program or, more often than one would wish, a batch.
- The **explained variance** is displayed as a scree plot. For the 2,700 blood cells of the standard scanpy tutorial, the first few components carry most of the structure, and the curve then flattens into noise. Components are kept up to this elbow: thirty to fifty for single-cell work, with a scanpy default of fifty, and far fewer for a bulk study of sixty samples.

The number of components cannot exceed the number of samples minus one. For a bulk study of sixteen samples, the scree plot has at most fifteen bars, of which the first three to five are read. In code, PCA takes one line, `sc.tl.pca` in scanpy or `PCA` in scikit-learn, applied to the log-normalised matrix. The scree plot takes one more line.

**Two properties.**

First, PCA is linear: each component is a weighted sum of genes. The loadings are therefore interpretable, and PCA struggles with curved structure.

Second, PCA is unsupervised: it maximises variance, and variance is not relevance. If the largest source of variance is the sequencing batch, PC1 is the batch. PCA works as designed in that case: it detects variance and knows nothing about the biology.

## 5. PCA as the first diagnostic

This section describes the habit that matters most in this block. With a new dataset, the first operation, before differential expression or any other analysis, is to compute a PCA and to plot it four times: coloured by condition, by batch, by sex, and by RIN, age or post-mortem interval. The plots are then read.

The ComBat-seq paper (Zhang, Parmigiani and Johnson, 2020), which presents a batch correction method for count data, provides a real case. Breast epithelial cells were transfected to activate different oncogenic pathways and sequenced in three batches. Before adjustment, the samples separate by batch, so batch is the largest source of variance.

The design of this study is the cross-tabulation of Course 6. The GFP controls appear in all three batches, and each treatment sits in a single batch. The controls allow the method to estimate the batch effect. For the treatments, batch and treatment can be separated only through the controls. After ComBat-seq adjustment, the controls of the three batches come together while the treatments stay apart. Without the shared control group, the method could not achieve this.

The same reading applies to any PCA plot.

| Observation | Interpretation |
|---|---|
| The conditions separate and no other variable does | The design looks clean; some suspicion remains appropriate |
| The batches separate | Recovery is possible only if the batches mix the conditions |
| No variable separates | Either the effect is small, which is normal, or a problem exists upstream |

One practical consequence follows for the project. Corrected data serve for display, and for display only. For the differential test, batch-corrected counts are not given to PyDESeq2. Batch enters the design formula, as the authors of DESeq2 and edgeR recommend, and the model accounts for it.

These plots take three lines of code. The report must contain them and, above all, an interpretation of them.

## 6. t-SNE and UMAP

In a complex tissue, two linear dimensions superimpose distinct populations. To separate them, the field adopted non-linear neighbour embeddings.

**t-SNE** (van der Maaten and Hinton, 2008) converts the distances in the high-dimensional space into probabilities that one point selects another as its neighbour. It then arranges the points in two dimensions to match those probabilities. Its key parameter is the perplexity, which corresponds roughly to the effective number of neighbours.

**UMAP** (McInnes, Healy and Melville, 2018) builds a weighted k-nearest-neighbour graph and optimises a two-dimensional layout of that graph. The parameter `n_neighbors` trades local detail against global structure, and `min_dist` controls how tightly the points pack. UMAP runs faster than t-SNE and is the default in single-cell work.

Both methods run on the PCA output, and not on the genes. The sequence is: normalise, select variable genes, run PCA down to about fifty dimensions, build the neighbour graph there, and embed in two dimensions. Applied to twenty thousand genes, the methods are slower and noisier, and the curse of dimensionality degrades the result.

Both methods aim to preserve neighbourhoods. They make no promise about distances. Kobak and Berens (2019) show this on data with fifteen known clusters. PCA keeps the global arrangement of the clusters and almost none of the fine neighbourhoods. Default t-SNE does the opposite: it gives far better neighbourhoods and places the clusters on the page in a largely arbitrary way. Better settings, such as a PCA initialisation, recover much of the global layout. Even then, nothing guarantees that distances on the page have a meaning.

For the project, one remark applies. These methods are designed for thousands of points. The bulk datasets of the project have a few dozen samples at most, and sixteen for the Rett study. The default perplexity of t-SNE, thirty, exceeds that number, and scikit-learn refuses to run. The project uses PCA; t-SNE and UMAP add nothing. In single-cell work, the random seed is changed at least once before any shape is believed.

## 7. The critique

UMAP figures are among the most over-interpreted objects in modern biology. A benchmark and a debate show why.

**The benchmark.** Huang, Wang, Rudin and Browne (2022) compared the popular methods, t-SNE, UMAP, TriMap, PaCMAP, PHATE and others, on data with a known true structure, including a three-dimensional mammoth. Each method draws the mammoth differently, and the drawing changes when a single setting goes from ten to fifteen to thirty. The data are the same and the pictures change. The authors give two warnings. First, these methods can produce false clusters: groups that separate on the page with little real difference behind them. Second, choices of parameters and preprocessing that look harmless can destroy the true structure of the data.

**The checklist.** Jeon and colleagues (2025) reviewed more than a hundred published analyses and derived a checklist.

| t-SNE and UMAP are suited to | They are not suited to |
|---|---|
| finding clusters | comparing distances between clusters or between points |
| finding outliers | judging cluster density |
| finding the neighbours of a point | judging the separability of classes |

The unsuited readings nevertheless appear often in published papers. The authors also observed practitioners who adjusted hyperparameters until the picture looked right, and who chose UMAP only because an advisor, or a language model, suggested it.

**The debate.** Chari and Pachter (2023) called these embeddings specious. They showed that data can be forced into the shape of an elephant without any reaction from the usual quality scores. Lause, Berens and Kobak (2024) replied that those scores measured distances, which these methods never claimed to preserve. Measured on neighbourhoods and cell types, they argued, t-SNE and UMAP are far from arbitrary. Both sides agree on the point that matters here: the two-dimensional coordinates are never used for quantitative analysis.

**In practice.** Clustering runs on the neighbour graph in PCA space, with Leiden or Louvain, and the embedding only displays the result. The analyst then shows that the claim survives a different clustering resolution, a different random seed, and a check with marker genes that make biological sense. The position of this course is that these plots are indispensable for exploration and communication, and that they are not evidence. For each UMAP figure in a paper, one question applies: does a claim in the text rest only on this picture? If it does, the claim is not yet supported.

## 8. The bridge: autoencoders and scVI

This section links the block to the rest of the AI curriculum.

PCA finds the best linear low-dimensional representation. An **autoencoder** does the same without the constraint of linearity. An encoder network compresses the expression vector into a latent representation of ten to thirty dimensions. A decoder reconstructs the input from it, and training minimises the reconstruction error. With a linear encoder, a linear decoder and a squared error, the latent space spans exactly the PCA subspace, a result of Baldi and Hornik. An autoencoder is therefore a non-linear generalisation of section 4.

For transcriptomics, the most important change concerns the loss. In the deep count autoencoder of Eraslan and colleagues (2019), already seen in Course 6, counts enter the network and pass through a narrow bottleneck. In place of a direct reconstruction, the decoder outputs the parameters of a count distribution, a negative binomial or a zero-inflated negative binomial. Training maximises the likelihood of the observed counts under that distribution. The loss function therefore carries the sampling physics of Course 4.

**scVI** (Lopez and colleagues, 2018) extends the idea. It is a variational autoencoder, so its latent space is probabilistic. It uses a count likelihood, and it receives the batch label as an explicit input, so that the latent space can carry the biology while the model accounts for the batch.

The machine learning blocks cover these architectures. One remark suffices here. Each statement made about PCA holds for a learned latent space: variance is not relevance, the largest signal may be technical, and a projection is a hypothesis and not a result. In a latent space, all of this is much harder to verify.

## 9. Vocabulary

The terms of this course for the mind map:

- **Motivation:** curse of dimensionality, intrinsic dimensionality.
- **Preprocessing:** library size normalisation, counts per million, median-of-ratios, TMM, log1p, variance stabilisation, highly variable genes, feature selection.
- **PCA:** PCA, singular value decomposition, eigenvalue, principal component, scores, loadings, scree plot, explained variance, elbow.
- **Neighbour embeddings:** k-nearest-neighbour graph, t-SNE, perplexity, UMAP, n_neighbors, min_dist, neighbourhood preservation, Leiden, Louvain, clustering resolution.
- **Learned representations:** embedding, latent space, autoencoder, variational autoencoder, scVI, reconstruction loss, negative binomial likelihood, batch correction.

## 10. Conclusion of the block

The block started with a molecule in a nucleus. We followed it out of the cell, through reverse transcription, a sequencer and an aligner, into a sparse matrix, into an archive, and into a two-dimensional plot. At each step, someone made a decision, and each decision left a trace in the numbers. The numbers under analysis carry all of these decisions, and the task of the analyst is to know which decisions were inherited.

For engineers, the block should have shown why the biology matters for each modelling choice. For biologists, the models should now be less opaque.

The assessments, the formation of the groups and the deadlines are published on Uness. The vocabulary sections at the end of each course provide the raw material for the mind map, and the connections remain the work of each student.
