type 
  Many = set of integer;


begin
  
  var mnog: Many;
  mnog += [3];
  mnog += [5];
  writeln(mnog);
  
  foreach var item in mnog do
  begin
    print(item);
  end;
  
  
  
end.