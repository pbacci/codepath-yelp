//
//  FiltersViewController.m
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"

NSInteger const NumCategoriesToShow = 2;

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *expandedSections;
@property (nonatomic, strong) UISwitch *onlyDealSwitch;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Filters";
        self.expandedSections = [NSMutableDictionary dictionary];
        self.onlyDealSwitch = [[UISwitch alloc] init];
        [self.onlyDealSwitch addTarget:self action:@selector(onOnlyDealSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the nav bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(onSearchButton)];

    // init table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FilterCell"];

    // init deals switch
    self.onlyDealSwitch.on = self.filterInfo.dealsOnly;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FilterTypeCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [FilterInfo headerTitleForFilterType:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    bool isExpanded = [self.expandedSections[@(section)] boolValue];
    switch (section) {
        case FilterTypeDistance:
            return isExpanded ? DistanceCount : 1;
        case FilterTypeSort:
            return isExpanded ? SortTypeCount : 1;
        case FilterTypeDeals:
            return 1;
        case FilterTypeCategory:
            return isExpanded ? CategoryCount : NumCategoriesToShow + 1;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (void)onOnlyDealSwitch
{
    self.filterInfo.dealsOnly = self.onlyDealSwitch.on;
}

- (void)onCancelButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSearchButton
{
    self.delegate.filterInfo = self.filterInfo;
    [self.delegate updateLocation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)expandSection:(NSInteger)section
{
    self.expandedSections[@(section)] = @YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get cell and clear existing accessories
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    bool isExpanded = [self.expandedSections[@(section)] boolValue];
    switch (section) {
        case FilterTypeDistance:
        {
            Distance distance;
            if (isExpanded) {
                distance = row;
                if (distance == self.filterInfo.distance) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                NSAssert(row == 0, @"collapsed sections should only have 1 row");
                distance = self.filterInfo.distance;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand_icon"]];
            }
            cell.textLabel.text = [FilterInfo displayStringForDistance:distance];

            return cell;
        }
        case FilterTypeSort:
        {
            SortType sortType;
            if (isExpanded) {
                sortType = row;
                if (sortType == self.filterInfo.sortType) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                NSAssert(row == 0, @"collapsed sections should only have 1 row");
                sortType = self.filterInfo.sortType;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand_icon"]];
            }
            cell.textLabel.text = [FilterInfo displayStringForSortType:sortType];

            return cell;
        }
        case FilterTypeDeals:
        {
            cell.textLabel.text = @"Offering a Deal";
            cell.accessoryView = self.onlyDealSwitch;
            return cell;
        }
        case FilterTypeCategory:
        {
            // special case the See All row
            if (!isExpanded && row == NumCategoriesToShow) {
                cell.textLabel.text = @"See All";
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand_icon"]];
                return cell;
            }

            Category category = row;
            cell.textLabel.text = [FilterInfo displayStringForCategory:category];
            if ([self.filterInfo.categories containsObject:[NSNumber numberWithInt:category]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            return cell;
        }
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (void)collapseSection:(NSInteger)section selectedRow:(NSInteger)row
{
    // update the filters
    NSIndexPath *prevSelectedIndexPath;
    switch (section) {
        case FilterTypeDistance:
            prevSelectedIndexPath = [NSIndexPath indexPathForRow:self.filterInfo.distance inSection:section];
            self.filterInfo.distance = row;
            break;
        case FilterTypeSort:
            prevSelectedIndexPath = [NSIndexPath indexPathForRow:self.filterInfo.sortType inSection:section];
            self.filterInfo.sortType = row;
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"not a collapsible section" userInfo:nil];
    }

    // move the checkmark to the newly selected cell
    UITableViewCell *prevSelectedCell = [self.tableView cellForRowAtIndexPath:prevSelectedIndexPath];
    prevSelectedCell.accessoryType = UITableViewCellAccessoryNone;
    NSIndexPath *newSelectedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *newSelectedCell = [self.tableView cellForRowAtIndexPath:newSelectedIndexPath];
    newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

    // mark the section as collapsed and refresh
    self.expandedSections[@(section)] = @NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    bool isExpanded = [self.expandedSections[@(section)] boolValue];

    switch (section) {
        case FilterTypeDistance:
        case FilterTypeSort:
            if (isExpanded) {
                [self collapseSection:section selectedRow:indexPath.row];
            } else {
                [self expandSection:section];
            }
            break;
        case FilterTypeDeals:
            // no-op
            break;
        case FilterTypeCategory:
            // special case the See All row
            if (!isExpanded && row == NumCategoriesToShow) {
                [self expandSection:section];
            } else {
                Category category = row;
                [self toggleCategory:category];
            }
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
    }
}

- (void)toggleCategory:(Category)category {
    // get the cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:category inSection:FilterTypeCategory];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    // toggle the category and the checkmark in the cell
    NSNumber *categoryNumber = [NSNumber numberWithInt:category];
    if ([self.filterInfo.categories containsObject:categoryNumber]) {
        [self.filterInfo.categories removeObject:categoryNumber];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.filterInfo.categories addObject:categoryNumber];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


@end
