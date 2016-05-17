//
//  ViewController.h
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)loginAction:(id)sender;

@end

