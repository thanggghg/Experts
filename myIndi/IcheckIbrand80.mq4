void OnTick(void)
{
  r4Value = iCustom(Symbol(), 0, "AllPivotPoints", 8, 0); ;
  r2Value = iCustom(Symbol(), 0, "AllPivotPoints", 6, 0);


  checkBuySell();
  checkcloseBuyOrDCABuy();
  checkcloseBuyOrDCASell();

  checkMaxAM();
  // cutoffSL();
  cutoffSLMax();

}

void checkBuySell()
{

  double iBandH1Lower_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
  double iBandH1Upper_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
  double iBandH1SMA_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  double PreviousCandleLow_1 = iLow(NULL, 0, 1);
  double PreviousCandleHigh_1 = iHigh(NULL, 0, 1);
  double previousClose = iClose(Symbol(), Period(), 1);
  double previousOpen = iOpen(Symbol(), Period(), 1);
  double ema200_1 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 1);
  double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
  datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);
  double LowPrice150 = GetLow();
  double HighPrice150 = GetHighestHigh();
  bool IsPriceCrossing1EMA50 = PriceCrossing1EMA50();

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (candleHour > 20 || candleHour <= 2)
  {
    return false;
  }

  if (MathAbs(r4Value - r2Value) / 0.1 < 80)
  {
    return false;
  }


  if (candleHour == 14 || candleHour == 13 || candleHour == 12 || candleHour == 7 || candleHour == 6)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200_1) / 0.1 > 50)
  {

    if (previousClosePrice != previousClose)
    {
      if (CountOrdersWithMagicSubtrend(9999) < 1)
      {
        if (PreviousCandleHigh_1 < iBandH1Upper_1
        && PreviousCandleHigh_1 > iBandH1SMA_1
        && previousOpen < previousClose
        && MathAbs(currentPrice - HighPrice150) / 0.1 > 30
        )
        {
          sendOrderSendBuy("IsCandleBuyVolue", lotSize, 9999);
        }
      }

      if (CountOrdersWithMagicSubtrend(8888) < 1)
      {
        if (iBandH1Lower_1 < PreviousCandleLow_1
        && PreviousCandleHigh_1 < iBandH1SMA_1
        && previousOpen > previousClose
        && MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 > 30
        )
        {
          sendOrderSendSell("IsCandleSellVolue", lotSize, 8888);
        }
      }
    }
  }
}

void cutoffSLMax()
{
  double totalProfit9 = CalculateTotalProfitByMagic(9999);
  double totalProfit8 = CalculateTotalProfitByMagic(8888);
  if (totalProfit9 < maxAmIfcutOff)
  {

    CloseProfitableByMagic(9999);
    if (CountOrdersWithMagicSubtrend(9999) > 1)
    {
      CloseProfitableByMagic(9999);
    }
  }

  if (totalProfit8 < maxAmIfcutOff)
  {
    CloseProfitableByMagic(8888);
    if (CountOrdersWithMagicSubtrend(8888) > 1)
    {
      CloseProfitableByMagic(8888);
    }

  }

}

void cutoffSL()
{
  double PreviousCandleHigh_1 = iHigh(NULL, 0, 1);
  double iBandH1SMA_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  double ema200_1 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 1);
  if (PreviousCandleHigh_1 < iBandH1SMA_1)
  {
    if (PreviousCandleHigh_1 > ema200_1)
    {
      CloseProfitableByMagic(9999);
    }
  }
  if (PreviousCandleHigh_1 > iBandH1SMA_1)
  {
    if (PreviousCandleHigh_1 > ema200_1)
    {
      CloseProfitableByMagic(8888);
    }

  }

}

