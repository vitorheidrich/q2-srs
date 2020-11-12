library(qiime2R)
library(SRS)
library(DT)
library(shiny)
library(shinycssloaders)
library(shinybusy)
library(dplyr)

SRS.shiny.app.qiime <- function(){
  #function that outputs the diversity retained in the normalized dataset for a given sampling depth
  #the default metric is richness, but simpson, shannon and invsimpson are other options
  
  SRSdivretained<-function(data,Cmin,metric="richness"){
    inisamp=length(data)
    total_richness=length(which(rowSums(data)>0))
    if(any(colSums(data) < Cmin)){
      samples_discarded<-colnames(data[,colSums(data) < Cmin, drop = F])
      cat(noquote(paste(paste(length(samples_discarded)," sample(s) discarded: ",
                              paste(samples_discarded, collapse=', ')),"","",sep="\n")))
      data<-data[,colSums(data) >= Cmin, drop = F]
    }
    finsamp=length(data)
    output<-as.data.frame(matrix(nrow = ncol(data), ncol = 5))
    rownames(output)<-colnames(data)
    #Retained: diversity of the normalized samples
    #Total: diversity of the non-normalized samples
    #% Retained: Retained/Total
    colnames(output)<-c("number of counts",
                        "initial diversity (non-normalized)",
                        "retained diversity (normalized)",
                        "%retained diversity (normalized)", 
                        "%discarded diversity (normalized)")
    SRS_output<-SRS(data,Cmin)
    retained_richness=length(which(rowSums(SRS_output)>0))
    if (metric=="richness"){
      for (sample in 1:ncol(data)){
        output[sample,1]=sum(data[,sample])
        output[sample,2]=vegan::specnumber(data[,sample])
        output[sample,3]=vegan::specnumber(SRS_output[,sample])
        output[sample,4]=100*(output[sample,3]/output[sample,2])
        output[sample,5]=100-100*(output[sample,3]/output[sample,2])
      }
    }
    else{
      for (sample in 1:ncol(data)){
        output[sample,1]=sum(data[,sample])
        output[sample,2]=vegan::diversity(data[,sample],index=metric)
        output[sample,3]=vegan::diversity(SRS_output[,sample],index=metric)
        output[sample,4]=100*(output[sample,3]/output[sample,2])
        output[sample,5]=100-100*(output[sample,3]/output[sample,2])
      }
    }
    cat(noquote(paste("==================sample summary=================","",sep="\n")))
    sample_summary<-data.frame(inisamp,finsamp,inisamp-finsamp,(finsamp/inisamp)*100,((inisamp-finsamp)/inisamp)*100)
    colnames(sample_summary)<-c("samples","included","discarded","%included","%discarded")
    print(sample_summary,row.names=F)
    
    cat(noquote(paste("","============global (species) richness============","",sep="\n")))
    richness_summary<-data.frame(total_richness,retained_richness,total_richness-retained_richness,(retained_richness/total_richness)*100,((total_richness-retained_richness)/total_richness)*100)
    colnames(richness_summary)<-c("total","retained","discarded","%retained","%discarded")
    print(richness_summary,row.names=F)
    
    cat(noquote(paste("","=======summary statistics diversity metric=======","",sep="\n")))
    
    return(output)
  }
  
  # Define UI for application
  ui <- fluidPage(
    
    # Application title
    headerPanel(HTML(paste0("SRS Shiny app for the determination of C",tags$sub("min")))),
    
    
    
    # Sidebar with metric options and sampling depth to be chosen
    sidebarLayout(
      sidebarPanel(
        
        #input .qza file
        fileInput("qza", "Upload ASV/OTU table QIIME2 artifact (.qza)",
                  multiple = F,
                  accept = ".qza"),
        
        #selection of diversity metric
        selectInput("metric", "diversity metric:", 
                    choices = c("richness", "shannon", "simpson","invsimpson")),
        #slider for Cmin
        sliderInput("Cmin",
                    (HTML(paste0("sampling depth (C",tags$sub("min"), ")"))),
                    min = 1,
                    max = max(colSums(data)),
                    value = min(colSums(data))),
        #numeric input of Cmin
        textInput(
          "textValue",
          (HTML(paste0("sampling depth (C",tags$sub("min"), ")"))),
          value = min(colSums(data))
        ),
        
        
        #reset bottun
        actionButton("reset", 
                     (HTML(paste0("reset C",tags$sub("min"))))
        ),
        
        
        #numeric input of step size
        textInput(
          "textValueStepSize",
          (HTML(paste0("SRS curve step size"))),
          value = 1000
        ),
        
        sliderInput("SRScurvemaxsamplesize",
                    (HTML(paste0("SRS curve max. sample size"))),
                    min = 1,
                    max = max(colSums(data)),
                    value = min(colSums(data))),
        
        textInput(
          "textValueMaxSampleSize",
          (HTML(paste0("SRS curve max. sample size"))),
          value = min(colSums(data))
        ),
        
        #reset bottun
        actionButton("reset1", 
                     (HTML(paste0("reset max. sample size")))
        )
        
        
      ),                                       
      mainPanel(
        tabsetPanel(
          tabPanel("rug plot and summary statistics",
                   h3("rug plot of retained samples"),
                   h5(HTML(paste0("the vertical dashed blue line indicates the selected C",tags$sub("min")))),
                   plotOutput("plot"),
                   h3("summary statistics"),
                   verbatimTextOutput("summary")),
          tabPanel("SRS curves",h3("SRS curves"),
                   h5(HTML(paste0("the vertical dashed blue line indicates the selected C",tags$sub("min")))),
                   plotOutput("SRSplot")),
          tabPanel("table diversity metric", DT::dataTableOutput("table") %>% withSpinner(color="#56B4E9"))
        )
      )
    )
  )
  
  # Define server to draw the desired table output of SRSdivretained
  server <- function(input, output, session) {
    #text input connected to slider 
    observeEvent(input$textValue, {
      print(input$textValue)
      if ((as.numeric(input$textValue) != input$Cmin) &
          input$textValue != "" &  input$Cmin != "")
      {
        updateSliderInput(
          session = session,
          inputId = 'Cmin',
          value = input$textValue
        )
      } else {
        if (input$textValue == "") {
          updateSliderInput(session = session,
                            inputId = 'Cmin',
                            value = 0)
        }
      }
    })
    
    observeEvent(input$Cmin, {
      if ((as.numeric(input$textValue) != input$Cmin) &
          input$Cmin != "" & input$textValue != "")
      {
        updateTextInput(
          session = session,
          inputId = 'textValue',
          value = input$Cmin
        )
      }
    })
    
    observeEvent(input$textValueMaxSampleSize, {
      print(input$textValueMaxSampleSize)
      if ((as.numeric(input$textValueMaxSampleSize) != input$SRScurvemaxsamplesize) &
          input$textValueMaxSampleSize != "" &  input$SRScurvemaxsamplesize != "")
      {
        updateSliderInput(
          session = session,
          inputId = 'SRScurvemaxsamplesize',
          value = input$textValueMaxSampleSize
        )
      } else {
        if (input$textValueMaxSampleSize == "") {
          updateSliderInput(session = session,
                            inputId = 'SRScurvemaxsamplesize',
                            value = 0)
        }
      }
    })
    
    observeEvent(input$SRScurvemaxsamplesize, {
      if ((as.numeric(input$textValueMaxSampleSize) != input$SRScurvemaxsamplesize) &
          input$SRScurvemaxsamplesize != "" & input$textValueMaxSampleSize != "")
      {
        updateTextInput(
          session = session,
          inputId = 'textValueMaxSampleSize',
          value = input$SRScurvemaxsamplesize
        )
      }
    })
    
    #reset button
    observeEvent(input$reset, {
      updateSliderInput(session = session,
                        inputId = 'Cmin',
                        value = min(colSums(data)))
    })
    #reset button
    observeEvent(input$reset1, {
      updateSliderInput(session = session,
                        inputId = "SRScurvemaxsamplesize",
                        value = min(colSums(data)))
    })
    
    output$table <- DT::renderDataTable({
      req(input$qza)
      data <- as.data.frame(qiime2R::read_qza(file=input$qza$datapath)[["data"]])
      
      df_table <- SRSdivretained(data,Cmin = input$Cmin, metric=input$metric)
      df_table <- round(df_table, digits = 3)
    })
    
    output$summary <- renderPrint({
      req(input$qza)
      data <- as.data.frame(qiime2R::read_qza(file=input$qza$datapath)[["data"]])
      
      df_summary <- SRSdivretained(data,Cmin = input$Cmin, metric=input$metric)
      summary(df_summary$retained)
    })
    
    output$plot <- renderPlot({
      req(input$qza)
      data <- as.data.frame(qiime2R::read_qza(file=input$qza$datapath)[["data"]])
      
      show_modal_spinner(text = "Please wait for the rug plot and summary statistics ...", color = "#56B4E9")
      counts <- NULL
      df_rug_plot <- data.frame(counts = colSums(data))
      h <- hist(df_rug_plot$counts, breaks=max(df_rug_plot$counts)-min(df_rug_plot$counts), plot=FALSE)
      cuts <- as.vector(cut(h$breaks, c(0,input$Cmin,Inf), right=F))
      colors <- cuts
      Cmin_position_rug_plot <- if(input$Cmin < min(colSums(data))){NULL} else {
        input$Cmin}
      jitter_size <- if(ncol(data) < 11 ){2
        } else {
          if(ncol(data) < 51 ){1
          } else { 
            if(ncol(data) < 101 ){0.75
            } else {
              if(ncol(data) < 301 ){0.5
              } else {0.4}
            }}}
      
      if(length(unique(cuts))==1){
        for (j in 1:length(cuts)){
          colors[j]<-"black"}
      }
      else{
        for (j in 1:length(cuts)){
          if(colors[j]==cuts[1]){colors[j]<-"grey"}
          else{colors[j]<-"black"}
        }
      }
      plot(h, col = colors, border = colors,yaxt='n',
           ylim = c(0,max(h$counts)+0.35),
           xlab = paste("total number of counts"), cex.lab = 1.25, cex.axis = 1.25, cex.main = 1.5,
           main = paste(nrow(subset(df_rug_plot,counts>=input$Cmin))," out of ",ncol(data)," samples retained (",round((nrow(subset(df_rug_plot,counts>=input$Cmin))/ncol(data))*100,2),"%)", sep = ""), 
           las= 1)
      axis(2, at = seq(0,max(h$counts, 1)),las = 1, cex.lab = 1.25, cex.axis = 1.25)
      boxplot(df_rug_plot$counts, add = T, horizontal=TRUE, at=max(h$counts)+0.2, col = "grey95",
              border="grey50", boxwex=0.5, outline=F, outpch = 16, whisklty = 1, whisklwd = 3, staplelwd = 3, boxlwd = 3, axes = F)
      set.seed(1)
      stripchart(df_rug_plot$counts, at=max(h$counts)+0.2, jitter = 0.08,
                 method = "jitter", add = TRUE, pch = 16, cex = jitter_size, col = 'black')
      set.seed(NULL)
      abline(v = Cmin_position_rug_plot , col="blue", lty="dashed")
      remove_modal_spinner()
    })
    
    #output tabs
    output$SRSplot <- renderPlot({
      req(input$qza)
      data <- as.data.frame(qiime2R::read_qza(file=input$qza$datapath)[["data"]])
      
      show_modal_spinner(text = "Please wait or choose larger step size ...", color = "#56B4E9")
      SRScurve(data, metric=input$metric, 
               step =if(input$textValueStepSize == ""){
                 1000
               } else {
                 as.numeric(input$textValueStepSize)},
               max.sample.size = if(input$textValueMaxSampleSize == "" ){
                 1
               } else {
                 as.numeric(input$textValueMaxSampleSize)},
               
               ylab = paste(input$metric), xlab = paste("total number of counts"),
               cex.lab = 1.25, cex.axis = 1.25, las = 1)
      abline(v = input$Cmin, col="blue", lty="dashed")
      remove_modal_spinner()
    })
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)}

#SRS.shiny.app.qiime()
