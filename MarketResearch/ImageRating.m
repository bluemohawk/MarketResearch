//
//  ImageRating.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 3/9/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ImageRating.h"
#import "ResourcesForRatingScale.h"
#import "CapsuleString.h"


@interface ImageRating ()
@property (nonatomic) UIScrollView *imageScrollView;
@property (nonatomic) UIScrollView *questionScrollView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) NSLayoutConstraint *cBottom_ImageScrollView;
@property (nonatomic) NSLayoutConstraint *cTop_QuestionScrollView;

@property (nonatomic) UIImageView *imageDisplay;
@property (weak, nonatomic) IBOutlet UIView *multiChoicesView;

@property (nonatomic) UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UILabel *mainQuestion;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthNext;

@property (nonatomic) NSMutableArray *arrayOfCapsuleString;
@property (nonatomic) NSMutableArray *arrayOfItemsSelected;
@property (nonatomic) int maxNumberOfSelection;

@end

@implementation ImageRating
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
    [self setButtonsForAnswer];
    [self setScrollViews];
    self.inputView.alpha = 0.0;
    self.mainQuestion.alpha = 0.0;

}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainQuestion.text = self.resourcesForQuestion_Parse.mainQuestion;
    [self setContentForQuestionScrollView: CGSizeMake(self.view.frame.size.width, self.view.bounds.size.height/3)];
    NSLog(@"H: %f, W: %f", self.questionScrollView.bounds.size.height, self.questionScrollView.frame.size.width);

}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animateAnswerButtons:self.nextButton toDismiss:NO];
    

}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
        //Where the parent tells the child that the device is rotating.
    self.view.frame = self.parentViewController.view.bounds;
    [self recenterImage:self.imageScrollView.bounds.size];


}

- (void) viewWillLayoutSubviews {
        //Resize your layers and round layer's corner based on the view's new frame. Interesting when animating with auto layout.
    [super viewWillLayoutSubviews];
    [self maintainRoundedCorners];
    
}

- (void) viewDidLayoutSubviews {
        //Resize your layers and round layer's corner based on the view's new frame. Interesting when animating with auto layout.
    [super viewDidLayoutSubviews];
    [self maintainRoundedCorners];
    [self setImageAtCenter:self.imageScrollView.bounds.size];

    [self recenterImage:self.imageScrollView.bounds.size];
    [self setZoomScale: self.imageScrollView.bounds.size];

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

-(void)setScrollViews {
    
    _imageScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.imageScrollView];
    self.imageScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleImageSelection:)];
    [self.imageScrollView addGestureRecognizer:atap];
    
    if (self.resourcesForQuestion_Parse.tempQuestionNumber == [NSNumber numberWithInt: 3]) {
        NSLog(@"tower");
        _imageDisplay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tower"]];
        
    } else if (self.resourcesForQuestion_Parse.tempQuestionNumber == [NSNumber numberWithInt: 4]) {
        NSLog(@"Name of ..... summer.jpg");

        _imageDisplay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"summer.jpg"]];
        
    }

    self.imageDisplay.contentMode = UIViewContentModeScaleAspectFill ;
    self.imageDisplay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageScrollView addSubview:self.imageDisplay];
    
    _questionScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.questionScrollView];
    self.questionScrollView.pagingEnabled = YES;
    self.questionScrollView.delegate = self;
    self.questionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _pageControl = [[UIPageControl alloc]init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.pageControl];

    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageScrollView, _imageDisplay, _questionScrollView, _pageControl);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageScrollView]|" options:0 metrics:0 views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_questionScrollView]|" options:0 metrics:0 views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pageControl]|" options:0 metrics:0 views:viewDict]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageScrollView]" options:0 metrics:0 views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_questionScrollView][_pageControl]|" options:0 metrics:0 views:viewDict]];
    
     _cBottom_ImageScrollView = [NSLayoutConstraint
                                            constraintWithItem:_imageScrollView
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                            constant:-self.view.bounds.size.height/3];
    
    _cTop_QuestionScrollView = [NSLayoutConstraint
                                            constraintWithItem:_questionScrollView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                            constant:-self.view.bounds.size.height/3];
    
    [self.view addConstraints:@[_cBottom_ImageScrollView, _cTop_QuestionScrollView]];
    
    
    [self.imageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageDisplay]" options:0 metrics:0 views:viewDict]];
    [self.imageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageDisplay]" options:0 metrics:0 views:viewDict]];

}



