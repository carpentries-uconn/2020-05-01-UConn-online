# Software Carpentry ggplot2 workshop


# Install 3rd party packages we'll be using
install.packages(c("ggplot2", "cowplot", "gapminder", 
     "plotly"))

# Read in data
gap <- read.csv("data/gapminder_data.csv")

# Getting help
?read.csv

# Take a quick look at our data
head(gap)
str(gap)



##### Intro to ggplot


# Load the ggplot library
library(ggplot2)

# first ggplot
ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp)) + 
     geom_point()

# ggplot with year vs life expectancy
# Not the most informative graph
# The aes() function lets us set an x and y variable
# The geom_point() function tells the graph to add a scatterplot
ggplot(data = gap, mapping = aes(x = year, 
     y = lifeExp, color = continent)) + 
     geom_point()

# This graph might be better with changes over time
# So we use geom_line() to make a line graph instead
# Adding a by argument to aes() lets us have a line for each country
# Adding a color argument lets us color by group (continent)
ggplot(data = gap, mapping = aes(x = year, 
     y = lifeExp, color = continent, 
     group = country)) + 
     geom_line()

# We could color the points and lines differently by adding 
# aes() to just the geom_line() layer
ggplot(data = gap, mapping = aes(x = year, 
     y = lifeExp, group = country)) + 
     geom_line(aes(color = continent)) + 
     geom_point()

# Color by group for lines, specific color for points (outside aes())
ggplot(data = gap, mapping = aes(x = year, 
     y = lifeExp, group = country)) + 
     geom_line(mapping = aes(color = continent)) + 
     geom_point(color = "blue")

# Make the points semi-transparent to see density
# Log-transform the x-axis
# Add a trendline (linear regression/model) using geom_smooth()
ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp)) +
     geom_point(alpha = 0.5) +
     scale_x_log10() +
     geom_smooth(method = "lm", size = 3)

# Make the points bigger, and give them a different shape for each continent
# Good for colorblind accessibility
ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp)) + 
     geom_point(aes(color = continent, shape = continent),
     size = 2, alpha = 0.5) +
     scale_x_log10() + 
     geom_smooth(aes(group = continent), method = "lm")


##### Getting ready for publication


# Modify the graph to make it look good for publication
# Also, save it to a variable
lifeExp_plot <- ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp, color = continent)) +
     geom_point(mapping = aes(shape = continent), 
          size = 2) + 
     scale_x_log10() + 
     geom_smooth(method = "lm") +

     # Change the y-axis limits and tickmark positions 
     scale_y_continuous(limits = c(0, 100), 
          breaks = seq(0, 100, by = 10)) + 

     # Change the theme to something more simple
     theme_minimal() +

     # Add axis and legend labels
     labs(title = "Effects of per-capita GDP", 
          x = "GDP per Capita ($)", 
          y = "Life Expectancy (yrs)", 
          color = "Continents", 
          shape = "Continents")

# Since we saved the plot to a variable, 
# we have to run the variable to show the plot now
lifeExp_plot

# Save as png
ggsave(file = "figures/life_expectancy.png", plot = lifeExp_plot)

# Save as pdf
ggsave(file = "figures/life_expectancy.pdf", plot = lifeExp_plot)

# Save as png, high resolution
ggsave(file = "figures/life_expectancy.png", plot = lifeExp_plot, 
     width = 8, height = 6, units = "in", dpi = 300)


##### Facets


# Facets for 3-dimensional data
# This splits the graph into multiple graphs in a panel
# Here, we show a different graph of gdpPercap vs lifeExp for each 
# continent
ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp)) + 
     facet_wrap(~ continent, ncol = 2, scales = "free") + 
     geom_point(alpha = 0.5) + 
     scale_x_log10() + 
     geom_smooth(method = "lm")

# Another example, coloring by continent, and faceting by year
ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp, color = continent)) + 
     facet_wrap(~year) +
     geom_point(alpha = 0.5) + 
     scale_x_log10() + 
     geom_smooth(method = "lm")


##### Combining graphs


# Load the cowplot library
library(cowplot)

# Make our first plot and save it
plotA <- ggplot(data = gap, mapping = aes(x = gdpPercap, 
     y = lifeExp)) + 
     geom_point() + 
     scale_x_log10() + 

     # Cowplot also has a nice minimalist theme
     theme_cowplot()

# Show first plot
plotA

# Make our second plot and save it
plotB <- ggplot(data = gap, mapping = aes(x = continent, 
     y = lifeExp)) + 
     geom_boxplot() +

     # Cowplot also has a nice minimalist theme 
     theme_cowplot()

# Show second plot
plotB

# Combine the two plots into a figure with A and B graphs
plot_grid(plotA, plotB, labels = c("A", "B"))

# Save the combined plot, with a custom size
ggsave(file = "figures/combined_plot.pdf", width = 10, 
     height = 4, units = "in")

# Another (more powerful) way to combine plots
# This way allows you to control relative size of the graphs
# ggdraw() works with a canvas that goes from 0 to 1 in the x and y axis
# You position and size graphs in that 0 to 1 space.
ggdraw() + 
     draw_plot(plotA, x = 0, y = 0, width = 0.3, height = 1) + 
     draw_plot(plotB, x = 0.3, y = 0, width = 0.7, height = 1)

# Show detailed tutorial for cowplot (also works for other packages)
browseVignettes("cowplot")


##### Interactive graphs


# Load the plotly library, which includes ggplotly()
library(plotly)

# Make a graph and save it to a variable
yearLifeExp <- ggplot(data = gap, mapping = aes(x = year, 
     y = lifeExp,
     continent = continent)) +
     facet_wrap(~ continent) +
     geom_line(aes(group = country)) + 
     scale_x_log10()

# Show the ggplot graph, not interactive yet
yearLifeExp

# Make the graph interactive with ggplotly. 
# Now, you can explore the data
ggplotly(yearLifeExp)

