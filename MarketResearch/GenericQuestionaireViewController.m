//
//  GenericQuestionaireViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/19/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "GenericQuestionaireViewController.h"

@interface GenericQuestionaireViewController ()

@end

@implementation GenericQuestionaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Unpack Resources from Parse


#pragma mark -
#pragma mark Setup Questions and Buttons for Answers

-(void)setTitle:(NSString *)aTile {
}

-(void)setQuestion:(NSString *)aQuestion {
}

-(void)setButtonsForAnswer {
}


#pragma mark -
#pragma mark Setup Image Geometry and Animation


#pragma mark -
#pragma mark Touches Handling


#pragma mark -
#pragma mark Delegate Methods


#pragma mark -
#pragma mark View Controller Life Cycle

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    if (parent == nil) {
        NSLog(@"childVC will leave");
        
    } else {
        NSLog(@"childVC will arrive");
        
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
