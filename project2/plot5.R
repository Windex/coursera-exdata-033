if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Baltimore City, Maryland (fips == "24510")

# How have emissions from motor vehicle sources changed from
# 1999–2008 in Baltimore City?

mvsrc <- unique(SCC$EI.Sector)[
    grep("vehicle", unique(SCC$EI.Sector), ignore.case = TRUE)]
mvSCC <- SCC[SCC$EI.Sector %in% mvsrc,]
mvNEI <- merge(NEI[NEI$fips == "24510",], mvSCC, by = "SCC")

years <- unique(NEI$year)

totals <- sapply(years, function(x) {
    sapply(mvsrc, function(y) {
        sum(mvNEI$Emissions[mvNEI$year == x & mvNEI$EI.Sector == y])
    })
})

png("plot5.png")
par(bg = "transparent")
barplot(
    totals,
    col = c("light green", "dark green", "light blue", "dark blue"),
    names.arg = years,
    main = "Motor Vehicle PM2.5 Emissions in Baltimore City",
    xlab = "Year",
    ylab = "Tons"
)
legend(x = "topright", inset = 0.05, bg = "lightgrey",
       fill = c("light green", "dark green", "light blue", "dark blue"),
       legend = sub("Mobile - On-Road ", "", sub(" Vehicles", "", mvsrc)))
dev.off()