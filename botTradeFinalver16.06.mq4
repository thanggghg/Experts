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
input int totalProfitCutOffPoint = 8;//âm tới StopDCAPrice thì pip DCA sẽ khác

bool ShouldEnterTrade = False;
bool EntryPrice = false;
bool MainIsBuy = False; 
datetime TimeClose = 0;
double previousClosePrice = 0.0;

double lastPIP = 0.0;
double tp_buy = 0;
double tp_sell = 0;
void OnTick(void) {
  datetime currentTime = iTime(Symbol(), Period(), 1);
  int candleHour = TimeHour(currentTime);
   if(TimeClose==0){
     TimeClose = iTime(Symbol(), Period(), 0);
  }
   if ((iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
       OpenTrade();
   }

  if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
  
    if (CountOrdersWithMagic(9999) < 1) {
         CheckEMATrade();
     }
  }

   if ((iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
     if (CountOrdersWithMagic(9999) < 1) {
        MaxMinOderRSI();
     }
   }
   
   if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
    if (CountOrdersWithMagic(9999) < 1) {
        CheckPivotStrategy();
     }
   }
   
   if ( (iTime(Symbol(),Period(),0)-TimeClose) > 15*60*GapMinute  ) {
    if (CountOrdersWithMagic(9999) < 1) {
        CheckMadridRibbon();
     }
   }
  
   int totalOrders = OrdersTotal();
   double totalProfit = CalculateTotalProfit();
   
   if(totalProfit > totalProfitCutOffPoint){
    EntryPrice =true;
   }
  //CheckAndCloseExpiredLossOrders();
  
  if(totalOrders <MAxLenNhoi && totalProfit > StopDCAPrice ){
    ShouldDCA();
  }
  
  if( CalculateNegativePips() > pipDCAIfMax && totalOrders <MAxLenNhoi ){
     ShouldDCA();
  }
//---

  if(TimeClose==0){
     TimeClose = iTime(Symbol(), Period(), 0);
  }

  if (totalProfit > tiencLhotLoi) {
     TimeClose = iTime(Symbol(), Period(), 0);
    CloseProfitableOrders();
  }

  if (totalProfit < 2 && EntryPrice == true && totalProfit > 0) {
     TimeClose = iTime(Symbol(), Period(), 0);
    CloseProfitableOrders();
  }

    if (CountOrdersWithMagic(9999) > 3 && totalProfit > 0 ) {
       CloseProfitableOrders();
  }
  
   double tpbuy = binhquangiabuy(tiencLhotLoi);
   double tpsell = binhquangiasell(tiencLhotLoi);
   
   if(tpbuy != tp_buy){tp_buy = tpbuy; ObjectDelete(0,"tpbuy"); nutbam_thanhngang("tpbuy",tp_buy,clrLime,3);}
    if(dem_so_lenh_hien_co("tong buy") == 0){ObjectDelete(0,"tpbuy");}
   if(tpsell != tp_sell){tp_sell = tpsell; ObjectDelete(0,"tpsell"); nutbam_thanhngang("tpsell",tp_sell,clrRed,3);}
    if(dem_so_lenh_hien_co("tong sell") == 0){ObjectDelete(0,"tpsell");}
  
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
        printf("IsCandleSellRSI");
        EntryPrice =false;
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
      }else if(rsiValue < MinOrderrsi
      && previousOpen <  previousClose
      && IsCandleBuyRSI()
      && IsSenkouCloudWithin20Pips() 
      ){
          printf("IsCandleBuyRSI");
           EntryPrice =false;
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
    double s3Value = GetS3Value(); // Lấy giá trị S3 từ hàm GetS3Value()
    double r3Value = GetR3Value(); // Lấy giá trị R3 từ hàm GetR3Value()

    if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < MaxPipPreviou) {
      if (
        // previousClose < ichimokuTenkan 
        //  &&
          previousClose < ichimokuKijun 
        //  &&previousClose < bollingerMiddle
         ) {
        // Open a Sell trade
        if ( valueSell > 3 
            && IsCandleSell()
            && rsiValue > MaxrsiSEll
            && currentPrice > s3Value
            ) {
              printf("IsCandleSell");
               EntryPrice =false;
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
        }
      }else if( 
        // previousClose > ichimokuTenkan 
                // &&
                 previousClose > ichimokuKijun 
                // && previousClose > bollingerMiddle
                ) {
        // Open a Buy trade
        if ( valueBUY > 3 
         //  && IsPriceAboveSenkouABy11Pips(true) 
           && IsCandleBuy()
           && rsiValue < MaxrsiBuy
           && currentPrice < r3Value
           ) {
           printf("IsCandleBuy");
            EntryPrice =false;
          OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
        }
      }
    }
  }
}

void CheckMadridRibbon()
{
   double s3Value = GetS3Value(); // Lấy giá trị S3 từ hàm GetS3Value()
   double r3Value = GetR3Value(); // Lấy giá trị R3 từ hàm GetR3Value()

   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double PreviousCandleHigh = iHigh(NULL, 0, 1);
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
   double PreviousCandleLow = iLow(NULL, 0, 1);
   double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
   // Kiểm tra nếu giá chạm mức S3, thì thực hiện mua
   if (((PreviousCandleHigh - PreviousCandleLow) / 0.1) < 30) {
      if ( checkTrend(clrGreen) || checkTrendUptrend(clrGreen))
      {
         if(IsCandleBuyRibbon() && rsiValue < MaxrsiBuy ){
            printf("IsCandleBuyRibbon");
             EntryPrice =false;
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
         }
      } else if ( checkTrend(clrRed) || checkTrendUptrend(clrRed))
      {
         if(IsCandleSellRibbon() && rsiValue > MaxrsiSEll ){
             printf("IsCandleSellRibbon");
              EntryPrice =false;
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
         }
      }
   }
}


