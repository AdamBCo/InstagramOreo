//
//  Follow.h
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/29/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface Follow : PFObject <PFSubclassing>

@property PFUser *userBeingFollowed;
@property PFUser *userWhoFollowed;

+ (void)updateFollowingStatusAndButton:(UIButton *)followButton selectedUserPost:(Post *)selectedUserPost loggedInUser:(PFUser *)loggedInUser;

@end
