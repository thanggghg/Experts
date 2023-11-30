input double MaxPipPreviou = 25; // cây nến trước nó đủ dk mà quá 19pip thì ko đánh nửa
input double senkouBNsenkouA = 20; // mây senkouB  và senkouA
input double InputcurrentPriceSenkouB =25;// giá hiện tại tới SenkouB
input double InputpipDifferenceEMA = 5;// khoản cách tới ema
input double pipDiffIchi =8;//khoản cách đương ichi 
input int IsSenkouCloudWithin20Pips = 28;//mây rộng bao nhiêu thì đánh

input double lotSize = 0.05;
input double tiencLhotLoi = 10;// tiền chốt lời
input double tienDownTrend = -10; // âm quá tiền thì đánh ngược nếu đủ dk
input double PipNhoiLen = 20;//số pip nhồi lện 
input double lotSizeNhoiLen = 0.03;//số lot nhồi lện 
input int MAxLenNhoi = 9;//số lện nhồi tối đa
input int MaxOrderrsi = 75;//lớn hơn bao nhiêu thì BUY Lện Chính
input int MinOrderrsi = 18;//nhỏ hơn bao nhiêu thì SELL Lện Chính
input int GapMinute = 1;  //cách bao nhiêu cây nến thì đánh
input int MaxrsiBuy = 68;//lớn hơn bao nhiêu thì KO BUY
input int MaxrsiSEll = 32;//nhỏ hơn bao nhiêu thì KO SELL
input double StopLostPrice = -300;//ko xài
input double StopDCAPrice = -400;//tới âm giá này thì ngưng DCA
input int pipDCAIfMax = 40;//âm tới StopDCAPrice thì pip DCA sẽ khác
input int totalProfitCutOffPoint = 8;//âm tới StopDCAPrice thì pip DCA sẽ khác

bool ShouldEnterTrade = False;
bool EntryPrice = false;
bool MainIsBuy = False;
datetime TimeClose = 0;
double previousClosePrice = 0.0;

double rsiValue, currentPrice, bandSMA, bandSMA20, bandSMA80, bandSMAH1, bollingerlow, bollingerlow1, bollingerlowH1, bollingerlowM15, bollingerMiddle, bollingerUper, bollingerUper1, bollingerUperH1, bollingerUpH1, bollingerUpM15, closePrice, currentValue, currentValue0, currentValue1, currentValue3, currentValue4, currentValueNow, distance, ema200, ema200_1, ema50, HighNow, iIchiKinjun_3, iIchiKinjun_4, iIchiKinjun_0, iIchiTenkan_3, iIchiTenkan_0, iIchiTenkan_5, iIchiTenkan_36, iIchiTenkan_1, iPreviousCandleLow_1, latestOrderLoss, lowerBand, PreviousCandleLow_1, newClosePrice, openPrice, pipDifference, pipDifferenceEMA, pipDifferenceEMAKIJUN, pipDifferenceEMATENKAN, pipDifferenceKIJUN, pipDifferenceSP, pipDifferenceSPA, pipDifferenceTenkan, pipDistance, pipValue, pointSize, PreviousCandleHigh_1, PreviousCandleHigh_2, PreviousCandleLow_2, previousClose, previousOpen, r3Value, rsiValue1, rsiValue2, rsiValue3, s3Value, senkouA, senkouA2, senkouB, senkouB2, upperBand;

