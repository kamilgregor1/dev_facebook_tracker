# VISUALIZATION OF NORMALIZED FACEBOOK DISTANCE USING MULTIDIMENSIONAL SCALLING (MDS)

# read the Rfacebook library

library(Rfacebook)

# create environments for data

e_mds <- new.env()  # an environment for MDS visualization

# set parameters

location <- "C:/Users/NB/Desktop/NFD/use case/"

e_mds$lg <- "cs"

e_mds$mn_cs <- "Politické strany na Facebooku"
e_mds$mn_en <- "Czech political parties on Facebook"
e_mds$sb_cs <- paste0("Graf ukazuje blízkost zobrazených subjektù na základì prùniku aktivních fanouškù na jejich facebookových stránkách. Použitou metrikou \nje Normalized Facebook Distance (viz Josef Šlerka: DataBoutique.cz). Data z období ", 
                      e_pr$sn, " - ", e_pr$un, ". Kamil Gregor, KohoVolit.eu.")
e_mds$sb_en <- paste0("The chart shows distances between the subjects based on an overlap of fans active on their Facebook pages. Calculated using \nthe Normalized Facebook Distance (see Josef Šlerka: DataBoutique.cz). Data from ", 
                      e_pr$sn, " to ", e_pr$un, ". Kamil Gregor, KohoVolit.eu.")

# vizualize the matrix of pages' NFD using MDS

library("reshape2")

e_mds$mx <- acast(e_xy$df, x ~ y, value.var = "NFD", fun.aggregate = mean)
e_mds$fit <- cmdscale(e_mds$mx, eig = TRUE, k = 2)
e_mds$df <- data.frame(e_mds$fit$points)
e_mds$df$name <- row.names(e_mds$df)
names(e_mds$df) <- c("x", "y", "id")
e_mds$df <- merge(e_mds$df, pg_us, by=c("id"))

plot(e_mds$df$x, e_mds$df$y, xlab = "", ylab = "", main = ifelse(e_mds$lg == "en", 
                                                                 e_mds$mn_en, e_mds$mn_cs), sub = ifelse(e_mds$lg == "en", e_mds$sb_en, e_mds$sb_cs), 
     xlim = c(ifelse(min(e_mds$df$x) > 0, min(e_mds$df$x) - (0.2 * min(e_mds$df$x)), 
                     min(e_mds$df$x) + (0.2 * min(e_mds$df$x))), ifelse(max(e_mds$df$x) > 0, max(e_mds$df$x) + 
                                                                          (0.2 * max(e_mds$df$x)), max(e_mds$df$x) - (0.2 * max(e_mds$df$x)))), ylim = c(ifelse(min(e_mds$df$y) > 
                                                                                                                                                                  0, min(e_mds$df$y) - (0.2 * min(e_mds$df$y)), min(e_mds$df$y) + (0.2 * min(e_mds$df$y))), 
                                                                                                                                                         ifelse(max(e_mds$df$y) > 0, max(e_mds$df$y) + (0.2 * max(e_mds$df$y)), max(e_mds$df$y) - 
                                                                                                                                                                  (0.2 * max(e_mds$df$y)))), cex.sub = 0.5, pch = "")
text(e_mds$df$x, e_mds$df$y, labels = e_mds$df$page, cex = 0.5) 

# save the workspace image

cd <- paste0("save.image('",location,"MDS.RData')")
eval(parse(text = cd))

# export the MDS positions and the distance matrix

cd <- paste0("write.table(e_mds$mx,'",location,"matrix.txt')")
eval(parse(text = cd))
cd <- paste0("write.table(e_mds$df,'",location,"MDS_scores.txt',row.names=F)")
eval(parse(text = cd))