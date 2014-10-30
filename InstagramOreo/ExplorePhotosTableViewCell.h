//
//  ExplorePhotosTableViewCell.h
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol ExplorePhotoDetailCellDelegate <NSObject>

- (void)followButtonPressed:(id)sender;

@end

@interface ExplorePhotosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *capturedPhoto;

@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextView *photoCaptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property id<ExplorePhotoDetailCellDelegate>delegate;

@end
