//
//  PolyWebViewController.m
//  HelloPoly
//
//  Created by Mick O'Doherty on 17/01/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PolyWebViewController.h"

@interface PolyWebViewController ()

@end

@implementation PolyWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    NSString *polygonName = [NSString stringWithFormat:@"%@%@", @"http://en.wikipedia.org/wiki/",self.model.name];
	NSURL * url = [NSURL URLWithString:polygonName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval: 10];
    [self.polyWebView loadRequest:request];
    self.polyWebView.hidden = NO;
    NSLog(@"PolyWebViewController viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
