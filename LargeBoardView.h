//
//  LargeBoardView.h
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallBoardView.h"

@interface LargeBoardView : UIView

@property (strong, nonatomic) SmallBoardView *topLeft;
@property (strong, nonatomic) SmallBoardView *topMid;
@property (strong, nonatomic) SmallBoardView *topRight;
@property (strong, nonatomic) SmallBoardView *midLeft;
@property (strong, nonatomic) SmallBoardView *midMid;
@property (strong, nonatomic) SmallBoardView *midRight;
@property (strong, nonatomic) SmallBoardView *botLeft;
@property (strong, nonatomic) SmallBoardView *botMid;
@property (strong, nonatomic) SmallBoardView *botRight;
@property (strong, nonatomic) NSMutableArray *smallBoards;
@property (strong, nonatomic) SmallBoardView *enlargedView;
@property (strong, nonatomic) SmallBoardView *nextSquare;

- (void)enlargeSquare:(int)board;
- (void)shrinkSquare;
- (void)updateBoard:(int)board square:(int)square player:(int)player;
- (void)updateOldBoard:(int)board square:(int)square player:(int)player;
- (void)updateCover:(int)board player:(int)player;
- (void)highlightSquares:(bool)highlightAll boardVals:(NSArray *)boardVals lastMove:(int)lastMove;

@end