-(NSMutableArray *)someMethodForString:(NSString *)aString withSize:(CGSize)targetSizeOfScrollView {
        //Words of a string are added as entry into an array.
        //A loop adds one word at the time into a string and measures reulting height of string/label.
        //The loop stops when max height of label is reached. Resulting string is added to an array.
        //A special case handles situation when last word is added while resulting string/label max height is not reached.
    
    
    NSMutableArray *arrayOfWords = [[aString componentsSeparatedByString:@" "] mutableCopy];
    
    NSMutableArray *arrayOfSentences = [NSMutableArray new];
    
    NSMutableString *buildingString = [NSMutableString new];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:30.0];
    CGSize constraint = CGSizeMake(targetSizeOfScrollView.width, CGFLOAT_MAX);
    
    
    for (NSString *newWord in arrayOfWords) {
        
        [buildingString appendString:@"..."];

        CGRect sizeOfTextInput = [buildingString boundingRectWithSize:constraint
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil];


        
        if (sizeOfTextInput.size.height < targetSizeOfScrollView.height*0.7) {
            NSLog(@"constraint: %f vs target:  %f, vs width:  %f", sizeOfTextInput.size.height, targetSizeOfScrollView.height, targetSizeOfScrollView.width);

                //A special case that handles situation when last word is added to string while resulting string/label max height is not reached.
            if (newWord == [arrayOfWords lastObject]) {
        
                [buildingString deleteCharactersInRange: [buildingString rangeOfString: @"..."]];
                [buildingString appendString:newWord];
                NSString *aString = [buildingString copy];
                [arrayOfSentences addObject:aString];
                
            } else {
                
                [buildingString deleteCharactersInRange: [buildingString rangeOfString: @"..."]];
                [buildingString appendString:newWord];
                [buildingString appendString:@" "];
            }
            
        } else {

            NSString *aString = [buildingString copy];
            [arrayOfSentences addObject:aString];
            
            [buildingString setString:@""];
            [buildingString appendString:newWord];
            [buildingString appendString:@" "];
            
        }
    }

    for (id object in arrayOfSentences) {
        NSLog(@"array of sentences:  %@", object);

    }
    
    return arrayOfSentences;
}

-(void)setContentForQuestionScrollView:(CGSize)targetSizeOfScrollView {
  
    NSMutableArray *arrayOfViews = [NSMutableArray new];
    
    NSMutableArray *arrayOfSentences = [self someMethodForString:@"Please look at this image carefully. We will ask you a few questions about what this image means to you?" withSize:targetSizeOfScrollView];
    
    
    for (int i = 0; i<arrayOfSentences.count; i++) {
        UIView *newView = [[UIView alloc]init];
        newView.backgroundColor = [UIColor clearColor];
        newView.translatesAutoresizingMaskIntoConstraints = NO;
        newView.layer.borderWidth = 1.0;
        [self.questionScrollView addSubview:newView];
        [arrayOfViews addObject:newView];
        
        UILabel *aLabel = [[UILabel alloc]init];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.translatesAutoresizingMaskIntoConstraints = NO;
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:28.0];
        aLabel.textColor = [UIColor whiteColor];
        aLabel.numberOfLines = 10;
        aLabel.text = arrayOfSentences [i];
        [newView addSubview:aLabel];
        
        NSDictionary *subDict = NSDictionaryOfVariableBindings(newView, aLabel);
        [newView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[aLabel]|" options:0 metrics:0 views:subDict]];
        [newView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[aLabel]|" options:0 metrics:0 views:subDict]];
        
        NSLog(@"H: %f, W: %f", aLabel.bounds.size.height, aLabel.bounds.size.width);
        
    }
    

    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btn.translatesAutoresizingMaskIntoConstraints = NO;
    self.btn.userInteractionEnabled = YES;
    [_btn addTarget:self action:@selector(bringUpSelection:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
    [self.btn setTitle:@"Next" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

    self.btn.layer.cornerRadius = self.btn.frame.size.height/2;
    self.btn.backgroundColor = [UIColor whiteColor];
    
    [self.questionScrollView addSubview:self.btn];
    
    self.pageControl.numberOfPages = arrayOfViews.count+1;
    self.pageControl.currentPage = 0;
    
    for (UIView *newView in arrayOfViews) {
        
        NSUInteger i = [arrayOfViews indexOfObject:newView];
        
        if (i == 0) {
            
            NSLog(@"first");  //first page only
            NSDictionary *subDict = NSDictionaryOfVariableBindings(newView, _questionScrollView);
            [self.questionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:0 views:subDict]];
            [self.questionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView(==_questionScrollView)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:0 views:subDict]];

        } else if ( (i >0) && (i< arrayOfViews.count -1) ) {
            
            NSLog(@"subsequent");  //all pages except first and last pages
            UIView *leftView = [arrayOfViews objectAtIndex:i-1];
            UIView *newView = [arrayOfViews objectAtIndex:i];
            NSDictionary *subDict = NSDictionaryOfVariableBindings(leftView, newView, _questionScrollView);
            [self.questionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(==_questionScrollView)][newView(==_questionScrollView)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:0 views:subDict]];

        } else  {
            NSLog(@"end"); //last page only
            UIView *leftView = [arrayOfViews objectAtIndex:i-1];
            UIView *newLastView = [arrayOfViews objectAtIndex:i];
            NSDictionary *subDict = NSDictionaryOfVariableBindings(leftView, newLastView, _btn, _questionScrollView);
            [self.questionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(==_questionScrollView)][newLastView(==_questionScrollView)][_btn(==_questionScrollView)]|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:subDict]];
        }
    }
    

}