void CheckPivotStrategy() 
{
   double s3Value = GetS3Value(); // Lấy giá trị S3 từ hàm GetS3Value()
   double r3Value = GetR3Value(); // Lấy giá trị R3 từ hàm GetR3Value()

   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double PreviousCandleHigh = iHigh(NULL, 0, 1);
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);
   double PreviousCandleLow = iLow(NULL, 0, 1);

   // Kiểm tra nếu giá chạm mức S3, thì thực hiện mua
   if(MathAbs(previousClose -previousOpen)/0.1 > 2 && ((PreviousCandleHigh - PreviousCandleLow) / 0.1) < 35  ){
      if (previousClose <= s3Value)
      { 
      
         bool Istrue = false;
          for (int z = 0; z < 9; z++) {
                  double iLowNow = iLow(NULL, 0, z);
                if(iLowNow > s3Value  ) {
                  Istrue = true;
                }
          }

         if(IsCandleBuyPivot() && Istrue){
           printf("IsCandleBuyPivot");
            EntryPrice =false;
           OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);

         }
         Istrue = false;
      } else if (previousClose >= r3Value)
      {
          bool Istruer3 = false;
          for (int A = 0; A < 9; A++) {
                  double HighNow = iHigh(NULL, 0, A);
                if(HighNow < r3Value) {
                  Istruer3 = true;
                }
          }

         if(IsCandleSellPivot() && Istruer3 ){
             printf("IsCandleSellPivot");
              EntryPrice =false;
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "", 9999,clrNONE);
         }
         Istruer3 = false;
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
  double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  
  if (previousClosePrice != previousClose) {
    previousClosePrice = previousClose;
   
    if (CheckOrderType() == 1) {
      if(currentPrice)
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
   return 0;
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


// Hàm kiểm tra xem 3 cây nến gần nhất có chạm vào band trên của Bollinger Bands hay không
bool AreLast5CandlesTouchingUpperBandIsBuy() {

    for (int i = 0; i < 5; i++) {
   
        double upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
        double candleHigh = High[i];
        
        if (candleHigh > upperBand) {
            return true; // Có ít nhất 1 cây nến chạm vào band trên
        }
    }
    
    return false; // Không có cây nến nào chạm vào band trên
}


bool AreLast4CandlesTouchingUpperBandIsSell() {
    double lowerBand;

    for (int i = 0; i < 4; i++) {
      
       lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
        double candleLow = Low[i];
        if (candleLow < lowerBand) {
            return true; // Có ít nhất 1 cây nến chạm vào band dưới
        }
    }
    
    return false; // Không có cây nến nào chạm vào band trên
}

bool AreLast3CandlesTouchingUpperBandIsSell() {
    double lowerBand;

    for (int i = 0; i < 3; i++) {
      
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
             printf("IsCandleSellEMA");
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "", 9999, clrNONE);
       }
       else if (openPrice > ema50 
       // && IsSenkouCloudWithin20Pips()
        && ichimokuTenkan > ema50
        && IsCandleSellEMA()
        && closePrice < ema50) {
           printf("IsCandleSellEMA");
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
      double bollingerlow1 =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 1);
      double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
      double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 1);
      double ichimokuTenkan5 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
      
      double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
      
      double pipDifferenceTenkan = MathAbs(ichimokuTenkanNow - ichimokuTenkan5) / 0.1;
      double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;
      
      double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
      double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
      double LowNow = iLow(NULL, 0, 0);
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
    
      double bandSMA80 = iBands(Symbol(), Period(), 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
      double bandSMA20 = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
      double valueSell = ((GetMin(ichimokuTenkan1, ichimokuKijun1, bollingerMiddle) - previousClose) /0.1);
      double valuePreviousSell = ((previousClose - previousOpen) / 0.1);
      double Low =  GetLow() ;
      double High =  GetHighestHigh(); 
      // if(PreviousCandleLow2  < PreviousCandleLow ){
      // return false;
      // }
      double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
      double rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
      double rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
      double rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

      // if(PreviousCandleHigh2 > PreviousCandleHigh ){
      //   return false;
      // } 

      if(rsiValue < 30 || rsiValue1 < 30 || rsiValue2 < 30 ||rsiValue3 < 30  && MathAbs(senkouB-senkouA)/0.1  > 50  ){
        return false;
      }

      if(MathAbs(LowNow - ema200)/0.1 < 10 ){
        return false;
      }

      if(MathAbs(ema50 - ema200)/0.1 < 10 ){
        return false;
      }

      if((High - LowNow)/0.1 > 500   ){
        return false;
      }

      if(MathAbs(LowNow - Low)/0.1 < 30   ){
        return false;
      }

      if(previousClose > previousOpen ){
       return false;
      }

      if((currentPrice - ema50 )/0.1 < 7 && (currentPrice - ema50 )/0.1 >  0 ){
         return false;
      }

      if((LowNow - ema50 )/0.1 < 10 && (currentPrice - ema50 )/0.1 >  0 ){
         return false;
      }

      if(MathAbs(bollingerlow1 - bandSMA20)/0.1 < 20 ){
        return false;
      }
      
      if(MathAbs(ema50 - ema200)/0.1 < 7 && senkouA > senkouB ){
        return false;
      }
      
      if(PreviousCandleLow < bollingerlowH1){
         return false;
      }
      
       if(MathAbs(PreviousCandleLow - bollingerlowH1)/0.1 < 20){
         return false;
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
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA && senkouA > senkouB  && MathAbs(senkouB-senkouA)/0.1 > 70  ){
         return false;
      }

      if( AreEMA50EMA200Crossing() && ema50 < ema200 && (PreviousCandleLow - bollingerlow)/0.1 < 10  ){
         return false;
      }

      if(IsPriceCrossing7EMA200() ){
         return false;
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

      if(senkouA > senkouB  
          && AreEMA50TenkanSenrossing14()
          && IsPriceCrossingEMA5014() ){
          return false;
      }

      if(senkouA > senkouB  
          && AreEMA50TKIJUSenrossing22()
          && AreEMA50TenkanSenrossing22()
          && IsPriceCrossingEMA5022() ){
          return false;
      }

      if( AreLast3CandlesTouchingUpperBandIsSell() && AreEMA50EMA200Crossing()){
           return false;
      }

      if((senkouB - senkouA )/0.1 >= 100 
           && AreLast3CandlesTouchingUpperBandIsSell() 
           && IsPriceCrossingEMA5014() ){
          return false;
      }

      if((senkouB - senkouA )/0.1 >= 100 
           && AreLast3CandlesTouchingUpperBandIsSell() 
           && AreEMA50TKIJUSenrossing22() ){
          return false;
      }

      if( (senkouB -senkouA)/0.1 > 30 
            && AreEMA50EMA200Crossing()
            &&  (ichimokuKIJUNNow - ichimokuTenkanNow) <  (ichimokuKIJUN - ichimokuTenkan)
            &&  ichimokuKIJUNNow  > ichimokuTenkanNow
            ){
           return false;
      }

      if(CheckBollingerUPPERCross()  && (senkouA - senkouB) >= (senkouA2 - senkouB2) ){
         return false;
      }

      if(IsPriceCrossingEMA20014() && AreTenkanKijunCrossing() ){
         return false;
      }

      if( bollingerlowH1 >currentPrice ){
         return false;
      }

      if( bollingerlowH1 > PreviousCandleLow || bollingerlowH1 > PreviousCandleLow2 ){
         return false;
      }

      if(ema50 > currentPrice  
          && PreviousCandleHigh > bandSMA80 
          && PreviousCandleLow <  bandSMA80
          && IsPriceCrossingEMA5014() ){
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
      double bollingerUper1 =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 1);
      double pipDifferenceEMAKIJUN = MathAbs(ema50 - ichimokuKIJUN) / 0.1;
      double HighNow = iHigh(NULL, 0, 0);
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
      double bandSMA80 = iBands(Symbol(), Period(), 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
      double bandSMA20 = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
      double High =  GetHighestHigh(); 
      double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
      double rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
      double rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
      double rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

      // if(PreviousCandleHigh2 > PreviousCandleHigh ){
      //   return false;
      // } 

      if((rsiValue > 66 || rsiValue1 > 66 || rsiValue2 > 66 ||rsiValue3 > 70 )  && MathAbs(senkouB-senkouA)/0.1  > 50  ){
        return false;
      }

      if(MathAbs(HighNow - ema200)/0.1 < 10 ){
        return false;
      }
      
      if(MathAbs(ema50 - ema200)/0.1 < 10 ){
        return false;
      }

      if(MathAbs(High - HighNow)/0.1 < 30  ){
        return false;
      }

      if(MathAbs(bollingerUper1 - bandSMA20)/0.1 < 20 ){
        return false;
      }

      if(MathAbs(PreviousCandleHigh - bollingerUperH1)/0.1 < 20){
          return false;
      }

       if((ema50 - currentPrice  )/0.1 < 7 && (ema50 - currentPrice  )/0.1 >  0 ){
         return false;
      }

      if((ema50 - PreviousCandleHigh  )/0.1 < 10 && (ema50 - currentPrice  )/0.1 >  0 ){
         return false;
      }
      
      if(MathAbs(ema50 - ema200)/0.1 < 7 && senkouA > senkouB ){
        return false;
      }
      
      if(PreviousCandleHigh >  bollingerUperH1){
          return false;
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
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA && (senkouB - senkouA)/0.1 > MaxPipPreviou && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA && (senkouB - senkouA)/0.1 > MaxPipPreviou && (currentPrice - senkouB)/0.1 > InputcurrentPriceSenkouB  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA && (senkouB > senkouA) >= (senkouB2 - senkouA2 )  ){
         return false;
      }

      if(pipDifferenceKIJUN <InputpipDifferenceEMA && senkouB > senkouA && MathAbs(senkouB-senkouA)/0.1 > 70  ){
         return false;
      }
      
      if(pipDifferenceKIJUN <InputpipDifferenceEMA && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
         return false;
      }
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
         return false;
      }
      
      if(pipDifferenceTenkan <InputpipDifferenceEMA && (senkouB-senkouA) >= (senkouB2 - senkouA2 )  ){
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

      if( AreEMA50EMA200Crossing() && ema50 > ema200 && ( bollingerUper - PreviousCandleHigh )/0.1 < 10 ){
         return false;
      }
      
       if(senkouB > senkouA  && CheckEMACross()){// 500
         return false; 
      }
      // 2023-08-24

      if(IsPriceCrossing7EMA200()){
        return false;
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

      if((senkouA - senkouB)/0.1 >= 100 
           && AreLast3CandlesTouchingUpperBandIsBuy() 
           && IsPriceCrossingEMA5014() ){
          return false;
      }

       if(senkouB   > senkouA
          && AreEMA50TKIJUSenrossing22()
          && AreEMA50TenkanSenrossing22()
          && IsPriceCrossingEMA5022() ){
          return false;
      }

      if( CalculateMaxDistance() > 65 ){
          return false;
      }

      if( (senkouB -senkouA)/0.1 > 30 
            && AreEMA50EMA200Crossing()
            &&  (ichimokuTenkanNow - ichimokuKIJUNNow) <  (ichimokuTenkan - ichimokuKIJUN )
            &&  ichimokuKIJUNNow  < ichimokuTenkanNow
            ){
           return false;
      }

      if(CheckBollingerLOWERCross()  && (senkouB-senkouA) >= (senkouB2 - senkouA2 ) ){
         return false;
      }


      if(IsPriceCrossingEMA20014() && AreTenkanKijunCrossing() ){
         return false;
      }

      if(currentPrice > bollingerUperH1 ){
         return false;
      }

      if( bollingerUperH1 < PreviousCandleHigh || bollingerUperH1 < PreviousCandleHigh2 ){
         return false;
      }

       if(ema50 < currentPrice  
          && PreviousCandleHigh > bandSMA80 
          && PreviousCandleLow <  bandSMA80
          && IsPriceCrossingEMA5014() ){
          return false;
      }
      printf("rsiValue3"+rsiValue3);

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
  double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
  double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
  double PreviousCandleHigh = iHigh(NULL, 0, 1);

  if((senkouB -senkouA) /0.1 >150 ){
   return false;
  }

  if((ema200 - PreviousCandleHigh  )/0.1 < 10 && (ema200 - currentPrice  )/0.1 >  0 ){
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
  double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);   
  double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
  double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
  double PreviousCandleLow =iLow(NULL, 0, 1);

   if((ema200 - PreviousCandleLow  )/0.1 < 10 && ( currentPrice -ema200  )/0.1 >  0 ){
         return false;
      }

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


bool IsCandleBuyPivot (){

   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE,0 );
   double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE,0 );
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  

   double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 0);
   double ichimokuTenkan5 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
   double pipDifferenceTenkan = MathAbs(ichimokuTenkanNow - ichimokuTenkan5) / 0.1;
   double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
   double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;
   double bollingerlowH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);
   double bollingerlowM15 =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);

   if(AreEMA50EMA200Crossing()){
     return false;
   }

   if(IsPriceCrossingEMA50()){
      return false;
   }
   if(CheckBollingerLOWERCross() && IsPriceCrossingEMA50()){
         return false;
   }

   if(previousClose < previousOpen){
       return false;
   }

    if(currentPrice < ema50 && AreTenkanKijunCrossing()){
      return false;
   }

   if(MathAbs(currentPrice - ema200)/0.1 < 17 ){
         return false;
   }

   if(currentPrice < ema50 && AreEma50KijunCrossing() ){
     return false;
   }

   if(currentPrice < bollingerlowH1 &&  currentPrice > bollingerlowM15 ){
     return false;
   }
   return true;
}

