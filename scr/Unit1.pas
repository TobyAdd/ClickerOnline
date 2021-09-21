unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinInet, StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ScoreLbl: TLabel;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Nickname: string;

const
  Host = 'http://yourhost.ru/onlineClicker';
  AccessKey = 'your secret key';

implementation

{$R *.dfm}

function HTTPCheck(const URL: string): boolean;
var
  hSession, hUrl: HINTERNET;
  dwIndex, dwCodeLen, dwFlags: DWORD;
  dwCode: array [1..20] of Char;
begin
  Result:=false;
  hSession:=InternetOpen('Mozilla/4.0 (MSIE 6.0; Windows NT 5.1)', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then begin

    if Copy(LowerCase(URL), 1, 8) = 'https://' then
      dwFlags:=INTERNET_FLAG_SECURE
    else
      dwFlags:=INTERNET_FLAG_RELOAD;

    hUrl:=InternetOpenURL(hSession, PChar(URL), nil, 0, dwFlags, 0);
    if Assigned(hUrl) then begin
      dwIndex:=0;
      dwCodeLen:=10;
      if HttpQueryInfo(hUrl, HTTP_QUERY_STATUS_CODE, @dwCode, dwCodeLen, dwIndex) then
        Result:=(PChar(@dwCode) = IntToStr(HTTP_STATUS_OK)) or (PChar(@dwCode) = IntToStr(HTTP_STATUS_REDIRECT));
      InternetCloseHandle(hUrl);
    end;

    InternetCloseHandle(hSession);
  end;
end;

function HTTPGet(URL: string): string;
var
  hSession, hUrl: HINTERNET;
  Buffer: array [1..8192] of Byte;
  dwFlags, BufferLen: DWORD;
  StrStream: TStringStream;
begin
  Result:='';
  hSession:=InternetOpen('Mozilla/4.0 (MSIE 6.0; Windows NT 5.1)', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then begin

    if Copy(LowerCase(URL), 1, 8) = 'https://' then
      dwFlags:=INTERNET_FLAG_SECURE
    else
      dwFlags:=INTERNET_FLAG_RELOAD;

    hUrl:=InternetOpenUrl(hSession, PChar(URL), nil, 0, dwFlags, 0);
    if Assigned(hUrl) then begin
      StrStream:=TStringStream.Create('');
      try
        repeat
          FillChar(Buffer, SizeOf(Buffer), 0);
          BufferLen:=0;
          if InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) then
            StrStream.WriteBuffer(Buffer, BufferLen)
          else
            Break;
          Application.ProcessMessages;
        until BufferLen = 0;
        Result:=StrStream.DataString;
      except
        Result:='';
      end;
      StrStream.Free;

      InternetCloseHandle(hUrl);
    end;

    InternetCloseHandle(hSession);
  end;
end;

function DigitToHex(Digit: Integer): Char;
  begin
    case Digit of
      0..9: Result := Chr(Digit + Ord('0'));
      10..15: Result := Chr(Digit - 10 + Ord('A'));
    else
      Result := '0';
  end;
end; // DigitToHex

function URLEncode(const S: string): string;
var
  i, idx, len: Integer;
begin
  len := 0;
  for i := 1 to Length(S) do
    if ((S[i] >= '0') and (S[i] <= '9')) or
      ((S[i] >= 'A') and (S[i] <= 'Z')) or
      ((S[i] >= 'a') and (S[i] <= 'z')) or (S[i] = ' ') or
      (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.') then
      len := len + 1
    else
      len := len + 3;
  SetLength(Result, len);
  idx := 1;
  for i := 1 to Length(S) do
    if S[i] = ' ' then begin
      Result[idx] := '+';
      idx := idx + 1;
    end else
      if ((S[i] >= '0') and (S[i] <= '9')) or
        ((S[i] >= 'A') and (S[i] <= 'Z')) or
        ((S[i] >= 'a') and (S[i] <= 'z')) or
        (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.') then begin
          Result[idx] := S[i];
          idx := idx + 1;
        end
        else
        begin
          Result[idx] := '%';
          Result[idx + 1] := DigitToHex(Ord(S[i]) div 16);
          Result[idx + 2] := DigitToHex(Ord(S[i]) mod 16);
          idx := idx + 3;
        end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ScoreLbl.Caption:=HTTPGet(Host + '/index.php?key=' + AccessKey + '&n=' + URLEncode(Nickname));
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputQuery('Clicker Online', 'Enter your nickname',Nickname) then
   begin
   
   end
   else
   begin
   Form1.Close;
   end;
   if Length(Nickname)=0 then
   begin
   MessageDlg('You have not entered your nickname!', mtError, [mbOK], 0);
   Form1.Close
   end;

end;

procedure TForm1.btn1Click(Sender: TObject);
var
  URL: string;
begin
url := 'http://yourhost.ru/onlineClicker/index.php';
ShellExecute(HInstance, 'open', PChar(url), nil, nil, SW_NORMAL);
end;

end.
