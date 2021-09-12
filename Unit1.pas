unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient,
  FMX.Controls.Presentation, FMX.Edit, IdSNTP, IdUDPBase, IdUDPClient,
  FMX.StdCtrls,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}

{$ENDIF POSIX}
{$IFDEF PC_MAPPED_EXCEPTIONS}

{$ENDIF PC_MAPPED_EXCEPTIONS}
{$IFDEF MACOS}

{$ENDIF MACOS}
 DateUtils;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Edit1: TEdit;
    IdSNTP1: TIdSNTP;
    Label1: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  TrueTime: TDateTime;
  OldTime : TDateTime;
  SystemTime:TSystemTime;
  IsChange:Boolean=False;
  OldTimeStr:String; //bak
implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  IsChange:=False;
  Edit2.Text:= OldTimeStr;  //reset
  DateTimeToSystemTime(TrueTime,SystemTime);
  SetLocalTime(systemtime);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IsChange:=True;
  OldTime:=StrToDateTime(Edit2.Text);
  OldTime:=IncSecond(OldTime);//fix gui bug
  OldTimeStr:=Edit2.Text;
  //set sys time
  DateTimeToSystemTime(OldTime,SystemTime);
  SetLocalTime(systemtime);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  sHost : string;
begin
  //https://www.aftsf.com/delphi/150.html
  //sHost := format('ntp%d.aliyun.com', [random(7) + 1]);
  sHost := 'ntp1.aliyun.com';
  if IdSNTP1.Connected then IdSNTP1.Disconnect;
  IdSNTP1.Host := sHost;
  IdSNTP1.Port := 123;
  TrueTime:=IdSNTP1.DateTime;
  Edit1.Text:= DateTimeToStr(TrueTime);
  IdSNTP1.Disconnect;
end;



procedure TForm1.Timer1Timer(Sender: TObject);
begin
  TrueTime:=IncSecond(TrueTime);
  Edit1.Text:= DateTimeToStr(TrueTime);

  //修改了系统时间的情况
  if IsChange then
  begin
    //not lock
    if CheckBox1.IsChecked then
    begin
      DateTimeToSystemTime(OldTime,SystemTime);
      SetLocalTime(systemtime);
    end
    else
    begin
       OldTime:=IncSecond(OldTime);
    end;

    Edit2.Text:=DateTimeToStr(OldTime);
  end;

//  if Abs(SecondsBetween(now, OldTime)) > 10000 then
//  begin
//
//  end;

end;

end.
