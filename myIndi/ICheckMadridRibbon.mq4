void CheckMadridRibbon()
{
  if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 30)
  {
    if (checkTrend(clrGreen) || checkTrendUptrend(clrGreen))
    {
      if (IsCandleBuyRibbon() && rsiValue < MaxrsiBuy)
      {
        sendOrderSendBuy("IsCandleBuyRibbon", lotSize, 9999);
      }
    }
    else if (checkTrend(clrRed) || checkTrendUptrend(clrRed))
    {
      if (IsCandleSellRibbon() && rsiValue > MaxrsiSEll)
      {
        sendOrderSendSell("IsCandleSellRibbon", lotSize, 9999);
      }
    }
  }
}

bool IsCandleBuyRibbon()
{
  double pipDifferenceSP = MathAbs(SuperTrendValue01 - ema50) / 0.1;
  double pipDifferenceSPA = MathAbs(SuperTrendValue01 - SuperTrendValue08) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;
  double valuePreviousBuy = ((previousOpen - previousClose) / 0.1);

  if (MathAbs(PreviousCandleHigh_1 - ema200) / 0.1 < 35 && currentPrice < ema200)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && currentPrice < ema200)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 20 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 20 && currentPrice < ema50)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > r2Value)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 2)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (iBandH1Upper_0 < iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && ema200 > currentPrice)
  {
    return false;
  }

  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_1 - iIchiTenkan_1) / 0.1 < 4)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 40 || MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 40)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_1 - iBandLower_1) / 0.1 < 5)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 > 100 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 1)
  {
    return false;
  }

  if (iBandH1Lower_0 > iBandLower_0)
  {
    return false;
  }

  if ((rsiValue > MaxrsiBuy || rsiValue1 > MaxrsiBuy || rsiValue2 > MaxrsiBuy || rsiValue3 > MaxrsiBuy)
 && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 15
 )
  {
    return false;
  }


  if (MathAbs(iBandUpper_30 - iBandUpper_1) / 0.1 > 40
  && MathAbs(iBandH1Upper_50 - iBandH1Upper_0) / 0.1 > 150
  && iBandH1Upper_50 > iBandH1Upper_0
  && iBandUpper_1 > iBandUpper_30
  && MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 < 55
  )
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandUpper_1)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 80 && pipDifferenceKIJUN < 2 && currentPrice > ema200 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - currentPrice) / 0.1 < 30 && pipDifferenceKIJUN < 2 && MathAbs(ema50 - currentPrice) / 0.1 < 35)
  {
    return false;
  }

  if (iBandH1Lower_15 > iBandLower_15)
  {
    return false;
  }


  if (iBandH1Upper_15 < iBandUpper_15)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 > 500)
  {
    return false;
  }

  if (currentPrice > HighPrice150 && MathAbs(HighNow - iBandUpper_1) / 0.1 < 10)
  {
    return false;
  }

  if (currentPrice < r2Value && MathAbs(currentPrice - r2Value) / 0.1 < 15 && MathAbs(HighPrice150 - currentPrice) / 0.1 < 60)
  {
    return false;
  }

  if (MathAbs(currentPrice - HighPrice150) / 0.1 > 600 && MathAbs(currentPrice - ema50) / 0.1 < 30)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }

  if (previousClose_2 == previousOpen_2 || previousOpen == previousClose ||
    MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5 ||
    MathAbs((PreviousCandleHigh_2 - PreviousCandleLow_2) / (previousClose_2 - previousOpen_2)) > 5
  )
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10 && isPriceCrossing7EMA50 && currentPrice > ema50)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) >= MathAbs(senkouA2 - senkouB2) && senkouB > senkouA && MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouA10) / 0.1 > 200)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandUpper_15) / 0.1 > 100 && iBandUpper_15 > iBandUpper_1)
  {
    return false;
  }

  if (MathAbs(HighNow - LowNow) / 0.1 > 30)
  {
    return false;
  }

  if (currentPrice > HighPrice150 && pipDifferenceKIJUN < 3 && currentPrice < PreviousCandleHigh_1)
  {
    return false;
  }

  printf("MathAbs(HighPrice150 - currentPrice)    " + MathAbs(HighPrice150 - currentPrice) / 0.1);
  return true;
}

bool IsCandleSellRibbon()
{
  double pipDifferenceSP = MathAbs(SuperTrendValue01 - ema50) / 0.1;
  double pipDifferenceSPA = MathAbs(SuperTrendValue01 - SuperTrendValue08) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;

  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

  if (MathAbs(PreviousCandleLow_1 - ema200) / 0.1 < 35 && currentPrice > ema200)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && currentPrice > ema200)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - ema50) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (PreviousCandleLow_1 < s2Value)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 2)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (iBandH1Lower_0 > iBandLower_0)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && ema200 < currentPrice)
  {
    return false;
  }

  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 80 && pipDifferenceKIJUN < 3 && currentPrice > ema200 && currentPrice < ema50)
  {
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_1 - iIchiTenkan_1) / 0.1 < 4)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - LowNow) / 0.1 < 40 || MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 40)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_1 - iBandUpper_1) / 0.1 < 5)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 > 100 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 1)
  {
    return false;
  }

  if (iBandH1Upper_0 < iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(iBandUpper_30 - iBandUpper_1) / 0.1 > 40
  && MathAbs(iBandH1Upper_50 - iBandH1Upper_0) / 0.1 > 150
  && iBandH1Upper_50 < iBandH1Upper_0
  && iBandUpper_1 < iBandUpper_30
  && MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 < 55
  )
  {
    return false;
  }

  if ((rsiValue < MaxrsiSEll || rsiValue1 < MaxrsiSEll || rsiValue2 < MaxrsiSEll || rsiValue3 < MaxrsiSEll)
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 15
  )
  {
    return false;
  }

  if (PreviousCandleLow_1 < iBandLower_1)
  {
    return false;
  }

  if (valuePreviousSell < 3)
  {
    return false;
  }

  if (MathAbs(iBandLower_1 - currentPrice) / 0.1 < 30 && pipDifferenceKIJUN < 2 && MathAbs(ema50 - currentPrice) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_1 - iBandLower_1) / 0.1 > 500)
  {
    return false;
  }

  if (currentPrice < LowPrice150 && MathAbs(LowNow - iBandLower_1) / 0.1 < 10)
  {
    return false;
  }

  if (currentPrice > s2Value && MathAbs(currentPrice - s2Value) / 0.1 < 15 && MathAbs(LowPrice150 - currentPrice) / 0.1 < 60)
  {
    return false;
  }

  if (MathAbs(currentPrice - LowPrice150) / 0.1 > 600 && MathAbs(currentPrice - ema50) / 0.1 < 30)
  {
    return false;
  }

  if (
  MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5 ||
  MathAbs((PreviousCandleHigh_2 - PreviousCandleLow_2) / (previousClose_2 - previousOpen_2)) > 5
)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10 && isPriceCrossing7EMA50 && currentPrice < ema50)
  {
    return false;

  }

  if (MathAbs(senkouA - senkouB) >= MathAbs(senkouA2 - senkouB2) && senkouB < senkouA && MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouA10) / 0.1 > 200)
  {
    return false;
  }


  if (MathAbs(iBandLower_1 - iBandLower_15) / 0.1 > 100 && iBandLower_1 > iBandLower_15)
  {
    return false;
  }
  if (MathAbs(HighNow - LowNow) / 0.1 > 30)
  {
    return false;
  }

  if (iBandH1Upper_15 < iBandUpper_15)
  {
    return false;
  }

  if (iBandH1Lower_15 > iBandLower_15)
  {
    return false;
  }

  return true;
}
