//
//  MultiChoiceStrings.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/24/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "MultiChoiceStrings.h"
#import <Parse/Parse.h>
#import "Question_Parse.h"
#import "CapsuleString.h"
#import "ResourcesForRatingScale.h"

@interface MultiChoiceStrings ()

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *validateAnswerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tcMainQuestion;
@property (weak, nonatomic) IBOutlet UILabel *questionTitle;
@property (weak, nonatomic) IBOutlet UILabel *mainQuestion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightValidate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthValidate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightReset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthReset;

@property (weak, nonatomic) IBOutlet UIView *multiChoicesView;
@property (nonatomic) NSMutableArray *arrayOfCapsuleString;
@property (nonatomic) NSMutableArray *arrayOfItemsSelected;
@property (nonatomic) int maxNumberOfSelection;

@end

@implementation MultiChoiceStrings


#pragma mark -
#pragma mark View Controller Life Cycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
        [self setButtonsForAnswer];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setQuestion:self.resourcesForQuestion_Parse.mainQuestion];

    [self setButtonsForAnswer];

    NSLog(@"view did load");
    self.maxNumberOfSelection = 3;
    self.arrayOfItemsSelected = [NSMutableArray new];

}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.multiChoicesView.layer.borderWidth = 1.0;
//    self.multiChoicesView.layer.borderColor = [UIColor blackColor].CGColor;
    [self getStringsToBeRated_fromParse];

}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    self.view.frame = self.parentViewController.view.bounds;
}


- (void) viewDidLayoutSubviews {
        // resize your layers based on the view's new frame
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

-(void) getStringsToBeRated_fromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ListOfQuestions"];
    [query whereKey:@"objectId" equalTo:self.resourcesForQuestion_Parse.objectId];
    [query includeKey:@"ArrayOfStrings"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
            
            for (Question_Parse *obj in objects) {
                
                NSMutableArray *arrayToSetCapsuleMethod = [NSMutableArray new];
                
                for (int i = 0; i<obj.ArrayOfStrings.count; i++) {
                    
                    ResourcesForRatingScale *aRes = obj.ArrayOfStrings[i];
                    if(aRes.ItemToBeRated != nil) {
                    [arrayToSetCapsuleMethod addObject:aRes.ItemToBeRated];

                    NSLog(@"String:  %@",aRes.ItemToBeRated);
                        
                    }
                }
                [self setCapsuleStrings:arrayToSetCapsuleMethod];
            }
        }
    }];
}



#pragma mark -
#pragma mark Setup Questions and Buttons for Answers

-(void)setTitle:(NSString *)aTile {
}

-(void)setQuestion:(NSString *)aQuestion {
    
    self.mainQuestion.text = aQuestion;
//    self.tcMainQuestion.constant +=100.0;
    self.mainQuestion.alpha = 1.0;
    self.questionTitle.text = self.resourcesForQuestion_Parse.context;
    self.questionTitle.alpha = 0.0;
//    [self animateMainQuestionDisplay];
}


-(void)setButtonsForAnswer {
    
    self.validateAnswerButton.backgroundColor = [UIColor blackColor];
    self.validateAnswerButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.validateAnswerButton.layer.borderWidth = 0.5;
    [self.validateAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.validateAnswerButton.layer.cornerRadius = self.validateAnswerButton.frame.size.width/2;
    self.validateAnswerButton.alpha = 0.0;
    
    self.resetButton.backgroundColor = [UIColor whiteColor];
    self.resetButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.resetButton.layer.borderWidth = 0.5;
    [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.resetButton.layer.cornerRadius = self.resetButton.frame.size.width/2;
    self.resetButton.alpha = 0.0;
}


#pragma mark -
#pragma mark Setup Image Geometry and Animation

-(void) setCapsuleStrings:(NSArray *)anArrayOfStringsFromParse {
    
    self.arrayOfCapsuleString = [NSMutableArray new];
    
    CGFloat cumulatedHeight = 0.0f;
    for (NSString *string in anArrayOfStringsFromParse) {
        
        CapsuleString *aCaspuleString = [[CapsuleString alloc]initWithTextInput:string andReceivingView:self.multiChoicesView];

        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleItemSelection:)];
        [aCaspuleString addGestureRecognizer:singleFingerTap];
        
        [self.arrayOfCapsuleString addObject:aCaspuleString];
        cumulatedHeight +=aCaspuleString.frame.size.height;
    }
    
    if (cumulatedHeight <= self.multiChoicesView.frame.size.height) {
        
        NSLog(@"xxx");
            //good to distribute capsulestrings evenly accross multichoice view
        [self distributeCapsuleStringsEvenlyAccrossMultiChoicesView];

    } else {
        
            //ask CapsuleString class to readjust fontsize
    }
}


