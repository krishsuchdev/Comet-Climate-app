//
//  APIManager.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "APIManager.h"
#import "RootPageViewController.h"
#import "WeatherObject.h"

#define serverURL "http://comet-climate-server.herokuapp.com"

@implementation APIManager

- (instancetype)init {
  self = [super init];
  if (self) {
    // Initial values
    self.fetchedWeather = false;
    self.fetchedTwitter = false;
  }
  return self;
}

- (void)fetchWeather {
  NSMutableArray<WeatherObject *> *weather = [[NSMutableArray alloc] init];
  
  // Set up request to the server
  NSString *weatherURL = [NSString stringWithFormat:@"%s/weather", serverURL];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:weatherURL]];
  [request setHTTPMethod:@"GET"];

  // Sending a request to the server
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!error) {
      // Received response from server without any connection errors
      
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      
      if (json && (BOOL)[json objectForKey:@"success"]) {
        // Received JSON data without any other errors from the server
        
        NSDate *currentDate = [NSDate date];
        
        NSDictionary *results = (NSDictionary *)[json objectForKey:@"results"];
        
        // Object to parse the dates given from the server
        NSDateFormatter *isoFormat = [[NSDateFormatter alloc] init];
        isoFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.S";
        isoFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        // Set last weather refresh date
        [self setWeatherLastRefresh:[isoFormat dateFromString:[results objectForKey:@"last_updated"]]];
        
        // Parses and adds the current weather data
        [weather addObject:[[WeatherObject alloc] initWithDate:currentDate condition:[WeatherObject conditionForString:[results objectForKey:@"condition"]] temperature:[[results objectForKey:@"temperature"] integerValue] temperatureHigh:[[results objectForKey:@"high"] integerValue] temperatureLow:[[results objectForKey:@"low"] integerValue] feelsLikeTemperature:[[results objectForKey:@"wind_chill"] integerValue] chanceOfRain:[[results objectForKey:@"precipitation"] integerValue] windSpeed:[[results objectForKey:@"wind_speed"] integerValue] windDirection:[WeatherObject degreesForWindDirection:[results objectForKey:@"wind_direction"]]]];
        
        // Parses and adds the hourly weather data of temperatures and rain chances
        NSArray *forecastTemperatures = [results mutableArrayValueForKey:@"forecast_temp"];
        NSArray *forecastPrecipitation = [results mutableArrayValueForKey:@"forecast_prec"];
        for (int hourAfter = 1; hourAfter <= MIN(forecastTemperatures.count, forecastPrecipitation.count); hourAfter++) {
          [weather addObject:[[WeatherObject alloc] initWithDate:[currentDate dateByAddingTimeInterval:60 * 60 * hourAfter] condition:[weather firstObject].condition temperature:[[forecastTemperatures objectAtIndex:hourAfter - 1] integerValue] chanceOfRain:[[forecastPrecipitation objectAtIndex:hourAfter - 1] integerValue]]];
        }
        
        // Done fetching
        self.fetchedWeather = true;
        self.weather = [[NSArray alloc] initWithArray:weather];
        
        // Update views in the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
          RootPageViewController *root = (RootPageViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
          [root updateViews];
        });
      }
    } else {
      // Error handling
    }
  }] resume];
}

- (void)fetchTwitter {
  NSMutableArray<TwitterObject *> *tweets = [[NSMutableArray alloc] init];
  
  // Set up request to the server
  NSString *twitterURL = [NSString stringWithFormat:@"%s/twitter", serverURL];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:twitterURL]];
  [request setHTTPMethod:@"GET"];
  
  // Sending a request to the server
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!error) {
      // Received response from server without any connection errors
      
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      
      if (json && (BOOL)[json objectForKey:@"success"]) {
        // Received JSON data without any other errors from the server
        
        NSArray *results = [json mutableArrayValueForKey:@"results"];
        
        // Object to parse the dates given from the server
        NSDateFormatter *isoFormat = [[NSDateFormatter alloc] init];
        isoFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        isoFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        // Parses and adds each tweet data
        for (NSDictionary *result in results) {
          [tweets addObject:[[TwitterObject alloc] initWithDisplayName:[result objectForKey:@"user_name"] username:[result objectForKey:@"user_screen_name"] profilePicture:[UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"user_profile_image"]]]] datePosted:[isoFormat dateFromString:[result objectForKey:@"created_at"]] contentText:[result objectForKey:@"text"] likes:[[result objectForKey:@"likes"] integerValue] retweets:[[result objectForKey:@"retweets"] integerValue] tweetID: [result objectForKey:@"tweet_id"]]];
        }
        
        // Sort by the date originally posted
        NSSortDescriptor *dateSortDescriptor;
        dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datePosted" ascending:false];
        [tweets sortUsingDescriptors:@[dateSortDescriptor]];
        
        // Done fetching
        self.fetchedTwitter = true;
        self.tweets = [[NSArray alloc] initWithArray:tweets];
        
        // Update views in the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
          RootPageViewController *root = (RootPageViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
          [root updateViews];
        });
      }
    } else {
      // Error handling
    }
  }] resume];
}

+ (instancetype)sharedInstance {
  // Returning singleton
  
  static APIManager *sharedInstance;
  static dispatch_once_t singleToken;
  dispatch_once(&singleToken, ^{
    sharedInstance = [[APIManager alloc] init];
  });
  return sharedInstance;
}

@end
