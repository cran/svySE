## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(svySE)

set.seed(123)

df <- data.frame(
  dept = rep(c("A", "B", "C"), each = 50),
  strata = rep(c("A", "B", "C"), each = 50),
  service = rep(c("S1", "S2"), length.out = 150),
  weight = runif(150, 10, 50),
  ind_1 = sample(c(0, 1), 150, replace = TRUE)
)

head(df)

## -----------------------------------------------------------------------------
cfg <- svySE_cfg(
  estimator = "prop",
  target = 1,
  valid_values = c(0, 1),
  lonely_psu = "adjust",
  truncate_lower_ci = TRUE
)

cfg

## -----------------------------------------------------------------------------
res <- svySE_calc(
  data = df,
  indicators = "ind_1",
  group_vars = "dept",
  group_labels = "Department",
  strata = "strata",
  weight = "weight",
  cfg = cfg,
  verbose = FALSE
)

res

## -----------------------------------------------------------------------------
res$results$ind_1$error$TOTAL

## -----------------------------------------------------------------------------
res_div <- svySE_calc(
  data = df,
  indicators = "ind_1",
  group_vars = "dept",
  group_labels = "Department",
  strata = "strata",
  weight = "weight",
  division = "service",
  div_weight = "weight",
  cfg = cfg,
  verbose = FALSE
)

names(res_div$results$ind_1$error)

## -----------------------------------------------------------------------------
file_err <- tempfile(fileext = ".xlsx")
file_tab <- tempfile(fileext = ".xlsx")

svySE_xlsx(
  x = res,
  file_err = file_err,
  file_tab = file_tab,
  cols_err = svySE_cols_err("full"),
  cols_tab = svySE_cols_tab("full")
)

file.exists(file_err)
file.exists(file_tab)

