% pex5.pl
% USAFA UFO Sightings 2024
%
% name: Zachary Poupart
%
% Documentation: I used large chunks from our HW7 as a jumping off point in my code
%				I discussed at points with Will Lockhart how to get the days in order,
%				but we ended up implementing different ideas. No other resources to document
%
% The query to get the answer(s) or that there is no answer:
% ?- solve.

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

cadet(smith).
cadet(garcia).
cadet(jones).
cadet(chen).

object(balloon).
object(kite).
object(fighter).
object(cloud).

solve :-
    % Pick a unique day for each cadet
    day(SmithDay), day(GarciaDay), day(JonesDay), day(ChenDay),
    all_different([SmithDay, GarciaDay, JonesDay, ChenDay]),

    % Pick a unique object for each cadet
    object(SmithObject), object(GarciaObject),
    object(JonesObject), object(ChenObject),
    all_different([SmithObject, GarciaObject, JonesObject, ChenObject]),

    Triples = [ [smith,  SmithDay,  SmithObject],
                [garcia, GarciaDay, GarciaObject],
                [jones,  JonesDay,  JonesObject],
                [chen,   ChenDay,   ChenObject] ],

    % 1. C4C Smith did not see a weather balloon, nor kite.
    \+ member([smith, _, balloon], Triples),
    \+ member([smith, _, kite], Triples),

    % 2. The one who saw the kite isn’t C4C Garcia.
    \+ member([garcia, _, kite], Triples),

    % 3. Friday’s sighting was made by either C4C Chen
    %    or the one who saw the fighter aircraft.
    (member([chen, friday, _], Triples); 
    member([_,   friday, fighter], Triples)),

    % 4. The kite was not sighted on Tuesday.
    \+ member([_, tuesday, kite], Triples),

    % 5. Neither C4C Garcia nor C4C Jones saw the weather balloon.
    \+ member([garcia, _, balloon], Triples),
    \+ member([jones,  _, balloon], Triples),

    % 6. C4C Jones did not make their sighting on Tuesday.
    \+ member([jones, tuesday, _], Triples),

    % 7. C4C Smith saw an object that turned out to be a cloud.
    member([smith, _, cloud], Triples),

    % 8. The fighter aircraft was spotted on Friday.
    member([_, friday, fighter], Triples),

    % 9. The weather balloon was not spotted on Wednesday.
    \+ member([_, wednesday, balloon], Triples),
    
    tell_day_order(tuesday, Triples),
    tell_day_order(wednesday, Triples),
    tell_day_order(thursday, Triples),
    tell_day_order(friday, Triples).
    

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell_day_order(Day, Triples) :-
		member([Cadet, Day, Object], Triples),
    	tell(Cadet, Day, Object).

tell(X, Y, Z) :-
    write(': C4C '), write(X), write(' saw the '), write(Z), write(' on '), write(Y), write('.'), nl.
