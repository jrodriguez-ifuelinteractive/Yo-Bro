//
//  ViewController.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "Users.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    [Users loginWithUsername:_username.text
                    Password: _password.text
                   onSuccess:^{
                       [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                   }
                   onFailure:^(NSString *error) {
                       UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                             message:error
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                       
                       
                       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * action) {
                                                                                 
                                                                             }];
                       
                       [alert addAction:defaultAction];
                       [self presentViewController:alert animated:YES completion:nil];
                   }];
    
}

@end
