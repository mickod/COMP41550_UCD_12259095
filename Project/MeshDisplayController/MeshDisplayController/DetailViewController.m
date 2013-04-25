//
//  DetailViewController.m
//  MeshDisplayController
//
//  Created by Mick O'Doherty on 16/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "DetailViewController.h"
#import "DeviceView.h"
#import "AppDelegate.h"
#import "ClientDevice.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the model to be the appdelgate model
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.meshDisplayControllermodel = appDelegate.meshDisplayControllermodel;
    
    //Set self to the MeshDisplayModelViewDelegate
    self.meshDisplayControllermodel.MeshDisplayModelViewDelegate = self;
    
    //Create the device view dictionary
     self.clientDeviceViews = [[NSMutableDictionary alloc] init];
    
    [self configureView];
}

- (void)handlePanGestureEventOnDeviceView:(UIPanGestureRecognizer *)sender {
    
    //Move the origin with the pan
    NSLog(@"Pan Gesture");
    
    CGPoint translation = [sender translationInView:self.view];
    CGRect rect = sender.view.frame;
    rect.origin = CGPointMake(sender.view.frame.origin.x + translation.x, sender.view.frame.origin.y + translation.y);
    sender.view.frame = rect;
    [self.view setNeedsDisplay];
    
    //set the translation view as translationInView gives the delta from the initial
    //point not from the last time it was called
    [sender setTranslation:CGPointZero inView:self.view];
    
}

- (void) handleTapEventOnDeviceView:(UIPanGestureRecognizer *)sender {
    
    //Unused for now
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) handleClientDeviceAddedEvent:(ClientDevice*) clientDeviceAdded {
    
    //Model delegate method - new devices have been creted so add them to the display
    
    //If the device if is controller do not create a device view for the device
    //Note this is clearly relying on a text string whihc is not good practice so should
    //be changed when time permits (time is not doing much permitting at the moment...)
    if ([clientDeviceAdded.deviceID isEqualToString:@"CONTROLLER"]) {
        return;
    }
    
    //Add a new DeviceView
    DeviceView *newDeviceView = [[DeviceView alloc] init];
    CGRect rect = newDeviceView.frame;
    rect.origin = CGPointMake(100, 100);
    newDeviceView.frame = rect;
    @synchronized(self) {
        [self.view addSubview:newDeviceView];
    }
    
    //Add the text to the view and the deviceID to the device label
    newDeviceView.displayTextField.text = clientDeviceAdded.text;
    newDeviceView.deviceLabel.text = clientDeviceAdded.deviceID;
    
    //Add the pan gesture to the device
    UIPanGestureRecognizer *deviceViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                              initWithTarget:self action:@selector(handlePanGestureEventOnDeviceView:)];
    [newDeviceView addGestureRecognizer:deviceViewPanGestureRecognizer];
    
    //Set self as the delegate for the view
    newDeviceView.deviceViewDelegae = self;
    
    //Add the new device to the dictionary
    @synchronized(self) {
        [self.clientDeviceViews  setValue:newDeviceView forKey:clientDeviceAdded.deviceID];
    }
}

- (void) handleClientDeviceRemovedEvent:(ClientDevice *)clientDeviceRemoved {
    
    //Model delegate method - a device has been removed so remove it from the display.
    
    //remove a new DeviceView
    DeviceView *deviceViewToGo = [self.clientDeviceViews objectForKey:clientDeviceRemoved.deviceID];
    [deviceViewToGo removeFromSuperview];
    
    //Remove from the dictionary
    @synchronized(self) {
        [self.clientDeviceViews  removeObjectForKey:clientDeviceRemoved.deviceID];
    }
}

- (void) handleDeviceViewTextEditedEvent:(NSString*) newText forDevice:(NSString*)deviceID {
    
    //DeviceView delegate method - this handles a user updating the text for a device
    [self.meshDisplayControllermodel setTextForDevice:deviceID withText:newText];
}

@end
