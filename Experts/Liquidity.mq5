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
input double percentRisk = 0.02;

// Compra
float SLCompra = 1.38;
float SLCompraTP = 0.13;
int ticksForActivo = 100000;

double High = 0.0;
double Low = 0.0;
float Rango = 0.0;
bool ordenEnviada = false;

int MA = 8851;
int MA_2 = 5992;

int handle_long_ma = 0;
double array_ma_long[];

int handle_validation_ma = 0;
double array_ma_validation[];

input bool BalanceFijo = true;
double entrada = 0.0;
double entradaLow = 0.0;
int OnInit()
{
   time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
   PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   handle_long_ma = iMA(Symbol(), PERIOD_CURRENT, MA, 0, MODE_EMA, PRICE_CLOSE);
   handle_validation_ma = iMA(Symbol(), PERIOD_CURRENT, MA_2, 0, MODE_EMA, PRICE_CLOSE);
   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
}

void OnTick()
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   if (BalanceFijo)
   {
      balance = 100000;
   }
   time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
   if (time_0 != PrevBarTime)
   {
      PrevBarTime = time_0;
      ArraySetAsSeries(array_ma_long, true);
      CopyBuffer(handle_long_ma, 0, 1, 2, array_ma_long);
      ArraySetAsSeries(array_ma_validation, true);
      CopyBuffer(handle_validation_ma, 0, 1, 2, array_ma_validation);
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
            double currentLow = iLow(_Symbol, PERIOD_CURRENT, i);
            double currentHigh = iHigh(_Symbol, PERIOD_CURRENT, i);

            if (i == 0)
            {
               Low = currentLow;
               High = currentHigh;
               entrada = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
               entradaLow = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            }

            if (Low > currentLow)
               Low = currentLow;

            if (High < currentHigh)
            {
               High = currentHigh;
               entrada = NormalizeDouble(High, _Digits);
               entradaLow = NormalizeDouble(Low, _Digits);
            }
         }
         ordenEnviada = true;
         entrada = NormalizeDouble(High, SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
         entradaLow = NormalizeDouble(Low, SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));

         float ranged = High - Low;
         float StopLoss = entrada - SLCompra * ranged;
         float TakeProfit = entrada + SLCompraTP * ranged;

         float TakeProfitLow = entradaLow + SLCompraTP * ranged;
         float StopLossLow = entradaLow - SLCompra * ranged;
         double pips = NormalizeDouble((entrada - StopLoss) * ticksForActivo, _Digits);
         double volume = NormalizeDouble(balance * percentRisk / pips, 2);

         if (array_ma_long[1] > High)
         {
            trade.SellLimit(volume, High, _Symbol, TakeProfit, StopLoss, ORDER_TIME_DAY, NULL, NULL);
         }
         else if (array_ma_validation[1] > Low)
         {
            trade.SellStop(volume, entradaLow, _Symbol, TakeProfitLow, StopLossLow, ORDER_TIME_DAY, NULL, NULL);
         }
      }
   }
}
