# Continuous dependent.
summary.factorlist0 <- function(df, dependent, explanatory,  cont="mean", p=FALSE, na.include=FALSE,
															 column=FALSE, total_col=FALSE, orderbytotal=FALSE, glm.id=FALSE,
																na.to.missing = TRUE){

	s = Hmisc:::summary.formula(as.formula(paste(dependent, "~", paste(explanatory, collapse="+"))), data = df,
															overall=FALSE, method="response", na.include=na.include,
															fun=function(x) {
																mean = mean(x)
																sd = sd(x)
																L = quantile(x, probs=c(0.25))[[1]]
																median = quantile(x, probs=c(0.5))[[1]]
																U = quantile(x, probs=c(0.75))[[1]]
																return(data.frame(mean, sd, L, median, U))
															}
	)

	# Dataframe
	df.out = data.frame(label=attr(s, "vlabel"), levels=attr(s, "dimnames")[[1]])

	# Add in lm level names, this needs hacked in given above methodology
	if (glm.id){
		vname = attr(s, "vname")
		vname_logical = (vname == "")
		for (i in 1:length(vname)){
			if(vname_logical[i]) vname[i] = vname[i-1]
		}
		levels = as.character(df.out$levels)
		df.out$glm.id = paste0(vname, levels)
		df.out$index = 1:dim(df.out)[1]
	}

	if (cont=="mean"){
		mean.out = sprintf("%.1f", matrix(s[,2]))
		sd.out = sprintf("%.1f", matrix(s[,3]))
		result.out = data.frame(paste0(mean.out, " (", sd.out, ")"))
		colnames(result.out) = "Mean (sd)"
	}

	if (cont=="median"){
		median.out = sprintf("%.1f", matrix(s[,5]))
		L_IQR = sprintf("%.1f", matrix(s[,4]))
		U_IQR = sprintf("%.1f", matrix(s[,6]))
		result.out = data.frame(paste0(median.out, " (", L_IQR, " to ", U_IQR, ")"))
		colnames(result.out) = "Median (IQR)"
	}

	df.out = cbind(df.out, result.out)
	return(df.out)
}
