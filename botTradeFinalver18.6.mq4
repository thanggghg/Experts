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
input int totalProfitCutOffPoint = 5;//âm tới StopDCAPrice thì pip DCA sẽ khác
input int ProfitCutOffPoint = 1;//âm tới StopDCAPrice thì pip DCA sẽ khác
input int SendTelegram = 0;//âm tới StopDCAPrice thì pip DCA sẽ khác
input double maxAmIf = -5; // âm quá tiền thì đánh ngược nếu đủ dk
input string telegramBotToken = "6486993124:AAGuq9xxD0nOAm9sSHZCTnuN_lsNYPoXesw";
input string telegramChatId = "-4076781244";
input int DiNhau = 0;
bool ShouldEnterTrade = False;
bool EntryPrice = false;
bool MainIsBuy = False;
datetime TimeClose = 0;
double maxAmBuy = 0;
double maxAmSell = 0;
double maxDuong = 0;
double maxAm = 0;
double previousClosePrice = 0.0;

double rsiValue, currentPrice, bandSMA, bandSMA20, bandSMA80, bandSMAH1, bollingerlow, bollingerlow1, bollingerlowH1, bollingerlowM15, bollingerMiddle, bollingerUper, bollingerUper1, bollingerUperH1, bollingerUpH1, bollingerUpM15, closePrice, currentValue, currentValue0, currentValue1, currentValue3, currentValue4, currentValueNow, distance, ema200, ema200_1, ema50, HighNow, iIchiKinjun_3, iIchiKinjun_4, iIchiKinjun_0, iIchiTenkan_3, iIchiTenkan_0, iIchiTenkan_5, iIchiTenkan_36, iIchiTenkan_1, iPreviousCandleLow_1, latestOrderLoss, lowerBand, PreviousCandleLow_1, newClosePrice, openPrice, pipDifference, pipDifferenceEMA, pipDifferenceEMAKIJUN, pipDifferenceEMATENKAN, pipDifferenceKIJUN, pipDifferenceSP, pipDifferenceSPA, pipDifferenceTenkan, pipDistance, pipValue, pointSize, PreviousCandleHigh_1, PreviousCandleHigh_2, PreviousCandleLow_2, previousClose, previousOpen, r3Value, rsiValue1, rsiValue2, rsiValue3, s3Value, senkouA, senkouA2, senkouB, senkouB2, upperBand;

double iBandLower_0, iIchiKinjun_1, iBandLower_1, iBandSma_0, iBandSma_1, iBandUpper_0, iBandUpper_1, iBandH1Lower_0, iBandH1Sma_1, iBandH1Upper_0;
double previousClose_2, previousOpen_2, valueBuySell, LowNow, ema50_6, SuperTrendValue21, SuperTrendValue01, SuperTrendValue11, SuperTrendValue22, SuperTrendValue23, SuperTrendValue08, SuperTrendValue20;
bool isAreTenkanKijunCrossing, IsPriceCrossing3EMA50, IsPriceCrossing8EMA200, IsPriceCrossing1EMA50, isPriceCrossingEMA200, isPriceCrossingEMA20014, isCheckEMACross, isAreEMA50EMA200Crossing, isPriceCrossing7EMA200, isPriceCrossing7EMA50, isPriceCrossing14EMA200, isPriceCrossingEMA50, isAreEMA50TenkanSenrossing14;
bool IsAreRecent5CandlesLower, IsAreRecent4CandlesLower, isPriceCrossingEMA5014, isAreEMA50TenkanSenrossing22, isPriceCrossingEMA5022, isAreEMA50TKIJUSenrossing22, isCheckBollingerUPPERCross;
double lastPIP = 0.0;
double tp_buy = 0;
double tp_sell = 0;

bool IsAreRecent5CandlesUperThan7;
int candleHour;
double ema50_1, iBandUpper_30, senkouA10, iBandH1Upper_50, r2Value, s2Value, iBandH1Lower_1, iBandH1Upper_1;
double IsPriceCrossingOneEMA50, r4Value, s4Value, iBandLower_15, iBandUpper_15, iBandH1Lower_15, iBandH1Upper_15;
double iIchiKinjun_2, iIchiTenkan_2;
double IDAX, IDAXm, IDAXP;
bool EntryPriceBuy = false;
bool EntryPriceSell = false;

