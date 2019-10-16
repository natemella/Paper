library(ReporteRs)
data(iris)
irisFT = FlexTable( iris )

vars <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
for (i in vars) {
  irisFT[iris[, i] < 3, i] = cellProperties( background.color = "orange" )
  irisFT[iris[, i] >= 3 & iris[, i] < 3.5, i] = cellProperties( background.color = "yellow" )
  irisFT[iris[, i] > 4, i] = cellProperties( background.color = "#81DAF5" )
}
