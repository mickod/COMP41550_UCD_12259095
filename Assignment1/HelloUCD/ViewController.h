//
//  ViewController.h
//  HelloUCD
//
//  Created by Mick O'Doherty on 15/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)imageLongPressEvent:(UILongPressGestureRecognizer *)sender;
- (IBAction)imageTapEvent:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ucdLogo;
@end
