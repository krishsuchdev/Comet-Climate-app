//
//  WeatherViewController.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

@property (weak, nonatomic) IBOutlet UIView *currentWeatherView;

@property (weak, nonatomic) IBOutlet UILabel *tabTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UIImageView *currentWeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;

@property (weak, nonatomic) IBOutlet UIView *currentHighLowTemperatureView;
@property (weak, nonatomic) IBOutlet UILabel *currentHighLowTemperatureTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentHighLowTemperatureDataLabel;

@property (weak, nonatomic) IBOutlet UIView *currentFeelsLikeRainChanceView;
@property (weak, nonatomic) IBOutlet UILabel *currentFeelsLikeRainChanceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentFeelsLikeRainChanceDataLabel;

@property (weak, nonatomic) IBOutlet UIView *currentWindView;
@property (weak, nonatomic) IBOutlet UILabel *currentWindTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWindSpeedDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWindSpeedUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentWindDirectionImageView;

@property (weak, nonatomic) IBOutlet UITableView *hourlyWeatherTableView;

- (void)updatePresentedData;

@end

NS_ASSUME_NONNULL_END
