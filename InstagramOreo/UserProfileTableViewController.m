//
//  UserProfileTableViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "UserProfileTableViewCell.h"
#import "ProfileCollectionViewCell.h"
#import "ProfileCollectionTableViewCell.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Follow.h"
#import "Post.h"

@interface UserProfileTableViewController () <UICollectionViewDataSource, UITableViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UICollectionViewDelegateFlowLayout>
@property NSArray *userPhotos;
@property NSInteger counterPlus;
@property NSArray *celltasticArray;
@property (weak, nonatomic) IBOutlet UILabel *postsnNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;

@property BOOL getThatGirl;
@end

@implementation UserProfileTableViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadPhotosToExplore];
    self.counterPlus = 0;
    self.getThatGirl = YES;

    [self setFollowingLabel];
    [self setFollowersLabel];
    [self setPostsLabel];
}

- (void)setFollowingLabel
{
    PFQuery *query = [Follow query];
    [query whereKey:@"userWhoFollowed" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error error quering like: %@",error.localizedDescription);
        }
        else
        {
            self.followingNumberLabel.text = @(objects.count).description;
        }
    }];
}

- (void)setFollowersLabel
{
    PFQuery *query = [Follow query];
    [query whereKey:@"userBeingFollowed" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error error quering like: %@",error.localizedDescription);
        }
        else
        {
            self.followersNumberLabel.text = @(objects.count).description;
        }
    }];
}

- (void)setPostsLabel
{
    PFQuery *query = [Post query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error error quering like: %@",error.localizedDescription);
        }
        else
        {
            self.postsnNumberLabel.text = @(objects.count).description;
        }
    }];
}



- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            self.getThatGirl = YES;
            [self.tableView reloadData];
            NSLog(@"%hhd",self.getThatGirl);
            break;
        case 1:
            self.getThatGirl = NO;
            [self.tableView reloadData];
            NSLog(@"%hhd",self.getThatGirl);
        default:
            break;
    }
}


- (void)loadPhotosToExplore
{
    PFQuery *query = [Post query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
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

                     NSMutableArray *cool = [NSMutableArray arrayWithArray:self.userPhotos];

                     NSMutableArray *bad = [NSMutableArray array];
                     self.celltasticArray = [self getArrayForThrees:cool arrayOfThrees:bad];
                     [self.tableView reloadData];
                 }];
             }
         }
     }];
}

- (NSArray *)getArrayForThrees:(NSMutableArray *)fullArray arrayOfThrees:(NSMutableArray *)arrayOfThrees{
    if (fullArray.count < 3)
    {
        if (fullArray.count != 0) {
            [arrayOfThrees addObject:fullArray];
        }
        return arrayOfThrees;
    }
    NSMutableArray *threes = [NSMutableArray array];

    for (int i = 0; i < 3; i++)
    {
        [threes addObject:[fullArray objectAtIndex:i]];
    }
    NSIndexSet *firstThreeIndexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    [fullArray removeObjectsAtIndexes:firstThreeIndexs];

    [arrayOfThrees addObject:threes];

    [self getArrayForThrees:fullArray arrayOfThrees:arrayOfThrees];

    return arrayOfThrees;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.getThatGirl) {
        return self.userPhotos.count;
    }
    return self.celltasticArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.getThatGirl) {
        UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UIImage *userPhoto = [UIImage imageWithData:[self.userPhotos objectAtIndex:indexPath.row]];
        cell.standardImage.image = userPhoto;
        NSLog(@"Got the Girl!!");
        return cell;
    }
        ProfileCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionTableCell" forIndexPath:indexPath];
        cell.storedImages = [NSArray arrayWithArray:[self.celltasticArray objectAtIndex:indexPath.row]];
        NSLog(@"NO Girl!!");
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.getThatGirl) {
        return 417;
    }
    return 120;
}



#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        if (self.counterPlus < self.userPhotos.count) {
                cell.standardImage.image = [UIImage imageWithData:[self.userPhotos objectAtIndex:self.counterPlus]];
            }
    self.counterPlus++;
    return cell;

}


#pragma mark - Collection View Flow Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Make three cells show up side by side
    CGSize size = CGSizeMake(collectionView.bounds.size.width * 0.333 - 10, collectionView.bounds.size.width * 0.333);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    return edgeInsets;
}





@end
