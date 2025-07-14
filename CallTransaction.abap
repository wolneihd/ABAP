*&---------------------------------------------------------------------*
*& Report ZR0019
*&---------------------------------------------------------------------*
*& AULA 94 - CALL TRANSACTION
*&---------------------------------------------------------------------*
REPORT zr0019.

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
DATA: t_message TYPE STANDARD TABLE OF bdcmsgcoll.

* WORK AREA:
DATA: w_file TYPE ty_file.
DATA: w_bdcdata TYPE bdcdata.
DATA: w_message TYPE bdcmsgcoll.

* tela de seleção
PARAMETERS: p_file TYPE localfile,
            P_mode TYPE c DEFAULT 'A'. " 'N' PROCESSA DIRETO (SEM PASSO-A-PASSO'

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

    " Batch Data Communication (BDC)
    CALL TRANSACTION 'ZCAD004'
      USING t_bdcdata " vide perform f_monta_tela
      MODE p_mode " escolhe o modo de processar o batch: a (passo-a-passo) / n (direto) / e (apenas erro) --> TRANS.SM35.
      UPDATE 'A' " A sincronizada (espera confirmação do BD)
      MESSAGES INTO t_message.

    PERFORM f_imprime_message.

  ENDLOOP.

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
*& Form F_IMPRIME_MESSAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_imprime_message .

  DATA: vl_id      TYPE bapiret2-id,
        vl_number  TYPE bapiret2-number,
        vl_msg1    TYPE bapiret2-message_v1,
        vl_msg2    TYPE bapiret2-message_v2,
        vl_msg3    TYPE bapiret2-message_v3,
        vl_msg4    TYPE bapiret2-message_v4,
        vl_message TYPE bapiret2-message.

  LOOP AT t_message INTO w_message where msgtyp = 'E' OR msgtyp = 'S'.

    " PRECISA FAZER PORQUE OS TIPOS NÃO SÃO COMPATIVEIS.
    " PARA EVITAR DUMP.
    vl_id      = w_message-msgid.
    vl_number  = w_message-msgnr.
    vl_msg1    = w_message-msgv1.
    vl_msg2    = w_message-msgv2.
    vl_msg3    = w_message-msgv3.
    vl_msg4    = w_message-msgv4.

    CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
      EXPORTING
        id         = vl_id
        number     = vl_number
*       LANGUAGE   = SY-LANGU
        textformat = 'ASC'
*       LINKPATTERN        =
        message_v1 = vl_msg1
        message_v2 = vl_msg2
        message_v3 = vl_msg3
        message_v4 = vl_msg4
*       LANGUAGE_ISO       =
*       LINE_SIZE  =
   IMPORTING
        message    = vl_message.

  WRITE:/ vl_message.
  CLEAR: t_bdcdata, w_bdcdata. " IMPORTANTE LIMPAR O WORK-AREA!

  ENDLOOP.

ENDFORM.