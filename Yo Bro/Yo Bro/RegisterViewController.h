//
//  RegisterViewController.h
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)registerAction:(id)sender;

@end
