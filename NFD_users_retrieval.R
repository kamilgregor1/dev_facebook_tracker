# RETRIEVAL OF ALL ACTIVE USERS OF ALL POSTS FROM A LIST OF FACEBOOK PAGES IN A TIME PERIOD

# read the Rfacebook library

library(Rfacebook)

# create environments for data

e_us <- new.env()  # an environment for active users

# crate sub-directories

dir.create("data/users")

# get rid of all types of posts except "link", "status" and "photo" as they cause errors when getting lists of users

for (i in 1:nrow(pg_pt)) {
  
  cd <- paste0("e_pt$pt_",pg_pt[i,2], " <- e_pt$pt_",pg_pt[i,2],"[which(e_pt$pt_",pg_pt[i,2],"$type=='link'|e_pt$pt_",pg_pt[i,2],"$type=='status'|e_pt$pt_",pg_pt[i,2],"$type=='photo'),]")
  eval(parse(text = cd))
  
}

# get a list of pages with more than one post in the selected period of time

pg_us <- data.frame(t(rep(NA,3)))
names(pg_us) <- c("name","posts","likes")

for (i in 1:nrow(pg_pt)) {
  
  pg_proviz <- data.frame(pg_pt[i,2])
  names(pg_proviz) <- "name"
  cd <- paste0("pg_proviz$posts <- nrow(e_pt$pt_",pg_pt[i,2],")")
  eval(parse(text = cd))
  cd <- paste0("pg_proviz$likes <- sum(e_pt$pt_",pg_pt[i,2],"$likes)")
  eval(parse(text = cd))
  
  pg_us <- rbind(pg_us,pg_proviz)
  rm(pg_proviz)
    
}

pg_us <- na.omit(pg_us)
pg_us <- merge(pg_pt[c("id","page","name")],pg_us,by=c("name"),all=F)
pg_us <- pg_us[which(pg_us$post >0),]
pg_us <- pg_us[order(pg_us$likes),]

# get lists of users of pages in 'pg_us'

diag_us <- data.frame(t(rep(NA,5)))
names(diag_us) <- c("name","start","end","posts","likes")

for (i in 1:nrow(pg_us)) {
  
  tryCatch({
    
    diag_proviz <- data.frame(pg_us[i,1])
    names(diag_proviz) <- "name"
     
  cd <- paste0("pt_i <- data.frame(e_pt$pt_", pg_us[i,1], "$id)")
  eval(parse(text = cd))
  colnames(pt_i)[1] <- "post_id" 
  us <- data.frame(t(rep(NA, 3)))
  names(us) <- c("user_id", "type", "post_id")
  
  diag_proviz$start <- as.character(Sys.time())
  
  for (j in 1:nrow(pt_i)) {
    
    print(paste0("Getting users from '",pg_us[i,3],"': ",j,"/",nrow(pt_i)," posts"))
    
    tryCatch({
    
      cd <- paste0("pt <- getPost('", pt_i[j,1], "',token = e_pr$tk,n=1000000,comments=F,likes=T)")
      eval(parse(text = cd))
    
      lk<-data.frame(pt$likes$from_id)
      colnames(lk)[1]<-'user_id'
      lk$type<-'like'
      lk$post_id<-pt_i[j,1]
      
    us <- rbind(us, lk)
    cd <- paste0("e_us$us_", pg_us[i,1], " <- data.frame(na.omit(us))")
    eval(parse(text = cd))
    cd <- paste0("names(e_us$us_", pg_us[i,1], ")<-c('user_id','type','post_id')")
    eval(parse(text = cd))
    
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
        
  } # for (j in pt_i$post_id)
  
  diag_proviz$end <- as.character(Sys.time())
  cd <- paste0("diag_proviz$posts <- length(unique(e_us$us_",pg_us[i,1],"$post_id))")
  eval(parse(text = cd))
  cd <- paste0("diag_proviz$likes <- nrow(e_us$us_",pg_us[i,1],"[which(e_us$us_",pg_us[i,1],"$type=='like'),])")
  eval(parse(text = cd))
  
  diag_us <- rbind(diag_us,diag_proviz)
  
  rm(diag_proviz)
  
  cd <- paste0("write.csv(e_us$us_",pg_us[i,1],",'",location,"data/users/users_",pg_us[i,1],".csv',row.names=F)")
  eval(parse(text = cd))
  
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
} # for (i in pg_us$name)

diag_us <- na.omit(diag_us)
diag_us <- merge(pg_us[c("id","page","name")],diag_us,by=c("name"),all=T)

rm(i)
rm(j)
rm(cd)
rm(lk)
rm(pt)
rm(pt_i)
rm(us)

# diagnostics of how many posts failed to retrieve likes

diag_us_done <- merge(pg_pt[c("id","name","label","page")],pg_us[c("id","posts","likes")],by=c("id"),all=F)
names(diag_us_done) <- c("id","name","label","page","posts_orig","likes_orig")
diag_us_done <- merge(diag_us_done,diag_us[c("id","posts","likes")],by=c("id"),all=F)
names(diag_us_done) <- c("id","name","label","page","posts_orig","likes_orig","posts_done","likes_done")
diag_us_done$posts_share <- diag_us_done$posts_done/diag_us_done$posts_orig
diag_us_done$likes_share <- diag_us_done$likes_done/diag_us_done$likes_orig

# save the workspace image

cd <- paste0("save.image('",location,"data/users/users.RData')")
eval(parse(text = cd))