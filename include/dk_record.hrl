%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 14:51
%%%-------------------------------------------------------------------
-author("admin").
-include("dk_macro.hrl").


-record(player,{
	accountid   = 0,        %%账号ID
	uuid        = 0,        %%角色ID
	rote        = 0,        %%角色类型
	bag         = #{},      %%背包
	apperance   = #{},      %%外观
	rat         = #{},      %%属性
	ext         = #{}
}).
-record(server,{
	serverid    = 0,
	servername  = << >>
}).

-record(bag,{
	type        ,
	goodlist    = [],
	extrasize   = 0,
	cursize     = 0,
	maxsize     = 1,
	ext         = #{}
}).

-record(goods,{
	gid         ,
	oid         ,
	type        = ?undefined,
	bind        = 0,
	curnum      = 0,
	maxnum      = 1,
	rat         = #{},
	createtime  ,   %%时效性
	endtime     ,
	describe
}).
-record(give,{
	gid         ,
	bind        = 0,
	oid         ,
	type        = ?undefined,
	num         = 0,
	limittime
}).
-record(cost,{
	gid        ,
	oid         ,
	type        = ?undefined,
	num         = 0
}).