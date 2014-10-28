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

@interface NewsFeedTableViewController ()
@property NSArray *arrayOfPhotoObjects;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    PFObject *photoObject = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedCell"];
    cell.capturedPhoto.file = [photoObject objectForKey:@"imageFile"];
    [cell.capturedPhoto loadInBackground];
    cell.photoCaptionTextView.text = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    return cell;
}

- (void)downloadAllImages{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.arrayOfPhotoObjects = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}


                
                
@end
