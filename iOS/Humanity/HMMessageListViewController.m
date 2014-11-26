//
//  HMMessageListViewController.m
//  Humanity
//
//  Created by Derek Omuro on 11/11/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "HMMessageListViewController.h"
#import "HMAppDelegate.h"
#import "HMReadStoryContainerWindow.h"
#import "HMProfileCard.h"

#import "DemoMessagesViewController.h"
#import "ZKMerchantCell.h"

//@interface HMMessageCell : UITableViewCell
//@property (strong, nonatomic) UIImageView *avatarImage;
//@end
//
//@implementation HMMessageCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}
//
//@end


@interface HMMessageListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) HMReadStoryContainerWindow *storyWindow;

@end

@implementation HMMessageListViewController {
    NSArray *imageViews;
}

- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect imageRect = CGRectMake(15, 10, 50, 50);
    UIImageView *anni = [[UIImageView alloc] initWithFrame:imageRect];
    [anni setClipsToBounds:YES];
    [anni.layer setCornerRadius:25];
    [anni setImage:[UIImage imageNamed:@"ballerina.JPG"]];
    [anni setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView *tim = [[UIImageView alloc] initWithFrame:imageRect];
    [tim setClipsToBounds:YES];
    [tim.layer setCornerRadius:25];
    [tim setImage:[UIImage imageNamed:@"timothy.png"]];
    [tim setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView *john = [[UIImageView alloc] initWithFrame:imageRect];
    [john setClipsToBounds:YES];
    [john.layer setCornerRadius:25];
    [john setImage:[UIImage imageNamed:@"John Gatte.png"]];
    [john setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView *steph = [[UIImageView alloc] initWithFrame:imageRect];
    [steph setClipsToBounds:YES];
    [steph.layer setCornerRadius:25];
    [steph setImage:[UIImage imageNamed:@"stephen cook.png"]];
    [steph setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView *tai = [[UIImageView alloc] initWithFrame:imageRect];
    [tai setClipsToBounds:YES];
    [tai.layer setCornerRadius:25];
    [tai setImage:[UIImage imageNamed:@"tai.jpg"]];
    [tai setContentMode:UIViewContentModeScaleAspectFill];
    
    imageViews = @[anni, tim, john, steph, tai];
    
    // Do any additional setup after loading the view.
    [self setTitle:NSLocalizedString(@"Hope", nil)];
    
    self.storyWindow = (HMReadStoryContainerWindow*)[(HMAppDelegate*)[[UIApplication sharedApplication] delegate] storyWindow];
     
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentComposeStory:)]];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b.layer setCornerRadius:b.frame.size.width/2];
    [b setImage:[UIImage imageNamed:@"domuro.png"] forState:UIControlStateNormal];
    [b setClipsToBounds:YES];
    
    // TODO: Uncomment and implement profile screen!
//    [b addTarget:self action:@selector(presentProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:b];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.storyWindow setPeekHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.storyWindow setPeekHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController*) fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"author" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate and DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKMerchantCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[ZKMerchantCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MessageCell"];
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Anni Liu"];
            [cell.detailTextLabel setText:@"Sent you an image."];
            break;
        case 1:
            [cell.textLabel setText:@"Timothy Balm"];
            [cell.detailTextLabel setText:@"You just have to take it one step at a time. I promise it will get better."];
            break;
        case 2:
            [cell.textLabel setText:@"John Gatte"];
            [cell.detailTextLabel setText:@"I can understand how confusing treatement options can be, let me"];
            break;
        case 3:
            [cell.textLabel setText:@"Stephen Cook"];
            [cell.detailTextLabel setText:@"I'm really glad we can talk like this."];

            break;
        default:
            [cell.textLabel setText:@"Tai Cao"];
            [cell.detailTextLabel setText:@"I've been there, I promise things will get better."];

            break;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"white"]];
    [cell addSubview:imageViews[indexPath.row]];
    [cell.detailTextLabel setNumberOfLines:0];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects]?:5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    NSArray *names = @[@"Anni", @"Timothy", @"John", @"Stephen", @"Tai"];
    vc.name = [names objectAtIndex:indexPath.row];
    vc.version = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
//            Course *changedCourse = [self.fetchedResultsController objectAtIndexPath:indexPath];
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.textLabel.text = changedCourse.title;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

#pragma mark - Transitions
- (void)presentComposeStory:(id)sender {
    HMCreateStoryView *c = [[HMCreateStoryView alloc] initWithFrame:self.view.bounds];
    [self.storyWindow presentCreateStoryView:c];
}

- (void)presentProfile:(id)sender {
    HMProfileCard *p = [[HMProfileCard alloc] initWithFrame:self.view.bounds];
    [self.storyWindow presentProfileCard:p];
}

@end
