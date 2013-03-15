//
//  BaseViewController.m
//  Squares
//
//  Created by Billy Irwin on 1/1/13.
//  Copyright (c) 2013 BirwinApps. All rights reserved.
//

#import "BaseViewController.h"
#import <Parse/Parse.h>

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize MenuView;
@synthesize menuOn;
@synthesize logoutButton;
@synthesize helpButton;
@synthesize soloGameButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    UIScreen *screen = [UIScreen mainScreen];
    MenuView = [[UIView alloc] initWithFrame:CGRectMake(-1 * screen.bounds.size.width/2, 0, screen.bounds.size.width/2, screen.bounds.size.height)];
    MenuView.backgroundColor = [UIColor blackColor];
    NSLog(@"screen dimensions: %f %f", screen.bounds.size.width/2, screen.bounds.size.height);
    [self.view addSubview:MenuView];
    
    logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MenuView.bounds.size.height-95, MenuView.bounds.size.width, 40)];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MenuView.bounds.size.width, 40)];
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(help:) forControlEvents:UIControlEventTouchUpInside];
    
    soloGameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, MenuView.bounds.size.width, 40)];
    [soloGameButton setTitle:@"Play Local Game" forState:UIControlStateNormal];
    [soloGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [soloGameButton addTarget:self action:@selector(playLocalGame:) forControlEvents:UIControlEventTouchUpInside];
    
    [MenuView addSubview:logoutButton];
    [MenuView addSubview:helpButton];
    [MenuView addSubview:soloGameButton];
    
    menuOn = false;
	// Do any additional setup after loading the view.
}

- (IBAction)playLocalGame:(id)sender
{
    [self performSegueWithIdentifier:@"localGame" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    menuOn = false;
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(menuOut:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
}

- (IBAction)menuOut:(id)sender
{
    if (menuOn) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        UIScreen *screen = [UIScreen mainScreen];
        MenuView.frame = CGRectMake(0, 0, screen.bounds.size.width/2, screen.bounds.size.height);
        [UIView commitAnimations];
        menuOn = false;
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        UIScreen *screen = [UIScreen mainScreen];
        MenuView.frame = CGRectMake(-1 * screen.bounds.size.width/2, 0, screen.bounds.size.width/2, screen.bounds.size.height);
        [UIView commitAnimations];
        menuOn = true;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuView:nil];
    [super viewDidUnload];
}
- (IBAction)help:(id)sender {
}

- (IBAction)logout:(id)sender
{
    [[PFInstallation currentInstallation] removeObject:[PFUser currentUser].username forKey:@"channels"];
    [[PFInstallation currentInstallation] saveInBackground];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
