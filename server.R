
# loading those library to R 
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


# read the WorldCups.csv as RAW dataset
wc_raw <- read.csv(file("./WorldCups.csv"), header = TRUE, na.strings = c("","NA"))
wcp_raw <- read.csv(file("./WorldCupPlayers.csv"), header = TRUE, na.strings = c("","NA"))
wcm_raw <- read.csv(file("./WorldCupMatches.csv"), header = TRUE, na.strings = c("","NA"))

wc_df<-wc_raw
wcm_df<- wcm_raw
wcp_df<- wcp_raw

wcm_data1 <- wcm_df %>% 
  distinct(MatchID, .keep_all= TRUE) %>%
  filter(!is.na(Year)) %>%
  filter(!is.na(Attendance)) %>%
  filter(!is.na(Home.Team.Goals)) %>%
  filter(!is.na(Away.Team.Goals)) %>%
  mutate(Year<-as.character(Year),
         Year<-as.factor(Year)) %>%
  group_by(Year) %>%
  summarise(Total_Att = sum(Attendance), Mean_Att=mean(Attendance), Total_Score=sum(Home.Team.Goals+Away.Team.Goals))

wcm_data2 <- wcm_df %>% 
  distinct(MatchID, .keep_all= TRUE) %>%
  filter(!is.na(Year)) %>%
  filter(!is.na(Home.Team.Goals)) %>%
  filter(!is.na(Away.Team.Goals)) %>%
  mutate(Year<-as.character(Year),
         Year<-as.factor(Year)) %>%
  group_by(Year, MatchID) %>%
  summarise(Match_Score=sum(Home.Team.Goals+Away.Team.Goals))


function(input, output) {
  
  output$data1 <- renderDT({
    wcm_data1
  })
  
  output$plot1 <- renderPlot({
    wcm_graph1 <- ggplot(wcm_data1, aes(x=factor(Year), y=Total_Att, fill=Year))
    # not displayed those outlier
    wcm_graph1 + geom_bar(stat="identity")+
      # label the title, x axis and y axis
      labs(x = "Year",
           y = "Attendance") +
      theme_classic() + guides(fill=FALSE)+
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma, expand = expand_scale(mult = c(0, 0.1), add = c(0, 0))) +
      scale_x_discrete(breaks=wcm_data1$Year, labels=wcm_data1$Year) +
      geom_text(aes(label=paste(scales::comma(round(Total_Att=Total_Att/1000)),"K")), vjust =-0.5, size=3) +
      scale_fill_viridis()
    
  })
  
  
  output$plot2 <- renderPlot({
    wcm_graph2 <- ggplot(wcm_data1, aes(x=factor(Year), y=Mean_Att))
    wcm_graph2 + geom_path(group = 1,size=1) + geom_point() +
      # label the title, x axis and y axis
      labs(x = "Year", 
           y = "Avg. Attendance") +
      theme_classic() + 
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma) +
      scale_x_discrete(breaks=wcm_data1$Year, labels=wcm_data1$Year) 
    
  })
  
  output$plot3 <- renderPlot({
    wcm_graph3 <- ggplot(wcm_data1, aes(x=factor(Year), y=Total_Score, fill=Year))
    wcm_graph3 + geom_path(group = 1,size=1) + geom_point(shape=21, color="darkred", size=6) +
      # label the title, x axis and y axis
      labs(x = "Year", 
           y = "Avg. Attendance") +
      theme_classic() + guides(fill=FALSE) +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma) +
      scale_x_discrete(breaks=wcm_data1$Year, labels=wcm_data1$Year) +
      scale_fill_viridis()
    
    
    
    
  })
  
  output$plot4 <- renderPlot({
    wcm_graph4 <- ggplot(wcm_data2, aes(x=factor(Year), y=Match_Score,fill=Year))
    wcm_graph4 + geom_boxplot() +
      # label the title, x axis and y axis
      labs(x = "Year", 
           y = "Goals") +
      theme_classic() + guides(fill=FALSE) +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma) +
      scale_x_discrete(breaks=wcm_data2$Year, labels=wcm_data2$Year) +
      scale_fill_viridis()
    
    
  })
  
  
  
  
  
}
