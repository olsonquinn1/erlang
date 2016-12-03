%% @author Quinn
%% @doc @todo Add description to test2.


-module(test2).
-include_lib("eunit/include/eunit.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([sort/1, testlistgen/1, editlist/2, editlist2/3, mergelists/3]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%movest biggest right, reverses list
sortbig(In) ->
	sortbig(In, [], 0).
sortbig([Big, Small | Rest], Out, Swaps) when Big > Small ->
	sortbig([Big | Rest], [Small | Out], Swaps + 1);
sortbig([Small, Big | Rest], Out, Swaps) ->
	sortbig([Big | Rest], [Small | Out], Swaps);
sortbig([Last], Out, Swaps) ->
	sortbig([], [Last | Out], Swaps);
sortbig([], Out, Swaps) ->
	{Out, Swaps}.
%moves smallest right, reverses list
sortsmall(In) ->
	sortsmall(In, [], 0).
sortsmall([Small, Big | Rest], Out, Swaps) when Small < Big ->
	sortsmall([Small | Rest], [Big | Out], Swaps + 1);
sortsmall([Big, Small | Rest], Out, Swaps) ->
	sortsmall([Small | Rest], [Big | Out], Swaps);
sortsmall([Last], Out, Swaps) ->
	sortsmall([], [Last | Out], Swaps);
sortsmall([], Out, Swaps) ->
	{Out, Swaps}.
%alternates sorting between small to right vs big to right, stops when list sorted
sort(List) ->
	sort(sortbig(List), 1).
sort({List, Swaps}, 1) when Swaps > 0->
	sort(sortbig(List), 2);
sort({List, Swaps}, 2) when Swaps > 0->
	sort(sortsmall(List), 1);
sort({List, 0}, 2) ->
	sort(sortsmall(List), 1);
sort({List, 0}, 1) ->
	List.
%unit test
sort_test() ->
	sort_test([testlistgen(20) | [[],[1],[2,1],[3,1,2]]]).
sort_test([A | Tests]) ->
	Correct = lists:sort(A),
	Correct = sort(A),
	sort_test(Tests);
sort_test([]) ->
	ok.
%generates an N long list of lists with a random number(0-10) of random numbers(0-10)				
testlistgen(N) ->
	[[rand:uniform(11)-1 || _ <- lists:seq(0, rand:uniform(11)-2)] || _ <- lists:seq(1, N)].
%applies Function on all the items in List
editlist(Function, List) ->
	[Function(A) || A <- List].
%Applies Function1 to item in List if Function2 returns true for that item
editlist2(Function1, Function2, List) -> 
	editlist2(Function1, Function2, List, []).
editlist2(F1, F2, [L | Ls], Out) ->
	case F2(L) of
		true -> editlist2(F1, F2, Ls, [F1(L) | Out]);
		false -> editlist2(F1, F2, Ls, Out)
	end;
editlist2(_, _, [], Out) ->
	lists:reverse(Out).
%merge two lists sorted by a function
mergelists(L1, L2, Function) ->
	mergelists(L1, L2, Function, []).
mergelists([A | As], [B | Bs], F, Out) ->
	case F(A, B) of
		A -> mergelists([As], [B | Bs], F, [A | Out]);
		B -> mergelists([A | As], [Bs], F, [B | Out])
	end;
mergelists([], [B], F, Out) ->
	mergelists([], [], F, [B | Out]);
mergelists([A], [], F, Out) ->
	mergelists([], [], F, [A | Out]);
mergelists([], [], _, Out) ->
	lists:reverse(Out).
	



				
				
				