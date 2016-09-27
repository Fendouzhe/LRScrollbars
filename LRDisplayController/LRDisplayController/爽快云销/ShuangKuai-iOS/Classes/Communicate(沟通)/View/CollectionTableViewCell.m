//
//  CollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "SMCollectionViewCell.h"
#import "SMGroupChatDetailData.h"
#import "SMGroupChatListData.h"
#import "ChatroomMemberListData.h"

#define collectionHeight 80*SMMatchWidth

@interface CollectionTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;/**< collectionview */
@property (nonatomic,assign,getter=administrators) BOOL isAdministrators;/**< 是否是管理员 */
@end

@implementation CollectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[SMCollectionViewCell class] forCellWithReuseIdentifier:@"SMCollectionViewCell"];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
//        self.collectionView.minimumInteritemSpacing = 0;
    }
    return self;
}

-(void)setRoomDetail:(SMGroupChatDetailData *)roomDetail{
    _roomDetail = roomDetail;
    NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if([roomDetail.chatroom.createrId isEqualToString:userIDStr]){
        self.isAdministrators = YES;
    }else{
        self.isAdministrators = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource



//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //    [collectionView layoutIfNeeded];
    if (!self.roomDetail.chatroomMemberList.count) {
        return 0;
    }
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.roomDetail.chatroomMemberList.count) {
        
        if (self.administrators) {
            if (self.roomDetail.chatroomMemberList.count>3) {
                return 6;
            }else{
                return self.roomDetail.chatroomMemberList.count + 2;
            }
        }else{
            if (self.roomDetail.chatroomMemberList.count>4) {
                return 6;
            }else{
                return self.roomDetail.chatroomMemberList.count + 1;
            }
        }
    }else{
        
        return 0;
    }
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    [collectionView layoutIfNeeded];
    static NSString * CellIdentifier = @"SMCollectionViewCell";
    SMCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    SMLog(@" cellIndex = %ld,%ld",indexPath.section,indexPath.row);
    cell.roomDetail = self.roomDetail;
    if(self.administrators){//是管理员 有删除，添加组员权限
        if (self.roomDetail.chatroomMemberList.count>3) {
            switch (indexPath.row) {
                case 4:
                {
                    cell.cellType = SMCollectionViewTypeAdd;
                }
                    break;
                case 5:
                {
                    cell.cellType = SMCollectionViewTypeDel;
                }
                    break;
                default:
                {
                    cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
                    cell.cellType = SMCollectionViewTypeNone;
                }
                    break;
            }
        }else{
            if (indexPath.row == self.roomDetail.chatroomMemberList.count+1) {
                cell.cellType = SMCollectionViewTypeDel;
            }else if(indexPath.row == self.roomDetail.chatroomMemberList.count){
                cell.cellType = SMCollectionViewTypeAdd;
            }else{
                cell.cellType = SMCollectionViewTypeNone;
                cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
            }
        }
//        if (indexPath.row == self.roomDetail.chatroomMemberList.count) {
//            cell.cellType = SMCollectionViewTypeAdd;
//        }else if(indexPath.row == self.roomDetail.chatroomMemberList.count-1){
//            cell.cellType = SMCollectionViewTypeDel;
//        }else{
//            cell.cellType = SMCollectionViewTypeNone;
//            cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
//        }
    }else{//不是管理员 只有添加组员权限
        
        if (self.roomDetail.chatroomMemberList.count>4) {
            if (indexPath.row == 5) {
                cell.cellType = SMCollectionViewTypeAdd;
            }else{
                cell.cellType = SMCollectionViewTypeNone;
                cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
            }
        }else{
            if (indexPath.row == self.roomDetail.chatroomMemberList.count) {
                cell.cellType = SMCollectionViewTypeAdd;
            }else{
                cell.cellType = SMCollectionViewTypeNone;
                cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
            }
        }
//        if (indexPath.row == self.roomDetail.chatroomMemberList.count-1) {
//            cell.cellType = SMCollectionViewTypeAdd;
//        }else{
//            cell.cellType = SMCollectionViewTypeNone;
//            cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
//        }
    }
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((KScreenWidth - 7*5)/6, collectionHeight - 10);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.0;
//}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor whiteColor];
//    if (indexPath.row == self.collectionDataArray.count) {
//        AllServerTableViewController *allServerVc = [[AllServerTableViewController alloc] init];
//        [self.navigationController pushViewController:allServerVc animated:YES];
//    }else{
//        WebViewController *webVc = [[WebViewController alloc] init];
//        //        NSString *urlStr = [self.collectionDataArray[indexPath.row] strAppUrl];
//        webVc.urlStr = [self.collectionDataArray[indexPath.row] strAppUrl];
//        //        webVc.urlStr = @"http://www.baidu.com";
//        [self.navigationController pushViewController:webVc animated:YES];
//    }
    SMCollectionViewCell *cell = (SMCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    switch (cell.cellType) {
        case SMCollectionViewTypeNone:
        {
            if([self.delegate respondsToSelector:@selector(clickUserWithUserID:)]){
                [self.delegate clickUserWithUserID:cell.cellData.userId];
            }
        }
            break;
        case SMCollectionViewTypeAdd:
        {
            if([self.delegate respondsToSelector:@selector(addGroupMemberClick)]){
                [self.delegate addGroupMemberClick];
            }
        }
            break;
        case SMCollectionViewTypeDel:
        {
            if([self.delegate respondsToSelector:@selector(delGroupMemberClick)]){
                [self.delegate delGroupMemberClick];
            }
        }
            break;
        default:
            break;
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"CollectionTableViewCell";
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
