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
    self.horizontalMenu.rowCount = 10;
    self.horizontalMenu.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
}

#pragma mark - APHorizontalMenuSelectDelegate

- (void)configureCell:(UITableViewCell *)cell forPosition:(NSInteger)index
{
    cell.textLabel.text = @(index).stringValue;
//    cell.backgroundColor = index%2 ? [UIColor blueColor] : [UIColor redColor];
}

- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index
{
    NSLog(@"APHorizontalMenu selection: %ld", (long)index);
}

@end
