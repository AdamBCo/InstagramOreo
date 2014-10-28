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
@property UIRefreshControl *refreshControl;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Refresh Control
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
    
    PFObject *photoObject = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedCell"];
    cell.capturedPhoto.file = [photoObject objectForKey:@"imageFile"];
    cell.photoCaptionTextView.text = [photoObject objectForKey:@"caption"];
    
    
    //TimeCreated
    NSDate *date = photoObject.createdAt;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *creationDate = [dateFormat stringFromDate:date];
    cell.timeLabel.text = creationDate;
    
    [cell.capturedPhoto loadInBackground];
    return cell;
}









- (void)downloadAllImages{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            self.arrayOfPhotoObjects = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else if (error){
            NSLog(@"Error: %@",error);
            [self.refreshControl endRefreshing];
        }
    }];
}



                
                
@end
