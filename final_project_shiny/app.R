
library(shiny)

# Define UI for application that draws a histogram
my_ui <- fluidPage(
  
  titlePanel("The World's Emotions at a Glance"),
  
  
  
  
  
  sidebarLayout( #this pannel will be taking in all of the inputs
    #---------------------------------------------------------------------------------------------------    
    sidebarPanel(
      #-------------------------------------------------------------
      sliderInput(inputId = ),
      
      
      selectInput(inputId = )
      
      
      
      
      
      
      
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
shinyApp(ui = ui, server = server)

