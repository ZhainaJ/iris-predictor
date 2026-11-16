library(shiny)
library(MASS)

# Fit the model once, when the app starts
fit <- lda(Species ~ ., data = iris)
cols <- c(setosa = "#E69F00", versicolor = "#56B4E9", virginica = "#009E73")

shinyServer(function(input, output) {

  # The user's flower as a one-row data frame
  newFlower <- reactive({
    data.frame(Sepal.Length = input$sl, Sepal.Width = input$sw,
               Petal.Length = input$pl, Petal.Width = input$pw)
  })

  # Model prediction, recomputed whenever a slider moves
  pred <- reactive(predict(fit, newFlower()))

  output$prediction <- renderText({
    p <- pred()
    sprintf("Predicted species: %s (%.1f%% probability)",
            as.character(p$class), 100 * max(p$posterior))
  })

  output$probTable <- renderTable({
    data.frame(Species = colnames(pred()$posterior),
               `Probability (%)` = round(100 * as.numeric(pred()$posterior), 1),
               check.names = FALSE)
  })

  output$probPlot <- renderPlot({
    post <- 100 * pred()$posterior[1, ]
    par(mar = c(4, 7, 1, 1))
    barplot(post, horiz = TRUE, las = 1, col = cols[names(post)], xlim = c(0, 100),
            xlab = "Probability (%)")
  })

  output$scatter <- renderPlot({
    x <- input$xvar; y <- input$yvar
    nf <- newFlower()
    lab <- function(v) gsub("\\.", " ", v)
    xr <- range(iris[[x]], nf[[x]]); yr <- range(iris[[y]], nf[[y]])
    plot(NA, xlim = xr, ylim = yr, xlab = paste(lab(x), "(cm)"), ylab = paste(lab(y), "(cm)"))
    if (input$showAll)
      points(iris[[x]], iris[[y]], col = cols[iris$Species], pch = 19, cex = 1.2)
    points(nf[[x]], nf[[y]], pch = 8, cex = 3, lwd = 3)
    legend("topleft", c(names(cols), "Your flower"), col = c(cols, "black"),
           pch = c(19, 19, 19, 8), bty = "n")
  })
})
