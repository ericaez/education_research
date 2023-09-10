# Load required packages
library(ggplot2)
library(tidyr)
library(readr)
library(dplyr)

theme_set(
  theme_minimal() +
    theme(
      text = element_text(family = "Computer Modern"),
      axis.title = element_text(family = "Computer Modern"),
      axis.text = element_text(family = "Computer Modern"),
      legend.title = element_text(family = "Computer Modern"),
      legend.text = element_text(family = "Computer Modern")
    )
)

# Create a named vector to map full state names to abbreviations
state_abbreviations_vector <- c(california="CA", newyork="NYC", texas="TX", illinois="IL")

# Accessing values
print(state_abbreviations_vector["california"])

# Read the data
data <- read_csv("/Users/natan/Downloads/data.csv", skip = 1)  # Skip the title row

# Reshape the data to long format
data_long <- data %>%
  gather(key = "Year", value = "ELA_Pass_Rate", -State) %>%
  group_by(State) %>%
  arrange(Year) %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  mutate(First_Non_NA = first(ELA_Pass_Rate, order_by = Year)) %>%
  ungroup()

# Calculate the change from the baseline for each state-year
data_long <- data_long %>%
  group_by(State) %>%
  mutate(Delta_Change = ELA_Pass_Rate - First_Non_NA) %>%
  ungroup()

# Remove NA rows
data_long <- na.omit(data_long)

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create the scatter plot
p <- ggplot(data_long, aes(x = Delta_Change, y = State)) +
  geom_vline(xintercept = 0, color = "gray", size = 0.5) +
  scale_x_continuous(limits = c(-10, 10), breaks = seq(-8, 8, by = 4)) +
  geom_point(aes(shape = YearLegend, size = YearLegend), size = 5) +
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  labs(x = "ELA Pass Rate Change from Baseline", y ="State") +
  scale_y_discrete(expand = c(2, 2)) +
  coord_fixed(ratio = 3) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks.y = element_line(color = "black"),
    axis.ticks.length = unit(0.4, "cm"),
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.background = element_rect(color = "black", linewidth = 0.5),
    legend.title = element_text(hjust = 0.5),
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0))
  ) +
  guides(shape = guide_legend(
    title.theme = element_text(size = 10, hjust = 0.5),
    title.position = "top", 
    keywidth = unit(1, "lines"),
    keyheight = unit(1, "lines"), 
    label.position = "right", 
    label.theme = element_text(size = 10, margin = margin(r = 20)),
    override.aes = list(size = c(6, 4.5)) # increase size here
  ))

ggsave(filename = "/Users/natan/Dev/virtual_mode_research/figures/mathpass_by_year.png", plot = p, width = 5, height = 8)

print(p)