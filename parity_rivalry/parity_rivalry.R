# List up files
files = list.files('./replication/parity_rivalry/data',full.names=T)
f = length(files)

si = gsub(".*(..)2019.*","\\1", files)
n = length(table(si))
usi = unique(si)

# Load data and store
temp = read.csv(files[1])
temp$sub = si[1]
temp$sn <- 1 
for (i in 2:f) {
  d = read.csv(files[[i]])
  d$sub = si[i]
  d$sn <- i
  temp = rbind(temp, d)
}

# Plot indivisual data
par(mfrow=c(2,3))
#for (l in 1:n){
for (i in 1:n){
  camp = subset(temp, temp$sub == usi[i], c("visual_angle", "cdt"))
#    camp = subset(temp, temp$sub == usi[l] and temp$sn == [i] , c("visual_angle", "cdt", "sn"))
#    plot(x=camp$visual_angle, y=camp$cdt, xlim=c(0,3), ylim=c(0,30), type="p", xlab="stimulus_size(deg)", ylab="cdt(sec)", main=toupper(usi[l]), col="red")
  plot(camp, xlim=c(0,3), ylim=c(0,30), type="p", xlab="stimulus_size(deg)", ylab="cdt(sec)", main=toupper(usi[i]))
  par(new=T)
  plot(aggregate(x=camp$cdt, by=camp["visual_angle"], FUN=mean), type="l", col="blue", xlim=c(0,3), ylim=c(0,30), xlab="", ylab="")
  par(new=F)
}
# Plot all data
plot(x=temp$visual_angle, y=temp$cdt, xlim=c(0,3), ylim=c(0,30), type="p", xlab="stimulus_size(deg)", ylab="cumultive disapperance times(sec)")
par(new=T)
plot(aggregate(x=temp$cdt, by=temp["visual_angle"], FUN=mean), type="l", col="blue", xlim=c(0,3), ylim=c(0,30), xlab="", ylab="")
par(new=F)
