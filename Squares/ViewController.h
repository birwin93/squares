//
//  ViewController.h
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallBoardView.h"

@interface ViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;



@end
