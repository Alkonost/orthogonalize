### Title:    Orthgonalization function front end 
### Author:   Pavel Panko
### Created:  2018-OCT-16
### Modified: 2019-FEB-22

orthogonalize <- function(formula, data, intercept = FALSE, group = NULL) {
    ##
    if(class(formula) != "character" & class(formula) != "formula"){
        stop("provide the `formula` as a `formula` or `character` class")
    }
    if(class(data) != "data.frame") {
        stop("provide the `data` as a `data.frame` class")
    }
    ##
    if(class(intercept) != "logical") {
        stop("intercept argument must be TRUE or FALSE")
    }
    if(!is.null(group)) {
        if(!is.atomic(group) & !is.vector(group)) {
            stop("group must be a vector containing the grouping variable or the name of a single grouping variable in the data")
        } else if(is.character(group) & length(group) == 1) {
            groupVec <- as.integer(data[[group]])
            data <- data[names(data) != group]
        } else if((is.factor(group) | is.numeric(group) | is.character(group)) & length(group) == nrow(data)) {
            groupVec <- as.integer(group)
        } else {
            stop("group must be a vector containing the grouping variable or the name of a single grouping variable in the data")
        }
    }
    ##
    mf <- stats::model.frame(formula, data)
    mt <- attr(mf, "terms")
    ##
    y <- model.response(mf, "numeric")
    X <- model.matrix(mt, mf)
    ##
    if(!is.null(group)) {
        out <- get_group_residuals(X, y, groupVec, as.integer(intercept))
    } else {
        out <- get_residuals(X, y, as.integer(intercept))
    }
    return(as.vector(out))
}
