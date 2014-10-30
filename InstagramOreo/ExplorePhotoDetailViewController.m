//
//  ExplorePhotoDetailViewController.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExplorePhotoDetailViewController.h"
#import "ExplorePhotosTableViewCell.h"

@interface ExplorePhotoDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation ExplorePhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"PHOTO";
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableview reloadData];
}

<<<<<<< HEAD
=======
- (IBAction)onFollowButtonPressed:(UIButton *)followButton
{
    PFUser *user = [PFUser currentUser];
    // Get selectedPost's userName
    __block NSString *selectedPostUserName;
    [self.selectedPost usernameWithCompletionBlock:^(NSString *username) {
        selectedPostUserName = username;
    }];

    if (selectedPostUserName != user.username)
    {
        PFRelation *followingRelationship = [user relationForKey:@"following"];
        //PFQuery *query = [followingRelationship query];

        //[query whereKey:@"user" equalTo:user];
        // Add selectedUser to list of users currentUser follows

        [followingRelationship addObject:self.selectedPost.user];
        [user saveInBackground];
        
        // Add currentUser to list of users following selectedUser
        PFRelation *followerRelationship = [self.selectedPost.user relationForKey:@"follower"];
        [followerRelationship addObject:user];
        [self.selectedPost.user saveInBackground];
    }

}
>>>>>>> Added code to follow user in explor detail view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplorePhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    //UserName
    [self.selectedPost usernameWithCompletionBlock:^(NSString *username) {
        cell.usernameLabel.text = username;
    }];

    //Image
    [self.selectedPost standardImageWithCompletionBlock:^(UIImage *photo) {
        cell.capturedPhoto.image = photo;
    }];

    //PhotoCaption
    cell.photoCaptionTextView.text = self.selectedPost.caption;

    //TimeLabel
    cell.timeLabel.text = self.selectedPost.timeCreatedString;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
