library(nlmixr2)
library(tidyverse)
library(xpose.nlmixr2)
library(xpose)


# read in the dataset from the repository and inspect graphically to inform on initial estimates for the parameters
df_repos <- read.csv()

df_repos %>% 
  ggplot()

#transform the dataset to nlmixr2 format: 
#  all numeric (e.g. CMT 1 for dosing, 2 for observed concentration)

df_repos_num <- df_repos %>% 
  mutate(CMT = ifelse(is.na(CMT), 2, ifelse(CMT == 'depot', 1, NA))) %>% 
  mutate(EVID = EVID + (100)) #EVID recording based on oral dose in cmt 1 (see nlmixr2 evid in tutorial)

#in case of ADDL and II columns (not recognized by nlmix2)

df_repos_dose <- df_repos_num %>% filter(CMT == 1) %>% 
  slice(rep(1:nrow(.), each = unique(ADDL) + 1)) %>% 
  mutate(TIME = rep(
    seq(
      unique(TIME), 
      unique(II) * unique(ADDL), 
      by = unique(II
      )),
    nrow(.)/(unique(ADDL) + 1)
  )
  )
#combine into fit dataset 

df_repos_fit <- df_repos_num %>% 
  filter(CMT != 1) %>% 
  bind_rows(df_repos_dose) %>% select(-II, -ADDL) %>% 
  arrange(ID, TIME, CMT)

#consider replacing NAs wiht 0
# df_repos_fit[is.na(df_repos_fit)] <- 0

# define the model structure similar to with rxode2
mod_est1 <- function() {
  
  #ini defines the (initial) values of the parmameters
  
  ini({
    # central 
    KA   =      
    tCL   =      
    eta.CL ~ 
    V2   =      
    # peripheral
    Q    =      
    V3   =      
    
    #RUV
    conc.sd = 
    
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


# fit1 <- nlmixr2(mod_est1, theo_sd, est = 'focei', foceiControl(print = 0))
fit1 <- nlmixr2(mod_est1, df_repos_fit, est = 'focei', foceiControl(print = 0))



#prepare diagnostics of the fit
xpdb <- xpose.nlmixr2::xpose_data_nlmixr2(obj = fit1)


xpose::ind_plots(xpdb)
xpose::dv_vs_pred(xpdb)
xpose::dv_vs_ipred(xpdb)
xpose::res_vs_idv(xpdb)
xpose::res_vs_pred(xpdb)
