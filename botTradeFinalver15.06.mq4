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
input double StopLostPrice = -700;//ko xài
input double StopDCAPrice = -400;//tới âm giá này thì ngưng DCA
input int pipDCAIfMax = 40;//âm tới StopDCAPrice thì pip DCA sẽ khác
input int FromTime = 22;
input int ToTime = 10;

bool ShouldEnterTrade = False;
bool MainIsBuy = False;
datetime TimeClose = False;
double previousClosePrice = 0.0;

double lastPIP = 0.0;

void OnTick(void) {
  datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);

  if (candleHour >= FromTime || candleHour < ToTime && (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
    

     OpenTrade();
    
    if (CountOrdersWithMagic(9999) < 1) {
        CheckEMATrade();
     }
  }
  if ((iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
     if (CountOrdersWithMagic(9999) < 1) {
         MaxMinOderRSI();
     }
  }
     
  
   int totalOrders = OrdersTotal();
   double totalProfit = CalculateTotalProfit();
   
  //CheckAndCloseExpiredLossOrders();
  
  if(totalOrders <MAxLenNhoi && totalProfit > StopDCAPrice ){
    ShouldDCA();
  }
  
  if( CalculateNegativePips() > pipDCAIfMax && totalOrders <MAxLenNhoi ){
     ShouldDCA();
  }
//---

  
  if (totalProfit > tiencLhotLoi) {
     TimeClose = iTime(Symbol(), Period(), 0);
    CloseProfitableOrders();
  }

 
  double totalProfitDownTrend =  CalculateTotalProfitDownTrend();
  if (totalProfitDownTrend > tiencLhotLoi) {
    CloseProfitableOrdersDownTrend();
  }
  
}

void MaxMinOderRSI() {
   double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double previousClose = iClose(Symbol(), Period(), 1);
    double previousOpen =  iOpen(Symbol(), Period(), 1);
    
      if(rsiValue > MaxOrderrsi 
      && previousOpen >  previousClose
      && IsCandleSellRSI()
      && IsSenkouCloudWithin20Pips()
      ){
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
      }else if(rsiValue < MinOrderrsi
      && previousOpen <  previousClose
      && IsCandleBuyRSI()
      && IsSenkouCloudWithin20Pips() 
      ){
        OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
      }

}

void OpenTrade() {
  if (CountOrdersWithMagic(9999) < 1) {
    double previousClose = iClose(Symbol(), Period(), 1);
    double previousOpen =  iOpen(Symbol(), Period(), 1);
    double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
    
    previousClosePrice = previousClose;
    double ichimokuTenkan = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
    double ichimokuKijun = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
    double bollingerMiddle =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double PreviousCandleLow = iLow(NULL, 0, 1);
    double pointSize = MarketInfo(OrderSymbol(), MODE_POINT);

    double valueSell = ((GetMin(ichimokuTenkan, ichimokuKijun, bollingerMiddle) - previousClose) /0.1);

    double valueBUY = ((currentPrice - GetMax(ichimokuTenkan, ichimokuKijun,bollingerMiddle)) / 0.1);

    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou) {
      if (previousClose < ichimokuTenkan 
         && previousClose < ichimokuKijun 
         &&previousClose < bollingerMiddle) {
        // Open a Sell trade
        if ( valueSell > 3 
            && IsCandleSell()
            && rsiValue > MaxrsiSEll
            
            ) {
            MainIsBuy = false;
              
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
        }
      }else if( previousClose > ichimokuTenkan 
                && previousClose > ichimokuKijun 
                && previousClose > bollingerMiddle) {
        // Open a Buy trade
        if ( valueBUY > 3 
         //  && IsPriceAboveSenkouABy11Pips(true) 
           && IsCandleBuy()
           && rsiValue < MaxrsiBuy
           ) {
          MainIsBuy = true;
           printf("AreTenkanKijunCrossingAreTenkanKijunCrossing"+AreTenkanKijunCrossing());
          OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
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
        OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", 8888,clrNONE);
      } else {
        OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", 8888,clrNONE);
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
    Print("CloseProfitableOrdersDownTrend");
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
                 
               } else {
                  
               }
            } else {
              
            }
         }
      }
   }
}

