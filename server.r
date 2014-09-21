library(shiny)

BMIcompute <- function(unit,hgt_feet,hgt_inch,hgt_m,wgt_kg,wgt_pd){ 
   wgt <<- wgt_kg
   hgt <<- hgt_m
   if(unit=='std'){ 
      wgt <<- wgt_pd/2.204
      hgt <<- (hgt_feet*12+hgt_inch)*0.0254
   }
      BMIvalue <<- wgt/(hgt*hgt) 
}

shinyServer(
  function(input, output){ 
    bmiVal <- reactive({BMIcompute(input$unit,as.numeric(input$hgt_feet),as.numeric(input$hgt_inch),input$hgt_m,input$wgt_kg,input$wgt_pd)}) 
    output$bmi <- renderText({bmiVal()})
    observe({
      bmi <- bmiVal()
      if(bmi>=30)
        output$category <- renderText('Obese')
      else if(bmi>=25)
        output$category <- renderText('Overweight')
      else if(bmi>=18.5)
        output$category <- renderText('Normal weight')
      else
        output$category <- renderText('Underweight')

      h <- input$hgt_m
      if(input$unit=='std')
         h <- (as.numeric(input$hgt_feet)*12+as.numeric(input$hgt_inch))*0.0254
      
      ob = 30*h^2 
      ov = 25*h^2 
      no = 18.5*h^2
      w <- input$wgt_kg
      if(input$unit=='std'){ 
        w <- input$wgt_pd
        wgt_range <- 0:w*2
        bmi <- wgt_range/2.204/h^2    
        x_label = "Weight (pounds)"

        ob = ob*2.204
        ov = ov*2.204
        no = no*2.204
      }
      else{
        wgt_range <- 0:w*2
        bmi <- wgt_range/h^2
        x_label = "Weight (kg)"
      }
      ob = round(ob,2)
      ov = round(ov,2)
      no = round(no,2)  
      lower_bound = 0-w 
      upper_bound = 400 
      right_bound = w*3
      left_bound = -100 
      output$mainPlot <- renderPlot({    
        plot(wgt_range, bmi, xlab=x_label, ylab="BMI")
        # draw three vertical lines
        abline(v=ob, col="red")
        text(ob,0,ob)
        abline(v=ov, col="blue")
        text(ov,0,ov)
        abline(v=no, col="purple")
        text(no,0,no)
        rect(left_bound, lower_bound, no, upper_bound, col= '#FFFF66', border = "transparent")
        rect(no, lower_bound, ov, upper_bound, col= '#FFCC00', border = "transparent")
        rect(ov, lower_bound, ob, upper_bound, col= '#FF9900', border = "transparent")
        rect(ob, lower_bound, right_bound, upper_bound, col= '#FF0000', border = "transparent")
        y_val = round(BMIvalue,2)
        if(input$unit=='std')
          y_val = round(BMIvalue/2.204 ,2)
        label = paste('Your Position')
        text(w,y_val-5,label) # -5 to avoid overlap
        points(w,y_val, bg='green', pch=21, cex=3, lwd=3)
        label = paste('Normal')
        text(no+5,10,label) 
        label = paste('Underweight')
        text(no-15,0,label) 
        label = paste('Overweight')
        text(ov+5,15,label) 
        label = paste('Obese')
        text(ob+25,20,label) 
      })    
      
      })
    
  }  
)