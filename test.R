# model 1 PK-PD #
# 2 compartments # 
# Kin Kout PD #

library(rxode2)
library(tidyverse)


mod1 <- function() {
  
  #ini defines the (initial) values of the parmameters
  
  ini({
    # central 
      KA   =  c(0.1,0,1)     #[0.1-1]
      CL   =  c(1,0,10)      #[1-10] 
      V2   =  c(10,0,50)      #[10-50]
      # peripheral
      Q    =  c(1,0,10)     #[1-10]
      V3   =  c(50,0,500)     #[50-500]
      # effects
      Kin  =   c(0.5,0,2)    #[0.5-2]
      Kout =   c(0.5,0,2)   #[0.5-2]
      EC50 =   0    #[] -> depends on your PK!
  })
  
  #model defines the structure and start values (initalization) of the compartments (0 if undefined)
  
  model({
    
    #variables for the differential equations can be defined here 
    #(define them before the equations or you will get an error)
    
    ke  <- CL/V2
    k12 <- Q/V2 
    k21 <- Q/V3
    C <- centr/V2
    
    #differential equations PK
    d/dt(depot) <- -KA*depot
    d/dt(centr) <- KA*depot - ke * centr - k12 * centr + k21*peri
    d/dt(peri)  <- k12 * centr - k21*peri
    
    #differential equation PD
    d/dt(eff)   <- Kin - Kout*(1-C/(EC50+C))*eff
    
    #initialization of the effect (PD) compartment
    eff(0) <- 1
    
  })
}


mod1 <- mod1() 

#inspect the ui by running it, or by summary()
mod1
summary(mod1$simulationModel)

ev  <-  et( #first defined doses 
  amt  = 1000,   #mg
  addl = 13,    #number of additional (addL) doses
  ii   = 12,    #interdose interval (ii) h
  cmt  = "depot", #define the compartment corresponding to your mod1 code
  evid = 1      #event id (evid) 1 means a dosing record
) %>%  
  #then define sampling 
  et(0:240, 
     evid = 0      #event id (evid) 0 means an observation record
  )# Add sampling 
df_output <- mod1 %>% rxSolve(ev)

# Now plot your outpout using ggplot 

df_output %>% 
  ggplot()