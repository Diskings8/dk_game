%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 17:27
%%%-------------------------------------------------------------------
-module(dk_good_api).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").
-include("data_/data_goods_type.hrl").

%% API
-export([]).
-compile(export_all).


add_goods([],Bag)->
	Bag;
add_goods([#give{type = Type}|T],Bag)->
	NewBag =
		case Type div 10 of
			?EQUIP_TYPE->
				?true;
			?MONEY_TYPE->
				?true;
			?COMSUM_TYPE->
				?true;
			?PROPERTY_TYPE->
				?true;
			_->
				Bag
		end,
	add_goods(T,NewBag).
