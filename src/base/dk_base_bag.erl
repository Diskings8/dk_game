%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 14:31
%%%-------------------------------------------------------------------
-module(dk_base_bag).
-author("admin").

-include("dk_macro.hrl").
-include("dk_record.hrl").

%% API
-export([]).
-compile(export_all).

init_bag(Type,OldBag)->
	case maps:is_key(Type,OldBag)of
		?true->
			OldBag;
		?false->
			TypeBag = dk_data_bag_type:get(Type),
			OldBag#{Type =>TypeBag}
	end.

get_type_bag(Type,OldBag)->
	case maps:get(Type,OldBag,?undefined)of
		TypeBag when is_record(TypeBag,bag)->
			TypeBag;
		_->
			?undefined
	end.

set_type_bag(Type,#bag{}=TBag,OldBag)->
	NewBag = maps:put(Type,TBag,OldBag),
	NewBag.
	
