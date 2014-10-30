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
@dynamic timeCreatedString;
@dynamic standardImage;
@dynamic numberOfLikes;
@dynamic user;
@dynamic commentsArray;
@dynamic userName;


+ (NSString *)parseClassName {
    return @"UserPhoto";
}

+ (void)load {
    [self registerSubclass];
}

-(NSString *)caption {
    return [self objectForKey:@"caption"];
}

-(void)standardImageWithCompletionBlock:(void(^)(UIImage *))completionBlock {
    
    PFFile *file = [self objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        completionBlock([UIImage imageWithData:data]);
    }];
}

-(PFUser *)user {
    return [self objectForKey:@"user"];
}

-(void)usernameWithCompletionBlock:(void(^)(NSString *username))completionBlock {
    
    PFUser *objectHelp = self.user;
    [objectHelp fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        completionBlock(objectHelp.username);
    }];
}

-(NSString *)timeCreatedString {
    NSDate *date = self.createdAt;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *creationDate = [dateFormat stringFromDate:date];
    return creationDate;
}







@end
