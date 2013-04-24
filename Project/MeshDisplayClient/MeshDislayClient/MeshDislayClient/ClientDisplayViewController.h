//
//  ClientDisplayViewController.h
//  MeshDislayClient
//
//  Created by Mick O'Doherty on 21/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDisplayClientModel.h"

@interface ClientDisplayViewController : UIViewController <MeshDisplayClientDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ClientDisplayTextLabel;
@property (strong, nonatomic) MeshDisplayClientModel *meshDisplayModel;
@end
