//
//  UserProfileTableViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "UserProfileTableViewCell.h"
#import <Parse/Parse.h>

@interface UserProfileTableViewController ()
@property NSArray *userPhotos;
@end

@implementation UserProfileTableViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadPhotosToExplore];

}

- (void)loadPhotosToExplore{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         NSMutableArray *newObjectIDArray = [NSMutableArray array];
         NSMutableArray *photoArray = [NSMutableArray array];

         if (objects.count > 0) {
             for (PFObject *eachObject in objects) {
                 [newObjectIDArray addObject:[eachObject objectId]];
                 PFFile *file = [eachObject objectForKey:@"imageFile"];
                 [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                     [photoArray addObject:data];
                     self.userPhotos = [NSArray arrayWithArray:photoArray];
                     [self.tableView reloadData];
                 }];
             }
         }
     }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *userPhoto = [UIImage imageWithData:[self.userPhotos objectAtIndex:indexPath.row]];
    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.standardImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.standardImage.image = userPhoto;
    return cell;
}



@end
