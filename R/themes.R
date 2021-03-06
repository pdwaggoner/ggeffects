#' @importFrom ggplot2 theme_minimal theme element_line element_rect element_text
#' @rdname plot
#' @export
theme_ggeffects <- function(base_size = 11, base_family = "") {
  (ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
     ggplot2::theme(
       axis.line.x      = ggplot2::element_line(colour = "grey80"),
       axis.line.y      = ggplot2::element_line(colour = "grey80"),
       axis.text        = ggplot2::element_text(colour = "grey50"),
       axis.title       = ggplot2::element_text(colour = "grey30"),
       strip.background = ggplot2::element_rect(colour = "grey70", fill = "grey90"),
       strip.text       = ggplot2::element_text(colour = "grey30"),
       legend.title     = ggplot2::element_text(colour = "grey30"),
       legend.text      = ggplot2::element_text(colour = "grey30")
     ))
}


ggeffects_colors <- list(
  `aqua` = c("#BAF5F3", "#46A9BE", "#8B7B88", "#BD7688", "#F2C29E", "#BAF5F3", "#46A9BE", "#8B7B88"),
  `warm` = c("#F8EB85", "#F1B749", "#C45B46", "#664458", "#072835", "#F8EB85", "#F1B749", "#C45B46"),
  `dust` = c("#AAAE9D", "#F8F7CF", "#F7B98B", "#7B5756", "#232126", "#AAAE9D", "#F8F7CF", "#F7B98B"),
  `blambus` = c("#5D8191", "#F2DD26", "#494949", "#BD772D", "#E02E1F", "#5D8191", "#F2DD26", "#494949"),
  `simply` = c("#CD423F", "#FCDA3B", "#0171D3", "#018F77", "#F5C6AC", "#CD423F", "#FCDA3B", "#0171D3"),
  `us` = c("#004D80", "#376C8E", "#37848E", "#9BC2B6", "#B5D2C0", "#004D80", "#376C8E", "#37848E"),
  `reefs` = c("#43a9b6", "#218282", "#dbdcd1", "#44515c", "#517784"),
  `breakfast club` = c("#b6411a", "#eec3d8", "#4182dd", "#ecf0c8", "#2d6328"),
  `metro` = c("#d11141", "#00aedb", "#00b159", "#f37735", "#8c8c8c", "#ffc425", "#cccccc"),
  `viridis` = c("#440154", "#46337E", "#365C8D", "#277F8E", "#1FA187", "#4AC16D", "#9FDA3A", "#FDE725"),
  `ipsum` = c("#d18975", "#8fd175", "#3f2d54", "#75b8d1", "#2d543d", "#c9d175", "#d1ab75", "#d175b8", "#758bd1"),
  `quadro` = c("#ff0000", "#1f3c88", "#23a393", "#f79f24", "#625757"),
  `eight` = c("#003f5c", "#2f4b7c", "#665191", "#a05195", "#d45087", "#f95d6a", "#ff7c43", "#ffa600"),
  `circus` = c("#0664C9", "#C1241E", "#EBD90A", "#6F130D", "#111A79"),
  `system` = c("#0F2838", "#F96207", "#0DB0F3", "#04EC04", "#FCC44C"),
  `hero` = c("#D2292B", "#165E88", "#E0BD1C", "#D57028", "#A5CB39", "#8D8F70")
)


ggeffects_pal <- function(palette = "metro", n = NULL) {
  pl <- ggeffects_colors[[palette]]

  if (!is.null(n) && n <= length(pl))
    pl <- pl[1:n]

  pl
}


#' @rdname plot
#' @importFrom purrr map_df
#' @importFrom tidyr gather
#' @importFrom dplyr arrange mutate
#' @importFrom rlang .data
#' @importFrom ggplot2 ggplot aes_string geom_bar scale_fill_manual scale_x_discrete labs theme_minimal coord_flip guides scale_y_continuous
#' @export
show_pals <- function() {

  longest.pal <- max(purrr::map_dbl(ggeffects_colors, ~ length(.x)))

  color_pal <- lapply(ggeffects_colors, function(.x) {
    if (length(.x) == longest.pal)
      .x
    else
      c(.x, rep("#ffffff", times = longest.pal - length(.x)))
  })

  x <- suppressWarnings(
    color_pal %>%
      as.data.frame() %>%
      purrr::map_df(~ .x[length(.x):1]) %>%
      tidyr::gather() %>%
      dplyr::arrange(.data$key)
  )

  x$y <- rep_len(1:longest.pal, nrow(x))
  x$cols = as.factor(1:nrow(x))

  x$key <- rev(x$key)
  ggplot2::ggplot(x, ggplot2::aes_string(x = "key", fill = "cols")) +
    ggplot2::geom_bar(width = .7) +
    ggplot2::scale_fill_manual(values = x$value) +
    ggplot2::scale_x_discrete(labels = rev(sort(names(color_pal)))) +
    ggplot2::scale_y_continuous(breaks = NULL, labels = NULL) +
    ggplot2::guides(fill = "none") +
    ggplot2::coord_flip() +
    ggplot2::theme_minimal() +
    ggplot2::labs(x = NULL, y = NULL)
}
