%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 三月 2019 15:23
%%%-------------------------------------------------------------------
-module(dk_util_list).
-author("admin").

%% API
-export([]).
-compile(export_all).

delete(_Elem,0,List)->
	List;
delete(Elem,Num,List)->
	NewList = lists:delete(Elem,List),
	delete(Elem,Num-1,NewList).