declare
    l_object_store   varchar2(32767) := 'https://<namespace>.objectstorage.<region>.oci.customer-oci.com/n/<namespace>/b/<bucket_name>/o/';

    l_url varchar2(32767);
    l_text_column    clob;
    l_response       clob;
    
    cursor voice_tr is
        select FILENAME
        from HELPDESK_CALLCENTRE WHERE CHAT_CONTENT IS NULL AND FILENAME IS NOT NULL;
BEGIN

    apex_web_service.clear_request_headers;
    apex_web_service.g_request_headers(1).name  := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';

    l_response := apex_web_service.make_rest_request(
      p_url            => l_object_store,
      p_http_method    => 'GET',
      p_credential_static_id => '<CREDENTIAL>'
    );

    -- dbms_output.put_line(l_response);

    INSERT INTO HELPDESK_CALLCENTRE (FILENAME) (
      SELECT TEXT FROM 
        json_table(l_response, '$.objects[*]'
        columns (
         text varchar2(32767) path '$.name'
        )) jt 
        WHERE TEXT LIKE '%.json' AND 
          NOT EXISTS (
            SELECT 1 FROM HELPDESK_CALLCENTRE
            WHERE lower(FILENAME) = lower(TEXT)
          )
    );

    commit;

  -- For each Record - Fetch Transcript from OS and Add Transcript to DB
    for r_row in voice_tr loop
      l_url := l_object_store || r_row.FILENAME;

      l_response := apex_web_service.make_rest_request(
        p_url            => l_url,
        p_http_method    => 'GET',
        p_credential_static_id => '<CREDENTIAL>'
      );

      --dbms_output.put_line(l_url);

      UPDATE HELPDESK_CALLCENTRE s SET JSON_DATA = l_response,
      s.CHAT_CONTENT = (
        SELECT TEXT FROM 
          json_table(l_response, '$.transcriptions[*]'
          columns (
           text varchar2(32767) path '$.transcription'
          )) jt
      ) WHERE lower(s.FILENAME) = r_row.FILENAME;

    end loop;
END;
