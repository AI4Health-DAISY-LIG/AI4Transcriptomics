# Course 7: Data Stewardship: Repositories, Reuse and the FAIR Principles

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 7, Data Stewardship and FAIR (19:31), SandrineTeach channel [https://www.youtube.com/watch?v=b5MKxQGgiI4](https://www.youtube.com/watch?v=b5MKxQGgiI4)

**Sources and further reading**

- Wilkinson M.D. et al. The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data* 3:160018 (2016). The founding reference, six pages long.
- Gabelica M., Bojčić R., Puljak L. Many researchers were not compliant with their published data sharing statement: a mixed-methods study. *Journal of Clinical Epidemiology* 150:33–41 (2022).
- Tedersoo L. et al. Data sharing practices and data availability upon request differ across scientific disciplines. *Scientific Data* 8:192 (2021).
- Baker M. 1,500 scientists lift the lid on reproducibility. *Nature* 533:452–454 (2016).
- Barrett T. et al. NCBI GEO: archive for functional genomics data sets, update. *Nucleic Acids Research* 41:D991–D995 (2013).
- Wilks C. et al. recount3: summaries and queries for large-scale RNA-seq expression and splicing. *Genome Biology* 22:323 (2021).
- Khoroshevskyi O. et al. GEOfetch: a command-line tool for downloading data and standardized metadata from GEO and SRA. *Bioinformatics* 39:btad069 (2023).
- Mungall C.J. et al. Uberon, an integrative multi-species anatomy ontology. *Genome Biology* 13:R5 (2012).
- Unni D.R. et al. Biolink Model: a universal schema for knowledge graphs in clinical, biomedical, and translational science. *Clinical and Translational Science* 15:1848–1855 (2022). doi:10.1111/cts.13302
- Biolink Model documentation, starting with the `knowledge_level` and `agent_type` slots. [https://biolink.github.io/biolink-model/](https://biolink.github.io/biolink-model/)
- NCATS Biomedical Data Translator. [https://ui.transltr.io/](https://ui.transltr.io/)
- Harmanci A., Gerstein M. Analysis of sensitive information leakage in functional genomics signal profiles through genomic deletions. *Nature Communications* 9:2453 (2018).
- Gymrek M. et al. Identifying personal genomes by surname inference. *Science* 339:321–324 (2013).
- The Turing Way: a free community handbook on reproducible research, with chapters on research data management. [https://the-turing-way.netlify.app/](https://the-turing-way.netlify.app/)

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=0s) |
| 2. "Available upon request" | [0:59](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=59s) |
| 3. The repository landscape | [2:51](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=171s) |
| 4. Anatomy of a GEO record | [4:45](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=285s) |
| 5. FAIR, principle by principle | [6:56](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=416s) |
| 6. Ontologies: the nouns | [9:08](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=548s) |
| 7. Biolink Model: the sentences | [11:01](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=661s) |
| 8. Ethics: consent, access, re-identification | [13:02](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=782s) |
| 9. Sharing data and code: Zenodo, Hugging Face | [15:08](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=908s) |
| 10. Vocabulary | [17:08](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=1028s) |
| 11. Summary and next course | [18:56](https://www.youtube.com/watch?v=b5MKxQGgiI4&t=1136s) |

---

## 1. Introduction

The second half of this block rests on one assumption: the data already exist.

A transcriptomic study of a rare disease costs tens of thousands of euros and takes years. It depends on patients and families who agreed to donate tissue, sometimes after death, for a condition that affects a small number of people. Such a dataset is a gift from those families, and the gift comes with conditions.

Most of these datasets serve once, for one paper, although they could answer many more questions. In rare disease, reuse is therefore close to an ethical obligation.

This course examines what makes reuse possible: where data are stored, how they are described, what use is permitted, and what an author must do so that others can still use the data in ten years.

## 2. "Available upon request"

The starting point is a failure, from which the rest of the course follows.

In 2016, *Nature* surveyed more than fifteen hundred scientists (Baker, 2016). More than 70 % reported that they had tried and failed to reproduce an experiment of another scientist, and more than half had failed to reproduce one of their own.

For years, the usual data availability statement in biomedical journals read: "data are available from the corresponding author upon reasonable request". The statement sounds responsible. Gabelica and colleagues (2022) tested it: they wrote to the authors of nearly eighteen hundred papers that made this promise. One hundred and twenty-three sent the data, which is 6.8 %, or about one in fifteen. The others declined or did not answer.

Tedersoo and colleagues (2021) examined the same problem from another angle. For papers in *Nature* and *Science* across nine disciplines, they measured the share whose data were available at publication, and the share after contact with the authors. A request helps, and it does not close the gap. The authors concluded that journals should stop accepting "available upon request".

The conclusions of those papers remain in the literature, and the evidence behind them can no longer be retrieved. For science, this is a failure: a result that nobody can re-examine can only be taken on trust.

Journals and funders now apply a clear rule: the data are deposited in a public archive, and the paper prints the accession number. Without that number, the second assignment of this block would be impossible.

## 3. The repository landscape

| Repository | Content | Access | Use |
|---|---|---|---|
| GEO (NCBI, United States); ArrayExpress, now part of BioStudies (EMBL-EBI, Europe) | Processed expression data | Open: a URL and a download | Source of the count matrices; the three papers proposed for the project deposited their data in GEO |
| SRA and ENA, which mirror each other | Raw reads (FASTQ), hundreds of gigabytes per study | Open | Not downloaded in this course |
| dbGaP (United States), EGA (Europe) | Data that can identify individuals, or data whose consent did not allow open release | Controlled: an application, a decision by a data access committee, a signed agreement | Sensitive human data; the procedure protects the donors |
| recount3 | More than 750,000 human and mouse RNA-seq samples reprocessed with a single pipeline | Open | Uniform processing, whose value follows from Course 5 |
| Expression Atlas | Curated differential expression results | Open | First look at a study |
| CZ CELLxGENE Discover, Human Cell Atlas | Single-cell data | Open, with exploration in the browser | Exploration before any download |

A recommended route for the project: consult Expression Atlas or CELLxGENE first, fetch the data from GEO, and check whether recount3 already holds a uniformly processed version of the study.

## 4. Anatomy of a GEO record

Students spend hours on GEO, so the structure of a record deserves a careful reading. The GEOfetch paper (Khoroshevskyi and colleagues, 2023) provides a clear diagram.

- A **series**, with an identifier that starts with GSE, is one study.
- A series contains **samples**, the GSMs, with one library each. Each sample becomes one row of the metadata table.
- A **platform**, GPL, describes the instrument.
- Samples link to the raw reads in the SRA, under identifiers that start with SRP, SRX and SRR.
- Series and samples may both carry processed files.

The Rett dataset of the project list, GSE128380, has sixteen GSMs: four Rett donors and four control donors, with two brain regions each.

Three warnings apply.

1. The *overall design* field is free text, and it should be read before any other field.
2. The characteristics of each sample are free-text pairs of keys and values, with no controlled vocabulary. The same archive contains "Male", "male", "M" and "Homme".
3. The supplementary files contain what the authors chose to deposit: raw counts, normalised values, FPKM, a covariate-adjusted matrix that DESeq2 cannot use, or only a results table. The analyst opens them and reads ten rows before any planning.

The essential habit is to fetch data with code and not with clicks. In Python, GEOparse reads a series and its sample metadata into pandas. geofetch downloads GEO and SRA metadata, and optionally the files, into one standard table. pysradb does the same for the SRA.

Code supports reproducibility because the script is itself the record. It states which accession and which files were used. It parses the metadata in the same way each time, so no spreadsheet is edited by hand without a trace. A reviewer, a group member, or the author a year later can rerun it and obtain the same table. A folder of downloads with no history provides none of this.

## 5. FAIR, principle by principle

Wilkinson and colleagues published the FAIR principles in *Scientific Data* in 2016. They now appear in the data management plans that nearly all European funders require. The four letters cover fifteen sub-principles, written for machines as much as for people.

| Principle | Formal requirements | Meaning for a GEO dataset |
|---|---|---|
| **F**indable | A globally unique and persistent identifier; rich metadata that include this identifier; registration in a searchable resource | The paper cites a GSE accession, and not a URL on a laboratory website: laboratories move and links break |
| **A**ccessible | Retrieval by identifier through a standard, open and free protocol, with authentication where necessary; metadata that remain available when the data no longer are | A documented procedure leads to the data |
| **I**nteroperable | A shared formal language; vocabularies that are themselves FAIR; qualified references to other data | Ensembl identifiers in place of gene symbols, ontology terms in place of free text |
| **R**eusable | Rich attributes; a clear licence; detailed provenance; community standards | The genome build, the annotation and the pipeline that produced the data (Course 5) |

The *accessible* principle is the most misread. **FAIR does not mean open.** A dataset under controlled access in the EGA can be fully FAIR: it can be found, its description can be read, and a documented procedure gives access to it.

The project of each group is evaluated against this table. A repository with a README that names the GSE, a script that downloads it, pinned package versions and a log of decisions is FAIR. Months later, when a reviewer asks a question, this organisation proves its value.

## 6. Ontologies: the nouns

Metadata are the part of data stewardship that all agree is important and few enjoy.

Minimum-information standards set the lower bound: MIAME for microarrays and MINSEQE for sequencing. They list what a deposit must describe: the design, the samples, the protocol, the processing and the raw data.

Above this lower bound, ontologies make a deposit reusable. An ontology is a controlled vocabulary in which each term has a stable identifier and a place in a hierarchy of relations: a set of permitted words with links between them. The ontologies met in this field include EFO, Uberon (anatomy), the Cell Ontology, MONDO and Orphanet (diseases), HPO (phenotypes), and the Gene Ontology, used for enrichment analysis.

Terms are written as CURIEs: a prefix, a colon and an identifier. `UBERON:0000955` is the brain, and `MONDO:0010726` is Rett syndrome. The prefix names the authority, the identifier is permanent, and the label can change without consequence. This is the argument of Course 5 for Ensembl identifiers over gene symbols, applied one level higher.

The Uberon paper (Mungall and colleagues, 2012) shows the value of the hierarchy. "Alveolus of lung" is a kind of alveolus, and it is part of the lung. The lung term of Uberon also covers the lung terms of the mouse and human anatomy ontologies. A query for genes expressed in the lung therefore also returns data annotated to alveoli, in mouse or in human.

For the project, the CURIE is placed next to the free text in `obs`, and "not reported" is written in place of a blank. A missing value and an unknown value differ, and the difference is itself information.

## 7. Biolink Model: the sentences

Ontologies provide the nouns. They do not say how to build a sentence. The Biolink Model does, and it is the point where transcriptomics meets knowledge graphs.

Suppose we want to state that the gene *MECP2* is associated with Rett syndrome. Ontologies give identifiers for both ends. Three questions still need shared answers: what kind of entity is each end, what kind of relation joins them, and how do we know?

Biolink answers all three. It is a schema written in a language named LinkML, developed for the NCATS Biomedical Data Translator. It defines a hierarchy of categories for the nodes, such as `Gene`, `Disease`, `PhenotypicFeature` or `AnatomicalEntity`, and a hierarchy of predicates for the edges, which all descend from a root predicate named `related_to`. Because both are hierarchies, independent knowledge sources can be queried as one graph.

The basic unit of knowledge is the **association** (Unni and colleagues, 2022). Its core is a triple: subject, predicate, object. Around the triple, slots hold the metadata: the origin of the statement and the evidence that supports it.

Two of these slots are now required.

- `knowledge_level` states whether the statement is an assertion, a statistical association, an observation or a prediction.
- `agent_type` states whether a human curator, a text-mining tool or a computational model produced it.

Consider "*MECP2* is associated with Rett syndrome". Asserted by a curator, this sentence carries a very different weight from the same sentence predicted by a model. In a graph that ignores the difference, a guess can pass for a fact. Each time a machine returns biomedical knowledge, these two fields are the first to read.

## 8. Ethics: consent, access, re-identification

This section is the most important of the course.

**Consent.** Each patient consented to a specific use. Broad consent for future research is common, yet not all studies have it, and nobody can add it afterwards. A person who reuses a dataset inherits the terms under which the researchers collected it.

**Why controlled access exists.** Expression data seem anonymous, and they are not. RNA-seq reads contain sequence, from which genetic variants can be called. Expression levels themselves carry genotype information through eQTLs, genetic variants that change the expression of a gene. Harmanci and Gerstein (2018) describe an attack that exploits this. The attacker takes publicly shared RNA-seq signal profiles, reads genomic deletions from the dips in coverage, and matches them against a genotype database that lists people by name. The match reveals the identity of the individuals, along with any sensitive information that the expression study held about them. Genomic data cannot be anonymised in the way a name is removed from a spreadsheet. For this reason, raw human reads are often stored in dbGaP or the EGA.

**The specific risk of rare disease.** Take six patients with a disease that affects two hundred people in Europe, with age, sex and referring centre in the metadata. These three fields may suffice to identify a person. An analyst who realises that the identity of a subject can be guessed has found a data-protection incident and should report it.

One principle extends beyond this course: the ability to download a file says nothing about the permitted use of that file. Under the GDPR, the European data protection regulation, health data are a special category, and "it was on the internet" has never been a legal basis.

## 9. Sharing data and code: Zenodo, Hugging Face

The preceding sections concern data shared by others. This one concerns the duties of a provider, starting with the student project.

The key object is the DOI, digital object identifier: a persistent identifier that points to a piece of work wherever it moves. It is principle F1 of FAIR applied to one's own work.

| Content | Repository | Notes |
|---|---|---|
| Expression data behind a paper | GEO or ArrayExpress | An accession number and metadata that follow the MINSEQE standard |
| Code, processed matrices, figures, weights of a trained model | Zenodo | Run by CERN and free; any format, up to 50 GB per record; a DOI for each version and a concept DOI that points to the latest version; connected to GitHub, it archives each tagged release of a repository with a DOI |
| Data ready for machine learning | Hugging Face Datasets | A common home for biological datasets; the dataset card is the documentation and deserves the care of a methods section |

An example on Hugging Face is Tahoe-100M: a hundred million single-cell profiles from fifty cancer cell lines treated with more than eleven hundred drugs, released under CC0 and loadable with one line of code.

Two rules apply to each choice.

1. **Attach a licence:** CC BY or CC0 for data, and an open-source licence such as MIT for code. Without a licence, nobody may legally reuse the work.
2. **Respect the limits on human data.** Identifiable human data may not be eligible for open release. Controlled access through the EGA then keeps the data FAIR without making them public.

## 10. Vocabulary

The terms of this course for the mind map:

- **Repositories:** GEO, GSE, GSM, GPL, SRA, ENA, ArrayExpress, BioStudies, dbGaP, EGA, recount3, Expression Atlas, CELLxGENE, Human Cell Atlas.
- **Deposition:** accession number, supplementary file, data availability statement, deposition.
- **FAIR:** FAIR, findable, accessible, interoperable, reusable, persistent identifier, DOI, Zenodo, ORCID.
- **Metadata and ontologies:** metadata, MINSEQE, ontology, controlled vocabulary, CURIE, EFO, Uberon, Cell Ontology, Gene Ontology, MONDO, Orphanet, HPO.
- **Knowledge graphs (bonus):** knowledge graph, triple, predicate, category, Biolink Model, LinkML, TRAPI, NCATS Translator, knowledge_level, agent_type.
- **Governance:** provenance, licence, consent, controlled access, re-identification, GDPR.

The Biolink terms are bonus vocabulary: they are not required, and a correct placement earns points.

## 11. Summary and next course

Data that are only "available on request" are, in most cases, unavailable. Reuse starts with a public archive, an accession number, and a script that fetches the data. FAIR does not mean open. The ability to download a file says nothing about what may be done with it.

Course 8 is the last of the block and the bridge to the AI half: how to reduce twenty thousand dimensions to two without self-deception.