#include <myIndi\IFunction.mq4>
#include <myIndi\IOpenTrade.mq4>
#include <myIndi\IMaxMinOderRSI.mq4>
#include <myIndi\ICheckPivotStrategy.mq4>
#include <myIndi\ICheckMadridRibbon.mq4>
#include <myIndi\ICheckMadridRibbonUpdate.mq4>
#include <myIndi\ICheckSenKouPan.mq4>
#include <myIndi\ICheckTenkanKinju.mq4>
#include <myIndi\IcheckIbandH1.mq4>
#include <myIndi\IcheckR4S4Value.mq4>
#include <myIndi\IcheckTenkanKinjuMore.mq4>
#include <myIndi\IMainIndi.mq4>
#include <myIndi\IcheckIDAX.mq4>
#include <myIndi\IcheckIbrand80.mq4>

void OnTick(void)
{

  datetime currentTime = iTime(Symbol(), Period(), 0);
  candleHour = TimeHour(currentTime);
  //vaiable

  int timeCanlde = TimeMinute(Time[1]);

  currentPrice = MarketInfo(OrderSymbol(), MODE_BID);

  IntIndi();

  IDAX = iADX(NULL, 0, 14, PRICE_HIGH, MODE_MAIN, 1);
  IDAXm = iADX(NULL, 0, 14, PRICE_HIGH, MODE_MINUSDI, 1);
  IDAXP = iADX(NULL, 0, 14, PRICE_HIGH, MODE_PLUSDI, 1);

  if (previousClosePrice != iClose(Symbol(), Period(), 1))
  {



    int hoursForRibbon[] = { 0, 1, 2,3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 23 };
    int hoursForRibbonUpdate[] = { 0, 1, 2,3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22 };
    int hoursForSenkoupan[] = { 0, 1, 2, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 23 };
    int hoursForOpenTrade[] = { 0, 1, 2, 3, 4,5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 23 };

    int hoursForTenkanKinju[] = { 3,4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 15, 17, 18, 20, 22 };
    int hoursForTenkanKinjuMore[] = { 6, 8, 9, 7, 10, 11, 12, 13,14, 15, 16, 17, 18, 20, 22 };
    int hoursForcheckcheckIDAX[] = { 5,6, 7, 9, 8, 11, 12, 13, 15, 16, 17, 18, 19, 22 };
    int hoursForcheckMaxMinOderRSI[] = { 10, 11, 12, 13, 14, 16, 18 };
    int hoursForcheckPivotStrategy[] = { 18, 19, 14 };

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForRibbon, ArraySize(hoursForRibbon)))
    {
     CheckMadridRibbon();
    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForRibbonUpdate, ArraySize(hoursForRibbonUpdate)))
    {
    CheckMadridRibbonUpdate();
    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForSenkoupan, ArraySize(hoursForSenkoupan)))
    {
      CheckSenKouPan();
    }//

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForOpenTrade, ArraySize(hoursForOpenTrade)))
    {
      OpenTrade();
    }


    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForcheckMaxMinOderRSI, ArraySize(hoursForcheckMaxMinOderRSI)))
    {
     MaxMinOderRSI();
    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForcheckPivotStrategy, ArraySize(hoursForcheckPivotStrategy)))
    {
      CheckPivotStrategy();

    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForTenkanKinju, ArraySize(hoursForTenkanKinju)))
    {
     CheckTenkanKinju();
    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForTenkanKinjuMore, ArraySize(hoursForTenkanKinjuMore)))
    {
     checkTenkanKinjuMore();
    }

    if (CountOrdersWithMagic() < 1 && !IsHourInArray(candleHour, hoursForcheckcheckIDAX, ArraySize(hoursForcheckcheckIDAX)))
    {
      checkIDAX();
    }

    if (CountOrdersWithMagic() < 1)
    {
     checkIbandH1();

    }

    if (CountOrdersWithMagic() < 1)
    {
      checkR4S4Value();

    }

    if (CountOrdersWithMagic() < 1)
    {
      checkIBand80();

    }

    if (CountOrdersWithMagic() < 1 && candleHour == 15 && timeCanlde == 30)
    {
      check15h();

    }

    if (CountOrdersWithMagic() < 1 && candleHour == 19 && timeCanlde == 15)
    {
      check15h();

    }


  }


  if (CountOrdersWithMagic() < 1)
  {
    EntryPrice = false;
  }

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
    maxAm = 0;

    CloseProfitableOrders();
    TimeClose = iTime(Symbol(), Period(), 0);
    SendTelegramMessage("tp " + totalProfit);
    EntryPrice = false;
  }

  if (totalProfit < ProfitCutOffPoint && EntryPrice == true && totalProfit > 0)
  {
    maxAm = 0;
    EntryPrice = false;
    CloseProfitableOrders();
    TimeClose = iTime(Symbol(), Period(), 0);
    SendTelegramMessage("tp " + totalProfit);
  }


  if (CountOrdersWithMagic() > 3 && totalProfit > 0)
  {
    maxAm = 0;
    TimeClose = iTime(Symbol(), Period(), 0);
    CloseProfitableOrders();
  }


  double tpbuy = binhquangiabuy(tiencLhotLoi);
  double tpsell = binhquangiasell(tiencLhotLoi);

  if (tpbuy != tp_buy) { tp_buy = tpbuy; ObjectDelete(0, "tpbuy"); nutbam_thanhngang("tpbuy", tp_buy, clrLime, 3); }
  if (dem_so_lenh_hien_co("tong buy") == 0) { ObjectDelete(0, "tpbuy"); }
  if (tpsell != tp_sell) { tp_sell = tpsell; ObjectDelete(0, "tpsell"); nutbam_thanhngang("tpsell", tp_sell, clrRed, 3); }
  if (dem_so_lenh_hien_co("tong sell") == 0) { ObjectDelete(0, "tpsell"); }

}



