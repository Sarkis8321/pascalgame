uses WPFObjects, GraphWPF, score, Timers;

type
  Enemys = set of CircleWPF;

var enemyCount := 6;
var enemyRadius := 20;
var sWidth := 800;
var sHeight := 600;
var playerSpeed := 1;

var healthCount := 3;

/// текущий счет
var scoreCount:=0;
var fpsCount := 0;

var player := new CircleWPF(10, 10, 10, colors.blue);
var arrayEnemy:Enemys;

/// fps
var text:= new TextWPF(sWidth+10,10,'fps: ', colors.blue);

var score1:= new scoreWPF(sWidth+10,40,'score: 0', colors.blue);

/// блок показа количества врагов
var EnemyCountScore:= new scoreWPF(sWidth+10,70,'Врагов: ' + enemyCount, colors.blue);

/// количество жизней
var HealthCountScore:= new scoreWPF(sWidth+10,100,'Жизней: ' + healthCount, colors.blue);

var eat := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),20,20, clRandom);
var eatHealth := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),40,40, clRandom);

/// процедура создания врагов
procedure initEnemy;
begin
  for var i:=1 to enemyCount do
    arrayEnemy += [new CircleWPF(random(enemyRadius+20,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),enemyRadius, colors.Red)];
end;

procedure moveEnemy;
begin
  foreach var itemEnm in arrayEnemy do
  begin
    if itemEnm.left <= 0 then itemEnm.Dx := 10
    else itemEnm.dx := random(1,-1);
      
    if itemEnm.left >= sWidth - 2*enemyRadius then itemEnm.Dx := -10
    else itemEnm.dx := random(1,-1);
    
    if itemEnm.top >= sHeight- 2*enemyRadius then itemEnm.Dy := -10
    else itemEnm.dy := random(1,-1);
    
    if itemEnm.top <= 0 then itemEnm.Dy := 10
    else itemEnm.dy := random(1,-1);
    
    itemEnm.Move;
  end;
end;

var (vLeft, vRight, vUp, vDown, vSpace) := (false,false,false,false,false);

procedure keyDown(K: Key);
begin
  case k of
    Key.Right: vRight := true;
    Key.Left: vLeft := true;
    Key.Up: vUp := true;
    Key.Down: vDown := true;
    Key.Space: vSpace:= not(vSpace);
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
   foreach var itemEnm in arrayEnemy do
    if player.Intersects(itemEnm) then a := true;
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

function isCollisionEatHealthToPlayer: boolean;
begin
  var a := false;
  if player.Intersects(EatHealth) then 
    begin
      healthCount +=1;
      HealthCountScore.Text := ('Жизней: ' + healthCount).ToString;
      eatHealth.Visible := false;
      a := true;
    end;
  Result:= a;
end;

procedure rerenderEat;
begin
  eat.Destroy;
  eat := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),20,20, clRandom);
  arrayEnemy += [new CircleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),enemyRadius, colors.Red)];
  enemyCount +=1;
  EnemyCountScore.Text:= 'Врагов: ' + enemyCount;
end;

procedure waitDegreeHealth;
begin
  var DegreeHealth:= new TextWPF(50,(sHeight/2)-20,'Потеряли жизнь, бегите за новой', colors.blue);
  DegreeHealth.BackgroundColor := colors.Black;
  DegreeHealth.Color := colors.White;
  DegreeHealth.FontSize:= 40;
  sleep(3000);
  DegreeHealth.Destroy;
end;

procedure renderEatHealth;
begin
  eatHealth.Destroy;
  eatHealth := new RectangleWPF(random(enemyRadius,sWidth-enemyRadius),random(enemyRadius,sHeight-enemyRadius),40,40, clRandom);
  eatHealth.Visible := true;
end;

var timerHealth := new Timer(3000,renderEatHealth);

procedure init;
begin
  window.SetSize(sWidth+300,sHeight);
  window.Caption := 'крутая игра';
  var rightLine := new lineWPF(sWidth,0,sWidth,sHeight,colors.Blue);
  initEnemy;
end;

function start(startGame:boolean):boolean;
begin
  
  Player.Left := 10;
  Player.Top := 10;
  
  timerHealth.Start;
  
  while startGame do
  begin
    moveEnemy;
    
    onKeyDown := keyDown;
    onKeyUp := keyUp;
    MovePlayer;
    
    if vSpace then startGame := false;
    
    if isCollisionEnemyToPlayer then startGame := false;
    if isCollisionEatToPlayer then rerenderEat;
    if isCollisionEatHealthToPlayer then renderEatHealth;
    
    fpsCount+=1;
   text.Text := 'FPS: ' + (fpsCount/Milliseconds*1000).ToString;
   
   score1.Text := 'Count: ' + scoreCount.ToString;
  end;
  
  timerHealth.Stop;
  
  result := false;
  
end;

/// начало программы
begin
  
  init;
 
  var fGame := true;
  
  while healthCount > 0 do
  begin
    if(start(fGame) = false) then 
      begin
        healthCount -= 1;
        HealthCountScore.Text := ('Жизней: ' + healthCount).ToString;
        waitDegreeHealth;
      end;
  end;  
   
end.