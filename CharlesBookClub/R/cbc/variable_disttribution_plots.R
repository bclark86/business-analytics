# create function to standardize plots and reproduce quicker
variable_dist_plot <- function(df, var, binwidth) {

  # label charts using feature table
  xlabel <- feature.definitions[feature.definitions$Features == var, 2]

  # use for intercept lines for overall mean
  xmean <- cbc.num.summary[which(rownames(cbc.num.summary) == var), 7]

  # placeholder to get for feature class group means
  mean.intercept <- paste0(var, "_mean")

  # histogram of training set variable
  p1 <- cbc.train %>%
    ggplot(aes_string(x = var), fill = "Overall") +
    geom_histogram(binwidth = binwidth, fill = cbPalette[2],
                   color = "black", alpha = 0.3) +
    geom_vline(aes_string(xintercept = xmean), color = "black",
               linetype = "dashed") +
    labs(title = paste0(xlabel, " (Overall)"), x = "", y = "Count")

  # histogram and denisty plot of training set variable by class group
  p2 <- cbc.train %>%
    ggplot(aes_string(x = var, fill = "Florence", color = "Florence")) +
    geom_histogram(aes(y =..density..), binwidth = binwidth,
                   position = "identity", alpha = 0.3) +
    geom_density(alpha = 0.4) +
    geom_vline(data = cbc.florence,
               aes_string(xintercept = mean.intercept, color = "Florence"),
               linetype = "dashed") +
    labs(title = xlabel, x = "", y = "Density") +
    scale_color_manual(values = c(cbPalette[6], cbPalette[7])) +
    scale_fill_manual(values = c(cbPalette[6], cbPalette[7])) +
    theme(legend.position = c(0.9, 0.9))

  # horizontal box blot of class group
  p3 <- cbc.train %>%
    ggplot(aes_string(x = "Florence", y = var, fill = "Florence")) +
    geom_boxplot() +
    coord_flip() +
    labs(title = xlabel, x = "", y = "") +
    theme(legend.position = c(0.9, 0.9)) +
    scale_color_manual(values = c(cbPalette[6], cbPalette[7])) +
    scale_fill_manual(values = c(cbPalette[6], cbPalette[7]))

  # display in 3 rows
  # NOTE: size of chart is rendered in R Markdown 'fig.height' parameter
  grid.arrange(
    p1,
    p2,
    p3,
    nrow = 3
  )
}