bool IsCandleSellPivot (){
   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double ema50= iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE,0 );
   double ema200= iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE,0 );
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  

   double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 0);
   double ichimokuTenkan5 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
   double pipDifferenceTenkan = MathAbs(ichimokuTenkanNow - ichimokuTenkan5) / 0.1;
   double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
   double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;

   double bollingerUpH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 0);
   double bollingerUpM15 =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 0);

   if(AreEMA50EMA200Crossing()){
     return false;
   }

   if(IsPriceCrossingEMA50()){
      return false;
   }
   
    if(previousOpen > previousClose){
       return false;
   }

   if(currentPrice > ema50 && AreTenkanKijunCrossing()){
       return false;
   }

   if(currentPrice > ema50 && AreEma50KijunCrossing() ){
         return false;
   }

   if(MathAbs(currentPrice - ema200)/0.1 < 17 ){
         return false;
   }

    if(CheckBollingerUPPERCross() && IsPriceCrossingEMA50()){
     return false;
   }

   if(currentPrice > bollingerUpH1 &&  currentPrice < bollingerUpM15 ){
     return false;
   }
   return true;
}

bool IsCandleBuyRibbon (){
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  
   double bollingerUperH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_UPPER, 0);
   double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema200_1 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 1);
   double PreviousCandleHigh = iHigh(NULL, 0, 1);
   double HighNow = iHigh(NULL, 0, 0);
   double PreviousCandleLow = iLow(NULL, 0, 1);
   double PreviousCandleHigh2 = iHigh(NULL, 0, 2);
   double PreviousCandleLow2 = iLow(NULL, 0, 2);
   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double pipDifferenceSP = MathAbs(iCustom(Symbol(), 0, "SuperTrend", 0,1) - ema50)   / 0.1;

   double pipDifferenceSPA = MathAbs(iCustom(Symbol(), 0, "SuperTrend", 0,1) - iCustom(Symbol(), 0, "SuperTrend", 0,8))   / 0.1;

   double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   double ichimokuTenkan_1 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 1);
   double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 1);
   double ichimokuTenkan6 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 5);
   double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
   double pipDifferenceTenkan = MathAbs(ichimokuTenkan_1 - ichimokuTenkan6) / 0.1;
   double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;

   double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
   double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
   double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
   double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);
   double upperBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
   double bandSMA = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
   double bandSMAH1 = iBands(Symbol(), Period(), 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
   double High =  GetHighestHigh();
   double valuePreviousBuy = ((previousOpen - previousClose) / 0.1);
   
   double r3Value = GetR3Value();

   double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
   double rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
   double rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
   double rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

   if((rsiValue > 66 || rsiValue1 > 66 || rsiValue2 > 66 ||rsiValue3 > 70 )  && MathAbs(senkouB-senkouA)/0.1  > 50  ){
        return false;
    }

   
   if(pipDifferenceTenkan < 2){
     return false;
   }
   
   if(PreviousCandleHigh >  upperBand ){
        return false;
   }

   if(pipDifferenceSPA  < 3  &&  ichimokuTenkanNow < ichimokuKIJUNNow && AreTenkanKijunCrossing() ){
       return false;
   }

   if((ema200_1 - PreviousCandleHigh)/0.1 < 25 && (ema200_1 - PreviousCandleHigh) > 0 ){
       return false;
   }

   if(AreTenkanKijunCrossing()  && AreLast3CandlesTouchingUpperBandIsBuy()){
      return false;
   }

   if(PreviousCandleHigh > bandSMA && PreviousCandleLow <  bandSMA && currentPrice <  ema50 ){
       return false;
   }

   if(MathAbs(High - HighNow)/0.1 < 30  ){
        return false;
   }

    if(MathAbs(bandSMA - upperBand)/0.1 < 21  ){
        return false;
   }

    if(MathAbs(currentPrice - upperBand)/0.1 < 27 &&  pipDifferenceSPA  < 3 ){
       return false;
   }

   if(MathAbs(bandSMA - upperBand)/0.1 < 27 &&  AreLast3CandlesTouchingUpperBandIsBuy() ){
       return false;
   }
   
   if(IsPriceCrossing1EMA50() ){
       return false;
   }

   if(IsPriceCrossing1EMA200() ){
       return false;
   }

   if(IsPriceCrossing8EMA200() &&  AreLast5CandlesTouchingUpperBandIsBuy()  ){
       return false; 
   }

   if(currentPrice < ema50 &&  pipDifferenceSP < 33){
       return false;
   }

   if(currentPrice > High &&  AreLast3CandlesTouchingUpperBandIsBuy() ){
       return false;
   }

    if(IsPriceCrossing1EMA50() &&  AreLast3CandlesTouchingUpperBandIsBuy() ){
       return false;
   }

   if(MathAbs(valuePreviousBuy) < 4){
         return false;
   }

   if((currentPrice - bandSMAH1 )/0.1 > 170  && (bollingerUperH1 - bandSMAH1 )/0.1 > 200  ){
      return false;
   }

    if((currentPrice - upperBand)/0.1 > 10 ){
      return false;
   }

    if(IsPriceCrossingEMA50() &&  currentPrice > upperBand){
       return false;
    }

   
   if(MathAbs(PreviousCandleHigh - r3Value)/0.1 < 20 ){
      return false;
   }

   if(PreviousCandleHigh > r3Value){
      return false;
   }

   if(previousClose < previousOpen){
       return false;
   }

   if(MathAbs(ema50 - ema200)/0.1 < 22 ){
        return false;
   }

   if(MathAbs(currentPrice - bollingerUperH1)/0.1 < 15 ){
        return false;
   }
  
   if(MathAbs(PreviousCandleHigh - bollingerUperH1)/0.1 < 15 ){
        return false;
   }

   if( bollingerUperH1 < PreviousCandleHigh || bollingerUperH1 < PreviousCandleHigh2 ){
         return false;
   }

   if( pipDifferenceKIJUN < 2){
         return false;
   }

   if((senkouB-senkouA) >= (senkouB2 - senkouA2 ) && senkouB > senkouA  ){
   
        return false;
   }

   if(MathAbs(bandSMAH1 - bandSMA)/0.1 < 13   ){
        return false;
   }
   

  //  if((senkouA2 -senkouB2 )/(senkouA - senkouB) > 4  && senkouA > senkouB   ){
   
  //       return false;
  //  }

  if( MathAbs(senkouB-senkouA)/0.1 < 5 && MathAbs(currentPrice - ema50)/0.1 < 25  ){
   
        return false;
   }
      
   if( AreTenkanKijunCrossing() && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA ){
        return false;
   }

   if(IsPriceCrossingEMA50() &&  pipDifferenceKIJUN < 4 && ichimokuTenkanNow < ichimokuKIJUNNow ){
       return false;
   }

    if(MathAbs((PreviousCandleHigh - PreviousCandleLow)/(previousOpen - previousClose)) > 5 ){
        return false;
    }

    if(PreviousCandleHigh > ema200_1 && ema200_1 > PreviousCandleLow  ){
        return false;
    }

     if(IsPriceCrossing3EMA50() ){
       return false;
   }

     printf("MathAbs(bandSMAH1 - bandSMA)"+MathAbs(bandSMAH1 - bandSMA));
  return true;
}

