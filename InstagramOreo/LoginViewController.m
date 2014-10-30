//
//  LoginViewController.m
//  InstagramOreo
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Trim.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginFacebook;
@property (weak, nonatomic) IBOutlet UIButton *signUpFacebook;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.alpha = 0;
    [self.usernameTextField setHidden:YES];
    [self.passwordTextField setHidden:YES];
    [self.emailTextField setHidden:NO];
    [self.loginFacebook setHidden:YES];
    [self.nextButton setHidden:NO];
//    [self.usernameTextField setBorderStyle:UITextBorderStyleNone];
//    [self.passwordTextField setBorderStyle:UITextBorderStyleNone];
//    [self.emailTextField setBorderStyle:UITextBorderStyleNone];


    
    [self.usernameTextField addTarget:self.passwordTextField action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTextField addTarget:self action:@selector(login:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.emailTextField addTarget:self action:@selector(signUp) forControlEvents:UIControlEventEditingDidEndOnExit];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
}

-(void)textFieldChange{

}

-(void)signUp{
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}
- (IBAction)nextButtonPushed:(id)sender {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

//Add this soon
//-(BOOL) NSStringIsValidEmail:(NSString *)checkString
//{
//    BOOL stricterFilter = NO;
//    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
//    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:checkString];
//}


- (void)dismissKeyboard
{
    if ([self.usernameTextField isFirstResponder])
    {
        [self.usernameTextField resignFirstResponder];
    }
    else if ([self.passwordTextField isFirstResponder])
    {
        [self.passwordTextField resignFirstResponder];
    }
    else if ([self.emailTextField isFirstResponder])
    {
        [self.emailTextField resignFirstResponder];
    }
}


- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.usernameTextField setHidden:YES];
            [self.passwordTextField setHidden:YES];
            [self.emailTextField setHidden:NO];
            [self.loginFacebook setHidden:YES];
            [self.signUpFacebook setHidden:NO];
            self.infoLabel.text = [NSString stringWithFormat:@"Sign up to see photos from\n your friends"];
            NSLog(@"Hello");
            break;

        case 1:
            [self.usernameTextField setHidden:NO];
            [self.passwordTextField setHidden:NO];
            [self.emailTextField setHidden:YES];
            [self.loginFacebook setHidden:NO];
            [self.signUpFacebook setHidden:YES];
            self.infoLabel.text = [NSString stringWithFormat:@"Login to see photos from\n your friends"];
            NSLog(@"Bye");
            break;

        default:
            break;
    }
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SignUpViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.emailString = self.emailTextField.text;
    
}


- (IBAction)loginWithFacebook:(id)sender {
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameTextField.text trim];
    NSString *password = [self.passwordTextField.text trim];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Info"
                                                            message:@"Please enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}


@end
