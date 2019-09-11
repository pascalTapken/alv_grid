*&---------------------------------------------------------------------*
*& Report ZPT_AVL_GRID
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpt_avl_grid.

TYPES: BEGIN OF ty_sflight.
    INCLUDE STRUCTURE sflight.
TYPES: fieldstyle TYPE lvc_t_styl,
END OF ty_sflight.

DATA: lt_sflight   TYPE TABLE OF sflight,
      lo_container TYPE REF TO cl_gui_custom_container,
      lt_fcat      TYPE lvc_t_fcat,
      lo_alv       TYPE REF TO cl_gui_alv_grid,
      ls_layout    TYPE lvc_s_layo,
      lv_valid     TYPE c.

SELECT * FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE lt_sflight
  UP TO 100 ROWS.

CREATE OBJECT lo_container
  EXPORTING
    container_name = 'CCONTAINER_SALV'.

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
    i_structure_name = 'SFLIGHT'
  CHANGING
    ct_fieldcat      = lt_fcat.

CREATE OBJECT lo_alv
  EXPORTING
    i_parent = lo_container.

ls_layout-zebra = abap_true.
ls_layout-stylefname = 'FIELDSTYLE'.

FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.
LOOP AT lt_fcat ASSIGNING <fs_fcat>.
*  IF <fs_fcat>-fieldname = 'CARRID'.
  <fs_fcat>-edit = abap_true.
*  ENDIF.
ENDLOOP.

FIELD-SYMBOLS: <fs_sflight> TYPE sflight.
DAta: ls_stylerow TYPE lvc_s_styl.
LOOP AT lt_sflight ASSIGNING <fs_sflight>.
  ls_stylerow-fieldname = 'CARRID'.
  ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled.
ENDLOOP.

CALL METHOD lo_alv->set_ready_for_input
  EXPORTING
    i_ready_for_input = 1.

CALL METHOD lo_alv->check_changed_data
  IMPORTING
    e_valid = lv_valid.


CALL METHOD lo_alv->set_table_for_first_display
  EXPORTING
    is_layout       = ls_layout
  CHANGING
    it_outtab       = lt_sflight
    it_fieldcatalog = lt_fcat.
CALL SCREEN 0100.

INCLUDE zpt_avl_grid_status_0100o01.

INCLUDE zpt_avl_grid_user_command_0i01.
