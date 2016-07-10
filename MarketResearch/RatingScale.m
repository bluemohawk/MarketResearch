//
//  RatingScale.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "RatingScale.h"
#import "CustomCell.h"
#import "ResourcesForRatingScale.h"

@interface RatingScale ()
@property (weak, nonatomic) IBOutlet UITableView *tableItemsRated;

@property (nonatomic) NSMutableArray *arrayOfItemsToBeRated;
@property (nonatomic) NSMutableArray *arrayOfRatedItems;
@property (nonatomic) NSArray *arrayOfRatingLevels;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRatingDisplay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthRatingDisplay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yAxisRatingDisplay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yAxisDisplay;

@property (weak, nonatomic) IBOutlet UILabel *mainQuestion;
@property (weak, nonatomic) IBOutlet UILabel *subQuestion;
@property (weak, nonatomic) IBOutlet UILabel *itemToBeRated;
@property (weak, nonatomic) IBOutlet UIView *ratingDisplay;
@property (weak, nonatomic) IBOutlet UILabel *display;


@property (weak, nonatomic) IBOutlet UISlider *ratingScale;

@end

@implementation RatingScale

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
    self.arrayOfRatedItems = [[NSMutableArray alloc]init];
    self.arrayOfItemsToBeRated = [[NSMutableArray alloc]init];
    
    [self getStringsToBeRated_fromParse];
    [self setQuestion:self.resourcesForQuestion_Parse.mainQuestion];

    self.tableItemsRated.estimatedRowHeight = 30.0;

}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.arrayOfRatingLevels = @[@"Strongly disagree", @"Disagree", @"Neither agree nor disagree", @"Agree", @"Strongly agree"];
    [self.ratingScale addTarget:self action:@selector(dragStartedForSlider:) forControlEvents:UIControlEventTouchDown];
    [self.ratingScale addTarget:self action:@selector(dragEndedForSlider:) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void) getStringsToBeRated_fromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ListOfQuestions"];
    [query whereKey:@"objectId" equalTo:self.resourcesForQuestion_Parse.objectId];
    [query includeKey:@"ArrayOfStrings"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
            
            for (Question_Parse *obj in objects) {
                
                for (int i = 0; i<obj.ArrayOfStrings.count-3; i++) {
                    
                    ResourcesForRatingScale *aRes = obj.ArrayOfStrings[i];
                    if(aRes.ItemToBeRated != nil) {
                        [self.arrayOfItemsToBeRated addObject:aRes.ItemToBeRated];
                        
                        NSLog(@"String:  %@",aRes.ItemToBeRated);
                        
                    }
                }
                [self setTextInItemToBeRatedLabel:[self.arrayOfItemsToBeRated firstObject]];
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
}



-(void)setButtonsForAnswer {
    
    self.display.text = @"Neither agree nor disagree";
    self.display.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *aTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlingValidation:)];
    aTap.minimumPressDuration = 0.0;
    [self.display addGestureRecognizer:aTap];

}


#pragma mark - Table view

