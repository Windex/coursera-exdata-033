if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Across the United States, how have emissions from coal
# combustion-related sources changed from 1999–2008?

coalsrc <- unique(SCC$EI.Sector)[
    grep("coal", unique(SCC$EI.Sector), ignore.case = T)]
coalSCC <- SCC[SCC$EI.Sector %in% coalsrc,]
coalNEI <- merge(NEI, coalSCC, by = "SCC")

years <- unique(NEI$year)
totals <- sapply(years, function(x) {
    sum(coalNEI$Emissions[coalNEI$year == x])
})
# TODO make this a stacked graph on EI.Sector?
png("plot4.png")
par(bg = "transparent")
barplot(
    totals / 1000,
    col = "red",
    names.arg = years,
    main = "Coal Combustion PM2.5 Emissions in the United States",
    xlab = "Year",
    ylab = "Thousand Tons"
)
dev.off()