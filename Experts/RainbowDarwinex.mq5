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

string dateTo = "23:00";
string dateFrom = "17:00";
int RSI_Period = 1;

// TICKS
double TICKS_1 = 0.00001;
double TICKS_3 = 0.00001;
double TICKS_2 = 0.00396;
double TICKS_4 = 0.00893;
double TICKS_5 = 0.00531;
double TICKS_6 = 0.00002;
double TICKS_7 = 0.00977;
double TICKS_8 = 0.00839;
double TICKS_9 = 0.00969;
double TICKS_10 = 0.00353;

int TREND_EMA = 23000;
int handle_trend_ema = 0;
double array_ema_trend[];

// INPUT LONG EMA
int LONG_EMA_1 = 286;
int LONG_EMA_2 = 236;
int LONG_EMA_3 = 238;
int LONG_EMA_4 = 279;
int LONG_EMA_5 = 283;
int LONG_EMA_6 = 208;
int LONG_EMA_7 = 213;
int LONG_EMA_8 = 369;
int LONG_EMA_9 = 335;
int LONG_EMA_10 = 211;


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


// INPUT SHORT EMA
int SHORT_EMA_1 = 178;
int SHORT_EMA_2 = 479;
int SHORT_EMA_3 = 209;
int SHORT_EMA_4 = 404;
int SHORT_EMA_5 = 369;
int SHORT_EMA_6 = 446;
int SHORT_EMA_7 = 454;
int SHORT_EMA_8 = 158;
int SHORT_EMA_9 = 219;
int SHORT_EMA_10 = 451;


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



// Función de inicialización del asesor experto
int OnInit()
{
    handle_trend_ema = iMA(_Symbol, PERIOD_CURRENT, TREND_EMA, 0, MODE_EMA, PRICE_CLOSE);
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
   

    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
    PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
    return (INIT_SUCCEEDED);
}

// Función de desinicialización del asesor experto
void OnDeinit(const int reason)
{
    // Puedes agregar lógica de desinicialización si es necesario
}


input double riesgoBuscado = 0.01;

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
    

   /** ticks x 100.000 **/

    datetime TiempoLocal = TimeCurrent();
    MqlDateTime FechaTiempo;
    TimeToStruct(TiempoLocal, FechaTiempo);
     // if (FechaTiempo.day_of_week == 5) return;
    string date = TimeToString(TimeCurrent(), TIME_MINUTES);
    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
   
    if (time_0 != PrevBarTime)
    {
        PrevBarTime = time_0;
        double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         
        ArraySetAsSeries(array_ema_trend, true);
        CopyBuffer(handle_trend_ema, 0, 1, 2, array_ema_trend);

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

        double multiplier = 1;
        if (FechaTiempo.day_of_week == 4) return;
        if (date >= dateFrom && date < dateTo)
        {
            if (RSI(0) < RSI(1) && RSI(2) < RSI(1)) return;
        
            double balance = AccountInfoDouble(ACCOUNT_BALANCE);
            double valorPosicon = NormalizeDouble(balance * riesgoBuscado, _Digits);

            double entry = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            
            
            if(entry < array_ema_trend[1]) return;
            // Lógica de compra
            if (array_ema_long_1[0] > array_ema_short_1[0] && array_ema_long_1[1] < array_ema_short_1[1])
            {
                double pips = NormalizeDouble(TICKS_1*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2); 
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_1, _Digits), NormalizeDouble(entry + TICKS_1, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }

            if (array_ema_long_2[0] > array_ema_short_2[0] && array_ema_long_2[1] < array_ema_short_2[1])
            {
                double pips = NormalizeDouble(TICKS_2*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);

                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_2, _Digits), NormalizeDouble(entry + TICKS_2, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_3[0] > array_ema_short_3[0] && array_ema_long_3[1] < array_ema_short_3[1])
            {
                double pips = NormalizeDouble(TICKS_3*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_3, _Digits), NormalizeDouble(entry + TICKS_3, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_4[0] > array_ema_short_4[0] && array_ema_long_4[1] < array_ema_short_4[1])
            {
                double pips = NormalizeDouble(TICKS_4*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_4, _Digits), NormalizeDouble(entry + TICKS_4, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_5[0] > array_ema_short_5[0] && array_ema_long_5[1] < array_ema_short_5[1])
            {
                double pips = NormalizeDouble(TICKS_5*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_5, _Digits), NormalizeDouble(entry + TICKS_5, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_6[0] > array_ema_short_6[0] && array_ema_long_6[1] < array_ema_short_6[1])
            {
                double pips = NormalizeDouble(TICKS_6*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_6, _Digits), NormalizeDouble(entry + TICKS_6, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_7[0] > array_ema_short_7[0] && array_ema_long_7[1] < array_ema_short_7[1])
            {
                double pips = NormalizeDouble(TICKS_7*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_7, _Digits), NormalizeDouble(entry + TICKS_7, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_8[0] > array_ema_short_8[0] && array_ema_long_8[1] < array_ema_short_8[1])
            {
                double pips = NormalizeDouble(TICKS_8*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_8, _Digits), NormalizeDouble(entry + TICKS_8, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_9[0] > array_ema_short_9[0] && array_ema_long_9[1] < array_ema_short_9[1])
            {
                double pips = NormalizeDouble(TICKS_9*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_9, _Digits), NormalizeDouble(entry + TICKS_9, _Digits), NULL);
                SendNotification(_Symbol + "Operacion abierta");
            }
            if (array_ema_long_10[0] > array_ema_short_10[0] && array_ema_long_10[1] < array_ema_short_10[1])
            {
                double pips = NormalizeDouble(TICKS_10*100000, _Digits);
                double volume = NormalizeDouble(valorPosicon / pips,2);
                trade.Buy(volume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - TICKS_10, _Digits), NormalizeDouble(entry + TICKS_10, _Digits), NULL);
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