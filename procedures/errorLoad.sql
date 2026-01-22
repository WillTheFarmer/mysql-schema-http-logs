-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `errorLoad`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `errorLoad`
  (IN in_module VARCHAR(300),
   IN in_mysqlerrno VARCHAR(10),
   IN in_messagetext VARCHAR(1000), 
   IN in_loadID VARCHAR(10))
BEGIN
  DECLARE mysqlerrno INT DEFAULT 0;
  DECLARE loadID INT DEFAULT 0;
  IF NOT CONVERT(in_mysqlerrno, UNSIGNED) = 0 THEN
    SET mysqlerrno = CONVERT(in_mysqlerrno, UNSIGNED);
  END IF;
  IF NOT CONVERT(in_loadID, UNSIGNED) = 0 THEN
    SET loadID = CONVERT(in_loadID, UNSIGNED);
  END IF;
  INSERT INTO import_error 
     (module,
      mysql_errno,
      message_text,
      importloadid,
      schema_name)
  VALUES
     (in_module,
      mysqlerrno,
      in_messagetext,
      loadID,
      'logs2mysql.py');
END //
DELIMITER ;
