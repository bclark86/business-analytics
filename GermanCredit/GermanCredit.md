---
title: "German Credit Decision Support"
author: "Bryan Clark"
output:
   html_document:
      self_contained: false
      toc: true
      keep_md: true
---



## Executive Summary

To process loan applications in a more efficient manner and understand factors of good credit vs. bad credit, we apply various machine learning algorithms to a dataset that has been manually evaluated by expert decision-makers. Through this process, we are able to build a predictive model to assess the probability an application will be good or bad. We then use the expected value of accepting good or bad applications to guide a recommended process for auto-accepting, auto-rejecting, or manually reviewing applications. Our process allows us to review applications at the extreme ends of the spectrum quicker, and then use the outcomes of a manual review process to further improve our model. We are able to achieve a better customer experience and reduced cost to review applications. 

## Understand

**Business Background**

German Credit is a money-lending organization that provides loans to its customers. Humans review the applications and provide a recommendation for credit using information they have collected from the customer. Upon review, the decision maker evaluates if the customer has "good credit" or "bad credit" and uses that determination to accept or reject the application.

**Business Problem & Analytics Solution**

The current process for German Credit to review applications and respond to the customer takes a lot of time. The decision maker needs to acquire any relevant data from its database on the customer (if they are a current customer of the instituion), review the status of the application, and then get together as a panel to decide whether to move forward with the application. 

The current process takes a week to complete, but German Credit has received feedback from customers and internal research that speed of approval is very important to the customer satisfaction level as customers would like to be able to action on their use of the loan quicker. German Credit believes that being able to decrease the turnaround time (TAT) of loan applications will increase the retention rate of its loan services. 

There are two methods being explored to increase the TAT of the loan application process. First, the decision makers have agreed upon a set of variables that inform their decision process. A data pipeline has been created to provide them with access to relevant data on the application without the need for them to track it down from various places. Second, we will explore using machine learning to model their decision-making criteria. The output of this model will be used to determine current factors decision makers rely on the most when making their decisions and to score future applications in an effort to "auto-accept" customers with good credit. 

To assist in the development of the decision support model, a panel of decision makers have scored a sample of 1000 applications with "good credit" or "bad credit" using 30 variables from the customer's application and any current dealings with German Credit. 

Lastly, German Credit have provided the cost/benefit of the application process. 

  * Accepting an application for good credit -- +100
  * Accepting an application for bad credit -- -500
  
The goal for the analytics product will be to develop a predictive model to use in place of the current application process. We will factor in the cost/benefit of predictions to select the model that maximizes expected profit. Based on model performance, we will recommend a cut off point for triaging applications between "auto-accept", "needs review", and "auto-reject". 


## Theorize

Based on the problem at hand, our task will be to use the set of decision criteria to see if we can accurately replicate the current decision maker's process. The goal is to operationalize their expert opinion to increase the speed of the application process, increase the throughput of applications, and reduce the costs associated with reviewing applications. Each of these business goals are believed to have a positive impact on overall customer satisfaction which should increase customer retention. 

### Dataset

Below we will explore the dataset of applications and determine the feasibility of a solution. The variables represent applicant information such as the purpose of their credit, past dealings with the bank, various financial information, and other administrative information about the customer. 

Most interesting, it appears this dataset is entirely male based on the variables described as "Applicant is male and [insert relationship stats]". This is important to note as if this project moves forward, we will need to consdier building an additional model to account for a different population of applicants and performance may suffer. 




```r
# load data definitions provided
definitions <- read_csv("data/DataDescription.csv")

# display in table
kable(definitions, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> Variable Name </th>
   <th style="text-align:left;"> Description </th>
   <th style="text-align:left;"> Variable Type </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> OBS# </td>
   <td style="text-align:left;"> Observation No. </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CHK_ACCT </td>
   <td style="text-align:left;"> Checking account status </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DURATION </td>
   <td style="text-align:left;"> Duration of credit in months </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HISTORY </td>
   <td style="text-align:left;"> Credit history </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NEW_CAR </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> USED_CAR </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FURNITURE </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RADIO/TV </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EDUCATION </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RETRAINING </td>
   <td style="text-align:left;"> Purpose of credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AMOUNT </td>
   <td style="text-align:left;"> Credit amount </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SAV_ACCT </td>
   <td style="text-align:left;"> Average balance in savings account </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EMPLOYMENT </td>
   <td style="text-align:left;"> Present employment since </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> INSTALL_RATE </td>
   <td style="text-align:left;"> Installment rate as % of disposable income </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_DIV </td>
   <td style="text-align:left;"> Applicant is male and divorced </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_SINGLE </td>
   <td style="text-align:left;"> Applicant is male and single </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_MAR_WID </td>
   <td style="text-align:left;"> Applicant is male and married or a widower </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO-APPLICANT </td>
   <td style="text-align:left;"> Application has a co-applicant </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GUARANTOR </td>
   <td style="text-align:left;"> Applicant has a guarantor </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PRESENT_RESIDENT </td>
   <td style="text-align:left;"> Present resident since - years </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> REAL_ESTATE </td>
   <td style="text-align:left;"> Applicant owns real estate </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PROP_UNKN_NONE </td>
   <td style="text-align:left;"> Applicant owns no property (or unknown) </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AGE </td>
   <td style="text-align:left;"> Age in years </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OTHER_INSTALL </td>
   <td style="text-align:left;"> Applicant has other installment plan credit </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RENT </td>
   <td style="text-align:left;"> Applicant rents </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OWN_RES </td>
   <td style="text-align:left;"> Applicant owns residence </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_CREDITS </td>
   <td style="text-align:left;"> Number of existing credits at this bank </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> JOB </td>
   <td style="text-align:left;"> Nature of job </td>
   <td style="text-align:left;"> Categorical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_DEPENDENTS </td>
   <td style="text-align:left;"> Number of people for whom liable to provide maintenance </td>
   <td style="text-align:left;"> Numerical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TELEPHONE </td>
   <td style="text-align:left;"> Applicant has phone in his or her name </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOREIGN </td>
   <td style="text-align:left;"> Foreign worker </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESPONSE </td>
   <td style="text-align:left;"> Credit rating is good </td>
   <td style="text-align:left;"> Binary </td>
  </tr>
</tbody>
</table>

### Exploratory Data Analysis

First we will pre-process our variables based on our data definitions provided. In some cases we truncate the label for plotting purposes. 


```r
# load our dataset
credit <- read_csv("data/GermanCredit.csv")

# convert categorical variables to factors with their labels
credit$CHK_ACCT <- factor(credit$CHK_ACCT, 
                          labels = c("< 0", "0 - <200", "200+", "None"))
credit$HISTORY <- factor(credit$HISTORY, 
                         labels = c("none", "current", "existing current", 
                                    "previous delays", "critical account"))
credit$SAV_ACCT <- factor(credit$SAV_ACCT, 
                          labels = c("<100", "100 - <500", 
                                     "500 - <1000", "1000+", 
                                     "unknown/none"))

credit$EMPLOYMENT <- factor(credit$EMPLOYMENT, 
                            labels = c("unemployed", "<1 year", 
                                       "1 - <4 years", "4 - <7 years", 
                                       "7+ years"))

# note the data dictionary shows 3 being >4 years, however that would invalidate this column for the case study
# in the real world, this discrepancy would need to be addressed
credit$PRESENT_RESIDENT <- factor(credit$PRESENT_RESIDENT, 
                                  labels = c("<= 1 year", ">1 - 2 years", ">2 - 3 years", ">3 years"))

