//
//  DataDef.h
//  VSHORE
//
//  Created by Fish on 14-2-19.
//  Copyright (c) 2014年 vshore. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

//用户信息
@interface UserInfo : NSObject
{
    //类型
    int       type; //0- 注册用户 1- Facebook用户
    //facebook ID
    NSString* facebook_id;
    //用户ID
    int       uid;
    //token
    NSString* token;
    
    NSString* name;
    NSString* email;
    NSString* password;
    
    NSString* highSchool;
    NSString* college;
    NSString* workPlace;
    
    //性别
    int        sex; //0-? 1-female 2-male
    //头像
    NSString*  pic;
    //电话号码
    NSString*  phone;
    //local 1
    NSString*  loc1;
    //local 2
    NSString*  loc2;
    //local 3
    NSString*  loc3;
}
@property(nonatomic)        int       type;
@property(nonatomic,retain) NSString* facebook_id;
@property(nonatomic)        int       uid;
@property(nonatomic,retain) NSString* token;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* email;
@property(nonatomic,retain) NSString* password;

@property(nonatomic,retain) NSString* highSchool;
@property(nonatomic,retain) NSString* college;
@property(nonatomic,retain) NSString* workPlace;

@property(nonatomic)        int       sex;
@property(nonatomic,retain) NSString* pic;
@property(nonatomic,retain) NSString* phone;
@property(nonatomic,retain) NSString* loc1;
@property(nonatomic,retain) NSString* loc2;
@property(nonatomic,retain) NSString* loc3;

//保存uid和token
-(void)saveUserInfo;
//载入uid和token
-(void)loadUserInfo;
//清除
-(void)clearUserInfo;

@end

//好友
@interface FriendInfo : NSObject
{
    //ID
    NSString* f_id;
    int       f_uid;
    //Name
    NSString* f_name;
    //pic
    NSString* f_pic;
    //phone
    NSString* f_phone;
}

@property(nonatomic,retain) NSString* f_id;
@property(nonatomic)        int       f_uid;
@property(nonatomic,retain) NSString* f_name;
@property(nonatomic,retain) NSString* f_pic;
@property(nonatomic,retain) NSString* f_phone;

@end

//Post数据
@interface PostData : NSObject
{
    //flag
    int flag;
    //pic
    NSString* pic1;
    NSString* pic2;
    NSString* pic3;
    NSString* pic4;
    
    //title
    NSString* title;
    //describe
    NSString* describe;
    
    //oprice
    NSString* oprice;
    //lprice
    NSString* lprice;

    int       contact;
    int       free;
    int       swap;
    
    int       pid;
}
@property(nonatomic)        int       flag;
@property(nonatomic,retain) NSString* pic1;
@property(nonatomic,retain) NSString* pic2;
@property(nonatomic,retain) NSString* pic3;
@property(nonatomic,retain) NSString* pic4;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* describe;
@property(nonatomic,retain) NSString* oprice;
@property(nonatomic,retain) NSString* lprice;
@property(nonatomic)        int       contact;
@property(nonatomic)        int       free;
@property(nonatomic)        int       swap;
@property(nonatomic)        int       pid;

-(void)clear;

@end

//评论信息
@interface CommentInfo : NSObject
{
    //cid
    int        cid;
    //uid
    int        uid;
    //name
    NSString*  name;
    //pic
    NSString*  pic;
    //date
    NSString*  date;
    //msg
    NSString*  msg;
    //like
    int        like;
}
@property(nonatomic)        int       cid;
@property(nonatomic)        int       uid;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* pic;
@property(nonatomic,retain) NSString* date;
@property(nonatomic,retain) NSString* msg;
@property(nonatomic)        int       like;

@end

//vshore列表
@interface ItemInfo : NSObject
{
    //pid
    int        pid;
    //uid
    int        uid;
    //name
    NSString*  name;
    //pic
    NSString*  pic;
    //date
    NSString*  date;
    //type
    NSString*  type;
    //title
    NSString*  title;
    //oprice
    NSString*  oprice;
    //price
    NSString*  price;
    //desc
    NSString*  desc;
    //pics
    NSArray*   pics;
    //like count
    int        like;
    //like状态
    int        liked; //0 没有like 1 like
    //comments
    int        comments;
    //状态
    int        status;
}
@property(nonatomic) int pid;
@property(nonatomic) int uid;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* pic;
@property(nonatomic,retain) NSString* date;
@property(nonatomic,retain) NSString* type;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* oprice;
@property(nonatomic,retain) NSString* price;
@property(nonatomic,retain) NSString* desc;
@property(nonatomic,retain) NSArray*  pics;
@property(nonatomic) int like;
@property(nonatomic) int liked;
@property(nonatomic) int comments;
@property(nonatomic) int status;

