# List up files
files = list.files('./data',full.names=T)
f = length(files)

si = gsub(".*(.)2018.*", "\\1", files)
n = length(table(si))

# Load data and store
temp = read.csv(files[1])
temp$si = si[1]
m = nrow(temp)
for (i in 2:f) {
  d = read.csv(files[[i]])
  d$si = si[i]
  temp = rbind(temp, d)
  }
dat = temp
dat$sub = dat$si
dat$si = NULL

# Reshape data for anova
ano = aggregate(x=dat$cdt, by=dat[c("doty","sub")], FUN=mean)
library("reshape2")
dc = dcast(ano, sub ~ doty, mean, value.var="x")
dc = subset(dc, select = -sub)
ddd = ncol(dc)

# Calculate SD
sd = sd(dc[,1])
for (l in 2:ddd) {sd = rbind(sd, sd(dc[,l]))}
sd = cbind(sd, dat$sub)

# Calculate SE
se = sd/sqrt(n)

# Anovakun
#source("anovakun_481.txt", encoding = "CP932")
#anovakun(dc,"sA", 6, peta=T)

# Plot indivisual data
par(mfrow=c(2,3))
for (k in 1:n){
  camp = subset(dat, dat$sub == si[k], c("doty", "cdt"))
  plot(camp, xlim=c(0,21), ylim=c(0,15), type = "p",xlab="vertical disparity(min of arc)", ylab="cumulative disapperance times(sec)")
  par(new=T)
  plot(aggregate(x = camp$cdt, by=camp["doty"], FUN=mean), type = "l", col="blue", xlim=c(0,21), ylim=c(0,15), ylab="", xlab="")
  par(new=F)
}

# Plot cdt with error bar
cdt = aggregate(x=dat$cdt, by=dat["doty"],FUN=mean)
plot(cdt, xlim=c(0,21), ylim=c(0,15), type="b", xlab="vertical disparity(min of arc)", ylab="mean of cdt(sec)")
arrows(cdt$doty, cdt$x-se, cdt$doty, cdt$x+se, length=0.05, angle=90, code=3)