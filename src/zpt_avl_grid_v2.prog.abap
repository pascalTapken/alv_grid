*&---------------------------------------------------------------------*
*& Report ZPT_AVL_GRID_V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpt_avl_grid_v2.
TABLES: sflight.

DATA: alv_container TYPE REF TO cl_gui_custom_container,
      alv_grid      TYPE REF TO cl_gui_alv_grid.
DATA: layout   TYPE lvc_s_layo.
DATA: fieldcat TYPE lvc_t_fcat.
DATA: lt_sflight TYPE TABLE OF sflight.

START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN 100.

Module status_0100 output.
  set PF-STATUS '0100'.
  set TITLEBAR '0100'.

  data: variant TYPE disvariant.

  variant-report = sy-repid.
  variant-username = sy-uname.

  create OBJECT alv_container
    EXPORTING
      container_name = 'ALV_CONTAINER'.

  create OBJECT alv_grid
    EXPORTING
      i_parent = alv_container.

  PERFORM get_fieldcatalog.

  call METHOD alv_grid->set_table_for_first_display
    EXPORTING
      is_layout         = layout
      is_variant        = variant
      i_save            = 'U'
      i_structure_name  = 'I_ALV'
    CHANGING
      it_outtab       = lt_sflight[]
      it_fieldcatalog = fieldcat[].
endmodule.

FORM get_data.
  select * into CORRESPONDING FIELDS OF TABLE lt_sflight
    from sflight.
ENDFORM.

form get_fieldcatalog.

ENDFORM.
