*&---------------------------------------------------------------------*
*& Report ZR0017
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr0017.

DATA: t_zt0001 TYPE TABLE OF zt0001 WITH HEADER LINE.

PARAMETERS: p_file TYPE localfile.

START-OF-SELECTION.
  PERFORM f_seleciona_dados.
  PERFORM f_download.

*&---------------------------------------------------------------------*
*& Form f_seleciona_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .

  SELECT * FROM zt0001 INTO TABLE t_zt0001.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_download
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_download .

  DATA: VL_FILENAME TYPE STRING.
  VL_FILENAME = P_FILE.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE                    =
      filename                        = VL_FILENAME
      FILETYPE                        = 'ASC'
*     APPEND                          = ' '
*     WRITE_FIELD_SEPARATOR           = ' '
*     HEADER                          = '00'
*     TRUNC_TRAILING_BLANKS           = ' '
*     WRITE_LF                        = 'X'
*     COL_SELECT                      = ' '
*     COL_SELECT_MASK                 = ' '
*     DAT_MODE                        = ' '
*     CONFIRM_OVERWRITE               = ' '
*     NO_AUTH_CHECK                   = ' '
*     CODEPAGE                        = ' '
*     IGNORE_CERR                     = ABAP_TRUE
*     REPLACEMENT                     = '#'
*     WRITE_BOM                       = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT                    = ' '
*     WK1_N_SIZE                      = ' '
*     WK1_T_FORMAT                    = ' '
*     WK1_T_SIZE                      = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS            = ABAP_TRUE
*     VIRUS_SCAN_PROFILE              = '/SCET/GUI_DOWNLOAD'
*   IMPORTING
*     FILELENGTH                      =
    tables
      data_tab                        = T_ZT0001
*     FIELDNAMES                      =
   EXCEPTIONS
     FILE_WRITE_ERROR                = 1
     NO_BATCH                        = 2
     GUI_REFUSE_FILETRANSFER         = 3
     INVALID_TYPE                    = 4
     NO_AUTHORITY                    = 5
     UNKNOWN_ERROR                   = 6
     HEADER_NOT_ALLOWED              = 7
     SEPARATOR_NOT_ALLOWED           = 8
     FILESIZE_NOT_ALLOWED            = 9
     HEADER_TOO_LONG                 = 10
     DP_ERROR_CREATE                 = 11
     DP_ERROR_SEND                   = 12
     DP_ERROR_WRITE                  = 13
     UNKNOWN_DP_ERROR                = 14
     ACCESS_DENIED                   = 15
     DP_OUT_OF_MEMORY                = 16
     DISK_FULL                       = 17
     DP_TIMEOUT                      = 18
     FILE_NOT_FOUND                  = 19
     DATAPROVIDER_EXCEPTION          = 20
     CONTROL_FLUSH_ERROR             = 21
     OTHERS                          = 22
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.