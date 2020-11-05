structure M = BinaryMapFn(struct 
				type ord_key = int * int
				 fun compare ((i1,i2),(j1,j2)) = 
                                	 case (Int.compare (i1,j1))
                                 		of EQUAL => Int.compare (i2,j2)
							| v => v	
				end);

fun doomsday file = 
	let			
		fun readchar input = TextIO.input1 input
		val inStream = TextIO.openIn file
		val q = Queue.mkQueue () : (char * int * int * int) Queue.queue 		
		val pos_grid = Array2.array (1000,1000, false)
		val neg_grid = Array2.array (1000,1000, false)

		fun read map (x,y) =
			let
				val elem=readchar inStream
			in 
				if elem= SOME #"." then read (M.insert (map, (x,y), #".")) (x,y+1)
				else if elem= SOME #"+" then (Array2.update (pos_grid,x,y,true); Queue.enqueue (q,(#"+",x,y,0)); read (M.insert (map, (x,y), #"+")) (x,y+1))
				else if elem= SOME #"-" then (Array2.update (neg_grid,x,y,true); Queue.enqueue (q,(#"-",x,y,0)); read (M.insert (map, (x,y), #"-")) (x,y+1))
				else if elem= SOME #"X" then read (M.insert (map, (x,y), #"X")) (x,y+1)
				else if elem= SOME #"\n" then read map (x+1,0)
				else map
			end			

		fun symbol_to_mark s1 s2 = 
			if (s1= #"-" andalso (s2= #"." orelse s2= #"-")) then #"-"
			else if (s1= #"+" andalso (s2= #"." orelse s2= #"+")) then #"+"
			else #"*"
	
		fun final map doomsday time 1 = map
		    | final map doomsday time break = 
			let
				
				val dq = Queue.dequeue q
		                val c = #1dq
                		val x = #2dq
                		val y = #3dq
                		val t = #4dq
				
				val elem = Option.valOf(M.find(map,(x,y)))
				val left = M.find(map,(x,y-1))
				val up = M.find(map,(x-1,y))
				val right = M.find(map,(x,y+1))
				val down = M.find(map,(x+1,y))

			in 	
				if ((doomsday=1) andalso (t>time)) then (print (Int.toString time);print "\n"; final map 1 time 1)
				
				else if ((doomsday=1) andalso (Queue.isEmpty q)) then (print (Int.toString time);print "\n"; final (M.insert(map,(x,y), symbol_to_mark c elem)) 1 time 1)

				else if ((c= #"+" andalso (elem= #"-" orelse elem= #"*")) orelse (c= #"-" andalso (elem= #"+" orelse elem= #"*"))) 
					then (final (M.insert(map, (x,y), symbol_to_mark c elem)) 1 t 0)
	
				else (
			 		if ((c= #"+") andalso (left <> NONE) andalso (Array2.sub(pos_grid,x,y-1) = false) andalso (Option.valOf(left) <> #"X") andalso (Option.valOf(left) <> c)) then 
						(Array2.update (pos_grid,x,y-1,true); Queue.enqueue(q,(c,x,y-1,t+1)))
						else ();
			 		if ((c= #"-") andalso (left <> NONE) andalso (Array2.sub(neg_grid,x,y-1) = false) andalso (Option.valOf(left) <> #"X") andalso (Option.valOf(left) <> c)) then 
						(Array2.update (neg_grid,x,y-1,true); Queue.enqueue(q,(c,x,y-1,t+1)))
						else ();
					if ((c= #"+") andalso (up <> NONE) andalso (Array2.sub(pos_grid,x-1,y) = false) andalso (Option.valOf(up) <> #"X") andalso (Option.valOf(up) <> c)) then 
						(Array2.update (pos_grid,x-1,y,true); Queue.enqueue(q,(c,x-1,y,t+1)))
						else ();
					if ((c= #"-") andalso (up <> NONE) andalso (Array2.sub(neg_grid,x-1,y) = false) andalso (Option.valOf(up) <> #"X") andalso (Option.valOf(up) <> c)) then 
						(Array2.update (neg_grid,x-1,y,true); Queue.enqueue(q,(c,x-1,y,t+1)))
						else ();
					if ((c= #"+") andalso (right <> NONE) andalso (Array2.sub(pos_grid,x,y+1) = false) andalso (Option.valOf(right) <> #"X") andalso (Option.valOf(right) <> c)) then
						(Array2.update (pos_grid,x,y+1,true); Queue.enqueue(q,(c,x,y+1,t+1)))
						else ();
					if ((c= #"-") andalso (right <> NONE) andalso (Array2.sub(neg_grid,x,y+1) = false) andalso (Option.valOf(right) <> #"X") andalso (Option.valOf(right) <> c)) then
						(Array2.update (neg_grid,x,y+1,true); Queue.enqueue(q,(c,x,y+1,t+1)))
						else ();
					if ((c= #"+") andalso (down <> NONE) andalso (Array2.sub(pos_grid,x+1,y) = false) andalso (Option.valOf(down) <> #"X") andalso (Option.valOf(down) <> c)) then 
						(Array2.update (pos_grid,x+1,y,true); Queue.enqueue(q,(c,x+1,y,t+1)))
						else ();
					if ((c= #"-") andalso (down <> NONE) andalso (Array2.sub(neg_grid,x+1,y) = false) andalso (Option.valOf(down) <> #"X") andalso (Option.valOf(down) <> c)) then 
						(Array2.update (neg_grid,x+1,y,true); Queue.enqueue(q,(c,x+1,y,t+1)))
						else ();
					if (Queue.isEmpty q) then (print ("the world is saved\n"); final (M.insert(map, (x,y), symbol_to_mark c elem)) doomsday time 1)
					else
						final (M.insert(map, (x,y), symbol_to_mark c elem)) doomsday t 0)
			end

		val map = read M.empty (0,0)
		val a = M.listItemsi map
		val a = List.last a
		val a = #1a
		val row_limit = #1a
		val col_limit = #2a
		val map = final map 0 0 0
	
		fun printmap map (x,y) = 
			let
				val elem = M.find(map, (x,y))
			in 	
				if elem = NONE then ()
				else if (y=col_limit) then (print (Char.toString(Option.valOf(elem))); print "\n"; printmap map (x+1,0))
				else (print (Char.toString(Option.valOf(elem))); printmap map (x,y+1))
			end

	in 
		printmap map (0,0) 
	end
