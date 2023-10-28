# Load necessary libraries
library(tidyverse)
library(grid)

state_abbreviations_vector <- c("ca"="CA", "nyc"="NYC", "tx"="TX", "il"="IL")

# Read the sample data
data <- read_csv("/Users/natan/Dev/education_research/descriptive_analysis/mathpass_by_black.csv", col_types = cols(`...1` = col_skip()))
colnames(data) <- c("state", "b_level", "2015", "2016", "2017", "2018", "2019", "2021" )

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "ELA_Pass_Rate") %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  group_by(state, b_level) %>%
  arrange(state, b_level, Year) %>%
  mutate(Average_Rate = mean(ELA_Pass_Rate, na.rm = TRUE)) %>%
  ungroup()

# Before mutating the h_level column
data_long$Original_Group <- data_long$b_level

# Calculate the change from the average for each state-year
data_long <- data_long %>%
  group_by(state, b_level) %>%
  mutate(Delta_Change = ELA_Pass_Rate - Average_Rate) %>%
  ungroup()

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create custom y-axis labels
data_long <- data_long %>%
  mutate(b_level = case_when(
    b_level == "mid" ~ paste0("   ", state_abbreviations_vector[state], "      Mid"),
    b_level == "high" ~ "High",
    b_level == "low" ~ "Low",
    TRUE ~ as.character(b_level)
  ))

# Explicitly order the Groupså
data_long$b_level <- factor(data_long$b_level, 
                          levels = c("High",
                                     paste0("   ", state_abbreviations_vector[unique(data_long$state)], "      Mid"),
                                     "Low"))


print(unique(data_long$Original_Group))


# Continue with the plot
p <- ggplot(data_long, aes(x = Delta_Change, y = b_level)) +
  scale_x_continuous(limits = c(-25, 10), breaks = seq(-50, 10, by = 10)) +
  geom_vline(xintercept = 0, color = "gray", size = 0.8, linetype="dotted") +
  # Modify the geom_point to color based on b_level and define the aesthetic mapping
  geom_point(aes(shape = YearLegend, size = YearLegend, color = Original_Group), size = 5) +
  # Add a scale_color_manual to specify the colors
  scale_color_manual(values = c("low" = "#d3d3d3", "mid" = "#A9A9A9", "high" = "#000000")) +
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  labs(x = "Math Pass Rate Change from Baseline", 
       y = "State", 
       color = "Black Population Level") +
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

ggsave(filename = "/Users/natan/Dev/education_research/figures/mathpass_by_black.png", bg = "white", plot = p, width = 5, height = 8)

rm(list = ls())



state_abbreviations_vector <- c("ca"="CA", "nyc"="NYC", "tx"="TX", "il"="IL")

# Read the sample data
data <- read_csv("/Users/natan/Dev/education_research/descriptive_analysis/elapass_by_black.csv", col_types = cols(`...1` = col_skip()))
colnames(data) <- c("state", "b_level", "2015", "2016", "2017", "2018", "2019", "2021" )

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "ELA_Pass_Rate") %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  group_by(state, b_level) %>%
  arrange(state, b_level, Year) %>%
  mutate(Average_Rate = mean(ELA_Pass_Rate, na.rm = TRUE)) %>%
  ungroup()

# Before mutating the h_level column
data_long$Original_Group <- data_long$b_level

# Calculate the change from the average for each state-year
data_long <- data_long %>%
  group_by(state, b_level) %>%
  mutate(Delta_Change = ELA_Pass_Rate - Average_Rate) %>%
  ungroup()

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create custom y-axis labels
data_long <- data_long %>%
  mutate(b_level = case_when(
    b_level == "mid" ~ paste0("   ", state_abbreviations_vector[state], "      Mid"),
    b_level == "high" ~ "High",
    b_level == "low" ~ "Low",
    TRUE ~ as.character(b_level)
  ))

# Explicitly order the Groupså
data_long$b_level <- factor(data_long$b_level, 
                            levels = c("High",
                                       paste0("   ", state_abbreviations_vector[unique(data_long$state)], "      Mid"),
                                       "Low"))


print(unique(data_long$Original_Group))


# Continue with the plot
p <- ggplot(data_long, aes(x = Delta_Change, y = b_level)) +
  scale_x_continuous(limits = c(-25, 10), breaks = seq(-50, 10, by = 10)) +
  geom_vline(xintercept = 0, color = "gray", size = 0.8, linetype="dotted") +
  # Modify the geom_point to color based on b_level and define the aesthetic mapping
  geom_point(aes(shape = YearLegend, size = YearLegend, color = Original_Group), size = 5) +
  # Add a scale_color_manual to specify the colors
  scale_color_manual(values = c("low" = "#d3d3d3", "mid" = "#A9A9A9", "high" = "#000000")) +
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  labs(x = "ELA Pass Rate Change from Baseline", 
       y = "State", 
       color = "Black Population Level") +
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

ggsave(filename = "/Users/natan/Dev/education_research/figures/elapass_by_black.png", bg = "white", plot = p, width = 5, height = 8)

rm(list = ls())





state_abbreviations_vector <- c("ca"="CA", "nyc"="NYC", "tx"="TX", "il"="IL")

# Read the sample data
data <- read_csv("/Users/natan/Dev/education_research/descriptive_analysis/dropout_by_black.csv", col_types = cols(`...1` = col_skip()))
colnames(data) <- c("state", "b_level", "2017", "2018", "2019", "2021" )

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "ELA_Pass_Rate") %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  group_by(state, b_level) %>%
  arrange(state, b_level, Year) %>%
  mutate(Average_Rate = mean(ELA_Pass_Rate, na.rm = TRUE)) %>%
  ungroup()

# Before mutating the h_level column
data_long$Original_Group <- data_long$b_level

# Calculate the change from the average for each state-year
data_long <- data_long %>%
  group_by(state, b_level) %>%
  mutate(Delta_Change = ELA_Pass_Rate - Average_Rate) %>%
  ungroup()

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create custom y-axis labels
data_long <- data_long %>%
  mutate(b_level = case_when(
    b_level == "mid" ~ paste0("   ", state_abbreviations_vector[state], "      Mid"),
    b_level == "high" ~ "High",
    b_level == "low" ~ "Low",
    TRUE ~ as.character(b_level)
  ))

# Explicitly order the Groupså
data_long$b_level <- factor(data_long$b_level, 
                            levels = c("High",
                                       paste0("   ", state_abbreviations_vector[unique(data_long$state)], "      Mid"),
                                       "Low"))


print(unique(data_long$Original_Group))


# Continue with the plot
p <- ggplot(data_long, aes(x = Delta_Change, y = b_level)) +
  scale_x_continuous(limits = c(-10, 5), breaks = seq(-50, 10, by = 10)) +
  geom_vline(xintercept = 0, color = "gray", size = 0.8, linetype="dotted") +
  # Modify the geom_point to color based on b_level and define the aesthetic mapping
  geom_point(aes(color = Original_Group, shape = YearLegend, size = YearLegend), size = 5) +
  # Add a scale_color_manual to specify the colors
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  scale_color_manual(values = c("low" = "#d3d3d3", "mid" = "#A9A9A9", "high" = "#000000")) +
  labs(x = "Dropout Rate Change from Baseline", 
       y = "State", 
       color = "Black Population Level") +
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

ggsave(filename = "/Users/natan/Dev/education_research/figures/dropout_by_black.png", bg = "white", plot = p, width = 5, height = 8)

rm(list = ls())
