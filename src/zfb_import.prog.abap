*&---------------------------------------------------------------------*
*& Report ZFB_IMPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfb_import.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_comp AS CHECKBOX.
PARAMETERS p_teams AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK bl1.


START-OF-SELECTION.
  DATA(football_api) = NEW zfootball( ).

  IF p_comp IS NOT INITIAL.
    football_api->import_competitions( ).
  ENDIF.

  if p_teams is not INITIAL.
    football_api->import_teams( ).
  endif.
