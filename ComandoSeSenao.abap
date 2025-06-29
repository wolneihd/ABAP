*&---------------------------------------------------------------------*
*& Report ZR0006
*&---------------------------------------------------------------------*
*& Aula 43
*&---------------------------------------------------------------------*
REPORT ZR0006 NO STANDARD PAGE HEADING.

DATA: V_RESUL TYPE I.

PARAMETERS: P_NUM1 TYPE I,
            P_NUM2 TYPE I,
            P_SOMA RADIOBUTTON GROUP GR1,
            P_SUBT RADIOBUTTON GROUP GR1,
            P_DIVI RADIOBUTTON GROUP GR1,
            P_MULT RADIOBUTTON GROUP GR1.

IF P_SOMA = 'X'.
  V_RESUL = P_NUM1 + P_NUM2.
ELSEIF P_SUBT = 'X'.
  V_RESUL = P_NUM1 - P_NUM2.
ELSEIF P_DIVI = 'X'.
  V_RESUL = P_NUM1 / P_NUM2.
ELSEIF P_MULT = 'X'.
  V_RESUL = P_NUM1 * P_NUM2.
ENDIF.

WRITE:/ 'Resultado:', V_RESUL.

IF P_NUM1 > P_NUM2.
  WRITE:/ 'Numero 01', p_num1, 'é maior que', p_num2.
ELSEIF P_NUM2 > P_NUM1.
  WRITE:/ 'Numero 02', p_num2, 'é maior que', p_num1.
ELSE.
  WRITE:/ 'Numero 01 é igual a numero 02', p_num2.
ENDIF.