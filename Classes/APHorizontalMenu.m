//
//  APHorizontalMenu.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "APHorizontalMenu.h"

static NSString * const kCellIdentifier = @"Cell";

@interface APHorizontalMenu ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger cellWidth;
@property (nonatomic) BOOL isTouchAnimation;

@end

@implementation APHorizontalMenu

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.visibleCellCount = 3;
}

- (void)createMenuControl
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.height,self.frame.size.width);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
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
    [self.tableView setDecelerationRate: UIScrollViewDecelerationRateNormal];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.tableView) {
        [self createMenuControl];
        [self update];
    }
}

#pragma mark - Custom setters

- (void)setRowCount:(NSInteger)rowCount
{
    if (_rowCount != rowCount) {
        _rowCount = rowCount;
        if (self.tableView) {
            [self update];
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex) {
        [self setCurrentIndex:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES];
    }
}

- (void)setVisibleCellCount:(NSInteger)visibleCellCount
{
    _visibleCellCount = visibleCellCount;
    if (self.tableView) {
        [self update];
    }
}

- (void)update
{
    self.cellWidth = self.frame.size.width/self.visibleCellCount;
    
    NSInteger viewWidth = self.frame.size.width;
    CGFloat f = (viewWidth-self.cellWidth)/2;
    [self.tableView setContentInset: UIEdgeInsetsMake(f, 0, f, 0)];
    self.clipsToBounds = YES;
    
    [self.tableView reloadData];
    if(self.rowCount > self.selectedIndex) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - UITableView control

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowCount;
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
    self.isTouchAnimation = YES;
    [self setCurrentIndex:indexPath animated:YES];
}

#pragma mark - Scroll control

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self centerTable];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerTable];
}

- (void)centerTable
{
    CGPoint point = [self convertPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) toView:self.tableView];
    NSIndexPath* centerIndexPath = [self.tableView indexPathForRowAtPoint:point];
    [self setCurrentIndex:centerIndexPath animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isTouchAnimation = NO;
}

- (void)setCurrentIndex:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if(self.isTouchAnimation || _selectedIndex != indexPath.row) {
        
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionTop];
        
        if(_selectedIndex != indexPath.row) {
            _selectedIndex = indexPath.row;
            
            if ([self.delegate respondsToSelector:@selector(horizontalMenu:didSelectPosition:)]) {
                [self.delegate horizontalMenu:self didSelectPosition:indexPath.row];
            }
        }
    }
}

@end
