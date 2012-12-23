//
//  SmallBoardView.h
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallBoardView : UIView

@property (nonatomic) int values;
@property (strong, nonatomic) UIButton *TL;
@property (strong, nonatomic) UIButton *TM;
@property (strong, nonatomic) UIButton *TR;
@property (strong, nonatomic) UIButton *ML;
@property (strong, nonatomic) UIButton *MM;
@property (strong, nonatomic) UIButton *MR;
@property (strong, nonatomic) UIButton *BL;
@property (strong, nonatomic) UIButton *BM;
@property (strong, nonatomic) UIButton *BR;
@property (strong, nonatomic) UIButton *coverView;
@property (strong, nonatomic) NSMutableArray *squares;
@property (nonatomic) CGRect defaultFrame;

- (void)setSquareColor:(UIColor *)color;
- (void)enlargeSquare;
- (void)shrinkSquare;

@end
