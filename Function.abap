FUNCTION Z_F0001.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(NUMERO01) TYPE  I
*"     REFERENCE(NUMERO02) TYPE  I
*"     REFERENCE(OPERACAO) TYPE  C
*"  EXPORTING
*"     REFERENCE(RESULTADO) TYPE  I
*"  EXCEPTIONS
*"      INV_OPERADOR
*"      DIVI_ZERO
*"----------------------------------------------------------------------

CLEAR RESULTADO.

IF OPERACAO = '/' AND NUMERO02 = 0.
  RAISE DIVI_ZERO.
ENDIF.

CASE OPERACAO.
  WHEN '+'.
   RESULTADO = NUMERO01 + NUMERO02.
  WHEN '-'.
   RESULTADO = NUMERO01 - NUMERO02.
  WHEN '*'.
   RESULTADO = NUMERO01 * NUMERO02.
  WHEN '/'.
   RESULTADO = NUMERO01 / NUMERO02.
  WHEN OTHERS.
   RESULTADO = 0.
ENDCASE.

ENDFUNCTION.