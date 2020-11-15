uses WPFObjects, GraphWPF, score;

const enemyCount = 20;
var enemyRadius := 20;
var sWidth := 800;
var sHeight := 600;
var playerSpeed := 1;

/// текущий счет
var scoreCount:=0;

var player := new CircleWPF(10, 10, 10, colors.blue);
var arrayEnemy:array[1..enemyCount] of CircleWPF;

/// fps
var text:= new TextWPF(sWidth+10,10,'fps: ', colors.blue);

var score1:= new scoreWPF(sWidth+10,40,'score: 0', colors.blue);




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
    if arrayEnemy[i].left <= 0 then arrayEnemy[i].Dx := 10
    else arrayEnemy[i].dx := random(1,-1);
      
    if arrayEnemy[i].left >= sWidth - 2*enemyRadius then arrayEnemy[i].Dx := -10
    else arrayEnemy[i].dx := random(1,-1);
    
    if arrayEnemy[i].top >= sHeight- 2*enemyRadius then arrayEnemy[i].Dy := -10
    else arrayEnemy[i].dy := random(1,-1);
    
    if arrayEnemy[i].top <= 0 then arrayEnemy[i].Dy := 10
    else arrayEnemy[i].dy := random(1,-1);
    
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
   
  if (vLeft) and (player.left >= 0) then Player.MoveOn(-playerSpeed,0);
  if (vRight) and (player.left <= sWidth - 20) then Player.MoveOn(playerSpeed,0);
  if (vUp) and (player.top >= 0) then Player.MoveOn(0,-playerSpeed);
  if (vDown) and (player.top <= sHeight - 20) then Player.MoveOn(0,playerSpeed);
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
  if player.Intersects(Eat) then 
    begin
      scoreCount +=1;
      a := true;
    end;
  Result:= a;
end;

procedure rerenderEat;
begin
  eat.Destroy;
  eat := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),20,20, clRandom);
end;

/// начало программы
begin
  window.SetSize(sWidth+300,sHeight);
  window.Caption := 'крутая игра';
  var rightLine := new lineWPF(sWidth,0,sWidth,sHeight,colors.Blue);
  
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
   text.Text := 'FPS: ' + (fpsCount/Milliseconds*1000).ToString;
   
   score1.Text := 'Count: ' + scoreCount.ToString;
  end;
  
  
  
end.