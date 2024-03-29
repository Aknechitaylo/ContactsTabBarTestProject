//
//  FirstViewControllerTableViewCell.m
//  ContactsTabBarTestProject
//
//  Created by Андрей on 12.08.2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

#import "FirstViewControllerTableViewCell.h"



@interface FirstViewControllerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorViewWidthConstraint;

@end

@implementation FirstViewControllerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateConstraints {
    [super updateConstraints];
    self.separatorViewWidthConstraint.constant = self.frame.size.width - 16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContactText:(NSString *)contactText {
    _contactText = contactText;
    
    self.contactLabel.text = contactText;
}

- (void)setContactImage:(UIImage *)contactImage {
    _contactImage = contactImage ?: [UIImage imageNamed:@"contacts"];
    
    self.contactImageView.image = _contactImage;
    
    self.contactImageView.layer.cornerRadius = self.contactImageView.frame.size.width/2;
    self.contactImageView.clipsToBounds = YES;
}

- (void)setImageViewLeadingConstraintConstant:(CGFloat)imageViewLeadingConstraintConstant {
    self.imageViewLeadingConstraint.constant = imageViewLeadingConstraintConstant;
    [self layoutIfNeeded];
}

@end
