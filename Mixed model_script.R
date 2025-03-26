#Mixed Model#

# Average_total_loads_E_coli_per_treatment_ANOVA (fig 1)

data1=Average_total_loads_E_coli_per_treatment_ANOVA
library(lme4)
model1 <- lmer(loads ~ group * day + (1|id), data = Average_total_loads_E_coli_per_treatment_ANOVA)
summary(model1)

library(car)
LME1=Anova(model1, test.statistic = "F", type = "III")
LME1

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model1)

# Residuals
res1=residuals(model1)
mean(res1)

#Normality
qqnorm(res1, datax = TRUE)
qqline(res1, datax = TRUE)


#Contrasts
library(gmodels)
library(lsmeans)

# Means
means.int1 <- lsmeans(model1, specs = c("group", "day"))
means.int1



# If you want to select the comparisons
ref1<-lsmeans(model1,c("group","day")) 
ref1 #check the combination of factors for contrasts

library(xlsx)
write.xlsx(ref1, file = "comparison_selection_average_loads_per_treatment.xlsx", sheetName = "Folha1", 
           col.names = TRUE, row.names = TRUE, append = FALSE)

ContrastVec <- list(d1_1=c(1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d1_2=c(1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d1_3=c(1,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d1_4=c(0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d1_5=c(0,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d1_6=c(0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_1=c(0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_2=c(0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_3=c(0,0,0,0,1,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_4=c(0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_5=c(0,0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d2_6=c(0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d3_1=c(0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),d3_2=c(0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0),d3_3=c(0,0,0,0,0,0,0,0,1,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0),d3_4=c(0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0),d3_5=c(0,0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0),d3_6=c(0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0),d4_1=c(0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0),d4_2=c(0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0,0),d4_3=c(0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,-1,0,0,0,0,0,0,0,0),d4_4=c(0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0,0),d4_5=c(0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0,0,0,0,0),d4_6=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,0),d5_1=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0),d5_2=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0,0),d5_3=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,-1,0,0,0,0),d5_4=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0,0),d5_5=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1,0,0,0,0),d5_6=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0,0,0),d6_1=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0,0),d6_2=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1,0),d6_3=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,-1),d6_4=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,0),d6_5=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,-1),d6_6=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1))
summary(contrast(ref1, ContrastVec), adjust = "bonferroni")



#########################


# Total_loads_E_coli_ANOVA (fig. S1 A)

data2=Total_loads_E_coli_ANOVA
library(lme4)
model2 <- lmer(loads ~ group * day + (1|id), data = Total_loads_E_coli_ANOVA)
summary(model2)

library(car)
LME2=Anova(model2, test.statistic = "F", type = "III")
LME2

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model2)

# Residuals
res2=residuals(model2)
mean(res2)

#Normality
qqnorm(res2, datax = TRUE)
qqline(res2, datax = TRUE)

##################################

# Total_loads_E_coli_Lactobacillus_ANOVA (Fig S1 B)

data3=Total_loads_E_coli_Lactobacillus_ANOVA
library(lme4)
model3 <- lmer(loads ~ group * day + (1|id), data = data3)
summary(model3)

library(car)
LME3=Anova(model3, test.statistic = "F", type = "III")
LME3

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model3)

# Residuals
res3=residuals(model3)
mean(res3)

#Normality
qqnorm(res3, datax = TRUE)
qqline(res3, datax = TRUE)


##################################

# Total_loads_E_coli_Lactobacillus_Btheta_ANOVA (Fig S1 C)

data4=Total_loads_E_coli_Lactobacillus_Btheta_ANOVA
library(lme4)
model4 <- lmer(loads ~ group * day + (1|id), data = data4)
summary(model4)

library(car)
LME4=Anova(model4, test.statistic = "F", type = "III")
LME4

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model4)

# Residuals
res4=residuals(model4)
mean(res4)

#Normality
qqnorm(res4, datax = TRUE)
qqline(res4, datax = TRUE)


# If you want to select the comparisons
ref4<-lsmeans(model4,c("group","day")) 
ref4 #check the combination of factors for contrasts

library(xlsx)
write.xlsx(ref4, file = "comparison_selection_average_loads_per_treatment.xlsx", sheetName = "Folha1", 
           col.names = TRUE, row.names = TRUE, append = FALSE)

# THIS IS NOT COMPLETE YET
ContrastVec <- list(c1=c(1,0,-1,0,0,0,0,0),c2=c(1,0,0,0,-1,0,0,0),c3=c(1,0,0,0,0,0,-1,0),c4=c(0,0,0,0,0,0,0,0)) # complete this
summary(contrast(ref1, ContrastVec), adjust = "bonferroni")


