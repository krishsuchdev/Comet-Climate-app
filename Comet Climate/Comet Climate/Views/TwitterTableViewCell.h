//
//  TwitterTableViewCell.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwitterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *contentMediaImageView;

@property (weak, nonatomic) IBOutlet UIImageView *likesImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesDataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetsImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetsDataLabel;

@end

NS_ASSUME_NONNULL_END
