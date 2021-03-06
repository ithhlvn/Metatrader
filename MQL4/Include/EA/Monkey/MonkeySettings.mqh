//+------------------------------------------------------------------+
//|                                               MonkeySettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

sinput string MonkeySettings1; // ####
sinput string MonkeySettings2; // #### Signal Settings
sinput string MonkeySettings3; // ####

input int BotAtrPeriod=120; // Period for calculating trigger and exit ranges.
input double BotAtrTriggerLevel=1; // ATR Entry Trigger Level. (distance from candle open)
input color BotAtrIndicatorColor=clrAqua; // Atr Trigger Indicator Color.
input double BotAtrExitsMultiplier=0.5; // SL Padding Multiplier.
input double BotMinimumTpSlDistance=3.0; // Tp/Sl minimum distance, in spreads.

sinput string MonkeySettings6; // #### Define Range, RSI controls range trades.
input int BotRangePeriod=14; // Range Period.
input int BotRangeShift=1; // Range Shift.
sinput string MonkeySettings6_1; // #### No trades are placed when price is within the filter zone.
input double BotRangeNullZoneWidth=33.0; // Range Noise Filter. (% of center)
input color BotIndicatorColorRangeNull=clrRed; // Range Noise Filter Indicator Color.

sinput string MonkeySettings7; // #### Define Trend threshold, ADX controls trend trades.
sinput string MonkeySettings7_1; // #### When price breaks above or below the highest
sinput string MonkeySettings7_2; // #### or lowest price in the range, the beginning of
sinput string MonkeySettings7_3; // #### a trend is assumed.
input int BotTrendPeriod=120; // Trend Period.
input int BotTrendShift=12; // Trend Shift.
input double BotTrendBufferWidth=100.0; // Trend Buffer Width. (% adjust calculated size)
input color BotIndicatorColorTrendNull=clrYellow; // Trend Threshold Indicator Color.

sinput string MonkeySettings8; // #### RSI Settings.
input int BotRsiPeriod=14; // RSI Period.
input double BotRsiWidebandHigh=70.0; // RSI Overbought Level.
input double BotRsiWidebandLow=30.0; // RSI Oversold Level.
sinput string MonkeySettings4; // #### Trades opened when RSI is in the midband will have a TP set.
input double BotRsiMidbandHigh=65.0; // RSI Midband High.
input double BotRsiMidbandLow=35.0; // RSI Midband Low.
sinput string MonkeySettings5; // #### No trades are placed when RSI is between the Noise High and Low.
input double BotRsiNullbandHigh=55.0; // RSI Noise High.
input double BotRsiNullbandLow=45.0; // RSI Noise Low.

sinput string MonkeySettings9; // #### ADX Settings.
input int BotAdxPeriod=14; // ADX Period.
input double BotAdxThreshold=30; // ADX Main Signal Threshold.

input color BotIndicatorColorArrows=clrMediumTurquoise; // Arrow Indicator Color.
      
#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
//+------------------------------------------------------------------+
