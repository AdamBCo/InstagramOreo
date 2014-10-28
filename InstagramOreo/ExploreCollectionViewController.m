//
//  ExploreCollectionViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExploreCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Parse/Parse.h>

@interface ExploreCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property NSArray *photos;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ExploreCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self loadPhotosToExplore];
}

- (void)loadPhotosToExplore
{
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
                    self.photos = [NSArray arrayWithArray:photoArray];
                    [self.collectionView reloadData];
                }];
            }
        }
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = object[@"title"];
    
    PFFile *thumbnail = object[@"thumbnail"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    cell.imageView.file = thumbnail;
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *collectionImage = [UIImage imageWithData:self.photos.firstObject];
    //collectionImage.size = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    //NSLog(@"image %@", collectionImage);
    cell.photoImage.image = [UIImage imageWithData:[self.photos objectAtIndex:indexPath.row]];
    [cell.photoImage sizeToFit];
    return cell;
}

#pragma mark - Collection View Flow Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //CGSize size = CGSizeMake(self.view.frame.size.width / .333, self.view.frame.size.width / .333);
    CGSize size = CGSizeMake(collectionView.bounds.size.width * 0.333, collectionView.bounds.size.height * 0.333);
    NSLog(@"%f",collectionView.bounds.size.width);
    return size;
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
