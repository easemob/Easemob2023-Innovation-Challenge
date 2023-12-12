//
//  EMGroupManageViewController.m
//  EaseIM
//
//  Created by 娜塔莎 on 2019/12/4.
//  Copyright © 2019 娜塔莎. All rights reserved.
//

#import "EMGroupManageViewController.h"
#import "EMGroupMutesViewController.h"
#import "EMGroupBlacklistViewController.h"
#import "EMGroupOwnerViewController.h"

@interface EMGroupManageViewController ()

@property (nonatomic, strong) EMGroup *group;

@property (nonatomic, strong) NSString *groupId;

@property (nonatomic, strong) UIButton *groupOwnerTurnOverBtn;

@property (nonatomic, strong) NSMutableArray *mutesList;

@property (nonatomic, strong) NSMutableArray *blackList;

@end

@implementation EMGroupManageViewController

- (instancetype)initWithGroup:(NSString *)aGroupId
{
    self = [super init];
    if (self) {
        _groupId = aGroupId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakself = self;
    [EMClient.sharedClient.groupManager getGroupSpecificationFromServerWithId:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
        weakself.group = aGroup;
        [weakself _setupSubviews];
        weakself.showRefreshHeader = NO;
        [weakself _fetchGroupBlackList:1];
        [weakself _fetchGroupMutes:1];
    }];

    self.mutesList = [[NSMutableArray alloc]init];
    self.blackList = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

- (void)_fetchGroupBlackList:(int)aPage
{
    if (self.group.permissionType == EMGroupPermissionTypeMember || self.group.permissionType == EMGroupPermissionTypeNone) {
        return;
    }
    if (aPage == 1) {
        [self.blackList removeAllObjects];
    }
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].groupManager getGroupBlacklistFromServerWithId:self.group.groupId pageNumber:self.page pageSize:200 completion:^(NSArray *aList, EMError *aError) {
        if (aError) {
            [EMAlertController showErrorAlert:aError.errorDescription];
        } else {
            [weakself.blackList addObjectsFromArray:aList];
        }
        if ([aList count] == 200) {
            [weakself _fetchGroupBlackList:(aPage + 1)];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }
    }];
}

- (void)_fetchGroupMutes:(int)aPage
{
    if (self.group.permissionType == EMGroupPermissionTypeMember || self.group.permissionType == EMGroupPermissionTypeNone) {
        return;
    }
    if (aPage == 1) {
        [self.mutesList removeAllObjects];
    }
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].groupManager getGroupMuteListFromServerWithId:self.group.groupId pageNumber:aPage pageSize:200 completion:^(NSArray *aList, EMError *aError) {
        if (aError) {
            [EMAlertController showErrorAlert:aError.errorDescription];
        } else {
            [weakself.mutesList addObjectsFromArray:aList];
        }
        if ([aList count] == 200) {
            [weakself _fetchGroupMutes:(aPage + 1)];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }
    }];
}

- (void)_setupSubviews
{
    [self addPopBackLeftItem];
    self.title = NSLocalizedString(@"groupAdmin", nil);
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@130);
    }];
    
    self.groupOwnerTurnOverBtn = [[UIButton alloc]init];
    [self.groupOwnerTurnOverBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:43/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.groupOwnerTurnOverBtn setTitle:NSLocalizedString(@"groupOwner", nil) forState:UIControlStateNormal];
    self.groupOwnerTurnOverBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.groupOwnerTurnOverBtn setBackgroundColor:[UIColor whiteColor]];
    [self.groupOwnerTurnOverBtn addTarget:self action:@selector(_turnOverGroupOwner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.groupOwnerTurnOverBtn];
    [self.groupOwnerTurnOverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(25);
        make.width.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    if (!(self.group.permissionType == EMGroupPermissionTypeOwner)) {
        self.groupOwnerTurnOverBtn.hidden = YES;
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"UITableViewCellValue1";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = NSLocalizedString(@"blManger", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"usersCount", nil),self.blackList.count];
        } else if (row == 1) {
            cell.textLabel.text = NSLocalizedString(@"muteManager", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"usersCount", nil),self.mutesList.count];
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            EMGroupBlacklistViewController *controller = [[EMGroupBlacklistViewController alloc] initWithGroup:self.group];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            EMGroupMutesViewController *controller = [[EMGroupMutesViewController alloc] initWithGroup:self.group];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - Action
//移交群主
- (void)_turnOverGroupOwner
{
    EMGroupOwnerViewController *controller = [[EMGroupOwnerViewController alloc] initWithGroup:self.group];
    __weak typeof(self) weakself = self;
    [controller setSuccessCompletion:^(EMGroup * _Nonnull aGroup) {
        weakself.groupOwnerTurnOverBtn.hidden = YES;
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
