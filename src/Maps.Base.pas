unit Maps.Base;

interface

uses
  System.SysUtils,
  System.JSON,
  System.NetEncoding,
  RESTRequest4D;

type
  TGCStatus = (gcOK, gcZERO_RESULTS, gcOVER_DAILY_LIMIT, gcOVER_QUERY_LIMIT, gcREQUEST_DENIED, gcINVALID_REQUEST, cgUNKNOWN_ERROR);

  IMaps = interface
    ['{FE2BCA4A-2865-4903-9DA7-E0945CEF53BF}']
    function Apikey(const AKey: string): IMaps;
    function GeoCode(out ALatitude: string; out ALongitude: string ): IMaps;
    function AddStreet(const AStreet: string): IMaps;
    function AddNumberOfAddress(const ANumberOfAddress: string): IMaps;
    function AddNeighborhood(const ANeighborhood: string): IMaps;
    function AddZipCode(const AZipCode: Integer): IMaps;
    function AddCity(const ACity: string): IMaps;
    function AddState(const AState: string): IMaps;
    function Location(const Address: string): IMaps;
    function GetLatitude(out ALatitude: string): IMaps;
    function GetLongitude(out ALongitude: string): IMaps;
    function GetResultJson(out AResult: string): IMaps;
    function GetAddressFormatted(out AddressFormatted: string): IMaps;
    function GetStatus(out AStatus: TGCStatus): IMaps; overload;
    function GetStatus: TGCStatus; overload;
    function GetMessageError(out AMessageError: string): IMaps; overload;
    function GetMessageError: string; overload;
  end;

  TMaps = Class(TInterfacedObject, IMaps)
   Private
      FApiKey: String;
      FLat: string;
      FLng: string;
      FAddress: string;
      FAddressFormatted: string;
      FResult: TJsonValue;
      FStreet: String;
      FNumberOfAddress: String;
      FNeighborhood: String;
      FZipCode: String;
      FCity: String;
      FState: String;
      FStatus: TGCStatus;
      FMessageError: string;
      procedure SetTypeStatus(aValue: string);
      function Apikey(const AKey: string): IMaps;
      function AddStreet(const AStreet: string): IMaps;
      function AddNumberOfAddress(const ANumberOfAddress: string): IMaps;
      function AddNeighborhood(const ANeighborhood: string): IMaps;
      function AddZipCode(const AZipCode: Integer): IMaps;
      function AddCity(const ACity: string): IMaps;
      function AddState(const AState: string): IMaps;
      function GeoCode(out ALatitude: string; out ALongitude: string ): IMaps;
      function Location(const Address: string): IMaps;
      function GetLatitude(out ALatitude: string): IMaps;
      function GetLongitude(out ALongitude: string): IMaps;
      function GetResultJson(out AResult: string): IMaps;
      function GetAddressFormatted(out AddressFormatted: string): IMaps;
      function GetStatus(out AStatus: TGCStatus): IMaps; overload;
      function GetStatus: TGCStatus; overload;
      function GetMessageError(out AMessageError: string): IMaps; overload;
      function GetMessageError: string; overload;
   Public
      constructor Create(const AKey: string);
      destructor Destroy; override;
      Class Function New(const AKey: string): IMaps;
   End;

implementation

{ TMapa }

function TMaps.AddCity(const ACity: string): IMaps;
begin
  Result := Self;
  if not ACity.Trim.IsEmpty then
    FCity := TNetEncoding.URL.Encode(ACity)+',';
end;

function TMaps.AddNeighborhood(const ANeighborhood: string): IMaps;
begin
  Result := Self;
  if not ANeighborhood.Trim.IsEmpty then
    FNeighborhood := TNetEncoding.URL.Encode(ANeighborhood)+',';
end;

function TMaps.AddNumberOfAddress(const ANumberOfAddress: string): IMaps;
begin
  Result := Self;
  if not ANumberOfAddress.Trim.IsEmpty then
    FNumberOfAddress := ANumberOfAddress+',';
end;

function TMaps.AddState(const AState: string): IMaps;
begin
  Result := Self;
  if not AState.Trim.IsEmpty then
    FState := AState+',';
end;

function TMaps.AddStreet(const AStreet: string): IMaps;
begin
  Result := Self;
  if not AStreet.Trim.IsEmpty then
    FStreet := TNetEncoding.URL.Encode(AStreet)+',';
end;

function TMaps.AddZipCode(const AZipCode: Integer): IMaps;
begin
  Result := Self;
  if (AZipCode <> 0) and (AZipCode <> -1) then
    FZipCode := FormatFloat('00000-000', AZipCode)+',';
