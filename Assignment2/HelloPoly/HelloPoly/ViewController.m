//
//  ViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"
#import "FullScreenViewController.h"
#import "PolyWebViewController.h"
#import "PolyAnimateViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIColor* initialButtonTextColor;
@property Boolean animationEnabled;
@property float animationDuration;
@end

#define POLYGON_NAMES [NSArray arrayWithObjects: @"Henagon",@"Digon", @"Triangle",@"Reactangle", @"Pentagon",@"hexagon",@"Heptagon",@"Octagon",@"Nonagon",@"Decagon",@"Hendecagon",@"DoDecagon",nil]

#define USER_DEFAULT_ANIMATION_ENABLED @"USER_DEFAULT_ANIMATION_ENABLED"
#define USER_DEFAULT_ANIMATION_DURATION @"USER_DEFAULT_ANIMATION_DURATION"

enum SIDE_NUMBERS {
    MINIMUM_SIDES = 3,
    LAST_DECREASEABLE_SIDES = 4,
    LAST_INCREASABLE_SIDES = 11,
    MAXIMUM_SIDES = 12
};

@implementation ViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ViewController prepareForSegue");
    if ([[segue identifier] isEqualToString:@"FULL_SCREEN_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is FullScreenViewController");
        FullScreenViewController *destinationVC = segue.destinationViewController;
        destinationVC.model = self.model;
        destinationVC.fullSreenViewControllerDelegate = self;
    } else if ([[segue identifier] isEqualToString:@"WEB_VIEW_SEGUE"]) {
        NSLog(@"ViewController prepareForSegue - kind is PolyWebViewController");
        PolyWebViewController *destinationVC = segue.destinationViewController;
        destinationVC.navigationController.navigationBarHidden = NO;
        destinationVC.model = self.model;
    } else if ([[segue identifier] isEqualToString:@"ANIMATE_VIEW_SEGUE"]){
        NSLog(@"ViewController prepareForSegue - kind is PolyAnimateViewController");
        PolyAnimateViewController *destinationVC = segue.destinationViewController;
        destinationVC.navigationController.navigationBarHidden = NO;
        destinationVC.model = self.model;
        destinationVC.polygonAnimateStateDelegate = self;
    }
}

- (IBAction)decrease:(UIButton *)sender {
    NSLog(@"decrease button handler");
    [self.polygonView stopAnimation];
    
    //Do not allow decrease below 3 and disable decrease button
    //if sides are at 4, before decreasing number of sides
    switch (self.model.numberOfSides) {
        case MINIMUM_SIDES: {
            return;
            break;
        }
        case LAST_DECREASEABLE_SIDES: {
            self.model.numberOfSides -=1;
            self.decreaseButton.enabled = NO;
            [self.decreaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            break;
        }
        default: {
            self.model.numberOfSides -=1;
            //Check to see if the increase button has been disabled and if so
            //renable it as we have now decreased the sides again
            if (!self.increaseButton.enabled) {
                self.increaseButton.enabled = YES;
                [self.increaseButton setTitleColor:self.initialButtonTextColor forState:UIControlStateNormal];
            }
        }
    }
    
    [self updateUI];
    NSLog(@"decrease button handler: number of sides at exit: %i", self.model.numberOfSides);
}

- (IBAction)increase:(UIButton *)sender {
    NSLog(@"increase button handler");
    [self.polygonView stopAnimation];
    
    //Do not allow increase above 12 and disable increase button
    //if sides are at 11, before increasing number of sides
    switch (self.model.numberOfSides) {
        case MAXIMUM_SIDES: {
            return;
            break;
        }
        case LAST_INCREASABLE_SIDES: {
            self.model.numberOfSides +=1;
            self.increaseButton.enabled = NO;
            [self.increaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            break;
        }
        default: {
            self.model.numberOfSides +=1;
            //Check to see if the decrease button has been disabled and if so
            //renable it as we have now increased the sides again
            if (!self.decreaseButton.enabled) {
                self.decreaseButton.enabled = YES;
                [self.decreaseButton setTitleColor:self.initialButtonTextColor forState:UIControlStateNormal];
            }
        }
    }
    
    [self updateUI];
    NSLog(@"increase button handler: number of sides at exit: %i", self.model.numberOfSides);
}

- (IBAction)shapeTapped:(id)sender {
    //If the shape is tapped then start animation if it is set
    NSLog(@"ViewController shapeTapped ");
    if (self.animationEnabled) {
        [self.polygonView animateNow];
    } 
}

- (int) numberOfSidesForPolygonView:(PolygonView*)polygonViewDelegator {
    //This is the implementation of the polygonViewDataProvider protocol method
    //that the controller must implement as it declares it implements this protocol
    NSLog(@"ViewController numberOfSidesForPolygonView %i", self.model.numberOfSides);
    if ([polygonViewDelegator isKindOfClass:[PolygonView class]]) {
        return self.model.numberOfSides;
    } else {
        return 0;
    }
}

- (void) setAnimation:(Boolean) setAnimationFlag: (PolyAnimateViewController *) protocolpolyAnimateViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //that the controller must implement to set the animation flag.
    NSLog(@"ViewController setAnimation ");
    self.animationEnabled = setAnimationFlag;
    //Save key values in the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.animationEnabled
                   forKey:USER_DEFAULT_ANIMATION_ENABLED];
    [userDefaults synchronize];
}