double iBandLower_0, iIchiKinjun_1, iBandLower_1, iBandSma_0, iBandSma_1, iBandUpper_0, iBandUpper_1, iBandH1Lower_0, iBandH1Sma_1, iBandH1Upper_0;
double previousClose_2, previousOpen_2, valueBuySell, LowNow, ema50_6, LowPrice150, HighPrice150, SuperTrendValue21, SuperTrendValue01, SuperTrendValue11, SuperTrendValue22, SuperTrendValue23, SuperTrendValue08, SuperTrendValue20;
bool isAreTenkanKijunCrossing, IsPriceCrossing3EMA50, IsPriceCrossing8EMA200, IsPriceCrossing1EMA200, IsPriceCrossing1EMA50, isPriceCrossingEMA200, isPriceCrossingEMA20014, isCheckEMACross, isAreEMA50EMA200Crossing, isPriceCrossing7EMA200, isPriceCrossing7EMA50, isPriceCrossing14EMA200, isCheckBollingerLOWERCross, isAreLast3CandlesTouchingUpperBandIsSell, isPriceCrossingEMA50, isAreEMA50TenkanSenrossing14;
bool isPriceCrossingEMA5014, isAreEMA50TenkanSenrossing22, isPriceCrossingEMA5022, isAreEMA50TKIJUSenrossing22, isCheckBollingerUPPERCross;
double lastPIP = 0.0;
double tp_buy = 0;
double tp_sell = 0;
double maxAm = 0;
double IsPriceCrossingOneEMA50;
void OnTick(void)
{
  //vaiable
  currentPrice = MarketInfo(OrderSymbol(), MODE_BID);

  iBandLower_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
  iBandLower_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
  iBandSma_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_SMA, 0);
  iBandSma_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  iBandUpper_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);
  iBandUpper_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);

  iBandH1Lower_0 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
  iBandH1Sma_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  iBandH1Upper_0 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);

  SuperTrendValue21 = iCustom(Symbol(), 0, "SuperTrend", 2, 1);
  SuperTrendValue01 = iCustom(Symbol(), 0, "SuperTrend", 0, 1);
  SuperTrendValue11 = iCustom(Symbol(), 0, "SuperTrend", 1, 1);
  SuperTrendValue22 = iCustom(Symbol(), 0, "SuperTrend", 2, 2);
  SuperTrendValue23 = iCustom(Symbol(), 0, "SuperTrend", 2, 3);
  SuperTrendValue08 = iCustom(Symbol(), 0, "SuperTrend", 0, 8);
  SuperTrendValue20 = iCustom(Symbol(), 0, "SuperTrend", 2, 0);

  ema200_1 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 1);
  ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
  ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
  ema50_6 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 6);

  iIchiKinjun_0 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
  iIchiKinjun_1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 1);
  iIchiKinjun_3 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 3);
  iIchiKinjun_4 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 4);

  iIchiTenkan_0 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
  iIchiTenkan_1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 1);
  iIchiTenkan_3 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 3);
  iIchiTenkan_5 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 5);

  PreviousCandleLow_1 = iLow(NULL, 0, 1);
  PreviousCandleLow_2 = iLow(NULL, 0, 2);

  HighNow = iHigh(NULL, 0, 0);
  LowNow = iLow(NULL, 0, 0);
  PreviousCandleHigh_1 = iHigh(NULL, 0, 1);
  PreviousCandleHigh_2 = iHigh(NULL, 0, 2);

  previousClose = iClose(Symbol(), Period(), 1);
  previousClose_2 = iClose(Symbol(), Period(), 2);
  previousOpen = iOpen(Symbol(), Period(), 1);
  previousOpen_2 = iOpen(Symbol(), Period(), 2);
  valueBuySell = MathAbs(previousClose - previousOpen) / 0.1;
  r3Value = GetR3Value();
  r3Value = GetR3Value();

  rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
  rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
  rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
  rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

  senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
  senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
  senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
  senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);

  LowPrice150 = GetLow();
  HighPrice150 = GetHighestHigh();

  isAreTenkanKijunCrossing = AreTenkanKijunCrossing();
  isCheckEMACross = CheckEMACross();
  isAreEMA50EMA200Crossing = AreEMA50EMA200Crossing();
  isPriceCrossing7EMA200 = PriceCrossing7EMA200();
  isPriceCrossing7EMA50 = PriceCrossing7EMA50();
  isPriceCrossing14EMA200 = PriceCrossing14EMA200();
  isCheckBollingerLOWERCross = CheckBollingerLOWERCross();
  isAreLast3CandlesTouchingUpperBandIsSell = AreLast3CandlesTouchingUpperBandIsSell();
  isPriceCrossingEMA50 = PriceCrossingEMA50();
  isAreEMA50TenkanSenrossing14 = AreEMA50TenkanSenrossing14();
  isPriceCrossingEMA20014 = PriceCrossingEMA20014();
  isPriceCrossingEMA200 = PriceCrossingEMA200();
  IsPriceCrossing1EMA50 = PriceCrossing1EMA50();
  IsPriceCrossingOneEMA50 = PriceCrossingOneEMA50();
  IsPriceCrossing1EMA200 = PriceCrossing1EMA200();
  IsPriceCrossing8EMA200 = PriceCrossing8EMA200();
  IsPriceCrossing3EMA50 = PriceCrossing3EMA50();

  isPriceCrossingEMA5014 = PriceCrossingEMA5014();
  isAreEMA50TenkanSenrossing22 = AreEMA50TenkanSenrossing22();
  isPriceCrossingEMA5022 = PriceCrossingEMA5022();
  isAreEMA50TKIJUSenrossing22 = AreEMA50TKIJUSenrossing22();
  isCheckBollingerUPPERCross = CheckBollingerUPPERCross();

  //vaiable

  datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);
  if (TimeClose == 0)
  {
    TimeClose = iTime(Symbol(), Period(), 0);
  }

  if ((iTime(Symbol(), Period(), 0) - TimeClose) > 15 * 60 * GapMinute)
  {
    if (valueBuySell > 3)
    {
      OpenTrade();
    }
  }

  // if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {

  //   if (CountOrdersWithMagic(9999) < 1) {
  //        CheckEMATrade();
  //    }
  // }

  //  if ((iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
  //    if (CountOrdersWithMagic(9999) < 1) {
  //       MaxMinOderRSI();
  //    }
  //  }

  //  if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
  //   if (CountOrdersWithMagic(9999) < 1) {
  //       CheckPivotStrategy();
  //    }
  //  }

  //  if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
  //   if (CountOrdersWithMagic(9999) < 1) {
  //       CheckMadridRibbon();
  //    }
  //  }

  // if ((iTime(Symbol(), Period(), 0) - TimeClose) > 15 * 60 * GapMinute)
  // {
  //   if (CountOrdersWithMagic(9999) < 1)
  //   {
  //     CheckMadridRibbonUpdate();
  //   }
  // }

  int totalOrders = OrdersTotal();
  double totalProfit = CalculateTotalProfit();

  if (totalProfit > totalProfitCutOffPoint)
  {
    EntryPrice = true;
  }


  if (maxAm > totalProfit)
  {
    maxAm = totalProfit;
  }

  //CheckAndCloseExpiredLossOrders();

  if (totalOrders < MAxLenNhoi && totalProfit > StopDCAPrice)
  {
    ShouldDCA();
  }

  if (CalculateNegativePips() > pipDCAIfMax && totalOrders < MAxLenNhoi)
  {
    ShouldDCA();
  }

  //---

  if (TimeClose == 0)
  {
    TimeClose = iTime(Symbol(), Period(), 0);
  }

  if (totalProfit > tiencLhotLoi || StopLostPrice > totalProfit)
  {
    TimeClose = iTime(Symbol(), Period(), 0);
    logabb("Am lan la " + maxAm);
    logabb("danh len " + CountOrdersWithMagic(9999));
    maxAm = 0;
    CloseProfitableOrders();
    TimeClose = iTime(Symbol(), Period(), 0);
  }

  if (totalProfit < 4 && EntryPrice == true && totalProfit > 0)
  {
    logabb("Am  lan la " + maxAm);
    logabb("danh len hue " + CountOrdersWithMagic(9999));
    maxAm = 0;
    CloseProfitableOrders();
    TimeClose = iTime(Symbol(), Period(), 0);
  }


  if (CountOrdersWithMagic(9999) > 3 && totalProfit > 0)
  {
    logabb("Am lan la " + maxAm);
    logabb("danh len " + CountOrdersWithMagic(9999));
    maxAm = 0;
    TimeClose = iTime(Symbol(), Period(), 0);
    CloseProfitableOrders();
  }


  // double tpbuy = binhquangiabuy(tiencLhotLoi);
  // double tpsell = binhquangiasell(tiencLhotLoi);

  // if (tpbuy != tp_buy) { tp_buy = tpbuy; ObjectDelete(0, "tpbuy"); nutbam_thanhngang("tpbuy", tp_buy, clrLime, 3); }
  // if (dem_so_lenh_hien_co("tong buy") == 0) { ObjectDelete(0, "tpbuy"); }
  // if (tpsell != tp_sell) { tp_sell = tpsell; ObjectDelete(0, "tpsell"); nutbam_thanhngang("tpsell", tp_sell, clrRed, 3); }
  // if (dem_so_lenh_hien_co("tong sell") == 0) { ObjectDelete(0, "tpsell"); }

}

