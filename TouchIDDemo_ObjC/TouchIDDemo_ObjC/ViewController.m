//
//  ViewController.m
//  TouchIDDemo_ObjC
//
//  Created by Pranay on 26/07/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define kDefaultUsername    @"Username"
#define kDefaultPassword    @"Password"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
  [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - TapGesture Method

- (void)tapGestureRecognizer:(UITapGestureRecognizer*)sender {
  //Hide Keyboard
  [self.usernameTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
}

#pragma mark - IBAction Method

- (IBAction)loginButtonAction:(id)sender {
  
  if (self.usernameTextField.text.length<=0 || self.passwordTextField.text.length<=0) {
    //Show alert for empty username or pasword
    [self showAlertMessage:@"username/password is empty!"];
  } else if (![self.usernameTextField.text isEqualToString:kDefaultUsername]) {
    //Show alert for wrong username
    [self showAlertMessage:@"username is not correct"];
  } else if (![self.passwordTextField.text isEqualToString:kDefaultPassword]) {
    //Show alert for wrong password
    [self showAlertMessage:@"password is not correct"];
  } else {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    //Validation Complete
    [self showAlertMessage:@"Logged in successfully!"];
  }
}

- (IBAction)authenticateButtonAction:(id)sender {
  
  LAContext *context = [[LAContext alloc] init];
  
  NSError *error = nil;
  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"Logging in with Touch ID"
                      reply:^(BOOL success, NSError *error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                          if (error) {
                            switch (error.code) {
                              case LAErrorAuthenticationFailed:
                                //Show Error Alert
                                [self showAlertMessage:@"There was a problem verifying your identity."];
                                break;
                              case LAErrorUserCancel:
                                //Show Error Alert
                                [self showAlertMessage:@"You pressed cancel."];
                                break;
                              case LAErrorUserFallback:
                                //Show Error Alert
                                [self showAlertMessage:@"You pressed password."];
                                break;
                                
                              default:
                                //Show Error Alert
                                [self showAlertMessage:@"Touch ID may not be configured"];
                                break;
                            }
                            
                            return;
                          }
                          
                          if (success) {
                            [self showAlertMessage:@"You are the device owner!"];
                          } else {
                            [self showAlertMessage:@"You are not the device owner."];
                          }
                        });
                      }];
    
  } else {
    //Show error alert message
    [self showAlertMessage:@"Your device cannot authenticate using TouchID."];
  }
}

#pragma mark - Other Methods

/**
 *  This method is used to show the alert message
 *
 *  @param message - message
 */
- (void)showAlertMessage:(NSString *)message {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
  [self presentViewController:alertController animated:YES completion:nil];
}

@end
