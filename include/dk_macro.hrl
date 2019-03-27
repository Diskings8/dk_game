%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2019 15:16
%%%-------------------------------------------------------------------
-author("admin").

-define(true,true).
-define(false,false).
-define(undefined,undefined).
-define(infility,infility).

-define(IF(X,T,F),case X of ?true->T; ?false->F end).


-define(second,         second).
-define(SECONDTIME,     1).
-define(MINUTETIME,     60*?SECONDTIME).
-define(HOURTIME,       60*?MINUTETIME).
-define(DAYTIME,        24*?HOURTIME).