void check15h()
{

  if (previousOpen == previousClose || MathAbs((PreviousCandleHigh_1 - PreviousCandleLow_1) / (previousOpen - previousClose)) > 3)
  {
    return false;
  }
  if (MathAbs(currentPrice - ema200_1) / 0.1 > 50 && MathAbs(ema50 - ema200_1) / 0.1 > 50 )
  {
    if (previousClosePrice != previousClose)
    {

      if (previousOpen < previousClose
           && SuperTrendValue21 == 1
      )
      {

        sendOrderSendBuy("IsCandleBuycheck15h", lotSize, 9999);
      }
      else if (previousOpen > previousClose
          && SuperTrendValue21 == -1
      )
      {
        sendOrderSendSell("IsCandleSellcheck15h", lotSize, 8888);
      }
    }
  }
}



bool IsHourInArray(int targetHour, int hours[], int arraySize)
{
  for (int i = 0; i < arraySize; i++)
  {
    if (hours[i] == targetHour)
    {
      return true;
    }
  }
  return false;
}


// Function to send a JSON message to Telegram
void SendTelegramMessage(string message)
{
  if (SendTelegram == 1)
  {
    string headers = "Content-Type: application/json";
    char post[];
    int postLength = 0;
    char result[];
    string resultHeaders;
    // Send the HTTP POST request to the Telegram API
    int res = WebRequest("GET", "https://api.telegram.org/bot" + telegramBotToken + "/sendMessage?chat_id=" + telegramChatId + "&text=" + message + "", NULL, NULL, 100, post, postLength, result, resultHeaders);
  }
  TimeClose = iTime(Symbol(), Period(), 0);


}



void sendOrderSendBuy(string mess, double lotSizeOrder, int magicNumber)
{
  double SSD5 = iCustom(Symbol(), 0, "SSD", 5, 1);
  if (MathAbs(HighNow - SSD5) / 0.1 > 40)
  {

    RefreshRates();
    EntryPrice = false;
    if (DiNhau == 0)
    {
      if (!OrderSend(Symbol(), OP_BUY, lotSizeOrder, Ask, 2, 0, 0, "", magicNumber, clrNONE))
      {
        RefreshRates();
        sendOrderSendBuy( mess,  lotSizeOrder,  magicNumber);
      }
      previousClosePrice = iClose(Symbol(), Period(), 1);
    }

    SendTelegramMessage(mess);
    printf(mess);
  }
}

void sendOrderSendSell(string mess, double lotSizeOrder, int magicNumber)
{
  double SSD6 = iCustom(Symbol(), 0, "SSD", 6, 1);
  if (MathAbs(LowNow - SSD6) / 0.1 > 40)
  {
    RefreshRates();
    EntryPrice = false;
    if (DiNhau == 0)
    {
      if (!OrderSend(Symbol(), OP_SELL, lotSizeOrder, Bid, 2, 0, 0, "", magicNumber, clrNONE))
      {
        RefreshRates();
        sendOrderSendSell( mess,lotSizeOrder,magicNumber);
      }
      previousClosePrice = iClose(Symbol(), Period(), 1);
    }

    SendTelegramMessage(mess);
    printf(mess);
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

