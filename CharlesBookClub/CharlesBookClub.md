---
title: "Charles Book Club Marketing Test"
author: "Bryan Clark"
output:
   html_document:
      self_contained: false
      toc: true
      keep_md: true
---



## Executive Summary

To help Charles Book Club (CBC) combat a shrinking profits problem, we partner with the marketing team to build a predictive model to gauage the propensity of a member purchasing a new book release. We then leverage the learnings of our modeling prototype process to test the models and implement recommendations for taking action on the learnings. We come out with ideas to focus new customer marketing efforts using affinities related to influential categories and a plan for reducing the overall budget used for marketing the new book release to customers in the database. We also include plans for improving the model and leverage the process for additional releases. 

## Understand

**Business Background**

Charles Book Club (CBC) is a book club that sells specialty books using direct marketing through various channels, including media advertising (TV, magazines, newspapers) and mailing. While CBC does not publish any books, it has built an active database of 500,000 subscribers. When signing up for the club, members provide information to assist CBC in developing a competitive advantage by delivering personalized options for its members. 

**Business Problem & Analytics Solution**

CBC sends monthly mailings to its database of members with the latest promotional offerings. They have been able to grow their business with certain metrics like member count, but bottom-line profits have been decreasing. 

CBC's marketing team would like to see if customer data can be used to reduce the cost of marketing activities to improve the profitability of their marketing operations. For an initial pilot of a predictive analytics solution, CBC has decided to focus on its strongest customers to run a marketing test for a new book release of The Art History of Florence. 

The results of the test can be used to increase the efficiency of various steps of the marketing funnel:

  * **[Customer Research]** 
      + Based on the sample of members used in the test, focus paid-advertising to content relevant to potential customers based on analysis of general affinities and channel attribution of members that respond to the test (purchase of book within 30 days). 
      + GOAL: increase new member acquisition paid advertising conversion rate.
  * **[Member Prediction]** 
      + Develop a predictive analytics model to predict the propensity score of a member to purchase the new book release. The propensity score will then be used to select customers most likely to purchase the new release. 
      + GOAL: increase active member direct marketing conversion rate.

The marketing team can use these learnings to provide their customers with increased marketing personalization in a way that is more effective from a cost perspective. The goal is to raise the conversion rates of new and active member conversion rate while simultaneously reducing their marketing spend. 

For the purpose of this analysis, we will be focusing on prototyping a predictive analytics model to use on active members. This prototype will be used to score the remainder of the customer base and determine an optimal budget for the book release. 


## Theorize

CBC attempted to design a complete profile of customers based spanning areas of general demographics, contact strategy, purchase analytics, and past behavior. The data available is at the listed at the customer level with the variables listed in the table below:

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> Features </th>
   <th style="text-align:left;"> Definition </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ID# </td>
   <td style="text-align:left;"> Customer Identification number </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gender </td>
   <td style="text-align:left;"> 0 = Male, 1 = Female </td>
  </tr>
  <tr>
   <td style="text-align:left;"> M </td>
   <td style="text-align:left;"> Monetary - Total money spent on books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R </td>
   <td style="text-align:left;"> Recency - Months since last purchase </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> Frequency - Total number of purchases </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FirstPurch </td>
   <td style="text-align:left;"> Months since first purchase </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ChildBks </td>
   <td style="text-align:left;"> Number of purchases from category of child books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YouthBks </td>
   <td style="text-align:left;"> Number of purchases from category of youth books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CookBks </td>
   <td style="text-align:left;"> Number of purchases from category of cook books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DoItYBks </td>
   <td style="text-align:left;"> Number of purchases from category of DIY books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RefBks </td>
   <td style="text-align:left;"> Number of purchases from category of reference books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ArtBks </td>
   <td style="text-align:left;"> Number of purchases from category of art books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GeoBks </td>
   <td style="text-align:left;"> Number of purchases from category of geography books </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalCook </td>
   <td style="text-align:left;"> Number of purchases of book title 'Secrets of Italian Cooking' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalAtlas </td>
   <td style="text-align:left;"> Number of purchases of book title 'Historical Atlas of Italy' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalArt </td>
   <td style="text-align:left;"> Number of purchases of book title 'Italian Art' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MCode </td>
   <td style="text-align:left;"> Monetary Code (0-25, 26-50, 51-100, 101-200, 200+) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RCode </td>
   <td style="text-align:left;"> Recency Code (0-2 mos., 3-6 mos., 7-12 mos., 13+ mos.) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FCode </td>
   <td style="text-align:left;"> Frequency Code (1 book, 2 books, 3+ books) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Related Purchase </td>
   <td style="text-align:left;"> Number of related books purchased </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Florence </td>
   <td style="text-align:left;"> = 1 if 'Art History of Florence' was purchased; = 0 if not </td>
  </tr>
</tbody>
</table>

It appears the data provided focuses mainly around purchase information. As such, we will focus our efforts on a predictive model using primarily customer purchase analytics and some general behavior. As CBC has this data available on each of their customers, it should be helpful in our attempt to operationalize the results of this test. 

Future iterations of a solution for future tests could include additional customer data such as time between purchases, preferred channel, or location. 

First, we load in the provided dataset and convert categorical variables to ordered factors.


```r
library(tidyverse)

cbc <- read_csv("data/CharlesBookClub.csv")

# convert categorical to factors
# add labels for interpretability
cbc$Gender <- factor(cbc$Gender, labels = c("Male", "Female"))
cbc$Mcode  <- factor(cbc$Mcode,
                       labels = c("$0-25", "$26-50", "$51-100", "$101-200", "$201+"),
                       ordered = TRUE)
cbc$Rcode  <- factor(cbc$Rcode,
                       labels = c("0-2 months", "3-6 months", "7-12 months", "13+ months"),
                       ordered = TRUE)
cbc$Fcode  <- factor(cbc$Fcode,
                       labels = c("1 book", "2 books", "3+ books"),
                       ordered = TRUE)

# update F feature name to prevent interaction with FALSE
cbc <- cbc %>% rename(Fr = `F`)

# remove unnecessary columns
cbc <- cbc %>%
  dplyr::select(-`Seq#`, -`ID#`, -Yes_Florence, -No_Florence) %>%
  dplyr::select(-Florence, everything()) # move Florence to end
