*&---------------------------------------------------------------------*
*& Report ZR0018
*&---------------------------------------------------------------------*
*& Aula 92 e 93
*&---------------------------------------------------------------------*
REPORT zr0018.

TYPES: BEGIN OF ty_file,
         forne LIKE zt0004-forne,
         denom LIKE zt0004-denom,
         ender LIKE zt0004-ender,
         telef LIKE zt0004-telef,
         email LIKE zt0004-email,
         cnpj  LIKE zt0004-cnpj,
       END OF ty_file.

* TABELA INTERNA:
DATA: t_file TYPE STANDARD TABLE OF ty_file.
DATA: t_bdcdata TYPE STANDARD TABLE OF bdcdata.

* WORK AREA:
DATA: w_file TYPE ty_file.
DATA: w_bdcdata TYPE bdcdata.

* tela de seleção
PARAMETERS p_file TYPE localfile.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_seleciona_arquivo.

START-OF-SELECTION.
  PERFORM f_upload_file.
  PERFORM f_monta_bdc.


*&---------------------------------------------------------------------*
*& Form F_SELECIONA_ARQUIVO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_arquivo .

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
*     PROGRAM_NAME        = SYST-REPID
*     DYNPRO_NUMBER       = SYST-DYNNR
      field_name = p_file
*     STATIC     = ' '
*     MASK       = ' '
*     FILEOPERATION       = 'R'
*     PATH       =
    CHANGING
      file_name  = p_file
*     LOCATION_FLAG       = 'P'
* EXCEPTIONS
*     MASK_TOO_LONG       = 1
*     OTHERS     = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_UPLOAD_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_upload_file .

  DATA vl_file TYPE string.
  vl_file = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = vl_file
      filetype                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
* IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = t_file
* CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_monta_bdc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_monta_bdc .

  PERFORM f_abre_pasta.

  LOOP AT t_file INTO w_file.

    " LINHA 01 NÃO NECESSITA.

    PERFORM f_monta_tela USING 'SAPLZTABELAS' '0004'.
    PERFORM f_monta_dados USING 'BDC_CURSOR' 'ZT0004-DENOM(01)'.
    PERFORM f_monta_dados USING 'BDC_OKCODE' '=NEWL'.

    PERFORM f_monta_tela USING 'SAPLZTABELAS' '0005'.
    PERFORM f_monta_dados USING 'BDC_CURSOR' 'ZT0004-CNPJ'.
    PERFORM f_monta_dados USING 'BDC_OKCODE' '=SAVE'.
    PERFORM f_monta_dados USING 'ZT0004-FORNE' w_file-forne.
    PERFORM f_monta_dados USING 'ZT0004-DENOM' w_file-denom.
    PERFORM f_monta_dados USING 'ZT0004-ENDER' w_file-ender.
    PERFORM f_monta_dados USING 'ZT0004-TELEF' w_file-telef.
    PERFORM f_monta_dados USING 'ZT0004-EMAIL' w_file-email.
    PERFORM f_monta_dados USING 'ZT0004-CNPJ'  w_file-cnpj.

    PERFORM f_monta_tela USING 'SAPLZTABELAS' '0005'.
    PERFORM f_monta_dados USING 'BDC_CURSOR' 'ZT0004-DENOM'.
    PERFORM f_monta_dados USING 'BDC_OKCODE' '=ENDE'.

    PERFORM f_insere_bdc.

  ENDLOOP.

  PERFORM f_fecha_pasta.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_monta_tela
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM f_monta_tela  USING    VALUE(p_program)
                            VALUE(p_screen).

  CLEAR w_bdcdata.
  w_bdcdata-program = p_program.
  w_bdcdata-dynpro  = p_screen.
  w_bdcdata-dynbegin = 'X'.
  APPEND w_bdcdata TO t_bdcdata.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_monta_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM f_monta_dados  USING    VALUE(p_name)
                             VALUE(p_value).

  CLEAR w_bdcdata.
  w_bdcdata-fnam = p_name.
  w_bdcdata-fval = p_value.
  APPEND w_bdcdata TO t_bdcdata.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_ABRE_PASTA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_abre_pasta .

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      client              = sy-mandt
*     DEST                = FILLER8
      group               = 'CARGA_FORNEC'
*     HOLDDATE            = FILLER8
      keep                = 'X' " não elimina a pasta ao finalizar de processar.
      user                = sy-uname
*     RECORD              = FILLER1
*     PROG                = SY-CPROG
*     DCPFM               = '%'
*     DATFM               = '%'
*     APP_AREA            = FILLER12
*     LANGU               = SY-LANGU
*   IMPORTING
*     QID                 =
    EXCEPTIONS
      client_invalid      = 1
      destination_invalid = 2
      group_invalid       = 3
      group_is_locked     = 4
      holddate_invalid    = 5
      internal_error      = 6
      queue_error         = 7
      running             = 8
      system_lock_error   = 9
      user_invalid        = 10
      OTHERS              = 11.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_INSERE_BDC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_insere_bdc .

  CALL FUNCTION 'BDC_INSERT'
    EXPORTING
      tcode            = 'ZCAD004'
*     POST_LOCAL       = NOVBLOCAL
*     PRINTING         = NOPRINT
*     SIMUBATCH        = ' '
*     CTUPARAMS        = ' '
    TABLES
      dynprotab        = t_bdcdata
    EXCEPTIONS
      internal_error   = 1
      not_open         = 2
      queue_error      = 3
      tcode_invalid    = 4
      printing_invalid = 5
      posting_invalid  = 6
      OTHERS           = 7.
  IF sy-subrc <> 0.
    MESSAGE TEXT-001 TYPE 'I'.
    STOP.
  ELSE.
    REFRESH t_bdcdata.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_FECHA_PASTA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_fecha_pasta .

  CALL FUNCTION 'BDC_CLOSE_GROUP'
    EXCEPTIONS
      not_open    = 1
      queue_error = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.