DTModuleUI <- function(id,title){
  ns <- NS(id)
  
  tagList(
    bs4Card(
      title = title, 
      closable = FALSE,
      status = "jounce",
      elevation = 2,
      width = 12, 
      solidHeader = TRUE, 
      collapsible = TRUE,
      DT::dataTableOutput(ns("tableName"))
    )
  )
}

DTModule <- function(input,output,session,subj,dset,dname,vlist,vname,lab=FALSE,...){
  output$tableName <- DT::renderDataTable({
    if(!is.null(subj())){
      if(subj() != "Select Subject..."){
        if(lab==FALSE){
            DT::datatable(as.data.frame(dset[[subj()]][[dname]])[,vlist],
                          options=list(paging=FALSE,searching=FALSE,info=FALSE, ...),
                          rownames=FALSE,
                          colnames=vname,
                          escape=FALSE)          
        }else{
          DT::datatable(as.data.frame(dset[[subj()]][[dname]])[,vlist],
                        filter="top",
                        options = list(dom="tpi", ...),
                        rownames=FALSE,
                        colnames=vname,
                        escape=FALSE)        
        }
      }
    }
  }) 
}