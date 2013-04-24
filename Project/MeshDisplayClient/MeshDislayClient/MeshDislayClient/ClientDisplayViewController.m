//
//  ClientDisplayViewController.m
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ClientDisplayViewController.h"

@interface ClientDisplayViewController ()

@end

@implementation ClientDisplayViewController

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
	// Do any additional setup after loading the view.
    self.meshDisplayModel.meshDisplayClientDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setClientDisplayTextLabel:nil];
    [super viewDidUnload];
}

- (void) handleModelDisplayTextUpdatedEvent {
    
    //The text has been updated so redraw the view
    self.ClientDisplayTextLabel.text = self.meshDisplayModel.textToDisplay;
    [self.view setNeedsDisplay];
}

@end
