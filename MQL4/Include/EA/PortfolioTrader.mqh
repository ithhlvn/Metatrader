//+------------------------------------------------------------------+
//|                                              PortfolioTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <PLManager\PLManager.mqh>
#include <Schedule\ScheduleSet.mqh>
#include <Signals\SignalSet.mqh>
#include <Signals\ExtremeBreak.mqh>
#include <Signals\AtrBreakout.mqh>
#include <PortfolioManager\PortfolioManager.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PortfolioTrader
  {
private:
   PortfolioManager *portfolioManager;
   SymbolSet        *ss;
   ScheduleSet      *sched;
   OrderManager     *om;
   PLManager        *plman;
   SignalSet        *signalSet;

public:
   void              PortfolioTrader(
                                      string watchedSymbols,int extremeBreakPeriod,int extremeBreakShift,color extremeBreakColor,
                                      int atrMinimumTpSlDistance,ENUM_TIMEFRAMES extremeBreakTimeframe,
                                      int atrPeriod, int atrMultiplier, color atrColor,
                                      int parallelSignals,double lots,double profitTarget,
                                      double maxLoss,int slippage,ENUM_DAY_OF_WEEK startDay,
                                      ENUM_DAY_OF_WEEK endDay,string startTime,string endTime,
                                      bool scheduleIsDaily,bool tradeAtBarOpenOnly);
   void             ~PortfolioTrader();
   void              Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PortfolioTrader::PortfolioTrader(
                                      string watchedSymbols,int extremeBreakPeriod,int extremeBreakShift,color extremeBreakColor,
                                      int atrMinimumTpSlDistance,ENUM_TIMEFRAMES extremeBreakTimeframe,
                                      int atrPeriod, int atrMultiplier, color atrColor,
                                      int parallelSignals,double lots,double profitTarget,
                                      double maxLoss,int slippage,ENUM_DAY_OF_WEEK startDay,
                                      ENUM_DAY_OF_WEEK endDay,string startTime,string endTime,
                                      bool scheduleIsDaily,bool tradeAtBarOpenOnly)
  {
   string symbols=watchedSymbols;
   this.ss=new SymbolSet();
   this.ss.AddSymbolsFromCsv(symbols);

   this.sched=new ScheduleSet();
   if(scheduleIsDaily==true)
     {
      this.sched.AddWeek(startTime,endTime,startDay,endDay);
     }
   else
     {
      this.sched.Add(new Schedule(startDay,startTime,endDay,endTime));
     }

   this.om=new OrderManager();
   this.om.Slippage=slippage;

   this.plman=new PLManager(ss,om);
   this.plman.ProfitTarget=profitTarget;
   this.plman.MaxLoss=maxLoss;
   this.plman.MinAge=60;

   this.signalSet=new SignalSet();
   int i;
   for(i=0;i<parallelSignals;i++)
     {
      this.signalSet.Add(
                         new ExtremeBreak(
                         extremeBreakPeriod,
                         extremeBreakTimeframe,
                         extremeBreakShift+(extremeBreakPeriod*i),
                         extremeBreakColor
                         ));

      this.signalSet.Add(new AtrBreakout(
                         atrPeriod,
                         atrMultiplier,
                         extremeBreakTimeframe,
                         extremeBreakShift+(extremeBreakPeriod*i),
                         atrMinimumTpSlDistance,
                         atrColor));
     }

   this.portfolioManager=new PortfolioManager(lots,this.ss,this.sched,this.om,this.plman,this.signalSet);
   this.portfolioManager.tradeEveryTick=!tradeAtBarOpenOnly;
   this.portfolioManager.Initialize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PortfolioTrader::~PortfolioTrader()
  {
   delete portfolioManager;
   delete ss;
   delete sched;
   delete om;
   delete plman;
   delete signalSet;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PortfolioTrader::Execute()
  {
   this.portfolioManager.Execute();
  }
//+------------------------------------------------------------------+
