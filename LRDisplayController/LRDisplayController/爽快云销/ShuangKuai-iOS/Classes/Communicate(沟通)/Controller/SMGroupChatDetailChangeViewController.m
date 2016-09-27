//
//  SMGroupChatDetailChangeViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatDetailChangeViewController.h"
#import "SMGroupChatDetailData.h"
#import "SMGroupChatListData.h"
#import "SMEditingTextField.h"

#define KLiteFrameHeight (30*SMMatchWidth)
#define KBigFrameHeight (200*SMMatchWidth)

@interface SMGroupChatDetailChangeViewController ()
@property (nonatomic,strong) SMEditingTextField *liteTextField;/**< 一行文本编辑 */
@property (nonatomic,strong) UITextView *bigTextView;/**< 多行文本编辑 */
@property (nonatomic,weak) UIButton *rightBtn;/**< 按钮 */
@property (nonatomic,assign,getter=isValueChange) BOOL valueChange;/**< 值改变 */
@property (nonatomic,copy) NSString *oldValue;/**< 旧变量 */
@end

@implementation SMGroupChatDetailChangeViewController

-(SMEditingTextField *)liteTextField{
    if (_liteTextField == nil) {
        _liteTextField = [[SMEditingTextField alloc] init];
        _liteTextField.backgroundColor = [UIColor whiteColor];
//        _liteTextField.backgroundColor = KControllerBackGroundColor;
//        _liteTextField.delegate = self;
        [self.view addSubview:_liteTextField];
    }
    return _liteTextField;
}

-(UITextView *)bigTextView{
    if (_bigTextView == nil) {
        _bigTextView = [[UITextView alloc] init];
        [self.view addSubview:_bigTextView];
    }
    return _bigTextView;
}

-(instancetype)initWithSMGroupChatDetailChangeType:(SMGroupChatDetailChangeType )changeType withSMGroupChatDetailData:(SMGroupChatDetailData *)roomDetail{
    if (self = [super init]) {
        self.view.backgroundColor = KControllerBackGroundColor;
        _changeType = changeType;
        _roomDetail = roomDetail;
        switch (changeType) {
            case SMGroupChatDetailChangeTypeGroupName:
            {
                self.liteTextField.text = self.roomDetail.chatroom.roomName;
                self.oldValue = self.roomDetail.chatroom.roomName;
                MJWeakSelf
                [self.liteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.topMargin.equalTo(weakSelf.view).with.offset(30);
                    make.leftMargin.equalTo(weakSelf.view).with.offset(10);
                    make.rightMargin.equalTo(weakSelf.view).with.offset(-10);
                    make.height.equalTo(@KLiteFrameHeight);
                }];
            }
                break;
            case SMGroupChatDetailChangeTypeGroupNotice:
            {
                self.bigTextView.text = self.roomDetail.chatroom.intro;
                self.oldValue = self.roomDetail.chatroom.intro;
                MJWeakSelf
                [self.bigTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.topMargin.equalTo(weakSelf.view).with.offset(30);
                    make.leftMargin.equalTo(weakSelf.view).with.offset(10);
                    make.rightMargin.equalTo(weakSelf.view).with.offset(-10);
                    make.height.equalTo(@KBigFrameHeight);
                }];
            }
                break;
            case SMGroupChatDetailChangeTypeGroupNickName:
            {
                self.liteTextField.text = self.roomDetail.chatroom.remark;
                self.oldValue = self.roomDetail.chatroom.remark;
                MJWeakSelf
                [self.liteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.topMargin.equalTo(weakSelf.view).with.offset(30);
                    make.leftMargin.equalTo(weakSelf.view).with.offset(10);
                    make.rightMargin.equalTo(weakSelf.view).with.offset(-10);
                    make.height.equalTo(@KLiteFrameHeight);
                }];
            }
                break;
            default:
                break;
        }
        
        UIButton *rightBtn = [[UIButton alloc] init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFontBig;
        dict[NSForegroundColorAttributeName] = KRedColorLight;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确定" attributes:dict];
        [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
        [rightBtn sizeToFit];
        self.rightBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

-(void)rightItemClick{
    
    switch (_changeType) {
        case SMGroupChatDetailChangeTypeGroupName:
        {
            if ([self.liteTextField.text isEqualToString:self.oldValue] && self.liteTextField.text.length!=0 ) {
                //值没有改变
                
            }else{
                //值改变
                self.roomDetail.chatroom.roomName = self.liteTextField.text;
                if ([self.delegate respondsToSelector:@selector(valueChangeWithRoomDetailWithType:newName:)]) {
                    [self.delegate valueChangeWithRoomDetailWithType:SMGroupChatDetailChangeTypeGroupName newName:self.liteTextField.text];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case SMGroupChatDetailChangeTypeGroupNotice:
        {
            if ([self.bigTextView.text isEqualToString:self.oldValue] && self.bigTextView.text.length!=0 ) {
                //值没有改变
                
            }else{
//                //值改变
//                self.roomDetail.chatroom.intro = self.bigTextView.text;
//                if ([self.delegate respondsToSelector:@selector(valueChangeWithRoomDetailWithType:)]) {
//                    [self.delegate valueChangeWithRoomDetailWithType:SMGroupChatDetailChangeTypeGroupNotice];
//                }
                //值改变
                self.roomDetail.chatroom.roomName = self.liteTextField.text;
                if ([self.delegate respondsToSelector:@selector(valueChangeWithRoomDetailWithType:newName:)]) {
                    [self.delegate valueChangeWithRoomDetailWithType:SMGroupChatDetailChangeTypeGroupNotice newName:self.liteTextField.text];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case SMGroupChatDetailChangeTypeGroupNickName:
        {
            if ([self.liteTextField.text isEqualToString:self.oldValue] && self.liteTextField.text.length!=0 ) {
                //值没有改变
                
            }else{
//                //值改变
//                self.roomDetail.chatroom.remark = self.liteTextField.text;
//                if ([self.delegate respondsToSelector:@selector(valueChangeWithRoomDetailWithType:)]) {
//                    [self.delegate valueChangeWithRoomDetailWithType:SMGroupChatDetailChangeTypeGroupNickName];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
                //值改变
                self.roomDetail.chatroom.roomName = self.liteTextField.text;
                if ([self.delegate respondsToSelector:@selector(valueChangeWithRoomDetailWithType:newName:)]) {
                    [self.delegate valueChangeWithRoomDetailWithType:SMGroupChatDetailChangeTypeGroupNickName newName:self.liteTextField.text];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
