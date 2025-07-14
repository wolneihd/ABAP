*&---------------------------------------------------------------------*
*& Report ZR0020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr0020.

* TYPE-POOL SLIS.

* IMPORTACAÇÃO DA TABELA
TABLES zt0005.
TABLES zt0001.

* TABELA INTERNA
DATA: t_zt0005   TYPE TABLE OF zt0005,
      t_zt0001   TYPE TABLE OF zt0001,
      t_saida    TYPE TABLE OF zs0001,
      t_fieldcat TYPE slis_t_fieldcat_alv,
      t_sort     TYPE SLIS_T_SORTINFO_ALV.

* WORK AREA
DATA: w_zt0005   TYPE zt0005,
      w_zt0001   TYPE zt0001,
      w_saida    TYPE zs0001,
      w_fieldcat TYPE slis_fieldcat_alv,
      W_SORT     TYPE SLIS_SORTINFO_ALV,
      w_layout   TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_tpmat FOR zt0005-tpmat,
                  s_mater FOR zt0005-mater.
SELECTION-SCREEN END OF BLOCK bc01.

SELECTION-SCREEN BEGIN OF BLOCK bc02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_varian TYPE slis_vari.
SELECTION-SCREEN END OF BLOCK bc02.

START-OF-SELECTION.

  PERFORM f_seleciona_dados.
  PERFORM f_tabela_saida.
  PERFORM f_monta_alv.

*&---------------------------------------------------------------------*
*& Form F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .

  SELECT * FROM zt0005 INTO TABLE t_zt0005
   WHERE tpmat IN s_tpmat
     AND mater IN s_mater.

  IF sy-subrc IS INITIAL.

    SELECT * FROM zt0001 INTO TABLE t_zt0001
     FOR ALL ENTRIES IN t_zt0005
     WHERE tpmat = t_zt0005-tpmat.

  ELSE.
    MESSAGE TEXT-003 TYPE 'I'.
    STOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_TABELA_SAIDA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_tabela_saida .

  LOOP AT t_zt0005 INTO w_zt0005.
    CLEAR w_saida.
    w_saida-mater = w_zt0005-mater.
    w_saida-denom = w_zt0005-denom.
    w_saida-brgew = w_zt0005-brgew.
    w_saida-ntgew = w_zt0005-ntgew.
    w_saida-gewei = w_zt0005-gewei.
    w_saida-status = w_zt0005-status.
    w_saida-tpmat = w_zt0005-tpmat.
    READ TABLE t_zt0001 INTO w_zt0001 WITH KEY tpmat = w_zt0005-tpmat.
    IF sy-subrc IS INITIAL.
      w_saida-denom_tp = w_zt0001-denom.
    ENDIF.
    APPEND w_saida TO t_saida.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_MONTA_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_monta_alv .

  PERFORM f_define_fieldcat.
  PERFORM f_ordena.
  PERFORM f_layout.
  PERFORM f_imprime_alv.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_DEFINE_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_define_fieldcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'T_SAIDA'
      i_structure_name       = 'ZS0001'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = t_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    MESSAGE TEXT-006 TYPE 'I'.
    STOP.
  ELSE.
    LOOP AT t_fieldcat INTO w_fieldcat.
      CASE w_fieldcat-fieldname.
        WHEN 'BRGEW'.
          w_fieldcat-seltext_s = w_fieldcat-seltext_m = w_fieldcat-seltext_l = w_fieldcat-reptext_ddic = TEXT-004.
        WHEN 'NTGEW'.
          w_fieldcat-seltext_s = w_fieldcat-seltext_m = w_fieldcat-seltext_l = w_fieldcat-reptext_ddic = TEXT-005.
      ENDCASE.
    ENDLOOP.

    MODIFY t_fieldcat FROM w_fieldcat INDEX sy-tabix TRANSPORTING seltext_s seltext_m seltext_l reptext_ddic.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_ordena
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_ordena .

  CLEAR W_SORT.
  W_SORT-spos = 1.
  w_sort-fieldname = 'MATER'.
  W_SORT-tabname = 'T_SAIDA'.
  W_SORT-up = 'X'. " ORDEM CRESCENTE.
  APPEND W_SORT TO T_SORT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_layout .

  W_LAYOUT-zebra = 'X'.
  W_LAYOUT-colwidth_optimize = 'X'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_imprime_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_imprime_alv .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
     IS_LAYOUT                         = W_LAYOUT
     IT_FIELDCAT                       = T_FIELDCAT
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
     IT_SORT                           = T_SORT
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB                      =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = T_SAIDA
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.