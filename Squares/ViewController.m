//
//  ViewController.m
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "Game.h"
#import <Parse/Parse.h>

@implementation ViewController
@synthesize usernameTF, passwordTF;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    [self.navigationController setNavigationBarHidden:YES];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    [PFUser logInWithUsernameInBackground:usernameTF.text password:passwordTF.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            [[PFInstallation currentInstallation] addUniqueObject:user.username forKey:@"channels"];
            [[PFInstallation currentInstallation] saveInBackground];
            [self performSegueWithIdentifier:@"login" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username/password combination" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            passwordTF.text = @"";
        }
    }];
}

- (IBAction)signup:(id)sender
{
    [self performSegueWithIdentifier:@"signup" sender:self];
}


@end
