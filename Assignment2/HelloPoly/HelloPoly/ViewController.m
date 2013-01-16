//
//  ViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIColor* initialButtonTextColor;
@end

@implementation ViewController

enum SIDE_NUMBERS {
    MINIMUM_SIDES = 3,
    LAST_DECREASEABLE_SIDES = 4,
    LAST_INCREASABLE_SIDES = 11,
    MAXIMUM_SIDES = 12
};


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

- (void) updateUI {
    NSLog(@"updateUI: number of sides: %i", self.model.numberOfSides);
    
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
    self.initialButtonTextColor = self.increaseButton.currentTitleColor;
    [self updateUI];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"My polygon: %@", self.model.name);
}

@end
