# create function to calculate percentage of purchasers within a percentage of the sample
gain_threshold_pct <- function(valid_df, valid_perf, cutoff, prob_var) {

  n_samples <- dim(valid_df)[1] * cutoff

  gain.subset <- valid_perf %>%
    arrange(desc(get(prob_var))) %>%
    mutate(id = row_number()) %>%
    filter(id <= n_samples)

  pct.purchase <- sum(gain.subset$actual_1) / sum(valid_perf$actual_1)

  return(pct.purchase)

}
