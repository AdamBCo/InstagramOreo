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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                             action:@selector(onBackButtonPressed:)];
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

    //UserName
    [self.selectedPost usernameWithCompletionBlock:^(NSString *username) {
        //cell..text = username;
        NSLog(@"%@",username);
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

- (IBAction)onBackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
