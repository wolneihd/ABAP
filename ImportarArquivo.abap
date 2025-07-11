*&---------------------------------------------------------------------*
*& Report ZR0016
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR0016.

*&---------------------------------------------------------------------*

* INSTANCIAÇÃO DOS DADOS DA TABELA: CLIENTE () ==> TXT
TYPES: BEGIN OF TY_TXT,
  CODIGO(10)   TYPE C, " private string codigo
  NOME(30)     TYPE C, " private string nome
  TELEFONE(14) TYPE C, " private string telefone
END OF TY_TXT.

* DECLARAÇÃO DA TABELA: ArrayList<Cliente>
DATA: T_TXT TYPE TABLE OF TY_TXT.

* Workarea: Cliente.get(x)
DATA: W_TXT TYPE TY_TXT.

*&---------------------------------------------------------------------*

* INSTANCIAÇÃO DOS DADOS DA TABELA: CLIENTE ()  ==> CSV
TYPES: BEGIN OF TY_CSV,
  LINE(100)   TYPE C,
END OF TY_CSV.

* DECLARAÇÃO DA TABELA: ArrayList<Cliente>
DATA: T_CSV TYPE TABLE OF TY_CSV.

* Workarea: Cliente.get(x)
DATA: W_CSV TYPE TY_CSV.
*&---------------------------------------------------------------------*

PARAMETERS: P_FILE TYPE LOCALFILE,
            P_CSV RADIOBUTTON GROUP GR1,
            P_TXT RADIOBUTTON GROUP GR1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM F_SELECIONA_ARQUIVO.

* Aqui só após de clicar em rodar.
START-OF-SELECTION.
  PERFORM F_UPLOAD.
  PERFORM F_IMPRIME_DADOS.

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
      FIELD_NAME          = P_FILE
*     STATIC              = ' '
*     MASK                = ' '
*     FILEOPERATION       = 'R'
*     PATH                =
    CHANGING
      file_name           = P_FILE
*     LOCATION_FLAG       = 'P'
   EXCEPTIONS
     MASK_TOO_LONG       = 1
     OTHERS              = 2.

  IF sy-subrc <> 0.
    MESSAGE TEXT-001 TYPE 'I'. " Erro ao selecionar e importar o arquivo
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_UPLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_upload .

  DATA VL_FILENAME TYPE STRING.
  FIELD-SYMBOLS <TABELA> TYPE STANDARD TABLE.
  VL_FILENAME = P_FILE.

  IF P_TXT = 'X'.
    ASSIGN T_TXT TO <TABELA>. " instance of
  ELSE.
    ASSIGN T_CSV TO <TABELA>.
  ENDIF.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                      = VL_FILENAME
      FILETYPE                      = 'ASC'
*     HAS_FIELD_SEPARATOR           = ' '
*     HEADER_LENGTH                 = 0
*     READ_BY_LINE                  = 'X'
*     DAT_MODE                      = ' '
*     CODEPAGE                      = ' '
*     IGNORE_CERR                   = ABAP_TRUE
*     REPLACEMENT                   = '#'
*     CHECK_BOM                     = ' '
*     VIRUS_SCAN_PROFILE            =
*     NO_AUTH_CHECK                 = ' '
*   IMPORTING
*     FILELENGTH                    =
*     HEADER                        =
    tables
      data_tab                      = <TABELA>
*   CHANGING
*     ISSCANPERFORMED               = ' '
   EXCEPTIONS
     FILE_OPEN_ERROR               = 1
     FILE_READ_ERROR               = 2
     NO_BATCH                      = 3
     GUI_REFUSE_FILETRANSFER       = 4
     INVALID_TYPE                  = 5
     NO_AUTHORITY                  = 6
     UNKNOWN_ERROR                 = 7
     BAD_DATA_FORMAT               = 8
     HEADER_NOT_ALLOWED            = 9
     SEPARATOR_NOT_ALLOWED         = 10
     HEADER_TOO_LONG               = 11
     UNKNOWN_DP_ERROR              = 12
     ACCESS_DENIED                 = 13
     DP_OUT_OF_MEMORY              = 14
     DISK_FULL                     = 15
     DP_TIMEOUT                    = 16
     OTHERS                        = 17
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_CSV = 'X'.
   LOOP AT <TABELA> INTO W_CSV.
     SPLIT W_CSV AT ';' INTO w_txt-codigo w_txt-nome w_txt-telefone.
     APPEND W_TXT TO T_TXT.
   ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_IMPRIME_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_imprime_dados .

  LOOP AT T_TXT INTO W_TXT. " FOR (CLIENTE) IN CLIENTES:
   WRITE:/ W_TXT-codigo, w_txt-nome, w_txt-telefone.
  ENDLOOP.

ENDFORM.