# type stream a = U nil { head=a; tail=strea a;}

let
 streamElemAt = s: i:
   if i == 0 then s.head
             else streamElemAt s.tail (i - 1);

 fibsFrom = n: m: {
   head = n;
   tail = fibsFrom m (n + m);
  };

  fibs = fibsFrom 1 1;
 in
  streamElemAt fibs 30