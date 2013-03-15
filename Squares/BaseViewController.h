//
//  BaseViewController.h
//  Squares
//
//  Created by Billy Irwin on 1/1/13.
//  Copyright (c) 2013 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (strong, nonatomic) UIView *MenuView;
@property (strong, nonatomic) UIButton *helpButton;
@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) UIButton *soloGameButton;
@property (nonatomic) bool menuOn;
- (IBAction)help:(id)sender;

- (IBAction)logout:(id)sender;
@end
