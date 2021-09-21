object Form1: TForm1
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'onlineClicker'
  ClientHeight = 83
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScoreLbl: TLabel
    Left = 8
    Top = 8
    Width = 13
    Height = 29
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 40
    Width = 81
    Height = 33
    Caption = 'Click'
    TabOrder = 0
    OnClick = Button1Click
  end
  object btn1: TButton
    Left = 96
    Top = 8
    Width = 153
    Height = 65
    Caption = 'Go to dashboard'
    TabOrder = 1
    OnClick = btn1Click
  end
end
