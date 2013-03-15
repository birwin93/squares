//
//  Game.h
//  SuperTicTacToe
//
//  Created by Billy Irwin on 12/19/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Game : NSObject

@property (strong, nonatomic) NSMutableArray *boardVals;
@property (strong, nonatomic) NSString *currentPlayer;
@property (strong, nonatomic) NSString *player1;
@property (strong, nonatomic) NSString *player2;
@property (nonatomic) int lastMove;
@property (nonatomic) bool freeMove;
@property (nonatomic) bool done;



@end
