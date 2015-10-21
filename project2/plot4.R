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
    grep("coal", unique(SCC$EI.Sector), ignore.case = TRUE)]
coalSCC <- SCC[SCC$EI.Sector %in% coalsrc,]
coalNEI <- merge(NEI, coalSCC, by = "SCC")

years <- unique(NEI$year)

totals <- sapply(years, function(x) {
    sapply(coalsrc, function(y) {
        sum(coalNEI$Emissions[coalNEI$year == x & coalNEI$EI.Sector == y])
    })
})

png("plot4.png")
par(bg = "transparent")
barplot(
    totals / 1000,
    col = c("red", "white", "blue"),
    names.arg = years,
    main = "Coal Combustion PM2.5 Emissions across the United States",
    xlab = "Year",
    ylab = "Thousand Tons"
)
legend(x = "bottomright", inset = .05, bg = "lightgrey",
       fill = c("red", "white", "blue"),
       legend = sub("Fuel Comb - ", "", sub(" - Coal", "", coalsrc)))
dev.off()