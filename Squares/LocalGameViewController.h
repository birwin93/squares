//
//  LocalGameViewController.h
//  Squares
//
//  Created by Billy Irwin on 1/2/13.
//  Copyright (c) 2013 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeBoardView.h"
#import "Game.h"


@interface LocalGameViewController : UIViewController
@property (strong, nonatomic) LargeBoardView *board;
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) IBOutlet UIButton *shrinkButton;


- (IBAction)enlarge:(UIButton *)sender;
- (IBAction)changeVal:(UIButton *)sender;
- (IBAction)shrinkBoard:(id)sender;
@end
