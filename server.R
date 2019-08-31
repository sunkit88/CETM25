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


getLatLng <- function(address){
  urlData <- GET(paste0("https://maps.googleapis.com/maps/api/geocode/json?address=", address,"&key=AIzaSyC6AvdVQP7U15XedlgPgDRiwEgCPOURLvg"))
  jsonResult <- rjson::fromJSON(rawToChar(urlData$content))
  # Sys.sleep(1)
  if(jsonResult$status != "OK"){
    print("Google geocode API Error")
    return("error")
  }
  print("LatLng Got")
  lat <<- jsonResult$results[[1]]$geometry$location$lat
  lng <<- jsonResult$results[[1]]$geometry$location$lng
  return(paste(lat, lng, sep=","))
}


getLatLngProg = function(address, total) {
  incProgress(0.1/total, detail = "Resolving location for Map")
  return (getLatLng(address))
}


# read the WorldCups.csv as RAW dataset
wc_raw <- read.csv(file("./WorldCups.csv"), header = TRUE, na.strings = c("","NA"), encoding = "ISO-8859-1")
wcp_raw <- read.csv(file("./WorldCupPlayers.csv"), header = TRUE, na.strings = c("","NA"), encoding = "ISO-8859-1")
wcm_raw <- read.csv(file("./WorldCupMatches.csv"), header = TRUE, na.strings = c("","NA"), encoding = "ISO-8859-1")


wc_df<-wc_raw
wcm_df<- wcm_raw
wcp_df<- wcp_raw


wc_data <- wc_df %>%
  filter(!is.na(Year)) %>%
  filter(!is.na(Winner)) %>%
  mutate(Winner = recode(Winner, 'Germany FR' = 'Germany')) %>%
  count(Winner) %>%
  mutate(n=n*10) %>%
  arrange(n)



wc_data1 <- wc_df %>%
  filter(!is.na(Year)) %>%
  filter(!is.na(Winner)) %>%
  mutate(Winner = recode(Winner, 'Germany FR' = 'Germany')) 



wcm_data <- wcm_df %>% 
  distinct(MatchID, .keep_all= TRUE) %>%
  select(Home.Team.Name, Away.Team.Name) %>%
  filter(!is.na(Home.Team.Name), !is.na(Away.Team.Name)) %>%
  mutate(Home.Team.Name = recode(Home.Team.Name, 'Germany FR' = 'Germany'),
         Away.Team.Name = recode(Away.Team.Name, 'Germany FR' = 'Germany')) %>%
  gather(Home_Away, Winner, Home.Team.Name, Away.Team.Name) %>%
  distinct(Winner, .keep_all= TRUE) %>%
  select(Winner) %>%
  count(Winner) %>%
  mutate(n=round(n/100,digit=0)+5) %>%
  arrange(n) 



wc_win_wordcloud <- rbind(wc_data,wcm_data) %>%
  distinct(Winner, .keep_all= TRUE) 
  


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



wcm_data3 <- wcm_df %>% 
  distinct(MatchID, .keep_all= TRUE) %>%
  filter(!is.na(Year)) %>%
  filter(!is.na(Home.Team.Goals)) %>%
  filter(!is.na(Away.Team.Goals)) %>%
  mutate(Year<-as.character(Year),
         Year<-as.factor(Year)) %>%
  group_by(Year, MatchID) %>%
  summarise(Match_Score=sum(Home.Team.Goals+Away.Team.Goals))



wcm_data3_W<- wcm_df %>%
  distinct(MatchID, .keep_all= TRUE) %>%
  select(MatchID, Home.Team.Name, Home.Team.Goals, Away.Team.Name, Away.Team.Goals, Win.conditions) %>%
  filter(!is.na(Home.Team.Name),!is.na(Home.Team.Goals),!is.na(Away.Team.Name),!is.na(Away.Team.Goals)) %>%
  mutate(Home.Team.Name = recode(Home.Team.Name, 'Germany FR' = 'Germany'),
         Away.Team.Name = recode(Away.Team.Name, 'Germany FR' = 'Germany')) %>%
  mutate(score = Home.Team.Goals - Away.Team.Goals) %>%
  gather(Home_Away, Team_name, Home.Team.Name, Away.Team.Name) %>%
  mutate(result = ifelse(score==0,"D",ifelse((score>0 & Home_Away=="Home.Team.Name"),"W",ifelse((score<0 & Home_Away=="Away.Team.Name"),"W","L")))) %>%
  count(Team_name,result) %>%
  filter(result=="W") %>%
  top_n(10) %>%
  arrange(n, Team_name)



