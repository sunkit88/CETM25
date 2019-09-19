# CETM25
UOS-CETM25
Ronald Cheng Man Kit

Dataset - FIFA World Cup
https://www.kaggle.com/abecklas/fifa-world-cup

Prototype demonstration
https://sunkit.shinyapps.io/CETM25/ 

If running the R code, belows packages needed to install first.
install.packages(c("shiny", "shinydashboard", "rsconnect", "DT", "tidyverse", "scales", "gmodels", "wesanderson", "viridis",                   "wordcloud", "RColorBrewer", "leaflet", "httr", "rjson"))                   
                   
Shiny Dashboard was strat by the command runApp() in the file app.R

In the main page, the left sidebar is the navigator bar, which including Overview with subtitle By Year and Data Sets.

Charts showing on the Overview page was:
The Wordcloud of Most successful teams - the teams who got more champions, the font size was bigger
next to the Wordcloud was the bar chart of the numbers of champions against the teams

At below was the map which marked the countries which have host the FIFA World cup.

And then the charts of the total attendance and the average attendance of each year

Following charts display the teams by the count of win, loss, and draw

At the bottom were the charts of total goals of each year and the boxplot showing the goals per match by years

By clicking on "By Year" at the sidebar, the dashboard page change to display the statistical information of each year with the map which marked the stadium's location. 

At the top which is a slider bar can select the year to view details information and there is a "PLAY" button to start the autoplay from year to year.

By clicking on "Data Sets" at the sidebar, the dashboard page change to three tag pages to display the raw data which download from Kaggle.
