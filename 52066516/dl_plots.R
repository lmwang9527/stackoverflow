library(shiny)
library(plotly)
library(webshot)

# dummy.df <- structure(list(
#   Tid = structure(
#     1:24, .Label = c("20180321-032-000001", 
#                      "20180321-032-000003", "20180321-032-000004", "20180321-032-000005", 
#                      "20180321-032-000006", "20180321-032-000007", "20180321-032-000008", 
#                      "20180321-032-000009", "20180321-032-000010", "20180321-032-000011", 
#                      "20180321-032-000012", "20180321-032-000013", "20180321-032-000014", 
#                      "20180321-032-000015", "20180321-032-000016", "20180321-032-000017", 
#                      "20180321-032-000018", "20180321-032-000020", "20180321-032-000021", 
#                      "20180321-032-000022", "20180321-032-000024", "20180321-032-000025", 
#                      "20180321-032-000026", "20180321-032-000027"), class = "factor"), 

dummy.df <- data.frame(
  Tid = 1:24,
  Measurand1 = c(4.1938661428, 4.2866076398, 4.2527368322, 
                 4.1653403962, 4.27242291066667, 4.16539040846667, 4.34047710253333, 
                 4.22442363773333, 4.19234076866667, 4.2468291332, 3.9844897884, 
                 4.22141039866667, 4.20227445513333, 4.33310654473333, 4.1927596214, 
                 4.15925140273333, 4.11148968806667, 4.08674611913333, 4.18821475666667, 
                 4.2206477116, 3.48470470453333, 4.2483107466, 4.209376197, 
                 4.04040350253333), 
  Measurand2 = c(240.457556634854, 248.218468503733, 
                 251.064523520989, 255.454918894609, 250.780599536337, 258.342398843477, 
                 252.343710644105, 249.881670507113, 254.937548700795, 257.252509533017, 
                 258.10699153634, 252.191362744656, 246.944795528771, 247.527116069484, 
                 261.060987461132, 257.770850218767, 259.844790397474, 243.046373553637, 
                 247.026385356368, 254.288899315579, 233.51454714355, 250.556819253509, 
                 255.8242909112, 254.938735944406), 
  Measurand3 = c(70.0613216684803, 
                 70.5004961457819, 70.8382322052776, 69.9282599322167, 68.3045749634227, 
                 71.5636835352475, 69.1173532716941, 71.3604764318073, 69.5045949393461, 
                 71.2211656142532, 72.5716638087178, 69.2085312787522, 70.7872214372161, 
                 70.7247180047809, 69.9466984209057, 71.8433220247599, 72.2055956743742, 
                 71.0348320947071, 69.3848050049961, 69.9884660785462, 73.160638501285, 
                 69.7524898841488, 71.1958302879424, 72.6060886025082))#, 
#  class = "data.frame", row.names = c(NA, 24L)
#)

# Define UI for application
ui <- fluidPage(
  titlePanel("Download Demo"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable",
                  label = "Plot Measurand",
                  choices = colnames(dummy.df)[2:11]
      ),
      hr(),
      downloadButton("downloadplot1", label = "Download plots")
    ),
    mainPanel(
      plotlyOutput("myplot1")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Output graph
  output$myplot1 <- renderPlotly({
    plot_ly(dummy.df, x = c(1:nrow(dummy.df)), y = ~get(input$variable), type = 'scatter',
            mode = 'markers') %>%
      layout(title = 'Values',
             xaxis = list(title = "Points", showgrid = TRUE, zeroline = FALSE),
             yaxis = list(title = input$variable, showgrid = TRUE, zeroline = FALSE))
  })
  
  # Creating plots individually and passing them as a list of parameters to RMD
  # Example for the first two measurands
  test.plot1 <- reactive({
    plot_ly(dummy.df, x = c(1:nrow(dummy.df)), y = ~Measurand1, type = 'scatter', mode = 'markers')
  })
  
  test.plot2 <- reactive({
    plot_ly(dummy.df, x = c(1:nrow(dummy.df)), y = ~Measurand2, type = 'scatter', mode = 'markers')
  }) 
  
  gather.plots <- reactive({
    list.of.measurands <- c("Measurand1", "Measurand2") #....all my measurands
    
    lapply(list.of.measurands, function(msrnd){
      plot_ly(dummy.df, x = c(1:nrow(dummy.df)), y = ~get(msrnd), type = 'scatter', mode = 'markers')
    })
  })
  
  output$downloadplot1 <-  downloadHandler(
    filename = "plots.pdf",
    content = function(file){
      
      tempReport <- file.path(tempdir(), "report1.Rmd")
      file.copy("download_content.Rmd", tempReport, overwrite = TRUE)
      
      list.of.measurands <- c("Measurand1", "Measurand2") #....all my measurands
      
      plots.gen <- lapply(list.of.measurands, function(msrnd){
        plot_ly(dummy.df, x = c(1:nrow(dummy.df)), y = ~get(msrnd), type = 'scatter', mode = 'markers')
      })
      
      params <- list(n = plots.gen)
      
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)