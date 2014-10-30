//
//  ExplorePhotoDetailViewController.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/28/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ExplorePhotoDetailViewController.h"
#import "ExplorePhotosTableViewCell.h"
#import "Follow.h"

@interface ExplorePhotoDetailViewController () <UITableViewDelegate, UITableViewDataSource, ExplorePhotoDetailCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property PFUser *user;


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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplorePhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;

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

#pragma mark - Follow / Unfollow User 

- (void)followButtonPressed:(UIButton *)followButton
{
    NSLog(@"HI");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
