# Load necessary libraries
library(tidyverse)
library(grid)

state_abbreviations_vector <- c("ca"="CA", "nyc"="NYC", "tx"="TX", "il"="IL")

# Read the sample data
data <- read_csv("/Users/natan/Dev/education_research/descriptive_analysis/mathpass_by_income.csv", col_types = cols(`...1` = col_skip()))
colnames(data) <- c("state", "income_level", "2015", "2016", "2017", "2018", "2019", "2021" )

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "ELA_Pass_Rate") %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  group_by(state, income_level) %>%
  arrange(state, income_level, Year) %>%
  mutate(First_Non_NA = first(ELA_Pass_Rate, order_by = Year)) %>%
  ungroup()

# Before mutating the income_level column
data_long$Original_Group <- data_long$income_level

# Calculate the change from the baseline for each state-year
data_long <- data_long %>%
  group_by(state, income_level) %>%
  mutate(Delta_Change = ELA_Pass_Rate - First_Non_NA) %>%
  ungroup()

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create custom y-axis labels
data_long <- data_long %>%
  mutate(income_level = case_when(
    income_level == "mid" ~ paste0("   ", state_abbreviations_vector[state], "      Mid"),
    income_level == "high" ~ "High",
    income_level == "low" ~ "Low",
    TRUE ~ as.character(income_level)
  ))

# Explicitly order the Groupså
data_long$income_level <- factor(data_long$income_level, 
                          levels = c("High",
                                     paste0("   ", state_abbreviations_vector[unique(data_long$state)], "      Mid"),
                                     "Low"))


print(unique(data_long$Original_Group))


# Continue with the plot
p <- ggplot(data_long, aes(x = Delta_Change, y = income_level)) +
  scale_x_continuous(limits = c(-30, 10), breaks = seq(-20, 10, by = 5)) +
  geom_vline(xintercept = 0, color = "darkred", size = 0.5) +
  # Modify the geom_point to color based on income_level and define the aesthetic mapping
  geom_point(aes(shape = YearLegend, size = YearLegend, color = Original_Group), size = 5) +
  # Add a scale_color_manual to specify the colors
  scale_color_manual(values = c("low" = "#d3d3d3", "mid" = "#A9A9A9", "high" = "#000000")) +
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  labs(x = "ELA Pass Rate Change from Baseline", 
       y = "State", 
       color = "Income Class Classification") +
  scale_y_discrete(expand = c(0.85, 0.85)) +
  facet_grid(state~., scales = "free", space = "free") + 
  theme_minimal() +
  theme(strip.background = element_blank(),
        strip.text = element_blank(),
        panel.spacing = unit(0, "cm"),
        panel.grid = element_blank(),
        axis.line = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        axis.ticks.length = unit(0.3, "cm"),
        legend.position = "bottom",
        legend.box = "vertical",
        legend.direction = "horizontal", # Stack the legends vertically
        legend.background = element_rect(color = "black", linewidth = 0.5),
        legend.title = element_text(hjust = 0.5),
        axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0))) +
  guides(shape = guide_legend(
    title.theme = element_text(size = 10, hjust = 0.5),
    title.position = "top", 
    keywidth = unit(1, "lines"),
    keyheight = unit(1, "lines"), 
    label.position = "right", 
    label.theme = element_text(size = 10, margin = margin(r = 20)),
    override.aes = list(size = c(6, 4.5)) # increase size here
  ))

print(p)

ggsave(filename = "/Users/natan/Dev/virtual_mode_research/figures/mathpass_by_income.png", bg = "white", plot = p, width = 5, height = 8)

rm(list = ls())




