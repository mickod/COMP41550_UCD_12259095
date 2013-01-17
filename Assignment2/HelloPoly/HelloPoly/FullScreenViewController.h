//
//  FullScreenViewController.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 17/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"
#import "PolygonView.h"

@interface FullScreenViewController : UIViewController <PolygonViewDataProvider>
@property (strong, nonatomic) IBOutlet PolygonShape *model;
@property (strong, nonatomic) IBOutlet PolygonView *fullScreenPolygonView;
- (IBAction)backButton:(id)sender;

@end
