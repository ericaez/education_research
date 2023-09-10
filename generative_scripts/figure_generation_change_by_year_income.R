# Load required packages
library(ggplot2)
library(tidyr)
library(readr)
library(dplyr)
library(tidyverse)
library(grid)

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

# Read the sample data
data <- read_csv("/Users/natan/Downloads/data2.csv")
colnames(data) <- c("Group", "2015", "2016", "2017", "2018", "2019", "2021", "State")

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "ELA_Pass_Rate") %>%
  filter(!is.na(ELA_Pass_Rate)) %>%
  group_by(State, Group) %>%
  arrange(State, Group, Year) %>%
  mutate(First_Non_NA = first(ELA_Pass_Rate, order_by = Year)) %>%
  ungroup()

# Before mutating the Group column
data_long$Original_Group <- data_long$Group

# Calculate the change from the baseline for each state-year
data_long <- data_long %>%
  group_by(State, Group) %>%
  mutate(Delta_Change = ELA_Pass_Rate - First_Non_NA) %>%
  ungroup()

# Recode Year for legend
data_long$YearLegend <- ifelse(data_long$Year == "2021", "2021", "< 2021")

# Create custom y-axis labels
data_long <- data_long %>%
  mutate(Group = case_when(
    Group == "mid" ~ paste0("   ", state_abbreviations_vector[State], "      Mid"),
    Group == "high" ~ "High",
    Group == "low" ~ "Low",
    TRUE ~ as.character(Group)
  ))

# Explicitly order the Groupså
data_long$Group <- factor(data_long$Group, 
                          levels = c("High",
                                     paste0("   ", state_abbreviations_vector[unique(data_long$State)], "      Mid"),
                                     "Low"))


print(unique(data_long$Original_Group))


# Continue with the plot
p <- ggplot(data_long, aes(x = Delta_Change, y = Group)) +
  scale_x_continuous(limits = c(-20, 10), breaks = seq(-20, 10, by = 5)) +
  geom_vline(xintercept = 0, color = "darkred", size = 0.5) +
  # Modify the geom_point to color based on Group and define the aesthetic mapping
  geom_point(aes(shape = YearLegend, size = YearLegend, color = Original_Group), size = 5) +
  # Add a scale_color_manual to specify the colors
  scale_color_manual(values = c("low" = "#d3d3d3", "mid" = "#A9A9A9", "high" = "#000000")) +
  scale_shape_manual(name = "Year", values = c("2021" = 5, "< 2021" = 18)) +
  scale_size_manual(name = "Year", values = c("2021" = 5, "< 2021" = 2)) +
  labs(x = "ELA Pass Rate Change from Baseline", 
       y = "State", 
       color = "Income Class Classification") +
  scale_y_discrete(expand = c(0.85, 0.85)) +
  facet_grid(State~., scales = "free", space = "free") + 
  theme_minimal() +
  theme(strip.background = element_blank(),
        strip.text = element_blank(),
        panel.spacing = unit(0, "cm"),
        panel.grid = element_blank(),
        axis.line = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        axis.ticks.length = unit(0.3, "cm"),
        legend.position = "bottom",
        legend.box = "horizontal",
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


