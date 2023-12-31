//+------------------------------------------------------------------+
//|                                                         toto.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

// Incluimos las bibliotecas necesarias para operar y obtener información de la cuenta
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

CTrade trade;
CAccountInfo account;
CPositionInfo positionInfo;

datetime date = 0;
datetime PrevBarTime;
datetime time_0;

input int initialBalance = 100000;

input string dateTo = "21:00";
input string dateFrom = "05:00";
input int RSI_Period = 4820;
input double percentRisk = 0.01;
// TICKS
input int TICKS_1 = 75;
input int TICKS_3 = 20;
input int TICKS_2 = 70;
input int TICKS_4 = 25;
input int TICKS_5 = 70;
input int TICKS_6 = 20;
input int TICKS_7 = 85;
input int TICKS_8 = 15;
input int TICKS_9 = 30;
input int TICKS_10 = 70;
input int TICKS_11 = 40;
input int TICKS_12 = 40;
input int TICKS_13 = 40;
input int TICKS_14 = 30;
input int TICKS_15 = 60;
input int TICKS_16 = 90;
input int TICKS_17 = 15;
input int TICKS_18 = 30;
input int TICKS_19 = 30;
input int TICKS_20 = 15;

// INPUT LONG EMA
input int LONG_EMA_1 = 5700;
input int LONG_EMA_2 = 5700;
input int LONG_EMA_3 = 2900;
input int LONG_EMA_4 = 4400;
input int LONG_EMA_5 = 5600;
input int LONG_EMA_6 = 5500;
input int LONG_EMA_7 = 4100;
input int LONG_EMA_8 = 7200;
input int LONG_EMA_9 = 4600;
input int LONG_EMA_10 = 6900;
input int LONG_EMA_11 = 6000;
input int LONG_EMA_12 = 3300;
input int LONG_EMA_13 = 3500;
input int LONG_EMA_14 = 3200;
input int LONG_EMA_15 = 5700;
input int LONG_EMA_16 = 6600;
input int LONG_EMA_17 = 2000;
input int LONG_EMA_18 = 3500;
input int LONG_EMA_19 = 4300;
input int LONG_EMA_20 = 6800;

// MANEJADOR LONG EMA
int handle_long_ema_1 = 0;
int handle_long_ema_2 = 0;
int handle_long_ema_3 = 0;
int handle_long_ema_4 = 0;
int handle_long_ema_5 = 0;
int handle_long_ema_6 = 0;
int handle_long_ema_7 = 0;
int handle_long_ema_8 = 0;
int handle_long_ema_9 = 0;
int handle_long_ema_10 = 0;
int handle_long_ema_11 = 0;
int handle_long_ema_12 = 0;
int handle_long_ema_13 = 0;
int handle_long_ema_14 = 0;
int handle_long_ema_15 = 0;
int handle_long_ema_16 = 0;
int handle_long_ema_17 = 0;
int handle_long_ema_18 = 0;
int handle_long_ema_19 = 0;
int handle_long_ema_20 = 0;

// ARRAY DE VALOR LONG EMA
double array_ema_long_1[];
double array_ema_long_2[];
double array_ema_long_3[];
double array_ema_long_4[];
double array_ema_long_5[];
double array_ema_long_6[];
double array_ema_long_7[];
double array_ema_long_8[];
double array_ema_long_9[];
double array_ema_long_10[];
double array_ema_long_11[];
double array_ema_long_12[];
double array_ema_long_13[];
double array_ema_long_14[];
double array_ema_long_15[];
double array_ema_long_16[];
double array_ema_long_17[];
double array_ema_long_18[];
double array_ema_long_19[];
double array_ema_long_20[];

