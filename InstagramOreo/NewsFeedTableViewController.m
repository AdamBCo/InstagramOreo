//
//  NewsFeedTableViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "NewsFeedTableViewCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "Like.h"
#import "Follow.h"

@interface NewsFeedTableViewController () <NewsFeedTableViewCellDelegate>

@property NSArray *arrayOfPhotoObjects;
@property UIRefreshControl *refreshControl;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(getMyfollowersImages) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"The current user is: %@", currentUser.username);
        [self.tabBarController.tabBar setHidden:NO];
        [self getMyfollowersImages];

    }
    else {
        [self performSegueWithIdentifier:@"ShowLoginSegue" sender:self];
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)onLogoutButtonPressed:(id)sender
{
    [PFUser logOut];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPhotoObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Post *photoPost = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedCell"];
    cell.delegate = self;

    //UserName
    [photoPost usernameWithCompletionBlock:^(NSString *username) {
        cell.userNameLabel.text = username;
    }];
    
    //Image
    [photoPost standardImageWithCompletionBlock:^(UIImage *photo) {
        cell.capturedPhoto.image = photo;
    }];
    
    //PhotoCaption
    cell.photoCaptionTextView.text = photoPost.caption;

    // Set the like button title
    PFQuery *query = [Like query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"post" equalTo:photoPost];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error error quering like: %@",error.localizedDescription);
        }
        else
        {
            if (objects.firstObject) {
                [cell.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
            }
            else
            {
                [cell.likeButton setTitle:@"Like" forState:UIControlStateNormal];
            }
        }
    }];

    //Likes
    cell.likesLabel.text = photoPost.likes.stringValue;

    //TimeLabel
    cell.timeLabel.text = photoPost.timeCreatedString;
    return cell;
}

- (void)getMyfollowersImages
{
    PFQuery *query = [Follow query];
    [query whereKey:@"userWhoFollowed" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error error quering like: %@",error.localizedDescription);
        }
        else
        {
            self.arrayOfPhotoObjects = [NSArray array];
            for (Follow *follower in objects) {
                PFQuery *postQuery = [Post query];

                [postQuery whereKey:@"user" equalTo:follower.userBeingFollowed];
                [postQuery orderByDescending:@"createdAt"];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objectsArray, NSError *error) {
                    if (error) {
                        NSLog(@"%@", error.localizedDescription);
                        [self.refreshControl endRefreshing];
                    }
                    else
                    {
                        if (![self.arrayOfPhotoObjects containsObject:objectsArray.firstObject]) {

                            self.arrayOfPhotoObjects = [self.arrayOfPhotoObjects arrayByAddingObjectsFromArray:objectsArray];
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                        }
                    }
                }];
            }
        }
    }];
}

#pragma mark - NewsFeedTableViewCell Delegate Methods

- (void)updateLikeCount:(UIButton *)likeButton
{
    CGPoint buttonPosition = [likeButton convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    Post *photoPost = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];

    if ([likeButton.titleLabel.text isEqualToString:@"Like"]) {
        Like *like = [Like object];
        like.user = [PFUser currentUser];
        like.post = photoPost;

        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error saving like: %@", error.localizedDescription);
            }
            else {
                [likeButton setTitle:@"Liked" forState:UIControlStateNormal];
            }
        }];
        photoPost.likes = [NSNumber numberWithInteger:photoPost.likes.integerValue + 1];

        [photoPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error updated likes on post: %@", error.localizedDescription);
            }
            else {
                [self.tableView reloadData];
            }
        }];
    }
    else
    {
        // Delete the like
        PFQuery *query = [Like query];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"post" equalTo:photoPost];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                NSLog(@"Error querying like: %@",error.localizedDescription);
            }
            else
            {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"Error deleting like: %@",error.localizedDescription);
                    }
                    else {
                        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
                    }
                }];
            }
        }];

        photoPost.likes = [NSNumber numberWithInteger:photoPost.likes.integerValue - 1];

        [photoPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error saving post with new like count: %@", error.localizedDescription);
            }
            else {
                [self.tableView reloadData];
            }
        }];

    }

}



@end
