input double lotSize = 0.1;
input double tiencLhotLoi = 0.2;// tiền chốt lời
input double tienDownTrend = 0.4; // âm quá tiền thì đánh ngược nếu đủ dk
input double maxDuongIf = 200; // âm quá tiền thì đánh ngược nếu đủ dk
input double maxAmIf = -300; // âm quá tiền thì đánh ngược nếu đủ dk


double maxAmBuy = 0;
double maxAmSell = 0;
double maxDuong = 0;
double maxAm = 0;

void OnTick(void)
{

  checkBuySell();
  // if (checkTalProfit())
  // {
  checkcloseBuyOrDCABuy();
  checkcloseBuyOrDCASell();
  //}


  checkMaxAM();

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
  printf("totalProfit9999 " + totalProfit);
  if (totalProfit > maxDuongIf)
  {
    if (totalProfit > maxDuong)
    {
      maxDuong = totalProfit;
    }
    if ((maxDuong - totalProfit) > maxDuong * tiencLhotLoi)
    {

      CloseProfitableByMagic(9999);
      maxDuong = 0;
    }
  }
  else if (maxAmBuy < maxAmIf)
  {
    if (totalProfit < maxAmBuy)
    {
      maxAmBuy = totalProfit;
    }

    if (MathAbs(totalProfit - maxAmBuy) > MathAbs(maxAmBuy) * tienDownTrend)
    {

      OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
      maxAmBuy = 0;
    }
  }
  printf("MathAbs(totalProfit - maxAmBuy) " + MathAbs(totalProfit - maxAmBuy));
  printf("MathAbs(maxAmBuy) * 0.4 " + MathAbs(maxAmBuy) * 0.4);
  printf("MathAbs(maxAmBuy)  " + maxAmBuy);
}

double checkcloseBuyOrDCASell()
{
  double totalProfit = 0.0;

  totalProfit = CalculateTotalProfitByMagic(8888);
  printf("totalProfit8888 " + totalProfit);
  if (totalProfit > maxDuongIf)
  {
    if (totalProfit > maxDuong)
    {
      maxDuong = totalProfit;
    }
    if ((maxDuong - totalProfit) > maxDuong * tiencLhotLoi)
    {

      CloseProfitableByMagic(8888);

      maxDuong = 0;
    }
  }
  else if (maxAmSell < maxAmIf)
  {
    if (totalProfit < maxAmSell)
    {
      maxAmSell = totalProfit;
    }
    if ((totalProfit - maxAmSell) > MathAbs(maxAmSell) * tienDownTrend)
    {

      OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
      maxAmSell = 0;
    }
  }
}

void checkBuySell()
{

  if (CountOrdersWithMagicSubtrend(9999) < 1)
  {
    sendOrderSendBuy("IsCandleBuyVolue", lotSize, 9999);
  }

  if (CountOrdersWithMagicSubtrend(8888) < 1)
  {
    sendOrderSendSell("IsCandleSellVolue", lotSize, 8888);
  }
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

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {

      if (OrderMagicNumber() == magicNumber)
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