bool checkMaxAM()
{
  double totalProfit9 = CalculateTotalProfitByMagic(9999);
  double totalProfit8 = CalculateTotalProfitByMagic(8888);

  if (totalProfit9 < maxAmIf)
  {
    if (totalProfit9 < maxAmBuy)
    {
      maxAmBuy = totalProfit9;
    }

  }

  if (totalProfit8 < maxAmIf)
  {
    if (totalProfit8 < maxAmSell)
    {
      maxAmSell = totalProfit8;
    }

  }
  if (totalProfit9 > ProfitCutOffPoint)
  {
    EntryPriceBuy = true;
  }
  if (totalProfit8 > ProfitCutOffPoint)
  {
    EntryPriceSell = true;
  }
  return false;
}

bool checkTalDCA()
{
  bool twoDCA = false;
  bool countDCA = false;
  if (CountOrdersWithMagicSubtrend(8888) > 1)
  {
    twoDCA = true;
  }
  if (CountOrdersWithMagicSubtrend(9999) > 1)
  {
    twoDCA = true;
  }

  double totalProfit9 = CalculateTotalProfitByMagic(9999);
  double totalProfit8 = CalculateTotalProfitByMagic(8888);

  if ((totalProfit9 + totalProfit8) > 0 && twoDCA)
  {
    countDCA = true;
  }
  return countDCA;
}

bool checkTalProfit()
{
  bool twoCalculate = false;


  double totalProfit9 = CalculateTotalProfitByMagic(9999);
  double totalProfit8 = CalculateTotalProfitByMagic(8888);

  if (totalProfit9 > maxDuongIf)
  {
    twoCalculate = true;
  }

  if (totalProfit8 > maxDuongIf)
  {
    twoCalculate = true;

  }
  return twoCalculate;
}

double checkcloseBuyOrDCABuy()
{
  double totalProfit = 0.0;

  totalProfit = CalculateTotalProfitByMagic(9999);
  if (totalProfit > maxDuongIf)
  {
    CloseProfitableByMagic(9999);
  }
  else if (totalProfit < maxAmIf && totalProfit > maxAmSL)
  {
    ShouldDCA(9999);
  }
  else if (totalProfit < maxAmSL)
  {
    CloseProfitableByMagic(9999);
  }
  else if (totalProfit < totalProfitCutOffPoint && totalProfit > 0 && EntryPriceBuy == true)
  {
    CloseProfitableByMagic(9999);
  }

}


double checkcloseBuyOrDCASell()
{
  double totalProfit = 0.0;

  totalProfit = CalculateTotalProfitByMagic(8888);
  if (totalProfit > maxDuongIf)
  {
    CloseProfitableByMagic(8888);
  }
  else if (totalProfit < maxAmIf && totalProfit > maxAmSL)
  {
    ShouldDCA(8888);
  }
  else if (totalProfit < maxAmSL)
  {
    CloseProfitableByMagic(8888);
  }
  else if (totalProfit < totalProfitCutOffPoint && totalProfit > 0 && EntryPriceSell == true)
  {
    CloseProfitableByMagic(8888);
  }

}

void ShouldDCA(int magicNumber)
{
  double negativePips = CalculateNegativePips(magicNumber);

  // Ví dụ: OrderSend(Symbol(), OP_BUY, lotSize, Bid, 2, 0, 0, "", 0, clrNONE);
  if (negativePips >= (PipNhoiLen + CountOrdersWithMagicSubtrend(magicNumber)*7))
  {
    double additionalOrdersCount = double(negativePips / PipNhoiLen);
    double lotSizeOrder = lotSize;
    if (additionalOrdersCount > 1)
    {
      for (int i = 0; i < (CountOrdersWithMagicSubtrend(magicNumber)); i++)
      {
        lotSizeOrder = lotSizeOrder + lotSizeNhoiLen;
      }
      OpenAdditionalOrder(lotSizeOrder, magicNumber);
    }
  }
}

void OpenAdditionalOrder(double lotSizeOrder, int magicNumber)
{
  // Thực hiện mở lệnh ở đây, dựa vào giá trị của lotSize
  double previousClose = iClose(Symbol(), Period(), 1);
  if (previousClosePrice != previousClose)
  {
    previousClosePrice = iClose(Symbol(), Period(), 1);
    if (magicNumber == 9999)
    {
      sendOrderSendBuy("OpenAdditionalOrder", lotSizeOrder, 9999);
    }
    else
    {
      sendOrderSendSell("OpenAdditionalOrder", lotSizeOrder, 8888);
    }
  }
}

