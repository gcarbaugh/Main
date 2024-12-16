library(shiny)
library(data.table)
library(DT)

# Function to calculate wheel circumference (in meters)
wheel_circumference <- function(diameter, tire_width) {
  pi * (diameter + 2 * (tire_width / 1000))
}

# Function to calculate speed (in mph)
calculate_speed <- function(circumference, teeth_front, teeth_rear, cadence) {
  circumference_km <- circumference / 1000  # Convert circumference to kilometers
  gear_ratio <- teeth_front / teeth_rear    # Calculate gear ratio
  speed_km_per_hr <- circumference_km * gear_ratio * cadence * 60  # Calculate speed in km/h
  speed_mph <- speed_km_per_hr * 0.621371  # Convert speed to mph
  return(round(speed_mph, 2))  # Round the speed to 2 decimal places
}

# Define UI
ui <- fluidPage(
  titlePanel("Cycling Speed Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("cadence", "Cadence Range (RPM):", min = 60, max = 110, value = c(60, 110), step = 5),
      numericInput("diameter", "Wheel Diameter (inches):", value = 27),
      numericInput("tireWidth", "Tire Width (mm):", value = 25),
      numericInput("teethFront", "Front Chainring Teeth:", min = 1, value = 53),
      numericInput("teethRear", "Rear Cog Teeth:", min = 1, value = 19)
    ),
    
    mainPanel(
      h3("Calculated Speeds (mph) for Various Cadences"),
      DT::DTOutput("speedTable")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$speedTable <- renderDataTable({
    # Convert inches to meters for wheel diameter
    diameter_m <- input$diameter * 0.0254
    # Convert tire width from mm to meters
    tireWidth_m <- input$tireWidth / 1000
    
    # Calculate wheel circumference
    circumference <- wheel_circumference(diameter_m, tireWidth_m)
    
    # Generate cadence sequence based on input
    cadences <- seq(input$cadence[1], input$cadence[2], by = 5)
    
    # Calculate speed for each cadence
    speeds <- sapply(cadences, function(cadence) calculate_speed(circumference, input$teethFront, input$teethRear, cadence))
    
    # Create a data table
    data_table <- data.table(Cadence = cadences, Speed_mph = speeds)
    
    # Return the data table
    data_table
  })
}

# Run the application
shinyApp(ui = ui, server = server)
