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

@interface ExploreCollectionViewController ()

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
                NSLog(@"Hello 3");
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [photoArray addObject:data];
                    self.photos = [NSArray arrayWithArray:photoArray];
                    [self.collectionView reloadData];
                    NSLog(@"Hello 4");
                }];
                NSLog(@"Hello 5");
            }
        }
        NSLog(@"Hello 2");
    }];
    NSLog(@"Hello 1");
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
    NSLog(@"image %@", collectionImage);
    cell.photoImage.image = [UIImage imageWithData:[self.photos objectAtIndex:indexPath.row]];
    return cell;
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
