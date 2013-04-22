//
//  ViewController.m
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ControlMenuViewController.h"
#import "ClientDisplayViewController.h"

@interface ControlMenuViewController ()

@end

@implementation ControlMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Set the default properties
    self.meshDisplayModel = [[MeshDisplayClientModel alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    NSLog(@"ControlMenuViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"CLIENT_DISPLAY_SEGUE"]) {
        //Segue to main Display view controller - set the model
        NSLog(@"ControlMenuViewController prepareForSegue - kind is CLIENT_DISPLAY_SEGUE");
         ClientDisplayViewController *destinationVC = segue.destinationViewController;
        destinationVC.meshDisplayModel = self.meshDisplayModel;
    }
}

- (IBAction)joinEventButtonPushed:(UIButton *)sender {
    
    //The user has asked to join an event - message the model with the event and the client id
    [self.meshDisplayModel joinEvent:self.EventIDTextField.text withClient:self.ClientIDTextField.text];
    
}

- (void)viewDidUnload {
    [self setEventIDTextField:nil];
    [self setClientIDTextField:nil];
    [super viewDidUnload];
}
@end