credit$JOB <- factor(credit$JOB, 
                     labels = c("none/NA", #"unemployed/unskilled - non-resident",
                                "low", #"unskilled - resident",
                                "medium", #"skilled employee / official",
                                "high")) #management/ self-employed/ highly qualified employee/ officer"))

credit$RESPONSE <- factor(credit$RESPONSE, 
                          labels = c("Bad", "Good"))

credit <- credit %>%
  rename(RADIO_TV = `RADIO/TV`, 
         CO_APPLICANT = `CO-APPLICANT`)

credit.obs <- credit$`OBS#`

credit <- subset(credit, select = -`OBS#`)
```

Before we partition our data into a training and test set for modeling, let's first ensure we don't have any holes we'll need to account for. 


```r
# create function to run summary on numeric features
df_num_summary <- function(df, cols = NULL) {

  if (is.null(cols)) {
    num.cols <- colnames(select_if(df, is.numeric))
  } else {
    num.cols <- cols
  }

  df <- subset(df, select = num.cols)

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

# create function to run summary on categorical features
df_cat_summary <- function(df, cols = NULL) {

  if (is.null(cols)) {
    cat.cols <- colnames(select_if(df, is.factor))
  } else {
    cat.cols <- cols
  }

  df <- subset(df, select = cat.cols)

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
```

We do not see any missing values from our numeric variables. Our `DURATION` and `AMOUNT` variables appear to be right skewed. We may need to account for potential outliers for the `AMOUNT` variable. 


```r
credit.num.summary <- df_num_summary(df = credit)

# display in table
kable(credit.num.summary, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Count </th>
   <th style="text-align:right;"> Miss Pct. </th>
   <th style="text-align:right;"> Card. </th>
   <th style="text-align:right;"> Min. </th>
   <th style="text-align:right;"> 1st Qrt. </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> 3rd Qrt. </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Std.Dev. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> DURATION </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 12.0 </td>
   <td style="text-align:right;"> 18.0 </td>
   <td style="text-align:right;"> 20.90 </td>
   <td style="text-align:right;"> 24.00 </td>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:right;"> 12.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NEW_CAR </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.23 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> USED_CAR </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.10 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FURNITURE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.18 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RADIO_TV </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.28 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EDUCATION </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RETRAINING </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.10 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AMOUNT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 921 </td>
   <td style="text-align:right;"> 250 </td>
   <td style="text-align:right;"> 1365.5 </td>
   <td style="text-align:right;"> 2319.5 </td>
   <td style="text-align:right;"> 3271.26 </td>
   <td style="text-align:right;"> 3972.25 </td>
   <td style="text-align:right;"> 18424 </td>
   <td style="text-align:right;"> 2822.74 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> INSTALL_RATE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 2.97 </td>
   <td style="text-align:right;"> 4.00 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_DIV </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_SINGLE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.55 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_MAR_or_WID </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.09 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO_APPLICANT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GUARANTOR </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> REAL_ESTATE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.28 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PROP_UNKN_NONE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.15 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AGE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 27.0 </td>
   <td style="text-align:right;"> 33.0 </td>
   <td style="text-align:right;"> 35.55 </td>
   <td style="text-align:right;"> 42.00 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 11.38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OTHER_INSTALL </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RENT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.18 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OWN_RES </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.71 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_CREDITS </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.41 </td>
   <td style="text-align:right;"> 2.00 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.58 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_DEPENDENTS </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.16 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TELEPHONE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.40 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOREIGN </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.19 </td>
  </tr>
</tbody>
</table>

We do not have any missing categorical variables. We see no variable has a level greater than 5. 


```r
credit.cat.summary <- df_cat_summary(df = credit)

# display in table
kable(credit.cat.summary, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Count </th>
   <th style="text-align:right;"> Miss Pct. </th>
   <th style="text-align:right;"> Card. </th>
   <th style="text-align:left;"> Mode </th>
   <th style="text-align:right;"> Mode Freq. </th>
   <th style="text-align:right;"> Mode Pct. </th>
   <th style="text-align:left;"> 2nd Mode </th>
   <th style="text-align:right;"> 2nd Mode Freq. </th>
   <th style="text-align:right;"> 2nd Mode Pct. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> CHK_ACCT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> None </td>
   <td style="text-align:right;"> 394 </td>
   <td style="text-align:right;"> 39.4 </td>
   <td style="text-align:left;"> &lt; 0 </td>
   <td style="text-align:right;"> 274 </td>
   <td style="text-align:right;"> 27.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HISTORY </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> existing current </td>
   <td style="text-align:right;"> 530 </td>
   <td style="text-align:right;"> 53.0 </td>
   <td style="text-align:left;"> critical account </td>
   <td style="text-align:right;"> 293 </td>
   <td style="text-align:right;"> 29.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SAV_ACCT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> &lt;100 </td>
   <td style="text-align:right;"> 603 </td>
   <td style="text-align:right;"> 60.3 </td>
   <td style="text-align:left;"> unknown/none </td>
   <td style="text-align:right;"> 183 </td>
   <td style="text-align:right;"> 18.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EMPLOYMENT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> 1 - &lt;4 years </td>
   <td style="text-align:right;"> 339 </td>
   <td style="text-align:right;"> 33.9 </td>
   <td style="text-align:left;"> 7+ years </td>
   <td style="text-align:right;"> 253 </td>
   <td style="text-align:right;"> 25.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PRESENT_RESIDENT </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> &gt;3 years </td>
   <td style="text-align:right;"> 413 </td>
   <td style="text-align:right;"> 41.3 </td>
   <td style="text-align:left;"> &gt;1 - 2 years </td>
   <td style="text-align:right;"> 308 </td>
   <td style="text-align:right;"> 30.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> JOB </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> medium </td>
   <td style="text-align:right;"> 630 </td>
   <td style="text-align:right;"> 63.0 </td>
   <td style="text-align:left;"> low </td>
   <td style="text-align:right;"> 200 </td>
   <td style="text-align:right;"> 20.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESPONSE </td>
   <td style="text-align:right;"> 1000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Good </td>
   <td style="text-align:right;"> 700 </td>
   <td style="text-align:right;"> 70.0 </td>
   <td style="text-align:left;"> Bad </td>
   <td style="text-align:right;"> 300 </td>
   <td style="text-align:right;"> 30.0 </td>
  </tr>
</tbody>
</table>

Before plotting plotting the distributions of our variables, we will partition our data into a train and test set. The training set will use 80% of our total records and we will use cross-validation to tune our models. The test set will be saved for later to help guide the recommendations for model selection and deployment. 


```r
# set random seed for reproducibility
set.seed(123)

# create 80/20 split of train and test data indices
trainIndex <- createDataPartition(credit$RESPONSE, p = .8, 
                                  list = FALSE, 
                                  times = 1)

# create partitions
credit.train <- credit[trainIndex, ]
credit.valid <- credit[-trainIndex, ]
```


```r
# set theme
theme_set(theme_classic())

# add colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
```

After partitioning our data, we will just be using the training set to identify opportunities in developing our model. 

**Summary Statistics**


```r
credit.train.num.summary <- df_num_summary(df = credit.train)

# display in table
kable(credit.train.num.summary, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Count </th>
   <th style="text-align:right;"> Miss Pct. </th>
   <th style="text-align:right;"> Card. </th>
   <th style="text-align:right;"> Min. </th>
   <th style="text-align:right;"> 1st Qrt. </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> 3rd Qrt. </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Std.Dev. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> DURATION </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 18.0 </td>
   <td style="text-align:right;"> 20.95 </td>
   <td style="text-align:right;"> 24.0 </td>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:right;"> 12.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NEW_CAR </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.22 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> USED_CAR </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.11 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.31 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FURNITURE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.18 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RADIO_TV </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.28 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EDUCATION </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RETRAINING </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.10 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AMOUNT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 752 </td>
   <td style="text-align:right;"> 250 </td>
   <td style="text-align:right;"> 1382 </td>
   <td style="text-align:right;"> 2350.5 </td>
   <td style="text-align:right;"> 3308.29 </td>
   <td style="text-align:right;"> 3968.5 </td>
   <td style="text-align:right;"> 18424 </td>
   <td style="text-align:right;"> 2845.80 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> INSTALL_RATE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 2.98 </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_DIV </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_SINGLE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.55 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_MAR_or_WID </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO_APPLICANT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GUARANTOR </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> REAL_ESTATE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.28 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PROP_UNKN_NONE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AGE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 33.0 </td>
   <td style="text-align:right;"> 35.79 </td>
   <td style="text-align:right;"> 42.0 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 11.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OTHER_INSTALL </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RENT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OWN_RES </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.70 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_CREDITS </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.41 </td>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NUM_DEPENDENTS </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.14 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TELEPHONE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.40 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOREIGN </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.18 </td>
  </tr>
</tbody>
</table>


```r
credit.train.cat.summary <- df_cat_summary(df = credit.train)

# display in table
kable(credit.train.cat.summary, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Count </th>
   <th style="text-align:right;"> Miss Pct. </th>
   <th style="text-align:right;"> Card. </th>
   <th style="text-align:left;"> Mode </th>
   <th style="text-align:right;"> Mode Freq. </th>
   <th style="text-align:right;"> Mode Pct. </th>
   <th style="text-align:left;"> 2nd Mode </th>
   <th style="text-align:right;"> 2nd Mode Freq. </th>
   <th style="text-align:right;"> 2nd Mode Pct. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> CHK_ACCT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> None </td>
   <td style="text-align:right;"> 314 </td>
   <td style="text-align:right;"> 39.2 </td>
   <td style="text-align:left;"> &lt; 0 </td>
   <td style="text-align:right;"> 223 </td>
   <td style="text-align:right;"> 27.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HISTORY </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> existing current </td>
   <td style="text-align:right;"> 420 </td>
   <td style="text-align:right;"> 52.5 </td>
   <td style="text-align:left;"> critical account </td>
   <td style="text-align:right;"> 237 </td>
   <td style="text-align:right;"> 29.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SAV_ACCT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> &lt;100 </td>
   <td style="text-align:right;"> 483 </td>
   <td style="text-align:right;"> 60.4 </td>
   <td style="text-align:left;"> unknown/none </td>
   <td style="text-align:right;"> 147 </td>
   <td style="text-align:right;"> 18.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EMPLOYMENT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> 1 - &lt;4 years </td>
   <td style="text-align:right;"> 269 </td>
   <td style="text-align:right;"> 33.6 </td>
   <td style="text-align:left;"> 7+ years </td>
   <td style="text-align:right;"> 207 </td>
   <td style="text-align:right;"> 25.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PRESENT_RESIDENT </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> &gt;3 years </td>
   <td style="text-align:right;"> 337 </td>
   <td style="text-align:right;"> 42.1 </td>
   <td style="text-align:left;"> &gt;1 - 2 years </td>
   <td style="text-align:right;"> 236 </td>
   <td style="text-align:right;"> 29.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> JOB </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> medium </td>
   <td style="text-align:right;"> 508 </td>
   <td style="text-align:right;"> 63.5 </td>
   <td style="text-align:left;"> low </td>
   <td style="text-align:right;"> 152 </td>
   <td style="text-align:right;"> 19.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESPONSE </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Good </td>
   <td style="text-align:right;"> 560 </td>
   <td style="text-align:right;"> 70.0 </td>
   <td style="text-align:left;"> Bad </td>
   <td style="text-align:right;"> 240 </td>
   <td style="text-align:right;"> 30.0 </td>
  </tr>
</tbody>
</table>

**Plots**

*Continuous Features*

The `DURATION` distributions confirm a right-skewed distribution. Additionally, it appears Bad credit is associated with longer credit durations. 


```r
# duration
ggplot(credit.train, aes(x = DURATION)) +
  geom_histogram(aes(y =..density..), color = "black", fill = "grey", binwidth = 1) +
  geom_density(fill= "grey", alpha = 0.4)
```

![](GermanCredit_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

```r
ggplot(credit.train, aes(x = DURATION, fill = RESPONSE)) +
  #geom_histogram(aes(y =..density..), color = "black", position = "identity", binwidth = 1, alpha = 0.5) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-11-2.png)<!-- -->

```r
ggplot(credit.train, aes(x = RESPONSE, y = DURATION, fill = RESPONSE)) +
  geom_boxplot() +
  coord_flip() +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-11-3.png)<!-- -->

The `AMOUNT` variable is also right-skewed with Bad credit showing slightly larger credit amounts. 


```r
# amount
ggplot(credit.train, aes(x = AMOUNT)) +
  geom_histogram(aes(y =..density..), color = "black", fill = "grey", binwidth = 100) +
  geom_density(fill= "grey", alpha = 0.4)
```

![](GermanCredit_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

```r
ggplot(credit.train, aes(x = AMOUNT, fill = RESPONSE)) +
  #geom_histogram(aes(y =..density..), color = "black", position = "identity", binwidth = 250, alpha = 0.5) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-12-2.png)<!-- -->

```r
ggplot(credit.train, aes(x = RESPONSE, y = AMOUNT, fill = RESPONSE)) +
  geom_boxplot() +
  coord_flip() +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-12-3.png)<!-- -->

The age of applicants tends to be lower for Bad credit labels compared to Good credit labels. 


```r
# age
ggplot(credit.train, aes(x = AGE)) +
  geom_histogram(aes(y =..density..), color = "black", fill = "grey", binwidth = 2) +
  geom_density(color = "grey", alpha = 0.4)
```

![](GermanCredit_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

```r
ggplot(credit.train, aes(x = AGE, fill = RESPONSE)) +
  #geom_histogram(aes(y =..density..), color = "black", position = "identity", binwidth = 2, alpha = 0.5) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-13-2.png)<!-- -->

```r
ggplot(credit.train, aes(x = RESPONSE, y = AGE, fill = RESPONSE)) +
  geom_boxplot() +
  coord_flip() +
  scale_fill_manual(values = c(cbPalette[7], cbPalette[4]))
```

![](GermanCredit_files/figure-html/unnamed-chunk-13-3.png)<!-- -->

*Binary Features*

In plotting binary features by our target, `NEW_CAR`, `USED_CAR`, and `RENT` display interesting variability in seperating the target feature. 


```r
bin.vars <- c("NEW_CAR", "USED_CAR", "FURNITURE", "RADIO_TV", "EDUCATION", "RETRAINING",
          "MALE_DIV", "MALE_SINGLE", "MALE_MAR_or_WID", 
          "CO_APPLICANT", "GUARANTOR", "REAL_ESTATE", "PROP_UNKN_NONE", "OTHER_INSTALL",
          "RENT", "OWN_RES", "TELEPHONE", "FOREIGN")

for (var in bin.vars) {
  
  form <- as.formula(paste("~ ", var, "+ RESPONSE"))
  
  mosaicplot(form, data = credit.train,
             col = c(cbPalette[7], cbPalette[4]),
             cex.axis = 0.45,
             xlab = var,
             main = "")
}
```

![](GermanCredit_files/figure-html/unnamed-chunk-14-1.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-2.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-3.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-4.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-5.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-6.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-7.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-8.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-9.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-10.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-11.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-12.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-13.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-14.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-15.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-16.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-17.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-14-18.png)<!-- -->


*Categorical Features*

In reviewing the distributions of our categorical variables compared to the target variable, `CHK_ACCT` stands out as a potentially important variable. 


```r
cat.vars <- c("CHK_ACCT", "HISTORY", "SAV_ACCT", "EMPLOYMENT", "INSTALL_RATE", 
          "PRESENT_RESIDENT", "NUM_CREDITS", "JOB", "NUM_DEPENDENTS")

for (var in cat.vars) {
  
  form <- as.formula(paste("~ ", var, "+ RESPONSE"))
  
  mosaicplot(form, data = credit.train,
             col = c(cbPalette[7], cbPalette[4]),
             cex.axis = 0.45,
             xlab = var,
             main = "")
}
```

![](GermanCredit_files/figure-html/unnamed-chunk-15-1.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-2.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-3.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-4.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-5.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-6.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-7.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-8.png)<!-- -->![](GermanCredit_files/figure-html/unnamed-chunk-15-9.png)<!-- -->

*Multivariate Analysis*

In reviewing correlations of our numeric variables, we see a strong negative correlation between `OWN_RES` and `RENT`, which is unsurprising. `DURATION` and `AMOUNT` also show a positive correlation.


```r
drop.vars <- c("CHK_ACCT", "HISTORY", "SAV_ACCT", "EMPLOYMENT", "INSTALL_RATE", 
          "PRESENT_RESIDENT", "NUM_CREDITS", "JOB", "NUM_DEPENDENTS")

# isolate variables for correlation
credit.corr <- credit.train %>%
  select(-one_of(drop.vars)) %>%
  mutate(RESPONSE = ifelse(RESPONSE == "Good", 1, 0))

# create correlation matrix
cor.mat <- round(cor(credit.corr), 2)
melted.cor.mat <- melt(cor.mat)

# plot correlation heatmap
ggplot(melted.cor.mat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white",
                       name = "Pearson Correlation") +
  labs(title = "German Credit Correlation Heatmap") +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 1.5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.title.x = element_blank(), axis.title.y = element_blank())
```

![](GermanCredit_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

When comparing the mean values of `DURATION`, `AMOUNT`, and `AGE` across Bad and Good credit, we see statistically significant differences. These will most likely be important variables to separate our classes. 


```r
credit.mean <- credit.train %>%
  select(DURATION, AMOUNT, AGE, RESPONSE)

categories <- colnames(credit.mean)

credit.ttest <- data.frame(Category = categories[1:3], 
                                 p_value = rep(0,3))


# loop to run through each variable for ttest
for (i in 1:nrow(credit.ttest)) {

  var <- categories[i]
  
  p <- t.test(get(var) ~ RESPONSE, data = credit.mean)$p.value
  
  credit.ttest[i, 2] <- round(p, 4)
}

# display in table
kable(credit.ttest, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> p_value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> DURATION </td>
   <td style="text-align:right;"> 0.0000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AMOUNT </td>
   <td style="text-align:right;"> 0.0004 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AGE </td>
   <td style="text-align:right;"> 0.0011 </td>
  </tr>
</tbody>
</table>


Testing the proportions of our binary variables shows some potentially significant differences for variables `OWN_RES`, `PROP_UNKN_NONE`, `OTHER_INSTALL`, and some others. We are running multiple tests, so there are likely false positives in our test results. 


```r
credit.prop <- credit.train %>%
  select(-DURATION, -AMOUNT, -INSTALL_RATE, -AGE, -NUM_CREDITS, 
         -NUM_DEPENDENTS, -CHK_ACCT, -HISTORY, -SAV_ACCT, -EMPLOYMENT, 
         -PRESENT_RESIDENT, -JOB)

categories <- colnames(credit.prop)

credit.prop.test <- data.frame(Category = categories[1:18], 
                                 p_value = rep(0,18))


# loop to run through each variable for ttest
for (i in 1:nrow(credit.prop.test)) {

  var <- categories[i]
  
  dat <- credit.prop %>% select(RESPONSE, var)
  
  test.table <- table(dat)
  test.table <- test.table[ , c(2, 1)]
  
  p <- prop.test(test.table)$p.value
  
  credit.prop.test[i, 2] <- round(p, 4)
}

# display in table
credit.prop.test %>%
  arrange(p_value) %>%
  kable(type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> p_value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> OWN_RES </td>
   <td style="text-align:right;"> 0.0001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PROP_UNKN_NONE </td>
   <td style="text-align:right;"> 0.0009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OTHER_INSTALL </td>
   <td style="text-align:right;"> 0.0022 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RADIO_TV </td>
   <td style="text-align:right;"> 0.0026 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> USED_CAR </td>
   <td style="text-align:right;"> 0.0027 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> REAL_ESTATE </td>
   <td style="text-align:right;"> 0.0032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RENT </td>
   <td style="text-align:right;"> 0.0042 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NEW_CAR </td>
   <td style="text-align:right;"> 0.0126 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EDUCATION </td>
   <td style="text-align:right;"> 0.0515 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_SINGLE </td>
   <td style="text-align:right;"> 0.0543 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CO_APPLICANT </td>
   <td style="text-align:right;"> 0.0676 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOREIGN </td>
   <td style="text-align:right;"> 0.1016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GUARANTOR </td>
   <td style="text-align:right;"> 0.1323 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TELEPHONE </td>
   <td style="text-align:right;"> 0.1394 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RETRAINING </td>
   <td style="text-align:right;"> 0.2472 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FURNITURE </td>
   <td style="text-align:right;"> 0.4685 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_DIV </td>
   <td style="text-align:right;"> 0.5954 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE_MAR_or_WID </td>
   <td style="text-align:right;"> 1.0000 </td>
  </tr>
</tbody>
</table>


## Prototype

Before moving forward with prototyping various models, we want to first remove predictors that have near zero variance in the training sample. These are variables that are likely to be uninformative for our modeling. We see two variables have been removed due to low variance. 


```r
# remove variables with low variance
nzv <- nearZeroVar(credit.train)
credit.train <- credit.train[ , -nzv]
credit.valid <- credit.valid[ , -nzv]

print(nzv)
```

```
## [1] 17 30
```

The first model we build is a logistic regression using all of the remaining variables. Using a 10-fold repeated cross-validation, we produce an accuracy of about 75%. This is an improvement above the baseline of 70%, which is the proportion of Good samples in our dataset. We use the Box-Cox transformation to handle any skewness of our variables. 


```r
# add controls for training model
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE
                     #summaryFunction = twoClassSummary
                     )

# set seed to compare models
set.seed(123)

glm.all <- train(RESPONSE ~ ., data = credit.train,
              method = "glm",
              #metric = "ROC",
              preProc = c("BoxCox"),
              trControl = ctrl)

glm.all
```

```
## Generalized Linear Model 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## Pre-processing: Box-Cox transformation (5) 
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results:
## 
##   Accuracy  Kappa    
##   0.7565    0.3900469
```

Using our initial logistic model, we use backwards stepwise selection to preduce our predictors. This produces a mild improvement in our accuracy while reducing our model to 18 predictors. 


```r
glm.all.step <- glm(RESPONSE ~ ., data = credit.train, family = "binomial")
glm.step.back <- step(glm.all.step, direction = "backward", trace = 0)

# set seed to compare models
set.seed(123)

glm.back <- train(glm.step.back$formula, data = credit.train,
              method = "glm",
              #metric = "ROC", 
              preProc = c("BoxCox"),
              trControl = ctrl)

glm.back
```

```
## Generalized Linear Model 
## 
## 800 samples
##  18 predictor
##   2 classes: 'Bad', 'Good' 
## 
## Pre-processing: Box-Cox transformation (5) 
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results:
## 
##   Accuracy  Kappa    
##   0.76375   0.4050818
```

Next, we use forward stepwise selection on our logisitc model. This method reduces our model to 17 predictors without much of a difference in performance from our full and backwards logistic models. 


```r
min.model <-  glm(RESPONSE ~ 1, data = credit.train, family = "binomial")
biggest <- formula(glm( RESPONSE ~ ., data = credit.train, family = "binomial"))

glm.step.for <- step(min.model, direction = "forward", scope = biggest, trace = 0)

# set seed to compare models
set.seed(123)

glm.for <- train(glm.step.for$formula, data = credit.train,
              method = "glm",
              #metric = "ROC",
              preProc = c("BoxCox"),
              trControl = ctrl)

glm.for
```

```
## Generalized Linear Model 
## 
## 800 samples
##  17 predictor
##   2 classes: 'Bad', 'Good' 
## 
## Pre-processing: Box-Cox transformation (5) 
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results:
## 
##   Accuracy  Kappa    
##   0.75975   0.3925573
```

Next, we increase explore using classification trees with a random search over the parameter grid. In testing 10 different models, we max our accuracy out at around 72%. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )
# set seed to compare models
set.seed(123)

ct <- train(RESPONSE ~ ., data = credit.train,
            method = "rpart",
            #metric = "ROC", 
            trControl = ctrl,
            tuneLength = 10
            )

ct
```

```
## CART 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   cp           Accuracy  Kappa     
##   0.000000000  0.70350   0.26566236
##   0.005555556  0.71350   0.26938587
##   0.006944444  0.72075   0.28005186
##   0.010000000  0.72200   0.26630999
##   0.020833333  0.71325   0.23582428
##   0.027083333  0.70725   0.21055744
##   0.045833333  0.70025   0.09415541
##   0.047916667  0.69500   0.05228968
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was cp = 0.01.
```

Using a slightly different classification tree method, we max our accuracy out at 72% with a tree depth of 11. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )

# set seed to compare models
set.seed(123)

ct2 <- train(RESPONSE ~ ., data = credit.train,
             method = "rpart2",
             #metric = "ROC", 
             trControl = ctrl,
             tuneLength = 10)

ct2
```

```
## CART 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   maxdepth  Accuracy  Kappa    
##    2        0.71125   0.1909295
##    3        0.71175   0.2201995
##    4        0.71500   0.2355226
##    8        0.72050   0.2598728
##   11        0.72275   0.2654983
##   17        0.72200   0.2663100
##   20        0.72200   0.2663100
##   29        0.72200   0.2663100
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was maxdepth = 11.
```

Next we explore using k-nearest neighbors model across several values of k. We max our accuracy out at 73% using the nearest 47 neighbors. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )

grid = expand.grid(k = seq(3, 51, 2))

# set seed to compare models
set.seed(123)

knn <- train(RESPONSE ~ ., data = credit.train,
            method = "knn",
            #metric = "ROC", 
            trControl = ctrl,
            preProc = c("BoxCox", "center", "scale"),
            tuneGrid = grid
            )

knn
```

```
## k-Nearest Neighbors 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## Pre-processing: Box-Cox transformation (5), centered (43), scaled (43) 
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   k   Accuracy  Kappa    
##    3  0.70925   0.2598501
##    5  0.70775   0.2316811
##    7  0.70650   0.2240451
##    9  0.70550   0.2050742
##   11  0.70925   0.2059110
##   13  0.70700   0.1885794
##   15  0.70400   0.1655101
##   17  0.70850   0.1754343
##   19  0.70725   0.1645962
##   21  0.70800   0.1599056
##   23  0.71050   0.1652140
##   25  0.71475   0.1737182
##   27  0.71100   0.1513471
##   29  0.71300   0.1516990
##   31  0.71900   0.1643922
##   33  0.72275   0.1680119
##   35  0.71925   0.1535694
##   37  0.71975   0.1507750
##   39  0.72150   0.1519236
##   41  0.72450   0.1575674
##   43  0.72525   0.1575965
##   45  0.72725   0.1599940
##   47  0.72800   0.1582270
##   49  0.72500   0.1469340
##   51  0.72425   0.1406629
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was k = 47.
```

Next, we move to more complex models to see if we can improve on our initial logistic model with more "black box" methods. A random search gets us closer with an accuracy of 75%. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )

# set seed to compare models
set.seed(123)

nn <- train(RESPONSE ~ ., data = credit.train,
            method = "nnet",
            preProc = c("BoxCox", "center", "scale"),
            #metric = "ROC", 
            trControl = ctrl,
            tuneLength = 10,
            trace = FALSE)

nn
```

```
## Neural Network 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## Pre-processing: Box-Cox transformation (5), centered (43), scaled (43) 
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   size  decay         Accuracy  Kappa    
##    1    2.505820e+00  0.74775   0.3506237
##    9    1.162583e-01  0.70950   0.3024253
##   10    5.333618e+00  0.74450   0.3143395
##   11    2.995894e-04  0.69900   0.2849435
##   12    9.279494e-04  0.69875   0.2770412
##   16    5.248134e-03  0.71125   0.2961710
##   18    1.787958e-05  0.69625   0.2590369
##   18    2.727724e-02  0.71900   0.3127534
##   19    4.145225e-05  0.69950   0.2733467
##   20    2.173882e+00  0.75625   0.3794894
## 
## Accuracy was used to select the optimal model using the largest value.
## The final values used for the model were size = 20 and decay = 2.173882.
```

Across a random search of random forest parameters, we produce an accuracy of 74%. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )
# set seed to compare models
set.seed(123)

rf <- train(RESPONSE ~ ., data = credit.train,
            method = "rf",
            #metric = "ROC", 
            trControl = ctrl,
            tuneLength = 10)

rf
```

```
## Random Forest 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy  Kappa    
##    2    0.72725   0.1558377
##   18    0.74425   0.3225642
##   20    0.74425   0.3230032
##   23    0.74125   0.3190801
##   24    0.74150   0.3207972
##   34    0.73875   0.3213285
##   38    0.73725   0.3186434
##   39    0.73825   0.3218119
##   41    0.73625   0.3210190
##   42    0.73600   0.3160522
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was mtry = 18.
```

Lastly, we try a boosting model to see if we can increase our accuracy further. A random grid search across 10 models provides us with an accuracy of around 75%. 


```r
ctrl <- trainControl(method = "repeatedcv", 
                     number = 10,
                     repeats = 5,
                     classProbs = TRUE, 
                     #summaryFunction = twoClassSummary,
                     search = "random"
                     )
# set seed to compare models
set.seed(123)

xgb <- train(RESPONSE ~ ., data = credit.train,
            method = "xgbTree",
            #metric = "ROC", 
            trControl = ctrl,
            tuneLength = 10)

xgb
```

```
## eXtreme Gradient Boosting 
## 
## 800 samples
##  28 predictor
##   2 classes: 'Bad', 'Good' 
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 5 times) 
## Summary of sample sizes: 720, 720, 720, 720, 720, 720, ... 
## Resampling results across tuning parameters:
## 
##   eta         max_depth  gamma      colsample_bytree  min_child_weight
##   0.08912107  10         2.3162579  0.6431311          7              
##   0.17420668   4         3.1818101  0.4063891         18              
##   0.32689555   3         7.5845954  0.3932136          2              
##   0.35689107   1         2.1640794  0.4863850         15              
##   0.38466358   7         6.9070528  0.4654897         16              
##   0.39376777   2         0.2461368  0.3609779         11              
##   0.41598924   5         9.0229905  0.4658185          9              
##   0.42540975   9         4.7779597  0.3555224          4              
##   0.57785152   9         1.4280002  0.3183325         13              
##   0.59656760   6         7.9546742  0.4475382          2              
##   subsample  nrounds  Accuracy  Kappa    
##   0.5798738  457      0.73750   0.3305658
##   0.8457567  552      0.73650   0.2995724
##   0.8575483  529      0.74425   0.3080856
##   0.8592921  893      0.73025   0.2848044
##   0.5379772  409      0.73725   0.2923941
##   0.8609800  941      0.70975   0.2725137
##   0.3211305  789      0.73200   0.2816812
##   0.5863873   46      0.74725   0.3399415
##   0.8158564  957      0.72575   0.3003962
##   0.4557877  884      0.73225   0.3266194
## 
## Accuracy was used to select the optimal model using the largest value.
## The final values used for the model were nrounds = 46, max_depth = 9,
##  eta = 0.4254098, gamma = 4.77796, colsample_bytree =
##  0.3555224, min_child_weight = 4 and subsample = 0.5863873.
```

Since we resample the same folds for evaluating our models, we can compare the accuracies of the different tests. Our logistic models show the highest median accuracies. This is benefical as the logistic model will be more transparent in terms of variable importance. 


```r
resamp <- resamples(list(Logistic_all  = glm.all,
                         Logistic_back = glm.back,
                         Logistic_for  = glm.for,
                         CART          = ct,
                         CART_2        = ct2,
                         K_NN          = knn,
                         Neural_Net    = nn,
                         Random_Forest = rf,
                         XGBoost       = xgb))

summary(resamp)
```

```
## 
## Call:
## summary.resamples(object = resamp)
## 
## Models: Logistic_all, Logistic_back, Logistic_for, CART, CART_2, K_NN, Neural_Net, Random_Forest, XGBoost 
## Number of resamples: 50 
## 
## Accuracy 
##                 Min.  1st Qu.  Median    Mean  3rd Qu.   Max. NA's
## Logistic_all  0.6500 0.725000 0.76250 0.75650 0.796875 0.8500    0
## Logistic_back 0.6625 0.740625 0.76250 0.76375 0.787500 0.8625    0
## Logistic_for  0.6500 0.725000 0.75625 0.75975 0.787500 0.8625    0
## CART          0.6000 0.700000 0.72500 0.72200 0.750000 0.8000    0
## CART_2        0.6000 0.700000 0.73125 0.72275 0.750000 0.8125    0
## K_NN          0.6625 0.712500 0.72500 0.72800 0.737500 0.8000    0
## Neural_Net    0.6500 0.725000 0.76250 0.75625 0.787500 0.8500    0
## Random_Forest 0.5875 0.715625 0.75000 0.74425 0.775000 0.8250    0
## XGBoost       0.6375 0.725000 0.73750 0.74725 0.775000 0.8250    0
## 
## Kappa 
##                      Min.    1st Qu.    Median      Mean   3rd Qu.
## Logistic_all   0.14473684 0.31250000 0.4017480 0.3900469 0.4869600
## Logistic_back  0.14473684 0.35363248 0.4135802 0.4050818 0.4938272
## Logistic_for   0.16666667 0.29927885 0.3944890 0.3925573 0.4620253
## CART          -0.14285714 0.18942710 0.2644280 0.2663100 0.3421053
## CART_2        -0.14285714 0.18942710 0.2792081 0.2654983 0.3411378
## K_NN          -0.03846154 0.08730159 0.1666667 0.1582270 0.2164179
## Neural_Net     0.10256410 0.31250000 0.3953130 0.3794894 0.4719878
## Random_Forest -0.13013699 0.23883032 0.3423791 0.3225642 0.4192814
## XGBoost        0.08227848 0.26159901 0.3323557 0.3399415 0.4078947
##                    Max. NA's
## Logistic_all  0.6153846    0
## Logistic_back 0.6428571    0
## Logistic_for  0.6428571    0
## CART          0.4871795    0
## CART_2        0.5238095    0
## K_NN          0.4117647    0
## Neural_Net    0.6052632    0
## Random_Forest 0.5512821    0
## XGBoost       0.5625000    0
```


```r
model.differences <- diff(resamp)

summary(model.differences)
```

```
## 
## Call:
## summary.diff.resamples(object = model.differences)
## 
## p-value adjustment: bonferroni 
## Upper diagonal: estimates of the difference
## Lower diagonal: p-value for H0: difference = 0
## 
## Accuracy 
##               Logistic_all Logistic_back Logistic_for CART      CART_2   
## Logistic_all               -0.00725      -0.00325      0.03450   0.03375 
## Logistic_back 1.0000000                   0.00400      0.04175   0.04100 
## Logistic_for  1.0000000    1.0000000                   0.03775   0.03700 
## CART          0.0001308    1.238e-06     1.576e-05              -0.00075 
## CART_2        0.0011054    2.398e-05     0.0001636    1.0000000          
## K_NN          0.0007890    8.008e-06     0.0001724    1.0000000 1.0000000
## Neural_Net    1.0000000    1.0000000     1.0000000    0.0001622 0.0005941
## Random_Forest 1.0000000    0.1152607     0.9091733    0.0013742 0.0033661
## XGBoost       1.0000000    0.5080848     1.0000000    0.0070903 0.0088843
##               K_NN      Neural_Net Random_Forest XGBoost 
## Logistic_all   0.02850   0.00025    0.01225       0.00925
## Logistic_back  0.03575   0.00750    0.01950       0.01650
## Logistic_for   0.03175   0.00350    0.01550       0.01250
## CART          -0.00600  -0.03425   -0.02225      -0.02525
## CART_2        -0.00525  -0.03350   -0.02150      -0.02450
## K_NN                    -0.02825   -0.01625      -0.01925
## Neural_Net    0.0008529             0.01200       0.00900
## Random_Forest 0.4047475 1.0000000                -0.00300
## XGBoost       0.0667534 1.0000000  1.0000000             
## 
## Kappa 
##               Logistic_all Logistic_back Logistic_for CART      
## Logistic_all               -0.0150350    -0.0025104    0.1237369
## Logistic_back 1.0000000                   0.0125246    0.1387719
## Logistic_for  1.0000000    1.0000000                   0.1262473
## CART          1.072e-06    5.652e-08     6.251e-07              
## CART_2        3.853e-06    2.966e-07     2.073e-06    1.0000000 
## K_NN          < 2.2e-16    < 2.2e-16     2.370e-16    0.0001967 
## Neural_Net    1.0000000    0.6525794     1.0000000    1.183e-05 
## Random_Forest 0.0120946    0.0004971     0.0126930    0.0022326 
## XGBoost       0.2763252    0.0119210     0.1503092    0.0050315 
##               CART_2     K_NN       Neural_Net Random_Forest XGBoost   
## Logistic_all   0.1245486  0.2318199  0.0105575  0.0674827     0.0501054
## Logistic_back  0.1395835  0.2468549  0.0255925  0.0825176     0.0651403
## Logistic_for   0.1270589  0.2343303  0.0130679  0.0699931     0.0526157
## CART           0.0008117  0.1080830 -0.1131794 -0.0562542    -0.0736315
## CART_2                    0.1072713 -0.1139910 -0.0570659    -0.0744432
## K_NN          0.0002971             -0.2212624 -0.1643372    -0.1817145
## Neural_Net    1.690e-05  < 2.2e-16              0.0569252     0.0395478
## Random_Forest 0.0035424  5.364e-10  0.0991966                -0.0173773
## XGBoost       0.0025545  9.205e-13  1.0000000  1.0000000
```




```r
bwplot(resamp, main = "Model Metric Comparison")
```

![](GermanCredit_files/figure-html/unnamed-chunk-31-1.png)<!-- -->


```r
dotplot(resamp, metric = "Accuracy", main = "Model Accuracy Confidence Intervals")
```

![](GermanCredit_files/figure-html/unnamed-chunk-32-1.png)<!-- -->

We can also review the variable importance of each of our models. We see `CHK_ACCT`, `SAV_ACCT`, `AGE`, and `DURATION` are common variables in the top 10 for each model. 


```r
log_back_imp <- varImp(glm.back)
log_all_imp  <- varImp(glm.all)
xgb_imp      <- varImp(xgb)
nn_imp       <- varImp(nn)
rf_imp       <- varImp(rf)
```


```r
plot(log_back_imp, top = 10, main = "Backward Stepwise Logistic Regression")
```

![](GermanCredit_files/figure-html/unnamed-chunk-34-1.png)<!-- -->


```r
plot(log_all_imp, top = 10, main = "Full Logisitc Regression")
```

![](GermanCredit_files/figure-html/unnamed-chunk-35-1.png)<!-- -->


```r
plot(xgb_imp, top = 10, main = "XgBoost")
```

![](GermanCredit_files/figure-html/unnamed-chunk-36-1.png)<!-- -->


```r
plot(nn_imp, top = 10, main = "Neural Net")
```

![](GermanCredit_files/figure-html/unnamed-chunk-37-1.png)<!-- -->


```r
plot(rf_imp, top = 10, main = "Random Forest")
```

![](GermanCredit_files/figure-html/unnamed-chunk-38-1.png)<!-- -->

## Test

Our initial tests show the logistic models perform well in our dataset compared to more complex models. We will use the test set we partitioned to evaluate the expected profits of the backwards logistic regression, gradient boosted, and random forest models. We will refer back to the profit for loans approved to select the best model and make recommendations for reviewing applications. 

As a refresher, for applications that are approved, a Good loan returns +100 in profit, and a Bad loan costs -500 in profit. 

To evaluate our models, we will view the ROC scores of our training and test sets to see how well the classes separate. Then we will determine the optimal cutoff points for probabilities to maximixe separation. 


```r
# function to plot ROC curves from ROCR objects
plot_roc <- function(train_roc, train_auc, test_roc, test_auc) {
  
  plot(train_roc, col = "blue", lty = "solid", main = "", lwd = 2,
       xlab = "False Positive Rate",
       ylab = "True Positive Rate")
  plot(test_roc, col = "red", lty = "dashed", lwd = 2, add = TRUE)
  abline(c(0,1))
  # draw legend
  train.legend <- paste("Training AUC = ", round(train_auc, digits = 3))
  test.legend <- paste("Test AUC = ", round(test_auc, digits = 3))
  legend("bottomright", legend = c(train.legend, test.legend),
         lty = c("solid", "dashed"), lwd = 2, col = c("blue", "red"))
  
}

# function to determine optimal cutoff point
opt.cut <-  function(perf, pred){
    cut.ind <-  mapply(FUN = function(x, y, p) {
        d <- (x - 0) ^ 2 + (y - 1) ^ 2
        ind <-  which(d == min(d))
        c(sensitivity = y[[ind]], specificity = 1 - x[[ind]], 
            cutoff = p[[ind]])
    }, perf@x.values, perf@y.values, pred@cutoffs)
}
```

Our logistic regression model produces a decent ROC score with an optimal cutoff probability of 0.67.


```r
# training metrics for backward step logistic regression
credit.train$log_back_prob <- predict.train(glm.back, 
                                            newdata = credit.train, 
                                            type = "prob")[ ,2]
credit.train.log_back_pred <- prediction(credit.train$log_back_prob, credit.train$RESPONSE)
credit.train.log_back.auc  <- as.numeric(performance(credit.train.log_back_pred, "auc")@y.values)
credit.train.roc <- performance(credit.train.log_back_pred, "tpr", "fpr")

# test accuracy for backward step logistic regression
credit.valid$log_back_prob <- predict.train(glm.back, 
                                            newdata = credit.valid, 
                                            type = "prob")[ ,2]
credit.valid.log_back_pred <- prediction(credit.valid$log_back_prob, credit.valid$RESPONSE)
credit.valid.log_back.auc  <- as.numeric(performance(credit.valid.log_back_pred, "auc")@y.values)
credit.valid.roc <- performance(credit.valid.log_back_pred, "tpr", "fpr")

# plot ROC/AUC scores
plot_roc(train_roc = credit.train.roc,
         train_auc = credit.train.log_back.auc,
         test_roc = credit.valid.roc,
         test_auc = credit.valid.log_back.auc)
```

![](GermanCredit_files/figure-html/unnamed-chunk-40-1.png)<!-- -->

```r
print(opt.cut(credit.valid.roc, credit.valid.log_back_pred))
```

```
##                  [,1]
## sensitivity 0.8000000
## specificity 0.7000000
## cutoff      0.6664984
```

The gradient boosted model drops slightly in performance across the test set compared to the logistic model. This is similar to what we saw in the model building process. 


```r
# training metrics for xgboost model
credit.train$xgb_prob <- predict.train(xgb, 
                                       newdata = credit.train, 
                                       type = "prob")[ ,2]
credit.train.xgb_pred <- prediction(credit.train$xgb_prob, credit.train$RESPONSE)
credit.train.xgb.auc  <- as.numeric(performance(credit.train.xgb_pred, "auc")@y.values)
credit.train.roc <- performance(credit.train.xgb_pred, "tpr", "fpr")

# test accuracy for xgboost model
credit.valid$xgb_prob <- predict.train(xgb, 
                                       newdata = credit.valid, 
                                       type = "prob")[ ,2]
credit.valid.xgb_pred <- prediction(credit.valid$xgb_prob, credit.valid$RESPONSE)
credit.valid.xgb.auc  <- as.numeric(performance(credit.valid.xgb_pred, "auc")@y.values)
credit.valid.roc <- performance(credit.valid.xgb_pred, "tpr", "fpr")

# plot ROC/AUC scores
plot_roc(train_roc = credit.train.roc,
         train_auc = credit.train.xgb.auc,
         test_roc = credit.valid.roc,
         test_auc = credit.valid.xgb.auc)
```

![](GermanCredit_files/figure-html/unnamed-chunk-41-1.png)<!-- -->

```r
print(opt.cut(credit.valid.roc, credit.valid.xgb_pred))
```

```
##                  [,1]
## sensitivity 0.7214286
## specificity 0.7166667
## cutoff      0.6946105
```

For the random forest, we see it overfits the training set and performs much worse on the test set. Again, the logistic regression still shows the best ROC score. 


```r
credit.valid$rf_prob <- predict.train(rf, 
                                      newdata = credit.valid, 
                                      type = "prob")[ ,2]

# training metrics for xgboost model
credit.train$rf_prob <- predict.train(rf, 
                                      newdata = credit.train, 
                                      type = "prob")[ ,2]
credit.train.rf_pred <- prediction(credit.train$rf_prob, credit.train$RESPONSE)
credit.train.rf.auc  <- as.numeric(performance(credit.train.rf_pred, "auc")@y.values)
credit.train.roc <- performance(credit.train.rf_pred, "tpr", "fpr")

# test accuracy for xgboost model
credit.valid$rf_prob <- predict.train(rf, 
                                      newdata = credit.valid, 
                                      type = "prob")[ ,2]
credit.valid.rf_pred <- prediction(credit.valid$rf_prob, credit.valid$RESPONSE)
credit.valid.rf.auc  <- as.numeric(performance(credit.valid.rf_pred, "auc")@y.values)
credit.valid.roc <- performance(credit.valid.rf_pred, "tpr", "fpr")

# plot ROC/AUC scores
plot_roc(train_roc = credit.train.roc,
         train_auc = credit.train.rf.auc,
         test_roc = credit.valid.roc,
         test_auc = credit.valid.rf.auc)
```

![](GermanCredit_files/figure-html/unnamed-chunk-42-1.png)<!-- -->

```r
print(opt.cut(credit.valid.roc, credit.valid.rf_pred))
```

```
##                  [,1]
## sensitivity 0.7642857
## specificity 0.6666667
## cutoff      0.6140000
```

To confirm our evaluation and guide our recommendations, we can calculate the expected profit of our predictions across each decile of the test set. Looking at the individual profit and cumulative profit provides us insight into where our model produces the most value as well as when we may want human-intervention to take over for the model. 

The gradient boosted model actually peaks out at the highest expected profit through 40% of the predictions ranked by probability. The random forest model performs the best through the first 20% of the test set. Across the entire test sample, the logistic regression provides the highest overall expected profit. Each model performs similar through the final 30% of the test sample. 


```r
# use optimal estimates for each models predictions
credit.valid$log_back_pred <- factor(ifelse(credit.valid$log_back_prob > 0.67, "Good", "Bad"))
credit.valid$xgb_pred <- factor(ifelse(credit.valid$xgb_prob > 0.69, "Good", "Bad"))
credit.valid$rf_pred <- factor(ifelse(credit.valid$rf_prob > 0.61, "Good", "Bad"))

# use predictions to assess expected profit
credit.valid$log_back_profit <- ifelse(credit.valid$log_back_pred == "Good" & credit.valid$RESPONSE == "Good", 100,
                                       ifelse(credit.valid$log_back_pred == "Good" & credit.valid$RESPONSE == "Bad", -500, 0))

credit.valid$xgb_profit <- ifelse(credit.valid$xgb_pred == "Good" & credit.valid$RESPONSE == "Good", 100,
                                  ifelse(credit.valid$xgb_pred == "Good" & credit.valid$RESPONSE == "Bad", -500, 0))

credit.valid$rf_profit <- ifelse(credit.valid$rf_pred == "Good" & credit.valid$RESPONSE == "Good", 100,
                                 ifelse(credit.valid$rf_pred == "Good" & credit.valid$RESPONSE == "Bad", -500, 0))

# calculate cumulative profit for each model to assess optimal profit for triage cutoff
logistic.profit <- credit.valid %>%
  select(log_back_prob, log_back_profit) %>%
  arrange(desc(log_back_prob)) %>%
  mutate(model = "Logistic",
         case = row_number(),
         profit = log_back_profit,
         decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(10:1))) %>%
  select(model, case, profit, decile)

xgb.profit <- credit.valid %>%
  select(xgb_prob, xgb_profit) %>%
  arrange(desc(xgb_prob)) %>%
  mutate(model = "XgBoost",
         case = row_number(),
         profit = xgb_profit,
         decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(10:1))) %>%
  select(model, case, profit, decile)

