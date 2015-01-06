//
//  ViewController.m
//  L31-32_tableViewEditing
//
//  Created by Artsiom Dolia on 1/4/15.
//  Copyright (c) 2015 Artsiom Dolia. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Group.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groups;

@end


@implementation ViewController

-(void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Studs" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonAction:)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Group" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.leftBarButtonItem = addButton;
    
    CGRect tableViewFrame = self.view.bounds;
    
    tableViewFrame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //tableView.editing = NO;
    
    tableView.allowsSelectionDuringEditing = YES;
    
    self.tableView = tableView;
    
    self.groups = [NSMutableArray array];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger minGroups = 1;
    NSInteger minStudents = 3;
    
    for (int i = 0; i < (minGroups); i++){
        
        [self.groups addObject:[self createGroupWithNumberOfStudents:(minStudents)
                                      andName:[NSString stringWithFormat:@"Group %d", i]]];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Group *group = [self.groups objectAtIndex:indexPath.section];
        Student *student = [group.students objectAtIndex:indexPath.row - 1];
        
        NSMutableArray *tmpStudents = [NSMutableArray arrayWithArray:group.students];
        [tmpStudents removeObject:student];
        group.students = tmpStudents;
        
        //[self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        if([group.students count] < 1){
            
            [self  removeGroupAtIndexPath:indexPath];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.groups count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Group *group = [self.groups objectAtIndex:section];
    return [group.students count] + 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    Group *group = [self.groups objectAtIndex:section];
    return group.groupName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
         static NSString *identifierAddStudent = @"AddStudent";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierAddStudent];
        
        if(!cell){
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierAddStudent];
        }
        
        cell.textLabel.text = @"Tap to Add Student";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor grayColor];
        
        return  cell;

    }else{
        
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if(!cell){
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        Group *group = [self.groups objectAtIndex:indexPath.section];
        Student *student = [group.students objectAtIndex:indexPath.row -1];
        cell.textLabel.text = student.studentName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",student.averageGrade];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    Group *sourceGroup = [self.groups objectAtIndex:sourceIndexPath.section];
    
    NSMutableArray *tmpSourceArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    Student *sourceStudent = [tmpSourceArray objectAtIndex:[self indexForObjectAtIndexPath:sourceIndexPath]];
    
    if(sourceIndexPath.section == destinationIndexPath.section){
        
        [tmpSourceArray removeObject:sourceStudent];
        [tmpSourceArray insertObject:sourceStudent atIndex:destinationIndexPath.row-1];
        
        /*
        if (sourceIndexPath.row < destinationIndexPath.row) {
            
            [tmpSourceArray insertObject:sourceStudent atIndex:destinationIndexPath.row];
            [tmpSourceArray removeObjectAtIndex:sourceIndexPath.row-1];

        }else{
            [tmpSourceArray insertObject:sourceStudent atIndex:destinationIndexPath.row -1];
            [tmpSourceArray removeObjectAtIndex:sourceIndexPath.row];
        }
         */
        sourceGroup.students = tmpSourceArray;
        
    }else{
        
        Group *destinationGroup = [self.groups objectAtIndex:destinationIndexPath.section];
        NSMutableArray *tmpDestArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        
        
        [tmpDestArray insertObject:sourceStudent atIndex:[self indexForObjectAtIndexPath:destinationIndexPath]];
        [tmpSourceArray removeObject:sourceStudent];
        
        sourceGroup.students = tmpSourceArray;
        destinationGroup.students = tmpDestArray;
        
        if ([sourceGroup.students count] < 1) {
            [self removeGroupAtIndexPath:sourceIndexPath];
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Remove";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        Group *group = [self.groups objectAtIndex:indexPath.section];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:group.students];
        
        NSInteger newStudentIndex = 0;
        
        [tmpArray insertObject:[[Student alloc] init] atIndex:indexPath.row];

        group.students = tmpArray;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex +1 inSection:indexPath.section];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];

    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (proposedDestinationIndexPath.row == 0){
        
        return sourceIndexPath;
    }else{
        
        return proposedDestinationIndexPath;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}


#pragma mark - Private methods

-(NSUInteger) indexForObjectAtIndexPath:(NSIndexPath *) indexPath{
    
    return indexPath.row - 1;
}

-(Group *) createGroupWithNumberOfStudents:(NSUInteger) numOfStudents andName:(NSString *)groupName {
    
    Group *group = [[Group alloc] init];
    group.groupName = groupName;
    
    NSMutableArray *students = [NSMutableArray array];
    
    for(int i = 0; i < numOfStudents; i++){
        Student *student = [[Student alloc] init];
        [students addObject:student];
    }
    
    group.students = students;
    
    return group;
}

-(void) removeGroupAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexSet *sectionIndexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    
    [self.groups removeObjectAtIndex:indexPath.section];
    
    [self.tableView beginUpdates];
    [self.tableView deleteSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}


#pragma mark - Buttons Actions

-(void) editButtonAction:(UIBarButtonItem*) sender{
    
    UIBarButtonItemStyle style = UIBarButtonItemStylePlain;
    NSString *title = @"Edit Studs";
    
    if(!self.tableView.editing){
        
        [self.tableView setEditing:YES animated:YES];
        style = UIBarButtonItemStylePlain;
        title = @"Done Editing";
        
    }else{
        
        [self.tableView setEditing:NO animated:YES];
    }
    
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:title style:style target:self action:@selector(editButtonAction:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

-(void) addButtonAction:(UIBarButtonItem*) sender{
     
    Group *groupToInsert = [self createGroupWithNumberOfStudents:1 andName:[NSString stringWithFormat:@"Group %lu", (unsigned long)[self.groups count]]];
    
    [self.groups insertObject:groupToInsert atIndex:0];
    
    //[self.tableView reloadData];
    
    NSIndexSet *groupIndexSet = [[NSIndexSet alloc] initWithIndex:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertSections:groupIndexSet withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}


@end
