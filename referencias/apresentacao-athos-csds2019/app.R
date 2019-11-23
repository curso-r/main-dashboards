library(shiny)
library(shinydashboard)
library(randomForest)
library(xgboost)
library(caret)
library(tidyverse)

lm_iris <- readRDS("lm_iris.rds")
rf_iris <- readRDS("rf_iris.rds")
xgb_iris <- readRDS("xgb_iris.rds")

ui <- dashboardPage(
  dashboardHeader(title = "Iris Predictor"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Calculator", tabName = "calc", icon = icon("calculator")),
      menuItem("Descriptive", tabName = "desc", icon = icon("chart-bar"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "calc", 
        h3("Prediction of Sepal.Width from iris dataset"),
        fluidRow(
          valueBoxOutput("lm_predict"),
          valueBoxOutput("rf_predict"),
          valueBoxOutput("xgb_predict")
        ),
        fluidRow(
          box(
            title = "Features",
            width = 4,
            height = 483,
            sliderInput("Sepal.Length", "Sepal.Length: ", min = min(iris$Sepal.Length), max = max(iris$Sepal.Length), value = mean(iris$Sepal.Length)),
            sliderInput("Petal.Length", "Petal.Length: ", min = min(iris$Petal.Length), max = max(iris$Petal.Length), value = mean(iris$Petal.Length)),
            sliderInput("Petal.Width", "Petal.Width: ", min = min(iris$Petal.Width), max = max(iris$Petal.Width), value = mean(iris$Petal.Width)),
            selectInput("Species", "Species: ", choices = unique(iris$Species))
          ),
          box(
            title = "Sense of extrapolation (usin PCA)",
            width = 8,
            plotOutput("pca")
          )
        )
      ),
      tabItem(
        tabName = "desc",
        fluidRow(
          infoBox(title = "Dataset", value = "Iris", width = 3),
          infoBox(title = "#rows", value = nrow(iris), width = 3),
          infoBox(title = "#features", value = ncol(iris) - 1, width = 3),
          infoBox(title = "Target", value = "Sepal.Width", width = 3, color = "green")
        ),
        fluidRow(
          column(
            width = 6,
            tabBox(
              title = "Densities",
              width = 12,
              height = 450,
              tabPanel("Sepal.Length", plotOutput("Sepal.Length_hist")),
              tabPanel("Sepal.Width",  plotOutput("Sepal.Width_hist")),
              tabPanel("Petal.Length", plotOutput("Petal.Length_hist")),
              tabPanel("Petal.Width",  plotOutput("Petal.Width_hist"))
            ),
            box(
              title = "Scatterplot Matrix",
              width = 12,
              plotOutput("ggpairs")
            )
          ),
          
          box(
            width = 6,
            dataTableOutput("iris_dt")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  novo_dado <- reactive({
    data.frame(
      Sepal.Length = input$Sepal.Length,
      Petal.Length = input$Petal.Length,
      Petal.Width  = input$Petal.Width,
      Species = input$Species
    )
  })
  
  output$lm_predict <- renderValueBox({
    pred <- round(predict(lm_iris, novo_dado()), 2)
    valueBox(pred, "Linear Regression")
  })
  
  output$rf_predict <- renderValueBox({
    pred <- round(predict(rf_iris, novo_dado()), 2)
    valueBox(pred, "Random Forest", color = "orange")
  })
  
  output$xgb_predict <- renderValueBox({
    pred <- round(predict(xgb_iris, novo_dado()), 2)
    valueBox(pred, "XGBoost", color = "purple")
  })
  
  output$pca <- renderPlot({
    iris_filtered <- iris %>% filter(Species == input$Species)
    pca <- princomp(~ Sepal.Length + Petal.Length + Petal.Width, data = iris_filtered)
    pca_iris <- predict(pca, iris_filtered) %>% as.data.frame()
    pca_novo_dado <- predict(pca, novo_dado()) %>% as.data.frame()
    
    pca_iris %>%
      ggplot(aes(x = Comp.1, y = Comp.2)) +
      geom_point(colour = "grey70") +
      geom_point(colour = "red", size = 5, data = pca_novo_dado)
  })
  
  output$iris_dt <- renderDataTable({
    iris
  })
  
  
  output$Sepal.Length_hist <- renderPlot({ggplot(iris) + geom_density(aes(x = Sepal.Length, fill = Species), alpha = 0.4)})
  output$Sepal.Width_hist <- renderPlot({ggplot(iris) + geom_density(aes(x = Sepal.Width, fill = Species), alpha = 0.4)})
  output$Petal.Length_hist <- renderPlot({ggplot(iris) + geom_density(aes(x = Petal.Length, fill = Species), alpha = 0.4)})
  output$Petal.Width_hist <- renderPlot({ggplot(iris) + geom_density(aes(x = Petal.Width, fill = Species), alpha = 0.4)})

  output$ggpairs <- renderPlot({
    GGally::ggpairs(iris, aes(colour = Species))
  }) 
}

shinyApp(ui, server)