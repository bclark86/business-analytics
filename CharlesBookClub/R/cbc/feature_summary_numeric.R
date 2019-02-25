df_num_summary <- function(df, cols = NULL) {

  if (is.null(cols)) {
    num.cols <- select_if(df, is.numeric)
  } else {
    num.cols <- cols
  }

  df <- df %>% select(num.cols)

    df.num.summmary <- data.frame(
      Count = round(sapply(df, length), 2),
      Miss = round((sapply(df, function(x) sum(length(which(is.na(x)))) / length(x)) * 100), 1),
      Card. = round(sapply(df, function(x) length(unique(x))), 2),
      Min. = round(sapply(df, min, na.rm = TRUE), 2),
      `25 perc.` = round(sapply(df, function(x) quantile(x, 0.25, na.rm = TRUE)), 2),
      Median = round(sapply(df, median, na.rm = TRUE), 2),
      Mean = round(sapply(df, mean, na.rm = TRUE), 2),
      `75 perc.` = round(sapply(df, function(x) quantile(x, 0.75, na.rm = TRUE)), 2),
      Max = round(sapply(df, max, na.rm = TRUE), 2),
      `Std Dev.` = round(sapply(df, sd, na.rm = TRUE), 2)
    ) %>%
      rename(`1st Qrt.` = X25.perc.,
             `3rd Qrt.` = X75.perc.,
             `Miss Pct.` = Miss)

    return(df.num.summmary)
}
