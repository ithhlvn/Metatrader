//+------------------------------------------------------------------+
//|                                         AbstractSignalConfig.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct AbstractSignalConfig
  {
public:
   int               Period;
   ENUM_TIMEFRAMES   Timeframe;
   int               Shift;
   double            MinimumTpSlDistance;
   color             IndicatorColor;

   void AbstractSignalConfig()
     {
      this.Period=240;
      this.Timeframe=PERIOD_D1;
      this.Shift=0;
      this.MinimumTpSlDistance=2.0;
      this.IndicatorColor=clrAqua;
     };
  };
//+------------------------------------------------------------------+