```

Next, we generate an understanding of the dataset via a summary of the continuous and categorical features to develop a plan for handling missing values, outliers, and irregular cardinality (unique values) in the data. 

We do not appear to have any missing values, nor do any of the minimum or maximum values jump out as potentially irregular. Using the mean of `Florence`, we can see the conversion rate of the sample is 8%. We can see our dataset is made up of members that have made a purchase with CBC in the last 2 to 36 months, purchased between 1 to 12 total books, and spent a total of \$15 to \$479 on books. 

**Continuous Features**

```r
# create function to run summary on numeric features
df_num_summary <- function(df, cols = NULL) {

  if (is.null(cols)) {
    num.cols <- colnames(select_if(df, is.numeric))
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

# apply function to cbc data
cbc.num.summary <- df_num_summary(df = cbc)

# display in table
kable(cbc.num.summary, type = "html") %>%
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
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 446 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 129 </td>
   <td style="text-align:right;"> 208 </td>
   <td style="text-align:right;"> 208.09 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:right;"> 479 </td>
   <td style="text-align:right;"> 100.95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 13.39 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 8.10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fr </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.83 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 3.46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FirstPurch </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 26.51 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 18.35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ChildBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.64 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YouthBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.30 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.61 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CookBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.73 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1.09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DoItYBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.35 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.69 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RefBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.26 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.56 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ArtBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.29 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GeogBks </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.39 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0.75 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalCook </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalAtlas </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalArt </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Related Purchase </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.88 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 1.23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Florence </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.28 </td>
  </tr>
</tbody>
</table>

**Categorical Features**

```r
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

# apply function to cbc data
cbc.cat.summary <- df_cat_summary(df = cbc)

# display in table
kable(cbc.cat.summary, type = "html") %>%
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
   <td style="text-align:left;"> Gender </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 2818 </td>
   <td style="text-align:right;"> 70.5 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 1182 </td>
   <td style="text-align:right;"> 29.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mcode </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> $201+ </td>
   <td style="text-align:right;"> 2092 </td>
   <td style="text-align:right;"> 52.3 </td>
   <td style="text-align:left;"> $101-200 </td>
   <td style="text-align:right;"> 1202 </td>
   <td style="text-align:right;"> 30.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rcode </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> 13+ months </td>
   <td style="text-align:right;"> 1826 </td>
   <td style="text-align:right;"> 45.6 </td>
   <td style="text-align:left;"> 7-12 months </td>
   <td style="text-align:right;"> 1322 </td>
   <td style="text-align:right;"> 33.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fcode </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 3+ books </td>
   <td style="text-align:right;"> 1570 </td>
   <td style="text-align:right;"> 39.2 </td>
   <td style="text-align:left;"> 1 book </td>
   <td style="text-align:right;"> 1227 </td>
   <td style="text-align:right;"> 30.7 </td>
  </tr>
</tbody>
</table>


**Data Partition**

For modeling purposes, we will split our dataset into a training set to develop a predictive model, a validation set to compare performance of different models, and lastly a test set to estimate performance of the selected model for deployment. 

To prevent data leakage from the validation/test set into training the model, we will only use the training set until we are ready to evaluate the performance of our predictive models. We will be using a 50/30/20 split of the dataset into train/validation/test sets. 


```r
library(caret)
# set random seed for reproducibility
set.seed(123)

# first transform Florence into categorical feature
cbc$Florence <- factor(cbc$Florence, labels = c("No", "Yes"))

# sample row numbers
#train.rows <- sample(rownames(cbc), dim(cbc)[1]  * .5)
#valid.rows <- sample(setdiff(rownames(cbc), train.rows), dim(cbc)[1]  * .3)
#test.rows  <- setdiff(rownames(cbc), union(train.rows, valid.rows))

# create partitions
#cbc.train <- cbc[train.rows, ]
#cbc.valid <- cbc[valid.rows, ]
#cbc.test  <- cbc[test.rows, ]

# create 80/20 split of train and test data
trainIndex <- createDataPartition(cbc$Florence, p = .7, 
                                  list = FALSE, 
                                  times = 1)

# create partitions
cbc.train <- cbc[trainIndex, ]
cbc.test <- cbc[-trainIndex, ]
```

Due to the imblance of purchases to non-purchases, we will need to ensure our samples get a representation of purchasers in each set, and potentially explore various methods to account for the imbalance when training our data. 

To confirm we have representative samples of our target feature, we can look at the proportion of `Florence` responses in each data partition to check if they are relatively close to one another. We can see that each set contains a 8-9% conversion rate of purchasers.


```r
# training set
prop.table(table(cbc.train$Florence))
```

```
## 
##         No        Yes 
## 0.91538736 0.08461264
```


```r
# validation set
#prop.table(table(cbc.valid$Florence))
```


```r
# test set
prop.table(table(cbc.test$Florence))
```

```
## 
##         No        Yes 
## 0.91576314 0.08423686
```


```r
# load packages and set theme
library(gridExtra)
library(gtable)
theme_set(theme_classic())

# add colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
```

After partitioning our data, we will just be using the training set to identify opportunities in developing our model. 

**Summary Statistics**

In developing summary statistics for our training set, we see averages of spending about \$210, last making a purchase about one year ago, and buying around 4 total books. The largest categories are Children and Cooking.


```r
cbc.train.num.summary <- df_num_summary(cbc.train)
cbc.train.cat.summary <- df_cat_summary(cbc.train)
```



```r
# display numeric summary in table
kable(cbc.train.num.summary, type = "html") %>%
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
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 437 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 126 </td>
   <td style="text-align:right;"> 206 </td>
   <td style="text-align:right;"> 206.89 </td>
   <td style="text-align:right;"> 282 </td>
   <td style="text-align:right;"> 477 </td>
   <td style="text-align:right;"> 102.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 13.56 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 8.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fr </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.83 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 3.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FirstPurch </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 26.63 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 92 </td>
   <td style="text-align:right;"> 18.33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ChildBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.65 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YouthBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.30 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.61 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CookBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.72 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 1.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DoItYBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.35 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.69 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RefBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.26 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0.57 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ArtBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.28 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GeogBks </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.39 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0.75 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalCook </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.12 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0.38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalAtlas </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalArt </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Related Purchase </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.88 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 1.22 </td>
  </tr>
</tbody>
</table>



```r
# display categorical summary in table
kable(cbc.train.cat.summary, type = "html") %>%
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
   <td style="text-align:left;"> Gender </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 1968 </td>
   <td style="text-align:right;"> 70.3 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:right;"> 29.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mcode </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> $201+ </td>
   <td style="text-align:right;"> 1446 </td>
   <td style="text-align:right;"> 51.6 </td>
   <td style="text-align:left;"> $101-200 </td>
   <td style="text-align:right;"> 837 </td>
   <td style="text-align:right;"> 29.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rcode </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> 13+ months </td>
   <td style="text-align:right;"> 1300 </td>
   <td style="text-align:right;"> 46.4 </td>
   <td style="text-align:left;"> 7-12 months </td>
   <td style="text-align:right;"> 916 </td>
   <td style="text-align:right;"> 32.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fcode </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 3+ books </td>
   <td style="text-align:right;"> 1099 </td>
   <td style="text-align:right;"> 39.2 </td>
   <td style="text-align:left;"> 1 book </td>
   <td style="text-align:right;"> 858 </td>
   <td style="text-align:right;"> 30.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Florence </td>
   <td style="text-align:right;"> 2801 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> No </td>
   <td style="text-align:right;"> 2564 </td>
   <td style="text-align:right;"> 91.5 </td>
   <td style="text-align:left;"> Yes </td>
   <td style="text-align:right;"> 237 </td>
   <td style="text-align:right;"> 8.5 </td>
  </tr>
</tbody>
</table>

With `Florence` being our target feature, we can look at the means of each class to get an initial idea of which variables could be most relevant to differentiating between purchasers and non-purchases of the new book. `Fr`, `ArtBks`, and `Related Purchases` stand out as potentially important variables. 


```r
# get mean values by Florence response to understand difference in means
cbc.florence <- cbc.train %>%
  dplyr::select(-Gender, -Mcode, -Rcode, -Fcode) %>%
  group_by(Florence) %>%
  summarize_all(funs(mean = mean))

cbc.florence.mean.table <- t(cbc.florence) %>%
  `colnames<-`(.[1, ])

cbc.florence.mean.table <- data.frame(cbc.florence.mean.table[-1, ])

# display in table
kable(cbc.florence.mean.table, type = "html") %>%
  kable_styling(bootstrap_options = "striped", full_width = F, position = "left", 
                latex_options = "scale_down")
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> No </th>
   <th style="text-align:left;"> Yes </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> M_mean </td>
   <td style="text-align:left;"> 205.6814 </td>
   <td style="text-align:left;"> 219.9620 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R_mean </td>
   <td style="text-align:left;"> 13.65679 </td>
   <td style="text-align:left;"> 12.51477 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fr_mean </td>
   <td style="text-align:left;"> 3.740250 </td>
   <td style="text-align:left;"> 4.797468 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FirstPurch_mean </td>
   <td style="text-align:left;"> 26.32449 </td>
   <td style="text-align:left;"> 29.90717 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ChildBks_mean </td>
   <td style="text-align:left;"> 0.6415757 </td>
   <td style="text-align:left;"> 0.7510549 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YouthBks_mean </td>
   <td style="text-align:left;"> 0.2917317 </td>
   <td style="text-align:left;"> 0.3713080 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CookBks_mean </td>
   <td style="text-align:left;"> 0.7168487 </td>
   <td style="text-align:left;"> 0.7426160 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DoItYBks_mean </td>
   <td style="text-align:left;"> 0.3482839 </td>
   <td style="text-align:left;"> 0.4219409 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RefBks_mean </td>
   <td style="text-align:left;"> 0.2546802 </td>
   <td style="text-align:left;"> 0.3628692 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ArtBks_mean </td>
   <td style="text-align:left;"> 0.2593604 </td>
   <td style="text-align:left;"> 0.5443038 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GeogBks_mean </td>
   <td style="text-align:left;"> 0.3716849 </td>
   <td style="text-align:left;"> 0.6033755 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalCook_mean </td>
   <td style="text-align:left;"> 0.1177847 </td>
   <td style="text-align:left;"> 0.1392405 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalAtlas_mean </td>
   <td style="text-align:left;"> 0.03588144 </td>
   <td style="text-align:left;"> 0.04641350 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalArt_mean </td>
   <td style="text-align:left;"> 0.04173167 </td>
   <td style="text-align:left;"> 0.08016878 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Related Purchase_mean </td>
   <td style="text-align:left;"> 0.8264431 </td>
   <td style="text-align:left;"> 1.4135021 </td>
  </tr>
</tbody>
</table>

*Significance Test of Mean Differences*

While not a requirement to move forward with the predictive model, we see an opportunity to provide the marketing team with valuable insights based on if the means of various categories are statistically different. If our assumption that purchasers of *The Art of Florence* on average buy more books of a particular category than non-purchasers holds true, then the marketing team can use that learning to focus marketing efforts in affinity groups related to those cateogories. 

Below we loop through the RFM variables and book categories to confirm that Art and Geography categories could be used to narrow down potential affinity groups. We also see that Do-It-Yourself could also be an interesting category to use for more focused marketing. 


```r
cbc.florence.mean <- cbc.train %>%
  dplyr::select(-Gender, -Mcode, -Rcode, -Fcode)

categories <- colnames(cbc.florence.mean[ , -16])

cbc.florence.ttest <- data.frame(Category = categories, 
                                 p_value = rep(0,15))


# loop to run through each variable for ttest
for (i in 1:nrow(cbc.florence.ttest)) {

  var <- categories[i]
  
  p <- t.test(get(var) ~ Florence, data = cbc.florence.mean)$p.value
  
  cbc.florence.ttest[i, 2] <- round(p, 4)
}

# display in table
kable(cbc.florence.ttest, type = "html") %>%
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
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> 0.0518 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R </td>
   <td style="text-align:right;"> 0.0291 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fr </td>
   <td style="text-align:right;"> 0.0001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FirstPurch </td>
   <td style="text-align:right;"> 0.0074 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ChildBks </td>
   <td style="text-align:right;"> 0.0880 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YouthBks </td>
   <td style="text-align:right;"> 0.0859 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CookBks </td>
   <td style="text-align:right;"> 0.7111 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DoItYBks </td>
   <td style="text-align:right;"> 0.1365 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RefBks </td>
   <td style="text-align:right;"> 0.0118 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ArtBks </td>
   <td style="text-align:right;"> 0.0000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GeogBks </td>
   <td style="text-align:right;"> 0.0002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalCook </td>
   <td style="text-align:right;"> 0.4313 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalAtlas </td>
   <td style="text-align:right;"> 0.4973 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ItalArt </td>
   <td style="text-align:right;"> 0.0562 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Related Purchase </td>
   <td style="text-align:right;"> 0.0000 </td>
  </tr>
</tbody>
</table>


```r
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
```

**Recency, Frequency, Monetary**

The marketing team heaviliy relies on the RFM variables of recency of last purchase, total number of purchases, and total money spent on purhcases to gauge the health of the members of the book club. Increases in either frequency of purchases or monetary spend and decreases in time since last purchase across the customer base intuitively will lead to more sales for the business. 

Our analysis of the features will begin with the assumption that customers  

*Recency of Last Purchase*

The plot below shows a left skew with most customers making their last purhcase 12-16 months ago. We see Purchases of the new release tended to make their last purchase more recently than non-purchasers.  


```r
variable_dist_plot(cbc.train, "R", 2.5)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

*Frequency of Purchases*

The plot below shows a left skew with a large nummber of customers making only 1-2 previous pruchases. Purchasers of Florence on average buy more total books compared to non-purchasers. 


```r
variable_dist_plot(cbc.train, "Fr", 1)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

*Monetary Spend*

Monetary spend follows closer to a normal distribution. Spend ranges from \$15 to \$429. There is not a lot of separation in the mean spend of each group, but with this sample representing the best customers, that is not all that surprising. 


```r
variable_dist_plot(cbc.train, "M", 5)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

*First Purhcase*

The plots below show us most members made their first purchase in the last 24-36 months with non-purchasers on average being newer customers of the book club. 


```r
variable_dist_plot(cbc.train, "FirstPurch", 1)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

*Correlation*

Other than monetary spend with frequnecy of purhcases, there isn't a strong correlation in the RFM variables. Unsurprisngly, customers that made their first purchase longer ago are correlated with a larger frequency of purchases. There is not a strong correlation between RFM variables and our target of purchasing *The Art of Florence*.  


```r
library(reshape2)

# isolate variables for correlation
cbc.rfm <- cbc.train %>%
  dplyr::select(R, Fr, M, FirstPurch, Florence) %>%
  mutate(Florence = ifelse(Florence == "Yes", 1, 0))

# create correlation matrix
cor.mat <- round(cor(cbc.rfm), 2)
melted.cor.mat <- melt(cor.mat)

# plot correlation heatmap
ggplot(melted.cor.mat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       name = "Pearson Correlation") +
  labs(title = "RFM Correlation Heatmap") +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1), 
        axis.title.x = element_blank(), axis.title.y = element_blank())
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

