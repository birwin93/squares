//
//  LocalGameViewController.m
//  Squares
//
//  Created by Billy Irwin on 1/2/13.
//  Copyright (c) 2013 BirwinApps. All rights reserved.
//

#import "LocalGameViewController.h"

@interface LocalGameViewController ()

@end

@implementation LocalGameViewController
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
    [shrinkButton setTitle:@"" forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enlarge:(UIButton *)sender
{
    // first check if square is the next valid square
    int location = game.lastMove;
    if (!game.freeMove && sender.tag != location % 10) {
        return;
    }
    
    // then check if square is already filled
    int full = [[[game.boardVals objectAtIndex:9] objectAtIndex:sender.tag] intValue];
    if (full) {
        return;
    }
    
    // make sure only current player can affect board
    NSString *currentPlayer = game.currentPlayer;
    if (![currentPlayer isEqualToString:[PFUser currentUser].username]) {
        return;
    }
    
    // finally check if game is finished
    if (game.done) {
        return;
    }
    
    //enlarge the square
    [board enlargeSquare:sender.tag];
    [shrinkButton setTitle:@"Click here to shrink" forState:UIControlStateNormal];
}


- (IBAction)changeVal:(UIButton *)sender
{
    // make sure player can't change a square that already contains a value
    int input = [[[game.boardVals objectAtIndex:board.enlargedView.tag] objectAtIndex:sender.tag] intValue];
    
    if (input == 1 || input == 2) {
        return;
    }
    
    // input the correct value
    NSString *nameHolder = game.currentPlayer;
    
    if ([nameHolder isEqualToString:game.player1]) {
        input = 1;
        game.currentPlayer = game.player2;
    } else {
        input = 2;
        game.currentPlayer = game.player1;
    }
    
    [[game.boardVals objectAtIndex:board.enlargedView.tag] replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:input]];
    
    [board updateBoard:board.enlargedView.tag square:sender.tag player:input];
    
    
    // check if next move is a free move
    if ([[[game.boardVals objectAtIndex:9] objectAtIndex:sender.tag] intValue] != 0) {
        game.freeMove = YES;
    } else {
        game.freeMove = NO;
    }
    
    // set lastMove
    int largeSquare = board.enlargedView.tag;
    int smallSquare = sender.tag;
    int lastMove = largeSquare*10 + smallSquare;
    
    [board shrinkSquare];
    [board highlightSquares:game.freeMove
                  boardVals:[game.boardVals objectAtIndex:9]
                   lastMove:lastMove];
    
    game.lastMove = lastMove;
    
    
}


- (int)checkLargeBoard
{
    int result = [self checkForAWin:[game.boardVals objectAtIndex:board.enlargedView.tag]];
    if (result == 1) {
        [board updateCover:board.enlargedView.tag player:1];
        [[game.boardVals objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:1]];
        return 1;
    } else if (result == 2) {
        [board updateCover:board.enlargedView.tag player:2];
        [[game.boardVals objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:2]];
        return 2;
    } else if (result == 3) {
        [board updateCover:board.enlargedView.tag player:3];
        [[game.boardVals objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:3]];
        return 3;
    }
    
    [self displayWinMessage];
    
    return 0;
}


- (void)setUpGame {
    
    board = [[LargeBoardView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:board];
    
    int i = 0;
    for (SmallBoardView *view in board.smallBoards) {
        [view.coverView addTarget:self action:@selector(enlarge:) forControlEvents:UIControlEventTouchUpInside];
        view.coverView.tag = i;
        
                
        i++;
    }
    
    // give each square an image and the squares within each large square a touch command
    int s = 0;
    for (SmallBoardView *view in board.smallBoards) {
        int a = 0;
        for (UIButton *button in view.squares) {
            button.tag = a;
            [button setImage:[UIImage imageNamed:@"blankSquare.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeVal:) forControlEvents:UIControlEventTouchUpInside];
            a++;
        }
        
        s++;
    }
    
    [board highlightSquares: game.freeMove
                  boardVals:[game.boardVals objectAtIndex: 9]
                   lastMove: game.lastMove];

    
}

- (void)displayWinMessage
{
    if (game.done == true) {
        // find out who won and display to player
        NSString *currentPlayer = game.currentPlayer;
        NSString *gameMessage;
        int result = [self checkForAWin:[game.boardVals objectAtIndex:9]];
        if (result == 1) {
            if ([currentPlayer isEqualToString: game.player1]) {
                gameMessage = [NSString stringWithFormat:@"You won"];
            } else {
                gameMessage = [NSString stringWithFormat:@"%@ won", game.player2];
            }
        } else if (result == 2) {
            if ([currentPlayer isEqualToString:game.player2]) {
                gameMessage = [NSString stringWithFormat:@"You won"];
            } else {
                gameMessage = [NSString stringWithFormat:@"%@ won", game.player1];
            }
        } else {
            gameMessage = [NSString stringWithFormat:@"Draw"];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:gameMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
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
