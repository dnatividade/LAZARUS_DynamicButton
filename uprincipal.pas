{
 Create buttons in runtime on the form
 Read the parameters.ini file
}
unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
  private
    function LoadFile(const AFilename: String): integer;
    procedure BtnClick(Sender: TObject);

  public

  end;

var
  Form1: TForm1;
  Btn: array[1..100] of TBitBtn; //MAX 100 buttons

implementation

{$R *.lfm}

{ TForm1 }

//SOURCES:
//https://stackoverflow.com/questions/37659267/read-mutiple-values-from-ini-file-into-tcombobox
//http://professorcarlos.blogspot.com/2010/05/lazarus-componentes-em-run-time.html

procedure TForm1.BtnClick(Sender: TObject);
begin
  //ShowMessage(ActiveControl.Name);
  //ShowMessage(ActiveControl.Caption);
  ShowMessage('Button name:    '+(Sender as TBitBtn).Name+#13+
              'Button caption: '+(Sender as TBitBtn).Caption);
end;

function TForm1.LoadFile(const AFilename: String): integer;
var
  I: TIniFile;
  L: TStringList;
  X: Integer;
  func: String;
  legend: String;
  ret: integer;
  lef,t: integer;

begin
  I:= TIniFile.Create(AFilename);
  try
    L:= TStringList.Create;
    try
      I.ReadSection('BUTTONS', L);
      ret:= L.Count-1;
      lef:= 5;
      t:= 0;
      for X:= 0 to ret do
      begin
        ////////////////////////////////////////////////////////////////////////
        func:= L[X]; //The Name
        legend:= I.ReadString('BUTTONS', func, ''); //The Value
        ////////////////////////////////////////////////////////////////////////
        Btn[X]:= TBitBtn.Create(nil);
        Btn[X].Parent:= ScrollBox1;
        Btn[X].Name:= 'btn_'+func;
        //Btn[X].Caption:= func;
        Btn[X].Caption:= legend;
        Btn[X].Left:= lef;
        Btn[X].Top:= t;
        Btn[X].Width:= 200;
        Btn[X].ShowHint:= true;
        Btn[X].Hint:= legend;
        Btn[X].OnClick:= @BtnClick;
        //
        if (((X+1) mod 2) = 0) then
        begin
           t:= t+32;
           lef:= 5;
        end else
        begin
             lef:= lef+220;
        end;

      end;
    finally
      L.Free;
    end;
  finally
    I.Free;
  end;
  //
  Result:= ret;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LoadFile('parameters.ini');
end;

end.

