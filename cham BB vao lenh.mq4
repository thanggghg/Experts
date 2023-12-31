//+------------------------------------------------------------------+
//|                                       black_05_vu dieu tu do.mq4 |
//|                                                        phatblack |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "phatblack"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
input    double     khoiluong         = 0.01;
input    double     tiencatlo         = -1000;
input    double     tienlenhbuy       = 10; // so tien chot lenh buy
input    double     tienlenhsell      = 10; // so tien chot lenh sell
input    double     sopipsnhoilenh    = 1000;
input    double     solot             = 0.01;

input    int        gioihansolenhbuy  = 5; // gioi han so lan nhoi lenh buy
input    int        gioihansolenhsell = 5; // gioi han so lan nhoi lenh sell

input    int        gioihanautobuy    = 3; // gioi han so lan auto buy
input    int        gioihanautosell   = 3; // gioi han so lan auto sell

string comment = "vu dieu tu do";

input    bool       chedotudong = false;

//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  
   ObjectDelete(0,"tpbuy");
   ObjectDelete(0,"tpsell");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
datetime b = 0;
int baocatnhau = 0;
int baodt = 0;
int autotrade = 0;

int tongcaclenhautobuy = 0;
int tongcaclenhautosell = 0;

double tp_buy = 0;
double tp_sell = 0;
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double tpbuy = binhquangiabuy(tienlenhbuy);
   double tpsell = binhquangiasell(tienlenhsell);
   
   if(tpbuy != tp_buy){tp_buy = tpbuy; ObjectDelete(0,"tpbuy"); nutbam_thanhngang("tpbuy",tp_buy,clrLime,3);}
    if(dem_so_lenh_hien_co("tong buy") == 0){ObjectDelete(0,"tpbuy");}
   if(tpsell != tp_sell){tp_sell = tpsell; ObjectDelete(0,"tpsell"); nutbam_thanhngang("tpsell",tp_sell,clrRed,3);}
    if(dem_so_lenh_hien_co("tong sell") == 0){ObjectDelete(0,"tpsell");}

   int tonglenhbuy = dem_so_lenh_hien_co("tong buy");
   int tonglenhsell = dem_so_lenh_hien_co("tong sell");
   datetime a =   iTime(Symbol(),PERIOD_CURRENT,1);
   
   if( a > b){b = a; baocatnhau = 1; baodt = 1;} 
   
   
   double tekan = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_TENKANSEN,1);
   double tekan2 = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_TENKANSEN,2);
   double tekan3 = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_TENKANSEN,3);
   
   double kijun = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_KIJUNSEN,1);
   double kijun2 = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_KIJUNSEN,2);
   double kijun3 = iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_KIJUNSEN,3);
   
   double bb = iBands(Symbol(),PERIOD_CURRENT,20,2,0,PRICE_CLOSE,MODE_MAIN,1);
   double bbb = iMA(Symbol(),PERIOD_CURRENT,20,0,MODE_SMA,PRICE_CLOSE,0);
                   // Comment(bbb + "\n" + Open[0]);
//   if(dem_so_lenh_hien_co("tong all") > 0){return;}

 if(tongprofit("tong buy") > tienlenhbuy ){ xoalenh("xoa lenh buy");}
 if(tongprofit("tong sell") > tienlenhsell){ xoalenh("xoa lenh sell");}
 
 if( tongprofit("tong all")<= tiencatlo ){ xoalenh("xoa het");}

 
 if(dem_so_lenh_dang_trade() < 1 && tonglenhbuy < gioihansolenhbuy){nhoilenhbuyandsell("buy");}
 if(dem_so_lenh_dang_trade() < 1 && tonglenhsell < gioihansolenhsell){nhoilenhbuyandsell("sell");}
   
   
