void MaxMinOderRSI()
{

  if (rsiValue > MaxOrderrsi
  && previousOpen > previousClose
  && IsCandleSellRSI()
  )
  {
    sendOrderSendSell("IsCandleSellRSI", lotSize, 9999);
  }
  else if (rsiValue < MinOrderrsi
  && previousOpen < previousClose
  && IsCandleBuyRSI()

  )
  {
    sendOrderSendBuy("IsCandleSellRibbon", lotSize, 9999);
  }

}

bool IsCandleSellRSI()
{
  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

  if (iBandH1Upper_0 < iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(ema50 - LowNow) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (MathAbs(valuePreviousSell) < 3)
  {
    return false;
  }

  if (MathAbs(HighNow - LowNow) / 0.1 > 30)
  {
    return false;
  }

  return true;
}

bool IsCandleBuyRSI()
{
  double valuePreviousBUY = ((previousClose - previousOpen) / 0.1);


  if (MathAbs(ema50 - HighNow) / 0.1 < 20 && currentPrice < ema50)
  {
    return false;
  }

  if (iBandH1Lower_0 > iBandLower_0)
  {
    return false;
  }


  if (MathAbs(valuePreviousBUY) < 3)
  {
    return false;
  }

  if (MathAbs(HighNow - LowNow) / 0.1 > 50)
  {
    return false;
  }

  return true;
}