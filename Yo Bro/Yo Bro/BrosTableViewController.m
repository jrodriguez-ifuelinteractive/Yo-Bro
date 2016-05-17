//
//  BrosTableViewController.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "BrosTableViewController.h"
#import "Users.h"
#import "OMPBrosTableViewCell.h"

@interface BrosTableViewController ()

@end

@implementation BrosTableViewController {
    NSMutableArray *tableViewItems;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [Users getBrosForUserByToken:@"empty" onSuccess:^(NSDictionary *items) {
        [self assignItems: items];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bar"] forBarMetrics:UIBarMetricsDefault];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [center addObserverForName:@"OMPNotificationAlert" object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *note) {
                        NSString *message = [[note.userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:message
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }];
}

- (void)assignItems:(NSDictionary *)items
{
    tableViewItems = [[NSMutableArray alloc] init];
    for (id key in items) {
        [tableViewItems addObject:key];
    }
    
    [self.tableView reloadData];
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

    return [tableViewItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OMPBrosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = myBackView;
    
    cell.usernameLabel.text = [[tableViewItems objectAtIndex: indexPath.row] objectForKey: @"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMPBrosTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.usernameLabel setAlpha: 0.0f];
    [cell.activityView startAnimating];
    
    NSString *username = [[tableViewItems objectAtIndex: indexPath.row] objectForKey: @"username"];
    NSString *userSelected = [[tableViewItems objectAtIndex: indexPath.row] objectForKey:@"name"];
    [Users sendBroTo:username
        successBlock:^{
            [cell.activityView stopAnimating];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 cell.usernameLabel.alpha = 1;
                                 cell.usernameLabel.text = @"Bro Sent!";
                                 cell.usernameLabel.textColor = [UIColor greenColor];
                             }
                             completion:^(BOOL finished) {
                                 if (finished){
                                     [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                         cell.usernameLabel.alpha = 0;
                                     } completion:^(BOOL finished){
                                         cell.usernameLabel.textColor = [UIColor blackColor];
                                         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                             cell.usernameLabel.alpha = 1;
                                             cell.usernameLabel.text = userSelected;
                                         } completion:^(BOOL finished){
                                             
                                         }];
                                     }];
                                 }
                             }];
        }
        failureBlock:^{
            [cell.activityView stopAnimating];
            [cell.broFailedLabel setHidden: NO];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSThread sleepForTimeInterval:2.0f];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.usernameLabel setAlpha:1.0];
                    [cell.broFailedLabel setHidden: YES];
                    [cell.usernameLabel setHidden: NO];
                });
            });
            
        }];
    
    // Kinda annoying I have to tell iOS to deselect row I selected.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
