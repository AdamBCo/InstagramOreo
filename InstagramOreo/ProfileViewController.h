//
//  ProfileViewController.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol ProfileViewConrollerDelegate

-(void)segmentedIndex:(int)index;

@end

@interface ProfileViewController : UIViewController

@property id<ProfileViewConrollerDelegate> delegate;



@end
