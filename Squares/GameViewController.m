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
@synthesize messageView;
@synthesize keyboardIsShowing;
@synthesize messageTextField;
@synthesize messageLabel;
@synthesize displayMessageView;
@synthesize attachMessageButton;
@synthesize messageCancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    keyboardIsShowing = false;
    
    if (![[game objectForKey:@"currentPlayer"] isEqualToString:[self getOpponent]]) {
        if ([[game objectForKey:@"isMessage"] boolValue] == true) {
            messageLabel.text = [game objectForKey:@"gameMessage"];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view bringSubviewToFront:displayMessageView];
            [UIView commitAnimations];
        }
    }
    
    
}

- (void)keyboardWillShow:(NSNotification *)note
{
    [self.view bringSubviewToFront:messageView];
    NSLog(@"keyboard appearing doe");
     NSLog(@"%f", messageView.frame.origin.y);
    
    CGRect frame = messageView.frame;
    frame.origin.y -= 210;
        
    [UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    messageView.frame = frame;
    [messageCancelButton setHidden:false];
    [attachMessageButton setHidden:false];
    [UIView commitAnimations];
    NSLog(@"%f", messageView.frame.origin.y);
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
  
        CGRect frame = messageView.frame;
        frame.origin.y += 210;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        messageView.frame = frame;
        [messageCancelButton setHidden:true];
        [attachMessageButton setHidden:true];
        [UIView commitAnimations];
        
 
}

- (NSString *)getOpponent
{
    if ([[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]) {
        return [game objectForKey:@"player2"];
    } else {
        return [game objectForKey:@"player1"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [messageCancelButton setHidden:true];
    [attachMessageButton setHidden:true];
    self.navigationItem.title = [self getOpponent];
    
    NSLog(@"%@", [self getOpponent]);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGame];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    [shrinkButton setTitle:@"" forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAttachMessage:(id)sender
{
    [messageTextField resignFirstResponder];
    
    messageTextField.text = @"";

}

- (IBAction)enlarge:(UIButton *)sender
{
    // first check if square is the next valid square
    int location = [[game objectForKey:@"lastMove"] intValue];
    if (![[game objectForKey:@"freeMove"] boolValue] && sender.tag != location % 10) {
        return;
    }
    
    // then check if square is already filled
    int full = [[[[game objectForKey:@"boardData"]  objectAtIndex:9] objectAtIndex:sender.tag] intValue];
    if (full) {
        return;
    }
    
    // make sure only current player can affect board
    NSString *currentPlayer = [game objectForKey:@"currentPlayer"];
    if (![currentPlayer isEqualToString:[PFUser currentUser].username]) {
        return;
    }
    
    // finally check if game is finished
    if ([[game objectForKey:@"done"] boolValue]) {
        return;
    }
    
    //enlarge the square
    [board enlargeSquare:sender.tag];
    [shrinkButton setTitle:@"Click here to shrink" forState:UIControlStateNormal];
}


- (IBAction)changeVal:(UIButton *)sender
{
    // make sure player can't change a square that already contains a value
    int input = [[[[game objectForKey:@"boardData"] objectAtIndex:board.enlargedView.tag] objectAtIndex:sender.tag] intValue];
    
    if (input == 1 || input == 2) {
        return;
    }
    
    // input the correct value
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
    
    [self sendMessage:input andName:nameHolder];
    
    // check if next move is a free move
    if ([[[[game objectForKey:@"boardData"] objectAtIndex:9] objectAtIndex:sender.tag] intValue] != 0) {
        [game setObject:[NSNumber numberWithBool:YES] forKey:@"freeMove"];
    } else {
        [game setObject:[NSNumber numberWithBool:NO] forKey:@"freeMove"];
    }
    
    // set lastMove
    int largeSquare = board.enlargedView.tag;
    int smallSquare = sender.tag;
    int lastMove = largeSquare*10 + smallSquare;
    
    [board shrinkSquare];
    [board highlightSquares:[[game objectForKey:@"freeMove"] boolValue]
                  boardVals:[[game objectForKey:@"boardData"] objectAtIndex:9]
                   lastMove:lastMove];
    [game setObject:[NSNumber numberWithInt:lastMove] forKey:@"lastMove"];
    
    [game setObject:[NSDate date] forKey:@"lastMoveDate"];
    
    [game saveInBackground];

}

- (void)sendMessage:(int)input andName:(NSString *)nameHolder
{
    NSString *message = [NSString stringWithFormat:@"Your move against %@", nameHolder];
    int result = [self checkLargeBoard];
    if (result != 0) {
        int finalResult = [self checkForAWin:[[game objectForKey:@"boardData"] objectAtIndex:9]];
        if (finalResult == 1) {
            [game setObject:[NSNumber numberWithBool:YES] forKey:@"done"];
            if (input == 1) {
                message = [NSString stringWithFormat:@"You lost to %@", [game objectForKey:@"player1"]];
            } else {
                message = [NSString stringWithFormat:@"You won!"];
            }
        } else if (finalResult == 2) {
            [game setObject:[NSNumber numberWithBool:YES] forKey:@"done"];
            if (input == 2) {
                message = [NSString stringWithFormat:@"You lost to %@", [game objectForKey:@"player2"]];
            } else {
                message = [NSString stringWithFormat:@"You won!"];
            }
        } else if (finalResult == 3) {
            [game setObject:[NSNumber numberWithBool:YES] forKey:@"done"];
            message = [NSString stringWithFormat:@"Game is a draw"];
        }
    }
    
    if ([[game objectForKey:@"newGame"] boolValue] == true) {
        message = [NSString stringWithFormat:@"%@ wants to play a game with you", nameHolder];
        [game setObject:[NSNumber numberWithBool:false] forKey:@"newGame"];
    }
    
    [PFPush sendPushMessageToChannelInBackground:[game objectForKey:@"currentPlayer"] withMessage:message];
}

- (int)checkLargeBoard
{
    int result = [self checkForAWin:[[game objectForKey:@"boardData"] objectAtIndex:board.enlargedView.tag]];
    if (result == 1) {
        [board updateCover:board.enlargedView.tag player:1];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:1]];
        return 1;
    } else if (result == 2) {
        [board updateCover:board.enlargedView.tag player:2];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:2]];
        return 2;
    } else if (result == 3) {
        [board updateCover:board.enlargedView.tag player:3];
        [[[game objectForKey:@"boardData"] objectAtIndex:9] replaceObjectAtIndex:board.enlargedView.tag withObject:[NSNumber numberWithInt:3]];
        return 3;
    }
    
    [self displayWinMessage];
    
    return 0;
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
            [button setImage:[UIImage imageNamed:@"blankSquare.png"] forState:UIControlStateNormal];
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
    
    [self displayWinMessage];
    
}

- (void)displayWinMessage
{
    if ([[game objectForKey:@"done"] boolValue] == true) {
        // find out who won and display to player
        NSString *currentPlayer = [game objectForKey:@"currentPlayer"];
        NSString *gameMessage;
        int result = [self checkForAWin:[[game objectForKey:@"boardData"] objectAtIndex:9]];
        if (result == 1) {
            if ([currentPlayer isEqualToString:[game objectForKey:@"player1"]]) {
                gameMessage = [NSString stringWithFormat:@"You won"];
            } else {
                gameMessage = [NSString stringWithFormat:@"%@ won", [game objectForKey:@"player2"]];
            }
        } else if (result == 2) {
            if ([currentPlayer isEqualToString:[game objectForKey:@"player2"]]) {
                gameMessage = [NSString stringWithFormat:@"You won"];
            } else {
                gameMessage = [NSString stringWithFormat:@"%@ won", [game objectForKey:@"player1"]];
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


- (IBAction)attachMessage:(id)sender
{
    [game setObject:messageTextField.text forKey:@"gameMessage"];
    [game setObject:[NSNumber numberWithBool:YES] forKey:@"isMessage"];
    [messageTextField resignFirstResponder];
    
    messageTextField.text = @"";
}

- (IBAction)closeMessage:(id)sender
{
    [game setObject:[NSNumber numberWithBool:NO] forKey:@"isMessage"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view sendSubviewToBack:displayMessageView];
    [UIView commitAnimations];
    
    [game saveInBackground];
}

- (void)viewDidUnload {
    [self setMessageTextField:nil];
    [self setDisplayMessageView:nil];
    [self setMessageLabel:nil];
    [self setMessageCancelButton:nil];
    [self setAttachMessageButton:nil];
    [super viewDidUnload];
}
@end

