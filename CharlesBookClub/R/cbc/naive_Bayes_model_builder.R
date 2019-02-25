# create function to quickly build and test naive Bayes models
cbc_nB_model <- function(laplace, prob_cutoff) {

  cbc.nb <- naiveBayes(Florence ~ ., data = cbc.train.nb, laplace = laplace)

  # training accuracy
  cbc.train.nb.pred <- predict(cbc.nb, newdata = cbc.train.nb, type = "raw")
  cbc.nb.train.perf <- data.frame(actual = cbc.train.nb$Florence, prob = cbc.train.nb.pred)


  # validation accuracy
  cbc.valid.nb.pred <- predict(cbc.nb, newdata = cbc.valid.nb, type = "raw")
  cbc.nb.valid.perf <- data.frame(actual = cbc.valid.nb$Florence, prob = cbc.valid.nb.pred)
  cbc.nb.valid.perf <- cbc.nb.valid.perf %>%
    mutate(Florence = factor(ifelse(cbc.nb.valid.perf$prob.Purchase < prob_cutoff,
                                    "No Purchase", "Purchase")),
           actual_1 = ifelse(actual == "Purchase", 1, 0))

  # model label
  model.name <- paste0("Naive Bayes: Laplace = ", laplace, ", proability cutoff = ", prob_cutoff)

  # create confusion matrix statistics
  conf.mat <- confusionMatrix(cbc.nb.valid.perf$Florence, cbc.valid.nb$Florence, positive = "Purchase")

  # extract metric for model evaluation
  recall <- conf.mat$byClass["Recall"]

  # grab metrics for 70% and 80% of sample to determine productivity
  pct.purchase.70 <- gain_threshold_pct(valid_df = cbc.valid.nb, valid_perf = cbc.nb.valid.perf, cutoff = 0.70, prob_var = "prob.Purchase")
  pct.purchase.80 <- gain_threshold_pct(valid_df = cbc.valid.nb, valid_perf = cbc.nb.valid.perf, cutoff = 0.80, prob_var = "prob.Purchase")
  pct.purchase.90 <- gain_threshold_pct(valid_df = cbc.valid.nb, valid_perf = cbc.nb.valid.perf, cutoff = 0.90, prob_var = "prob.Purchase")

  # create vector evaluation metrics
  model.summary <- c(model.name, recall, pct.purchase.70, pct.purchase.80, pct.purchase.90)
  names(model.summary) <- c("model", "recall", "pct_purchase_70", "pct_purchase_80", "pct_purchase_90")

  # add to model selection queue and remove duplicates
  nb.models[nrow(nb.models) + 1, ] <- c(model.summary)
  nb.models <- unique(nb.models)

}