void MaxMinOderRSI()
{

  if (rsiValue > MaxOrderrsi
  && previousOpen > previousClose
  && IsCandleSellRSI()
  && IsSenkouCloudWithin20Pips()
  )
  {
    printf("IsCandleSellRSI");
    EntryPrice = false;
    OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
  }
  else if (rsiValue < MinOrderrsi
  && previousOpen < previousClose
  && IsCandleBuyRSI()
  && IsSenkouCloudWithin20Pips()
  )
  {
    printf("IsCandleBuyRSI");
    EntryPrice = false;
    OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
  }

}

void OpenTrade()
{
  if (CountOrdersWithMagic(9999) < 1)
  {
    double valueSell = ((GetMin(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0) - currentPrice) / 0.1);
    double valueBUY = ((currentPrice - GetMax(iIchiTenkan_0, iIchiKinjun_0, iBandSma_0)) / 0.1);
    previousClosePrice = previousClose;
    if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < MaxPipPreviou)
    {
      if (previousClose < iIchiKinjun_0
         )
      {
        if (valueSell > 3
            && IsCandleSell()
            && rsiValue > MaxrsiSEll
            && currentPrice > s3Value
            )
        {
          printf("IsCandleSell");
          EntryPrice = false;
          OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
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
          printf("IsCandleBuy");
          EntryPrice = false;
          OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
        }
      }
    }
  }
}

void CheckMadridRibbon()
{
  if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 30)
  {
    if (checkTrend(clrGreen) || checkTrendUptrend(clrGreen))
    {
      if (IsCandleBuyRibbon() && rsiValue < MaxrsiBuy)
      {
        printf("IsCandleBuyRibbon");
        EntryPrice = false;
        OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
      }
    }
    else if (checkTrend(clrRed) || checkTrendUptrend(clrRed))
    {
      if (IsCandleSellRibbon() && rsiValue > MaxrsiSEll)
      {
        printf("IsCandleSellRibbon");
        EntryPrice = false;
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
      }
    }
  }
}

