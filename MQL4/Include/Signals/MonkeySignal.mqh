//+------------------------------------------------------------------+
//|                                                 MonkeySignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\MonkeySignalBase.mqh>
#include <Signals\RsiBands.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MonkeySignal : public MonkeySignalBase
  {
private:
   datetime          _lastTrigger;
   RsiBands         *_rsiBands;
   MonkeySignalConfig _config;
public:
                     MonkeySignal(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL);
                    ~MonkeySignal();
   SignalResult     *Analyzer(string symbol,int shift);
   virtual bool Validate(ValidationResult *v);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignal::MonkeySignal(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL):MonkeySignalBase(config,aSubSignal)
  {
   this._lastTrigger=TimeCurrent();
   this._config=config;
   this._rsiBands=new RsiBands(config.RsiBands);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonkeySignal::~MonkeySignal()
  {
   delete this._rsiBands;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MonkeySignal::Validate(ValidationResult *v)
  {
   AbstractSignal::Validate(v);
   this._rsiBands.Validate(v);
   
   if(!this._compare.IsGreaterThanOrEqualTo(this._config.TriggerLevel,0.0))
     {
      v.Result=false;
      v.AddMessage("Trigger level must be zero or greater.");
     }
   
//   if(!this._compare.IsGreaterThan(this._config.BollingerBandThreshold,0.0))
//     {
//      v.Result=false;
//      v.AddMessage("Bollinger band threshold must be greater than zero.");
//     }
//   
//   if(!this._compare.IsGreaterThan(this._config.BollingerBandPeriod,0))
//     {
//      v.Result=false;
//      v.AddMessage("Bollinger band period must be greater than zero.");
//     }
   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *MonkeySignal::Analyzer(string symbol,int shift)
  {
   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   CandleMetrics *candle=this.GetCandleMetrics(symbol,shift);

   if(gotTick && candle.IsSet && candle.Time!=this._lastTrigger)
     {
      double atr=this.GetAtr(symbol,shift)*this._config.TriggerLevel;
      PriceRange trigger;
      trigger.high=candle.Open+atr;
      trigger.low=candle.Open-atr;

      this.DrawIndicatorRectangle(symbol,shift,trigger.high,trigger.low,NULL,1);
      
      //double bbUpperThreshold=this.GetBollingerBands(symbol,shift,this._config.BollingerBandThreshold,0,PRICE_CLOSE,MODE_UPPER,this._config.BollingerBandPeriod);
      //double bbLowerThreshold=this.GetBollingerBands(symbol,shift,this._config.BollingerBandThreshold,0,PRICE_CLOSE,MODE_LOWER,this._config.BollingerBandPeriod);

      bool sellSignal=false,buySignal=false;

      if(candle.High>=trigger.high || candle.Low<=trigger.low)
        {
         sellSignal=this._rsiBands.IsSellSignal(symbol,shift);// && bbLowerThreshold>tick.bid;
         buySignal=this._rsiBands.IsBuySignal(symbol,shift);// && bbUpperThreshold<tick.ask;
        }
        
      if(_compare.Xor(sellSignal,buySignal))
        {
         bool setTp=this._rsiBands.IsInMidBand(symbol,shift);
         if(sellSignal)
           {
            this.SetSellSignal(symbol,shift,tick,setTp);
           }

         if(buySignal)
           {
            this.SetBuySignal(symbol,shift,tick,setTp);
           }

         // signal confirmation
         if(!this.DoesSubsignalConfirm(symbol,shift))
           {
            this.Signal.Reset();
           }
         else
           {
            this._lastTrigger=candle.Time;
           }
        }
      else
        {
         this.Signal.Reset();
        }
     }

// if there is an order open...
   if(1<=OrderManager::PairOpenPositionCount(symbol,TimeCurrent()))
     {
      this.SetExits(symbol,shift,tick);
     }

   delete candle;
   return this.Signal;
  }
//+------------------------------------------------------------------+
