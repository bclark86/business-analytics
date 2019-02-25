# create function to run summary on categorical features
df_cat_summary <- function(df, cols = NULL) {

  if (is.null(cols)) {
    cat.cols <- colnames(select_if(df, is.factor))
  } else {
    cat.cols <- cols
  }

  df <- df %>% select(cat.cols)

  df.cat.summary <- data.frame(
    Count = round(sapply(df, length), 2),
    Miss = round(sapply(df, function(x) sum(length(which(is.na(x)))) / length(x)), 2),
    Card. = round(sapply(df, function(x) length(unique(x))), 2),
    Mode = names(sapply(df, function(x) sort(table(x), decreasing = TRUE)[1])),
    Mode_Freq = sapply(df, function(x) sort(table(x), decreasing = TRUE)[1]),
    Mode_pct = round((sapply(df, function(x) sort(table(x),
                                                  decreasing = TRUE)[1] / length(x)) * 100), 1),
    Mode_2 = names(sapply(df, function(x) sort(table(x), decreasing = TRUE)[2])),
    Mode_Freq_2 = sapply(df, function(x) sort(table(x), decreasing = TRUE)[2]),
    Mode_pct_2 = round((sapply(df, function(x) sort(table(x),
                                                    decreasing = TRUE)[2] / length(x)) * 100), 1)
  )

  df.cat.summary$Mode <- gsub("^.*\\.","", df.cat.summary$Mode)
  df.cat.summary$Mode_2 <- gsub("^.*\\.","", df.cat.summary$Mode_2)

  df.cat.summary <- df.cat.summary %>%
    rename(`Miss Pct.` = Miss,
           `Mode Freq.` = Mode_Freq,
           `Mode Pct.` = Mode_pct,
           `2nd Mode` = Mode_2,
           `2nd Mode Freq.` = Mode_Freq_2,
           `2nd Mode Pct.` = Mode_pct_2
    )

  return(df.cat.summary)
}
