library(readr)
library(dplyr)

books <- read_csv("data-raw/CharlesBookClub/CharlesBookClub.csv")

# convert categorical to factors
# add labels for interpretability
books$Gender <- factor(books$Gender, labels = c("Male", "Female"))
books$Mcode  <- factor(books$Mcode,
                       labels = c("$0-25", "$26-50", "$51-100", "$101-200", "$201+"),
                       ordered = TRUE)
books$Rcode  <- factor(books$Rcode,
                       labels = c("0-2 months", "3-6 months", "7-12 months", "13+ months"),
                       ordered = TRUE)
books$Fcode  <- factor(books$Fcode,
                       labels = c("1 book", "2 books", "3+ books"),
                       ordered = TRUE)

charlesbookclub <- books %>%
  select(-Yes_Florence, -No_Florence) %>%
  select(-Florence, everything()) # move Florence to end

devtools::use_data(charlesbookclub, overwrite = TRUE)
