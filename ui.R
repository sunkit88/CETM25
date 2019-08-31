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
  title = "FIFA World CUP"
)


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview",
             tabName = "overview"),
    menuSubItem("By Year",
                tabName ="byyear"),
    menuItem("Data Set",
             tabName = "dataset")

  )
)


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "overview", "Overview",
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
    
    
    
    
    tabItem(tabName = "byyear", "By Year",
            
            fluidRow(
              box(
                title =  "Select the Year", width = 12,
                sliderInput("selectyear", "Select the Year to showing details", min = 1930, max = 2014, value = 1930, step = 4,
                            animate = animationOptions(interval = 5000, loop = TRUE))
              )
            ),
            
            uiOutput("byyear_box")
            # fluidRow(
            #   valueBoxOutput("year"),
            #   valueBoxOutput("winner"),
            #   valueBoxOutput("total_att")
            # ),
            # 
            # fluidRow(
            #   valueBoxOutput("country"),
            #   valueBoxOutput("total_goal"),
            #   valueBoxOutput("avg_att")
            # ),
            # 
            # fluidRow(
            #   # box(title= "Hosts Stadium", 
            #   #     status = "info", solidHeader = TRUE, width = 12, height = 450,
            #       leafletOutput("map2")
            #       
            #       
            # )
            # 
            
    ),
    
    
    tabItem(tabName = "dataset", "Data Set",
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














ui <- dashboardPage(header, sidebar, body)
