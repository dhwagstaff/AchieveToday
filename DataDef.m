//
//  DataDef.m
//  VSHORE
//
//  Created by Fish on 14-2-19.
//  Copyright (c) 2014年 vshore. All rights reserved.
//

#import "DataDef.h"
#import "StaticTools.h"

@implementation UserInfo

@synthesize type;
@synthesize facebook_id;
@synthesize uid;
@synthesize token;
@synthesize name;
@synthesize email;
@synthesize password;
@synthesize highSchool;
@synthesize college;
@synthesize workPlace;
@synthesize sex;
@synthesize pic;
@synthesize phone;
@synthesize loc1;
@synthesize loc2;
@synthesize loc3;

-(id)init
{
    if (self = [super init])
    {
        type       = 0;
        facebook_id= nil;
        uid        = 0;
        token      = nil;
        name       = nil;
        email      = nil;
        password   = nil;
        highSchool = nil;
        college    = nil;
        workPlace  = nil;
        
        sex        = 0;
        pic        = nil;
        phone      = nil;
        loc1       = nil;
        loc2       = nil;
        loc3       = nil;
    }
    
    return self;
}

-(void)dealloc
{
    [facebook_id release];
    [token release];
    [name release];
    [email release];
    [password release];
    [highSchool release];
    [college release];
    [workPlace release];
    
    [pic release];
    [phone release];
    [loc1 release];
    [loc2 release];
    [loc3 release];
    
    [super dealloc];
}


//保存uid、token、登录类型、email、passwordmd5
-(void)saveUserInfo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:self.uid] forKey:@"uid"];
    [prefs setObject:self.token forKey:@"token"];
}

//载入uid和token 登录类型、email、passwordmd5
-(void)loadUserInfo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.uid   = [[prefs objectForKey:@"uid"] intValue];
    self.token = [prefs objectForKey:@"token"];
}

//清除
-(void)clearUserInfo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"uid"];
    [prefs removeObjectForKey:@"token"];
    
    self.uid = 0;
    self.token = nil;
    self.name = nil;
    self.email = nil;
    
    //删掉fb好友文件
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[StaticTools appDocDir] stringByAppendingPathComponent:@"fb.dat"] error:nil];
}

@end

//好友
@implementation FriendInfo

@synthesize f_id;
@synthesize f_uid;
@synthesize f_name;
@synthesize f_pic;
@synthesize f_phone;

-(id)init
{
    if (self = [super init])
    {
        f_id    = nil;
        f_uid   = 0;
        f_name  = nil;
        f_pic   = nil;
        f_phone = nil;
    }
    
    return self;
}

-(void)dealloc
{
    [f_id release];
    [f_name release];
    [f_pic release];
    [f_phone release];
    
    [super dealloc];
}


@end

//post data
@implementation PostData

@synthesize flag;
@synthesize pic1;
@synthesize pic2;
@synthesize pic3;
@synthesize pic4;
@synthesize title;
@synthesize describe;
@synthesize oprice;
@synthesize lprice;
@synthesize contact;
@synthesize free;
@synthesize swap;
@synthesize pid;

-(id)init
{
    if (self=[super init])
    {
        flag = 0;
        pic1 = nil;
        pic2 = nil;
        pic3 = nil;
        pic4 = nil;
        title = nil;
        describe = nil;
        oprice = nil;
        lprice = nil;
        contact = 0;
        free    = 0;
        swap    = 0;
        pid     = 0;
    }
    return self;
}

-(void)dealloc
{
    [pic1 release];
    [pic2 release];
    [pic3 release];
    [pic4 release];
    [title release];
    [describe release];
    [oprice release];
    [lprice release];
    
    [super dealloc];
}

-(void)clear
{
    self.pic1     = nil;
    self.pic2     = nil;
    self.pic3     = nil;
    self.pic4     = nil;
    self.title    = nil;
    self.describe = nil;
    self.oprice   = nil;
    self.lprice   = nil;
    self.contact  = 0;
    self.free     = 0;
    self.swap     = 0;
    
    self.pid      = 0;
}

@end

@implementation CommentInfo

@synthesize cid;
@synthesize uid;
@synthesize name;
@synthesize pic;
@synthesize date;
@synthesize msg;
@synthesize like;

-(id)init
{
    if (self = [super init])
    {
        cid  = 0;
        uid  = 0;
        name = nil;
        pic  = nil;
        date = nil;
        msg  = nil;
        like = 0;
    }
    return self;
}

