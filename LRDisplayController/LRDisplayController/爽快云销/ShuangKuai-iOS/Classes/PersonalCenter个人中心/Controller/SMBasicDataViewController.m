//
//  SMBasicDataViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMBasicDataViewController.h"
#import "SMIndustryController.h"
#import "SMBasicInfoCell.h"
#import "SMCreateErWeiMaViewController.h"
#import "SMNewChatViewController.h"

@interface SMBasicDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property (nonatomic ,strong)UIButton *addFriendBtn;

//加好友验证消息
@property (nonatomic,copy)NSString * remark;

@end

@implementation SMBasicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"基本资料";
    
    [self setupTableView];
    
    //获取别人的资料
    [self getOthersDatas];
    
    //设置按钮文字
    [self setupButton];
    
}
- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

-(void)getOthersDatas
{
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    //是别人
    if (self.user && ![self.user.userid isEqualToString:ID]) {
//        [[SKAPI shared] queryUserProfile:ID block:^(id result, NSError *error) {
//            if (error) {//请求失败
//                SMLog(@"%@",error);
//            }else{//请求成功
//                
//                User * user = (User *)result;
//                self.user = user;
//                [self.tableView reloadData];
//            }
//        }];
    }
    
}

- (void)setupButton{
    
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    //是别人
    if (self.user && ![self.user.userid isEqualToString:ID]) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = KRedColorLight;
        CGFloat width = KScreenWidth * 0.8;
        button.frame = CGRectMake((KScreenWidth-width)*0.5, KScreenHeight*0.7, width, 44);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:16*KMatch];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [self.view addSubview:button];
        self.addFriendBtn = button;
        [self.addFriendBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //如果一经是自己的好友，就显示“发起会话”，如果不是，则显示“添加到联系人”
        [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
            if (!error) {
                [self.addFriendBtn setTitle:@"添加到联系人" forState:UIControlStateNormal];
                for (User *user in array) {
                    SMLog(@"[user.userid isEqualToString:self.user.userid]   %zd",[user.userid isEqualToString:self.user.userid]);
                    if ([user.userid isEqualToString:self.user.userid]) {
                        [self.addFriendBtn setTitle:@"发起会话" forState:UIControlStateNormal];
                        break;
                    }else{
                        [self.addFriendBtn setTitle:@"添加到联系人" forState:UIControlStateNormal];
                    }
                }
            }else{
                SMLog(@"error   %@",error);
            }
        }];
    }
}

