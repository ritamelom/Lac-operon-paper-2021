---


---

<h2 id="data-import">Data Import</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime tools <span class="token function">import</span> \
  --type <span class="token string">'SampleData[PairedEndSequencesWithQuality]'</span> \
  --input-path pe-33-manifest \
  --output-path paired-end-demux.qza \
  --input-format PairedEndFastqManifestPhred33

qiime tools validate paired-end-demux.qza
</code></pre>
<h2 id="quality-filtering">Quality Filtering</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime vsearch join-pairs \
 --p-allowmergestagger \
  --i-demultiplexed-seqs paired-end-demux.qza \
  --o-joined-sequences demux-joined.qza
qiime demux summarize \
  --i-data demux-joined.qza \
  --o-visualization demux-joined.qzv

qiime quality-filter q-score \
  --i-demux demux-joined.qza \
  --o-filtered-sequences demux-joined-filtered.qza \
  --o-filter-stats demux-joined-filter-stats.qza
</code></pre>
<h2 id="denoising-with-deblur">Denoising with Deblur</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime deblur denoise-16S \
  --i-demultiplexed-seqs demux-joined-filtered.qza \
  --p-trim-length 250 \
  --p-sample-stats \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-stats deblur-stats.qza

qiime deblur visualize-stats \
  --i-deblur-stats deblur-stats.qza \
  --o-visualization deblur-stats.qzv

qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv
</code></pre>
<h2 id="asv-table-generation">ASV Table Generation</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime feature-table relative-frequency \
  --i-table table.qza \
  --o-relative-frequency-table collapsed-frequency-filtered-table-ASV-without-decontam.qza 

qiime tools <span class="token function">export</span> \
  --input-path collapsed-frequency-filtered-table-ASV-without-decontam.qza \
  --output-path exported-filtered-rel-table-ASV-without-decontam

<span class="token function">cd</span> exported-filtered-rel-table-ASV-without-decontam

biom convert -i feature-table.biom -o otu_table_rel_asv-wo_decontam.tsv --to-tsv --header-key taxonomy
</code></pre>
<h1 id="alpha-and-beta-diversity">Alpha and beta diversity</h1>
<pre class=" language-bash"><code class="prism  language-bash">qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 30000 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha-rarefaction.qzv

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 6468 \
  --m-metadata-file metadata.tsv \
  --output-dir core-metrics-results

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/weighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/unweighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/jaccard-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/bray-curtis-subgroup-significance.qzv \
  --p-pairwise
</code></pre>
<h2 id="filter-sequences-per-timepoint">Filter sequences per timepoint</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime feature-table filter-samples \
  --i-table table.qza \
  --m-metadata-file metadata.tsv \
  --p-where <span class="token string">"[before_or_after_str] IN ('after')"</span> \
  --o-filtered-table filtered-table-after_str.qza

qiime feature-table filter-seqs \
 --i-data rep-seqs.qza \
 --i-table filtered-table-after_str.qza \
 --o-filtered-data filtered-rep-seqs-after_str.qza

qiime feature-table summarize \
  --i-table filtered-table-after_str.qza \
  --o-visualization filtered-table-after_str.qzv \
  --m-sample-metadata-file metadata.tsv
</code></pre>
<h2 id="beta-diversity">Beta diversity</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences filtered-rep-seqs-after_str.qza \
  --o-alignment aligned-rep-seqs-after_str.qza \
  --o-masked-alignment masked-aligned-rep-seqs-after_str.qza \
  --o-tree unrooted-tree-after_str.qza \
  --o-rooted-tree rooted-tree-after_str.qza

qiime diversity alpha-rarefaction \
  --i-table filtered-table-after_str.qza \
  --i-phylogeny rooted-tree-after_str.qza \
  --p-max-depth 30000 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha-rarefaction-after_str.qzv

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree-after_str.qza \
  --i-table filtered-table-after_str.qza \
  --p-sampling-depth 6468 \
  --m-metadata-file metadata.tsv \
  --output-dir core-metrics-results

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/weighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/unweighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/jaccard-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/bray-curtis-subgroup-significance.qzv \
  --p-pairwise
</code></pre>
<h2 id="exclude-sample-y11">Exclude sample Y11</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime feature-table filter-samples \
  --i-table table.qza \
  --m-metadata-file metadata.tsv \
  --p-where <span class="token string">"NOT [mouse-name]='Y11'"</span> \
  --o-filtered-table filtered-table-without-Y11.qza

qiime feature-table filter-seqs \
 --i-data rep-seqs.qza \
 --i-table filtered-table-without-Y11.qza \
 --o-filtered-data filtered-rep-seqs-without-Y11.qza

qiime feature-table summarize \
  --i-table filtered-table-without-Y11.qza \
  --o-visualization filtered-table-without-Y11.qzv \
  --m-sample-metadata-file metadata.tsv
</code></pre>
<h2 id="alpha-and-beta-diversity-no-y11">Alpha and Beta diversity (no Y11)</h2>
<pre class=" language-bash"><code class="prism  language-bash">qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences filtered-rep-seqs-without-Y11.qza \
  --o-alignment aligned-rep-seqs-without-Y11.qza \
  --o-masked-alignment masked-aligned-rep-seqs-without-Y11.qza \
  --o-tree unrooted-tree-without-Y11.qza \
  --o-rooted-tree rooted-tree-without-Y11.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree-without-Y11.qza \
  --i-table filtered-table-without-Y11.qza \
  --p-sampling-depth 6468 \
  --m-metadata-file metadata.tsv \
  --output-dir core-metrics-results

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/weighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/unweighted-unifrac-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/jaccard-subgroup-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column subgroup \
  --o-visualization core-metrics-results/bray-curtis-subgroup-significance.qzv \
  --p-pairwise

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/shannon_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/shannon-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/faith-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/observed_features_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/observed_features-group-significance.qzv
</code></pre>