void ShouldDCA() {
  double negativePips = CalculateNegativePips();

  // Ví dụ: OrderSend(Symbol(), OP_BUY, lotSize, Bid, 2, 0, 0, "", 0, clrNONE);
  if (negativePips >= (PipNhoiLen+CountOrdersWithMagic(9999))) {
    double additionalOrdersCount = double(negativePips / PipNhoiLen);
    double lotSizeOrder = lotSize;
    if (additionalOrdersCount > 1) {
      for (int i = 0; i < (CountOrdersWithMagic(9999)); i++) {
        lotSizeOrder = lotSizeOrder + lotSizeNhoiLen;
      }
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

void CheckAndCloseExpiredOrders() {
   int totalOrders = OrdersTotal();
   
   for (int i = 0; i < totalOrders; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         CloseOrderIfExpired(OrderTicket());
      }
   }
}

void CheckAndCloseExpiredLossOrders() {
   int totalOrders = OrdersTotal();
   
   for (int i = 0; i < totalOrders; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         CloseOrderIfExpired(OrderTicket());
      }
   }
}

void CloseOrderIfExpired(int ticket) {
   if (ShouldCloseOrder(ticket)) {
      if (OrderClose(ticket, OrderLots(), OrderClosePrice(), 3, clrNONE)) {
         Print("Lệnh đã được đóng vì quá thời hạn: Ticket = ", ticket);
      } else {
         Print("Không thể đóng lệnh: Lỗi = ", GetLastError());
      }
   }
}

bool ShouldCloseOrder(int ticket) {
   if (OrderSelect(ticket, SELECT_BY_TICKET)) {
      if (OrderProfit() < 0) { // Chỉ đóng lệnh âm
         datetime openTime = OrderOpenTime();
         datetime currentTime = TimeCurrent();
      
         int secondsPassed = currentTime - openTime;
         int maxOpenTime = 2 * 24 * 60 * 60; // 2 ngày
      
         return secondsPassed > maxOpenTime;
      }
   }
   
   return false;
}


// Hàm lấy giá trị lớn nhất và nhỏ nhất của Mây Senkou A và Mây Senkou B
void GetMinMaxSenkouValues(double &outMin, double &outMax) {
 
double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN,0);
double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN,0 );
 if(senkouA > senkouB){
    outMax = senkouA;
    outMin = senkouB;
 }else{
    outMax = senkouB;
    outMin = senkouA;
 }

}

// Hàm kiểm tra xem 3 cây nến gần nhất có chạm vào band trên của Bollinger Bands hay không
bool AreLast3CandlesTouchingUpperBandIsBuy() {

    for (int i = 0; i < 3; i++) {
   
        double upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
        double candleHigh = High[i];
        
        if (candleHigh > upperBand) {
            return true; // Có ít nhất 1 cây nến chạm vào band trên
        }
    }
    
    return false; // Không có cây nến nào chạm vào band trên
}




bool AreLast3CandlesTouchingUpperBandIsSell() {
    double lowerBand;

    for (int i = 0; i < 2; i++) {
      
       lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
        double candleLow = Low[i];
        if (candleLow < lowerBand) {
            return true; // Có ít nhất 1 cây nến chạm vào band dưới
        }
    }
    
    return false; // Không có cây nến nào chạm vào band trên
}

bool IsSenkouCloudWithin20Pips() {
    bool Pips = true;
    for (int i = 0; i < 4; i++) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, i);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
     if(pipDistance < IsSenkouCloudWithin20Pips){
        Pips =  false;
     }
    }
    return Pips;
}

bool IsSenkouCloudWithin20PipsLog() {
    bool Pips = true;
    for (int i = 0; i < 4; i++) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, i);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
    printf("pipDistancepipDistancepipDistancepipDistancepipDistancepipDistancepipDistance"+pipDistance);
     if(pipDistance < IsSenkouCloudWithin20Pips){
        Pips =  false;
     }
    }
    return Pips;
}

