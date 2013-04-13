//
//  PadCalcViewController.m
//  GraphCalc_Universal
//
//  Created by Mick O'Doherty on 03/04/2013.
//  Copyright (c) 2013 Mick O'Doherty. All rights reserved.
//

#import "PadCalcViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "PadGraphViewController.h"

@interface PadCalcViewController ()

@end

@implementation PadCalcViewController

- (void) awakeFromNib {
    self.splitViewController.delegate = self;
}

- (PadGraphViewController *)getPadGraphViewController {
    id padGraphVC = [self.splitViewController.viewControllers lastObject];
    if(![padGraphVC isKindOfClass:[PadGraphViewController class]]) padGraphVC =  nil;
    return padGraphVC;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonPresenter
{
    //This method simply returns the last object in the split view controller array, which is
    //the 'big' view, so long as it confomrs to the SplitViewBarButtonItemPresenter protcol
    //which it always should in our case. If it does not it retruns nil.
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    //To explain this slightly obscure line... this means
    //if the splitViewBarButtonPresenter method does not return nil
    //    then return YES (I.e hide the view controller) if the UI interface is Portrait
    //         and NO if it is not
    //else
    //    simply return NO
    //
    //This makes sure that we only hide the view controller when in Portrait and when the view
    //controller conforms to the SplitViewBarButtonItemPresenter protocol, and hence
    //has a bar button item.
    return [self splitViewBarButtonPresenter]?UIInterfaceOrientationIsPortrait(orientation):NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = barButtonItem;
    [[self splitViewBarButtonPresenter] showToolBar];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take button away
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = nil;
    [[self splitViewBarButtonPresenter] hideToolBar];
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    //Set this object as the delegate for its split view controller
    self.splitViewController.delegate = self;
    
    //set the graph view delegate to be the detail view (i.e. the big view on the iPad)
    self.plotGraphDelegate = [self getPadGraphViewController];
}

- (IBAction)graphButtonPressed:(id)sender {
    
    //Check that the expression has a variable in it
    if (![CalcModel variablesInExpression:self.calcModel.expression]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Expression has no variable"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    //Ask the graph to plot itself
    [self.plotGraphDelegate plotGraphFromExpressionInModel:self.calcModel];
    
}

@end
