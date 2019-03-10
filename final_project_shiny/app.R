library("shiny")
library("dplyr")
library("tidyr")
library("jsonlite")
library("ggplot2")
library("hexbin")
library('maps')







# Define UI for application that draws a histogram
my_ui <- fluidPage(
  
  titlePanel("The World's Emotions at a Glance"),
  
  
  
  
  
  sidebarLayout( #this pannel will be taking in all of the inputs
    #---------------------------------------------------------------------------------------------------    
    sidebarPanel(
      #-------------------------------------------------------------
      
      
      
      
      
      
      sliderInput(inputId = "happiness_id", label = "Assign a weight to how much you value happiness", min = 0, max = 100, value = 50),
      sliderInput(inputId = "freedom_id", label = "Assign a weight to how much you value freedom", min = 0, max = 100, value = 50),
      sliderInput(inputId = "gini_id", label = "Assign a weight to how much you value equality", min = 0, max = 100, value = 50)
      
      
      
      
      
      
      #------------------------------------------------------------- 
    ),
    
    
    
    
    
    
    
    
    
    mainPanel(  #this is the display pannel.  This is where all the renderings will be taking place
      #-------------------------------------------------------------
      
      tabsetPanel(
        #-------------------------------------------------------------
        tabPanel("tab1"
                 
                 
        ),
        
        tabPanel("tab2"
                 
        ),
        
        tabPanel("tab3"
                 
                 
                 
        )
        
        #-------------------------------------------------------------  
      )
      
      #-------------------------------------------------------------
    )
    
    
    
    
    
    
    #----------------------------------------------------------------------------------------------------   
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   
}

# Run the application 
shinyApp(ui = my_ui, server = my_server)

