

mlag2 <- function(FY, plag = 2){
  for (i in 1:plag) {
    if (i == 1){
      ans <- apply(FY, 2, dplyr::lag, n = i)
    }else {
      ans <- apply(FY, 2, dplyr::lag, n = i) %>% cbind(ans,.)
    }
  }
  return(ans)
}
