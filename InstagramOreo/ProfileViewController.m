//
//  ProfileViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCollectionViewController.h"
#import "ProfileCollectionViewCell.h"

#import "UserProfileTableViewController.h"
#import "UserProfileTableViewCell.h"

@interface ProfileViewController ()
@property NSArray *userPhotos;
@property NSArray *tableViewCellsNeeded;
@property NSArray *celltasticArray;
@property NSInteger counterPlus;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.counterPlus = 0;
}


- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:

            [self.delegate segmentedIndex:YES];
            break;
        case 1:
            [self.delegate segmentedIndex:NO];
        default:
            break;
    }
}




@end