bool IsCandleSellRibbon (){
   double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  
   double bollingerlowH1 =iBands(Symbol(), 0, 80, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);
   double bollingerlow =iBands(Symbol(), 0, 20, 2.0, 0, PRICE_CLOSE, MODE_LOWER, 0);
   double PreviousCandleHigh = iHigh(NULL, 0, 1);
   double PreviousCandleLow = iLow(NULL, 0, 1);
   double LowNow = iLow(NULL, 0, 0);
   double PreviousCandleHigh2 = iHigh(NULL, 0, 2);
   double PreviousCandleLow2 = iLow(NULL, 0, 2);
   double previousClose = iClose(Symbol(), Period(), 1);
   double previousOpen =  iOpen(Symbol(), Period(), 1);
   double ema50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema200_1 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, 1);
   double pipDifferenceSP = MathAbs(iCustom(Symbol(), 0, "SuperTrend", 0,1) - ema50)   / 0.1;
   double pipDifferenceSPA = MathAbs(iCustom(Symbol(), 0, "SuperTrend", 0,1) - iCustom(Symbol(), 0, "SuperTrend", 0,8))   / 0.1;
   double ichimokuTenkanNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   double ichimokuTenkan_1 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   double ichimokuKIJUNNow = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 1);
   double ichimokuTenkan6 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_TENKANSEN, 6);
   double ichimokuKIJUN4 = iIchimoku(Symbol(),Period(), 9, 26, 52, MODE_KIJUNSEN, 4);
   double pipDifferenceTenkan = MathAbs(ichimokuTenkan_1 - ichimokuTenkan6) / 0.1;
   double pipDifferenceKIJUN = MathAbs(ichimokuKIJUNNow - ichimokuKIJUN4) / 0.1;

   double senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
   double senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
   double senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
   double senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);
   double lowerBand = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
   double valuePreviousSell = ((previousClose - previousOpen) / 0.1);
   double bandSMA = iBands(Symbol(), Period(), 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
   double bandSMAH1 = iBands(Symbol(), Period(), 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
   double Low =  GetLow() ;
   double s3Value = GetS3Value();  

    double rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
    double rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
    double rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
    double rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

    if(rsiValue < 30 || rsiValue1 < 30 || rsiValue2 < 30 ||rsiValue3 < 30  && MathAbs(senkouB-senkouA)/0.1  > 50  ){
        return false;
      }
   
   if(pipDifferenceTenkan < 2){
     return false;
   }

    if(Low > currentPrice  &&  AreLast4CandlesTouchingUpperBandIsSell() ){
       return false;
   }

   if(lowerBand >  PreviousCandleLow ){
        return false;
   }

  if(MathAbs(bandSMAH1 - bandSMA)/0.1 < 13   ){
        return false;
   }
  
  if(MathAbs(LowNow - Low)/0.1 < 30   ){
        return false;
   }

   if((PreviousCandleLow - ema200_1)/0.1 < 25  && (PreviousCandleLow - ema200_1) > 0){
       return false;
   }

   if(pipDifferenceSPA  < 3  &&  ichimokuTenkanNow > ichimokuKIJUNNow && AreTenkanKijunCrossing() ){
       return false;
   }

   if(currentPrice > ema50 &&  pipDifferenceSP < 30){
       return false;
   }

   if(MathAbs(bandSMA - lowerBand)/0.1 < 21   ){
        return false;
   }

    if(MathAbs(currentPrice - lowerBand)/0.1 < 27 &&  pipDifferenceSPA  < 3  ){
        return false;
   }

  //   if(( senkouB2 - senkouA2 )/( senkouB - senkouA) > 4  && senkouB > senkouA  ){
   
  //       return false;
  //  }

   if(MathAbs(bandSMA - lowerBand)/0.1 < 27 &&  AreLast3CandlesTouchingUpperBandIsSell()   ){
        return false;
   }
    
    if(IsPriceCrossingEMA50() &&  currentPrice < lowerBand){
       return false;
    }

    if((lowerBand - currentPrice)/0.1 > 10 ){
      return false;
   }

   if(MathAbs(ema50 - ema200)/0.1 < 22 ){
        return false;
   }
   
   if((bandSMAH1 - currentPrice )/0.1 > 170 && (bandSMAH1 - bollingerlowH1 )/0.1 > 200 ){
      return false;
   }

   if(PreviousCandleHigh > bandSMA && PreviousCandleLow <  bandSMA  && currentPrice >  ema50 ){
       return false;
   }

   if(IsPriceCrossing1EMA50()){
       return false;
   }
 
   if(IsPriceCrossing1EMA200() ){
       return false;
   }

   if(IsPriceCrossing3EMA50() ){
       return false;
   }


   if(IsPriceCrossing1EMA50() &&  AreLast3CandlesTouchingUpperBandIsSell()  ){
       return false;
   }

   
   if(IsPriceCrossing8EMA200() &&  AreLast3CandlesTouchingUpperBandIsSell()  ){
       return false; 
   }

   if(MathAbs(valuePreviousSell) < 4){
         return false;
   }

   if(MathAbs(PreviousCandleLow - s3Value)/0.1 < 20 ){
      return false;
   }

   if(s3Value > PreviousCandleLow){
      return false;
   }

    if( MathAbs(bollingerlowH1 - currentPrice)/0.1 < 15 ){
         return false;
   }
 
   if( MathAbs(bollingerlowH1 - PreviousCandleLow)/0.1 < 15 ){
         return false;
   }

   if( bollingerlowH1 > PreviousCandleLow || bollingerlowH1 > PreviousCandleLow2 ){
      return false;
   }

   if(previousClose > previousOpen){
       return false;
   }

   if((senkouA - senkouB) >= (senkouA2 - senkouB2) && senkouA > senkouB ){
      return false;
   }

    if( MathAbs(senkouB-senkouA)/0.1 < 5 && MathAbs(currentPrice - ema50)/0.1 < 25  ){
   
        return false;
   }
     
   if((senkouA - senkouB)/0.1 >= 100 && AreTenkanKijunCrossing() ){
        return false; 
   }

   if((senkouA - senkouB) >= (senkouA2 - senkouB2) && MathAbs(senkouB-senkouA)/0.1  < senkouBNsenkouA  ){
        return false;
   }

   if( pipDifferenceKIJUN < 2){
         return false;
   }
    

   if(IsPriceCrossingEMA50() &&  pipDifferenceKIJUN < 4 && ichimokuTenkanNow > ichimokuKIJUNNow ){
       return false;
   }

    if(MathAbs((PreviousCandleHigh - PreviousCandleLow)/(previousOpen - previousClose)) > 5 ){
        return false;
    }

    if(PreviousCandleHigh > ema200_1 && ema200_1 > PreviousCandleLow  ){
        return false;
    }

  printf("Low()"+Low);
  printf("currentPrice"+currentPrice);
  return true;
}
bool AreEma50KijunCrossing() {
    double ema50[12];
    double kijunSen[12];

    for (int z = 0; z < 12; z++) {
        ema50[z] =iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE,z );;
        kijunSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
    }

    for (int i = 0; i < 12 ; i++) {
        if ((ema50[i - 1] > kijunSen[i - 1] && ema50[i] <= kijunSen[i]) ||
            (ema50[i - 1] < kijunSen[i - 1] && ema50[i] >= kijunSen[i])) {
            return true; // Đường Tenkan-sen và Kijun-sen cắt nhau
        }
    }

    return false; // Không có cắt nhau
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
            return true; 
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

bool IsPriceCrossing8EMA200() {

    for (int i = 1; i < 8; i++) {
        double closePrice = Close[i];
        double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema200 && PreviousCandleLow <= ema200)) {
             return true;
        }
    }
   
    return false; // Không có cắt qua
}

