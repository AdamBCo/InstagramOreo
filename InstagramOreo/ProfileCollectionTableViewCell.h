//
//  ProfileCollectionTableViewCell.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property NSArray *storedImages;

@end