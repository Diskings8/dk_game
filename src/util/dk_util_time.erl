%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 三月 2019 14:20
%%%-------------------------------------------------------------------
-module(dk_util_time).
-author("admin").

%% API
%-export([]).
-compile(export_all).

%% get function
get_system_time()->
	erlang:system_time().

get_system_time_micsec()->
	erlang:system_time(microsecond).

get_timestamp()->
	erlang:timestamp().

get_now()->
	erlang:now().


