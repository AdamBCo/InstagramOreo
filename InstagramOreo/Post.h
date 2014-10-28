//
//  Post.h
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post :PFObject <PFSubclassing>
@property NSString *caption;
@property PFFile * profileImage;
@property PFFile *standardImage;
@property NSDate *timeCreated;

@end
