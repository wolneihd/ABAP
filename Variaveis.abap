*&---------------------------------------------------------------------*
*& Report ZR0004
*&---------------------------------------------------------------------*
*& Aula 38
*&---------------------------------------------------------------------*
REPORT ZR0004 NO STANDARD PAGE HEADING.

DATA: V_DATA TYPE D, "DATE
      V_HORA TYPE T, "TIME
      V_NOME TYPE STRING. "TEXTO

CONSTANTS C_ANO(4) TYPE C VALUE '2014'.

* Atribuição valores as variáveis
V_DATA = '20140101'.
V_HORA = '120000'.
V_NOME = 'José da Silva'.

WRITE:/ 'Nome:', V_NOME.
WRITE:/ 'Data:', V_DATA DD/MM/YYYY.
WRITE:/ 'Hora:', V_HORA ENVIRONMENT TIME FORMAT.
WRITE:/ 'Ano:', C_ANO.

ULINE.

* todos tipos variaveis:
DATA: V_BYTE TYPE X VALUE 0,
      V_CHAR TYPE C VALUE 'A',
      V_INT TYPE I VALUE 10,
      V_FLOAT TYPE f VALUE '40.35627374734737337373737'.