void CheckMadridRibbonUpdate()
{
  // Kiểm tra nếu giá chạm mức S3, thì thực hiện mua
  if (((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 30)
  {
    if (checkTrendUptrendUPdate(clrGreen))
    {
      if (currentPrice < SuperTrendValue11)
      {
        EntryPrice = false;
        OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
      }

    }
    else if (checkTrendUptrendUPdate(clrRed))
    {
      if (currentPrice > SuperTrendValue21)
      {
        EntryPrice = false;
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
      }
    }
  }
}

void CheckPivotStrategy()
{

  if (MathAbs(previousClose - previousOpen) / 0.1 > 2 && ((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 35)
  {
    if (previousClose <= s3Value)
    {

      bool Istrue = false;
      for (int z = 0; z < 9; z++)
      {
        double iPreviousCandleLow_1 = iLow(NULL, 0, z);
        if (iPreviousCandleLow_1 > s3Value)
        {
          Istrue = true;
        }
      }

      if (IsCandleBuyPivot() && Istrue)
      {
        printf("IsCandleBuyPivot");
        EntryPrice = false;
        OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);

      }
      Istrue = false;
    }
    else if (previousClose >= r3Value)
    {
      bool Istruer3 = false;
      for (int A = 0; A < 9; A++)
      {
        double HighNow = iHigh(NULL, 0, A);
        if (HighNow < r3Value)
        {
          Istruer3 = true;
        }
      }

      if (IsCandleSellPivot() && Istruer3)
      {
        printf("IsCandleSellPivot");
        EntryPrice = false;
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
      }
      Istruer3 = false;
    }
  }
}

void OpenAdditionalOrder(double lotSizeOrder)
{
  // Thực hiện mở lệnh ở đây, dựa vào giá trị của lotSize
  if (previousClosePrice != previousClose)
  {
    previousClosePrice = previousClose;

    if (CheckOrderType() == 1)
    {
      if (currentPrice)
        OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", 9999,
                  clrNONE);
    }
    else
    {
      OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", 9999,
                clrNONE);
    }
  }
}


double CalculateTotalProfitDownTrend()
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

  // Ví dụ: OrderSend(Symbol(), OP_BUY, lotSize, Bid, 2, 0, 0, "", 0, clrNONE);
  if (negativePips >= (PipNhoiLen + CountOrdersWithMagic(9999)))
  {
    double additionalOrdersCount = double(negativePips / PipNhoiLen);
    double lotSizeOrder = lotSize;
    if (additionalOrdersCount > 1)
    {
      for (int i = 0; i < (CountOrdersWithMagic(9999)); i++)
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
      if (OrderMagicNumber() == 9999)
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
  }
  return 0;
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
  int LatestOrderWithMagic = GetLatestOrderWithMagic(9999);

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

void CheckEMATrade()
{
  double openPrice = Open[1];
  double closePrice = Close[1];
  double openPriceNow = Open[0];
  double pipDifference = MathAbs(openPriceNow - ema50) / 0.1;

  double pipDifferenceEMA = MathAbs(ema50 - iIchiTenkan_3) / 0.1;

  if (pipDifference >= 5 && pipDifferenceEMA > 15
   && ((PreviousCandleHigh_1 - PreviousCandleLow_1) / 0.1) < 45
   )
  {
    if (openPrice < ema50
    && iIchiTenkan_3 < ema50
    && IsCandleBuyEMA()
    && closePrice > ema50)
    {
      printf("IsCandleSellEMA");
      OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
    }
    else if (openPrice > ema50
     && iIchiTenkan_3 > ema50
     && IsCandleSellEMA()
     && closePrice < ema50)
    {
      printf("IsCandleSellEMA");
      OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999, clrNONE);
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
    logaaa("isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_0 - iIchiTenkan_0) / 0.1 < 1");
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 10 && isPriceCrossing14EMA200 && isPriceCrossing7EMA50)
  {
    logaaa("MathAbs(PreviousCandleLow_1 - iBandH1Lower_0) / 0.1 < 10");
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && pipDifferenceKIJUN < 3)
  {
    logaaa("MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30");
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && iBandLower_1 > PreviousCandleLow_1)
  {
    logaaa("MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && currentPrice > ema50 )
  {
    return false;
  }

  // if (rsiValue1 < MaxrsiSEll || rsiValue < MaxrsiSEll)
  // {
  //   logaaa("if (rsiValue1 < MaxrsiSEll || rsiValue < MaxrsiSEll)");
  //   return false;
  // }

  if (currentPrice < LowPrice150 && rsiValue1 > (MaxrsiSEll + 3))
  {
    logaaa("if (currentPrice < LowPrice150 && rsiValue1 > (MaxrsiSEll + 3))");
    return false;
  }

  if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 500 && MathAbs(ema50 - currentPrice) / 0.1 < 50 && currentPrice > ema50)
  {
    logaaa("if (MathAbs(LowPrice150 - currentPrice) / 0.1 > 500 && MathAbs(ema50 - currentPrice) / 0.1 < 50 && currentPrice > ema50)");
    return false;
  }

  // if (isPriceCrossing7EMA50 && MathAbs(ema50 - currentPrice) / 0.1 < 30)
  // {
  //logaaa("if (isPriceCrossing7EMA50 && MathAbs(ema50 - currentPrice) / 0.1 < 30)");
  //   return false;
  // }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)");
    return false;
  }


  if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)");
    return false;
  }


  if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(iBandH1Lower_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (isPriceCrossing7EMA50 && LowNow < iBandLower_0)
  {
    logaaa("if (isPriceCrossing7EMA50 && LowNow < iBandLower_0)");
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && isPriceCrossing7EMA200)
  {
    logaaa("if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30 && isPriceCrossing7EMA200)");
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 60 && MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 25 && MathAbs(ema50 - currentPrice) / 0.1 < 30)
  {
    logaaa("if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 60 && MathAbs(iBandLower_1 - iBandSma_1) / 0.1 < 25 && MathAbs(ema50 - currentPrice) / 0.1 < 30)");
    return false;
  }
  //23-11-23
  if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && isPriceCrossing7EMA50)
  {
    logaaa("if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15 && isPriceCrossing7EMA50)");
    return false;
  }

  if (ema50 > ema200 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 < ema50)
  {
    logaaa("if (ema50 > ema200 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 < ema50)");
    return false;
  }

  if (isPriceCrossing7EMA50 && PreviousCandleLow_1 < iBandLower_1)
  {
    logaaa("if (isPriceCrossing7EMA50 && PreviousCandleLow_1 < iBandLower_1)");
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    logaaa("if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)");
    return false;
  }

  if (iBandH1Lower_0 > currentPrice || iBandH1Lower_0 > PreviousCandleLow_1)
  {
    logaaa("if (iBandH1Lower_0 > currentPrice || iBandH1Lower_0 > PreviousCandleLow_1)");
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    logaaa("previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5");
    return false;
  }


  //24-11-23
  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    logaaa("MathAbs(ema50 - ema200) / 0.1 < 20");
    return false;
  }

  if (IsPriceCrossing1EMA50 && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 3)
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 10
  && MathAbs(ema50 - iBandLower_1) / 0.1 < 10
  )
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 24
  && MathAbs(PreviousCandleLow_1 - iBandLower_1) / 0.1 < 15
  && MathAbs(ema50 - iBandLower_1) / 0.1 < 10
  && MathAbs(senkouA - senkouB) / 0.1 < 7
  )
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
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

     if (MathAbs(ema50 - currentPrice) / 0.1 < 15 &&  HighNow > ema50 )
  {
    return false;
  }

  printf("&& MathAbs(HighPrice150 - PreviousCandleHigh_1) " + MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1);
  //2021
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
    logaaa("if (isPriceCrossing7EMA50 && MathAbs(iIchiKinjun_0 - iIchiTenkan_0) / 0.1 < 1)");
    return false;
  }

  // if (MathAbs(PreviousCandleHigh_1 - iBandH1Upper_0) / 0.1 < 10)
  // {
  //   //logaaa("if (MathAbs(PreviousCandleHigh_1 - iBandH1Upper_0) / 0.1 < 10)");
  //   return false;
  // }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30)");
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30 && PreviousCandleHigh_1 > iBandUpper_1)
  {
    logaaa("if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30)");
    return false;
  }

  if (currentPrice > HighPrice150 && rsiValue1 > (MaxrsiBuy - 5))
  {
    logaaa("if (currentPrice > HighPrice150 && rsiValue1 > (MaxrsiBuy - 5))");
    return false;
  }

  if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 500 && MathAbs(ema50 - currentPrice) / 0.1 < 50 && ema50 > currentPrice)
  {
    logaaa("if (MathAbs(HighPrice150 - currentPrice) / 0.1 > 500 && MathAbs(ema50 - currentPrice) / 0.1 < 50 && ema50 > currentPrice)");
    return false;
  }

  if (isPriceCrossing7EMA50 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50)
  {
    logaaa("if (isPriceCrossing7EMA50 && MathAbs(HighPrice150 - PreviousCandleHigh_1) / 0.1 < 50)");
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 22)
  {
    logaaa("if (MathAbs(ema50 - ema200) / 0.1 < 22)");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 10)
  {
    logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 10)");
    return false;
  }

  if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (isPriceCrossing7EMA50 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 27 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)
  {
    logaaa("if (MathAbs(iBandH1Upper_0 - currentPrice) / 0.1 < 15 && pipDifferenceKIJUN < 3)");
    return false;
  }

  if (isPriceCrossing7EMA50 && HighNow > iBandUpper_0)
  {
    logaaa("if (isPriceCrossing7EMA50 && HighNow > iBandUpper_0)");
    return false;
  }

  if (MathAbs(iBandUpper_1 - PreviousCandleHigh_1) / 0.1 < 7 && isPriceCrossing7EMA200)
  {
    logaaa("if (MathAbs(iBandUpper_1 - PreviousCandleHigh_1) / 0.1 < 7 && isPriceCrossing7EMA200)");
    return false;
  }

  if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && isPriceCrossing7EMA50)
  {
    logaaa("if (MathAbs(iBandH1Upper_0 - PreviousCandleHigh_1) / 0.1 < 15 && isPriceCrossing7EMA50)");
    return false;
  }

  if (ema50 < ema200 && isAreEMA50EMA200Crossing && pipDifferenceKIJUN < 3 && ema50_6 > ema50)
  {
    logaaa("if (ema50 < ema200 && isAreEMA50EMA200Crossing && pipDifferenceKIJUN < 3 && ema50_6 > ema50)");
    return false;
  }

  if (isPriceCrossing7EMA50 && PreviousCandleHigh_1 > iBandUpper_1)
  {
    logaaa("if (isPriceCrossing7EMA50 && PreviousCandleHigh_1 > iBandUpper_1)");
    return false;
  }
  //23-11-23
  if (ema50 < ema200 && MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 > ema50)
  {
    logaaa("if (ema50 < ema200 && MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 50 && pipDifferenceKIJUN < 2 && ema50_6 > ema50)");
    return false;
  }

  if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)
  {
    logaaa("if (MathAbs(iBandUpper_1 - iBandSma_1) / 0.1 < 20)");
    return false;
  }

  if (iBandH1Upper_0 < currentPrice || iBandH1Upper_0 < PreviousCandleHigh_1)
  {
    logaaa("if (iBandH1Upper_0 < currentPrice || iBandH1Upper_0 < PreviousCandleHigh_1)");
    return false;
  }

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    logaaa("if (MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)");
    return false;
  }
  //24-11-23
  if (MathAbs(ema50 - ema200) / 0.1 < 20)
  {
    logaaa("MathAbs(ema50 - ema200) / 0.1 < 20");
    return false;
  }

  if (IsPriceCrossing1EMA50 && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 3)
  {
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 3)
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
    return false;
  }

  if (MathAbs(ema50 - currentPrice) / 0.1 < 15
  && MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 15
  && MathAbs(ema50 - iBandUpper_1) / 0.1 < 15
  )
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
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
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
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

  //  if (MathAbs(PreviousCandleHigh_1 - iBandUpper_1) / 0.1 < 20 && MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30)
  // {
  //   return false;
  // }

  if (ema50 > currentPrice
  && MathAbs(previousClose - previousOpen) / 0.1 > 12
  && previousClose < previousOpen
  && MathAbs(previousClose - previousOpen) / MathAbs(PreviousCandleHigh_1 - PreviousCandleLow_1) > 0.7
  && MathAbs(previousClose_2 - previousOpen_2) / MathAbs(PreviousCandleHigh_2 - PreviousCandleLow_2) < 0.2
  )
  {
    //logaaa("if (MathAbs(ema50 - currentPrice) / 0.1 < 20 || MathAbs(ema200 - currentPrice) / 0.1 < 20)");
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

 if (MathAbs(ema50 - currentPrice) / 0.1 < 15 &&  LowNow < ema50 )
  {
    return false;
  }

   if (MathAbs(ema50 - currentPrice) / 0.1 < 20 && currentPrice < ema50 )
  {
    return false;
  }


  printf("MathAbs(HighPrice150 - currentPrice) " + MathAbs(HighPrice150 - currentPrice) / 0.1);
  return true;

}

