*&---------------------------------------------------------------------*
*& Report ZR0015
*&---------------------------------------------------------------------*
*& AULA 90
*&---------------------------------------------------------------------*
REPORT zr0015.

TABLES: zt0005.

DATA: t_zt0001 TYPE TABLE OF zt0001 WITH HEADER LINE,
      t_zt0005 TYPE TABLE OF zt0005 WITH HEADER LINE.

SELECT-OPTIONS: s_tpmat FOR zt0005-tpmat,
                s_mater FOR zt0005-mater.

START-OF-SELECTION.

  SELECT * FROM zt0005
    INTO TABLE t_zt0005
   WHERE mater IN s_mater
     AND tpmat IN s_tpmat.

  IF sy-subrc IS INITIAL.
    SELECT * FROM zt0001
      INTO TABLE t_zt0001
      FOR ALL ENTRIES IN t_zt0005
      WHERE tpmat = t_zt0005-tpmat.
  ENDIF.

  SORT t_zt0005 BY mater tpmat.
  SORT t_zt0001 BY tpmat.

  LOOP AT t_zt0005.
    WRITE:/ t_zt0005-mater, t_zt0005-denom, t_zt0005-brgew, t_zt0005-ntgew.
    READ TABLE t_zt0001 WITH KEY tpmat = t_zt0005-tpmat BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      WRITE:/ t_zt0001-denom.
    ENDIF.
  ENDLOOP.