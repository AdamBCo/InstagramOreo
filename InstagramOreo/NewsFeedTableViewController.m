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
@property NSArray *photoPosts;
@property NSArray *photoTexts;

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
    return self.photoPosts.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedCell"];
    cell.capturedPhoto.image = [self.photoPosts objectForKey:@"imageFile"];
    cell.photoCaptionTextView.text = [self.photoTexts objectAtIndex:indexPath.row];
    return cell;
}

- (void)downloadAllImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSMutableArray *photoArray = [NSMutableArray array];
        if (objects.count > 0) {
            for (PFObject *eachObject in objects) {
                [newObjectIDArray addObject:[eachObject objectId]];
                PFFile *file = [eachObject objectForKey:@"imageFile"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [photoArray addObject:data];
                    NSLog(@"Data: %@",data);
                }];
                self.photoPosts = [NSArray arrayWithArray:photoArray];
                [self.tableView reloadData];
            }
        }
    }];
}


                
                
@end
