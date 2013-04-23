//
//  MasterViewController.h
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDisplayControllerModel.h"

@interface MasterViewController : UIViewController
- (IBAction)createEventEvent:(UIButton *)sender;
- (IBAction)eventCodeEnteredEvent:(UITextField *)sender;
- (IBAction)deleteEventEvent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *EventCodeTextField;
@property (strong, nonatomic) MeshDisplayControllerModel *meshDisplayControllermodel;
@end
