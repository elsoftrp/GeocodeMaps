object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 431
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edtRua: TLabeledEdit
    Left = 32
    Top = 40
    Width = 193
    Height = 21
    EditLabel.Width = 16
    EditLabel.Height = 13
    EditLabel.Caption = 'rua'
    TabOrder = 0
  end
  object edtNumero: TLabeledEdit
    Left = 32
    Top = 88
    Width = 193
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'numero'
    TabOrder = 1
  end
  object edtBairro: TLabeledEdit
    Left = 32
    Top = 136
    Width = 193
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'bairro'
    TabOrder = 2
  end
  object edtCidade: TLabeledEdit
    Left = 32
    Top = 232
    Width = 193
    Height = 21
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'cidade'
    TabOrder = 3
  end
  object edtEstado: TLabeledEdit
    Left = 32
    Top = 280
    Width = 193
    Height = 21
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'estado'
    TabOrder = 4
  end
  object edtlat: TLabeledEdit
    Left = 312
    Top = 88
    Width = 193
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'latitude'
    TabOrder = 5
  end
  object edtlong: TLabeledEdit
    Left = 312
    Top = 136
    Width = 193
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'longitude'
    TabOrder = 6
  end
  object Memo1: TMemo
    Left = 528
    Top = 88
    Width = 321
    Height = 323
    Lines.Strings = (
      'Memo1')
    TabOrder = 7
  end
  object Button1: TButton
    Left = 256
    Top = 278
    Width = 75
    Height = 25
    Caption = 'localizar'
    TabOrder = 8
    OnClick = Button1Click
  end
  object edtCep: TLabeledEdit
    Left = 32
    Top = 184
    Width = 193
    Height = 21
    EditLabel.Width = 17
    EditLabel.Height = 13
    EditLabel.Caption = 'cep'
    TabOrder = 9
  end
  object edtEnderecoFormatado: TLabeledEdit
    Left = 312
    Top = 40
    Width = 537
    Height = 21
    EditLabel.Width = 100
    EditLabel.Height = 13
    EditLabel.Caption = 'Endere'#231'o Formatado'
    TabOrder = 10
  end
end
