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

@interface NewsFeedTableViewController () <NewsFeedTableViewCellDelegate>

@property NSArray *arrayOfPhotoObjects;
@property UIRefreshControl *refreshControl;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(downloadAllImages) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"The current user is: %@", currentUser.username);
        [self.tabBarController.tabBar setHidden:NO];
        [self downloadAllImages];
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
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
        else
        {
            if (object) {
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


- (void)downloadAllImages {
    PFUser *user = [PFUser currentUser];
    PFQuery *postQuery = [PFQuery queryWithClassName:[Post parseClassName]];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"user" equalTo:user];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error);
            [self.refreshControl endRefreshing];
        }else{
            self.arrayOfPhotoObjects = objects;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
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
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [likeButton setTitle:@"Liked" forState:UIControlStateNormal];
            }
        }];
        photoPost.likes = [NSNumber numberWithInteger:photoPost.likes.integerValue + 1];

        [photoPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
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
                NSLog(@"Error: %@",error.localizedDescription);
            }
            else
            {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@",error.localizedDescription);
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
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [self.tableView reloadData];
            }
        }];

    }

}



@end