bool IsCandleBuyRSI()
{
  double valuePreviousBUY = ((previousClose - previousOpen) / 0.1);

  if (ema200 > currentPrice && isPriceCrossingEMA200)
  {
    return false;
  }

  if (ema50 > currentPrice && isPriceCrossingEMA50)
  {
    return false;
  }

  if (MathAbs(valuePreviousBUY) < 3)
  {
    return false;
  }

  return true;
}

bool IsCandleSellRSI()
{
  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

  if (currentPrice > ema200 && isPriceCrossingEMA200)
  {
    return false;
  }

  if (currentPrice > ema50 && isPriceCrossingEMA50)
  {
    return false;
  }

  if (MathAbs(valuePreviousSell) < 3)
  {
    return false;
  }

  return true;
}

bool IsCandleBuyEMA()
{

  if ((senkouB - senkouA) / 0.1 > 150)
  {
    return false;
  }

  if ((ema200 - PreviousCandleHigh_1) / 0.1 < 10 && (ema200 - currentPrice) / 0.1 > 0)
  {
    return false;
  }

  if (senkouB > senkouA && isAreEMA50EMA200Crossing)
  {
    return false;
  }

  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (isPriceCrossing7EMA50)
  {
    return false;
  }

  if (isAreTenkanKijunCrossing)
  {
    return false;
  }

  return true;
}

