unit UnitSentMailsAutoProcessing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls, System.Masks;

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
  private
    { Private declarations }
  public
    function CheckFileName(inputFileName: string): boolean;
    function ifFolderExistsRename(inputFolderName: string): string;
    function CorrectPath(inputDirectory: string): string;

    procedure AddLog(inputString: string; LogType: integer); //LogType бывает:
                                                             //isError Ц цвет текста  расный
                                                             //isSuccess Ц цвет текста «елЄный
                                                           //isInformation Ц цвет текста „Єрный
  end;

var
  formMain: TformMain;

const
  isError = 0;
  isSuccess = 1;
  isInformation = 2;

implementation

{$R *.dfm}

function TFormMain.CheckFileName(inputFileName: string): boolean;
begin
  Result := False;

  if MatchesMask(inputFileName, 'SH_*_*_*.zip') or
     MatchesMask(inputFileName, 'SH3_*_*_*.zip') or
     MatchesMask(inputFileName, 'SHO_*_*_*.zip') or
     MatchesMask(inputFileName, 'SHUD_*_*_*.zip') or
     MatchesMask(inputFileName, 'SMP_*_*_*.zip') or
     MatchesMask(inputFileName, 'SHCP_*_*_основной.zip') or
     MatchesMask(inputFileName, 'MSHO_*_MTP_*.zip') or //MTP Ц по-английски
     MatchesMask(inputFileName, 'MSHO_*_ћ“–_*.zip') or //MTP Ц по-русски
     MatchesMask(inputFileName, 'MSH_*_MTP_*.zip') or //MTP Ц по-английски
     MatchesMask(inputFileName, 'MSH_*_ћ“–_*.zip') or //MTP Ц по-русски
     MatchesMask(inputFileName, 'MSMP_*_MTP_*.zip') or //MTP Ц по-английски
     MatchesMask(inputFileName, 'MSMP_*_ћ“–_*.zip') then //MTP Ц по-русски
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

procedure TFormMain.AddLog(inputString: string; LogType: integer); //LogType бывает:
                                                                   //isError Ц цвет текста  расный
                                                                   //isSuccess Ц цвет текста «елЄный
                                                                   //isInformation Ц цвет текста „Єрный
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

end.
