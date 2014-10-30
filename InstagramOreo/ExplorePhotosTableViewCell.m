//
//  ExplorePhotosTableViewCell.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExplorePhotosTableViewCell.h"

@implementation ExplorePhotosTableViewCell

- (void)awakeFromNib
{
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)onFollowButtonPressed:(id)sender
{
    [self.delegate followButtonPressed:sender];
}


@end
