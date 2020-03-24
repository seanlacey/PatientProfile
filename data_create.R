library(tidyverse)

subjlist <- c("TRL001","TRL002","TRL003","TRL004","TRL005")
cohlist <- c("Placebo","Fauximab","Fauximab","Placebo","Fauximab")

subjects <- tibble(subjid=subjlist,
                   cohort=cohlist)

datadate <- "2020-03-22"

subject1 <- list(header=tibble(subjid="TRL-001",
                                 scrnid="SCR001",
                                 sitename="Site 1",
                                 asr="50/M/White",
                                 height=160,
                                 weight=62,
                                 smoke="Y",
                                 pdose="Placebo",
                                 exstdtc="2019-03-22",
                                 exendtc="2019-05-16",
                                 tstatus="OFF TREATMENT",
                                 eotdtc="2019-05-16",
                                 eotreas="Completed"),
                 dose=tibble(cycle=c(1,2,3),
                             date=c("2019-03-22","2019-04-15","2019-05-16"),
                             dose=c("1mg","1mg","1mg")),
                 ae=tibble(aeid=c(1,2,3,4),
                           aename=c("Nausea","Rash","Anaemia","Nausea"),
                           aedate=c("2019-03-23/<br>2019-03-24",
                                    "2019-04-06/<br>2019-04-12",
                                    "2019-04-06/<br>2019-05-16",
                                    "2019-04-15/<br>2019-04-16"),
                           related=c("Likely Related","Not Related","Related","Possibly Related"),
                           grade=c("Grade 1","Grade 2","Grade 1","Grade 1"))
                 )

subject2 <- list(header=tibble(subjid="TRL-002",
                                 scrnid="SCR002",
                                 sitename="Site 1",
                                 asr="28/F/White",
                                 height=159,
                                 weight=67,
                                 smoke="N",
                                 pdose="Fauximab",
                                 exstdtc="2019-04-06",
                                 exendtc="2019-06-04",
                                 tstatus="OFF TREATMENT",
                                 eotdtc="2019-06-04",
                                 eotreas="Completed"),
                 dose=tibble(cycle=c(1,2,3),
                             date=c("2019-04-06","2019-05-10","2019-06-04"),
                             dose=c("1mg","1mg","1mg")),
                 ae=tibble(aeid=c(1,2,3),
                           aename=c("Nausea","Diarrhoea","Nausea"),
                           aedate=c("2019-04-12/<br>2019-04-13",
                                    "2019-05-10/<br>2019-05-12",
                                    "2019-05-10/<br>2019-05-12"),
                           related=c("Likely Related","Related","Related"),
                           grade=c("Grade 1","Grade 1","Grade 1"))
                 )

subject3 <- list(header=tibble(subjid="TRL-003",
                                 scrnid="SCR003",
                                 sitename="Site 2",
                                 asr="67/M/African American",
                                 height=168,
                                 weight=70,
                                 smoke="N",
                                 pdose="Fauximab",
                                 exstdtc="2018-12-07",
                                 exendtc="2019-03-10",
                                 tstatus="OFF TREATMENT",
                                 eotdtc="2019-03-10",
                                 eotreas="Adverse Event"),
                 dose=tibble(cycle=c(1,2,3),
                             date=c("2018-12-07","2019-01-29","2019-03-10"),
                             dose=c("1mg","1mg","1mg")),
                 ae=tibble(aeid=c(1,2,3,4),
                           aename=c("Nausea","Hypertension","Nausea","Nausea"),
                           aedate=c("2018-12-07/<br>2018-12-08",
                                    "2019-01-10/<br>2019-03-01",
                                    "2019-01-29/<br>2019-01-30",
                                    "2019-03-10/<br>2019-03-10"),
                           related=c("Related","Not Related","Related","Related"),
                           grade=c("Grade 1","Grade 1","Grade 2","Grade 3"))
                 )

subject4 <- list(header=tibble(subjid="TRL-004",
                                 scrnid="SCR004",
                                 sitename="Site 2",
                                 asr="43/F/Asian",
                                 height=158,
                                 weight=59,
                                 smoke="N",
                                 pdose="Placebo",
                                 exstdtc="2019-02-12",
                                 exendtc="2019-05-15",
                                 tstatus="OFF TREATMENT",
                                 eotdtc="2019-05-15",
                                 eotreas="Subject Withdrawal"),
                 dose=tibble(cycle=c(1,2,3),
                             date=c("2019-02-12","2019-03-31","2019-05-15"),
                             dose=c("1mg","1mg","1mg")),
                 ae=tibble(aeid=c(1,2,3,4),
                           aename=c("Nausea","Diarrhoea","Nausea","Nausea"),
                           aedate=c("2019-02-12/<br>2019-02-13",
                                    "2019-03-31/<br>2019-04-01",
                                    "2019-03-31/<br>2019-04-01",
                                    "2019-05-15/<br>2019-05-15"),
                           related=c("Related","Likely Related","Related","Related"),
                           grade=c("Grade 1","Grade 1","Grade 1","Grade 2"))
)

subject5 <- list(header=tibble(subjid="TRL-005",
                                 scrnid="SCR005",
                                 sitename="Site 3",
                                 asr="50/M/Asian",
                                 height=162,
                                 weight=63,
                                 smoke="Y",
                                 pdose="Fauximab",
                                 exstdtc="2019-03-03",
                                 exendtc="2019-06-03",
                                 tstatus="OFF TREATMENT",
                                 eotdtc="2019-06-03",
                                 eotreas="Completed"),
                 dose=tibble(cycle=c(1,2,3),
                             date=c("2019-03-03","2019-04-30","2019-06-03"),
                             dose=c("1mg","1mg","1mg")),
                 ae=tibble(aeid=c(1,2,3),
                           aename=c("Nausea","Diarrhoea","Nausea"),
                           aedate=c("2019-03-03/<br>2019-03-03",
                                    "2019-03-03/<br>2019-03-04",
                                    "2019-06-03/<br>2019-06-03"),
                           related=c("Related","Likely Related","Related"),
                           grade=c("Grade 2","Grade 1","Grade 1"))
)

tmpdata=list("TRL001"=subject1,
             "TRL002"=subject2,
             "TRL003"=subject3,
             "TRL004"=subject4,
             "TRL005"=subject5,
             "subjects"=subjects,
             "datadate"=datadate)

pdata <- tmpdata


c("Select Subject...",pull(pdata[["subjects"]],"subjid"))

saveRDS(tmpdata,file="C:/Users/seanm/OneDrive/Documents/profile_dummy/data/profile_data.rds")
