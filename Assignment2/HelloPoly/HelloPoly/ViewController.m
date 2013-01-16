//
//  ViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
            sender.enabled = NO;
            break;
        }
        default: {
            self.model.numberOfSides -=1;
        }
    }
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
            sender.enabled = NO;
            break;
        }
        default: {
            self.model.numberOfSides +=1;
        }
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"My polygon: %@", self.model.name);
}

@end
