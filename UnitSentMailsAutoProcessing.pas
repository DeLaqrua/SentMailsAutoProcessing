unit UnitSentMailsAutoProcessing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls,
  System.Masks, FileCtrl;

type
  TformMain = class(TForm)
    labelDirectorySentMails: TLabel;
    editDirectorySentMails: TEdit;
    buttonDirectorySentMails: TButton;
    richeditLog: TRichEdit;
    labelAutoprocessingInterval: TLabel;
    spineditMin: TSpinEdit;
    labelMin: TLabel;
    spineditSec: TSpinEdit;
    labelSec: TLabel;
    speedbuttonPlay: TSpeedButton;
    speedbuttonStop: TSpeedButton;
    buttonManualProcessing: TButton;
    labelAutoprocessingState: TLabel;
    timerAutoprocessing: TTimer;
    timerAutoprocessingState: TTimer;
    groupboxDirectory: TGroupBox;
    labelDirectoryVipnet: TLabel;
    editDirectoryVipnet: TEdit;
    buttonDirectoryVipnet: TButton;
    procedure FormCreate(Sender: TObject);
    procedure buttonDirectorySentMailsClick(Sender: TObject);
    procedure buttonManualProcessingClick(Sender: TObject);
    procedure speedbuttonPlayClick(Sender: TObject);
    procedure speedbuttonStopClick(Sender: TObject);
    procedure timerAutoprocessingStateTimer(Sender: TObject);
    procedure timerAutoprocessingTimer(Sender: TObject);
    procedure speedbuttonPlayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure speedbuttonPlayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure speedbuttonStopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure speedbuttonStopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spineditMinKeyPress(Sender: TObject; var Key: Char);
    procedure spineditSecKeyPress(Sender: TObject; var Key: Char);
    procedure spineditMinChange(Sender: TObject);
    procedure spineditSecChange(Sender: TObject);
    procedure buttonDirectoryVipnetClick(Sender: TObject);
  private
    { Private declarations }
  public
    function CheckFileName(inputFileName: string): boolean;
    function ifFolderExistsRename(inputFolderName: string): string;
    function CorrectPath(inputDirectory: string): string;

    procedure AddLog(inputString: string; LogType: integer); //LogType ������:
                                                             //isError � ���� ������ �������
                                                             //isSuccess � ���� ������ ������
                                                           //isInformation � ���� ������ ׸����
  end;

var
  formMain: TformMain;

var
  directorySentMails, directorySentMailsArchive, directoryVipnet: string;

const
  isError = 0;
  isSuccess = 1;
  isInformation = 2;

implementation

{$R *.dfm}

