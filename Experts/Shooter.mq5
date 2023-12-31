//+------------------------------------------------------------------+
//|                                                         toto.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

// Incluye las bibliotecas necesarias
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

// Declaración de objetos
CTrade trade;
CAccountInfo account;
CPositionInfo positionInfo;

// Parámetros de entrada
input int PeriodoRSI = 3;
input int BarreraRSI = 67;
input double RiesgoPorOperacion = 0.01;
input int PuntosStopLoss = 93;
input int MA = 26;
input double PorcentajeRompimiento = 0.7;
input int MinTamanoVela = 9;
input double BarreraMomentum = 100.01;
input int MomentumPeriodo = 17;

// Variables globales
int handle_long_ma = 0;
double array_ma_long[];
datetime date = 0;
datetime PrevBarTime;
datetime time_0;

// Función de inicialización del asesor experto
int OnInit() {
    handle_long_ma = iMA(Symbol(), PERIOD_CURRENT, MA, 0, MODE_EMA, PRICE_CLOSE);

    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);
    PrevBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
    return (INIT_SUCCEEDED);
}

// Función ejecutada en cada tick del mercado
void OnTick() {
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double multiplier = 1;
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double percentBalance = balance * RiesgoPorOperacion;
    double buyVolume = NormalizeDouble(percentBalance / PuntosStopLoss, _Digits);
    int buy_count = 0;
    datetime TiempoLocal = TimeCurrent();
    string date = TimeToString(TimeCurrent(), TIME_MINUTES);
    time_0 = iTime(_Symbol, PERIOD_CURRENT, 0);

    MqlDateTime FechaTiempo;
    TimeToStruct(TiempoLocal, FechaTiempo);
    ArraySetAsSeries(array_ma_long, true);
    CopyBuffer(handle_long_ma, 0, 1, 2, array_ma_long);

    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        PositionGetTicket(i);
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
            buy_count++;
        }
    }

    if (buy_count > 0) return;

    if (time_0 != PrevBarTime) {
        PrevBarTime = time_0;

        double tmano = iClose(_Symbol, PERIOD_CURRENT, 1) - iOpen(_Symbol, PERIOD_CURRENT, 1);
        double distancia = iClose(_Symbol, PERIOD_CURRENT, 1) - array_ma_long[1];

        if (FechaTiempo.day_of_week == 4 || FechaTiempo.day_of_week == 5) return;

        if (RSI(1) > BarreraRSI && MOMENTUM(1) > BarreraMomentum && iOpen(_Symbol, PERIOD_CURRENT, 1) < array_ma_long[1] &&
            iClose(_Symbol, PERIOD_CURRENT, 1) > array_ma_long[1] && distancia / tmano > PorcentajeRompimiento &&
            tmano > MinTamanoVela) {
            double entry = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            trade.Buy(buyVolume, Symbol(), NormalizeDouble(entry, _Digits), NormalizeDouble(entry - PuntosStopLoss, _Digits),
                      NormalizeDouble(entry + PuntosStopLoss, _Digits), NULL);
        }
    }
}

// Función para calcular el RSI
double RSI(int posicion) {
    double RSIArray[];
    CopyBuffer(iRSI(_Symbol, PERIOD_CURRENT, PeriodoRSI, PRICE_CLOSE), 0, 0, 3, RSIArray);
    ArraySetAsSeries(RSIArray, true);
    return NormalizeDouble(RSIArray[posicion], _Digits);
}

// Función para calcular el MOMENTUM
double MOMENTUM(int posicion) {
    double MOMENTUMArray[];
    CopyBuffer(iMomentum(_Symbol, PERIOD_CURRENT, MomentumPeriodo, PRICE_CLOSE), 0, 0, 3, MOMENTUMArray);
    ArraySetAsSeries(MOMENTUMArray, true);
    return (NormalizeDouble(MOMENTUMArray[posicion], _Digits));
}