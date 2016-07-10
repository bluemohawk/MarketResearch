//
//  OpenEnded.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "OpenEnded.h"

@interface OpenEnded ()

@property (weak, nonatomic) IBOutlet UILabel *aQuestion;

@end

@implementation OpenEnded

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
        //    self.view.backgroundColor = [UIColor redColor];
    
    self.aQuestion.text = self.resourcesForQuestion_Parse.mainQuestion;
    
    NSLog(@"%@",self.aQuestion.text);
    
    
}

#pragma mark
#pragma mark Unpack Resources from Parse

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

