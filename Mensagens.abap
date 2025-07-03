*&---------------------------------------------------------------------*
*& Report ZEXER0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXER0004.

DATA: ld_texto(20) TYPE c VALUE 'Exemplo de mensagem'.

SELECTION-SCREEN BEGIN OF BLOCK options.
PARAMETERS: r_sucess  RADIOBUTTON GROUP rad1 DEFAULT 'X',
            r_erro    RADIOBUTTON GROUP rad1,
            r_warn    RADIOBUTTON GROUP rad1,
            r_info    RADIOBUTTON GROUP rad1,
            r_abort   RADIOBUTTON GROUP rad1,
            r_cancel  RADIOBUTTON GROUP rad1,
            r_cl_msg  RADIOBUTTON GROUP rad1.
SELECTION-SCREEN END OF BLOCK options.

IF r_sucess = 'X'.
  MESSAGE ld_texto TYPE 'S'.
ELSEIF r_erro = 'X'.
  MESSAGE ld_texto TYPE 'E'.
ELSEIF r_warn = 'X'.
  MESSAGE ld_texto TYPE 'W'.
ELSEIF r_info = 'X'.
  MESSAGE ld_texto TYPE 'I'.
ELSEIF r_abort = 'X'.
  MESSAGE ld_texto TYPE 'A'.
ELSEIF r_cancel = 'X'.
  MESSAGE ld_texto TYPE 'X'.
ELSEIF r_cl_msg = 'X'.
  MESSAGE s002(ZC0001) WITH 'ABCD'. "PRIMEIRA LETRA s000 de sucesso!
ENDIF.