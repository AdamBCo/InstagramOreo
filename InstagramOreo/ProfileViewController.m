//
//  ProfileViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfileTableViewCell.h"
#import "ProfileTableViewCollectionViewCell.h"

@interface ProfileViewController () <UICollectionViewDataSource, UITableViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UICollectionViewDelegateFlowLayout>
@property NSArray *userPhotos;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    return cell;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"oreoTwo"];
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
