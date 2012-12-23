//
//  GameViewController.m
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize board;
@synthesize game;
@synthesize shrinkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGame];
    shrinkButton.titleLabel.text = @"";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enlarge:(UIButton *)sender
{
    int location = [[game objectForKey:@"lastMove"] intValue];
    if (![[game objectForKey:@"freeMove"] boolValue] && sender.tag != location % 10) {
        return;
    }
    
    int full = [[[[game objectForKey:@"boardData"]  objectAtIndex:9] objectAtIndex:sender.tag] intValue];
    if (full) {
        return;
    }
    
    NSString *currentPlayer = [game objectForKey:@"currentPlayer"];
    if (![currentPlayer isEqualToString:[PFUser currentUser].username]) {
        return;
    }
    
   
    [board enlargeSquare:sender.tag];
    [shrinkButton setTitle:@"Click here to shrink" forState:UIControlStateNormal];
}


- (IBAction)changeVal:(UIButton *)sender
{
    int input = [[[[game objectForKey:@"boardData"] objectAtIndex:board.enlargedView.tag] objectAtIndex:sender.tag] intValue];
    
    if (input == 1 || input == 2) {
        return;
    }
    
    NSString *nameHolder = [game objectForKey:@"currentPlayer"];
    
    if ([nameHolder isEqualToString:[game objectForKey:@"player1"]]) {
        input = 1;
        [game setObject:[game objectForKey:@"player2"] forKey:@"currentPlayer"];
    } else {
        input = 2;
        [game setObject:[game objectForKey:@"player1"] forKey:@"currentPlayer"];
    }
    
    [[[game objectForKey:@"boardData"] objectAtIndex:board.enlargedView.tag] replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:input]];

    [board updateBoard:board.enlargedView.tag square:sender.tag player:input];
    
    if ([[[[game objectForKey:@"boardData"] objectAtIndex:9] objectAtIndex:sender.tag] intValue] != 0) {
        [game setObject:[NSNumber numberWithBool:YES] forKey:@"freeMove"];
    } else {
        [game setObject:[NSNumber numberWithBool:NO] forKey:@"freeMove"];
    }
    
    [self checkLargeBoard];
    
    int largeSquare = board.enlargedView.tag;
    int smallSquare = sender.tag;
    int lastMove = largeSquare*10 + smallSquare;
    
    [board shrinkSquare];
    [board highlightSquares:[[game objectForKey:@"freeMove"] boolValue] boardVals:[[game objectForKey:@"boardData"] objectAtIndex:9] lastMove:lastMove];
    
    [game setObject:[NSNumber numberWithInt:lastMove] forKey:@"lastMove"];
    [game saveInBackground];
    
    
    NSString *message = [NSString stringWithFormat:@"Your move against %@", nameHolder];
    [PFPush sendPushMessageToChannelInBackground:[game objectForKey:@"currentPlayer"] withMessage:message];
    
}

- (void)checkLargeBoard
{
    int result = [self checkForAWin:[[game objectForKey:@"boardData"] objectAtIndex:board.enlargedView.tag]];
    if (result == 1) {
        [board updateCover:board.enlargedView.tag player:1];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:1]];
    } else if (result == 2) {
        [board updateCover:board.enlargedView.tag player:2];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:2]];
    } else if (result == 3) {
        [board updateCover:board.enlargedView.tag player:3];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:3]];
    }

}


