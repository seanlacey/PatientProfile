controlbar <- 
  bs4DashControlbar(br(),br(),br(),
                    pickerInput("subjid","Select Subject:",
                                choices=c("Select Subject...",pull(pdata[["subjects"]],"subjid")), 
                                options = list(size = 10),
                                multiple=FALSE),
                    hr(),
                    p(h4("Filters")),
                    pickerInput("cohort", "Select Cohort:",
                                choices=c("All",unname(as_vector(unique(pdata[["subjects"]][,"cohort"])))),
                                options = list(size = 10),
                                multiple=FALSE),
                    skin="light")