-(void)setZoomScale: (CGSize)scrollViewSize {
    
    CGSize imageSize = self.imageDisplay.bounds.size;
    
    CGFloat widthScale = scrollViewSize.width / imageSize.width;
    CGFloat heightScale = scrollViewSize.height / imageSize.height;
    NSLog(@"set zoom  %f, %f, %f, %f", scrollViewSize.width, imageSize.width, scrollViewSize.height, imageSize.height);
    CGFloat minScale = MAX(widthScale, heightScale);
    NSLog(@"%f", minScale);

    self.imageScrollView.minimumZoomScale = 0.5;
    self.imageScrollView.zoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 2.0;

}

-(void)setImageAtCenter:(CGSize)scrollViewSize {
    
    CGFloat scrollWidth = CGRectGetWidth(self.imageDisplay.bounds) - scrollViewSize.width ;
    
    CGFloat targetContextOffsetX = scrollWidth/2;
    self.imageScrollView.contentOffset = CGPointMake(targetContextOffsetX,0);
    
    NSLog(@"Offset: %f", targetContextOffsetX);

//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.imageScrollView.contentOffset = CGPointMake(targetContextOffsetX,0);
//    } completion:nil];
    
    
}

-(void)recenterImage:(CGSize)scrollViewSize {
    
    CGSize imageSize = self.imageDisplay.frame.size;
    
    CGFloat horizontalSpace = (imageSize.width < scrollViewSize.width) ? (scrollViewSize.width - imageSize.width)/2 : 0;
    CGFloat verticalSpace = (imageSize.height < scrollViewSize.height) ? (scrollViewSize.height - imageSize.height)/2 : 0;

    self.imageScrollView.contentInset = UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace);

    NSLog(@"Height - Scroll:%f Image:%f", scrollViewSize.height, imageSize.height);
    NSLog(@"Top: %f Botton %f", self.imageScrollView.contentInset.top, self.imageScrollView.contentInset.bottom);

    NSLog(@"Width - Scroll:%f Image:%f", scrollViewSize.width, imageSize.width);
    NSLog(@"Right: %f Left %f", self.imageScrollView.contentInset.right, self.imageScrollView.contentInset.left);

}

- (IBAction)animateZoom:(id)sender {

    [UIView animateWithDuration:10.0
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat minScale = self.imageScrollView.zoomScale;
                         minScale = minScale *2.0;
                         self.imageScrollView.zoomScale = minScale;
                     }
                     completion:nil];

}

-(void)setQuestionScrollView:(UIScrollView *)questionScrollView {
    
//    self.questionScrollView.delegate = self;
}

-(void)setQuestion:(NSString *)aQuestion {
}

-(void)setButtonsForAnswer {
    
    self.nextButton.backgroundColor = [UIColor blackColor];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width/2;
    self.nextButton.alpha = 0.0;
}


#pragma mark -
#pragma mark Setup Image Geometry and Animation


