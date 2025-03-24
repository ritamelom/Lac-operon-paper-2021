---


---

<h1 id="microbiota-analysis-pipeline">Microbiota Analysis Pipeline</h1>
<p>This repository contains the microbiota analysis pipeline used in the study “The Selective Advantage of the lac Operon for Escherichia coli Is Conditional on Diet and Microbiota Composition” published in Frontiers in Microbiology (<a href="https://doi.org/10.3389/fmicb.2021.709259">https://doi.org/10.3389/fmicb.2021.709259</a>). The pipeline processes and analyzes 16S rRNA sequencing data using QIIME2.</p>
<h2 id="requirements">Requirements</h2>
<ul>
<li>
<p>QIIME2 (version used in the study: 2020.8)</p>
</li>
<li>
<p>Conda (for environment management)</p>
</li>
<li>
<p>Python (required for QIIME2)</p>
</li>
<li>
<p>FASTQ files (paired-end reads from Illumina sequencing)</p>
</li>
</ul>
<h2 id="data-and-files">Data and Files</h2>
<ul>
<li>
<p>Input: Demultiplexed paired-end FASTQ files</p>
</li>
<li>
<p>Metadata File: A TSV file with sample information (e.g., groups, conditions)</p>
</li>
<li>
<p>Outputs: Diversity metrics</p>
</li>
</ul>
<h2 id="pipeline-workflow">Pipeline Workflow</h2>
<ol>
<li>Set up the environment</li>
</ol>
<pre class=" language-bash"><code class="prism  language-bash">module load conda
module load qiime2
</code></pre>
<ol start="2">
<li>Import raw sequencing data</li>
</ol>
<pre class=" language-python"><code class="prism  language-python">qiime tools <span class="token keyword">import</span> \
  <span class="token operator">-</span><span class="token operator">-</span><span class="token builtin">type</span> <span class="token string">'SampleData[PairedEndSequencesWithQuality]'</span> \
  <span class="token operator">-</span><span class="token operator">-</span><span class="token builtin">input</span><span class="token operator">-</span>path pe<span class="token number">-33</span><span class="token operator">-</span>manifest \
  <span class="token operator">-</span><span class="token operator">-</span>output<span class="token operator">-</span>path paired<span class="token operator">-</span>end<span class="token operator">-</span>demux<span class="token punctuation">.</span>qza \
  <span class="token operator">-</span><span class="token operator">-</span><span class="token builtin">input</span><span class="token operator">-</span><span class="token builtin">format</span> PairedEndFastqManifestPhred33

qiime tools validate paired<span class="token operator">-</span>end<span class="token operator">-</span>demux<span class="token punctuation">.</span>qza
</code></pre>
<ol start="3">
<li>Quality filtering and denoising (deblur)</li>
</ol>
<pre class=" language-python"><code class="prism  language-python">qiime deblur denoise<span class="token operator">-</span>16S \
  <span class="token operator">-</span><span class="token operator">-</span>i<span class="token operator">-</span>demultiplexed<span class="token operator">-</span>seqs demux<span class="token operator">-</span>joined<span class="token operator">-</span>filtered<span class="token punctuation">.</span>qza \
  <span class="token operator">-</span><span class="token operator">-</span>p<span class="token operator">-</span>trim<span class="token operator">-</span>length <span class="token number">250</span> \
  <span class="token operator">-</span><span class="token operator">-</span>p<span class="token operator">-</span>sample<span class="token operator">-</span>stats \
  <span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>representative<span class="token operator">-</span>sequences rep<span class="token operator">-</span>seqs<span class="token punctuation">.</span>qza \
  <span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>table table<span class="token punctuation">.</span>qza \
  <span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>stats deblur<span class="token operator">-</span>stats<span class="token punctuation">.</span>qza

qiime deblur visualize<span class="token operator">-</span>stats \
  <span class="token operator">-</span><span class="token operator">-</span>i<span class="token operator">-</span>deblur<span class="token operator">-</span>stats deblur<span class="token operator">-</span>stats<span class="token punctuation">.</span>qza \
  <span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>visualization deblur<span class="token operator">-</span>stats<span class="token punctuation">.</span>qzv
</code></pre>
<ol start="4">
<li>Diversity Analysis</li>
</ol>
<pre class=" language-python"><code class="prism  language-python">qiime diversity core<span class="token operator">-</span>metrics<span class="token operator">-</span>phylogenetic <span class="token operator">-</span><span class="token operator">-</span>i<span class="token operator">-</span>table table<span class="token punctuation">.</span>qza \
<span class="token operator">-</span><span class="token operator">-</span>i<span class="token operator">-</span>phylogeny rooted<span class="token operator">-</span>tree<span class="token punctuation">.</span>qza <span class="token operator">-</span><span class="token operator">-</span>m<span class="token operator">-</span>metadata<span class="token operator">-</span><span class="token builtin">file</span> metadata<span class="token punctuation">.</span>tsv \
<span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>rarefied<span class="token operator">-</span>table rarefied<span class="token operator">-</span>table<span class="token punctuation">.</span>qza <span class="token operator">-</span><span class="token operator">-</span>p<span class="token operator">-</span>sampling<span class="token operator">-</span>depth <span class="token punctuation">[</span>depth<span class="token punctuation">]</span> \
<span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>jaccard<span class="token operator">-</span>distance<span class="token operator">-</span>matrix jaccard<span class="token operator">-</span>dm<span class="token punctuation">.</span>qza \
<span class="token operator">-</span><span class="token operator">-</span>o<span class="token operator">-</span>unweighted<span class="token operator">-</span>unifrac<span class="token operator">-</span>distance<span class="token operator">-</span>matrix unweighted<span class="token operator">-</span>unifrac<span class="token operator">-</span>dm<span class="token punctuation">.</span>qza
</code></pre>
<h2 id="outputs">Outputs</h2>
<ul>
<li>
<p>Feature table: table.qza</p>
</li>
<li>
<p>Representative sequences: rep-seqs.qza</p>
</li>
<li>
<p>Diversity metrics: alpha diversity values and beta diversity distance matrices</p>
</li>
</ul>
<h2 id="source">Source</h2>
<p>This analysis was performed by Rita Melo-Miranda and results in the data presented in:<br>
Pinto C, Melo-Miranda R, Gordo I and Sousa A (2021) The Selective Advantage of the lac Operon for Escherichia coli Is Conditional on Diet and Microbiota Composition. Front. Microbiol. 12:709259.</p>

