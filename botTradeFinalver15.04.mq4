input double lotSize = 0.05;
input double tiencLhotLoi = 10;// tiền chốt lời
input double tienDownTrend = -10; // âm quá tiền thì đánh ngược nếu đủ dk
input double MaxPipPreviou = 19; // cây nến trước nó đủ dk mà quá 19pip thì ko đánh nửa
input double MinPipPreviou = 2;
input double MaxPipBand = 10;
input double MaxPipichimoku = 12;// cách ichimoku xa quá củng không đánh vd 12pip
input double PipNhoiLen = 20;//số pip nhồi lện 
input double lotSizeNhoiLen = 0.03;//số lot nhồi lện 
input int MAxLenNhoi = 9;//số lện nhồi tối đa
input int  MaxCHIKOUSPAN = 280;
input int IsPriceAboveSenkouABy11Pips = 4; //xem giá hiện tại có nằm trên Mây Senkou A dưới 11 pip hay không
input int GapMinute = 1;  //cách bao nhiêu cây nến thì đánh
input int IsSenkouCloudWithin20Pips = 28;//mây rộng bao nhiêu thì đánh
input int IsSenkouCloudWithin20PipsPAN = 5;//mây rộng bao nhiêu thì đánh

input int MaxOrderrsi = 75;//lớn hơn bao nhiêu thì BUY Lện Chính
input int MinOrderrsi = 18;//nhỏ hơn bao nhiêu thì SELL Lện Chính

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
  
    double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ichimokuTenkan = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 3);
    double ichimokuKIJUN = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 3);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double pipDifferenceEMATENKAN = MathAbs(ema50 - ichimokuTenkan) / 0.1;
     double pipDifferenceEMA = MathAbs(ema50 - currentPrice) / 0.1;
    
    double pipDifferenceEMAKIJUN = MathAbs(ema50 - ichimokuKIJUN) / 0.1;
    
    //if( pipDifferenceEMAKIJUN > 8 && pipDifferenceEMATENKAN > 8 ){
    //if(pipDifferenceEMA > 7){
    
         OpenTrade();
   //  }
 
    // }
   
  }
  
 if (CountOrdersWithMagic(9999) < 1) {
        MaxMinOderRSI();
     
       }
   
     if (CountOrdersWithMagic(9999) < 1) {
        CheckEMATrade();
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

  if (totalProfit < tienDownTrend) {
    //OpenTradeDownTrend();
  }
  double totalProfitDownTrend =  CalculateTotalProfitDownTrend();
  if (totalProfitDownTrend > tiencLhotLoi) {
    CloseProfitableOrdersDownTrend();
  }
  
}

