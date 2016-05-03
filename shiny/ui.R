# ui.R
shinyUI(pageWithSidebar(
  headerPanel("Example 1: scatter chart"),
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("rock", "pressure", "cars"))
  ),
  mainPanel(
    htmlOutput("view")
  )
))