rm(list=ls())
constrained.kmeans <- function(p,a,std,k,b,imax,seed,details){
# Bob Agnew (raagnew1@gmail.com, www.raagnew.com)
# Constrained k-means clustering using lp.transport function
# in R package lpSolve
# Implements Bradley-Bennett-Demiriz algorithm
# p = population vector associated with observations
# Population for each observation must be assigned to same cluster
# For a normal clustering problem, p is a vector of ones
# a = numeric attribute matrix with a row for each observation
# std = TRUE if attributes are to be standardized across observations,
# else FALSE
# k = specified number of k-means clusters
# b = vector of integer lower bounds for population clusters
# If all populations are one, then these are exact lower bounds
# for cluster sizes
# If populations vary, then these are target lower bounds for
# cluster populations
# imax = maximum number of iterations in kmeans loop
# seed = random number seed for initial cluster assignments
# details = TRUE for printing of iteration details, else FALSE
m <- dim(a)[1] # Number of observations
n <- dim(a)[2] # Number of attributes
if (std) {a <- apply(a,2,function(u) (u-mean(u))/sd(u))}
set.seed(seed,kind=NULL,normal.kind=NULL) # Set random number seed
c <- sample.int(k,m,replace=TRUE,prob=NULL) # Initial cluster vector
require(lpSolve) # Load R linear programming package
num <- iter <- 1
while (iter <= imax & num > 0){
cost <- matrix(0,nrow=m,ncol=k)
for (j in 1:n){
cost <- cost + outer(a[,j],tapply(p*a[,j],c,sum)/tapply(p,c,sum),"-")^2}
# Solution of transportation linear program
trans <- lp.transport(cost,"min",rep("=",m),p,rep(">=",k),b)
# Generate new clusters
# For split allocation, assign to maximal cluster
c1 <- apply(trans$solution,1,which.max)
num <- sum(c1!=c)
if (details){
print(noquote("Iteration Number"))
print(iter)
print(trans)
print(noquote("Number of split allocations"))
print(sum(apply(trans$solution,1,max) < p))
print(noquote("Number of revised cluster elements"))
print(num)}
c <- c1 #Clusters revised
iter <- iter + 1
}
means <- NULL
for (j in 1:n){
means <- cbind(means,tapply(p*a[,j],c,sum)/tapply(p,c,sum))}
cost <- matrix(0,nrow=m,ncol=k)
for (j in 1:n){
cost <- cost + outer(a[,j],tapply(p*a[,j],c,sum)/tapply(p,c,sum),"-")^2}
cost <- matrix(p,nrow=m,ncol=k)*cost
ss <- sum(cost*outer(c,1:k,"=="))
result <- list(iter-1,num==0,c,tapply(p,c,sum),means,ss)
names(result) <- c("iter","converge","cluster","population","centers",
"tot.withinss")
return(result)}

date() # Time
# Read in Connecticut census block group data
# Downloaded CT data from https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/
# Trimmed data in CT_Extract.R script
data <- read.table("c:/Congressional_Districting/CT_Blkgrps.txt",sep=",",header=TRUE)
# Remove dummy block groups with no population 
data <- data[data[,4]!="0",]
p <- sapply(data[,4],as.numeric) #Census block group populations
# Number of census block groups with positive population
length(p)
# Block group population range
range(p)
# Block group population mean
mean(p)
# Block group population median
median(p)
a <- matrix(sapply(data[,c(6,5)],as.numeric),ncol=2) # Block group longitudes and latitudes
# Block group longitude range
range(a[,1])
# Block group latitude range
range(a[,2])
k <- 5 # Number of clusters = number of CT congressional districts

# Constrained k-means clustering applied to CT congressional districting
# Target population lower bounds set tightly at average rounded down
ckm <- constrained.kmeans(p,a,FALSE,k,rep(floor(sum(p)/k),k),100,23,TRUE)
ckm$iter
ckm$converge
ckm$tot.withinss
ckm$population # Approximately equal
MEAN_LONGITUDE <- ckm$centers[,1]
MEAN_LATITUDE <- ckm$centers[,2]
c <- ckm$cluster
CLUSTER <- sapply(c,as.character)

# Save blockgroup table with appended clusters
write.table(cbind(data,CLUSTER),file="c:/CONGRESSIONAL_DISTRICTING/CT_Blkgroup_Clusters.txt",sep=",",row.names=FALSE,col.names=TRUE)

# Geoplot of CT census block groups and cluster centroids
pdf("c:/CONGRESSIONAL_DISTRICTING/CT_Census_Block_Group_Centroids.pdf")
plot(a[,1],a[,2],col="black",pch=19,cex=.25,asp=1.5,xlab="LONGITUDE",ylab="LATITUDE",
main="CONNECTICUT CENSUS BLOCK GROUPS & CLUSTER CENTROIDS")
points(MEAN_LONGITUDE,MEAN_LATITUDE,col="red",pch=19,cex=.75)
dev.off()

# Geoplot of CT census block group clusters
pdf("c:/CONGRESSIONAL_DISTRICTING/CT_Census_Block_Group_Clusters.pdf")
plot(a[,1],a[,2],asp=1.5,cex=.25,col=rainbow(k)[c],pch=19,xlab="LONGITUDE",ylab="LATITUDE",
main="CONNECTICUT CENSUS BLOCK GROUP CLUSTERS")
dev.off()
date() # Time