end;

function TMaps.Apikey(const AKey: string): IMaps;
begin
  Result := Self;
  FApiKey := AKey;
end;

constructor TMaps.Create(const AKey: string);
begin
  FApiKey := AKey;
end;

destructor TMaps.Destroy;
begin
  if Assigned(FResult) then
    FResult.DisposeOf;
  inherited;
end;

function TMaps.GeoCode(out ALatitude: string; out ALongitude: string ): IMaps;
Var
  LResponse: IResponse;
  rAddress: string;
  jsonResult: TJSONArray;
  jsonItem, jsonGeometry, jsonLocation: TJSONObject;
  rStatus: string;
begin
  Result := Self;
  if FState.IsEmpty then
    raise Exception.Create('Informe o Estado');
  if FCity.IsEmpty then
    raise Exception.Create('Informe a Cidade');
  rAddress := 'Brasil,'+FState+FCity+FNeighborhood+FStreet+FNumberOfAddress+FZipCode;
  Delete(rAddress,Length(rAddress),1);
  if rAddress <> FAddress then
  begin
    FLat := '';
    FLng := '';
    FAddress := rAddress;
    LResponse := TRequest.New.BaseURL('https://maps.googleapis.com/maps/api/geocode/json?address='+FAddress+'&key='+FApiKey)
      .ContentType('application/json')
      .Accept('application/json')
      .Get;

    FResult := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse.Content), 0) As TJSONObject;
    jsonResult :=  FResult.GetValue<TJSONArray>('results');
    FResult.TryGetValue<string>('status', rStatus);
    FResult.TryGetValue<string>('error_message', FMessageError);

    SetTypeStatus(rStatus);

    if (FStatus = gcOK) and (jsonResult.Count > 0) then
    begin
      jsonItem := jsonResult.Items[0] as TJSONObject;
      jsonItem.TryGetValue<TJSONObject>('geometry', jsonGeometry);
      jsonGeometry.TryGetValue<TJSONObject>('location', jsonLocation);
      jsonItem.TryGetValue<string>('formatted_address', FAddressFormatted);
      jsonLocation.TryGetValue<string>('lat', FLat);
      jsonLocation.TryGetValue<string>('lng', FLng);
    end;
  end;
  ALatitude := FLat;
  ALongitude := FLng;
end;

function TMaps.GetAddressFormatted(out AddressFormatted: string): IMaps;
begin
  Result := Self;
  AddressFormatted := FAddressFormatted;
end;

function TMaps.GetLatitude(out ALatitude: string): IMaps;
begin
  Result := Self;
  ALatitude := FLat;
end;

function TMaps.Location(const Address: string): IMaps;
begin

end;

function TMaps.GetLongitude(out ALongitude: string): IMaps;
begin
  Result := Self;
  ALongitude := FLng;
end;

function TMaps.GetMessageError: string;
begin
  Result := FMessageError;
end;

function TMaps.GetMessageError(out AMessageError: string): IMaps;
begin
  AMessageError := FMessageError;
end;

class function TMaps.New(const AKey: string): IMaps;
begin
  Result := TMaps.Create(AKey);
end;

procedure TMaps.SetTypeStatus(aValue: string);
begin
  if aValue.Trim.Equals('OK') then
    FStatus := gcOK;
  if aValue.Trim.Equals('ZERO_RESULTS') then
    FStatus := gcZERO_RESULTS;
  if aValue.Trim.Equals('OVER_DAILY_LIMIT') then
    FStatus := gcOVER_DAILY_LIMIT;
  if aValue.Trim.Equals('OVER_QUERY_LIMIT') then
    FStatus := gcOVER_QUERY_LIMIT;
  if aValue.Trim.Equals('REQUEST_DENIED') then
    FStatus := gcREQUEST_DENIED;
  if aValue.Trim.Equals('INVALID_REQUEST') then
    FStatus := gcINVALID_REQUEST;
  if aValue.Trim.Equals('UNKNOWN_ERROR') then
    FStatus := cgUNKNOWN_ERROR;
end;

function TMaps.GetResultJson(out AResult: string): IMaps;
begin
  Result := Self;
  AResult := FResult.ToString;
end;

function TMaps.GetStatus: TGCStatus;
begin
  Result := FStatus;
end;

function TMaps.GetStatus(out AStatus: TGCStatus): IMaps;
begin
  AStatus := FStatus;
end;

end.
