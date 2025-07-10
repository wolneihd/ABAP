*&---------------------------------------------------------------------*
*& Report ZR0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr0012.

PARAMETERS: p_num01 TYPE i,
            p_num02 TYPE i,
            p_opera TYPE c.

DATA: V_RESUL TYPE I.

START-OF-SELECTION.

  PERFORM f_executa_calculo.

  WRITE:/ 'Resultado: ', v_resul.

*&---------------------------------------------------------------------*
*& Form F_EXECUTA_CALCULO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_executa_calculo .

  CALL FUNCTION 'Z_F0001'
    EXPORTING
      numero01          = p_num01
      numero02          = p_num02
      operacao          = p_opera
   IMPORTING
     RESULTADO          = V_RESUL
   EXCEPTIONS
     INV_OPERADOR       = 1
     DIVI_ZERO          = 2
     OTHERS             = 3
            .
  IF sy-subrc <> 0.
    IF sy-subrc = 1.
      MESSAGE TEXT-001 TYPE 'I'. " Operador inválido
      STOP.
    ELSEIF sy-subrc = 1.
      MESSAGE TEXT-002 TYPE 'I'. " Divisão por zero não possível
      STOP.
    ELSE.
      MESSAGE TEXT-003 TYPE 'I'. " Erro não identificado
      STOP.
    ENDIF.
  ENDIF.

ENDFORM.