# EXPORT LISTS OF POSTS, ACTIVE USERS AND COMMENTS OF A LIST OF FACEBOOK PAGES

for (i in pg$id) {

cd <- paste0("write.table(e_pt$pt_", i,",'C:/Users/NB/Desktop/NFD/analysis/posts_", i,".txt', sep='ß',eol='¤',row.names=F)")
eval(parse(text = cd))

cd <- paste0("write.table(e_us$us_", i,",'C:/Users/NB/Desktop/NFD/analysis/users_", i,".txt', sep='ß',eol='¤',row.names=F)")
eval(parse(text = cd))

cd <- paste0("write.table(e_ct$ct_", i,",'C:/Users/NB/Desktop/NFD/analysis/comments_", i,".txt', sep='ß',eol='¤',row.names=F)")
eval(parse(text = cd))

}

write.table(e_mds$mx, "C:/Users/NB/Desktop/NFD/analysis/matrix.txt")
write.table(e_mds$df, "C:/Users/NB/Desktop/NFD/analysis/MDS.txt", row.names=F)
