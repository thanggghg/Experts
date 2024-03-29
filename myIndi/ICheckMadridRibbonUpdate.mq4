void CheckMadridRibbonUpdate()
{
  // Kiểm tra nếu giá chạm mức S3, thì thực hiện mua
  if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 30)
  {
    if (checkTrendUptrendUPdate(clrGreen))
    {
      if (currentPrice < SuperTrendValue01 && MathAbs(currentPrice - SuperTrendValue01) / 0.1 > 3 && IsCandleBuyRibbonUpdate())
      {
        sendOrderSendBuy("IsCandleBuyRibbonUpdate", lotSize, 9999);

      }

    }
    else if (checkTrendUptrendUPdate(clrRed))
    {
      if (currentPrice > SuperTrendValue01 && MathAbs(currentPrice - SuperTrendValue01) / 0.1 > 3 && IsCandleSellRibbonUpdate())
      {
        sendOrderSendSell("IsCandleSellRibbonUpdate", lotSize, 9999);
      }
    }
  }
}


bool IsCandleSellRibbonUpdate()
{
  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  //2020
  if (iBandUpper_1 > iBandH1Upper_0)
  {
    return false;
  }
  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }
  if (MathAbs(ema50 - currentPrice) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - LowNow) / 0.1 < 40 || MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 40)
  {
    return false;
  }

  if (iBandH1Lower_1 > iBandLower_1)
  {
    return false;
  }

  if (PreviousCandleLow_1 < s2Value)
  {
    return false;
  }

  if ((rsiValue < MaxrsiSEll || rsiValue1 < MaxrsiSEll || rsiValue2 < MaxrsiSEll || rsiValue3 < MaxrsiSEll)
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 15
  )
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

  if (MathAbs(ema50 - ema200) / 0.1 < 80 && pipDifferenceKIJUN < 3 && currentPrice > ema200 && currentPrice < ema50)
  {
    return false;
  }

  if (PreviousCandleLow_1 < iBandLower_1 && MathAbs(ema50 - currentPrice) / 0.1 < 25)
  {
    return false;
  }

  if (valuePreviousSell < 3)
  {
    return false;
  }

  if (MathAbs(iBandH1Sma_1 - iBandSma_1) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 25 && currentPrice > ema50)
  {
    return false;
  }

  if (MathAbs(ema50 - PreviousCandleLow_1) / 0.1 < 25 && currentPrice > ema50)
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

  if (MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 3 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }

  if ((MathAbs(ema50 - PreviousCandleHigh_1) / 0.1 < 25 || MathAbs(ema50 - PreviousCandleLow_1) / 0.1 < 25) && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (iBandH1Upper_15 < iBandUpper_15)
  {
    return false;
  }

  if (MathAbs(HighNow - LowNow) / 0.1 > 30)
  {
    return false;
  }

  printf("MathAbs(ema50 - ema200)    " + MathAbs(ema50 - ema200) / 0.1);
  //2020
  return true;
}

bool IsCandleBuyRibbonUpdate()
{
  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_1 - iIchiKinjun_4) / 0.1;
  //2020
  if (iBandH1Lower_1 > iBandLower_1)
  {
    return false;
  }

  if (iBandUpper_1 > iBandH1Upper_0)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > r2Value)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }

  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 25 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 15)
  {
    return false;
  }

  if ((MathAbs(ema50 - PreviousCandleHigh_1) / 0.1 < 25 || MathAbs(ema50 - PreviousCandleLow_1) / 0.1 < 25) && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - PreviousCandleHigh_1) / 0.1 < 25 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 40 || MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 40)
  {
    return false;
  }
  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (valuePreviousSell < 3)
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

  if (MathAbs(iBandH1Sma_1 - iBandSma_1) / 0.1 < 15)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandUpper_1 && MathAbs(ema50 - currentPrice) / 0.1 < 25)
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

  if (MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 3 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (iBandH1Lower_15 > iBandLower_15)
  {
    return false;
  }

  if (MathAbs(HighNow - LowNow) / 0.1 > 30)
  {
    return false;
  }
  printf("MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose))    " + MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)));
  //2020
  return true;
}

