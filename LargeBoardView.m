//
//  LargeBoardView.m
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import "LargeBoardView.h"

@implementation LargeBoardView
@synthesize topMid, topRight, topLeft, midRight, midMid, midLeft, botRight, botMid, botLeft;
@synthesize smallBoards;
@synthesize enlargedView;
@synthesize nextSquare;

#define largeTL CGRectMake(5, 5, 100, 100)
#define largeTM CGRectMake(110, 5, 100, 100)
#define largeTR CGRectMake(215, 5, 100, 100)
#define largeML CGRectMake(5, 110, 100, 100)
#define largeMM CGRectMake(110, 110, 100, 100)
#define largeMR CGRectMake(215, 110, 100, 100)
#define largeBL CGRectMake(5, 215, 100, 100)
#define largeBM CGRectMake(110, 215, 100, 100)
#define largeBR CGRectMake(215, 215, 100, 100)
#define full CGRectMake(5, 5, 310, 310)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        topLeft = [[SmallBoardView alloc] initWithFrame:largeTL];
        topMid = [[SmallBoardView alloc] initWithFrame:largeTM];
        topRight = [[SmallBoardView alloc] initWithFrame:largeTR];
        midLeft = [[SmallBoardView alloc] initWithFrame:largeML];
        midMid = [[SmallBoardView alloc] initWithFrame:largeMM];
        midRight = [[SmallBoardView alloc] initWithFrame:largeMR];
        botLeft = [[SmallBoardView alloc] initWithFrame:largeBL];
        botMid = [[SmallBoardView alloc] initWithFrame:largeBM];
        botRight = [[SmallBoardView alloc] initWithFrame:largeBR];
        [self addSubview:topLeft];
        [self addSubview:topMid];
        [self addSubview:topRight];
        [self addSubview:midLeft];
        [self addSubview:midMid];
        [self addSubview:midRight];
        [self addSubview:botLeft];
        [self addSubview:botMid];
        [self addSubview:botRight];
        
        smallBoards = [[NSMutableArray alloc] initWithObjects:topLeft, topMid, topRight, midLeft, midMid, midRight, botLeft, botMid, botRight, nil];
        
        int i = 0;
        for (SmallBoardView *s in smallBoards) {
            s.tag = i;
            i++;
        }
        
        self.backgroundColor = [UIColor blackColor];

    }
    return self;
}

- (void)enlargeSquare:(int)board
{
    enlargedView = [smallBoards objectAtIndex:board];
    [self bringSubviewToFront:enlargedView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    enlargedView.frame = full;
    [enlargedView sendSubviewToBack:enlargedView.coverView];
    [enlargedView enlargeSquare];
    [UIView commitAnimations];
}

- (void)shrinkSquare
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    enlargedView.frame = enlargedView.defaultFrame;
    [enlargedView shrinkSquare];
    [enlargedView bringSubviewToFront:enlargedView.coverView];
    [UIView commitAnimations];
}

- (void)updateBoard:(int)board square:(int)square player:(int)player
{
    UIButton *selectedSquare = [[[smallBoards objectAtIndex:board] squares] objectAtIndex:square];
    selectedSquare.backgroundColor = [UIColor blackColor];
    
    switch (player) {
        case 0:
            [selectedSquare setImage:[UIImage imageNamed:@"blankSquare.png"]
                            forState:UIControlStateNormal];
            break;
        case 1:
            [selectedSquare setImage:[UIImage imageNamed:@"xSquare.png"]
                            forState:UIControlStateNormal];
            break;
        case 2:
            [selectedSquare setImage:[UIImage imageNamed:@"oSquare.png"]
                            forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    nextSquare = [smallBoards objectAtIndex:square];
}

- (void)updateCover:(int)board player:(int)player
{
    SmallBoardView *s = [smallBoards objectAtIndex:board];
    
    switch (player) {
        case 1:
            [s.coverView setBackgroundImage:[UIImage imageNamed:@"xSquare.png"]
                                      forState:UIControlStateNormal];
            break;
        case 2:
            [s.coverView setBackgroundImage:[UIImage imageNamed:@"oSquare.png"]
                                      forState:UIControlStateNormal];
            break;
        case 3:
            [s.coverView setBackgroundImage:[UIImage imageNamed:@"blankSquare.png"]
                                      forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [s bringSubviewToFront:s.coverView];
}

- (void)highlightSquares:(bool)highlightAll boardVals:(NSArray *)boardVals lastMove:(int)lastMove
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.4];
    [UIView setAnimationDuration:0.3];
    if (highlightAll) {
        int i = 0;
        for (SmallBoardView *s in smallBoards) {
            if ([[boardVals objectAtIndex:i] intValue] == 0) {
                s.coverView.backgroundColor = [UIColor clearColor];
                s.coverView.alpha = 1;
            }
            i++;
        }
    } else {
        int i = 0;
        for (SmallBoardView *s in smallBoards) {
            if ([[boardVals objectAtIndex:i] intValue] == 0) {
                if (i == lastMove % 10) {
                    s.coverView.alpha = 1;
                    s.coverView.backgroundColor = [UIColor clearColor];
                } else {
                    s.coverView.backgroundColor = [UIColor blackColor];
                    s.coverView.alpha = .4;
                }
            }
            i++;
        }
    }
    
    [UIView commitAnimations];
}





@end
