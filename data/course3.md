# Course 3: Git Best Practices: A Start-Up Guide

*From Nucleus to Neural Networks: Foundations of AI in Transcriptomics* · M2 AI for Omics  
Sandrine Muller · AI4Health@DAISY group · LIG · Université Grenoble Alpes

## References

**Video lecture**

- Course 3, Git Best Practices (19:32), SandrineTeach channel [https://www.youtube.com/watch?v=YnwD_9Stjh0](https://www.youtube.com/watch?v=YnwD_9Stjh0)

**Sources and further reading** (all free)

- MIT, The Missing Semester of Your CS Education, lecture on version control (Git). It explains the data model of Git instead of listing commands, and it is the best starting point for readers who find Git arbitrary. [https://missing.csail.mit.edu/2020/version-control/](https://missing.csail.mit.edu/2020/version-control/)
- Chacon S., Straub B. *Pro Git*, 2nd ed. Chapters 2 and 3 cover the needs of this semester. [https://git-scm.com/book](https://git-scm.com/book)
- GitHub Skills: an interactive first branch and first pull request inside a real repository. [https://skills.github.com/](https://skills.github.com/)
- Astral, uv documentation: installation, projects, lock files. [https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)
- AI4Health@DAISY group, Python for beginners: setting up Python and uv, step by step. [https://ai4health-daisy-lig.github.io/python4beginners/tutorial.html?collection=tutorials&lesson=setup](https://ai4health-daisy-lig.github.io/python4beginners/tutorial.html?collection=tutorials&lesson=setup)
- Perez-Riverol Y. et al. Ten Simple Rules for Taking Advantage of Git and GitHub. *PLoS Computational Biology* 12(7):e1004947 (2016).
- Wilson G. et al. Good Enough Practices in Scientific Computing. *PLoS Computational Biology* 13(6):e1005510 (2017). Eleven pages of direct use in daily work.
- The Turing Way: community handbook on reproducible research. [https://the-turing-way.netlify.app/](https://the-turing-way.netlify.app/)

## Contents

| Section | Video |
|---|---|
| 1. Introduction | [0:00](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=0s) |
| 2. The problem: three familiar situations | [1:36](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=96s) |
| 3. The mental model: a chain of snapshots | [3:14](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=194s) |
| 4. Six commands that cover 95 % of the work | [5:01](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=301s) |
| 5. Branches and pull requests | [6:25](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=385s) |
| 6. What must never enter a repository | [8:05](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=485s) |
| 7. What is a Python environment? | [10:16](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=616s) |
| 8. Setting up a project with uv | [11:43](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=703s) |
| 9. Anatomy of a good analysis repository | [13:33](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=813s) |
| 10. Commits as a lab notebook, releases as citable code | [15:07](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=907s) |
| 11. Requirements for the group repository | [16:45](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=1005s) |
| 12. Summary and next course | [18:55](https://www.youtube.com/watch?v=YnwD_9Stjh0&t=1135s) |

---

## 1. Introduction

This course leaves the cell and covers two tools: version control with Git, and Python environments with uv.

The course is optional. Students who open pull requests each week and who manage their Python environments with uv or a similar tool can move to Course 4. The other students should follow it, and this includes many engineers: a person who has worked alone on a personal laptop for years has had no reason to learn these tools.

The reason is practical. From Course 5 onwards, each submission for this block is a Git repository with a readable history. Notebooks attached to emails and zip files are not accepted. The second assessment asks students to reproduce a published differential expression analysis, and it shows how hard this task becomes when the authors did not keep their code or record their package versions. Students who have met this difficulty should not pass it on to the next reader.

The course provides a vocabulary, six Git commands, and a method to set up a Python project that runs in the same way on each machine. Fluency comes with practice, during the same week.

## 2. The problem: three familiar situations

**Situation 1.** Figure 3 of a report looks wrong. A correction was made two weeks ago, its content is forgotten, and the script that produced the figure has changed eleven times since. The version that produced the figure already pasted into the slides cannot be found.

**Situation 2.** An analysis ran on Tuesday and fails today, although "nothing changed". In fact, a package was updated, a helper function was edited late at night, and a data file moved to another folder.

**Situation 3.** Two students edited the same script over the weekend. The last one to save wins, the work of the other is lost, and neither received a warning.

Version control addresses all three. It keeps each state that the project has been in, labelled with the author of the change and its reason. Two names are often confused. **Git** is the tool that runs on the computer. **GitHub** and **GitLab** are websites that host Git repositories and add collaboration features. Many working researchers confuse them, and the distinction should be clear from the start.

Version control alone does not solve the package update of situation 2. Sections 7 and 8 return to it with environments.

## 3. The mental model: a chain of snapshots

One mental model is enough; the rest of Git is syntax that can be looked up.

A Git repository is a chain of snapshots, and Git calls each snapshot a **commit**. A commit is the complete state of the project at one moment: each file as it was, the author, the date, a short message that explains the reason for the change, and a pointer to the previous commit. The history is therefore a graph of project states in which we can move. Three consequences follow.

1. **We can return to any commit**, at any time, and find it as it was.
2. **We can find when something broke.** Git keeps each state, so we can walk back through the history, or ask Git to search it with `git bisect`, until we find the commit where the result changed.
3. **We can branch.** Because the history is a graph, a second line of snapshots can start from any point, receive work, and later be merged or discarded. The version that already worked stays untouched.

Two further terms complete the model. The repository lives in a hidden folder named `.git` inside the project folder. A **remote** is another copy of the repository, usually on GitHub. `push` sends new commits to the remote, and `pull` brings the new commits of the remote to the local copy. The laptop and GitHub are peers, and both hold the complete history. For this reason Git is described as distributed.

## 4. Six commands that cover 95 % of the work

| Command | Effect |
|---|---|
| `git clone` | copies an existing repository onto the machine |
| `git status` | shows what has changed |
| `git add` | stages a change for the next snapshot |
| `git commit` | takes the snapshot |
| `git push` | sends the commits to GitHub |
| `git pull` | brings the commits of GitHub to the machine |

Two recommendations prevent most later trouble.

First, `git status` costs nothing and should be typed often: before `add`, after `add`, before `commit`, after `pull`. It states the current position in plain English and usually suggests the next command.

Second, `add` and `commit` are two separate steps by design. `add` selects the changes that go into the next snapshot. A bug fix and a new figure made in the same afternoon can then be recorded as two commits. Six months later, two separate commits are much easier to read than one mixed commit.

One warning concerns a seventh command. When Git refuses a push, the temptation is to type `git push --force`. The correct reaction is to stop and ask someone. A forced push rewrites the shared history, and on a group project it can erase the work of the other members.

## 5. Branches and pull requests

`main` is the branch that must work at all times. To try something, for example a new normalisation or a different statistical model, we create a branch. The command `git switch -c feature/deseq2` creates a branch with that name and moves onto it.

DESeq2 is the standard method to test which genes change their expression level between two groups of samples, for example patients and controls. The second assessment uses its Python version, PyDESeq2.

On a branch, commits can be as frequent as needed, and `main` does not move. If the idea fails, the branch is deleted. If it works, it is merged.

On GitHub, a merge goes through a **pull request**: a web page that shows what would change. The other members of the group can comment line by line, and the whole discussion stays on record.

The group project follows one rule: one branch per person per task, and nobody merges their own pull request. Another member of the group reads it and merges it.

The reason is the oral examination. When the examiner asks why the group chose a given filtering threshold, the best answer is: "we discussed it in pull request number 4, and here it is". This record exists only if another member examined the choice when it was made.

## 6. What must never enter a repository

Git handles text files such as code well, and gigabytes of binary data badly. Five kinds of files stay out of the repository.

1. **Raw data.** In transcriptomics, raw data are FASTQ files, which hold the millions of short sequence reads produced by the sequencer, and count matrices, which give the number of reads that each gene received in each sample. They belong in the public archive they came from; for the papers of this block, the archive is GEO, the Gene Expression Omnibus. The repository stores the accession number, for example GSE104288, and the script that downloads the files. The repository stays small, and any reader can check the origin of the data.
2. **Anything that identifies a patient.** The GDPR applies, so this is a legal obligation. Git has a property that requires care: a file that was committed and then deleted remains in the history and in each clone. A proper removal requires a rewrite of the history, which is painful, and if the repository was public in the meantime, the data have already leaked. Such files must stay out from the first commit.
3. **Credentials:** passwords, tokens, API keys, and the `.env` files that often contain them. Bots scan public GitHub continuously for these.
4. **Outputs that can be regenerated:** caches, `__pycache__` folders, intermediate objects, rendered figures unless a figure is itself a deliverable, and the `.venv` folder that holds the Python environment (section 7).
5. **Any file above about 100 MB**, which GitHub refuses in any case.

The tool for all five is a file named `.gitignore`, at the root of the repository. It lists the files that Git must ignore. It should be written on the first day, before the first commit. Adding it later is the most common self-inflicted problem in student projects.

## 7. What is a Python environment?

Situation 2 of section 2, "it worked last Tuesday", is often caused by a package that changed version.

A Python environment is a folder inside the project, by convention named `.venv`. It contains one Python interpreter and the exact set of packages that the project uses, each at a specific version.

Each project needs its own environment. Suppose that project A needs pandas 1.5 and project B needs pandas 2.2. A single global installation on the laptop breaks one of the two. With one environment per project, each project has what it needs and the two do not interfere.

An environment is disposable. It is not edited by hand and it is not committed. If it reaches an inconsistent state, we delete the `.venv` folder and rebuild it in a few seconds.

The rebuild uses a recipe, and the recipe goes into Git. It has two files. `pyproject.toml` lists the packages that the project requested. `uv.lock` records the exact version of each installed package, including the dependencies of the dependencies. The same recipe gives the same environment on each laptop of the group and on the machine used for grading.

## 8. Setting up a project with uv

This block uses a tool named uv. It installs Python itself, creates the environment and installs the packages. It replaces three older tools, pyenv, venv and pip, and it is fast.

**Once per machine.** Install uv with one line: a `curl` command on macOS or Linux, an `irm` command in PowerShell on Windows. The *Python for beginners* tutorial of the group (see References) describes this step in detail.

**Once per project.**

```
uv init                     # creates pyproject.toml and .python-version
uv python pin 3.12          # fixes the Python version
uv add pandas pydeseq2 scanpy jupyterlab
```

The `uv add` command does three things: it resolves versions that are compatible with each other, writes them into `pyproject.toml` and `uv.lock`, and installs them into `.venv`.

**Each day.** Prefix commands with `uv run`:

```
uv run jupyter lab          # opens Jupyter inside the project environment
uv run python script.py     # runs a script inside the environment
```

No activation is needed, and the code cannot run with the wrong Python by accident.

**After a clone.** A group member who clones the repository types one command, `uv sync`. uv reads the lock file and builds an identical environment, with the same packages at the same versions.

In summary, Git tracks `pyproject.toml`, `uv.lock` and `.python-version`, and ignores the `.venv` folder, which belongs in `.gitignore`.

## 9. Anatomy of a good analysis repository

The submissions of this block should follow a recognisable project structure. Four elements deserve emphasis.

**The README is the entry point.** In three sentences, it states what the project does, where the data come from, and the exact commands that reproduce the result. It is written for a stranger, and eight months later that stranger is often the author.

**`pyproject.toml` and `uv.lock` pin each version.** Most "it worked on my machine" problems come from version mismatches. With a lock file, the versions can be checked instead of guessed.

**Notebooks are numbered**, because the order of the steps is part of the method: quality control, then differential expression, then enrichment. Notebooks carry the narrative. Code that is called twice goes into the `src` folder as a function. A helper copied into three notebooks cannot be reviewed.

**`docs/decisions.md` records the choices**, and most students omit it. Each choice that is not obvious receives two lines: what was chosen and why. Examples are the samples excluded and the criterion, or the threshold used and the alternatives tried. Across a whole project this takes about ten minutes, and it provides the material needed for the defence of the work.

## 10. Commits as a lab notebook, releases as citable code

A commit message is an entry in a lab notebook. Compare two messages.

- `update stuff` tells the reader nothing.
- `Filter genes with fewer than 10 counts in fewer than 3 samples`, followed by a body: before, no filter was applied; the filter removes 41 % of the genes; the PCA plot now separates the samples by condition and no longer by batch.

A batch is a group of samples processed together, on the same day or on the same machine. Batch effects are one of the main pitfalls of transcriptomics, and they return in almost each course of this block.

The second message states what changed, what it replaced, and what effect it had. It takes twenty seconds to write. The convention is a short first line in the imperative, a blank line, then the reason.

A last point belongs to Course 7 and is introduced here. A GitHub repository is not an archive: its owner can delete it, rename it or make it private. At publication, the author connects the repository to Zenodo and creates a release. Zenodo stores a permanent copy and assigns it a DOI, so other researchers can cite the code and retrieve it even if the GitHub repository disappears. The operation takes about five minutes. Studies of published papers find repeatedly that code "available on request" is often never provided. With a DOI, readers obtain the code without a request.

## 11. Requirements for the group repository

For this block, the repository of each group must contain:

- a README that allows the analysis to be reproduced;
- `pyproject.toml` and `uv.lock` committed, with the `.venv` folder ignored;
- a `.gitignore` that keeps data and secrets out;
- numbered notebooks;
- a decisions file;
- a history that shows commits from each member of the group;
- an open-source licence (MIT is suitable).

The history is examined: forty commits from one person and two from the others raise a question at the oral examination.

One criterion determines the grade: a stranger can clone the repository, run `uv sync`, and obtain the same numbers. Elegance earns no points.

## 12. Summary and next course

Git records each state of a project as a commit; branches and pull requests organise collaborative work; `.gitignore` keeps data, secrets and regenerable files out; and uv, with `pyproject.toml` and `uv.lock`, makes the environment reproducible.

Before the next session, each student creates a personal branch in the group repository and installs uv before the first practical. Nobody merges their own pull request.

Course 4 brings the two halves of the class together and shows how a molecule in a cell becomes an integer in a table. It is compulsory for all students.