double checkIsSenkouCloudWithin20Pips() {

    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, 0);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, 0);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
     
    return pipDistance;
}

void CheckEMATrade() {
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double openPrice = Open[1];
    double closePrice = Close[1];
    double openPriceNow = Open[0];
    double pipDifference = MathAbs(openPriceNow - ema50) / 0.1;
    double ichimokuTenkan = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 3);
    
    double pipDifferenceEMA = MathAbs(ema50 - ichimokuTenkan) / 0.1;
    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double PreviousCandleLow = iLow(NULL, 0, 1);
 
     if (pipDifference >= 5 && pipDifferenceEMA > 15 
      && ((PreviousCandleHigh - PreviousCandleLow)/0.1) <  45
      ) {
       if (openPrice < ema50 
       && ichimokuTenkan < ema50
       //&& IsSenkouCloudWithin20Pips()
       && IsCandleBuyEMA()
       && closePrice > ema50) {
             printf("IsPriceCrossing7EMA50IsPriceCrossing7EMA50IsPriceCrossing7EMA50"+IsPriceCrossing7EMA50());
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
       }
       else if (openPrice > ema50 
       // && IsSenkouCloudWithin20Pips()
        && ichimokuTenkan > ema50
        && IsCandleSellEMA()
        && closePrice < ema50) {
           OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
       }
    } 
    
}

