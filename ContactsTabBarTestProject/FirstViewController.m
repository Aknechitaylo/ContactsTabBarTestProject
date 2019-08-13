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
@property (strong, nonatomic) NSMutableArray *contactsArray;

@property (assign, nonatomic) NSUInteger heightForRow;

@end



@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchBar.delegate = self;
    
    self.firstViewControllerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contactsArray = [NSMutableArray array];
    
    self.heightForRow = 60;
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
        }
    }];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // выполняется один раз
    
    [self getListOfAllContactsOfUser];
    
    self.firstViewControllerTableView.dataSource = self;
    self.firstViewControllerTableView.delegate = self;
    [self.firstViewControllerTableView reloadData];
    self.firstViewControllerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.searchBar.delegate = nil;
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

@end
