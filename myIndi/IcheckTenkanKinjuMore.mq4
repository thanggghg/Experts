void checkTenkanKinjuMore()
{

  if (iIchiTenkan_1 > iIchiTenkan_2 && iIchiKinjun_1 > iIchiKinjun_2)
  {
    if (IsCandleBuyTenkanKinjun() && rsiValue < MaxrsiBuy)
    {
      sendOrderSendBuy("IsCandleBuyTenkanKinjun", lotSize, 9999);
    }
  }
  else if (iIchiTenkan_1 < iIchiTenkan_2 && iIchiKinjun_1 < iIchiKinjun_2)
  {
    if (IsCandleSellTenkanKinjun() && rsiValue > MaxrsiSEll)
    {
      sendOrderSendSell("IsCandleSellTenkanKinjun", lotSize, 9999);
    }
  }

}

bool IsCandleSellTenkanKinjun()
{

  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.3)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(iBandSma_1 - iBandUpper_1) / 0.1 < 20)
  {
    return false;
  }

  if (currentPrice > PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && iBandH1Lower_1 > iBandLower_1)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (currentPrice < s3Value)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
  {
    return false;
  }

  if (MathAbs(currentPrice - HighPrice150) / 0.1 > 800)
  {
    return false;
  }

  if (MathAbs(currentPrice - LowPrice150) / 0.1 < 25 )
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35)
  {
    return false;
  }
  return true;
}



bool IsCandleBuyTenkanKinjun()
{


  if (candleHour >= 21 || candleHour <= 2)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.3)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 35)
  {
    return false;
  }

  if (MathAbs(iBandSma_1 - iBandUpper_1) / 0.1 < 20)
  {
    return false;
  }

  if (currentPrice < PreviousCandleHigh_1)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - HighPrice150) / 0.1 < 30 && iBandH1Upper_1 < iBandUpper_1)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 5)
  {
    return false;
  }

  if (currentPrice > r3Value)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
  {
    return false;
  }

  if (MathAbs(currentPrice - LowPrice150) / 0.1 > 800)
  {
    return false;
  }

  if (MathAbs(currentPrice - iBandH1Upper_1) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(currentPrice - HighPrice150) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35)
  {
    return false;
  }

  return true;
}


