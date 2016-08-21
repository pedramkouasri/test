-- --------------------------------------------------------
-- Host:                         aryaweb.ir
-- Server version:               5.1.73-log - Source distribution
-- Server OS:                    redhat-linux-gnu
-- HeidiSQL Version:             8.2.0.4675
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for function sor_db.FDATE
DELIMITER //
CREATE DEFINER=`sor_user`@`%` FUNCTION `FDATE`(`xdate` TIMESTAMP) RETURNS char(10) CHARSET utf8
BEGIN
	DECLARE xYear INT DEFAULT 0; 
	DECLARE xMonth INT DEFAULT 0;
	DECLARE xDay INT DEFAULT 0;
	DECLARE xF_Year INT DEFAULT 0;
	DECLARE xF_Month INT DEFAULT 0;
	DECLARE xF_Day INT DEFAULT 0;
	DECLARE xLastDay INT DEFAULT 0;
	DECLARE xPlus INT DEFAULT 0;
	DECLARE xMinus INT DEFAULT 0;
	DECLARE xIntercalary INT DEFAULT 0;
	
	IF (xdate*1 = 0) OR (xdate IS NULL) THEN
		RETURN NULL;
	END IF;	
	
	SET xPlus    = 0;
	SET xYear    = YEAR(xdate);
	SET xMonth   = MONTH(xdate);
	SET xDay     = DAY(xdate);
	
	IF ((xMonth = 1) OR (xMonth = 5) OR (xMonth = 6)) THEN
		SET xPlus = 10;	
	END IF;	
	IF ((xMonth = 2) OR (xMonth = 4)) THEN
		SET xPlus = 11;		
	END IF;
	IF ((xMonth = 3) OR (xMonth = 7) OR (xMonth = 8) OR (xMonth = 9) OR (xMonth = 11) OR (xMonth = 12)) THEN
		SET xPlus = 9;
	END IF;		
	IF (xMonth = 10) THEN
		SET xPlus = 8;
	END IF;		
	SET xYear = xYear % 100;
	SET xIntercalary = xYear; 
	IF (xIntercalary % 4 = 0) THEN
		IF (xMonth > 2) THEN
	  		SET xPlus = xPlus + 1;
		END IF;
	END IF;
	IF ((xIntercalary - 1) % 4 = 0) THEN
		SET xLastDay = 30;
		IF (xMonth <= 3)  THEN
			SET xPlus = xPlus + 1;
		END IF;
	ELSE
		SET xLastDay = 29;
	END IF;
	SET xF_Year = xYear - 22;
	IF (xF_Year < 0)  THEN
		SET xF_Year = xF_Year + 100;
	END IF;
	SET xF_Month = xMonth + 9;
	IF (xF_Month > 12) THEN
		SET xF_Month = xF_Month - 12;
		SET xF_Year = xF_Year + 1;
	END IF;
	SET xF_Day = xDay + xPlus;
	IF (xF_Month <= 6) THEN
		SET xMinus = 31;
	ELSE 
		IF ((xF_Month > 6) AND (xF_Month<12)) THEN 
			SET xMinus = 30;
		ELSE 
			SET xMinus = xLastDay;
		END IF;
	END IF;
	IF (xF_Day > xMinus) THEN
		SET xF_Day = xF_Day - xMinus;
		SET xF_Month = xF_Month + 1;
	END IF;
	IF (xF_Month > 12) THEN
		SET xF_Month = xF_Month - 12;
		SET xF_Year  = xF_Year + 1; 
	END IF;

	RETURN CONCAT_WS('/', 1300+xF_Year, IF(xF_Month<10, CONCAT('0', xF_Month), xF_Month), IF(xF_Day<10, CONCAT('0', xF_Day), xF_Day));
END//
DELIMITER ;


