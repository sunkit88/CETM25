library(shiny)
library(shinydashboard)
library(rsconnect)
library(DT)
library(tidyverse)
library(scales)
library(gmodels)
library(wesanderson)
library(viridis)
library(wordcloud)
library(RColorBrewer)
library(leaflet)
library(httr)
library(rjson)


header <- dashboardHeader()
sidebar <- dashboardSidebar()
body <- dashboardBody()


header <- dashboardHeader(
  title = span(
    "FIFA World Cup",
    style = "font-family: Segoe UI; font-weight: bold; font-size: 30px"
  ),
  titleWidth = "300px"

)


sidebar <- dashboardSidebar(
  width = 300,
  sidebarMenu(style = "position: fixed; overflow: visible;",
    menuItem(text= span("Overview", style = "font-weight: bold; font-size: 20px"),
             tabName = "overview"),
    menuSubItem(text= span("By Year", style = "font-size: 20px"),
                tabName ="byyear"),
    menuItem(text= span("Data Set", style = "font-weight: bold; font-size: 20px"),
             tabName = "dataset")

  )
)


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "overview", h2("Overview"),
            fluidRow(
              
              box(title = "Most successful team(s) - Wordcloud",
                  status = "info", solidHeader = TRUE, width = 8,
                  plotOutput("plot1")),
              box(title = "Most successful team(s) - chart",
                  status = "info", solidHeader = TRUE, width =4,
                  plotOutput("plot2"))
              
            ),
            fluidRow(
              box(title= "Hosts Country", 
                  status = "info", solidHeader = TRUE, width = 12, height = 450,
                  leafletOutput("map1")
                  
                
              )
            ),
            fluidRow(
              box(title = "Total Attendance", status = "info", solidHeader = TRUE, 
                  plotOutput("plot3",height = 300)),
              
              box(title = "Avg. Attendance", status = "info", solidHeader = TRUE, 
                  plotOutput("plot4",height = 300))
            ),
            fluidRow(
              box(title = "Most Win teams", status = "info", solidHeader = TRUE, width = 4,
                  plotOutput("plot7")),
              box(title = "Most loss teams", status = "info", solidHeader = TRUE, width = 4,
                  plotOutput("plot8")),
              box(title = "Most draw teams", status = "info", solidHeader = TRUE, width = 4,
                  plotOutput("plot9"))
            ),
            fluidRow(
              box(title = "Total goals", status = "info", solidHeader = TRUE, width = 8,
                  plotOutput("plot5")),
              
              box(title = "Total goals during games", status = "info", solidHeader = TRUE, width = 4,
                  plotOutput("plot6"))
            )
    ),
    
    
    
    
    tabItem(tabName = "byyear", h2("By Year"),
            
            fluidRow(
              box(
                title =  "Select the Year", width = 12,
                sliderInput("selectyear", "Select the Year to showing details", min = 1930, max = 2014, value = 1930, step = 4,
                            animate = animationOptions(interval = 5000, loop = TRUE))
              )
            ),
            
            uiOutput("byyear_box")
    ),
    
    
    tabItem(tabName = "dataset", h2("Data Set"),
            tabsetPanel(type = "tabs",
                tabPanel("WorldCups.csv", 
                         DTOutput("data1", 
                                  width = "100%", height = "auto")),
                tabPanel("WorldCupMatches.csv", 
                         DTOutput("data2",
                                  width = "100%", height = "auto")),
                tabPanel("WorldCupPlayers.csv", 
                         DTOutput("data3",
                                  width = "100%", height = "auto"))
            )
    )
  )
)














ui <- dashboardPage(title="FIFA World Cup", header, sidebar, body)
