function CNR = calcCNR(x,y)
    signalPow = rssq(x(:)).^2;
    noisePow  = rssq(y(:)).^2;
    CNR = 10 * log10(signalPow / noisePow);
return