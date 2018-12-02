//
//  WeatherViewController.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherTableViewCell.h"
#import "APIManager.h"
#import "WeatherObject.h"

@interface WeatherViewController () {
  NSTimer *_secondaryWeatherDataSlotTimer;
}

@end

@implementation WeatherViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Sets both secondary weather data slots to be visible and starts animation countdowns
  self.currentFeelsLikeRainChanceView.alpha = self.currentWindView.alpha = 1.0;
  [self resetSecondaryWeatherDataSlotTimer];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // Refresh content before user sees the view controller
  [self updatePresentedData];
}

- (void)resetSecondaryWeatherDataSlotTimer {
  // Stops any ongoing timer
  if (_secondaryWeatherDataSlotTimer) [_secondaryWeatherDataSlotTimer invalidate];
  
  // Replaces old timer with a new one
  _secondaryWeatherDataSlotTimer = [NSTimer timerWithTimeInterval:6.0 repeats:true block:^(NSTimer * _Nonnull timer) {
    // No animation should occur the first time the view controller calls this method
    BOOL instantAnimation = self.currentFeelsLikeRainChanceView.alpha == self.currentWindView.alpha;
    [UIView animateWithDuration:instantAnimation ? 0.0 : 1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
      if (self.currentWindView.alpha == 1.0) {
        // If the wind data is currently showing
        self.currentFeelsLikeRainChanceView.alpha = 1.0;
        self.currentWindView.alpha = 0.0;
      } else {
        // If the feels like and rain chance is currently showing
        self.currentFeelsLikeRainChanceView.alpha = 0.0;
        self.currentWindView.alpha = 1.0;
      }
    } completion:^(BOOL finished) {
      if (self.currentWindView.alpha == 1.0) {
        // Animate the wind direction arrow if it is currently not in the correct spot
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          // Convert the wind direction in degrees to radians
          double radiansWindDirection = [[APIManager sharedInstance].weather objectAtIndex:0].windDirection * M_PI / 180.0;
          self.currentWindDirectionImageView.transform = CGAffineTransformMakeRotation(radiansWindDirection);
        } completion:^(BOOL finished) {
        }];
      }
    }];
  }];
  
  // Start the timer
  [_secondaryWeatherDataSlotTimer fire];
  [NSRunLoop.currentRunLoop addTimer:_secondaryWeatherDataSlotTimer forMode:NSRunLoopCommonModes];
}

- (void)updatePresentedData {
  // Reload all content without stopping any ongoing animations
  
  if ([APIManager sharedInstance].fetchedWeather) {
    // Animate the data to appear if previously hidden
    [UIView animateWithDuration:0.5 animations:^{
      self.currentWeatherView.alpha = 1.0;
      self.hourlyWeatherTableView.alpha = 1.0;
    }];
    
    // Get current weather data
    WeatherObject *weather = [[APIManager sharedInstance].weather objectAtIndex:0];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitDay) fromDate:weather.date];
    
    // Set the background designated for the current weather conditions
    [self.backgroundImage setImage:[WeatherObject imageForWeatherCondition:weather.condition asBackground:true]];
    // Show a darker background if it is night-time or early morning
    if (dateComponents.hour <= 6 || dateComponents.hour > 12 + 6)
      [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    else
      [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    // Update the data at the top of the view to current weather conditions
    [self.currentWeatherIcon setImage:[WeatherObject imageForWeatherCondition:weather.condition asBackground:false]];
    [self.currentTemperatureLabel setText:[NSString stringWithFormat:@"%lu˚", weather.temperature]];
    [self.currentHighLowTemperatureDataLabel setText:[NSString stringWithFormat:@"%lu˚\n%lu˚", weather.temperatureHigh, weather.temperatureLow]];
    
    // Update feels like and rain chance
    NSMutableAttributedString *currentFeelsLikeRainChance = [[NSMutableAttributedString alloc] init];
    // Feels like font color should be white
    [currentFeelsLikeRainChance appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu˚\n", weather.feelsLikeTemperature] attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor}]];
    // Rain chance font color should be blue
    [currentFeelsLikeRainChance appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu%%", weather.chanceOfRain] attributes:@{NSForegroundColorAttributeName : [[UIColor alloc] initWithRed:50/255.0 green:150/255.0 blue:255/255.0 alpha:1.0]}]];
    [self.currentFeelsLikeRainChanceDataLabel setAttributedText:currentFeelsLikeRainChance];
    
    // Update wind speed labels
    [self.currentWindSpeedDataLabel setText:[NSString stringWithFormat:@"%lu", weather.windSpeed]];
  } else {
    // If there is no data yet, hide all content
    self.currentWeatherView.alpha = 0.0;
    self.hourlyWeatherTableView.alpha = 0.0;
  }
  
  // Refresh hourly weather
  [self.hourlyWeatherTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return MAX(0, [APIManager sharedInstance].weather.count - 1);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  // Designing a custom view for section header
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 24.0)];
  
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0, 0.0, headerView.frame.size.width - 39.0, headerView.frame.size.height)];
  [headerLabel setText:[APIManager sharedInstance].fetchedWeather ? [NSString stringWithFormat:@"Next %lu Hours", [APIManager sharedInstance].weather.count - 1].uppercaseString : @"- -"];
  [headerLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16.0]];
  [headerLabel setTextColor:[UIColor.whiteColor colorWithAlphaComponent:0.5]];
  
  [headerView addSubview:headerLabel];
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 24.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Setting up the cells displaying the forecast for each hour
  
  WeatherTableViewCell *cell = (WeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HourWeather"];
  
  // Get weather data for current hour
  WeatherObject *weather = [[APIManager sharedInstance].weather objectAtIndex:indexPath.row + 1];
  NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitDay) fromDate:weather.date];
  
  // Update labels and images
  [cell.hourNumberLabel setText:[NSString stringWithFormat:@"%lu", (dateComponents.hour + 11) % 12 + 1]];
  [cell.timeOfDayLabel setText:dateComponents.hour < 12 ? @"AM" : @"PM"];
  [cell.weatherIcon setImage:[WeatherObject imageForWeatherCondition:weather.condition asBackground:false]];
  [cell.predictedTemperatureLabel setText:[NSString stringWithFormat:@"%lu˚", weather.temperature]];
  [cell.chanceOfRainLabel setText:[NSString stringWithFormat:@"%lu%%", weather.chanceOfRain]];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0;
}

- (IBAction)secondaryWeatherDataSlotTapped:(UITapGestureRecognizer *)sender {
  // Called when user taps the secondary weather data slot
  
  // Animates to the other view
  [self resetSecondaryWeatherDataSlotTimer];
}

- (IBAction)weatherInfoButtonTapped:(UIButton *)sender {
  // Displays other weather info
  
  // Do not present an alert if weather data hasn't been received yet
  if (![APIManager sharedInstance].fetchedWeather)
    return;
  
  // Date format to display to the user
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMM d, yyyy 'at' h:mm a";
  
  // Set up alert titles and messages
  UIAlertController *weatherInfo = [UIAlertController alertControllerWithTitle:@"Weather Info" message:[NSString stringWithFormat:@"Weather Data provided by the National Weather Service in the Richardson, TX area.\n\nLast Refresh: %@", [dateFormatter stringFromDate: [APIManager sharedInstance].weatherLastRefresh]] preferredStyle:UIAlertControllerStyleAlert];
  // Add "OK" button to alert
  [weatherInfo addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  }]];
  [weatherInfo setPreferredAction:[weatherInfo.actions firstObject]];
  
  // Display alert to current view
  [self presentViewController:weatherInfo animated:true completion:^{
  }];
}

@end
