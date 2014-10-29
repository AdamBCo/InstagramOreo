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
@property (weak, nonatomic) IBOutlet UIView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UIView *photoTableView;



@property (strong, nonatomic) ProfileCollectionViewController *photoCollectionViewController;
@property (strong, nonatomic) UserProfileTableViewController *photoTableViewController;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.counterPlus = 0;
}


- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            self.photoCollectionView.hidden = NO;
            self.photoTableView.hidden = YES;
            break;
        case 1:
            self.photoCollectionView.hidden = YES;
            self.photoTableView.hidden = NO;
        default:
            break;
    }
}




@end
