//
//  NotificationsTableViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "NotificationTableViewCell.h"
#import <Parse/Parse.h>
#import "Follow.h"

@interface NotificationsTableViewController () <NotificationTableViewCellDelegate>

@property NSArray *listOfFollows;

@end

@implementation NotificationsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"NOTIFICATIONS";
    self.listOfFollows = [NSArray array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self queryUsersImFollowing];
}

- (void)queryUsersImFollowing
{
    self.listOfFollows = [NSArray array];
    PFQuery *query = [Follow query];
    [query whereKey:@"userWhoFollowed" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
        else
        {
            self.listOfFollows = [self.listOfFollows arrayByAddingObjectsFromArray:objects];
            [self.tableView reloadData];
        }
    }];

//    PFQuery *query2 = [Follow query];
//    [query2 whereKey:@"userBeingFollowed" equalTo:[PFUser currentUser]];
//    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@",error.localizedDescription);
//        }
//        else
//        {
//            //NSLog(@"%@", objects)
//            self.listOfFollows = [self.listOfFollows arrayByAddingObjectsFromArray:objects];
//            NSLog(@"%@ 1", self.listOfFollows);
//            [self.tableView reloadData];
//        }
//    }];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfFollows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Follow *follower = [self.listOfFollows objectAtIndex:indexPath.row];
    PFUser *userFollower = follower.userBeingFollowed;

    [userFollower fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        cell.notificationTextView.text = userFollower.username;
    }];

    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

#pragma mark - NotificationTableViewCell Delegate Methods

- (void)followButtonPressed:(UIButton *)followButton
{
    CGPoint buttonPosition = [followButton convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    // Get pfuser of selected user
    Follow *followUser = [self.listOfFollows objectAtIndex:indexPath.row];
    PFUser *selectedUser = followUser.userBeingFollowed;

    // Get get string of selected user's name
    __block NSString *selectedPostUserName;
    [selectedUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        selectedPostUserName = selectedUser.username;
    }];
    // Follow or Unfollow user depending on what was tapped. 
    if (![selectedPostUserName isEqualToString:[PFUser currentUser].username])
    {
        [Follow updateFollowingStatusAndButton:followButton selectedUser:selectedUser loggedInUser:[PFUser currentUser]];

//        NSMutableArray *mutableFollowers = [NSMutableArray arrayWithArray:self.listOfFollows];
//        [mutableFollowers removeObjectAtIndex:indexPath.row];
//        self.listOfFollows = [NSArray arrayWithArray:mutableFollowers];
//        [self.tableView reloadData];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
