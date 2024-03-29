void IntIndi()
{
  iBandLower_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
  iBandLower_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
  iBandLower_15 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 15);
  iBandSma_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_SMA, 0);
  iBandSma_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  iBandUpper_0 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);
  iBandUpper_15 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 15);
  iBandUpper_30 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 30);
  iBandUpper_1 = iBands(Symbol(), 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);


  iBandH1Lower_0 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
  iBandH1Lower_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
  iBandH1Lower_15 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_LOWER, 15);
  iBandH1Sma_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_SMA, 1);
  iBandH1Upper_0 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);
  iBandH1Upper_1 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
  iBandH1Upper_15 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 15);
  iBandH1Upper_50 = iBands(Symbol(), 0, 80, 2, 0, PRICE_CLOSE, MODE_UPPER, 50);

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
  ema50_1 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 1);
  ema50_6 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 6);

  iIchiKinjun_0 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 0);
  iIchiKinjun_1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 1);
  iIchiKinjun_2 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 2);
  iIchiKinjun_3 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 3);
  iIchiKinjun_4 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 4);

  iIchiTenkan_0 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 0);
  iIchiTenkan_1 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 1);
  iIchiTenkan_2 = iIchimoku(Symbol(), 0, 9, 26, 52, MODE_TENKANSEN, 2);
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

  IDAX = iADX(NULL, 0, 14, PRICE_HIGH, MODE_MAIN, 1);
  IDAXm = iADX(NULL, 0, 14, PRICE_HIGH, MODE_MINUSDI, 1);
  IDAXP = iADX(NULL, 0, 14, PRICE_HIGH, MODE_PLUSDI, 1);



  r4Value = iCustom(Symbol(), 0, "AllPivotPoints", 8, 0); ;
  s4Value = iCustom(Symbol(), 0, "AllPivotPoints", 4, 0); ;

  r3Value = GetR3Value();
  s3Value = GetS3Value();

  r2Value = GetR2Value();
  s2Value = GetS2Value();

  rsiValue = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 0);
  rsiValue1 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 1);
  rsiValue2 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 2);
  rsiValue3 = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, 3);

  senkouA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 0);
  senkouA2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 2);
  senkouA10 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, 10);
  senkouB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 0);
  senkouB2 = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, 2);

  LowPrice150 = GetLow();
  HighPrice150 = GetHighestHigh();

  isAreEMA50EMA200Crossing = AreEMA50EMA200Crossing();
  isPriceCrossing7EMA200 = PriceCrossing7EMA200();
  isPriceCrossing7EMA50 = PriceCrossing7EMA50();
  isPriceCrossing14EMA200 = PriceCrossing14EMA200();
  IsPriceCrossing1EMA50 = PriceCrossing1EMA50();
  IsPriceCrossingOneEMA50 = PriceCrossingOneEMA50();
  IsPriceCrossing3EMA50 = PriceCrossing3EMA50();
  IsAreRecent4CandlesLower = AreRecent4CandlesLowerThan4thPrevious();
  IsAreRecent5CandlesLower = AreRecent5CandlesLowerThan4thPrevious();
  IsAreRecent5CandlesUperThan7 = AreRecent5CandlesUperThan7thPrevious();
}