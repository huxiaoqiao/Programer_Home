//
//  FavoriteModel.h
//  Programer_Home
//
//  Created by 胡晓桥 on 14-7-2.
//  Copyright (c) 2014年 胡晓桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject
@property int objid;
@property int type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@end
/*
 <oschina>
 <pagesize>3</pagesize>
 <favorites>
 <favorite>
 <objid>159718</objid>
 <type>2</type>
 <title><![CDATA[我的算法学习之路]]></title>
 <url><![CDATA[http://www.oschina.net/question/587367_159718]]></url>
 </favorite>
 <favorite>
 <objid>159648</objid>
 <type>2</type>
 <title><![CDATA[一个程序员如何快速赚到一百万？]]></title>
 <url><![CDATA[http://www.oschina.net/question/587361_159648]]></url>
 </favorite>
 <favorite>
 <objid>159365</objid>
 <type>2</type>
 <title><![CDATA[程序员必须知道的10大基础实用算法及其讲解]]></title>
 <url><![CDATA[http://www.oschina.net/question/1397765_159365]]></url>
 </favorite>
 </favorites>
 <notice>
 <atmeCount>0</atmeCount>
 <msgCount>0</msgCount>
 <reviewCount>0</reviewCount>
 <newFansCount>0</newFansCount>
 </notice>
 </oschina>
 
 */