bool IsCandleSellEMA()
{


  if ((ema200 - PreviousCandleLow_1) / 0.1 < 10 && (currentPrice - ema200) / 0.1 > 0)
  {
    return false;
  }

  if ((senkouA - senkouB) / 0.1 > 150)
  {
    return false;
  }

  if (senkouA > senkouB && isAreEMA50EMA200Crossing)
  {
    return false;
  }

  if (isPriceCrossing7EMA200)
  {
    return false;
  }

  if (isPriceCrossing7EMA50)
  {
    return false;
  }

  if (isAreTenkanKijunCrossing)
  {
    return false;
  }
  return true;
}

bool IsCandleBuyPivot()
{


  if (isAreEMA50EMA200Crossing)
  {
    return false;
  }

  if (isPriceCrossingEMA50)
  {
    return false;
  }
  if (isCheckBollingerLOWERCross && isPriceCrossingEMA50)
  {
    return false;
  }

  if (previousClose < previousOpen)
  {
    return false;
  }

  if (currentPrice < ema50 && isAreTenkanKijunCrossing)
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 17)
  {
    return false;
  }

  if (currentPrice < ema50 && AreEma50KijunCrossing())
  {
    return false;
  }

  if (currentPrice < iBandH1Lower_0 && currentPrice > iBandLower_0)
  {
    return false;
  }
  return true;
}

bool IsCandleSellPivot()
{

  if (isAreEMA50EMA200Crossing)
  {
    return false;
  }

  if (isPriceCrossingEMA50)
  {
    return false;
  }

  if (previousOpen > previousClose)
  {
    return false;
  }

  if (currentPrice > ema50 && isAreTenkanKijunCrossing)
  {
    return false;
  }

  if (currentPrice > ema50 && AreEma50KijunCrossing())
  {
    return false;
  }

  if (MathAbs(currentPrice - ema200) / 0.1 < 17)
  {
    return false;
  }

  if (isCheckBollingerUPPERCross && isPriceCrossingEMA50)
  {
    return false;
  }

  if (currentPrice > iBandH1Upper_0 && currentPrice < iBandUpper_0)
  {
    return false;
  }
  return true;
}

