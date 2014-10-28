//
//  ExplorePhotosTableViewCell.h
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ExplorePhotosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *capturedPhoto;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextView *photoCaptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
