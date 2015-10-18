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
png("plot4.png")
par(bg = "transparent", mfrow = c(2,2))

# Top Left
plot(
    x = dat$datetime,
    y = dat$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power"
)

# Top Right
plot(
    x = dat$datetime,
    y = dat$Voltage,
    type = "l",
    xlab = "datetime",
    ylab = "Voltage"
)

# Bottom Left
plot(
    x = dat$datetime,
    y = dat$Sub_metering_1,
    type = "l",
    col = "black",
    xlab = "",
    ylab = "Energy sub metering"
)
points(
    x = dat$datetime,
    y = dat$Sub_metering_2,
    type = "l",
    col = "red"
)
points(
    x = dat$datetime,
    y = dat$Sub_metering_3,
    type = "l",
    col = "blue"
)
legend(
    "topright",
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    lty = c(1, 1, 1),
    col = c("black", "red", "blue"),
    bty = "n"
)

# Bottom Right
plot(
    x = dat$datetime,
    y = dat$Global_reactive_power,
    type = "l",
    xlab = "datetime",
    ylab = "Global_reactive_power"
)
dev.off()
