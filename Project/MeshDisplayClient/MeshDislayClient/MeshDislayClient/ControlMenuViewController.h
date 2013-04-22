//
//  ViewController.h
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDisplayClientModel.h"

@interface ControlMenuViewController : UIViewController
- (IBAction)joinEventButtonPushed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *EventIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *ClientIDTextField;
@property (strong, nonatomic) MeshDisplayClientModel *meshDisplayModel;
@end
