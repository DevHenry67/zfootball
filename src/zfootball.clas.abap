class ZFOOTBALL definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods IMPORT_COMPETITIONS .
  methods IMPORT_TEAMS .
  PROTECTED SECTION.
    DATA: http_client TYPE REF TO if_http_client,
          rest_client TYPE REF TO cl_rest_http_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZFOOTBALL IMPLEMENTATION.


  METHOD constructor.

*   Create HTTP instance using RFC destination created
    cl_http_client=>create_by_destination(
     EXPORTING
       destination              = 'FOOTBALL'    " Logical destination (specified in function call)
     IMPORTING
       client                   = http_client    " HTTP Client Abstraction
     EXCEPTIONS
       argument_not_found       = 1
       destination_not_found    = 2
       destination_no_authority = 3
       plugin_not_active        = 4
       internal_error           = 5
       OTHERS                   = 6
    ).

*   Set HTTP version
    http_client->request->set_version( if_http_request=>co_protocol_version_1_0 ).

*   Create REST client instance
    CREATE OBJECT rest_client
      EXPORTING
        io_http_client = http_client.

*   Set request header if any
    CALL METHOD rest_client->if_rest_client~set_request_header
      EXPORTING
        iv_name  = 'X-Auth-Token'
        iv_value = 'cdaa3ae550fc48e6bb60be7067636ee6'.
  ENDMETHOD.


  METHOD import_competitions.

    TYPES: BEGIN OF ty_response,
             count        TYPE i,
             filters      TYPE string,
             competitions TYPE zfb_competitions_tt,
           END OF ty_response.

    DATA: abap_response   TYPE ty_response,
          lt_competitions TYPE TABLE OF zfb_competitions.

    CHECK http_client IS BOUND AND rest_client IS BOUND.

*   Set the URI if any
    cl_http_utility=>set_request_uri(
      EXPORTING
        request = http_client->request    " HTTP Framework (iHTTP) HTTP Request
        uri     = 'competitions'                      " URI String (in the Form of /path?query-string)
    ).
*   HTTP GET
    rest_client->if_rest_client~get( ).

*   HTTP response
    DATA(lo_response) = rest_client->if_rest_client~get_response_entity( ).

*   HTTP return status
    DATA(http_status)   = lo_response->get_header_field( '~status_code' ).

*   HTTP JSON return string
    DATA(json_response) = lo_response->get_string_data( ).

    DATA(json_doc) = zcl_json_document=>create_with_json( json_response ).
    json_doc->get_data( IMPORTING data = abap_response ).

    lt_competitions = CORRESPONDING #( abap_response-competitions MAPPING plan_tier = plan
                                                                          area_name = area-name
                                                                          currentmatchday = currentseason-currentmatchday ).

    LOOP AT lt_competitions ASSIGNING FIELD-SYMBOL(<comp>).
      <comp>-mandt = sy-mandt.
    ENDLOOP.

    UPDATE zfb_competitions FROM TABLE lt_competitions.

    COMMIT WORK.
    WRITE:/ sy-dbcnt, 'are updated'.

  ENDMETHOD.


  METHOD IMPORT_TEAMS.

    TYPES: BEGIN OF ty_response,
             count        TYPE i,
             filters      TYPE string,
             competitions TYPE zfb_competitions_tt,
           END OF ty_response.

    DATA: abap_response  TYPE ty_response,
          lt_competitions TYPE TABLE OF zfb_competitions.

    CHECK http_client IS BOUND AND rest_client IS BOUND.

*   Set the URI if any
    cl_http_utility=>set_request_uri(
      EXPORTING
        request = http_client->request    " HTTP Framework (iHTTP) HTTP Request
        uri     = 'competitions/2003/teams'                      " URI String (in the Form of /path?query-string)
    ).
*   HTTP GET
    rest_client->if_rest_client~get( ).

*   HTTP response
    DATA(lo_response) = rest_client->if_rest_client~get_response_entity( ).

*   HTTP return status
    DATA(http_status)   = lo_response->get_header_field( '~status_code' ).

*   HTTP JSON return string
    DATA(json_response) = lo_response->get_string_data( ).

    DATA(json_doc) = zcl_json_document=>create_with_json( json_response ).
    json_doc->get_data( IMPORTING data = abap_response ).

    lt_competitions = CORRESPONDING #( abap_response-competitions MAPPING plan_tier = plan ).

    LOOP AT lt_competitions ASSIGNING FIELD-SYMBOL(<comp>).
      <comp>-mandt = sy-mandt.
    ENDLOOP.

    UPDATE zfb_competitions FROM TABLE lt_competitions.

    COMMIT WORK.
    WRITE:/ sy-dbcnt, 'are updated'.

  ENDMETHOD.
ENDCLASS.
