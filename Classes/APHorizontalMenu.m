//
//  APHorizontalMenu.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "APHorizontalMenu.h"

static NSString * const kCellIdentifier = @"Cell";

@interface APHorizontalMenuTableView : UITableView

@end

@implementation APHorizontalMenuTableView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end

@interface APHorizontalMenu ()

@property (nonatomic) UITableView *tableView;

@end

@implementation APHorizontalMenu

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.tableView) {
        [self createTableView];
    }
}

- (void)createTableView
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.height,self.frame.size.width);
    CGFloat horizontalSpace = (self.bounds.size.width - [self.delegate selectedCellWidth])/2.;
    
    self.tableView = [[APHorizontalMenuTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.canCancelContentTouches = YES;
    
    if (self.tableHeaderView) {
        CGRect frame = self.tableHeaderView.frame;
        frame.size.width = horizontalSpace;
        self.tableHeaderView.frame = frame;
        
        self.tableHeaderView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    if (self.tableFooterView) {
        self.tableFooterView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        CGRect frame = self.tableFooterView.frame;
        frame.origin = CGPointZero;
        frame.size.height = horizontalSpace;
        self.tableFooterView.frame = frame;
        
        self.tableView.tableFooterView = self.tableFooterView;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (self.cellClass) {
        [self.tableView registerClass:self.cellClass forCellReuseIdentifier:kCellIdentifier];
    } else if (self.cellNib) {
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    } else {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    
    [self addSubview:self.tableView];
    
    CGPoint oldCenter = self.center;
    oldCenter.y = frame.size.width/2;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.center = oldCenter;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat leadingSpace = self.tableView.tableHeaderView ? 0. : horizontalSpace;
    CGFloat trailingSpace = self.tableView.tableFooterView ? 0. : horizontalSpace;
    [self.tableView setContentInset: UIEdgeInsetsMake(leadingSpace, 0., trailingSpace, 0.)];
    self.clipsToBounds = YES;
    
    [self.tableView reloadData];
    
    if([self.delegate rowCount] > self.selectedRow) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow
                                                                inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionTop];
        if ([self.delegate respondsToSelector:@selector(horizontalMenu:didSelectPosition:)]) {
            [self.delegate horizontalMenu:self didSelectPosition:self.selectedRow];
        }
    }
    
    if (self.tableView.tableHeaderView) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,
                                                   0.);
    }
}

#pragma mark -

- (void)setSelectedRow:(NSInteger)selectedIndex
{
    _selectedRow = selectedIndex;
    
    [self.tableView reloadData]; // Update all row height
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y = self.tableView.tableHeaderView.bounds.size.width + [self.delegate cellWidth]*selectedIndex - self.bounds.size.width/2. + [self.delegate selectedCellWidth]/2.;
    [self.tableView setContentOffset:offset animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(horizontalMenu:didSelectPosition:)]) {
        [self.delegate horizontalMenu:self didSelectPosition:selectedIndex];
    }
}

- (void)deleteRow:(NSInteger)row
{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationLeft];
    
    if ([self.delegate rowCount]) {
        self.selectedRow = self.selectedRow == [self.delegate rowCount] ? self.selectedRow - 1 : self.selectedRow;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == self.selectedRow ? [self.delegate selectedCellWidth] : [self.delegate cellWidth];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate rowCount];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.delegate configureCell:cell forPosition:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedRow:indexPath.row];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView
                                 willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end
