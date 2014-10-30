//
//  NotificationTableViewCell.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationTableViewCellDelegate <NSObject>

- (void)followButtonPressed:(id)sender;

@end

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextView *notificationTextView;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property id<NotificationTableViewCellDelegate>delegate;

@end
