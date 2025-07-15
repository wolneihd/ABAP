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
      t_sort     TYPE slis_t_sortinfo_alv,
      t_header   TYPE slis_t_listheader.

* WORK AREA
DATA: w_zt0005   TYPE zt0005,
      w_zt0001   TYPE zt0001,
      w_saida    TYPE zs0001,
      w_fieldcat TYPE slis_fieldcat_alv,
      w_sort     TYPE slis_sortinfo_alv,
      w_layout   TYPE slis_layout_alv,
      w_header   TYPE slis_listheader,
      w_variant  TYPE DISVARIANT.

SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_tpmat FOR zt0005-tpmat,
                  s_mater FOR zt0005-mater.
SELECTION-SCREEN END OF BLOCK bc01.

SELECTION-SCREEN BEGIN OF BLOCK bc02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_varian TYPE slis_vari.
SELECTION-SCREEN END OF BLOCK bc02.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_varian.
  PERFORM F_VARIANT_F4 CHANGING P_VARIAN.

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
        WHEN 'MATER'.
          w_fieldcat-hotspot = 'X'.
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

  CLEAR w_sort.
  w_sort-spos = 1.
  w_sort-fieldname = 'MATER'.
  w_sort-tabname = 'T_SAIDA'.
  w_sort-up = 'X'. " ORDEM CRESCENTE.
  APPEND w_sort TO t_sort.

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

  w_layout-zebra = 'X'.
  w_layout-colwidth_optimize = 'X'.

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

  w_variant-variant = p_varian.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
     I_CALLBACK_TOP_OF_PAGE            = 'F_CABECALHO'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = w_layout
      it_fieldcat        = t_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
      it_sort            = t_sort
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
     I_SAVE             = 'X'
     IS_VARIANT         = w_variant
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB       =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = t_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

FORM f_cabecalho.

  CLEAR W_HEADER.
  REFRESH T_HEADER.

  W_HEADER-typ = 'H'.
  W_HEADER-info = TEXT-007. " Relatório de materiais
  APPEND W_HEADER TO T_HEADER.

  W_HEADER-typ = 'S'.
  W_HEADER-key = TEXT-008. " Data.:
  write sy-datum to w_header-info.
  APPEND W_HEADER TO T_HEADER.

  W_HEADER-typ = 'S'.
  W_HEADER-key = TEXT-009. " Hora.:
  write sy-uzeit to w_header-info.
  APPEND W_HEADER TO T_HEADER.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary       = T_HEADER
     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
            .


ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_VARIANT_F4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_VARIAN
*&---------------------------------------------------------------------*
FORM f_variant_f4  CHANGING p_p_varian.

  DATA: VL_VARIANT TYPE DISVARIANT.
  vl_variant-report = SY-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant                = vl_variant
*     I_TABNAME_HEADER          =
*     I_TABNAME_ITEM            =
*     IT_DEFAULT_FIELDCAT       =
     I_SAVE                    = 'I'
*     I_DISPLAY_VIA_GRID        = ' '
   IMPORTING
*     E_EXIT                    =
     ES_VARIANT                = vl_variant
   EXCEPTIONS
     NOT_FOUND                 = 1
     PROGRAM_ERROR             = 2
     OTHERS                    = 3.

  IF sy-subrc = 0.
    p_p_varian = vl_variant-variant.
  ENDIF.

ENDFORM.

FORM USER_COMMAND USING R_UCOM      LIKE SY-UCOMM
                       RS_SELFIELD TYPE SLIS_SELFIELD.

  DATA: TL_VIMSELLIST TYPE STANDARD TABLE OF VIMSELLIST,
        WL_VIMSELLIST TYPE VIMSELLIST.

  IF RS_SELFIELD-sel_tab_field = 'T_SAIDA-MATER'.

    wl_vimsellist-viewfield = 'MATER'.
    wl_vimsellist-OPERATOR = 'EQ'.
    wl_vimsellist-value = rs_selfield-value.
    APPEND wl_vimsellist TO tl_vimsellist.

   CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
     EXPORTING
       action                               = 'S'
*      CORR_NUMBER                          = '          '
*      GENERATE_MAINT_TOOL_IF_MISSING       = ' '
*      SHOW_SELECTION_POPUP                 = ' '
       view_name                            = 'ZT0005'
*      NO_WARNING_FOR_CLIENTINDEP           = ' '
*      RFC_DESTINATION_FOR_UPGRADE          = ' '
*      CLIENT_FOR_UPGRADE                   = ' '
*      VARIANT_FOR_SELECTION                = ' '
*      COMPLEX_SELCONDS_USED                = ' '
*      CHECK_DDIC_MAINFLAG                  = ' '
*      SUPPRESS_WA_POPUP                    = ' '
    TABLES
      DBA_SELLIST                          = TL_VIMSELLIST
*      EXCL_CUA_FUNCT                       =
    EXCEPTIONS
      CLIENT_REFERENCE                     = 1
      FOREIGN_LOCK                         = 2
      INVALID_ACTION                       = 3
      NO_CLIENTINDEPENDENT_AUTH            = 4
      NO_DATABASE_FUNCTION                 = 5
      NO_EDITOR_FUNCTION                   = 6
      NO_SHOW_AUTH                         = 7
      NO_TVDIR_ENTRY                       = 8
      NO_UPD_AUTH                          = 9
      ONLY_SHOW_ALLOWED                    = 10
      SYSTEM_FAILURE                       = 11
      UNKNOWN_FIELD_IN_DBA_SELLIST         = 12
      VIEW_NOT_FOUND                       = 13
      MAINTENANCE_PROHIBITED               = 14
      OTHERS                               = 15
             .
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

  ENDIF.

ENDFORM.