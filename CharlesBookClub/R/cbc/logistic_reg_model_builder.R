# create function to test different glm models
cbc_glm_model <- function(glm_model, glm_name, prob_cutoff) {

  # validation accuracy
  cbc.valid.glm.pred <- predict(glm_model, newdata = cbc.valid.glm, type = "response")
  cbc.glm.valid.perf <- data.frame(actual = cbc.valid.glm$Florence, prob = cbc.valid.glm.pred)
  cbc.glm.valid.perf <- cbc.glm.valid.perf %>%
    mutate(Florence = factor(ifelse(cbc.glm.valid.perf$prob < prob_cutoff,
                                    "No Purchase", "Purchase")),
           actual_1 = ifelse(actual == "Purchase", 1, 0))

  # model label
  model.name <- paste0("Logisitc Regression: Method = ", glm_name, ", proability cutoff = ", prob_cutoff)

  # create confusion matrix statistics
  conf.mat <- confusionMatrix(cbc.glm.valid.perf$Florence, cbc.valid.glm$Florence, positive = "Purchase")

  # extract metric for model evaluation
  recall <- conf.mat$byClass["Recall"]

  # grab metrics for 70% and 80% of sample to determine productivity
  pct.purchase.70 <- gain_threshold_pct(valid_df = cbc.valid.glm, valid_perf = cbc.glm.valid.perf, cutoff = 0.70, prob_var = "prob")
  pct.purchase.80 <- gain_threshold_pct(valid_df = cbc.valid.glm, valid_perf = cbc.glm.valid.perf, cutoff = 0.80, prob_var = "prob")
  pct.purchase.90 <- gain_threshold_pct(valid_df = cbc.valid.glm, valid_perf = cbc.glm.valid.perf, cutoff = 0.90, prob_var = "prob")

  # create vector evaluation metrics
  model.summary <- c(model.name, recall, pct.purchase.70, pct.purchase.80, pct.purchase.90)
  names(model.summary) <- c("model", "recall", "pct_purchase_70", "pct_purchase_80", "pct_purchase_90")

  # add to model selection queue and remove duplicates
  glm.models[nrow(glm.models) + 1, ] <- c(model.summary)
  glm.models <- unique(glm.models)

}
