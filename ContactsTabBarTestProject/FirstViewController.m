//
//  FirstViewController.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 08.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "FirstViewController.h"



@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property IBOutlet UITableView *firstViewControllerTableView;

@property (strong, nonatomic) CNContactPickerViewController *contactPickerViewController;
@property (strong, nonatomic) NSMutableArray *contactsArray;

@property (assign, nonatomic) NSUInteger heightForRow;
@property (assign, nonatomic) CGSize imageSize;

@end



@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchBar.delegate = self;
    
    self.firstViewControllerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contactsArray = [NSMutableArray array];
    
    self.heightForRow = 60;
    self.imageSize = CGSizeMake(self.heightForRow - 1, self.heightForRow - 1);
//    self.contactPickerViewController = [CNContactPickerViewController new];
//    self.contactPickerViewController.delegate = self;
    
//    [self presentViewController:self.contactPickerViewController animated:YES completion:nil];
}

- (void)getListOfAllContactsOfUser {
//    __block int count = 0;
    CNContactStore *store = [CNContactStore new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactImageDataKey];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    CNContact *contact = self.contactsArray[indexPath.row];
    NSString *name = contact.givenName;
    NSString *familyName = contact.familyName;
    UIImage *contactImage = [UIImage imageWithData:contact.imageData];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", name, familyName];
    
//    cell.imageView.contentMode = ;
    cell.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    cell.imageView.image = contactImage;

    [cell layoutSubviews];
    
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    cell.imageView.clipsToBounds = YES;
    
    return cell;
}

//- (UIImage *)makeRoundedImage:(UIImage *)image
//                      radius:(float)radius {
//
//    CALayer *imageLayer = [CALayer layer];
//    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    imageLayer.contents = (id) image.CGImage;
//
//    imageLayer.masksToBounds = YES;
//    imageLayer.cornerRadius = radius;
//
//    UIGraphicsBeginImageContext(image.size);
//    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return roundedImage;
//}

//- (UIImage *)imageScaledToSize:(CGSize)size {
//    UIGraphicsBeginImageContext(size);
//    [self.view drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.heightForRow;
}

@end
