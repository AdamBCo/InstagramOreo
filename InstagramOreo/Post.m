//
//  Post.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "Post.h"
#import <Parse/PFObject+Subclass.h>

@implementation Post
@dynamic caption;
@dynamic profileImage;
@dynamic standardImage;
@dynamic timeCreated;


+ (NSString *)parseClassName{
    return @"Post";
}

+ (void)load{
    [self registerSubclass];
}



@end
