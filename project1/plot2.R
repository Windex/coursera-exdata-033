HPC = "household_power_consumption.txt"

readHPCData <- function() {
    # Line count range of data (2880 rows)
    # 66638:1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000
    # 69517:2/2/2007;23:59:00;3.680;0.224;240.370;15.200;0.000;2.000;18.000
    cnames <- as.character(read.table(
        HPC, sep = ";", nrows = 1, stringsAsFactors = FALSE
    ))
    dat <- read.table(
        HPC, header = FALSE, sep = ";",
        na.strings = "?", col.names = cnames,
        nrows = 2880, skip = 66637,
        stringsAsFactors = FALSE
    )
    dat$datetime <- strptime(paste(dat$Date, dat$Time),
                             "%d/%m/%Y %T")
    dat
}

dat <- readHPCData()
png("plot2.png")
par(bg = "transparent")
plot(
    x = dat$datetime,
    y = dat$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power (kilowatts)"
)
dev.off()