bool IsCandleBuyRibbon()
{
  double pipDifferenceSP = MathAbs(SuperTrendValue01 - ema50) / 0.1;
  double pipDifferenceSPA = MathAbs(SuperTrendValue01 - SuperTrendValue08) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;
  double valuePreviousBuy = ((previousOpen - previousClose) / 0.1);

  if ((rsiValue > 66 || rsiValue1 > 66 || rsiValue2 > 66 || rsiValue3 > 70) && MathAbs(senkouB - senkouA) / 0.1 > 50)
  {
    return false;
  }

  if (pipDifferenceTenkan < 2)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandUpper_1)
  {
    return false;
  }

  if (pipDifferenceSPA < 3 && iIchiTenkan_0 < iIchiKinjun_0 && isAreTenkanKijunCrossing)
  {
    return false;
  }

  if ((ema200_1 - PreviousCandleHigh_1) / 0.1 < 25 && (ema200_1 - PreviousCandleHigh_1) > 0)
  {
    return false;
  }

  if (isAreTenkanKijunCrossing && AreLast3CandlesTouchingUpperBandIsBuy())
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandSma_1 && PreviousCandleLow_1 < iBandSma_1 && currentPrice < ema50)
  {
    return false;
  }

  if (MathAbs(HighPrice150 - HighNow) / 0.1 < 30)
  {
    return false;
  }

  if (MathAbs(iBandSma_1 - iBandUpper_1) / 0.1 < 21)
  {
    return false;
  }

  if (MathAbs(currentPrice - iBandUpper_1) / 0.1 < 27 && pipDifferenceSPA < 3)
  {
    return false;
  }

  if (MathAbs(iBandSma_1 - iBandUpper_1) / 0.1 < 27 && AreLast3CandlesTouchingUpperBandIsBuy())
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (IsPriceCrossing1EMA200)
  {
    return false;
  }

  if (IsPriceCrossing8EMA200 && AreLast5CandlesTouchingUpperBandIsBuy())
  {
    return false;
  }

  if (currentPrice < ema50 && pipDifferenceSP < 33)
  {
    return false;
  }

  if (currentPrice > HighPrice150 && AreLast3CandlesTouchingUpperBandIsBuy())
  {
    return false;
  }

  if (IsPriceCrossing1EMA50 && AreLast3CandlesTouchingUpperBandIsBuy())
  {
    return false;
  }

  if (MathAbs(valuePreviousBuy) < 4)
  {
    return false;
  }

  if ((currentPrice - iBandH1Sma_1) / 0.1 > 170 && (iBandH1Upper_0 - iBandH1Sma_1) / 0.1 > 200)
  {
    return false;
  }

  if ((currentPrice - iBandUpper_1) / 0.1 > 10)
  {
    return false;
  }

  if (isPriceCrossingEMA50 && currentPrice > iBandUpper_1)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - r3Value) / 0.1 < 20)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > r3Value)
  {
    return false;
  }

  if (previousClose < previousOpen)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 22)
  {
    return false;
  }

  if (MathAbs(currentPrice - iBandH1Upper_0) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(PreviousCandleHigh_1 - iBandH1Upper_0) / 0.1 < 15)
  {
    return false;
  }

  if (iBandH1Upper_0 < PreviousCandleHigh_1 || iBandH1Upper_0 < PreviousCandleHigh_2)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 2)
  {
    return false;
  }

  if ((senkouB - senkouA) >= (senkouB2 - senkouA2) && senkouB > senkouA)
  {

    return false;
  }

  if (MathAbs(iBandH1Sma_1 - bandSMA) / 0.1 < 13)
  {
    return false;
  }

  //  if((senkouA2 -senkouB2 )/(senkouA - senkouB) > 4  && senkouA > senkouB   ){

  //       return false;
  //  }

  if (MathAbs(senkouB - senkouA) / 0.1 < 5 && MathAbs(currentPrice - ema50) / 0.1 < 25)
  {

    return false;
  }

  if (isAreTenkanKijunCrossing && MathAbs(senkouB - senkouA) / 0.1 < senkouBNsenkouA)
  {
    return false;
  }

  if (isPriceCrossingEMA50 && pipDifferenceKIJUN < 4 && iIchiTenkan_0 < iIchiKinjun_0)
  {
    return false;
  }

  if (MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > ema200_1 && ema200_1 > PreviousCandleLow_1)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
  {
    return false;
  }

  printf("MathAbs(iBandH1Sma_1 - bandSMA)" + MathAbs(iBandH1Sma_1 - bandSMA));
  return true;
}

