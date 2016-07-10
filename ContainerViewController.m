//
//  ContainerViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ContainerViewController.h"
#import <Parse/Parse.h>
#import "Study_Parse.h"
#import "Question_Parse.h"
#import "ResourcesForRatingScale.h"
#import "OpenEnded.h"
#import "Introduction.h"
#import "RatingScale.h"
#import "ImageRating.h"



@interface ContainerViewController ()

@property (nonatomic) UIViewController *currentController;
@property (nonatomic) Question_Parse *currentQuestion_Parse;

@property (nonatomic) NSArray *sortedArrayOfQuestions;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnPageUp:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnPageDown:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeUp];
    
    
    self.sortedArrayOfQuestions = [NSArray new];

    self.sortedArrayOfQuestions = [self.selectedStudy_Parse.ArrayOfQuestionnaires sortedArrayUsingComparator:^NSComparisonResult(Question_Parse *q1, Question_Parse *q2){
        
        return [q1.tempQuestionNumber compare:q2.tempQuestionNumber];
        
    }];
    
    
    NSLog(@"Number Questions:  %lu", (unsigned long)self.sortedArrayOfQuestions.count);

    
    self.currentQuestion_Parse = self.sortedArrayOfQuestions[0];//self.selectedStudy_Parse.ArrayOfQuestionnaires[0];

    GenericQuestionaireViewController *viewController = [[NSClassFromString(self.currentQuestion_Parse.questionType)  alloc] initWithNibName:nil bundle:Nil] ;

    viewController.delegate = self;
    viewController.view.frame = self.view.frame;
    viewController.aStudy_Parse = self.selectedStudy_Parse;
    viewController.resourcesForQuestion_Parse = self.currentQuestion_Parse;
    NSLog(@"Main Question:  %@", self.selectedStudy_Parse.title);

    [self addChildViewController:viewController];//method calls "willMoveToParentViewController:self" on child VC

    self.currentController = viewController;
    [self.view insertSubview:self.currentController.view atIndex:0];
    [self.currentController didMoveToParentViewController:self];
    
    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController setToolbarHidden:YES animated:YES];
    

}


- (void)changeVC:(UIViewController *)viewController {
    
    [self.currentController willMoveToParentViewController:nil];
    viewController.view.frame = self.view.frame;
    [self addChildViewController:viewController];
    
    [self transitionFromViewController:self.currentController
                      toViewController:viewController
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                            } completion:^(BOOL finished) {
                                [self.currentController removeFromParentViewController];
                                self.currentController = viewController;
                                [self.view insertSubview:self.currentController.view atIndex:0];
                                [viewController didMoveToParentViewController:self];
                            }];
}


- (void)turnPageUp:(UIViewController *)viewController {
    
    NSInteger indexOfQuestion = 0;
    
    //  Return from NSARRAY the index of current Question Parse object
    indexOfQuestion = [self.sortedArrayOfQuestions indexOfObject: self.currentQuestion_Parse];
//      NSLog(@"initial page: %li", (long)indexOfQuestion);
//    NSLog(@"count page: %li", (long)self.selectedStudy_Parse.arrayOfQuestions.count);

    //  Increase index by one
    if (indexOfQuestion == self.sortedArrayOfQuestions.count - 1) {
        
        NSLog(@"Page + 1: %@", @"max page");
        
    } else {
        
        indexOfQuestion = MIN(indexOfQuestion+1, [self.sortedArrayOfQuestions count]-1);
            //        NSLog(@"Page + 1: %i", indexOfQuestion);
        
        //  Return from NSARRAY the next Question Parse object and update self.currentQuestionPage
        self.currentQuestion_Parse = [self.sortedArrayOfQuestions objectAtIndex:indexOfQuestion];
        
        
            //initiate new view controller based on the next Question Parse object
        GenericQuestionaireViewController *nextViewController = [[NSClassFromString(self.currentQuestion_Parse.questionType) alloc] initWithNibName:nil bundle:Nil] ;
        
        nextViewController.delegate = self;

        nextViewController.resourcesForQuestion_Parse = self.currentQuestion_Parse;
        NSLog(@"New page name: %@", self.currentQuestion_Parse.mainQuestion);


            //commit to "transition from to view controllers" based on the two variables "current" and "next" view controllers
        [self changeVC:nextViewController];
    }
}

- (void)turnPageDown:(UIViewController *)viewController {
    
    NSInteger indexOfQuestion = 0;
    
        //  Return from NSARRAY the index of current Question Parse object
    indexOfQuestion = [self.sortedArrayOfQuestions indexOfObject: self.currentQuestion_Parse];
        //  NSLog(@"initial page: %i", indexOfQuestion);
    
        //Decrease index number by one
    if (indexOfQuestion == 0) {
        indexOfQuestion = indexOfQuestion;
        NSLog(@"Page - 1: %@", @"min page");
    } else {
        indexOfQuestion = indexOfQuestion - 1;
        //NSLogk(@"Page - 1: %i", indexOfQuestion);
        
            //  Return from NSARRAY the next Question Parse object and update self.currentQuestionPage
        self.currentQuestion_Parse = [self.sortedArrayOfQuestions objectAtIndex:indexOfQuestion];
        NSLog(@"New page name: %@", self.currentQuestion_Parse.mainQuestion);
        
            //initiate new view controller based on the next Question Parse object
        GenericQuestionaireViewController *nextViewController = [[NSClassFromString(self.currentQuestion_Parse.questionType) alloc] initWithNibName:nil bundle:Nil] ;
        nextViewController.delegate = self;
        nextViewController.resourcesForQuestion_Parse = self.currentQuestion_Parse;
        NSLog(@"New page name: %@", self.currentQuestion_Parse.mainQuestion);

        
            //commit to "transition from to view controllers" based on the two variables "current" and "next" view controllers
        [self changeVC:nextViewController];
    }
}

