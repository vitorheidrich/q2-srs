rawdata <- read.table(file = "table.tsv")
data <- read.table(file = "table.tsv",
                            skip = 0, 
                            header = F,
                            row.names = NULL,
                            check.names = FALSE
)[,-1]
colnames(data) <- colnames(read.csv("table.tsv", nrows=1, skip=1, sep = "\t", check.names = FALSE))[-1]

norm_data<-SRS(data,100)

rownames(norm_data) <- read.table(file = "table.tsv",
                                  skip = 0, 
                                  header = F,
                                  #col.names = T,
                                  check.names = FALSE
)[,1]


write.table(norm_data, "norm_data.tsv", sep = "\t",
            row.names = T,
            quote = F)
  