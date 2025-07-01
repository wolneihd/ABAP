*&---------------------------------------------------------------------*
*& Report ZR0008
*&---------------------------------------------------------------------*
*& OpenSQL - Aula 81
*&---------------------------------------------------------------------*
REPORT ZR0008 NO STANDARD PAGE HEADING.

* importando as tabelas desejadas:
TABLES ZT0001.

* tela de seleção:
SELECTION-SCREEN BEGIN OF BLOCK textFields WITH FRAME TITLE text-001.
PARAMETERS: P_TPMAT LIKE ZT0001-tpmat OBLIGATORY,
            P_DENOM LIKE ZT0001-denom OBLIGATORY.
SELECTION-SCREEN END OF BLOCK textFields.

SELECTION-SCREEN BEGIN OF BLOCK radioButtons WITH FRAME TITLE text-002.
PARAMETERS: P_INSERT RADIOBUTTON GROUP GR1,
            P_UPDATE RADIOBUTTON GROUP GR1,
            P_MODIFY RADIOBUTTON GROUP GR1,
            P_DELETE RADIOBUTTON GROUP GR1.
SELECTION-SCREEN END OF BLOCK radioButtons.

IF P_INSERT = 'X'.
  CLEAR ZT0001.
  zt0001-tpmat = P_TPMAT.
  zt0001-denom = p_denom.
  INSERT zt0001.

  IF SY-SUBRC = 0.
    COMMIT WORK.
    MESSAGE 'Registro cadastrado com sucesso' TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Erro ao salvar o cadastro' TYPE 'E'.
  ENDIF.

ELSEIF P_UPDATE = 'X'.

UPDATE ZT0001
   SET DENOM = P_DENOM
 WHERE TPMAT = P_TPMAT.

  IF SY-SUBRC = 0.
    COMMIT WORK.
    MESSAGE 'Registro alterado com sucesso' TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Erro ao salvar o cadastro' TYPE 'E'.
  ENDIF.

ELSEIF P_MODIFY = 'X'. " caso existir, atualiza, caso não, inclui um novo.
  CLEAR ZT0001.
  zt0001-tpmat = P_TPMAT.
  zt0001-denom = p_denom.
  MODIFY zt0001.

  IF SY-SUBRC = 0.
    COMMIT WORK.
    MESSAGE 'Registro modificado com sucesso' TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Erro ao modificado o cadastro' TYPE 'E'.
  ENDIF.

ELSEIF p_delete = 'X'. " caso existir, atualiza, caso não, inclui um novo.
  DELETE FROM zt0001 WHERE tpmat = p_tpmat.

  IF SY-SUBRC = 0.
    COMMIT WORK.
    MESSAGE 'Registro excluido com sucesso' TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Erro ao excluir o cadastro' TYPE 'E'.
  ENDIF.

ENDIF.