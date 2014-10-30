//
//  Like.h
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/30/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface Like : PFObject <PFSubclassing>

@property PFUser *user;
@property Post *post;

@end
