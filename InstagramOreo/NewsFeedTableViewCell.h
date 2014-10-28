//
//  NewsFeedTableViewCell.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell
@property UIImage *profileImage;
@property UITextView * photoCaption;
@property NSDate *timeCaptured;
@property UIImage *capturedPhoto;

@end