-(void)dealloc
{
    [name release];
    [pic release];
    [date release];
    [msg release];
    
    [super dealloc];
}

@end


@implementation ItemInfo

@synthesize pid;
@synthesize uid;
@synthesize name;
@synthesize pic;
@synthesize date;
@synthesize type;
@synthesize title;
@synthesize oprice;
@synthesize price;
@synthesize desc;
@synthesize pics;
@synthesize liked;
@synthesize like;
@synthesize comments;
@synthesize status; //0 selling 1 sold 2 expired 3 delete

-(id)init
{
    if (self = [super init])
    {
        pid   = 0;
        uid   = 0;
        name  = nil;
        pic   = nil;
        date  = nil;
        type  = nil;
        title = nil;
        oprice= nil;
        price = nil;
        desc  = nil;
        pics  = nil;
        like  = 0;
        comments = 0;
        status= 0;
    }
    
    return self;
}

-(void)dealloc
{
    [name release];
    [pic release];
    [date release];
    [type release];
    [title release];
    [oprice release];
    [price release];
    [desc release];
    [pics release];
    
    [super dealloc];
}

@end


//用户数据
@implementation MUseInfo

@synthesize flag;
@synthesize uid;
@synthesize name;
@synthesize pic;
@synthesize date;
@synthesize loc;
@synthesize pics;
@synthesize pics1;

-(id)init
{
    if (self = [super init])
    {
        flag = 0;
        uid  = 0;
        name = nil;
        pic  = nil;
        date = nil;
        loc  = nil;
        pics = nil;
        pics1= nil;
    }
    
    return self;
}

-(void)dealloc
{
    [name release];
    [pic release];
    [date release];
    [loc release];
    [pics release];
    [pics1 release];
    
    [super dealloc];
}

@end


@implementation TagInfo

@synthesize tagName;
@synthesize status;

-(id)init
{
    if (self = [super init])
    {
        tagName = nil;
        status  = 0;
    }
    return self;
}

-(void)dealloc
{
    [tagName release];
    [super dealloc];
}

@end


@implementation Message

@synthesize msgid;
@synthesize fuid;
@synthesize fnick;
@synthesize fheader;
@synthesize fsex;
@synthesize tuid;
@synthesize tnick;
@synthesize theader;
@synthesize tsex;
@synthesize type;
@synthesize msg;
@synthesize time;
@synthesize loc;
@synthesize alen;
@synthesize pic;
@synthesize status;

-(id)init
{
    if (self = [super init])
    {
        fnick   = nil;
        fheader = nil;
        tnick   = nil;
        theader = nil;
        msg     = nil;
        time    = nil;
        loc     = nil;
        pic     = nil;
        status  = 0;
    }
    
    return self;
}

-(void)dealloc
{
    [fnick release];
    [fheader release];
    [tnick release];
    [theader release];
    [msg release];
    [time release];
    [loc release];
    [pic release];
    
    [super dealloc];
}

@end


//用户消息
@implementation UserMessages

@synthesize uid;
@synthesize nick;
@synthesize header;
@synthesize msgs;

