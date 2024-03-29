void CheckPivotStrategy()
{

  if (MathAbs(previousClose - previousOpen) / 0.1 > 2)
  {
    if (previousClose <= s3Value)
    {

      bool Istrue = false;
      for (int z = 0; z < 9; z++)
      {
        double iPreviousCandleLow_1 = iLow(NULL, 0, z);
        if (iPreviousCandleLow_1 > s3Value)
        {
          Istrue = true;
        }
      }

      if (IsCandleBuyPivot())
      {
        sendOrderSendBuy("IsCandleBuyPivot", lotSize, 9999);
      }
      Istrue = false;
    }
    else if (previousClose >= r3Value)
    {
      bool Istruer3 = false;
      for (int A = 0; A < 9; A++)
      {
        double HighNow = iHigh(NULL, 0, A);
        if (HighNow < r3Value)
        {
          Istruer3 = true;
        }
      }

      if (IsCandleSellPivot())
      {
        sendOrderSendSell("IsCandleSellPivot", lotSize, 9999);
      }
      Istruer3 = false;
    }
  }
}


bool IsCandleBuyPivot()
{

  if (iBandH1Lower_0 > currentPrice)
  {
    return false;
  }

  if (iBandH1Lower_0 > iBandLower_0)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 25)
  {
    return false;
  }

  if (currentPrice < ema50 && MathAbs(HighNow - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - iBandLower_0) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_1 - iBandLower_1) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 700)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema200) / 0.1 < 40 && ema200 > PreviousCandleHigh_1)
  {
    return false;
  }

  printf("MathAbs(previousClose - previousOpen) " + MathAbs(iBandH1Lower_0 - iBandLower_0) / 0.1);
  return true;
}

bool IsCandleSellPivot()
{

  if (currentPrice > iBandH1Upper_0)
  {
    return false;
  }

  if (currentPrice > ema50 && MathAbs(LowNow - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (iBandH1Upper_0 < iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - iBandUpper_0) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_1 - iBandUpper_1) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - ema200) / 0.1 < 40 && ema200 < PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 700)
  {
    return false;
  }
  printf("MathAbs(previousClose - previousOpen) " + MathAbs(iBandH1Lower_0 - iBandLower_0) / 0.1);

  return true;
}

