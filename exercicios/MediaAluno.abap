*&---------------------------------------------------------------------*
*& Report ZEXER0001
*&---------------------------------------------------------------------*
*& Aula Youtube
*& https://www.youtube.com/watch?v=4GOao9wzEuU&list=PLnpMwD8LFgjh05i3HTz0OowSufokin24z&index=11
*&---------------------------------------------------------------------*
REPORT ZEXER0001 NO STANDARD PAGE HEADING.

SELECTION-SCREEN BEGIN OF BLOCK B1.
PARAMETERS: P_BIM1 TYPE P DECIMALS 2,
            P_BIM2 TYPE P DECIMALS 2,
            P_BIM3 TYPE P DECIMALS 2,
            P_BIM4 TYPE P DECIMALS 2.
SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.
  DATA V_MEDIA(12) TYPE P DECIMALS 2.
  V_MEDIA = ( P_BIM1 + P_BIM2 + P_BIM3 + P_BIM4 ) / 4.

IF V_MEDIA >= 0 AND V_MEDIA < 50.
  WRITE: 'Sua média anual foi de', V_MEDIA COLOR 6 INTENSIFIED ON INVERSE, 'REPROVADO!'.
ELSEIF V_MEDIA >= 50 AND V_MEDIA < 60.
  WRITE: 'Sua média anual foi de', V_MEDIA COLOR COL_TOTAL INTENSIFIED ON INVERSE, 'RECUPERACAO!'.
ELSE.
  WRITE: 'Sua média anual foi de', V_MEDIA COLOR 5 INTENSIFIED ON INVERSE, 'APROVADO!'.
ENDIF.