//
//  SmallBoardView.m
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import "SmallBoardView.h"

#define smallTL CGRectMake(0, 0, self.frame.size.width/3 - 1, self.frame.size.width/3 - 1)
#define smallTM CGRectMake(self.frame.size.width/3 +1 , 0, self.frame.size.width/3 -1, self.frame.size.width/3 -1)
#define smallTR CGRectMake(2*self.frame.size.width/3 +2 , 0, self.frame.size.width/3 -1, self.frame.size.width/3 - 1)
#define smallML CGRectMake(0, self.frame.size.width/3 +1, self.frame.size.width/3 - 1, self.frame.size.width/3 - 1)
#define smallMM CGRectMake(self.frame.size.width/3 +1 , self.frame.size.width/3 +1, self.frame.size.width/3 -1, self.frame.size.width/3 -1)
#define smallMR CGRectMake(2*self.frame.size.width/3 +2 , self.frame.size.width/3 +1, self.frame.size.width/3 -1, self.frame.size.width/3 - 1)
#define smallBL CGRectMake(0, 2*self.frame.size.width/3 +2, self.frame.size.width/3 - 1, self.frame.size.width/3 - 1)
#define smallBM CGRectMake(self.frame.size.width/3 +1 , 2*self.frame.size.width/3 +2, self.frame.size.width/3 -1, self.frame.size.width/3 -1)
#define smallBR CGRectMake(2*self.frame.size.width/3 +2 , 2*self.frame.size.width/3 +2, self.frame.size.width/3 -1, self.frame.size.width/3 - 1)

@implementation SmallBoardView
@synthesize values;
@synthesize TL, TM, TR, ML, MM, MR, BL, BM, BR;
@synthesize coverView;
@synthesize squares;
@synthesize defaultFrame;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        TL = [[UIButton alloc] initWithFrame:smallTL];
        TL.tag = 0;
        TM = [[UIButton alloc] initWithFrame:smallTM];
        TM.tag = 0;
        TR = [[UIButton alloc] initWithFrame:smallTR];
        TR.tag = 0;
        ML = [[UIButton alloc] initWithFrame:smallML];
        ML.tag = 0;
        MM = [[UIButton alloc] initWithFrame:smallMM];
        MM.tag = 0;
        MR = [[UIButton alloc] initWithFrame:smallMR];
        MR.tag = 0;
        BL = [[UIButton alloc] initWithFrame:smallBL];
        BL.tag = 0;
        BM = [[UIButton alloc] initWithFrame:smallBM];
        BM.tag = 0;
        BR = [[UIButton alloc] initWithFrame:smallBR];
        BR.tag = 0;
        
        coverView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 101, 101)];
        defaultFrame = frame;
        
        [self addSubview:TL];
        [self addSubview:TR];
        [self addSubview:TM];
        [self addSubview:ML];
        [self addSubview:MM];
        [self addSubview:MR];
        [self addSubview:BL];
        [self addSubview:BM];
        [self addSubview:BR];
        [self addSubview:coverView];
        
        self.backgroundColor = [UIColor blackColor];
        [self bringSubviewToFront:coverView];
        coverView.backgroundColor = [UIColor clearColor];
        coverView.alpha = 1;
        [self setSquareColor:[UIColor whiteColor]];
        NSLog(@"creating smallboardView");
        
        squares = [[NSMutableArray alloc] init];
        [squares addObject:TL];
        [squares addObject:TM];
        [squares addObject:TR];
        [squares addObject:ML];
        [squares addObject:MM];
        [squares addObject:MR];
        [squares addObject:BL];
        [squares addObject:BM];
        [squares addObject:BR];
        
        
        
        values= 0;
        
    }
    
    return self;
}




- (void)setSquareColor:(UIColor *)color
{
    TL.backgroundColor = color;
    TM.backgroundColor = color;
    TR.backgroundColor = color;
    ML.backgroundColor = color;
    MM.backgroundColor = color;
    MR.backgroundColor = color;
    BL.backgroundColor = color;
    BM.backgroundColor = color;
    BR.backgroundColor = color;
}

- (void)enlargeSquare
{
    coverView.frame = CGRectMake(0, 0, 320, 330);
    TL.frame = smallTL;
    TM.frame = smallTM;
    TR.frame = smallTR;
    ML.frame = smallML;
    MM.frame = smallMM;
    MR.frame = smallMR;
    BL.frame = smallBL;
    BM.frame = smallBM;
    BR.frame = smallBR;
}

- (void)shrinkSquare
{
    coverView.frame = CGRectMake(0, 0, 101, 101);
    TL.frame = smallTL;
    TM.frame = smallTM;
    TR.frame = smallTR;
    ML.frame = smallML;
    MM.frame = smallMM;
    MR.frame = smallMR;
    BL.frame = smallBL;
    BM.frame = smallBM;
    BR.frame = smallBR;
}

@end

