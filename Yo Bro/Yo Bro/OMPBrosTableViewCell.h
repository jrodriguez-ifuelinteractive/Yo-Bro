//
//  OMPBrosTableViewCell.h
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/12/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMPBrosTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UILabel *broFailedLabel;

@end
