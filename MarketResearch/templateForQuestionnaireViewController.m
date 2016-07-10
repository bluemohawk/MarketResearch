//
//  templateForQuestionnaireViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/23/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "templateForQuestionnaireViewController.h"

@interface templateForQuestionnaireViewController ()

@end

@implementation templateForQuestionnaireViewController

#pragma mark -
#pragma mark View Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setButtonsForAnswer];

}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //Where the parent tells the child that the device is rotating.
    self.view.frame = self.parentViewController.view.bounds;
}


- (void) viewDidLayoutSubviews {
    //Resize your layers and round layer's corner based on the view's new frame. Interesting when animating with auto layout.
    [super viewDidLayoutSubviews];
    [self maintainRoundedCorners];

    
}

    //- (void)updateViewConstraints
    //{
    //    [super updateViewConstraints];
    //        // do calculations if needed, like set constants
    //
    //}

#pragma mark -
#pragma mark Unpack Resources from Parse


#pragma mark -
#pragma mark Setup Questions and Buttons for Answers

-(void)setTitle:(NSString *)aTile {
}

-(void)setQuestion:(NSString *)aQuestion {
}

-(void)setButtonsForAnswer {
    
//    self.nextButton.backgroundColor = [UIColor blackColor];
//    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width/2;
//    self.nextButton.alpha = 0.0;
}


#pragma mark -
#pragma mark Setup Image Geometry and Animation

-(void) setCapsuleStrings:(NSArray *)anArray {
}


-(void)animateCapsuleStringInitialDisplay {
    
}

-(void) maintainRoundedCorners {

        //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
        //self.yesButton.layer.cornerRadius = self.yesButton.frame.size.height/2;
    
}


#pragma mark -
#pragma mark Touches Handling


- (void)handleItemSelection:(UITapGestureRecognizer *)recognizer {
    
}


-(void) checkForValidationCondition {
    
}


-(void)animateAnswerButtons:(UIButton *)aButton forConditionMet:(BOOL)conditionMet {
    
    if ((conditionMet == YES) && (aButton.alpha == 0.0)) {
        
        [self.view setNeedsLayout];
//        self.heightReset.constant += 5;
//        self.widthReset.constant += 5;
//        self.heightValidate.constant += 5;
//        self.widthValidate.constant += 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];
        
    } else if ((conditionMet == NO) && (aButton.alpha == 1.0)) {
        
        [self.view setNeedsLayout];
//        self.heightReset.constant -= 5;
//        self.widthReset.constant -= 5;
//        self.heightValidate.constant -= 5;
//        self.widthValidate.constant -= 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];
    }
}


- (IBAction)recordSelection:(UIButton *)validateButton {
    
        //implement delegate method
//    e.g., [self.delegate do something];
    
}



#pragma mark -
#pragma mark Delegate Methods


#pragma mark -
#pragma mark Child Parent View Controllers Coordination

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"childVC will leave");
        
    } else {
        NSLog(@"childVC will arrive");
            //get the resources necessary for the view controller set up
//        e.g., [self setQuestion:self.resourcesForQuestion_Parse.mainQuestion];
        
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"childVC left");
        
    } else {
        NSLog(@"childVC arrived");
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
