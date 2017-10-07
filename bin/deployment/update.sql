USE `Ratemanagement3`;

INSERT INTO `tblIntegration` (`IntegrationID`, `CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (21, 1, 'SagePay Direct Debit', 'sagepaydirectdebit', 4, 'N');
INSERT INTO `tblIntegration` (`IntegrationID`, `CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (22, 1, 'FideliPay', 'fidelipay', 4, 'N');


INSERT INTO `tblResourceCategoriesGroups` (`CategoriesGroupID`, `GroupName`) VALUES (13, 'Reports');

INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1306, 'RateCompare.All', 1, 5);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1311, 'Report.All', 1, 13);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1310, 'Report.View', 1, 13);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1309, 'Report.Delete', 1, 13);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1308, 'Report.Edit', 1, 13);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1307, 'Report.Add', 1, 13);

INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ( 'RateCompare.*', 'RateCompareController.*', 1, 'Sumera Saeed', NULL, '2017-08-31 17:16:34.000', '2017-08-31 17:16:34.000', 1306);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.report_store', 'ReportController.report_store', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1307);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.create', 'ReportController.create', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1307);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.report_update', 'ReportController.report_update', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1308);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.edit', 'ReportController.edit', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1308);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.report_delete', 'ReportController.report_delete', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1309);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.getdatalist', 'ReportController.getdatalist', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1310);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.getdatagrid', 'ReportController.getdatagrid', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1310);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.ajax_datagrid', 'ReportController.ajax_datagrid', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1310);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.index', 'ReportController.index', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1310);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Report.*', 'ReportController.*', 1, 'Sumera Saeed', NULL, '2017-09-25 16:54:42.000', '2017-09-25 16:54:42.000', 1311);

INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (11, 'Fusion PBX', 'FusionPBX', 1, 'RateManagementSystem', '2017-08-23 10:47:22', NULL, NULL);

INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (113, 11, 'Fusion PBX Server', 'dbserver', 1, '2017-08-23 06:22:07', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (114, 11, 'Fusion PBX Username', 'username', 1, '2017-08-23 06:22:09', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (115, 11, 'Fusion PBX Password', 'password', 1, '2017-08-23 06:22:10', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (116, 11, 'Authentication Rule', 'NameFormat', 1, '2017-08-23 06:22:10', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (117, 11, 'CDR ReRate', 'RateCDR', 1, '2017-08-23 06:22:11', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (118, 11, 'Rate Format', 'RateFormat', 1, '2017-08-23 06:22:11', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (119, 11, 'CLI Translation Rule', 'CLITranslationRule', 1, '2017-08-23 06:22:12', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (120, 11, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2017-08-23 06:22:13', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (121, 11, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2017-08-23 06:22:14', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (122, 11, 'Allow Account Import', 'AllowAccountImport', 1, '2017-08-23 06:22:15', 'RateManagementSystem', NULL, NULL);
INSERT INTO tblGatewayConfig (GatewayConfigID, GatewayID, Title, Name, Status, Created_at, CreatedBy, updated_at, ModifiedBy) VALUES (123, 8, 'Auto Add IP', 'AutoAddIP', 1, '2017-08-29 11:45:38', 'RateManagementSystem', NULL, NULL);
INSERT INTO tblGatewayConfig (GatewayConfigID, GatewayID, Title, Name, Status, Created_at, CreatedBy, updated_at, ModifiedBy) VALUES (124, 3, 'Auto Add IP', 'AutoAddIP', 1, '2017-08-29 11:45:38', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (3, 'SSH Host', 'sshhost', 1, '2017-09-11 11:10:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (3, 'SSH Username', 'sshusername', 1, '2017-09-11 11:10:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (3, 'SSH Password', 'sshpassword', 1, '2017-09-11 11:10:00', 'RateManagementSystem', NULL, NULL);


UPDATE tblCompanyConfiguration SET `Value`='{"ThresholdTime":"500","SuccessEmail":"","ErrorEmail":"","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"02:00:00 AM"}' WHERE  `Key`='CUSTOMER_SUMMARYDAILY_CRONJOB';
UPDATE tblCompanyConfiguration SET `Value`='{"ThresholdTime":"500","SuccessEmail":"","ErrorEmail":"","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"2:30:00 AM"}' WHERE  `Key`='VENDOR_SUMMARYDAILY_CRONJOB';

INSERT INTO `tblCronJobCommand` ( `CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES ( 1, 11, 'Download Fusion PBX CDR', 'fusionpbxaccountusage', '[[{"title":"Fusion PBX Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-08-23 06:25:14', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 3, 'Rate Export To Vos', 'rateexporttovos', '[[{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-09-07 12:57:02', 'RateManagementSystem');

UPDATE `tblCronJobCommand` SET `GatewayID`=NULL WHERE Command='vendorratefileexport' AND `GatewayID`=10;
UPDATE `tblCronJobCommand` SET `GatewayID`=NULL WHERE Command='customerratefileexport' AND `GatewayID`=10;

UPDATE `tblGlobalAdmin` SET `EmailAddress`='globaladmin@neon-soft.com' , `password`='$2y$10$2sqYQFuptjEC5sD2eIi.l.YhByUmd8AATV/Qly8AofkaJpddBAojq' WHERE `GlobalAdminID`=1;	
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ( 1, 'FUSION_PBX_CRONJOB', '{"MaxInterval":"1440","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'FIDELIPAY_WSDL_URL', 'https://usaepay.com/soap/gate/STG4PDAE/usaepay.wsdl');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ( 1, 'CUSTOMER_DASHBOARD_DISPLAY', '1'),
( 1, 'CUSTOMER_NOTICEBOARD_DISPLAY', '1'),
( 1, 'CUSTOMER_TICKET_DISPLAY', '1'),
( 1, 'CUSTOMER_BILLING_DISPLAY', '1'),
( 1, 'CUSTOMER_BANALYSIS_DISPLAY', '1'),
( 1, 'CUSTOMER_INVOICE_DISPLAY', '1'),
( 1, 'CUSTOMER_PAYMENT_DISPLAY', '1'),
( 1, 'CUSTOMER_STATEMENT_DISPLAY', '1'),
( 1, 'CUSTOMER_PAYMENT_PROFILE_DISPLAY', '1'),
( 1, 'CUSTOMER_CDR_DISPLAY', '1'),
( 1, 'CUSTOMER_ANALYSIS_DISPLAY', '1'),
( 1, 'CUSTOMER_PROFILE_DISPLAY', '1');


ALTER TABLE `tblAccountPaymentProfile`
	CHANGE COLUMN `Options` `Options` TEXT NULL DEFAULT NULL COLLATE 'utf8_unicode_ci';

ALTER TABLE `tblDialStringCode`
	CHANGE COLUMN `ChargeCode` `ChargeCode` VARCHAR(250) NOT NULL COLLATE 'utf8_unicode_ci';	
	
ALTER TABLE `tblRateRule`	
	ADD COLUMN `Description` VARCHAR(200) NULL AFTER `Code`;	
	
ALTER TABLE `tblAccountAuditExportLog`
  ADD COLUMN `Type` VARCHAR(50) NULL DEFAULT NULL AFTER `CompanyGatewayID`;
  
ALTER TABLE `tblUser`
	ADD COLUMN `LastLoginDate` DATETIME NULL AFTER `JobNotification`;

ALTER TABLE `tblTempVendorRate`
	ADD COLUMN `CountryCode` VARCHAR(500) NULL AFTER `CodeDeckId`;

ALTER TABLE `tblTempVendorRate`
	CHANGE COLUMN `Code` `Code` TEXT NULL DEFAULT NULL COLLATE 'utf8_unicode_ci' AFTER `CountryCode`;
	
CREATE TABLE IF NOT EXISTS `tblAccountAuditExportLog` (
  `AccountAuditExportLogID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `Status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`AccountAuditExportLogID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP PROCEDURE IF EXISTS `prc_WSProcessDialString`;
DELIMITER |
CREATE PROCEDURE `prc_WSProcessDialString`(
	IN `p_processId` VARCHAR(200) ,
	IN `p_dialStringId` INT
)
BEGIN

    DECLARE v_AffectedRecords_ INT DEFAULT 0;         
    DECLARE totalduplicatecode INT(11) DEFAULT 0;	 
    DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  ( 
        Message longtext   
    );
      
     -- check duplicate code record    
      
    	DELETE n1 
	 FROM tblTempDialString n1 
	 INNER JOIN (
	 	SELECT MAX(TempDialStringID) as TempDialStringID FROM tblTempDialString WHERE ProcessId = p_processId 
		GROUP BY DialString,ChargeCode
		HAVING COUNT(*)>1
	) n2 
	 	ON n1.TempDialStringID = n2.TempDialStringID
	WHERE n1.ProcessId = p_processId;  		 		
 	
			SELECT COUNT(*) INTO totalduplicatecode FROM(
				SELECT COUNT(DialString) as c,DialString 
					FROM tblTempDialString 
						WHERE DialStringID = p_dialStringId
							 AND ProcessId = p_processId
					   GROUP BY DialString HAVING c>1) AS tbl;
	
    -- for duplicate code record    			
			
			IF  totalduplicatecode > 0
			THEN	
				
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT 
				  CONCAT(DialString , ' DUPLICATE CODE')
				  	FROM(
						SELECT   COUNT(DialString) as c,DialString
							 FROM tblTempDialString
									WHERE DialStringID = p_dialStringId
										 AND ProcessId = p_processId
						  GROUP BY DialString HAVING c>1) AS tbl;				
					
			END IF;	

IF  totalduplicatecode = 0 	
THEN	
 
   -- check and delete from tblDialStringCode where action is delete
    
	IF ( SELECT COUNT(*)
                 FROM   tblTempDialString
                 WHERE  tblTempDialString.ProcessId = p_processId
						AND tblTempDialString.DialStringID = p_dialStringId
                        AND tblTempDialString.Action = 'D'
               ) > 0
            THEN
		DELETE  tblDialStringCode
            FROM    tblDialStringCode
                    INNER JOIN tblTempDialString
						ON tblDialStringCode.DialString = tblTempDialString.DialString
                        AND tblDialStringCode.ChargeCode = tblTempDialString.ChargeCode
						AND tblDialStringCode.DialStringID = tblTempDialString.DialStringID
            WHERE   tblTempDialString.Action = 'D' AND tblTempDialString.DialStringID = p_dialStringId AND tblTempDialString.ProcessId = p_processId;   
		END IF; 
		
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
	  
      -- update description and forbidden 
		      
		UPDATE  tblDialStringCode
		JOIN tblTempDialString ON tblDialStringCode.DialString = tblTempDialString.DialString
      		AND tblDialStringCode.ChargeCode = tblTempDialString.ChargeCode            
			AND tblDialStringCode.DialStringID = tblTempDialString.DialStringID
			AND tblTempDialString.ProcessId = p_processId
            AND tblTempDialString.DialStringID = p_dialStringId
            AND tblTempDialString.Action != 'D'
		SET   tblDialStringCode.Description = tblTempDialString.Description,
            tblDialStringCode.Forbidden = tblTempDialString.Forbidden;
  
      
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
      
	  
       -- insert new record
		
            INSERT  INTO tblDialStringCode
                    ( DialStringID ,
                      DialString ,
                      ChargeCode,
                      Description ,
                      Forbidden
                    )
                    SELECT  DISTINCT
				tblTempDialString.DialStringID ,
                            tblTempDialString.DialString ,
                            tblTempDialString.ChargeCode,
                            tblTempDialString.Description ,
                            tblTempDialString.Forbidden
                    FROM    tblTempDialString left join tblDialStringCode
						on(tblDialStringCode.DialStringID = tblTempDialString.DialStringID
							AND  tblDialStringCode.DialString = tblTempDialString.DialString)
							
                    WHERE  tblDialStringCode.DialStringCodeID is null
                            AND tblTempDialString.ProcessId = p_processId
							AND tblTempDialString.DialStringID = p_dialStringId
                            AND tblTempDialString.Action != 'D';
  
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
		
 END IF;   
 
		INSERT INTO tmp_JobLog_ (Message)
		SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );
	 
	 	DELETE  FROM tblTempDialString WHERE   tblTempDialString.ProcessId = p_processId;
		SELECT * from tmp_JobLog_; 
	      
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    
END|
DELIMITER ;	

DROP PROCEDURE IF EXISTS `prc_getAccountAuditExportLog`;
DELIMITER |
CREATE PROCEDURE `prc_getAccountAuditExportLog`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT
)
BEGIN
    DECLARE v_last_time_exist INT DEFAULT 0;
    DECLARE v_last_time DATETIME;
    DECLARE v_start_time DATETIME;
    DECLARE v_end_time DATETIME;
    DECLARE v_cur_date DATE DEFAULT CURDATE();
    DECLARE v_cur_time DATETIME DEFAULT NOW();

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SELECT end_time INTO v_last_time FROM tblAccountAuditExportLog WHERE CompanyID=p_CompanyID AND CompanyGatewayID=p_GatewayID AND Type='account' AND Status=1 ORDER BY AccountAuditExportLogID DESC LIMIT 1;

    IF (v_last_time IS NOT NULL AND v_last_time != '')
    THEN
      -- SELECT end_time INTO v_last_time FROM tblAccountAuditExportLog WHERE CompanyID=p_CompanyID AND CompanyGatewayID=p_GatewayID AND Status=1 ORDER BY AccountAuditExportLogID DESC LIMIT 1;

        SELECT
             MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
        FROM
            tblAuditHeader AS tah
        LEFT JOIN
            tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
        LEFT JOIN
            tblDynamicFieldsValue AS dfv ON dfv.ParentID=tah.ParentColumnID
        LEFT JOIN
            tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
        WHERE
            df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='account' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_cur_date) AND tad.created_at>v_last_time;

        IF ((v_start_time IS NOT NULL AND v_start_time != '') AND (v_end_time IS NOT NULL AND v_end_time != ''))
        THEN
            INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,Type,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, 'account', v_start_time, v_end_time, v_cur_time);
        END IF;

        SELECT
            tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
        FROM
            tblAuditHeader AS tah
        LEFT JOIN
            tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
        LEFT JOIN
            tblDynamicFieldsValue AS dfv ON dfv.ParentID=tah.ParentColumnID
        LEFT JOIN
            tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
        WHERE
            df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='account' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_cur_date) AND tad.created_at>v_last_time;

    ELSE
        SELECT
            MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
        FROM
            tblAuditHeader AS tah
        LEFT JOIN
            tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
        LEFT JOIN
            tblDynamicFieldsValue AS dfv ON dfv.ParentID=tah.ParentColumnID
        LEFT JOIN
            tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
        WHERE
            df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='account' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;

        IF ((v_start_time IS NOT NULL AND v_start_time != '') AND (v_end_time IS NOT NULL AND v_end_time != ''))
        THEN
            INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,Type,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, 'account', v_start_time, v_end_time, v_cur_time);
        END IF;

        SELECT
            tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
        FROM
            tblAuditHeader AS tah
        LEFT JOIN
            tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
        LEFT JOIN
            tblDynamicFieldsValue AS dfv ON dfv.ParentID=tah.ParentColumnID
        LEFT JOIN
            tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
        WHERE
            df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='account' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;
    END IF;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;







DROP PROCEDURE IF EXISTS `prc_getAccountIPAuditExportLog`;
DELIMITER |
CREATE PROCEDURE `prc_getAccountIPAuditExportLog`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT
)
BEGIN
	DECLARE v_last_time_exist INT DEFAULT 0;
	DECLARE v_last_time DATETIME;
	DECLARE v_start_time DATETIME;
	DECLARE v_end_time DATETIME;
	DECLARE v_cur_date DATE DEFAULT CURDATE();
	DECLARE v_cur_time DATETIME DEFAULT NOW();

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT end_time INTO v_last_time FROM tblAccountAuditExportLog WHERE CompanyID=p_CompanyID AND CompanyGatewayID=p_GatewayID AND Type='accountip' AND Status=1 ORDER BY AccountAuditExportLogID DESC LIMIT 1;

	IF (v_last_time IS NOT NULL AND v_last_time != '')
	THEN
		SELECT
			 MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
		FROM
			tblAuditHeader AS tah
		LEFT JOIN
			tblAccountAuthenticate AS aa ON tah.ParentColumnID=aa.AccountAuthenticateID
		LEFT JOIN
			tblAccount AS a ON aa.AccountID=a.AccountID
		LEFT JOIN
			tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
		LEFT JOIN
			tblDynamicFieldsValue AS dfv ON dfv.ParentID=a.AccountID
		LEFT JOIN
			tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
		WHERE
			df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='accountip' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_cur_date) AND tad.created_at>v_last_time;

		IF ((v_start_time IS NOT NULL AND v_start_time != '') AND (v_end_time IS NOT NULL AND v_end_time != ''))
     	THEN
			INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,Type,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, 'accountip', v_start_time, v_end_time, v_cur_time);
		END IF;

		SELECT
			tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,s.ServiceName,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
		FROM
			tblAuditHeader AS tah
		LEFT JOIN
			tblAccountAuthenticate AS aa ON tah.ParentColumnID=aa.AccountAuthenticateID
		LEFT JOIN
			tblAccount AS a ON aa.AccountID=a.AccountID
		LEFT JOIN
			tblService AS s ON s.ServiceID=aa.ServiceID
		LEFT JOIN
			tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
		LEFT JOIN
			tblDynamicFieldsValue AS dfv ON dfv.ParentID=a.AccountID
		LEFT JOIN
			tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
		WHERE
			df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='accountip' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_cur_date) AND tad.created_at>v_last_time;

	ELSE
		SELECT
	   	MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
		FROM
			tblAuditHeader AS tah
		LEFT JOIN
			tblAccountAuthenticate AS aa ON tah.ParentColumnID=aa.AccountAuthenticateID
		LEFT JOIN
			tblAccount AS a ON aa.AccountID=a.AccountID
		LEFT JOIN
			tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
		LEFT JOIN
			tblDynamicFieldsValue AS dfv ON dfv.ParentID=a.AccountID
		LEFT JOIN
			tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
		WHERE
			df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='accountip' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;

		IF ((v_start_time IS NOT NULL AND v_start_time != '') AND (v_end_time IS NOT NULL AND v_end_time != ''))
    	THEN
			INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,Type,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, 'accountip', v_start_time, v_end_time, v_cur_time);
		END IF;

		SELECT
	   		tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,s.ServiceName,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
		FROM
			tblAuditHeader AS tah
		LEFT JOIN
			tblAccountAuthenticate AS aa ON tah.ParentColumnID=aa.AccountAuthenticateID
		LEFT JOIN
			tblAccount AS a ON aa.AccountID=a.AccountID
		LEFT JOIN
			tblService AS s ON s.ServiceID=aa.ServiceID
		LEFT JOIN
			tblAuditDetails AS tad ON tah.AuditHeaderID=tad.AuditHeaderID
		LEFT JOIN
			tblDynamicFieldsValue AS dfv ON dfv.ParentID=a.AccountID
		LEFT JOIN
			tblDynamicFields AS df ON df.DynamicFieldsID=dfv.DynamicFieldsID
		WHERE
			df.FieldName='Gateway' AND find_in_set(p_GatewayID,dfv.FieldValue) > 0 AND tah.Type='accountip' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;
   	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;



DROP PROCEDURE IF EXISTS `prc_GetRateTableRate`;
DELIMITER |
CREATE PROCEDURE `prc_GetRateTableRate`(
    IN `p_companyid` INT,
    IN `p_RateTableId` INT,
    IN `p_trunkID` INT,
    IN `p_contryID` INT,
    IN `p_code` VARCHAR(50),
    IN `p_description` VARCHAR(50),
    IN `p_effective` VARCHAR(50),
    IN `p_view` INT,
    IN `p_PageNumber` INT,
    IN `p_RowspPage` INT,
    IN `p_lSortCol` VARCHAR(50),
    IN `p_SortOrder` VARCHAR(5),
    IN `p_isExport` INT
)
BEGIN
    DECLARE v_OffSet_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET sql_mode = '';
    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
   CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        ID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
          ConnectionFee DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        updated_at DATETIME,
        ModifiedBy VARCHAR(50),
        RateTableRateID INT,
        RateID INT,
        INDEX tmp_RateTableRate_RateID (`RateID`)
    );
    
    
    
    INSERT INTO tmp_RateTableRate_
    SELECT
        RateTableRateID AS ID,
        Code,
        Description,
        ifnull(tblRateTableRate.Interval1,1) as Interval1,
        ifnull(tblRateTableRate.IntervalN,1) as IntervalN,
          tblRateTableRate.ConnectionFee,
        IFNULL(tblRateTableRate.Rate, 0) as Rate,
        IFNULL(tblRateTableRate.EffectiveDate, NOW()) as EffectiveDate,
        tblRateTableRate.updated_at,
        tblRateTableRate.ModifiedBy,
        RateTableRateID,
        tblRate.RateID
    FROM tblRate
    LEFT JOIN tblRateTableRate
        ON tblRateTableRate.RateID = tblRate.RateID
        AND tblRateTableRate.RateTableId = p_RateTableId
    INNER JOIN tblRateTable
        ON tblRateTable.RateTableId = tblRateTableRate.RateTableId
    WHERE       (tblRate.CompanyID = p_companyid)
        AND (p_contryID = '' OR CountryID = p_contryID)
        AND (p_code = '' OR Code LIKE REPLACE(p_code, '*', '%'))
        AND (p_description = '' OR Description LIKE REPLACE(p_description, '*', '%'))
        AND TrunkID = p_trunkID
        AND (           
            p_effective = 'All' 
        OR (p_effective = 'Now' AND EffectiveDate <= NOW() )
        OR (p_effective = 'Future' AND EffectiveDate > NOW())
            );
     
      IF p_effective = 'Now'
        THEN
           CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);          
         DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
           AND  n1.RateID = n2.RateID;
        END IF;
     
    IF p_isExport = 0
    THEN

        IF p_view = 1 -- normal view
        THEN
        SELECT * FROM tmp_RateTableRate_
                    ORDER BY CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN ModifiedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN ModifiedBy
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN RateTableRateID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN RateTableRateID
                END ASC,                
                    CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;
            
            SELECT
            COUNT(RateID) AS totalcount
            FROM tmp_RateTableRate_;
        
        ELSE  -- group by Description view
            SELECT group_concat(ID) AS ID, group_concat(Code) AS Code,Description,Interval1,Intervaln,ConnectionFee,Rate,EffectiveDate,MAX(updated_at) AS updated_at,MAX(ModifiedBy) AS ModifiedBy,group_concat(ID) AS RateTableRateID,group_concat(RateID) AS RateID FROM tmp_RateTableRate_
                    GROUP BY Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate
                    ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN ModifiedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN ModifiedBy
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN RateTableRateID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN RateTableRateID
                END ASC,                
                    CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;
            
            SELECT COUNT(*) AS `totalcount`
            FROM (
                SELECT
                Description
                FROM tmp_RateTableRate_
                    GROUP BY Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate
            ) totalcount;
            
        -- END IF p_view = 1
        END IF;
    
    END IF;

    IF p_isExport = 1
    THEN

        SELECT
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate,
            updated_at,
            ModifiedBy

        FROM   tmp_RateTableRate_;
         

    END IF;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    
END|
DELIMITER ;






DROP PROCEDURE IF EXISTS `prc_AddAccountIPCLI`;
DELIMITER |
CREATE PROCEDURE `prc_AddAccountIPCLI`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_CustomerVendorCheck` INT,
	IN `p_IPCLIString` LONGTEXT,
	IN `p_IPCLICheck` LONGTEXT,
	IN `p_ServiceID` INT
)
BEGIN

	DECLARE i int;
	DECLARE v_COUNTER int;
	DECLARE v_IPCLI LONGTEXT;
	DECLARE v_IPCLICheck VARCHAR(10);
	DECLARE v_Check int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLI`; 
		CREATE TEMPORARY TABLE `AccountIPCLI` (
		  `AccountName` varchar(45) NOT NULL,
		  `IPCLI` LONGTEXT NOT NULL
		);

	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLITable1`; 
		CREATE TEMPORARY TABLE `AccountIPCLITable1` (
		  `splitted_column` varchar(45) NOT NULL
		);
		
	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLITable2`; 
		CREATE TEMPORARY TABLE `AccountIPCLITable2` (
		  `splitted_column` varchar(45) NOT NULL
		);
	
		
	INSERT INTO AccountIPCLI
	SELECT acc.AccountName,
	CONCAT(
	IFNULL(((CASE WHEN CustomerAuthRule = p_IPCLICheck THEN accauth.CustomerAuthValue ELSE '' END)),''),',',
	IFNULL(((CASE WHEN VendorAuthRule = p_IPCLICheck THEN accauth.VendorAuthValue ELSE '' END)),'')) as Authvalue
	FROM tblAccountAuthenticate accauth
	INNER JOIN tblAccount acc ON acc.AccountID = accauth.AccountID
	AND accauth.CompanyID = p_CompanyID
	AND ((CustomerAuthRule = p_IPCLICheck) OR (VendorAuthRule = p_IPCLICheck))
	WHERE 
		((SELECT fnFIND_IN_SET(CONCAT(IFNULL(accauth.CustomerAuthValue,''),',',IFNULL(accauth.VendorAuthValue,'')),p_IPCLIString) WHERE accauth.AccountID != p_AccountID) > 0)
		OR
		CASE(p_CustomerVendorCheck)
			WHEN 1 THEN
				(SELECT fnFIND_IN_SET(IFNULL(accauth.CustomerAuthValue,''),p_IPCLIString) WHERE accauth.AccountID = p_AccountID) > 0
			WHEN 2 THEN
				(SELECT fnFIND_IN_SET(IFNULL(accauth.VendorAuthValue,''),p_IPCLIString) WHERE accauth.AccountID = p_AccountID) > 0
		END
	;
	
	SELECT COUNT(AccountName) INTO v_COUNTER FROM AccountIPCLI;
	
	
	IF v_COUNTER > 0 THEN
		SELECT *  FROM AccountIPCLI;
		
		
		SET i = 1;
		REPEAT
			INSERT INTO AccountIPCLITable1
			SELECT FnStringSplit(p_IPCLIString, ',', i) WHERE FnStringSplit(p_IPCLIString, ',', i) IS NOT NULL LIMIT 1;
			SET i = i + 1;
			UNTIL ROW_COUNT() = 0
		END REPEAT;
		
		
		INSERT INTO AccountIPCLITable2
		SELECT AccountIPCLITable1.splitted_column FROM AccountIPCLI,AccountIPCLITable1
		WHERE FIND_IN_SET(AccountIPCLITable1.splitted_column,AccountIPCLI.IPCLI)>0
		GROUP BY AccountIPCLITable1.splitted_column;
		
		
		DELETE t1 FROM AccountIPCLITable1 t1
		INNER JOIN AccountIPCLITable2 t2 ON t1.splitted_column = t2.splitted_column
		WHERE t1.splitted_column=t2.splitted_column;
		
		SELECT GROUP_CONCAT(t.splitted_column separator ',') INTO p_IPCLIString FROM AccountIPCLITable1 t;
		
		
		DELETE t1,t2 FROM AccountIPCLITable1 t1,AccountIPCLITable2 t2;
	END IF;
	
	
	SELECT 
	accauth.AccountAuthenticateID, 
	(CASE WHEN p_CustomerVendorCheck = 1 THEN accauth.CustomerAuthValue ELSE accauth.VendorAuthValue END) as AuthValue,
	(CASE WHEN p_CustomerVendorCheck = 1 THEN accauth.CustomerAuthRule ELSE accauth.VendorAuthRule END) as AuthRule INTO v_Check,v_IPCLI,v_IPCLICheck
	FROM tblAccountAuthenticate accauth 
	WHERE accauth.CompanyID =  p_CompanyID
	AND accauth.ServiceID = p_ServiceID
	AND accauth.AccountID = p_AccountID;
			
	IF v_Check > 0 && p_IPCLIString IS NOT NULL && p_IPCLIString!='' THEN
		IF v_IPCLICheck != p_IPCLICheck THEN
		
			IF p_CustomerVendorCheck = 1 THEN
				UPDATE tblAccountAuthenticate accauth SET accauth.CustomerAuthValue = ''
				WHERE accauth.CompanyID =  p_CompanyID
				AND accauth.ServiceID = p_ServiceID
				AND accauth.AccountID = p_AccountID;
			ELSEIF p_CustomerVendorCheck = 2 THEN
				UPDATE tblAccountAuthenticate accauth SET accauth.VendorAuthValue = ''
				WHERE accauth.CompanyID =  p_CompanyID
				AND accauth.ServiceID = p_ServiceID
				AND accauth.AccountID = p_AccountID;
			END IF;
			SET v_IPCLI = p_IPCLIString;
		ELSE
			
				SET i = 1;
				REPEAT
					INSERT INTO AccountIPCLITable1
					SELECT FnStringSplit(v_IPCLI, ',', i) WHERE FnStringSplit(v_IPCLI, ',', i) IS NOT NULL LIMIT 1;
					SET i = i + 1;
					UNTIL ROW_COUNT() = 0
				END REPEAT;
			
				SET i = 1;
				REPEAT
					INSERT INTO AccountIPCLITable2
					SELECT FnStringSplit(p_IPCLIString, ',', i) WHERE FnStringSplit(p_IPCLIString, ',', i) IS NOT NULL LIMIT 1;
					SET i = i + 1;
					UNTIL ROW_COUNT() = 0
				END REPEAT;
				
				
				SELECT GROUP_CONCAT(t.splitted_column separator ',') INTO v_IPCLI
				FROM
				(
				SELECT splitted_column FROM AccountIPCLITable1
				UNION
				SELECT splitted_column FROM AccountIPCLITable2
				GROUP BY splitted_column
				ORDER BY splitted_column
				) t;
		END IF;
			
			
		IF p_CustomerVendorCheck = 1 THEN
			UPDATE tblAccountAuthenticate accauth SET accauth.CustomerAuthValue = v_IPCLI, accauth.CustomerAuthRule = p_IPCLICheck
			WHERE accauth.CompanyID =  p_CompanyID
			AND accauth.ServiceID = p_ServiceID
			AND accauth.AccountID = p_AccountID;
		ELSEIF p_CustomerVendorCheck = 2 THEN
			UPDATE tblAccountAuthenticate accauth SET accauth.VendorAuthValue = v_IPCLI, accauth.VendorAuthRule = p_IPCLICheck
			WHERE accauth.CompanyID =  p_CompanyID
			AND accauth.ServiceID = p_ServiceID
			AND accauth.AccountID = p_AccountID;
		END IF;
	ELSEIF v_Check IS NULL && p_IPCLIString IS NOT NULL && p_IPCLIString!='' THEN
	
		IF p_CustomerVendorCheck = 1 THEN
			INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,CustomerAuthRule,CustomerAuthValue,ServiceID)
			SELECT p_CompanyID,p_AccountID,p_IPCLICheck,p_IPCLIString,p_ServiceID;
		ELSEIF p_CustomerVendorCheck = 2 THEN
			INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,VendorAuthRule,VendorAuthValue,ServiceID)
			SELECT p_CompanyID,p_AccountID,p_IPCLICheck,p_IPCLIString,p_ServiceID;
		END IF;
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
	
END|
DELIMITER ;




