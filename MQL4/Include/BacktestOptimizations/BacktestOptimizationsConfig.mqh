//+------------------------------------------------------------------+
//|                                  BacktestOptimizationsConfig.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\Config.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct BacktestOptimizationsConfig : public Config
  {
public:
   double            InitialScore;
   double            GainsStdDevLimitMax,GainsStdDevLimitMin;
   int               GainsStdDevLimitWeight;
   double            LossesStdDevLimitMax,LossesStdDevLimitMin;
   int               LossesStdDevLimitWeight;
   double            NetProfitRangeMax,NetProfitRangeMin;
   int               NetProfitRangeWeight;
   double            ExpectancyRangeMax,ExpectancyRangeMin;
   int               ExpectancyRangeWeight;
   double            TradesPerDayRangeMax,TradesPerDayRangeMin;
   int               TradesPerDayRangeWeight;
   double            LargestLossPerTotalGainLimit;
   int               LargestLossPerTotalGainWeight;
   double            MedianLossPerMedianGainPercentLimit;
   int               MedianLossPerMedianGainPercentWeight;
   int               FactorBy_GainsSlopeUpward_Granularity;
   void BacktestOptimizationsConfig():InitialScore(100)
   ,GainsStdDevLimitMin(0),GainsStdDevLimitMax(0),GainsStdDevLimitWeight(1)
   ,LossesStdDevLimitMax(0),LossesStdDevLimitMin(0),LossesStdDevLimitWeight(1)
   ,NetProfitRangeMax(0),NetProfitRangeMin(0),NetProfitRangeWeight(1)
   ,ExpectancyRangeMax(0),ExpectancyRangeMin(0),ExpectancyRangeWeight(1)
   ,TradesPerDayRangeMax(0),TradesPerDayRangeMin(0),TradesPerDayRangeWeight(1)
   ,LargestLossPerTotalGainLimit(0),LargestLossPerTotalGainWeight(1)
   ,MedianLossPerMedianGainPercentLimit(0),MedianLossPerMedianGainPercentWeight(1)
   ,FactorBy_GainsSlopeUpward_Granularity(0)
     {
     }
  };
//+------------------------------------------------------------------+
