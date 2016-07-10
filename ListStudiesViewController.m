//
//  ListStudiesViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/12/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ListStudiesViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Study_Parse.h"

#import "ViewController.h"
#import "ContainerViewController.h"
#import "CellForSudyList.h"

@interface ListStudiesViewController ()

@property (nonatomic) NSArray *listOfStudies;


@property (nonatomic) NSMutableArray *arrayOfStudies;
@property (nonatomic) NSMutableArray *arrayOfQuestionaires;
@property (nonatomic) NSMutableArray *arrayOfImages;

@property (nonatomic) NSNumber *numberOfNewStudy;
@property (nonatomic) NSNumber *numberOfQuestionnaire;




@end

@implementation ListStudiesViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        self.parseClassName = @"ListOfStudies";
        self.textKey = @"subtitle";
        self.pullToRefreshEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(prepareForInsertingNewStudyInPare:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self downloadListOfStudiesFromParse];
    
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.tableView reloadData];

}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
        //Where the parent tells the child that the device is rotating.
    self.view.frame = self.parentViewController.view.bounds;
}


- (void) viewDidLayoutSubviews {
        //Resize your layers and round layer's corner based on the view's new frame. Interesting when animating with auto layout.
    [super viewDidLayoutSubviews];
    
    
}

    //- (void)updateViewConstraints
    //{
    //    [super updateViewConstraints];
    //        // do calculations if needed, like set constants
    //
    //}

-(void)downloadListOfStudiesFromParse {
    
    PFQuery *query = [Study_Parse query];
    [query includeKey:@"ArrayOfQuestionnaires"];
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
            if (error) {
    
                NSLog(@"Error: %@ %@", error, [error userInfo]);
    
            } else {
    
                self.listOfStudies = [NSArray arrayWithArray:objects];
    
            }
        }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForInsertingNewStudyInPare:(id)sender {

//    PFQuery *existingStudiesInParse = [PFQuery queryWithClassName:@"ListOfStudies"];
//    [existingStudiesInParse findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//
//        Study_Parse *lastStudyAdded = [objects lastObject];
//        self.numberOfNewStudy = @(lastStudyAdded.StudyNumber.intValue + 1);
//        [self insertNewStudyAfterLastStudyInParse: lastStudyAdded.StudyNumber];
//
//    }];
    
}
-(void)insertNewStudyAfterLastStudyInParse:(NSNumber *)numberOfLastStudy_inParse {
    
    self.arrayOfStudies = [NSMutableArray new];
    
    Study_Parse *aStudy = [Study_Parse objectWithClassName:@"ListOfStudies"];
    [aStudy setObject:self.numberOfNewStudy  forKey:@"StudyNumber"];
   
    [self.arrayOfStudies addObject:aStudy];
   
    [aStudy saveInBackground];
    
    [self insertNewQuestionaireOfType:aStudy];
}



-(void)insertNewQuestionaireOfType:(Study_Parse *)aNewStudy_Parse  {

    
    self.arrayOfQuestionaires = [NSMutableArray new];
    for (int numberOfQuestionaires = 1; numberOfQuestionaires < 11; numberOfQuestionaires+=1) {
        
        PFObject *aQuestionaireOfType = [PFObject objectWithClassName:@"ListOfQuestions"];
        [aQuestionaireOfType setObject:self.numberOfNewStudy forKey:@"StudyNumber"];
        [aQuestionaireOfType setObject:@(numberOfQuestionaires) forKey:@"QuestionnaireNumber"];
        
        [self.arrayOfQuestionaires addObject:aQuestionaireOfType];
        
        [aQuestionaireOfType saveInBackground];
    }
    [aNewStudy_Parse setObject:self.arrayOfQuestionaires forKey:@"ArrayOfQuestionnaires"];
    [aNewStudy_Parse saveInBackground];
    
    [self insertImageResources:self.arrayOfQuestionaires];
    [self insertStringResources:self.arrayOfQuestionaires];
}






-(void)insertImageResources:(NSMutableArray *)arrayOfQuestionnairesOfType {
    
    int numberOfQuestionaire = 0;
    
    for (PFObject *eachQuestionnaireOfType in self.arrayOfQuestionaires) {
        
        numberOfQuestionaire +=1;

        NSMutableArray *arrayOfImages = [NSMutableArray new];
        for (int numberOfImage = 1; numberOfImage < 6; numberOfImage += 1) {
           
            PFObject *anImage = [PFObject objectWithClassName:@"Resources"];
            [anImage setObject:self.numberOfNewStudy  forKey:@"StudyNumber"];
            [anImage setObject:@(numberOfQuestionaire) forKey:@"QuestionnaireNumber"];
            [anImage setObject:@(numberOfImage) forKey:@"ImageNumber"];
            
            [arrayOfImages addObject:anImage];
            [anImage saveInBackground];
        }
        [eachQuestionnaireOfType setObject:arrayOfImages forKey:@"ArrayOfImages"];
        [eachQuestionnaireOfType saveInBackground];
    }
}


