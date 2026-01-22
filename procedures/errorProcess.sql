-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `errorProcess`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `errorProcess`
  (IN in_module VARCHAR(300),
   IN in_mysqlerrno INTEGER, 
   IN in_messagetext VARCHAR(1000), 
   IN in_returnedsqlstate VARCHAR(250), 
   IN in_schemaname VARCHAR(64),
   IN in_catalogname VARCHAR(64),
   IN in_loadID INTEGER,
   IN in_processID INTEGER)
BEGIN
  INSERT INTO import_error 
     (module,
      mysql_errno,
      message_text,
      returned_sqlstate,
      schema_name,
      catalog_name,
      importloadid,
      importprocessid)
   VALUES
     (in_module,
      in_mysqlerrno,
      in_messagetext,
      in_returnedsqlstate,
      in_schemaname,
      in_catalogname,
      in_loadID,
      in_processID);
END //
DELIMITER ;