**Purchase Analytics**

Next we will look at if activity across other book categories could help us predict purchasers from non-purchasers. 

*Category Purchases*

As our earlier analysis suggested, we see some level of separation between purchases and non-purchasers in their purchasers across book cateogries. Art, Reference, and Youth appear to have some levels of separation in their distributions. 


```r
# reshape data to compare categories
books <- cbc.train %>%
  dplyr::select(contains("Bks"), contains("Ital"), `Related Purchase`, Florence) %>%
  gather(key = "category", value = "count", contains("Bks"), contains("Ital"), `Related Purchase`)

ggplot(books, aes(x = category, y = count , fill = Florence)) +
  geom_boxplot() +
  labs(title = "Purchases by Book Category", x = "") +
  scale_fill_manual(values = c(cbPalette[6], cbPalette[7])) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

In looking at the correlation matrix of all the variables, we see some interesting areas of correlation. 
  * Art and Cooking cateogories are strongly correlated with longer-tenured customers
  * Geography and Art purchasers are strongly correlated with `Related Purchases` variable, indicating these could be redundant
  * Gender doesn't appear to be correlated with any of the variables
  * Purchasing or not purchasing also doesn't show much of a correlation to any of the variables. 


```r
# isolate variables for correlation
cbc.corr <- cbc.train %>%
  dplyr::select(-contains("code")) %>%
  mutate(Florence = ifelse(Florence == "Yes", 1, 0),
         Gender = ifelse(Gender == "Female", 1, 0))

