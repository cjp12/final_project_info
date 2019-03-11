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
        tabPanel("Relocation",
                 plotOutput(outputId = "weighted_map"),   #This outputs the color coded map
                 textOutput(outputId = "weighted_string"),  #This outputs the text message for those using a screen reader
                 tableOutput(outputId = "weighted_table")   #This outputs the table of the top 5 choices
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
   
  
  output$weighted_map <- renderPlot({    #this ranks and color codes the countries by their weighted amounts
    
    composite_map_mutated_df <- composite_map_df %>% 
      mutate(
        weight = (hf_score * input$freedom_id[1]) + (Happiness.Score * input$happiness_id[1])
      )

    p <- ggplot(composite_map_mutated_df)+
      geom_polygon(aes(x = long, y = lat, group = group, fill = weight))+
      scale_fill_gradient(low = "red", high = "green")
    
   p 
  })
  
  
  
  
  
  
  output$weighted_table <- renderTable({    #this creates a table that ranks the top 5 countries
    
    composite_map_sliced_df <- composite_map_df %>% 
      mutate(
        total_score = (hf_score * input$freedom_id[1]) + (Happiness.Score * input$happiness_id[1])
      ) %>% 
      arrange(desc(total_score)) %>% 
      select(c(Country.Name)) %>% 
      unique() %>% 
      slice(1:5)
    
    composite_map_sliced_df["Place"] <- c(1:5)
    
    composite_map_sliced_df
  })
  
  
  
  output$weighted_string <- renderText({    #this creates a string that makes the map above easier to understand.
  
    best_country <- composite_map_df %>% 
      mutate(
        total_score = (hf_score * input$freedom_id[1]) + (Happiness.Score * input$happiness_id[1])
      ) %>% 
      arrange(desc(total_score)) %>% 
      select(c(Country.Name)) %>% 
      unique() %>% 
      slice(1)
    
    freedom_value <- input$freedom_id[1]
    happiness_value <- input$happiness_id[1]
    best_country <- strong(best_country)
    
    message <- paste0("So you are ready to relocate? Well, accordinging to your assigned weight of ", freedom_value, " for freedom and your weight of ", happiness_value, " for happiness, it seems that, ", best_country, " would be the best choice for you.")
    
    message
  })
  
  
  
  
  
   
}

# Run the application 
shinyApp(ui = my_ui, server = my_server)