-- Dumping structure for function sor_db.FDATE_FORMAT
DELIMITER //
CREATE DEFINER=`sor_user`@`%` FUNCTION `FDATE_FORMAT`(`xdate` TIMESTAMP, `xformat` VARCHAR(128)) RETURNS varchar(128) CHARSET utf8
BEGIN
	DECLARE xYear INT DEFAULT 0; 
	DECLARE xMonth INT DEFAULT 0;
	DECLARE xDay INT DEFAULT 0;
	DECLARE xF_Year INT DEFAULT 0;
	DECLARE xF_Month INT DEFAULT 0;
	DECLARE xF_Day INT DEFAULT 0;
	DECLARE xF_Year_Big INT DEFAULT 0;
	DECLARE xHour INT DEFAULT 0;
	DECLARE xMinute INT DEFAULT 0;
	DECLARE xSecond INT DEFAULT 0;
	DECLARE xF_0Year VARCHAR(2);
	DECLARE xF_0Month VARCHAR(2);
	DECLARE xF_0Day VARCHAR(2);
	DECLARE x0Hour VARCHAR(2);
	DECLARE x0Minute VARCHAR(2);
	DECLARE x0Second VARCHAR(2);
	DECLARE xF_Day_Name VARCHAR(10); 
	DECLARE xF_Month_Name VARCHAR(10); 
	DECLARE xLastDay INT DEFAULT 0;
	DECLARE xPlus INT DEFAULT 0;
	DECLARE xMinus INT DEFAULT 0;
	DECLARE xIntercalary INT DEFAULT 0;
	DECLARE xS_Year VARCHAR(4); 
	DECLARE xS_Month VARCHAR(2);
	DECLARE xS_Day VARCHAR(2);
	DECLARE xE_Date VARCHAR(20);
	DECLARE xRet VARCHAR(20);
	
	IF xformat = '' OR xformat IS NULL THEN
		SET xformat = '%Y/%m/%d';
	END IF;
	
	IF (xdate*1 = 0) OR (xdate IS NULL) THEN
		RETURN NULL;
	END IF;	
	
	SET xPlus   = 0;
	SET xYear   = YEAR(xdate);
	SET xMonth  = MONTH(xdate);
	SET xDay    = DAY(xdate);
		SET xS_Year  = CAST(xYear AS CHAR);
	SET xS_Month = CAST(xMonth AS CHAR);
	SET xS_Day   = CAST(xDay AS CHAR);
	IF  LENGTH(xS_Month) < 2 THEN
	  SET xS_Month = '0'+xS_Month;
	END IF;  
		  
	IF  LENGTH(xS_Day) < 2 THEN	
	  SET xS_Day = '0'+xS_Day;
	END IF;
	SET xE_Date =   xS_Year + xS_Month + xS_Day ;
	
	SET xF_Day_Name = CASE DAYOFWEEK(xdate) 
		WHEN 1 THEN 'يک شنبه'	
		WHEN 2 THEN 'دو شنبه'	
		WHEN 3 THEN 'سه شنبه'	
		WHEN 4 THEN 'چهار شنبه'	
		WHEN 5 THEN 'پنج شنبه'	
		WHEN 6 THEN 'جمعه'	
		WHEN 7 THEN 'شنبه'	
	END;
	
	IF ((xMonth = 1) OR (xMonth = 5) OR (xMonth = 6)) THEN
	  SET xPlus = 10;	
	END IF;	
	IF ((xMonth = 2) OR (xMonth = 4)) THEN
	  SET xPlus = 11;		
	END IF;
	IF ((xMonth = 3) OR (xMonth = 7)  OR (xMonth = 8) OR
	    (xMonth = 9) OR (xMonth = 11) OR (xMonth = 12)) THEN
	  SET xPlus = 9;
	END IF;		
	IF (xMonth = 10) THEN
	  SET xPlus = 8;
	END IF;		
	SET xYear = xYear % 100;
	SET xIntercalary = xYear; 
	IF (xIntercalary % 4 = 0) THEN
	  IF (xMonth > 2) THEN
	    SET xPlus = xPlus + 1;
	  END IF;
	END IF;
	IF ((xIntercalary - 1) % 4 = 0) THEN
	  SET xLastDay = 30;
	  IF (xMonth <= 3)  THEN
	    SET xPlus = xPlus + 1;
	  END IF;
	ELSE
	  SET xLastDay = 29;
	END IF;
	SET xF_Year = xYear - 22;
	IF (xF_Year < 0)  THEN
	  SET xF_Year = xF_Year + 100;
	END IF;
	SET xF_Month = xMonth + 9;
	IF (xF_Month > 12) THEN
	  SET xF_Month = xF_Month - 12;
	  SET xF_Year = xF_Year + 1;
	END IF;
	SET xF_Day = xDay + xPlus;
	IF (xF_Month <= 6) THEN
	  SET xMinus = 31;
	ELSE 
	  IF ((xF_Month > 6) AND (xF_Month<12)) THEN 
	  	SET xMinus = 30;
	  ELSE 
	    SET xMinus = xLastDay;
	  END IF;
	END IF;
	IF (xF_Day > xMinus) THEN
	  SET xF_Day = xF_Day - xMinus;
	  SET xF_Month = xF_Month + 1;
	END IF;
	IF (xF_Month > 12) THEN
	  SET xF_Month = xF_Month - 12;
	  SET xF_Year  = xF_Year + 1; 
	END IF;
	IF xF_Year >= 10 THEN
	   SET xF_0Year = CAST(xF_Year AS CHAR);
	   SET xF_Year_Big =  1300 + xF_Year;
	ELSE 
	   SET xF_0Year = CONCAT('0', CAST(xF_Year AS CHAR));
	   SET xF_Year_Big =  1400 + xF_Year;
	END IF;
	IF xF_Month >= 10 THEN
	   SET xF_0Month = CAST(xF_Month AS CHAR);
	ELSE 
	   SET xF_0Month = CONCAT('0', CAST(xF_Month AS CHAR));
	END IF;
	SET xF_Month_Name = CASE xF_Month
		WHEN 1 THEN  'فروردين'
		WHEN 2 THEN  'ارديبهشت'
		WHEN 3 THEN  'خرداد'
		WHEN 4 THEN  'تير'
		WHEN 5 THEN  'مرداد'	
		WHEN 6 THEN  'شهريور'	
		WHEN 7 THEN  'مهر'	
		WHEN 8 THEN  'آبان'	
		WHEN 9 THEN  'آذر'	
		WHEN 10 THEN 'دي'	
		WHEN 11 THEN 'بهمن'
		WHEN 12 THEN 'اسفند'
	END;
	
	IF xF_Day >= 10 THEN
	   SET xF_0Day = CAST(xF_Day AS CHAR);
	ELSE 
	   SET xF_0Day = CONCAT('0', CAST(xF_Day AS CHAR));
	END IF;
	
	SET xHour   = HOUR(xdate);
	SET xMinute = MINUTE(xdate);
	SET xSecond = SECOND(xdate);
	
	SET x0Hour   = IF(xHour<10, CONCAT('0', xHour), xHour);
	SET x0Minute = IF(xMinute<10, CONCAT('0', xMinute), xMinute);
	SET x0Second = IF(xSecond<10, CONCAT('0', xSecond), xSecond);
		
	SET xRet = xformat;
	SET xRet = REPLACE(xRet, '%%', '{[-%%-]}');
	SET xRet = REPLACE(xRet, '%c', xF_Month);
	SET xRet = REPLACE(xRet, '%d', xF_0Day);
	SET xRet = REPLACE(xRet, '%e', xF_Day);
	SET xRet = REPLACE(xRet, '%H', x0Hour);
	SET xRet = REPLACE(xRet, '%i', x0Minute);
	SET xRet = REPLACE(xRet, '%k', xHour);
	SET xRet = REPLACE(xRet, '%M', xF_Month_Name);
	SET xRet = REPLACE(xRet, '%m', xF_0Month);
	SET xRet = REPLACE(xRet, '%S', xSecond);
	SET xRet = REPLACE(xRet, '%s', x0Second);
	SET xRet = REPLACE(xRet, '%W', xF_Day_Name);
	SET xRet = REPLACE(xRet, '%Y', xF_Year_Big);
	SET xRet = REPLACE(xRet, '%y', xF_0Year);
	SET xRet = REPLACE(xRet, '{[-%%-]}', '%');
	
	RETURN xRet;
