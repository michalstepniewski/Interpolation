library(RSQLite)
library(zoo)

db <- dbConnect(SQLite(), dbname="crawl_sqlite_db_2016_01_18.db")
dbListTables(db)
start_date <- "2016-01-01"
end_date <- "2016-01-07"
query <- sprintf("
                 SELECT *
                 FROM PostsByReadDates
WHERE (created_date BETWEEN '%s' AND '%s')
                                  ", start_date, end_date)
# musze zrobic to zeby jakos dzialalo na cala baze
# moge to robic po kawalku jakos
# problem zeby tyle naraz wczytac do pamieci
# mozna robic po kawalku datowym

test <- dbGetQuery(db, query)

post_ids_query <- sprintf("SELECT DISTINCT post_id FROM PostsByReadDates")

post_ids <- dbGetQuery(db, post_ids_query)
InterpolatedMain <- test[0,]

crt_tbl_command =sprintf("CREATE TABLE PostsByReadDatesInterpolated(Id INTEGER PRIMARY KEY,\
                                                                      post_id TEXT,\
 video_id TEXT,\
 created_date TEXT,\
 length TEXT,\
 message TEXT,\
 labels TEXT,\
 origin TEXT,\
 views INTEGER,\
 likes INTEGER,\
 comments INTEGER,\
 shares INTEGER,\
 read_date TEXT,\
 minutes_elapsed INTEGER,\
 hours_elapsed INTEGER,\
 filename TEXT)");
dbSendQuery(db, crt_tbl_command)

for (post_id in unique(test$post_id)){

# wybrac unikalne posty
    test2 <- test[which(test$post_id==post_id),]

    read_dates_full_hour <- as.POSIXct(test2$read_date, format = "%Y_%m_%d_%H")
    read_dates <- as.POSIXct(test2$read_date, format = "%Y_%m_%d_%H%M%S")
    Zwynik <- data.frame(unique(read_dates_full_hour))
    
    for (column in data.frame(test2$views,test2$likes,test2$comments,test2$shares))
    {    
        zs <- zoo(column, unique(read_dates_full_hour))
        zc <- zoo(column, unique(read_dates))
        z <-merge(zs,zc)
#        z <-merge(zs,zc)
        z$zc <- na.approx(z$zc, rule=2)

        Z <- z[index(zs),]
        #potem concatenowac to
#        Zwynik <- merge(Zwynik,as.numeric(Z[,1]))
        Zwynik[dim(Zwynik)[2]+1] <- as.numeric(Z[,1])
        
    }
    Interpolated <- cbind(test2[1:dim(Zwynik)[1],1:8],  Zwynik[,2:5], unique(read_dates_full_hour), test2[1:dim(Zwynik)[1],14:16])
    InterpolatedMain <- rbind(InterpolatedMain,Interpolated)
    dbWriteTable(db,"PostsByReadDatesInterpolated",InterpolatedMain)
}
#test2[1:8]

