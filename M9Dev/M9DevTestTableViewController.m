//
//  M9DevTestTableViewController.m
//  M9Dev
//
//  Created by MingLQ on 2014-08-22.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import "M9DevTestTableViewController.h"

#import "NSArray+.h"

#import "M9NetworkingViewController.h"
#import "JSLayoutViewController.h"
#import "VideosOCCollectionViewController.h"
#import "VideosJSCollectionViewController.h"
#import "M9PagingViewController.h"

// #if DEBUG
#import <FLEX/FLEXManager.h>
// #endif

@interface M9DevTestTableViewController ()

@end

@implementation M9DevTestTableViewController {
    NSArray *viewControllers;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"M9DevTest";
        
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class tableViewCellClass = [UITableViewCell class];
    [self.tableView registerClass:tableViewCellClass forCellReuseIdentifier:NSStringFromClass(tableViewCellClass)];
    self.tableView.rowHeight = 50;
    
    viewControllers = @[ [FLEXManager sharedManager],
                         [M9NetworkingViewController new],
                         [JSLayoutViewController new],
                         [VideosOCCollectionViewController new],
                         [VideosJSCollectionViewController new],
                         ({
                             UIViewController *vc = [M9PagingViewController new];
                             vc.navigationItem.title = @"M9PagingViewController";
                             _RETURN vc;
                         }) ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* pop view controller by gesture recognizer
    if (self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    } */
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    UIViewController *viewController = [[viewControllers objectOrNilAtIndex:indexPath.row] as:[UIViewController class]];
    cell.textLabel.text = viewController ? viewController.navigationItem.title : @"FLEX";
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[viewControllers objectOrNilAtIndex:indexPath.row] as:[UIViewController class]];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        // #if DEBUG
        FLEXManager *flex = [FLEXManager sharedManager];
        if (flex.isHidden) {
            [flex showExplorer];
        }
        else {
            [flex hideExplorer];
        }
        // #endif
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
