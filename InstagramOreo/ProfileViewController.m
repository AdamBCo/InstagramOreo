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
@property (weak, nonatomic) IBOutlet UITableView *photosTableView;
@property NSArray *userPhotos;
@property NSArray *tableViewCellsNeeded;
@property NSArray *celltasticArray;
@property NSInteger counterPlus;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPhotosToExplore];
    self.counterPlus = 0;
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
                     self.userPhotos = [NSArray arrayWithArray:photoArray];
                     
                     NSMutableArray *cool = [NSMutableArray arrayWithArray:self.userPhotos];
                     
                     NSMutableArray *bad = [NSMutableArray array];
                     self.celltasticArray = [self getArrayForThrees:cool arrayOfThrees:bad];
//                     NSLog(@"Cells: %lu",(unsigned long)self.celltasticArray.count);
                     [self.photosTableView reloadData];
                 }];
             }
         }
     }];
}

- (NSArray *)getArrayForThrees:(NSMutableArray *)fullArray arrayOfThrees:(NSMutableArray *)arrayOfThrees{
    if (fullArray.count < 3)
    {
        [arrayOfThrees addObject:fullArray];
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



#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.celltasticArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    cell.storedImages = [NSArray arrayWithArray:[self.celltasticArray objectAtIndex:indexPath.row]];
    return cell;
}



#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (self.counterPlus < self.userPhotos.count) {
        cell.imageView.image = [UIImage imageWithData:[self.userPhotos objectAtIndex:self.counterPlus]];
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
