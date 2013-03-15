//
//  Game.m
//  SuperTicTacToe
//
//  Created by Billy Irwin on 12/19/12.
//
//

#import "Game.h"

@implementation Game
@synthesize boardVals, lastMove, currentPlayer;
@synthesize player1, player2;
@synthesize freeMove;
@synthesize done;

- (id)init {
    self = [super init];
    if (self) {
        boardVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j = 0; j < 9; j++) {
                [array addObject:[NSNumber numberWithInt:0]];
            }
            [boardVals addObject:array];
        }
        
        currentPlayer = [[NSString alloc] init];
        player1 = [[NSString alloc] init];
        player2 = [[NSString alloc] init];
        lastMove = 999;
        freeMove = true;
        done = false;
        
    }
    return self;
}




@end
