//
//  ExplorePhotoDetailViewController.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExplorePhotoDetailViewController.h"
#import "ExplorePhotosTableViewCell.h"
#import "Follow.h"

@interface ExplorePhotoDetailViewController () <UITableViewDelegate, UITableViewDataSource, ExplorePhotoDetailCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property PFUser *user;


@end

@implementation ExplorePhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"PHOTO";

    self.user = [PFUser currentUser];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplorePhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;

    //UserName
    [self.selectedPost usernameWithCompletionBlock:^(NSString *username) {
        cell.usernameLabel.text = username;
    }];

    PFQuery *query = [Follow query];
    [query whereKey:@"userBeingFollowed" equalTo:self.selectedPost.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
        else
        {
            if (objects.count > 0 ) {
                [cell.followButton setTitle:@"unfollow" forState:UIControlStateNormal];
            }
            else {
                [cell.followButton setTitle:@"follow" forState:UIControlStateNormal];
            }
        }
    }];

    //Image
    [self.selectedPost standardImageWithCompletionBlock:^(UIImage *photo) {
        cell.capturedPhoto.image = photo;
    }];

    //PhotoCaption
    cell.photoCaptionTextView.text = self.selectedPost.caption;

    //TimeLabel
    cell.timeLabel.text = self.selectedPost.timeCreatedString;
    
    return cell;
}

#pragma mark - Follow / Unfollow User 

- (void)followButtonPressed:(UIButton *)followButton
{
    // Get selectedPost's userName
    __block NSString *selectedPostUserName;
    [self.selectedPost usernameWithCompletionBlock:^(NSString *username) {
        selectedPostUserName = username;
    }];

    if (![selectedPostUserName isEqualToString:self.user.username])
    {
        [Follow updateFollowingStatusAndButton:followButton selectedUser:self.selectedPost.user loggedInUser:self.user];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
