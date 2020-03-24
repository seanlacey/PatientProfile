library(shiny)
library(shinyWidgets)
library(bs4Dash)
library(fontawesome)
library(DT)
library(tidyverse)
library(shinyjs)

#Load Mods
source("mods/DTModule.R")

#Load Data
pdata <- readRDS(file="data/profile_data.rds") #For Windows Version

# Data Retrieving Function ------------------------------------------------
dsget <- function(id,ds,var=NULL,dsin=pdata){
  if(is.null(var)){
    dsin[[id]][[ds]] 
  } else{
    dsin[[id]][[ds]][,var]
  }
}

# Date Conversion Function ------------------------------------------------
#Takes day and an anchor date (which = day 1) and converts to a date
date9conv <- function(day,anchor){
  if(day < 1){
    as.character(toupper(format(as.Date.numeric(day,origin=strptime(anchor,"%d%b%Y")),"%d%b%Y")))
  } else{
    as.character(toupper(format(as.Date.numeric(day-1,origin=strptime(anchor,"%d%b%Y")),"%d%b%Y")))
  }
}

#About Tab -------------------------------------------------------------
about_tab <- bs4TabItem(
  tabName = "about",
  bs4Card(fluidRow(h6("Welcome to the Patient Profiles.")),
          br(),
          fluidRow(h6(tags$b("First time here?")," Click on the following to learn how to navigate the profiles.")),
          br(),
          bs4Accordion(
            id="sidenav",
            bs4AccordionItem(
              id="sidenav1",
              title="Subject Selection (click to expand)",
              status="jounce2",
              fluidRow(column(8,
                              br(),br(),
                              h6(
                                "Subject selection takes place in the right sidebar, accessed using the icon in the upper right corner of your screen. See below for more information:",
                                br(),br(),
                                tags$ol(
                                  tags$li("Subject Selection Icon. Clicking will open and close the right sidebar."),
                                  br(),br(),
                                  tags$li("Subject selection drop down menu. Use to select subject to display in profiles"),
                                  br(),br(),
                                  tags$li("Cohort filter dropdown menu. Use to specify specific cohorts for display in subject selection dropdown menu (2)")
                                ))
              ),
              column(4,
                     img(src="controlbar.png",align="center",width="300px"),align="center"))
            ),
            bs4AccordionItem(
              id="sidenav2",
              title="Sidebar Navigation (click to expand)",
              status="jounce2",
              fluidRow(column(1,icon("info"),align="center"),column(2,tags$b("About:")),column(9,"The current page.")),
              fluidRow(column(1,icon("user"),align="center"),column(2,tags$b("Overview:")),column(9,"Highlight of important demographics, dosing, and disease information.")),
              fluidRow(column(1,icon("calendar-alt"),align="center"),column(2,tags$b("History:")),column(9,"Disease History, Medical History, Prior Surgery, Prior Radiotherapy, and Prior Systemic Therapies")),
              fluidRow(column(1,icon("syringe"),align="center"),column(2,tags$b("Dosing:")),column(9,"Exposure")),
              fluidRow(column(1,icon("prescription-bottle"),align="center"),column(2,tags$b("Concomitant:")),column(9,"Concomitant Medications")),
              fluidRow(column(1,icon("file-medical"),align="center"),column(2,tags$b("Adverse Events:")),column(9,"Adverse Events")),
              fluidRow(column(1,icon("vial"),align="center"),column(2,tags$b("Labs:")),column(9,"Chemistry, Coagulation, Hematology, and Urinalysis")),
              fluidRow(column(1,icon("heartbeat"),align="center"),column(2,tags$b("Vitals:")),column(9,"Vital Signs and Electrocardiograms")),
              fluidRow(column(1,icon("search"),align="center"),column(2,tags$b("Investigator RECIST 1.1:")),column(9,"Investigator RECIST 1.1 Data. Target Lesions, Non-Target Lesions, New Lesions, Response Assessments")),
              fluidRow(column(1,icon("x-ray"),align="center"),column(2,tags$b("Central RECIST 1.1:")),column(9,"Central Review RECIST 1.1 Data. Target Lesions, Non-Target Lesions, New Lesions, Response Assessments, and Comments")),
              fluidRow(column(1,icon("diagnoses"),align="center"),column(2,tags$b("Central irRC:")),column(9,"Central Review irRC Data. Target Lesions, Non-Target Lesions, New Lesions, Response Assessments, and Comments")),
              fluidRow(column(1,icon("chart-bar"),align="center"),column(2,tags$b("AE Timeline:")),column(9,"Plot of Adverse Events and Exposure over time.")),
              fluidRow(column(1,icon("chart-line"),align="center"),column(2,tags$b("Vital Signs Plot:")),column(9,"Systolic Blood Pressure, Diastolic Blood Pressure, Heart Rate, Respiratory Rate, Oxygen Saturation, Temperature, and Weight over time."))
            )
          ),
          title="Getting Started",
          closable=FALSE,
          elevation=2,
          status="jounce",
          width=10),
  bs4Card(
    title = "Change Log",
    closable=FALSE,
    elevation=2,
    width=10,
    status = "jounce",
    userPost(
      id = 1,
      src = "slacey.jpg",
      author = "Sean Lacey",
      description = "Version 1.0, 2019-03-28",
      "First version available.",
      userPostTagItems(
        userPostTagItem(bs4Badge("Major", status = "danger"))
      )
    )
  )
)

# Header Functions --------------------------------------------------------
headcard <- function(tbl.name,title,wval=6){
  bs4Card(
    title = title, 
    closable = FALSE, 
    width = wval, 
    solidHeader = TRUE, 
    collapsible = TRUE,
    status = "jounce",
    elevation = 2,
    tableOutput(tbl.name)
  )
}

headdata <- function(subj,ds,lbl,varvec){
  renderTable({
    if(!is.null(subj())){
      if(subj() != "Select Subject..."){
        
        col1 <- sapply(lbl,
                       function(x) paste0("<b>",x,":</b>"),
                       simplify = T,
                       USE.NAMES = F)
        col2 <- sapply(varvec,
                       function(x) as.character(ds[[subj()]][["header"]][,x]),
                       simplify = T,
                       USE.NAMES = F)
        
        head.df <- data.frame("col1" = as_vector(col1),
                              "col2" = as_vector(col2))
        
        ###Return final dataframe
        return(head.df)
      } 
    }
  },include.rownames=F,include.colnames=F,bordered=FALSE,sanitize.text.function=identity)
}

# Header Tab -------------------------------------------------------------
header_tab <- bs4TabItem(
  tabName = "header",
  fluidRow(
    headcard("card_subj","Subject Information"),
    headcard("card_demo","Demographics"),
    headcard("card_dose","Dosing"),
    headcard("card_eot","End of Treatment")
  )
)

# Dose Tab -------------------------------------------------------------
dose_tab <- bs4TabItem(
  tabName = "dosing",
  fluidRow(
    div(DTModuleUI("dose","Drug Administration"),class="col-sm-12",id="jtxcard")
  )
)

# AE Tab -------------------------------------------------------------
ae_tab <- bs4TabItem(
  tabName = "adverse",
  fluidRow(
    DTModuleUI("ae","Adverse Events")
  )
)
