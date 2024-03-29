void OpenAdditionalOrder(double lotSizeOrder)
{
  // Thực hiện mở lệnh ở đây, dựa vào giá trị của lotSize
  if (previousClosePrice != previousClose)
  {
    previousClosePrice = previousClose;
    if (CheckOrderType() == 1)
    {
      sendOrderSendBuy("OpenAdditionalOrder", lotSizeOrder, 9999);
    }
    else
    {
      sendOrderSendSell("OpenAdditionalOrder", lotSizeOrder, 9999);
    }
  }
}

double DownTrend()
{
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderMagicNumber() == 8888)
      {
        totalProfit += OrderProfit();
      }
    }
  }

  return totalProfit;
}

double CalculateTotalProfit()
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


double GetMin(double value1, double value2, double value3)
{
  double minValue = value1;

  if (value2 < minValue)
  {
    minValue = value2;
  }

  if (value3 < minValue)
  {
    minValue = value3;
  }

  return minValue;
}

double GetMax(double value1, double value2, double value3)
{
  double maxValue = value1;

  if (value2 > maxValue)
  {
    maxValue = value2;
  }

  if (value3 > maxValue)
  {
    maxValue = value3;
  }

  return maxValue;
}

double CalculateNegativePips()
{
  double pipChange = 0.0;

  double totalNegativePips = 0.0;
  int LatestOrderWithMagic = GetLatestOrderWithMagic();

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

int GetLatestOrderWithMagic()
{
  int totalOrders = OrdersTotal();
  int latestOrderIndex = -1;
  datetime latestOrderTime = 0;

  for (int i = totalOrders - 1; i >= 0; i--)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {

      if (latestOrderIndex == -1 || OrderOpenTime() > latestOrderTime)
      {
        latestOrderIndex = i;
        latestOrderTime = OrderOpenTime();
      }
    }
  }

  return latestOrderIndex;
}

void CheckAndCloseExpiredOrders()
{
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      CloseOrderIfExpired(OrderTicket());
    }
  }
}

void CheckAndCloseExpiredLossOrders()
{
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      CloseOrderIfExpired(OrderTicket());
    }
  }
}

void CloseOrderIfExpired(int ticket)
{
  if (ShouldCloseOrder(ticket))
  {
    if (OrderClose(ticket, OrderLots(), OrderClosePrice(), 3, clrNONE))
    {
      Print("Lệnh đã được đóng vì quá thời hạn: Ticket = ", ticket);
    }
    else
    {
      Print("Không thể đóng lệnh: Lỗi = ", GetLastError());
    }
  }
}

bool ShouldCloseOrder(int ticket)
{
  if (OrderSelect(ticket, SELECT_BY_TICKET))
  {
    if (OrderProfit() < 0)
    { // Chỉ đóng lệnh âm
      datetime openTime = OrderOpenTime();
      datetime currentTime = TimeCurrent();

      int secondsPassed = currentTime - openTime;
      int maxOpenTime = 2 * 24 * 60 * 60; // 2 ngày

      return secondsPassed > maxOpenTime;
    }
  }

  return false;
}

// Hàm kiểm tra xem 3 cây nến gần nhất có chạm vào band trên của Bollinger Bands hay không
bool AreLast3CandlesTouchingUpperBandIsBuy()
{

  for (int i = 0; i < 3; i++)
  {

    double upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
    double candleHigh = High[i];

    if (candleHigh > upperBand)
    {
      return true; // Có ít nhất 1 cây nến chạm vào band trên
    }
  }

  return false; // Không có cây nến nào chạm vào band trên
}

// Hàm kiểm tra xem 3 cây nến gần nhất có chạm vào band trên của Bollinger Bands hay không
bool AreLast5CandlesTouchingUpperBandIsBuy()
{

  for (int i = 0; i < 5; i++)
  {

    double upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
    double candleHigh = High[i];

    if (candleHigh > upperBand)
    {
      return true; // Có ít nhất 1 cây nến chạm vào band trên
    }
  }

  return false; // Không có cây nến nào chạm vào band trên
}

