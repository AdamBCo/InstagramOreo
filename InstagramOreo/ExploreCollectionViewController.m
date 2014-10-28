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

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self loadPhotosToExplore];
}

- (void)loadPhotosToExplore
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    //PFUser *user = [PFUser currentUser];
    //[query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSMutableArray *photoArray = [NSMutableArray array];

        if (objects.count > 0)
        {
            for (PFObject *eachObject in objects)
            {
                [newObjectIDArray addObject:[eachObject objectId]];
               // NSLog(@"PFObject HAHA: %@",eachObject);
                PFFile *file = [eachObject objectForKey:@"imageFile"];
                //NSLog(@"Notifications: %@",file);
                NSLog(@"Data: %@", [file getData]);
                NSData *data = [file getData];
                [photoArray addObject:data];
            }

            self.photos = [NSArray arrayWithArray:photoArray];
            [self.collectionView reloadData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
