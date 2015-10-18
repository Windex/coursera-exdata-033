if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Have total emissions from PM2.5 decreased in the Baltimore City,
# Maryland (fips == "24510") from 1999 to 2008? Use the base
# plotting system to make a plot answering this question.

years <- unique(NEI$year)
totals <- sapply(years, function(x) {
    sum(NEI$Emissions[NEI$year == x & NEI$fips == "24510"])
})

png("plot2.png")
par(bg = "transparent")
barplot(
    totals / 1000,
    col = "red",
    names.arg = years,
    main = "Total PM2.5 Emissions in Baltimore City, Maryland",
    xlab = "Year",
    ylab = "Thousand Tons"
)
dev.off()