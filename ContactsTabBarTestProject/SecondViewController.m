//
//  SecondViewController.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 08.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "SecondViewController.h"



@interface SecondViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property IBOutlet UITableView *secondViewControllerTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondViewControllerCollectionView;
@property IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (strong, nonatomic) NSArray *contactsArray;
@property (strong, nonatomic) NSArray<NSIndexPath *> *selectedRows;

@end



@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.secondViewControllerTableView.dataSource = self;
    self.secondViewControllerTableView.delegate = self;
    self.secondViewControllerCollectionView.dataSource = self;
    self.secondViewControllerCollectionView.delegate = self;
    
    self.contactsArray = @[@"Настя", @"Дима", @"Андрей", @"Катя", @"Машка"];
    
    self.collectionViewHeightConstraint.constant = 0;
    
    [self.secondViewControllerTableView setEditing:YES];
}

- (void)updateTopCollectionViewWithSelectedRows:(NSArray<NSIndexPath *> *)selectedRows {
    
    self.collectionViewHeightConstraint.constant = selectedRows.count == 0 ? 0 : 50;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.secondViewControllerCollectionView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellID = @"tableViewCellID";
    static NSString *contactImageName = @"photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    
    cell.textLabel.text = self.contactsArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:contactImageName];
    
    return cell;
}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRows = [tableView indexPathsForSelectedRows];
    [self updateTopCollectionViewWithSelectedRows:self.selectedRows];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRows = [tableView indexPathsForSelectedRows];
    [self updateTopCollectionViewWithSelectedRows:self.selectedRows];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedRows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *collectionViewCellID = @"collectionViewCellID";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    
    
    return cell;
}


#pragma mark - UICollectionViewDataDelegate


@end