rf.profit <- credit.valid %>%
  select(rf_prob, rf_profit) %>%
  arrange(desc(rf_prob)) %>%
  mutate(model = "Random Forest",
         case = row_number(),
         profit = rf_profit,
         decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(10:1))) %>%
  select(model, case, profit, decile)

# combine expected profit dataframes for plotting
profit <- rbind(logistic.profit, xgb.profit, rf.profit) %>%
  group_by(model, decile) %>%
  summarise(dec_profit = sum(profit)) %>%
  mutate(profit = cumsum(dec_profit))

# plot expected profit by decile
ggplot(profit, aes(x = decile, y = dec_profit, group = model, color = model)) +
  geom_line(aes(linetype = model)) +
  geom_point(aes(shape = model)) +
  geom_hline(yintercept = 1, linetype = 2, size = 0.1) +
  labs(title = "Decile Expected Profit - Test Set", x = "Decile", y = "Profit")
```

![](GermanCredit_files/figure-html/unnamed-chunk-43-1.png)<!-- -->

```r
# plot cumulative expected profit by decile
ggplot(profit, aes(x = decile, y = profit, group = model, color = model)) +
  geom_line(aes(linetype = model)) +
  geom_point(aes(shape = model)) +
  geom_hline(yintercept = 1, linetype = 2, size = 0.1) +
  labs(title = "Cumulative Expected Profit - Test Set", x = "Decile", y = "Profit")
```

![](GermanCredit_files/figure-html/unnamed-chunk-43-2.png)<!-- -->


## Implement

If we view the predicted probabilities of Good credit for the logisitc model, we can determine the best way to triage the model's predictions in deployment. We see that our profit is maximized through the top 40% of predicted probabilities for the logisitc regression model. Additionally, our profit remains flat through the last 40%. Using the distribution of the predicted probabilities, we surmise that the model can be used to auto-accept applications with a predicted probability above 80-85% (82% based on our sample) and auto-reject applications with a predicted probability lower than 70-75% (71% for our sample). We can then continue to manually review applications that fall within the two cutoff points. This method will reduce cost to review applications, speed up the process of notifying customers of their status, and allow us to continue to get samples to refine and improve the model. 


```r
sort(quantile(credit.valid$log_back_prob, probs = seq(0, 1, .1)), decreasing = TRUE)
```

```
##       100%        90%        80%        70%        60%        50% 
## 0.99336040 0.96432018 0.93439597 0.87819237 0.82405482 0.77761621 
##        40%        30%        20%        10%         0% 
## 0.71493049 0.58946064 0.42023900 0.32647786 0.08492754
```