bool IsCandleSellRibbon()
{
  double pipDifferenceSP = MathAbs(SuperTrendValue01 - ema50) / 0.1;
  double pipDifferenceSPA = MathAbs(SuperTrendValue01 - SuperTrendValue08) / 0.1;
  double pipDifferenceKIJUN = MathAbs(iIchiKinjun_0 - iIchiKinjun_4) / 0.1;

  double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

  if (rsiValue < 30 || rsiValue1 < 30 || rsiValue2 < 30 || rsiValue3 < 30 && MathAbs(senkouB - senkouA) / 0.1 > 50)
  {
    return false;
  }

  if (pipDifferenceTenkan < 2)
  {
    return false;
  }

  if (LowPrice150 > currentPrice && AreLast4CandlesTouchingUpperBandIsSell())
  {
    return false;
  }

  if (iBandLower_1 > PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(iBandH1Sma_1 - bandSMA) / 0.1 < 13)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - LowPrice150) / 0.1 < 30)
  {
    return false;
  }

  if ((PreviousCandleLow_1 - ema200_1) / 0.1 < 25 && (PreviousCandleLow_1 - ema200_1) > 0)
  {
    return false;
  }

  if (pipDifferenceSPA < 3 && iIchiTenkan_0 > iIchiKinjun_0 && isAreTenkanKijunCrossing)
  {
    return false;
  }

  if (currentPrice > ema50 && pipDifferenceSP < 30)
  {
    return false;
  }

  if (MathAbs(iBandSma_1 - iBandLower_1) / 0.1 < 21)
  {
    return false;
  }

  if (MathAbs(currentPrice - iBandLower_1) / 0.1 < 27 && pipDifferenceSPA < 3)
  {
    return false;
  }

  //   if(( senkouB2 - senkouA2 )/( senkouB - senkouA) > 4  && senkouB > senkouA  ){

  //       return false;
  //  }

  if (MathAbs(iBandSma_1 - iBandLower_1) / 0.1 < 27 && isAreLast3CandlesTouchingUpperBandIsSell)
  {
    return false;
  }

  if (isPriceCrossingEMA50 && currentPrice < iBandLower_1)
  {
    return false;
  }

  if ((iBandLower_1 - currentPrice) / 0.1 > 10)
  {
    return false;
  }

  if (MathAbs(ema50 - ema200) / 0.1 < 22)
  {
    return false;
  }

  if ((iBandH1Sma_1 - currentPrice) / 0.1 > 170 && (iBandH1Sma_1 - iBandH1Lower_0) / 0.1 > 200)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > iBandSma_1 && PreviousCandleLow_1 < iBandSma_1 && currentPrice > ema50)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50)
  {
    return false;
  }

  if (IsPriceCrossing1EMA200)
  {
    return false;
  }

  if (IsPriceCrossing3EMA50)
  {
    return false;
  }

  if (IsPriceCrossing1EMA50 && isAreLast3CandlesTouchingUpperBandIsSell)
  {
    return false;
  }

  if (IsPriceCrossing8EMA200 && isAreLast3CandlesTouchingUpperBandIsSell)
  {
    return false;
  }

  if (MathAbs(valuePreviousSell) < 4)
  {
    return false;
  }

  if (MathAbs(PreviousCandleLow_1 - s3Value) / 0.1 < 20)
  {
    return false;
  }

  if (s3Value > PreviousCandleLow_1)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - currentPrice) / 0.1 < 15)
  {
    return false;
  }

  if (MathAbs(iBandH1Lower_0 - PreviousCandleLow_1) / 0.1 < 15)
  {
    return false;
  }

  if (iBandH1Lower_0 > PreviousCandleLow_1 || iBandH1Lower_0 > PreviousCandleLow_2)
  {
    return false;
  }

  if (previousClose > previousOpen)
  {
    return false;
  }

  if ((senkouA - senkouB) >= (senkouA2 - senkouB2) && senkouA > senkouB)
  {
    return false;
  }

  if (MathAbs(senkouB - senkouA) / 0.1 < 5 && MathAbs(currentPrice - ema50) / 0.1 < 25)
  {

    return false;
  }

  if ((senkouA - senkouB) / 0.1 >= 100 && isAreTenkanKijunCrossing)
  {
    return false;
  }

  if ((senkouA - senkouB) >= (senkouA2 - senkouB2) && MathAbs(senkouB - senkouA) / 0.1 < senkouBNsenkouA)
  {
    return false;
  }

  if (pipDifferenceKIJUN < 2)
  {
    return false;
  }

  if (isPriceCrossingEMA50 && pipDifferenceKIJUN < 4 && iIchiTenkan_0 > iIchiKinjun_0)
  {
    return false;
  }

  if (MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 5)
  {
    return false;
  }

  if (PreviousCandleHigh_1 > ema200_1 && ema200_1 > PreviousCandleLow_1)
  {
    return false;
  }

  printf("Low()" + LowPrice150);
  printf("currentPrice" + currentPrice);
  return true;
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

bool PriceCrossing1EMA50()
{

  for (int i = 1; i < 3; i++)
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

bool PriceCrossingOneEMA50()
{

  for (int i = 1; i < 2; i++)
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

bool PriceCrossingEMA5014()
{

  for (int i = 0; i < 14; i++)
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

bool PriceCrossingEMA20014()
{

  for (int i = 0; i < 14; i++)
  {
    double closePrice = Close[i];
    double ema50 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i);
    double PreviousCandleHigh_1 = iHigh(NULL, 0, i);
    double PreviousCandleLow_1 = iLow(NULL, 0, i);

    if ((PreviousCandleHigh_1 > ema50 && PreviousCandleLow_1 <= ema50))
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

bool AreEMA50TenkanSenrossing()
{
  double ema50[7];
  double tenkanSen[7];

  for (int z = 0; z < 7; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 7; i++)
  {
    if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
        (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50TenkanSenrossing14()
{
  double ema50[14];
  double tenkanSen[14];

  for (int z = 0; z < 14; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 14; i++)
  {
    if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
        (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}


bool AreEMA50TenkanSenrossing22()
{
  double ema50[22];
  double tenkanSen[22];

  for (int z = 0; z < 22; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
  }

  for (int i = 1; i < 22; i++)
  {
    if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
        (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50TKIJUSenrossing22()
{
  double ema50[22];
  double tenkanSen[22];

  for (int z = 0; z < 22; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
  }

  for (int i = 1; i < 22; i++)
  {
    if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
        (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i]))
    {
      return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
    }
  }

  return false; // Không có cắt nhau
}

bool AreEMA50EMA200Crossing()
{
  double ema50[45];
  double ema200[45];

  for (int z = 0; z < 45; z++)
  {
    ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
    ema200[z] = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, z);
  }

  for (int i = 1; i < 45; i++)
  {
    if ((ema50[i - 1] > ema200[i - 1] && ema50[i] <= ema200[i]) ||
        (ema50[i - 1] < ema200[i - 1] && ema50[i] >= ema200[i]))
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
  int fileHandle;
  string fileName = "mylog1.csv";
  fileHandle = FileOpen(fileName, FILE_CSV | FILE_READ | FILE_WRITE, ';');

  if (fileHandle != INVALID_HANDLE)
  {
    FileSeek(fileHandle, 0, SEEK_END);
    FileWrite(fileHandle, logMessage);
    FileClose(fileHandle);
  }
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