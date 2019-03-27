%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 三月 2019 14:17
%%%-------------------------------------------------------------------
-module(dk_lib_index).
-author("admin").

%% API
-export([]).
-compile(export_all).
get_index()->
	ServerID = 0,
	Index = dk_util_time:get_system_time() * 1000 + ServerID ,
	Index.

get_index_server(Index)->
	Index rem 1000 .