bool IsPriceCrossing1EMA200() {

    for (int i = 1; i < 3; i++) {
        double closePrice = Close[i];
        double ema200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema200 && PreviousCandleLow <= ema200)) {
             return true;
        }
    }
   
    return false; // Không có cắt qua
}


bool IsPriceCrossing3EMA50() {

    for (int i = 0; i < 4; i++) {
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

bool IsPriceCrossing1EMA50() {

    for (int i = 1; i < 3; i++) {
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

bool IsPriceCrossingEMA20014() {

    for (int i = 0; i < 14; i++) {
        double closePrice = Close[i];
        double ema50 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, i );
        double PreviousCandleHigh = iHigh(NULL, 0, i);
        double PreviousCandleLow = iLow(NULL, 0, i);

        if ((PreviousCandleHigh > ema50 && PreviousCandleLow <= ema50)) {
             return true;
        }
    } 
   
    return false; // Không có cắt qua
}

bool IsPriceCrossingEMA5022() {

    for (int i = 0; i < 22; i++) {
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



bool AreEMA50TenkanSenrossing22() {
    double ema50[22];
    double tenkanSen[22];

    for (int z = 0; z < 22; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, z);
    }

    for (int i = 1; i < 22; i++) {
        if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
            (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}
 

bool AreEMA50TKIJUSenrossing22() {
    double ema50[22];
    double tenkanSen[22];

    for (int z = 0; z < 22; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        tenkanSen[z] = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, z);
    }

    for (int i = 1; i < 22; i++) {
        if ((ema50[i - 1] > tenkanSen[i - 1] && ema50[i] <= tenkanSen[i]) ||
            (ema50[i - 1] < tenkanSen[i - 1] && ema50[i] >= tenkanSen[i])) {
            return true; // Đường EMA 50 và EMA 200 cắt nhau trong 20 cây nến gần nhất
        }
    }

    return false; // Không có cắt nhau
}

bool AreEMA50EMA200Crossing() {
    double ema50[45];
    double ema200[45];

    for (int z = 0; z < 45; z++) {
        ema50[z] = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, z);
        ema200[z] = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_CLOSE, z);
    }

    for (int i = 1; i < 45; i++) {
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


double CalculateMaxDistance() {
    double maxDistance = 0;

    for (int i = 0; i < 7; i++) {
        double tenkanSen = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i);
        double kijunSen = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_KIJUNSEN, i);

        double distance = MathAbs(tenkanSen - kijunSen);
        if (distance > maxDistance) {
            maxDistance = distance;
        }
    }

    return maxDistance/0.1;
}

double GetS3Value()
{
   double s3Value = iCustom(Symbol(), 0, "AllPivotPoints",3, 0);

   return(s3Value);
}

double GetR3Value()
{
   double r3Value = iCustom(Symbol(), 0, "AllPivotPoints",7, 0);

   return(r3Value);
}





bool checkTrendUptrend(color checkcolor)
{
double currentValueNow = iCustom(Symbol(), 0, "SuperTrend", 2, 0);
double currentValue = iCustom(Symbol(), 0, "SuperTrend", 2, 1);
double currentValue1 = iCustom(Symbol(), 0, "SuperTrend", 1, 1);
double currentValue0 = iCustom(Symbol(), 0, "SuperTrend", 0, 1);
double currentValue3 = iCustom(Symbol(), 0, "SuperTrend", 2, 2);

double currentPrice = MarketInfo(OrderSymbol(), MODE_BID);  
double previousClose = iClose(Symbol(), Period(), 0);
double previousOpen =  iOpen(Symbol(), Period(), 0);

if ( currentValue3 == 1
    && currentValueNow == 1
    && currentValue == 1
   // && currentValue1 < 1
    // && currentPrice < currentValue0
  //  && currentPrice >  previousOpen
    && checkcolor == clrGreen ) {
   return true;
} else if ( currentValue == -1 
            && currentValue3 == -1 
            && currentValueNow == -1 
            //  && currentValue1 > 1
            // && currentPrice < previousOpen
            // && currentPrice > currentValue0
            && checkcolor == clrRed)  {
    return true; 
} 

return false;
}

bool checkTrend(color checkcolor)
{
double currentValue = iCustom(Symbol(), 0, "SuperTrend", 2, 1);
double currentValue3 = iCustom(Symbol(), 0, "SuperTrend", 2, 2);
double currentValue4 = iCustom(Symbol(), 0, "SuperTrend", 2, 3);


if (currentValue4 == -1 
    && currentValue3 == 1
    && currentValue == 1
    && checkcolor == clrGreen ) {
   return true;
} else if (currentValue4 == 1 
            && currentValue == -1 
            && currentValue3 == -1 
            && checkcolor == clrRed)  {
    return true; 
} 


return false;
}

void nutbam_thanhngang (string name, double price, color mau_thanh_ngang, int fontsize)
                
                
  { 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 

   ResetLastError(); 
      int chart_ID = 0;

      if(!ObjectCreate(chart_ID,name,OBJ_HLINE,0,0,price)) 
       { 
         Print(__FUNCTION__, 
            ": failed to create a horizontal line! Error code = ",GetLastError()); 
         return; 
       } 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,mau_thanh_ngang); 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID); 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,fontsize); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 

   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
   return; 
  } 
  