@end


//查看用户信息
@interface MUseInfo : NSObject
{
    //朋友标志
    int           flag;
    //uid
    int           uid;
    //名字
    NSString*     name;
    //用户头像
    NSString*     pic;
    //最后登录时间
    NSString*     date;
    //距离
    NSString*     loc;
    //图片
    NSArray*      pics;
    NSArray*      pics1;
}
@property(nonatomic)         int       flag;
@property(nonatomic)         int       uid;
@property(nonatomic,retain)  NSString* name;
@property(nonatomic,retain)  NSString* pic;
@property(nonatomic,retain)  NSString* date;
@property(nonatomic,retain)  NSString* loc;
@property(nonatomic,retain)  NSArray*  pics;
@property(nonatomic,retain)  NSArray*  pics1;

@end


//tag
@interface TagInfo : NSObject
{
    //tag
    NSString*  tagName;
    //status
    int        status; //0 uncheck 1 check
}

@property(nonatomic,retain) NSString* tagName;
@property(nonatomic)        int       status;

@end


//消息
@interface Message : NSObject
{
    //消息id
    int  msgid;
    //发送人id
    int fuid;
    //发送人nick
    NSString* fnick;
    //发送人头像
    NSString* fheader;
    //发送人性别
    int fsex;
    //接收人id
    int tuid;
    //接收人nick
    NSString* tnick;
    //接收人头像
    NSString* theader;
    //接收人性别
    int tsex;
    //消息类型
    int type;
    //消息内容
    NSString* msg;
     //发送时间
    NSString* time;
    //loc
    NSString* loc;
    //音频秒数
    int       alen;
    
    //pic
    NSString* pic;//图片大图
    
    //读取
    int    status; //0 未读  1 已读
}

@property(nonatomic)        int msgid;
@property(nonatomic)        int fuid;
@property(nonatomic,retain) NSString* fnick;
@property(nonatomic,retain) NSString* fheader;
@property(nonatomic)        int fsex;
@property(nonatomic)        int tuid;
@property(nonatomic,retain) NSString* tnick;
@property(nonatomic,retain) NSString* theader;
@property(nonatomic)        int tsex;
@property(nonatomic)        int type;
@property(nonatomic,retain) NSString* msg;
@property(nonatomic,retain) NSString* time;
@property(nonatomic,retain) NSString* loc;
@property(nonatomic)        int       alen;
@property(nonatomic,retain) NSString* pic;
@property(nonatomic)        int       status;

@end


//用户消息
@interface UserMessages : NSObject
{
    int             uid;
    NSString*       nick;
    NSString*       header;
    NSMutableArray* msgs;
}

@property(nonatomic)              int       uid;
@property(nonatomic,retain) NSString*       nick;
@property(nonatomic,retain) NSString*       header;
@property(nonatomic,assign) NSMutableArray* msgs;

@end

//消息管理
@interface MessageManager : NSObject
{
    //数据库操作
    sqlite3* db;
    
    //本人uid
    int      uid;
    
    //时间戳
    int      pd;
    //消息列表 UserMessages
    NSMutableArray* users;
    NSMutableDictionary* messages;
}

@property(nonatomic)        int     uid;
@property(nonatomic)        int     pd;
@property(nonatomic,assign) NSMutableArray* users;
@property(nonatomic,assign) NSMutableDictionary* messages;


//打开数据库
-(void)opendb;
//关闭数据库
-(void)closedb;
//创建数据库
-(void)createdb;

//插入一条记录
-(void)insertMessage:(Message*)msg;
//删除一条记录
-(void)removeMessage:(int)type qid:(int)qid;
//获得聊天记录
-(void)getMessages;

//获得未读消息个数
-(int)getUnReadMsgCount:(int)ouid;
//更新消息为已读
-(void)updateReadedMsg:(int)ouid;

//删除指定时间内
-(void)removeMessagesOfDay:(int)day;

//保存时间戳
-(void)saveTimestamp;
//读出时间戳
-(void)loadTimestamp;


@end


//app preference
@interface AppPreference : NSObject
{
    int new_message_alerts;
    NSString* notifications_timing_start;
    NSString* notifications_timing_end;
    int new_selling_alerts;
    int visible_in_market;
}
@property(nonatomic) int new_message_alerts;
@property(nonatomic,retain) NSString* notifications_timing_start;
@property(nonatomic,retain) NSString* notifications_timing_end;
@property(nonatomic) int new_selling_alerts;
@property(nonatomic) int visible_in_market;

@end