wcm_data3_L<- wcm_df %>%
  distinct(MatchID, .keep_all= TRUE) %>%
  select(MatchID, Home.Team.Name, Home.Team.Goals, Away.Team.Name, Away.Team.Goals, Win.conditions) %>%
  filter(!is.na(Home.Team.Name),!is.na(Home.Team.Goals),!is.na(Away.Team.Name),!is.na(Away.Team.Goals)) %>%
  mutate(Home.Team.Name = recode(Home.Team.Name, 'Germany FR' = 'Germany'),
         Away.Team.Name = recode(Away.Team.Name, 'Germany FR' = 'Germany')) %>%
  mutate(score = Home.Team.Goals - Away.Team.Goals) %>%
  gather(Home_Away, Team_name, Home.Team.Name, Away.Team.Name) %>%
  mutate(result = ifelse(score==0,"D",ifelse((score>0 & Home_Away=="Home.Team.Name"),"W",ifelse((score<0 & Home_Away=="Away.Team.Name"),"W","L")))) %>%
  count(Team_name,result) %>%
  filter(result=="L") %>%
  top_n(10) %>%
  arrange(n, Team_name)



wcm_data3_D<- wcm_df %>%
  distinct(MatchID, .keep_all= TRUE) %>%
  select(MatchID, Home.Team.Name, Home.Team.Goals, Away.Team.Name, Away.Team.Goals, Win.conditions) %>%
  filter(!is.na(Home.Team.Name),!is.na(Home.Team.Goals),!is.na(Away.Team.Name),!is.na(Away.Team.Goals)) %>%
  mutate(Home.Team.Name = recode(Home.Team.Name, 'Germany FR' = 'Germany'),
         Away.Team.Name = recode(Away.Team.Name, 'Germany FR' = 'Germany')) %>%
  mutate(score = Home.Team.Goals - Away.Team.Goals) %>%
  gather(Home_Away, Team_name, Home.Team.Name, Away.Team.Name) %>%
  mutate(result = ifelse(score==0,"D",ifelse((score>0 & Home_Away=="Home.Team.Name"),"W",ifelse((score<0 & Home_Away=="Away.Team.Name"),"W","L")))) %>%
  count(Team_name,result) %>%
  filter(result=="D") %>%
  top_n(10) %>%
  arrange(n, Team_name)




