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

@interface NewsFeedTableViewController ()
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfPhotoObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Post *photoPost = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedCell"];
    
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
    
    //TimeLabel
    cell.timeLabel.text = photoPost.timeCreatedString;
    return cell;
}


- (void)downloadAllImages{
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



                
                
@end