//   if(tekan > kijun && Open[3] < Close[3] && Open[2] < Close[2] && Open[1] > Close[1] && Open[3] > tekan3 && Open[2] > tekan2 && Close[1] > tekan && dem_so_lenh_hien_co("tong buy") == 0)
   
   if(( tekan < kijun && Open[0] < bbb && Bid >= bbb && dem_so_lenh_hien_co("tong sell") == 0 && baodt == 1) ||
      ( tekan < kijun && Open[0] > bbb && Bid <= bbb && dem_so_lenh_hien_co("tong sell") == 0 && baodt == 1))
   { SendNotification("co lenh Sell moi"); baodt = 0; autotrade = 1;}
    
   if(autotrade == 1 && chedotudong == true && tongcaclenhautosell < gioihanautobuy)
   {int sell = OrderSend(Symbol(),OP_SELL,khoiluong,Bid,0,0,0,comment); autotrade = 0; tongcaclenhautosell++; tongcaclenhautobuy = 0;}
   
   
//   if(tekan < kijun && Open[3] > Close[3] && Open[2] > Close[2] && Open[1] < Close[1] && Open[3] < tekan3 && Open[2] < tekan2 && Close[1] < tekan && dem_so_lenh_hien_co("tong sell") == 0)

   if(( tekan > kijun && Open[0] > bbb && Bid <= bbb && dem_so_lenh_hien_co("tong buy") == 0 && baodt == 1)||
      ( tekan > kijun && Open[0] < bbb && Bid >= bbb && dem_so_lenh_hien_co("tong buy") == 0 && baodt == 1))
   { SendNotification("co lenh Buy moi"); baodt = 0; autotrade = 2;}
   
   if(autotrade == 2 && chedotudong == true && tongcaclenhautobuy < gioihanautobuy)
   {int buy = OrderSend(Symbol(),OP_BUY,khoiluong,Ask,0,0,0,comment); autotrade = 0; tongcaclenhautobuy++; tongcaclenhautosell = 0;}
   
   if(kijun2 <= tekan2 && kijun > tekan && baocatnhau == 1){SendNotification(" kijun cat len tekan "); baocatnhau = 0; }
   
   if(kijun2 >= tekan2 && kijun < tekan && baocatnhau == 1){SendNotification(" kijun cat xuong tekan"); baocatnhau = 0; } 
   
  }
//+------------------------------------------------------------------+
//###################  DEM SO LENH DANG TRADE TRONG NEN HIEN TAI ###############
int dem_so_lenh_dang_trade()
{
   int solenh = 0;
   for(int i= OrdersTotal(); i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol() == Symbol())
         {
            if(OrderOpenTime() >= iTime(Symbol(),PERIOD_CURRENT,0))
            {
               solenh++;
            }
         }
      }
   } return(solenh);
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
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// ##################### HAM TRAILINGSTOP #################
void trallingstop(double diemtrallingg, double diemstartt, double step)
  {
   double giatrisl = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY && OrderOpenPrice()<= Bid-diemtrallingg*Point)
              {
               giatrisl = Bid - diemtrallingg*Point;
               if(OrderOpenPrice()<= Bid - diemstartt*Point && OrderStopLoss()<= Bid - (diemtrallingg + step)*Point)
                 {
                  bool thaydoislbuy = OrderModify(OrderTicket(),OrderOpenPrice(),giatrisl,OrderTakeProfit(),0,CLR_NONE);
                 }
              }
            //---------------------------------------------------------------------------------------------------------------------
            if(OrderType()==OP_SELL && OrderOpenPrice()>= Ask + diemtrallingg*Point)
              {
               double sovohan  = iHigh(Symbol(),PERIOD_D1,1)*2;
               giatrisl = Ask + diemtrallingg*Point;
               if(OrderStopLoss() == 0)
                 {
                  bool tamthoi = OrderModify(OrderTicket(),OrderOpenPrice(),sovohan,OrderTakeProfit(),0,CLR_NONE);
                 }

               if(OrderOpenPrice()>= Ask + diemstartt*Point && OrderStopLoss()>= Ask + (diemtrallingg + step)*Point)
                 {
                  bool thaydoislsell = OrderModify(OrderTicket(),OrderOpenPrice(),giatrisl,OrderTakeProfit(),0,CLR_NONE);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//############################ HAM NHOI LENH CA 2 CHIEU BUY SELL ##########################################
void nhoilenhbuyandsell( string kieu)
  {
   datetime optimebuy = 0;
   datetime optimesell = 0;
   double lots = 0;
   double lotvaolenh = 0;
   double gialenhcuoicung = 0;
   
   double close = iClose(Symbol(),PERIOD_CURRENT,1);
   for(int i = OrdersTotal()-1; i >=0 ; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))

        {
         if(OrderOpenTime()>optimebuy && OrderSymbol()==Symbol() && kieu == "buy")
           {
            if(OrderType() == OP_BUY)
              {
               optimebuy= OrderOpenTime();
               gialenhcuoicung = OrderOpenPrice();
               lots = OrderLots();
                 {
                  if(gialenhcuoicung>=close+sopipsnhoilenh*Point)
                    { int buy = OrderSend(Symbol(),OP_BUY,lots+solot,Ask,0,0,0,comment);}
                 }
              }
           }
         //----------------------------------------------------------------------------
         if(OrderOpenTime()>optimesell && OrderSymbol()==Symbol() && kieu == "sell")
           {
            if(OrderType() == OP_SELL)
              {
               optimesell= OrderOpenTime();
               gialenhcuoicung = OrderOpenPrice();
               lots = OrderLots();
                 {
                  if(gialenhcuoicung<=close-sopipsnhoilenh*Point)
                    { int sell = OrderSend(Symbol(),OP_SELL,lots+solot,Bid,0,0,0,comment);}
                 }
              }
           }
        }
     }
  }
