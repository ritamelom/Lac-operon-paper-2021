library(qiime2R)
library(phyloseq)
library(ggplot2)
library(vegan)
phy<-qza_to_phyloseq(features="/path-to-file/filtered-table-without-Y11.qza", metadata="/path-to-file/metadata.tsv", taxonomy="/path-to-file/taxonomy-gg.qza", tree="path-to-file/rooted-tree-without-Y11.qza", tmp="C:/tmp")
head(sample_data(phy))
phy
phy_scaled <- rarefy_even_depth(phy,sample.size=6468, replace=FALSE, rngseed = 1)
phy_pcoa_bray <- ordinate(
  physeq = phy_scaled, 
  method = "NMDS", 
  distance = "bray"
)
phy_pcoa_wu <- ordinate(
  physeq = phy_scaled, 
  method = "NMDS", 
  distance = "wunifrac"
)

plot_ordination(phy_scaled,phy_pcoa_bray, type="samples", color="subgroup") + 
  geom_point(size = 2) + 
  coord_fixed(ratio = 1) +
  scale_color_manual(values =c("deepskyblue3", "cadetblue3", "green4", "darkolivegreen3")) +
  stat_ellipse(aes(group = subgroup), linetype = 2)+
  theme_classic()

phyloseq::plot_ordination(phy_scaled,phy_pcoa_wu, type="samples", color="subgroup") + 
  geom_point(size = 2) +
  coord_fixed(ratio = 1) +
  scale_color_manual(values =c("dodgerblue3", "cadetblue3", "green4", "darkolivegreen3")) +
  stat_ellipse(aes(group = subgroup), linetype = 2)+
  theme_classic()

phy_group <- get_variable(phy_scaled, "subgroup")
anosim_wu <- anosim(distance(phy_scaled, "unifrac", weighted=TRUE), phy_group, permutations = 999)
print(anosim_wu)
anosim_bray <- anosim(distance(phy_scaled, "bray"), phy_group, permutations = 999)
print(anosim_bray)