bool IsCandleSell() {
     double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
     double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
     
     double ichimokuTenkan = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 3);
     double ichimokuKIJUN = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 3);
     double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
     double pipDifferenceEMATENKAN = MathAbs(ema50 - ichimokuTenkan) / 0.1;
     double pipDifferenceEMA = MathAbs(ema50 - currentPrice) / 0.1;
    
      double pipDifferenceEMAKIJUN = MathAbs(ema50 - ichimokuKIJUN) / 0.1;
      double bollingerlowH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);
      double bollingerlow =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);
      double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
      double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 0);
      double ichimokuTenkan5 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
      
      double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
      
      double pipDifferenceTenkan = MathAbs(ichimokuTenkanNow - ichimokuTenkan5) / 0.1;
      double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;
      
      double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
      double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
      
      double PreviousCandleHigh = iHigh(NULL, 0, 1);
      double PreviousCandleLow = iLow(NULL, 0, 1);
      double PreviousCandleHigh2 = iHigh(NULL, 0, 2);
      double PreviousCandleLow2 = iLow(NULL, 0, 2);
      
      double ichimokuTenkan1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
      double ichimokuKijun1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
      double bollingerMiddle =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

      double previousClose = iClose(Symbol(), Period(), 1);
      double previousOpen =  iOpen(Symbol(), Period(), 1);
      
      double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
      double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);
    
      
      double valueSell = ((GetMin(ichimokuTenkan1, ichimokuKijun1, bollingerMiddle) - previousClose) /0.1);
      double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

      if(previousClose > previousOpen ){
       return false;
      }
      
      if(MathAbs(ema50 - ema200)/0.1 < 7 && senkouA > senkouB ){
        return false;
      }
      
      if(PreviousCandleLow < bollingerlowH1){
         //return false;
      }
      
       if(MathAbs(PreviousCandleLow - bollingerlowH1)/0.1 < 7){
         //return false;
      }
     
      if(MathAbs(valuePreviousSell) < 3){
         return false;
      }
      
       if((senkouA - senkouB) >= (senkouA2 - senkouB2) && AreTenkanKijunCrossing() ){
        return false;
      }
     
      if((senkouA - senkouB)/0.1 >= 100 && AreTenkanKijunCrossing() ){
        return false;
      }

      if((senkouA - senkouB) >= (senkouA2 - senkouB2) && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
        return false;
      }
      
      if(pipDifferenceTenkan < InputpipDifferenceEMA && (senkouA - senkouB )/0.1 > senkouBNsenkouA && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN < InputpipDifferenceEMA && (senkouA - senkouB )/0.1 > senkouBNsenkouA && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN < InputpipDifferenceEMA && (senkouA - senkouB) >= (senkouA2 - senkouB2)  ){
         return false;
      }
      
      if(pipDifferenceTenkan < InputpipDifferenceEMA && (senkouA - senkouB) >= (senkouA2 - senkouB2)  ){
         return false;
      }
      
      if(MathAbs(ichimokuTenkanNow - ichimokuKIJUNNow)/0.1 < 3 ){
         return false;
      }
      
      if(MathAbs(PreviousCandleHigh - PreviousCandleLow)/0.1 > 25 ){
         return false;
      }
      
      if(MathAbs(PreviousCandleHigh2 - PreviousCandleLow2)/0.1 > 25 ){
         return false;
      }
      
      if(pipDifferenceEMAKIJUN  < InputpipDifferenceEMA  && pipDifferenceKIJUN < pipDiffIchi){
         return false;
      }
      
      if(pipDifferenceEMATENKAN  < InputpipDifferenceEMA && pipDifferenceTenkan < pipDiffIchi ){
         return false;
      }
      
      if( AreTenkanKijunCrossing() && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA ){
        return false;
      }
      
      if(pipDifferenceEMAKIJUN  < InputpipDifferenceEMA  && ((senkouA - senkouB )/0.1) < senkouBNsenkouA){
         return false;
      }
      
      if(pipDifferenceEMATENKAN  < InputpipDifferenceEMA && ((senkouA - senkouB )/0.1) < senkouBNsenkouA){
         return false;
      }
      
      if((senkouB - senkouA )/0.1 >= 75 && AreTenkanKijunCrossing() && MathAbs(currentPrice - bollingerlow)/0.1 < 5 ){
        return false;
      }
      
    
      
      if(senkouA > senkouB  && CheckEMACross()){
         return false;
      }
      

      //2023-08- 24

      if(senkouA > senkouB  && AreEMA50EMA200Crossing()){
       //  return false;
      }

      if(IsPriceCrossing7EMA200() ){
         //return false;
      }

     if(IsPriceCrossing7EMA50() && IsPriceCrossing14EMA200() ){
        return false;
      }

      if(CheckBollingerLOWERCross()  && AreLast3CandlesTouchingUpperBandIsSell()){
         return false;
      }

      if(AreTenkanKijunCrossing() && pipDifferenceKIJUN < 4){
         return false;
      }
      
       if((senkouA - senkouB) >= (senkouA2 - senkouB2)   
          && AreLast3CandlesTouchingUpperBandIsSell()
          && IsPriceCrossingEMA50() ){
   
        return false;
      }

      if(senkouB > senkouA 
          && AreEMA50TenkanSenrossing14()
          && IsPriceCrossingEMA5014() ){
          return false;
      }

      if( AreLast3CandlesTouchingUpperBandIsSell() && AreEMA50EMA200Crossing()){
           return false;
      }

      return true;

}

