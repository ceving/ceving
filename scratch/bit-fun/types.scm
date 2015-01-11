

x x x 1

(uint '(1 1 1))
(uint '(1 1 1 1))
(uint '(1 1 1 1 1))
(uint '(1 1 1 1 1 1))

x x x 0  x x x 1

 8  0xxx xxxx
16  10xx xxxx  xxxx xxxx
32  110x xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx
64  1110 xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx xxxx  xxxx xxxx  xxxx xxxx


 8  01xx xxxx  int  -32..31
 8  001x xxxx  (uint '(1 1 1 1 1))


 8  xxx0 xxxx
16  xxx1 xxx0  xxxx xxxx
32  xxx1 xxx0  xxxx xxxx  xxxx xxxx  xxxx xxxx

