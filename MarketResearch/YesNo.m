//
//  YesNo.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "YesNo.h"

@interface YesNo ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightYes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthYes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthNo;


@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@end

@implementation YesNo


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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"YesNo viewDidLoad");

    [self setButtonsForAnswer];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        NSLog(@"YesNo viewWillAppear");
    self.questionLabel.text = self.resourcesForQuestion_Parse.mainQuestion;

    NSLog(@"%@", self.resourcesForQuestion_Parse.mainQuestion);
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"YesNo viewDidAppear");
    
    [self animateAnswerButtons:self.yesButton toDismiss:NO];
    [self animateAnswerButtons:self.noButton toDismiss:NO];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.view.frame = self.parentViewController.view.bounds;
}

- (void) viewDidLayoutSubviews {
        // resize your layers based on the view's new frame
    NSLog(@"YesNo viewDidLayoutSubviews");

    
    [super viewDidLayoutSubviews];
    

    [self maintainRoundedCorners];

}

    //- (void)updateViewConstraints
    //{
    //    [super updateViewConstraints];
    //        // do calculations if needed, like set constants
    //    NSLog(@"something xxxx");
    //
    //}

#pragma mark -
#pragma mark Unpack Resources from Parse


#pragma mark -
#pragma mark Questions and Buttons for Answers

-(void)setTitle:(NSString *)aTilte {
    
//    self.studyTitle.text = aTilte;
}


-(void)setContext: (NSString *)aContext {
    
//    self.studyContext.text = aContext;
}


-(void)setButtonsForAnswer {
    
    self.yesButton.backgroundColor = [UIColor whiteColor];
    [self.yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.yesButton.layer.cornerRadius = self.yesButton.frame.size.width/2;
    self.yesButton.alpha = 0.0;
    
    self.noButton.backgroundColor = [UIColor whiteColor];
    [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.noButton.layer.cornerRadius = self.noButton.frame.size.width/2;
    self.noButton.alpha = 0.0;


}


#pragma mark -
#pragma mark Image Geometry and Animation


-(void) maintainRoundedCorners {
    
    //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
    self.yesButton.layer.cornerRadius = self.yesButton.frame.size.height/2;
    self.noButton.layer.cornerRadius = self.noButton.frame.size.height/2;
    
}

#pragma mark -
#pragma mark Touches Handling


-(void)animateAnswerButtons:(UIButton *)aButton toDismiss:(BOOL)dismiss {
    
    if (dismiss == NO) {
        
        [self.view setNeedsLayout];
        self.heightYes.constant += 5;
        self.widthYes.constant += 5;
        self.heightNo.constant += 5;
        self.widthNo.constant += 5;
        
        [UIView animateWithDuration:0.5 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 1.0;
            
        } completion:^(BOOL finished) {}];
        
    } else if (dismiss == YES) {
        
        if (aButton == self.yesButton) {
            
            self.heightYes.constant -= 5;
            self.widthYes.constant -= 5;
            
        } else {
            
            self.heightNo.constant -= 5;
            self.widthNo.constant -= 5;
            
        }
        [self.view setNeedsLayout];

        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 0.0;
            
        } completion:^(BOOL finished) {}];
    }
}

- (IBAction)recordAnswer:(UIButton *)sender {
    
    NSLog(@"questionID:  %@", self.resourcesForQuestion_Parse.objectId);
    NSLog(@"studyID:  %@", self.aStudy_Parse.objectId);
    [self animateAnswerButtons:self.yesButton toDismiss:YES];
    [self animateAnswerButtons:self.noButton toDismiss:YES];

    [self.delegate recordAnswer:sender
                  ForQuestionID:self.resourcesForQuestion_Parse.objectId
                     ForStudyID:self.resourcesForQuestion_Parse.objectId];
}

#pragma mark -
#pragma mark Delegate Methods


#pragma mark -
#pragma mark Child Parent View Controllers Coordination

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"YesNo childVC will leave");
        
    } else {
        NSLog(@"YesNo childVC will arrive");

        
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"YesNo childVC left");
        
    } else {
        NSLog(@"YesNo childVC arrived");



        
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