bool IsCandleBuy() {
      double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
      double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
      
      double ichimokuTenkan = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 3);
      double ichimokuKIJUN = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 3);
      double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
      double pipDifferenceEMATENKAN = MathAbs(ema50 - ichimokuTenkan) / 0.1;
      double pipDifferenceEMA = MathAbs(ema50 - currentPrice) / 0.1;
      double bollingerUperH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 0);
      double bollingerUper =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 0);
      double pipDifferenceEMAKIJUN = MathAbs(ema50 - ichimokuKIJUN) / 0.1;
     
      double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
      double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 0);
      double ichimokuTenkan5 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
      
      double pipDifferenceTenkan = MathAbs(ichimokuTenkanNow - ichimokuTenkan5) / 0.1;
      
      double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
      
      double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;
      
      double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
      double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
      
      double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
      double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);
    
      double PreviousCandleHigh = iHigh(NULL, 0, 1);
      double PreviousCandleLow = iLow(NULL, 0, 1);
      double PreviousCandleHigh2 = iHigh(NULL, 0, 2);
      double PreviousCandleLow2 = iLow(NULL, 0, 2);
      
      double ichimokuTenkan1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
      double ichimokuKijun1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
      double bollingerMiddle =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

      double previousClose = iClose(Symbol(), Period(), 1);
      double previousOpen =  iOpen(Symbol(), Period(), 1);

      double valueBUY = ((previousClose - GetMax(ichimokuTenkan1, ichimokuKijun1,bollingerMiddle)) / 0.1);
      double valuePreviousBUY = ((previousClose - previousOpen) / 0.1);

      if(MathAbs(PreviousCandleHigh - bollingerUperH1)/0.1 < 7){
          return false;
      }
      
      if(MathAbs(ema50 - ema200)/0.1 < 7 && senkouA > senkouB ){
        return false;
      }
      
      if(PreviousCandleHigh >  bollingerUperH1){
         // return false;
      }
      
      if(MathAbs(valuePreviousBUY) < 3){
          return false;
      }
          
      if((senkouB-senkouA) >= (senkouB2 - senkouA2 ) && AreTenkanKijunCrossing() ){
   
        return false;
      }
      
      if( AreTenkanKijunCrossing() && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA ){
        return false;
      }

      if( (senkouB-senkouA) >= (senkouB2 - senkouA2 ) && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA ){
        return false;
      }
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA&& (senkouB - senkouA)/0.1 > MaxPipPreviou && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA&& (senkouB - senkouA)/0.1 > MaxPipPreviou && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA&& (senkouB-senkouA) >= (senkouB2 - senkouA2 )  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA&& MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
         return false;
      }
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA&& MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
         return false;
      }
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA&& (senkouB-senkouA) >= (senkouB2 - senkouA2 )  ){
         return false;
      }
      
      if(MathAbs(ichimokuTenkanNow - ichimokuKIJUNNow)/0.1 < 3 ){
         return false;
      }
      
      if(MathAbs(PreviousCandleHigh - PreviousCandleLow)/0.1 > MaxPipPreviou ){
         return false;
      }
      
      if(MathAbs(PreviousCandleHigh2 - PreviousCandleLow2)/0.1 > MaxPipPreviou ){
         return false;
      }
      
      if((senkouA - senkouB)/0.1 >= 100 && AreTenkanKijunCrossing() ){
        return false;
      }
      
      if((senkouA - senkouB)/0.1 >= 75 && AreTenkanKijunCrossing() && MathAbs(currentPrice - bollingerUper)/0.1 < 5 ){
        return false;
      }
      
      if(pipDifferenceEMAKIJUN  <InputpipDifferenceEMA && pipDifferenceKIJUN < pipDiffIchi){
         return false;
      }
      
      if(pipDifferenceEMATENKAN  <InputpipDifferenceEMA && pipDifferenceTenkan < pipDiffIchi ){
         return false;
      }
      
      if(pipDifferenceEMAKIJUN  <InputpipDifferenceEMA && ((senkouB - senkouA)/0.1) < senkouBNsenkouA){
         return false;
      }
      
      if(pipDifferenceEMATENKAN  <InputpipDifferenceEMA&& ((senkouB - senkouA )/0.1) < senkouBNsenkouA){
         return false;
      }

      if(senkouB > senkouA   && AreEMA50EMA200Crossing()){
         //return false;
      }
      
       if(senkouB > senkouA  && CheckEMACross()){// 500
         return false; 
      }
      // 2023-08-24

      if(IsPriceCrossing7EMA200()){
        // return false;
      }

      if(IsPriceCrossing7EMA50() && IsPriceCrossing14EMA200() ){
        return false;
      }

      if(AreTenkanKijunCrossing() && pipDifferenceKIJUN < 4){
         return false;
      }

      if(AreTenkanKijunCrossing() && pipDifferenceTenkan < 4){
         return false;
      }

      if(AreTenkanKijunCrossing()  && AreLast3CandlesTouchingUpperBandIsBuy()){
         return false;
      }

      if(CheckBollingerUPPERCross()  && AreLast3CandlesTouchingUpperBandIsBuy()){
         return false;
      }

      if((senkouB-senkouA) >= (senkouB2 - senkouA2 ) 
          && AreLast3CandlesTouchingUpperBandIsBuy()
          && IsPriceCrossingEMA50() ){
   
        return false;
      }

      if(senkouB > senkouA 
          && AreEMA50TenkanSenrossing14()
          && IsPriceCrossingEMA5014() ){
          return false;
      }
      
      if( AreLast3CandlesTouchingUpperBandIsBuy() && AreEMA50EMA200Crossing()){
           return false;
      }

      return true;

}

