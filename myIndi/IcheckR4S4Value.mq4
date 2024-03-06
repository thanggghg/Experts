
void checkR4S4Value()
{

  if (currentPrice < s4Value)
  {
    if (IsCandleBuycheckR4S4())
    {
      sendOrderSendBuy("IsCandleBuycheckR4S4", lotSize, 9999);
    }
  }
  else if (currentPrice > r4Value)
  {
    if (IsCandleSellR4S4())
    {
      sendOrderSendSell("IsCandleSellR4S4", lotSize, 9999);
    }
  }

}

bool IsCandleSellR4S4()
{

  if (candleHour > 19)
  {
    return false;
  }
  if (MathAbs(senkouA - senkouB) / 0.1 < 11)
  {
    return false;
  }

  if (pipDifferenceTenkan > 40)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(currentPrice - r4Value) / 0.1 > 100 && r4Value < currentPrice)
  {
    return false;
  }

  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (MathAbs(iIchiTenkan_1 - iIchiKinjun_1) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(r4Value - r2Value) / 0.1 < 80)
  {
    return false;
  }

  return true;
}

bool IsCandleBuycheckR4S4()
{
  if (candleHour > 19)
  {
    return false;
  }

  if (MathAbs(senkouA - senkouB) / 0.1 < 11)
  {
    return false;
  }
  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (pipDifferenceTenkan > 40)
  {
    return false;
  }

  if (MathAbs(ema200 - ema50) / 0.1 < 25)
  {
    return false;
  }

  if (MathAbs(currentPrice - s4Value) / 0.1 > 100 && s4Value > currentPrice)
  {
    return false;
  }

  if (MathAbs(iIchiTenkan_1 - iIchiKinjun_1) / 0.1 < 20)
  {
    return false;
  }

  if (MathAbs(s4Value - s2Value) / 0.1 < 80)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema50) / 0.1 < 25 || MathAbs(PreviousCandleHigh_1 - ema50) / 0.1 < 25)
  {
    return false;
  }


  printf("pipDifferenceKIJUN " + MathAbs(s3Value - s4Value) / 0.1);
  return true;

}

