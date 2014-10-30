//
//  NewsFeedTableViewCell.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol NewsFeedTableViewCellDelegate <NSObject>

- (void)updateLikeCount:(id)sender;

@end

@interface NewsFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *capturedPhoto;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextView *photoCaptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property id<NewsFeedTableViewCellDelegate> delegate;
@end