- (void)setUpGame {
    
   
    // first remove last move from the board data
    /*int smallSquare = [[game objectForKey:@"lastMove"] intValue] % 10;
    int largeSquare = [[game objectForKey:@"lastMove"] intValue] / 10;
    
    [[[game objectForKey:@"boardData"] objectAtIndex:largeSquare] replaceObjectAtIndex:smallSquare withObject:[NSNumber numberWithInt:0]];
    [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:largeSquare withObject:[NSNumber numberWithInt:0]];
    */
    
    board = [[LargeBoardView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:board];
 
    int i = 0;
    for (SmallBoardView *view in board.smallBoards) {
        [view.coverView addTarget:self action:@selector(enlarge:) forControlEvents:UIControlEventTouchUpInside];
        view.coverView.tag = i;
        
        if ([[[[game objectForKey:@"boardData"] objectAtIndex:9] objectAtIndex:i] intValue] != 0) {
            [board updateCover:i player:[[[[game objectForKey:@"boardData"] objectAtIndex:9] objectAtIndex:i] intValue]];
        }
        
        i++;
    }
    
    // give each square an image and the squares within each large square a touch command
    int s = 0;
    for (SmallBoardView *view in board.smallBoards) {
        int a = 0;
        for (UIButton *button in view.squares) {
            button.tag = a;
            [button setImage:[UIImage imageNamed:@"large_blank.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeVal:) forControlEvents:UIControlEventTouchUpInside];
            [board updateBoard:s square:a player:[[[[game objectForKey:@"boardData"] objectAtIndex:s] objectAtIndex:a] intValue]];
            a++;
        }
        
        [board updateCover:s player:[[[[game objectForKey:@"boardData"] objectAtIndex:9] objectAtIndex:s] intValue]];
        s++;
    }
    
    
    /*if (![[game objectForKey:@"newGame"] boolValue]) {
        NSLog(@"updating last move");
        int input;
        if ([[game objectForKey:@"currentPlayer"] isEqualToString:[game objectForKey:@"player1"]]) {
            input = 2;
        } else {
            input = 1;
        }
        
        [board updateBoard:largeSquare square:smallSquare player:input];
        [[[game objectForKey:@"boardData"] objectAtIndex:largeSquare] replaceObjectAtIndex:smallSquare withObject:[NSNumber numberWithInt:input]];
        [self checkLargeBoard];
    }*/
    
    
    [board highlightSquares:[[game objectForKey:@"freeMove"] boolValue]
                  boardVals:[[game objectForKey:@"boardData"] objectAtIndex:9]
                   lastMove:[[game objectForKey:@"lastMove"] intValue]];
    
}


- (int)checkForAWin:(NSArray *)values
{
    int TL = [[values objectAtIndex:0] intValue];
    int TM = [[values objectAtIndex:1] intValue];
    int TR = [[values objectAtIndex:2] intValue];
    int ML = [[values objectAtIndex:3] intValue];
    int MM = [[values objectAtIndex:4] intValue];
    int MR = [[values objectAtIndex:5] intValue];
    int BL = [[values objectAtIndex:6] intValue];
    int BM = [[values objectAtIndex:7] intValue];
    int BR = [[values objectAtIndex:8] intValue];
    
    if (TL == TM && TL == TR && TL != 0) {
        NSLog(@"top row");
        return TL;
    }
    if (TL == MM && TL == BR && TL != 0) {
        NSLog(@"LR diag");
        return TL;
    }
    if (TL == ML && TL == BL && TL != 0) {
        NSLog(@"left column");
        return TL;
    }
    if (TM == MM && TM == BM && TM != 0) {
        NSLog(@"middle column");
        return TM;
    }
    if ((TR == MR) && (TR == BR) && TR != 0) {
        NSLog(@"right column");
        return TR;
    }
    if (TR == MM && TR == BL && TR != 0) {
        NSLog(@"rl diag");
        return TR;
    }
    if (ML == MM && ML == MR && ML != 0) {
        NSLog(@"middle row");
        return ML;
    }
    if (BL == BM && BL == BR && BL != 0) {
        NSLog(@"bottom row");
        return BL;
    }
    
    if (TL != 0 && TM != 0 && TR != 0 && ML != 0 && MM != 0 && MR != 0 && BL != 0 && BM != 0 && BR != 0) {
        return 3;
    }
    
    return 0;
}


- (IBAction)shrinkBoard:(id)sender
{
    [board shrinkSquare];
    [shrinkButton setTitle:@"" forState:UIControlStateNormal];
}
@end