void MaxMinOderRSI() {
   double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
    double ichimokuCHIKOUSPAN = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_CHIKOUSPAN, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double previousClose = iClose(Symbol(), Period(), 1);
    double previousOpen =  iOpen(Symbol(), Period(), 1);
    
      if(rsiValue > MaxOrderrsi 
      && ((ichimokuCHIKOUSPAN - currentPrice)/0.1) > MaxCHIKOUSPAN
      && previousOpen >  previousClose
      && IsSenkouCloudWithin20Pips()
      ){
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
      }else if(rsiValue < MinOrderrsi
      && ((currentPrice - ichimokuCHIKOUSPAN)/0.1) > MaxCHIKOUSPAN
      && previousOpen <  previousClose
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
    double ichimokuTenkan6 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, 6);
    
    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double PreviousCandleLow = iLow(NULL, 0, 1);
    double pointSize = MarketInfo(OrderSymbol(), MODE_POINT);

    double valueSell = ((GetMin(ichimokuTenkan, ichimokuKijun, bollingerMiddle) - previousClose) /0.1);

    double valueBUY = ((currentPrice - GetMax(ichimokuTenkan, ichimokuKijun,bollingerMiddle)) / 0.1);
    
    double pricePrevious = (MathAbs(previousClose - previousOpen) / 0.1);
    double TenkanPrevious = (MathAbs(ichimokuTenkan6 - ichimokuTenkan) / 0.1);
    
    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou && pricePrevious > MinPipPreviou && TenkanPrevious > 5 ) {
      if (previousClose < ichimokuTenkan 
         && previousClose < ichimokuKijun 
         &&previousClose < bollingerMiddle) {
        // Open a Sell trade
        if (valueSell < MaxPipichimoku && valueSell > 3 
           && AreLast3CandlesTouchingUpperBandIsSell()
           &&IsSenkouCloudWithin20Pips()
            && rsiValue > MaxrsiSEll
            && IsPriceAboveSenkouABy11Pips(false)) {
          MainIsBuy = false;
          // printf("CalculateAverageVolumeCalculateAverageVolumeCalculateAverageVolumeCalculateAverageVolume"+(ichimokuTenkan6-ichimokuTenkan)/0.1);
          OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
        }
      } else if (previousClose > ichimokuTenkan &&
                 previousClose > ichimokuKijun &&
                 previousClose > bollingerMiddle) {
        // Open a Buy trade

        if (valueBUY < MaxPipichimoku && valueBUY > 3 
           && IsPriceAboveSenkouABy11Pips(true) 
           && IsSenkouCloudWithin20Pips()
           && rsiValue < MaxrsiBuy
           && AreLast3CandlesTouchingUpperBandIsBuy()
         ){
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

    double previousOpen =  iOpen(Symbol(), Period(), 1);
    
     double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
    
    previousClosePrice = previousClose;
    double ichimokuTenkan = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
    double ichimokuKijun = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
    double bollingerMiddle = iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_SMA, 0);

    double PreviousCandleHigh = iHigh(NULL, 0, 1);
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    double PreviousCandleLow = iLow(NULL, 0, 1);
    double pointSize = MarketInfo(OrderSymbol(), MODE_POINT);

    double valueSell =((GetMin(ichimokuTenkan, ichimokuKijun, bollingerMiddle) -previousClose) /0.1);

    double valueBUY = ((currentPrice - GetMax(ichimokuTenkan, ichimokuKijun, bollingerMiddle)) /0.1);

    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou) {
      if (previousClose < ichimokuTenkan 
         && previousClose < ichimokuKijun 
         && previousClose < bollingerMiddle) {
        // Open a Sell trade
        if (valueSell < MaxPipichimoku && valueSell > 3 
            && AreLast3CandlesTouchingUpperBandIsSell()
            &&IsSenkouCloudWithin20Pips()
            && rsiValue > MaxrsiSEll
            && IsPriceAboveSenkouABy11Pips(false)) {
          if (MainIsBuy == true) {
          
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 8888,clrNONE);
          }
        }
      } else if (previousClose > ichimokuTenkan &&
                 previousClose > ichimokuKijun &&
                 previousClose > bollingerMiddle) {
        // Open a Buy trade

        if (valueBUY < MaxPipichimoku && valueBUY > 3 
           && IsPriceAboveSenkouABy11Pips(true) 
           && IsSenkouCloudWithin20Pips()
           && rsiValue < MaxrsiBuy
           && AreLast3CandlesTouchingUpperBandIsBuy()) {
          if (MainIsBuy == false) {
         
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 8888,clrNONE);
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

// Hàm kiểm tra xem giá hiện tại có nằm trên Mây Senkou A dưới 11 pip hay không
bool IsPriceAboveSenkouABy11Pips(bool isBuy) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, 0);
    
    double minSenkou, maxSenkou;
    
    GetMinMaxSenkouValues(minSenkou, maxSenkou);
    
    double currentPrice = Ask; // Giá hiện tại (Ask)
    
    double pipDistance = 0; // Khoảng cách tính bằng pip

    if(isBuy){
    pipDistance = (currentPrice - maxSenkou) / Point;
    }else{
     pipDistance = (minSenkou - currentPrice ) / Point;
    }
    
    return (pipDistance > IsPriceAboveSenkouABy11Pips);
    
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
    double upperBand;

    for (int i = 1; i < 2; i++) {
   
        upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
        double candleHigh = High[i];
        
      //  printf("candleHighcandleHighcandleHighcandleHigh"+MathAbs(candleHigh - upperBand)/0.1);
           if (MathAbs(candleHigh - upperBand)/0.1 < MaxPipBand) {
            return false; // Có ít nhất 1 cây nến chạm vào band trên
          }
        
       
        if (candleHigh > upperBand) {
            return false; // Có ít nhất 1 cây nến chạm vào band trên
        }
    }
    
    
    return true; // Không có cây nến nào chạm vào band trên
}

bool AreLast3CandlesTouchingUpperBandIsSell() {
    double lowerBand;

    for (int i = 1; i < 2; i++) {
      
       lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
       double candleLow = Low[i];
        
       if (MathAbs(candleLow - lowerBand)/0.1 < MaxPipBand) {
            return false; // Có ít nhất 1 cây nến chạm vào band dưới
          }
        
        
        
        if (candleLow < lowerBand) {
            return false; // Có ít nhất 1 cây nến chạm vào band dưới
        }
    
    }
    
    return true; // Không có cây nến nào chạm vào band trên
}

bool IsSenkouCloudWithin20PipsPAN() {
    bool Pips = true;
    for (int i = 0; i < 4; i++) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, i);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
     if(pipDistance < IsSenkouCloudWithin20PipsPAN){
        Pips =  false;
        
     }
    }
 
    return Pips;
}

bool IsSenkouCloudWithin20Pips() {
    bool Pips = true;
    for (int i = 0; i < 4; i++) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, i);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
     if(pipDistance < IsSenkouCloudWithin20Pips){
        Pips =  false;
        
     }
    }
    if(!IsSenkouCloudWithin20PipsPAN()){
       Pips =  false;
    }
    return Pips;
}

bool IsSenkouCloudWithin20PipsLog() {
    bool Pips = true;
    for (int i = 0; i < 4; i++) {
    double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, i);
    double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, i);
    
    double pipDistance = MathAbs(senkouA - senkouB) / 0.1; // Khoảng cách tính bằng pip
    //printf("pipDistancepipDistancepipDistancepipDistancepipDistancepipDistancepipDistance"+pipDistance);
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
 
    double ichimokuCHIKOUSPAN = Close[52];
    double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
    
    double CHIKOUSPANPriceNow = ((currentPrice - ichimokuCHIKOUSPAN)/0.1);
    double pipDifferenceEMA = MathAbs(ema50 - ichimokuTenkan) / 0.1;
    
    double PreviousCandleHigh = iHigh(NULL, 0, 1);

    double PreviousCandleLow = iLow(NULL, 0, 1);
 
     if (pipDifference >= 5 && pipDifferenceEMA > 15 
      && ((PreviousCandleHigh - PreviousCandleLow)/0.1) <  45
      ) {
       if (openPrice < ema50 
       && ichimokuTenkan < ema50
       && IsSenkouCloudWithin20Pips()
       && closePrice > ema50) {
          
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
       }
       else if (openPrice > ema50 
        && IsSenkouCloudWithin20Pips()
        && ichimokuTenkan > ema50
        && closePrice < ema50) {
           OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
       }
    } 
    
}

double CalculateAverageVolume(int startBar, int period) {
    double totalVolume = 0;

    for (int i = startBar; i > startBar - period; i--) {
        totalVolume += Volume[i];
    }

    double averageVolume = totalVolume / period;
    return averageVolume;
}

 