# create correlation matrix
cor.mat <- round(cor(cbc.corr), 2)
melted.cor.mat <- melt(cor.mat)

# plot correlation heatmap
ggplot(melted.cor.mat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       name = "Pearson Correlation") +
  labs(title = "Customer Analytics Correlation Heatmap") +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.title.x = element_blank(), axis.title.y = element_blank())
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

## Prototype

#### Modeling Plan

To drive our model building and selection process, we will use two machine learning algorithms (naive Bayes, logistic regression) and iterate over different parameters, variable selections, and probability score cutoff for purchase classifciation to determine the best models on the basis of gain, lift, and ROC score. The top models will then be used to evaluate the test set in the evaluation phase. 
Our goal is to build a model that maximizes the percentage of purchasers when ranking them by the model's predicted propensity to make a purchase. Successfully developing a predictive model to predict a large percentage of purchasers within 70-80% of our sample will allow us to get more efficiency from our marketing budget by reducing the number of customers we have to market to to return a similar amount of expected revenue. 
As such, and due to the low base-rate (rare class) of being a purhcaser, we are willing to sacrafice overall prediction accuracy of purchasers and non-purchasers combined to more efficiently predict purchasers compared to non-purchasers. In other words, if we ranked the probability of members purchasing the new book, we want our model to rank actual purchasers closer to the top of the list so that we can reduce the expected number of customers in total we have to target for marketing. 

**naive Bayes**

The first algorithm we will try is a simple one to apply on the RFM code segments and gender variables. Using conditional probability of the different variable combinations with the target feature, we calculate the probability of being a purchaser. Furthermore, we will use the Laplace parameter to adjust different weights to account for combinations of the variables relative to the target feature. 

Below we use 5-fold cross-validation to calculate a ROC score for our initial naive Bayes model acorss different parameter adjustments. We see the different parameters more or less produce a ROC score of .57. 


```r
library(klaR)
library(caret)
library(ROCR)

ctrl <- trainControl(method = "repeatedcv", 
                     number = 5, 
                     classProbs = TRUE, 
                     summaryFunction = twoClassSummary)

nb.vars <- c("Gender", "Rcode", "Fcode", "Mcode", "Florence")

cbc.train.nb <- cbc.train[ , nb.vars]
#cbc.valid.nb <- cbc.valid[ , nb.vars]



# create grid of tuning parameters for Laplace
nbGrid <-  expand.grid(fL = c(0, 1, 5),
                       usekernel = c(TRUE, FALSE), 
                       adjust = c(0, 0.5, 1.0)
                       )

# build model and generate a-priori probabilities
cbc.nb1 <- train(Florence ~ ., data = cbc.train.nb,
             method = "nb",
             metric = "ROC", 
             tuneGrid = nbGrid,
             trControl = ctrl)

cbc.nb1
```

```
## Naive Bayes 
## 
## 2801 samples
##    4 predictor
##    2 classes: 'No', 'Yes' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold, repeated 1 times) 
## Summary of sample sizes: 2242, 2241, 2240, 2241, 2240 
## Resampling results across tuning parameters:
## 
##   fL  usekernel  adjust  ROC        Sens  Spec
##   0   FALSE      0.0     0.5637049    1     0 
##   0   FALSE      0.5     0.5637049    1     0 
##   0   FALSE      1.0     0.5637049    1     0 
##   0    TRUE      0.0     0.5253856  NaN   NaN 
##   0    TRUE      0.5     0.5525024    1     0 
##   0    TRUE      1.0     0.5568866    1     0 
##   1   FALSE      0.0     0.5637049    1     0 
##   1   FALSE      0.5     0.5637049    1     0 
##   1   FALSE      1.0     0.5637049    1     0 
##   1    TRUE      0.0     0.5253856  NaN   NaN 
##   1    TRUE      0.5     0.5525024    1     0 
##   1    TRUE      1.0     0.5568866    1     0 
##   5   FALSE      0.0     0.5637049    1     0 
##   5   FALSE      0.5     0.5637049    1     0 
##   5   FALSE      1.0     0.5637049    1     0 
##   5    TRUE      0.0     0.5253856  NaN   NaN 
##   5    TRUE      0.5     0.5525024    1     0 
##   5    TRUE      1.0     0.5568866    1     0 
## 
## ROC was used to select the optimal model using the largest value.
## The final values used for the model were fL = 0, usekernel = FALSE
##  and adjust = 0.
```

