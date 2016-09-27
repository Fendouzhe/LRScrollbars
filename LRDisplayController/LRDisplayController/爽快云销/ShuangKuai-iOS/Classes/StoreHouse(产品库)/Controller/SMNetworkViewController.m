//
//  SMNetworkViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNetworkViewController.h"
#import "RTLabel.h"
#import "SMUploadCardViewController.h"
#import "SMConfirmPaymentController.h"
#import "SMShippingController.h"
#import "SMSurePayController.h"

@interface SMNetworkViewController ()<UITextViewDelegate,RTLabelDelegate,SMUploadCardViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idCardTextField;
@property (strong, nonatomic) IBOutlet UIButton *certainBtn;

@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;


@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UILabel *ruleLable;
@property (nonatomic,copy)NSMutableDictionary * keyRectDict;
//身份证正面上传成功的token
@property (nonatomic ,copy)NSString *tokenFront;
//身份证反面上传成功的token
@property (nonatomic ,copy)NSString *tokenBack;
//手持身份证正面上传成功的token
@property (nonatomic ,copy)NSString *tokenHandCard;

#pragma mark -- match
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCellHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnHeight;

@end

@implementation SMNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //改变协议lable为红色
    self.keyRectDict = [NSMutableDictionary dictionary];
//    clickable link - <a href='http://store.apple.com'>link to apple store</a> <a href='http://www.google.com'>link to google</a> <a href='http://www.yahoo.com'>link to yahoo</a> <a href='https://github.com/honcheng/RTLabel'>link to RTLabel in GitHub</a> <a href='http://www.wiki.com'>link to wiki.com website</a>"
    
    [self match];
    
    self.title = @"入网资料";
    
//    NSString * string = @"1.根据国家工信部<uu color=clear><font face=Futura size=12 color='#dd1100'><a href='http://www.baidu.com'>《电话用户真实身份信息登记规定》（工业和信息化部令25号）</a></font></uu></font>要求，用户在我平台办理电话开户等入网手续需进行实名制登记。中国电信将保证此身份证照片仅用于本次入网使用。";
//
//    
//    RTLabel *label = [[RTLabel alloc] initWithFrame:self.ruleLable.frame];
//    label.width = KScreenWidth-20;
//    label.lineSpacing = 0.0;
//    //label.textColor = [UIColor redColor];
//    label.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:label];
//    [label setText:string];
//    label.delegate = self;
    

//    self.ruleLable.hidden = YES;
    
    self.uploadBtn.layer.borderWidth = 1;
    self.uploadBtn.layer.borderColor = KRedColorLight.CGColor;
    self.uploadBtn.layer.cornerRadius = 5;
    self.uploadBtn.layer.masksToBounds = YES;
    
    self.certainBtn.layer.cornerRadius = 8;
    self.certainBtn.layer.masksToBounds = YES;
    self.certainBtn.backgroundColor = KRedColorLight;
    
    
//    [self addNotifications];
}

- (void)match{
    self.topCellHeight.constant = 44 *SMMatchHeight;
    self.sureBtnHeight.constant = 44 *SMMatchHeight;
}
//
//- (void)addNotifications{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardFrontUploadSeccess:) name:@"KCardFrontUploadSeccess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardBackUploadSeccess:) name:@"KCardBackUploadSeccess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardHandCardUploadSeccess:) name:@"KCardHandCardUploadSeccess" object:nil];
//}

//- (void)cardFrontUploadSeccess:(NSNotification *)noti{
//    self.tokenFront = noti.userInfo[@"KCardFrontUploadSeccessKey"];
//    SMLog(@"self.tokenFront  %@",self.tokenFront);
//}
//
//- (void)cardBackUploadSeccess:(NSNotification *)noti{
//    self.tokenBack = noti.userInfo[@"KCardBackUploadSeccessKey"];
//    SMLog(@"self.tokenBack  %@",self.tokenBack);
//}
//
//- (void)cardHandCardUploadSeccess:(NSNotification *)noti{
//    self.tokenHandCard = noti.userInfo[@"KCardHandCardUploadSeccessKey"];
//    SMLog(@"self.tokenHandCard  %@",self.tokenHandCard);
//}


#pragma mark - RTLableDelegate
//点击label 中的url  之后的回调
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    SMLog(@"did select url %@", url);
    //处理点击事件 url
    
}



- (IBAction)uploadAction:(UIButton *)sender {
    SMLog(@"点击上传按钮");
    SMUploadCardViewController * upload = [SMUploadCardViewController new];
    upload.delegate = self;
    [self.navigationController pushViewController:upload animated:YES];
}

#pragma mark -- SMUploadCardViewControllerDelegate
- (void)cardFrontUploadSeccess:(NSString *)token{
    self.tokenFront = token;
}

- (void)cardBackUploadSeccess:(NSString *)token{
    self.tokenBack = token;
}

- (void)cardHandUploadSeccess:(NSString *)token{
    self.tokenHandCard = token;
}

- (IBAction)certainAction:(UIButton *)sender {
    SMLog(@"点击了确定按钮");
    if ([self.nameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.idCardTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填身份证号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!self.tokenFront || !self.tokenBack || !self.tokenHandCard) { //三张照片只要有一张没有上传成功的，就提示用户需要上传
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传证件照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    //从本地拿到之前用户填写过的收获地址
    NSString * nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
    NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
    NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
    NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
    
    if (nameStr  && phoneStr && provinceStr && detailAddress) { //如果收货地址信息都齐全,直接跳到确认支付页面
        if (self.isDianxin) {  //电信产品
            SMSurePayController *vc = [[SMSurePayController alloc] init];
//            vc.productID = self.productID;
            if (self.spec) {
                vc.productID = self.spec.id;
            }else{
                vc.productID = self.specId;
            }
            SMLog(@"vc.productID  %@",vc.productID);
            
            vc.name = self.nameTextField.text;
            vc.cardNum = self.idCardTextField.text;
            vc.token1 = self.tokenFront;
            vc.token2 = self.tokenBack;
            vc.token3 = self.tokenHandCard;
            if (self.spec) {
                vc.spec = self.spec;
            }else{
                vc.specId = self.specId;
            }
            
            vc.phoneNumPara = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
        }else{   //普通产品
            SMConfirmPaymentController *vc = [[SMConfirmPaymentController alloc] init];
            addressModle *address = [[addressModle alloc] init];
            address.name = self.nameTextField.text;
            address.phone = self.idCardTextField.text;
            address.address = [provinceStr stringByAppendingString:detailAddress];
            vc.address = address;
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:self.productID];
            vc.arrProductIDs = arr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{ //收货地址不全，跳到填写收货地址界面，
        SMShippingController *vc = [[SMShippingController alloc] init];
        vc.productID = self.productID;
        vc.isDianxin = YES;
        vc.name = self.nameTextField.text;
        vc.cardNum = self.idCardTextField.text;
        vc.token1 = self.tokenFront;
        vc.token2 = self.tokenBack;
        vc.token3 = self.tokenHandCard;
        if (self.spec) {
            vc.spec = self.spec;
        }else{
            vc.specId = self.specId;
        }
        
        vc.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