- (void)addBtnClick:(UIButton *)sender {
    
    if ([self.addFriendBtn.currentTitle isEqualToString:@"添加到联系人"]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请求添加好友验证" message:self.user.name preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [[SKAPI shared] addFriend:self.user.userid andRemark:self.remark block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"%@",result);
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }];
        // 创建按钮
        // 注意取消按钮只能添加一个
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入验证信息";
            SMLog(@"text =  = %@",textField.text);
            textField.delegate = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        SMLog(@"点击了发起会话");
        //新建一个聊天会话View Controller对象
        SMNewChatViewController *chat = [[SMNewChatViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.user.userid;
        //设置聊天会话界面要显示的标题
        chat.title = self.user.name;
        chat.user = self.user;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
    
}

- (void)alertTextFieldTextDidChange:(NSNotification *)notification
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    
    if (alert) {
        UITextField *lisen = [alert.textFields lastObject];
        self.remark = lisen.text;
        SMLog(@"self.remark = %@",self.remark);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMBasicInfoCell *cell = [SMBasicInfoCell cellWithTableView:tableView];
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    cell.leftLabel.font = KDefaultFontBig;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0){
        cell.leftLabel.text = @"性别";
        cell.iconImageView.image = [UIImage imageNamed:@"sex"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            NSInteger sex = self.user.gender;
            if (sex == 0) {
                cell.rightLabel.text = @"未知性别";
            }else if (sex == 1){
                cell.rightLabel.text = @"男";
            }else if (sex == 2){
                cell.rightLabel.text = @"女";
            }
        }else{
            NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSex];
//                if (sexStr.integerValue == 0) {
//                    cell.rightLabel.text = @"";
//                }else if (sexStr.integerValue == 1){
//                    cell.rightLabel.text = @"男";
//                }else if (sexStr.integerValue == 2){
//                    cell.rightLabel.text = @"女";
//                }
            cell.rightLabel.text = sexStr;
        }
        cell.icon.hidden = YES;
    }else if(indexPath.row == 1){
        cell.leftLabel.text = @"手机号码";
        cell.iconImageView.image = [UIImage imageNamed:@"mobile"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            cell.rightLabel.text = self.user.phone;
        }else{
            NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserTelephoneNum];
            cell.rightLabel.text = phone;
        }
        cell.icon.hidden = YES;
    }else if (indexPath.row == 2){
        cell.leftLabel.text = @"工作电话";
        cell.iconImageView.image = [UIImage imageNamed:@"telephone"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            cell.rightLabel.text = self.user.workPhone;
        }else{
            NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserWorkPhone];
            cell.rightLabel.text = phone;
        }
        cell.icon.hidden = YES;
    }else if (indexPath.row == 3){
        cell.leftLabel.text = @"所在地";
        cell.iconImageView.image = [UIImage imageNamed:@"address"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            
            cell.rightLabel.text = self.user.address;
            
        }else{
            //cell.rightLabel.text = @"广东 广州";
            NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyAddress];
            cell.rightLabel.text = address;
        }
        
        SMLog(@"Cell.rightLabel =     %@",cell.rightLabel.text);
        
        if (cell.rightLabel.text == nil ||[cell.rightLabel.text isEqualToString:@""]) {
            cell.rightLabel.text = @"暂未设置所在地";
        }
        
        cell.icon.hidden = YES;
    }else if (indexPath.row == 4){
        NSString *companyName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
        cell.leftLabel.text = @"公司";
        cell.iconImageView.image = [UIImage imageNamed:@"company"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            cell.rightLabel.text = self.user.companyName;
        }else{
            cell.rightLabel.text = companyName;
        }
        cell.icon.hidden = YES;
    }else if (indexPath.row == 5){
        NSString *industryStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIndustry];
        cell.leftLabel.text = @"行业";
        cell.iconImageView.image = [UIImage imageNamed:@"industry"];
        if (self.user && ![self.user.userid isEqualToString:ID]) {
            cell.rightLabel.text = self.user.induTag;
            if (self.user.induTag == nil) {
                cell.rightLabel.text = @"该用户暂时没有选择行业";
            }
            //cell.rightLabel.text = industryStr;
        }else{
            cell.rightLabel.text = industryStr;
        }
        cell.icon.hidden = YES;
    }else if (indexPath.row == 6){
        cell.leftLabel.text = @"二维码";
        cell.iconImageView.image = [UIImage imageNamed:@"QRCode"];
        cell.rightLabel.text = @"";
        cell.icon.image = [UIImage imageNamed:@"erweimaHei"];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 43;
    }else if (isIPhone6){
        height = 43 * KMatch6Height;
    }else if (isIPhone6p){
        height = 43 * KMatch6pHeight;
    }else if (KScreenHeight == 480){
        height = 40;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {//点击 二维码
        //SMEditInfo2Controller *vc = [[SMEditInfo2Controller alloc] init];
        //[self.navigationController pushViewController:vc animated:YES];
        SMCreateErWeiMaViewController * erWeiView = [SMCreateErWeiMaViewController new];
        if (self.user) {
            erWeiView.user = self.user;
            [erWeiView setupQrcodeWithStr:[NSString stringWithFormat:@"SK-PROFILE:%@",self.user.userid]];
            [self.navigationController pushViewController:erWeiView animated:YES];
        }else{
            NSString * ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
            [erWeiView setupQrcodeWithStr:[NSString stringWithFormat:@"SK-PROFILE:%@",ID]];
            [self.navigationController pushViewController:erWeiView animated:YES];
        }
        
    }else if (indexPath.row == 4){//点击了 行业
        SMLog(@"点击了 行业");
    }else if (indexPath.row == 2){
        SMLog(@"点击了 工作电话");
        
    }

}

@end
