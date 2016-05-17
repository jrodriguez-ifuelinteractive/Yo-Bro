//
//  OMPOptionsTableViewController.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/15/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "OMPOptionsTableViewController.h"
#import "ViewController.h"

@interface OMPOptionsTableViewController ()

@end

@implementation OMPOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Version 1.0.1";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Sign out";
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:vc animated:YES completion:^{
        // Register for remote notifications.
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"bro_token"];
        [defaults removeObjectForKey:@"bro_device_token"];
        [defaults synchronize];
    }];
}

@end
