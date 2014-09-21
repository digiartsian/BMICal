library(shiny)
shinyUI(fluidPage(

  titlePanel("Body Mass Index (BMI) Calculator"),
  h5('This calculator provides BMI and the corresponding BMI weight status category.'),
  sidebarPanel(
    h4('Please select your height and weight:'),
    radioButtons("unit","",c("Metric Units"="metric","Standard Units"="std")),
    conditionalPanel(
      condition = "input.unit == 'metric'",
      h3('Height'),
      sliderInput('hgt_m', 'Meters',value = 1.70, min = 1, max = 2, step = 0.01,),
      h3('Weight'),
      sliderInput('wgt_kg', 'Kilograms',value = 60, min = 10, max = 150, step = 1,)
    ),  
    conditionalPanel(
      condition = "input.unit == 'std'",
      h3('Height'),
      sliderInput('hgt_feet', 'Feet',value = 5, min = 3, max = 7, step = 1,),
      sliderInput('hgt_inch', 'Inches',value = 7, min = 0, max = 11, step = 1,),
      h3('Weight'),
      sliderInput('wgt_pd', 'Pounds',value = 130, min = 22, max = 330, step = 2,)
    ),
    br(),
    h4('Documentation'),
    h5('Step 1. Input'),
    p('Select Standard Or Metric as unit in radio button'),
    p('Use the slider to indicate your height and weight'),
    h5('Step 2. Ouput'),
    p('Result shows the BMI category you currently belong to'),
    h5('Formula'),
    p('BMI = Weight (in kg)/Height^2 (in m)'),
    code('w/(h*h)'),
    h5('BMI Categories'),
    p('Underweight = <18.5'),
    p('Normal weight = 18.5–24.9'),    
    p('Overweight = 25–29.9'),
    p('Obesity = BMI of 30 or greater'),
    p(''),
    h5("Reference:", a("CDC", href="http://www.cdc.gov/healthyweight/assessing/bmi/adult_bmi/index.html?s_cid=tw_ob064"))

  ),

  mainPanel(
    h3('BMI'),
    textOutput('bmi'),
    h3('BMI Category'),
    textOutput('category'),
    h3('Visualization'),
    plotOutput("mainPlot")
  )
))