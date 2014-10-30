////
////  ProfileCollectionViewController.m
////  InstagramOreo
////
////  Created by Adam Cooper on 10/29/14.
////  Copyright (c) 2014 MobileMakers. All rights reserved.
////
//
//#import "ProfileCollectionViewController.h"
//#import "ProfileCollectionViewCell.h"
//#import <Parse/Parse.h>
//
//@interface ProfileCollectionViewController ()
//@property NSArray *userPhotos;
//
//@end
//
//@implementation ProfileCollectionViewController
//
//static NSString * const reuseIdentifier = @"Cell";
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self loadPhotosToExplore];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//
//- (void)loadPhotosToExplore{
//    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//     {
//         NSMutableArray *newObjectIDArray = [NSMutableArray array];
//         NSMutableArray *photoArray = [NSMutableArray array];
//
//         if (objects.count > 0) {
//             for (PFObject *eachObject in objects) {
//                 [newObjectIDArray addObject:[eachObject objectId]];
//                 PFFile *file = [eachObject objectForKey:@"imageFile"];
//                 [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                     [photoArray addObject:data];
//                     self.userPhotos = [NSArray arrayWithArray:photoArray];
//                     [self.collectionView reloadData];
//                 }];
//             }
//         }
//     }];
//}
//
//
//
//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//
//    return self.userPhotos.count;
//}
//
////- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
////    UIImage *userPhoto = [UIImage imageWithData:[self.userPhotos objectAtIndex:indexPath.row]];
////    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
////    cell.imageView.image = userPhoto;
////    return cell;
////}
////
//
//
//#pragma mark Delegate
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Make three cells show up side by side
//    CGSize size = CGSizeMake(collectionView.bounds.size.width * 0.333 - 10, collectionView.bounds.size.width * 0.333);
//    return size;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
//    return edgeInsets;
//}
//
//@end
