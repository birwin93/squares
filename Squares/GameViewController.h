//
//  GameViewController.h
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeBoardView.h"
#import "Game.h"

@interface GameViewController : UIViewController
@property (strong, nonatomic) LargeBoardView *board;
@property (strong, nonatomic) PFObject *game;
@property (strong, nonatomic) IBOutlet UIButton *shrinkButton;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (nonatomic) BOOL keyboardIsShowing;
@property (strong, nonatomic) IBOutlet UIView *displayMessageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *messageCancelButton;
@property (strong, nonatomic) IBOutlet UIButton *attachMessageButton;
- (IBAction)cancelAttachMessage:(id)sender;

- (IBAction)enlarge:(UIButton *)sender;
- (IBAction)changeVal:(UIButton *)sender;
- (IBAction)shrinkBoard:(id)sender;
- (IBAction)attachMessage:(id)sender;
- (IBAction)closeMessage:(id)sender;

@end