// INPUT SHORT EMA
input int SHORT_EMA_1 = 7300;
input int SHORT_EMA_2 = 6100;
input int SHORT_EMA_3 = 3300;
input int SHORT_EMA_4 = 3900;
input int SHORT_EMA_5 = 5600;
input int SHORT_EMA_6 = 6700;
input int SHORT_EMA_7 = 5000;
input int SHORT_EMA_8 = 7300;
input int SHORT_EMA_9 = 7300;
input int SHORT_EMA_10 = 3300;
input int SHORT_EMA_11 = 5600;
input int SHORT_EMA_12 = 3300;
input int SHORT_EMA_13 = 5800;
input int SHORT_EMA_14 = 3700;
input int SHORT_EMA_15 = 6800;
input int SHORT_EMA_16 = 4000;
input int SHORT_EMA_17 = 2600;
input int SHORT_EMA_18 = 5900;
input int SHORT_EMA_19 = 5000;
input int SHORT_EMA_20 = 7100;

// MANEJADOR LONG EMA
int handle_short_ema_1 = 0;
int handle_short_ema_2 = 0;
int handle_short_ema_3 = 0;
int handle_short_ema_4 = 0;
int handle_short_ema_5 = 0;
int handle_short_ema_6 = 0;
int handle_short_ema_7 = 0;
int handle_short_ema_8 = 0;
int handle_short_ema_9 = 0;
int handle_short_ema_10 = 0;
int handle_short_ema_11 = 0;
int handle_short_ema_12 = 0;
int handle_short_ema_13 = 0;
int handle_short_ema_14 = 0;
int handle_short_ema_15 = 0;
int handle_short_ema_16 = 0;
int handle_short_ema_17 = 0;
int handle_short_ema_18 = 0;
int handle_short_ema_19 = 0;
int handle_short_ema_20 = 0;

// ARRAY DE VALOR LONG EMA
double array_ema_short_1[];
double array_ema_short_2[];
double array_ema_short_3[];
double array_ema_short_4[];
double array_ema_short_5[];
double array_ema_short_6[];
double array_ema_short_7[];
double array_ema_short_8[];
double array_ema_short_9[];
double array_ema_short_10[];
double array_ema_short_11[];
double array_ema_short_12[];
double array_ema_short_13[];
double array_ema_short_14[];
double array_ema_short_15[];
double array_ema_short_16[];
double array_ema_short_17[];
double array_ema_short_18[];
double array_ema_short_19[];
double array_ema_short_20[];

// Función de inicialización del asesor experto
int OnInit()
{
    // Manejadores de EMA LONG
    handle_long_ema_1 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_1, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_2 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_2, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_3 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_3, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_4 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_4, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_5 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_5, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_6 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_6, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_7 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_7, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_8 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_8, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_9 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_9, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_10 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_10, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_11 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_11, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_12 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_12, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_13 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_13, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_14 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_14, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_15 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_15, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_16 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_16, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_17 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_17, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_18 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_18, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_19 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_19, 0, MODE_EMA, PRICE_CLOSE);
    handle_long_ema_20 = iMA(_Symbol, PERIOD_CURRENT, LONG_EMA_20, 0, MODE_EMA, PRICE_CLOSE);

    // Manejadores de EMA SHORT
    handle_short_ema_1 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_1, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_2 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_2, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_3 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_3, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_4 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_4, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_5 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_5, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_6 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_6, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_7 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_7, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_8 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_8, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_9 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_9, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_10 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_10, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_11 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_11, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_12 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_12, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_13 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_13, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_14 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_14, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_15 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_15, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_16 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_16, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_17 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_17, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_18 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_18, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_19 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_19, 0, MODE_EMA, PRICE_CLOSE);
    handle_short_ema_20 = iMA(_Symbol, PERIOD_CURRENT, SHORT_EMA_20, 0, MODE_EMA, PRICE_CLOSE);

    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
    PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
    return (INIT_SUCCEEDED);
}

// Función de desinicialización del asesor experto
void OnDeinit(const int reason)
{
    // Puedes agregar lógica de desinicialización si es necesario
}