DROP PROCEDURE IF EXISTS `prc_GetAccountLogs`;
DELIMITER |
CREATE PROCEDURE `prc_GetAccountLogs`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_AccountID` int ,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5)
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SELECT * FROM
	(
		(
			SELECT
				d.ColumnName,
				CASE
					WHEN (d.ColumnName='accountgateway') THEN
						GROUP_CONCAT(DISTINCT cgo.Title)
					WHEN (d.ColumnName='IsCustomer' AND d.OldValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsCustomer' AND d.OldValue=1) THEN
						'YES'
					WHEN (d.ColumnName='IsVendor' AND d.OldValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsVendor' AND d.OldValue=1) THEN
						'YES'
					ELSE
						d.OldValue
				END AS OldValue,
				CASE
					WHEN (d.ColumnName='accountgateway') THEN
						GROUP_CONCAT(DISTINCT cgn.Title)
					WHEN (d.ColumnName='IsCustomer' AND d.NewValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsCustomer' AND d.NewValue=1) THEN
						'YES'
					WHEN (d.ColumnName='IsVendor' AND d.NewValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsVendor' AND d.NewValue=1) THEN
						'YES'
					ELSE
						d.NewValue
				END AS NewValue,
				d.created_at,
				d.created_by
			FROM tblAuditDetails AS d
			LEFT JOIN tblAuditHeader AS h
				ON h.AuditHeaderID = d.AuditHeaderID
			LEFT JOIN tblAccount AS a
				ON h.ParentColumnID = a.AccountID
			LEFT JOIN tblCompanyGateway AS cgo
				ON FIND_IN_SET(cgo.CompanyGatewayID,d.OldValue)
			LEFT JOIN tblCompanyGateway AS cgn
				ON FIND_IN_SET(cgn.CompanyGatewayID,d.NewValue)
			WHERE   
				h.Type = 'account' AND 
				h.ParentColumnName = 'AccountID' AND 
				h.ParentColumnID = p_AccountID AND 
				a.AccountID = p_AccountID
			GROUP BY
				d.AuditDetailID,d.OldValue,d.NewValue
		)
		
		UNION
		
		(
			SELECT
				IF(d2.ColumnName="CustomerAuthValue","Customer IP","Vendor IP"),
				d2.OldValue AS OldValue,
				d2.NewValue AS NewValue,
				d2.created_at,
				d2.created_by
			FROM tblAuditDetails AS d2
			LEFT JOIN tblAuditHeader AS h2
				ON h2.AuditHeaderID = d2.AuditHeaderID
			LEFT JOIN tblAccountAuthenticate AS aa
				ON aa.AccountAuthenticateID=h2.ParentColumnID
			LEFT JOIN tblAccount AS a2
				ON aa.AccountID = a2.AccountID
			WHERE   
				h2.Type = 'accountip' AND 
				h2.ParentColumnName = 'AccountAuthenticateID' AND 
				a2.AccountID = p_AccountID
			GROUP BY
				d2.AuditDetailID,d2.OldValue,d2.NewValue
		)
	) mix

	ORDER BY
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ColumnNameDESC') THEN mix.ColumnName
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ColumnNameASC') THEN mix.ColumnName
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN mix.created_at
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN mix.created_at
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_byDESC') THEN mix.created_by
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_byASC') THEN mix.created_by
		END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;

	SELECT 
		COUNT(*) AS totalcount
	FROM
	(
		(
			SELECT
				d.ColumnName,
				CASE
					WHEN (d.ColumnName='accountgateway') THEN
						GROUP_CONCAT(DISTINCT cgo.Title)
					WHEN (d.ColumnName='IsCustomer' AND d.OldValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsCustomer' AND d.OldValue=1) THEN
						'YES'
					WHEN (d.ColumnName='IsVendor' AND d.OldValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsVendor' AND d.OldValue=1) THEN
						'YES'
					ELSE
						d.OldValue
				END AS OldValue,
				CASE
					WHEN (d.ColumnName='accountgateway') THEN
						GROUP_CONCAT(DISTINCT cgn.Title)
					WHEN (d.ColumnName='IsCustomer' AND d.NewValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsCustomer' AND d.NewValue=1) THEN
						'YES'
					WHEN (d.ColumnName='IsVendor' AND d.NewValue=0) THEN
						'NO'
					WHEN (d.ColumnName='IsVendor' AND d.NewValue=1) THEN
						'YES'
					ELSE
						d.NewValue
				END AS NewValue,
				d.created_at,
				d.created_by
			FROM tblAuditDetails AS d
			LEFT JOIN tblAuditHeader AS h
				ON h.AuditHeaderID = d.AuditHeaderID
			LEFT JOIN tblAccount AS a
				ON h.ParentColumnID = a.AccountID
			LEFT JOIN tblCompanyGateway AS cgo
				ON FIND_IN_SET(cgo.CompanyGatewayID,d.OldValue)
			LEFT JOIN tblCompanyGateway AS cgn
				ON FIND_IN_SET(cgn.CompanyGatewayID,d.NewValue)
			WHERE   
				h.Type = 'account' AND 
				h.ParentColumnName = 'AccountID' AND 
				h.ParentColumnID = p_AccountID AND 
				a.AccountID = p_AccountID
			GROUP BY
				d.AuditDetailID,d.OldValue,d.NewValue
		)
		
		UNION
		
		(
			SELECT
				d2.ColumnName,
				d2.OldValue AS OldValue,
				d2.NewValue AS NewValue,
				d2.created_at,
				d2.created_by
			FROM tblAuditDetails AS d2
			LEFT JOIN tblAuditHeader AS h2
				ON h2.AuditHeaderID = d2.AuditHeaderID
			LEFT JOIN tblAccountAuthenticate AS aa
				ON aa.AccountAuthenticateID=h2.ParentColumnID
			LEFT JOIN tblAccount AS a2
				ON aa.AccountID = a2.AccountID
			WHERE   
				h2.Type = 'accountip' AND 
				h2.ParentColumnName = 'AccountAuthenticateID' AND 
				a2.AccountID = p_AccountID
			GROUP BY
				d2.AuditDetailID,d2.OldValue,d2.NewValue
		)
	) totalcount;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;





DROP PROCEDURE IF EXISTS `prc_WSProcessImportAccountIP`;
DELIMITER |
CREATE PROCEDURE `prc_WSProcessImportAccountIP`(
	IN `p_processId` VARCHAR(200),
	IN `p_companyId` INT
)
BEGIN
    DECLARE v_AffectedRecords_ INT DEFAULT 0;
	DECLARE totalduplicatecode INT(11);
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;
	DECLARE v_accounttype INT DEFAULT 0;
	DECLARE i INT;

	SET sql_mode = '';
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION sql_mode='';

	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  (
        Message longtext
    );

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountAuthenticate_;
    CREATE TEMPORARY TABLE tmp_AccountAuthenticate_  (
        CompanyID INT,
        AccountID INT,
        IsCustomerOrVendor VARCHAR(20),
        IP TEXT	
    );
	
	SET i = 1;
	REPEAT
		INSERT INTO tmp_AccountAuthenticate_ (CompanyID, AccountID, IsCustomerOrVendor, IP)
		SELECT CompanyID, AccountID, 'Customer', FnStringSplit(CustomerAuthValue, ',', i)  FROM tblAccountAuthenticate
			WHERE CustomerAuthRule='IP' AND FnStringSplit(CustomerAuthValue, ',' , i) IS NOT NULL;
	SET i = i + 1;
	UNTIL ROW_COUNT() = 0
	END REPEAT;
	  
	SET i = 1;
	REPEAT
		INSERT INTO tmp_AccountAuthenticate_ (CompanyID, AccountID, IsCustomerOrVendor, IP)
		SELECT CompanyID, AccountID, 'Vendor', FnStringSplit(VendorAuthValue, ',', i)  FROM tblAccountAuthenticate
			WHERE VendorAuthRule='IP' AND FnStringSplit(VendorAuthValue, ',' , i) IS NOT NULL;
	SET i = i + 1;
	UNTIL ROW_COUNT() = 0
	END REPEAT;
    

    DELETE n1
		FROM tblTempAccountIP n1
		INNER JOIN (
			SELECT MAX(tblTempAccountIPID) as tblTempAccountIPID FROM tblTempAccountIP WHERE ProcessID = p_processId
			GROUP BY CompanyID,AccountName,IP,Type
			HAVING COUNT(*)>1
		) n2 ON n1.tblTempAccountIPID = n2.tblTempAccountIPID
		WHERE n1.ProcessID = p_processId;

		

		DELETE tblTempAccountIP
			FROM tblTempAccountIP
			INNER JOIN(
				SELECT 
					ta.tblTempAccountIPID
				FROM 
					tblTempAccountIP ta 
				LEFT JOIN 
					tblAccount a ON a.AccountName = ta.AccountName
				LEFT JOIN 
					tmp_AccountAuthenticate_ aa 
				ON
					(aa.IP=ta.IP AND a.AccountID != aa.AccountID) 
					OR
					(aa.IP=ta.IP AND ta.Type = aa.IsCustomerOrVendor) 
				WHERE ta.ProcessID = p_processId AND aa.CompanyID = p_companyId
			) aold ON aold.tblTempAccountIPID = tblTempAccountIP.tblTempAccountIPID;


 		DROP TEMPORARY TABLE IF EXISTS tmp_accountipimport;
		CREATE TEMPORARY TABLE tmp_accountipimport (
						  `CompanyID` INT,
						  `AccountID` INT,
						  `AccountName` VARCHAR(100),
						  `IP` LONGTEXT,
						  `Type` VARCHAR(50),
						  `ProcessID` VARCHAR(50),
						  `ServiceID` INT,
						  `created_at` DATETIME,
						  `created_by` VARCHAR(50)
		) ENGINE=InnoDB;

		INSERT INTO tmp_accountipimport(`CompanyID`,`AccountName`,`IP`,`Type`,`ProcessID`,`ServiceID`,`created_at`,`created_by`)
		select CompanyID,AccountName,IP,Type,ProcessID,ServiceID,created_at,created_by FROM tblTempAccountIP WHERE ProcessID = p_processId;

		UPDATE tmp_accountipimport ta LEFT JOIN tblAccount a ON ta.AccountName=a.AccountName
				SET ta.AccountID = a.AccountID
		WHERE a.AccountID IS NOT NULL AND a.AccountType=1 AND a.CompanyId=p_companyId;

		DROP TEMPORARY TABLE IF EXISTS tmp_accountcustomerip;
			CREATE TEMPORARY TABLE tmp_accountcustomerip (
							  `CompanyID` INT,
							  `AccountID` INT,
							  `CustomerAuthRule` VARCHAR(50),
							  `CustomerAuthValue` VARCHAR(8000),
							  `ServiceID` INT
			) ENGINE=InnoDB;

		DROP TEMPORARY TABLE IF EXISTS tmp_accountvendorip;
			CREATE TEMPORARY TABLE tmp_accountvendorip (
							  `CompanyID` INT,
							  `AccountID` INT,
							  `VendorAuthRule` VARCHAR(50),
							  `VendorAuthValue` VARCHAR(500),
							  `ServiceID` INT
			) ENGINE=InnoDB;
		INSERT INTO tmp_accountcustomerip(CompanyID,AccountID,CustomerAuthRule,CustomerAuthValue,ServiceID)
		select CompanyID,AccountID,'IP' as CustomerAuthRule, GROUP_CONCAT(IP) as CustomerAuthValue,ServiceID from tmp_accountipimport where Type='Customer' GROUP BY AccountID,ServiceID;

		INSERT INTO tmp_accountvendorip(CompanyID,AccountID,VendorAuthRule,VendorAuthValue,ServiceID)
		select CompanyID,AccountID,'IP' as VendorAuthRule, GROUP_CONCAT(IP) as VendorAuthValue,ServiceID from tmp_accountipimport where Type='Vendor' GROUP BY AccountID,ServiceID;

		

		INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,CustomerAuthRule,CustomerAuthValue,ServiceID)
			SELECT ac.CompanyID,ac.AccountID,ac.CustomerAuthRule,'',ac.ServiceID
				FROM tmp_accountcustomerip ac LEFT JOIN tblAccountAuthenticate aa
					ON ac.AccountID=aa.AccountID AND ac.ServiceID=aa.ServiceID
			 WHERE aa.AccountID IS NULL;


			INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,VendorAuthRule,VendorAuthValue,ServiceID)
			SELECT av.CompanyID,av.AccountID,av.VendorAuthRule,'',av.ServiceID
				FROM tmp_accountvendorip av LEFT JOIN tblAccountAuthenticate aa
					ON av.AccountID=aa.AccountID AND av.ServiceID=aa.ServiceID
			WHERE aa.AccountID IS NULL;

		

		UPDATE tmp_accountcustomerip ac LEFT JOIN tblAccountAuthenticate aa ON ac.AccountID=aa.AccountID AND ac.ServiceID=aa.ServiceID
				SET	aa.CustomerAuthRule='IP',aa.CustomerAuthValue =
					CASE WHEN((aa.CustomerAuthValue IS NULL) OR (aa.CustomerAuthValue='') OR (aa.CustomerAuthRule!='IP'))
								THEN
									  ac.CustomerAuthValue
								ELSE
									  CONCAT(aa.CustomerAuthValue,',',ac.CustomerAuthValue)
								END
			WHERE ac.AccountID IS NOT NULL AND aa.AccountID IS NOT NULL;


			UPDATE tmp_accountvendorip av LEFT JOIN tblAccountAuthenticate aa ON av.AccountID=aa.AccountID AND av.ServiceID=aa.ServiceID
				SET aa.VendorAuthRule='IP',aa.VendorAuthValue =
					CASE WHEN (aa.VendorAuthValue IS NULL) OR (aa.VendorAuthValue='') OR (aa.VendorAuthRule!='IP')
								THEN
									 av.VendorAuthValue
								ELSE
									CONCAT(aa.VendorAuthValue,',',av.VendorAuthValue)
								END
			 WHERE av.AccountID IS NOT NULL AND aa.AccountID IS NOT NULL;


			SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

			INSERT INTO tmp_JobLog_ (Message)
			SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );

			DELETE  FROM tblTempAccountIP WHERE ProcessID = p_processId;

		SELECT * from tmp_JobLog_;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;





DROP PROCEDURE IF EXISTS `prc_SplitVendorRate`;
DELIMITER |
CREATE PROCEDURE `prc_SplitVendorRate`(
	IN `p_processId` VARCHAR(200),
	IN `p_dialcodeSeparator` VARCHAR(50)
)
ThisSP:BEGIN

	DECLARE i INTEGER;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_TempVendorRateID_ INT;
	DECLARE v_Code_ TEXT;
	DECLARE v_CountryCode_ VARCHAR(500);	
	DECLARE newcodecount INT(11) DEFAULT 0;
	
	IF p_dialcodeSeparator !='null'
	THEN
	
	
	
	
	
	DROP TEMPORARY TABLE IF EXISTS `my_splits`;
	CREATE TEMPORARY TABLE `my_splits` (
		`TempVendorRateID` INT(11) NULL DEFAULT NULL,
		`Code` Text NULL DEFAULT NULL,
		`CountryCode` Text NULL DEFAULT NULL
	);
    
  SET i = 1;
  REPEAT
    INSERT INTO my_splits (TempVendorRateID, Code, CountryCode)
      SELECT TempVendorRateID , FnStringSplit(Code, p_dialcodeSeparator, i), CountryCode  FROM tblTempVendorRate
      WHERE FnStringSplit(Code, p_dialcodeSeparator , i) IS NOT NULL
			 AND ProcessId = p_processId;
    SET i = i + 1;
    UNTIL ROW_COUNT() = 0
  END REPEAT;
  
  UPDATE my_splits SET Code = trim(Code);
  
	-- UPDATE my_splits SET Code = trim(SUBSTR(Code, LOCATE(' ', Code)));
  

  DROP TEMPORARY TABLE IF EXISTS tmp_newvendor_splite_;
	CREATE TEMPORARY TABLE tmp_newvendor_splite_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempVendorRateID INT(11) NULL DEFAULT NULL,
		Code VARCHAR(500) NULL DEFAULT NULL,
		CountryCode VARCHAR(500) NULL DEFAULT NULL
	);
	
	INSERT INTO tmp_newvendor_splite_(TempVendorRateID,Code,CountryCode)
	SELECT 
		TempVendorRateID,
		Code,
		CountryCode
	FROM my_splits
	WHERE Code like '%-%'
		AND TempVendorRateID IS NOT NULL;

  	
  
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_newvendor_splite_);
	
	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_TempVendorRateID_ = (SELECT TempVendorRateID FROM tmp_newvendor_splite_ t WHERE t.RowID = v_pointer_); 
		SET v_Code_ = (SELECT Code FROM tmp_newvendor_splite_ t WHERE t.RowID = v_pointer_);
		SET v_CountryCode_ = (SELECT CountryCode FROM tmp_newvendor_splite_ t WHERE t.RowID = v_pointer_);
		
		Call prc_SplitAndInsertVendorRate(v_TempVendorRateID_,v_Code_,v_CountryCode_);
		
	SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
	DELETE FROM my_splits
		WHERE Code like '%-%'
			AND TempVendorRateID IS NOT NULL;

	DELETE FROM my_splits
		WHERE Code = '' OR Code IS NULL;
			
	 INSERT INTO tmp_split_VendorRate_
	SELECT DISTINCT
		   my_splits.TempVendorRateID as `TempVendorRateID`,
		   `CodeDeckId`,
		   CONCAT(IFNULL(my_splits.CountryCode,''),my_splits.Code) as Code,
		   `Description`,
			`Rate`,
			`EffectiveDate`,
			`Change`,
			`ProcessId`,
			`Preference`,
			`ConnectionFee`,
			`Interval1`,
			`IntervalN`,
			`Forbidden`,
			`DialStringPrefix`
		 FROM my_splits
		   INNER JOIN tblTempVendorRate 
				ON my_splits.TempVendorRateID = tblTempVendorRate.TempVendorRateID
		  WHERE	tblTempVendorRate.ProcessId = p_processId;	
		  
	END IF;
	
  	-- select * from tmp_split_VendorRate_;
	-- LEAVE ThisSP;
  
	IF p_dialcodeSeparator = 'null'
	THEN
	
		INSERT INTO tmp_split_VendorRate_
		SELECT DISTINCT
			  `TempVendorRateID`,
			  `CodeDeckId`,
			   `Code`,
			   `Description`,
				`Rate`,
				`EffectiveDate`,
				`Change`,
				`ProcessId`,
				`Preference`,
				`ConnectionFee`,
				`Interval1`,
				`IntervalN`,
				`Forbidden`,
				`DialStringPrefix`
			 FROM tblTempVendorRate
			  WHERE ProcessId = p_processId;	
	
	END IF;	
		
END|
DELIMITER ;





DROP PROCEDURE IF EXISTS `prc_SplitAndInsertVendorRate`;
DELIMITER |
CREATE PROCEDURE `prc_SplitAndInsertVendorRate`(
	IN `TempVendorRateID` INT,
	IN `Code` VARCHAR(500),
	IN `p_countryCode` VARCHAR(50)
)
BEGIN

	DECLARE v_First_ INT;
	DECLARE v_Last_ INT;	
		
	SELECT  REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 1)
                 , LENGTH(SUBSTRING_INDEX(Code, '-', 0)) + 1)
                 , '-'
                 , '') INTO v_First_;
                 
	 SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 2)
                 , LENGTH(SUBSTRING_INDEX(Code, '-', 1)) + 1)
                 , '-'
                 , '') INTO v_Last_;                 
	
	
   WHILE v_Last_ >= v_First_
	DO
   	 INSERT my_splits (TempVendorRateID,Code,CountryCode) VALUES (TempVendorRateID,v_Last_,p_countryCode);
	    SET v_Last_ = v_Last_ - 1;
  END WHILE;
	
END|
DELIMITER ;





DROP PROCEDURE IF EXISTS `prc_checkDialstringAndDupliacteCode`;
DELIMITER |
CREATE PROCEDURE `prc_checkDialstringAndDupliacteCode`(
	IN `p_companyId` INT,
	IN `p_processId` VARCHAR(200) ,
	IN `p_dialStringId` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_dialcodeSeparator` VARCHAR(50)
)
BEGIN
	
    DECLARE totaldialstringcode INT(11) DEFAULT 0;	 
    DECLARE     v_CodeDeckId_ INT ;
  	 DECLARE totalduplicatecode INT(11);	 
  	 DECLARE errormessage longtext;
	 DECLARE errorheader longtext;


DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_ ;			
	 CREATE TEMPORARY TABLE `tmp_VendorRateDialString_` (						
						`CodeDeckId` int ,
						`Code` varchar(50) ,
						`Description` varchar(200) ,
						`Rate` decimal(18, 6) ,
						`EffectiveDate` Datetime ,
						`Change` varchar(100) ,
						`ProcessId` varchar(200) ,
						`Preference` varchar(100) ,
						`ConnectionFee` decimal(18, 6),
						`Interval1` int,
						`IntervalN` int,
						`Forbidden` varchar(100) ,
						`DialStringPrefix` varchar(500)
					);
		
		
		
		CALL prc_SplitVendorRate(p_processId,p_dialcodeSeparator);							
		
		DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_2;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_split_VendorRate_2 as (SELECT * FROM tmp_split_VendorRate_);
                                             
	     DELETE n1 FROM tmp_split_VendorRate_ n1, tmp_split_VendorRate_2 n2 
     WHERE n1.EffectiveDate < n2.EffectiveDate 
	 	AND n1.CodeDeckId = n2.CodeDeckId
		AND  n1.Code = n2.Code
		AND  n1.ProcessId = n2.ProcessId
 		AND  n1.ProcessId = p_processId AND n2.ProcessId = p_processId;

		  INSERT INTO tmp_TempVendorRate_
	        SELECT DISTINCT `CodeDeckId`,
			  						`Code`,
									`Description`,
									`Rate`,
									`EffectiveDate`,
									`Change`,
									`ProcessId`,
									`Preference`,
									`ConnectionFee`,
									`Interval1`,
									`IntervalN`,
									`Forbidden`,
									`DialStringPrefix`
						 FROM tmp_split_VendorRate_
						 	 WHERE tmp_split_VendorRate_.ProcessId = p_processId;
			
		
	 	     SELECT CodeDeckId INTO v_CodeDeckId_ 
					FROM tmp_TempVendorRate_
						 WHERE ProcessId = p_processId  LIMIT 1;

            UPDATE tmp_TempVendorRate_ as tblTempVendorRate
            LEFT JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                AND tblRate.CompanyID = p_companyId
                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                AND tblRate.CodeDeckId =  v_CodeDeckId_
            SET  
                tblTempVendorRate.Interval1 = CASE WHEN tblTempVendorRate.Interval1 is not null  and tblTempVendorRate.Interval1 > 0
                                            THEN    
                                                tblTempVendorRate.Interval1
                                            ELSE
                                            CASE WHEN tblRate.Interval1 is not null  
                                            THEN    
                                                tblRate.Interval1
                                            ELSE CASE WHEN tblTempVendorRate.Interval1 is null and (tblTempVendorRate.Description LIKE '%gambia%' OR tblTempVendorRate.Description LIKE '%mexico%')
                                                 THEN 
                                                    60
                                            ELSE CASE WHEN tblTempVendorRate.Description LIKE '%USA%' 
                                                 THEN 
                                                    6
                                                 ELSE 
                                                    1
                                                END
                                            END

                                            END
                                            END,
                tblTempVendorRate.IntervalN = CASE WHEN tblTempVendorRate.IntervalN is not null  and tblTempVendorRate.IntervalN > 0
                                            THEN    
                                                tblTempVendorRate.IntervalN
                                            ELSE
                                                CASE WHEN tblRate.IntervalN is not null 
                                          THEN
                                            tblRate.IntervalN
                                          ElSE
                                            CASE
                                                WHEN tblTempVendorRate.Description LIKE '%mexico%' THEN 60
                                            ELSE CASE
                                                WHEN tblTempVendorRate.Description LIKE '%USA%' THEN 6
                                                
                                            ELSE 
                                            1
                                            END
                                            END
                                          END
                                          END;

 			
			IF  p_effectiveImmediately = 1
            THEN
            
            	
            
                UPDATE tmp_TempVendorRate_
           	     SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
           		     WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

            END IF;
			
			
			SELECT count(*) INTO totalduplicatecode FROM(
				SELECT count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl;
				
			
			IF  totalduplicatecode > 0
			THEN	
			
			
				SELECT GROUP_CONCAT(code) into errormessage FROM(
					SELECT DISTINCT code, 1 as a FROM(
						SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl) as tbl2 GROUP by a;				
				
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT 
				  CONCAT(code , ' DUPLICATE CODE')
				  	FROM(
						SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl;				
					
			END IF;
							
   IF	totalduplicatecode = 0
   THEN
						
	 
    IF p_dialstringid >0
    THEN
    		
    		DROP TEMPORARY TABLE IF EXISTS tmp_DialString_;
    		CREATE TEMPORARY TABLE tmp_DialString_ (
				`DialStringID` INT,
				`DialString` VARCHAR(250),
				`ChargeCode` VARCHAR(250),
				`Description` VARCHAR(250),
				`Forbidden` VARCHAR(50),
				INDEX tmp_DialStringID (`DialStringID`),			
	         INDEX tmp_DialStringID_ChargeCode (`DialStringID`,`ChargeCode`)
         );

         INSERT INTO tmp_DialString_ 
			SELECT DISTINCT
				`DialStringID`,
				`DialString`,
				`ChargeCode`,
				`Description`,
				`Forbidden`
			FROM tblDialStringCode
				WHERE DialStringID = p_dialstringid;
         
         SELECT  COUNT(*) as count INTO totaldialstringcode
			FROM tmp_TempVendorRate_ vr
				LEFT JOIN tmp_DialString_ ds
					ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  )) 
					-- ON vr.Code = ds.ChargeCode 
				WHERE vr.ProcessId = p_processId 
					AND ds.DialStringID IS NULL
					AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
		   
         IF totaldialstringcode > 0
         THEN
         
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT CONCAT(Code ,' ', IFNULL(vr.DialStringPrefix,'') , ' No PREFIX FOUND')
				  	FROM tmp_TempVendorRate_ vr
						LEFT JOIN tmp_DialString_ ds
							-- ON vr.Code = ds.ChargeCode
							ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  )) 
						WHERE vr.ProcessId = p_processId
							AND ds.DialStringID IS NULL				
							AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
         
         END IF;

         IF totaldialstringcode = 0
         THEN
				 
				 	INSERT INTO tmp_VendorRateDialString_ 	
					 SELECT DISTINCT
							`CodeDeckId`,
							`DialString`,
							CASE WHEN ds.Description IS NULL OR ds.Description = ''
								THEN    
									tblTempVendorRate.Description									
								ELSE
									ds.Description
							END
								AS Description,
							`Rate`,
							`EffectiveDate`,
							`Change`,
							`ProcessId`,
							`Preference`,
							`ConnectionFee`,
							`Interval1`,
							`IntervalN`,
							tblTempVendorRate.Forbidden as Forbidden ,
							tblTempVendorRate.DialStringPrefix as DialStringPrefix
					   FROM tmp_TempVendorRate_ as tblTempVendorRate
							INNER JOIN tmp_DialString_ ds
							  --	 ON tblTempVendorRate.Code = ds.ChargeCode
							  	ON ( (tblTempVendorRate.Code = ds.ChargeCode AND tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' AND tblTempVendorRate.DialStringPrefix =  ds.DialString AND tblTempVendorRate.Code = ds.ChargeCode  ))
							  -- on (tblTempVendorRate.DialStringPrefix != '' and tblTempVendorRate.DialStringPrefix =  ds.DialString and tblTempVendorRate.Code = ds.ChargeCode  )
						 WHERE tblTempVendorRate.ProcessId = p_processId
							AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');							
		
						
					DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_2;
					CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRateDialString_2 as (SELECT * FROM tmp_VendorRateDialString_);
					
					DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_3;
					CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRateDialString_3 as (					
					 SELECT vrs1.* from tmp_VendorRateDialString_2 vrs1
					 LEFT JOIN tmp_VendorRateDialString_ vrs2 ON vrs1.Code=vrs2.Code AND vrs1.CodeDeckId=vrs2.CodeDeckId AND vrs1.Description=vrs2.Description AND vrs1.EffectiveDate=vrs2.EffectiveDate AND vrs1.DialStringPrefix != vrs2.DialStringPrefix
					 WHERE ((vrs1.DialStringPrefix ='' AND vrs2.Code IS NULL) OR (vrs1.DialStringPrefix!='' AND vrs2.Code IS NOT NULL))						 
					);
					
					
					DELETE  FROM tmp_TempVendorRate_ WHERE  ProcessId = p_processId; 
					
					INSERT INTO tmp_TempVendorRate_(
							CodeDeckId,
							Code,
							Description,
							Rate,
							EffectiveDate,
							`Change`,
							ProcessId,
							Preference,
							ConnectionFee,
							Interval1,
							IntervalN,
							Forbidden,
							DialStringPrefix
						)
					SELECT DISTINCT 
						`CodeDeckId`,
						`Code`,
						`Description`,
						`Rate`,
						`EffectiveDate`,
						`Change`,
						`ProcessId`,
						`Preference`,
						`ConnectionFee`,
						`Interval1`,
						`IntervalN`,
						`Forbidden`,
						DialStringPrefix 
					 FROM tmp_VendorRateDialString_3;
					   
				  	UPDATE tmp_TempVendorRate_ as tblTempVendorRate
					JOIN tmp_DialString_ ds
					-- ON tblTempVendorRate.Code = ds.DialString
					  ON ( (tblTempVendorRate.Code = ds.ChargeCode and tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' and tblTempVendorRate.DialStringPrefix =  ds.DialString and tblTempVendorRate.Code = ds.ChargeCode  )) 
							AND tblTempVendorRate.ProcessId = p_processId
							AND ds.Forbidden = 1
					SET tblTempVendorRate.Forbidden = 'B';
					
					UPDATE tmp_TempVendorRate_ as  tblTempVendorRate
					JOIN tmp_DialString_ ds
						-- ON tblTempVendorRate.Code = ds.DialString
						ON ( (tblTempVendorRate.Code = ds.ChargeCode and tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' and tblTempVendorRate.DialStringPrefix =  ds.DialString and tblTempVendorRate.Code = ds.ChargeCode  ))
							AND tblTempVendorRate.ProcessId = p_processId
							AND ds.Forbidden = 0
					SET tblTempVendorRate.Forbidden = 'UB';
					        
			END IF;	  

    END IF;	
   
END IF; 

 	

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_RateCompare`;
DELIMITER  //
CREATE PROCEDURE `prc_RateCompare`(
  IN `p_companyid` INT,
  IN `p_trunkID` INT,
  IN `p_codedeckID` INT,
  IN `p_currencyID` INT,
  IN `p_code` VARCHAR(50),
  IN `p_description` VARCHAR(50),
  IN `p_groupby` VARCHAR(50),
  IN `p_source_vendors` VARCHAR(100),
  IN `p_source_customers` VARCHAR(100),
  IN `p_source_rate_tables` VARCHAR(100),
  IN `p_destination_vendors` VARCHAR(100),
  IN `p_destination_customers` VARCHAR(100),
  IN `p_destination_rate_tables` VARCHAR(100),
  IN `p_Effective` VARCHAR(50),
  IN `p_SelectedEffectiveDate` DATE,
  IN `p_PageNumber` INT,
  IN `p_RowspPage` INT,
  IN `p_SortOrder` VARCHAR(50),
  IN `p_isExport` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT ''
  BEGIN

    DECLARE v_OffSet_ int;
    DECLARE v_CompanyCurrencyID_ INT;

    DECLARE v_pointer_ INT;
    DECLARE v_rowCount_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SET @@session.collation_connection='utf8_unicode_ci';
    SET @@session.character_set_results='utf8';

    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

    SET SESSION  sql_mode = '';


    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) ,
      RateID INT,
      Description VARCHAR(200) ,
      Rate DECIMAL(18,6),
      EffectiveDate DATE ,
      TrunkID INT ,
      VendorRateID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRate_;
    CREATE TEMPORARY TABLE tmp_CustomerRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) ,
      RateID INT,
      Description VARCHAR(200) ,
      Rate DECIMAL(18,6) ,
      EffectiveDate DATE ,
      TrunkID INT,
      CustomerRateId INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_RateTableRate_ (
      RateTableName VARCHAR(200) ,
      RateID INT,
      Code VARCHAR(50) ,
      Description VARCHAR(200) ,
      Rate DECIMAL(18,6) ,
      EffectiveDate DATE ,
      RateTableID INT,
      RateTableRateID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_code_;
    CREATE TEMPORARY TABLE tmp_code_ (
      Code  varchar(50),
      Description  varchar(250),
      RateID int,
      INDEX Index1 (Code)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_final_compare;
    CREATE TEMPORARY TABLE tmp_final_compare (
      Code  varchar(50),
      Description VARCHAR(200) ,
      -- 		RateID int,
      INDEX Index1 (Code)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_vendors_;
    CREATE TEMPORARY TABLE tmp_vendors_ (
      AccountID  int,
      AccountName varchar(100),
      CurrencyID int,
      RowID int
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_vendors_;
    CREATE TEMPORARY TABLE tmp_vendors_ (
      AccountID  int,
      AccountName varchar(100),
      CurrencyID int,
      RowID int
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_customers_;
    CREATE TEMPORARY TABLE tmp_customers_ (
      AccountID  int,
      AccountName varchar(100),
      CurrencyID int,
      RowID int
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_rate_tables_;
    CREATE TEMPORARY TABLE tmp_rate_tables_ (
      RateTableID  int,
      RateTableName varchar(100),
      CurrencyID int,
      RowID int
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_dynamic_columns_;
    CREATE TEMPORARY TABLE tmp_dynamic_columns_ (
      ColumnName  varchar(200),
      ColumnType  varchar(50),
      ColumnID  INT
    );

    SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;

    #vendors
    INSERT INTO tmp_vendors_
      SELECT a.AccountID,a.AccountName,a.CurrencyID,
        @row_num := @row_num+1 AS RowID
      FROM tblAccount a
        Inner join tblVendorTrunk vt on vt.CompanyID = a.CompanyId AND vt.AccountID = a.AccountID and vt.Status =  a.Status and vt.TrunkID =  p_trunkID
        ,(SELECT @row_num := 0) x
      WHERE  (FIND_IN_SET(a.AccountID,p_source_vendors)!= 0 OR  FIND_IN_SET(a.AccountID,p_destination_vendors)!= 0)
             AND a.CompanyId = p_companyid and a.Status = 1 and a.IsVendor = 1 AND a.CurrencyId is not NULL;

    #customer
    INSERT INTO tmp_customers_
      SELECT a.AccountID,a.AccountName,a.CurrencyID,
        @row_num := @row_num+1 AS RowID
      FROM tblAccount a
        Inner join tblCustomerTrunk vt on vt.CompanyID = a.CompanyId AND vt.AccountID = a.AccountID and vt.Status =  a.Status and vt.TrunkID =  p_trunkID
        ,(SELECT @row_num := 0) x
      WHERE  (FIND_IN_SET(a.AccountID,p_source_customers)!= 0 OR  FIND_IN_SET(a.AccountID,p_destination_customers)!= 0)
             AND a.CompanyId = p_companyid and a.Status = 1 and a.IsCustomer = 1 AND a.CurrencyId is not NULL;


    #rate tables
    INSERT INTO tmp_rate_tables_
      SELECT RateTableID,RateTableName,CurrencyID,
        @row_num := @row_num+1 AS RowID
      FROM tblRateTable,(SELECT @row_num := 0) x
      WHERE  (FIND_IN_SET(RateTableID,p_source_rate_tables)!= 0 OR  FIND_IN_SET(RateTableID,p_destination_rate_tables)!= 0)
             AND CompanyID = p_companyid and TrunkID = p_trunkID /*and CodeDeckId = p_codedeckID*/ AND CurrencyId is not NULL;



    insert into tmp_code_
      select Code,Description,RateID
      from tblRate
      WHERE CompanyID = p_companyid AND CodedeckID = p_codedeckID
            AND ( CHAR_LENGTH(RTRIM(p_code)) = '' OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
            AND ( CHAR_LENGTH(RTRIM(p_description)) = '' OR tblRate.Description LIKE REPLACE(p_description,'*', '%') )
      order by `Code`;
    -- LIMIT p_RowspPage OFFSET v_OffSet_ ;



    IF p_source_vendors != '' OR p_destination_vendors != '' THEN

      INSERT INTO tmp_VendorRate_ ( AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , VendorRateID )
        SELECT distinct
          tblVendorRate.AccountId,
          tblAccount.AccountName,
          tblRate.Code,
          tblRate.RateID,
          tblRate.Description,
          CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
            THEN tblVendorRate.Rate
          WHEN  v_CompanyCurrencyID_ = p_CurrencyID
            THEN ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
          ELSE (
            (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
            * ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
          )
          END as  Rate,
          tblVendorRate.EffectiveDate,
          tblVendorRate.TrunkID,
          tblVendorRate.VendorRateID
        FROM tblVendorRate
          INNER JOIN tmp_vendors_ as tblAccount   ON tblVendorRate.AccountId = tblAccount.AccountID
          INNER JOIN tblRate ON tblVendorRate.RateId = tblRate.RateID
          INNER JOIN tmp_code_ tc ON tc.Code = tblRate.Code
          LEFT JOIN tblVendorPreference vp
            ON vp.AccountId = tblVendorRate.AccountId
               AND vp.TrunkID = tblVendorRate.TrunkID
               AND vp.RateId = tblVendorRate.RateId
          LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
                                                              AND tblVendorRate.AccountId = blockCode.AccountId
                                                              AND tblVendorRate.TrunkID = blockCode.TrunkID
          LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
                                                                  AND tblVendorRate.AccountId = blockCountry.AccountId
                                                                  AND tblVendorRate.TrunkID = blockCountry.TrunkID
        WHERE
          tblVendorRate.TrunkID = p_trunkID
          AND blockCode.RateId IS NULL
          AND blockCountry.CountryId IS NULL
          AND
          (
            ( p_Effective = 'Now' AND tblVendorRate.EffectiveDate <= NOW() )
            OR
            ( p_Effective = 'Future' AND tblVendorRate.EffectiveDate > NOW())
            OR (

              p_Effective = 'Selected' AND tblVendorRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
            )
          )

        ORDER BY tblRate.Code asc;


    END IF;

    IF p_source_customers != '' OR p_destination_customers != '' THEN

      INSERT INTO tmp_CustomerRate_ ( AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , CustomerRateID )
        SELECT distinct
          tblCustomerRate.CustomerID,
          tblAccount.AccountName,
          tblRate.Code,
          tblCustomerRate.RateID,
          tblRate.Description,
          CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
            THEN tblCustomerRate.Rate
          WHEN  v_CompanyCurrencyID_ = p_CurrencyID
            THEN ( tblCustomerRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
          ELSE (
            ( Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
            * ( tblCustomerRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
          )
          END as  Rate,
          tblCustomerRate.EffectiveDate,
          tblCustomerRate.TrunkID,
          tblCustomerRate.CustomerRateId
        FROM tblCustomerRate
          INNER JOIN tmp_customers_ as tblAccount   ON tblCustomerRate.CustomerID = tblAccount.AccountID
          INNER JOIN tblRate ON tblCustomerRate.RateId = tblRate.RateID
          INNER JOIN tmp_code_ tc ON tc.Code = tblRate.Code
        WHERE
          tblCustomerRate.TrunkID = p_trunkID
          AND
          (
            ( p_Effective = 'Now' AND tblCustomerRate.EffectiveDate <= NOW() )
            OR
            ( p_Effective = 'Future' AND tblCustomerRate.EffectiveDate > NOW())
            OR (

              p_Effective = 'Selected' AND tblCustomerRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
            )
          )
        ORDER BY tblRate.Code asc;

    -- @TODO : skipp tmp_CustomerRate_ from rate table.
    -- dont show rate table rate in customer rate
    /*
    INSERT INTO tmp_CustomerRate_ ( AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , CustomerRateID )
              SELECT
              tblAccount.AccountID,
              tblAccount.AccountName,
              tblRate.Code,
              tblRateTableRate.RateID,
              tblRate.Description,
              CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
                THEN tblRateTableRate.Rate
              WHEN  v_CompanyCurrencyID_ = p_CurrencyID
                THEN ( tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
              ELSE (
                ( Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
                * ( tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
              )
              END as  Rate,
              tblRateTableRate.EffectiveDate,
              p_trunkID as TrunkID,
              NULL as CustomerRateId
            FROM tblRateTableRate
              INNER JOIN tblCustomerTrunk    ON  tblCustomerTrunk.CompanyID = p_companyid And  tblCustomerTrunk.Status= 1 And tblCustomerTrunk.TrunkID= p_trunkID  AND tblCustomerTrunk.RateTableID = tblRateTableRate.RateTableID
              INNER JOIN tmp_customers_ as tblAccount   ON tblCustomerTrunk.AccountId = tblAccount.AccountID
              INNER JOIN tblRate ON tblRateTableRate.RateId = tblRate.RateID
              INNER JOIN tmp_code_ tc ON tc.Code = tblRate.Code
            WHERE
              (
                ( p_Effective = 'Now' AND tblRateTableRate.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND tblRateTableRate.EffectiveDate > NOW())
                OR (
                  p_Effective = 'Selected' AND tblRateTableRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
                )
              )
              ORDER BY tblRate.Code asc;
        */

    END IF;


    IF p_source_rate_tables != '' OR p_destination_rate_tables != '' THEN

      INSERT INTO tmp_RateTableRate_
        SELECT
          tblRateTable.RateTableName,
          tblRateTableRate.RateID,
          tblRate.Code,
          tblRate.Description,
          CASE WHEN  tblRateTable.CurrencyID = p_CurrencyID
            THEN tblRateTableRate.Rate
          WHEN  v_CompanyCurrencyID_ = p_CurrencyID
            THEN ( tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTable.CurrencyID and  CompanyID = p_companyid ) )
          ELSE (
            ( Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
            * ( tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTable.CurrencyID and  CompanyID = p_companyid ) )
          )
          END as  Rate,
          tblRateTableRate.EffectiveDate,
          tblRateTableRate.RateTableID,
          tblRateTableRate.RateTableRateID
        FROM tblRateTableRate
          INNER JOIN tmp_rate_tables_ as tblRateTable on tblRateTable.RateTableID =  tblRateTableRate.RateTableID
          INNER JOIN tblRate ON tblRateTableRate.RateId = tblRate.RateID
          INNER JOIN tmp_code_ tc ON tc.Code = tblRate.Code
        WHERE
          (
            ( p_Effective = 'Now' AND tblRateTableRate.EffectiveDate <= NOW() )
            OR
            ( p_Effective = 'Future' AND tblRateTableRate.EffectiveDate > NOW())
            OR (

              p_Effective = 'Selected' AND tblRateTableRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
            )
          )

        ORDER BY Code asc;

    -- select * from tmp_RateTableRate_;
    -- select count(*) as totalcount from tmp_RateTableRate_;

    END IF;


    #insert into tmp_final_compare
    INSERT  INTO  tmp_final_compare (Code,Description)
      SELECT 	DISTINCT 		Code,		Description
      FROM
        (
          SELECT DISTINCT
            Code,
            Description,
            RateID
          FROM tmp_VendorRate_

          UNION ALL

          SELECT DISTINCT
            Code,
            Description,
            RateID
          FROM tmp_CustomerRate_

          UNION ALL

          SELECT DISTINCT
            Code,
            Description,
            RateID
          FROM tmp_RateTableRate_
        ) tmp;

    -- #########################Source##############################################################




    #source vendor insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_vendors_source;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_vendors_source as (select AccountID,AccountName,CurrencyID, @row_num := @row_num+1 AS RowID from tmp_vendors_ ,(SELECT @row_num := 0) x where FIND_IN_SET(AccountID , p_source_vendors) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_vendors_source);
    SET @Group_sql = '';

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @AccountID = (SELECT AccountID FROM tmp_vendors_source WHERE RowID = v_pointer_);
        SET @AccountName = (SELECT AccountName FROM tmp_vendors_source WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@AccountID , p_source_vendors) > 0  ) THEN

        SET @ColumnName = concat('`', @AccountName ,' (VR)`' );

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');

        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_VendorRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.AccountID = ', @AccountID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(VR)' ,  @AccountID );


        -- END IF;


        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;

    #source customer insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_customers_source;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_customers_source as (select AccountID,AccountName,CurrencyID, @row_num := @row_num+1 AS RowID from tmp_customers_ ,(SELECT @row_num := 0) x where FIND_IN_SET(AccountID , p_source_customers) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_customers_source );

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @AccountID = (SELECT AccountID FROM tmp_customers_source WHERE RowID = v_pointer_);
        SET @AccountName = (SELECT AccountName FROM tmp_customers_source WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@AccountID , p_source_customers) > 0  ) THEN

        SET @ColumnName = concat('`', @AccountName ,' (CR)`');

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');


        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_CustomerRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description  set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.AccountID = ', @AccountID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;


        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(CR)' ,  @AccountID );

        -- END IF;

        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;



    #Rate Table insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_rate_tables_source;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_rate_tables_source as (select RateTableID,RateTableName,CurrencyID, @row_num := @row_num+1 AS RowID from tmp_rate_tables_ ,(SELECT @row_num := 0) x where FIND_IN_SET(RateTableID , p_source_rate_tables) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_rate_tables_source );

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @RateTableID = (SELECT RateTableID FROM tmp_rate_tables_source WHERE RowID = v_pointer_);
        SET @RateTableName = (SELECT TRIM(REPLACE(REPLACE(REPLACE( RateTableName,"\\"," "),"/"," "),'-'," ")) FROM tmp_rate_tables_source WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@RateTableID , p_destination_rate_tables) > 0  ) THEN

        SET @ColumnName = concat('`', @RateTableName,' (RT)`');

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');

        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_RateTableRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description  set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.RateTableID = ', @RateTableID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(RT)' ,  @RateTableID );

        -- END IF;

        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;

    -- ##################Destination#######################################################

    #destination vendor insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_vendors_destination;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_vendors_destination as (select AccountID,AccountName, CurrencyID, @row_num := @row_num+1 AS RowID from tmp_vendors_ ,(SELECT @row_num := 0) x where FIND_IN_SET(AccountID , p_destination_vendors) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = ( SELECT COUNT(*)FROM tmp_vendors_destination );

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @AccountID = (SELECT AccountID FROM tmp_vendors_destination WHERE RowID = v_pointer_);
        SET @AccountName = (SELECT AccountName FROM tmp_vendors_destination WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@AccountID , p_destination_vendors) > 0  ) THEN

        SET @ColumnName = concat('`', @AccountName ,' (VR)`');

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');

        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_VendorRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description  set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.AccountID = ', @AccountID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(VR)' ,  @AccountID );

        -- END IF;


        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;

    #destination customer insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_customers_destination;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_customers_destination as (select AccountID,AccountName,CurrencyID, @row_num := @row_num+1 AS RowID from tmp_customers_ ,(SELECT @row_num := 0) x where FIND_IN_SET(AccountID , p_destination_customers) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_customers_destination);

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @AccountID = (SELECT AccountID FROM tmp_customers_destination WHERE RowID = v_pointer_);
        SET @AccountName = (SELECT AccountName FROM tmp_customers_destination WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@AccountID , p_destination_customers) > 0  ) THEN

        SET @ColumnName = concat('`', @AccountName ,' (CR)`');

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');


        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_CustomerRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description  set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.AccountID = ', @AccountID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(CR)' ,  @AccountID );

        -- END IF;

        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;


    #Rate Table insert rates
    DROP TEMPORARY TABLE IF EXISTS tmp_rate_tables_destination;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_rate_tables_destination as (select RateTableID,RateTableName,CurrencyID, @row_num := @row_num+1 AS RowID from tmp_rate_tables_ ,(SELECT @row_num := 0) x where FIND_IN_SET(RateTableID , p_destination_rate_tables) > 0);
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_rate_tables_destination);

    IF v_rowCount_ > 0 THEN

      WHILE v_pointer_ <= v_rowCount_
      DO

        SET @RateTableID = (SELECT RateTableID FROM tmp_rate_tables_destination WHERE RowID = v_pointer_);
        SET @RateTableName = (SELECT TRIM(REPLACE(REPLACE(REPLACE( RateTableName,"\\"," "),"/"," "),'-'," "))  FROM tmp_rate_tables_destination WHERE RowID = v_pointer_);

        -- IF ( FIND_IN_SET(@RateTableID , p_destination_rate_tables) > 0  ) THEN

        SET @ColumnName = concat('`', @RateTableName ,' (RT)`');

        SET @stm1 = CONCAT('ALTER   TABLE `tmp_final_compare` ADD COLUMN ', @ColumnName , ' VARCHAR(100) NULL DEFAULT NULL');

        PREPARE stmt1 FROM @stm1;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare` tmp  INNER JOIN tmp_RateTableRate_ vr on vr.Code = tmp.Code and vr.Description = tmp.Description  set ', @ColumnName , ' =  IFNULL(concat(vr.Rate,"<br>",vr.EffectiveDate),"") WHERE vr.RateTableID = ', @RateTableID , ' ;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        SET @stm2 = CONCAT('UPDATE `tmp_final_compare`  set ', @ColumnName , ' =  "" where  ', @ColumnName , ' is null;');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

        INSERT INTO tmp_dynamic_columns_  values ( @ColumnName , '(RT)' ,  @RateTableID );

        -- END IF;

        SET v_pointer_ = v_pointer_ + 1;


      END WHILE;

    END IF;

    -- #######################################################################################

    /*select tmp.* from tmp_final_compare tmp
      left join tblRate on CompanyID = p_companyid AND CodedeckID = p_codedeckID and tmp.Code =  tblRate.Code
    WHERE tblRate.Code  is null
    order by tmp.Code;
-- LIMIT p_RowspPage OFFSET v_OffSet_ ;

    -- select count(*) as totalcount from tblRate WHERE CompanyID = p_companyid AND CodedeckID = p_codedeckID;
*/


    IF p_groupby = 'description' THEN

      select GROUP_CONCAT( concat(' max(' , ColumnName , ') as ' , ColumnName ) ) , GROUP_CONCAT(ColumnID)  INTO @maxColumnNames , @ColumnIDS from tmp_dynamic_columns_;

    ELSE

      select GROUP_CONCAT(ColumnName) , GROUP_CONCAT(ColumnID) INTO @ColumnNames ,  @ColumnIDS from tmp_dynamic_columns_;

    END IF;



    IF p_isExport = 0 THEN

      IF p_groupby = 'description' THEN

        IF @maxColumnNames is not null THEN

          SET @stm2 = CONCAT('select max(Description) as Destination , ',@maxColumnNames ,'  , "',@ColumnIDS ,'" as ColumnIDS   from tmp_final_compare Group by  Description  order by Description LIMIT  ', p_RowspPage , ' OFFSET ' , v_OffSet_ , '');

          PREPARE stmt2 FROM @stm2;
          EXECUTE stmt2;
          DEALLOCATE PREPARE stmt2;

          SELECT count(*) as totalcount from  (select count(Description) FROM tmp_final_compare Group by Description)tmp;
        ELSE

          select '' as 	Destination, '' as ColumnIDS;
          select 0 as  totalcount;

        END IF;

      ELSE


        IF @ColumnNames is not null THEN

          SET @stm2 = CONCAT('select concat( Code , " : " , Description ) as Destination , ', @ColumnNames,' , "', @ColumnIDS ,'" as ColumnIDS from tmp_final_compare order by Code LIMIT  ', p_RowspPage , ' OFFSET ' , v_OffSet_ , '');
          PREPARE stmt2 FROM @stm2;
          EXECUTE stmt2;
          DEALLOCATE PREPARE stmt2;

          select count(*) as totalcount from tmp_final_compare;

        ELSE

          select '' as 	Destination,   '' as ColumnIDS;
          select 0 as  totalcount;

        END IF;




      END IF;


    ELSE

      IF p_groupby = 'description' THEN

        SET @stm2 = CONCAT('select max(Description) as Destination , ',@maxColumnNames ,' from tmp_final_compare Group by  Description  order by Description');

        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;

      ELSE

        SET @stm2 = CONCAT('select distinct concat( Code , " : " , Description ) as Destination , ', @ColumnNames,' from tmp_final_compare order by Code');
        PREPARE stmt2 FROM @stm2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;


      END IF;


    END IF;


    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



  END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RateCompareRateUpdate`;
DELIMITER  //
CREATE PROCEDURE `prc_RateCompareRateUpdate`(
  IN `p_CompanyID` INT,
  IN `p_GroupBy` VARCHAR(50),
  IN `p_Type` VARCHAR(50),
  IN `p_TypeID` INT,
  IN `p_Rate` DOUBLE,
  IN `p_Code` VARCHAR(50),
  IN `p_Description` VARCHAR(200),
  IN `p_NewDescription` VARCHAR(200),
  IN `p_EffectiveDate` VARCHAR(50),
  IN `p_TrunkID` INT,
  IN `p_Effective` VARCHAR(50),
  IN `p_SelectedEffectiveDate` DATE
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT ''
  BEGIN

    DECLARE v_RateUpdate_ VARCHAR(200);
    -- DECLARE v_DesciptionUpdate_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



    IF ( p_Type = 'vendor_rate') THEN

      IF ( p_GroupBy = 'description' ) THEN

        Update
            tblVendorRate v
            inner join tblRate r on r.RateID = v.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Description = p_Description AND
              v.AccountId = p_TypeID AND
              v.TrunkID = p_TrunkID
              AND
              (
                ( p_Effective = 'Now' AND v.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND v.EffectiveDate > NOW())
                OR
                ( p_Effective = 'Selected' AND v.EffectiveDate <= DATE(p_SelectedEffectiveDate) )
              );

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblVendorTrunk WHERE CompanyID = p_CompanyID AND AccountID = p_TypeID AND TrunkID = p_TrunkID ) AND
                 Description = p_Description;

        END IF;


      ELSE

        Update
            tblVendorRate v
            inner join tblRate r on r.RateID = v.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Code = p_Code AND
              r.Description = p_Description AND
              v.AccountId = p_TypeID AND
              v.TrunkID = p_TrunkID AND
              v.EffectiveDate = p_EffectiveDate;

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblVendorTrunk WHERE CompanyID = p_CompanyID AND AccountID = p_TypeID AND TrunkID = p_TrunkID ) AND
                 -- Description = p_Description AND
                 `Code` 			= p_Code ;

        END IF;


      END IF;


    END IF;


    IF ( p_Type = 'rate_table') THEN

      IF ( p_GroupBy = 'description') THEN

        update
            tblRateTableRate rtr
            inner join tblRate r on r.RateID = rtr.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Description = p_Description AND
              rtr.RateTableId = p_TypeID
              AND
              (
                ( p_Effective = 'Now' AND rtr.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND rtr.EffectiveDate > NOW())
                OR
                ( p_Effective = 'Selected' AND rtr.EffectiveDate <= DATE(p_SelectedEffectiveDate) )
              );

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblRateTable WHERE  RateTableId = p_TypeID ) AND
                 Description = p_Description;

        END IF;



      ELSE

        update
            tblRateTableRate rtr
            inner join tblRate r on r.RateID = rtr.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Code = p_Code AND
              r.Description = p_Description AND
              rtr.RateTableId = p_TypeID AND
              rtr.EffectiveDate = p_EffectiveDate;

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblRateTable WHERE  RateTableId = p_TypeID ) AND
                 -- Description = p_Description AND
                 `Code` 			= p_Code ;

        END IF;


      END IF;


    END IF;

    IF ( p_Type = 'customer_rate') THEN

      IF ( p_GroupBy = 'description') THEN

        update
            tblCustomerRate c
            inner join tblRate r on r.RateID = c.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Description = p_Description AND
              c.CustomerID = p_TypeID AND
              c.TrunkID = p_TrunkID
              AND
              (
                ( p_Effective = 'Now' AND c.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND c.EffectiveDate > NOW())
                OR (
                  p_Effective = 'Selected' AND c.EffectiveDate <= DATE(p_SelectedEffectiveDate)
                )
              );

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblCustomerTrunk WHERE CompanyID = p_CompanyID AND AccountID = p_TypeID AND TrunkID = p_TrunkID ) AND
                 Description = p_Description;

        END IF;


      ELSE

        update
            tblCustomerRate c
            inner join tblRate r on r.RateID = c.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Code = p_Code AND
              r.Description = p_Description AND
              c.CustomerID = p_TypeID AND
              c.TrunkID = p_TrunkID AND
              c.EffectiveDate = p_EffectiveDate;

        SELECT concat ( ROW_COUNT() , ' Records updated' ) INTO v_RateUpdate_;

        IF ( p_Description != p_NewDescription ) THEN

          UPDATE tblRate
          SET 	Description = p_NewDescription
          WHERE  CompanyID = p_CompanyID AND
                 CodeDeckId = ( SELECT CodeDeckId from tblCustomerTrunk WHERE CompanyID = p_CompanyID AND AccountID = p_TypeID AND TrunkID = p_TrunkID ) AND
                 -- Description = p_Description AND
                 `Code` 			= p_Code ;

        END IF;




      END IF;

    END IF;


    select v_RateUpdate_ as rows_update ;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


  END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_RateCompareRateAdd`;
DELIMITER  //
CREATE PROCEDURE `prc_RateCompareRateAdd`(

  IN `p_CompanyID` INT,
  IN `p_GroupBy` VARCHAR(50),
  IN `p_Type` VARCHAR(50),
  IN `p_TypeID` INT,
  IN `p_Rate` DOUBLE,
  IN `p_Code` VARCHAR(50),
  IN `p_Description` VARCHAR(200),
  IN `p_EffectiveDate` VARCHAR(50),
  IN `Interval1` INT,
  IN `IntervalN` INT,
  IN `p_ConnectionFee` DOUBLE,
  IN `p_TrunkID` INT,
  IN `p_Effective` VARCHAR(50),
  IN `p_SelectedEffectiveDate` DATE

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT ''
  BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


    -- Vendor Rate
    IF ( p_Type = 'vendor_rate') THEN

      IF ( p_GroupBy = 'description') THEN


        INSERT INTO tblVendorRate (AccountID,RateID,Rate,EffectiveDate,Interval1,IntervalN,ConnectionFee)
          SELECT p_TypeID,r.RateID,p_Rate,p_EffectiveDate,p_Interval1,p_IntervalN,p_ConnectionFee
          FROM tblVendorRate v
            JOIN tblVendorTrunk vt
              ON vt.AccountID = p_TypeID
                 AND  vt.TrunkID = p_TrunkID
                 AND vt.Status = 1
            LEFT JOIN tblRate r on r.RateID = v.RateId AND r.CodedeckID = vt.CodedeckID
          where r.CompanyID = p_CompanyID AND
                r.Description = v_Description AND
                v.AccountId = p_TypeID AND
                v.TrunkID = p_TrunkID
                AND
                (
                  ( p_Effective = 'Now' AND v.EffectiveDate <= NOW() )
                  OR
                  ( p_Effective = 'Future' AND v.EffectiveDate > NOW())
                  OR
                  ( p_Effective = 'Selected' AND v.EffectiveDate <= DATE(p_SelectedEffectiveDate) )
                );



      ELSE

        select '' ;

      END IF;


    END IF;

    -- Rate Table
    IF ( p_Type = 'rate_table') THEN

      IF ( p_GroupBy = 'description') THEN

        -- Rate Table group by description
        update
            tblRateTableRate rtr
            inner join tblRate r on r.RateID = rtr.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Description = p_Description AND
              rtr.RateTableId = p_TypeID
              AND
              (
                ( p_Effective = 'Now' AND rtr.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND rtr.EffectiveDate > NOW())
                OR
                ( p_Effective = 'Selected' AND rtr.EffectiveDate <= DATE(p_SelectedEffectiveDate) )
              );



      ELSE

        -- Rate Table by code and EffectiveDate
        update
            tblRateTableRate rtr
            inner join tblRate r on r.RateID = rtr.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Code = p_Code AND
              r.Description = p_Description AND
              rtr.RateTableId = p_TypeID AND
              rtr.EffectiveDate = p_EffectiveDate;


      END IF;


    END IF;

    -- Customer Rate
    IF ( p_Type = 'customer_rate') THEN

      IF ( p_GroupBy = 'description') THEN

        -- Customer Rate group by description
        update
            tblCustomerRate c
            inner join tblRate r on r.RateID = c.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Description = p_Description AND
              c.CustomerID = p_TypeID AND
              c.TrunkID = p_TrunkID
              AND
              (
                ( p_Effective = 'Now' AND c.EffectiveDate <= NOW() )
                OR
                ( p_Effective = 'Future' AND c.EffectiveDate > NOW())
                OR (
                  p_Effective = 'Selected' AND c.EffectiveDate <= DATE(p_SelectedEffectiveDate)
                )
              );

      ELSE

        -- Customer Rate by Code and EffectiveDate
        update
            tblCustomerRate c
            inner join tblRate r on r.RateID = c.RateId
        SET Rate = p_Rate
        where r.CompanyID = p_CompanyID AND
              r.Code = p_Code AND
              r.Description = p_Description AND
              c.CustomerID = p_TypeID AND
              c.TrunkID = p_TrunkID AND
              c.EffectiveDate = p_EffectiveDate;

      END IF;

    END IF;


    select ROW_COUNT() as rows_update ;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


  END//
DELIMITER ;
-- Rate geneator

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;
DELIMITER //
CREATE  PROCEDURE `prc_WSGenerateRateTable`(
  IN `p_jobId` INT,
  IN `p_RateGeneratorId` INT,
  IN `p_RateTableId` INT,
  IN `p_rateTableName` VARCHAR(200),
  IN `p_EffectiveDate` VARCHAR(10),
  IN `p_delete_exiting_rate` INT,
  IN `p_EffectiveRate` VARCHAR(50)



)
    GenerateRateTable:BEGIN


    DECLARE v_RTRowCount_ INT;
    DECLARE v_RatePosition_ INT;
    DECLARE v_Use_Preference_ INT;
    DECLARE v_CurrencyID_ INT;
    DECLARE v_CompanyCurrencyID_ INT;
    DECLARE v_Average_ TINYINT;
    DECLARE v_CompanyId_ INT;
    DECLARE v_codedeckid_ INT;
    DECLARE v_trunk_ INT;
    DECLARE v_rateRuleId_ INT;
    DECLARE v_RateGeneratorName_ VARCHAR(200);
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;



    DECLARE v_tmp_code_cnt int ;
    DECLARE v_tmp_code_pointer int;
    DECLARE v_p_code varchar(50);
    DECLARE v_Codlen_ int;
    DECLARE v_p_code__ VARCHAR(50);
    DECLARE v_Commit int;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

    END;

    SET @@session.collation_connection='utf8_unicode_ci';
    SET @@session.character_set_client='utf8';

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);


    IF p_rateTableName IS NOT NULL
    THEN


      SET v_RTRowCount_ = (SELECT
                             COUNT(*)
                           FROM tblRateTable
                           WHERE RateTableName = p_rateTableName
                                 AND CompanyId = (SELECT
                                                    CompanyId
                                                  FROM tblRateGenerator
                                                  WHERE RateGeneratorID = p_RateGeneratorId));

      IF v_RTRowCount_ > 0
      THEN
        CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
        LEAVE GenerateRateTable;
      END IF;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
    CREATE TEMPORARY TABLE tmp_Rates_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Rates_code (`code`) ,
      UNIQUE KEY `unique_code` (`code`)

    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
    CREATE TEMPORARY TABLE tmp_Rates2_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Rates2_code (`code`)
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_Codedecks_;
    CREATE TEMPORARY TABLE tmp_Codedecks_ (
      CodeDeckId INT
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;

    CREATE TEMPORARY TABLE tmp_Raterules_  (
      rateruleid INT,
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      description VARCHAR(200) COLLATE utf8_unicode_ci,
      RowNo INT,
      INDEX tmp_Raterules_code (`code`,`description`),
      INDEX tmp_Raterules_rateruleid (`rateruleid`),
      INDEX tmp_Raterules_RowNo (`RowNo`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
    CREATE TEMPORARY TABLE tmp_Vendorrates_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      AccountId INT,
      RowNo INT,
      PreferenceRank INT,
      INDEX tmp_Vendorrates_code (`code`),
      INDEX tmp_Vendorrates_rate (`rate`)
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
    CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      FinalRankNumber int,
      INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
    CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
      RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
      FinalRankNumber int,
      INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
    CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_code_;
    CREATE TEMPORARY TABLE tmp_code_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      INDEX tmp_code_code (`code`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
    CREATE TEMPORARY TABLE tmp_all_code_ (
      RowCode  varchar(50) COLLATE utf8_unicode_ci,
      Code  varchar(50) COLLATE utf8_unicode_ci,
      RowNo int,
      INDEX Index2 (Code)
    );



    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
    CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      MaxMatchRank int ,
      prev_prev_RowCode VARCHAR(50),
      prev_AccountID int
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
    CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      FinalRankNumber int,
      INDEX IX_CODE (RowCode)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
      AccountId int,
      AccountName varchar(200),
      Code varchar(50) COLLATE utf8_unicode_ci,
      Description varchar(200) ,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate date,
      TrunkID int,
      CountryID int,
      RateID int,
      Preference int,
      INDEX IX_CODE (Code)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
      AccountId int,
      AccountName varchar(200),
      Code varchar(50),
      Description varchar(200),
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate date,
      TrunkID int,
      CountryID int,
      RateID int,
      Preference int,
      INDEX IX_Code (Code),
      INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
    );

    SELECT CurrencyID INTO v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = p_RateGeneratorId;

    SELECT
      UsePreference,
      rateposition,
      companyid ,
      CodeDeckId,
      tblRateGenerator.TrunkID,
      tblRateGenerator.UseAverage  ,
      tblRateGenerator.RateGeneratorName INTO v_Use_Preference_, v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_
    FROM tblRateGenerator
    WHERE RateGeneratorId = p_RateGeneratorId;


    SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;




    INSERT INTO tmp_Raterules_
      SELECT
        rateruleid,
        tblRateRule.Code,
        tblRateRule.Description,
        @row_num := @row_num+1 AS RowID
      FROM tblRateRule,(SELECT @row_num := 0) x
      WHERE rategeneratorid = p_RateGeneratorId
      ORDER BY tblRateRule.Code DESC;

    INSERT INTO tmp_Codedecks_
      SELECT DISTINCT
        tblVendorTrunk.CodeDeckId
      FROM tblRateRule
        INNER JOIN tblRateRuleSource
          ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
        INNER JOIN tblAccount
          ON tblAccount.AccountID = tblRateRuleSource.AccountId and tblAccount.IsVendor = 1
        JOIN tblVendorTrunk
          ON tblAccount.AccountId = tblVendorTrunk.AccountID
             AND  tblVendorTrunk.TrunkID = v_trunk_
             AND tblVendorTrunk.Status = 1
      WHERE RateGeneratorId = p_RateGeneratorId;

    SET v_pointer_ = 1;
    -- SET v_rowCount_ = (SELECT COUNT(distinct Code ) FROM tmp_Raterules_);
    SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Raterules_);




    insert into tmp_code_
      SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode
      FROM (
             SELECT @RowNo  := @RowNo + 1 as RowNo
             FROM mysql.help_category
               ,(SELECT @RowNo := 0 ) x
             limit 15
           ) x
        INNER JOIN
        (SELECT
           distinct
           tblRate.code
         FROM tblRate
           JOIN tmp_Raterules_ rr
             ON ( rr.code != '' AND tblRate.Code LIKE (REPLACE(rr.code,'*', '%%')) )
                OR
                ( rr.description != '' AND tblRate.Description LIKE (REPLACE(rr.description,'*', '%%')) )
         where  tblRate.CodeDeckId = v_codedeckid_
         Order by tblRate.code
        ) as f
          ON   x.RowNo   <= LENGTH(f.Code)
      order by loopCode   desc;





    SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
    SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;




    INSERT INTO tmp_VendorCurrentRates1_
      Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
             SELECT  tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
                                                                        CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
                                                                          THEN
                                                                            tblVendorRate.Rate
                                                                        WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
                                                                          THEN
                                                                            (
                                                                              ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
                                                                            )
                                                                        ELSE
                                                                          (

                                                                            (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
                                                                            * (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
                                                                          )
                                                                        END
                                                                                                                                                                                                                                                                                            as  Rate,
               ConnectionFee,
                                                                        DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
               tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
                                                                        @row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
               @prev_AccountId := tblVendorRate.AccountID,
               @prev_TrunkID := tblVendorRate.TrunkID,
               @prev_RateId := tblVendorRate.RateID,
               @prev_EffectiveDate := tblVendorRate.EffectiveDate
             FROM      tblVendorRate
               Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  v_trunk_
               inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
               INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
               INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
               INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
               LEFT JOIN tblVendorPreference vp
                 ON vp.AccountId = tblVendorRate.AccountId
                    AND vp.TrunkID = tblVendorRate.TrunkID
                    AND vp.RateId = tblVendorRate.RateId
               LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
                                                                   AND tblVendorRate.AccountId = blockCode.AccountId
                                                                   AND tblVendorRate.TrunkID = blockCode.TrunkID
               LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
                                                                       AND tblVendorRate.AccountId = blockCountry.AccountId
                                                                       AND tblVendorRate.TrunkID = blockCountry.TrunkID

               ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

             WHERE
               (
                 (p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
                 OR
                 (p_EffectiveRate = 'future' AND EffectiveDate > NOW())
                 OR
                 (p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate)
               )
               AND tblAccount.IsVendor = 1
               AND tblAccount.Status = 1
               AND tblAccount.CurrencyId is not NULL
               AND tblVendorRate.TrunkID = v_trunk_
               AND blockCode.RateId IS NULL
               AND blockCountry.CountryId IS NULL
               AND ( @IncludeAccountIds = NULL
                     OR ( @IncludeAccountIds IS NOT NULL
                          AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
                     )
               )
             ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
           ) tbl
      order by Code asc;

    INSERT INTO tmp_VendorCurrentRates_
      Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
             SELECT * ,
               @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
               @prev_AccountId := AccountID,
               @prev_TrunkID := TrunkID,
               @prev_RateId := RateID,
               @prev_EffectiveDate := EffectiveDate
             FROM tmp_VendorCurrentRates1_
               ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
             ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
           ) tbl
      WHERE RowID = 1
      order by Code asc;










    /* convert 9131 to all possible codes
      9131
      913
      91
     */
    insert into tmp_all_code_ (RowCode,Code,RowNo)
      select RowCode , loopCode,RowNo
      from (
             select   RowCode , loopCode,
               @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
                           ELSE 1
                           END

               )      as RowNo,
               @prev_Code := tbl1.RowCode

             from (
                    SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode
                    FROM (
                           SELECT @RowNo  := @RowNo + 1 as RowNo
                           FROM mysql.help_category
                             ,(SELECT @RowNo := 0 ) x
                           limit 15
                         ) x
                      INNER JOIN
                      (
                        select distinct Code from
                          tmp_VendorCurrentRates_
                      ) AS f
                        ON  x.RowNo   <= LENGTH(f.Code)
                    order by RowCode desc,  LENGTH(loopCode) DESC
                  ) tbl1
               , ( Select @RowNo := 0 ) x
           ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;








    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

    insert ignore into tmp_VendorRate_stage_1 (
      RowCode,
      AccountId ,
      AccountName ,
      Code ,
      Rate ,
      ConnectionFee,
      EffectiveDate ,
      Description ,
      Preference
    )
      SELECT
        distinct
        RowCode,
        v.AccountId ,
        v.AccountName ,
        v.Code ,
        v.Rate ,
        v.ConnectionFee,
        v.EffectiveDate ,
        v.Description ,
        v.Preference
      FROM tmp_VendorCurrentRates_ v
        Inner join  tmp_all_code_
                    SplitCode   on v.Code = SplitCode.Code
      where  SplitCode.Code is not null
      order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;



    insert into tmp_VendorRate_stage_
      SELECT
        RowCode,
        v.AccountId ,
        v.AccountName ,
        v.Code ,
        v.Rate ,
        v.ConnectionFee,
        v.EffectiveDate ,
        v.Description ,
        v.Preference,
        @rank := ( CASE WHEN ( @prev_RowCode   = RowCode and   @prev_AccountID = v.AccountId   )
          THEN @rank + 1
                   ELSE 1  END ) AS MaxMatchRank,

        @prev_RowCode := RowCode	 as prev_RowCode,
        @prev_AccountID := v.AccountId as prev_AccountID
      FROM tmp_VendorRate_stage_1 v
        , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
      order by AccountID,RowCode desc ;


    truncate tmp_VendorRate_;
    insert into tmp_VendorRate_
      select
        AccountId ,
        AccountName ,
        Code ,
        Rate ,
        ConnectionFee,
        EffectiveDate ,
        Description ,
        Preference,
        RowCode
      from tmp_VendorRate_stage_
      where MaxMatchRank = 1 order by RowCode desc;







    WHILE v_pointer_ <= v_rowCount_
    DO

      SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);


      INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
        select  code,rate,ConnectionFee from tmp_Rates_;



      truncate tmp_final_VendorRate_;

      IF( v_Use_Preference_ = 0 )
      THEN

        insert into tmp_final_VendorRate_
          SELECT
            AccountId ,
            AccountName ,
            Code ,
            Rate ,
            ConnectionFee,
            EffectiveDate ,
            Description ,
            Preference,
            RowCode,
            FinalRankNumber
          from
            (
              SELECT
                vr.AccountId ,
                vr.AccountName ,
                vr.Code ,
                vr.Rate ,
                vr.ConnectionFee,
                vr.EffectiveDate ,
                vr.Description ,
                vr.Preference,
                vr.RowCode,
                @rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <  vr.Rate ) THEN @rank+1
                         WHEN ( @prev_RowCode  = vr.RowCode  AND @prev_Rate = vr.Rate) THEN @rank
                         ELSE
                           1
                         END
                  AS FinalRankNumber,
                @prev_RowCode  := vr.RowCode,
                @prev_Rate  := vr.Rate
              from (
                     select tmpvr.*
                     from tmp_VendorRate_  tmpvr
                       inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
                                                       -- tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
                                                       (
                                                         ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
                                                         OR
                                                         ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
                                                       )
                       inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
                   ) vr
                ,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0  ) x
              order by vr.RowCode,vr.Rate,vr.AccountId ASC

            ) tbl1
          where FinalRankNumber <= v_RatePosition_;

      ELSE

        insert into tmp_final_VendorRate_
          SELECT
            AccountId ,
            AccountName ,
            Code ,
            Rate ,
            ConnectionFee,
            EffectiveDate ,
            Description ,
            Preference,
            RowCode,
            FinalRankNumber
          from
            (
              SELECT
                vr.AccountId ,
                vr.AccountName ,
                vr.Code ,
                vr.Rate ,
                vr.ConnectionFee,
                vr.EffectiveDate ,
                vr.Description ,
                vr.Preference,
                vr.RowCode,
                @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
                                    WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate < vr.Rate) THEN @preference_rank + 1
                                    WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate = vr.Rate) THEN @preference_rank
                                    ELSE 1 END AS FinalRankNumber,
                @prev_Code := vr.RowCode,
                @prev_Preference := vr.Preference,
                @prev_Rate := vr.Rate
              from (
                     select tmpvr.*
                     from tmp_VendorRate_  tmpvr
                       inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
                                                       -- tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
                                                       (
                                                         ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
                                                         OR
                                                         ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
                                                       )
                       inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
                   ) vr

                ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
              order by vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC

            ) tbl1
          where 				FinalRankNumber <= v_RatePosition_;

      END IF;



      truncate   tmp_VRatesstage2_;

      INSERT INTO tmp_VRatesstage2_
        SELECT
          vr.RowCode,
          vr.code,
          vr.rate,
          vr.ConnectionFee,
          vr.FinalRankNumber
        FROM tmp_final_VendorRate_ vr
          left join tmp_Rates2_ rate on rate.Code = vr.RowCode
        WHERE  rate.code is null
        order by vr.FinalRankNumber desc ;



      IF v_Average_ = 0
      THEN
        insert into tmp_dupVRatesstage2_
          SELECT RowCode , MAX(FinalRankNumber) AS MaxFinalRankNumber
          FROM tmp_VRatesstage2_ GROUP BY RowCode;

        truncate tmp_Vendorrates_stage3_;
        INSERT INTO tmp_Vendorrates_stage3_
          select  vr.RowCode as RowCode , vr.rate as rate , vr.ConnectionFee as  ConnectionFee
          from tmp_VRatesstage2_ vr
            INNER JOIN tmp_dupVRatesstage2_ vr2
              ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

        INSERT IGNORE INTO tmp_Rates_
          SELECT RowCode,
            CASE WHEN rule_mgn.RateRuleId is not null
              THEN
                CASE WHEN AddMargin LIKE '%p'
                  THEN ( vRate.rate + (CAST(REPLACE(AddMargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate)
                ELSE  vRate.rate + AddMargin
                END
            ELSE
              vRate.rate
            END as Rate,
            ConnectionFee
          FROM tmp_Vendorrates_stage3_ vRate
            left join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;



      ELSE

        INSERT IGNORE INTO tmp_Rates_
          SELECT RowCode,
            CASE WHEN rule_mgn.AddMargin is not null
              THEN
                CASE WHEN AddMargin LIKE '%p'
                  THEN ( vRate.rate + (CAST(REPLACE(AddMargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate)
                ELSE  vRate.rate + AddMargin
                END
            ELSE
              vRate.rate
            END as Rate,
            ConnectionFee
          FROM (
                 select RowCode,
                   AVG(Rate) as Rate,
                   AVG(ConnectionFee) as ConnectionFee
                 from tmp_VRatesstage2_
                 group by RowCode
               )  vRate
            left join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;
      END IF;


      SET v_pointer_ = v_pointer_ + 1;


    END WHILE;



    START TRANSACTION;

    IF p_RateTableId = -1
    THEN

      INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
      VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

      SET p_RateTableId = LAST_INSERT_ID();

      INSERT INTO tblRateTableRate (RateID,
                                    RateTableId,
                                    Rate,
                                    EffectiveDate,
                                    PreviousRate,
                                    Interval1,
                                    IntervalN,
                                    ConnectionFee
      )
        SELECT DISTINCT
          RateId,
          p_RateTableId,
          Rate,
          p_EffectiveDate,
          Rate,
          Interval1,
          IntervalN,
          ConnectionFee
        FROM tmp_Rates_ rate
          INNER JOIN tblRate
            ON rate.code  = tblRate.Code
        WHERE tblRate.CodeDeckId = v_codedeckid_;

    ELSE

      IF p_delete_exiting_rate = 1
      THEN
        DELETE tblRateTableRate
        FROM tblRateTableRate
        WHERE tblRateTableRate.RateTableId = p_RateTableId;
      END IF;

      INSERT INTO tblRateTableRate (RateID,
                                    RateTableId,
                                    Rate,
                                    EffectiveDate,
                                    PreviousRate,
                                    Interval1,
                                    IntervalN,
                                    ConnectionFee
      )
        SELECT DISTINCT
          tblRate.RateId,
          p_RateTableId RateTableId,
          rate.Rate,
          p_EffectiveDate EffectiveDate,
          rate.Rate,
          tblRate.Interval1,
          tblRate.IntervalN,
          rate.ConnectionFee
        FROM tmp_Rates_ rate
          INNER JOIN tblRate
            ON rate.code  = tblRate.Code
          LEFT JOIN tblRateTableRate tbl1
            ON tblRate.RateId = tbl1.RateId
               AND tbl1.RateTableId = p_RateTableId
          LEFT JOIN tblRateTableRate tbl2
            ON tblRate.RateId = tbl2.RateId
               and tbl2.EffectiveDate = p_EffectiveDate
               AND tbl2.RateTableId = p_RateTableId
        WHERE  (    tbl1.RateTableRateID IS NULL
                    OR
                    (
                      tbl2.RateTableRateID IS NULL
                      AND  tbl1.EffectiveDate != p_EffectiveDate

                    )
               )
               AND tblRate.CodeDeckId = v_codedeckid_;

      UPDATE tblRateTableRate
        INNER JOIN tblRate
          ON tblRate.RateId = tblRateTableRate.RateId
             AND tblRateTableRate.RateTableId = p_RateTableId
             AND tblRateTableRate.EffectiveDate = p_EffectiveDate
        INNER JOIN tmp_Rates_ as rate
          ON  rate.code  = tblRate.Code
      SET tblRateTableRate.PreviousRate = tblRateTableRate.Rate,
        tblRateTableRate.EffectiveDate = p_EffectiveDate,
        tblRateTableRate.Rate = rate.Rate,
        tblRateTableRate.ConnectionFee = rate.ConnectionFee,
        tblRateTableRate.updated_at = NOW(),
        tblRateTableRate.ModifiedBy = 'RateManagementService',
        tblRateTableRate.Interval1 = tblRate.Interval1,
        tblRateTableRate.IntervalN = tblRate.IntervalN
      WHERE tblRate.CodeDeckId = v_codedeckid_
            AND rate.rate != tblRateTableRate.Rate;

      DELETE tblRateTableRate
      FROM tblRateTableRate
      WHERE tblRateTableRate.RateTableId = p_RateTableId
            AND RateId NOT IN (SELECT DISTINCT
                                 RateId
                               FROM tmp_Rates_ rate
                                 INNER JOIN tblRate
                                   ON rate.code  = tblRate.Code
                               WHERE tblRate.CodeDeckId = v_codedeckid_)
            AND tblRateTableRate.EffectiveDate = p_EffectiveDate;


    END IF;


    UPDATE tblRateTable
    SET RateGeneratorID = p_RateGeneratorId,
      TrunkID = v_trunk_,
      CodeDeckId = v_codedeckid_,
      updated_at = now()
    WHERE RateTableID = p_RateTableId;

    SELECT p_RateTableId as RateTableID;

    CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

    COMMIT;


    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



  END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix`;
DELIMITER //
CREATE  PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
  IN `p_jobId` INT,
  IN `p_RateGeneratorId` INT,
  IN `p_RateTableId` INT,
  IN `p_rateTableName` VARCHAR(200),
  IN `p_EffectiveDate` VARCHAR(10),
  IN `p_delete_exiting_rate` INT,
  IN `p_EffectiveRate` VARCHAR(50)



)
    GenerateRateTable:BEGIN


    DECLARE v_RTRowCount_ INT;
    DECLARE v_RatePosition_ INT;
    DECLARE v_Use_Preference_ INT;
    DECLARE v_CurrencyID_ INT;
    DECLARE v_CompanyCurrencyID_ INT;
    DECLARE v_Average_ TINYINT;
    DECLARE v_CompanyId_ INT;
    DECLARE v_codedeckid_ INT;
    DECLARE v_trunk_ INT;
    DECLARE v_rateRuleId_ INT;
    DECLARE v_RateGeneratorName_ VARCHAR(200);
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;



    DECLARE v_tmp_code_cnt int ;
    DECLARE v_tmp_code_pointer int;
    DECLARE v_p_code varchar(50);
    DECLARE v_Codlen_ int;
    DECLARE v_p_code__ VARCHAR(50);
    DECLARE v_Commit int;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      show warnings;
      ROLLBACK;
      CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

    END;

    SET @@session.collation_connection='utf8_unicode_ci';
    SET @@session.character_set_client='utf8';

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);


    IF p_rateTableName IS NOT NULL
    THEN


      SET v_RTRowCount_ = (SELECT
                             COUNT(*)
                           FROM tblRateTable
                           WHERE RateTableName = p_rateTableName
                                 AND CompanyId = (SELECT
                                                    CompanyId
                                                  FROM tblRateGenerator
                                                  WHERE RateGeneratorID = p_RateGeneratorId));

      IF v_RTRowCount_ > 0
      THEN
        CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
        LEAVE GenerateRateTable;
      END IF;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
    CREATE TEMPORARY TABLE tmp_Rates_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Rates_code (`code`),
      UNIQUE KEY `unique_code` (`code`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
    CREATE TEMPORARY TABLE tmp_Rates2_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Rates2_code (`code`)
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_Codedecks_;
    CREATE TEMPORARY TABLE tmp_Codedecks_ (
      CodeDeckId INT
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;

    CREATE TEMPORARY TABLE tmp_Raterules_  (
      rateruleid INT,
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      description VARCHAR(50) COLLATE utf8_unicode_ci,
      RowNo INT,
      INDEX tmp_Raterules_code (`code`),
      INDEX tmp_Raterules_rateruleid (`rateruleid`),
      INDEX tmp_Raterules_RowNo (`RowNo`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
    CREATE TEMPORARY TABLE tmp_Vendorrates_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      AccountId INT,
      RowNo INT,
      PreferenceRank INT,
      INDEX tmp_Vendorrates_code (`code`),
      INDEX tmp_Vendorrates_rate (`rate`)
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
    CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      FinalRankNumber int,
      INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
    CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
      RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
      FinalRankNumber int,
      INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
    CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      rate DECIMAL(18, 6),
      ConnectionFee DECIMAL(18, 6),
      INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_code_;
    CREATE TEMPORARY TABLE tmp_code_  (
      code VARCHAR(50) COLLATE utf8_unicode_ci,
      INDEX tmp_code_code (`code`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
    CREATE TEMPORARY TABLE tmp_all_code_ (
      RowCode  varchar(50) COLLATE utf8_unicode_ci,
      Code  varchar(50) COLLATE utf8_unicode_ci,
      RowNo int,
      INDEX Index2 (Code)
    );



    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
    CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      MaxMatchRank int ,
      prev_prev_RowCode VARCHAR(50),
      prev_AccountID int
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
    CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
      AccountId INT ,
      AccountName VARCHAR(100) ,
      Code VARCHAR(50) COLLATE utf8_unicode_ci,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate DATETIME ,
      Description VARCHAR(255),
      Preference INT,
      RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
      FinalRankNumber int,
      INDEX IX_CODE (RowCode)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
      AccountId int,
      AccountName varchar(200),
      Code varchar(50) COLLATE utf8_unicode_ci,
      Description varchar(200) ,
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate date,
      TrunkID int,
      CountryID int,
      RateID int,
      Preference int,
      INDEX IX_CODE (Code)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
      AccountId int,
      AccountName varchar(200),
      Code varchar(50),
      Description varchar(200),
      Rate DECIMAL(18,6) ,
      ConnectionFee DECIMAL(18,6) ,
      EffectiveDate date,
      TrunkID int,
      CountryID int,
      RateID int,
      Preference int,
      INDEX IX_Code (Code),
      INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
    );

    SELECT CurrencyID INTO v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = p_RateGeneratorId;

    SELECT
      UsePreference,
      rateposition,
      companyid ,
      CodeDeckId,
      tblRateGenerator.TrunkID,
      tblRateGenerator.UseAverage  ,
      tblRateGenerator.RateGeneratorName INTO v_Use_Preference_, v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_
    FROM tblRateGenerator
    WHERE RateGeneratorId = p_RateGeneratorId;


    SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;




    INSERT INTO tmp_Raterules_
      SELECT
        rateruleid,
        tblRateRule.Code,
        tblRateRule.Description,
        @row_num := @row_num+1 AS RowID
      FROM tblRateRule,(SELECT @row_num := 0) x
      WHERE rategeneratorid = p_RateGeneratorId
      ORDER BY tblRateRule.Code DESC;

    INSERT INTO tmp_Codedecks_
      SELECT DISTINCT
        tblVendorTrunk.CodeDeckId
      FROM tblRateRule
        INNER JOIN tblRateRuleSource
          ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
        INNER JOIN tblAccount
          ON tblAccount.AccountID = tblRateRuleSource.AccountId and tblAccount.IsVendor = 1
        JOIN tblVendorTrunk
          ON tblAccount.AccountId = tblVendorTrunk.AccountID
             AND  tblVendorTrunk.TrunkID = v_trunk_
             AND tblVendorTrunk.Status = 1
      WHERE RateGeneratorId = p_RateGeneratorId;

    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(distinct Code ) FROM tmp_Raterules_);







    insert into tmp_code_
      SELECT
        tblRate.code
      FROM tblRate
        JOIN tmp_Codedecks_ cd
          ON tblRate.CodeDeckId = cd.CodeDeckId
        JOIN tmp_Raterules_ rr
          ON ( rr.code != '' AND tblRate.Code LIKE (REPLACE(rr.code,'*', '%%')) )
             OR
             ( rr.description != '' AND tblRate.Description LIKE (REPLACE(rr.description,'*', '%%')) )

      Order by tblRate.code ;









    SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
    SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;



    INSERT INTO tmp_VendorCurrentRates1_
      Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
             SELECT  tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
                                                                        CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
                                                                          THEN
                                                                            tblVendorRate.Rate
                                                                        WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
                                                                          THEN
                                                                            (
                                                                              ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
                                                                            )
                                                                        ELSE
                                                                          (

                                                                            (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
                                                                            * (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
                                                                          )
                                                                        END
                                                                                                                                                                                                                                                                                            as  Rate,
               ConnectionFee,
                                                                        DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
               tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
                                                                        @row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
               @prev_AccountId := tblVendorRate.AccountID,
               @prev_TrunkID := tblVendorRate.TrunkID,
               @prev_RateId := tblVendorRate.RateID,
               @prev_EffectiveDate := tblVendorRate.EffectiveDate
             FROM      tblVendorRate

               Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and

                                               vt.Status =  1 and vt.TrunkID =  v_trunk_
               inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
               INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
               INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
               INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
               LEFT JOIN tblVendorPreference vp
                 ON vp.AccountId = tblVendorRate.AccountId
                    AND vp.TrunkID = tblVendorRate.TrunkID
                    AND vp.RateId = tblVendorRate.RateId
               LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
                                                                   AND tblVendorRate.AccountId = blockCode.AccountId
                                                                   AND tblVendorRate.TrunkID = blockCode.TrunkID
               LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
                                                                       AND tblVendorRate.AccountId = blockCountry.AccountId
                                                                       AND tblVendorRate.TrunkID = blockCountry.TrunkID

               ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

             WHERE
               (
                 (p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
                 OR
                 (p_EffectiveRate = 'future' AND EffectiveDate > NOW())
                 OR
                 (p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate)
               )
               AND tblAccount.IsVendor = 1
               AND tblAccount.Status = 1
               AND tblAccount.CurrencyId is not NULL
               AND tblVendorRate.TrunkID = v_trunk_
               AND blockCode.RateId IS NULL
               AND blockCountry.CountryId IS NULL
               AND ( @IncludeAccountIds = NULL
                     OR ( @IncludeAccountIds IS NOT NULL
                          AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
                     )
               )
             ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
           ) tbl
      order by Code asc;

    INSERT INTO tmp_VendorCurrentRates_
      Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
             SELECT * ,
               @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
               @prev_AccountId := AccountID,
               @prev_TrunkID := TrunkID,
               @prev_RateId := RateID,
               @prev_EffectiveDate := EffectiveDate
             FROM tmp_VendorCurrentRates1_
               ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
             ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
           ) tbl
      WHERE RowID = 1
      order by Code asc;













    insert into tmp_all_code_ (RowCode,Code,RowNo)
      select RowCode , loopCode,RowNo
      from (
             select   RowCode , loopCode,
               @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
                           ELSE 1
                           END

               )      as RowNo,
               @prev_Code := tbl1.RowCode
             from (
                    select distinct Code as RowCode, Code as  loopCode from
                      tmp_VendorCurrentRates_
                  ) tbl1
               , ( Select @RowNo := 0 ) x
           ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;















    insert into tmp_VendorRate_
      select
        AccountId ,
        AccountName ,
        Code ,
        Rate ,
        ConnectionFee,
        EffectiveDate ,
        Description ,
        Preference,
        Code as RowCode
      from tmp_VendorCurrentRates_;






    WHILE v_pointer_ <= v_rowCount_
    DO

      SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);


      INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
        select  code,rate,ConnectionFee from tmp_Rates_;



      truncate tmp_final_VendorRate_;

      IF( v_Use_Preference_ = 0 )
      THEN

        insert into tmp_final_VendorRate_
          SELECT
            AccountId ,
            AccountName ,
            Code ,
            Rate ,
            ConnectionFee,
            EffectiveDate ,
            Description ,
            Preference,
            RowCode,
            FinalRankNumber
          from
            (
              SELECT
                vr.AccountId ,
                vr.AccountName ,
                vr.Code ,
                vr.Rate ,
                vr.ConnectionFee,
                vr.EffectiveDate ,
                vr.Description ,
                vr.Preference,
                vr.RowCode,
                @rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate ) THEN @rank+1

                         ELSE
                           1
                         END
                  AS FinalRankNumber,
                @prev_RowCode  := vr.RowCode,
                @prev_Rate  := vr.Rate
              from (
                     select tmpvr.*
                     from tmp_VendorRate_  tmpvr
                       inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
                                                       -- tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
                                                       (
                                                         ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
                                                         OR
                                                         ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
                                                       )
                       inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
                   ) vr
                ,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0  ) x
              order by vr.RowCode,vr.Rate,vr.AccountId ASC

            ) tbl1
          where FinalRankNumber <= v_RatePosition_;

      ELSE

        insert into tmp_final_VendorRate_
          SELECT
            AccountId ,
            AccountName ,
            Code ,
            Rate ,
            ConnectionFee,
            EffectiveDate ,
            Description ,
            Preference,
            RowCode,
            FinalRankNumber
          from
            (
              SELECT
                vr.AccountId ,
                vr.AccountName ,
                vr.Code ,
                vr.Rate ,
                vr.ConnectionFee,
                vr.EffectiveDate ,
                vr.Description ,
                vr.Preference,
                vr.RowCode,
                @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
                                    WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1

                                    ELSE 1 END AS FinalRankNumber,
                @prev_Code := vr.RowCode,
                @prev_Preference := vr.Preference,
                @prev_Rate := vr.Rate
              from (
                     select tmpvr.*
                     from tmp_VendorRate_  tmpvr
                       inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
                                                       -- tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
                                                       (
                                                         ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
                                                         OR
                                                         ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
                                                       )
                       inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
                   ) vr

                ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
              order by vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC

            ) tbl1
          where FinalRankNumber <= v_RatePosition_;

      END IF;



      truncate   tmp_VRatesstage2_;

      INSERT INTO tmp_VRatesstage2_
        SELECT
          vr.RowCode,
          vr.code,
          vr.rate,
          vr.ConnectionFee,
          vr.FinalRankNumber
        FROM tmp_final_VendorRate_ vr
          left join tmp_Rates2_ rate on rate.Code = vr.RowCode
        WHERE  rate.code is null
        order by vr.FinalRankNumber desc ;



      IF v_Average_ = 0
      THEN
        insert into tmp_dupVRatesstage2_
          SELECT RowCode , MAX(FinalRankNumber) AS MaxFinalRankNumber
          FROM tmp_VRatesstage2_ GROUP BY RowCode;

        truncate tmp_Vendorrates_stage3_;
        INSERT INTO tmp_Vendorrates_stage3_
          select  vr.RowCode as RowCode , vr.rate as rate , vr.ConnectionFee as  ConnectionFee
          from tmp_VRatesstage2_ vr
            INNER JOIN tmp_dupVRatesstage2_ vr2
              ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

        INSERT IGNORE INTO tmp_Rates_
          SELECT
            RowCode,
            IFNULL((SELECT
            CASE WHEN vRate.rate  BETWEEN minrate AND maxrate THEN vRate.rate
                                                                   + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin
                                                                      END) ELSE vRate.rate
            END
                    FROM tblRateRuleMargin
                    WHERE rateruleid = v_rateRuleId_
                          and vRate.rate  BETWEEN minrate AND maxrate LIMIT 1
                   ),vRate.Rate) as Rate,
            ConnectionFee
          FROM tmp_Vendorrates_stage3_ vRate;



      ELSE

        INSERT IGNORE INTO tmp_Rates_
          SELECT
            RowCode,
            IFNULL((SELECT
            CASE WHEN vRate.rate  BETWEEN minrate AND maxrate THEN vRate.rate
                                                                   + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin
                                                                      END) ELSE vRate.rate
            END
                    FROM tblRateRuleMargin
                    WHERE rateruleid = v_rateRuleId_
                          and vRate.rate  BETWEEN minrate AND maxrate LIMIT 1
                   ),vRate.Rate) as Rate,
            ConnectionFee
          FROM (
                 select RowCode,
                   AVG(Rate) as Rate,
                   AVG(ConnectionFee) as ConnectionFee
                 from tmp_VRatesstage2_
                 group by RowCode
               )  vRate;




      END IF;


      SET v_pointer_ = v_pointer_ + 1;


    END WHILE;


    START TRANSACTION;

    IF p_RateTableId = -1
    THEN

      INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
      VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

      SET p_RateTableId = LAST_INSERT_ID();

      INSERT INTO tblRateTableRate (RateID,
                                    RateTableId,
                                    Rate,
                                    EffectiveDate,
                                    PreviousRate,
                                    Interval1,
                                    IntervalN,
                                    ConnectionFee
      )
        SELECT DISTINCT
          RateId,
          p_RateTableId,
          Rate,
          p_EffectiveDate,
          Rate,
          Interval1,
          IntervalN,
          ConnectionFee
        FROM tmp_Rates_ rate
          INNER JOIN tblRate
            ON rate.code  = tblRate.Code
        WHERE tblRate.CodeDeckId = v_codedeckid_;

    ELSE

      IF p_delete_exiting_rate = 1
      THEN
        DELETE tblRateTableRate
        FROM tblRateTableRate
        WHERE tblRateTableRate.RateTableId = p_RateTableId;
      END IF;

      INSERT INTO tblRateTableRate (RateID,
                                    RateTableId,
                                    Rate,
                                    EffectiveDate,
                                    PreviousRate,
                                    Interval1,
                                    IntervalN,
                                    ConnectionFee
      )
        SELECT DISTINCT
          tblRate.RateId,
          p_RateTableId RateTableId,
          rate.Rate,
          p_EffectiveDate EffectiveDate,
          rate.Rate,
          tblRate.Interval1,
          tblRate.IntervalN,
          rate.ConnectionFee
        FROM tmp_Rates_ rate
          INNER JOIN tblRate
            ON rate.code  = tblRate.Code
          LEFT JOIN tblRateTableRate tbl1
            ON tblRate.RateId = tbl1.RateId
               AND tbl1.RateTableId = p_RateTableId
          LEFT JOIN tblRateTableRate tbl2
            ON tblRate.RateId = tbl2.RateId
               and tbl2.EffectiveDate = p_EffectiveDate
               AND tbl2.RateTableId = p_RateTableId
        WHERE  (    tbl1.RateTableRateID IS NULL
                    OR
                    (
                      tbl2.RateTableRateID IS NULL
                      AND  tbl1.EffectiveDate != p_EffectiveDate

                    )
               )
               AND tblRate.CodeDeckId = v_codedeckid_;

      UPDATE tblRateTableRate
        INNER JOIN tblRate
          ON tblRate.RateId = tblRateTableRate.RateId
             AND tblRateTableRate.RateTableId = p_RateTableId
             AND tblRateTableRate.EffectiveDate = p_EffectiveDate
        INNER JOIN tmp_Rates_ as rate
          ON  rate.code  = tblRate.Code
      SET tblRateTableRate.PreviousRate = tblRateTableRate.Rate,
        tblRateTableRate.EffectiveDate = p_EffectiveDate,
        tblRateTableRate.Rate = rate.Rate,
        tblRateTableRate.ConnectionFee = rate.ConnectionFee,
        tblRateTableRate.updated_at = NOW(),
        tblRateTableRate.ModifiedBy = 'RateManagementService',
        tblRateTableRate.Interval1 = tblRate.Interval1,
        tblRateTableRate.IntervalN = tblRate.IntervalN
      WHERE tblRate.CodeDeckId = v_codedeckid_
            AND rate.rate != tblRateTableRate.Rate;

      DELETE tblRateTableRate
      FROM tblRateTableRate
      WHERE tblRateTableRate.RateTableId = p_RateTableId
            AND RateId NOT IN (SELECT DISTINCT
                                 RateId
                               FROM tmp_Rates_ rate
                                 INNER JOIN tblRate
                                   ON rate.code  = tblRate.Code
                               WHERE tblRate.CodeDeckId = v_codedeckid_)
            AND tblRateTableRate.EffectiveDate = p_EffectiveDate;


    END IF;


    UPDATE tblRateTable
    SET RateGeneratorID = p_RateGeneratorId,
      TrunkID = v_trunk_,
      CodeDeckId = v_codedeckid_,
      updated_at = now()
    WHERE RateTableID = p_RateTableId;

    SELECT p_RateTableId as RateTableID;

    CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

    COMMIT;


    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



  END//
DELIMITER ;



DROP PROCEDURE IF EXISTS `prc_CheckTicketsSlaVoilation`;
DELIMITER //
CREATE PROCEDURE `prc_CheckTicketsSlaVoilation`(
  IN `p_CompanyID` int,
  IN `p_currentDateTime` DATETIME

)
  BEGIN
    DECLARE P_Status varchar(100);
    DECLARE v_ClosedResolvedStatus varchar(100);

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET  sql_mode='';

    SELECT
      group_concat(TFV.ValuesID separator ',') INTO P_Status FROM tblTicketfieldsValues TFV
      LEFT JOIN tblTicketfields TF
        ON TF.TicketFieldsID = TFV.FieldsID
    WHERE
      TF.FieldType = 'default_status' AND TFV.FieldValueAgent!='Closed' AND TFV.FieldValueAgent!='Resolved';


    SELECT
      group_concat(TFV.ValuesID separator ',') INTO v_ClosedResolvedStatus FROM tblTicketfieldsValues TFV
      LEFT JOIN tblTicketfields TF
        ON TF.TicketFieldsID = TFV.FieldsID
    WHERE
      TF.FieldType = 'default_status' AND TFV.FieldValueAgent='Closed' AND TFV.FieldValueAgent='Resolved';




    DROP TEMPORARY TABLE IF EXISTS tmp_tickets_sla_voilation_;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tickets_sla_voilation_(
      TicketID int,
      TicketSlaID int,
      CreatedDate datetime,
      RespondTime datetime,
      ResolveTime datetime,
      IsRespondedVoilation int,
      RespondEmailTime datetime,
      DueDate datetime,
      IsResolvedVoilation int,
      EscalationEmail int

    );
    insert into tmp_tickets_sla_voilation_
      SELECT
        T.TicketID,
        T.TicketSlaID as TicketSlaID,
        T.created_at as CreatedDate,
        CASE WHEN (TST.RespondType = 'Minute') THEN
          DATE_ADD(T.created_at, INTERVAL TST.RespondValue Minute)
        WHEN RespondType = 'Hour' THEN
          DATE_ADD(T.created_at, INTERVAL TST.RespondValue Hour)
        WHEN (TST.RespondType = 'Day') THEN
          DATE_ADD(T.created_at, INTERVAL TST.RespondValue Day)
        WHEN RespondType = 'Month' THEN
          DATE_ADD(T.created_at, INTERVAL TST.RespondValue Month)
        END AS RespondTime,
        CASE WHEN (TST.ResolveType = 'Minute') THEN
          DATE_ADD(T.DueDate, INTERVAL TST.ResolveValue Minute)
        WHEN ResolveType = 'Hour' THEN
          DATE_ADD(T.DueDate, INTERVAL TST.ResolveValue Hour)
        WHEN (TST.ResolveType = 'Day') THEN
          DATE_ADD(T.DueDate, INTERVAL TST.ResolveValue Day)
        WHEN ResolveType = 'Month' THEN
          DATE_ADD(T.DueDate, INTERVAL TST.ResolveValue Month)
        END AS ResolveTime,
        T.RespondSlaPolicyVoilationEmailStatus AS IsRespondedVoilation,
        '0000-00-00 00:00' as RespondEmailTime,
        T.DueDate,
        T.ResolveSlaPolicyVoilationEmailStatus AS IsResolvedVoilation,
        TST.EscalationEmail as EscalationEmail

      FROM
        tblTickets T
        LEFT JOIN tblTicketSlaTarget TST
          ON TST.TicketSlaID = T.TicketSlaID
      WHERE
        T.CompanyID = p_CompanyID
        AND TST.PriorityID = T.Priority
        AND T.Group > 0
        AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))
        AND ( ( AgentRepliedDate is NULL AND T.RespondSlaPolicyVoilationEmailStatus = 0 ) OR  ( find_in_set(T.`Status`,v_ClosedResolvedStatus) = 0 AND  T.ResolveSlaPolicyVoilationEmailStatus = 0 ) )
        AND T.TicketSlaID>0;



    UPDATE tmp_tickets_sla_voilation_ TSV SET
      TSV.IsRespondedVoilation =
      CASE
      WHEN TSV.IsRespondedVoilation =1 THEN 0
      WHEN p_currentDateTime>=TSV.RespondTime THEN 1 ELSE 0
      END,
      TSV.IsResolvedVoilation  =
      CASE
      WHEN TSV.IsResolvedVoilation =1 THEN 0
      WHEN p_currentDateTime>=TSV.ResolveTime THEN 1 ELSE 0
      END;

    SELECT * FROM tmp_tickets_sla_voilation_;




    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  END//
DELIMITER ;

USE `RMBilling3`;

DROP PROCEDURE IF EXISTS `prc_getInvoice`;
DELIMITER |
CREATE PROCEDURE `prc_getInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_InvoiceType` INT,
	IN `p_InvoiceStatus` VARCHAR(50),
	IN `p_IsOverdue` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_CurrencyID` INT,
	IN `p_isExport` INT,
	IN `p_sageExport` INT,
	IN `p_zerovalueinvoice` INT,
	IN `p_InvoiceID` LONGTEXT,
	IN `p_userID` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_TotalCount int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET  sql_mode='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT cr.Symbol INTO v_CurrencyCode_ from Ratemanagement3.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		InvoiceType tinyint(1),
		AccountName varchar(100),
		InvoiceNumber varchar(100),
		IssueDate datetime,
		InvoicePeriod varchar(100),
		CurrencySymbol varchar(5),
		GrandTotal decimal(18,6),
		TotalPayment decimal(18,6),
		PendingAmount decimal(18,6),
		InvoiceStatus varchar(50),
		InvoiceID int,
		Description varchar(500),
		Attachment varchar(255),
		AccountID int,
		ItemInvoice tinyint(1),
		BillingEmail varchar(255),
		AccountNumber varchar(100),
		PaymentDueInDays int,
		PaymentDate datetime,
		SubTotal decimal(18,6),
		TotalTax decimal(18,6),
		NominalAnalysisNominalAccountNumber varchar(100)
	);

		INSERT INTO tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			inv.GrandTotal as GrandTotal,
			(SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			inv.InvoiceID,
			inv.Description,
			inv.Attachment,
			inv.AccountID,
			inv.ItemInvoice,
			IFNULL(ac.BillingEmail,'') as BillingEmail,
			ac.Number,
			if (inv.BillingClassID > 0,
				 (SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblBillingClass b where  b.BillingClassID =inv.BillingClassID),
				 (SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID LIMIT 1)
			) as PaymentDueInDays,
			(SELECT PaymentDate FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID ORDER BY PaymentID DESC LIMIT 1) AS PaymentDate,
			inv.SubTotal,
			inv.TotalTax,
			ac.NominalAnalysisNominalAccountNumber
			FROM tblInvoice inv
			INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
			LEFT JOIN tblInvoiceDetail invd ON invd.InvoiceID = inv.InvoiceID AND (invd.ProductType = 5 OR inv.InvoiceType = 2)
			LEFT JOIN Ratemanagement3.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId
			WHERE ac.CompanyID = p_CompanyID
			AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
			AND (p_userID = 0 OR ac.Owner = p_userID)
			AND (p_InvoiceNumber = '' OR (inv.FullInvoiceNumber like Concat('%',p_InvoiceNumber,'%')))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
			AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
			AND (p_InvoiceStatus = '' OR ( p_InvoiceStatus != '' AND FIND_IN_SET(inv.InvoiceStatus,p_InvoiceStatus) ))
			AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal != 0))
			AND (p_InvoiceID = '' OR (p_InvoiceID !='' AND FIND_IN_SET (inv.InvoiceID,p_InvoiceID)!= 0 ))
			AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));

	IF p_isExport = 0 and p_sageExport = 0
	THEN

		SELECT
			InvoiceType ,
			AccountName,
			InvoiceNumber,
			IssueDate,
			InvoicePeriod,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
			InvoiceStatus,
			DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY)) AS DueDate,
			IF(InvoiceStatus NOT IN ('paid','cancel','draft'), IF(DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))) > 0,DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))),''), '') AS DueDays,
			InvoiceID,
			Description,
			Attachment,
			AccountID,
			PendingAmount as OutstandingAmount,
			ItemInvoice,
			BillingEmail,
			GrandTotal
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				)
		ORDER BY
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeDESC') THEN InvoiceType
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeASC') THEN InvoiceType
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusDESC') THEN InvoiceStatus
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusASC') THEN InvoiceStatus
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberASC') THEN InvoiceNumber
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberDESC') THEN InvoiceNumber
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN IssueDate
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN IssueDate
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodASC') THEN InvoicePeriod
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodDESC') THEN InvoicePeriod
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN GrandTotal
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN GrandTotal
				END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDDESC') THEN InvoiceID
				END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDASC') THEN InvoiceID
				END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT COUNT(*) INTO v_TotalCount
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);

		SELECT
			v_TotalCount AS totalcount,
			ROUND(sum(GrandTotal),v_Round_) as total_grand,
			ROUND(sum(TotalPayment),v_Round_) as `TotalPayment`,
			ROUND(sum(PendingAmount),v_Round_) as `TotalPendingAmount`,
			v_CurrencyCode_ as currency_symbol
		FROM tmp_Invoices_
			WHERE ((InvoiceStatus IS NULL) OR (InvoiceStatus NOT IN('draft','Cancel')))
			AND (p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);

	END IF;
	IF p_isExport = 1
	THEN

		SELECT
			AccountName ,
			InvoiceNumber,
			IssueDate,
			REPLACE(InvoicePeriod, '<br>', '') as InvoicePeriod,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
			InvoiceStatus,
			InvoiceType,
			ItemInvoice
		FROM tmp_Invoices_
		WHERE
				(p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);
		END IF;
	IF p_isExport = 2
	THEN

		

		SELECT
			AccountName ,
			InvoiceNumber,
			IssueDate,
			REPLACE(InvoicePeriod, '<br>', '') as InvoicePeriod,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
			InvoiceStatus,
			InvoiceType,
			ItemInvoice,
			InvoiceID
		FROM tmp_Invoices_
		WHERE
				(p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);

	END IF;

	IF p_sageExport =1 OR p_sageExport =2
	THEN
			

		IF p_sageExport = 2
		THEN
			UPDATE tblInvoice  inv
			INNER JOIN Ratemanagement3.tblAccount ac
				ON ac.AccountID = inv.AccountID
			INNER JOIN Ratemanagement3.tblAccountBilling ab
				ON ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID
			INNER JOIN Ratemanagement3.tblBillingClass b
				ON ab.BillingClassID = b.BillingClassID
			INNER JOIN Ratemanagement3.tblCurrency c
				ON c.CurrencyId = ac.CurrencyId
			SET InvoiceStatus = 'paid'
			WHERE ac.CompanyID = p_CompanyID
				AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
				AND (p_userID = 0 OR ac.Owner = p_userID)
				AND (p_InvoiceNumber = '' OR (inv.FullInvoiceNumber like Concat('%',p_InvoiceNumber,'%')))
				AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
				AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
				AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
				AND (p_InvoiceStatus = '' OR ( p_InvoiceStatus != '' AND FIND_IN_SET(inv.InvoiceStatus,p_InvoiceStatus) ))
				AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal != 0))
				AND (p_InvoiceID = '' OR (p_InvoiceID !='' AND FIND_IN_SET (inv.InvoiceID,p_InvoiceID)!= 0 ))
				AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID))
				AND (p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > IFNULL(b.PaymentDueInDays,0)
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND((inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) )>0)
						)
				);
		END IF;
		SELECT
			AccountNumber,
			DATE_FORMAT(DATE_ADD(IssueDate,INTERVAL PaymentDueInDays DAY), '%Y-%m-%d') AS DueDate,
			GrandTotal AS GoodsValueInAccountCurrency,
			GrandTotal AS SalControlValueInBaseCurrency,
			1 AS DocumentToBaseCurrencyRate,
			1 AS DocumentToAccountCurrencyRate,
			DATE_FORMAT(IssueDate, '%Y-%m-%d') AS PostedDate,
			InvoiceNumber AS TransactionReference,
			'' AS SecondReference,
			'' AS Source,
			4 AS SYSTraderTranType, 
			DATE_FORMAT(PaymentDate ,'%Y-%m-%d') AS TransactionDate,
			TotalTax AS TaxValue,
			SubTotal AS `NominalAnalysisTransactionValue/1`,
			NominalAnalysisNominalAccountNumber AS `NominalAnalysisNominalAccountNumber/1`,
			'NEON' AS `NominalAnalysisNominalAnalysisNarrative/1`,
			'' AS `NominalAnalysisTransactionAnalysisCode/1`,
			1 AS `TaxAnalysisTaxRate/1`,
			SubTotal AS `TaxAnalysisGoodsValueBeforeDiscount/1`,
			TotalTax as   `TaxAnalysisTaxOnGoodsValue/1`
		FROM tmp_Invoices_
		WHERE
				(p_IsOverdue = 0
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getPayments`;
DELIMITER |
CREATE PROCEDURE `prc_getPayments`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_InvoiceNo` VARCHAR(30),
	IN `p_FullInvoiceNumber` VARCHAR(50),
	IN `p_Status` VARCHAR(20),
	IN `p_PaymentType` VARCHAR(20),
	IN `p_PaymentMethod` VARCHAR(20),
	IN `p_RecallOnOff` INT,
	IN `p_CurrencyID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isCustomer` INT ,
	IN `p_paymentStartDate` DATETIME,
	IN `p_paymentEndDate` DATETIME,
	IN `p_isExport` INT,
	IN `p_userID` INT
)
BEGIN
		
	DECLARE v_OffSet_ INT;
	DECLARE v_Round_ INT;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	SET sql_mode = '';

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT cr.Symbol INTO v_CurrencyCode_ FROM Ratemanagement3.tblCurrency cr WHERE cr.CurrencyId =p_CurrencyID;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT
			tblPayment.PaymentID,
			tblAccount.AccountName,
			tblPayment.AccountID,
			ROUND(tblPayment.Amount,v_Round_) AS Amount,
			CASE WHEN p_isCustomer = 1 THEN
				CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
				END
			ELSE
				PaymentType
			END as PaymentType,
			tblPayment.CurrencyID,
			tblPayment.PaymentDate,
			CASE WHEN p_RecallOnOff = -1 AND tblPayment.Recall=1  THEN 'Recalled' ELSE tblPayment.Status END as `Status`,
			tblPayment.CreatedBy,
			tblPayment.PaymentProof,
			tblPayment.InvoiceNo,
			tblPayment.PaymentMethod,
			tblPayment.Notes,
			tblPayment.Recall,
			tblPayment.RecallReasoan,
			tblPayment.RecallBy,
			CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) AS AmountWithSymbol
		FROM tblPayment
		LEFT JOIN Ratemanagement3.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
		WHERE tblPayment.CompanyID = p_CompanyID
			AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
			AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
			AND((p_FullInvoiceNumber = '' OR tblPayment.InvoiceNo = p_FullInvoiceNumber))
			AND((p_Status IS NULL OR tblPayment.Status = p_Status))
			AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
			AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID)
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN tblAccount.AccountName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN tblAccount.AccountName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoDESC') THEN InvoiceNo
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoASC') THEN InvoiceNo
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentTypeDESC') THEN PaymentType
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentTypeASC') THEN PaymentType
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateDESC') THEN PaymentDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateASC') THEN PaymentDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tblPayment.Status
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tblPayment.Status
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN tblPayment.CreatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN tblPayment.CreatedBy
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(tblPayment.PaymentID) AS totalcount,
			CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(sum(Amount),v_Round_)) AS total_grand
		FROM tblPayment
		LEFT JOIN Ratemanagement3.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
		WHERE tblPayment.CompanyID = p_CompanyID
			AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
			AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
			AND((p_FullInvoiceNumber = '' OR tblPayment.InvoiceNo = p_FullInvoiceNumber))
			AND((p_Status IS NULL OR tblPayment.Status = p_Status))
			AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
			AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);

	END IF;
	IF p_isExport = 1
	THEN

		SELECT 
			AccountName,
			CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) AS Amount,
			CASE WHEN p_isCustomer = 1 THEN
				CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
				END
			ELSE  PaymentType
			END AS PaymentType,
			PaymentDate,
			tblPayment.Status,
			tblPayment.CreatedBy,
			InvoiceNo,
			tblPayment.PaymentMethod,
			Notes 
		FROM tblPayment
		LEFT JOIN Ratemanagement3.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
		WHERE tblPayment.CompanyID = p_CompanyID
			AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
			AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
			AND((p_FullInvoiceNumber = '' OR tblPayment.InvoiceNo = p_FullInvoiceNumber))
			AND((p_Status IS NULL OR tblPayment.Status = p_Status))
			AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
			AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);
	END IF;
	
	
	IF p_isExport = 2
	THEN

		SELECT 
			AccountName,
			CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) as Amount,
			CASE WHEN p_isCustomer = 1 THEN
				CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
				END
			ELSE  PaymentType
			END as PaymentType,
			PaymentDate,
			tblPayment.Status,
			InvoiceNo,
			tblPayment.PaymentMethod,
			Notes 
		FROM tblPayment
		LEFT JOIN Ratemanagement3.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
		WHERE tblPayment.CompanyID = p_CompanyID
			AND(tblPayment.Recall = p_RecallOnOff)
			AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo = p_InvoiceNo))
			AND((p_FullInvoiceNumber = '' OR tblPayment.InvoiceNo = p_FullInvoiceNumber))
			AND((p_Status IS NULL OR tblPayment.Status = p_Status))
			AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
			AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP FUNCTION IF EXISTS `fnGetAutoAddIP`;
