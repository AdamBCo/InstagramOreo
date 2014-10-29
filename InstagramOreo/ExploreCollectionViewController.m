//
//  ExploreCollectionViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExploreCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "ExplorePhotoDetailViewController.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface ExploreCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property NSArray *posts;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ExploreCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"EXPLORE";

    // Register cell classes
    [self loadPhotosToExplore];
}

- (void)loadPhotosToExplore
{
    PFQuery *query = [PFQuery queryWithClassName:[Post parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
        else {
            self.posts = objects;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Post *post = [self.posts objectAtIndex:indexPath.row];
    //Image
    [post standardImageWithCompletionBlock:^(UIImage *photo) {
        cell.photoImage.image = photo;
    }];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"ExplorePhotoDetailSegue"])
    {
        UINavigationController *navController = segue.destinationViewController;
        ExplorePhotoDetailViewController *detailViewController = navController.viewControllers.firstObject;
        detailViewController.selectedPost = [self.posts objectAtIndex:indexPath.row];
    }
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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
