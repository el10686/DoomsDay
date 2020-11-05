#!/usr/bin/env python3

from collections import deque

def doomsday(f):

	i = j = k = l = t = doomsday = 0
	time = -1
	buff = [[0 for j in range(1000)] for i in range(1000)]
	positive_grid = [["." for j in range(1000)] for i in range(1000)]
	negative_grid = [["." for j in range(1000)] for i in range(1000)]
	c = f.read(1)
	q = 0

	class Node:
	
		def __init__(self,symbol,x,y,time):
			self.symbol = symbol
			self.x = x
			self.y = y
			self.time = time

	while (c):
		buff[i][j] = c

		if c == "+" or c == "-":
			node = Node(c, i, j, t)
			if q:
				q.append(node)
			else:
				q = deque([node])
			if c == "+":
				positive_grid[i][j] = "+"
			if c == "-":
				negative_grid[i][j] = "-"
		
		j += 1
		c = f.read(1)
		
		if j == 1000:
			i += 1
			k = i 
			l = j 
			j = 0 

		if c == "\n":
			i += 1
			k = i 
			l = j 
			j = 0 
			while c == "\n":
				c = f.read(1)
	
	up = down = right = left = 0 

	while q:
		
		elem = q.popleft()
		c = elem.symbol
		i = elem.x
		j = elem.y 
		t = elem.time

		if doomsday and time < t:
			break
	
		if (c == "-" and buff[i][j] == "+") or (c == "+" and buff[i][j] == "-"):
			buff[i][j] = "*"
			if doomsday == 0:
				doomsday = 1
				time = t
				
		elif buff[i][j] != "*":
			if time == -1 or t <= time:
				buff[i][j] = c
	
			up = i - 1
			down = i + 1
			right = j + 1
			left = j - 1
		
			if up >= 0 and buff[up][j] != "X" and buff[up][j] != c:
				if c == "+" and positive_grid[up][j] != "+":
					positive_grid[up][j] = "+"
					node = Node(c, up, j, t+1)
					q.append(node)
				if c == "-" and negative_grid[up][j] != "-":
					negative_grid[up][j] = "-"
					node = Node(c, up, j, t+1)
					q.append(node)
					
			if down <= k-1 and buff[down][j] != "X" and buff[down][j] != c:
				if c == "+" and positive_grid[down][j] != "+":
					positive_grid[down][j] = "+"
					node = Node(c, down, j, t+1)
					q.append(node)
				if c == "-" and negative_grid[down][j] != "-":
					negative_grid[down][j] = "-"
					node = Node(c, down, j, t+1)
					q.append(node)

			if right <= l-1 and buff[i][right] != "X" and buff[i][right] != c:
				if c == "+" and positive_grid[i][right] != "+":
					positive_grid[i][right] = "+"
					node = Node(c, i, right, t+1)
					q.append(node)
				if c == "-" and negative_grid[i][right] != "-":
					negative_grid[i][right] = "-"
					node = Node(c, i, right, t+1)
					q.append(node)

			if left >= 0 and buff[i][left] != "X" and buff[i][left] != c:
				if c == "+" and positive_grid[i][left] != "+":
					positive_grid[i][left] = "+"
					node = Node(c, i, left, t+1)
					q.append(node)
				if c == "-" and negative_grid[i][left] != "-":
					negative_grid[i][left] = "-"
					node = Node(c, i, left, t+1)
					q.append(node)

	if doomsday:
		print(time)
	else:
		print("the world is saved")

	for i in range(k):
		for j in range(l):
			sys.stdout.write(buff[i][j])
		print()
	
if __name__ == "__main__":
	import sys
	if len(sys.argv) > 1:
		with open(sys.argv[1], "rt") as f:
			doomsday(f)
	else:
		print("Usage: ./doomsday text_file")
