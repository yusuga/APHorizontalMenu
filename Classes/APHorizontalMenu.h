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

- (NSInteger)rowCount;
- (CGFloat)cellWidth;
- (CGFloat)selectedCellWidth;
- (void)configureCell:(UITableViewCell *)cell forPosition:(NSInteger)index;
- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index;

@optional
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface APHorizontalMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Class cellClass;
@property (nonatomic) UINib *cellNib;
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UIView *tableFooterView;

@property (nonatomic, weak) IBOutlet id<APHorizontalMenuSelectDelegate> delegate;

@property (nonatomic) NSInteger selectedRow;
- (void)deleteRow:(NSInteger)row;

@end
