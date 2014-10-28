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
    cell.capturedPhoto.image = [UIImage imageWithData:[self.photoPosts objectAtIndex:indexPath.row]];
    return cell;
}

- (void)downloadAllImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSMutableArray *photoArray = [NSMutableArray array];
        
        if (objects.count > 0) {
            for (PFObject *eachObject in objects) {
                [newObjectIDArray addObject:[eachObject objectId]];
                NSLog(@"PFObject HAHA: %@",eachObject);
                PFFile *file = [eachObject objectForKey:@"imageFile"];
                NSLog(@"Notifications: %@",file);
                NSLog(@"Data: %@", [file getData]);
                NSData *data = [file getData];
                [photoArray addObject:data];
            }

            self.photoPosts = [NSArray arrayWithArray:photoArray];
            [self.tableView reloadData];
        }
    }];
}


                
                
@end
