//+------------------------------------------------------------------+
//|                                  BollingerBandPullbackTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Criteria:"
#property description "1. Price touches bollinger band."
#property description "2. Price pulls back to the moving average."
#property description "3. Enter order anticipating price to move toward touched bollinger band."
#property description "4. Stopout level is to be controlled by Atr defined range around current price."
#property strict

#include <Signals\AtrExits.mqh>
#include <Signals\MovingAveragePullback.mqh>
#include <Signals\BollingerBandsTouch.mqh>
#include <EA\PortfolioManagerBasedBot\BasePortfolioManagerBot.mqh>
#include <EA\BollingerBandPullbackTrader\BollingerBandPullbackTraderConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BollingerBandPullbackTrader : public BasePortfolioManagerBot
  {
public:
   void              BollingerBandPullbackTrader(BollingerBandPullbackTraderConfig &config);
   void             ~BollingerBandPullbackTrader();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BollingerBandPullbackTrader::BollingerBandPullbackTrader(BollingerBandPullbackTraderConfig &config):BasePortfolioManagerBot(config)
  {
   this.signalSet.ExitSignal=new AtrExits(
                                          config.bollingerBandPullbackAtrPeriod,
                                          config.bollingerBandPullbackAtrMultiplier,
                                          config.bollingerBandPullbackTimeframe,
                                          config.atrSkew,
                                          config.bollingerBandPullbackShift,
                                          1,
                                          config.bollingerBandPullbackAtrColor);
   int i;
   for(i=0;i<config.parallelSignals;i++)
     {
      this.signalSet.Add(
                         new BollingerBandsTouch(
                         config.bollingerBandPullbackBbPeriod+(config.bollingerBandPullbackBbPeriod*i),
                         config.bollingerBandPullbackTimeframe,
                         config.bollingerBandPullbackFadeTouch,
                         config.bollingerBandPullbackTouchPeriod,
                         config.bollingerBandPullbackBbDeviation,
                         config.bollingerBandPullbackBbAppliedPrice,
                         config.bollingerBandPullbackTouchShift,
                         config.bollingerBandPullbackBbShift,
                         config.bollingerBandPullbackShift,
                         config.bollingerBandPullbackMinimumTpSlDistance,
                         config.bollingerBandPullbackBbIndicatorColor,
                         config.bollingerBandPullbackTouchIndicatorColor
                         ));
      this.signalSet.Add(
                         new MovingAveragePullback(
                         config.bollingerBandPullbackMaPeriod+(config.bollingerBandPullbackMaPeriod*i),
                         config.bollingerBandPullbackTimeframe,
                         config.bollingerBandPullbackMaMethod,
                         config.bollingerBandPullbackMaAppliedPrice,
                         config.bollingerBandPullbackMaShift,
                         config.bollingerBandPullbackShift,
                         config.bollingerBandPullbackMaColor));
     }
   this.Initialize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BollingerBandPullbackTrader::~BollingerBandPullbackTrader()
  {
   delete this.signalSet.ExitSignal;
  }
//+------------------------------------------------------------------+