procedure TformMain.FormCreate(Sender: TObject);
begin
  AddLog('���� �������� ���������: ' + DateToStr(Now) + ' ' + TimeToStr(Now) + #13#10, isInformation);
end;

procedure TformMain.buttonManualProcessingClick(Sender: TObject);
var searchResult: TSearchRec;
begin
  buttonManualProcessing.Enabled := False;
  timerAutoprocessing.Enabled := False;
  speedbuttonPlay.Enabled := False;
  speedbuttonStop.Enabled := False;

  try
    directorySentMails := CorrectPath(editDirectorySentMails.Text);
    directoryVipnet := CorrectPath(editDirectoryVipnet.Text);
    if System.SysUtils.DirectoryExists(directorySentMails) = False then
      ShowMessage('��������� ���� � ����� ��� ����������� ������������ �����. ����� �� ����������')
    else
    if System.SysUtils.DirectoryExists(directoryVipnet) = False then
      ShowMessage('��������� ���� � ����� ��� �������� ����� Vipnet''��. ����� �� ����������')
    else
      begin
        {directorySentMailsArchive := directorySentMails + 'Archive\';
        if FindFirst(directorySentMails + '*.*', faNormal, searchResult) = 0 then
          begin
            repeat
              if CheckFileName(searchResult.Name) = True then
                begin

                end
              else addLog(DateToStr(Now) + ' ' + TimeToStr(Now) + '  ' + '��� ����� ' + searchResult.Name + ' �� ������������� �����', isError);
            until FindNext(searchResult) <> 0;
          end;}
      end;
  finally
    buttonManualProcessing.Enabled := True;
    speedbuttonPlay.Enabled := True;
    speedbuttonStop.Enabled := True;
  end;
end;

procedure TformMain.buttonDirectorySentMailsClick(Sender: TObject);
begin
  if SelectDirectory('�������� ����� ������ ���������������:', '', directorySentMails, [sdNewFolder, sdShowShares, sdNewUI, sdValidateDir]) then
    editDirectorySentMails.Text := directorySentMails;
end;

procedure TformMain.buttonDirectoryVipnetClick(Sender: TObject);
begin
  if SelectDirectory('�������� ����� ��� �������� ����� Vipnet''��:', '', directoryVipnet, [sdNewFolder, sdShowShares, sdNewUI, sdValidateDir]) then
    editDirectoryVipnet.Text := directoryVipnet;
end;

function TFormMain.CheckFileName(inputFileName: string): boolean;
begin
  Result := False;

  if MatchesMask(inputFileName, 'SH_*_*_*.*') or
     MatchesMask(inputFileName, 'SH3_*_*_*.*') or
     MatchesMask(inputFileName, 'SHO_*_*_*.*') or
     MatchesMask(inputFileName, 'SHUD_*_*_*.*') or
     MatchesMask(inputFileName, 'SMP_*_*_*.*') or
     MatchesMask(inputFileName, 'SHCP_*_*_��������.*') or
     MatchesMask(inputFileName, 'MSHO_*_MTP_*.*') or //MTP � ��-���������
     MatchesMask(inputFileName, 'MSHO_*_���_*.*') or //MTP � ��-������
     MatchesMask(inputFileName, 'MSH_*_MTP_*.*') or //MTP � ��-���������
     MatchesMask(inputFileName, 'MSH_*_���_*.*') or //MTP � ��-������
     MatchesMask(inputFileName, 'MSMP_*_MTP_*.*') or //MTP � ��-���������
     MatchesMask(inputFileName, 'MSMP_*_���_*.*') then //MTP � ��-������
    begin
      Result := True;
    end;

end;

function TFormMain.ifFolderExistsRename(inputFolderName: string): string;
var counterName: integer;
begin
  result := inputFolderName;

  counterName := 0;
  while System.SysUtils.DirectoryExists(inputFolderName) do
    begin
      counterName := counterName + 1;
      if counterName = 1 then
        begin
          Insert(' (' + IntToStr(counterName) + ')', inputFolderName, Length(inputFolderName));
          result := inputFolderName;
        end
      else
        begin
          inputFolderName := StringReplace(inputFolderName, ' (' + IntToStr(counterName-1) +')', ' (' + IntToStr(counterName) + ')', []);
          result := inputFolderName;
        end;
    end;

end;

function TFormMain.CorrectPath(inputDirectory: string): string;
begin
  if inputDirectory = '' then
    Result := ''
  else
    begin
      inputDirectory := Trim(inputDirectory);

      if Pos('/', inputDirectory) <> 0 then
        begin
          inputDirectory := StringReplace(inputDirectory, '/', '\', [rfReplaceAll]);
        end;

      if inputDirectory[length(inputDirectory)] <> '\' then
        Result := inputDirectory + '\'
      else
        Result := inputDirectory;
    end;
end;

procedure TFormMain.AddLog(inputString: string; LogType: integer); //LogType ������:
                                                                   //isError � ���� ������ �������
                                                                   //isSuccess � ���� ������ ������
                                                                   //isInformation � ���� ������ ׸����
begin
  case LogType of
    isError: begin
               RichEditLog.SelAttributes.Color := clRed;
               RichEditLog.Lines.Add(inputString);
               RichEditLog.Refresh;
             end;
    isSuccess: begin
                 RichEditLog.SelAttributes.Color := clBlack;
                 RichEditLog.SelAttributes.Style := [fsItalic];
                 RichEditLog.Lines.Add(inputString);
                 RichEditLog.Refresh;
               end;
    isInformation: begin
                     RichEditLog.SelAttributes.Color := clBlack;
                     RichEditLog.Lines.Add(inputString);
                     RichEditLog.Refresh;
                   end;
  end;

end;

procedure TformMain.speedbuttonPlayClick(Sender: TObject);
begin
  buttonManualProcessing.Enabled := False;

  speedbuttonPlay.Visible := False;
  speedbuttonStop.Visible := True;

  if (spineditSec.Value > 59) or
     (spineditSec.Value < 0) or
     (spineditMin.Value < 0) or
     ( (spineditSec.Value = 0) and (spineditMin.Value = 0) ) then
    ShowMessage('������� ������� ������/�������')
  else
    begin
      timerAutoProcessing.Interval := spineditMin.Value * 60000 + spineditSec.Value * 1000;
      timerAutoProcessing.Enabled := True;

      timerAutoProcessingState.Enabled := True;
      labelAutoProcessingState.Caption := '�������������� �������';
    end;
end;

procedure TformMain.speedbuttonStopClick(Sender: TObject);
begin
  buttonManualProcessing.Enabled := True;

  speedbuttonStop.Visible := False;
  speedbuttonPlay.Visible := True;

  timerAutoProcessingState.Enabled := False;
  labelAutoProcessingState.Caption := '�������������� �� �������';

  timerAutoProcessing.Enabled := False;
end;

procedure TformMain.timerAutoprocessingStateTimer(Sender: TObject);
begin
  labelAutoProcessingState.Caption := labelAutoProcessingState.Caption + '.';
  if labelAutoProcessingState.Caption = '�������������� �������....' then
    labelAutoProcessingState.Caption := '�������������� �������';
end;

procedure TformMain.timerAutoprocessingTimer(Sender: TObject);
begin
  timerAutoProcessing.Enabled := False;
  buttonManualProcessingClick(Self);
  timerAutoProcessing.Enabled := True;
end;

procedure TformMain.speedbuttonPlayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  speedbuttonPlay.Glyph.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Icons\PlayPush.bmp');
end;

procedure TformMain.speedbuttonPlayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  speedbuttonPlay.Glyph.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Icons\Play.bmp');
end;

procedure TformMain.speedbuttonStopMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  speedbuttonStop.Glyph.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Icons\StopPush.bmp');
end;

procedure TformMain.speedbuttonStopMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  speedbuttonStop.Glyph.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Icons\Stop.bmp');
end;

procedure TformMain.spineditMinKeyPress(Sender: TObject; var Key: Char);
begin
  spineditMin.SelLength := 1;
end;

procedure TformMain.spineditSecKeyPress(Sender: TObject; var Key: Char);
begin
  spineditSec.SelLength := 1;
end;

procedure TformMain.spineditMinChange(Sender: TObject);
begin
  if SpinEditMin.Text = '' then
    SpinEditMin.Text := '0';
end;

procedure TformMain.spineditSecChange(Sender: TObject);
begin
  if SpinEditSec.Text = '' then
    SpinEditSec.Text := '0';
end;

end.
