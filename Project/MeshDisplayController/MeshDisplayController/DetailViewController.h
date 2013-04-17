//
//  DetailViewController.h
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDisplayControllerModel.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (strong, nonatomic) MeshDisplayControllerModel *meshDisplayControllermodel;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
