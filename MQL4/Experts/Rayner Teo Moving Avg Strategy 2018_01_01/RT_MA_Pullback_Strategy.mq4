//+------------------------------------------------------------------+
//|                                      RT_MA_Pullback_Strategy.mq4 |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version    "1.0"
#property description "Implementation of the \"Moving Average Trading Strategy\""
#property description "described by Rayner Teo in his video at"
#property description "https://youtu.be/clAQxb-PMSI"
#property strict

#include <EA\RT_MA_Pullback_Strategy\RT_MA_Pullback_Strategy.mqh>
#include <EA\RT_MA_Pullback_Strategy\RT_MA_Pullback_StrategySettings.mqh>
#include <EA\RT_MA_Pullback_Strategy\RT_MA_Pullback_StrategyConfig.mqh>

RT_MA_Pullback_Strategy *bot;
#include <EA\PortfolioManagerBasedBot\BasicEATemplate.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   RT_MA_Pullback_StrategyConfig config;

   GetBasicConfigs(config);

   config.timeframe=PortfolioTimeframe;
   config.maPeriod=MAPeriod;
   config.maPullbackPeriod=MAPullbackPeriod;
   config.maPullbackTests=MAPullbackTests;
   config.maThresholdPeriod=MAThresholdPeriod;
   config.maThresholdColor=MAThresholdColor;
   config.minimumTpSlDistance=MinimumTpSlDistance;
   config.maColor=MAColor;
   config.maPullbackColor=MAPullbackColor;
   config.exitsByHighLowPeriod=ExitsByHighLowPeriod;
   config.exitSignalColor=ExitSignalColor;
   config.followTrend=FollowTrend;
   config.followTrendTrailingStopPeriod=FollowTrendTrailingStopPeriod;
   config.initializeTrailingStopTo1Atr=InitializeTrailingStopTo1Atr;

   bot=new RT_MA_Pullback_Strategy(config);
  }
//+------------------------------------------------------------------+