-(void) setCapsuleStrings:(NSArray *)anArrayOfStringsFromParse {
    
    self.arrayOfCapsuleString = [NSMutableArray new];
    self.multiChoicesView.backgroundColor = [UIColor blackColor];
    
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
        NSLog(@"yyy");
        [self distributeCapsuleStringsEvenlyAccrossMultiChoicesView];

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


-(void) maintainRoundedCorners {
    
        //called by viewDidLayoutSubviews in order to keep layer rounded corner when view animating
        self.btn.layer.cornerRadius = self.btn.frame.size.height/2;
    
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
        
//        [self animateAnswerButtons:self.validateAnswerButton forConditionMet:YES];
//        [self animateAnswerButtons:self.resetButton forConditionMet:YES];
        
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            self.multiChoicesView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self recordSelection:Nil];

        }];
        
        
    } else {
        
//        [self animateAnswerButtons:self.validateAnswerButton forConditionMet:NO];
//        [self animateAnswerButtons:self.resetButton forConditionMet:NO];
        
    }
}


-(void)animateAnswerButtons:(UIButton *)aButton toDismiss:(BOOL)dismiss {
    
    if (dismiss == YES) {
        
        [self.view setNeedsLayout];
        self.heightNext.constant += 5;
        self.widthNext.constant += 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];
        
    } else if (dismiss == NO) {
        
        [self.view setNeedsLayout];
        self.heightNext.constant -= 5;
        self.widthNext.constant -= 5;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {}];
    }
}
- (IBAction)nextButton:(UIButton *)sender {
    
    [self animateAnswerButtons:sender toDismiss:NO];
    
}


- (IBAction)recordSelection:(UIButton *)validateButton {
    
        //implement delegate method
        //    e.g., [self.delegate do something];
    NSMutableArray *array = [NSMutableArray new];
    
    for (CapsuleString *anyCapsuleString in self.arrayOfItemsSelected) {
        
        [array addObject: anyCapsuleString.stringForSelection];
    }
    
    [self.delegate recordMultiSelection:array forQuestionID:self.resourcesForQuestion_Parse.objectId forStudyID:self.resourcesForQuestion_Parse.objectId];

    
}


- (void)pageControlTouched:(id)sender {
    
    
    CGFloat scrollWidth = CGRectGetWidth(self.questionScrollView.bounds);
    CGFloat targetContextOffsetX = scrollWidth * self.pageControl.currentPage;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.questionScrollView.contentOffset = CGPointMake(targetContextOffsetX,0);
    } completion:nil];
}


-(void)handleImageSelection:(UITapGestureRecognizer *)aTap {
    
    if (self.questionScrollView.alpha == 1.0 ) {
        
            [self.view setNeedsLayout];
            self.cBottom_ImageScrollView.constant = 0.0;

            [UIView animateWithDuration:0.2 animations:^{
                self.questionScrollView.alpha = 0.0;
                self.pageControl.alpha = 0.0;
            }];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];
            } completion:Nil];
        
        
    } else {
        
            [self.view setNeedsLayout];
            self.cBottom_ImageScrollView.constant = -self.view.frame.size.height/3;
        
            [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.questionScrollView.alpha = 1.0;
                self.pageControl.alpha = 1.0;

            } completion:Nil];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];

            } completion:Nil];
        
    }
    
}

-(void)bringUpSelection:(UIButton *)nextBTN {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.questionScrollView.alpha = 0.0;
        self.pageControl.alpha = 0.0;
        self.inputView.alpha = 1.0;
        self.mainQuestion.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [self.questionScrollView removeFromSuperview];
        [self getStringsToBeRated_fromParse];
        self.arrayOfItemsSelected = [NSMutableArray new];
        self.maxNumberOfSelection = 1;
    }];
    
    
}



#pragma mark -
#pragma mark Delegate Methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    NSLog(@"ZOOM");
    return _imageDisplay;
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                NSLog(@"--------didZoom");
                [self recenterImage:self.imageScrollView.bounds.size];
            } completion:nil];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.questionScrollView) {
        CGFloat scrollWidth = CGRectGetWidth(scrollView.bounds);
        CGFloat pageFraction = scrollView.contentOffset.x / scrollWidth;
        self.pageControl.currentPage = (int)roundf(pageFraction);
    }

}


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
