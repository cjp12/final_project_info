library("shiny")
library("dplyr")
library("tidyr")
library("jsonlite")
library("ggplot2")
library("hexbin")
library('maps')
library("reshape2")



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
        
        tabPanel("Happiness_Factors",
                 plotOutput(outputId = "values_comparison", height=700)
                 
        ),
        
        tabPanel("Homicide_vs_Personal_Freedom",
                plotOutput(outputId = "homicide_comparison", height=700),
                textOutput(outputId = "weighted_essay")
                 
        )         
          
        )
        
        #-------------------------------------------------------------  
      )
      
      #-------------------------------------------------------------
    
    
    
    
    
    
    
    #----------------------------------------------------------------------------------------------------   
  )
)





#-------------------data manipulation-----------------------------------------------






#------------------/data manipulation-----------------------------------------------

















#View(world_df)




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
  
  output$values_comparison <- renderPlot({
    
    
    
    Happiness <- happiness_raw_df
    Happiness.Region <- Happiness %>%
      select(Region,Happiness.Score,Lower.Confidence.Interval,Upper.Confidence.Interval,Economy..GDP.per.Capita.,
             Family,Health..Life.Expectancy.,Freedom,Trust..Government.Corruption.,Generosity,Dystopia.Residual) %>%
      group_by(Region) %>%
      summarise_all(mean)
    
    Happiness.Region.melt <- melt(Happiness.Region)
    
    
    plot <- ggplot(Happiness.Region.melt, aes(y=value, x=Region, color=Region, fill=Region)) + 
      geom_bar( stat="identity") + facet_wrap(~variable) + theme_bw() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      labs(title = "Happiness Factors by Region") 
    
    plot
  })
  
  
  output$homicide_comparison <- renderPlot({
  
    #Plots personal freedoms (freedom of religion, expression, internet use) vs. homicide per region
  Freedom <- freedom_raw_df
  Freedom.region <- Freedom %>%
    select(region, pf_ss_homicide, pf_religion, pf_expression,  pf_expression_internet) %>%
    group_by(region) %>%
    summarize_all(mean)
  
   Freedom.region.melt <- melt(Freedom.region)
  
   plot <- ggplot(Freedom.region.melt, aes(y = value, x = region, color = region, fill = region)) +
     geom_bar(stat = "identity") + facet_wrap(~variable) + theme_bw() + 
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     labs(title = "Homicide vs. Personal Freedom across various regions")
    
   plot
   
   })

  output$weighted_essay <- renderText({
    message <- paste0("This analysis soke to find a correlation between violence (in the form of homicide rates) and the limiting of personal freedoms (freedom of religion, internet use, and expression). This analysis covered North America, Western Europe, Oceania and East Asia. It's easy to notice that North America has the lowest homicide rate, and highest levels of personal freedom on all three parameters in comparison to the other regions observed. Although Europe has the highest homicide rate among the three, it also has a very high rate of freedom of expression, an anomally that may be attributed to the issues between immigrants and locals. This would make sense, given the relatively lower level of perceived religious freedom. In short, while there are caveats, in general violence tends to be lower in regions where the population enjoys more personal liberty.")
    message
  })
  
} 


# Run the application 
shinyApp(ui = my_ui, server = my_server)

