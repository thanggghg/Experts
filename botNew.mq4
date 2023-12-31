input double lotSize = 0.05;
input double tiencLhotLoi = 10;
input double tienDownTrend = -10;
input double MaxPipPreviou = 15;
input double MaxPipichimoku = 10;
input double PipNhoiLen = 20;
input double StopLostPrice = -500;
input double lotSizeNhoiLen = 0.03;
input int MAxLenNhoi = 9;
input int FromTime = 22;
input int ToTime = 10;

bool ShouldEnterTrade = False;
bool MainIsBuy = False;

double previousClosePrice = 0.0;

double lastPIP = 0.0;
void OnTick(void) {
if (CountOrdersWithMagic(9999) < 1) {
datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);
  printf("ssssssssssss"+candleHour);
OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
 }
}
void OnTicks(void) {
  datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);

  if (candleHour >= FromTime || candleHour < ToTime) {
    OpenTrade();
  }

  //--
  int totalOrders = OrdersTotal();
  double totalProfit = CalculateTotalProfit();
  double totalProfitMain = CalculateTotalProfitMain();

  if(totalOrders <MAxLenNhoi && totalProfit > StopLostPrice ){
    ShouldDCA();
  }

  if(totalProfitMain < StopLostPrice ){
    if (CountOrdersWithMagic(6666) < 1) {
      BlockMain();
    }
  }
  
  if (totalProfit > tiencLhotLoi) {
    CloseProfitableOrders();
  }
  
  if (totalProfit < tienDownTrend) {
    OpenTradeDownTrend();
  }
  double totalProfitDownTrend =  CalculateTotalProfitDownTrend();
  if (totalProfitDownTrend > tiencLhotLoi) {
    CloseProfitableOrdersDownTrend();
  }
}

void OpenTrade() {
  if (CountOrdersWithMagic(9999) < 1) {
    double previousClose = iClose(Symbol(), Period(), 1);
    previousClosePrice = previousClose;
    double ichimokuTenkan =
        iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
    double ichimokuKijun = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
    double bollingerMiddle =
        iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double PreviousCandleLow = iLow(NULL, 0, 1);
    double pointSize = MarketInfo(OrderSymbol(), MODE_POINT);

    double valueSell =
        ((GetMin(ichimokuTenkan, ichimokuKijun, bollingerMiddle) -
          previousClose) /
         0.1);

    double valueBUY = ((currentPrice - GetMax(ichimokuTenkan, ichimokuKijun,
                                              bollingerMiddle)) /
                       0.1);

    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou) {
      if (previousClose < ichimokuTenkan && previousClose < ichimokuKijun &&
          previousClose < bollingerMiddle) {
        // Open a Sell trade
        if (valueSell < MaxPipichimoku && valueSell > 3) {
          MainIsBuy = false;
          OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,
                    clrNONE);
        }
      } else if (previousClose > ichimokuTenkan &&
                 previousClose > ichimokuKijun &&
                 previousClose > bollingerMiddle) {
        // Open a Buy trade

        if (valueBUY < MaxPipichimoku && valueBUY > 3) {
          MainIsBuy = true;
          OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
        }
      }
    }
  }
}

void OpenTradeDownTrend() {
  if (CountOrdersWithMagic(8888) < 1) {
    double previousClose = iClose(Symbol(), Period(), 1);
    previousClosePrice = previousClose;
    double ichimokuTenkan =
        iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
    double ichimokuKijun = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
    double bollingerMiddle =
        iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double PreviousCandleLow = iLow(NULL, 0, 1);
    double pointSize = MarketInfo(OrderSymbol(), MODE_POINT);

    double valueSell =
        ((GetMin(ichimokuTenkan, ichimokuKijun, bollingerMiddle) -
          previousClose) /
         0.1);

    double valueBUY = ((currentPrice - GetMax(ichimokuTenkan, ichimokuKijun,
                                              bollingerMiddle)) /
                       0.1);

    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou) {
      if (previousClose < ichimokuTenkan && previousClose < ichimokuKijun &&
          previousClose < bollingerMiddle) {
        // Open a Sell trade
        if (valueSell < MaxPipichimoku && valueSell > 3) {
          if (MainIsBuy == true) {
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 8888,
                      clrNONE);
          }
        }
      } else if (previousClose > ichimokuTenkan &&
                 previousClose > ichimokuKijun &&
                 previousClose > bollingerMiddle) {
        // Open a Buy trade

        if (valueBUY < MaxPipichimoku && valueBUY > 3) {
          if (MainIsBuy == false) {
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 8888,
                      clrNONE);
          }
        }
      }
    }
  }
}