- (void) setAnimationDuration:(float)animateDurationSetting :(PolyAnimateViewController *)protocolpolyAnimateViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //that the controller must implement to set the anmation duration
    NSLog(@"ViewController setAnimationSpeed ");
    self.animationDuration = animateDurationSetting;
    
    //Save key values in the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:self.animationDuration
                    forKey:USER_DEFAULT_ANIMATION_DURATION];
    [userDefaults synchronize];
}

- (Boolean) getCurrentAnimationState: (PolyAnimateViewController *) protocolpolyAnimateViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the current animation enabled state.
    NSLog(@"ViewController getCurrentAnimationState ");
    return self.animationEnabled;
}

- (float) getCurrentAnimationDuration: (PolyAnimateViewController *) protocolpolyAnimateViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the current animation duration value.
    NSLog(@"ViewController getCurrentAnimationDuration ");
    return self.animationDuration;
}

- (NSString*) getAnimationImageFileName:(PolygonView *) polygonViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the animation image.
    NSLog(@"ViewController getCurrentAnimationState ");
    return nil;
}

- (float) getAnimationDuartionForView:(PolygonView *) polygonViewDelegator {
    //This is the implementation of the PolygonAnimateViewProtocol protocol method
    //to provide the animation duration to the view.
    NSLog(@"ViewController getAnimationDuration ");
    return self.animationDuration;
}

- (float) getAnimationDurationFromDelegateController:(FullScreenViewController*) fullViewScreenDelegate {
    return self.animationDuration;
}

- (void) updateUI {
    NSLog(@"updateUI: number of sides: %i", self.model.numberOfSides);
    
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
    self.polygonName.text = POLYGON_NAMES[self.model.numberOfSides -1];
    [self.polygonView setNeedsDisplay];
}

- (void) viewDidLoad {
    NSLog(@"ViewController viewDidLoad");
    [super viewDidLoad];
    self.initialButtonTextColor = self.increaseButton.currentTitleColor;
    [self.polygonView setPolygonViewDelegate:self];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.animationEnabled = NO;
    self.animationDuration = 5;
    [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    //Load the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.animationEnabled = [userDefaults boolForKey:USER_DEFAULT_ANIMATION_ENABLED];
    self.animationDuration = [userDefaults floatForKey:USER_DEFAULT_ANIMATION_DURATION];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"My polygon: %@", self.model.name);
}

@end
