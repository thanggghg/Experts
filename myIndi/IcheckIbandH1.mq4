void checkIbandH1()
{

  if (iBandH1Lower_1 > iBandLower_1 && previousClose < iBandLower_1)
  {
    if (IsCandleBuycheckIbandH1())
    {
      sendOrderSendBuy("IsCandleBuycheckIbandH1", lotSize, 9999);
    }
  }
  else if (iBandUpper_1 > iBandH1Upper_1 && previousClose > iBandUpper_1)
  {
    if (IsCandleSellIbandH1())
    {
      sendOrderSendSell("IsCandleSellIbandH1", lotSize, 9999);
    }
  }

}


bool IsCandleSellIbandH1()
{

  pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  pipDifferenceTenkan = MathAbs(iIchiTenkan_1 - iIchiTenkan_5) / 0.1;

  if (candleHour == 14 || candleHour == 13 || candleHour == 7 || candleHour == 8)
  {
    return false;
  }


  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.2)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 11)
  {
    return false;
  }

  if ((currentPrice - PreviousCandleLow_1) / 0.1 > 150 || (currentPrice - PreviousCandleLow_2) / 0.1 > 150)
  {
    return false;
  }

  if (pipDifferenceTenkan > 40)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / 0.1 > 40)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(currentPrice - HighPrice150) / 0.1 < 500)
  {
    return false;
  }

  printf("pipDifferenceKIJUN " + pipDifferenceTenkan);
  return true;
}

bool IsCandleBuycheckIbandH1()
{

  pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  pipDifferenceTenkan = MathAbs(iIchiTenkan_1 - iIchiTenkan_5) / 0.1;

  if (candleHour == 14 || candleHour == 13 || candleHour == 7 || candleHour == 8)
  {
    return false;
  }


  if (MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) < 0.2)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 11)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(previousClose - previousOpen) / 0.1 > 40)
  {
    return false;
  }

  if (pipDifferenceTenkan > 40)
  {
    return false;
  }

  if ((PreviousCandleHigh_1 - currentPrice) / 0.1 > 150 || (PreviousCandleHigh_2 - currentPrice) / 0.1 > 150)
  {
    return false;
  }

  if (currentPrice < s3Value)
  {
    return false;
  }

  return true;
}