DELIMITER |
CREATE FUNCTION `fnGetAutoAddIP`(
	`p_CompanyGatewayID` INT
) RETURNS int(11)
BEGIN

	DECLARE v_AutoAddIP_ INT;

	SELECT 
		CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.AutoAddIP'),'"','') > 0
		THEN
			CAST(REPLACE(JSON_EXTRACT(cg.Settings, '$.AutoAddIP'),'"','') AS UNSIGNED INTEGER)
		ELSE
			NULL
		END
	INTO v_AutoAddIP_
	FROM Ratemanagement3.tblCompanyGateway cg
	WHERE cg.CompanyGatewayID = p_CompanyGatewayID
	LIMIT 1;
	
	SET v_AutoAddIP_ = IFNULL(v_AutoAddIP_,0);

	RETURN v_AutoAddIP_;
END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_autoAddIP`;
DELIMITER |
CREATE PROCEDURE `prc_autoAddIP`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT
)
BEGIN
	DECLARE AutoAddIP INT;
	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL
	);
	SELECT fnGetAutoAddIP(p_CompanyGatewayID) INTO AutoAddIP;
	IF AutoAddIP = 1
	THEN
		INSERT IGNORE INTO tmp_tblTempRateLog_ (
			CompanyID,
			CompanyGatewayID,
			MessageType,
			Message,
			RateDate
		)
		SELECT 
			ga.CompanyID,
			ga.CompanyGatewayID,
			4,
			CONCAT('Account: ',ga.AccountName,' - IP: ',GROUP_CONCAT(ga.AccountIP)),
			DATE(NOW())
		FROM tblGatewayAccount ga
		INNER JOIN Ratemanagement3.tblAccount a 
			ON a.AccountName = ga.AccountName
			AND a.CompanyId = p_CompanyID
			AND a.AccountType = 1
			AND a.`Status` = 1
		WHERE  ga.CompanyID = p_CompanyID 
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.AccountID IS NULL 
			AND ga.AccountName <> ''
			AND ga.AccountIP <> ''
			AND ga.IsVendor IS NULL
		GROUP BY ga.CompanyID,ga.CompanyGatewayID,ga.AccountID,ga.AccountName,ga.ServiceID;
		
		INSERT INTO Ratemanagement3.tblTempRateLog (
			CompanyID,
			CompanyGatewayID,
			MessageType,
			Message,
			RateDate,
			SentStatus,
			created_at
		)
		SELECT
			CompanyID,
			CompanyGatewayID,
			MessageType,
			Message,
			RateDate,
			0,
			NOW()
		FROM tmp_tblTempRateLog_;
	
		/* update customer ips */
		UPDATE Ratemanagement3.tblAccountAuthenticate aa
		INNER JOIN (
			SELECT 
				ga.CompanyID,
				a.AccountID,
				CONCAT(IFNULL(MAX(aa.CustomerAuthValue),''),IF(MAX(aa.CustomerAuthValue) IS NULL,'',','),GROUP_CONCAT(ga.AccountIP)) AS CustomerAuthValue 
			FROM tblGatewayAccount ga
			INNER JOIN Ratemanagement3.tblAccount a 
				ON a.AccountName = ga.AccountName
				AND a.CompanyId = p_CompanyID
				AND a.AccountType = 1
				AND a.`Status` = 1
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID
			WHERE  ga.CompanyID = p_CompanyID 
				AND ga.CompanyGatewayID = p_CompanyGatewayID
				AND ga.AccountID IS NULL 
				AND ga.AccountName <> ''
				AND ga.AccountIP <> ''
				AND ga.IsVendor IS NULL
				AND ( 
						 ( FIND_IN_SET(ga.AccountIP,aa.CustomerAuthValue) IS NULL OR FIND_IN_SET(ga.AccountIP,aa.CustomerAuthValue) = 0)
					AND ( FIND_IN_SET(ga.AccountIP,aa.VendorAuthValue) IS NULL OR FIND_IN_SET(ga.AccountIP,aa.VendorAuthValue) = 0)
					 )
			GROUP BY ga.CompanyID,ga.CompanyGatewayID,a.AccountID,ga.AccountName,ga.ServiceID
		) TBl
		ON TBl.AccountID = aa.AccountID
		SET aa.CustomerAuthValue = TBl.CustomerAuthValue;
	
		/* update vendor ips */
		UPDATE Ratemanagement3.tblAccountAuthenticate aa
		INNER JOIN (
			SELECT
				ga.CompanyID,
				a.AccountID,
				CONCAT(IFNULL(MAX(aa.VendorAuthValue),''),IF(MAX(aa.VendorAuthValue) IS NULL,'',','),GROUP_CONCAT(ga.AccountIP)) AS VendorAuthValue 
			FROM tblGatewayAccount ga
			INNER JOIN Ratemanagement3.tblAccount a 
				ON a.AccountName = ga.AccountName
				AND a.CompanyId = p_CompanyID
				AND a.AccountType = 1
				AND a.`Status` = 1
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID
			WHERE  ga.CompanyID = p_CompanyID 
				AND ga.CompanyGatewayID = p_CompanyGatewayID
				AND ga.AccountID IS NULL 
				AND ga.AccountName <> ''
				AND ga.AccountIP <> ''
				AND ga.IsVendor = 1
				AND ( 
						 ( FIND_IN_SET(ga.AccountIP,aa.CustomerAuthValue) IS NULL OR FIND_IN_SET(ga.AccountIP,aa.CustomerAuthValue) = 0)
					AND ( FIND_IN_SET(ga.AccountIP,aa.VendorAuthValue) IS NULL OR FIND_IN_SET(ga.AccountIP,aa.VendorAuthValue) = 0)
					 )
			GROUP BY ga.CompanyID,ga.CompanyGatewayID,a.AccountID,ga.AccountName,ga.ServiceID
		) TBl
		ON TBl.AccountID = aa.AccountID
		SET aa.VendorAuthValue = TBl.VendorAuthValue;
	
		/* insert customer ips */
		INSERT IGNORE INTO Ratemanagement3.tblAccountAuthenticate (
			CompanyID,
			AccountID,
			CustomerAuthRule,
			CustomerAuthValue,
			ServiceID
		)
		SELECT 
			ga.CompanyID,
			a.AccountID,
			'IP',
			GROUP_CONCAT(ga.AccountIP),
			ga.ServiceID
		FROM tblGatewayAccount ga
		INNER JOIN Ratemanagement3.tblAccount a 
			ON a.AccountName = ga.AccountName
			AND a.CompanyId = p_CompanyID
			AND a.AccountType = 1
			AND a.`Status` = 1
		LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
			ON a.AccountID = aa.AccountID
		WHERE  ga.CompanyID = p_CompanyID 
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.AccountID IS NULL 
			AND ga.AccountName <> ''
			AND ga.AccountIP <> ''
			AND ga.IsVendor IS NULL
			AND aa.AccountID IS NULL
		GROUP BY ga.CompanyID,ga.CompanyGatewayID,a.AccountID,ga.AccountName,ga.ServiceID;
	
		/* insert vendor ips */
		INSERT IGNORE INTO Ratemanagement3.tblAccountAuthenticate (
			CompanyID,
			AccountID,
			VendorAuthRule,
			VendorAuthValue,
			ServiceID
		)
		SELECT 
			ga.CompanyID,
			a.AccountID,
			'IP',
			GROUP_CONCAT(ga.AccountIP),
			ga.ServiceID
		FROM tblGatewayAccount ga
		INNER JOIN Ratemanagement3.tblAccount a 
			ON a.AccountName = ga.AccountName
			AND a.CompanyId = p_CompanyID
			AND a.AccountType = 1
			AND a.`Status` = 1
		LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
			ON a.AccountID = aa.AccountID
		WHERE  ga.CompanyID = p_CompanyID 
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.AccountID IS NULL 
			AND ga.AccountName <> ''
			AND ga.AccountIP <> ''
			AND ga.IsVendor = 1
			AND aa.AccountID IS NULL
		GROUP BY ga.CompanyID,ga.CompanyGatewayID,a.AccountID,ga.AccountName,ga.ServiceID;

	END IF;

END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getMissingAccounts`;
DELIMITER |
CREATE PROCEDURE `prc_getMissingAccounts`(
	IN `p_CompanyID` int,
	IN `p_CompanyGatewayID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT 
		cg.Title,
		CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.NameFormat'),'"','') = 'NUB'
		THEN
			ga.AccountNumber
		ELSE
			CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.NameFormat'),'"','') = 'IP'
			THEN
				ga.AccountIP
			ELSE
				CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.NameFormat'),'"','') = 'CLI'
				THEN
					ga.AccountCLI
				ELSE 
					ga.AccountName
				END
			END
		END
		AS AccountName
	FROM tblGatewayAccount ga
	INNER JOIN Ratemanagement3.tblCompanyGateway cg ON ga.CompanyGatewayID = cg.CompanyGatewayID
	WHERE ga.GatewayAccountID IS NOT NULL and ga.CompanyID =p_CompanyID AND ga.AccountID IS NULL AND cg.`Status` =1
	AND (p_CompanyGatewayID = 0 OR ga.CompanyGatewayID = p_CompanyGatewayID )
	AND ga.AccountIP IS NOT NULL AND ga.AccountName IS NOT NULL
	ORDER BY ga.CompanyGatewayID,ga.AccountName;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ProcesssCDR`;
DELIMITER |
CREATE PROCEDURE `prc_ProcesssCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_OutboundTableID` INT,
	IN `p_InboundTableID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	/* update service against cli or ip */
	CALL prc_autoAddIP(p_CompanyID,p_CompanyGatewayID);
	CALL prc_ProcessCDRService(p_CompanyID,p_processId,p_tbltempusagedetail_name);

	/* check service enable at gateway*/
	DROP TEMPORARY TABLE IF EXISTS tmp_Service_;
	CREATE TEMPORARY TABLE tmp_Service_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		ServiceID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_Service_ (ServiceID)
	SELECT DISTINCT ServiceID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND ServiceID > 0;
	');
	
	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;
	
	SET @stm = CONCAT('
	INSERT INTO tmp_Service_ (ServiceID)
	SELECT DISTINCT tblService.ServiceID 
	FROM Ratemanagement3.tblService 
	LEFT JOIN  RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	ON tblService.ServiceID = ud.ServiceID AND ProcessID="' , p_processId , '"
	WHERE tblService.ServiceID > 0 AND tblService.CompanyID = "' , p_CompanyID , '" AND tblService.CompanyGatewayID > 0 AND ud.ServiceID IS NULL
	');
	
	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	/* update account and add new accounts and apply authentication rule*/
	CALL prc_ProcessCDRAccount(p_CompanyID,p_CompanyGatewayID,p_processId,p_tbltempusagedetail_name,p_NameFormat);

	IF ( ( SELECT COUNT(*) FROM tmp_Service_ ) > 0 OR p_OutboundTableID > 0)
	THEN

		/* rerate cdr service base */
		CALL prc_RerateOutboundService(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate,p_OutboundTableID);

	ELSE

		/* rerate cdr trunk base */
		CALL prc_RerateOutboundTrunk(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate);
	
	END IF;

	/* if rerate is off and acconts and trunks not setup update prefix from default codedeck*/
	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN 
		/* temp accounts and trunks*/
		DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
		CREATE TEMPORARY TABLE tmp_Accounts_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_Accounts_(AccountID)
		SELECT DISTINCT AccountID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

		/* get default code */
		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);

		/* update prefix from default codes 
		 if rate format is prefix base not charge code*/
		CALL prc_updateDefaultPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;

	/* inbound rerate process*/
	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate,p_InboundTableID);
	
	/* generate rerate error log*/
	CALL prc_CreateRerateLog(p_processId,p_tbltempusagedetail_name,p_RateCDR);
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CreateRerateLog`;
DELIMITER |
CREATE PROCEDURE `prc_CreateRerateLog`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT
)
BEGIN

	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( " Account Name : ( " , ga.AccountName ," ) Number ( " , ga.AccountNumber ," ) IP  ( " , ga.AccountIP ," ) CLI  ( " , ga.AccountCLI," ) - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga 
		ON  ga.AccountName = ud.AccountName
		AND ga.AccountNumber = ud.AccountNumber
		AND ga.AccountCLI = ud.AccountCLI
		AND ga.AccountIP = ud.AccountIP
		AND ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.ServiceID = ud.ServiceID
	INNER JOIN Ratemanagement3.tblCompanyGateway cg ON cg.CompanyGatewayID = ud.CompanyGatewayID
	WHERE ud.ProcessID = "' , p_processid  , '" and ud.AccountID IS NULL');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF p_RateCDR = 1
	THEN
	
		IF ( SELECT COUNT(*) FROM tmp_Service_ ) > 0
		THEN
		
			SET @stm = CONCAT('
			INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
			SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Service: ",IFNULL(s.ServiceName,"")," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
			FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
			INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
			LEFT JOIN Ratemanagement3.tblService s on  s.ServiceID = ud.ServiceID
			WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
	
			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		
		ELSE

			SET @stm = CONCAT('
			INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
			SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
			FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
			INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
			WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
	
			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		
		END IF;

		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,3,  CONCAT( "Account:  " , a.AccountName ,  " - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 1 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @stm = CONCAT('
		INSERT INTO Ratemanagement3.tblTempRateLog (CompanyID,CompanyGatewayID,MessageType,Message,RateDate,SentStatus,created_at)
		SELECT rt.CompanyID,rt.CompanyGatewayID,rt.MessageType,rt.Message,rt.RateDate,0 as SentStatus,NOW() as created_at FROM tmp_tblTempRateLog_ rt
		LEFT JOIN Ratemanagement3.tblTempRateLog rt2 
			ON rt.CompanyID = rt2.CompanyID
			AND rt.CompanyGatewayID = rt2.CompanyGatewayID
			AND rt.MessageType = rt2.MessageType
			AND rt.Message = rt2.Message
			AND rt.RateDate = rt2.RateDate
		WHERE rt2.TempRateLogID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	SELECT DISTINCT Message FROM tmp_tblTempRateLog_;

END|
DELIMITER ;

UPDATE tblInvoice INNER JOIN tblInvoiceDetail ON tblInvoice.InvoiceID =tblInvoiceDetail.InvoiceID 
SET ProductType = 5
WHERE ProductType IS NULL   AND InvoiceType =2;

DROP PROCEDURE IF EXISTS `prc_ProcessCDRAccount`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_ProcessCDRAccount`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_NameFormat` VARCHAR(50)
)
BEGIN

	DECLARE v_NewAccountIDCount_ INT;
	
	/* insert new account */
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName,AccountNumber,AccountCLI,AccountIP,ServiceID)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.AccountName,
		ud.AccountNumber,
		ud.AccountCLI,
		ud.AccountIP,
		ud.ServiceID
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	LEFT JOIN tblGatewayAccount ga
		ON  ga.AccountName = ud.AccountName
		AND ga.AccountNumber = ud.AccountNumber
		AND ga.AccountCLI = ud.AccountCLI
		AND ga.AccountIP = ud.AccountIP
		AND ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.ServiceID = ud.ServiceID
	WHERE ProcessID =  "' , p_processId , '"
		AND ga.GatewayAccountID IS NULL
		AND ud.GatewayAccountID IS NOT NULL;
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	/* update cdr account */
	SET @stm = CONCAT('
	UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.AccountName = uh.AccountName
		AND ga.AccountNumber = uh.AccountNumber
		AND ga.AccountCLI = uh.AccountCLI
		AND ga.AccountIP = uh.AccountIP
		AND ga.ServiceID = uh.ServiceID
	SET uh.GatewayAccountPKID = ga.GatewayAccountPKID
	WHERE uh.CompanyID = ' ,  p_CompanyID , '
	AND uh.ProcessID = "' , p_processId , '" ;
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* active new account */
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,p_NameFormat);
	
	

	/* update cdr account */
	SET @stm = CONCAT('
	UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.AccountName = uh.AccountName
		AND ga.AccountNumber = uh.AccountNumber
		AND ga.AccountCLI = uh.AccountCLI
		AND ga.AccountIP = uh.AccountIP
		AND ga.ServiceID = uh.ServiceID
	SET uh.AccountID = ga.AccountID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = ' ,  p_CompanyID , '
	AND uh.ProcessID = "' , p_processId , '" ;
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT COUNT(*) INTO v_NewAccountIDCount_ 
	FROM RMCDR3.tblUsageHeader uh
	INNER JOIN tblGatewayAccount ga
		ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = p_CompanyID
	AND uh.CompanyGatewayID = p_CompanyGatewayID;

	IF v_NewAccountIDCount_ > 0
	THEN

		/* update header cdr account */
		UPDATE RMCDR3.tblUsageHeader uh
		INNER JOIN tblGatewayAccount ga
			ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;
		
		UPDATE RMCDR3.tblCallDetail uh
		INNER JOIN tblGatewayAccount ga
			ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyGatewayID = p_CompanyGatewayID;
		
		UPDATE RMCDR3.tblCallDetail uh
		INNER JOIN tblGatewayAccount ga
			ON  uh.GatewayVAccountPKID = ga.GatewayAccountPKID
		SET uh.VAccountID = ga.AccountID
		WHERE uh.VAccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyGatewayID = p_CompanyGatewayID;
		

	END IF;

END|
DELIMITER ;

USE `RMCDR3`;

CREATE TABLE IF NOT EXISTS `tblUCall` (
  `UID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UUID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UID`),
  KEY `UUID` (`UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP PROCEDURE IF EXISTS `prc_UniqueIDCallID`;
DELIMITER |
CREATE PROCEDURE `prc_UniqueIDCallID`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_ProcessID` VARCHAR(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @stm1 = CONCAT('
	INSERT INTO tblUCall (UUID)
	SELECT DISTINCT tud.UUID FROM  `' , p_tbltempusagedetail_name , '` tud
	LEFT JOIN tblUCall ON tud.UUID = tblUCall.UUID
	WHERE UID IS NULL
	AND  tblUCall.UUID IS NOT NULL
	AND  tud.CompanyID = "' , p_CompanyID , '"
	AND  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');

	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

	SET @stm2 = CONCAT('
	UPDATE `' , p_tbltempusagedetail_name , '` tud
	INNER JOIN tblUCall ON tud.UUID = tblUCall.UUID
	SET  tud.ID = tblUCall.UID
	WHERE tud.CompanyID = "' , p_CompanyID , '"
	AND  tblUCall.UUID IS NOT NULL
	AND  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END|
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblCallDetail` (
  `CallDetailID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `GCID` bigint(20) unsigned DEFAULT NULL,
  `CID` bigint(20) DEFAULT NULL,
  `VCID` bigint(20) DEFAULT NULL,
  `UsageHeaderID` int(11) DEFAULT NULL,
  `VendorCDRHeaderID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountPKID` int(11) DEFAULT NULL,
  `GatewayVAccountPKID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `VAccountID` int(11) DEFAULT NULL,
  `FailCall` tinyint(4) DEFAULT NULL,
  `FailCallV` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`CallDetailID`),
  KEY `IX_GCID` (`GCID`),
  KEY `IX_CID` (`CID`),
  KEY `IX_VCID` (`VCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP PROCEDURE IF EXISTS `prc_linkCDR`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_linkCDR`(
	IN `p_ProcessID` INT,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	SET @stmt = CONCAT('
	INSERT INTO   tblTempCallDetail_1_',p_UniqueID,' (
		GCID1,
		CID,
		UsageHeaderID,
		CompanyGatewayID1,
		GatewayAccountPKID,
		AccountID,
		FailCall,
		ProcessID
	)
	SELECT 
		ID,
		UsageDetailID,
		tblUsageDetails.UsageHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		AccountID,
		1,
		ProcessID
	FROM tblUsageDetails
	INNER JOIN tblUsageHeader
		ON  tblUsageDetails.UsageHeaderID = tblUsageHeader.UsageHeaderID
	WHERE ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblTempCallDetail_1_',p_UniqueID,' (
		GCID1,
		CID,
		UsageHeaderID,
		CompanyGatewayID1,
		GatewayAccountPKID,
		AccountID,
		FailCall,
		ProcessID
	)
	SELECT 
		ID,
		UsageDetailFailedCallID,
		tblUsageDetailFailedCall.UsageHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		AccountID,
		2,
		ProcessID
	FROM tblUsageDetailFailedCall
	INNER JOIN tblUsageHeader
		ON  tblUsageDetailFailedCall.UsageHeaderID = tblUsageHeader.UsageHeaderID
	WHERE ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblTempCallDetail_2_',p_UniqueID,' (
		GCID2,
		VCID,
		VendorCDRHeaderID,
		CompanyGatewayID2,
		GatewayVAccountPKID,
		VAccountID,
		FailCallV,
		ProcessID
	)
	SELECT 
		ID,
		VendorCDRID,
		tblVendorCDR.VendorCDRHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		AccountID,
		1,
		ProcessID
	FROM tblVendorCDR
	INNER JOIN tblVendorCDRHeader
		ON  tblVendorCDR.VendorCDRHeaderID = tblVendorCDRHeader.VendorCDRHeaderID
	WHERE ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblTempCallDetail_2_',p_UniqueID,' (
		GCID2,
		VCID,
		VendorCDRHeaderID,
		CompanyGatewayID2,
		GatewayVAccountPKID,
		VAccountID,
		FailCallV,
		ProcessID
	)
	SELECT 
		ID,
		VendorCDRFailedID,
		tblVendorCDRFailed.VendorCDRHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		AccountID,
		2,
		ProcessID
	FROM tblVendorCDRFailed
	INNER JOIN tblVendorCDRHeader
		ON  tblVendorCDRFailed.VendorCDRHeaderID = tblVendorCDRHeader.VendorCDRHeaderID
	WHERE ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblCallDetail (
		GCID,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	)
	SELECT 
		c.GCID1,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		c.CompanyGatewayID1,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	FROM tblTempCallDetail_1_',p_UniqueID,' c
	INNER JOIN tblTempCallDetail_2_',p_UniqueID,' v
		ON c.GCID1 = v.GCID2
		AND c.CompanyGatewayID1 = v.CompanyGatewayID2
		AND c.ProcessID = v.ProcessID
	WHERE c.ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblCallDetail (
		GCID,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	)
	SELECT 
		c.GCID1,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		c.CompanyGatewayID1,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	FROM tblTempCallDetail_1_',p_UniqueID,' c
	LEFT JOIN tblTempCallDetail_2_',p_UniqueID,' v
		ON c.GCID1 = v.GCID2
		AND c.CompanyGatewayID1 = v.CompanyGatewayID2
		AND c.ProcessID = v.ProcessID
	WHERE c.ProcessID = "' , p_ProcessID , '"
		AND v.VCID IS NULL;
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	INSERT INTO   tblCallDetail (
		GCID,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		CompanyGatewayID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	)
	SELECT 
		v.GCID2,
		CID,
		VCID,
		UsageHeaderID,
		VendorCDRHeaderID,
		v.CompanyGatewayID2,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		FailCall,
		FailCallV
	FROM tblTempCallDetail_2_',p_UniqueID,' v
	LEFT JOIN tblTempCallDetail_1_',p_UniqueID,' c
		ON c.GCID1 = v.GCID2
		AND c.CompanyGatewayID1 = v.CompanyGatewayID2
		AND c.ProcessID = v.ProcessID
	WHERE v.ProcessID = "' , p_ProcessID , '"
		AND c.CID IS NULL;
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

USE `StagingReport`;

DROP PROCEDURE IF EXISTS `prc_getDailyReport`;
DELIMITER |
CREATE PROCEDURE `prc_getDailyReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	SET sql_mode = 'ALLOW_INVALID_DATES';
	SET @PreviosBalance := 0;
	SET @TotalPreviosBalance := 0;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	IF p_StartDate <> '0000-00-00'
	THEN

	SET @PreviosBalance := 
	(SELECT 
		COALESCE(SUM(Amount),0)
	FROM RMBilling3.tblPayment 
	WHERE CompanyID = p_CompanyID
		AND AccountID = p_AccountID
		AND Status = 'Approved'
		AND Recall =0
		AND PaymentType = 'Payment In'
		AND PaymentDate < p_StartDate) - 
		
		(SELECT 
		COALESCE(SUM(TotalCharges),0)
	FROM tblHeader
	INNER JOIN tblDimDate 
		ON tblDimDate.DateID = tblHeader.DateID
	WHERE CompanyID = p_CompanyID
		AND AccountID = p_AccountID
		AND date < p_StartDate);
	
	SET @TotalPreviosBalance := @PreviosBalance;

	END IF;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_dates_;
	CREATE TEMPORARY TABLE tmp_dates_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		Dates Date,
		UNIQUE INDEX `date` (`Dates`)
	);
	INSERT INTO tmp_dates_ (Dates)
	SELECT 
		DISTINCT DATE(PaymentDate) 
	FROM RMBilling3.tblPayment 
	WHERE CompanyID = p_CompanyID
		AND AccountID = p_AccountID
		AND Status = 'Approved'
		AND Recall =0
		AND PaymentType = 'Payment In'
		AND (p_StartDate = '0000-00-00' OR ( p_StartDate != '0000-00-00' AND PaymentDate >= p_StartDate) )
		AND (p_EndDate = '0000-00-00' OR ( p_EndDate != '0000-00-00' AND PaymentDate <= p_EndDate));

	INSERT IGNORE INTO tmp_dates_ (Dates)
	SELECT 
		DISTINCT date 
	FROM tblHeader
	INNER JOIN tblDimDate 
		ON tblDimDate.DateID = tblHeader.DateID
	WHERE CompanyID = p_CompanyID
		AND AccountID = p_AccountID
		AND (p_StartDate = '0000-00-00' OR ( p_StartDate != '0000-00-00' AND date >= p_StartDate) )
		AND (p_EndDate = '0000-00-00' OR ( p_EndDate != '0000-00-00' AND date <= p_EndDate));

	IF p_isExport = 0
	THEN

		SELECT 
			Dates,
			ROUND(SUM(Amount),v_Round_),
			ROUND(SUM(TotalCharges),v_Round_),
			ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_),
			@PreviosBalance:= ROUND(@PreviosBalance,v_Round_)+ ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_) AS Balance 
		FROM tmp_dates_
		LEFT JOIN RMBilling3.tblPayment 
			ON date(PaymentDate) = Dates 
			AND tblPayment.AccountID = p_AccountID
			AND Status = 'Approved'
			AND Recall =0
			AND PaymentType = 'Payment In'
		LEFT JOIN tblDimDate 
			ON date = Dates
		LEFT JOIN tblHeader 
			ON tblDimDate.DateID = tblHeader.DateID 
			AND tblHeader.AccountID = p_AccountID
		GROUP BY Dates 
		ORDER BY Dates DESC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(DISTINCT Dates) AS totalcount,
			ROUND(COALESCE(SUM(Amount),0),v_Round_) AS TotalPayment,
			ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) AS TotalCharge,
			ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_) AS Total,
			ROUND(@TotalPreviosBalance,v_Round_)+ ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_) AS Balance 
		FROM tmp_dates_
		LEFT JOIN RMBilling3.tblPayment 
			ON date(PaymentDate) = Dates 
			AND tblPayment.AccountID = p_AccountID
			AND Status = 'Approved'
			AND Recall =0
			AND PaymentType = 'Payment In'
		LEFT JOIN tblDimDate 
			ON date = Dates
		LEFT JOIN tblHeader 
			ON tblDimDate.DateID = tblHeader.DateID 
			AND tblHeader.AccountID = p_AccountID;

	END IF;

	IF p_isExport = 1
	THEN

		SELECT 
			Dates AS `Date`,
			ROUND(SUM(Amount),v_Round_) AS `Payments`,
			ROUND(SUM(TotalCharges),v_Round_) AS `Consumption`,
			ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_) AS `Total`,
			@PreviosBalance:= ROUND(@PreviosBalance,v_Round_)+ ROUND(COALESCE(SUM(Amount),0)-COALESCE(SUM(TotalCharges),0),v_Round_) AS `Balance`
		FROM tmp_dates_
		LEFT JOIN RMBilling3.tblPayment 
			ON date(PaymentDate) = Dates 
			AND tblPayment.AccountID = p_AccountID
			AND Status = 'Approved'
			AND Recall =0
			AND PaymentType = 'Payment In'
		LEFT JOIN tblDimDate 
			ON date = Dates
		LEFT JOIN tblHeader 
			ON tblDimDate.DateID = tblHeader.DateID 
			AND tblHeader.AccountID = p_AccountID
		GROUP BY Dates
		ORDER BY Dates DESC;

	END IF;

