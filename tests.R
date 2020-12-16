
library(TSDtools)


DataDir <- '/home/maximilien.chaumon/ownCloud/Lab/00-Projects/TimeSocialDistancing/DATA/data_exp_201215'

d <- gimmedata(DataDir,ExperimentName = 'IT', verbose = T)


ddd <- d %>% group_by(`Participant Private ID`, UniqueName, Run, Session) %>%
  arrange(`Participant Private ID`,UniqueName,Session,Run) %>%
  summarize(start = first(`UTC Date`),stop = last(`UTC Date`))

ggplot(ddd,aes(x=start,xend=stop,y=`Participant Private ID`,yend = `Participant Private ID`, col = UniqueName)) +
  geom_segment(size=2)


