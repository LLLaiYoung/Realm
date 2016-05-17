//
//  ViewController.m
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "ViewController.h"
#import "DataBaseManager.h"
#import "HiSchool.h"
#import "RealmCell.h"
static NSString *const cellIdentifier = @"HiSchoolCell";
@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
        [self.view addSubview:tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Realm";
    [self.tableView registerClass:[RealmCell class] forCellReuseIdentifier:cellIdentifier];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRealm)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除所有对象" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    self.tableView.rowHeight = 60;
}
#pragma mark - item Action
- (void)addRealm {
        HiSchool *hiSchool = [HiSchool new];
        hiSchool.title = @"LaiYoung";
        hiSchool.subTitle = @"http://www.jianshu.com/users/08ea9f093bfb/latest_articles";
        hiSchool.age = @20;
        hiSchool.date = [NSDate date];
        hiSchool.isMale = @YES;
        hiSchool.weight = @115.60;
        hiSchool.height = @170;
        hiSchool.avatar = UIImagePNGRepresentation([UIImage imageNamed:@"IMG_0852"]);
        BOOL error = [[DataBaseManager defaultManager] insertDefaultDBWithHiSchool:hiSchool];
//        [[DateBaseManager defaultManager] insertCustomDBWithDBName:kRealmCustomDBName OfHiSchool:hiSchool];
        NSLog(@"%i",error);
        [self.tableView reloadData];
}
- (void)leftItemAction {
    //* ------------------delete--------------------------------------------- */
//    [[DataBaseManager defaultManager] deleteDefaultDBAllObjects];//YES
//    
//    [[DataBaseManager defaultManager] deleteDefaultDBHischoolNumberOfIndex:0];//YES
//    
//    HiSchool *hiSchool = [[DataBaseManager defaultManager] queryDefaultDBAllObjects][0];
//    [[DataBaseManager defaultManager] deleteDefaultDBWithHiSchool:hiSchool];
    //* ------------------update--------------------------------------------- */
//    HiSchool *hiSchool = [[DataBaseManager defaultManager] queryDefaultDBWithHiSchoolNumberOfIndex:0];
//    RLMRealm *realm = RLMRealm.defaultRealm;
//    [realm transactionWithBlock:^{
//        hiSchool.title = @"HiSchool";
//    }];
//    [[DataBaseManager defaultManager] updateDefaultDBWithHiSchool:hiSchool];
//
//    RLMResults *results = [[DataBaseManager defaultManager] queryDefaultDBAllObjects];
//    NSMutableArray *updateValues = [NSMutableArray array];
//    for (HiSchool *hiSchool in results) {
//        RLMRealm *realm = RLMRealm.defaultRealm;
//        [realm transactionWithBlock:^{
//            hiSchool.title = @"LaiYoung";
//        }];
//        [updateValues addObject:hiSchool];
//        [[DataBaseManager defaultManager] updateDefaultDBWithArray:updateValues];
//    }
    //* ------------------query--------------------------------------------- */
//    RLMResults *results = [[DataBaseManager defaultManager] queryDefaultDBAllObjects];
//    for (HiSchool *hiSchool in results) {
//        NSLog(@"%@",hiSchool);
//    }

//    RLMResults *results = [[DataBaseManager defaultManager] queryDefaultDBWithContains:@"LaiYoung"];
//    for (HiSchool *hiSchool in results) {
//        NSLog(@"%@",hiSchool);
//    }
    RLMResults *results = [[DataBaseManager defaultManager] sortDefaultDBWithProperty:kRealmPrimaryKey ascending:NO];
    for (HiSchool *hiSchool in results) {
        NSLog(@"%@",hiSchool);
    }
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)  return [[DataBaseManager defaultManager] numberOfDefaultDBCount];
    return [[DataBaseManager defaultManager] numberOfCustomDBCountWithDBName:kRealmCustomDBName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RealmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section==0) {
        HiSchool *hiSchool = [[DataBaseManager defaultManager] queryDefaultDBWithHiSchoolNumberOfIndex:indexPath.row];
        cell.hiSchool = hiSchool;
        return cell;
    }
    HiSchool *hischool = [[DataBaseManager defaultManager] queryCustomDBWithDBName:kRealmCustomDBName OfIndex:indexPath.row];
    cell.hiSchool = hischool;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [[DataBaseManager defaultManager] deleteDefaultDBWithHiSchool:[[DataBaseManager defaultManager] queryDefaultDBAllObjects][indexPath.row]];
        }
    } else {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [[DataBaseManager defaultManager] deleteCustomDBWithDBName:kRealmCustomDBName OfHiSchool:[[DataBaseManager defaultManager] queryCustomDBAllObjectsWithDBName:kRealmCustomDBName][indexPath.row]];
        }
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