END|
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblRRate` (
  `RRateID` int(11) NOT NULL auto_increment,
  `CountryID` int(11) NULL,
  `CompanyID` int(11) NULL,
  `Code` varchar(50) NOT NULL,
  PRIMARY KEY (`RRateID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblReport` (
  `ReportID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CompanyID` INT(11) NULL DEFAULT NULL,
  `Name` VARCHAR(50) NULL DEFAULT NULL COLLATE utf8_unicode_ci,
  `Settings` LONGTEXT NULL COLLATE utf8_unicode_ci,
  `Type` TINYINT(4) NULL DEFAULT '0',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE utf8_unicode_ci,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE utf8_unicode_ci,
  PRIMARY KEY (`ReportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblRTrunk` (
  `RTrunkID` int(11) NOT NULL auto_increment,
  `Trunk` varchar(50) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`RTrunkID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblUsageSummaryDay` (
  `UsageSummaryDayID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderID` bigint(20) unsigned NOT NULL,
  `TotalCharges` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `VAccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`UsageSummaryDayID`),
  KEY `FK_tblUsageSummaryNew_dim_date`(`HeaderID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblUsageSummaryDayLive` (
  `UsageSummaryDayLiveID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderID` bigint(20) unsigned NOT NULL,
  `TotalCharges` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `VAccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`UsageSummaryDayLiveID`),
  KEY `FK_tblUsageSummaryNew_dim_date`(`HeaderID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblUsageSummaryHour` (
  `UsageSummaryHourID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderID` bigint(20) unsigned NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `VAccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`UsageSummaryHourID`),
  KEY `FK_tblUsageSummaryDetailNew_dim_time`(`TimeID`),
  KEY `FK_tblUsageSummaryDetailNew_tblSummaryHeader`(`HeaderID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblUsageSummaryHourLive` (
  `UsageSummaryHourLiveID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderID` bigint(20) unsigned NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `VAccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`UsageSummaryHourLiveID`),
  KEY `FK_tblUsageSummaryDetailNew_dim_time`(`TimeID`),
  KEY `FK_tblUsageSummaryDetailNew_tblSummaryHeader`(`HeaderID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblVendorSummaryDay` (
  `VendorSummaryDayID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderVID` bigint(20) unsigned NOT NULL,
  `TotalCharges` double NULL,
  `TotalSales` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `AccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`VendorSummaryDayID`),
  KEY `FK_tblVendorSummaryNew_dim_date`(`HeaderVID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblVendorSummaryDayLive` (
  `VendorSummaryDayLiveID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderVID` bigint(20) unsigned NOT NULL,
  `TotalCharges` double NULL,
  `TotalSales` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `AccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`VendorSummaryDayLiveID`),
  KEY `FK_tblVendorSummaryNew_dim_date`(`HeaderVID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblVendorSummaryHour` (
  `VendorSummaryHourID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderVID` bigint(20) unsigned NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double NULL,
  `TotalSales` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `AccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`VendorSummaryHourID`),
  KEY `FK_tblVendorSummaryDetailNew_dim_time`(`TimeID`),
  KEY `FK_tblVendorSummaryDetailNew_tblSummaryHeader`(`HeaderVID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblVendorSummaryHourLive` (
  `VendorSummaryHourLiveID` bigint(20) unsigned NOT NULL auto_increment,
  `HeaderVID` bigint(20) unsigned NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double NULL,
  `TotalSales` double NULL,
  `TotalBilledDuration` int(11) NULL,
  `TotalDuration` int(11) NULL,
  `NoOfCalls` int(11) NULL,
  `NoOfFailCalls` int(11) NULL,
  `CompanyGatewayID` int(11) NULL,
  `ServiceID` int(11) NULL,
  `GatewayAccountPKID` int(11) NULL,
  `GatewayVAccountPKID` int(11) NULL,
  `AccountID` int(11) NULL,
  `Trunk` varchar(50) NULL,
  `AreaPrefix` varchar(100) NULL,
  `CountryID` int(11) NULL,
  PRIMARY KEY (`VendorSummaryHourLiveID`),
  KEY `FK_tblVendorSummaryDetailNew_dim_time`(`TimeID`),
  KEY `FK_tblVendorSummaryDetailNew_tblSummaryHeader`(`HeaderVID`)
) ENGINE=InnoDB;

ALTER TABLE `tmp_SummaryHeader`
	CHANGE COLUMN `SummaryHeaderID` `HeaderID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
	DROP COLUMN `GatewayAccountID`,
	DROP COLUMN `CompanyGatewayID`,
	DROP COLUMN `Trunk`,
	DROP COLUMN `AreaPrefix`,
	DROP COLUMN `CountryID`,
	DROP COLUMN `created_at`,
	DROP COLUMN `ServiceID`;

CREATE INDEX `SH1_Unique_key` ON `tmp_SummaryHeader`(`DateID`, `CompanyID`, `AccountID`);

ALTER TABLE `tmp_SummaryHeaderLive`
	CHANGE COLUMN `SummaryHeaderID` `HeaderID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
	DROP COLUMN `GatewayAccountID`,
	DROP COLUMN `CompanyGatewayID`,
	DROP COLUMN `Trunk`,
	DROP COLUMN `AreaPrefix`,
	DROP COLUMN `CountryID`,
	DROP COLUMN `created_at`,
	DROP COLUMN `ServiceID`;

CREATE INDEX `SH2_Unique_key` ON `tmp_SummaryHeaderLive`(`DateID`, `CompanyID`, `AccountID`);

ALTER TABLE `tmp_SummaryVendorHeader`
	CHANGE COLUMN `SummaryVendorHeaderID` `HeaderVID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `AccountID` `VAccountID` INT(11) NULL DEFAULT NULL AFTER `CompanyID`,
	DROP COLUMN `GatewayAccountID`,
	DROP COLUMN `CompanyGatewayID`,
	DROP COLUMN `Trunk`,
	DROP COLUMN `AreaPrefix`,
	DROP COLUMN `CountryID`,
	DROP COLUMN `created_at`,
	DROP COLUMN `ServiceID`;
	
CREATE INDEX `SH3_Unique_key` ON `tmp_SummaryVendorHeader`(`DateID`, `CompanyID`, `VAccountID`);


ALTER TABLE `tmp_SummaryVendorHeaderLive`
	CHANGE COLUMN `SummaryVendorHeaderID` `HeaderVID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `AccountID` `VAccountID` INT(11) NULL DEFAULT NULL AFTER `CompanyID`,
	DROP COLUMN `GatewayAccountID`,
	DROP COLUMN `CompanyGatewayID`,
	DROP COLUMN `Trunk`,
	DROP COLUMN `AreaPrefix`,
	DROP COLUMN `CountryID`,
	DROP COLUMN `created_at`,
	DROP COLUMN `ServiceID`;
	
CREATE INDEX `SH4_Unique_key` ON `tmp_SummaryVendorHeaderLive`(`DateID`, `CompanyID`, `VAccountID`);

DROP INDEX `Unique_key` ON `tmp_UsageSummary`;

ALTER TABLE `tmp_UsageSummary`
  DROP COLUMN `GatewayAccountID`
  , ADD COLUMN `GatewayAccountPKID` int(11) NULL
  , ADD COLUMN `GatewayVAccountPKID` int(11) NULL
  , ADD COLUMN `VAccountID` int(11) NULL;

CREATE INDEX `Unique_key` ON `tmp_UsageSummary`(`DateID`, `CompanyID`, `AccountID`);

ALTER TABLE `tmp_UsageSummaryLive`
  DROP COLUMN `GatewayAccountID`
  , ADD COLUMN `GatewayAccountPKID` int(11) NULL
  , ADD COLUMN `GatewayVAccountPKID` int(11) NULL
  , ADD COLUMN `VAccountID` int(11) NULL;

DROP INDEX `Unique_key` ON `tmp_UsageSummaryLive`;

CREATE INDEX `Unique_key` ON `tmp_UsageSummaryLive`(`DateID`, `CompanyID`, `AccountID`);

DROP INDEX `Unique_key` ON `tmp_VendorUsageSummary`;

ALTER TABLE `tmp_VendorUsageSummary`
  DROP COLUMN `GatewayAccountID`
  , MODIFY COLUMN `AccountID` int(11) NULL
  , ADD COLUMN `GatewayAccountPKID` int(11) NULL
  , ADD COLUMN `GatewayVAccountPKID` int(11) NULL
  , ADD COLUMN `VAccountID` int(11) NOT NULL;

CREATE INDEX `Unique_key` ON `tmp_VendorUsageSummary`(`DateID`, `CompanyID`, `VAccountID`);

DROP INDEX `Unique_key` ON `tmp_VendorUsageSummaryLive`;

ALTER TABLE `tmp_VendorUsageSummaryLive`
  DROP COLUMN `GatewayAccountID`
  , MODIFY COLUMN `AccountID` int(11) NULL
  , ADD COLUMN `GatewayAccountPKID` int(11) NULL
  , ADD COLUMN `GatewayVAccountPKID` int(11) NULL
  , ADD COLUMN `VAccountID` int(11) NOT NULL;

CREATE INDEX `Unique_key` ON `tmp_VendorUsageSummaryLive`(`DateID`, `CompanyID`, `AccountID`);

ALTER TABLE `tmp_tblUsageDetailsReport`
  MODIFY COLUMN `UsageDetailID` int(11) NULL
  , MODIFY COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblUsageDetailsReportLive`
  MODIFY COLUMN `UsageDetailID` int(11) NULL
  , MODIFY COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblVendorUsageDetailsReport`
  MODIFY COLUMN `VendorCDRID` int(11) NULL
  , MODIFY COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblVendorUsageDetailsReportLive`
  MODIFY COLUMN `VendorCDRID` int(11) NULL
  , MODIFY COLUMN `ServiceID` int(11) NULL DEFAULT '0';

  
DROP PROCEDURE IF EXISTS `fnDistinctList`;
  
DELIMITER |
CREATE PROCEDURE `fnDistinctList`(
	IN `p_CompanyID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	INSERT INTO tblRRate(Code,CompanyID,CountryID)
	SELECT tbl.AreaPrefix,tbl.CompanyID,tbl.CountryID FROM (SELECT DISTINCT AreaPrefix,CountryID,CompanyID FROM tmp_UsageSummary)tbl
	LEFT JOIN tblRRate
		ON	tbl.AreaPrefix = tblRRate.Code
		AND tbl.CompanyID = tblRRate.CompanyID
	WHERE tblRRate.CompanyID = p_CompanyID
	AND tbl.AreaPrefix IS NULL;
	
	INSERT INTO tblRTrunk(Trunk,CompanyID)
	SELECT tbl.Trunk,tbl.CompanyID FROM (SELECT DISTINCT Trunk,CompanyID FROM tmp_UsageSummary)tbl
	LEFT JOIN tblRTrunk
		ON	tbl.Trunk = tblRTrunk.Trunk
		AND tbl.CompanyID = tblRTrunk.CompanyID
	WHERE tblRTrunk.CompanyID = p_CompanyID
	AND tbl.Trunk IS NULL;
	
	INSERT INTO tblRRate(Code,CompanyID,CountryID)
	SELECT tbl.AreaPrefix,tbl.CompanyID,tbl.CountryID FROM (SELECT DISTINCT AreaPrefix,CountryID,CompanyID FROM tmp_VendorUsageSummary)tbl
	LEFT JOIN tblRRate
		ON	tbl.AreaPrefix = tblRRate.Code
		AND tbl.CompanyID = tblRRate.CompanyID
	WHERE tblRRate.CompanyID = p_CompanyID
	AND tbl.AreaPrefix IS NULL;
	
	INSERT INTO tblRTrunk(Trunk,CompanyID)
	SELECT tbl.Trunk,tbl.CompanyID FROM (SELECT DISTINCT Trunk,CompanyID FROM tmp_VendorUsageSummary)tbl
	LEFT JOIN tblRTrunk
		ON	tbl.Trunk = tblRTrunk.Trunk
		AND tbl.CompanyID = tblRTrunk.CompanyID
	WHERE tblRTrunk.CompanyID = p_CompanyID
	AND tbl.Trunk IS NULL;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetUsageForSummary`;

DELIMITER |
CREATE PROCEDURE `fnGetUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET @stmt = CONCAT('
	INSERT IGNORE INTO tmp_tblUsageDetailsReport_' , p_UniqueID , ' (
		UsageDetailID,
		AccountID,
		CompanyID,
		CompanyGatewayID,
		GatewayAccountPKID,
		connect_time,
		connect_date,
		billed_duration,
		area_prefix,
		cost,
		duration,
		trunk,
		call_status,
		ServiceID,
		disposition,
		userfield,
		pincode,
		extension
	)
	SELECT 
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountPKID,
		CONCAT(DATE_FORMAT(ud.connect_time,"%H"),":",IF(MINUTE(ud.connect_time)<30,"00","30"),":00"),
		DATE_FORMAT(ud.connect_time,"%Y-%m-%d"),
		billed_duration,
		area_prefix,
		cost,
		duration,
		trunk,
		1 as call_status,
		uh.ServiceID,
		disposition,
		userfield,
		pincode,
		extension
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	SET @stmt = CONCAT('
	INSERT IGNORE INTO tmp_tblUsageDetailsReport_' , p_UniqueID , ' (
		UsageDetailID,
		AccountID,
		CompanyID,
		CompanyGatewayID,
		GatewayAccountPKID,
		connect_time,
		connect_date,
		billed_duration,
		area_prefix,
		cost,
		duration,
		trunk,
		call_status,
		ServiceID,
		disposition,
		userfield,
		pincode,
		extension
	)
	SELECT 
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountPKID,
		CONCAT(DATE_FORMAT(ud.connect_time,"%H"),":",IF(MINUTE(ud.connect_time)<30,"00","30"),":00"),
		DATE_FORMAT(ud.connect_time,"%Y-%m-%d"),
		billed_duration,
		area_prefix,
		cost,
		duration,
		trunk,
		2 as call_status,
		uh.ServiceID,
		disposition,
		userfield,
		pincode,
		extension
	FROM RMCDR3.tblUsageDetailFailedCall  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummary`;

DELIMITER |
CREATE PROCEDURE `fnGetVendorUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET @stmt = CONCAT('
	INSERT IGNORE INTO tmp_tblVendorUsageDetailsReport_' , p_UniqueID , ' (
		VendorCDRID,
		VAccountID,
		CompanyID,
		CompanyGatewayID,
		GatewayVAccountPKID,
		ServiceID,
		connect_time,
		connect_date,
		billed_duration,
		duration,
		selling_cost,
		buying_cost,
		trunk,
		area_prefix,
		call_status_v		
	)
	SELECT 
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountPKID,
		uh.ServiceID,
		CONCAT(DATE_FORMAT(ud.connect_time,"%H"),":",IF(MINUTE(ud.connect_time)<30,"00","30"),":00"),
		DATE_FORMAT(ud.connect_time,"%Y-%m-%d"),
		billed_duration,
		duration,
		selling_cost,
		buying_cost,
		trunk,
		area_prefix,		
		1 AS call_status
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @stmt = CONCAT('
	INSERT IGNORE INTO tmp_tblVendorUsageDetailsReport_' , p_UniqueID , ' (
		VendorCDRID,
		VAccountID,
		CompanyID,
		CompanyGatewayID,
		GatewayVAccountPKID,
		ServiceID,
		connect_time,
		connect_date,
		billed_duration,
		duration,
		selling_cost,
		buying_cost,
		trunk,
		area_prefix,
		call_status_v		
	)
	SELECT 
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountPKID,
		uh.ServiceID,
		CONCAT(DATE_FORMAT(ud.connect_time,"%H"),":",IF(MINUTE(ud.connect_time)<30,"00","30"),":00"),
		DATE_FORMAT(ud.connect_time,"%Y-%m-%d"),
		billed_duration,
		duration,
		selling_cost,
		buying_cost,
		trunk,
		area_prefix,		
		2 AS call_status
	FROM RMCDR3.tblVendorCDRFailed  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUpdateCustomerLink`;

DELIMITER |
CREATE PROCEDURE `fnUpdateCustomerLink`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET @stmt = CONCAT('
	INSERT IGNORE INTO tblTempCallDetail_1_' , p_UniqueID , '
	SELECT cd.* FROM RMCDR3.tblCallDetail cd
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = cd.UsageHeaderID
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	UPDATE tmp_tblUsageDetailsReport_' , p_UniqueID , ' ud
	INNER JOIN tblTempCallDetail_1_' , p_UniqueID , ' cd on cd.CID = ud.UsageDetailID
	SET ud.VAccountID = cd.VAccountID,ud.GatewayVAccountPKID = cd.GatewayVAccountPKID,ud.call_status_v = cd.FailCallV
	WHERE ud.CompanyID = ' , p_CompanyID , ';
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUpdateVendorLink`;

DELIMITER |
CREATE PROCEDURE `fnUpdateVendorLink`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET @stmt = CONCAT('
	INSERT IGNORE INTO tblTempCallDetail_2_' , p_UniqueID , '
	SELECT cd.* FROM RMCDR3.tblCallDetail cd
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = cd.VendorCDRHeaderID
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stmt = CONCAT('
	UPDATE tmp_tblVendorUsageDetailsReport_' , p_UniqueID , ' ud
	INNER JOIN tblTempCallDetail_2_' , p_UniqueID , ' cd on cd.VCID = ud.VendorCDRID
	SET ud.AccountID = cd.AccountID,ud.GatewayAccountPKID = cd.GatewayAccountPKID,ud.call_status = cd.FailCall
	WHERE ud.CompanyID = ' , p_CompanyID , ';
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageSummary`;

DELIMITER |
CREATE PROCEDURE `fnUsageSummary`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT,
	IN `p_Detail` INT
)
BEGIN
	DECLARE v_TimeId_ INT;

	IF DATEDIFF(p_EndDate,p_StartDate) > 31 AND p_Detail = 2
	THEN
		SET p_Detail = 1;
	END IF;

	IF p_Detail = 1 
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			us.CompanyGatewayID,
			us.Trunk,
			us.AreaPrefix,
			us.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblHeader sh
		INNER JOIN tblUsageSummaryDay  us
			ON us.HeaderID = sh.HeaderID
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR us.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR us.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR us.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR us.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			us.CompanyGatewayID,
			us.Trunk,
			us.AreaPrefix,
			us.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblHeader sh
		INNER JOIN tblUsageSummaryDayLive  us
			ON us.HeaderID = sh.HeaderID
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR us.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR us.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR us.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR us.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

	END IF;

	IF p_Detail = 2
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`TimeID` INT(11) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);

		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			usd.CompanyGatewayID,
			usd.Trunk,
			usd.AreaPrefix,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblHeader sh
		INNER JOIN tblUsageSummaryHour  usd
			ON usd.HeaderID = sh.HeaderID
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR usd.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR usd.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR usd.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR usd.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			usd.CompanyGatewayID,
			usd.Trunk,
			usd.AreaPrefix,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblHeader sh
		INNER JOIN tblUsageSummaryHourLive  usd
			ON usd.HeaderID = sh.HeaderID
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR usd.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR usd.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR usd.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR usd.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

	END IF;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageSummaryDetail`;

DELIMITER |
CREATE PROCEDURE `fnUsageSummaryDetail`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE i INTEGER;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
			`DateID` BIGINT(20) NOT NULL,
			`TimeID` INT(11) NOT NULL,
			`Time` VARCHAR(50) NOT NULL,
			`CompanyID` INT(11) NOT NULL,
			`AccountID` INT(11) NOT NULL,
			`CompanyGatewayID` INT(11) NOT NULL,
			`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`CountryID` INT(11) NULL DEFAULT NULL,
			`TotalCharges` DOUBLE NULL DEFAULT NULL,
			`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
			`TotalDuration` INT(11) NULL DEFAULT NULL,
			`NoOfCalls` INT(11) NULL DEFAULT NULL,
			`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
			`AccountName` varchar(100),
			INDEX `tblUsageSummary_dim_date` (`DateID`)
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AreaPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_AreaPrefix_ (
		`Code` Text NULL DEFAULT NULL
	);

	SET i = 1;
	REPEAT
		INSERT INTO tmp_AreaPrefix_ ( Code)
		SELECT Ratemanagement3.FnStringSplit(p_AreaPrefix, ',', i) FROM tblDimDate WHERE Ratemanagement3.FnStringSplit(p_AreaPrefix, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;

	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		usd.CompanyGatewayID,
		usd.Trunk,
		usd.AreaPrefix,
		usd.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblHeader sh
	INNER JOIN tblUsageSummaryHour  usd
		ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = usd.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON usd.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(usd.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(usd.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		usd.CompanyGatewayID,
		usd.Trunk,
		usd.AreaPrefix,
		usd.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblHeader sh
	INNER JOIN tblUsageSummaryHourLive  usd
		ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = usd.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON (p_AreaPrefix = '' OR usd.AreaPrefix LIKE REPLACE(ap.Code, '*', '%') )
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(usd.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(usd.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageVendorSummary`;

DELIMITER |
CREATE PROCEDURE `fnUsageVendorSummary`(
	IN `p_CompanyID` int ,
	IN `p_CompanyGatewayID` int ,
	IN `p_AccountID` int ,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` datetime ,
	IN `p_EndDate` datetime ,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT,
	IN `p_Detail` INT
)
BEGIN
	DECLARE v_TimeId_ INT;

	IF DATEDIFF(p_EndDate,p_StartDate) > 31 AND p_Detail =2
	THEN
		SET p_Detail = 1;
	END IF;

	IF p_Detail = 1 
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.VAccountID,
			us.CompanyGatewayID,
			us.Trunk,
			us.AreaPrefix,
			us.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblHeaderV sh
		INNER JOIN tblVendorSummaryDay us
			ON us.HeaderVID = sh.HeaderVID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.VAccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.VAccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR us.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR us.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR us.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR us.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.VAccountID,
			us.CompanyGatewayID,
			us.Trunk,
			us.AreaPrefix,
			us.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblHeaderV sh
		INNER JOIN tblVendorSummaryDayLive us
			ON us.HeaderVID = sh.HeaderVID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.VAccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.VAccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR us.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR us.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR us.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR us.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

	END IF;

	IF p_Detail = 2 
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`TimeID` INT(11) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);

		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.VAccountID,
			usd.CompanyGatewayID,
			usd.Trunk,
			usd.AreaPrefix,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblHeaderV sh
		INNER JOIN tblVendorSummaryHour usd
			ON usd.HeaderVID = sh.HeaderVID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.VAccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.VAccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR usd.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR usd.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR usd.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR usd.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.VAccountID,
			usd.CompanyGatewayID,
			usd.Trunk,
			usd.AreaPrefix,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblHeaderV sh
		INNER JOIN tblVendorSummaryHourLive usd
			ON usd.HeaderVID = sh.HeaderVID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.VAccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.VAccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR usd.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR usd.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR usd.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR usd.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);

	END IF;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageVendorSummaryDetail`;

DELIMITER |
CREATE PROCEDURE `fnUsageVendorSummaryDetail`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE i INTEGER;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
		`DateID` BIGINT(20) NOT NULL,
		`TimeID` INT(11) NOT NULL,
		`Time` VARCHAR(50) NOT NULL,
		`CompanyID` INT(11) NOT NULL,
		`AccountID` INT(11) NOT NULL,
		`CompanyGatewayID` INT(11) NOT NULL,
		`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`CountryID` INT(11) NULL DEFAULT NULL,
		`TotalCharges` DOUBLE NULL DEFAULT NULL,
		`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
		`TotalDuration` INT(11) NULL DEFAULT NULL,
		`NoOfCalls` INT(11) NULL DEFAULT NULL,
		`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
		`AccountName` varchar(100),
		INDEX `tblUsageSummary_dim_date` (`DateID`)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_AreaPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_AreaPrefix_ (
		`Code` Text NULL DEFAULT NULL
	);

	SET i = 1;
	REPEAT
		INSERT INTO tmp_AreaPrefix_ ( Code)
		SELECT Ratemanagement3.FnStringSplit(p_AreaPrefix, ',', i) FROM tblDimDate WHERE Ratemanagement3.FnStringSplit(p_AreaPrefix, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;

	INSERT INTO tmp_tblUsageVendorSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.VAccountID,
		usd.CompanyGatewayID,
		usd.Trunk,
		usd.AreaPrefix,
		usd.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblHeaderV sh
	INNER JOIN tblVendorSummaryHour usd
		ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.VAccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = usd.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap
		ON usd.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.VAccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(usd.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(usd.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

	INSERT INTO tmp_tblUsageVendorSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.VAccountID,
		usd.CompanyGatewayID,
		usd.Trunk,
		usd.AreaPrefix,
		usd.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblHeaderV sh
	INNER JOIN tblVendorSummaryHourLive usd
		ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.VAccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = usd.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap
		ON usd.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.VAccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(usd.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(usd.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateSummary`;

DELIMITER |
CREATE PROCEDURE `prc_generateSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateCustomerLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);

	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;

	SET @stmt = CONCAT('
	INSERT INTO tmp_UsageSummary(
		DateID,
		TimeID,
		CompanyID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		Trunk,
		AreaPrefix,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk;
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_UsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummary.CountryID =code.CountryID
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;
	
	DELETE h FROM tblHeader h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeader (
		DateID,
		CompanyID,
		AccountID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		DateID,
		CompanyID,
		AccountID,
		SUM(TotalCharges) as TotalCharges,
		SUM(TotalBilledDuration) as TotalBilledDuration,
		SUM(TotalDuration) as TotalDuration,
		SUM(NoOfCalls) as NoOfCalls,
		SUM(NoOfFailCalls) as NoOfFailCalls
	FROM tmp_UsageSummary 
	WHERE CompanyID = p_CompanyID
	GROUP BY DateID,CompanyID,AccountID;
	
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeader (HeaderID,DateID,CompanyID,AccountID)
	SELECT 
		sh.HeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID
	FROM tblHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummaryDay us 
	INNER JOIN tblHeader sh ON us.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblUsageSummaryHour usd
	INNER JOIN tblHeader sh ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblUsageSummaryDay (
		HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT
		sh.HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalBilledDuration),
		SUM(us.TotalDuration),
		SUM(us.NoOfCalls),
		SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)	 
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.AccountID = sh.AccountID
	WHERE us.CompanyID = p_CompanyID
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderID;
	
	INSERT INTO tblUsageSummaryHour (
		HeaderID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls	
	)
	SELECT 
		sh.HeaderID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		us.TotalCharges,
		us.TotalBilledDuration,
		us.TotalDuration,
		us.NoOfCalls,
		us.NoOfFailCalls
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.AccountID = sh.AccountID
	WHERE us.CompanyID = p_CompanyID;
	
	CALL fnDistinctList(p_CompanyID);

	COMMIT;
	
	SET @stmt = CONCAT('TRUNCATE TABLE tmp_tblUsageDetailsReport_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	SET @stmt = CONCAT('TRUNCATE TABLE tblTempCallDetail_1_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateSummaryLive`;

DELIMITER |
CREATE PROCEDURE `prc_generateSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateCustomerLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);

	DELETE FROM tmp_UsageSummaryLive WHERE CompanyID = p_CompanyID;

	SET @stmt = CONCAT('
	INSERT INTO tmp_UsageSummaryLive(
		DateID,
		TimeID,
		CompanyID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		Trunk,
		AreaPrefix,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk;
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_UsageSummaryLive
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;
	
	DELETE h FROM tblHeader h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeader (
		DateID,
		CompanyID,
		AccountID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		DateID,
		CompanyID,
		AccountID,
		SUM(TotalCharges) as TotalCharges,
		SUM(TotalBilledDuration) as TotalBilledDuration,
		SUM(TotalDuration) as TotalDuration,
		SUM(NoOfCalls) as NoOfCalls,
		SUM(NoOfFailCalls) as NoOfFailCalls
	FROM tmp_UsageSummaryLive 
	WHERE CompanyID = p_CompanyID
	GROUP BY DateID,CompanyID,AccountID;
	
	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeaderLive (HeaderID,DateID,CompanyID,AccountID)
	SELECT 
		sh.HeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID
	FROM tblHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummaryDayLive us 
	INNER JOIN tblHeader sh ON us.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblUsageSummaryHourLive usd
	INNER JOIN tblHeader sh ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblUsageSummaryDayLive (
		HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT
		sh.HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalBilledDuration),
		SUM(us.TotalDuration),
		SUM(us.NoOfCalls),
		SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)	 
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.AccountID = sh.AccountID
	WHERE us.CompanyID = p_CompanyID
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderID;
	
	INSERT INTO tblUsageSummaryHourLive (
		HeaderID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls	
	)
	SELECT 
		sh.HeaderID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		us.TotalCharges,
		us.TotalBilledDuration,
		us.TotalDuration,
		us.NoOfCalls,
		us.NoOfFailCalls
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.AccountID = sh.AccountID
	WHERE us.CompanyID = p_CompanyID;

	COMMIT;	 
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateVendorSummary`;

DELIMITER |
CREATE PROCEDURE `prc_generateVendorSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateVendorLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);

	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;

	SET @stmt = CONCAT('
	INSERT INTO tmp_VendorUsageSummary(
		DateID,
		TimeID,
		CompanyID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		Trunk,
		AreaPrefix,
		TotalCharges,
		TotalSales,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk;	
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_VendorUsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummary.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;
	
	DELETE h FROM tblHeaderV h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeaderV (
		DateID,
		CompanyID,
		VAccountID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		DateID,
		CompanyID,
		VAccountID,
		SUM(TotalCharges) as TotalCharges,
		SUM(TotalBilledDuration) as TotalBilledDuration,
		SUM(TotalDuration) as TotalDuration,
		SUM(NoOfCalls) as NoOfCalls,
		SUM(NoOfFailCalls) as NoOfFailCalls
	FROM tmp_VendorUsageSummary 
	WHERE CompanyID = p_CompanyID
	GROUP BY DateID,CompanyID,VAccountID;
	
	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryVendorHeader (HeaderVID,DateID,CompanyID,VAccountID)
	SELECT 
		sh.HeaderVID,
		sh.DateID,
		sh.CompanyID,
		sh.VAccountID
	FROM tblHeaderV sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblVendorSummaryDay us 
	INNER JOIN tblHeaderV sh ON us.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblVendorSummaryHour usd
	INNER JOIN tblHeaderV sh ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblVendorSummaryDay (
		HeaderVID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT
		sh.HeaderVID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalBilledDuration),
		SUM(us.TotalDuration),
		SUM(us.NoOfCalls),
		SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)	 
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.VAccountID = sh.VAccountID
	WHERE us.CompanyID = p_CompanyID
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderVID;
	
	INSERT INTO tblVendorSummaryHour (
		HeaderVID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls	
	)
	SELECT 
		sh.HeaderVID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		us.TotalCharges,
		us.TotalBilledDuration,
		us.TotalDuration,
		us.NoOfCalls,
		us.NoOfFailCalls
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.VAccountID = sh.VAccountID
	WHERE us.CompanyID = p_CompanyID;

	CALL fnDistinctList(p_CompanyID);

	COMMIT;
	
	SET @stmt = CONCAT('TRUNCATE TABLE tmp_tblVendorUsageDetailsReport_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	SET @stmt = CONCAT('TRUNCATE TABLE tblTempCallDetail_2_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;
	
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateVendorSummaryLive`;

DELIMITER |
CREATE PROCEDURE `prc_generateVendorSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateVendorLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);

	DELETE FROM tmp_VendorUsageSummaryLive WHERE CompanyID = p_CompanyID;

	SET @stmt = CONCAT('
	INSERT INTO tmp_VendorUsageSummaryLive(
		DateID,
		TimeID,
		CompanyID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		VAccountID,
		Trunk,
		AreaPrefix,
		TotalCharges,
		TotalSales,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk;	
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_VendorUsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;
	
	DELETE h FROM tblHeaderV h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeaderV (
		DateID,
		CompanyID,
		VAccountID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		DateID,
		CompanyID,
		VAccountID,
		SUM(TotalCharges) as TotalCharges,
		SUM(TotalBilledDuration) as TotalBilledDuration,
		SUM(TotalDuration) as TotalDuration,
		SUM(NoOfCalls) as NoOfCalls,
		SUM(NoOfFailCalls) as NoOfFailCalls
	FROM tmp_VendorUsageSummaryLive 
	WHERE CompanyID = p_CompanyID
	GROUP BY DateID,CompanyID,VAccountID;
	
	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryVendorHeaderLive (HeaderVID,DateID,CompanyID,VAccountID)
	SELECT 
		sh.HeaderVID,
		sh.DateID,
		sh.CompanyID,
		sh.VAccountID
	FROM tblHeaderV sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblVendorSummaryDayLive us 
	INNER JOIN tblHeaderV sh ON us.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblVendorSummaryHourLive usd
	INNER JOIN tblHeaderV sh ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblVendorSummaryDayLive (
		HeaderVID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT
		sh.HeaderVID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalBilledDuration),
		SUM(us.TotalDuration),
		SUM(us.NoOfCalls),
		SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)	 
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.VAccountID = sh.VAccountID
	WHERE us.CompanyID = p_CompanyID
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderVID;
	
	INSERT INTO tblVendorSummaryHourLive (
		HeaderVID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		TotalCharges,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls	
	)
	SELECT 
		sh.HeaderVID,
		TimeID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		AccountID,
		Trunk,
		AreaPrefix,
		CountryID,
		us.TotalCharges,
		us.TotalBilledDuration,
		us.TotalDuration,
		us.NoOfCalls,
		us.NoOfFailCalls
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)
		ON  us.DateID = sh.DateID
		AND us.CompanyID = sh.CompanyID
		AND us.VAccountID = sh.VAccountID
	WHERE us.CompanyID = p_CompanyID;

	COMMIT;	
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountExpense`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountExpense`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT
)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_DateID_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	SELECT MIN(DateID) INTO v_DateID_ FROM tblDimDate WHERE fnGetMonthDifference(date,NOW()) <= 12;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
		`DateID` BIGINT(20) NOT NULL,
		`CompanyID` INT(11) NOT NULL,
		`AccountID` INT(11) NOT NULL,
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`TotalCharges` DOUBLE NULL DEFAULT NULL,
		`CustomerVendor` INT,
		INDEX `tmp_tblUsageSummary_DateID` (`DateID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary2_(
		`DateID` BIGINT(20) NOT NULL,
		`CompanyID` INT(11) NOT NULL,
		`AccountID` INT(11) NOT NULL,
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`TotalCharges` DOUBLE NULL DEFAULT NULL,
		`CustomerVendor` INT,
		INDEX `tmp_tblUsageSummary_DateID` (`DateID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblCustomerPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblCustomerPrefix_(
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`CustomerTotal` DOUBLE NULL DEFAULT NULL,
		`FinalTotal` DOUBLE NULL DEFAULT NULL,
		`YearMonth` VARCHAR(50) NOT NULL
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblVendorPrefix_(
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`VendorTotal` DOUBLE NULL DEFAULT NULL,
		`FinalTotal` DOUBLE NULL DEFAULT NULL,
		`YearMonth` VARCHAR(50) NOT NULL
	);
	
	/* insert customer summary */
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		us.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblHeader sh
	INNER JOIN tblUsageSummaryDay us
		ON us.HeaderID = sh.HeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		us.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblHeader sh
	INNER JOIN tblUsageSummaryDayLive us
		ON us.HeaderID = sh.HeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	/* insert vendor summary */
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.VAccountID,
		us.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblHeaderV sh
	INNER JOIN tblVendorSummaryDay us
		ON us.HeaderVID = sh.HeaderVID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.VAccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.VAccountID,
		us.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblHeaderV sh
	INNER JOIN tblVendorSummaryDayLive us
		ON us.HeaderVID = sh.HeaderVID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.VAccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary2_
	SELECT * FROM tmp_tblUsageSummary_;
	
	/* customer and vendor chart by month and year */
	SELECT 
		ROUND(SUM(IF(CustomerVendor=1,TotalCharges,0)),v_Round_) AS  CustomerTotal,
		ROUND(SUM(IF(CustomerVendor=2,TotalCharges,0)),v_Round_) AS  VendorTotal,
		dd.year as Year,
		dd.month_of_year as Month
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	GROUP BY dd.year,dd.month_of_year;
	
	/* top 5 customer destination month and year */
	INSERT INTO tmp_tblCustomerPrefix_
	SELECT 
		us.AreaPrefix,
		ROUND(SUM(TotalCharges),2) AS  CustomerTotal,
		FinalTotal,
		CONCAT(dd.year,'-',dd.month_of_year) as YearMonth
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN 
	(SELECT SUM(TotalCharges) as FinalTotal,AreaPrefix FROM tmp_tblUsageSummary2_ WHERE CustomerVendor = 1 AND AreaPrefix != 'other' AND DateID >= v_DateID_ GROUP BY AreaPrefix ORDER BY FinalTotal DESC LIMIT 5 ) tbl
	ON tbl.AreaPrefix = us.AreaPrefix
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	WHERE 
			 us.CustomerVendor = 1 
		AND us.AreaPrefix != 'other'
		AND dd.DateID >= v_DateID_
	GROUP BY dd.year,dd.month_of_year,us.AreaPrefix;
	
	/* convert into pivot table*/
	
	IF (SELECT COUNT(*) FROM tmp_tblCustomerPrefix_) > 0
	THEN
		SET @sql = NULL;
		
		SELECT
			GROUP_CONCAT( DISTINCT CONCAT('MAX(IF(YearMonth = ''',YearMonth,''', CustomerTotal, 0)) AS ''',YearMonth,'''') ) INTO @sql
		FROM tmp_tblCustomerPrefix_;
	
		SET @sql = CONCAT('
							SELECT AreaPrefix , ', @sql, ' 
							FROM tmp_tblCustomerPrefix_ 
							GROUP BY AreaPrefix
							ORDER BY MAX(FinalTotal) desc, MAX(YearMonth)
						');
		
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	ELSE
		SELECT 0 as datacount;
	END IF;

	/* top 5 vendor destination month and year */
	INSERT INTO tmp_tblVendorPrefix_
	SELECT 
		us.AreaPrefix,
		ROUND(SUM(TotalCharges),2) AS  VendorTotal,
		FinalTotal,
		CONCAT(dd.year,'-',dd.month_of_year) as YearMonth
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN 
	(SELECT SUM(TotalCharges) as FinalTotal,AreaPrefix FROM tmp_tblUsageSummary2_ WHERE CustomerVendor = 2 AND AreaPrefix != 'other' AND DateID >= v_DateID_ GROUP BY AreaPrefix ORDER BY FinalTotal DESC LIMIT 5 ) tbl
	ON tbl.AreaPrefix = us.AreaPrefix
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	WHERE 
			 us.CustomerVendor = 2 
		AND us.AreaPrefix != 'other'
		AND dd.DateID >= v_DateID_
	GROUP BY dd.year,dd.month_of_year,us.AreaPrefix;

	/* convert into pivot table*/
	
	IF (SELECT COUNT(*) FROM tmp_tblVendorPrefix_) > 0
	THEN
	
		SET @stm = NULL;
		SELECT
			GROUP_CONCAT( DISTINCT CONCAT('MAX(IF(YearMonth = ''',YearMonth,''', VendorTotal, 0)) AS ''',YearMonth,'''') ) INTO @stm
		FROM tmp_tblVendorPrefix_;

		SET @stm = CONCAT('
							SELECT AreaPrefix , ', @stm, ' 
							FROM tmp_tblVendorPrefix_ 
							GROUP BY AreaPrefix
							ORDER BY MAX(FinalTotal) desc, MAX(YearMonth)
						');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	ELSE
		SELECT 0 as datacount;	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashboardPayableReceivable`;

DELIMITER |
CREATE PROCEDURE `prc_getDashboardPayableReceivable`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Unbilled` INT,
	IN `p_ListType` VARCHAR(50)
)
BEGIN
	DECLARE v_Round_ INT;
	DECLARE prev_TotalInvoiceOut  DECIMAL(18,6);
	DECLARE prev_TotalInvoiceIn DECIMAL(18,6);
	DECLARE prev_TotalPaymentOut DECIMAL(18,6);
	DECLARE prev_TotalPaymentIn DECIMAL(18,6);
	DECLARE prev_CustomerUnbill DECIMAL(18,6);
	DECLARE prev_VendrorUnbill DECIMAL(18,6);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerUnbilled_;
	CREATE TEMPORARY TABLE tmp_CustomerUnbilled_  (
		DateID INT,
		CustomerUnbill DOUBLE
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_VendorUbilled_;
	CREATE TEMPORARY TABLE tmp_VendorUbilled_  (
		DateID INT,
		VendrorUnbill DOUBLE
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_FinalResult_;
	CREATE TEMPORARY TABLE tmp_FinalResult_  (
		TotalInvoiceOut DOUBLE,
		TotalInvoiceIn DOUBLE,
		TotalPaymentOut DOUBLE,
		TotalPaymentIn DOUBLE,
		CustomerUnbill DOUBLE,
		VendrorUnbill DOUBLE,
		date DATE,
		TotalOutstanding DOUBLE,
		TotalPayable DOUBLE,
		TotalReceivable DOUBLE
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_FinalResult2_;
	CREATE TEMPORARY TABLE tmp_FinalResult2_  (
		TotalInvoiceOut DOUBLE,
		TotalInvoiceIn DOUBLE,
		TotalPaymentOut DOUBLE,
		TotalPaymentIn DOUBLE,
		CustomerUnbill DOUBLE,
		VendrorUnbill DOUBLE,
		date DATE,
		TotalOutstanding DOUBLE,
		TotalPayable DOUBLE,
		TotalReceivable DOUBLE
	);
	
	IF p_Unbilled = 1
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
		CREATE TEMPORARY TABLE tmp_Account_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT,
			LastInvoiceDate DATE
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Account2_;
		CREATE TEMPORARY TABLE tmp_Account2_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT,
			LastInvoiceDate DATE
		);

		INSERT INTO tmp_Account_ (AccountID)
		SELECT DISTINCT tblHeader.AccountID  FROM tblHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblHeader.AccountID WHERE tblHeader.CompanyID = 1;

		UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastInvoiceDate(AccountID);

		INSERT INTO tmp_Account2_ (AccountID)
		SELECT DISTINCT tblHeaderV.VAccountID  FROM tblHeaderV INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblHeaderV.VAccountID WHERE tblHeaderV.CompanyID = p_CompanyID;

		UPDATE tmp_Account2_ SET LastInvoiceDate = fngetLastVendorInvoiceDate(AccountID);

		SELECT 
			SUM(h.TotalCharges)
		INTO
			prev_CustomerUnbill
		FROM tmp_Account_ a
		INNER JOIN tblDimDate dd
			ON dd.date >= a.LastInvoiceDate
		INNER JOIN tblHeader h
			ON h.AccountID = a.AccountID
			AND h.DateID = dd.DateID
		WHERE dd.date < p_StartDate;
		
		SELECT 
			SUM(h.TotalCharges)
		INTO 
			prev_VendrorUnbill
		FROM tmp_Account2_ a
		INNER JOIN tblDimDate dd
			ON dd.date >= a.LastInvoiceDate
		INNER JOIN tblHeaderV h
			ON h.VAccountID = a.AccountID
			AND h.DateID = dd.DateID
		WHERE dd.date < p_StartDate;

		INSERT INTO tmp_CustomerUnbilled_(DateID,CustomerUnbill)
		SELECT 
			dd.DateID,
			SUM(h.TotalCharges)
		FROM tmp_Account_ a
		INNER JOIN tblDimDate dd
			ON dd.date >= a.LastInvoiceDate
		INNER JOIN tblHeader h
			ON h.AccountID = a.AccountID
			AND h.DateID = dd.DateID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		GROUP BY dd.date;

		INSERT INTO tmp_VendorUbilled_ (DateID,VendrorUnbill)
		SELECT 
			dd.DateID,
			SUM(h.TotalCharges)
		FROM tmp_Account2_ a
		INNER JOIN tblDimDate dd
			ON dd.date >= a.LastInvoiceDate
		INNER JOIN tblHeaderV h
			ON h.VAccountID = a.AccountID
			AND h.DateID = dd.DateID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		GROUP BY dd.date;
	
	END IF;

	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) 
	INTO 
		prev_TotalInvoiceOut,
		prev_TotalInvoiceIn
	FROM RMBilling3.tblInvoice 
	WHERE 
		CompanyID = p_CompanyID
		AND CurrencyID = p_CurrencyID
		AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft') )  )
		AND (p_AccountID = 0 or AccountID = p_AccountID)
	AND tblInvoice.IssueDate < p_StartDate ;

	SELECT 
		SUM(IF(PaymentType='Payment In',p.Amount,0)),
		SUM(IF(PaymentType='Payment Out',p.Amount,0)) 
	INTO 
		prev_TotalPaymentIn,
		prev_TotalPaymentOut
	FROM RMBilling3.tblPayment p 
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = p.AccountID
	WHERE 
		p.CompanyID = p_CompanyID
		AND ac.CurrencyId = p_CurrencyID
		AND p.Status = 'Approved'
		AND p.Recall=0
		AND (p_AccountID = 0 or p.AccountID = p_AccountID)
	AND p.PaymentDate < p_StartDate;
	
	SET @prev_TotalInvoiceOut := IFNULL(prev_TotalInvoiceOut,0) ;
	SET @prev_TotalInvoiceIn := IFNULL(prev_TotalInvoiceIn,0) ;
	SET @prev_TotalPaymentOut := IFNULL(prev_TotalPaymentOut,0) ;
	SET @prev_TotalPaymentIn := IFNULL(prev_TotalPaymentIn,0) ;
	SET @prev_CustomerUnbill := IFNULL(prev_CustomerUnbill,0) ;
	SET @prev_VendrorUnbill := IFNULL(prev_VendrorUnbill,0) ;
	
	INSERT INTO tmp_FinalResult_(TotalInvoiceOut,TotalInvoiceIn,TotalPaymentOut,TotalPaymentIn,CustomerUnbill,VendrorUnbill,date,TotalOutstanding,TotalReceivable,TotalPayable)
	SELECT 
		@prev_TotalInvoiceOut := @prev_TotalInvoiceOut +    IFNULL(TotalInvoiceOut,0) AS TotalInvoiceOut ,
		@prev_TotalInvoiceIn := @prev_TotalInvoiceIn +   IFNULL(TotalInvoiceIn,0) AS TotalInvoiceIn,
		@prev_TotalPaymentOut := @prev_TotalPaymentOut +   IFNULL(TotalPaymentOut,0) AS TotalPaymentOut,
		@prev_TotalPaymentIn := @prev_TotalPaymentIn +   IFNULL(TotalPaymentIn,0) AS TotalPaymentIn,
		@prev_CustomerUnbill := @prev_CustomerUnbill +   IFNULL(CustomerUnbill,0) AS CustomerUnbill,
		@prev_VendrorUnbill := @prev_VendrorUnbill +   IFNULL(VendrorUnbill,0) AS VendrorUnbill,
		date,
		ROUND( ( @prev_TotalInvoiceOut - @prev_TotalPaymentIn ) - ( @prev_TotalInvoiceIn - @prev_TotalPaymentOut ) + ( @prev_CustomerUnbill - @prev_VendrorUnbill ) , v_Round_ ) AS TotalOutstanding,
		ROUND( ( @prev_TotalInvoiceOut - @prev_TotalPaymentIn + @prev_CustomerUnbill ), v_Round_ ) AS TotalReceivable,
		ROUND( ( @prev_TotalInvoiceIn - @prev_TotalPaymentOut + @prev_VendrorUnbill), v_Round_ ) AS TotalPayable
	FROM(
		SELECT 
			dd.date,
			TotalPaymentIn,
			TotalPaymentOut,
			TotalInvoiceOut,
			TotalInvoiceIn,
			CustomerUnbill,
			VendrorUnbill
		FROM tblDimDate dd 
		LEFT JOIN(
			SELECT 
				SUM(IF(InvoiceType=1,GrandTotal,0)) AS TotalInvoiceOut,
				SUM(IF(InvoiceType=2,GrandTotal,0)) AS TotalInvoiceIn,
				DATE(tblInvoice.IssueDate) AS  IssueDate 
			FROM RMBilling3.tblInvoice 
			WHERE 
				CompanyID = p_CompanyID
				AND CurrencyID = p_CurrencyID
				AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft') )  )
				AND (p_AccountID = 0 or AccountID = p_AccountID)
				AND IssueDate BETWEEN p_StartDate AND p_EndDate
			GROUP BY DATE(tblInvoice.IssueDate)
			HAVING (TotalInvoiceOut <> 0 OR TotalInvoiceIn <> 0)
		) TBL ON IssueDate = dd.date
		LEFT JOIN (
			SELECT
				SUM(IF(PaymentType='Payment In',p.Amount,0)) AS TotalPaymentIn ,
				SUM(IF(PaymentType='Payment Out',p.Amount,0)) AS TotalPaymentOut,
				DATE(p.PaymentDate) AS PaymentDate
			FROM RMBilling3.tblPayment p
			INNER JOIN Ratemanagement3.tblAccount ac
				ON ac.AccountID = p.AccountID
			WHERE
				p.CompanyID = p_CompanyID
				AND ac.CurrencyId = p_CurrencyID
				AND p.Status = 'Approved'
				AND p.Recall=0
				AND (p_AccountID = 0 or p.AccountID = p_AccountID)
				AND PaymentDate BETWEEN p_StartDate AND p_EndDate
			GROUP BY DATE(p.PaymentDate)
			HAVING (TotalPaymentIn <> 0 OR TotalPaymentOut <> 0)
		)TBL2 ON PaymentDate = dd.date
		LEFT JOIN tmp_CustomerUnbilled_ cu 
			ON cu.DateID = dd.DateID
		LEFT JOIN tmp_VendorUbilled_ vu
			ON vu.DateID = dd.DateID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND ( PaymentDate IS NOT NULL OR IssueDate IS NOT NULL OR cu.DateID IS NOT NULL OR vu.DateID IS NOT NULL)
		ORDER BY dd.date
	)tbl;
	
	INSERT INTO tmp_FinalResult2_
	SELECT * FROM tmp_FinalResult_;

	IF p_ListType = 'Daily'
	THEN

		SELECT
			TotalOutstanding,
			TotalPayable,
			TotalReceivable,
			date AS Date
		FROM  tmp_FinalResult_;

	END IF;

	IF p_ListType = 'Weekly'
	THEN

		SELECT 
			TotalOutstanding,
			TotalPayable,
			TotalReceivable,
			CONCAT( YEAR(date),' - ',WEEK(date,1)) AS Date
		FROM	tmp_FinalResult_ t1
		INNER JOIN (
			SELECT 
				MAX(date) as finaldate
			FROM tmp_FinalResult2_
			GROUP BY
			YEAR(date),WEEK(date,1)
		)TBL ON TBL.finaldate = t1.date;

	END IF;
	
	IF p_ListType = 'Monthly'
	THEN

		SELECT 
			TotalOutstanding,
			TotalPayable,
			TotalReceivable,
			CONCAT( YEAR(date),' - ',MONTHNAME(date)) AS Date
		FROM	tmp_FinalResult_ t1
		INNER JOIN (
			SELECT 
				MAX(date) as finaldate
			FROM tmp_FinalResult2_
			GROUP BY
			YEAR(date),MONTH(date)
		)TBL ON TBL.finaldate = t1.date;

	END IF;
	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDistinctList`;

DELIMITER |
CREATE PROCEDURE `prc_getDistinctList`(
	IN `p_CompanyID` INT,
	IN `p_ColName` VARCHAR(50),
	IN `p_Search` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_ColName = 'CompanyGatewayID'
	THEN

		SELECT 
			CompanyGatewayID,
			Title 
		FROM Ratemanagement3.tblCompanyGateway 
		WHERE CompanyID = p_CompanyID
		AND Title LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblCompanyGateway 
		WHERE CompanyID = p_CompanyID
		AND Title LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'CountryID'
	THEN

		SELECT 
			CountryID,
			Country 
		FROM Ratemanagement3.tblCountry
		WHERE Country LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblCountry
		WHERE Country LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'AccountID' OR p_ColName = 'VAccountID'
	THEN

		SELECT 
			AccountID,
			AccountName 
		FROM Ratemanagement3.tblAccount
		WHERE CompanyID = p_CompanyID
		AND AccountName LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblAccount
		WHERE CompanyID = p_CompanyID
		AND AccountName LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'ServiceID'
	THEN

		SELECT 
			ServiceID,
			ServiceName 
		FROM Ratemanagement3.tblService 
		WHERE CompanyID = p_CompanyID
		AND ServiceName LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblService 
		WHERE CompanyID = p_CompanyID
		AND ServiceName LIKE CONCAT(p_Search,'%');

	END IF;
	
	
	IF p_ColName = 'Trunk'
	THEN

		SELECT 
			DISTINCT
			Trunk as Trunk1,
			Trunk
		FROM tblRTrunk
		WHERE CompanyID = p_CompanyID
		AND Trunk LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM tblRTrunk
		WHERE CompanyID = p_CompanyID
		AND Trunk LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'CurrencyID'
	THEN

		SELECT 
			DISTINCT
			CurrencyId as CurrencyID,
			Code
		FROM Ratemanagement3.tblCurrency
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblCurrency
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'TaxRateID'
	THEN

		SELECT 
			DISTINCT
			TaxRateId as CurrencyID,
			Title
		FROM Ratemanagement3.tblTaxRate
		WHERE CompanyID = p_CompanyID
		AND Title LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM Ratemanagement3.tblTaxRate
		WHERE CompanyID = p_CompanyID
		AND Title LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'ProductID'
	THEN

		SELECT 
			DISTINCT
			ProductID as ProductID,
			Name
		FROM RMBilling3.tblProduct
		WHERE CompanyID = p_CompanyID
		AND Name LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM RMBilling3.tblProduct
		WHERE CompanyID = p_CompanyID
		AND Name LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'Code'
	THEN

		SELECT 
			DISTINCT
			ProductID as ProductID,
			Code
		FROM RMBilling3.tblProduct
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM RMBilling3.tblProduct
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'AreaPrefix'
	THEN

		SELECT 
			DISTINCT
			Code as AreaPrefix1,
			Code
		FROM tblRRate
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%')
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(*) AS totalcount
		FROM tblRRate
		WHERE CompanyID = p_CompanyID
		AND Code LIKE CONCAT(p_Search,'%');

	END IF;
	
	IF p_ColName = 'GatewayAccountPKID' OR p_ColName = 'GatewayVAccountPKID'
	THEN

		SELECT
			DISTINCT 
			CASE WHEN AccountIP <> ''
			THEN 
				AccountIP
			ELSE
				AccountCLI
			END as AccountIP,
			CASE WHEN AccountIP <> ''
			THEN 
				AccountIP
			ELSE
				AccountCLI
			END as AccountIP1 
		FROM RMBilling3.tblGatewayAccount 
		WHERE CompanyID = p_CompanyID
		AND (AccountIP <> '' OR AccountCLI <> '')
		AND ( AccountIP LIKE CONCAT(p_Search,'%') OR AccountCLI LIKE CONCAT(p_Search,'%'))
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(
			DISTINCT
			CASE WHEN AccountIP <> ''
			THEN 
				AccountIP
			ELSE
				AccountCLI
			END) AS totalcount
		FROM RMBilling3.tblGatewayAccount 
		WHERE CompanyID = p_CompanyID
		AND (AccountIP <> '' OR AccountCLI <> '')
		AND ( AccountIP LIKE CONCAT(p_Search,'%') OR AccountCLI LIKE CONCAT(p_Search,'%'));

	END IF;
	
	IF p_ColName = 'week_of_year'
	THEN

		SELECT 
			DISTINCT
			tblDimDate.week_of_year as week_of_year1,
			tblDimDate.week_of_year
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID
		ORDER BY tblDimDate.week_of_year
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(DISTINCT tblDimDate.week_of_year) AS totalcount
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID;

	END IF;
	
	IF p_ColName = 'month'
	THEN

		SELECT 
			DISTINCT
			tblDimDate.month_of_year as month1,
			tblDimDate.month
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID
		ORDER BY tblDimDate.month_of_year
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(DISTINCT tblDimDate.month) AS totalcount
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID;

	END IF;
	
	IF p_ColName = 'quarter_of_year'
	THEN

		SELECT 
			DISTINCT
			tblDimDate.quarter_of_year as month1,
			tblDimDate.quarter_of_year
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID
		ORDER BY tblDimDate.quarter_of_year
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(DISTINCT tblDimDate.quarter_of_year) AS totalcount
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID;

	END IF;
	
	IF p_ColName = 'year'
	THEN

		SELECT 
			DISTINCT
			tblDimDate.year as month1,
			tblDimDate.year
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID
		ORDER BY tblDimDate.year
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT
			COUNT(DISTINCT tblDimDate.year) AS totalcount
		FROM tblHeader
		INNER JOIN tblDimDate
			ON tblDimDate.DateID = tblHeader.DateID
		WHERE CompanyID = p_CompanyID;

	END IF;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getUnbilledReport`;

DELIMITER |
CREATE PROCEDURE `prc_getUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tblHeader us
		INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
		WHERE dd.date BETWEEN p_LastInvoiceDate AND p_Today 
		AND us.CompanyID = p_CompanyID
		AND us.AccountID = p_AccountID
		GROUP BY us.DateID;	
		
	
	END IF;
	
	IF p_Detail = 3
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_FinalAmount_;
		CREATE TEMPORARY TABLE tmp_FinalAmount_  (
			FinalAmount DOUBLE
		);
		INSERT INTO tmp_FinalAmount_
		SELECT 
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		FROM tblHeader us
		INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
		WHERE dd.date BETWEEN p_LastInvoiceDate AND p_Today 
		AND us.CompanyID = p_CompanyID
		AND us.AccountID = p_AccountID;
		
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorUnbilledReport`;

DELIMITER |
CREATE PROCEDURE `prc_getVendorUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tblHeaderV us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		WHERE dd.date BETWEEN p_LastInvoiceDate AND p_Today 
		AND us.CompanyID = p_CompanyID
		AND us.VAccountID = p_AccountID
		GROUP BY us.DateID;	
	
	END IF;
	
	 
	
	IF p_Detail = 3
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_FinalAmount_;
		CREATE TEMPORARY TABLE tmp_FinalAmount_  (
			FinalAmount DOUBLE
		);
		INSERT INTO tmp_FinalAmount_
		SELECT 
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		FROM tblHeaderV us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		WHERE dd.date BETWEEN p_LastInvoiceDate AND p_Today 
		AND us.CompanyID = p_CompanyID
		AND us.VAccountID = p_AccountID;
	
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateLiveTables`;

DELIMITER |
CREATE PROCEDURE `prc_updateLiveTables`(
	IN `p_CompanyID` INT,
	IN `p_UniqueID` VARCHAR(50),
	IN `p_Type` VARCHAR(50)
)
BEGIN
	
	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_Type = 'Customer'
	THEN
		SET @stmt = CONCAT('
		UPDATE tmp_tblUsageDetailsReport_',p_UniqueID,' uh
		INNER JOIN RMBilling3.tblGatewayAccount ga
			ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = ',p_CompanyID,';
		');

		PREPARE stmt FROM @stmt;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @stmt = CONCAT('
		UPDATE tblTempCallDetail_1_',p_UniqueID,' uh
		INNER JOIN RMBilling3.tblGatewayAccount ga
			ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null;
		');

		PREPARE stmt FROM @stmt;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	IF p_Type = 'Vendor'
	THEN

		SET @stmt = CONCAT('
		UPDATE tmp_tblVendorUsageDetailsReport_',p_UniqueID,' uh
		INNER JOIN RMBilling3.tblGatewayAccount ga
			ON  uh.GatewayVAccountPKID = ga.GatewayAccountPKID
		SET uh.VAccountID = ga.AccountID
		WHERE uh.VAccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = ',p_CompanyID,';
		');

		PREPARE stmt FROM @stmt;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @stmt = CONCAT('
		UPDATE tblTempCallDetail_2_',p_UniqueID,' uh
		INNER JOIN RMBilling3.tblGatewayAccount ga
			ON  uh.GatewayVAccountPKID = ga.GatewayAccountPKID
		SET uh.VAccountID = ga.AccountID
		WHERE uh.VAccountID IS NULL
		AND ga.AccountID is not null;
		');

		PREPARE stmt FROM @stmt;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateUnbilledAmount`;
DELIMITER |
CREATE PROCEDURE `prc_updateUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATE;
	DECLARE v_FinalAmount_ DOUBLE;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATE
	);
	
	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblHeader.AccountID  FROM tblHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblHeader.AccountID WHERE tblHeader.CompanyID = p_CompanyID;
	
	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastInvoiceDate(AccountID);
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		
		CALL prc_getUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);
		
		SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;
		
		IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
		THEN
			UPDATE Ratemanagement3.tblAccountBalance SET UnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
		ELSE
			INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,UnbilledAmount,BalanceAmount)
			SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
		END IF;
		
		SET v_pointer_ = v_pointer_ + 1;
	
	END WHILE;
	
	UPDATE 
		Ratemanagement3.tblAccountBalance 
	INNER JOIN
		(
			SELECT 
				DISTINCT tblAccount.AccountID 
			FROM Ratemanagement3.tblAccount  
			LEFT JOIN tmp_Account_ 
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET UnbilledAmount = 0;
	
	CALL prc_updateVendorUnbilledAmount(p_CompanyID,p_Today);
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_updateVendorUnbilledAmount`;
DELIMITER |
CREATE PROCEDURE `prc_updateVendorUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATETIME;
	DECLARE v_FinalAmount_ DOUBLE;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATETIME
	);
	
	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblHeaderV.VAccountID  FROM tblHeaderV INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblHeaderV.VAccountID WHERE tblHeaderV.CompanyID = p_CompanyID;
	
	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastVendorInvoiceDate(AccountID);
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		
		IF v_LastInvoiceDate_ IS NOT NULL
		THEN
		
			CALL prc_getVendorUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);
			
			SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;
			
			IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
			THEN
				UPDATE Ratemanagement3.tblAccountBalance SET VendorUnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
			ELSE
				INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,VendorUnbilledAmount,BalanceAmount)
				SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
			END IF;
			
		END IF;
		
		SET v_pointer_ = v_pointer_ + 1;
	
	END WHILE;	
	
	UPDATE 
		Ratemanagement3.tblAccountBalance 
	INNER JOIN
		(
			SELECT 
				DISTINCT tblAccount.AccountID 
			FROM Ratemanagement3.tblAccount  
			LEFT JOIN tmp_Account_ 
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET VendorUnbilledAmount = 0;	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getAccountReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* account by call count */	
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
	FROM tmp_tblUsageSummary_ us
	GROUP BY AccountName   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 account by call count */	
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 account by call cost */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 account by call minutes */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDescReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getDescReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE v_OffSet_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fngetDefaultCodes(p_CompanyID);

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	/* grid display*/
	IF p_isExport = 0
	THEN

		/* Description by call count */	
		SELECT IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY c.Description
		ORDER BY
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
		END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM(
			SELECT IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR
			FROM tmp_tblUsageSummary_ us
			LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
			GROUP BY c.Description
		)tbl;

	END IF;

	/* export data*/
	IF p_isExport = 1
	THEN

		SELECT SQL_CALC_FOUND_ROWS IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description;

	END IF;

	/* chart display*/
	IF p_isExport = 2
	THEN

		/* top 10 Description by call count */
		SELECT Description AS ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;

		/* top 10 Description by call cost */
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;

		/* top 10 Description by call minutes */
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDestinationReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getDestinationReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* country by call count */	
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
	FROM tmp_tblUsageSummary_ us
	LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
	WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
	GROUP BY c.Country   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN Country
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN IF(SUM(NoOfCalls)>0,(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN IF(SUM(NoOfCalls)>0,(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	

	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM(
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 country by call count */	
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 country by call cost */	
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 country by call minutes */	
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getGatewayReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getGatewayReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* CompanyGatewayID by call count */	
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
	FROM tmp_tblUsageSummary_ us
	GROUP BY CompanyGatewayID   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayDESC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayASC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 CompanyGatewayID by call count */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call cost */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call minutes */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getPrefixReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getPrefixReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* AreaPrefix by call count */	
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageSummary_ us
	GROUP BY AreaPrefix   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN AreaPrefix
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN AreaPrefix
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 AreaPrefix by call count */	
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call cost */	
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call minutes */	
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getTrunkReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getTrunkReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* Trunk by call count */	
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageSummary_ us
	GROUP BY Trunk   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkDESC') THEN Trunk
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkASC') THEN Trunk
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 Trunk by call count */	
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 Trunk by call cost */	
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 Trunk by call minutes */	
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorAccountReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorAccountReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* account by call count */	
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AccountName   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 account by call count */	
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 account by call cost */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 account by call minutes */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorDescReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorDescReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE v_OffSet_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fngetDefaultCodes(p_CompanyID);

	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	/* grid display*/
	IF p_isExport = 0
	THEN

		/* Description by call count */	
		SELECT IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY c.Description   
		ORDER BY
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
		END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
			SELECT IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR
			FROM tmp_tblUsageVendorSummary_ us
			LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
			GROUP BY c.Description
		)tbl;

	END IF;

	/* export data*/
	IF p_isExport = 1
	THEN

		SELECT SQL_CALC_FOUND_ROWS IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description;

	END IF;

	/* chart display*/
	IF p_isExport = 2
	THEN

		/* top 10 Description by call count */
		SELECT Description AS ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;

		/* top 10 Description by call cost */
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;

		/* top 10 Description by call minutes */
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorDestinationReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorDestinationReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* country by call count */	
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
	WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
	GROUP BY c.Country   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN Country
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 country by call count */	
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 country by call cost */	
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 country by call minutes */	
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorGatewayReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorGatewayReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* CompanyGatewayID by call count */	
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY CompanyGatewayID   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayDESC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayASC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 CompanyGatewayID by call count */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call cost */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call minutes */	
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorPrefixReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorPrefixReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* AreaPrefix by call count */	
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AreaPrefix   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN AreaPrefix
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN AreaPrefix
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 AreaPrefix by call count */	
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call cost */	
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call minutes */	
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getVendorTrunkReportAll`;
DELIMITER |
CREATE PROCEDURE `prc_getVendorTrunkReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* Trunk by call count */	
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY Trunk   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkDESC') THEN Trunk
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkASC') THEN Trunk
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,ROUND(SUM(TotalSeconds)/60,0) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 Trunk by call count */	
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 Trunk by call cost */	
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 Trunk by call minutes */	
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `report_mig`;
DELIMITER |
CREATE PROCEDURE `report_mig`()
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  INSERT INTO tblUsageSummaryDay (HeaderID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID)
	SELECT 
    HeaderID,tblUsageSummary.TotalCharges,tblUsageSummary.TotalBilledDuration,tblUsageSummary.TotalDuration,tblUsageSummary.NoOfCalls,tblUsageSummary.NoOfFailCalls,tblSummaryHeader.CompanyGatewayID,tblSummaryHeader.ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID
  FROM tblUsageSummary 
  INNER JOIN tblSummaryHeader ON tblSummaryHeader.SummaryHeaderID = tblUsageSummary.SummaryHeaderID
  INNER JOIN tblHeader ON tblHeader.DateID = tblSummaryHeader.DateID and tblHeader.CompanyID = tblSummaryHeader.CompanyID AND tblHeader.AccountID = tblSummaryHeader.AccountID
  LEFT JOIN RMBilling3.tblGatewayAccount ON tblGatewayAccount.GatewayAccountID = tblSummaryHeader.GatewayAccountID AND tblGatewayAccount.CompanyGatewayID = tblSummaryHeader.CompanyGatewayID;
  
  INSERT INTO tblVendorSummaryDay (HeaderVID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID)
	SELECT 
    HeaderVID,tblUsageVendorSummary.TotalCharges,tblUsageVendorSummary.TotalSales,tblUsageVendorSummary.TotalBilledDuration,tblUsageVendorSummary.TotalDuration,tblUsageVendorSummary.NoOfCalls,tblUsageVendorSummary.NoOfFailCalls,tblSummaryVendorHeader.CompanyGatewayID,tblSummaryVendorHeader.ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID
  FROM tblUsageVendorSummary 
  INNER JOIN tblSummaryVendorHeader ON tblSummaryVendorHeader.SummaryVendorHeaderID = tblUsageVendorSummary.SummaryVendorHeaderID
  INNER JOIN tblHeaderV ON tblHeaderV.DateID = tblSummaryVendorHeader.DateID and tblHeaderV.CompanyID = tblSummaryVendorHeader.CompanyID AND tblHeaderV.VAccountID = tblSummaryVendorHeader.AccountID
  LEFT JOIN RMBilling3.tblGatewayAccount ON tblGatewayAccount.GatewayAccountID = tblSummaryVendorHeader.GatewayAccountID AND tblGatewayAccount.CompanyGatewayID = tblSummaryVendorHeader.CompanyGatewayID;

	INSERT INTO tblUsageSummaryHour (HeaderID,TimeID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID)
	SELECT 
    HeaderID,TimeID,tblUsageSummaryDetail.TotalCharges,tblUsageSummaryDetail.TotalBilledDuration,tblUsageSummaryDetail.TotalDuration,tblUsageSummaryDetail.NoOfCalls,tblUsageSummaryDetail.NoOfFailCalls,tblSummaryHeader.CompanyGatewayID,tblSummaryHeader.ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID
  FROM tblUsageSummaryDetail 
  INNER JOIN tblSummaryHeader ON tblSummaryHeader.SummaryHeaderID = tblUsageSummaryDetail.SummaryHeaderID
  INNER JOIN tblHeader ON tblHeader.DateID = tblSummaryHeader.DateID and tblHeader.CompanyID = tblSummaryHeader.CompanyID AND tblHeader.AccountID = tblSummaryHeader.AccountID
  LEFT JOIN RMBilling3.tblGatewayAccount ON tblGatewayAccount.GatewayAccountID = tblSummaryHeader.GatewayAccountID AND tblGatewayAccount.CompanyGatewayID = tblSummaryHeader.CompanyGatewayID;
  
  INSERT INTO tblVendorSummaryHour (HeaderVID,TimeID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID)
  SELECT 
    HeaderVID,TimeID,tblUsageVendorSummaryDetail.TotalCharges,tblUsageVendorSummaryDetail.TotalSales,tblUsageVendorSummaryDetail.TotalBilledDuration,tblUsageVendorSummaryDetail.TotalDuration,tblUsageVendorSummaryDetail.NoOfCalls,tblUsageVendorSummaryDetail.NoOfFailCalls,tblSummaryVendorHeader.CompanyGatewayID,tblSummaryVendorHeader.ServiceID,Trunk,AreaPrefix,CountryID,GatewayAccountPKID
  FROM tblUsageVendorSummaryDetail 
  INNER JOIN tblSummaryVendorHeader ON tblSummaryVendorHeader.SummaryVendorHeaderID = tblUsageVendorSummaryDetail.SummaryVendorHeaderID
  INNER JOIN tblHeaderV ON tblHeaderV.DateID = tblSummaryVendorHeader.DateID and tblHeaderV.CompanyID = tblSummaryVendorHeader.CompanyID AND tblHeaderV.VAccountID = tblSummaryVendorHeader.AccountID
  LEFT JOIN RMBilling3.tblGatewayAccount ON tblGatewayAccount.GatewayAccountID = tblSummaryVendorHeader.GatewayAccountID AND tblGatewayAccount.CompanyGatewayID = tblSummaryVendorHeader.CompanyGatewayID;
  
  
  RENAME TABLE `tblSummaryHeader` TO `tblSummaryHeader_delete`;
  RENAME TABLE `tblSummaryVendorHeader` TO `tblSummaryVendorHeader_delete`;
  
  RENAME TABLE `tblUsageSummaryDetailLive` TO `tblUsageSummaryDetailLive_delete`;  
  RENAME TABLE `tblUsageSummaryLive` TO `tblUsageSummaryLive_delete`;
  
  RENAME TABLE `tblUsageSummary` TO `tblUsageSummary_delete`;
  RENAME TABLE `tblUsageSummaryDetail` TO `tblUsageSummaryDetail_delete`;
  
  RENAME TABLE `tblUsageVendorSummary` TO `tblUsageVendorSummary_delete`;
  RENAME TABLE `tblUsageVendorSummaryDetail` TO `tblUsageVendorSummaryDetail_delete`;  

  RENAME TABLE `tblUsageVendorSummaryLive` TO `tblUsageVendorSummaryLive_delete`;
  RENAME TABLE `tblUsageVendorSummaryDetailLive` TO `tblUsageVendorSummaryDetailLive_delete`;
  

END|
DELIMITER ;


CALL report_mig();

INSERT INTO `tblReport` (`ReportID`, `CompanyID`, `Name`, `Settings`, `Type`, `created_at`, `CreatedBy`, `updated_at`, `UpdatedBy`) VALUES (1, 1, 'Monthly Revenue Report', '{"Cube":"invoice","row":"year,month","column":"GrandTotal,ProductType","filter":"date","filter_col_name":"date","filter_settings":"{\\"date\\":{\\"table-filter-list_length\\":\\"10\\",\\"TaxRateID\\":[\\"3\\"],\\"wildcard_match_val\\":\\"\\",\\"start_date\\":\\"2017-01-01\\",\\"end_date\\":\\"2017-10-02\\",\\"condition\\":\\"none\\",\\"top\\":\\"none\\"}}","wildcard_match_val":"","start_date":"","end_date":"","condition":"none","top":"none","Name":"Monthly Revenue Report","ReportID":"1"}', 1, '2017-10-02 16:31:56', 'System', '2017-10-03 11:25:43', 'System');
INSERT INTO `tblReport` (`ReportID`, `CompanyID`, `Name`, `Settings`, `Type`, `created_at`, `CreatedBy`, `updated_at`, `UpdatedBy`) VALUES (2, 1, 'Monthly Tax Report', '{"Cube":"invoice","row":"year,month","column":"TotalTax,TaxRateID","filter":"","filter_col_name":"date","filter_settings":"{\\"date\\":{\\"wildcard_match_val\\":\\"\\",\\"start_date\\":\\"2017-01-01\\",\\"end_date\\":\\"2017-10-02\\",\\"condition\\":\\"none\\",\\"top\\":\\"none\\"}}","wildcard_match_val":"","start_date":"2017-01-01","end_date":"2017-10-02","condition":"none","top":"none","Name":"Monthly Tax Report","ReportID":""}', 1, '2017-10-02 16:41:49', 'System', '2017-10-02 16:41:49', 'System');
INSERT INTO `tblReport` (`ReportID`, `CompanyID`, `Name`, `Settings`, `Type`, `created_at`, `CreatedBy`, `updated_at`, `UpdatedBy`) VALUES (3, 1, 'Monthly Invoice  Report', '{"Cube":"invoice","row":"year,month","column":"GrandTotal,InvoiceType","filter":"","filter_col_name":"date","filter_settings":"{\\"date\\":{\\"wildcard_match_val\\":\\"\\",\\"start_date\\":\\"2017-01-01\\",\\"end_date\\":\\"2017-10-02\\",\\"condition\\":\\"none\\",\\"top\\":\\"none\\"}}","wildcard_match_val":"","start_date":"","end_date":"","condition":"none","top":"none","Name":"Monthly Invoice  Report","ReportID":"3"}', 1, '2017-10-02 16:43:06', 'System', '2017-10-02 16:43:48', 'System');
INSERT INTO `tblReport` (`ReportID`, `CompanyID`, `Name`, `Settings`, `Type`, `created_at`, `CreatedBy`, `updated_at`, `UpdatedBy`) VALUES (4, 1, 'Cross Analysis Report', '{"Cube":"summary","row":"VAccountID","column":"TotalCharges,NoOfCalls,AccountID","filter":"AreaPrefix","filter_col_name":"AreaPrefix","filter_settings":"{\\"date\\":{\\"wildcard_match_val\\":\\"\\",\\"start_date\\":\\"2017-07-01\\",\\"end_date\\":\\"2017-10-02\\",\\"condition\\":\\"none\\",\\"top\\":\\"none\\"},\\"AreaPrefix\\":{\\"table-filter-list_length\\":\\"10\\",\\"AreaPrefix\\":[\\"8801\\"],\\"wildcard_match_val\\":\\"\\",\\"start_date\\":\\"2017-07-01\\",\\"end_date\\":\\"2017-10-02\\",\\"condition\\":\\"none\\",\\"top\\":\\"none\\"}}","table-filter-list_length":"10","AreaPrefix":["8801"],"wildcard_match_val":"","start_date":"2017-07-01","end_date":"2017-10-02","condition":"none","top":"none","Name":"Cross Analysis Report","ReportID":""}', 1, '2017-10-02 17:16:49', 'System', '2017-10-02 17:16:49', 'System');
