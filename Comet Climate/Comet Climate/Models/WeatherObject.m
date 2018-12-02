//
//  WeatherObject.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherObject.h"

@implementation WeatherObject

- (instancetype)initWithDate:(NSDate *)date
                   condition:(enum WeatherCondition)condition
                 temperature:(NSInteger)temperature
                chanceOfRain:(NSInteger)chanceOfRain {
  // Initialize a WeatherObject when only given a few parameters. Used for hourly weather where data such as the feels like temperature may not be available
  self = [self initWithDate:date
                  condition:condition
                temperature:temperature
            temperatureHigh:temperature
             temperatureLow:temperature
       feelsLikeTemperature:temperature
               chanceOfRain:chanceOfRain
                  windSpeed:0
              windDirection:0];
  return self;
}

- (instancetype)initWithDate:(NSDate *)date
                   condition:(enum WeatherCondition)condition
                 temperature:(NSInteger)temperature
             temperatureHigh:(NSInteger)temperatureHigh
              temperatureLow:(NSInteger)temperatureLow
        feelsLikeTemperature:(NSInteger)feelsLikeTemperature
                chanceOfRain:(NSInteger)chanceOfRain
                   windSpeed:(NSInteger)windSpeed
               windDirection:(NSInteger)windDirection {
  // Initialize a WeatherObject when given all parameters and used for current weather.
  self = [super init];
  if (self) {
    self.date = date;
    self.condition = condition;
    self.temperature = temperature;
    self.temperatureHigh = temperatureHigh;
    self.temperatureLow = temperatureLow;
    self.feelsLikeTemperature = feelsLikeTemperature;
    self.chanceOfRain = chanceOfRain;
    self.windSpeed = windSpeed;
    self.windDirection = windDirection;
  }
  return self;
}

+ (enum WeatherCondition)conditionForString:(NSString *)condition {
  // Logic for which weather condition to display
  if ([condition containsString:@"Clear"] || [condition containsString:@"Fair"])
    return WeatherConditionSun;
  else if ([condition containsString:@"Partly Cloudy"] || [condition containsString:@"Mostly Cloudy"])
    return WeatherConditionPartialCloud;
  else if ([condition containsString:@"Overcast"] || [condition containsString:@"Cloudy"] || [condition containsString:@"Fog"])
    return WeatherConditionCloud;
  else if ([condition containsString:@"Rain"] || [condition containsString:@"Showers"] || [condition containsString:@"Mist"])
    return WeatherConditionRain;
  else if ([condition containsString:@"Storm"] || [condition containsString:@"Thunder"] || [condition containsString:@"Hurricane"])
    return WeatherConditionStorm;
  else if ([condition containsString:@"Snow"])
    return WeatherConditionSnow;
  else
    return WeatherConditionSnow; // Acting as an unknown value, cuz it never snows in Texas :/
}

+ (UIImage *)imageForWeatherCondition:(enum WeatherCondition)condition asBackground:(BOOL)asBackground {
  // Return the icon or background image for the displaying weather condition
  
  NSString *imageName = @"";
  switch (condition) {
    case WeatherConditionSun:
      imageName = @"Sunny";
      break;
    case WeatherConditionPartialCloud:
      imageName = @"Partial Cloudy";
      break;
    case WeatherConditionCloud:
      imageName = @"Cloudy";
      break;
    case WeatherConditionRain:
      imageName = @"Rainy";
      break;
    case WeatherConditionStorm:
      imageName = @"Stormy";
      break;
    case WeatherConditionSnow:
      imageName = @"Snowy";
      break;
    default:
      break;
  }
  if (asBackground) imageName = [NSString stringWithFormat:@"%@ Background", imageName];
  
  return [UIImage imageNamed:imageName];
}

+ (NSInteger)degreesForWindDirection:(NSString *)windDirection {
  double degrees = 0.0;
  NSArray *directions = [NSArray arrayWithObjects:@"N", @"NNE", @"NE", @"ENE", @"E", @"ESE", @"SE", @"SSE", @"S", @"SSW", @"SW", @"WSW", @"W", @"WNW", @"NW", @"NNW", nil];
  for (NSString *direction in directions) {
    degrees += 22.5;
    if ([windDirection isEqualToString:direction]) break;
  }
  return (NSInteger)round(degrees);
}

@end