Adding variables for Art and Geography purhcases only incrementally improves the ROC score for the naive Bayes algorithm. 


```r
# lets add art and geography purchasers

cbc.train$Art_1 <- factor(ifelse(cbc.train$ArtBks > 0, 1, 0))
cbc.train$Geo_1 <- factor(ifelse(cbc.train$GeogBks > 0, 1, 0))


nb2.vars <- c("Gender", "Rcode", "Fcode", "Mcode", "Art_1", "Geo_1", "Florence")


# build model and generate a-priori probabilities
cbc.nb2 <- train(Florence ~ ., data = cbc.train[ , nb2.vars],
             method = "nb",
             metric = "ROC", 
             tuneGrid = nbGrid,
             trControl = ctrl)

cbc.nb2
```

```
## Naive Bayes 
## 
## 2801 samples
##    6 predictor
##    2 classes: 'No', 'Yes' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold, repeated 1 times) 
## Summary of sample sizes: 2241, 2241, 2240, 2241, 2241 
## Resampling results across tuning parameters:
## 
##   fL  usekernel  adjust  ROC        Sens       Spec      
##   0   FALSE      0.0     0.5997353  0.9941452  0.02943262
##   0   FALSE      0.5     0.5997353  0.9941452  0.02943262
##   0   FALSE      1.0     0.5997353  0.9941452  0.02943262
##   0    TRUE      0.0     0.5262902        NaN         NaN
##   0    TRUE      0.5     0.5870620  1.0000000  0.00000000
##   0    TRUE      1.0     0.5932800  1.0000000  0.00000000
##   1   FALSE      0.0     0.5997353  0.9941452  0.02943262
##   1   FALSE      0.5     0.5997353  0.9941452  0.02943262
##   1   FALSE      1.0     0.5997353  0.9941452  0.02943262
##   1    TRUE      0.0     0.5262902        NaN         NaN
##   1    TRUE      0.5     0.5870620  1.0000000  0.00000000
##   1    TRUE      1.0     0.5932800  1.0000000  0.00000000
##   5   FALSE      0.0     0.5997353  0.9941452  0.02943262
##   5   FALSE      0.5     0.5997353  0.9941452  0.02943262
##   5   FALSE      1.0     0.5997353  0.9941452  0.02943262
##   5    TRUE      0.0     0.5262902        NaN         NaN
##   5    TRUE      0.5     0.5870620  1.0000000  0.00000000
##   5    TRUE      1.0     0.5932800  1.0000000  0.00000000
## 
## ROC was used to select the optimal model using the largest value.
## The final values used for the model were fL = 0, usekernel = FALSE
##  and adjust = 0.
```

Lastly, adding a binary variable for customers tenure greater than or equal to 24 months also only incrementally improves the model. We've got from .57 to .585 in our ROC scores. 


```r
# lets add one more variable for customer greater than 24 months
cbc.train$FirstPurch_2 <- factor(ifelse(cbc.train$FirstPurch >= 24, 1, 0))

nb3.vars <- c("Gender", "Rcode", "Fcode", "Mcode", "Art_1", "Geo_1", "FirstPurch_2", "Florence")


# build model and generate a-priori probabilities
cbc.nb3 <- train(Florence ~ ., data = cbc.train[ , nb3.vars],
             method = "nb",
             metric = "ROC", 
             tuneGrid = nbGrid,
             trControl = ctrl)

cbc.nb3
```

```
## Naive Bayes 
## 
## 2801 samples
##    7 predictor
##    2 classes: 'No', 'Yes' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold, repeated 1 times) 
## Summary of sample sizes: 2241, 2240, 2242, 2241, 2240 
## Resampling results across tuning parameters:
## 
##   fL  usekernel  adjust  ROC        Sens       Spec      
##   0   FALSE      0.0     0.5821812  0.9914154  0.04210993
##   0   FALSE      0.5     0.5821812  0.9914154  0.04210993
##   0   FALSE      1.0     0.5821812  0.9914154  0.04210993
##   0    TRUE      0.0     0.5263548        NaN         NaN
##   0    TRUE      0.5     0.5674299  1.0000000  0.00000000
##   0    TRUE      1.0     0.5698773  1.0000000  0.00000000
##   1   FALSE      0.0     0.5821812  0.9914154  0.04210993
##   1   FALSE      0.5     0.5821812  0.9914154  0.04210993
##   1   FALSE      1.0     0.5821812  0.9914154  0.04210993
##   1    TRUE      0.0     0.5263548        NaN         NaN
##   1    TRUE      0.5     0.5674299  1.0000000  0.00000000
##   1    TRUE      1.0     0.5698773  1.0000000  0.00000000
##   5   FALSE      0.0     0.5821812  0.9914154  0.04210993
##   5   FALSE      0.5     0.5821812  0.9914154  0.04210993
##   5   FALSE      1.0     0.5821812  0.9914154  0.04210993
##   5    TRUE      0.0     0.5263548        NaN         NaN
##   5    TRUE      0.5     0.5674299  1.0000000  0.00000000
##   5    TRUE      1.0     0.5698773  1.0000000  0.00000000
## 
## ROC was used to select the optimal model using the largest value.
## The final values used for the model were fL = 0, usekernel = FALSE
##  and adjust = 0.
```


**Logistic Regression**

The next algorithm we will use is logistic regression. We will build a few models to add to our selection group by selecting different features to include in our logistic regression and adjust the probability cutoff as a paramter of our models. Our initial model uses all the variables except the RFM codes and number of recent purchases as those have a high level of correlation with our raw RFM variables and purchases in specific book categories. We remove them to remove redundant information and better understand the impact of the remaining variables. 

We see some variables are statistically significant in our model and categories of Art and Geography have a positive influence on liklihood to purchase while Cooking has a negative impact. Frequency of purchases also has a larger impact on purchasing the new book, which makes sense. The more you buy in general, the more likely it is that you will buy a new book release. It is possible this learning could be leveraged to test a VIP program for frequent purchasers. 

Our initial ROC score is now above 0.6. 