-(id)init
{
    if (self = [super init])
    {
        nick   = nil;
        header = nil;
        msgs   = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(void)dealloc
{
    [nick release];
    [header release];
    [msgs release];
    
    [super dealloc];
}

@end

//消息管理类
@implementation MessageManager

@synthesize uid;
@synthesize pd;
@synthesize users;
@synthesize messages;

-(id)init
{
    if (self = [super init])
    {
        uid = 0;
        pd  = 0;
        users = [[NSMutableArray alloc] init];
        messages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [users release];
    [messages release];
    
    [super dealloc];
}

//打开数据库
-(void)opendb
{
	//获取文件路径
	NSString *path = [[StaticTools appDocDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"msg_%d.db",uid]];
	
	//判断数据库文件是否存在
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:path];
		
    //直接打开数据
    if (sqlite3_open([path UTF8String],&db) != SQLITE_OK)
    {
        sqlite3_close(db);
        return;
    }
    
    //如果文件不存在
    if (!find)
    {
        //创建表格
        [self createdb];
    }
}

//关闭数据库
-(void)closedb
{
    sqlite3_close(db);
}

//创建数据库
-(void)createdb
{
    //消息id msgid;
    //发送人id fuid;
    //发送人nick fnick;
    //发送人头像 fheader;
    //发送人性别 fsex;
    //接收人id tuid;
    //接收人nick tnick;
    //接收人头像 theader;
    //接收人性别 tsex;
    //消息内容 msg;
    //音频文件url afile;
    //音频时间长度 asec;
    //图片url pfile
    //发送时间 time;
    //loc
    
	char* msg_sql = "CREATE TABLE messages(msgid integer, fuid integer, fnick text,fheader text, fsex integer, tuid integer, tnick text, theader text, tsex integer, type integer, msg text, time text, loc text, pic text, alen int, status int)";
	sqlite3_stmt* statement;
	if (sqlite3_prepare_v2(db,msg_sql,-1,&statement,nil) != SQLITE_OK)
	{
        [self closedb];
        return;
	}
    
	int success = sqlite3_step(statement);
	sqlite3_finalize(statement);
	if (success != SQLITE_DONE)
	{
		[self closedb];
	}
}

//插入一条记录
-(void)insertMessage:(Message*)msg
{
	//执行SQL语句
	NSString* sql_format = @"INSERT INTO messages(msgid,fuid,fnick,fheader,fsex,tuid,tnick,theader,tsex,type,msg,time,loc,pic,alen,status) VALUES(%d,%d,'%@','%@', %d,%d,'%@','%@',%d, %d,'%@','%@','%@','%@',%d, 0)";

	NSString* sql = [NSString stringWithFormat:sql_format,
                     msg.msgid,
                     msg.fuid,
                     msg.fnick,
                     msg.fheader,
                     msg.fsex,
                     msg.tuid,
                     msg.tnick,
                     msg.theader,
                     msg.tsex,
                     msg.type,
                     msg.msg,
                     msg.time,
                     (msg.loc==nil)?@"":msg.loc,
                     msg.pic,
                     msg.alen];
	
	char* errorMsg;
	if (sqlite3_exec(db, [sql UTF8String], nil ,nil, &errorMsg) != SQLITE_OK)
	{
		[self closedb];
	}
}

//删除记录
-(void)removeMessage:(int)type qid:(int)qid
{
	//执行SQL语句
	NSString* sql_str = @"DELETE FROM messages WHERE ";
    
    if (type == 1)
        sql_str = [NSString stringWithFormat:@"%@ fuid = %d OR tuid = %d",sql_str, qid, qid];
    else
        sql_str = [NSString stringWithFormat:@"%@ msgid = %d",sql_str, qid];
    
	char* errorMsg;
	if (sqlite3_exec(db, [sql_str UTF8String], nil ,nil, &errorMsg) != SQLITE_OK)
	{
		[self closedb];
	}
}

//删除指定时间内
-(void)removeMessagesOfDay:(int)day
{
    NSDate* date = [NSDate date];
    NSTimeInterval a_day = -24*60*60*day;
    NSDate *querydate = [date addTimeInterval: a_day];
    
    //显示时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:querydate];
    [dateFormatter release];

    // OutLog(@"%d days %@",day,dateString);
    
    NSString* sql_str = [NSString stringWithFormat:@"DELETE FROM messages WHERE time < '%@'", dateString];
    
	char* errorMsg;
	if (sqlite3_exec(db, [sql_str UTF8String], nil ,nil, &errorMsg) != SQLITE_OK)
	{
		[self closedb];
	}
}

//获得未读消息个数
-(int)getUnReadMsgCount:(int)ouid
{
    //获取聊天记录数据
    //NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM messages WHERE status = 0 AND (fuid = %d OR tuid = %d)", ouid, ouid];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM messages WHERE status = 0 AND fuid = %d", ouid];
    
	sqlite3_stmt* statement = nil;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) != SQLITE_OK)
	{
		return 0;
	}
    int count = 0;
	//从结果集合获取记录
	if (sqlite3_step(statement) == SQLITE_ROW)
    {
        count = sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    return count;
}

//更新消息为已读
-(void)updateReadedMsg:(int)ouid
{
    NSString* sql_str = [NSString stringWithFormat:@"UPDATE  messages SET status = 1 WHERE fuid = %d OR  tuid = %d", ouid, ouid];
    
	char* errorMsg;
	if (sqlite3_exec(db, [sql_str UTF8String], nil ,nil, &errorMsg) != SQLITE_OK)
	{
		[self closedb];
	}
}


//获得聊天记录
-(void)getMessages
{
    [users removeAllObjects];
    [messages removeAllObjects];
    
	//获取聊天记录数据
    NSString* sql = @"SELECT msgid,fuid,fnick,fheader,fsex,tuid,tnick,theader,tsex,type,msg,time,loc,pic,alen FROM messages order by time";
    
	sqlite3_stmt* statement = nil;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) != SQLITE_OK)
	{
		return;
	}
	//从结果集合获取记录
	while (sqlite3_step(statement) == SQLITE_ROW)
    {
        //消息id msgid;
        int msgid = sqlite3_column_int(statement, 0);
        //发送人id fuid;
        int fuid  = sqlite3_column_int(statement, 1);
        //发送人nick fnick;
        char* fnick = (char*)sqlite3_column_text(statement, 2);
        //发送人头像 fheader;
        char* fheader = (char*)sqlite3_column_text(statement, 3);
        //发送人性别 fsex;
        int fsex = sqlite3_column_int(statement, 4);
        //接收人id tuid;
        int tuid = sqlite3_column_int(statement, 5);
        //接收人nick tnick;
        char* tnick = (char*)sqlite3_column_text(statement, 6);
        //接收人头像 theader;
        char* theader = (char*)sqlite3_column_text(statement, 7);
        //接收人性别 tsex;
        int tsex = sqlite3_column_int(statement, 8);
        //消息类型 type
        int type = sqlite3_column_int(statement, 9);
        //消息内容 msg;
        char* msg = (char*)sqlite3_column_text(statement, 10);
        //发送时间 time;
        char* time = (char*)sqlite3_column_text(statement, 11);
        //loc
        char* loc = (char*)sqlite3_column_text(statement, 12);
        //pic
        char* pic = (char*)sqlite3_column_text(statement, 13);
        //alen
        int   alen = sqlite3_column_int(statement, 14);
        
        //判断是否存在聊天记录
        int query_uid = 0;
        NSString* query_nick = nil;
        NSString* query_header = nil;
        if(fuid != self.uid)
        {
            query_uid = fuid;
            if(fnick)   query_nick   = [NSString stringWithUTF8String:fnick];
            if(fheader) query_header = [NSString stringWithUTF8String:fheader];
        }
        else if (tuid != self.uid)
        {
            query_uid = tuid;
            if(tnick)   query_nick   = [NSString stringWithUTF8String:tnick];
            if(theader) query_header = [NSString stringWithUTF8String:theader];
        }
        
        UserMessages* user_message = (UserMessages*)[messages objectForKey:[NSNumber numberWithInt:query_uid]];
        //判断是否存在
        if(user_message == nil)
        {
            //[users addObject:[NSNumber numberWithInt:query_uid]];
            [users insertObject:[NSNumber numberWithInt:query_uid] atIndex:0];
            
            user_message = [[UserMessages alloc] init];
            
            user_message.uid    = query_uid;
            user_message.nick   = query_nick;
            user_message.header = query_header;
            
            [messages setObject:user_message forKey:[NSNumber numberWithInt:query_uid]];
            [user_message release];
        }
        
        Message* message = [[Message alloc] init];
        
        message.msgid = msgid;
        message.fuid  = fuid;
        if(fnick)   message.fnick   = [NSString stringWithUTF8String:fnick];
        if(fheader) message.fheader = [NSString stringWithUTF8String:fheader];
        message.fsex = fsex;
        message.tuid = tuid;
        if(tnick)   message.tnick   = [NSString stringWithUTF8String:tnick];
        if(theader) message.theader = [NSString stringWithUTF8String:theader];
        message.tsex = tsex;
        message.type = type;
        if(msg)   message.msg    = [NSString stringWithUTF8String:msg];
        if(time)  message.time   = [NSString stringWithUTF8String:time];
        if(loc)   message.loc    = [NSString stringWithUTF8String:loc];
        if(pic)   message.pic    = [NSString stringWithUTF8String:pic];
        message.alen = alen;
        
        [user_message.msgs addObject:message];
        [message release];
	}
	sqlite3_finalize(statement);
}

//保存时间戳
-(void)saveTimestamp
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:self.pd] forKey:[NSString stringWithFormat:@"msgtime-%d",uid]];
}

//读出时间戳
-(void)loadTimestamp
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* _pd = [prefs objectForKey:[NSString stringWithFormat:@"msgtime-%d",uid]];
    self.pd = [_pd intValue];
}


@end


@implementation AppPreference

@synthesize new_message_alerts;
@synthesize notifications_timing_start;
@synthesize notifications_timing_end;
@synthesize new_selling_alerts;
@synthesize visible_in_market;

-(id)init
{
    if (self = [super init])
    {
        notifications_timing_start = nil;
        notifications_timing_end   = nil;
    }
    
    return self;
}

-(void)dealloc
{
    [notifications_timing_start release];
    [notifications_timing_end release];
    
    [super dealloc];
}

@end




