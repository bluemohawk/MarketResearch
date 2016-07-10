//
//  IntroductionViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/20/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Introduction.h"

@interface Introduction ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthButton;

@property (weak, nonatomic) IBOutlet UILabel *studyTitle;
@property (weak, nonatomic) IBOutlet UILabel *studyContext;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation Introduction


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
    
    NSLog(@"Intro viewDidLoad");

}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Intro willAppear");

    
    NSLog(@"Introduction Title:  %@", self.aStudy_Parse.title);
    self.studyTitle.text = self.resourcesForQuestion_Parse.mainQuestion;
    self.studyContext.text = self.resourcesForQuestion_Parse.context;
    
    [self setButtonsForAnswer];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"Intro didAppear");
    [self animateAnswerButtons:self.nextButton toDismiss:NO];


}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
        //Where the parent tells the child that the device is rotating.
    self.view.frame = self.parentViewController.view.bounds;
}


- (void) viewDidLayoutSubviews {
        //Resize your layers and round layer's corner based on the view's new frame. Interesting when animating with auto layout.
    [super viewDidLayoutSubviews];
    [self maintainRoundedCorners];

    
    NSLog(@"Intro viewDidLayoutSubviews");

    
    
}

#pragma mark -
#pragma mark Unpack Resources from Parse


#pragma mark -
#pragma mark Setup Questions and Buttons for Answers

-(void)setTitle:(NSString *)aTilte {
    
//    self.studyTitle.text = aTilte;
}


-(void)setContext: (NSString *)aContext {
    
    self.studyContext.text = aContext;
}


-(void)setButtonsForAnswer {
    
    self.nextButton.backgroundColor = [UIColor blackColor];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width/2;
    self.nextButton.alpha = 0.0;
    

    
    NSLog(@"study title:   %@", self.resourcesForQuestion_Parse.mainQuestion);
    
    if ([self.studyTitle.text isEqualToString:@"Thank You!"]) {
        
        [self.nextButton setTitle: @"Done" forState: UIControlStateNormal];
    
    } else {
        
        [self.nextButton setTitle: @"Next" forState: UIControlStateNormal];
        
    }
    
}


#pragma mark -
#pragma mark Setup Image Geometry and Animation

-(void) maintainRoundedCorners {
    
        //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/2;
    
}



#pragma mark -
#pragma mark Touches Handling


-(void)animateAnswerButtons:(UIButton *)aButton toDismiss:(BOOL)dismiss {
    
    if (dismiss == NO) {
        
        [self.view setNeedsLayout];
        self.heightButton.constant += 10;
        self.widthButton.constant += 10;
        
        [UIView animateWithDuration:0.5 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 1.0;
            
        } completion:^(BOOL finished) {}];
        
    } else if (dismiss == YES) {
        
        self.heightButton.constant -= 5;
        self.widthButton.constant -= 5;
        [self.view setNeedsLayout];
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 0.0;
            
        } completion:^(BOOL finished) {}];
    }
}


#pragma mark -
#pragma mark Delegate Methods

- (IBAction)recordAnswer:(UIButton *)sender {
    

    [self animateAnswerButtons:self.nextButton toDismiss:YES];
    
    if ([self.nextButton.titleLabel.text isEqual: @"Done"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    } else {
        
        [self.delegate nextPage];

    }

}

#pragma mark -
#pragma mark View Controller Life Cycle

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"Intro childVC will leave");
        
    } else {
        NSLog(@"Intro childVC will arrive");
//        
//        NSLog(@"Introduction Title:  %@", self.aStudy_Parse.title);
//        self.studyTitle.text = self.aStudy_Parse.title;
//        self.studyContext.text = self.aStudy_Parse.subtitle;
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"Intro childVC left");
        
    } else {
        NSLog(@"Intro childVC arrived");

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
