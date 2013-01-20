//
//  FullScreenViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 17/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "FullScreenViewController.h"

#define MOUSE_IMAGE_NAME @"Mouse"
#define MOUSE_IMAGE_FILENAME @"mouse1.png"

@interface FullScreenViewController ()

@end

@implementation FullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateUI {
    NSLog(@"FullScreenViewController updateUI: number of sides: %i", self.model.numberOfSides);
    [self.fullScreenPolygonView animateNow];
    [self.fullScreenPolygonView setNeedsDisplay];
}

- (int) numberOfSidesForPolygonView:(PolygonView*) polygonViewDelegator{
    //This is the implementation of the polygonViewDataProvider protocol method
    //that the controller must implement as it declares it implements this protocol
    NSLog(@"FullScreenViewController numberOfSidesForPolygonView %i", self.model.numberOfSides);
    if ([polygonViewDelegator isKindOfClass:[PolygonView class]]) {
        return self.model.numberOfSides;
    } else {
        return 0;
    }
}

- (NSString*) getAnimationImageFileName:(PolygonView *) polygonViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the animation image.
    NSLog(@"ViewController getCurrentAnimationState ");
    return [self.fullSreenViewControllerDelegate getAnimationImageFileNameFromDelegateController:self];
}


- (float) getAnimationDuartionForView:(PolygonView *) polygonViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the animation duration to the view.
    NSLog(@"ViewController getAnimationDuration ");
    return [self.fullSreenViewControllerDelegate getAnimationDurationFromDelegateController:self];
}

- (void)viewDidLoad
{
    NSLog(@"FullScreenViewController viewDidLoad");
    [super viewDidLoad];
    [self.fullScreenPolygonView setPolygonViewDelegate:self];
	[self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