#pragma mark -
#pragma mark Delegate Methods

-(void)nextPage {
    
    NSLog(@"delegate speaking");
    [self turnPageUp:nil];
    
}

- (void)recordAnswer:(UIButton *)sender ForQuestionID:(NSString *)parseQuestionID ForStudyID:(NSString *)parseStudyID {
    
    NSLog(@"delegate speaking: %@" , parseQuestionID);
    
    PFObject *answer = [PFObject objectWithClassName:@"AnswersForStudy"];
    
    
    
    answer[@"QuestionID"] = [PFObject objectWithoutDataWithClassName:@"ListOfQuestions" objectId:parseQuestionID];
    answer[@"Value"] = sender.titleLabel.text;
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
                // The object has been saved.
        } else {
                // There was a problem, check error.description
        }
    }];
    [self turnPageUp:nil];

    
}

-(void)recordMultiSelection:(NSArray *)arrayOfSelectedItems forQuestionID:(NSString *)parseQuestionID forStudyID:(NSString *)parseStudyId {
 
    PFObject *answer = [PFObject objectWithClassName:@"AnswersForStudy"];
    
    
    
    answer[@"QuestionID"] = [PFObject objectWithoutDataWithClassName:@"ListOfQuestions" objectId:parseQuestionID];
    answer[@"ArrayOfValues"] = arrayOfSelectedItems;
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
                // The object has been saved.
        } else {
                // There was a problem, check error.description
        }
    }];
    [self turnPageUp:nil];

    
}

#pragma mark
#pragma mark Unpack Resources from Parse

-(NSMutableArray *) methodToGetAnArrayOfQuestions_ParseObjects {
    
    NSMutableArray *arrayOfQuestion_ParseObjects = [NSMutableArray new];

    
    PFQuery *query = [PFQuery queryWithClassName:@"ListOfStudies"];
    [query whereKey:@"objectId" equalTo:self.selectedStudy_Parse.objectId];
    [query includeKey:@"ArrayOfQuestionnaires"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {

            NSLog(@"Error: %@ %@", error, [error userInfo]);

        } else {

            for (Study_Parse *obj in objects) {


                for (int i = 0; i<obj.ArrayOfQuestionnaires.count; i++) {

                    Question_Parse *aQuestion = obj.ArrayOfQuestionnaires[i];
                    if(aQuestion.questionType != nil) {
                        [arrayOfQuestion_ParseObjects addObject:aQuestion];

                        NSLog(@"String:  %@",aQuestion.questionType);
                        
                    }
                }
                NSArray *sortedArray = [arrayOfQuestion_ParseObjects sortedArrayUsingComparator:^NSComparisonResult(Question_Parse *q1, Question_Parse *q2){
                    
                    return [q1.tempQuestionNumber compare:q2.tempQuestionNumber];
                    
                }];
                
                NSLog(@"XXX%@", sortedArray);
                NSLog(@"ccc%lu", (unsigned long)sortedArray.count);


            }
        }
    }];
    
    NSLog(@"bbb%lu", (unsigned long)arrayOfQuestion_ParseObjects.count);
    return arrayOfQuestion_ParseObjects;
}


-(NSMutableDictionary *) methodToGetADictionnary_withAllStringResources_forEachQuestion_InaSelectedStudy:(Study_Parse *)aStudyParse  {
    
    NSMutableDictionary *dictOfStrings = [NSMutableDictionary new];

    for (Question_Parse *eachQuestion_Parse in aStudyParse.ArrayOfQuestionnaires) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"ListOfQuestions"];
        [query whereKey:@"objectId" equalTo:eachQuestion_Parse.objectId];
        [query includeKey:@"ArrayOfStrings"];
        [query includeKey:@"ArrayOfImages"];


        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            } else {
                
                for (Question_Parse *aQuestion in objects) {
                    
//                    [dictOfStrings setObject:aQuestion.ArrayOfStrings forKey:eachQuestion_Parse.objectId];
                }
            }
        }];
    }

    return dictOfStrings;
}


-(NSMutableDictionary *) methodToGetADictionnary_with_All_Image_Resources_forEachQuestion_InaSelectedStudy:(Study_Parse *)aStudyParse  {
    
    NSMutableDictionary *dictOfImages = [NSMutableDictionary new];
    
    for (Question_Parse *eachQuestion_Parse in aStudyParse.ArrayOfQuestionnaires) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"ListOfQuestions"];
        [query whereKey:@"objectId" equalTo:eachQuestion_Parse.objectId];
        [query includeKey:@"ArrayOfImages"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            } else {
                
                for (Question_Parse *aQuestion in objects) {
                    
                    [dictOfImages setObject:aQuestion.ArrayOfImages forKey:eachQuestion_Parse.objectId];
                }
            }
        }];
    }
    
    return dictOfImages;
}

#pragma mark -
#pragma mark View Controller Life Cycle

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