bool IsCandleBuyRSI() {
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double previousClose = iClose(Symbol(), Period(), 1);
    double previousOpen =  iOpen(Symbol(), Period(), 1);
    double valuePreviousBUY = ((previousClose - previousOpen) / 0.1);

    if(ema200 > currentPrice  && IsPriceCrossingEMA200()){
     return false;
    }
    
    if(ema50 > currentPrice  && IsPriceCrossingEMA50()){
     return false;
    }

    if(MathAbs(valuePreviousBUY) < 3){
          return false;
    }
    
    return true;
}

bool IsCandleSellRSI() {
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double previousClose = iClose(Symbol(), Period(), 1);
    double previousOpen =  iOpen(Symbol(), Period(), 1);
    double valuePreviousSell = ((previousClose - previousOpen) / 0.1);

    if(currentPrice > ema200  && IsPriceCrossingEMA200()){
     return false;
    }
    
    if(currentPrice > ema50 && IsPriceCrossingEMA50()){
     return false;
    }
    
    if(MathAbs(valuePreviousSell) < 3){
          return false;
    }

    return true;
}

bool IsCandleBuyEMA() {
  double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
  double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
  double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);   
  double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
  double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);


  if((senkouB -senkouA) /0.1 >150 ){
   return false;
  }
  
  if(senkouB > senkouA   && AreEMA50EMA200Crossing()){
         return false;
  }

  if(IsPriceCrossing7EMA200()  ){
        return false;
  }

  if(IsPriceCrossing7EMA50()  ){
        return false;
  }

  if(AreTenkanKijunCrossing()  ){
        return false;
  }

  return true;
}

bool IsCandleSellEMA() {
  double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
  double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
      
  double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
  double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);
   
  if( (senkouA -senkouB) /0.1 >150 ){
   return false;
  }
  
  if(senkouA > senkouB  && AreEMA50EMA200Crossing()){
         return false;
  }

  if(IsPriceCrossing7EMA200() ){
           return false;
  }

   if(IsPriceCrossing7EMA50()  ){
        return false;
  }

  if(AreTenkanKijunCrossing()  ){
        return false;
  }
  return true;
}

bool AreTenkanKijunCrossing() {
    double tenkanSen[9];
    double kijunSen[9];

    for (int z = 0; z < 9; z++) {
        tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
        kijunSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
    }

    for (int i = 0; i < 8 ; i++) {
        if ((tenkanSen[i - 1] > kijunSen[i - 1] && tenkanSen[i] <= kijunSen[i]) ||
            (tenkanSen[i - 1] < kijunSen[i - 1] && tenkanSen[i] >= kijunSen[i])) {
            return true; // Đường Tenkan-sen và Kijun-sen cắt nhau
        }
    }

    return false; // Không có cắt nhau
}

bool IsPriceCrossingEMA200() {
     for (int i = 0; i < 40 ; i++) {
        double closePrice = Close[i];
        double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema200 && PreviousCandleLow <= ema200)) {
            return true; // Giá cắt qua đường EMA 200 trong 40 cây nến gần nhất
        }
    }

    return false; // Không có cắt qua
}

bool IsPriceCrossing7EMA200() {
     
    for (int i = 0; i < 7; i++) {
        double closePrice = Close[i];
        double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema200 && PreviousCandleLow <= ema200)) {
            return true; // Giá cắt qua đường EMA 200 trong 40 cây nến gần nhất
        }
    }

    return false; // Không có cắt qua
}

