void CheckTenkanKinju()
{

  if (iIchiTenkan_1 > iIchiKinjun_1 && MathAbs(iIchiTenkan_1 - iIchiKinjun_1) / 0.1 > 2)
  {
    if (rsiValue < MaxrsiBuy && IsCandleBuyTenkan())
    {
      sendOrderSendBuy("IsCandleBuyTenkan", lotSize, 9999);
    }
  }
  else if (iIchiKinjun_1 < iIchiTenkan_1 && MathAbs(iIchiTenkan_1 - iIchiKinjun_1) / 0.1 > 2)
  {
    if (rsiValue > MaxrsiSEll && IsCandleSellTenkan())
    {
      sendOrderSendSell("IsCandleSellTenkan", lotSize, 9999);
    }
  }

}

bool IsCandleSellTenkan()
{

  pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  pipDifferenceTenkan = MathAbs(iIchiTenkan_1 - iIchiTenkan_5) / 0.1;
  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (currentPrice > PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (pipDifferenceTenkan < 1 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50 && MathAbs(ema200 - LowNow) / 0.1 < 30)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 40)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 80 && pipDifferenceKIJUN < 2 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (MathAbs(iIchiKinjun_1 - iIchiTenkan_1) / 0.1 < 3)
  {
    return false;
  }
  if (MathAbs(previousClose - previousOpen) / 0.1 < 3)
  {
    return false;
  }

  if (currentPrice < s3Value)
  {
    return false;
  }



  return true;
}

bool IsCandleBuyTenkan()
{

  pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  pipDifferenceTenkan = MathAbs(iIchiTenkan_1 - iIchiTenkan_5) / 0.1;

  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (currentPrice < PreviousCandleHigh_1)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 25 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 25 && pipDifferenceTenkan < 1)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 25 && pipDifferenceTenkan < 1)
  {
    return false;
  }

  if (MathAbs(ema50 - PreviousCandleLow_1) / 0.1 < 7 && currentPrice > ema50)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / 0.1 < 3)
  {
    return false;
  }

  if (IsAreRecent4CandlesLower)
  {
    return false;
  }

  if (IsAreRecent5CandlesLower)
  {
    return false;
  }

  if (pipDifferenceTenkan < 1 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50 && MathAbs(ema200 - HighNow) / 0.1 < 30)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 40)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 80 && pipDifferenceKIJUN < 2 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (MathAbs(iIchiKinjun_1 - iIchiTenkan_1) / 0.1 < 3)
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

  if (IsAreRecent4CandlesLower)
  {
    return false;
  }

  if (currentPrice > r3Value)
  {
    return false;
  }
  if (MathAbs(HighNow - ema200) / 0.1 < 35 && HighNow < ema200 && pipDifferenceKIJUN < 1)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 20 && iBandUpper_1 > iBandH1Upper_1)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 20 && HighPrice150 > HighNow && MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    return false;
  }

  if (HighPrice150 < HighNow && MathAbs(iBandH1Upper_0 - iBandUpper_0) / 0.1 < 15 && currentPrice > iBandUpper_0)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 1 && MathAbs(senkouA - senkouB) / 0.1 < 3)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 1 && iBandUpper_1 > iBandH1Upper_1 && HighPrice150 < HighNow)
  {
    return false;
  }


  if (MathAbs(currentPrice - LowPrice150) / 0.1 > 500)
  {
    return false;
  }

   if (MathAbs(HighNow - HighPrice150) / 0.1 < 15)
  {
    return false;
  }

  printf("MathAbs(HighNow - ema200) / 0.1 " + MathAbs(HighPrice150 - HighNow) / 0.1);
  printf("HighPrice150 > HighNow " + (HighPrice150 > HighNow));
  printf("candleHour " + candleHour);
  return true;
}

