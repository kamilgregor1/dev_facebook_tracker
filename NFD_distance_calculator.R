# CALCULATOR OF NORMALIZED FACEBOOK DISTANCE

# read the Rfacebook library

library(Rfacebook)

# create environments for data

e_xy <- new.env()  # an environment for NFD margins

# set parameters

location <- "C:/Users/NB/Desktop/NFD/use case/"
e_pr$M <- 3700000

# calculate NFD for every pair of pages

e_xy$df <- data.frame(t(rep(NA, 3)))
names(e_xy$df) <- c("x", "y", "NFD")

e_xy$proviz <- data.frame(t(rep(NA, 3)))
names(e_xy$proviz) <- c("x", "y", "NFD")

for (i in pg_us$id) {
  for (j in pg_us$id) {
    
    cd <- paste0("e_xy$us_i <- data.frame(unique(e_us$us_", i,"$user_id))")
    eval(parse(text = cd))
    cd <- paste0("colnames(e_xy$us_i)[1]<-'user_id'")
    eval(parse(text = cd))
    cd <- paste0("e_xy$us_j <- data.frame(unique(e_us$us_", j,"$user_id))")
    eval(parse(text = cd))
    cd <- paste0("colnames(e_xy$us_j)[1]<-'user_id'")
    eval(parse(text = cd))    
    cd <- paste0("e_xy$x <- nrow(e_xy$us_i)")
    eval(parse(text = cd))
    cd <- paste0("e_xy$y <- nrow(e_xy$us_j)")
    eval(parse(text = cd))
    e_xy$xy <- nrow(merge(e_xy$us_i,e_xy$us_j,by=c("user_id")))
    
    e_xy$NFD <- (max(log10(e_xy$x), log10(e_xy$y)) - log10(e_xy$xy))/(log10(e_pr$M) - 
      min(log10(e_xy$x), log10(e_xy$y)))
    
    cd <- paste0("e_xy$proviz[1,1] <- '", i, "'")
    eval(parse(text = cd))
    cd <- paste0("e_xy$proviz[1,2] <- '", j, "'")
    eval(parse(text = cd))
    e_xy$proviz[1, 3] <- e_xy$NFD
    
    e_xy$df <- rbind(e_xy$df, e_xy$proviz)
    
  }
}

e_xy$df <- na.omit(e_xy$df)
max <- e_xy$df[-which(e_xy$df$NFD=="Inf"),]
max <- max(max$NFD)
e_xy$df$NFD <- ifelse(is.infinite(e_xy$df$NFD)=="TRUE",max,e_xy$df$NFD)

rm(max)
rm(cd)
rm(i)
rm(j)

# diagnostics of distances

diag_nfd <- data.frame(t(rep(NA, 3)))
names(diag_nfd) <- c("id","min","max")

for (i in pg_us$id) {
  
  diag_proviz <- data.frame(i)
  names(diag_proviz) <- "id"
  df_proviz <- e_xy$df
  df_proviz <- df_proviz[which(df_proviz$x==i),]
  diag_proviz$min <- min(df_proviz$NFD)
  diag_proviz$max <- max(df_proviz$NFD)
  diag_nfd <- rbind(diag_nfd,diag_proviz)
  rm(diag_proviz)
  rm(df_proviz)
  
}

diag_nfd <- na.omit(diag_nfd)
diag_nfd <- diag_nfd[order(diag_nfd$max),]

# save the workspace image

cd <- paste0("save.image('",location,"distances.RData')")
eval(parse(text = cd))