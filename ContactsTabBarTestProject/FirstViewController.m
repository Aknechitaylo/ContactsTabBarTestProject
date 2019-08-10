//
//  FirstViewController.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 08.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "FirstViewController.h"



@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *firstViewControllerTableView;

@property (strong, nonatomic) NSArray *contactsArray;

@end



@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.firstViewControllerTableView.dataSource = self;
    self.firstViewControllerTableView.delegate = self;
    
    self.contactsArray = @[@"Настя", @"Дима", @"Андрей", @"Катя", @"Машка"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    NSString *contactImageName = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    cell.textLabel.text = self.contactsArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:contactImageName];
    
    return cell;
}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
