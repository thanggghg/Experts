

void check15h()
{

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 3)
  {
    return false;
  }
  
    if (MathAbs(senkouA - senkouB) / 0.1 < 7 )
  {
    return false;
  }

  if(IsCandleInCloud(1)){
     return false;
  }

  if(rsiValue > MaxrsiBuy || rsiValue < MaxrsiSEll ){
    return false;
  }

  if(rsiValue1 > MaxrsiBuy || rsiValue1 < MaxrsiSEll ){
    return false;
  }

  
  if(currentPrice < s4Value || currentPrice > r4Value ){
    return false;
  }


  
   
   
    if (MathAbs(iBandH1Sma_1 - iBandH1Lower_1) / 0.1 < 50 && MathAbs(iBandLower_1 -  iBandSma_1) / 0.1 < 20)
  {
    return false;
  }


  if (MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) /0.1 > 100)
  {
    return false;
  }
  
    if (MathAbs(r4Value - r2Value) / 0.1 < 80)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200_1) / 0.1 > 50 && MathAbs(ema50 - ema200_1) / 0.1 > 20 )
  {
    if (previousClosePrice != previousClose)
    {

      if (previousOpen < previousClose
           && SuperTrendValue21 == 1
      )
      {

        sendOrderSendBuy("IsCandleBuycheck15h", lotSize, 9999);
      }
      else if (previousOpen > previousClose
          && SuperTrendValue21 == -1
      )
      {
        sendOrderSendSell("IsCandleSellcheck15h", lotSize, 8888);
      }
    }
  }
}
