#R  script to load SRS R package and run SRS function

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

data <- args[[1]]
c_min <- args[[2]]
norm_data_name <- args[[3]]

errQuit <- function(mesg, status=1) {
  message("Error: ", mesg)
  q(status=status)
}

#Check SRS installations and install SRS if needed
if ("SRS" %in% installed.packages()[,"Package"]) {
    cat("SRS package already installed! \n\n")
} else {
    install.packages("SRS")
}

library(SRS)
cat("SRS R package version:", as.character(packageVersion("SRS")), "\n")

#read raw data
data <- read.table(file = data, skip = 0, header = F,row.names = NULL,check.names = FALSE)[,-1]
#include sample names
colnames(data) <- colnames(read.csv(file = data, nrows=1, skip=1, sep = "\t", check.names = FALSE))[-1]
#normalize at c_min
norm_data<-SRS(data,c_min)
#include features names
rownames(norm_data) <- read.table(file = data, skip = 0, header = F, check.names = FALSE)[,1]


write.table(norm_data, 'norm_table.tsv', sep = "\t", row.names = T, quote = F)

q(status=0)
