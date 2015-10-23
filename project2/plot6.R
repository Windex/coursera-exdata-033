if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Baltimore City, Maryland (fips == "24510")

# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes
# over time in motor vehicle emissions?

mvsrc <- unique(SCC$EI.Sector)[
    grep("vehicle", unique(SCC$EI.Sector), ignore.case = TRUE)]
mvSCC <- SCC[SCC$EI.Sector %in% mvsrc,]
mvNEI <- merge(NEI, mvSCC, by = "SCC")

years <- unique(NEI$year)

totals <- lapply(c("24510", "06037"), function(w) {
    sapply(years, function(x) {
        sapply(mvsrc, function(y) {
            sum(mvNEI$Emissions[
                mvNEI$fips == w &
                mvNEI$year == x & 
                mvNEI$EI.Sector == y
            ])
        })
    })
})

diffs <- t(sapply(totals, function(x) {
    (colSums(x) / sum(x[,1]) - 1) * 100
}))

png("plot6.png", width = 800, height = 800)
par(bg = "transparent", mfrow = c(2,2))

# Top left - Baltimore
barplot(
    totals[[1]],
    col = c("light green", "dark green", "light blue", "dark blue"),
    names.arg = years,
    main = "Motor Vehicle PM2.5 Emissions in Baltimore City",
    xlab = "Year",
    ylab = "Tons",
)

# Top right - Los Angeles
barplot(
    totals[[2]],
    col = c("light green", "dark green", "light blue", "dark blue"),
    names.arg = years,
    main = "Motor Vehicle PM2.5 Emissions in Los Angeles County",
    xlab = "Year",
    ylab = "Tons"
)

# Bottom left - Differences
barplot(
    diffs[1,],
    col = "yellow",
    names.arg = years,
    main = "Change in Motor Vehicle PM2.5 Emissions",
    xlab = "Year",
    ylab = "%",
    ylim = c(-75,75)
)
barplot(
    diffs[2,],
    col = "orange",
    add = TRUE
)
legend(x = "top", inset = 0.1, bg = "lightgrey", cex = 2,
       fill = c("orange", "yellow"),
       legend = c("Los Angeles", "Baltimore"))

# Bottom right - Legend (w/ empty plot)
plot(1, type = "n", axes = FALSE, xlab = "", ylab = "")
legend(x = "top", inset = 0.1, bg = "lightgrey", cex = 2,
       fill = c("light green", "dark green", "light blue", "dark blue"),
       legend = sub("Mobile - On-Road ", "", sub(" Vehicles", "", mvsrc)))

dev.off()