-(void) distributeCapsuleStringsEvenlyAccrossMultiChoicesView {
    
    CGFloat inBetweenCapsuleSpace = 5.0;
    CGFloat cumulativeCapsuleHeights = 0.0;
    for (CapsuleString *aCapsule in self.arrayOfCapsuleString) {
        cumulativeCapsuleHeights += aCapsule.frame.size.height;
    }
    
    cumulativeCapsuleHeights += (self.arrayOfCapsuleString.count - 1) * inBetweenCapsuleSpace;
    
    CGFloat differenceInHeights = self.multiChoicesView.frame.size.height - cumulativeCapsuleHeights;
    
    CGFloat upperMargin = 0.0;
    if (differenceInHeights >= 0) {
    
        upperMargin = differenceInHeights /2 ;
    }
    
    
    CGFloat yPosition = 0.0f;
    for (CapsuleString *aCapsule in self.arrayOfCapsuleString) {
        
        if([self.arrayOfCapsuleString indexOfObject: aCapsule] == 0) {
            
            yPosition = upperMargin;
            aCapsule.transform = CGAffineTransformMakeTranslation(0, yPosition);
            yPosition +=aCapsule.frame.size.height;
            [self.multiChoicesView addSubview:aCapsule];
            aCapsule.alpha = 0.0;
            
        } else {
            
            yPosition += 5;
            aCapsule.transform = CGAffineTransformMakeTranslation(0, yPosition);
            yPosition +=aCapsule.frame.size.height;
            [self.multiChoicesView addSubview:aCapsule];
            aCapsule.alpha = 0.0;
            
        }
    }
    [self animateCapsuleStringInitialDisplay];

}

-(void)animateCapsuleStringInitialDisplay {
    
    int n = 1;
    for (CapsuleString *aCapsule in self.arrayOfCapsuleString) {
    
        n +=1;
        
        CGRect tempBound = CGRectOffset(aCapsule.frame, 15.0, 0);
        aCapsule.frame = tempBound;
        [UIView animateWithDuration:0.5
                              delay:0.3*n*0.3 //delay decreases
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             aCapsule.alpha = 1.0;
                             aCapsule.center = CGPointMake(aCapsule.center.x - 15, aCapsule.center.y);
                         } completion:^(BOOL finished) {}];
    }
}

-(void)maintainRoundedCorners {
    
        //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
    self.resetButton.layer.cornerRadius = self.resetButton.frame.size.height/2;
    self.validateAnswerButton.layer.cornerRadius = self.validateAnswerButton.frame.size.height/2;
    self.questionTitle.layer.cornerRadius = 20;
    self.questionTitle.layer.masksToBounds = YES;

    
}

-(void)animateMainQuestionDisplay {
    
//    [self.view setNeedsLayout];
//    self.tcMainQuestion.constant -=100.0;
    
    [UIView animateWithDuration:1.5 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        
//        [self.view layoutIfNeeded];
        self.questionTitle.alpha = 1.0;
        
    } completion:^(BOOL finished) {NSLog(@"i am done");
}];
}

