# install the required packages
install.packages(c("shiny",
                   "shinydashboard",
                   "rsconnect",
                   "DT",
                   "tidyverse",
                   "scales",
                   "gmodels",
                   "wesanderson",
                   "viridis",
                   "wordcloud",
                   "RColorBrewer",
                   "leaflet",
                   "httr",
                   "rjson"))


# load the required library
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


# set the working folder for reading csv files placed in the same folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# running the Shiny Dashboard
runApp()

