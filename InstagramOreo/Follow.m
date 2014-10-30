//
//  Follow.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "Follow.h"
#import <Parse/PFObject+Subclass.h>

@implementation Follow

@dynamic userWhoFollowed;
@dynamic userBeingFollowed;

+ (NSString *)parseClassName
{
    return @"Follow";
}

+ (void)load
{
    [self registerSubclass];
}

- (PFUser *)userBeingFollowed
{
    return [self objectForKey:@"userBeingFollowed"];
}

- (PFUser *)userWhoFollowed
{
    return [self objectForKey:@"userWhoFollowed"];
}

@end
