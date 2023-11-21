#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

CTrade trade;
CAccountInfo account;
CPositionInfo positionInfo;

// Configuracion
datetime date = 0;
datetime PrevBarTime;
datetime time_0;
double percentRisk = 0.002;

// Compra
float RatioCompra = 6.609;
float EntradaCompra = 0.1458;
float SLCompra = 0.1758;
float RatioVenta = 3.847;
float EntradaVenta = -0.001;
float SLVenta = -0.031;

input int ticksForActivo = 100000;
int OnInit()
{
   time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
   PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
}

float High = 0.0;
float Low = 0.0;
float Rango = 0.0;
float EntradaCompraTicks = 0.0;
float SLCompraTicks = 0.0;
float EntradaVentaTicks = 0.0;
float SLVentaTicks = 0.0;

bool ordenEnviada = false;

void OnTick()
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
   if (time_0 != PrevBarTime)
   {  
     
      PrevBarTime = time_0;
      double currentPriceASK = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double currentPriceBID = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double percentBalance = balance * percentRisk;

      datetime TiempoLocal = TimeCurrent();
      MqlDateTime FechaTiempo;
      TimeToStruct(TiempoLocal, FechaTiempo);

      string date = TimeToString(TimeCurrent(), TIME_MINUTES);

      if (date == "06:00")
         ordenEnviada = false;
      if (date == "07:00" && !ordenEnviada)
      {
         for (int i = 0; i < 23; i++)
         {
            if (i == 0)
            {
               Low = iLow(_Symbol, PERIOD_CURRENT, i);
               High = iHigh(_Symbol, PERIOD_CURRENT, i);
            }
            if (Low > iLow(_Symbol, PERIOD_CURRENT, i))
               Low = iLow(_Symbol, PERIOD_CURRENT, i);
            if (High < iHigh(_Symbol, PERIOD_CURRENT, i))
               High = iHigh(_Symbol, PERIOD_CURRENT, i);
         }
         float ranged = High - Low;

         EntradaCompraTicks = Low - EntradaCompra * ranged;
         SLCompraTicks = (Low - SLCompra * ranged);

         EntradaVentaTicks = High - EntradaVenta * ranged;
         SLVentaTicks = (High - SLVenta * ranged);

         float StopLoss = SLCompraTicks;
         float TakeProfit = (currentPriceASK + (EntradaCompraTicks - SLCompraTicks) * RatioCompra);

         float VentaStopLoss = SLVentaTicks;
         float VentaTakeProfit = (currentPriceASK + (EntradaVentaTicks - SLVentaTicks) * RatioVenta);

         ordenEnviada = true;

         Print(High);
         Print(EntradaVentaTicks);
         Print(VentaStopLoss);
         Print(VentaTakeProfit);

         double pips = NormalizeDouble((EntradaCompraTicks - StopLoss) * ticksForActivo, _Digits);
         double volume = NormalizeDouble(balance * percentRisk / pips, 2);
         double VentaPips = NormalizeDouble((VentaStopLoss - EntradaVentaTicks) * ticksForActivo, _Digits);
         double VentaVolume = NormalizeDouble(balance * percentRisk / VentaPips, 2);

         trade.BuyLimit(volume, EntradaCompraTicks, _Symbol, NormalizeDouble(StopLoss, _Digits), NormalizeDouble(TakeProfit, _Digits), ORDER_TIME_DAY, NULL, NULL);
         trade.SellLimit(VentaVolume, EntradaVentaTicks, _Symbol, NormalizeDouble(VentaStopLoss, _Digits), NormalizeDouble(VentaTakeProfit, _Digits), ORDER_TIME_DAY, NULL, NULL);
      }
   }
}