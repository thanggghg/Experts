
void checkIDAX()
{

  if (IDAX > 40 && IDAXP > IDAXm)
  {
    if (rsiValue < MaxrsiBuy && IsCandleBuyIDAX())
    {
      printf("IDAX" + IDAX);
      sendOrderSendBuy("IsCandleBuyIDAX", lotSize, 9999);
    }
  }
  else if (IDAX > 40 && IDAXP < IDAXm)
  {
    if (rsiValue > MaxrsiSEll && IsCandleSellIDAX())
    {
      printf("IDAX" + IDAX);
      printf("IDAXP" + IDAXP);
      printf("IDAXm" + IDAXm);
      sendOrderSendSell("IsCandleSellIDAX", lotSize, 9999);
    }
  }

}

bool IsCandleSellIDAX()
{

  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }


  if (iBandH1Lower_0 < iBandH1Lower_1)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50 && MathAbs(ema200 - HighNow) / 0.1 < 30)
  {
    return false;
  }



  if (MathAbs(r2Value - r3Value) / 0.1 < 45)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema200) / 0.1 < 35)
  {
    return false;
  }


  if (MathAbs(PreviousCandleLow_1 - ema200) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 35)
  {
    return false;
  }


  if (MathAbs(PreviousCandleLow_1 - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.2)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_1 - iBandH1Upper_1) / 0.1 > 700)
  {
    return false;
  }

  if (MathAbs(IDAXP - IDAXm) < 4)
  {
    return false;
  }

  return true;
}

bool IsCandleBuyIDAX()
{

  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(r2Value - r3Value) / 0.1 < 45)
  {
    return false;
  }

  if (iBandUpper_1 > iBandH1Upper_1)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50 && MathAbs(ema200 - HighNow) / 0.1 < 30)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema200) / 0.1 < 35)
  {
    return false;
  }


  if (MathAbs(PreviousCandleLow_1 - ema200) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 35)
  {
    return false;
  }


  if (MathAbs(PreviousCandleLow_1 - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.2)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_1 - iBandH1Upper_1) / 0.1 > 700)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - LowPrice150) / 0.1 > 500)
  {
    return false;
  }

  if (MathAbs(IDAXP - IDAXm) < 4)
  {
    return false;
  }


  printf("MathAbs(HighPrice150 - LowPrice150) " + MathAbs(HighPrice150 - LowPrice150));
  return true;
}