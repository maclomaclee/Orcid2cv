### code to retrieve a csv of citations from an ORCID ID
### author: malcolm.macleod@ed.ac.uk
### version 0.1
### date 19 March 2021

library(jsonlite)
library(tidyverse)
library(rorcid)
library(rcrossref)

### for rorcid, you need to register to use the ORCID api and link it to your ORCID id
### to do this, log in to orcid, click on name > developer tools > enable public api

### for rcrossref, best practice is to place your email address within your r environment
## 1. Open file: file.edit("~/.Renviron")
## 2. Add email address to be shared with Crossref crossref_email = name@example.com
### 3. Save the file and restart your R session

### place your orcid is where shown

User_Orcid <- orcid_works(orcid = "0000-0001-9187-9839") ### so ORCID id here
global_User <- as.data.frame(User_Orcid$'0000-0001-9187-9839') ### and here

dois <- setNames(data.frame(matrix(ncol = 1, nrow = 0)), c("doi"))
len <- nrow(global_User)

for (i in 1:len)
  {
  focus <- as.data.frame(global_User[[21]][[i]])
  focus <- focus[,1:2]
  colnames(focus) <- c("type", "value")
  hocus <- filter(focus, type == "doi")
  doistemp <- setNames(data.frame(matrix(ncol = 1, nrow = nrow(hocus))), c("doi"))
  doistemp$doi <-hocus$value
        dois <- rbind(dois, doistemp)
    }

dois = unique(dois)
len = nrow(dois)
citation <- data.frame(matrix(ncol=1, nrow = len))

for (i in 1:len)  
  {
  try({citation[i,1] <- cr_cn(dois[i,1], format = "text", style = "vancouver", raw = TRUE)}, silent = TRUE)
}

write.csv(citation, "citations.csv")
         