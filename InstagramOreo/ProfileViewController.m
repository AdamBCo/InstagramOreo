//
//  ProfileViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfileTableViewController.h"
#import "UserProfileTableViewCell.h"

@interface ProfileViewController ()
@property NSArray *userPhotos;
@property NSArray *tableViewCellsNeeded;
@property NSArray *celltasticArray;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.delegate segmentedIndex:0];
            NSLog(@"Plop");
            break;
        case 1:
            [self.delegate segmentedIndex:1];
            NSLog(@"Plug");
            break;

        default:
            break;
    }
}




@end
