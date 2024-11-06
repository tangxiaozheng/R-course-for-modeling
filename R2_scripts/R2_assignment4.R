library(nlmixr2)
library(tidyverse)
library(xpose.nlmixr2)
library(xpose)


# inspect the dataset graphically to inform on initial estimates for the parameters

theo_sd %>% 
  ggplot(aes(TIME, DV)) + geom_point() + geom_line(aes(group = ID)) + scale_y_log10()


# define the model structure similar to with rxode2
mod_est1 <- function() {
  
  #ini defines the (initial) values of the parmameters
  
  ini({
    # central 
    tKA   =      #[0.1-1]
    tCL   =     #[1-10] 
    tV   =      #[10-50]
    eta.KA ~ 
    eta.CL ~ 
    eta.V ~ 
    
    #RUV
    add.sd = 
    
  })
  
  #model defines the structure and start values (initalization) of the compartments (0 if undefined)
  
  model({
    
    #variables for the differential equations can be defined here 
    #(define them before the equations or you will get an error)
    
    ka <- tKA *exp(eta.KA)
    cl <- tCL *exp(eta.CL)
    v <- tV *exp(eta.V)
    linCmt() ~ add(add.sd)

    #bonus: instead of using the linCmt function, use differential equations (check init.est)
    # ke  <- cl/v
    #differential equations PK
    #d/dt(depot) <- -ka*depot
    #d/dt(centr) <- ka*depot - ke * centr
    # C <- centr/V
    # C ~ add(add.sd)
    
  })
}


fit1 <- nlmixr2(mod_est1, theo_sd, est = 'focei', foceiControl(print = 0))
# fit1 <- nlmixr2(mod_est1, theo_sd, est = 'saem', saemControl(print = 0))



#prepare diagnostics of the fit
xpdb <- xpose.nlmixr2::xpose_data_nlmixr2(obj = fit1)

#goodness of fit
xpose::dv_vs_pred(xpdb)
xpose::dv_vs_ipred(xpdb)
xpose::res_vs_idv(xpdb)
xpose::res_vs_pred(xpdb)

#individual fits 
xpose::ind_plots(xpdb)

