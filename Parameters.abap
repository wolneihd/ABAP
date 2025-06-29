*&---------------------------------------------------------------------*
*& Report ZR0005
*&---------------------------------------------------------------------*
*& Aula 39
*&---------------------------------------------------------------------*
REPORT ZR0005 NO STANDARD PAGE HEADING.

* Declaração de parâmetros:
PARAMETER P_DATA TYPE D.

PARAMETERS: P_HORA TYPE T,
            P_NOME TYPE STRING.

WRITE:/ 'NOME: ', P_NOME.
WRITE:/ 'HORA: ', P_HORA ENVIRONMENT TIME FORMAT.
WRITE:/ 'DATA: ', P_DATA DD/MM/YYYY.