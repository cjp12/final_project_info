library("shiny")
library("dplyr")
library("tidyr")
library("jsonlite")
library("ggplot2")
library("hexbin")
library('maps')



source("analysis.R")



# Define UI for application that draws a histogram
my_ui <- fluidPage(
  
  titlePanel("The World's Emotions at a Glance"),
  
  
  
  
  
  sidebarLayout( #this pannel will be taking in all of the inputs
    #---------------------------------------------------------------------------------------------------    
    sidebarPanel(
      #-------------------------------------------------------------
      
      
      
      
      
      
      sliderInput(inputId = "happiness_id", label = "Assign a weight to how much you value happiness", min = 0, max = 100, value = 50),
      sliderInput(inputId = "freedom_id", label = "Assign a weight to how much you value freedom", min = 0, max = 100, value = 50)
      
      
      
      
      
      
      
      #------------------------------------------------------------- 
    ),
    
    
    
    
    
    
    
    
    
    mainPanel(  #this is the display pannel.  This is where all the renderings will be taking place
      #-------------------------------------------------------------
      
      tabsetPanel(
        #-------------------------------------------------------------
        tabPanel("tab1",
                 plotOutput(outputId = "weighted_map")
                 
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





#-------------------data manipulation-----------------------------------------------






#------------------/data manipulation-----------------------------------------------

















View(world_df)




# Define server logic required to draw a histogram
my_server <- function(input, output) {
   
  
  output$weighted_map <- renderPlot({
    
    composite_map_mutated_df <- composite_map_df %>% 
      mutate(
        weight = (hf_score * input$freedom_id[1]) + (Happiness.Score * input$happiness_id[1])
      ) 
      
    
    p <- ggplot(composite_map_mutated_df)+
      geom_polygon(aes(x = long, y = lat, group = group, fill = weight))+
      scale_fill_gradient(low = "red", high = "green")
    
    
  
    
    
   p 
    
    
  })
  
  
  
  
  
  
  
  
   
}

# Run the application 
shinyApp(ui = my_ui, server = my_server)

