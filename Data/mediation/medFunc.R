doEffectDecomp <- function(dat, ind = NULL, varlist)
{ 
  #############################################
  # This function is a modified version of 
  # Rochon, J., du Bois, A., & Lange, T. (2014). 
  # Mediation analysis of the relationship between 
  # institutional research activity and patient survival. 
  # BMC medical research methodology, 14(1), 9.
  #############################################
  # Comments at ehsan.karim@ubc.ca
  #############################################
  # Step 0: Replicate exposure variable, predict mediators 
  if (is.null(ind)) ind <- 1:nrow(dat)
  d <- dat[ind,] 
  # Varlist
  d$mediator <- ifelse(as.character(d$painmed) == "Yes", 1, 0)
  d$exposure <- ifelse(as.character(d$OA) == "OA", 1, 0)
  d$outcome <- ifelse(as.character(d$CVD) == "event", 1, 0)
  d$exposureTemp <- d$exposure
  w.design0 <- svydesign(id=~1, weights=~weight, 
                         data=d)
  w.design <- subset(w.design0, miss == 0)
  fit.m <- svyglm(as.formula(paste0(paste0("mediator ~ exposureTemp  + "), paste0(varlist, collapse = "+"))), 
                  design = w.design, 
                  family = quasibinomial("logit"))
  # summary(fit.m)
  
  # Steps 1 and 2: Replicate data with different exposures for mediator 
  d1 <- d2 <- d
  d1$exposure.counterfactual <- d1$exposure 
  d2$exposure.counterfactual <- !d2$exposure 
  newd <- rbind(d1, d2)
  newd <- newd[order(newd$ID), ]
  
  # Step 3: Compute weights for the mediation
  newd$exposureTemp <- newd$exposure
  w <- predict(fit.m, newdata=newd, type='response') 
  direct <- ifelse(newd$mediator, w, 1-w)
  newd$exposureTemp <- newd$exposure.counterfactual
  w <- predict(fit.m, newdata=newd, type='response') 
  indirect <- ifelse(newd$mediator, w, 1-w)
  newd$W.mediator <- indirect/direct
  summary(newd$W.mediator)
  
  # Step 4: Weighted outcome Model 
  #newd$S.w <- with(newd,(weight)/mean(weight))
  newd$S.w <- with(newd,weight)
  summary(newd$S.w)
  newd$SM.w <- with(newd,(W.mediator * S.w))
  newd$SM.w[is.na(newd$SM.w)] <- 0
  summary(newd$SM.w)
  w.design0 <- svydesign(id=~1, weights=~SM.w, 
                         data=newd)
  w.design <- subset(w.design0, miss == 0)
  fit <- svyglm(as.formula(paste0(paste0("outcome ~ exposure + exposure.counterfactual +"), 
                                  paste0(varlist, collapse = "+"))),
                design = w.design, 
                family = quasibinomial("logit"))
  
  # Return value: Estimates for total, direct, indirect effects
  TE <- exp(sum(coef(fit)[c('exposure', 'exposure.counterfactual')])) 
  DE <- exp(unname(coef(fit)['exposure']))
  IE <- exp(unname(coef(fit)[c('exposure.counterfactual')])) 
  PM <- log(IE) / log(TE)
  
  return(c(TE=TE, DE=DE, IE=IE, PM=PM))
}


doEffectDecomp.int <- function(dat, ind = NULL, varlist)
{ 
  #############################################
  # This function is a modified version of 
  # Rochon, J., du Bois, A., & Lange, T. (2014). 
  # Mediation analysis of the relationship between 
  # institutional research activity and patient survival. 
  # BMC medical research methodology, 14(1), 9.
  #############################################
  # Comments at ehsan.karim@ubc.ca
  #############################################
  # Step 0: Replicate exposure variable, predict mediators 
  if (is.null(ind)) ind <- 1:nrow(dat)
  d <- dat[ind,] 
  # d <- analytic2
  d$exposureTemp <- d$exposure
  w.design0 <- svydesign(id=~1, weights=~weight, 
                         data=d)
  w.design <- subset(w.design0, miss == 0)
  fit.m <- svyglm(as.formula(paste0(paste0("mediator ~ exposureTemp + phyact*diab +"), 
                                  paste0(varlist, collapse = "+"))),
                    design = w.design, 
                  family = quasibinomial("logit"))
  # summary(fit.m)
  
  # Steps 1 and 2: Replicate data with different exposures for mediator 
  d1 <- d2 <- d
  d1$exposure.counterfactual <- d1$exposure 
  d2$exposure.counterfactual <- !d2$exposure 
  newd <- rbind(d1, d2)
  newd <- newd[order(newd$ID), ]
  
  # Step 3: Compute weights for the mediation
  newd$exposureTemp <- newd$exposure
  w <- predict(fit.m, newdata=newd, type='response') 
  direct <- ifelse(newd$mediator, w, 1-w)
  newd$exposureTemp <- newd$exposure.counterfactual
  w <- predict(fit.m, newdata=newd, type='response') 
  indirect <- ifelse(newd$mediator, w, 1-w)
  newd$W.mediator <- indirect/direct
  summary(newd$W.mediator)
  
  # Step 4: Weighted outcome Model 
  # newd$S.w <- with(newd,(weight)/mean(weight))
  newd$S.w <- with(newd,weight)
  summary(newd$S.w)
  newd$SM.w <- with(newd,(W.mediator * S.w))
  newd$SM.w[is.na(newd$SM.w)] <- 0
  summary(newd$SM.w)
  w.design0 <- svydesign(id=~1, weights=~SM.w, 
                         data=newd)
  w.design <- subset(w.design0, miss == 0)
  fit <- svyglm(as.formula(paste0(paste0("outcome ~ exposure + exposure.counterfactual +"), 
                                    paste0(varlist, collapse = "+"))),
                design = w.design, 
                family = quasibinomial("logit"))
  
  # Return value: Estimates for total, direct, indirect effects
  TE <- exp(sum(coef(fit)[c('exposure', 'exposure.counterfactual')])) 
  DE <- exp(unname(coef(fit)['exposure']))
  IE <- exp(unname(coef(fit)[c('exposure.counterfactual')])) 
  PM <- log(IE) / log(TE)
  
  return(c(TE=TE, DE=DE, IE=IE, PM=PM))
}


