//
//  ViewController.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 01/05/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.horizontalMenu.delegate = self;
    self.horizontalMenu.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
}

#pragma mark - APHorizontalMenuSelectDelegate

- (NSInteger)rowCount
{
    return 10;
}

- (CGFloat)cellWidth
{
    return 60.;
}

- (CGFloat)selectedCellWidth
{
    return 120.;
}

- (void)configureCell:(UITableViewCell *)cell forPosition:(NSInteger)index
{
    cell.textLabel.text = @(index).stringValue;
//    cell.backgroundColor = index%2 ? [UIColor blueColor] : [UIColor redColor];
}

- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index
{
    NSLog(@"APHorizontalMenu index: %zd", index);
}

@end
