//
//  ProfileCollectionViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "ProfileCollectionViewCell.h"

@interface ProfileCollectionViewController ()

@end

@implementation ProfileCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"oreoTwo"];

    return cell;
}


@end
