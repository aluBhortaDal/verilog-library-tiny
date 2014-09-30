/*
Author: Tasdiq Ameem

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
  
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  .....publisher note: yes this is actually a legit licence :D
  */

 /* 
   _0	
 5| |1		6_
 4|_|2
	3
________________________________________________
0 1 2 3 4 5 6 7 8 9 A b C d E F
  _			 _		_				 _
 | |	|	 _|		_|		|_|		|_
 |_|	|	|_		_|		  |		 _|

  _  	_		 _		 _			 _		 _
 |_		 |		|_|		|_|	  	or	|_|		|_|
 |_| 	 |		|_|		 _|			  |		| |

		 _				 _		 _
|_		|		 _|		|_		|_
|_|		|_		|_|		|_		|

*/


// IMPORTANT:
// IF YOUR 7 SEG DECODER IS INVERTED, JUST PUT A NOT ON THE WHOLE OUTPUT
// FOR BEHAVIOURAL LOGIC, FLIP THE OUTPUT STATE
module binary_to_hex_7segDecoder (num, hex_decoder);
	input [3:0] num;			// 4 bit binary number
	output [6:0] hex_decoder;	// to display a single digit of hex number

	assign hex_decoder[] = ;
	assign hex_decoder[] = ;
	assign hex_decoder[] = ;
	assign hex_decoder[] = ;
	assign hex_decoder[] = ;
	assign hex_decoder[] = ;
	assign hex_decoder[] = ;



endmodule 