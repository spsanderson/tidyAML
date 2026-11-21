# Exercise installed package entry points without attaching tidyAML.
stopifnot(!"package:tidyAML" %in% search())

fit <- tidyAML::gated_fast_regression(
  mtcars, "mpg", c("disp", "hp", "wt"), .gate_eng = "lm",
  .u_pca = 1, .s_pls = 1, .parsnip_eng = "lm", .seed = 280L
)
stopifnot(inherits(fit, "fst_reg_tbl"), nrow(fit) == 1L)

audit <- tidyAML::lodo_engine_audit(
  list(cars_1 = mtcars[1:16, ], cars_2 = mtcars[17:32, ]), "mpg",
  .parsnip_eng = "lm", .seed = 280L
)
stopifnot(nrow(audit) == 2L, all(is.finite(audit$held_out_loss)))
stopifnot(!"package:tidyAML" %in% search())
