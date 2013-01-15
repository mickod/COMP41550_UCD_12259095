//
//  ViewController.m
//  HelloUCD
//
//  Created by Mick O'Doherty on 15/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageTapEvent:(UILongPressGestureRecognizer *)sender {
    //Animate the image for a short tap event
    if (self.ucdLogo.isAnimating) {
        [self.ucdLogo stopAnimating];
        self.ucdLogo.image = [UIImage imageNamed:@"largeUCDLogo.png"];
    } else {
        self.ucdLogo.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"UCDFencing.jpg"],
                                        [UIImage imageNamed:@"UCDBall.jpg"],
                                        [UIImage imageNamed:@"largeUCDLogo.png"],
                                        nil];
        self.ucdLogo.animationDuration = 2.0;
        self.ucdLogo.transform = CGAffineTransformIdentity;
        [self.ucdLogo startAnimating];
        self.ucdLogo.userInteractionEnabled = YES;
    }
}

- (IBAction)imageLongPressEvent:(UITapGestureRecognizer *)sender {
    //Rotate the image for a long press event
    float angle = 3.142;
    self.ucdLogo.transform = CGAffineTransformRotate(self.ucdLogo.transform, angle);
}

@end