bool AreLast4CandlesTouchingUpperBandIsSell()
{
  double lowerBand;

  for (int i = 0; i < 4; i++)
  {

    lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
    double candleLow = Low[i];
    if (candleLow < lowerBand)
    {
      return true; // Có ít nhất 1 cây nến chạm vào band dưới
    }
  }

  return false; // Không có cây nến nào chạm vào band trên
}

bool AreLast3CandlesTouchingUpperBandIsSell()
{
  double lowerBand;

  for (int i = 0; i < 3; i++)
  {

    lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
    double candleLow = Low[i];
    if (candleLow < lowerBand)
    {
      return true; // Có ít nhất 1 cây nến chạm vào band dưới
    }
  }

  return false; // Không có cây nến nào chạm vào band trên
}

bool IsSenkouCloudWithin20Pips()
{
  bool Pips = true;
  for (int i = 0; i < 4; i++)
  {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, i);

    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
    if (pipDistance < IsSenkouCloudWithin20Pips)
    {
      Pips = false;
    }
  }
  return Pips;
}

bool AreEma50KijunCrossing()
{
  double ema50[12];
  double kijunSen[12];

  for (int z = 0; z < 12; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z); ;
    kijunSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
  }

  for (int i = 0; i < 12; i++)
  {
    if ((ema50[i - 1] > kijunSen[i - 1] && ema50[i] <= kijunSen[i]) ||
        (ema50[i - 1] < kijunSen[i - 1] && ema50[i] >= kijunSen[i]))
    {
      return true; // Đường Tenkan-sen và Kijun-sen cắt nhau
    }
  }

  return false; // Không có cắt nhau
}

bool AreTenkanKijunCrossing()
{
  double tenkanSen[9];
  double kijunSen[9];

  for (int z = 0; z < 9; z++)
  {
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
    kijunSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
  }

  for (int i = 0; i < 8; i++)
  {
    if ((tenkanSen[i - 1] > kijunSen[i - 1] && tenkanSen[i] <= kijunSen[i]) ||
        (tenkanSen[i - 1] < kijunSen[i - 1] && tenkanSen[i] >= kijunSen[i]))
    {
      return true; // Đường Tenkan-sen và Kijun-sen cắt nhau
    }
  }

  return false; // Không có cắt nhau
}

