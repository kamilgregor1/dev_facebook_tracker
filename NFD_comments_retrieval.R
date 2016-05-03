# RETRIEVAL OF ALL COMMENTS ON ALL POSTS FROM A LIST OF FACEBOOK PAGES IN A TIME PERIOD

# read the Rfacebook library

library(Rfacebook)

# create environments for data

e_ct <- new.env()  # an environment for comments

# crate sub-directories

dir.create("data/comments")

# get comments on posts of pages in 'pg'

for (i in 1:nrow(pg_pt)) {
  
  cd <- paste0("pt_i <- data.frame(e_pt$pt_", pg_pt[i,2], "$id)")
  eval(parse(text = cd))
  
  colnames(pt_i)[1] <- "post_id" 
  
  for (j in 1:nrow(pt_i)) {
    
    print(paste0("Getting comments from '",pg_us[i,3],"': ",j,"/",nrow(pt_i)," posts"))
        
    tryCatch({
      
      cd <- paste0("pt <- getPost('", pt_i[j,1], "',token = e_pr$tk,n=1000000,comments=T,likes=F)")
      eval(parse(text = cd))
      
      posts <- pt$post
      comments <- pt$comments
      
      comments$post_from_id <- posts$from_id
      comments$post_from_name <- posts$from_name
      comments$post_message <- posts$message
      comments$post_created_time <- posts$created_time
      comments$post_type <- posts$type
      comments$post_link <- posts$link
      comments$post_id <- posts$id
      comments$post_likes_count <- posts$likes_count
      comments$post_comments_count <- posts$comments_count
      comments$post_shares_count <- posts$shares_count
      
      rm(posts)
      
      if (j == 1) {
        
        cd <- paste0("e_ct$ct_", pg_pt[i,2], " <- comments")
        eval(parse(text = cd))
        
      } else {
        
        cd <- paste0("e_ct$ct_", pg_pt[i,2], " <- rbind(e_ct$ct_", pg_pt[i,2], ",comments)")
        eval(parse(text = cd))
        
      } # if (j == 1)
    
      rm(comments)
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
            
  } # for (j in 1:nrow(pt_i))
  
  cd <- paste0("write.csv(e_ct$ct_",pg_pt[i,1],",'",location,"data/comments/comments_",pg_us[i,1],".csv',row.names=F)")
  eval(parse(text = cd))
  
} # for (i in 1:nrow(pg_pt))

rm(cd)
rm(i)
rm(j)
rm(pt)
rm(pt_i)

# save the workspace image

cd <- paste0("save.image('",location,"data/comments/comments.RData')")
eval(parse(text = cd))