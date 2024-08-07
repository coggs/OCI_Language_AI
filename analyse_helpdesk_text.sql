-- Pre Requisite - LLM Loaded into DB and permissios set
-- Using ALL_MINILM_L6_V2 ONNX Model
--
-- GET Key Phrases for all Conversations
--
-- Get Sentiment (if Required)

declare
  l_url1            varchar2(32767) := 'https://language.aiservice.<REGION>.oci.oraclecloud.com/20221001/actions/detectLanguageKeyPhrases'; 
  l_url2            varchar2(32767) := 'https://language.aiservice.<REGION>.oci.oraclecloud.com/20221001/actions/detectLanguageSentiments'; 

  l_text_column    clob;
  l_response       clob;

  cursor cc_CONTENT is
      select ID, CHAT_CONTENT
      from HELPDESK_CALLCENTRE WHERE AI_CATEGORY IS NULL;

begin

  apex_web_service.clear_request_headers;
  apex_web_service.g_request_headers(1).name  := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json';

  for r_row in cc_CONTENT loop
    l_text_column := r_row.CHAT_CONTENT;

    l_response := apex_web_service.make_rest_request(
      p_url            => l_url1,
      p_http_method    => 'POST',
      p_body           => json_object(
                      'text' value l_text_column
                      ),
      p_credential_static_id => '<CREDENTIAL>'
    );

    update HELPDESK_CALLCENTRE set AI_CATEGORY = l_response WHERE ID = r_row.ID;

    -- Comma Separated list of Key Phrases
    UPDATE HELPDESK_CALLCENTRE c SET c.keyphrases = 
    (select LISTAGG(jt.text, ', ') WITHIN GROUP (ORDER BY jt.text) key_phrases
    from json_table(l_response, '$.keyPhrases[*]'
        columns (
          text varchar2(100) path '$.text',
          score number(18,16) path '$.score'
        )) jt )
    WHERE c.ID = r_row.ID;

    -- Turn Key Phrase list into a Vector
    UPDATE HELPDESK_CALLCENTRE c SET c.CHAT_VECTOR = TO_VECTOR(VECTOR_EMBEDDING(ALL_MINILM_L6_V2 USING c.keyphrases as data)) WHERE c.ID = r_row.ID;

    l_response := '';

    -- Call Sentiment 
    l_response := apex_web_service.make_rest_request(
      p_url            => l_url2,
      p_http_method    => 'POST',
      p_body           => json_object(
                      'text' value l_text_column
                      ),
      p_credential_static_id => '<CREDENTIAL>'
    );

    update HELPDESK_CALLCENTRE set AI_SENTIMENT = l_response WHERE ID = r_row.ID;

  end loop;

end;
