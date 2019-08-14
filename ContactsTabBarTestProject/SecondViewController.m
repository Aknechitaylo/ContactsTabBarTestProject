//
//  SecondViewController.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 08.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "FirstViewControllerTableViewCell.h"



@interface SecondViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property IBOutlet UITableView *secondViewControllerTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondViewControllerCollectionView;
@property IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (strong, nonatomic) NSArray *contactsArray;
@property (strong, nonatomic) NSArray<NSIndexPath *> *selectedRows;

@property (assign, nonatomic) CGFloat collectionViewCellHeight;

@end



static NSString * const reuseIdentifier = @"Cell";



@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.secondViewControllerTableView.dataSource = self;
    self.secondViewControllerTableView.delegate = self;
    self.secondViewControllerCollectionView.dataSource = self;
    self.secondViewControllerCollectionView.delegate = self;
    
    self.collectionViewCellHeight = 70;
    
    FirstViewController *firstVC = self.tabBarController.viewControllers[0];
    self.contactsArray = firstVC.contactsArray;
    
    [self.secondViewControllerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionViewHeightConstraint.constant = 0;
    
    [self.secondViewControllerTableView setEditing:YES];
}

- (void)updateTopCollectionViewWithSelectedRows:(NSArray<NSIndexPath *> *)selectedRows {
    
    self.collectionViewHeightConstraint.constant = selectedRows.count == 0 ?: self.collectionViewCellHeight;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.secondViewControllerCollectionView reloadData];
    
    NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:self.selectedRows.count - 1 inSection:0];
    [self.secondViewControllerCollectionView scrollToItemAtIndexPath:lastItemIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FirstViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
        cell = [[FirstViewControllerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    CNContact *contact = self.contactsArray[indexPath.row];
    
    cell.contactText = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    cell.contactImage = [UIImage imageWithData:contact.thumbnailImageData];
    
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
    if (self.selectedRows.count == 0)
        [self.secondViewControllerCollectionView.collectionViewLayout invalidateLayout];
    [self updateTopCollectionViewWithSelectedRows:self.selectedRows];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedRows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [collectionViewCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.selectedRows.count != 0) {
        NSIndexPath *selectedRowIndexPath = self.selectedRows[indexPath.row];
        CNContact *contact = self.contactsArray[selectedRowIndexPath.row];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:collectionViewCell.contentView.frame];
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.clipsToBounds = YES;
        
        UIImage *contactThumbnail = [UIImage imageWithData:contact.thumbnailImageData];
        imageView.image = contactThumbnail ?: [UIImage imageNamed:@"contacts"];
        [collectionViewCell.contentView addSubview:imageView];
    }
    
    return collectionViewCell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionViewCellHeight, self.collectionViewCellHeight);
}

@end
