//
//  ViewController.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 16/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"
#import "PolygonView.h"
#import "PolyAnimateViewController.h"


@interface ViewController : UIViewController <PolygonViewDataProvider, PolygonAnimateViewProtocol>
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (strong, nonatomic) PolygonShape *model;
@property (strong, nonatomic) IBOutlet UIButton *decreaseButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseButton;
@property (strong, nonatomic) IBOutlet PolygonView *polygonView;
@property (weak, nonatomic) IBOutlet UILabel *polygonName;
- (IBAction)decrease:(id)sender;
- (IBAction)increase:(id)sender;
- (IBAction)shapeTapped:(id)sender;


@end