##################################

# Total_loads_E_coli_SPF_ANOVA (Fig S1 D)

data5=Total_loads_E_coli_SPF_ANOVA
library(lme4)
model5 <- lmer(loads ~ group * day + (1|id), data = data5)
summary(model5)

library(car)
LME5=Anova(model5, test.statistic = "F", type = "III")
LME5

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model5)

# Residuals
res5=residuals(model5)
mean(res5)

#Normality
qqnorm(res5, datax = TRUE)
qqline(res5, datax = TRUE)


############### FREQUENCY OF LAC+ - GERM-FREE (Fig 2 A)

#freq_lac_GF

data6=freq_lac_GF
library(lme4)
model6 <- lmer(freq ~ group * day + (1|id), data = data6)
summary(model6)

library(car)
LME6=Anova(model6, test.statistic = "F", type = "III")
LME6

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model6)

# Residuals
res6=residuals(model6)
mean(res6)

#Normality
qqnorm(res6, datax = TRUE)
qqline(res6, datax = TRUE)

############### FREQUENCY OF LAC+ - + Latobacillus (Fig 2 B)

#freq_lac_Lb

data7=freq_lac_Lb
library(lme4)
model7 <- lmer(freq ~ group * day + (1|id), data = data7)
summary(model7)

library(car)
LME7=Anova(model7, test.statistic = "F", type = "III")
LME7

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model7)

# Residuals
res7=residuals(model7)
mean(res7)

#Normality
qqnorm(res7, datax = TRUE)
qqline(res7, datax = TRUE)



############### FREQUENCY OF LAC+ - + Latobacillus + B theta (Fig 2 C)

#freq_lac_Lb_Btheta

data8=freq_lac_Lb_Btheta
library(lme4)
model8 <- lmer(freq ~ group * day + (1|id), data = data8)
summary(model8)

library(car)
LME8=Anova(model8, test.statistic = "F", type = "III")
LME8

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model8)

# Residuals
res8=residuals(model8)
mean(res8)

#Normality
qqnorm(res8, datax = TRUE)
qqline(res8, datax = TRUE)


library(emmeans)

# If you want to select the comparisons
ref8<-lsmeans(model8,c("group","day")) 
ref8 #check the combination of factors for contrasts

library(xlsx)
write.xlsx(ref8, file = "comparison_selection_freq_lac_Lb_Btheta.xlsx", sheetName = "Folha1", 
           col.names = TRUE, row.names = TRUE, append = FALSE)

ContrastVec <- list(d0=c(1,-1,0,0,0,0,0,0,0,0),d1=c(0,0,1,-1,0,0,0,0,0,0),d2=c(0,0,0,0,1,-1,0,0,0,0),d3=c(0,0,0,0,0,0,1,-1,0,0),d6=c(0,0,0,0,0,0,0,0,1,-1))
summary(contrast(ref8, ContrastVec), adjust = "bonferroni")



############### FREQUENCY OF LAC+ - + SPF (Fig 2 D)

#freq_lac_SPF

data9=freq_lac_SPF
library(lme4)
model9 <- lmer(freq ~ group * day + (1|id), data = data9)
summary(model9)

library(car)
LME9=Anova(model9, test.statistic = "F", type = "III")
LME9

##### Model quality #####
library(MuMIn)
r.squaredGLMM(model9)

# Residuals
res9=residuals(model9)
mean(res9)

#Normality
qqnorm(res9, datax = TRUE)
qqline(res9, datax = TRUE)


library(emmeans)

# If you want to select the comparisons
ref9<-lsmeans(model9,c("group","day")) 
ref9 #check the combination of factors for contrasts

library(xlsx)
write.xlsx(ref9, file = "comparison_selection_freq_lac_SPF.xlsx", sheetName = "Folha1", 
           col.names = TRUE, row.names = TRUE, append = FALSE)

ContrastVec <- list(d0=c(1,-1,0,0,0,0,0,0,0,0,0,0,0,0),d1=c(0,0,1,-1,0,0,0,0,0,0,0,0,0,0),d2=c(0,0,0,0,1,-1,0,0,0,0,0,0,0,0),d3=c(0,0,0,0,0,0,1,-1,0,0,0,0,0,0),d4=c(0,0,0,0,0,0,0,0,1,-1,0,0,0,0),d5=c(0,0,0,0,0,0,0,0,0,0,1,-1,0,0),d6=c(0,0,0,0,0,0,0,0,0,0,0,0,1,-1))
summary(contrast(ref9, ContrastVec), adjust = "bonferroni")
