uses WPFObjects, GraphWPF;
const enemyCount = 20;
var enemyRadius := 20;
var sWidth := 800;
var sHeight := 600;

var player := new CircleWPF(10, 10, 10, colors.blue);
var arrayEnemy:array[1..enemyCount] of CircleWPF;

var text:= new TextWPF(10,100,'очки: ', colors.red);

procedure initEnemy;
begin
  for var i:=1 to enemyCount do
    arrayEnemy[i]:= new CircleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),enemyRadius, colors.Red);
end;

procedure moveEnemy;
begin
  for var i:=1 to enemyCount do
  begin
    arrayEnemy[i].dx := random(-1,1);
    arrayEnemy[i].dy := random(-1,1);
    arrayEnemy[i].Move;
  end;
end;


/// начало программы
begin
  window.SetSize(sWidth,sHeight);
  initEnemy;
 
  
  while true do
  begin
    moveEnemy;
    
   
  end;
  
  
  
end.