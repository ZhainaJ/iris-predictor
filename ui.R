library(shiny)

features <- c("Sepal Length" = "Sepal.Length", "Sepal Width" = "Sepal.Width",
              "Petal Length" = "Petal.Length", "Petal Width" = "Petal.Width")

shinyUI(fluidPage(
  titlePanel("Iris Species Predictor & Explorer"),

  sidebarLayout(
    sidebarPanel(
      h4("1. Enter flower measurements (cm)"),
      sliderInput("sl", "Sepal length", min = 4.0, max = 8.0, value = 5.8, step = 0.1),
      sliderInput("sw", "Sepal width",  min = 2.0, max = 4.5, value = 3.0, step = 0.1),
      sliderInput("pl", "Petal length", min = 1.0, max = 7.0, value = 4.3, step = 0.1),
      sliderInput("pw", "Petal width",  min = 0.1, max = 2.5, value = 1.3, step = 0.1),
      hr(),
      h4("2. Choose plot axes"),
      selectInput("xvar", "X axis", choices = features, selected = "Petal.Length"),
      selectInput("yvar", "Y axis", choices = features, selected = "Petal.Width"),
      checkboxInput("showAll", "Show all 150 flowers on the plot", value = TRUE)
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Prediction",
          br(),
          h3(textOutput("prediction")),
          p("Probability of each species, from a Linear Discriminant Analysis model fitted to the iris data:"),
          tableOutput("probTable"),
          plotOutput("probPlot", height = "250px")
        ),
        tabPanel("Explore",
          br(),
          p("Your flower is the black star. Colored points are the 150 flowers in the iris data."),
          plotOutput("scatter", height = "450px")
        ),
        tabPanel("Documentation & Help",
          br(),
          h3("What this app does"),
          p("It predicts the species of an iris flower (setosa, versicolor or virginica)",
            "from four measurements, and shows where your flower sits among the 150 flowers",
            "of Edgar Anderson's classic iris data set."),
          h3("How to use it"),
          tags$ol(
            tags$li("Move the four sliders on the left to your flower's sepal and petal",
                    "length and width, in centimetres."),
            tags$li("Open the ", strong("Prediction"), " tab: the predicted species and the",
                    "probability for each species update instantly."),
            tags$li("Open the ", strong("Explore"), " tab and pick any two measurements for",
                    "the X and Y axes to see how the species separate. Untick the checkbox",
                    "to show only your flower.")
          ),
          h3("How the prediction works"),
          p("The server fits a Linear Discriminant Analysis model (", code("MASS::lda"),
            ") on all four measurements once when the app starts. Each time you move a",
            "slider, it calls ", code("predict()"), " on your values and returns the",
            "posterior probability of each species."),
          h3("Tips"),
          tags$ul(
            tags$li("Petal measurements matter most: small petals (under 2 cm long) are almost always setosa."),
            tags$li("Measurements far outside the slider ranges are outside the data, so predictions there are unreliable.")
          )
        )
      )
    )
  )
))
