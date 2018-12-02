//
//  APIManager.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherObject.h"
#import "TwitterObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (nonatomic) BOOL fetchedWeather;
@property (nonatomic) NSArray<WeatherObject *> *weather;
@property (nonatomic) NSDate *weatherLastRefresh;

@property (nonatomic) BOOL fetchedTwitter;
@property (nonatomic) NSArray<TwitterObject *> *tweets;

- (void)fetchWeather;
- (void)fetchTwitter;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
