uses Timers;

procedure TimerProc;
begin
  write(1);
end;


begin
  var t := new Timer(100,TimerProc);
  t.Start;
  Sleep(3000);
  t.Interval := 500;
  
  Sleep(3000);
end.