double CalculateNegativePips(int magicNumber)
{
  double pipChange = 0.0;

  double totalNegativePips = 0.0;
  int LatestOrderWithMagic = GetLatestOrderWithMagic(magicNumber);
  double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
  if (OrderSelect(LatestOrderWithMagic, SELECT_BY_POS, MODE_TRADES))
  {
    double openPrice = OrderOpenPrice();
    if (OrderType() == OP_BUY)
    {
      totalNegativePips = (currentPrice - openPrice) / 0.1;
    }
    else if (OrderType() == OP_SELL)
    {
      totalNegativePips = (openPrice - currentPrice) / 0.1;
    }
  }

  if (totalNegativePips < 0)
  {
    pipChange += totalNegativePips;
  }

  return MathAbs(pipChange);
}

int GetLatestOrderWithMagic(int magicNumber)
{
  int totalOrders = OrdersTotal();
  int latestOrderIndex = -1;
  datetime latestOrderTime = 0;

  for (int i = totalOrders - 1; i >= 0; i--)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderMagicNumber() == magicNumber)
      {

        if (latestOrderIndex == -1 || OrderOpenTime() > latestOrderTime)
        {
          latestOrderIndex = i;
          latestOrderTime = OrderOpenTime();
        }
      }
    }
  }

  return latestOrderIndex;
}




double GetHighestHigh()
{
  double highestHigh = 0;

  for (int i = 15; i < 350; i++)
  {
    double high = iOpen(NULL, PERIOD_M15, i);
    if (high > highestHigh)
    {
      highestHigh = high;
    }
  }
  return highestHigh;
}

double GetLow()
{
  double Lows = 9999999;

  for (int i = 15; i < 150; i++)
  {
    double low = iClose(NULL, PERIOD_M15, i);
    if (low < Lows)
    {
      Lows = low;
    }
  }
  return Lows;
}

void CloseProfitableAll()
{

  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderType() == OP_BUY)
      {
        OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
      }
      else
      {
        OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
      }
    }
  }
}


void CloseProfitableByMagic(int magicNumber)
{

  int totalOrders = OrdersTotal();
  previousClosePrice = iClose(Symbol(), Period(), 1);

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {

      if (OrderMagicNumber() == magicNumber)
      {
        if (OrderType() == OP_BUY)
        {
          EntryPriceBuy = false;
          OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
        }
        else
        {
          EntryPriceSell = false;
          OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
        }
      }

    }
  }
  if (CountOrdersWithMagicSubtrend(magicNumber) > 0)
  {
    CloseProfitableByMagic(magicNumber);
  }
}


int CountOrdersWithMagicSubtrend(int magicNumber)
{
  int totalOrders = OrdersTotal();
  int count = 0;

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderMagicNumber() == magicNumber)
      {
        count++;
      }
    }
  }

  return count;
}





void sendOrderSendBuy(string mess, double lotSizeOrder, int magicNumber)
{
  RefreshRates();


  if (!OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", magicNumber, clrNONE))
  {
    RefreshRates();
    OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", magicNumber, clrNONE);
  }


}

void sendOrderSendSell(string mess, double lotSizeOrder, int magicNumber)
{
  RefreshRates();


  if (!OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", magicNumber, clrNONE))
  {
    RefreshRates();
    OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", magicNumber, clrNONE);
  }

}

double CalculateTotalProfitByMagic(int magicNumber)
{
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderMagicNumber() == magicNumber)
      {
        totalProfit += OrderProfit();
      }
    }
  }

  return totalProfit;
}



double CalculateTotalAllProfit()
{
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      totalProfit += OrderProfit();
    }
  }

  return totalProfit;
}


