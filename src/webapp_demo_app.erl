%%%-------------------------------------------------------------------
%% @doc webapp_demo public API
%% @end
%%%-------------------------------------------------------------------
-module(webapp_demo_app).

-behavior(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch =
        cowboy_router:compile([
            {'_', [{"/", cowboy_static, {priv_file, webapp_demo_app, "index.html"}},
                   {"/websocket", webapp_demo_handler, []},
                   {"/static/[...]", cowboy_static, {priv_dir, websocket, "static"}}]}]),
    {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{env => #{dispatch => Dispatch}}),
    webapp_demo_sup:start_link().

stop(_State) ->
    ok.

%% Internal functions