// Función principal que se ejecuta en cada tick
void OnTick()
{
    int buy_count = 0;
    for (int i = PositionsTotal() - 1; i >= 0; i--)
    {
        PositionGetTicket(i);
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
        {
            buy_count++;
        }
    }
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double percentBalance = balance * percentRisk;

    datetime TiempoLocal = TimeCurrent();
    MqlDateTime FechaTiempo;
    TimeToStruct(TiempoLocal, FechaTiempo);

    string date = TimeToString(TimeCurrent(), TIME_MINUTES);
    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
    if (buy_count > 1)
        return;
    if (time_0 != PrevBarTime)
    {
        PrevBarTime = time_0;
        double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);

        // LONG SERIES
        ArraySetAsSeries(array_ema_long_1, true);
        ArraySetAsSeries(array_ema_long_2, true);
        ArraySetAsSeries(array_ema_long_3, true);
        ArraySetAsSeries(array_ema_long_4, true);
        ArraySetAsSeries(array_ema_long_5, true);
        ArraySetAsSeries(array_ema_long_6, true);
        ArraySetAsSeries(array_ema_long_7, true);
        ArraySetAsSeries(array_ema_long_8, true);
        ArraySetAsSeries(array_ema_long_9, true);
        ArraySetAsSeries(array_ema_long_10, true);
        ArraySetAsSeries(array_ema_long_11, true);
        ArraySetAsSeries(array_ema_long_12, true);
        ArraySetAsSeries(array_ema_long_13, true);
        ArraySetAsSeries(array_ema_long_14, true);
        ArraySetAsSeries(array_ema_long_15, true);
        ArraySetAsSeries(array_ema_long_16, true);
        ArraySetAsSeries(array_ema_long_17, true);
        ArraySetAsSeries(array_ema_long_18, true);
        ArraySetAsSeries(array_ema_long_19, true);
        ArraySetAsSeries(array_ema_long_20, true);
        // Copy Buffer LONG EMA
        CopyBuffer(handle_long_ema_1, 0, 1, 2, array_ema_long_1);
        CopyBuffer(handle_long_ema_2, 0, 1, 2, array_ema_long_2);
        CopyBuffer(handle_long_ema_3, 0, 1, 2, array_ema_long_3);
        CopyBuffer(handle_long_ema_4, 0, 1, 2, array_ema_long_4);
        CopyBuffer(handle_long_ema_5, 0, 1, 2, array_ema_long_5);
        CopyBuffer(handle_long_ema_6, 0, 1, 2, array_ema_long_6);
        CopyBuffer(handle_long_ema_7, 0, 1, 2, array_ema_long_7);
        CopyBuffer(handle_long_ema_8, 0, 1, 2, array_ema_long_8);
        CopyBuffer(handle_long_ema_9, 0, 1, 2, array_ema_long_9);
        CopyBuffer(handle_long_ema_10, 0, 1, 2, array_ema_long_10);
        CopyBuffer(handle_long_ema_11, 0, 1, 2, array_ema_long_11);
        CopyBuffer(handle_long_ema_12, 0, 1, 2, array_ema_long_12);
        CopyBuffer(handle_long_ema_13, 0, 1, 2, array_ema_long_13);
        CopyBuffer(handle_long_ema_14, 0, 1, 2, array_ema_long_14);
        CopyBuffer(handle_long_ema_15, 0, 1, 2, array_ema_long_15);
        CopyBuffer(handle_long_ema_16, 0, 1, 2, array_ema_long_16);
        CopyBuffer(handle_long_ema_17, 0, 1, 2, array_ema_long_17);
        CopyBuffer(handle_long_ema_18, 0, 1, 2, array_ema_long_18);
        CopyBuffer(handle_long_ema_19, 0, 1, 2, array_ema_long_19);
        CopyBuffer(handle_long_ema_20, 0, 1, 2, array_ema_long_20);
        // SHORT SERIES
        ArraySetAsSeries(array_ema_short_1, true);
        ArraySetAsSeries(array_ema_short_2, true);
        ArraySetAsSeries(array_ema_short_3, true);
        ArraySetAsSeries(array_ema_short_4, true);
        ArraySetAsSeries(array_ema_short_5, true);
        ArraySetAsSeries(array_ema_short_6, true);
        ArraySetAsSeries(array_ema_short_7, true);
        ArraySetAsSeries(array_ema_short_8, true);
        ArraySetAsSeries(array_ema_short_9, true);
        ArraySetAsSeries(array_ema_short_10, true);
        ArraySetAsSeries(array_ema_short_11, true);
        ArraySetAsSeries(array_ema_short_12, true);
        ArraySetAsSeries(array_ema_short_13, true);
        ArraySetAsSeries(array_ema_short_14, true);
        ArraySetAsSeries(array_ema_short_15, true);
        ArraySetAsSeries(array_ema_short_16, true);
        ArraySetAsSeries(array_ema_short_17, true);
        ArraySetAsSeries(array_ema_short_18, true);
        ArraySetAsSeries(array_ema_short_19, true);
        ArraySetAsSeries(array_ema_short_20, true);

        // SHORT COPY BUFFER
        CopyBuffer(handle_short_ema_1, 0, 1, 2, array_ema_short_1);
        CopyBuffer(handle_short_ema_2, 0, 1, 2, array_ema_short_2);
        CopyBuffer(handle_short_ema_3, 0, 1, 2, array_ema_short_3);
        CopyBuffer(handle_short_ema_4, 0, 1, 2, array_ema_short_4);
        CopyBuffer(handle_short_ema_5, 0, 1, 2, array_ema_short_5);
        CopyBuffer(handle_short_ema_6, 0, 1, 2, array_ema_short_6);
        CopyBuffer(handle_short_ema_7, 0, 1, 2, array_ema_short_7);
        CopyBuffer(handle_short_ema_8, 0, 1, 2, array_ema_short_8);
        CopyBuffer(handle_short_ema_9, 0, 1, 2, array_ema_short_9);
        CopyBuffer(handle_short_ema_10, 0, 1, 2, array_ema_short_10);
        CopyBuffer(handle_short_ema_11, 0, 1, 2, array_ema_short_11);
        CopyBuffer(handle_short_ema_12, 0, 1, 2, array_ema_short_12);
        CopyBuffer(handle_short_ema_13, 0, 1, 2, array_ema_short_13);
        CopyBuffer(handle_short_ema_14, 0, 1, 2, array_ema_short_14);
        CopyBuffer(handle_short_ema_15, 0, 1, 2, array_ema_short_15);
        CopyBuffer(handle_short_ema_16, 0, 1, 2, array_ema_short_16);
        CopyBuffer(handle_short_ema_17, 0, 1, 2, array_ema_short_17);
        CopyBuffer(handle_short_ema_18, 0, 1, 2, array_ema_short_18);
        CopyBuffer(handle_short_ema_19, 0, 1, 2, array_ema_short_19);
        CopyBuffer(handle_short_ema_20, 0, 1, 2, array_ema_short_20);

        if (RSI(0) < RSI(1) && RSI(2) < RSI(1))
            return;

        double multiplier = 1;

        if (date >= dateFrom && date < dateTo)
        {

            // Lógica de compra
            if (array_ema_long_1[0] > array_ema_short_1[0] && array_ema_long_1[1] < array_ema_short_1[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_1, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_1, _Digits), NormalizeDouble(entry + TICKS_1, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_2[0] > array_ema_short_2[0] && array_ema_long_2[1] < array_ema_short_2[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_2, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_2, _Digits), NormalizeDouble(entry + TICKS_2, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_3[0] > array_ema_short_3[0] && array_ema_long_3[1] < array_ema_short_3[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_3, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_3, _Digits), NormalizeDouble(entry + TICKS_3, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_4[0] > array_ema_short_4[0] && array_ema_long_4[1] < array_ema_short_4[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_4, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_4, _Digits), NormalizeDouble(entry + TICKS_4, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_5[0] > array_ema_short_5[0] && array_ema_long_5[1] < array_ema_short_5[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_5, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_5, _Digits), NormalizeDouble(entry + TICKS_5, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_6[0] > array_ema_short_6[0] && array_ema_long_6[1] < array_ema_short_6[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_6, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_6, _Digits), NormalizeDouble(entry + TICKS_6, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_7[0] > array_ema_short_7[0] && array_ema_long_7[1] < array_ema_short_7[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_7, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_7, _Digits), NormalizeDouble(entry + TICKS_7, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_8[0] > array_ema_short_8[0] && array_ema_long_8[1] < array_ema_short_8[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_8, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_8, _Digits), NormalizeDouble(entry + TICKS_8, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_9[0] > array_ema_short_9[0] && array_ema_long_9[1] < array_ema_short_9[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_9, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_9, _Digits), NormalizeDouble(entry + TICKS_9, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_10[0] > array_ema_short_10[0] && array_ema_long_10[1] < array_ema_short_10[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_10, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_10, _Digits), NormalizeDouble(entry + TICKS_10, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_11[0] > array_ema_short_11[0] && array_ema_long_11[1] < array_ema_short_11[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_11, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_11, _Digits), NormalizeDouble(entry + TICKS_11, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_12[0] > array_ema_short_12[0] && array_ema_long_12[1] < array_ema_short_12[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_12, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_12, _Digits), NormalizeDouble(entry + TICKS_12, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_13[0] > array_ema_short_13[0] && array_ema_long_13[1] < array_ema_short_13[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_13, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_13, _Digits), NormalizeDouble(entry + TICKS_13, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_14[0] > array_ema_short_14[0] && array_ema_long_14[1] < array_ema_short_14[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_14, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_14, _Digits), NormalizeDouble(entry + TICKS_14, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_15[0] > array_ema_short_15[0] && array_ema_long_15[1] < array_ema_short_15[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_15, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_15, _Digits), NormalizeDouble(entry + TICKS_15, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_16[0] > array_ema_short_16[0] && array_ema_long_16[1] < array_ema_short_16[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_16, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_16, _Digits), NormalizeDouble(entry + TICKS_16, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_17[0] > array_ema_short_17[0] && array_ema_long_17[1] < array_ema_short_17[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_17, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_17, _Digits), NormalizeDouble(entry + TICKS_17, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_18[0] > array_ema_short_18[0] && array_ema_long_18[1] < array_ema_short_18[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_18, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_18, _Digits), NormalizeDouble(entry + TICKS_18, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_19[0] > array_ema_short_19[0] && array_ema_long_19[1] < array_ema_short_19[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_19, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_19, _Digits), NormalizeDouble(entry + TICKS_19, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_20[0] > array_ema_short_20[0] && array_ema_long_20[1] < array_ema_short_20[1])
            {
                double volume = NormalizeDouble(percentBalance / TICKS_20, _Digits) * multiplier;
                double entry = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_20, _Digits), NormalizeDouble(entry + TICKS_20, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
        }
    }
}

double RSI(int posicion)
{
    double RSIArray[];
    CopyBuffer(iRSI(_Symbol, PERIOD_CURRENT, RSI_Period, PRICE_CLOSE), 0, 0, 3, RSIArray);
    ArraySetAsSeries(RSIArray, true);
    return NormalizeDouble(RSIArray[posicion], _Digits);
}

double deal_profitY()
{

    ulong ticket;
    int consectuve = 0;
    double deal_profit = 0;

    if (HistorySelect(0, TimeCurrent()))
    {

        for (int i = HistoryDealsTotal(); i >= HistoryDealsTotal() - 24; i--)
        {
            ticket = HistoryDealGetTicket(i);
            if ((HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT))
            {

                deal_profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                if (deal_profit > 0)
                {
                    break;
                }
                consectuve++;
            }
        }
    }
    return (consectuve);
}