//
//  TwitterObject.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "TwitterObject.h"

@implementation TwitterObject

- (instancetype)initWithDisplayName:(NSString *)displayName
                           username:(NSString *)username
                     profilePicture:(UIImage *)profilePicture
                         datePosted:(NSDate *)datePosted
                        contentText:(NSString *)contentText
                              likes:(NSInteger)likes
                           retweets:(NSInteger)retweets
                            tweetID:(NSString *)tweetID {
  // Initialize a TwitterObject without any media content.
  self = [super init];
  if (self) {
    self.displayName = displayName;
    self.username = username;
    self.profilePicture = profilePicture;
    self.datePosted = datePosted;
    self.contentText = contentText;
    self.likes = likes;
    self.retweets = retweets;
    self.tweetID = tweetID;
  }
  return self;
}

- (instancetype)initWithDisplayName:(NSString *)displayName
                           username:(NSString *)username
                     profilePicture:(UIImage *)profilePicture
                         datePosted:(NSDate *)datePosted
                        contentText:(NSString *)contentText
                  contentMediaPhoto:(UIImage *)contentMediaPhotoName
                              likes:(NSInteger)likes
                           retweets:(NSInteger)retweets
                            tweetID:(NSString *)tweetID {
  // Initialize a TwitterObject when media content is available.
  self = [super init];
  if (self) {
    self.displayName = displayName;
    self.username = username;
    self.profilePicture = profilePicture;
    self.datePosted = datePosted;
    self.contentText = contentText;
    self.contentMediaPhoto = contentMediaPhotoName;
    self.likes = likes;
    self.retweets = retweets;
    self.tweetID = tweetID;
  }
  return self;
}

@end
