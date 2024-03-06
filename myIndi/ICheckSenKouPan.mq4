
void CheckSenKouPan()
{
  if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 30)
  {
    if (senkouA > senkouB && checkTrendUptrendUPdate(clrGreen))
    {
      if (rsiValue < MaxrsiBuy && IsCandleBuySenKouPan())
      {
        sendOrderSendBuy("IsCandleBuySenKouPan", lotSize, 9999);
      }
    }
    else if (senkouA < senkouB && checkTrendUptrendUPdate(clrRed))
    {
      if (rsiValue > MaxrsiSEll && IsCandleSellSenKouPan())
      {
        sendOrderSendSell("IsCandleSellSenKouPan", lotSize, 9999);
      }
    }
  }
}


bool IsCandleSellSenKouPan()
{
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  if (currentPrice > PreviousCandleLow_1)
  {
    return false;
  }

  if (IsPriceCrossingOneEMA50)
  {
    return false;
  }

  if (IsAreRecent5CandlesUperThan7)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 1 && MathAbs(currentPrice - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (PreviousCandleLow_1 < s4Value)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.5)
  {
    return false;
  }


  if (currentPrice < iBandH1Lower_1)
  {
    return false;
  }

  if (MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 20 && PreviousCandleLow_1 > LowPrice150)
  {
    return false;
  }

  if (iBandH1Upper_1 < iBandUpper_1 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 20 && currentPrice < ema50 && isPriceCrossing7EMA50)
  {
    return false;
  }


  if (MathAbs(currentPrice - ema50) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (PreviousCandleLow_1 < LowPrice150 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (iBandH1Lower_1 > iBandLower_1 && MathAbs(ema200 - PreviousCandleLow_1) / 0.1 < 30)
  {
    return false;
  }

  if (candleHour > 21 || candleHour < 2)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 < 10)
  {
    return false;
  }


  if (MathAbs(PreviousCandleHigh_1 - ema50_1) / 0.1 < 20 && currentPrice < ema50 && LowNow > LowPrice150)
  {
    return false;
  }

  printf("IsAreRecent5CandlesUperThan7  " + IsAreRecent5CandlesUperThan7);

  return true;
}

bool IsCandleBuySenKouPan()
{
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;

  if (IsPriceCrossingOneEMA50)
  {
    return false;
  }


  if (pipDifferenceKIJUN < 1 && MathAbs(currentPrice - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.5)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    return false;
  }

  if (currentPrice > iBandH1Upper_1)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandH1Upper_1)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > r4Value)
  {
    return false;
  }
  if (MathAbs(senkouA - senkouB) / 0.1 < 7 && iBandH1Upper_1 < iBandUpper_1)
  {
    return false;
  }
  if (senkouA > senkouB
  && MathAbs(senkouA - senkouB) < MathAbs(senkouA2 - senkouB2)
  )
  {
    return false;
  }

  if (IsAreRecent4CandlesLower)
  {
    return false;
  }


  if (iBandH1Lower_1 > iBandLower_1 && MathAbs(ema50 - PreviousCandleHigh_1) / 0.1 < 30)
  {
    return false;
  }

  if (IsAreRecent5CandlesLower)
  {
    return false;
  }


  if (iBandUpper_1 > iBandH1Upper_1 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (iBandUpper_1 > iBandH1Upper_1 && rsiValue1 > MaxrsiBuy)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 1 && currentPrice > HighPrice150)
  {
    return false;
  }

  if (candleHour > 21 || candleHour < 2)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 < 10)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 14)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 20)
  {
    return false;
  }

  if (HighPrice150 < HighNow && MathAbs(iBandH1Upper_0 - iBandUpper_0) / 0.1 < 15 && currentPrice > iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 20)
  {
    return false;
  }
  printf("HighPrice150  " + HighPrice150);

  return true;
}

