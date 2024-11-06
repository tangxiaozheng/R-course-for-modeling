library(rxode2)
library(tidyverse)

#create the model file mod1 containing the model structure, parameters, and initalization

set.seed(1234)
rxSetSeed(1234)

mod2 <- function() {
  
  #ini defines the (initial) values of the parmameters
  
  ini({
    # central 
    KA   =        #[0.1-1]
    tCL  =        #[1-10] 
    eta.CL ~ 0.3^2
    V2   =        #[10-50]
    # peripheral
    Q    =        #[1-10]
    V3   =        #[50-500]

    #RUV
    conc.sd = 0.15^2

  })
  
  #model defines the structure and start values (initalization) of the compartments (0 if undefined)
  
  model({
    
    #variables for the differential equations can be defined here 
    #(define them before the equations or you will get an error)
    
    CL <- tCL *exp(eta.CL)
    ke  <- CL/V2
    k12 <- Q/V2 
    k21 <- Q/V3
    C <- centr/V2
    
    #differential equations PK
    d/dt(depot) <- -KA*depot
    d/dt(centr) <- KA*depot - ke * centr - k12 * centr + k21*peri
    d/dt(peri)  <- k12 * centr - k21*peri

    C ~ prop(conc.sd)
    
  })
}

mod2 <- mod2() # create the ui object (can also use `rxode2(mod1)`)


#last thing we need is the table with doses and sampling times 

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

# Run the model
df_output2 <-  rxSolve(mod2, ev, nSub = ) 


# Now plot your outpout using ggplot 

df_output2 %>% 
  ggplot()


# And prepare your dataset by joining the output with the dosing information
# tip1: get the dosing information by filtering the ev data for evid==1, and select time, cmt, and dosing information)
# tip2: join the df_output and the dosing information, make sure dosing is available for all IDs
# tip3: order the dataset by id, time, and make sure the dose comes before the sampling


df_dose_repos <- ev %>% 
  filter(evid == 1) %>% 
  select(ID = id,
         TIME = time,
         EVID = evid,
         CMT = cmt, 
         AMT = amt, 
         [other dosing variables, capitalize them]
         ) 

df_repos <- [combine df_output2 and df_dose_repos]





# Write out your dataset as csv (withour row numbers and quotes)


