//
//  MenuViewController.m
//  Squares
//
//  Created by Billy Irwin on 12/19/12.
//  Copyright (c) 2012 BirwinApps. All rights reserved.
//

#import "MenuViewController.h"
#import "Game.h"
#import "GameViewController.h"
#import <Parse/Parse.h>


#define offScreen CGRectMake(0, -200, 320, 200)
#define onScreen CGRectMake(0, 0, 320, 200)
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize gamesArray, yourMove, opponentsMove, finishedGames;
@synthesize gamesTableView;
@synthesize usernameTextField;
@synthesize createGameView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (IBAction)addGame:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    createGameView.frame = onScreen;
    [UIView commitAnimations];
}

- (IBAction)createGame:(id)sender
{
    
    [usernameTextField resignFirstResponder];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:usernameTextField.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            createGameView.frame = offScreen;
            [UIView commitAnimations];
            
            PFObject *newGame = [PFObject objectWithClassName:@"Game"];
            
            NSMutableArray *gameData = [[NSMutableArray alloc] init];
            for (int i = 0; i<10; i++) {
                NSMutableArray *smallBoard = [[NSMutableArray alloc] init];
                for (int j = 0; j<9; j++) {
                    [smallBoard addObject:[NSNumber numberWithInt:0]];
                }
                [gameData addObject:smallBoard];
            }
            
            [newGame setObject:gameData forKey:@"boardData"];
            [newGame setObject:[PFUser currentUser].username forKey:@"player1"];
            [newGame setObject:[object objectForKey:@"username"] forKey:@"player2"];
            [newGame setObject:[PFUser currentUser].username forKey:@"currentPlayer"];
            [newGame setObject:[NSNumber numberWithBool:NO] forKey:@"done"];
            [newGame setObject:[NSNumber numberWithBool:YES] forKey:@"freeMove"];
            [newGame setObject:[NSNumber numberWithBool:YES] forKey:@"newGame"];
            [newGame setObject:[NSNumber numberWithInt:0] forKey:@"lastMove"];
            [newGame saveInBackground];
        
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No user with username exists"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)cancel:(id)sender
{
    [usernameTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    createGameView.frame = offScreen;
    [UIView commitAnimations];
}

- (IBAction)reload:(id)sender
{
    [self loadGames];
}

- (IBAction)logout:(id)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(addGame:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    [self loadGames];
}

- (void)loadGames
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"player1" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            PFQuery *query1 = [PFQuery queryWithClassName:@"Game"];
            [query1 whereKey:@"player2" equalTo:[PFUser currentUser].username];
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *results2, NSError *error) {
                if (!error) {
                    NSLog(@"results: %i", [results count]);
                    NSLog(@"results: %i", [results2 count]);
                    [gamesArray removeAllObjects];
                    [gamesArray addObjectsFromArray:results];
                    [gamesArray addObjectsFromArray:results2];
                    NSLog(@"results: %i", [gamesArray count]);
                    [self organizeGames];
                    
                } else {
                    NSLog(@"%@", error);
                }
            }];
            
        } else {
            NSLog(@"%@", error);
        }
    }];

}

- (void)organizeGames {
    [yourMove removeAllObjects];
    [opponentsMove removeAllObjects];
    [finishedGames removeAllObjects];
    
    NSLog(@"all games: %i", [gamesArray count]);
    
    for (PFObject *game in gamesArray) {
        if ([[game objectForKey:@"done"] boolValue] == true) {
            [finishedGames addObject:game];
        } else {
            if ([[game objectForKey:@"currentPlayer"] isEqualToString:[PFUser currentUser].username]) {
                [yourMove addObject:game];
            } else {
                [opponentsMove addObject:game];
            }
        }
    }
    
    [gamesTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    gamesArray = [[NSMutableArray alloc] init];
    yourMove = [[NSMutableArray alloc] init];
    opponentsMove = [[NSMutableArray alloc] init];
    finishedGames = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playGame:(id)sender
{
    [self performSegueWithIdentifier:@"playGame" sender:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 0) {
        NSLog(@"yourMoves: %i", [yourMove count]);
        return [yourMove count];
    } else if (section == 1) {
        NSLog(@"opponentsMoves: %i", [opponentsMove count]);
        return [opponentsMove count];
    } else {
        NSLog(@"finishedGames: %i", [finishedGames count]);
        return [finishedGames count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Your Moves";
    } else if (section == 1) {
        return @"Opponent's Moves";
    } else {
        return @"Finished Games";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    
    PFObject *game;
    if (indexPath.section == 0) {
        game = [yourMove objectAtIndex:indexPath.row];
        if ([[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]) {
            label.text = [game objectForKey:@"player2"];
        } else {
            label.text = [game objectForKey:@"player1"];
        }
    } else if (indexPath.section == 1) {
        game = [opponentsMove objectAtIndex:indexPath.row];
        if ([[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]) {
            label.text = [game objectForKey:@"player2"];
        } else {
            label.text = [game objectForKey:@"player1"];
        }
    } else {
        game = [finishedGames objectAtIndex:indexPath.row];
        if ([[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]) {
            label.text = [game objectForKey:@"player2"];
        } else {
            label.text = [game objectForKey:@"player1"];
        }

    }
    
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"playGame" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameViewController *g = [segue destinationViewController];
    NSIndexPath *selectedGame = [gamesTableView indexPathForSelectedRow];
    PFObject *game;
    if (selectedGame.section == 0) {
        game = [yourMove objectAtIndex:selectedGame.row];
    } else if (selectedGame.section == 1) {
        game = [opponentsMove objectAtIndex:selectedGame.row];
    } else {
        game = [finishedGames objectAtIndex:selectedGame.row];
    }
    
    g.game = game;
}


@end
