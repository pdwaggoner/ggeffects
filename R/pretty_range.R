#' @title Create a pretty sequence over a range of a vector
#' @name pretty_range
#'
#' @description Creates an evenly spaced, pretty sequence of numbers for a
#'   range of a vector.
#'
#' @param x A numeric vector.
#' @param n Integer value, indicating the size of how many values are used to
#'   create a pretty sequence. If \code{x} has a large value range (> 100),
#'   \code{n} could be something between 1 to 5. If \code{x} has a rather
#'   small amount of unique values, \code{n} could be something between
#'   10 to 20. If \code{n = NULL}, \code{pretty_range()} automatically
#'   tries to find a pretty sequence.
#'
#' @return A numeric vector with a range corresponding to the minimum and maximum
#'   values of \code{x}.
#'
#' @examples
#' library(sjmisc)
#' data(efc)
#'
#' x <- std(efc$c12hour)
#' x
#' # pretty range for vectors with decimal points
#' pretty_range(x)
#'
#' # pretty range for large range, increasing by 50
#' pretty_range(1:1000)
#'
#' # increasing by 20
#' pretty_range(1:1000, n = 7)
#'
#' @importFrom dplyr n_distinct
#' @export
pretty_range <- function(x, n = NULL) {
  ra.min <- min(x, na.rm = TRUE)
  ra.max <- max(x, na.rm = TRUE)
  ra <- seq(ra.min, ra.max, sqrt(ra.max - ra.min) / 10)

  if (!is.null(n))
    pr <- n
  else if (dplyr::n_distinct(x, na.rm = TRUE) > 100)
    pr <- 3
  else if (dplyr::n_distinct(x, na.rm = TRUE) > 50)
    pr <- 5
  else
    pr <- 10

  pr <- pr^(floor(log10(length(ra))))

  p1 <- pretty(ra, n = pr)
  p2 <- pretty(ra, n = ceiling(pr * 1.5))
  p3 <- pretty(ra, n = 2 * pr)

  if (length(p1) >= dplyr::n_distinct(x, na.rm = TRUE))
    p1
  else if (length(p1) < 10 && length(p2) < 25)
    p2
  else if (length(p2) < 15 && length(p3) < 25)
    p3
  else
    p1
}