#pragma mark -
#pragma mark Touches Handling


- (void)handleItemSelection:(UITapGestureRecognizer *)recognizer {
    
    //As long as the max number of selection has not been reached, you can select a new item ...
    if (self.arrayOfItemsSelected.count < self.maxNumberOfSelection) {
        
        for (CapsuleString *aCapsuleString in self.arrayOfCapsuleString) {
            if ([recognizer.view isEqual:aCapsuleString]) {
                if (aCapsuleString.isSelected == YES) {
                    [self.arrayOfItemsSelected removeObject:aCapsuleString];
                } else {
                    [self.arrayOfItemsSelected addObject:aCapsuleString];
                }
                [aCapsuleString changeApperanceWhenSelected];
            }
        }
        
    //... if max number of selection has been reached, you can only deselect a previous selection.
    } else {
        
        for (CapsuleString *aCapsuleString in self.arrayOfCapsuleString) {
            if ([recognizer.view isEqual:aCapsuleString]) {
                if (aCapsuleString.isSelected == YES) {
                    [aCapsuleString changeApperanceWhenSelected];
                    [self.arrayOfItemsSelected removeObject:aCapsuleString];
                }
            }
        }
    }
    
    [self checkForValidationCondition];

}


-(void) checkForValidationCondition {
    
    NSLog(@"%lu", (unsigned long)self.arrayOfItemsSelected.count);
    
    if (self.arrayOfItemsSelected.count == self.maxNumberOfSelection) {
        NSLog(@"condition met");
        
        [self animateAnswerButtons:self.validateAnswerButton forConditionMet:YES];
        [self animateAnswerButtons:self.resetButton forConditionMet:YES];
        
        
    } else {
        
        [self animateAnswerButtons:self.validateAnswerButton forConditionMet:NO];
        [self animateAnswerButtons:self.resetButton forConditionMet:NO];
        
    }
}


-(void)animateAnswerButtons:(UIButton *)aButton forConditionMet:(BOOL)conditionMet {
    
    if ((conditionMet == YES) && (aButton.alpha == 0.0)) {
        
        [self.view setNeedsLayout];
        self.heightReset.constant += 5;
        self.widthReset.constant += 5;
        self.heightValidate.constant += 5;
        self.widthValidate.constant += 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 1.0;
            self.questionTitle.alpha = 0.0;
            
        } completion:^(BOOL finished) {}];
        
    } else if ((conditionMet == NO) && (aButton.alpha == 1.0)) {
        
        [self.view setNeedsLayout];
        self.heightReset.constant -= 5;
        self.widthReset.constant -= 5;
        self.heightValidate.constant -= 5;
        self.widthValidate.constant -= 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            aButton.alpha = 0.0;
            self.questionTitle.alpha = 1.0;

            
        } completion:^(BOOL finished) {}];
    }
}


- (IBAction)recordSelection:(UIButton *)validateButton {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (CapsuleString *anyCapsuleString in self.arrayOfItemsSelected) {
        
        [array addObject: anyCapsuleString.stringForSelection];
    }
    
    [self.delegate recordMultiSelection:array forQuestionID:self.resourcesForQuestion_Parse.objectId forStudyID:self.resourcesForQuestion_Parse.objectId];

}


- (IBAction)resetSelection:(UIButton *)resetButton {
    
    for (CapsuleString *aCapsuleString in self.arrayOfCapsuleString) {
            if (aCapsuleString.isSelected == YES) {
                [aCapsuleString changeApperanceWhenSelected];
                [self.arrayOfItemsSelected removeObject:aCapsuleString];
            }
        }
    
    [self checkForValidationCondition];
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
//        [self setQuestion:self.resourcesForQuestion_Parse.mainQuestion];


    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"childVC left");
        
    } else {
        NSLog(@"childVC arrived");
        [self animateMainQuestionDisplay];
        [self setCapsuleStrings:Nil];
//        [self animateCapsuleStringInitialDisplay];

        
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