END//
DELIMITER ;


-- Dumping structure for table sor_db.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.migrations: 6 rows
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
REPLACE INTO `migrations` (`migration`, `batch`) VALUES
	('2015_07_03_142010_create_session_table', 1),
	('2015_07_03_142030_create_users_group_table', 1),
	('2015_07_03_142109_create_users_role_table', 1),
	('2015_07_03_142250_create_users_table', 1),
	('2015_07_03_143348_create_users_info_table', 1),
	('2015_07_03_144751_create_password_reminder', 1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxpassword_reminder
CREATE TABLE IF NOT EXISTS `xxpassword_reminder` (
  `email` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `xxpassword_reminder_email_index` (`email`),
  KEY `xxpassword_reminder_token_index` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxpassword_reminder: 0 rows
/*!40000 ALTER TABLE `xxpassword_reminder` DISABLE KEYS */;
/*!40000 ALTER TABLE `xxpassword_reminder` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxsession
CREATE TABLE IF NOT EXISTS `xxsession` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `payload` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `last_activity` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `xxsession_userid_index` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxsession: 0 rows
/*!40000 ALTER TABLE `xxsession` DISABLE KEYS */;
/*!40000 ALTER TABLE `xxsession` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxuser_group
CREATE TABLE IF NOT EXISTS `xxuser_group` (
  `xgroupid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `xgroup` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`xgroupid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxuser_group: 3 rows
/*!40000 ALTER TABLE `xxuser_group` DISABLE KEYS */;
REPLACE INTO `xxuser_group` (`xgroupid`, `xgroup`) VALUES
	(1, 'Admin'),
	(2, 'Programmer'),
	(3, 'Customer');
/*!40000 ALTER TABLE `xxuser_group` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxuser_info
CREATE TABLE IF NOT EXISTS `xxuser_info` (
  `xuserid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `xname` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `xfamily` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `xgender` enum('male','female') COLLATE utf8_unicode_ci NOT NULL,
  `xbirthday` date NOT NULL,
  `xtel` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `xfax` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `xmobile` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `xzipcode` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `xcurrentip` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `xcreationdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `xaddress` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`xuserid`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxuser_info: 4 rows
/*!40000 ALTER TABLE `xxuser_info` DISABLE KEYS */;
REPLACE INTO `xxuser_info` (`xuserid`, `xname`, `xfamily`, `xgender`, `xbirthday`, `xtel`, `xfax`, `xmobile`, `xzipcode`, `xcurrentip`, `xcreationdate`, `xaddress`) VALUES
	(1, 'Sales', 'aryaweb', 'male', '0000-00-00', '', '', '', '', '', '0000-00-00 00:00:00', ''),
	(2, 'برنامه نویس', '', 'male', '0000-00-00', '', '', '', '', '', '0000-00-00 00:00:00', ''),
	(3, 'پدرام', 'کوثری', 'male', '0000-00-00', '', '', '09372392767', '', '', '0000-00-00 00:00:00', ''),
	(4, 'محسن', 'عاشوری', 'male', '0000-00-00', '', '', '09372392766', '', '', '0000-00-00 00:00:00', '');
/*!40000 ALTER TABLE `xxuser_info` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxuser_name
CREATE TABLE IF NOT EXISTS `xxuser_name` (
  `xuserid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `xusername` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `xpassword` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `xpayload` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `xuser_status` enum('active','inactive','deleted') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'active',
  `xremember_token` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`xuserid`),
  UNIQUE KEY `xxuser_name_email_unique` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxuser_name: 4 rows
/*!40000 ALTER TABLE `xxuser_name` DISABLE KEYS */;
REPLACE INTO `xxuser_name` (`xuserid`, `xusername`, `xpassword`, `xpayload`, `email`, `xuser_status`, `xremember_token`, `created_at`, `updated_at`) VALUES
	(1, 'sa', '$2y$10$4Hec.qj4EGbZ7MnQ76iK6eO4KoLMSa7CeE3y9vxd4RurBu3Zbz0wm', 'eyJpdiI6IkN3TUFxdWJmdzJmVHJnZzVqVzZweVE9PSIsInZhbHVlIjoiRDU3SW9mRndUVGRtcTZCNm1RK1lGZz09IiwibWFjIjoiNzM1NTBmNDg4OGY3YzgzM2RiZmZiMGYyMTQxZTM5MzE4NTUzYTAxYzk1NGYwZDlmZGI4NWJiNGRlZjU2OGFjZiJ9', 'sales@aryaweb.com', 'active', '', '2016-08-10 10:29:45', '0000-00-00 00:00:00'),
	(2, 'programmer', '$2y$10$/JthIVxgJgABfJrgh8FtYugcja3hhBxvBr2JPOpuGy22hINOCO94y', 'eyJpdiI6Inp4c3pRS2oxRTdRbmhHUHVva2Q4V2c9PSIsInZhbHVlIjoiTFFPNDhtcTMxMlBRTkg5ZXBwWDFNTGpmcjlKaVpTd1RBN1JxQWhQYXFqRT0iLCJtYWMiOiIwODM1ZTY2NTliMzZmMjAyOGQ1MjFmYzk5ZDdlN2IzMDEwMjIzZWRiNjZlZGIwNTM1YzlhOTA0ZDU3NzUxYmMyIn0=', 'programmer@aryaweb.com', 'active', '', '2016-08-10 10:29:45', '0000-00-00 00:00:00'),
	(3, 'persianped@gmail.com', '$2y$10$qym5.oh78rzdXeKPmp4a4.pXOgNf7H8XKBEJjzgGLMESVYih6hGEu', '', 'persianped@gmail.com', 'active', '', '2016-08-14 12:16:12', '2016-08-14 12:16:12'),
	(4, 'mohsen@ashori.com', '$2y$10$qAe3gJXtd1PE.ibCWQ5IU.C6PxFZ0KQ64SqWDEJCSsPZMcXg6/zim', '', 'mohsen@ashori.com', 'active', '', '2016-08-14 12:19:39', '2016-08-14 12:19:39');
/*!40000 ALTER TABLE `xxuser_name` ENABLE KEYS */;


-- Dumping structure for table sor_db.xxuser_role
CREATE TABLE IF NOT EXISTS `xxuser_role` (
  `xroleid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `xgroupid` int(11) NOT NULL,
  `xuserid` int(11) NOT NULL,
  PRIMARY KEY (`xroleid`),
  UNIQUE KEY `xxuser_role_xgroupid_xuserid_unique` (`xgroupid`,`xuserid`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table sor_db.xxuser_role: 4 rows
/*!40000 ALTER TABLE `xxuser_role` DISABLE KEYS */;
REPLACE INTO `xxuser_role` (`xroleid`, `xgroupid`, `xuserid`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 3, 3),
	(4, 3, 4);
/*!40000 ALTER TABLE `xxuser_role` ENABLE KEYS */;


-- Dumping structure for table sor_log.xxlog
CREATE TABLE IF NOT EXISTS `xxlog` (
  `xlogid` bigint(20) NOT NULL AUTO_INCREMENT,
  `xid` int(11) DEFAULT NULL,
  `xuserid` int(11) NOT NULL,
  `xaction` enum('login','logout','insert','update','delete') COLLATE utf8_persian_ci DEFAULT NULL,
  `xtable` varchar(32) COLLATE utf8_persian_ci DEFAULT NULL,
  `xquery` text COLLATE utf8_persian_ci,
  `xpre_data` text COLLATE utf8_persian_ci,
  `xpost_data` text COLLATE utf8_persian_ci,
  `xurl` varchar(128) COLLATE utf8_persian_ci DEFAULT NULL,
  `xip` varchar(16) COLLATE utf8_persian_ci DEFAULT NULL,
  `xtime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `xrecovery_num` int(11) DEFAULT NULL,
  `xrecovery_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`xlogid`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- Dumping data for table sor_log.xxlog: 27 rows
/*!40000 ALTER TABLE `xxlog` DISABLE KEYS */;
REPLACE INTO `xxlog` (`xlogid`, `xid`, `xuserid`, `xaction`, `xtable`, `xquery`, `xpre_data`, `xpost_data`, `xurl`, `xip`, `xtime`, `xrecovery_num`, `xrecovery_time`) VALUES
	(65, 65, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-09 13:56:22\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-09 10:10:08";s:10:"updated_at";s:19:"2016-08-09 10:10:02";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-09 13:56:22";s:10:"updated_at";s:19:"2016-08-09 13:56:22";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-09 13:56:22', NULL, NULL),
	(62, 62, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-08 09:57:29\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:37:42";s:10:"updated_at";s:19:"2016-08-08 09:37:42";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:57:29";s:10:"updated_at";s:19:"2016-08-08 09:57:29";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-08 09:57:29', NULL, NULL),
	(63, 63, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-08 09:57:47\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:57:29";s:10:"updated_at";s:19:"2016-08-08 09:57:29";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:57:47";s:10:"updated_at";s:19:"2016-08-08 09:57:47";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-08 09:57:47', NULL, NULL),
	(64, 64, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-09 10:10:02\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:57:47";s:10:"updated_at";s:19:"2016-08-08 09:57:47";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-09 10:10:08";s:10:"updated_at";s:19:"2016-08-09 10:10:02";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-09 10:10:08', NULL, NULL),
	(61, 61, 8, 'update', 'xxcompany_temp', 'update `xxcompany_temp` set `xcompany_temp_data` = \'{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"3","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"1","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}\', `updated_at` = \'2016-08-08 09:57:29\' where `xcompany_tempid` = \'1\'', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"1";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-08 09:37:42";s:10:"updated_at";s:19:"2016-08-08 09:37:42";}}', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"3","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"1","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"1";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-08 09:57:29";s:10:"updated_at";s:19:"2016-08-08 09:57:29";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-08 09:57:29', NULL, NULL),
	(60, 60, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-08 09:37:42\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-06 13:32:46";s:10:"updated_at";s:19:"2016-08-06 13:32:46";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-08 09:37:42";s:10:"updated_at";s:19:"2016-08-08 09:37:42";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-08 09:37:42', NULL, NULL),
	(58, 58, 8, 'update', 'xxcompany_user', 'update `xxcompany_user` set `xcompany_userid` = \'287\', `xcompany_user_nationalcode` = \'0070960641\', `xcompany_user_name` = \'ami\', `xcompany_user_family` = \'h\', `xcompany_user_father` = \'es\', `xcompany_user_birthdate` = \'1983-05-04\', `xcompany_user_numberid` = \'145\', `updated_at` = \'2016-08-06 13:32:55\' where `xcompany_userid` = \'287\'', 'a:1:{i:0;a:11:{s:15:"xcompany_userid";s:3:"287";s:18:"xcompany_user_name";s:3:"ami";s:20:"xcompany_user_family";s:1:"h";s:26:"xcompany_user_nationalcode";s:10:"0070960641";s:20:"xcompany_user_father";s:2:"es";s:23:"xcompany_user_birthdate";s:19:"1983-05-04 00:00:00";s:22:"xcompany_user_numberid";s:3:"145";s:21:"xcompany_user_address";N;s:24:"xcompany_user_postalcode";N;s:10:"created_at";s:19:"2016-07-18 16:01:17";s:10:"updated_at";s:19:"2016-07-25 16:06:07";}}', 'a:1:{i:0;a:11:{s:15:"xcompany_userid";s:3:"287";s:18:"xcompany_user_name";s:3:"ami";s:20:"xcompany_user_family";s:1:"h";s:26:"xcompany_user_nationalcode";s:10:"0070960641";s:20:"xcompany_user_father";s:2:"es";s:23:"xcompany_user_birthdate";s:19:"1983-05-04 00:00:00";s:22:"xcompany_user_numberid";s:3:"145";s:21:"xcompany_user_address";N;s:24:"xcompany_user_postalcode";N;s:10:"created_at";s:19:"2016-07-18 16:01:17";s:10:"updated_at";s:19:"2016-08-06 13:32:55";}}', 'Customer/Company/step2', '127.0.0.1', '2016-08-06 13:32:55', NULL, NULL),
	(59, 59, 8, 'update', 'xxcompany_temp', 'update `xxcompany_temp` set `xcompany_temp_step` = \'1\', `updated_at` = \'2016-08-08 09:37:42\' where `xcompany_tempid` = \'1\'', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"2";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-06 13:32:55";s:10:"updated_at";s:19:"2016-08-06 13:32:55";}}', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"1";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-08 09:37:42";s:10:"updated_at";s:19:"2016-08-08 09:37:42";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-08 09:37:42', NULL, NULL),
	(56, NULL, 8, 'delete', 'xxcompany_userlegal', 'delete from `xxcompany_userlegal` where xcompanyid', NULL, NULL, 'Customer/Company/step2', '127.0.0.1', '2016-08-06 13:32:55', NULL, NULL),
	(57, 57, 8, 'update', 'xxcompany_user', 'update `xxcompany_user` set `xcompany_userid` = \'286\', `xcompany_user_nationalcode` = \'0200294849\', `xcompany_user_name` = \'aydin\', `xcompany_user_family` = \'abadani\', `xcompany_user_father` = \'esi\', `xcompany_user_birthdate` = \'1983-05-08\', `xcompany_user_numberid` = \'1121\', `updated_at` = \'2016-08-06 13:32:55\' where `xcompany_userid` = \'286\'', 'a:1:{i:0;a:11:{s:15:"xcompany_userid";s:3:"286";s:18:"xcompany_user_name";s:5:"aydin";s:20:"xcompany_user_family";s:7:"abadani";s:26:"xcompany_user_nationalcode";s:10:"0200294849";s:20:"xcompany_user_father";s:3:"esi";s:23:"xcompany_user_birthdate";s:19:"1983-05-08 00:00:00";s:22:"xcompany_user_numberid";s:4:"1121";s:21:"xcompany_user_address";s:15:"africa - naseri";s:24:"xcompany_user_postalcode";s:10:"1111111111";s:10:"created_at";s:19:"2016-07-18 16:01:17";s:10:"updated_at";s:19:"2016-07-25 16:06:16";}}', 'a:1:{i:0;a:11:{s:15:"xcompany_userid";s:3:"286";s:18:"xcompany_user_name";s:5:"aydin";s:20:"xcompany_user_family";s:7:"abadani";s:26:"xcompany_user_nationalcode";s:10:"0200294849";s:20:"xcompany_user_father";s:3:"esi";s:23:"xcompany_user_birthdate";s:19:"1983-05-08 00:00:00";s:22:"xcompany_user_numberid";s:4:"1121";s:21:"xcompany_user_address";s:15:"africa - naseri";s:24:"xcompany_user_postalcode";s:10:"1111111111";s:10:"created_at";s:19:"2016-07-18 16:01:17";s:10:"updated_at";s:19:"2016-08-06 13:32:55";}}', 'Customer/Company/step2', '127.0.0.1', '2016-08-06 13:32:55', NULL, NULL),
	(55, 55, 8, 'update', 'xxcompany_temp', 'update `xxcompany_temp` set `xcompany_temp_step` = \'2\', `updated_at` = \'2016-08-06 13:32:55\' where `xcompany_tempid` = \'1\'', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"1";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-06 13:32:45";s:10:"updated_at";s:19:"2016-08-06 13:32:45";}}', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"2";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-06 13:32:55";s:10:"updated_at";s:19:"2016-08-06 13:32:55";}}', 'Customer/Company/step2', '127.0.0.1', '2016-08-06 13:32:55', NULL, NULL),
	(54, 54, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompanyid` = \'45\', `xcompany_typeid` = \'3\', `xcompany_mony` = \'6575757\', `xcompany_address` = \'سشیشسیشسیشسی 3\', `xcompany_postalcode` = \'4234288875\', `xcompany_management` = \'board of directors\', `xcompany_activitiesid` = \'1\', `xagentid` = \'1\', `xuserid` = \'8\', `updated_at` = \'2016-08-06 13:32:46\' where `xcompanyid` = \'45\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-07-25 16:06:03";s:10:"updated_at";s:19:"2016-07-25 16:06:03";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"45";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:1:"1";s:15:"xcompany_typeid";s:1:"3";s:21:"xcompany_activitiesid";s:1:"1";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"6575757";s:19:"xcompany_management";s:18:"board of directors";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:26:"سشیشسیشسیشسی 3";s:19:"xcompany_postalcode";s:10:"4234288875";s:10:"created_at";s:19:"2016-08-06 13:32:46";s:10:"updated_at";s:19:"2016-08-06 13:32:46";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-06 13:32:46', NULL, NULL),
	(49, 6, 8, 'insert', 'xxrecord_edit_address', 'insert into `xxrecord_edit_address` (`xrecord_edit_address_company_name`, `xrecord_edit_address_registration_number`, `xrecord_edit_address_national_code`, `xrecord_edit_address_company_mony`, `xrecord_edit_address_company_address_from`, `xrecord_edit_address_company_address_to`, `xrecord_edit_address_company_postal_code`, `xrecord_edit_address_person_gender`, `xrecord_edit_address_person_name`) values (\'بهین سیستم\', \'111111\', \'66666666666\', \'100000\', \'آبادان - شهرک دریا \', \'تهران - نواب - هاشمی\', \'3333243333\', \'miss\', \'سمیه رضایی\')', NULL, 'a:1:{i:0;a:11:{s:22:"xrecord_edit_addressid";s:1:"6";s:33:"xrecord_edit_address_company_name";s:19:"بهین سیستم";s:40:"xrecord_edit_address_registration_number";s:6:"111111";s:34:"xrecord_edit_address_national_code";s:11:"66666666666";s:33:"xrecord_edit_address_company_mony";s:6:"100000";s:41:"xrecord_edit_address_company_address_from";s:33:"آبادان - شهرک دریا ";s:39:"xrecord_edit_address_company_address_to";s:34:"تهران - نواب - هاشمی";s:40:"xrecord_edit_address_company_postal_code";s:10:"3333243333";s:34:"xrecord_edit_address_person_gender";s:4:"miss";s:32:"xrecord_edit_address_person_name";s:19:"سمیه رضایی";s:10:"created_at";s:19:"2016-08-06 12:33:19";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:33:19', NULL, NULL),
	(50, 12, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'6\', \'نیلوفر رحیمی\', \'chief\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:2:"12";s:9:"xrecordid";s:1:"6";s:17:"xrecord_user_name";s:23:"نیلوفر رحیمی";s:17:"xrecord_user_post";s:5:"chief";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:33:19', NULL, NULL),
	(51, 13, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'6\', \'ثصقثصق\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:2:"13";s:9:"xrecordid";s:1:"6";s:17:"xrecord_user_name";s:12:"ثصقثصق";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:33:19', NULL, NULL),
	(52, 14, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'6\', \'یبلاابلا\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:2:"14";s:9:"xrecordid";s:1:"6";s:17:"xrecord_user_name";s:16:"یبلاابلا";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:33:19', NULL, NULL),
	(53, 53, 8, 'update', 'xxcompany_temp', 'update `xxcompany_temp` set `xcompany_temp_data` = \'{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}\', `xcompany_temp_step` = \'1\', `updated_at` = \'2016-08-06 13:32:45\' where `xcompany_tempid` = \'1\'', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1606:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"286"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","addressForUser":"286","frmUsereAddress":{"xcompany_user_address":"africa - naseri","xcompany_user_postalcode":"1111111111"},"contactList":{"row1":{"xcompany_membertypeid":"1","xcompany_member_name":"286"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"3";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-07-25 16:06:16";s:10:"updated_at";s:19:"2016-07-25 16:06:16";}}', 'a:1:{i:0;a:7:{s:15:"xcompany_tempid";s:1:"1";s:7:"xuserid";s:1:"8";s:18:"xcompany_temp_data";s:1527:"{"frm":{"xcompanyid":"45","xcompany_typeid":"3","xcompany_mony":"6575757","xcompany_address":"\\u0633\\u0634\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc\\u0634\\u0633\\u06cc 3","xcompany_postalcode":"4234288875","xcompany_management":"board of directors","xcompany_activitiesid":"1","xagentid":"1"},"numberReal":"2","frmuserreal":[{"xcompany_userid":"286","xcompany_user_nationalcode":"0200294849","xcompany_user_name":"aydin","xcompany_user_family":"abadani","xcompany_user_father":"esi","xcompany_user_birthdate":"1362\\/02\\/18","xcompany_user_numberid":"1121","xcompany_user_share":"41"},{"xcompany_userid":"287","xcompany_user_nationalcode":"0070960641","xcompany_user_name":"ami","xcompany_user_family":"h","xcompany_user_father":"es","xcompany_user_birthdate":"1362\\/02\\/14","xcompany_user_numberid":"145","xcompany_user_share":"59"}],"numberLegal":"0","frmUsereAddress":{"xcompany_user_address":"","xcompany_user_postalcode":""},"contactList":{"row1":{"xcompany_membertypeid":"1"}},"companyNameList":{"row1":{"xcompany_nameid":""},"row2":{"xcompany_nameid":""},"row3":{"xcompany_nameid":""}},"companyName":{"row1":{"xcompany_name":"africa"},"row2":{"xcompany_name":"taba"},"row3":{"xcompany_name":"sea"}},"companyBranchList":{"row1":{"xcompany_branchid":""}},"companyBranch":{"row1":{"xcompany_branch_address":"","xcompany_branch_postalcode":"","xcompany_branch_nationalcode":"","xcompany_branch_name":"","xcompany_branch_family":"","xcompany_branch_birthdate":"","xcompany_branch_fathername":"","xcompany_branch_numberid":""}}}";s:18:"xcompany_temp_step";s:1:"1";s:20:"xcompany_temp_status";s:6:"active";s:10:"created_at";s:19:"2016-08-06 13:32:45";s:10:"updated_at";s:19:"2016-08-06 13:32:45";}}', 'Customer/Company/step1', '127.0.0.1', '2016-08-06 13:32:45', NULL, NULL),
	(46, 9, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'5\', \'نیلوفر رحیمی\', \'chief\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:1:"9";s:9:"xrecordid";s:1:"5";s:17:"xrecord_user_name";s:23:"نیلوفر رحیمی";s:17:"xrecord_user_post";s:5:"chief";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:31:12', NULL, NULL),
	(47, 10, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'5\', \'ثصقثصق\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:2:"10";s:9:"xrecordid";s:1:"5";s:17:"xrecord_user_name";s:12:"ثصقثصق";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:31:12', NULL, NULL),
	(48, 11, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'5\', \'یبلاابلا\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:2:"11";s:9:"xrecordid";s:1:"5";s:17:"xrecord_user_name";s:16:"یبلاابلا";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:31:12', NULL, NULL),
	(45, 5, 8, 'insert', 'xxrecord_edit_address', 'insert into `xxrecord_edit_address` (`xrecord_edit_address_company_name`, `xrecord_edit_address_registration_number`, `xrecord_edit_address_national_code`, `xrecord_edit_address_company_mony`, `xrecord_edit_address_company_address_from`, `xrecord_edit_address_company_address_to`, `xrecord_edit_address_company_postal_code`, `xrecord_edit_address_person_gender`, `xrecord_edit_address_person_name`) values (\'بهین سیستم\', \'111111\', \'66666666666\', \'100000\', \'آبادان - شهرک دریا \', \'تهران - نواب - هاشمی\', \'3333243333\', \'miss\', \'سمیه رضایی\')', NULL, 'a:1:{i:0;a:11:{s:22:"xrecord_edit_addressid";s:1:"5";s:33:"xrecord_edit_address_company_name";s:19:"بهین سیستم";s:40:"xrecord_edit_address_registration_number";s:6:"111111";s:34:"xrecord_edit_address_national_code";s:11:"66666666666";s:33:"xrecord_edit_address_company_mony";s:6:"100000";s:41:"xrecord_edit_address_company_address_from";s:33:"آبادان - شهرک دریا ";s:39:"xrecord_edit_address_company_address_to";s:34:"تهران - نواب - هاشمی";s:40:"xrecord_edit_address_company_postal_code";s:10:"3333243333";s:34:"xrecord_edit_address_person_gender";s:4:"miss";s:32:"xrecord_edit_address_person_name";s:19:"سمیه رضایی";s:10:"created_at";s:19:"2016-08-06 12:31:12";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:31:12', NULL, NULL),
	(44, 44, 8, 'update', 'xxcompany', 'update `xxcompany` set `xcompany_nationalcode` = \'66666666666\', `xcompany_address` = \'تهران - نواب - هاشمی\', `xcompany_postalcode` = \'3333243333\', `updated_at` = \'2016-08-06 12:19:32\' where `xcompanyid` = \'36\'', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"36";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:3:"217";s:15:"xcompany_typeid";s:1:"4";s:21:"xcompany_activitiesid";s:1:"4";s:21:"xcompany_nationalcode";N;s:13:"xcompany_mony";s:7:"1000000";s:19:"xcompany_management";s:14:"director alone";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:33:"آبادان - شهرک دریا ";s:19:"xcompany_postalcode";s:10:"1458478748";s:10:"created_at";s:19:"2016-05-02 14:45:02";s:10:"updated_at";s:19:"2016-05-02 14:45:02";}}', 'a:1:{i:0;a:13:{s:10:"xcompanyid";s:2:"36";s:7:"xuserid";s:1:"8";s:8:"xagentid";s:3:"217";s:15:"xcompany_typeid";s:1:"4";s:21:"xcompany_activitiesid";s:1:"4";s:21:"xcompany_nationalcode";s:11:"66666666666";s:13:"xcompany_mony";s:7:"1000000";s:19:"xcompany_management";s:14:"director alone";s:15:"xcompany_branch";s:1:"1";s:16:"xcompany_address";s:34:"تهران - نواب - هاشمی";s:19:"xcompany_postalcode";s:10:"3333243333";s:10:"created_at";s:19:"2016-08-06 12:19:32";s:10:"updated_at";s:19:"2016-08-06 12:19:32";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL),
	(41, 6, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'4\', \'نسترن نیمایی\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:1:"6";s:9:"xrecordid";s:1:"4";s:17:"xrecord_user_name";s:23:"نسترن نیمایی";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL),
	(42, 7, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'4\', \'پدرام کوثری\', \'supervisor\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:1:"7";s:9:"xrecordid";s:1:"4";s:17:"xrecord_user_name";s:21:"پدرام کوثری";s:17:"xrecord_user_post";s:10:"supervisor";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL),
	(43, 8, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'4\', \'علی زندی\', \'clerk\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:1:"8";s:9:"xrecordid";s:1:"4";s:17:"xrecord_user_name";s:15:"علی زندی";s:17:"xrecord_user_post";s:5:"clerk";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL),
	(40, 5, 8, 'insert', 'xxrecord_user', 'insert into `xxrecord_user` (`xrecordid`, `xrecord_user_name`, `xrecord_user_post`) values (\'4\', \'نیلوفر رحیمی\', \'chief\')', NULL, 'a:1:{i:0;a:4:{s:14:"xrecord_userid";s:1:"5";s:9:"xrecordid";s:1:"4";s:17:"xrecord_user_name";s:23:"نیلوفر رحیمی";s:17:"xrecord_user_post";s:5:"chief";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL),
	(39, 4, 8, 'insert', 'xxrecord_edit_address', 'insert into `xxrecord_edit_address` (`xrecord_edit_address_national_code`, `xrecord_edit_address_company_address_to`, `xrecord_edit_address_company_postal_code`, `xrecord_edit_address_person_gender`, `xrecord_edit_address_person_name`, `xrecord_edit_address_company_name`, `xrecord_edit_address_registration_number`, `xrecord_edit_address_company_mony`, `xrecord_edit_address_company_address_from`) values (\'66666666666\', \'تهران - نواب - هاشمی\', \'3333243333\', \'miss\', \'سمیه رضایی\', \'تتیس\', \'1036\', \'1000000\', \'آبادان - شهرک دریا \')', NULL, 'a:1:{i:0;a:11:{s:22:"xrecord_edit_addressid";s:1:"4";s:33:"xrecord_edit_address_company_name";s:8:"تتیس";s:40:"xrecord_edit_address_registration_number";s:4:"1036";s:34:"xrecord_edit_address_national_code";s:11:"66666666666";s:33:"xrecord_edit_address_company_mony";s:7:"1000000";s:41:"xrecord_edit_address_company_address_from";s:33:"آبادان - شهرک دریا ";s:39:"xrecord_edit_address_company_address_to";s:34:"تهران - نواب - هاشمی";s:40:"xrecord_edit_address_company_postal_code";s:10:"3333243333";s:34:"xrecord_edit_address_person_gender";s:4:"miss";s:32:"xrecord_edit_address_person_name";s:19:"سمیه رضایی";s:10:"created_at";s:19:"2016-08-06 12:19:32";}}', 'Customer/Record/store', '127.0.0.1', '2016-08-06 12:19:32', NULL, NULL);
/*!40000 ALTER TABLE `xxlog` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
