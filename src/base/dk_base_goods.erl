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
	find_by_gid(Gid,BagList,[],[]).
find_by_gid(Gid,[#goods{gid = Gid}=H|T],SumList,RemoveList)->
	find_by_gid(Gid,T,[H|SumList],RemoveList);
find_by_gid(Gid,[H|T],SumList,RemoveList)->
	find_by_gid(Gid,T,SumList,[H|RemoveList]);
find_by_gid(_Gid,[],SumList,RemoveList)->
	{SumList,RemoveList}.



add_good(Give,Bag)->                                                %%添加一个物品
	add_goods([Give],Bag).
add_goods([],Bag)->
	Bag;
add_goods([#give{type = ?EQUIP_TYPE}=H|T],Bag)->                    %%添加一列表物品
	Oid     = dk_lib_index:get_index(),
	Good    = give_to_good(H),
	Good1   = Good#goods{oid = Oid,maxnum = 1},
	NewBag  = [Good1|Bag],
	add_goods(T,NewBag);
add_goods([#give{gid = Gid,num = Num}=H|T],Bag)->
	Good    = give_to_good(H),
	{GidList,RemoveList}    = find_by_gid(Gid,Bag),
	{AddList,LeastList}     = add_to_bag(Good,Num,[],GidList),
	NewBag  = lists:merge3(AddList,LeastList,RemoveList),
	add_goods(T,NewBag);
add_goods([],Bag)->
	Bag.

add_to_bag(_G,0,PartAdd,PartBag)->                                  %%添加数量为 0 时
	{PartAdd,PartBag};
add_to_bag(#goods{endtime = 0,maxnum = MN}=G,Num,PartAdd,PartBag)-> %%添加物品为限时物品，单独一个位置
	case Num =< MN of
		?true->
			{[G#goods{curnum = Num}|PartAdd],PartBag};
		?false->
			add_to_bag(G,Num - MN,[G#goods{curnum = Num}|PartAdd],PartBag)
	end;
add_to_bag(#goods{maxnum = MN}=G,MN,PartAdd,PartBag)->              %%添加一个上限数量的物品时
	{[G#goods{curnum = MN}|PartAdd],PartBag};
add_to_bag(#goods{maxnum = MN}=G,Num,PartAdd,PartBag)when Num > MN->       %%添加一个超过上限数量的物品时
	add_to_bag(G,Num-MN,[G#goods{curnum = MN}|PartAdd],PartBag);
add_to_bag(G,Num,PartAdd,[])->                                             %%添加一个小额数量但是没有候选物品集时
	{[G#goods{curnum = Num}|PartAdd],[]};
add_to_bag(#goods{maxnum = MN}=G,Num,PartAdd,[#goods{curnum = CN}=H|T])->   %%添加一个没超过上限数量的物品时
	case CN + Num =< MN of
		?true->
			{[H#goods{curnum = CN + Num}|PartAdd],T};
		?false->
			add_to_bag(G,Num - MN,[H#goods{curnum = Num}|PartAdd],T)
	end.

del_good(Cost,Bag)->
	del_goods([Cost],Bag).

del_goods([],Bag)->
	Bag;
del_goods([#cost{oid = Oid,type = ?EQUIP_TYPE}|TCosts],Bag)->
	case del_by_oid(Oid,Bag) of
		?false->
			{?false,"don't hvae this goods"};
		NewBag->
			del_goods(TCosts,NewBag)
	end;
del_goods([#cost{gid = Gid,num = Num}=C|TCost],Bag)->
	{GidList,OtherList} = find_by_gid(Gid,Bag),
	{IB,NB,LTB} = filter(GidList,{[],[],[]}),
	{N1,L1} = del_limittime(C,Num,LTB),
	{N2,L2} = del_bind(C,N1,IB),
	{N3,L3} = del_bind(C,N2,NB),
	NewList = lists:merge3(L1,L2,L3),
	case N3 =< 0 of
		?true->
			del_goods(TCost,lists:merge(OtherList,NewList));
		?false->
			{?false,"not enough to cost this goods"}
	end.

del_limittime(_,0,LTB)->
	{0,LTB};
del_limittime(_C,Num,LTB)when length(LTB) < Num->
	{Num,LTB};
del_limittime(#cost{gid = Gid},Num,LTB)->
	NewList = dk_util_list:delete(Gid,Num,LTB),
	{0,NewList}.

del_bind(_,0,IB)->
	{0,IB};
del_bind(_C,Num,[#goods{curnum = CN}=H|TIB])when CN > Num->
	{0,[H#goods{curnum = CN -Num}|TIB]};
del_bind(_C,CN,[#goods{curnum = CN}|TIB])->
	{0,TIB};
del_bind(_C,Num,[#goods{curnum = CN}|TIB])->
	del_bind(_C,Num - CN,TIB).

del_nobind(_,0,NB)->
	{0,NB};
del_nobind(_C,Num,[#goods{curnum = CN}=H|TNB])when CN > Num->
	{0,[H#goods{curnum = CN -Num}|TNB]};
del_nobind(_C,CN,[#goods{curnum = CN}|TNB])->
	{0,TNB};
del_nobind(_C,Num,[#goods{curnum = CN}|TNB])->
	del_nobind(_C,Num - CN,TNB).

	
filter([],{IB,NB,LTB})->
	{IB,NB,LTB};
filter([#goods{bind = Bind,endtime = LT}=H|T],{IB,NB,LTB})->
	case LT of
		?infility when Bind =:= ?ISBIND->
			filter(T,{[H|IB],NB,LTB});
		?infility when Bind =:= ?NOBIND->
			filter(T,{IB,[H|NB],LTB});
		_->
			filter(T,{IB,NB,[H|LTB]})
	end.


give_to_good(#give{gid = Gid,bind = Bind,limittime = LT})->
	#goods{bind = ABind}=Good = dk_data_goods:get(Gid),
	Good1 = ?IF(Bind > ABind,Good#goods{bind = Bind},Good),
	Good2 = Good1#goods{createtime = dk_util_time:get_system_time()},
	Good3 = ?IF(LT =:= 0,Good2#goods{endtime = ?infility},Good2#goods{endtime = 0}),
	Good3.