bool IsWithinTimeRange() {
  datetime currentTime = TimeCurrent();
  int utcOffset = TimeGMTOffset();
  int localHour = Hour() + utcOffset + 7;

  return (localHour >= 5 && localHour < 17);
}

void OpenAdditionalOrder(double lotSizeOrder) {
  // Thực hiện mở lệnh ở đây, dựa vào giá trị của lotSize
  double previousClose = iClose(Symbol(), Period(), 1);
  if (previousClosePrice != previousClose) {
    previousClosePrice = previousClose;

    if (CalculateTotalProfitDownTrend() > 0) {
      if (CheckOrderType() == 1) {
        OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", 8888,
                  clrNONE);
      } else {
        OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", 8888,
                  clrNONE);
      }
    }

    if (CheckOrderType() == 1) {
      OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", 9999,
                clrNONE);
    } else {
      OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", 9999,
                clrNONE);
    }
  }
}

double CalculateTotalProfitDownTrend() {
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderMagicNumber() == 8888) {
        totalProfit += OrderProfit();
      }
    }
  }

  return totalProfit;
}

double CalculateTotalProfit() {
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      totalProfit += OrderProfit();
    }
  }

  return totalProfit;
}

void CloseProfitableOrders() {
     Print("CloseProfitableOrders");
  int totalOrders = OrdersTotal();
  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
       

            if (OrderType() == OP_BUY) {
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
            } else {
                OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
            }
       
    }
  }
  CloseOrdersWithRequote();
}

void CloseProfitableOrdersDownTrend() {
  int totalOrders = OrdersTotal();
  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
       
         if (OrderMagicNumber() == 8888) {
            if (OrderType() == OP_BUY) {
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
            } else {
                OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
            }
        }
    }
  }
}

double CalculateTotalProfitMain() {
  double totalProfit = 0.0;
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (OrderMagicNumber() == 9999) {
      totalProfit += OrderProfit();
        }
    }
  }

  return totalProfit;
}

void CloseOrdersWithRequote() {
   int totalOrders = OrdersTotal();
   
   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         double closePrice = OrderType() == OP_BUY ? MarketInfo(OrderSymbol(), MODE_BID) : MarketInfo(OrderSymbol(), MODE_ASK);
         if (OrderClose(OrderTicket(), OrderLots(), closePrice, 3, clrNONE)) {
         } else {
            int lastError = GetLastError();
            if (lastError == ERR_REQUOTE) {
               // Thử đóng lại lần nữa với giá mới
               double newClosePrice = OrderType() == OP_BUY ? MarketInfo(OrderSymbol(), MODE_BID) - 5 * Point : MarketInfo(OrderSymbol(), MODE_ASK) + 5 * Point;
               if (OrderClose(OrderTicket(), OrderLots(), newClosePrice, 3, clrNONE)) {
                  Print("Đã đóng lệnh sau khi thử lại: ", OrderType(), " Ticket: ", OrderTicket(), " Giá mua: ", OrderOpenPrice(), " Số lô: ", OrderLots());
               } else {
                  Print("Không thể đóng lệnh: ", lastError);
               }
            } else {
               Print("Không thể đóng lệnh: ", lastError);
            }
         }
      }
   }
}

