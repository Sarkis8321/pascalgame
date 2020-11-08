uses WPFObjects, GraphWPF;

const enemyCount = 20;
var enemyRadius := 20;
var sWidth := 800;
var sHeight := 600;
var playerSpeed := 1;

var player := new CircleWPF(10, 10, 10, colors.blue);
var arrayEnemy:array[1..enemyCount] of CircleWPF;
var text:= new TextWPF(10,100,'очки: ', colors.blue);

var eat := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),20,20, clRandom);

/// процедура создания врагов
procedure initEnemy;
begin
  for var i:=1 to enemyCount do
    arrayEnemy[i]:= new CircleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),enemyRadius, colors.Red);
end;

procedure moveEnemy;
begin
  for var i:=1 to enemyCount do
  begin
   
    
    arrayEnemy[i].dx := random(1,-1);
    arrayEnemy[i].dy := random(1,-1);
    arrayEnemy[i].Move;
  end;
end;

var (vLeft, vRight, vUp, vDown) := (false,false,false,false);

procedure keyDown(K: Key);
begin
  case k of
    Key.Right: vRight := true;
    Key.Left: vLeft := true;
    Key.Up: vUp := true;
    Key.Down: vDown := true;
  end;
end;

procedure keyUp(K: Key);
begin
  case k of
    Key.Right: vRight := false;
    Key.Left: vLeft := false;
    Key.Up: vUp := false;
    Key.Down: vDown := false;
  end;
end;

procedure MovePlayer;
begin
  if vLeft then Player.MoveOn(-playerSpeed,0);
  if vRight then Player.MoveOn(playerSpeed,0);
  if vUp then Player.MoveOn(0,-playerSpeed);
  if vDown then Player.MoveOn(0,playerSpeed);
end;

function isCollisionEnemyToPlayer: boolean;
begin
  var a := false;
  for var i:=1 to enemyCount do
    if player.Intersects(arrayEnemy[i]) then a := true;
  Result:= a;
end;

function isCollisionEatToPlayer: boolean;
begin
  var a := false;
  if player.Intersects(Eat) then a := true;
  Result:= a;
end;

procedure rerenderEat;
begin
  eat.Destroy;
  eat := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),20,20, clRandom);
end;


/// начало программы
begin
  window.SetSize(sWidth,sHeight);
  window.Caption := 'крутая игра';
  initEnemy;
  var fpsCount := 0;
  
  
  
  var fGame := true;
  
  while fGame do
  begin
    moveEnemy;
    
    onKeyDown := keyDown;
    onKeyUp := keyUp;
    MovePlayer;
    
    if isCollisionEnemyToPlayer then fGame := false;
    if isCollisionEatToPlayer then rerenderEat;
    
    
    fpsCount+=1;
   text.Text := (fpsCount/Milliseconds*1000).ToString;
  end;
  
  
  
end.