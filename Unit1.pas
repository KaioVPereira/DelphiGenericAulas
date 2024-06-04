unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type

  TPessoa = class
  private
    Fnome: String;
    procedure Setnome(const Value: String);
  published
    property nome : String  read Fnome write Setnome;
  end;

  TNFe<T: constructor> = class
    FGeneric : T;
    constructor Create;
    function GetGeneric : T;
  end;

  TProduto = class
  private
    FDescricao: String;
    procedure SetDescricao(const Value: String);
  published
    constructor Create;
    property Descricao : String read FDescricao write SetDescricao;
  end;

  TDias  = (Segunda, Terça, Quarta, Quinta, Sexta, Sabado, Domingo);
  TMes =   (Janeiro, Fevereiro, Marco, Abril, Maio, Junho);

  TENeumUtils<T> = class
    class procedure EnumToList (Value : Tstrings);
  end;

  TMeuGeneric = array [0..9] of string;

  TMeuArrayGeneric<T> = class // Tipo T é o Tipo Genérico, ao usar a classe em outro ponto do sistema, troco o tipo T para o tipo que quero utilizar
    FArray : array [0..9] of T;
  end;

  TUtis = class
    class function IIF<T>(Condiction : Boolean; T1,T2 : T): T;
  end;

  TKeyValue<T> = class // Tipo T é o Tipo Genérico, ao usar a classe em outro ponto do sistema, troco o tipo T para o tipo que quero utilizar
  private
    FKey: String;
    FValue: T;
    procedure SetKey(const Value: String);
    procedure SetValue(const Value: T);
  published

    property Key : String read FKey write SetKey;
    property  Value : T read FValue write SetValue;

  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMeuGenericoA = TMeuArrayGeneric<String>;

var
  Form1: TForm1;

implementation

uses
  System.TypInfo;

{$R *.dfm}

{ TKeyValue<T> }



procedure TForm1.Button1Click(Sender: TObject);
var KV : TKeyValue<TForm>; // Trocando o tipo T (GENERICO) para um Form
begin
  KV := TKeyValue<TForm>.Create;
  try
    KV.Key := 'F1';
    KV.Value := Form1;

    ShowMessage('Número da Fomr: '+ KV.key + ' Nome da form: '+ KV.Value.Name )

  finally
   KV.Free;
  end;

end;

{ TKeyValue<T> }

procedure TKeyValue<T>.SetKey(const Value: String);
begin
  FKey := Value;
end;

procedure TKeyValue<T>.SetValue(const Value: T);
begin
  FValue := Value;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Auxiliar1 : TMeuGeneric;
  Auxiliar2 : TMeuGeneric;
  Auxiliar3 : Array [0..9] of string;
  Auxiliar4 : Array [0..9] of string;
begin

  Auxiliar1 := Auxiliar2;
  //Auxiliar1 := Auxiliar3; Linha com erro pois para o compilador são de tipos diferentes


end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Auxiliar1 : TMeuArrayGeneric<String>;
  Auxiliar2 : TMeuArrayGeneric<String>;
  Auxiliar3 : TMeuGenericoA;
  Auxiliar4 : TMeuGenericoA;
begin

  Auxiliar1 := Auxiliar3;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  TENeumUtils<TMes>.EnumToList(ComboBox1.Items)
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  TENeumUtils<TDias>.EnumToList(ComboBox1.Items)
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  Auxiliar : String;

begin
  Auxiliar := TUtis.IIF<String>((Edit1.Text <> ''), Edit1.Text, 'Laranja' );
  Edit1.Text := Auxiliar;
end;

procedure TForm1.Button7Click(Sender: TObject);
Var
  Prod1 , Prod2, Prod3 : TProduto;
begin
  Prod1 := nil;
  prod2 := nil;
  prod3 := nil;
  Try

    Prod3 := TUtis.IIF<TProduto>((Assigned(Prod2)),Prod2, TProduto.Create);

    ShowMessage(Prod3.Descricao);
  Finally
    Prod1.Free;
    Prod2.Free;
    Prod3.Free;
  End;


end;

procedure TForm1.Button8Click(Sender: TObject);
Var
  NFE : TNFe<TPessoa>;
begin
  NFE := TNFe<TPessoa>.Create;
  Try
   NFE.FGeneric.nome := 'Kaio';
  Finally
    NFE.Free;
  End;
end;

{ TENeumUtils<T> }

class procedure TENeumUtils<T>.EnumToList(Value: Tstrings);
var
  Aux : String;
  I : Integer;
  Pos : Integer;
begin
  Value.Clear;
  I := 0;
  repeat
    Aux := GetEnumName (TypeInfo(T), I);
    Pos := GetEnumValue(TypeInfo(T), Aux);
    if Pos <> -1 then Value.Add(Aux); // Quando o Indice estiver em um valor que não encontrar no GetEnumValue, automáticamente o retorno será -1
    Inc(I);
  until (Pos<0);
end;

{ TUtis }

class function TUtis.IIF<T>(Condiction: Boolean; T1, T2: T): T;
begin
  if Condiction  then
    Result := T1
  else
    Result := T2;
end;

{ TProduto }

constructor TProduto.Create;
begin
  FDescricao := 'Produto Genérico';
end;

procedure TProduto.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

{ TPessoa }

procedure TPessoa.Setnome(const Value: String);
begin
  Fnome := Value;
end;

{ TNFe<T> }

constructor TNFe<T>.Create;
begin
  FGeneric := T.Create;
end;

function TNFe<T>.GetGeneric: T;
begin
  result := FGeneric;
end;

end.
