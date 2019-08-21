library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(stringr)
library(ggplot2)
library(scales)
library(gmodels)
library(wesanderson)
library(viridis)
library(rsconnect)

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
              box(title = "Total Attendance", status = "info", solidHeader = TRUE,
                  plotOutput("plot1")),
              
              box(title = "Avg. Attendance", status = "info", solidHeader = TRUE,
                  plotOutput("plot2"))
            ),
            fluidRow(
              box(title = "Total goals", status = "info", solidHeader = TRUE,
                  plotOutput("plot3")),
              
              box(title = "Total goals during games", status = "info", solidHeader = TRUE,
                  plotOutput("plot4"))
            ),
            fluidRow(
              box(title = "Match outcomes by home and away teams", status = "info", solidHeader = TRUE,
                  plotOutput("plot5")),
              
              box(title = "Match outcomes by home and away teams", status = "info", solidHeader = TRUE,
                  plotOutput("plot6"))
            )
    ),
    
    
    
    
    tabItem(tabName = "byyear", "By Year",br(),
            fluidRow(
              box(
                title =  "Select the Year", br(),
                sliderInput("selectyear", "Year:", 1930,2014,4)
                
              )
            )
    ),
    
    
    
    
    
    tabItem(tabName = "dataset", "Data Set",
            DTOutput("data1"))
  )
)














ui <- dashboardPage(header, sidebar, body)
