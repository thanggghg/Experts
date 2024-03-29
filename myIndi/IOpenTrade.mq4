void OpenTrade()
{
  if (CountOrdersWithMagic() < 1)
  {
    double valueSell = ((GetMin(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0) - currentPrice) / 0.1);
    double valueBUY = ((currentPrice - GetMax(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0)) / 0.1);
    previousClosePrice = previousClose;
    if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < MaxPipPreviou)
    {
      if (previousClose < iIchiKinjun_0)
      {
        if (valueSell > 3
            && IsCandleSell()
            && rsiValue > MaxrsiSEll
            && currentPrice > s3Value
            )
        {
          sendOrderSendSell("IsCandleSell", lotSize, 9999);

        }
      }
      else if (previousClose > iIchiKinjun_0)
      {
        if (valueBUY > 3
           && IsCandleBuy()
           && rsiValue < MaxrsiBuy
           && currentPrice < r3Value
           )
        {
          sendOrderSendBuy("IsCandleBuy", lotSize, 9999);

        }
      }
    }
  }
}

bool IsCandleSell()
{

  double pipDifferenceEMATENKAN = MathAbs(ema50 - iIchiTenkan_3) / 0.1;
  double pipDifferenceEMA = MathAbs(ema50 - currentPrice) / 0.1;

  double pipDifferenceEMAKIJUN = MathAbs(ema50 - iIchiKinjun_3) / 0.1;
  double pipDifferenceTenkan = MathAbs(iIchiTenkan_0 - iIchiTenkan_5) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;

  double valueSell = ((GetMin(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0) - previousClose) / 0.1);
  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

  if (isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_0 - iIchiTenkan_0) / 0.1 < 1)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 10 && isPriceCrossing14EMA200 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && iBandLower_1 > PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && currentPrice > ema50)
  {
    return false;
  }

  if (currentPrice < LowPrice150 && rsiValue1 > (MaxrsiSEll + 3))
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 420 && MathAbs(ema50 - currentPrice) / 0.1 < 60 && currentPrice > ema50)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    return false;
  }


  if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && LowNow < iBandLower_0)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && isPriceCrossing7EMA200)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 60 && MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 25 && MathAbs(ema50 - currentPrice) / 0.1 < 30)
  {
    return false;
  }
  //23-11-23
  if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (ema50 > ema200 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 < ema50)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && PreviousCandleLow_1 < iBandLower_1)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    return false;
  }

  if (iBandH1Lower_0 > currentPrice || iBandH1Lower_0 > PreviousCandleLow_1)
  {
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }


  //24-11-23
  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50 && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 10
  && MathAbs(ema50 - iBandLower_1) / 0.1 < 10
  )
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 24
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 15
  && MathAbs(ema50 - iBandLower_1) / 0.1 < 10
  && MathAbs(senkouA - senkouB) / 0.1 < 7
  )
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && MathAbs(PreviousCandleLow_1 - iBandH1Lower_0) / 0.1 < 15)
  {
    return false;
  }

  //2021
  if ((rsiValue < MaxrsiSEll || rsiValue1 < MaxrsiSEll || rsiValue2 < MaxrsiSEll || rsiValue3 < MaxrsiSEll)
 && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 15
 )
  {
    return false;
  }

  if (ema50 < currentPrice
&& MathAbs(previousClose - previousOpen) / 0.1 > 12
&& previousClose > previousOpen
&& MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) > 0.7
&& MathAbs(previousClose_2 - previousOpen_2) / MathAbs(PreviousCandleHigh_2 - PreviousCandleLow_2) < 0.2
)
  {
    return false;
  }

  if (IsPriceCrossingOneEMA50)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 2)
  {
    return false;
  }

  if (senkouA > senkouB
  && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 20
  && currentPrice > ema50
  && MathAbs(senkouA - senkouB) > MathAbs(senkouA2 - senkouB2)
  )
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 5)
  {
    return false;
  }

  if (PreviousCandleLow_1 < iBandLower_1)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 < 20 && MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - currentPrice) / 0.1 > 250 && currentPrice > iBandH1Sma_1)
  {
    return false;
  }

  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 15 && HighNow > ema50)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 15)
  {
    return false;
  }

  //2021
  if (MathAbs(iBandUpper_30 - iBandUpper_1) / 0.1 > 40
&& MathAbs(iBandH1Upper_50 - iBandH1Upper_0) / 0.1 > 150
&& iBandH1Upper_50 < iBandH1Upper_0
&& iBandUpper_1 < iBandUpper_30
&& MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 < 50
)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 > 500
  )
  {
    return false;
  }
  //2020
  if (MathAbs(senkouA - senkouB) / 0.1 > 100 && senkouB < senkouA)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 < 20 && MathAbs(iBandLower_1 - PreviousCandleLow_1) / 0.1 < 15 && currentPrice > LowPrice150)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && ema200 < currentPrice)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }

  if (PreviousCandleLow_1 < s2Value)
  {
    return false;
  }

  if (currentPrice > r3Value)
  {
    return false;
  }

  if (iBandH1Lower_0 > iBandLower_0)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 700)
  {
    return false;
  }

  if (currentPrice < LowPrice150 && pipDifferenceKIJUN < 2)
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && MathAbs(ema200 - currentPrice) / 0.1 < 40 && ema50 > ema200)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
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

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 25 && MathAbs(currentPrice - iBandLower_0) / 0.1 < 5)
  {
    return false;
  }

  if (IsAreRecent5CandlesUperThan7)
  {
    return false;
  }

  printf("isPriceCrossing7EMA200 " + IsAreRecent5CandlesUperThan7);
  printf("MathAbs(ema50 - currentPrice) / 0.1 " + MathAbs(ema200 - currentPrice) / 0.1);
  return true;

}