```r
cbc.train.glm <- cbc.train %>%
  dplyr::select(-contains("Code"), 
                -contains("_"),
                -`Related Purchase`)

# build model and generate a-priori probabilities
cbc.glm <- train(Florence ~ ., data = cbc.train.glm,
                 method = "glm",
                 metric = "ROC", 
                 trControl = ctrl)

cbc.glm
```

```
## Generalized Linear Model 
## 
## 2801 samples
##   15 predictor
##    2 classes: 'No', 'Yes' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold, repeated 1 times) 
## Summary of sample sizes: 2241, 2240, 2241, 2241, 2241 
## Resampling results:
## 
##   ROC        Sens  Spec      
##   0.6105304  1     0.01693262
```

```r
summary(cbc.glm)
```

```
## 
## Call:
## NULL
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.9501  -0.4358  -0.3628  -0.3167   2.6645  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -2.4131417  0.2348410 -10.276  < 2e-16 ***
## GenderFemale -0.4311915  0.1437021  -3.001  0.00269 ** 
## M            -0.0006175  0.0008142  -0.758  0.44823    
## R            -0.0130812  0.0136274  -0.960  0.33710    
## Fr            0.1752096  0.0630806   2.778  0.00548 ** 
## FirstPurch    0.0032474  0.0100109   0.324  0.74564    
## ChildBks     -0.1881636  0.0984966  -1.910  0.05609 .  
## YouthBks     -0.1526255  0.1314544  -1.161  0.24562    
## CookBks      -0.3231661  0.1012843  -3.191  0.00142 ** 
## DoItYBks     -0.2065469  0.1257887  -1.642  0.10059    
## RefBks       -0.0130748  0.1321414  -0.099  0.92118    
## ArtBks        0.4622381  0.0940448   4.915 8.87e-07 ***
## GeogBks       0.2084077  0.0890775   2.340  0.01930 *  
## ItalCook      0.0188147  0.1824198   0.103  0.91785    
## ItalAtlas    -0.1861995  0.3238799  -0.575  0.56536    
## ItalArt       0.3265181  0.2693313   1.212  0.22539    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1624.0  on 2800  degrees of freedom
## Residual deviance: 1537.7  on 2785  degrees of freedom
## AIC: 1569.7
## 
## Number of Fisher Scoring iterations: 5
```

Additionally, we can try a view other variations of logistic regression using stepwise selection. Each method will attempt to select variables based on how statistically meaning they are to purchasing the new book release. Forward selection appears to return the same model as using all our varibles and the top performing model is our logisitic regression with all the variables and a probability cutoff of 5%. 


```r
cbc.glm.step <- glm(Florence ~ ., data = cbc.train.glm, family = "binomial")

cbc.glm.forward <- step(cbc.glm.step, direction = "forward", trace = 0)
cbc.glm.backward <- step(cbc.glm.step, direction = "backward", trace = 0)
cbc.glm.both <- step(cbc.glm.step, direction = "both", trace = 0)
```


```r
cbc.glm.for1 <- train(cbc.glm.forward$formula, data = cbc.train.glm,
                 method = "glm",
                 metric = "ROC", 
                 trControl = ctrl)

cbc.glm.bck1 <- train(cbc.glm.backward$formula, data = cbc.train.glm,
                 method = "glm",
                 metric = "ROC", 
                 trControl = ctrl)

cbc.glm.both1 <- train(cbc.glm.both$formula, data = cbc.train.glm,
                 method = "glm",
                 metric = "ROC", 
                 trControl = ctrl)
```

We see our best model is our original logisitc model using forward and backwards selection of variables to reduce the AIC.


```r
cbc.glm.for1$results
```

```
##   parameter       ROC Sens       Spec      ROCSD SensSD     SpecSD
## 1      none 0.6004058    1 0.01276596 0.02977103      0 0.01903037
```

```r
cbc.glm.bck1$results
```

```
##   parameter       ROC      Sens        Spec      ROCSD      SensSD
## 1      none 0.6091687 0.9992203 0.008510638 0.04656821 0.001743523
##       SpecSD
## 1 0.01165367
```

```r
cbc.glm.both1$results
```

```
##   parameter       ROC Sens       Spec      ROCSD SensSD     SpecSD
## 1      none 0.6201553    1 0.01258865 0.04025685      0 0.01149324
```

Below is a comparison of the formulas of each model, with our last model being the simplest. In this case, both "backward" and "both" stepwise selected the same variables, and our difference of ROC scores was due to sampling. 


```r
cbc.glm.for1$finalModel
```

```
## 
## Call:  NULL
## 
## Coefficients:
##  (Intercept)  GenderFemale             M             R            Fr  
##   -2.4131417    -0.4311915    -0.0006175    -0.0130812     0.1752096  
##   FirstPurch      ChildBks      YouthBks       CookBks      DoItYBks  
##    0.0032474    -0.1881636    -0.1526255    -0.3231661    -0.2065469  
##       RefBks        ArtBks       GeogBks      ItalCook     ItalAtlas  
##   -0.0130748     0.4622381     0.2084077     0.0188147    -0.1861995  
##      ItalArt  
##    0.3265181  
## 
## Degrees of Freedom: 2800 Total (i.e. Null);  2785 Residual
## Null Deviance:	    1624 
## Residual Deviance: 1538 	AIC: 1570
```

```r
cbc.glm.bck1$finalModel
```

```
## 
## Call:  NULL
## 
## Coefficients:
##  (Intercept)  GenderFemale            Fr      ChildBks       CookBks  
##      -2.6317       -0.4300        0.1707       -0.1924       -0.3287  
##     DoItYBks        ArtBks       GeogBks  
##      -0.2056        0.4748        0.1804  
## 
## Degrees of Freedom: 2800 Total (i.e. Null);  2793 Residual
## Null Deviance:	    1624 
## Residual Deviance: 1543 	AIC: 1559
```

```r
cbc.glm.both1$finalModel
```

```
## 
## Call:  NULL
## 
## Coefficients:
##  (Intercept)  GenderFemale            Fr      ChildBks       CookBks  
##      -2.6317       -0.4300        0.1707       -0.1924       -0.3287  
##     DoItYBks        ArtBks       GeogBks  
##      -0.2056        0.4748        0.1804  
## 
## Degrees of Freedom: 2800 Total (i.e. Null);  2793 Residual
## Null Deviance:	    1624 
## Residual Deviance: 1543 	AIC: 1559
```

Let's add back our monetary and recency variables to see how they impact the model. We see the more complicated model, albeit one with important marketing customer metrics, does not improve our model's ROC. 


```r
glm.form <- {Florence ~ Gender + M + R + Fr + ChildBks + CookBks + DoItYBks + ArtBks + GeogBks}

cbc.glm.both2 <- train(glm.form , data = cbc.train.glm,
                 method = "glm",
                 metric = "ROC", 
                 trControl = ctrl)

cbc.glm.both2
```

