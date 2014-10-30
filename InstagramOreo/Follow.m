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

+ (void)updateFollowingStatusAndButton:(UIButton *)followButton selectedUser:(PFUser *)selectedUser loggedInUser:(PFUser *)loggedInUser
{
    if ([followButton.titleLabel.text isEqualToString:@"follow"])
    {
        Follow *follower = [Follow object];
        follower.userBeingFollowed = selectedUser;
        follower.userWhoFollowed = loggedInUser;
        [follower saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [followButton setTitle:@"unfollow" forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        // Delete the follower
        PFQuery *query = [Follow query];
        [query whereKey:@"userBeingFollowed" equalTo:selectedUser];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                NSLog(@"Error: %@",error.localizedDescription);
            }
            else
            {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@",error.localizedDescription);
                    }
                    else {
                        [followButton setTitle:@"follow" forState:UIControlStateNormal];
                    }
                }];
            }
        }];
    }
}


@end
