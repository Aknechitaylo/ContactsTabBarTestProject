//
//  FirstViewController.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 08.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewControllerTableViewCell.h"



@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property IBOutlet UITableView *firstViewControllerTableView;

@property (strong, nonatomic) CNContactPickerViewController *contactPickerViewController;

@property (assign, nonatomic) NSUInteger heightForRow;
@property (assign, nonatomic) BOOL animateCells;

@end



@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchBar.delegate = self;
    
    self.contactsArray = [NSMutableArray array];
    [self getListOfAllContactsOfUser];

    self.heightForRow = 60;
    self.animateCells = YES;
}

- (void)getListOfAllContactsOfUser {
    CNContactStore *store = [CNContactStore new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactThumbnailImageDataKey];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
                if (error)
                    NSLog(@"error fetching contacts %@", error);
                else
                    [self.contactsArray addObject:contact];
            }];
        } else
            [self askUserToGruntContactsAccess];
    }];

}

- (void)askUserToGruntContactsAccess {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Для использования приложения, пожалуйста, предоставьте доступ к вашим контактам" message:@"Разрешите доступ в настройках" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.contactsArray.count == 0) {
        [self getListOfAllContactsOfUser];
    }
    
    self.firstViewControllerTableView.dataSource = self;
    self.firstViewControllerTableView.delegate = self;
    [self.firstViewControllerTableView reloadData];
}

- (void)animateCell:(FirstViewControllerTableViewCell *)cell {
    // анимация ячеек таблицы
    CGFloat cellWidth, firstXCoordinate, secondXCoordinate, finalXCoordinate;
    cellWidth = cell.frame.size.width;
    firstXCoordinate = -cellWidth;
    secondXCoordinate = 24;
    finalXCoordinate = 8;
    
    cell.imageViewLeadingConstraintConstant = firstXCoordinate;
    
    static NSTimeInterval delay = 0.1f;
    delay = delay + 0.05f;
    
    [UIView animateWithDuration:0.25f delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.imageViewLeadingConstraintConstant = secondXCoordinate;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            cell.imageViewLeadingConstraintConstant = finalXCoordinate;
            self.animateCells = NO;
        }];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    
    FirstViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[FirstViewControllerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    CNContact *contact = self.contactsArray[indexPath.row];
    
    cell.contactText = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    cell.contactImage = [UIImage imageWithData:contact.thumbnailImageData];
    
    return cell;
}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.heightForRow;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.animateCells)
        [self animateCell:(FirstViewControllerTableViewCell *)cell];
}

@end
