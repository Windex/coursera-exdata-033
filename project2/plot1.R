if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Have total emissions from PM2.5 decreased in the United States
# from 1999 to 2008? Using the base plotting system, make a plot
# showing the total PM2.5 emission from all sources for each of the
# years 1999, 2002, 2005, and 2008.

years <- unique(NEI$year)
totals <- sapply(years, function(x) {
    sum(NEI$Emissions[NEI$year == x])
})

png("plot1.png")
par(bg = "transparent")
barplot(
    totals / 1000000,
    col = "red",
    names.arg = years,
    main = "Total PM2.5 Emissions in the United States",
    xlab = "Year",
    ylab = "Million Tons"
)
dev.off()