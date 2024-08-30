DROP TABLE "CALLCENTRE";
DROP SEQUENCE "CC_SEQ";

CREATE TABLE "CALLCENTRE" 
(	"ID" NUMBER NOT NULL ENABLE, 
	"OPERATOR_ID" NUMBER,  
	"CHAT_CONTENT" CLOB, 
	"CHAT_VECTOR" VECTOR, 
	"KEYPHRASES" VARCHAR2(32767), 
	"AI_CATEGORY" JSON, 
	"AI_SENTIMENT" JSON
	"CREATED" DATE, 
	"CREATED_BY" VARCHAR2(50), 
	"UPDATED" DATE, 
	"UPDATED_BY" VARCHAR2(50)
);

CREATE SEQUENCE  "CC_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 9001 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

CREATE OR REPLACE EDITIONABLE TRIGGER "CALLCENTRE_BIU" 
before insert or update 
  on CALLCENTRE 
  for each row 
  begin 
  if inserting then 
      :new.created := sysdate; 
      select "CC_SEQ".nextval into :NEW."ID"; 
      :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
  end if; 
  :new.updated := sysdate; 
  :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
  end callcentre_biu;
/
