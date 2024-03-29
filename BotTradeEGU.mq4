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


}


void checkBuySell()
{

  if (CountOrdersWithMagic(9999) < 1)
  {
    sendOrderSendBuy("GBPUSD", lotSize, 9999);
  }

  if (CountOrdersWithMagic(8888) < 1)
  {
    sendOrderSendSell("EURUSD", lotSize, 8888);
  }
}



int CountOrdersWithMagic(int magicNumber)
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


void sendOrderSendBuy(string Symbol, double lotSizeOrder, int magicNumber)
{
  RefreshRates();


  if (!OrderSend(Symbol, OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", magicNumber, clrNONE))
  {
    RefreshRates();
    OrderSend(Symbol, OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", magicNumber, clrNONE);
  }


}

void sendOrderSendSell(string Symbol, double lotSizeOrder, int magicNumber)
{
  RefreshRates();


  if (!OrderSend(Symbol, OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", magicNumber, clrNONE))
  {
    RefreshRates();
    OrderSend(Symbol, OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", magicNumber, clrNONE);
  }

}
