//
//  Like.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/30/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "Like.h"
#import <Parse/PFObject+Subclass.h>

@implementation Like

@dynamic user;
@dynamic post;

+ (NSString *)parseClassName
{
    return @"Like";
}

+ (void)load
{
    [self registerSubclass];
}


@end
