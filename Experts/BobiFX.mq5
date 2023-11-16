//+------------------------------------------------------------------+
//|                                                         toto.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// TF 5M
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

// Incluye las bibliotecas necesarias
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

// Declaración de objetos
CTrade trade;
CAccountInfo account;
CPositionInfo positionInfo;

input double PercentStopLoss = 0.005;
input double MinTamanoVela = 9;
input double diffVelaAnt = 1.37703;
input double SL = 0.00959;
input int MA = 82;
input int MAValidation = 1;
input int MATrend = 33322;

datetime date = 0;
datetime PrevBarTime;
datetime time_0;

int handle_long_ma = 0;
double array_ma_long[];

int handle_validation_ma = 0;
double array_ma_validation[];

int handle_trend_ma = 0;
double array_ma_trend[];

// Función de inicialización del asesor experto
int OnInit()
{
    handle_long_ma = iMA(Symbol(), PERIOD_CURRENT, MA, 0, MODE_EMA, PRICE_CLOSE);
    handle_trend_ma = iMA(Symbol(), PERIOD_CURRENT, MATrend, 0, MODE_EMA, PRICE_CLOSE);
    handle_validation_ma = iMA(Symbol(), PERIOD_CURRENT, MAValidation, 0, MODE_EMA, PRICE_CLOSE);
    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
    PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
    return (INIT_SUCCEEDED);
}

// Función ejecutada en cada tick del mercado
void OnTick()
{
    ArraySetAsSeries(array_ma_long, true);
    CopyBuffer(handle_long_ma, 0, 1, 2, array_ma_long);
    ArraySetAsSeries(array_ma_trend, true);
    CopyBuffer(handle_trend_ma, 0, 1, 2, array_ma_trend);
    ArraySetAsSeries(array_ma_validation, true);
    CopyBuffer(handle_validation_ma, 0, 1, 2, array_ma_validation);
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double buyVolume = 1;
    int buy_count = 0;
    datetime TiempoLocal = TimeCurrent();
    string date = TimeToString(TimeCurrent(), TIME_MINUTES);
    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);

    MqlDateTime FechaTiempo;
    TimeToStruct(TiempoLocal, FechaTiempo);

    if (time_0 != PrevBarTime)
    {

        if (array_ma_long[1] < array_ma_validation[1])
            return;
        PrevBarTime = time_0;
        double velaActual = iClose(_Symbol, PERIOD_CURRENT, 1) - iOpen(_Symbol, PERIOD_CURRENT, 1);
        double velaAnter = iOpen(_Symbol, PERIOD_CURRENT, 2) - iClose(_Symbol, PERIOD_CURRENT, 2);
        if (velaActual == 0)
            return;
        double diffVelas = velaAnter / velaActual;
        double pips = NormalizeDouble(SL * 100000, _Digits);

        double volume = NormalizeDouble(balance * PercentStopLoss / pips, 2);
        if (iOpen(_Symbol, PERIOD_CURRENT, 1) < iClose(_Symbol, PERIOD_CURRENT, 1) &&
            iOpen(_Symbol, PERIOD_CURRENT, 2) > iClose(_Symbol, PERIOD_CURRENT, 2) &&
            diffVelas > diffVelaAnt &&
            array_ma_long[1] < iClose(_Symbol, PERIOD_CURRENT, 1) &&
            array_ma_trend[1] < array_ma_long[1]

        )
        {
            double entry = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - SL, _Digits), NormalizeDouble(entry + SL, _Digits), NULL);
        }
    }
}
