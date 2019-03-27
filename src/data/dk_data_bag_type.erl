%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 15:26
%%%-------------------------------------------------------------------
-module(dk_data_bag_type).
-author("admin").

-include("dk_record.hrl").
-include("dk_macro.hrl").
-include("data_/data_bag_type.hrl").

%% API
-export([]).
-compile(export_all).


get(10)->
	#bag{
		type        = ?EQUIPMENT,
		goodlist    = [],
		extrasize   = 0,
		ext         = #{}
	}.