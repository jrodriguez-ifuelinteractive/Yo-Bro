//
//  RegisterViewController.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "RegisterViewController.h"
#import "Users.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)registerAction:(id)sender {
    
    
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithDictionary:@{
                               @"name": _name.text,
                               @"username": _username.text,
                               @"email": @"",
                               @"password": _password.text
                               }];
    
    [Users registerUserWithData:userData onSuccess:^{
        [self performSegueWithIdentifier:@"BrosSegue" sender: self];
    }];
    
}
@end
