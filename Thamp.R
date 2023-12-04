
library(lmerTest)
library(lme4)
library(tidyverse)

#thampdata <- read.csv('~/Documents/MINDlab/ThampData.csv')
#thampdata <- read.table('ThampData')
which(is.na(ThampData_headphonecheck.copy)==T)
ThampData2 <- ThampData2[complete.cases(ThampData_headphonecheck.copy),]

#VALENCE
v.model = lmer(valence ~ mod +
                 (1 | subject) + (1 | song),
               data = ThampData_headphonecheck.copy)
summary(v.model)

#AROUSAL
a.model = lmer(arousal ~ mod +
                 (1 | subject) + (1 | song),
               data = ThampData_headphonecheck.copy)
summary(a.model)

# #ttest
# sub_removed <- subset(ThampData, subject != "610f188b8ad0a93f6d508cad")
# mod <- subset(sub_removed, mod=="mod")
# unmod <-  subset(sub_removed, mod=="unmod")
# cor.test(mod$arousal, unmod$arousal, paired=TRUE)
# sd(unmod$arousal)
# table(mod$subject)

#avg arousal for all songs
ggplot(data=ThampData_headphonecheck.copy, aes(x=mod, y=arousal))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'pointrange')

#avg for individual songs arousal
ggplot(data=ThampData_headphonecheck.copy, aes(x=factor(song), y=arousal, color=mod))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'point') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + xlab("Song")

#avg for individual songs arousal SORTED 
ggplot(data=ThampData_headphonecheck.copy, aes(x=reorder(factor(song),arousal,mean), y=arousal, color=mod))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'point') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + xlab("Song") +theme_bw()

#avg valence for all songs
ggplot(data=ThampData_headphonecheck.copy, aes(x=mod, y=valence))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'pointrange')

#avg for individual songs valence
ggplot(data=ThampData_headphonecheck.copy, aes(x=factor(song), y=valence, color=mod))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'point') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + xlab("Song")

#avg for individual songs valence SORTED 
ggplot(data=ThampData_headphonecheck.copy, aes(x=reorder(factor(song),valence,mean), y=valence, color=mod))+
  stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) +
  stat_summary(fun.data = 'mean_cl_normal', geom = 'point') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + xlab("Song") + theme_bw()

#PLOTTING VALENCE VS AROUSAL
#lower = 
#upper = 
#geom_errorbarh(data=ThampData_headphonecheck.copy, mapping=aes(y=valence,x=arousal,xmin=lower,xmax=upper))

ggplot(data=ThampData_headphonecheck.copy, aes(x=arousal, y=valence, color=mod))+
       stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2,alpha = 0.5) +
         stat_summary(fun.data = 'mean_cl_normal', geom = 'point',alpha = 0.5) + 
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + ylim(-50,50) 
  + geom_text(label=rownames(song))
    +geom_errorbarh(aes(xmin=,xmax=upper))


##
#repeat with musical exp as IV
 v2.model = lmer(valence ~ mod*BMRQ_total_scaled +
                  (1 | subject) + (1 | song),
                data = ThampData_headphonecheck.copy,
                REML = FALSE)
 summary(v2.model)
 
 a2.model = lmer(arousal ~ mod*BMRQ_total_scaled +
                  (1 | subject) + (1 | song),
                data = ThampData_headphonecheck.copy,
                REML = FALSE)
 summary(a2.model)


