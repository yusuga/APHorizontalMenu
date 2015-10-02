//
//  APHorizontalMenu.h
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol to get the selected item
@protocol APHorizontalMenuSelectDelegate <NSObject>

- (void)configureCell:(UITableViewCell *)cell forPosition:(NSInteger)index;
- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index;

@end

@interface APHorizontalMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Class cellClass;
@property (nonatomic) UINib *cellNib;

@property (nonatomic, weak) IBOutlet id<APHorizontalMenuSelectDelegate> delegate;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger visibleCellCount;

@property (nonatomic) NSInteger selectedIndex;

@end