bool IsPriceCrossing14EMA200() {
     
    for (int i = 0; i < 15; i++) {
        double closePrice = Close[i];
        double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema200 && PreviousCandleLow <= ema200)) {
            return true; // Giá cắt qua đường EMA 200 trong 40 cây nến gần nhất
        }
    }

    return false; // Không có cắt qua
}


bool IsPriceCrossing7EMA50() {
     
    int a = 0;
    for (int i = 2; i < 9; i++) {
        double closePrice = Close[i];
        double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema50 && PreviousCandleLow <= ema50)) {
             return true;
        }
    }
   
    return false; // Không có cắt qua
}

bool IsPriceCrossingEMA50() {

    for (int i = 0; i < 10; i++) {
        double closePrice = Close[i];
        double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema50 && PreviousCandleLow <= ema50)) {
             return true;
        }
    }
   
    return false; // Không có cắt qua
}

bool IsPriceCrossingEMA5014() {

    for (int i = 0; i < 14; i++) {
        double closePrice = Close[i];
        double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema50 && PreviousCandleLow <= ema50)) {
             return true;
        }
    }
   
    return false; // Không có cắt qua
}
bool AreEMA50TenkanSenrossing() {
    double ema50[7];
    double tenkanSen[7];

    for (int z = 0; z < 7; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
    }

    for (int i = 1; i < 7; i++) {
        if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
            (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool AreEMA50TenkanSenrossing14() {
    double ema50[14];
    double tenkanSen[14];

    for (int z = 0; z < 14; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
    }

    for (int i = 1; i < 14; i++) {
        if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
            (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool AreEMA50EMA200Crossing() {
    double ema50[20];
    double ema200[20];

    for (int z = 0; z < 20; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        ema200[z] = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, z);
    }

    for (int i = 1; i < 20; i++) {
        if ((ema50[i - 1] > ema200[i - 1] && ema50[i] <= ema200[i]) ||
            (ema50[i - 1] < ema200[i - 1] && ema50[i] >= ema200[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool CheckBollingerUPPERCross() {
   double upper20[20];
    double upper80[20];

    for (int z = 0; z < 20; z++) {
        upper20[z] = iBands(Symbol(), Period(), 20, 2.0, 0,PRICE_CLOSE, MODE_UPPER, z);
        upper80[z] = iBands(Symbol(), Period(), 80, 2.0, 0,PRICE_CLOSE, MODE_UPPER, z);
    }

    for (int i = 1; i < 20; i++) {
        if ((upper20[i - 1] > upper80[i - 1] && upper20[i] <= upper80[i]) ||
            (upper20[i - 1] < upper80[i - 1] && upper20[i] >= upper80[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool CheckBollingerLOWERCross() {
   double upper20[20];
    double upper80[20];

    for (int z = 0; z < 20; z++) {
        upper20[z] = iBands(Symbol(), Period(), 20, 2.0, 0,PRICE_CLOSE, MODE_LOWER, z);
        upper80[z] = iBands(Symbol(), Period(), 80, 2.0, 0,PRICE_CLOSE, MODE_LOWER, z);
    }

    for (int i = 1; i < 20; i++) {
        if ((upper20[i - 1] > upper80[i - 1] && upper20[i] <= upper80[i]) ||
            (upper20[i - 1] < upper80[i - 1] && upper20[i] >= upper80[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool CheckEMACross() {
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double pipValue = MarketInfo(Symbol(), MODE_POINT);
    double allowedDeviation = 5 * 0.1;

    for (int i = 0; i < 3; i++) {
        double closePrice = iClose(Symbol(), Period(), i);

        if (MathAbs(closePrice - ema50) <= allowedDeviation) {
            return true;  // Có nến chạm EMA50 trong khoảng sai số 5 pip
        }
    }

    return false;  // Không có nến nào chạm EMA50 trong khoảng sai số 5 pip
}