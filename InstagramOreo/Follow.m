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

+ (void)updateFollowingStatusAndButton:(UIButton *)followButton selectedUserPost:(Post *)selectedUserPost loggedInUser:(PFUser *)loggedInUser
{
    // Get selectedPost's userName
    __block NSString *selectedPostUserName;
    [selectedUserPost usernameWithCompletionBlock:^(NSString *username) {
        selectedPostUserName = username;
    }];

    if (![selectedPostUserName isEqualToString:loggedInUser.username])
    {
        if ([followButton.titleLabel.text isEqualToString:@"follow"])
        {
            Follow *follower = [Follow object];
            follower.userBeingFollowed = selectedUserPost.user;
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
            [query whereKey:@"userBeingFollowed" equalTo:selectedUserPost.user];
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
}


@end
