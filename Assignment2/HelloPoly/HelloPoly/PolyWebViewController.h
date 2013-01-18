//
//  PolyWebViewController.h
//  HelloPoly
//
//  Created by Mick O'Doherty on 17/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"

@interface PolyWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *polyWebView;
@property (strong, nonatomic) PolygonShape *model;
@end
