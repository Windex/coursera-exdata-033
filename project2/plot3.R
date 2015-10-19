if (!(exists("NEI") && exists("SCC"))) {
    print("Reading files...")
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    print("Using cached data")
}

# Baltimore City, Maryland (fips == "24510")

# Of the four types of sources indicated by the type (point,
# nonpoint, onroad, nonroad) variable, which of these four sources
# have seen decreases in emissions from 1999–2008 for Baltimore
# City? Which have seen increases in emissions from 1999–2008? Use
# the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)

png("plot3.png")
p <- ggplot(data = NEI[NEI$fips == "24510",],
            aes(factor(year), Emissions / 1000, fill = "red")) +
    stat_summary(fun.y = sum, geom = "bar") +
    facet_wrap(~ type, ncol = 2) +
    labs(title = paste(
        "Total PM2.5 Emissions in Baltimore City,",
        "Maryland by Source Type"
    )) +
    xlab("Year") + ylab("Thousand Tons") +
    guides(fill = FALSE) + theme_bw()
print(p)
dev.off()