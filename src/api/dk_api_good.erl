%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 17:27
%%%-------------------------------------------------------------------
-module(dk_api_good).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").
-include("data_/data_goods_type.hrl").

%% API
-export([]).
-compile(export_all).



add_good(Give,Opt,Bag)->
	add_goods([Give],Opt,Bag).
add_goods(Gives,_Opt,#bag{goodlist = GL,maxsize = MS,extrasize = ES}=Bag)->
	NewGL   = dk_base_goods:add_goods(Gives,GL),
	Len1    = length(NewGL),
	?IF(Len1 =< MS + ES,Bag#bag{goodlist = NewGL,cursize = Len1},Bag).      %%保留对超越包容量的操作参数，尚不处理

del_good(Cost,Bag)->
	del_goods([Cost],Bag).
del_goods(Costs,#bag{goodlist = GL}=Bag)->
	case dk_base_goods:del_goods(Costs,GL) of
		{?false,_}->
			{?false,Bag};
		NewGL->
			Len1 = length(NewGL),
			{?true,Bag#bag{goodlist = NewGL,cursize = Len1}}
	end.

del_oid(Oid,#bag{goodlist = GL}=Bag)->
	case dk_base_goods:del_by_oid(Oid,GL) of
		?false->
			{?false,Bag};
		NewGL->
			Len1 = length(NewGL),
			{?true,Bag#bag{goodlist = NewGL,cursize = Len1}}
	end.