//########################################################
//---DONG LENH
void xoalenh(const string kieu = "xoa het / xoa lenh buy / xoa lenh sell / buystop / sellstop / buylimit / selllimit")
{
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType()>-1 && OrderSymbol() == Symbol()&& kieu =="xoa het")
        {
         if(OrderType()<2) bool donglenh = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
        }
//-----------------------------------------------------------------------------------------------------        
        if(OrderType()==OP_BUY && OrderSymbol() == Symbol()&& kieu =="xoa lenh buy")
        {
          bool donglenh = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
        }
//------------------------------------------------------------------------------------        
        if(OrderType()==OP_SELL && OrderSymbol() == Symbol()&& kieu =="xoa lenh sell")
        {
          bool donglenh = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
        }
//------------------------------------------------------------------------------------        
        if(OrderType()==OP_BUYSTOP && OrderSymbol() == Symbol()&& kieu =="buystop")
        {
          bool xoalenh = OrderDelete(OrderTicket());
        }
//------------------------------------------------------------------------------------        
        if(OrderType()==OP_SELLSTOP && OrderSymbol() == Symbol()&& kieu =="sellstop")
        {
          bool xoalenh = OrderDelete(OrderTicket());
        }
//------------------------------------------------------------------------------------        
        if(OrderType()==OP_BUYLIMIT && OrderSymbol() == Symbol()&& kieu =="buylimit")
        {
          bool xoalenh = OrderDelete(OrderTicket());
        }
//------------------------------------------------------------------------------------        
        if(OrderType()==OP_SELLLIMIT && OrderSymbol() == Symbol()&& kieu =="selllimit")
        {
          bool xoalenh = OrderDelete(OrderTicket());
        }
      }
   }
}


double tongprofit( string kieu)
{
   double tong = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol() == Symbol()&& OrderType()<2 && kieu == "tong all")
            {
               tong = OrderProfit() + OrderSwap() + OrderCommission() + tong;
            }      
         if(OrderSymbol() == Symbol()&& OrderType() == OP_BUY && kieu == "tong buy")
            {
               tong = OrderProfit() + OrderSwap() + OrderCommission() + tong;
            }   
         if(OrderSymbol() == Symbol()&& OrderType() == OP_SELL && kieu == "tong sell")
            {
               tong = OrderProfit() + OrderSwap() + OrderCommission() + tong;
            }   
      }
   }  return(tong);
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
  
//+------------------------------------------------------------------+
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
//--- set line color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,mau_thanh_ngang); 
//--- set line display style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- set line width 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,fontsize); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 
//--- enable (true) or disable (false) the mode of moving the line by mouse 
//--- when creating a graphical object using ObjectCreate function, the object cannot be 
//--- highlighted and moved by default. Inside this method, selection parameter 
//--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,true); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
//--- successful execution 
   return; 
  } 
  
  //#################################################################################3