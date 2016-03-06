setwd("~/Cornell Healthcare Hackathon 2016")

d2011 <- read.csv("Hospital_Inpatient_Discharges__SPARCS_De-Identified___2011.csv")
d2011$Total.Costs <- as.numeric(gsub('\\$', '', d2011$Total.Costs))
d2011$Total.Charges <- as.numeric(gsub('\\$', '', d2011$Total.Charges))
elective2011 <- d2011[d2011$Type.of.Admission == "Elective",]
elective2011 <- elective2011[elective2011$Race != "Unknown",]
elective2011 <- elective2011[elective2011$Gender != "U",]


d2012 <- read.csv("Hospital_Inpatient_Discharges__SPARCS_De-Identified___2012.csv")
d2012$Total.Costs <- as.numeric(gsub('\\$', '', d2012$Total.Costs))
d2012$Total.Charges <- as.numeric(gsub('\\$', '', d2012$Total.Charges))
elective2012 <- d2012[d2012$Type.of.Admission == "Elective",]
elective2012 <- elective2012[elective2012$Race != "Unknown",]
elective2012 <- elective2012[elective2012$Gender != "U",]
names(elective2012)[29:31] <- names(elective2011)[29:31]
names(elective2012)[4] <- "Facility.ID"

elect <- rbind(elective2011, elective2012)
healthcareplans <- c("Self-Pay","Medicare","Medicaid","Insurance Company",
                     "Private Health Insurance","Blue Cross","Blue Cross/Blue Shield")
elect <- elect[elect$Source.of.Payment.1 %in% healthcareplans,]
procedures <- c("HIP REPLACEMENT,TOT/PRT","SPINAL FUSION","CANCER CHEMOTHERAPY","ALCO/DRUG REHAB/DETOX")
elect <- elect[elect$CCS.Procedure.Description %in% procedures,]
elect$Length.of.Stay <- as.numeric(as.character(elect$Length.of.Stay))
elect <- elect[elect$Hospital.County=="Manhattan",]
elect <- elect[elect$Facility.Name %in% tail(names(sort(table(elect$Facility.Name))), 10),]
elect$Race <- as.character(elect$Race)
elect$Ethnicity <- as.character(elect$Ethnicity)
elect <- elect[!is.na(elect$Race),]
elect$Race[elect$Ethnicity=="Spanish/Hispanic" & elect$Race=="Other Race"] = "Hispanic"
elect$Age <- 0
elect$Age[elect$Age.Group=="0 to 17"] = sample(0:17,sum(elect$Age.Group=="0 to 17"),replace=T) 
elect$Age[elect$Age.Group=="18 to 29"] = sample(18:29,sum(elect$Age.Group=="18 to 29"),replace=T) 
elect$Age[elect$Age.Group=="30 to 49"] = sample(30:49,sum(elect$Age.Group=="30 to 49"),replace=T) 
elect$Age[elect$Age.Group=="50 to 69"] = sample(50:69,sum(elect$Age.Group=="50 to 69"),replace=T) 
elect$Age[elect$Age.Group=="70 or Older"] = sample(70:100,sum(elect$Age.Group=="70 or Older"),replace=T) 

fit <- lm(log(Total.Charges) ~ 
            log(Length.of.Stay) + Race + Age*Gender + Age*CCS.Procedure.Description + 
            APR.Severity.of.Illness.Description + Facility.Name, data=elect)
summary(fit)
# samplepeople <- read.csv("samplepeople.csv")

testpred <- exp(as.numeric(predict.lm(fit,elect)))
# write.csv(elect, "sample_procedures.csv", row.names = F)

temp <- elect
temp <- temp[,c(5,8,9,11,20,40)]
temp$Facility.Name <- gsub('[[:punct:]]','',temp$Facility.Name)
temp$Facility.Name <- gsub('[[:space:]]','_',temp$Facility.Name)
temp$Race <- gsub('[[:punct:]]','_',temp$Race)
temp$Race <- gsub('[[:space:]]','_',temp$Race)
temp$CCS.Procedure.Description <- gsub('[[:punct:]]','',temp$CCS.Procedure.Description)
temp$CCS.Procedure.Description <- gsub('[[:space:]]','_',temp$CCS.Procedure.Description)
# temp$Age.Group <- paste('_',sep='',temp$Age.Group)
# temp$Age.Group <- gsub('[[:space:]]','_',temp$Age.Group)
temp$PredictedCost <- testpred
temp <- aggregate(temp[,c(4,6,7)], list(
  temp$Facility.Name,
  temp$Age,
  temp$Gender,
  temp$Race), mean)
names(temp)[1:4] <- c("Facility.Name","Age","Gender","Race")

# temp <- aggregate(elect[,9:10], 
#                   by=list(elect$Age.Group, 
#                           elect$Race, 
#                           elect$Gender, 
#                           elect$Zip.Code...3.digits,
#                           elect$Facility.Name,
#                           elect$Length.of.Stay,
#                           elect$CCS.Procedure.Description,
#                           elect$Source.of.Payment.1), mean)

temp <- temp[order(temp$Facility.Name, temp$Age),]
temp <- temp[,-6]
write.table(temp, 'test.tsv', quote=FALSE, sep='\t', row.names = F)





hospitals <- read.csv("hospitals.csv")
library(ggmap)
mymap <- get_map(location = "Manhattan", maptype = "roadmap", zoom = 12)
mapPoints <- ggmap(mymap)
# , maprange = F) + 
#   coord_map(projection="mercator", 
#             ylim=c(40.7008, 40.85001),
#             xlim=c(-74.06012, -73.8934))

tempmap <- merge(temp, hospitals)
tempmap <- tempmap[,-c(2,3,4)]
tempmap <- aggregate(tempmap[,2:5], list(
  temp$Facility.Name), function(x) mean(x, na.rm = T))
library(scales)
mapPoints  + geom_point(data = tempmap, 
               aes(x = lon, y = lat, colour = Length.of.Stay, size=PredictedCost), 
               alpha = .75) + scale_colour_gradient(high="red") + 
  scale_size_continuous(labels=comma)


x <- get_map(maptype = "satellite", zoom = 12) 
ggmap(x, base_layer=ggplot(aes(x=lon,y=lat),data = hospitals),
      extent = "normal", maprange=FALSE) +
  coord_map(projection="mercator", 
            xlim=c(attr(x, "bb")$ll.lon, attr(x, "bb")$ur.lon),
            ylim=c(attr(x, "bb")$ll.lat, attr(x, "bb")$ur.lat)) +
  theme_nothing()





# 
# library(animation)
# 
# ## Save images and convert them to a single HTML animation
# 
# saveHTML({
#   for (i in 1985:2013) {
#     subdata <- subset(alldata[alldata$Cause != "OTHER",],year==i)
#     subdata$Cause <- factor(subdata$Cause, levels = c("RAIN AND TROPICAL STORM","SNOW AND ICE","OTHER"))
#     
#     map_with_jitter <- base_world +
#       geom_point(data=subdata, 
#                  aes(x=Centroid.X,y=Centroid.Y,colour=Cause,size=Affected.sq.km),
#                  position="jitter", alpha=0.3) + scale_size(guide = "none") + 
#       ggtitle(as.character(i)) + theme_bw() +
#       theme(plot.title = element_text(color="#666666", face="bold", size=18)) + 
#       guides(colour = guide_legend(override.aes = list(size=6,linetype=0)))
#     
#     
#     print(plot_grid(map_with_jitter, b, nrow=2))
#   }
# }, ani.height = 600, ani.width = 1000, movie.name = "ggplot2-giftest.html")







