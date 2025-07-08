*&---------------------------------------------------------------------*
*& Report ZR0011
*&---------------------------------------------------------------------*
*& Aula 82, 83, 84, 85, 86
*&---------------------------------------------------------------------*
REPORT zr0011.

TABLES t005u.

* TABELA INTERNA
DATA: BEGIN OF t_t005u OCCURS 0,
        land1 LIKE t005u-land1,
        bland LIKE t005u-bland,
        bezei LIKE t005u-bezei,
      END OF t_t005u.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_land1 FOR t_t005u-land1, " importando essas colunas.
                  s_bland FOR t_t005u-bland.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_spras LIKE t005u-spras. " tras os dados para seleção com seu respectivo dado.
SELECTION-SCREEN END OF BLOCK b02.

INITIALIZATION. " O inicialization roda antes de inicializar. Indicado para preencher campos standart.
S_LAND1-LOW = 'BR'.
S_LAND1-SIGN = 'I'.
S_LAND1-OPTION = 'EQ'.
APPEND S_LAND1.
CLEAR S_LAND1.

START-OF-SELECTION. " só roda depois de de clicar rodar.

PERFORM f_seleciona_dados.

IF sy-subrc = 0.
  LOOP AT t_t005u.
    WRITE:/ t_t005u-land1, t_t005u-bland, t_t005u-bezei.
  ENDLOOP.
ENDIF.

*&---------------------------------------------------------------------*
*& Form F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .
  SELECT land1 bland bezei
    FROM t005u
    INTO TABLE t_t005u
    WHERE land1 IN s_land1
      AND bland IN s_bland
      AND spras = p_spras.

  IF sy-subrc <> 0.
    MESSAGE TEXT-003 TYPE 'I'. " registro não encontrado.
    STOP.
  ENDIF.

ENDFORM.