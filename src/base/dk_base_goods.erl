%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 16:03
%%% Modified : <hzh> make sure the unit part at first
%%%-------------------------------------------------------------------
-module(dk_base_goods).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").
-include("data_/data_goods_type.hrl").

-compile(export_all).
%% API
%% {Gid, Num,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}

find_by_oid(Oid,BagList)->
	lists:keyfind(Oid,#goods.oid,BagList).

%%-spec del_by_oid(Oid,BagList) -> {value,Good,NewBagList}when
%%	Oid  :: integer(),
%%	BagList  :: [#goods{}],
%%	NewBagList :: [#goods{}],
%%	Good   :: #goods{}.

del_by_oid(Oid,BagList)->
	lists:keytake(Oid,#goods.oid,BagList).

find_by_gid(Gid,BagList)->
	find_by_gid(Gid,BagList,[]).
find_by_gid(Gid,[#goods{gid = Gid}=H|T],SumList)->
	find_by_gid(Gid,T,[H|SumList]);
find_by_gid(Gid,[_|T],SumList)->
	find_by_gid(Gid,T,SumList);
find_by_gid(_Gid,[],SumList)->
	SumList.


add_good(Good,Bag)->
	add_goods([Good],Bag).

add_goods([#give{type = ?EQUIP_TYPE}=H|T],Bag)->
	Oid = dk_lib_index:get_index(),
	Good = give_to_good(H),
	Good1 = Good#goods{oid = Oid},
	NewBag = add_to_bag(Good1,Bag),
	add_goods(T,NewBag);
add_goods([H|T],Bag)->
	Good = give_to_good(H),
	NewBag =add_to_bag(Good,Bag),
	add_goods(T,NewBag);
add_goods([],Bag)->
	Bag.

add_to_bag(Good,Bag)->
	IsBind =[],
	NoBind =[],
	IsLT   =[],
	add_to_bag(Good,Bag,IsBind,NoBind,IsLT).
add_to_bag(G,B,A1,B1,C1)->
	{G,B,A1,B1,C1}.



give_to_good(#give{gid = Gid,bind = Bind,limittime = LT})->
	#goods{bind = ABind}=Good = dk_data_goods:get(Gid),
	Good1 = ?IF(Bind > ABind,Good#goods{bind = Bind},Good),
	Good2 = Good1#goods{createtime = dk_util_time:get_system_time()},
	Good3 = ?IF(LT =:= 0,Good2#goods{endtime = ?infility},Good2#goods{endtime = 0}),
	Good3.