void ShouldDCA() {
  double negativePips = CalculateNegativePips();

  // Ví dụ: OrderSend(Symbol(), OP_BUY, lotSize, Bid, 2, 0, 0, "", 0, clrNONE);
  if (negativePips >= PipNhoiLen) {
    double additionalOrdersCount = double(negativePips / PipNhoiLen);
    double lotSizeOrder = lotSize;
    if (additionalOrdersCount > 1) {
      for (int i = 0; i < (CountOrdersWithMagic(9999)); i++) {
        lotSizeOrder = lotSizeOrder + lotSizeNhoiLen;
      }
      // Print("ssssssss"+additionalOrdersCount);

      OpenAdditionalOrder(lotSizeOrder);
    }
  }
}

int CheckOrderType() {
  int totalOrders = OrdersTotal();

  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderMagicNumber() == 9999) {
        if (OrderType() == OP_BUY) {
          return 1;
        } else {
          return 0;
        }
      }
    }
  }
}

int CountOrdersWithMagic(int magicNumber) {
  int totalOrders = OrdersTotal();
  int count = 0;

  for (int i = 0; i < totalOrders; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderMagicNumber() == magicNumber) {
        count++;
      }
    }
  }

  return count;
}

double GetMin(double value1, double value2, double value3) {
  double minValue = value1;

  if (value2 < minValue) {
    minValue = value2;
  }

  if (value3 < minValue) {
    minValue = value3;
  }

  return minValue;
}

double GetMax(double value1, double value2, double value3) {
  double maxValue = value1;

  if (value2 > maxValue) {
    maxValue = value2;
  }

  if (value3 > maxValue) {
    maxValue = value3;
  }

  return maxValue;
}

double GetLatestOrderLoss() {
  double latestOrderLoss = 0.0;
  int totalOrders = OrdersTotal();

  if (totalOrders > 0) {
    if (OrderSelect(totalOrders - 1, SELECT_BY_POS, MODE_TRADES)) {
      latestOrderLoss = OrderProfit() < 0 ? OrderProfit() : 0.0;
    }
  }

  return latestOrderLoss;
}

double CalculateNegativePips() {
  double pipChange = 0.0;

  double totalNegativePips = 0.0;
  int LatestOrderWithMagic = GetLatestOrderWithMagic(9999);

  if (OrderSelect(LatestOrderWithMagic, SELECT_BY_POS, MODE_TRADES)) {
    double openPrice = OrderOpenPrice();
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  // Sử dụng giá Bid hiện tại
    if (OrderType() == OP_BUY) {
       totalNegativePips = (currentPrice - openPrice) / 0.1;
    } else if (OrderType() == OP_SELL) {
       totalNegativePips = (openPrice - currentPrice) / 0.1;
    }
  }

  if (totalNegativePips < 0) {
    pipChange += totalNegativePips;
  }

  return MathAbs(pipChange);
}

int GetLatestOrderWithMagic(int magicNumber) {
   int totalOrders = OrdersTotal();
   int latestOrderIndex = -1;
   datetime latestOrderTime = 0;
   
   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == magicNumber) {
            if (latestOrderIndex == -1 || OrderOpenTime() > latestOrderTime) {
               latestOrderIndex = i;
               latestOrderTime = OrderOpenTime();
            }
         }
      }
   }
   
   return latestOrderIndex;
}

void BlockMain() {
   double totalLots = 0;
   int totalOrders = OrdersTotal();
   
   for (int i = totalOrders - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (OrderMagicNumber() == 9999) {
         totalLots += OrderLots();
        }
        
      }
   }
   
   if (totalLots > 0) {
    if (OrderType() == OP_BUY) {
      OrderSend(Symbol(), OP_SELL, totalLots,  Bid , 3, 0, 0, "", 6666, clrNONE);
    }else{
      OrderSend(Symbol(), OP_BUY, totalLots,  Ask, 3, 0, 0, "", 6666, clrNONE);
    }
   }
}