function(input, output) {
  
  
  output$plot1 <- renderPlot({
    wordcloud(wc_win_wordcloud$Winner, wc_win_wordcloud$n, 
              max.words=100, random.order=FALSE, scale=c(5,0.5), 
              rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
  })
  

  
  output$plot2 <- renderPlot({
    wc_graph1 <- ggplot(wc_data, aes(x=factor(Winner,levels = Winner),y=(n/10),fill=Winner))
    wc_graph1 + geom_bar(stat="identity") +
      # label the title, x axis and y axis
      labs(x = "Winner", 
           y = "count") +
      theme_classic() + guides(fill=FALSE) + coord_flip() +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma,expand = c(0,0)) +
      scale_x_discrete(breaks = wc_data$Winner) +
      scale_color_viridis()
  })
  

  output$plot3 <- renderPlot({
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
  
  
  output$plot4 <- renderPlot({
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
  
  
  output$plot5 <- renderPlot({
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
  
  
  output$plot6 <- renderPlot({
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

  
  output$plot7 <- renderPlot({
    wcm_graph3_W <- ggplot(wcm_data3_W, aes(x=factor(Team_name, levels = Team_name),y=n, fill=n))
    wcm_graph3_W + geom_bar(stat="identity")+
      # label the title, x axis and y axis
      labs(x = "Team", 
           y = "count") +
      theme_classic() + coord_flip() +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma,expand = c(0,0)) +
      scale_fill_viridis("count")
  })
    
  
  output$plot8 <- renderPlot({
    wcm_graph3_L <- ggplot(wcm_data3_L, aes(x=factor(Team_name, levels = Team_name),y=n, fill=n))
    wcm_graph3_L + geom_bar(stat="identity")+
      # label the title, x axis and y axis
      labs(x = "Team", 
           y = "count") +
      theme_classic() + coord_flip() +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma,expand = c(0,0)) +
      scale_fill_viridis("count")
  })
    
  
  output$plot9 <- renderPlot({
    wcm_graph3_D <- ggplot(wcm_data3_D, aes(x=factor(Team_name, levels = Team_name),y=n, fill=n))
    wcm_graph3_D + geom_bar(stat="identity")+
      # label the title, x axis and y axis
      labs(x = "Team", 
           y = "count") +
      theme_classic() + coord_flip() +
      # change the label of y axis to numieric with comma
      scale_y_continuous(labels = scales::comma,expand = c(0,0)) +
      scale_fill_viridis("count")
  })
  
    
  output$data1 <- renderDT({
    DT::datatable(wc_raw, options = list(scrollX = TRUE))
  })
  
  
  output$data2 <- renderDT({
    DT::datatable(wcm_raw, options = list(scrollX = TRUE))
  })
  
  
  output$data3 <- renderDT({
    DT::datatable(wcp_raw, options = list(scrollX = TRUE))
  })
  
  
  output$map1 <- renderLeaflet({
    withProgress(value = 0, {
      wc_data2 <- wc_df %>%
        mutate(Year=as.character(Year),
               Year=as.factor(Year)) %>%
        separate(Country, c("Country_1", "Country_2"), sep="/") %>%
        gather(Country_dummy,Country,Country_1:Country_2) %>%
        select(Year, Country, Winner) %>%
        filter(!is.na(Year), !is.na(Country), !is.na(Winner)) %>%
        rowwise() %>%
        mutate(LatLng = getLatLngProg(str_replace_all(Country, " ","+"), nrow(Country))) %>%
        filter(LatLng!="error") %>%
        separate(LatLng, c("Lat", "Lng"), sep=",") %>%
        mutate(Lat=as.numeric(Lat), Lng=as.numeric(Lng))
      map <- leaflet(wc_data2, options = leafletOptions(minZoom = 2, maxZoom = 4)) %>%
        addTiles() %>%  
        addLabelOnlyMarkers (~Lng,~Lat, label = paste(sep = " ", wc_data2$Country, wc_data2$Year),
                             labelOptions = labelOptions(noHide = T))
    })
  })
  
  output$map2 <- renderLeaflet({
    withProgress(value = 0, {
      wcm_data2_m1 <- wcm_df %>% 
        filter(Year==input$selectyear) %>%
        distinct(Stadium, .keep_all= TRUE) %>%
        select(Year, Stadium, City) %>%
        rowwise() %>%
        mutate(LatLng = getLatLngProg(paste0(str_replace_all(Stadium, " ","+"),"+", str_replace_all(City, " ","+")), nrow(Stadium))) %>%
        filter(LatLng!="error") %>%
        separate(LatLng, c("Lat", "Lng"), sep=",") %>%
        mutate(Lat=as.numeric(Lat), Lng=as.numeric(Lng))
      if(dim(wcm_data2_m1)[1] != 0) {
        map <- leaflet(wcm_data2_m1, options = leafletOptions(minZoom = 4, maxZoom = 15)) %>%
          addTiles() %>%  
          addLabelOnlyMarkers (~Lng,~Lat, label = paste(sep = ", ", wcm_data2_m1$Stadium, wcm_data2_m1$City),
                               labelOptions = labelOptions(noHide = T))}
    })
  })
  
  
  output$year <- renderValueBox({
    valueBox(
      input$selectyear, ifelse(((input$selectyear!="1942") & (input$selectyear!="1946")), "Year", "World Cup not held because of the Second World War"), 
      icon = icon(name = "list-ul", class = "fas fa-list-ul"),
      color = "purple"
    )
  })
  

  output$country <- renderValueBox({
    wc_data_v1 <- wc_data1 %>%
      filter(Year==input$selectyear)
    valueBox(
      wc_data_v1$Country, "Host country", icon = icon(name = "globe", class = "fas fa-globe"),
      color = "purple"
    )
  })
  
  output$winner <- renderValueBox({
    wc_data_v1 <- wc_data1 %>%
      filter(Year==input$selectyear)
    
    valueBox(
      wc_data_v1$Winner, "Winner", icon = icon(name = "trophy", class = "fas fa-trophy"),
      color = "yellow"
    )
  })
  
  output$total_goal <- renderValueBox({
    wcm_data_v1 <- wcm_data1 %>%
      filter(Year==input$selectyear)
    
    valueBox(
      wcm_data_v1$Total_Score, "Total goals", icon = icon(name = "futbol", class = "fas fa-futbol"),
      color = "yellow"
    )
  })
  
  output$total_att <- renderValueBox({
    wcm_data_v1 <- wcm_data1 %>%
      filter(Year==input$selectyear)
    
    valueBox(
      wcm_data_v1$Total_Att, "Total Attendance", icon = icon(name = "users", class = "fas fa-users"),
      color = "blue"
    )
  })
  
  output$avg_att <- renderValueBox({
    wcm_data_v1 <- wcm_data1 %>%
      filter(Year==input$selectyear)
    
    valueBox(
      round(wcm_data_v1$Mean_Att), "Avg. Attendance", icon = icon(name = "users", class = "fas fa-users"),
      color = "blue"
    )
  })
    

  output$byyear_box <- renderUI({
    if (input$selectyear!=1942 & input$selectyear!=1946) 
      {
      fluidPage(
        
        fluidRow(
          valueBoxOutput("year"),
          valueBoxOutput("winner"), 
          valueBoxOutput("total_att")
        ),
        
        fluidRow(
          valueBoxOutput("country"),
          valueBoxOutput("total_goal"),
          valueBoxOutput("avg_att")
        ),
        
        fluidRow(
          # box(title= "Hosts Stadium",
          #     status = "info", solidHeader = TRUE, width = 12, height = 450,
          leafletOutput("map2")
        )
      )
    }
    else {
      fluidPage(
        fluidRow(
          valueBoxOutput("year")
        )
      )
    }
  })
  
  


  


}
