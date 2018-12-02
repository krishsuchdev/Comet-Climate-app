//
//  TwitterObject.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwitterObject : NSObject

@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *username;
@property (nonatomic) UIImage *profilePicture;

@property (nonatomic) NSDate *datePosted;
@property (nonatomic) NSString *contentText;
@property (nonatomic) UIImage *contentMediaPhoto;

@property (nonatomic) NSInteger likes;
@property (nonatomic) NSInteger retweets;

@property (nonatomic) NSString *tweetID;

- (instancetype)initWithDisplayName:(NSString *)displayName
                           username:(NSString *)username
                     profilePicture:(UIImage *)profilePicture
                         datePosted:(NSDate *)datePosted
                        contentText:(NSString *)contentText
                              likes:(NSInteger)likes
                           retweets:(NSInteger)retweets
                            tweetID:(NSString *)tweetID;

- (instancetype)initWithDisplayName:(NSString *)displayName
                           username:(NSString *)username
                     profilePicture:(UIImage *)profilePicture
                         datePosted:(NSDate *)datePosted
                        contentText:(NSString *)contentText
                  contentMediaPhoto:(UIImage *)contentMediaPhotoName
                              likes:(NSInteger)likes
                           retweets:(NSInteger)retweets
                            tweetID:(NSString *)tweetID;

@end

NS_ASSUME_NONNULL_END
