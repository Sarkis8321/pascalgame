uses WPFObjects, GraphWPF;


begin
  
  var text:= new TextWPF(50,280,'Потеряли жизнь, бегите за новой', colors.blue);
  
  text.Visible := false;
  text.BackgroundColor := colors.Black;
  text.Color := colors.White;
  text.FontSize:= 40;
  //text.AnimScale(3,2);
  text.Visible := true;
  
  
  var v:= false;
  v := not(v);
  print(v);
end.