```
## Generalized Linear Model 
## 
## 2801 samples
##    9 predictor
##    2 classes: 'No', 'Yes' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold, repeated 1 times) 
## Summary of sample sizes: 2240, 2240, 2241, 2242, 2241 
## Resampling results:
## 
##   ROC        Sens  Spec      
##   0.6185213  1     0.01666667
```

**Model Selection**

After reviewing the output of our naive Bayes and logisitc regression models, we will use two models to test the expected performance:

1.  navie Bayes model with RFM codes, gender, and Art/Geography/Cooking binary pairs
2.  logisitc regression model with gender, Frequency, 


## Test

Below we run the final test sample through the best naive Bayes and logisitic regression models. We will run each model through a process making predictions on the test set, calculating our ROC score, measuring gain/lift across the sample, and then determining the best way to deploy our learnings. 


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
```



```r
# reminder of our nb variables
nb3.vars <- c("Gender", "Rcode", "Fcode", "Mcode", "Art_1", "Geo_1", "FirstPurch_2", "Florence")

# add our feature transformations to the test set
cbc.test$Art_1 <- factor(ifelse(cbc.test$ArtBks > 0, 1, 0))
cbc.test$Geo_1 <- factor(ifelse(cbc.test$GeogBks > 0, 1, 0))
cbc.test$FirstPurch_2 <- factor(ifelse(cbc.test$FirstPurch >= 24, 1, 0))

# training metrics for our best naive Bayes model
cbc.train$nb_prob <- predict(cbc.nb3, newdata = cbc.train[ , nb3.vars], type = "prob")[ , 2]
cbc.train.nb.pred <- prediction(cbc.train$nb_prob, cbc.train$Florence)
cbc.train.nb.auc  <- as.numeric(performance(cbc.train.nb.pred, "auc")@y.values)
cbc.train.roc <- performance(cbc.train.nb.pred, "tpr", "fpr")

# test accuracy for our best naive Bayes model
cbc.test$nb_prob <- predict(cbc.nb3, newdata = cbc.test[ , nb3.vars], type = "prob")[ , 2]
cbc.test.nb.pred <- prediction(cbc.test$nb_prob, cbc.test$Florence)
cbc.test.nb.auc  <- as.numeric(performance(cbc.test.nb.pred, "auc")@y.values)
cbc.test.roc <- performance(cbc.test.nb.pred, "tpr", "fpr")

# plot ROC/AUC scores
plot_roc(train_roc = cbc.train.roc,
         train_auc = cbc.train.nb.auc,
         test_roc = cbc.test.roc,
         test_auc = cbc.test.nb.auc)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-29-1.png)<!-- -->


```r
# reminder of glm formula
glm.form <- {Florence ~ Gender + M + R + Fr + ChildBks + CookBks + DoItYBks + ArtBks + GeogBks}

# training accuracy for our best naive Bayes model
cbc.train$glm_prob <- predict(cbc.glm.both2, newdata = cbc.train, type = "prob")[ , 2]
cbc.train.glm.pred <- prediction(cbc.train$glm_prob, cbc.train$Florence)
cbc.train.glm.auc  <- as.numeric(performance(cbc.train.glm.pred, "auc")@y.values)
cbc.train.glm.roc <- performance(cbc.train.glm.pred, "tpr", "fpr")

# test accuracy for our best naive Bayes model
cbc.test$glm_prob <- predict(cbc.glm.both2, newdata = cbc.test, type = "prob")[ , 2]
cbc.test.glm.pred <- prediction(cbc.test$glm_prob, cbc.test$Florence)
cbc.test.glm.auc  <- as.numeric(performance(cbc.test.glm.pred, "auc")@y.values)
cbc.test.glm.roc <- performance(cbc.test.glm.pred, "tpr", "fpr")

# plot ROC/AUC scores
plot_roc(train_roc = cbc.train.glm.roc,
         train_auc = cbc.train.glm.auc,
         test_roc = cbc.test.glm.roc,
         test_auc = cbc.test.glm.auc)
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-30-1.png)<!-- -->

While neither model is particularly great with ROC scores of under .70, we will move forward with the logistic regression model due to its performance compared to the naive Bayes model. We next can determine an optimal cutoff point for classifying a purchaser as the point in which our true positive rate is closest to 1 (100%) and our false positive rate is closest to 0 (0%). Our estimate is close to the actual probability of a purchaser at 0.08 (8%). 


```r
# function to determine optimal cutoff point
opt.cut <-  function(perf, pred){
    cut.ind <-  mapply(FUN=function(x, y, p){
        d <- (x - 0) ^ 2 + (y - 1) ^ 2
        ind <-  which(d == min(d))
        c(sensitivity = y[[ind]], specificity = 1-x[[ind]], 
            cutoff = p[[ind]])
    }, perf@x.values, perf@y.values, pred@cutoffs)
}
```


```r
print(opt.cut(cbc.test.glm.roc, cbc.test.glm.pred))
```

```
##                   [,1]
## sensitivity 0.60396040
## specificity 0.63570128
## cutoff      0.07909549
```

The performance metric of interest relative to reducing costs in for marketing are the cumulative gain and lift of each model. By ranking our predictions from highest to lowest, we can capture how efficient the model is at capturing our purchasers.

The code below sorts the probability scores for each model to determine gain and lift metrics. 


```r
cbc.nb.test.perf <- data.frame(model = rep_len(c("naive Bayes"), 
                                           length(cbc.test$Florence)), 
                               actual = cbc.test$Florence, prob = cbc.test$nb_prob)

cbc.nb.test.perf <- cbc.nb.test.perf %>%
  arrange(prob) %>%
  mutate(actual_1 = ifelse(actual == "Yes", 1, 0),
         pos = cumsum(ifelse(actual_1 == 1, 1, 0)),
         neg = cumsum(ifelse(actual_1 != 1, 1, 0)),
         pos_cum_prob = pos / max(pos),
         neg_cum_prob = neg / max(neg),
         distance = abs(neg_cum_prob - pos_cum_prob),
         pct_pop = row_number() / n())

# create gain/lift table
cbc.nb.test.perf.dec <- cbc.nb.test.perf %>%
  arrange(desc(prob)) %>%
  mutate(decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(1:10))) %>%
  group_by(model, decile) %>%
  summarize(n = n(), 
            pos = sum(actual_1),
            neg = sum(ifelse(actual_1 != 1, 1, 0))) %>%
  ungroup %>%
  mutate(gain = pos / sum(pos),
         cum_gain = cumsum(gain),
         lift = pos / mean(pos),
         cum_lift = (cumsum(pos) / cumsum(n)) / (sum(pos) / sum(n)))

######### Logistic Regression ##########

