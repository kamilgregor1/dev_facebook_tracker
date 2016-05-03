# RETRIEVAL OF ALL POSTS FROM A LIST OF FACEBOOK PAGES IN A TIME PERIOD

# read the Rfacebook library

library(Rfacebook)

# create environments for data

e_pr <- new.env()  # an environment for parameters
e_pt <- new.env()  # an environment for lists of posts

# set parameters

location <- "C:/Users/NB/Desktop/"
e_pr$tk <- "458515980970791|WLwRW5waE3JNH55v10XaH2aY9yY"  # a Facebook API token
#e_pt$tk <- "CAACEdEose0cBAFuAmGd3MKHCiA7j9720aPKEJlMPaT9YQZC6MvoHhNi6VRN7WhZCENyNXHVPuvZByFHPxRcdOdCM0hZCe3UiScT9szEfDZCYKuZB5HAZANLm0axIxackZA9cSKSVVPAfAg4PyZC1UdBgiCZCYLEZB3g2noE2JPiVYuynTyngJtBxA4kkaokLEdVuYAFwlZBLSdGsNOERwhEKvXoG"
e_pr$sn <- "2016-04-20"
e_pr$un <- "2016-05-01"

# set a working directory

setwd(location)

# convert parameters to dates

e_pr$sn <- as.Date(e_pr$sn)
e_pr$un <- as.Date(e_pr$un)

# crate sub-directories

dir.create("data")
dir.create("data/posts")

# input a list of pages (must contain a column 'id' with IDs of pages)

cd <- paste0("pg_pt <- read.delim('",location,"pages.txt')")
eval(parse(text = cd))

# get posts from every page in 'pg_pt'

for (i in 1:nrow(pg_pt)) {
    
  for (j in 1:(e_pr$un-e_pr$sn)) {
  
    print(paste0("Getting posts from '",pg_pt[i,1],"': ",(e_pr$sn-1)+j))
    
  tryCatch({
    
    cd <- paste0("e_pt$pt_proviz <- getPage('",pg_pt[i,4], "', token = e_pr$tk, since = '",(e_pr$sn-1)+j,"', until = '",e_pr$sn+j,"')")
    eval(parse(text = cd))
    
    if (j == 1) {
      
      cd <- paste0("e_pt$pt_",pg_pt[i,2]," <- e_pt$pt_proviz")
      eval(parse(text = cd))
      
    } else {
      
      cd <- paste0("e_pt$pt_",pg_pt[i,2]," <- rbind(e_pt$pt_",pg_pt[i,2],",e_pt$pt_proviz)")
      eval(parse(text = cd))
      
    } # if (i == 1)
    
    rm(pt_proviz, envir = e_pt)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  } # for (j in 1:(until-since))
    
  cd <- paste0("write.csv(e_pt$pt_",pg_pt[i,2],",'",location,"data/posts/posts_",pg_pt[i,2],".csv',row.names=F)")
  eval(parse(text = cd))
  
  cd <- paste0("save.image('",location,"data/posts/posts.RData')")
  eval(parse(text = cd))
  
} # for (i in 1:nrow(pg_pt$id))

# diagnostics of lists of posts

diag_pt <- data.frame(t(rep(NA,5)))
names(diag_pt) <- c("id","first","last","posts","likes")

for (i in 1:nrow(pg_pt)) {
  
  tryCatch({
    
    cd <- paste0("diag_proviz <- data.frame('",pg_pt[i,2],"')")
    eval(parse(text = cd))
    names(diag_proviz) <- "id"
    cd <- paste0("diag_proviz$first <- min(e_pt$pt_",pg_pt[i,2],"$created_time)")
    eval(parse(text = cd))
    cd <- paste0("diag_proviz$last <- max(e_pt$pt_",pg_pt[i,2],"$created_time)")
    eval(parse(text = cd))
    cd <- paste0("diag_proviz$posts <- nrow(e_pt$pt_",pg_pt[i,2],")")
    eval(parse(text = cd))
    cd <- paste0("diag_proviz$likes <- sum(e_pt$pt_",pg_pt[i,2],"$likes)")
    eval(parse(text = cd))
    
    diag_pt <- rbind(diag_pt,diag_proviz)
    
    rm(diag_proviz)
        
        
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })

}

diag_pt <- na.omit(diag_pt)
diag_pt$days <- as.Date(as.character(diag_pt$last), format="%Y-%m-%d")-as.Date(as.character(diag_pt$first), format="%Y-%m-%d")
diag_pt$days <- as.numeric(diag_pt$days)
diag_pt$pt_per_day <- diag_pt$posts/diag_pt$days
diag_pt <- diag_pt[order(diag_pt$posts),]

# save the workspace image

cd <- paste0("save.image('",location,"data/posts/posts.RData')")
eval(parse(text = cd))