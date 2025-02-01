An API to control the NES Pictionary cursor like the Logo turtle, like it was always meant to be! Plus a few examples.

The specifics were directly inspired by [turtle.py](https://docs.python.org/3/library/turtle.html).

## Units

- **Distance** - One unit of forwardness is defined as reaching the next lattice point. It is technically 1, $\sqrt{2}$,
  or $\sqrt{5}$ depending on your angle.
- **Angle** - Pictionary defines angles like the classic Logo turtle: 0 is up, and clockwise is positive. There are 16
  angle units in a circle, ranging from 0 to 15. Because of the lattice point thing, these are also weird if you think
  about them too hard. They are 0°, arctan(0.5), 45°, arctan(2), 90°

## Functions:

`right(ang)`  
Turn right by `ang` angle units

`left(ang)`  
Turn left by `ang` angle units

`forward(amt)`  
Go forward by `amt` steps along the lattice.

`up()`  
Pen up. Move without drawing from now on.

`down()`  
Pen down. Draw while moving from now on.

`undo()`    
Undo your last stroke using the game's built-in undo function (select button).

`bigcircle()`  
Draw a big circle by pressing up

`lilcircle()`  
Draw a lil' circle by pressing down

`pos()`  
Return the current lattice coordinate (not pixels) of the turtle, ranging from (0,0) to (23,16)

`heading()`  
Return the current facing angle of the turtle, in Pictionary angle units (0-15)
