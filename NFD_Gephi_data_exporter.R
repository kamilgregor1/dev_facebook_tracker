# EXPORT OF NORMALIZED FACEBOOK DISTANCE DATA FOR GEPHI

# read the Rfacebook library

library(Rfacebook)

# generate an input file for Gephi

gephi <- e_xy$df
gephi <- merge(gephi,pg_pt[c("id","label")],by.x=c("x"),by.y=c("id"),all=F)
names(gephi) <- c("x","y","NFD","Source")
gephi <- merge(gephi,pg_pt[c("id","label")],by.x=c("y"),by.y=c("id"),all=F)
names(gephi) <- c("x","y","Weight","Source","Target")
gephi <- gephi[c("Source","Target","Weight")]

# write the input file for Gephi

cd <- paste0("write.csv(gephi,'",location,"gephi.csv',row.names=F)")
eval(parse(text = cd))

# save the workspace image

cd <- paste0("save.image('",location,"Gephi.RData')")
eval(parse(text = cd))