library(zoo)

interpolate <- function(my_data) {

InterpolatedMain <- my_data[0,]

for (post_id in unique(my_data$post_id)){

# for every post
    my_data_post_id <- my_data[which(my_data$post_id==post_id),]

    read_dates_full_hour <- as.POSIXct(my_data_post_id$read_date, format = "%Y_%m_%d_%H")
    read_dates <- as.POSIXct(my_data_post_id$read_date, format = "%Y_%m_%d_%H%M%S")
    Zwynik <- data.frame(unique(read_dates_full_hour))
    
    for (column in data.frame(my_data_post_id$views,my_data_post_id$likes,my_data_post_id$comments,my_data_post_id$shares))
    {    
        zs <- zoo(column, unique(read_dates_full_hour))
        zc <- zoo(column, unique(read_dates))
        z <-merge(zs,zc)
        z$zc <- na.approx(z$zc, rule=2)

        Z <- z[index(zs),]
        Zwynik[dim(Zwynik)[2]+1] <- as.numeric(Z[,1])
    }
    Interpolated <- cbind(test2[1:dim(Zwynik)[1],1:8],  Zwynik[,2:5], unique(read_dates_full_hour), test2[1:dim(Zwynik)[1],14:16])
    InterpolatedMain <- rbind(InterpolatedMain,Interpolated)
}
InterpolatedMain
}