-(void) methodThatPutAnswerInTable {
    
    NSLog(@"%lu", (unsigned long)self.arrayOfRatedItems.count);
    
    [self.tableItemsRated beginUpdates];
    [self.arrayOfRatedItems addObject:self.itemToBeRated.text];
    
    [self.tableItemsRated insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.arrayOfRatedItems.count -1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    NSLog(@"index:  %lu", (unsigned long)[self.arrayOfRatedItems indexOfObject:[self.arrayOfRatedItems lastObject]]);
    
    [self.tableItemsRated endUpdates];
    
    [self.tableItemsRated scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrayOfRatedItems.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        // Return the number of rows in the section.
    
    NSLog(@"????%lu", (unsigned long)self.arrayOfRatedItems.count);
    return self.arrayOfRatedItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableItemsRated registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    NSLog(@"table");
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    cell.itemLabel.text = self.arrayOfRatedItems[indexPath.row];
    cell.ratingLabel.text = self.display.text;
    
        //(CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
////    Study_Parse *aStudy_Parse = [self.listOfStudies objectAtIndex:indexPath.row];
//    cell.ratingLabel.text = @"Once A Week";
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:20.0];
//    
//    CGSize constraint = CGSizeMake(self.tableItemsRated.bounds.size.width, MAXFLOAT);
//    
//    CGRect sizeOfTextInput = [aString boundingRectWithSize:constraint
//                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                attributes:@{NSFontAttributeName:font}
//                                                   context:nil];
//    
//    CGFloat aFloat = 0.0;
//    
//    return sizeOfTextInput.size.height;
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Setup Image Geometry and Animation

-(void)maintainRoundedCorners {
    
    //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
    self.ratingDisplay.layer.cornerRadius = self.ratingDisplay.frame.size.height/2;
}


-(void) nextItemToBeRated {
    
    NSInteger i = [self.arrayOfItemsToBeRated indexOfObject:self.itemToBeRated.text];
    i +=1;
    if (i < self.arrayOfItemsToBeRated.count) {
        
        self.itemToBeRated.text = self.arrayOfItemsToBeRated[i];
    } else {
        
        self.display.userInteractionEnabled = NO;
    }
}


-(void) setTextInItemToBeRatedLabel:(NSString *)itemFromArrayOfItemsToBerated {
    
    self.itemToBeRated.text = itemFromArrayOfItemsToBerated;
    
    NSLog(@"string:    %@", itemFromArrayOfItemsToBerated);
}


-(void)animateCapsuleStringInitialDisplay {
    
}




#pragma mark -
#pragma mark Touches Handling


- (IBAction)handlingSlider:(UISlider *)slider {
    
    NSString *aString = [self.arrayOfRatingLevels objectAtIndex:(int)(slider.value * 4)];
    
    if(![self.display.text isEqualToString:aString]) {

        [UIView transitionWithView:self.display duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
        self.display.text = [NSString stringWithFormat:@"%@", aString];
        } completion:^(BOOL finished) {}];
        
        [self.view setNeedsLayout];
        self.heightRatingDisplay.constant += 5;
        self.widthRatingDisplay.constant += 5;
        
        
        [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self.view setNeedsLayout];
            self.heightRatingDisplay.constant -= 5;
            self.widthRatingDisplay.constant -= 5;
            
            
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {}];

        NSLog(@"%@", self.display.text);
        }];
    
    [self.display setNeedsLayout];
    }
}

-(void)dragStartedForSlider:(UISlider *)slider {
//    
//    [self.view setNeedsLayout];
//    self.heightRatingDisplay.constant += 10;
//    self.widthRatingDisplay.constant += 10;
    
    
//    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//        
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {}];
    
}

-(void)dragEndedForSlider:(UISlider *)slider {
    
//    [self.view setNeedsLayout];
//    self.heightRatingDisplay.constant -= 10;
//    self.widthRatingDisplay.constant -= 10;

    
//    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//        
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {}];
}

-(void)handlingValidation:(UITapGestureRecognizer *)recognizer {
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.view setNeedsLayout];
        self.heightRatingDisplay.constant += 10;
        self.widthRatingDisplay.constant += 10;
        
        
        [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self.view setNeedsLayout];
        self.heightRatingDisplay.constant -= 10;
        self.widthRatingDisplay.constant -= 10;
        
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];

        [self methodThatPutAnswerInTable];
        [self nextItemToBeRated];
        [self checkForValidationCondition];
    }
}


- (void)handleItemSelection:(UITapGestureRecognizer *)recognizer {
    
}


-(void) checkForValidationCondition {
    
    NSLog(@"completed: %lu, target: %lu",(unsigned long)self.arrayOfRatedItems.count,  (unsigned long)self.arrayOfItemsToBeRated.count );
    
    if(self.arrayOfRatedItems.count == self.arrayOfItemsToBeRated.count) {
        NSLog(@"Condition met");
        
        
        [self recordSelection:nil];
        
    } else {
        
    }

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
    NSMutableArray *array = [NSMutableArray new];
    
    [self.delegate recordMultiSelection:array forQuestionID:self.resourcesForQuestion_Parse.objectId forStudyID:self.resourcesForQuestion_Parse.objectId];
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