-(void)insertStringResources:(NSMutableArray *)arrayOfQuestionnairesOfType {
    

    int numberOfQuestionaire = 0;
    
    for (PFObject *eachQuestionnaireOfType in self.arrayOfQuestionaires) {
        
        numberOfQuestionaire +=1;
        
        NSMutableArray *arrayOfSrings = [NSMutableArray new];
        for (int numberOfString = 1; numberOfString < 11; numberOfString += 1) {
            
            PFObject *aString = [PFObject objectWithClassName:@"ResourcesForRatingScale"];
            [aString setObject:self.numberOfNewStudy  forKey:@"StudyNumber"];
            [aString setObject:@(numberOfQuestionaire) forKey:@"QuestionnaireNumber"];
            [aString setObject:@(numberOfString) forKey:@"StringNumber"];
            
            [arrayOfSrings addObject:aString];
            [aString saveInBackground];
        }
        [eachQuestionnaireOfType setObject:arrayOfSrings forKey:@"ArrayOfStrings"];
        [eachQuestionnaireOfType saveInBackground];
    }
}

    
    
//    PFObject *anImage1 = [PFObject objectWithClassName:@"Resources"];
//    [anImage1 setObject:[self.listOfStudies objectAtIndex:0] forKey:@"StudyID"];
//    PFObject *anImage2 = [PFObject objectWithClassName:@"Resources"];
//    PFObject *anImage3 = [PFObject objectWithClassName:@"Resources"];
//
//    NSArray *array = @[anImage1, anImage2, anImage3];
//    
//    PFObject *aQuestion = [PFObject objectWithClassName:@"QuestionType_YESNO"];
//    [aQuestion setObject:[self.listOfStudies objectAtIndex:0] forKey:@"StudyID"];
//    [aQuestion setObject:array forKey:@"ArrayOfResources"];
//    
//    [aQuestion saveInBackground];

    
//    PFObject *answer = [PFObject objectWithClassName:@"AnswersForStudy"];
//    [answer setObject:[self.listOfStudies objectAtIndex:0] forKey:@"StudyID"];
//    answer[@"score"] = @1337;
//    answer[@"FileName"] =
//    [answer saveInBackground];

    
//        // set up our query for a User object
//    PFQuery *questionQuery = [PFQuery queryWithClassName:@"QuestionType_YESNO"];
////    [questionQuery whereKey:@"objectID" equalTo:@"sqvePEMdEE"];
//        // configure any constraints on your query...
//        // for example, you may want users who are also playing with or against you
//    
//        // tell the query to fetch all of the Weapon objects along with the user
//        // get the "many" at the same time that you're getting the "one"
//    [questionQuery includeKey:@"ArrayOfResources"];
//    
//        // execute the query
//    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            // objects contains all of the User objects, and their associated Weapon objects, too
//        NSLog(@"%lu", (unsigned long)objects.count);
//       
//        for (PFObject *object in objects) {
//            
//            NSArray *array = [object objectForKey:@"ArrayOfResources"];
//            NSLog(@"%@", array);
//        }
//
//    }];
//    
//    
//}

#pragma mark - Table view data source

-(PFQuery *) queryForTable {
    
    PFQuery *query = [Study_Parse query];
    return query;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

    static NSString *cellIdentifier = @"Cell";
    CellForSudyList *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CellForSudyList *cellForStudyList = (CellForSudyList*)cell;

    
    cellForStudyList.studyTitle.text = object[@"title"];
    cellForStudyList.studyContext.text = [NSString stringWithFormat:@"%@",object[@"subtitle"]];
    
    PFFile *thumbnail = object[@"StudyPicture"];
//    cellForStudyList.thumbnail.image = [UIImage imageNamed:@"summer.png"];
    cellForStudyList.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    cellForStudyList.thumbnail.file = thumbnail;
    [cellForStudyList.thumbnail loadInBackground];
    NSLog(@"%@", thumbnail.description);
    
    return cell;

}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    Study_Parse *aStudy_Parse = [self.listOfStudies objectAtIndex:indexPath.row];
//    cell.textLabel.text = aStudy_Parse.title;
//    cell.detailTextLabel.text = aStudy_Parse.subtitle;
//    
//    NSLog(@"%@", aStudy_Parse.subtitle );
//    
//    return cell;
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Passing selectedStudy PFObject as resource
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Study_Parse *selectedStudy = [self.listOfStudies objectAtIndex:path.row];
    
    
    ContainerViewController *studyToBeFielded = segue.destinationViewController;
    studyToBeFielded.selectedStudy_Parse = selectedStudy;
    studyToBeFielded.hidesBottomBarWhenPushed = YES;
    
}


@end
