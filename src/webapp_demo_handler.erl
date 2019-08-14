-module(webapp_demo_handler).

-export([init/2]).
-export([websocket_init/1,
         websocket_handle/2,
         websocket_info/2]).


init(Req, Opts) ->
    {cowboy_websocket, Req, Opts}.


websocket_init(State) ->
    erlang:start_timer(1000, self(), <<"Hello!">>),
    {ok, State}.

websocket_handle({text, Msg}, State) ->
    lager:debug("Got Data: ~p", [Msg]),
    {reply, {text, <<"That's what she said!", Msg/binary>>}, State};
websocket_handle(Data, State) ->
    lager:debug("Got unexpected data: ~p", [Data]),
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
    erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, State};
websocket_info(Info, State) ->
    lager:debug("Got unexpected info: ~p", [Info]),
    {ok, State}.
