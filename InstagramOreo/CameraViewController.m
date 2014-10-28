//
//  CameraViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "CameraViewController.h"
#import <Parse/Parse.h>

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>

@property UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property BOOL takePhoto;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.takePhoto = YES;
    //self.tabBarItem.tag = 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self showCamera];
    self.tabBarController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Set tabBarController's delegate to nil when view disapears otherwise taping on any other tab will also
    // call showCamera
    self.tabBarController.delegate = nil;
}

- (void)showCamera
{
    if (self.takePhoto == YES)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        self.takePhoto = NO;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self showCamera];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.textView resignFirstResponder];
    }
}

//- (IBAction)selectPhoto:(UIButton *)sender {
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
//    
//    
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
<<<<<<< HEAD
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)uploadImage
{
    if (self.imageView.image != nil)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.05f);

        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

        NSString *caption = self.textView.text;

        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {

                PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
                [userPhoto setObject:imageFile forKey:@"imageFile"];
                [userPhoto setObject:caption forKey:@"caption"];

                //            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

                PFUser *user = [PFUser currentUser];
                [userPhoto setObject:user forKey:@"user"];

                [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {

                        NSLog(@"IT WAS Posted!!");
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        self.takePhoto = YES;
                    }
                    else{
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Take A Photo!"
                                                           message:@"You can't upload a photo if you didn't take or choose a photo..."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        alertView.delegate = self;
        [alertView show];
    }
=======
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)uploadImage{

    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    NSString *caption = self.textView.text;

    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto setObject:caption forKey:@"caption"];
            [userPhoto setObject:0 forKey:@"numberOfLikes"];
            
            PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [photoACL setPublicReadAccess:YES];
            userPhoto.ACL = photoACL;
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            //We setup a background task to allow for the image to upload, when the phone turns off.
            self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            }];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    self.takePhoto = YES;
                    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
                    NSLog(@"Image was posted Successfully");
                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
>>>>>>> 04a90063ba7d10e973a8656b1b191f71adffdffd
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.takePhoto = YES;
}

- (IBAction)postImage:(id)sender
{
    [self uploadImage];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
