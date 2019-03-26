%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 16:03
%%%-------------------------------------------------------------------
-module(base_goods).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").
-include("data_/data_goods_type.hrl").

-compile(export_all).
%% API
%% {Gid, Num,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}

add_money_goods(?MONEY_TYPE,#give{type = Type,num = Num},Bag)->
	case lists:keyfind(Type,1,Bag) of
		{?NORMAL_MONEY,OldNum}->
			lists:keystore(?NORMAL_MONEY,1,Bag,{?NORMAL_MONEY,OldNum + Num});
		{?GOLD_MONEY,OldNum}->
			lists:keystore(?GOLD_MONEY,1,Bag,{?GOLD_MONEY,OldNum + Num});
		?false->
			lists:keystore(Type,1,Bag,{Type, Num})
	end.
del_money_goods(?MONEY_TYPE,#give{type = Type,num = Num},Bag)->
	case lists:keyfind(Type,1,Bag) of
		{?NORMAL_MONEY,OldNum}->
			lists:keystore(?NORMAL_MONEY,1,Bag,{?NORMAL_MONEY,OldNum - Num});
		{?GOLD_MONEY,OldNum}->
			lists:keystore(?GOLD_MONEY,1,Bag,{?GOLD_MONEY,OldNum - Num});
		?false->
			Bag
	end.
check_money_goods(?MONEY_TYPE,[],_Bag)->
	?true;
check_money_goods(?MONEY_TYPE,[{Type,Num}|T],Bag)->
	case lists:keyfind(Type,1,Bag) of
		{_,OldNum}when OldNum >= Num->
			check_money_goods(?MONEY_TYPE,T,Bag);
		_->
			?false
	end.


add_comsum_goods(?COMSUM_TYPE,#give{gid = Gid,bind = Bind,num = Num},Bag)->
	case lists:keyfind(Gid,1,Bag) of
		?false when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, Num,{Num,[]},{0,[]}});
		?false ->
			lists:keystore(Gid,1,Bag,{Gid, Num,{0,[]},{Num,[]}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind}}when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, OldNum + Num,{IsNum+Num,IsBind},{NoNum,NoBind}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind}}when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, OldNum + Num,{IsNum,IsBind},{NoNum+Num,NoBind}})
	end.

del_comsum_goods(?COMSUM_TYPE,#give{gid = Gid,num = Num},Bag)->
	case lists:keyfind(Gid,1,Bag) of
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind}}when IsNum >= Num->
			lists:keystore(Gid,1,Bag,{Gid, OldNum - Num,{IsNum-Num,IsBind},{NoNum,NoBind}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind}}->
			lists:keystore(Gid,1,Bag,{Gid, OldNum - Num,{0,IsBind},{OldNum - Num,NoBind}})
	end.

check_comsum_goods(?COMSUM_TYPE,[],_Bag)->
	?true;
check_comsum_goods(?COMSUM_TYPE,[{Gid,Num}|T],Bag)->
	case lists:keyfind(Gid,1,Bag) of
		{Gid, OldNum,_,_}when OldNum >= Num->
			check_comsum_goods(?COMSUM_TYPE,T,Bag);
		_->
			?false
	end.

add_property_goods(?PROPERTY_TYPE,#give{gid = Gid,bind = Bind,oid = Oid,num = Num,limittime = LT},Bag)->
	case lists:keyfind(Gid,1,Bag) of
		?false when LT =/= ?infility andalso Num =:= 1 ->
			lists:keystore(Gid,1,Bag,{Gid, Num,{0,[]},{0,[]},{Num,[Oid]}});
		?false when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, Num,{Num,[Oid]},{0,[]},{0,[]}});
		?false ->
			lists:keystore(Gid,1,Bag,{Gid, Num,{0,[]},{Num,[Oid]},{0,[]}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}when LT =/= ?infility->
			lists:keystore(Gid,1,Bag,{Gid, OldNum + Num,{IsNum,IsBind},{NoNum,NoBind},{LimNum+Num,[Oid|Limittime]}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, OldNum + Num,{IsNum+Num,[Oid|IsBind]},{NoNum,NoBind},{LimNum,Limittime}});
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}when Bind=:=?ISBIND->
			lists:keystore(Gid,1,Bag,{Gid, OldNum + Num,{IsNum,IsBind},{NoNum+Num,[Oid|NoBind]},{LimNum,Limittime}});
		_->
			Bag
	end.

del_property_goods(?PROPERTY_TYPE,#give{gid = Gid,oid = Oid,limittime = LT,num = Num},Bag)->
	case lists:keyfind(Gid,1,Bag) of
		{Gid, OldNum,{IsNum,IsBind},{NoNum,NoBind},{LimNum,Limittime}}->
			F =
				fun({N,LL})->
					case lists:member(Oid,LL) of
						?true when LT =/= ?infility->
							{N-1,lists:delete(Oid,LL)};
						?true->
							{N-Num,lists:delete(Oid,LL)};
						?false->
							{N,LL}
					end
				end,
			lists:keystore(Gid,1,Bag,{Gid, OldNum,
				F({IsNum,IsBind}),
				F({NoNum,NoBind}),
				F({LimNum,Limittime})})
	end.

check_property_goods(?PROPERTY_TYPE,[],_Bag)->
	?true;
check_property_goods(?PROPERTY_TYPE,[{Gid,Num}|T],Bag)->
	case lists:keyfind(Gid,1,Bag) of
		{Gid, OldNum,_,_}when OldNum >= Num->
			check_comsum_goods(?COMSUM_TYPE,T,Bag);
		_->
			?false
	end.