cbc.glm.test.perf <- data.frame(model = rep_len(c("logistic regression"), 
                                                length(cbc.test$Florence)),
                                actual = cbc.test$Florence, prob = cbc.test$glm_prob)

cbc.glm.test.perf <- cbc.glm.test.perf %>%  
  arrange(prob) %>%
  mutate(actual_1 = ifelse(actual == "Yes", 1, 0),
         pos = cumsum(ifelse(actual_1 == 1, 1, 0)),
         neg = cumsum(ifelse(actual_1 != 1, 1, 0)),
         pos_cum_prob = pos / max(pos),
         neg_cum_prob = neg / max(neg),
         distance = abs(neg_cum_prob - pos_cum_prob),
         pct_pop = row_number() / n())

# create gain/lift table  
cbc.glm.test.perf.dec <- cbc.glm.test.perf %>%
  arrange(desc(prob)) %>%
  mutate(decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(1:10))) %>%
  group_by(model, decile) %>%
  summarize(n = n(), 
            pos = sum(actual_1),
            neg = sum(ifelse(actual_1 != 1, 1, 0))) %>%
  ungroup %>%
  mutate(gain = pos / sum(pos),
         cum_gain = cumsum(gain),
         lift = pos / mean(pos),
         cum_lift = (cumsum(pos) / cumsum(n)) / (sum(pos) / sum(n)))

# combine model tables for plotting
model.test.perf <- rbind(cbc.nb.test.perf, cbc.glm.test.perf)
model.test.perf.dec <- rbind(cbc.nb.test.perf.dec, cbc.glm.test.perf.dec)
```

In the chart below, we see that the logistic model out performs the naive Bayes model through the majority of the records.  


```r
# determine culmulative gain per sample
cum.gain <- model.test.perf %>%
  group_by(model) %>%
  arrange(desc(prob)) %>%
  mutate(decile = cut(1:n(), breaks = quantile(1:n(), probs = seq(0, 1, .1)), 
              include.lowest = TRUE,
              labels = c(1:10)),
         gain = cumsum(actual_1) / sum(actual_1),
         pct_pop = row_number() / n(),
         diff = abs(gain - pct_pop))

# cumulative gain comparison
ggplot(cum.gain) +
  geom_line(aes(x = pct_pop, y = gain, color = model, linetype = model)) +
  geom_abline(intercept = 0, slope = 1, linetype = 2, size = 0.1) +
  labs(title = "Culmulative Gain - Test Set", x = "Pecentage of Records", y = "Cumulative Gain")
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-34-1.png)<!-- -->

Similarly, we can measure gain across deciles to get a better understanding of performance at different stages of the rankings. We again see the logistic model performs better through the majority of the sample. Using the test set, we can see that the logistic model captures ~ 90% of the purchasers within the top 80% of the sample. If we move further down, the logistic model captures ~ 80% of the purchasers within the top 60% of the sample. This means that we could save 40% of the direct marketing costs and give up only about 20% of the purchasers. 


```r
# cumulative gain line chart
ggplot(model.test.perf.dec, aes(x = decile, y = cum_gain, group = model, color = model)) +
  geom_line(aes(linetype = model)) +
  geom_point(aes(shape = model)) +
  geom_abline(intercept = 0, slope = 1/10, linetype = 2, size = 0.1) +
  labs(title = "Culmulative Gain - Test Set", x = "Decile", y = "Cumulative Gain")
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-35-1.png)<!-- -->

Looking at our lift for each decile, we see the logistic regression model predicts over 2x the rate of purchasers compared to the baseline average. Additionally, we have postive or flat lift through the top 60% of the sample of members. 


```r
# lift line chart
ggplot(model.test.perf.dec, aes(x = decile, y = lift, group = model, color = model)) +
  geom_line(aes(linetype = model)) +
  geom_point(aes(shape = model)) +
  geom_hline(yintercept = 1, linetype = 2, size = 0.1) +
  labs(title = "Lift - Test Set", x = "Decile", y = "Lift")
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-36-1.png)<!-- -->

Looking at cumulative lift, we see an improvement of 1.25x maintained through the 7th decile of the sample. 


```r
# cumulative lift line chart
ggplot(model.test.perf.dec, aes(x = decile, y = cum_lift, group = model, color = model)) +
  geom_line(aes(linetype = model)) +
  geom_point(aes(shape = model)) +
  geom_hline(yintercept = 1, linetype = 2, size = 0.1) +
  labs(title = "Cumulative Lift - Test Set", x = "Decile", y = "Cumulative Lift")
```

![](CharlesBookClub_files/figure-html/unnamed-chunk-37-1.png)<!-- -->

**Final Results**

After reviewing the performance of the models on our test set, we see the logistic regression model outperforms the naive Bayes model and provides us opportunity for reducing the direct marketing budget by targeting members predicted to be most likely to purchase the new book release. 

In terms of predictors, we see that males are more likely to purchase than females, purchases in categories like Art and Geography increase the probability of purchasing, and purchases in Cooking and DIY have negative impacts. 

## Implement

**Model Deployment**

Based on the results of our analysis, prototypes, and tests, it is our recommendation to leverage the learnings in the following ways:

  * Art and Geography emerged as interesting categories related to separating purchasers and non-purchasers. Affinity analysis for customers of these categories can be leveraged to focus advertising spend for new customers as current customers of these categories are more likely to purchase the new book. 
  * Use the logisitic regression model and naive Bayes model to predict purchasing propensity of the customer database and store their individual and combined predictions. 
  * Using the logisitc regression score, select the top 10% of customers to test a more focused VIP campaign. With this being the best set of customers, we can see if a VIP campaign increases their propensity to purchase as well as future purchasing patterns when compared to the control customers in their predicted group.
  * Using the propensity score, select only a subset of customers to use for direct marketing. For example, if we were to select 80% of the members most likely to purchase, we could capture around 90% of our expected purhcasers. We give up 10% of our expected purchasers in exchange for 20% of the cost of marketing to all customers. The 20% of savings can be used in other channels or areas to improve marketing for the 80% of customers selected, or given profit/costs of marketing and purchasing per customer, an optimal sample can be determined to maximize expected profit. 
  * Use the same process to evaluate additional book releases with eventual operalization as profit improvement dictates. 
  
**Model Improvement**

Our logistic model could potentially be improved by factoring in the total amount of purchase the purchasers made when responding to the campaign. While it wouldn't improve the prediction of a customer to be a purhcaser, it would help further isolate customers to focus marketing efforts by using a probability to purchase along with predicted purchase value to calculate an expected profit from each customer. Our sample could then be ranked based on the expected profit. 

Additionally, other behavior variables could be useful such as the average time between purchaser by the member (what is the general cadence of the customer's purchases?), spend in the last 90 days (or other cyclical value), and purchases in the last 90 days (or other cyclical value). 

