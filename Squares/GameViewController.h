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

- (IBAction)enlarge:(UIButton *)sender;
- (IBAction)random:(UIButton *)sender;
- (IBAction)changeVal:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *shrinkButton;
- (IBAction)shrinkBoard:(id)sender;

@end
