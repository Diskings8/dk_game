%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 三月 2019 15:43
%%%-------------------------------------------------------------------
-module(dk_util_server).
-author("admin").
-include("dk_record.hrl").

%% API
%-export([]).
-compile(export_all).

set_server_id(Server,ID)->
	Server#server{serverid = ID}.

get_server_id(#server{serverid = ID}=_Server)->
	ID.