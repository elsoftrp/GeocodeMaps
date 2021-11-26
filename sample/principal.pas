unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Maps.Base;

type
  TfrmPrincipal = class(TForm)
    edtRua: TLabeledEdit;
    edtNumero: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtEstado: TLabeledEdit;
    edtlat: TLabeledEdit;
    edtlong: TLabeledEdit;
    Memo1: TMemo;
    Button1: TButton;
    edtCep: TLabeledEdit;
    edtEnderecoFormatado: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var
  mapa : IMaps;
  rlat, rlng, memo, addressFormatt:string;
begin
  mapa := TMaps.New('SUA_API_KEY');

  mapa
    .AddStreet(edtRua.Text)
    .AddNumberOfAddress(edtNumero.Text)
    .AddNeighborhood(edtBairro.Text)
    .AddZipCode(StrToInt(edtCep.Text))
    .AddCity(edtCidade.Text)
    .AddState(edtEstado.Text)
    .GeoCode(rlat, rlng)
    .GetResultJson(memo)
    .GetAddressFormatted(addressFormatt);

  edtlat.Text := rlat;
  edtlong.Text := rlng;
  Memo1.Text := memo;
  edtEnderecoFormatado.Text := addressFormatt;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
   ReportMemoryLeaksOnShutdown := true;
end;

end.