bool PriceCrossingEMA200()
{
  for (int i = 0; i < 40; i++)
  {
    double closePrice = Close[i];
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema200 && PreviousCandleLow_1 <= ema200))
    {
      return true; // Giá cắt qua đường EMA 200 trong 40 cây nến gần nhất
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing7EMA200()
{

  for (int i = 0; i < 7; i++)
  {
    double closePrice = Close[i];
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema200 && PreviousCandleLow_1 <= ema200))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing14EMA200()
{

  for (int i = 0; i < 15; i++)
  {
    double closePrice = Close[i];
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema200 && PreviousCandleLow_1 <= ema200))
    {
      return true; // Giá cắt qua đường EMA 200 trong 40 cây nến gần nhất
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing7EMA50()
{

  int a = 0;
  for (int i = 0; i < 9; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossingEMA50()
{

  for (int i = 0; i < 10; i++)
  {
    double closePrice = Close[i];
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50 && PreviousCandleLow_1 <= ema50))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing8EMA200()
{

  for (int i = 1; i < 8; i++)
  {
    double closePrice = Close[i];
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema200 && PreviousCandleLow_1 <= ema200))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing1EMA200()
{

  for (int i = 1; i < 3; i++)
  {
    double closePrice = Close[i];
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema200 && PreviousCandleLow_1 <= ema200))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing3EMA50()
{

  for (int i = 0; i < 4; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossing1EMA50()
{

  for (int i = 1; i < 3; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossingOneEMA50()
{

  for (int i = 1; i < 2; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossingEMA5014()
{

  for (int i = 0; i < 14; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossingEMA20014()
{

  for (int i = 0; i < 14; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool PriceCrossingEMA5022()
{

  for (int i = 0; i < 22; i++)
  {
    double closePrice = Close[i];
    double ema50f = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50f && PreviousCandleLow_1 <= ema50f))
    {
      return true;
    }
  }

  return false; // Không có cắt qua
}

bool AreEMA50TenkanSenrossing()
{
  double ema50f[7];
  double tenkanSen[7];

  for (int z = 0; z < 7; z++)
  {
    ema50f[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 7; i++)
  {
    if ((ema50f[i - 1] > tenkanSen[i - 1] && ema50f[i] <= tenkanSen[i]) ||
        (ema50f[i - 1] < tenkanSen[i - 1] && ema50f[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50TenkanSenrossing14()
{
  double ema50f[14];
  double tenkanSen[14];

  for (int z = 0; z < 14; z++)
  {
    ema50f[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 14; i++)
  {
    if ((ema50f[i - 1] > tenkanSen[i - 1] && ema50f[i] <= tenkanSen[i]) ||
        (ema50f[i - 1] < tenkanSen[i - 1] && ema50f[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}


bool AreEMA50TenkanSenrossing22()
{
  double ema50f[22];
  double tenkanSen[22];

  for (int z = 0; z < 22; z++)
  {
    ema50f[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 22; i++)
  {
    if ((ema50f[i - 1] > tenkanSen[i - 1] && ema50f[i] <= tenkanSen[i]) ||
        (ema50f[i - 1] < tenkanSen[i - 1] && ema50f[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50TKIJUSenrossing22()
{
  double ema50f[22];
  double tenkanSen[22];

  for (int z = 0; z < 22; z++)
  {
    ema50f[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
  }

  for (int i = 1; i < 22; i++)
  {
    if ((ema50f[i - 1] > tenkanSen[i - 1] && ema50f[i] <= tenkanSen[i]) ||
        (ema50f[i - 1] < tenkanSen[i - 1] && ema50f[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50EMA200Crossing()
{
  double ema50f[45];
  double ema200f[45];

  for (int z = 0; z < 45; z++)
  {
    ema50f[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    ema200f[z] = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, z);
  }

  for (int i = 1; i < 45; i++)
  {
    if ((ema50f[i - 1] > ema200f[i - 1] && ema50f[i] <= ema200f[i]) ||
        (ema50f[i - 1] < ema200f[i - 1] && ema50f[i] >= ema200f[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool CheckBollingerUPPERCross()
{
  double upper20[20];
  double upper80[20];

  for (int z = 0; z < 20; z++)
  {
    upper20[z] = iBands(Symbol(), Period(), 20, 2.0, 0, PRICE_CLOSE, MODE_UPPER, z);
    upper80[z] = iBands(Symbol(), Period(), 80, 2.0, 0, PRICE_CLOSE, MODE_UPPER, z);
  }

  for (int i = 1; i < 20; i++)
  {
    if ((upper20[i - 1] > upper80[i - 1] && upper20[i] <= upper80[i]) ||
        (upper20[i - 1] < upper80[i - 1] && upper20[i] >= upper80[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool CheckBollingerLOWERCross()
{
  double upper20[20];
  double upper80[20];

  for (int z = 0; z < 20; z++)
  {
    upper20[z] = iBands(Symbol(), Period(), 20, 2.0, 0, PRICE_CLOSE, MODE_LOWER, z);
    upper80[z] = iBands(Symbol(), Period(), 80, 2.0, 0, PRICE_CLOSE, MODE_LOWER, z);
  }

  for (int i = 1; i < 20; i++)
  {
    if ((upper20[i - 1] > upper80[i - 1] && upper20[i] <= upper80[i]) ||
        (upper20[i - 1] < upper80[i - 1] && upper20[i] >= upper80[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool CheckEMACross()
{
  double pipValue = MarketInfo(Symbol(), MODE_POINT);
  double allowedDeviation = 5 * 0.1;

  for (int i = 0; i < 3; i++)
  {
    double closePrice = iClose(Symbol(), Period(), i);

    if (MathAbs(closePrice - ema50) <= allowedDeviation)
    {
      return true;  // Có nến chạm EMA50 trong khoảng sai số 5 pip
    }
  }

  return false;  // Không có nến nào chạm EMA50 trong khoảng sai số 5 pip
}

double CalculateMaxDistance()
{
  double maxDistance = 0;

  for (int i = 0; i < 7; i++)
  {
    double tenkanSen = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i);
    double kijunSen = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, i);

    double distance = MathAbs(tenkanSen - kijunSen);
    if (distance > maxDistance)
    {
      maxDistance = distance;
    }
  }

  return maxDistance / 0.1;
}

double GetS3Value()
{
  double s3Value = iCustom(Symbol(), 0, "AllPivotPoints", 3, 0);

  return (s3Value);
}

double GetS2Value()
{
  double s2Value = iCustom(Symbol(), 0, "AllPivotPoints", 2, 0);

  return (s2Value);
}



double GetR2Value()
{
  double r2Value = iCustom(Symbol(), 0, "AllPivotPoints", 6, 0);

  return (r2Value);
}

double GetR3Value()
{
  double r3Value = iCustom(Symbol(), 0, "AllPivotPoints", 7, 0);

  return (r3Value);
}

bool checkTrendUptrendUPdate(color checkcolor)
{

  if (SuperTrendValue20 == 1
      && SuperTrendValue21 == 1
      && checkcolor == clrGreen)
  {
    return true;
  }
  else if (SuperTrendValue21 == -1
              && SuperTrendValue20 == -1
              && checkcolor == clrRed)
  {
    return true;
  }

  return false;
}

bool checkTrendUptrend(color checkcolor)
{
  if (SuperTrendValue22 == 1
      && SuperTrendValue20 == 1
      && SuperTrendValue21 == 1
      && checkcolor == clrGreen)
  {
    return true;
  }
  else if (SuperTrendValue21 == -1
              && SuperTrendValue22 == -1
              && SuperTrendValue20 == -1
              && checkcolor == clrRed)
  {
    return true;
  }

  return false;
}

bool checkTrend(color checkcolor)
{
  if (SuperTrendValue23 == -1
      && SuperTrendValue22 == 1
      && SuperTrendValue21 == 1
      && checkcolor == clrGreen)
  {
    return true;
  }
  else if (SuperTrendValue23 == 1
              && SuperTrendValue21 == -1
              && SuperTrendValue22 == -1
              && checkcolor == clrRed)
  {
    return true;
  }

  return false;
}

void nutbam_thanhngang(string name, double price, color mau_thanh_ngang, int fontsize)
{
  if (!price)
    price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

  ResetLastError();
  int chart_ID = 0;

  if (!ObjectCreate(chart_ID, name, OBJ_HLINE, 0, 0, price))
  {
    Print(__FUNCTION__,
       ": failed to create a horizontal line! Error code = ", GetLastError());
    return;
  }
  ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, mau_thanh_ngang);
  ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, STYLE_SOLID);
  ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, fontsize);
  ObjectSetInteger(chart_ID, name, OBJPROP_BACK, false);

  ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, true);
  ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, true);
  ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, true);
  ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, 0);
  return;
}

int dem_so_lenh_hien_co(string kieu)
{
  int dem = 0;
  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderType() < 2 && OrderSymbol() == Symbol() && kieu == "tong all")
      { dem++; }
      if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && kieu == "tong buy")
      { dem++; }
      if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && kieu == "tong sell")
      { dem++; }
    }
  }
  return (dem);
}
//########################################
double binhquangiabuy(double sotienn)
{
  double swap = 0;
  double lots = 0;
  double entry = 0;
  double tongswap = 0;
  double tongcomm = 0;
  double comm = 0;
  double tonglots = 0;
  double tonglenh = 0;
  double tp = 0;
  double ticksize = MarketInfo(Symbol(), MODE_TICKSIZE);
  double tickvalue = MarketInfo(Symbol(), MODE_TICKVALUE);

  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderSymbol() == Symbol() && OrderType() == OP_BUY)
      {
        lots = OrderLots();
        entry = OrderOpenPrice();
        swap = OrderSwap();
        comm = OrderCommission();
        tonglots = tonglots + lots;
        tonglenh = tonglenh + entry * lots;
        tongswap = tongswap + swap;
        tongcomm = tongcomm + comm;
        {
          tp = (tonglenh + ((sotienn + tongswap) * (ticksize / tickvalue))) / tonglots;
        }
      }
    }
  }
  return (tp);
}
//###########################################333
double binhquangiasell(double sotienn)
{
  double swap = 0;
  double lots = 0;
  double entry = 0;
  double tongswap = 0;
  double tongcomm = 0;
  double comm = 0;
  double tonglots = 0;
  double tonglenh = 0;
  double tp = 0;
  double ticksize = MarketInfo(Symbol(), MODE_TICKSIZE);
  double tickvalue = MarketInfo(Symbol(), MODE_TICKVALUE);

  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderSymbol() == Symbol() && OrderType() == OP_SELL)
      {
        lots = OrderLots();
        entry = OrderOpenPrice();
        swap = OrderSwap();
        comm = OrderCommission();
        tonglots = tonglots + lots;
        tonglenh = tonglenh + entry * lots;
        tongswap = tongswap + swap;
        tongcomm = tongcomm + comm;
        {
          tp = (tonglenh - ((sotienn + tongswap) * (ticksize / tickvalue))) / tonglots;
        }
      }
    }
  }
  return (tp);
}

double GetHighestHigh()
{
  double highestHigh = 0;

  for (int i = 15; i < 150; i++)
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

bool AreRecent5CandlesLowerThan4thPrevious()
{
  double fourthPreviousHigh = High[5];
  for (int i = 1; i <= 5; i++)
  {
    if (High[i] > fourthPreviousHigh)
    {
      return false;
    }
  }
  return true;
}


bool AreRecent5CandlesUperThan7thPrevious()
{
  double fourthPreviousHigh = Low[7];
  for (int i = 1; i <= 6; i++)
  {
    if (Low[i] < fourthPreviousHigh)
    {
      return false;
    }
  }
  return true;
}

bool AreRecent4CandlesLowerThan4thPrevious()
{
  double fourthPreviousHigh = High[4];
  for (int i = 1; i <= 4; i++)
  {
    if (High[i] > fourthPreviousHigh)
    {
      return false;
    }
  }
  return true;
}


void CloseProfitableOrders()
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
  CloseOrdersWithRequote();
}

void CloseProfitableOrdersDownTrend()
{
  Print("CloseProfitableOrdersDownTrend");
  int totalOrders = OrdersTotal();
  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {

      if (OrderMagicNumber() == 8888)
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

void CloseOrdersWithRequote()
{
  int totalOrders = OrdersTotal();

  for (int i = totalOrders - 1; i >= 0; i--)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      double closePrice = OrderType() == OP_BUY ? MarketInfo(OrderSymbol(), MODE_BID) : MarketInfo(OrderSymbol(), MODE_ASK);
      if (OrderClose(OrderTicket(), OrderLots(), closePrice, 3, clrNONE))
      {

      }
      else
      {
        int lastError = GetLastError();
        if (lastError == ERR_REQUOTE)
        {
          // Thử đóng lại lần nữa với giá mới
          double newClosePrice = OrderType() == OP_BUY ? MarketInfo(OrderSymbol(), MODE_BID) - 5 * Point : MarketInfo(OrderSymbol(), MODE_ASK) + 5 * Point;
          if (OrderClose(OrderTicket(), OrderLots(), newClosePrice, 3, clrNONE))
          {

          }
          else
          {

          }
        }
        else
        {

        }
      }
    }
  }
}

void ShouldDCA()
{
  double negativePips = CalculateNegativePips();

  if (negativePips >= (PipNhoiLen + CountOrdersWithMagic()))
  {
    double additionalOrdersCount = double(negativePips / PipNhoiLen);
    double lotSizeOrder = lotSize;
    if (additionalOrdersCount > 1)
    {
      for (int i = 0; i < (CountOrdersWithMagic()); i++)
      {
        lotSizeOrder = lotSizeOrder + lotSizeNhoiLen;
      }
      OpenAdditionalOrder(lotSizeOrder);
    }
  }
}

int CheckOrderType()
{
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {

      if (OrderType() == OP_BUY)
      {
        return 1;
      }
      else
      {
        return 0;
      }

    }
  }
  return 0;
}

int CountOrdersWithMagic()
{
  int totalOrders = OrdersTotal();
  int count = 0;

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      count++;
    }
  }

  return count;
}