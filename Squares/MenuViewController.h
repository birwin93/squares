//
//  MenuViewController.h
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *gamesArray;
@property (strong, nonatomic) NSMutableArray *yourMove;
@property (strong, nonatomic) NSMutableArray *opponentsMove;
@property (strong, nonatomic) NSMutableArray *finishedGames;
@property (strong, nonatomic) IBOutlet UITableView *gamesTableView;
@property (strong, nonatomic) IBOutlet UIView *createGameView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)playGame:(id)sender;
- (IBAction)createGame:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)reload:(id)sender;

@end
