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

- (void) didMoveToParentViewController:(UIViewController *)parent {
    
    //This is called when the 'back' button is hit - we want to leave the
    //event in this case
    [self.meshDisplayModel leaveEvent];
}
@end
