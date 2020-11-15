unit score;

uses WPFObjects;

type
  scoreWPF = class(WPFObjects.TextWPF);

var
  count := 0;

procedure incCount;
begin
  count += 1;
end;

end.