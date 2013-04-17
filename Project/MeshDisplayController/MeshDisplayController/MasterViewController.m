//
//  MasterViewController.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "MasterViewController.h"
#import "DeviceView.h"
#import "AppDelegate.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    //Set the model to be the appdelgate model
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.meshDisplayControllermodel = appDelegate.meshDisplayControllermodel;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEventEvent:(UIButton *)sender {
    
    //The user wants to create a new event (Yes I know ...EventEvent is a silly name but...)
    [self.meshDisplayControllermodel createEvent:self.EventCodeTextField.text];
}

- (IBAction)deleteEventEvent:(UIButton *)sender {
    
    //The user wants to delete the current event
    [self.meshDisplayControllermodel deleteCurrentEvent];
}

- (IBAction)eventCodeEnteredEvent:(UITextField *)sender {
    
    //The user has entered an event code - currently we just ignore this unless they
    //push Create event also, in which case we will create a new event
}
@end
