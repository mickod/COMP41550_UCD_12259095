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

@interface ViewController ()
@property (weak, nonatomic) UIColor* initialButtonTextColor;
@end

#define POLYGON_NAMES [NSArray arrayWithObjects: @"Henagon",@"Digon", @"Triangle",@"Reactangle", @"Pentagon",@"hexagon",@"Heptagon",@"Octagon",@"Nonagon",@"Decagon",@"Hendecagon",@"DoDecagon",nil]

enum SIDE_NUMBERS {
    MINIMUM_SIDES = 3,
    LAST_DECREASEABLE_SIDES = 4,
    LAST_INCREASABLE_SIDES = 11,
    MAXIMUM_SIDES = 12
};

@implementation ViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[FullScreenViewController class]]) {
        NSLog(@"ViewController prepareForSegue - kind is lScreenViewController");
        FullScreenViewController *destinationVC = segue.destinationViewController;
        destinationVC.model = self.model;
    } else if ([sender isKindOfClass:[PolyWebViewController class]]) {
        NSLog(@"ViewController prepareForSegue - kind is PolyWebViewController");
        PolyWebViewController *destinationVC = segue.destinationViewController;
        destinationVC.navigationController.navigationBarHidden = NO;
    }
}


- (IBAction)decrease:(UIButton *)sender {
    NSLog(@"decrease button handler");
    
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

- (IBAction)polygonTappedEvent:(id)sender {
   
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

- (void) updateUI {
    NSLog(@"updateUI: number of sides: %i", self.model.numberOfSides);
    
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
    self.polygonName.text = POLYGON_NAMES[self.model.numberOfSides -1];
    [self.polygonView setNeedsDisplay];
}

- (void) viewDidLoad {
    NSLog(@"ViewController viewDidLoad");
    [super viewDidLoad];
    self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
    self.initialButtonTextColor = self.increaseButton.currentTitleColor;
    [self.polygonView setPolygonViewDelegate:self];
    [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"My polygon: %@", self.model.name);
}

@end
