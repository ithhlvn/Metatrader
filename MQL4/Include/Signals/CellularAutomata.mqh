//+------------------------------------------------------------------+
//|                                             CellularAutomata.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\CellularAutomataBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CellularAutomata : public CellularAutomataBase
  {
public:
                     CellularAutomata(int period,ENUM_TIMEFRAMES timeframe,double minimumSpreadsTpSl,double skew,AbstractSignal *aSubSignal=NULL);
   SignalResult     *Analyzer(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CellularAutomata::CellularAutomata(int period,ENUM_TIMEFRAMES timeframe,double minimumSpreadsTpSl,double skew,AbstractSignal *aSubSignal=NULL):CellularAutomataBase(period,timeframe,0,minimumSpreadsTpSl,skew,aSubSignal)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *CellularAutomata::Analyzer(string symbol,int shift)
  {
// if there are no orders open...
   if(0>=OrderManager::PairOpenPositionCount(symbol,TimeCurrent()))
     {
      MqlTick tick;
      bool gotTick=SymbolInfoTick(symbol,tick);
      // and there's a fresh tick on the symbol's chart
      if(gotTick)
        {
         PriceRange pr=this.CalculateRangingRange(symbol,shift,5,tick);
         bool isRangeMode=this.IsRangeMode(symbol,shift,5,tick);
         bool sell=tick.bid<pr.mid;
         bool buy=tick.ask>pr.mid;
         bool sellSignal=(_compare.Ternary(isRangeMode,buy,sell));
         bool buySignal=(_compare.Ternary(isRangeMode,sell,buy));
         // Sell when the last order was a buy order that lost, or a sell order that won
         if(sellSignal)
           {
            this.SetSellSignal(symbol,shift,tick);
           }
         // Buy when the last order was a sell order that lost, or a buy order that won
         else if(buySignal)
           {
            this.SetBuySignal(symbol,shift,tick);
           }

         // signal confirmation
         if(!this.DoesSubsignalConfirm(symbol,shift))
           {
            this.Signal.Reset();
           }
        }
     }

// if there is an order open...
   if(1<=OrderManager::PairOpenPositionCount(symbol,TimeCurrent()))
     {
      MqlTick tick;
      bool gotTick=SymbolInfoTick(symbol,tick);
      // and there's a fresh tick on the symbol's chart
      if(gotTick)
        {
         this.SetExits(symbol,shift,tick);
        }
     }

   return this.Signal;
  }
//+------------------------------------------------------------------+
