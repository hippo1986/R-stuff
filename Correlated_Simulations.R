# simulate historical stock prices #
set.seed(10)
n<-250; r<-0.05 ; dt<-1/n 
sigma<-c(0.4,0.3,0.35)
SIGMA<-matrix(c(1,0.3,0.3,0.3,1,0.3,0.3,0.3,1),3,3)
SIGMA<-SIGMA*(sigma %*% t(sigma))

#starting values #
S<-matrix(0, 3, n+1); 
S[,1]<-c(100,90,80) #1.Spalte d.h. 3 Assets in 3 Zeilen übereinander 
for (i in 1:n) {
  S[,i+1]<-S[,i]*exp(r*dt+rnorm(3)%*%chol(SIGMA)*sqrt(dt));
}

Portf<-S[1,]+S[2,]+S[3,]
print(Portf)
returnS<-diff(t(log(S)))
returnP<-diff(log(Portf))

cor(returnS)
A<-var(returnS)/dt
B<-var(returnP)/dt
C<-S[,n+1]

time<-(0:n)/n;
range<-c(min(S)*0.5, max(S)*1.2);
plot(time,S[1,], type='l', xlim=c(0,1.6),ylim=range, ylab='stock price')
lines(time, S[2,], type='l')
lines(time,S[3,], type='l')

range<-c(min(S)*0.5, max(S)*1.6);
plot(time,S[1,], type='l', xlim=c(0,1.6),ylim=range, ylab='stock price')
lines(time, S[2,], type='l')
lines(time,S[3,], type='l')
lines(c(1,1), range, type='l')
print(C)

# simulate scenarios ## 
K<-250; t<-0.5; 
d1<-(log(sum(C)/K)+(r+B^2/2)*t)/sqrt(B*t)
d2<-d1-sqrt(B*t);
sum(C)*pnorm(d1)-K*exp(-r*t)*pnorm(d2);

N<-20000
S<-matrix(0,N,3)
S[,1]<-C[1]; S[,2]<-C[2]; S[,3]<-C[3]; 

for (i in 1:125) {
  S<-S*exp(r*dt+matrix(rnorm(3*N),N,3) %*% chol(A)*sqrt(dt))
}

P<-S[,1]+S[,2]+S[,3]
price<-exp(-r*T)*pmax(P-K,0); 
mean(price)
for (i in 1:20){
  lines(c(1,1.5),c(C[1],S[i,1]), type='l')
  lines(c(1,1.5),c(C[2],S[i,2]), type='l')
  lines(c(1,1.5),c(C[3],S[i,3]), type='l')
}
