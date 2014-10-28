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

@property NSArray *photos;

@end

@implementation ExplorePhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplorePhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectedImage.image = [UIImage imageWithData:self.selectedObject];
    [cell.selectedImage sizeToFit];
    return cell;
}

- (IBAction)onBackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
