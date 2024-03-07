# Install zoo package if not already installed
if (!requireNamespace("zoo", quietly = TRUE)) {
  install.packages("zoo")
}

# Load the zoo package
library(zoo)

# clear console
cat("\014")

# Clear R workspace objects (variables/data/etc.)
rm(list = ls(all.names = TRUE))

# Read in the data
precip_data <- read.table("C:/Users/natda/OneDrive/Desktop/precip_data.txt",
                          header=TRUE, colClasses=c("character","numeric"), sep="\t")

# Convert Date_time to Date class
precip_data$Date <- as.Date(precip_data$Date_time, format = "%m/%d/%Y %H:%M")

# Create sequence of days 
days <- seq(from = min(precip_data$Date), to = max(precip_data$Date), by = "day")

# Calculate daily precipitation
daily_precip <- sapply(days, function(d) {
  sum(precip_data$P_inches[precip_data$Date == d], na.rm = TRUE)  
})

# Calculate 24-hour precipitation using zoo::rollapply
roll_sum <- rollapply(precip_data$P_inches, width = 24, FUN = sum, align = "right", fill = NA)

# Plot daily precipitation
plot(days, daily_precip, type = "p", xlab = "Day", ylab = "Precipitation (inches)")

# Find max daily precipitation
max_daily <- max(daily_precip, na.rm = TRUE)

# Find max 24-hour precipitation  
max_24hr <- max(roll_sum, na.rm = TRUE)

print(paste("Max daily precipitation:", round(max_daily, 2), "inches"))
print(paste("Max 24-hour precipitation:", round(max_24hr, 2), "inches"))

