//
//  WeatherObject.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherObject : NSObject

enum WeatherCondition {
  WeatherConditionSun,
  WeatherConditionPartialCloud,
  WeatherConditionCloud,
  WeatherConditionRain,
  WeatherConditionStorm,
  WeatherConditionSnow
};

@property (nonatomic) NSDate *date;

@property (nonatomic) enum WeatherCondition condition;
@property (nonatomic) NSInteger temperature;

@property (nonatomic) NSInteger temperatureHigh;
@property (nonatomic) NSInteger temperatureLow;

@property (nonatomic) NSInteger feelsLikeTemperature;
@property (nonatomic) NSInteger chanceOfRain;

@property (nonatomic) NSInteger windSpeed;
@property (nonatomic) NSInteger windDirection;

- (instancetype)initWithDate:(NSDate *)date
                   condition:(enum WeatherCondition)condition
                 temperature:(NSInteger)temperature
                chanceOfRain:(NSInteger)chanceOfRain;

- (instancetype)initWithDate:(NSDate *)date
                   condition:(enum WeatherCondition)condition
                 temperature:(NSInteger)temperature
             temperatureHigh:(NSInteger)temperatureHigh
              temperatureLow:(NSInteger)temperatureLow
        feelsLikeTemperature:(NSInteger)feelsLikeTemperature
                chanceOfRain:(NSInteger)chanceOfRain
                   windSpeed:(NSInteger)windSpeed
               windDirection:(NSInteger)windDirection;

+ (enum WeatherCondition)conditionForString:(NSString *)condition;
+ (UIImage *)imageForWeatherCondition:(enum WeatherCondition)condition asBackground:(BOOL)asBackground;
+ (NSInteger)degreesForWindDirection:(NSString *)windDirection;

@end

NS_ASSUME_NONNULL_END
