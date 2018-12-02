//
//  TwitterViewController.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwitterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (nonatomic) UIRefreshControl *tweetsRefresh;

- (void)updatePresentedData;

@end

NS_ASSUME_NONNULL_END
