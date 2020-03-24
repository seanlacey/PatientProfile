#Load Helpers
source("helpers.R",local=TRUE)

###Load DashPage Options
source("sidebar.R",local=TRUE)
source("controlbar.R",local=TRUE)

# UI Call -----------------------------------------------------------------
ui <- bs4DashPage(navbar=bs4DashNavbar(textOutput("nav_subj"),
                                       rightUi=textOutput("nav_help"),
                                       controlbarIcon="user-circle"),
                  sidebar=sidebar,
                  controlbar=controlbar,
                  body = bs4DashBody(tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "profile_style.css")),
                                     ###Initialize shinyjs
                                     useShinyjs(),
                                     
                                     bs4TabItems(
                                       about_tab,
                                       header_tab,
                                       dose_tab,
                                       ae_tab
                                     )),
                  footer = bs4DashFooter(textOutput("foot_date")),
                  
                  title="Patient Profiles",
                  sidebar_collapsed=TRUE)

# Server Call -------------------------------------------------------------
server <- function(input, output, session) {
  
  # Filter for Subjid -------------------------------------------------------
  observe({
    if(input$cohort!="All"){
      selectVec <- c("Select Subject...",unname(as_vector(pdata[["subjects"]][pdata[["subjects"]][,"cohort"]==input$cohort,"subjid"])))
    }else{
      selectVec <- c("Select Subject...",unname(as_vector(pdata[["subjects"]][,"subjid"])))    
    }
    
    updatePickerInput(session,"subjid",choices=selectVec)
  })
  
  subj <- reactive({input$subjid}) 
  
  output$nav_subj <- renderText({
    if(!is.null(input$subjid)){
      if(input$subjid != "Select Subject..."){
        paste("Subject:",input$subjid,sep=" ")
      } else{
        "Subject: Unselected"
      }
    }
  })
  
  output$nav_help <- renderText({
    "Click icon to select subject"
  })
  
  output$foot_date <- renderText({
    paste("Data Creation Date:",pdata[["datadate"]],sep=" ")
  })
  
  # Header: Subject Information ---------------------------------------------
  output$card_subj <- headdata(subj=subj,
                               ds=pdata,
                               lbl=c("Subject ID","Screening ID","Site Name"),
                               varvec=c("subjid","scrnid","sitename"))
  
  # Header: Demographics ---------------------------------------------
  output$card_demo <- headdata(subj=subj,
                               ds=pdata,
                               lbl=c("Age/Gender/Race","Height BL(cm)","Weight BL(kg)","Smoker"),
                               varvec=c("asr","height","weight","smoke"))
  
  # Header: Dosing ---------------------------------------------
  output$card_dose <- headdata(subj=subj,
                               ds=pdata,
                               lbl=c("Planned Dose","First Dose Date","Last Dose Date"),
                               varvec=c("pdose","exstdtc","exendtc"))
  
  # Header: EOT ---------------------------------------------
  output$card_eot <- headdata(subj=subj,
                              ds=pdata,
                              lbl=c("Treatment Status","EOT Date","EOT Reason"),
                              varvec=c("tstatus","eotdtc","eotreas"))
  
  # Dosing --------------------------------------------------------
  callModule(DTModule,"dose",subj=subj,dset=pdata,dname="dose",
             vlist=c("cycle","date","dose"),
             vname=c("Cycle","Date","Dose"),
             order=list(list(0, 'asc')))
  
  # Adverse Events ------------------------------------------------
  callModule(DTModule,"ae",subj=subj,dset=pdata,dname="ae",
             vlist=c("aeid","aename","aedate","related","grade"),
             vname=c("ID","Preferred Term",
                     "Start Date<br>End Date","Relatedness",
                     "Grade"),
             lab=TRUE,
             columnDefs=list(list(width="15%",targets=c(2))),
             order = list(list(0, 'asc')))
}

# Run the application 
shinyApp(ui = ui, server = server)

