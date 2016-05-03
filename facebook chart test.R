library(googleVis)

test <- e_pt$pt_stranazelenych

time <- test$created_time
time <- strsplit(time, "T")
time <- unlist(time)
date <- time[seq(1, length(time), 2)]

test$date <- date

time <- time[seq(2, length(time), 2)]
time <- strsplit(time, ":")
time <- unlist(time)
time <- paste(time[seq(1, length(time), 3)], time[seq(2, length(time), 3)], "00", sep = ":")
created_time <- paste(date, time, sep = " ")
test$created_time <- created_time
test$created_time <- as.POSIXlt(strptime(test$created_time, "%Y-%m-%d %H:%M:%S"))

test <- test[which(test$date > as.Date("2015-05-03", "%Y-%m-%d")), ]

link <- test$id
link <- strsplit(link, "_")
link <- unlist(link)
link <- link[seq(2, length(link), 2)]
link <- paste("<iframe src='https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fods.cz%2Fposts%2F", link, "&width=500' width='500' height='570' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true'></iframe>", sep = "")

test$"link.html.tooltip" <- link

test[is.na(test)] <- "NA"

Encoding(test$message.html.tooltip) <- "utf-8"

chart <- gvisColumnChart(data = test,
                         xvar = "created_time",
                         yvar = c("likes_count","link.html.tooltip"),
                         options = list(
                           height = 500,
                           tooltip="{isHtml:'true'}",
                           legend = "{position: 'none'}",
                           title = "Number of post likes"
                         ))

plot(chart)

write.csv(test, "C:/test.csv")
