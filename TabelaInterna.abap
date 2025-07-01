*&---------------------------------------------------------------------*
*& Report ZR0007
*&---------------------------------------------------------------------*
*& Aula 78
*&---------------------------------------------------------------------*
REPORT ZR0007 NO STANDARD PAGE HEADING.

* Declaração de tipos:
TYPES: BEGIN OF TY_MATERIAL,
  CODMAT(10) TYPE C,
  DESCRI(35) TYPE C,
END OF TY_MATERIAL.

* Declaração de estrutura (WorkArea):
DATA W_MATERIAL TYPE TY_MATERIAL.

DATA: BEGIN OF W_CLIENTE,
  CODCLI(10) TYPE C,
  NOME(35)   TYPE C,
END OF W_CLIENTE.

* STANDART TABLE
* SORTED TABLE
* HASHED TABLE

DATA T_MATERIAL TYPE TABLE OF TY_MATERIAL. "WITH HEADER LINE

DATA: BEGIN OF T_FORNEC OCCURS 0, "OCCURS 0 --> Sem tamanho delimitado!
  CODFOR(10) TYPE C,
  NOME(35) TYPE C,
END OF T_FORNEC.

* Inserindo registros na tabela interna:

* T_FORNEC   > COM HEADER LINE
T_FORNEC-CODFOR = 'FORN-0001'.
T_FORNEC-NOME = 'APPLE'.
APPEND T_FORNEC.
CLEAR t_fornec. "LIMPA O HEADER LINE

T_FORNEC-codfor = 'FORN-0002'.
T_FORNEC-nome ='SAMSUNG'.
APPEND T_FORNEC.
CLEAR t_fornec.

* T_MATERIAL > SEM HEADER LINE
W_MATERIAL-codmat = 'MAT-0001'.
W_MATERIAL-descri = 'IPHONE 6'.
APPEND w_material TO t_material.
CLEAR w_material.

W_MATERIAL-codmat = 'MAT-0002'.
W_MATERIAL-descri = 'GALAXY 6'.
APPEND w_material TO t_material.
CLEAR w_material.

* T_FORNEC   > COM HEADER LINE
LOOP AT t_fornec. "WHERE CODFOR = 'FORN-0001'
  WRITE:/ 'código:', t_fornec-codfor, 'nome:', t_fornec-nome.
ENDLOOP.

ULINE.

* T_MATERIAL > SEM HEADER LINE
LOOP AT t_material INTO w_material.
  WRITE:/ 'código:', w_material-codmat, 'descrição:', w_material-descri.
ENDLOOP.