bool IsCandleBuy()
{
  double pipDifferenceEMATENKAN = MathAbs(ema50 - iIchiTenkan_3) / 0.1;
  double pipDifferenceEMA = MathAbs(ema50 - currentPrice) / 0.1;
  double pipDifferenceEMAKIJUN = MathAbs(ema50 - iIchiKinjun_3) / 0.1;

  double pipDifferenceTenkan = MathAbs(iIchiTenkan_0 - iIchiTenkan_5) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;
  double valueBUY = ((previousClose - GetMax(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0)) / 0.1);
  double valuePreviousBUY = ((previousClose - previousOpen) / 0.1);

  if (isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_0 - iIchiTenkan_0) / 0.1 < 1)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30 && PreviousCandleHigh_1 > iBandUpper_1)
  {
    return false;
  }

  if (currentPrice > HighPrice150 && rsiValue1 > (MaxrsiBuy - 5))
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 500 && MathAbs(ema50 - currentPrice) / 0.1 < 50 && ema50 > currentPrice)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 22)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && HighNow > iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - PreviousCandleHigh_1) / 0.1 < 7 && isPriceCrossing7EMA200)
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (ema50 < ema200 && isAreEMA50EMA200Crossing && pipDifferenceKIJUN < 3 && ema50_6 > ema50)
  {
    return false;
  }

  if (isPriceCrossing7EMA50 && PreviousCandleHigh_1 > iBandUpper_1)
  {
    return false;
  }
  //23-11-23
  if (ema50 < ema200 && MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 > ema50)
  {
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    return false;
  }

  if (iBandH1Upper_0 < currentPrice || iBandH1Upper_0 < PreviousCandleHigh_1)
  {
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }
  //24-11-23
  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50 && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 15
  && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 15
  && MathAbs(ema50 - iBandUpper_1) / 0.1 < 15
  )
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && isPriceCrossing7EMA50)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 24
  && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 15
  && MathAbs(ema50 - iBandUpper_1) / 0.1 < 15
  && MathAbs(senkouA - senkouB) / 0.1 < 7
  )
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && MathAbs(PreviousCandleHigh_1 - iBandH1Upper_0) / 0.1 < 15)
  {
    return false;
  }

  if ((rsiValue > MaxrsiBuy || rsiValue1 > MaxrsiBuy || rsiValue2 > MaxrsiBuy || rsiValue3 > MaxrsiBuy)
  && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 15
  )
  {
    return false;
  }

  if (ema50 > currentPrice
  && MathAbs(previousClose - previousOpen) / 0.1 > 12
  && previousClose < previousOpen
  && MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) > 0.7
  && MathAbs(previousClose_2 - previousOpen_2) / MathAbs(PreviousCandleHigh_2 - PreviousCandleLow_2) < 0.2
  )
  {
    return false;
  }

  if (IsPriceCrossingOneEMA50)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 2)
  {
    return false;
  }

  if (senkouA < senkouB
  && MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 20
  && currentPrice < ema50
  && MathAbs(senkouA - senkouB) > MathAbs(senkouA2 - senkouB2)
  )
  {
    return false;
  }

  if (MathAbs(senkouA2 - senkouB2) / 0.1 < 2)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandUpper_1)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 < 20 && MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(ema200 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 15 && LowNow < ema50)
  {
    return false;
  }
  //2020
  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - PreviousCandleLow_1) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(iBandUpper_30 - iBandUpper_1) / 0.1 > 40
  && MathAbs(iBandH1Upper_50 - iBandH1Upper_0) / 0.1 > 150
  && iBandH1Upper_50 > iBandH1Upper_0
  && iBandUpper_1 > iBandUpper_30
  && MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 < 50
  )
  {
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - iBandUpper_1) / 0.1 > 500
  )
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 > 100 && senkouB > senkouA)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 < 20 && MathAbs(iBandLower_1 - PreviousCandleHigh_1) / 0.1 < 15 && HighPrice150 > currentPrice)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 35 && ema200 > currentPrice)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 < 40 && MathAbs(senkouA - senkouB) / 0.1 < 15)
  {
    return false;
  }


  if (IsAreRecent5CandlesLower && HighNow > HighPrice150)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 40 && MathAbs(senkouA - senkouB) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }


  if (PreviousCandleHigh_1 > r2Value)
  {
    return false;
  }


  if (s3Value > currentPrice)
  {
    return false;
  }


  if (iBandH1Upper_0 < iBandUpper_0)
  {
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 600)
  {
    return false;
  }
  if (MathAbs(HighNow - LowNow) / 0.1 > 50)
  {
    return false;
  }

  if (currentPrice > HighPrice150 && pipDifferenceKIJUN < 2)
  {
    return false;
  }

  if (isPriceCrossing7EMA200 && MathAbs(ema200 - currentPrice) / 0.1 < 40 && ema50 < ema200)
  {
    return false;
  }
  if (IsPriceCrossing3EMA50)
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

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 25 && MathAbs(currentPrice - iBandUpper_0) / 0.1 < 5)
  {
    return false;
  }

  printf("MathAbs(HighPrice150 - currentPrice) / 0.1   " + MathAbs(HighPrice150 - currentPrice) / 0.1);
  return true;

}