int dem_so_lenh_hien_co(string kieu)
{
   int dem = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType()<2 && OrderSymbol()== Symbol() && kieu == "tong all")
            { dem++; } 
         if(OrderType()==OP_BUY && OrderSymbol()== Symbol()&& kieu == "tong buy")
            { dem++; }
         if(OrderType()==OP_SELL && OrderSymbol()== Symbol()&& kieu == "tong sell")
            { dem++; }       
      }
   }  return(dem);
}
//########################################
//########################################
double binhquangiabuy( double sotienn )
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

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderType()== OP_BUY )
           {
            lots = OrderLots();
            entry = OrderOpenPrice();
            swap = OrderSwap();
            comm = OrderCommission();
            tonglots = tonglots + lots;
            tonglenh = tonglenh + entry*lots;
            tongswap = tongswap + swap;
            tongcomm = tongcomm + comm;
              {
                 tp = (tonglenh+((sotienn+tongswap)*(ticksize/tickvalue)))/tonglots;
              }
           }
        }
     }
   return(tp);
  }
//###########################################333
double binhquangiasell( double sotienn )
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

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderType()== OP_SELL )
           {
            lots = OrderLots();
            entry = OrderOpenPrice();
            swap = OrderSwap();
            comm = OrderCommission();
            tonglots = tonglots + lots;
            tonglenh = tonglenh + entry*lots;
            tongswap = tongswap + swap;
            tongcomm = tongcomm + comm;
              {
                 tp = (tonglenh-((sotienn+tongswap)*(ticksize/tickvalue)))/tonglots;
              }
           }
        }
     }
   return(tp);
  }
double logaaa( string logMessage ){
//   int fileHandle;
// string fileName = "mylog.csv"; // Tên tệp log

// // Mở tệp để ghi
// fileHandle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE,';');

// if (fileHandle != INVALID_HANDLE)
// {
//     FileSeek(fileHandle, 0, SEEK_END);
//     FileWrite(fileHandle, logMessage);
//     FileClose(fileHandle); // Đóng tệp sau khi ghi
// }

}

double GetHighestHigh() {
    double highestHigh = 0;

    for (int i = 15; i < 150; i++) {
        double high = iOpen(NULL, PERIOD_M15, i);
        if (high > highestHigh) {
            highestHigh = high;
        }
    }
    return highestHigh;
}


double GetLow() {
    double Lows = 9999999;

    for (int i = 15; i < 150; i++) {
        double low = iClose(NULL, PERIOD_M15, i);
        if (low < Lows) {
            Lows = low;
        }
    }
    return Lows;
}