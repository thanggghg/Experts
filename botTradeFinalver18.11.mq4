input double lotSize = 0.1;
input double tiencLhotLoi = 20;// tiền chốt lời
input double tienDownTrend = 40; // âm quá tiền thì đánh ngược nếu đủ dk


double maxAm = 0;
double maxDuong = 0;

void OnTick(void)
{

  checkBuySell();

CalculateTotalProfit();
}


double CalculateTotalProfit()
{

  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      double totalProfit = 0.0;

      totalProfit = OrderProfit();

      if (totalProfit < -10 )
      {

        if (totalProfit < maxAm)
        {
          maxAm = totalProfit;
        }
        if ((totalProfit - maxAm) > tienDownTrend)
        {
          printf("totalProfit" +totalProfit);
          printf("totalProfit" +maxAm);
          if (OrderType() == OP_BUY)
          {
            OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
          }
          else
          {
            OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
          }
          maxAm = 0 ;
        }

      }else if (totalProfit > 10 ){
         if (totalProfit > maxDuong)
        {
          maxDuong = totalProfit;
        }
        if ((maxDuong - totalProfit ) > tiencLhotLoi)
        {
          printf("totalProfit" +totalProfit);
          if (OrderType() == OP_BUY)
          {
            OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
          }
          else
          {
            OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
          }
          maxDuong = 0 ;
          maxAm = 0 ;
        }
      }

    }
  }

  return totalProfit;
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


void CloseProfitableOrdersSubtrendSell()
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



void CloseProfitableOrdersSubtrendBuy()
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




double logaaa(string logMessage)
{
  // int fileHandle;
  // string fileName = "mylog.csv";
  // fileHandle = FileOpen(fileName, FILE_CSV | FILE_READ | FILE_WRITE, ';');

  // if (fileHandle != INVALID_HANDLE)
  // {
  //   FileSeek(fileHandle, 0, SEEK_END);
  //   FileWrite(fileHandle, logMessage);
  //   FileClose(fileHandle);
  // }
}

double logabb(string logMessage)
{
  // int fileHandle;
  // string fileName = "mylog1.csv";
  // fileHandle = FileOpen(fileName, FILE_CSV | FILE_READ | FILE_WRITE, ';');

  // if (fileHandle != INVALID_HANDLE)
  // {
  //   FileSeek(fileHandle, 0, SEEK_END);
  //   FileWrite(fileHandle, logMessage);
  //   FileClose(fileHandle);
  // }
}

