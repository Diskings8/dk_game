%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 15:59
%%%-------------------------------------------------------------------
-module(dk_api_bag).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").
-include("data_/data_goods_type.hrl").

%% API
-export([]).
-compile(export_all).

add_good(BagType,Good,Reason,Player)when is_tuple(Good)->
	add_goods(BagType,[Good],Reason,Player).


add_goods(_BagType,_GoodsList,_Reason,Player)when is_list(_GoodsList)->
	Player.



del_good(BagType,Good,Reason,Player)when is_tuple(Good)->
	del_goods(BagType,[Good],Reason,Player).


del_goods(_BagType,_GoodsList,_Reason,Player)when is_list(_GoodsList)->
	Player.

find_good(BagType,Good,Player)when is_integer(Good)->
	find_goods(BagType,[Good],Player).

find_goods(_BagType,GoodsList,Player) when is_list(GoodsList)->
	Player.



