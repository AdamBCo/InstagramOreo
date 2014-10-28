//
//  PostViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.capturedImage;
}
- (IBAction)postPhotoWithTextButtonPressed:(id)sender {
    
    
}


@end
