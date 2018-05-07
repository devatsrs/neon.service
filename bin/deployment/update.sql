USE `Ratemanagement3`;

set sql_mode='';

ALTER TABLE `tblRateRule`
ADD COLUMN `Order` INT(11) NULL AFTER `ModifiedBy`;

UPDATE tblRateRule SET `Order` = RateRuleId;

ALTER TABLE `tblAccountBilling`
	ADD COLUMN `LastChargeDate` DATE NULL DEFAULT NULL AFTER `NextInvoiceDate`,
	ADD COLUMN `NextChargeDate` DATE NULL DEFAULT NULL AFTER `LastChargeDate`;
	
UPDATE tblAccountBilling SET LastChargeDate=LastInvoiceDate,NextChargeDate=DATE_ADD(NextInvoiceDate, INTERVAL -1 DAY);

CREATE TABLE IF NOT EXISTS `tblAccountDetails` (
	`AccountDetailID` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountID` INT(11) NOT NULL,
	`CustomerPaymentAdd` INT(11) NULL DEFAULT '0',
	`customerpanelpassword` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`DisplayRates` INT(11) NULL DEFAULT '0',
	`ResellerOwner` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`AccountDetailID`),
	UNIQUE INDEX `UI_AccountID` (`AccountID`),
	INDEX `IX_AccountID` (`AccountID`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;

INSERT INTO `tblCronJobCommand` ( `CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 4, 'Reseller PBX CDR', 'resellerpbxaccountusage', '[[{"title":"Start Date","type":"text","datepicker":"","value":"","name":"StartDate"},{"title":"End Date","type":"text","value":"","datepicker":"","name":"EndDate"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2018-03-13 15:00:00', 'RateManagementSystem');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PBX_RESELLER_CRONJOB', '{"StartDate":"","EndDate":"","ThresholdTime":"120","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"10","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');

INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1333, 'CustomersRates.Create', 1, 3);

INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('CustomersRates.create', 'CustomersRatesController.create', 1, 'Vasim Seta', NULL, '2018-04-13 09:37:36.000', '2018-04-13 09:37:36.000', 1333);

ALTER TABLE `tblCustomerRate`
	ADD COLUMN `CreatedBy` VARCHAR(50) NULL DEFAULT NULL AFTER `CreatedDate`,
	ADD COLUMN `EndDate` DATE NULL DEFAULT NULL AFTER `EffectiveDate`;

ALTER TABLE `tblRateSheetDetails`
	ADD COLUMN `EndDate` DATETIME NULL AFTER `EffectiveDate`;

RENAME TABLE `tblCustomerRateArchive` TO `tblCustomerRateArchive_old`;
CREATE TABLE IF NOT EXISTS `tblCustomerRateArchive` (
  `CustomerRateArchiveID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerRateID` int(11) DEFAULT NULL,
  `AccountId` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `RoutinePlan` int(11) DEFAULT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CustomerRateArchiveID`),
  KEY `CustomerRateID` (`CustomerRateID`),
  KEY `AccountId` (`AccountId`),
  KEY `TrunkID` (`TrunkID`),
  KEY `RateId` (`RateId`),
  KEY `EffectiveDate` (`EffectiveDate`),
  KEY `EndDate` (`EndDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'AUTO_SIPPY_ACCOUNT_IMPORT_INTERVAL', '360');

INSERT IGNORE INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (7, 'FTP', 'FTP', 1, 'RateManagementSystem', '2017-04-21 12:20:01', NULL, '2017-04-21 12:20:01');
UPDATE `tblGateway` SET `Status`  = 1 WHERE `Name` = 'FTP';
SELECT GatewayID INTO @FTPGatewayID  FROM tblGateway WHERE `Name` = 'FTP';
DELETE FROM tblGatewayConfig WHERE `GatewayID` = @FTPGatewayID;
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Rate Format', 'RateFormat', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Authentication Rule', 'NameFormat', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'CDR ReRate', 'RateCDR', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'CLI Translation Rule', 'CLITranslationRule', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'FTP Host IP', 'host', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Protocol Type', 'protocol_type', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Port', 'port', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'SSL', 'ssl', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Passive Mode', 'passive_mode', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'User Name', 'username', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Password', 'password', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Key', 'key', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Key Phrase', 'keyphrase', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'FTP CDR Download Path', 'cdr_folder', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Billing Time', 'BillingTime', 1, '2017-04-14 15:59:25', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2017-06-09 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` ( `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES ( @FTPGatewayID, 'File Name Rule', 'FileNameRule', 1, '2017-06-09 00:00:00', 'RateManagementSystem', NULL, NULL);

ALTER TABLE `tblRateRuleMargin`
	ADD COLUMN `FixedValue` DECIMAL(18,6) NULL AFTER `AddMargin`;

INSERT INTO `tblIntegration` (`CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (1, 'PeleCard', 'pelecard', 4, 'N');

INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1332, 'RateUpload.All', 1, 5);

INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.missingMethod', 'RateUploadController.missingMethod', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.getAllowedActions', 'RateUploadController.getAllowedActions', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.get', 'RateUploadController.get', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.destroy', 'RateUploadController.destroy', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.update', 'RateUploadController.update', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.edit', 'RateUploadController.edit', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.show', 'RateUploadController.show', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.store', 'RateUploadController.store', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.create', 'RateUploadController.create', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:01.000', '2018-03-27 17:44:01.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.*', 'RateUploadController.*', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.index', 'RateUploadController.index', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.getUploadTemplates', 'RateUploadController.getUploadTemplates', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.getTrunk', 'RateUploadController.getTrunk', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.checkUpload', 'RateUploadController.checkUpload', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.ajaxfilegrid', 'RateUploadController.ajaxfilegrid', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.storeTemplate', 'RateUploadController.storeTemplate', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.reviewRatesExports', 'RateUploadController.reviewRatesExports', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.getReviewRates', 'RateUploadController.getReviewRates', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.reviewRates', 'RateUploadController.reviewRates', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.updateTempReviewRates', 'RateUploadController.updateTempReviewRates', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('RateUpload.getSheetNamesFromExcel', 'RateUploadController.getSheetNamesFromExcel', 1, 'Sumera Saeed', NULL, '2018-03-27 17:44:00.000', '2018-03-27 17:44:00.000', 1332);

ALTER TABLE `tblRateTableRate`
	ADD COLUMN `EndDate` DATE NULL AFTER `EffectiveDate`;


CREATE TABLE IF NOT EXISTS `tblRateTableRateChangeLog` (
  `RateTableRateChangeLogID` int(11) NOT NULL AUTO_INCREMENT,
  `TempRateTableRateID` int(11) NOT NULL DEFAULT '0',
  `RateTableRateID` int(11) DEFAULT NULL,
  `RateTableId` int(11) DEFAULT NULL,
  `RateId` int(11) DEFAULT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Rate` decimal(18,6) DEFAULT NULL,
  `EffectiveDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `Action` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RateTableRateChangeLogID`),
  KEY `IX_tblRateTableRateChangeLog_RateTableRateID` (`RateTableRateID`),
  KEY `IX_tblRateTableRateChangeLog_ProcessID` (`ProcessID`),
  KEY `RateId` (`RateId`),
  KEY `EffectiveDate` (`EffectiveDate`),
  KEY `Code` (`Code`),
  KEY `Action` (`Action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblTempRateTableRate` (
  `TempRateTableRateID` int(11) NOT NULL AUTO_INCREMENT,
  `CodeDeckId` int(11) DEFAULT NULL,
  `CountryCode` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Code` text COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Change` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessId` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Preference` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `Interval1` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IntervalN` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Forbidden` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DialStringPrefix` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempRateTableRateID`),
  KEY `IX_tblTempRateTableRateProcessID` (`ProcessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `tblRateTableRateArchive`;
CREATE TABLE IF NOT EXISTS `tblRateTableRateArchive` (
  `RateTableRateArchiveID` int(11) NOT NULL AUTO_INCREMENT,
  `RateTableRateID` int(11) DEFAULT NULL,
  `RateTableId` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateTableRateArchiveID`),
  KEY `RateTableRateID` (`RateTableRateID`),
  KEY `RateTableId` (`RateTableId`),
  KEY `RateId` (`RateId`),
  KEY `EffectiveDate` (`EffectiveDate`),
  KEY `EndDate` (`EndDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS `tblFileUploadTemplateType` (
  `FileUploadTemplateTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `TemplateType` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `UploadDir` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`FileUploadTemplateTypeID`),
  UNIQUE KEY `IXUnique_TemplateType` (`TemplateType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `tblFileUploadTemplateType` (`FileUploadTemplateTypeID`, `TemplateType`, `Title`, `UploadDir`, `created_at`, `created_by`, `Status`) VALUES
	(1, 'CDR', 'CDR', 'CDR_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(2, 'VendorCDR', 'Vendor CDR', 'CDR_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(3, 'Account', 'Account', 'ACCOUNT_DOCUMENT', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(4, 'Leads', 'Leads', 'ACCOUNT_DOCUMENT', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(5, 'DialString', 'DialString', 'DIALSTRING_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(6, 'IPs', 'IPs', 'IP_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(7, 'Item', 'Item', 'ITEM_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(8, 'VendorRate', 'Vendor Rate', 'VENDOR_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(9, 'Payment', 'Payment', 'PAYMENT_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(10, 'RatetableRate', 'Ratetable Rate', 'RATETABLE_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 1),
	(11, 'CustomerRate', 'Customer Rate', 'CUSTOMER_UPLOAD', '2018-04-24 13:59:54', 'Vasim Seta', 0);

ALTER TABLE `tblFileUploadTemplate`
	CHANGE COLUMN `Type` `FileUploadTemplateTypeID` TINYINT(3) UNSIGNED NULL DEFAULT NULL AFTER `FileUploadTemplateID`;
	
ALTER TABLE `tblBillingClass`
	ADD COLUMN `RoundChargesCDR` INT(11) NULL DEFAULT NULL AFTER `RoundChargesAmount`;	
	
CREATE TABLE IF NOT EXISTS `tblAutoImport` (
  `AutoImportID` int(11) NOT NULL AUTO_INCREMENT,
  `JobID` int(11) NOT NULL DEFAULT '0',
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `AccountName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `To` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `From` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CC` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `Subject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `MessageId` text COLLATE utf8_unicode_ci NOT NULL,
  `MailDateTime` datetime NOT NULL,
  `Attachment` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AutoImportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblAutoImportInboxSetting` (
  `AutoImportInboxSettingID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `port` int(11) DEFAULT NULL,
  `host` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IsSSL` tinyint(1) DEFAULT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `emailNotificationOnSuccess` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `emailNotificationOnFail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SendCopyToAccount` enum('Y','N') COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`AutoImportInboxSettingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS `tblAutoImportSetting` (
  `AutoImportSettingID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `Type` tinyint(1) NOT NULL COMMENT '1=Vendor,2=RateTable',
  `TypePKID` int(11) DEFAULT NULL COMMENT 'Type:1 = AccountID ,Type:2 = VendorID',
  `TrunkID` int(11) DEFAULT NULL,
  `ImportFileTempleteID` int(11) DEFAULT NULL,
  `Subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FileName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SendorEmail` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AutoImportSettingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;	

INSERT INTO `tblCronJobCommand` ( `CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES ( 1, NULL, 'Read Email for AutoRateImport', 'reademailsautoimport', '[[{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, NULL, NULL);

ALTER TABLE `tblAccount`
ADD COLUMN `LanguageID` INT(11) NULL DEFAULT '43' AFTER `CurrencyId`;

ALTER TABLE `tblTicketGroups`
ADD COLUMN `LanguageID` INT(11) NULL DEFAULT '43' AFTER `CompanyID`;

ALTER TABLE `tblEmailTemplate`
ADD COLUMN `LanguageID` INT(11) NULL DEFAULT '43' AFTER `CompanyID`;


CREATE TABLE IF NOT EXISTS `tblLanguage` (
	`LanguageID` int(11) NOT NULL AUTO_INCREMENT,
	`ISOCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
	`Language` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
	`flag` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
	`is_rtl` enum('Y','N') COLLATE utf8_unicode_ci DEFAULT 'N',
	PRIMARY KEY (`LanguageID`),
	UNIQUE KEY `ISO_Code` (`ISOCode`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


INSERT INTO `tblLanguage` (`LanguageID`, `ISOCode`, `Language`, `flag`, `is_rtl`) VALUES
	(1, 'ab', 'Abkhazian', NULL, 'N'),
	(2, 'aa', 'Afar', NULL, 'N'),
	(3, 'af', 'Afrikaans', NULL, 'N'),
	(4, 'ak', 'Akan', NULL, 'N'),
	(5, 'sq', 'Albanian', NULL, 'N'),
	(6, 'am', 'Amharic', NULL, 'N'),
	(7, 'ar', 'Arabic', 'sa.png', 'N'),
	(8, 'an', 'Aragonese', NULL, 'N'),
	(9, 'hy', 'Armenian', NULL, 'N'),
	(10, 'as', 'Assamese', NULL, 'N'),
	(11, 'av', 'Avaric', NULL, 'N'),
	(12, 'ae', 'Avestan', NULL, 'N'),
	(13, 'ay', 'Aymara', NULL, 'N'),
	(14, 'az', 'Azerbaijani', NULL, 'N'),
	(15, 'bm', 'Bambara', NULL, 'N'),
	(16, 'ba', 'Bashkir', NULL, 'N'),
	(17, 'eu', 'Basque', NULL, 'N'),
	(18, 'be', 'Belarusian', NULL, 'N'),
	(19, 'bn', 'Bengali(Bangla)', NULL, 'N'),
	(20, 'bh', 'Bihari', NULL, 'N'),
	(21, 'bi', 'Bislama', NULL, 'N'),
	(22, 'bs', 'Bosnian', NULL, 'N'),
	(23, 'br', 'Breton', NULL, 'N'),
	(24, 'bg', 'Bulgarian', NULL, 'N'),
	(25, 'my', 'Burmese', NULL, 'N'),
	(26, 'ca', 'Catalan', NULL, 'N'),
	(27, 'ch', 'Chamorro', NULL, 'N'),
	(28, 'ce', 'Chechen', NULL, 'N'),
	(29, 'ny', 'Chichewa,Chewa,Nyanja', NULL, 'N'),
	(30, 'zh', 'Chinese', NULL, 'N'),
	(31, 'zh-Hans', 'Chinese(Simplified)', NULL, 'N'),
	(32, 'zh-Hant', 'Chinese(Traditional)', NULL, 'N'),
	(33, 'cv', 'Chuvash', NULL, 'N'),
	(34, 'kw', 'Cornish', NULL, 'N'),
	(35, 'co', 'Corsican', NULL, 'N'),
	(36, 'cr', 'Cree', NULL, 'N'),
	(37, 'hr', 'Croatian', NULL, 'N'),
	(38, 'cs', 'Czech', NULL, 'N'),
	(39, 'da', 'Danish', NULL, 'N'),
	(40, 'dv', 'Divehi,Dhivehi,Maldivian', NULL, 'N'),
	(41, 'nl', 'Dutch', NULL, 'N'),
	(42, 'dz', 'Dzongkha', NULL, 'N'),
	(43, 'en', 'English', 'gb.png', 'N'),
	(44, 'eo', 'Esperanto', NULL, 'N'),
	(45, 'et', 'Estonian', NULL, 'N'),
	(46, 'ee', 'Ewe', NULL, 'N'),
	(47, 'fo', 'Faroese', NULL, 'N'),
	(48, 'fj', 'Fijian', NULL, 'N'),
	(49, 'fi', 'Finnish', NULL, 'N'),
	(50, 'fr', 'French', NULL, 'N'),
	(51, 'ff', 'Fula,Fulah,Pulaar,Pular', NULL, 'N'),
	(52, 'gl', 'Galician', NULL, 'N'),
	(53, 'gd', 'Gaelic(Scottish)', NULL, 'N'),
	(54, 'gv', 'Gaelic(Manx)', NULL, 'N'),
	(55, 'ka', 'Georgian', NULL, 'N'),
	(56, 'de', 'German', NULL, 'N'),
	(57, 'el', 'Greek', NULL, 'N'),
	(59, 'gn', 'Guarani', NULL, 'N'),
	(60, 'gu', 'Gujarati', NULL, 'N'),
	(61, 'ht', 'HaitianCreole', NULL, 'N'),
	(62, 'ha', 'Hausa', NULL, 'N'),
	(63, 'he', 'Hebrew', 'il.png', 'Y'),
	(64, 'hz', 'Herero', NULL, 'N'),
	(65, 'hi', 'Hindi', NULL, 'N'),
	(66, 'ho', 'HiriMotu', NULL, 'N'),
	(67, 'hu', 'Hungarian', NULL, 'N'),
	(68, 'is', 'Icelandic', NULL, 'N'),
	(69, 'io', 'Ido', NULL, 'N'),
	(70, 'ig', 'Igbo', NULL, 'N'),
	(71, 'id', 'Indonesian', NULL, 'N'),
	(72, 'ia', 'Interlingua', NULL, 'N'),
	(73, 'ie', 'Interlingue', NULL, 'N'),
	(74, 'iu', 'Inuktitut', NULL, 'N'),
	(75, 'ik', 'Inupiak', NULL, 'N'),
	(76, 'ga', 'Irish', NULL, 'N'),
	(77, 'it', 'Italian', NULL, 'N'),
	(78, 'ja', 'Japanese', NULL, 'N'),
	(79, 'jv', 'Javanese', NULL, 'N'),
	(80, 'kl', 'Kalaallisut,Greenlandic', NULL, 'N'),
	(81, 'kn', 'Kannada', NULL, 'N'),
	(82, 'kr', 'Kanuri', NULL, 'N'),
	(83, 'ks', 'Kashmiri', NULL, 'N'),
	(84, 'kk', 'Kazakh', NULL, 'N'),
	(85, 'km', 'Khmer', NULL, 'N'),
	(86, 'ki', 'Kikuyu', NULL, 'N'),
	(87, 'rw', 'Kinyarwanda(Rwanda)', NULL, 'N'),
	(88, 'rn', 'Kirundi', NULL, 'N'),
	(89, 'ky', 'Kyrgyz', NULL, 'N'),
	(90, 'kv', 'Komi', NULL, 'N'),
	(91, 'kg', 'Kongo', NULL, 'N'),
	(92, 'ko', 'Korean', NULL, 'N'),
	(93, 'ku', 'Kurdish', NULL, 'N'),
	(94, 'kj', 'Kwanyama', NULL, 'N'),
	(95, 'lo', 'Lao', NULL, 'N'),
	(96, 'la', 'Latin', NULL, 'N'),
	(97, 'lv', 'Latvian(Lettish)', NULL, 'N'),
	(98, 'li', 'Limburgish(Limburger)', NULL, 'N'),
	(99, 'ln', 'Lingala', NULL, 'N'),
	(100, 'lt', 'Lithuanian', NULL, 'N'),
	(101, 'lu', 'Luga-Katanga', NULL, 'N'),
	(102, 'lg', 'Luganda,Ganda', NULL, 'N'),
	(103, 'lb', 'Luxembourgish', NULL, 'N'),
	(105, 'mk', 'Macedonian', NULL, 'N'),
	(106, 'mg', 'Malagasy', NULL, 'N'),
	(107, 'ms', 'Malay', NULL, 'N'),
	(108, 'ml', 'Malayalam', NULL, 'N'),
	(109, 'mt', 'Maltese', NULL, 'N'),
	(110, 'mi', 'Maori', NULL, 'N'),
	(111, 'mr', 'Marathi', NULL, 'N'),
	(112, 'mh', 'Marshallese', NULL, 'N'),
	(113, 'mo', 'Moldavian', NULL, 'N'),
	(114, 'mn', 'Mongolian', NULL, 'N'),
	(115, 'na', 'Nauru', NULL, 'N'),
	(116, 'nv', 'Navajo', NULL, 'N'),
	(117, 'ng', 'Ndonga', NULL, 'N'),
	(118, 'nd', 'NorthernNdebele', NULL, 'N'),
	(119, 'ne', 'Nepali', NULL, 'N'),
	(120, 'no', 'Norwegian', NULL, 'N'),
	(121, 'nb', 'Norwegianbokmål', NULL, 'N'),
	(122, 'nn', 'Norwegiannynorsk', NULL, 'N'),
	(124, 'oc', 'Occitan', NULL, 'N'),
	(125, 'oj', 'Ojibwe', NULL, 'N'),
	(126, 'cu', 'OldChurchSlavonic,OldBulgarian', NULL, 'N'),
	(127, 'or', 'Oriya', NULL, 'N'),
	(128, 'om', 'Oromo(AfaanOromo)', NULL, 'N'),
	(129, 'os', 'Ossetian', NULL, 'N'),
	(130, 'pi', 'Pāli', NULL, 'N'),
	(131, 'ps', 'Pashto,Pushto', NULL, 'N'),
	(132, 'fa', 'Persian(Farsi)', NULL, 'N'),
	(133, 'pl', 'Polish', NULL, 'N'),
	(134, 'pt', 'Portuguese', NULL, 'N'),
	(135, 'pa', 'Punjabi(Eastern)', NULL, 'N'),
	(136, 'qu', 'Quechua', NULL, 'N'),
	(137, 'rm', 'Romansh', NULL, 'N'),
	(138, 'ro', 'Romanian', NULL, 'N'),
	(139, 'ru', 'Russian', NULL, 'N'),
	(140, 'se', 'Sami', NULL, 'N'),
	(141, 'sm', 'Samoan', NULL, 'N'),
	(142, 'sg', 'Sango', NULL, 'N'),
	(143, 'sa', 'Sanskrit', NULL, 'N'),
	(144, 'sc', 'Sardinian', NULL, 'N'),
	(145, 'sr', 'Serbian', NULL, 'N'),
	(146, 'sh', 'Serbo-Croatian', NULL, 'N'),
	(147, 'st', 'Sesotho', NULL, 'N'),
	(148, 'tn', 'Setswana', NULL, 'N'),
	(149, 'sn', 'Shona', NULL, 'N'),
	(150, 'ii', 'Sichuan Yi, Nuosu', NULL, 'N'),
	(151, 'sd', 'Sindhi', NULL, 'N'),
	(152, 'si', 'Sinhalese', NULL, 'N'),
	(154, 'sk', 'Slovak', NULL, 'N'),
	(155, 'sl', 'Slovenian', NULL, 'N'),
	(156, 'so', 'Somali', NULL, 'N'),
	(157, 'nr', 'SouthernNdebele', NULL, 'N'),
	(158, 'es', 'Spanish', 'es.png', 'N'),
	(159, 'su', 'Sundanese', NULL, 'N'),
	(160, 'sw', 'Swahili(Kiswahili)', NULL, 'N'),
	(161, 'ss', 'Swati, Siswati', NULL, 'N'),
	(162, 'sv', 'Swedish', NULL, 'N'),
	(163, 'tl', 'Tagalog', NULL, 'N'),
	(164, 'ty', 'Tahitian', NULL, 'N'),
	(165, 'tg', 'Tajik', NULL, 'N'),
	(166, 'ta', 'Tamil', NULL, 'N'),
	(167, 'tt', 'Tatar', NULL, 'N'),
	(168, 'te', 'Telugu', NULL, 'N'),
	(169, 'th', 'Thai', NULL, 'N'),
	(170, 'bo', 'Tibetan', NULL, 'N'),
	(171, 'ti', 'Tigrinya', NULL, 'N'),
	(172, 'to', 'Tonga', NULL, 'N'),
	(173, 'ts', 'Tsonga', NULL, 'N'),
	(174, 'tr', 'Turkish', NULL, 'N'),
	(175, 'tk', 'Turkmen', NULL, 'N'),
	(176, 'tw', 'Twi', NULL, 'N'),
	(177, 'ug', 'Uyghur', NULL, 'N'),
	(178, 'uk', 'Ukrainian', NULL, 'N'),
	(179, 'ur', 'Urdu', 'pk.png', 'Y'),
	(180, 'uz', 'Uzbek', NULL, 'N'),
	(181, 've', 'Venda', NULL, 'N'),
	(182, 'vi', 'Vietnamese', NULL, 'N'),
	(183, 'vo', 'Volapük', NULL, 'N'),
	(184, 'wa', 'Wallon', NULL, 'N'),
	(185, 'cy', 'Welsh', NULL, 'N'),
	(186, 'wo', 'Wolof', NULL, 'N'),
	(187, 'fy', 'WesternFrisian', NULL, 'N'),
	(188, 'xh', 'Xhosa', NULL, 'N'),
	(189, 'yi', 'Yiddish', NULL, 'N'),
	(190, 'yo', 'Yoruba', NULL, 'N'),
	(191, 'za', 'Zhuang,Chuang', NULL, 'N'),
	(192, 'zu', 'Zulu', NULL, 'N');


CREATE TABLE IF NOT EXISTS `tblTranslation` (
  `TranslationID` int(11) NOT NULL AUTO_INCREMENT,
  `LanguageID` int(11) DEFAULT NULL,
  `Language` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Translation` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TranslationID`)
)
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	AUTO_INCREMENT=1
;

-- add English Lables
INSERT INTO `tblTranslation` ( `LanguageID`, `Language`, `Translation`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES ( 43, 'English', '{"BUTTON_ACTIVATE_CAPTION":"Activate","BUTTON_ACTIVE_CAPTION":"Active","BUTTON_ADD_CAPTION":"Add New","BUTTON_APPROVE_CAPTION":"Approve","BUTTON_BACK_CAPTION":"Back","BUTTON_BROWSE_CAPTION":"Browse","BUTTON_CLOSE_CAPTION":"Close","BUTTON_DEACTIVATE_CAPTION":"Deactivate","BUTTON_DELETE_CAPTION":"Delete","BUTTON_DOWNLOAD_CAPTION":"Download","BUTTON_EDIT_CAPTION":"Edit","BUTTON_EXPORT_CAPTION":"Export","BUTTON_EXPORT_CSV_CAPTION":"CSV","BUTTON_EXPORT_EXCEL_CAPTION":"EXCEL","BUTTON_IMPORTCSV_CAPTION":"Import","BUTTON_INACTIVE_CAPTION":"Inactive","BUTTON_LOADING_CAPTION":"Loading...","BUTTON_LOGIN_CAPTION":"Login","BUTTON_NO_CAPTION":"No","BUTTON_OFF_CAPTION":"OFF","BUTTON_ON_CAPTION":"ON","BUTTON_PAY_CAPTION":"Pay","BUTTON_PAY_NOW_CAPTION":"Pay Now","BUTTON_REJECT_CAPTION":"Reject","BUTTON_SAVE_CAPTION":"Save","BUTTON_SEARCH_CAPTION":"Search","BUTTON_SEND_CAPTION":"Send","BUTTON_UPDATE_CAPTION":"Update","BUTTON_UPLOAD_CAPTION":"Upload","BUTTON_VIEW_CAPTION":"View","BUTTON_YES_CAPTION":"Yes","CUST_PANEL_BREADCRUMB_HOME":"Home","CUST_PANEL_FILTER_TITLE":"Filter","CUST_PANEL_HEAER_EDIT_PROFILE":"Edit Profile","CUST_PANEL_HEAER_LOGOUT":"Log Out","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_FILTER_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_FILTER_FIELD_START_DATE":"Start Date","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_AC_NAME":"Account Name","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_ATTACHMENT":"Attachment","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_CREATED_BY":"Created By","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_CREATED_DATE":"Created Date","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_DISPUTE_AMOUNT":"Dispute Amount","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_INVOICE_NUMBER":"Invoice Number","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_INVOICE_TYPE":"Invoice Type","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_NOTES":"Notes","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_FIELD_STATUS":"Status","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_DISPUTE_TITLE":"Dispute","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_ACTION":"Action","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_AMOUNT":"Amount","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_INVOICE":"Invoice","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_NOTES":"Notes","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_PAYMENT_DATE":"Payment Date","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_FIELD_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_MODAL_VIEW_PAYMENT_TITLE":"View Payment","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_AMOUNT":"AMOUNT","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_BALANCE_AFTER_OFFSET":"BALANCE AFTER OFFSET:","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_BALANCE_BROUGHT_FORWARD":"BALANCE BROUGHT FORWARD: ","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_DATE":"DATE","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_INVOICE":"INVOICE","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_NO":"NO","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_NO_DATA":"No data available in table","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_PAYMENT":"PAYMENT","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_PENDING_DISPUTE":"PENDING DISPUTE","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TBL_PERIOD":"PERIOD","CUST_PANEL_PAGE_ACCOUNT_STATEMENT_TITLE":"Statement of Account","CUST_PANEL_PAGE_ANALYSIS_DDL_LISTTYPE_LBL_MONTHLY":"Monthly","CUST_PANEL_PAGE_ANALYSIS_DDL_LISTTYPE_LBL_WEEKLY":"Weekly","CUST_PANEL_PAGE_ANALYSIS_DDL_LISTTYPE_LBL_YEARLY":"Yearly","CUST_PANEL_PAGE_ANALYSIS_DDL_PINEXT_LBL_BY_EXTENSION":"By Extension","CUST_PANEL_PAGE_ANALYSIS_DDL_PINEXT_LBL_BY_PINCODE":"By Pincode","CUST_PANEL_PAGE_ANALYSIS_DDL_TYPE_LBL_BY_COST":"By Cost","CUST_PANEL_PAGE_ANALYSIS_DDL_TYPE_LBL_BY_DURATION":"By Duration","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_COUNTRY":"Country","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_PREFIX":"Prefix","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_START_DATE":"Start date","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_TIMEZONE":"TimeZone","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_TRUNK":"Trunk","CUST_PANEL_PAGE_ANALYSIS_FILTER_FIELD_TYPE":"Type","CUST_PANEL_PAGE_ANALYSIS_HEADER_ANALYSIS_DATA_LBL_TOTAL_CALLS":"Total Calls","CUST_PANEL_PAGE_ANALYSIS_HEADER_ANALYSIS_DATA_LBL_TOTAL_MINUTES":"Total Minutes","CUST_PANEL_PAGE_ANALYSIS_HEADER_ANALYSIS_DATA_LBL_TOTAL_SALES":"Total Sales","CUST_PANEL_PAGE_ANALYSIS_HEADING_EXTENSIONS":"Top Extensions","CUST_PANEL_PAGE_ANALYSIS_HEADING_EXTENSIONS_REPORT":"Top Extensions Detail Report","CUST_PANEL_PAGE_ANALYSIS_HEADING_INVOICES_&_EXPENSES":"Invoices & Expenses","CUST_PANEL_PAGE_ANALYSIS_HEADING_INVOICES_&_EXPENSES_LBL_PAYMENT_RECEIVED":"Payment Received:","CUST_PANEL_PAGE_ANALYSIS_HEADING_INVOICES_&_EXPENSES_LBL_TOTAL_INVOICE":"Total Invoice:","CUST_PANEL_PAGE_ANALYSIS_HEADING_INVOICES_&_EXPENSES_LBL_TOTAL_OUTSTANDING":"Total Outstanding:","CUST_PANEL_PAGE_ANALYSIS_HEADING_PINCODE":"Top Pincodes","CUST_PANEL_PAGE_ANALYSIS_HEADING_PINCODE_REPORT":"Top Pincodes Detail Report","CUST_PANEL_PAGE_ANALYSIS_HEADING_PIN_GRID":"Pincodes Detail Report","CUST_PANEL_PAGE_ANALYSIS_INVOICE_BUTTON_INVOICE_RECEIVED":"Invoice Received","CUST_PANEL_PAGE_ANALYSIS_INVOICE_BUTTON_INVOICE_SENT":"Invoice Sent","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_ACCOUNT_BALANCE":"Account Balance","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_DUE_AMOUNT":"Due Amount","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_LOCUTORIOS_BALANCE":"Locutorios Total Balance","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_MOR_BALANCE":"MOR Total Balance","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_OUTSTANDING_PRIOD":"Outstanding For Selected Period","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_OVERDUE_AMOUNT":"Overdue Amount","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_PAYMENT_RECEIVED":"Payments Received","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_PAYMENT_SENT":"Payments Sent","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_PENDING_DISPUTE":"Pending Dispute","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_PENDING_ESTIMATE":"Pending Eastimate","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_TOTAL_INVOICE_RECEIVED":"Invoice Received","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_TOTAL_INVOICE_SENT":"Invoice Sent for selected period","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_TOTAL_OUTSTANDING":"Total Outstanding","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_TOTAL_PAYABLE":"Total Payable","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_TOTAL_RECEIVABLE":"Total Receivable","CUST_PANEL_PAGE_ANALYSIS_INVOICE_LBL_UNBILLED_AMOUNT":"Unbilled Amount","CUST_PANEL_PAGE_ANALYSIS_LBL_CALL_COST":"Call Cost","CUST_PANEL_PAGE_ANALYSIS_LBL_CALL_COUNT":"Call Count","CUST_PANEL_PAGE_ANALYSIS_LBL_CALL_MINUTES":"Call Minutes","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_AC_NAME":"Account Name","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_AMOUNT":"Amount","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_CREATEDBY":"CreatedBy","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_INVOICE_NO":"Invoice No","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_NOTES":"Notes","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TBL_PAYMENT_DATE":"Payment Date","CUST_PANEL_PAGE_ANALYSIS_MODAL_PAYMENT_RECEIVED_TITLE":"Payment Received","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_AC_NAME":"Account Name","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_GRAND_TOTAL":"Grand Total","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_INVOICE_NUMBER":"Invoice Number","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_ISSUE_DATE":"Issue Date","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_PAID_OS":"Paid\\/OS","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_PERIOD":"Period","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TBL_STATUS":"Status","CUST_PANEL_PAGE_ANALYSIS_MODAL_TOTAL_INVOICES_TITLE":"Total Invoices","CUST_PANEL_PAGE_ANALYSIS_PIN_GRID_TBL_DESTINATION_NUMBER":"Destination Number","CUST_PANEL_PAGE_ANALYSIS_PIN_GRID_TBL_NUMBER_OF_TIMES_DIALED":"Number of Times Dialed","CUST_PANEL_PAGE_ANALYSIS_PIN_GRID_TBL_TOTAL_COST":"Total Cost","CUST_PANEL_PAGE_ANALYSIS_TAB_CUSTOMER_TITLE":"Customer","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_LBL_BY_DESTINATION_BREAK_CALL_COST":"By Destination Break - Call Cost.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_LBL_BY_DESTINATION_BREAK_CALL_COUNT":"By Destination Break - Call Count.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_LBL_BY_DESTINATION_BREAK_CALL_MINUTES":"By Destination Break - Call Minutes.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_ACD":"ACD (mm:ss)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_ASR":"ASR (%)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_BILLED_DURATION_MIN":"Billed Duration (Min.)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_CHARGED_AMOUNT":"Charged Amount","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_DESTINATION_BREAK":"Destination Break","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_MARGIN":"Margin","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TBL_NO_OF_CALLS":"No. of Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_BREAK_TITLE":"Destination Break","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_LBL_BY_DESTINATION_CALL_COST":"By Destination - Call Cost.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_LBL_BY_DESTINATION_CALL_COUNT":"By Destination - Call Count.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_LBL_BY_DESTINATION_CALL_MINUTES":"By Destination - Call Minutes.","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_ACD":"ACD (mm:ss)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_ASR":"ASR (%)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_BILLED_DURATION_MIN":"Billed Duration (Min.)","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_CHARGED_AMOUNT":"Charged Amount","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_COUNTRY":"Country","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_MARGIN":"Margin","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TBL_NO_OF_CALLS":"No. of Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_DESTINATION_TITLE":"Destination","CUST_PANEL_PAGE_ANALYSIS_TAB_LONGEST_DURATIONS_CALLS_TITLE":"Longest Durations Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_MOST_DIALLED_NUMBER_TITLE":"Most Dialled Number","CUST_PANEL_PAGE_ANALYSIS_TAB_MOST_EXPENSIVE_CALLS_TITLE":"Most Expensive Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_LBL_BY_PREFIX_CALL_COST":"By Prefix - Call Cost.","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_LBL_BY_PREFIX_CALL_COUNT":"By Prefix - Call Count.","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_LBL_BY_PREFIX_CALL_MINUTES":"By Prefix - Call Minutes.","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_ACD":"ACD (mm:ss)","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_ASR":"ASR (%)","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_BILLED_DURATION_MIN":"Billed Duration (Min.)","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_CHARGED_AMOUNT":"Charged Amount","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_MARGIN":"Margin","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_NO_OF_CALLS":"No. of Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TBL_PREFIX":"Prefix","CUST_PANEL_PAGE_ANALYSIS_TAB_PREFIX_TITLE":"Prefix","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_LBL_BY_TRUNK_CALL_COST":"By Trunk - Call Cost.","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_LBL_BY_TRUNK_CALL_COUNT":"By Trunk - Call Count.","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_LBL_BY_TRUNK_CALL_MINUTES":"By Trunk - Call Minutes.","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_ACD":"ACD (mm:ss)","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_ASR":"ASR (%)","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_BILLED_DURATION_MIN":"Billed Duration (Min.)","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_CHARGED_AMOUNT":"Charged Amount","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_MARGIN":"Margin","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_NO_OF_CALLS":"No. of Calls","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TBL_TRUNK":"Trunk","CUST_PANEL_PAGE_ANALYSIS_TAB_TRUNK_TITLE":"Trunk","CUST_PANEL_PAGE_ANALYSIS_TAB_VENDOR_TITLE":"Vendor","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CDR_TYPE":"CDR Type","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CDR_TYPE_DLL_BOTH":"Both","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CDR_TYPE_DLL_INBOUND":"Inbound","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CDR_TYPE_DLL_OUTBOUND":"Outbound","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CLD":"CLD","CUST_PANEL_PAGE_CDR_FILTER_FIELD_CLI":"CLI","CUST_PANEL_PAGE_CDR_FILTER_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_CDR_FILTER_FIELD_PREFIX":"Prefix","CUST_PANEL_PAGE_CDR_FILTER_FIELD_SHOW":"Show","CUST_PANEL_PAGE_CDR_FILTER_FIELD_SHOW_DDL_NON_ZERO_COST":"Non Zero Cost","CUST_PANEL_PAGE_CDR_FILTER_FIELD_SHOW_DDL_ZERO_COST":"Zero Cost","CUST_PANEL_PAGE_CDR_FILTER_FIELD_START_DATE":"Start Date","CUST_PANEL_PAGE_CDR_FILTER_FIELD_TRUNK":"Trunk","CUST_PANEL_PAGE_CDR_FILTER_FIELD_TRUNK_DLL_OTHER":"Other","CUST_PANEL_PAGE_CDR_TBL_AC_NAME":"Account Name","CUST_PANEL_PAGE_CDR_TBL_AVG_RATE_MIN":"Avg. Rate\\/Min","CUST_PANEL_PAGE_CDR_TBL_BILLED_DURATION_SEC":"Billed Duration (sec)","CUST_PANEL_PAGE_CDR_TBL_CLD":"CLD","CUST_PANEL_PAGE_CDR_TBL_CLI":"CLI","CUST_PANEL_PAGE_CDR_TBL_CONNECT_TIME":"Connect Time","CUST_PANEL_PAGE_CDR_TBL_COST":"Cost","CUST_PANEL_PAGE_CDR_TBL_DISCONNECT_TIME":"Disconnect Time","CUST_PANEL_PAGE_CDR_TBL_PREFIX":"Prefix","CUST_PANEL_PAGE_CDR_TBL_TRUNK":"Trunk","CUST_PANEL_PAGE_CDR_TITLE":"CDR","CUST_PANEL_PAGE_CREDIT_CARD_FIELD_CARD_TYPE":"Card Type*","CUST_PANEL_PAGE_CREDIT_CARD_FIELD_CREDIT_CARD_NUMBER":"Credit Card Number *","CUST_PANEL_PAGE_CREDIT_CARD_FIELD_CVV_NUMBER":"CVV Number*","CUST_PANEL_PAGE_CREDIT_CARD_FIELD_EXPIRY_DATE":"Expiry Date *","CUST_PANEL_PAGE_CREDIT_CARD_FIELD_NAME_ON_CARD":"Name on card*","CUST_PANEL_PAGE_CREDIT_CARD_HEADING":"Credit Card Detail","CUST_PANEL_PAGE_CUSTOMERS_RATES_MSG_NO_INBOUND_RATE_TABLE_ASSIGN":"No Inbound Rate table assign","CUST_PANEL_PAGE_CUSTOMERS_RATES_MSG_PLEASE_SELECT_A_TRUNK":"Please Select a Trunk","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_INBOUND_RATE_TITLE":"Inbound Rate","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_CODE":"Code","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_COUNTRY":"Country","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_DESCRIPTION":"Description","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_EFFECTIVE":"Effective","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_EFFECTIVE_DLL_FUTURE":"Future","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_EFFECTIVE_DLL_NOW":"Now","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_ROUTING_PLAN":"Routing Plan","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_FIELD_TRUNK":"Trunk","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_FILTER_SEARCH_TITLE":"Search","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_CODE":"Code","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_CONNECTION_FEE":"Connection Fee","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_DESCRIPTION":"Description","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_EFFECTIVE_DATE":"Effective Date","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_INTERVAL_1":"Interval 1","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_INTERVAL_N":"Interval N","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_RATE":"Rate","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TBL_ROUTING_PLAN":"Routing plan","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_OUTBOUND_RATE_TITLE":"Outbound Rate","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SERVICE_RATE_FILTER_FIELD_RATE_TYPE":"Rate Type","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SERVICE_RATE_FILTER_FIELD_SERVICE":"Service","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SERVICE_RATE_TITLE":"Service Rate","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SETTINGS_TAB_OUTGOING_TBL_PREFIX":"Prefix","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SETTINGS_TAB_OUTGOING_TBL_TRUNK":"Trunk","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SETTINGS_TAB_OUTGOING_TITLE":"Outgoing","CUST_PANEL_PAGE_CUSTOMERS_RATES_TAB_SETTINGS_TITLE":"Settings","CUST_PANEL_PAGE_EDIT_PROFILE_TITLE":"Edit Profile","CUST_PANEL_PAGE_INVOICE_BANK_AC_TBL_CREATED_DATE":"Created Date","CUST_PANEL_PAGE_INVOICE_BANK_AC_TBL_DEFAULT":"Default","CUST_PANEL_PAGE_INVOICE_BANK_AC_TBL_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_INVOICE_BANK_AC_TBL_TITLE":"Title","CUST_PANEL_PAGE_INVOICE_BUTTON_PAY_NOW":"Pay Now","CUST_PANEL_PAGE_INVOICE_BUTTON_PAY_NOW_CONFIRM_MSG":"Are you sure you want to pay selected invoices?","CUST_PANEL_PAGE_INVOICE_BUTTON_PAY_NOW_ERROR_MSG":"please select invoice from one Account","CUST_PANEL_PAGE_INVOICE_CVIEW_BUTTON_DOWNLOAD_USAGE":"Download Usage","CUST_PANEL_PAGE_INVOICE_CVIEW_BUTTON_PRINT_INVOICE":"Print Invoice","CUST_PANEL_PAGE_INVOICE_CVIEW_LBL_DUE":"DUE","CUST_PANEL_PAGE_INVOICE_CVIEW_LBL_PAID":"Paid","CUST_PANEL_PAGE_INVOICE_CVIEW_MSG_ERROR_LOADING_INVOICE":"Error loading Invoice, Its need to regenerate.","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_END_DATE":"Issue Date End","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_HIDE_ZERO":"Hide Zero Value","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_NUMBER":"Number","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_OVERDUE":"Overdue","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_START_DATE":"Issue Date Start","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_TYPE":"Type","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_TYPE_DDL_BOTH":"Both","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_TYPE_DDL_INVOICE_RECEIVED":"Invoice Received","CUST_PANEL_PAGE_INVOICE_FILTER_FIELD_TYPE_DDL_INVOICE_SENT":"Invoice sent","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_ACTIVECARD_CONFIRM_MSG":"Are you sure you want to Active the Card?","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_DISABLECARD_CONFIRM_MSG":"Are you sure you want to Disable the Card?","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_LBL_TOTAL_PAYMENT":"Total Payment","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_MSG_TOTAL_OUTSTANDING_IS_LESS_OR_EQUAL_TO_ZERO":"Total outstanding is less or equal to zero","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TBL_CREATED_DATE":"Created Date","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TBL_DEFAULT":"Default","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TBL_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TBL_STATUS":"Status","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TBL_TITLE":"Title","CUST_PANEL_PAGE_INVOICE_MODAL_PAY_NOW_TITLE":"Pay Now","CUST_PANEL_PAGE_INVOICE_MODAL_PRINT_INVOICE_TITLE":"Print","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_ACCOUNT_NAME":"Account Name","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_DESCRIPTION":"Description","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_GRAND_TOTAL":"Grand Total","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_INVOICE_NUMBER":"Invoice Number","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_ISSUE_DATE":"Issue Date","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_FIELD_START_DATE":"Start Date","CUST_PANEL_PAGE_INVOICE_MODAL_VIEW_INVOICE_TITLE":"View Invoice","CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE":"Due Date:","CUST_PANEL_PAGE_INVOICE_PDF_LBL_FROM":"From","CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_DATE":"Invoice Date:","CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_FROM":"Invoice From","CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO":"Invoice No:","CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_PERIOD":"Invoice Period:","CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_TO":"Invoice To:","CUST_PANEL_PAGE_INVOICE_PDF_LBL_MANAGEMENT_REPORT":"Management Report","CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE":"Usage","CUST_PANEL_PAGE_INVOICE_PDF_TBL_ADDITIONAL":"Additional","CUST_PANEL_PAGE_INVOICE_PDF_TBL_BILLED_DURATION":"Billed Duration","CUST_PANEL_PAGE_INVOICE_PDF_TBL_BROUGHT_FORWARD":"Brought Forward","CUST_PANEL_PAGE_INVOICE_PDF_TBL_CALLS":"Calls","CUST_PANEL_PAGE_INVOICE_PDF_TBL_CHARGE":"Charge","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE":"Date","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_FROM":"Date From","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_TO":"Date To","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DESCRIPTION":"Description","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DISCOUNT":"Discount","CUST_PANEL_PAGE_INVOICE_PDF_TBL_DURATION":"Duration","CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL":"Grand Total","CUST_PANEL_PAGE_INVOICE_PDF_TBL_LINE_TOTAL":"Line Total","CUST_PANEL_PAGE_INVOICE_PDF_TBL_MINS":"Mins","CUST_PANEL_PAGE_INVOICE_PDF_TBL_PRICE":"Price","CUST_PANEL_PAGE_INVOICE_PDF_TBL_QUANTITY":"Quantity","CUST_PANEL_PAGE_INVOICE_PDF_TBL_RECURRING":"Recurring","CUST_PANEL_PAGE_INVOICE_PDF_TBL_SUB_TOTAL":"Sub Total","CUST_PANEL_PAGE_INVOICE_PDF_TBL_TITLE":"Title","CUST_PANEL_PAGE_INVOICE_PDF_TBL_TO":"To","CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_DUE":"Total Due","CUST_PANEL_PAGE_INVOICE_PDF_TBL_USAGE":"Usage","CUST_PANEL_PAGE_INVOICE_TBL_AC_NAME":"Account Name","CUST_PANEL_PAGE_INVOICE_TBL_GRAND_TOTAL":"Grand Total","CUST_PANEL_PAGE_INVOICE_TBL_INVOICE_NUMBER":"Invoice Number","CUST_PANEL_PAGE_INVOICE_TBL_INVOICE_STATUS":"Invoice Status","CUST_PANEL_PAGE_INVOICE_TBL_ISSUE_DATE":"Issue Date","CUST_PANEL_PAGE_INVOICE_TBL_PAID_OS":"Paid\\/OS","CUST_PANEL_PAGE_INVOICE_TITLE":"Invoice","CUST_PANEL_PAGE_LOGIN_HEADING_INVALID_LOGIN_MSG":"Enter correct login and password.","CUST_PANEL_PAGE_LOGIN_HEADING_INVALID_LOGIN_TITLE":"Invalid login","CUST_PANEL_PAGE_LOGIN_LBL_LOGIN_MSG":"Dear user, Please login below!","CUST_PANEL_PAGE_LOGIN_MSG_LOGGING_PROCESS":"logging in...","CUST_PANEL_PAGE_MONITOR_HEADING_TRAFFIC_BY_REGION":"Traffic By Region","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_ACD":"ACD (mm:ss)","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_ASR_IN_PERCENTAGE":"ASR (%)","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_BILLED_DURATION_MIN":"Billed Duration (Min.)","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_CHARGED_AMOUNT":"Charged Amount","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_MARGIN":"Margin","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_MARGIN_IN_PERCENTAGE":"Margin (%)","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_NO_OF_CALLS":"No. of Calls","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TBL_PREFIX":"Prefix","CUST_PANEL_PAGE_MONITOR_MODAL_TRAFFIC_BY_PREFIX_TITLE":"Traffic By Prefix","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_ACCOUNT_MANAGER":"Account Manager","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_ACCOUNT_MANAGER_EMAIL":"Email","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_ACCOUNT_MANAGER_NAME":"Name","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_MINUTES":"Minutes","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_SALES":"Sales","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_TODAY_MINUTES":"Minutes","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_TODAY_MINUTES_BY_HOUR":"Today Minutes by hour","CUST_PANEL_PAGE_MONITOR_RIGHT_SIDE_TODAY_SALES_BY_HOUR":"Today Sales by hour","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_BREAK_LBL_TOP_DESTINATION_BREAK_CALL_COST":"Top 10 Destination Break - Call Cost.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_BREAK_LBL_TOP_DESTINATION_BREAK_CALL_COUNT":"Top 10 Destination Break - Call Count.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_BREAK_LBL_TOP_DESTINATION_BREAK_CALL_MINUTES":"Top 10 Destination Break - Call Minutes.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_BREAK_TITLE":"Destination Break","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_LBL_TOP_DESTINATION_CALL_COST":"Top 10 Destination - Call Cost.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_LBL_TOP_DESTINATION_CALL_COUNT":"Top 10 Destination - Call Count.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_LBL_TOP_DESTINATION_CALL_MINUTES":"Top 10 Destination - Call Minutes.","CUST_PANEL_PAGE_MONITOR_TAB_DESTINATION_TITLE":"Destination","CUST_PANEL_PAGE_MONITOR_TAB_LONGEST_DURATIONS_CALLS_TBL_DURATION_SEC":"Duration(Sec)","CUST_PANEL_PAGE_MONITOR_TAB_LONGEST_DURATIONS_CALLS_TBL_NUMBER":"Number","CUST_PANEL_PAGE_MONITOR_TAB_LONGEST_DURATIONS_CALLS_TITLE":"Longest Durations Calls","CUST_PANEL_PAGE_MONITOR_TAB_MOST_DIALLED_NUMBER_TBL_NUMBER":"Number","CUST_PANEL_PAGE_MONITOR_TAB_MOST_DIALLED_NUMBER_TBL_NUMBER_OF_TIMES_DIALLED":"Number of Times Dialled","CUST_PANEL_PAGE_MONITOR_TAB_MOST_DIALLED_NUMBER_TBL_TOTAL_TALK_TIME_SEC":"Total Talk time (sec)","CUST_PANEL_PAGE_MONITOR_TAB_MOST_DIALLED_NUMBER_TITLE":"Most Dialled Number","CUST_PANEL_PAGE_MONITOR_TAB_MOST_EXPENSIVE_CALLS_TBL_COST":"Cost","CUST_PANEL_PAGE_MONITOR_TAB_MOST_EXPENSIVE_CALLS_TBL_DURATION_SEC":"Duration(Sec)","CUST_PANEL_PAGE_MONITOR_TAB_MOST_EXPENSIVE_CALLS_TBL_NUMBER":"Number","CUST_PANEL_PAGE_MONITOR_TAB_MOST_EXPENSIVE_CALLS_TITLE":"Most Expensive Calls","CUST_PANEL_PAGE_MONITOR_TAB_PREFIX_TITLE":"Prefix","CUST_PANEL_PAGE_MONITOR_TAB_PREFIX_TOP_PREFIX_CALL_COST":"Top 10 Prefix - Call Cost.","CUST_PANEL_PAGE_MONITOR_TAB_PREFIX_TOP_PREFIX_CALL_COUNT":"Top 10 Prefix - Call Count.","CUST_PANEL_PAGE_MONITOR_TAB_PREFIX_TOP_PREFIX_CALL_MINUTES":"Top 10 Prefix - Call Minutes.","CUST_PANEL_PAGE_MONITOR_TAB_TRUNK_TITLE":"Trunk","CUST_PANEL_PAGE_MONITOR_TAB_TRUNK_TOP_TRUNK_CALL_COST":"Top 10 Trunks - Call Cost.","CUST_PANEL_PAGE_MONITOR_TAB_TRUNK_TOP_TRUNK_CALL_COUNT":"Top 10 Trunks - Call Count.","CUST_PANEL_PAGE_MONITOR_TAB_TRUNK_TOP_TRUNK_CALL_MINUTES":"Top 10 Trunks - Call Minutes.","CUST_PANEL_PAGE_MOVEMENT_REPORT_FILTER_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_MOVEMENT_REPORT_FILTER_FIELD_START_DATE":"Start Date","CUST_PANEL_PAGE_MOVEMENT_REPORT_TBL_BALANCE":"Balance","CUST_PANEL_PAGE_MOVEMENT_REPORT_TBL_CONSUMPTION":"Consumption","CUST_PANEL_PAGE_MOVEMENT_REPORT_TBL_DATE":"Date","CUST_PANEL_PAGE_MOVEMENT_REPORT_TBL_PAYMENTS":"Payments","CUST_PANEL_PAGE_MOVEMENT_REPORT_TBL_TOTAL":"Total","CUST_PANEL_PAGE_MOVEMENT_REPORT_TITLE":"Movement Report","CUST_PANEL_PAGE_NEW_TICKET_DETAIL_HEADER":"Ticket Detail","CUST_PANEL_PAGE_NEW_TICKET_TITLE":"New Ticket","CUST_PANEL_PAGE_NOTICEBOARD_MSG_NO_UPDATES_FOUND":"No Updates Found.","CUST_PANEL_PAGE_NOTICEBOARD_MSG_UPDATED":"Updated","CUST_PANEL_PAGE_NOTIFICATIONS_BUTTON_ADD_NEW":"Add New","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_ACTIVE":"Active","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_BUSINESS_HOUR_FROM":"Business Hour From","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_BUSINESS_HOUR_TO":"Business Hour To","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_MAX_COST":"Max. Cost","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_MAX_DURATION_SEC":"Max. Duration(sec.)","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_NAME":"Name","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_SEND_COPY_TO":"Send Copy To","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_FIELD_TYPE":"Type","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_ADD_MONITORING_TITLE":"Add Monitoring","CUST_PANEL_PAGE_NOTIFICATIONS_MODAL_EDIT_MONITORING_TITLE":"Edit Monitoring","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_ACCOUNT_IS_REQUIRED":"Account is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_ALERTTYPE_IS_ALREADY_TAKEN":"AlertType is already taken.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_AT_LEAST_ONE_BLACKLIST_DESTINATION_IS_REQUIRED":"At least one blacklist destination is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_CLOSE_TIME_IS_REQUIRED":"Close Time is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_COST_IS_REQUIRED":"Cost is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_DURATION_IS_REQUIRED":"Duration is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_EMAIL_ADDRESS_IS_REQUIRED":"Email Address is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_LATEST_UPDATES":"Latest Updates!","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_NOTIFICATION_SUCCESSFULLY_CREATED":"Notification Successfully Created","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_NOTIFICATION_SUCCESSFULLY_DELETED":"Notification Successfully Deleted","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_NOTIFICATION_SUCCESSFULLY_UPDATED":"Notification Successfully Updated","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_OPEN_TIME_IS_REQUIRED":"Open Time is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_PROBLEM_CREATING_NOTIFICATION":"Problem Creating Notification.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_PROBLEM_DELETING_NOTIFICATION":"Problem Deleting Notification.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_PROBLEM_UPDATING_NOTIFICATION":"Problem Updating Notification.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_QOS_ALERT_INTERVAL_IS_REQUIRED":"Qos Alert Interval is required.","CUST_PANEL_PAGE_NOTIFICATIONS_MSG_QOS_ALERT_TIME_IS_REQUIRED":"Qos Alert Time is required.","CUST_PANEL_PAGE_NOTIFICATIONS_TAB_MONITORING":"Monitoring","CUST_PANEL_PAGE_NOTIFICATIONS_TBL_LAST_UPDATED":"Last Updated","CUST_PANEL_PAGE_NOTIFICATIONS_TBL_NAME":"Name","CUST_PANEL_PAGE_NOTIFICATIONS_TBL_STATUS":"Status","CUST_PANEL_PAGE_NOTIFICATIONS_TBL_TYPE":"Type","CUST_PANEL_PAGE_NOTIFICATIONS_TBL_UPDATED_BY":"Updated By","CUST_PANEL_PAGE_NOTIFICATIONS_TITLE":"Notifications","CUST_PANEL_PAGE_PAYMENTS_BUTTON_ADD_NEW":"Add New","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_ACTION":"Action","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_ACTION_DDL_PAYMENT_IN":"Payment In","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_ACTION_DDL_PAYMENT_OUT":"Payment out","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_END_DATE":"End Date","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_INVOICE_NO":"Invoice No","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD_DDL_BANK_TRANSFER":"BANK TRANSFER","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD_DDL_CASH":"CASH","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD_DDL_CHEQUE":"CHEQUE","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD_DDL_CREDIT_CARD":"CREDIT CARD","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_PAYMENT_METHOD_DDL_PAYPAL":"PAYPAL","CUST_PANEL_PAGE_PAYMENTS_FILTER_FIELD_START_DATE":"Start Date","CUST_PANEL_PAGE_PAYMENTS_MODAL_ADD_PAYMENT_TITLE":"Add New Payment","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_ACTION":"Action *","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_AMOUNT":"Amount *","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_INVOICE":"Invoice No","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_NOTES":"Notes","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_PAYMENT_DATE":"Payment Date *","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_PAYMENT_METHOD":"Payment Method *","CUST_PANEL_PAGE_PAYMENTS_MODAL_EDIT_PAYMENT_FIELD_PROOF_UPLOAD_EXTENSION":"Upload (.pdf, .jpg, .png, .gif)","CUST_PANEL_PAGE_PAYMENTS_MODAL_PAYMENT_NOTES_FIELD_NOTES":"Notes","CUST_PANEL_PAGE_PAYMENTS_MODAL_PAYMENT_NOTES_TITLE":"Payment Notes","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_ACTION":"Action","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_AC_NAME":"Account Name","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_AMOUNT":"Amount","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_INVOICE":"Invoice No","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_NOTES":"Notes","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_PAYMENT_DATE":"Payment Date","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_FIELD_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_PAYMENTS_MODAL_VIEW_PAYMENT_TITLE":"View Payment","CUST_PANEL_PAGE_PAYMENTS_MSG_PAYMENT_SUCCESSFULLY_UPDATED":"payment Successfully Updated","CUST_PANEL_PAGE_PAYMENTS_MSG_PROBLEM_CREATING_PAYMENT":"Problem Creating Payment.","CUST_PANEL_PAGE_PAYMENTS_MSG_YOU_HAVE_NOT_PERMISSION_TO_APPROVE_OR_REJECT":"You have not permission to Approve or reject","CUST_PANEL_PAGE_PAYMENTS_TBL_AMOUNT":"Amount","CUST_PANEL_PAGE_PAYMENTS_TBL_INVOICE_NO":"Invoice No","CUST_PANEL_PAGE_PAYMENTS_TBL_PAYMENT_DATE":"Payment Date","CUST_PANEL_PAGE_PAYMENTS_TBL_STATUS":"Status","CUST_PANEL_PAGE_PAYMENTS_TBL_TYPE":"Type","CUST_PANEL_PAGE_PAYMENTS_TITLE":"Payments","CUST_PANEL_PAGE_PAYMENT_METHOD_MSG_PAYMENT_METHOD_NOT_INTEGRATED":"Payment Method Not Integrated","CUST_PANEL_PAGE_PAYMENT_METHOD_MSG_PAYMENT_METHOD_PROFILE_SUCCESSFULLY_UPDATED":"Payment Method Profile Successfully Updated","CUST_PANEL_PAGE_PAYMENT_METHOD_MSG_PROBLEM_UPDATING_PAYMENT_METHOD_PROFILE":"Problem Updating Payment Method Profile.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_ADD_BANK_ACCOUNT":"Add Bank Account","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_ADD_NEW":"Add New","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_SET_DEFAULT":"Set Default","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_SET_DEFAULT_CARD_MSG":"Are you sure you want to set Default this Card?","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_SET_DEFAULT_MSG_PAYMENT_METHOD_PROFILE_SUCCESSFULLY_UPDATED":"Payment Method Profile Successfully Updated","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_SET_DEFAULT_MSG_PROBLEM_UPDATING_PAYMENT_METHOD_PROFILE":"Problem Updating Payment Method Profile.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_BUTTON_VERIFY":"Verify","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_FIELD_AC_HOLDER_NAME":"Account Holder Name*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_FIELD_AC_HOLDER_TYPE":"Account Holder Type*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_FIELD_AC_NUMBER":"Account Number *","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_FIELD_ROUTING_NUMBER":"Routing Number*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_FIELD_TITLE":"Title","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_BANK_AC_TITLE":"Add Bank Account","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_CARD_TYPE":"Card Type*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_CREDIT_CARD_NUMBER":"Credit Card Number *","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_CVV_NUMBER":"CVV Number*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_EXPIRY_DATE":"Expiry Date *","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_NAME_ON_CARD":"Name on card*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_FIELD_TITLE":"Title","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_MSG_PAYMENT_GATEWAY_NOT_SETUP":"Payment Gateway not setup","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_MSG_PLEASE_SELECT_PAYMENT_GATEWAY":"Please Select Payment Gateway","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_ADD_NEW_CARD_TITLE":"Add New Card","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_AC_HOLDER_TYPE":"Account Holder Type*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_AC_NAME":"Bank Account Name*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_AC_NUMBER":"Account Number *","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_BRANCH_CODE":"Branch Code*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_SAGEPAY_AC_NAME":"Account Name(Sage Pay System) *","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_FIELD_TITLE":"Title","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_SAGEPAY_ADD_NEW_BANK_AC_TITLE":"Add Bank Account","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_FIELD_MICRO_DEPOSIT1":"Micro Deposit 1*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_FIELD_MICRO_DEPOSIT1_MSG":"You can verify your customer\\u2019s routing and account numbers by sending their account two micro-deposits. Two small deposits will be made to their account. The transfers can take 3-4 business days to appear on their account. Once they\\u2019ve been received by the customer, the amounts for each deposit will need to be provided to you by the customer to verify that they have access to their account statement.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_FIELD_MICRO_DEPOSIT2":"Micro Deposit 2*","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_FIELD_MICRO_DEPOSIT2_MSG":"You can verify your customer\\u2019s routing and account numbers by sending their account two micro-deposits. Two small deposits will be made to their account. The transfers can take 3-4 business days to appear on their account. Once they\\u2019ve been received by the customer, the amounts for each deposit will need to be provided to you by the customer to verify that they have access to their account statement.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_LBL_MICRO_DEPOSIT":"Micro Deposit","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_MSG1":"* Both Deposit amounts in cents","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_MSG2":"* For live payments you have upto 10 tries to verify bank account after that bank account is unverifiable","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MODAL_VERIFY_BANK_AC_TITLE":"Verify Bank Account","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_CARD_ACTIVE_DEACTIVE_FAILED":"Problem Updating Card.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_CARD_ACTIVE_DEACTIVE_SUCCESSFULLY":"Card Successfully Updated","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_PAYMENT_GATEWAY_NOT_SETUP":"Payment Gateway not setup","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_PAYMENT_SUCCESSFULLY_CREATED":"Payment Successfully Created","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_PROBLEM_CREATING_PAYMENT":"Problem Creating Payment.","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_MSG_SAGE_DIRECT_DEBIT_NOT_SETUP_CORRECTLY":"Sage Direct Debit not setup correctly","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_ACTIVE_CARD_MSG":"Are you sure you want to Active the Card?","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_CREATED_DATE":"Created Date","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_DEFAULT":"Default","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_DISABLE_CARD_MSG":"Are you sure you want to Disable the Card?","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_STATUS":"Status","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_TITLE":"Title","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TBL_VERIFY":"Verify","CUST_PANEL_PAGE_PAYMENT_METHOD_PROFILES_TITLE":"Payment Method Profiles","CUST_PANEL_PAGE_PROFILE_HEADING_ACCOUNT_DETAILS":"Account Details","CUST_PANEL_PAGE_PROFILE_HEADING_VIEW_ACCOUNT":"View Account","CUST_PANEL_PAGE_PROFILE_MSG_ACCOUNT_SUCCESSFULLY_UPDATED":"Account Successfully Updated","CUST_PANEL_PAGE_PROFILE_MSG_PROBLEM_UPDATING_ACCOUNT":"Problem Updating Account.","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_ACCOUNT_NAME":"*Account Name","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_ACCOUNT_OWNER":"Account Owner","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_AC_NUMBER":"Account Number","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_BILLING_EMAIL":"Billing Email","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_CURRENCY":"Currency","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_CUSTOMER":"Customer","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_DESCRIPTION":"Description","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_EMPLOYEE":"Employee","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_FAX":"Fax","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_FIRST_NAME":"First Name","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_LAST_NAME":"Last Name","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_OWNERSHIP":"Ownership","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_PASSWORD":"Password","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_PHONE":"Phone","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_PICTURE":"Picture","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_STATUS":"Status","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_TIMEZONE":"Timezone","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_VAT_NUMBER":"VAT Number","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_VENDOR":"Vendor","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_LBL_WEBSITE":"Website","CUST_PANEL_PAGE_PROFILE_TAB_AC_DETAILS_TITLE":"Account Details","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_ADDRESS_LINE_1":"Address Line 1","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_ADDRESS_LINE_2":"Address Line 2","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_ADDRESS_LINE_3":"Address Line 3","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_CITY":"City","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_COUNTRY":"*Country","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_LBL_POST_ZIP_CODE":"Post\\/Zip Code","CUST_PANEL_PAGE_PROFILE_TAB_ADDRESS_INFORMATION_TITLE":"Address Information","CUST_PANEL_PAGE_PROFILE_TAB_BILLING_LBL_BILLING_TIMEZONE":"Billing Timezone*","CUST_PANEL_PAGE_PROFILE_TAB_BILLING_LBL_BILLING_TYPE":"Billing Type*","CUST_PANEL_PAGE_PROFILE_TAB_BILLING_LBL_TAX_RATE":"Tax Rate","CUST_PANEL_PAGE_PROFILE_TAB_BILLING_TITLE":"Billing","CUST_PANEL_PAGE_PROFILE_TAB_CONTACTS_TBL_CONTACT_NAME":"Contact Name","CUST_PANEL_PAGE_PROFILE_TAB_CONTACTS_TBL_EMAIL":"Email","CUST_PANEL_PAGE_PROFILE_TAB_CONTACTS_TBL_PHONE":"Phone","CUST_PANEL_PAGE_PROFILE_TAB_CONTACTS_TITLE":"Contacts","CUST_PANEL_PAGE_PROFILE_TAB_PAYMENT_INFORMATION_LBL_PAYMENT_DETAILS":"Payment Details","CUST_PANEL_PAGE_PROFILE_TAB_PAYMENT_INFORMATION_LBL_PAYMENT_METHOD":"Payment Method","CUST_PANEL_PAGE_PROFILE_TAB_PAYMENT_INFORMATION_TITLE":"Payment Information","CUST_PANEL_PAGE_PROFILE_TBL_FILE_NAME":"File Name","CUST_PANEL_PAGE_PROFILE_TITLE":"Profile","CUST_PANEL_PAGE_RATES_FILTER_FIELD_DESCRIPTION":"Description","CUST_PANEL_PAGE_RATES_FILTER_FIELD_PREFIX":"Prefix","CUST_PANEL_PAGE_RATES_TBL_CONNECTION_FEE":"Connection Fee","CUST_PANEL_PAGE_RATES_TBL_EFFECTIVE_DATE":"Effective Date","CUST_PANEL_PAGE_RATES_TBL_INTERVAL_1":"Interval 1","CUST_PANEL_PAGE_RATES_TBL_INTERVAL_N":"Interval N","CUST_PANEL_PAGE_RATES_TBL_NAME":"Name","CUST_PANEL_PAGE_RATES_TBL_PREFIX":"Prefix","CUST_PANEL_PAGE_RATES_TBL_RATE":"Rate","CUST_PANEL_PAGE_RATES_TITLE":"Rates","CUST_PANEL_PAGE_TICKETS_ADD_TICKET":"Ticket","CUST_PANEL_PAGE_TICKETS_BUTTON_ADD_NEW":"Add New","CUST_PANEL_PAGE_TICKETS_DETAIL_TAB_REQUESTER_INFO":"Requester Info","CUST_PANEL_PAGE_TICKETS_DETAIL_TAB_TICKET_PROPERTIES":"Ticket Properties","CUST_PANEL_PAGE_TICKETS_DETAIL_TITLE":"Detail","CUST_PANEL_PAGE_TICKETS_FILTER_FIELD_PRIORITY":"Priority","CUST_PANEL_PAGE_TICKETS_FILTER_FIELD_SEARCH":"Search","CUST_PANEL_PAGE_TICKETS_FILTER_FIELD_STATUS":"Status","CUST_PANEL_PAGE_TICKETS_MODAL_TICKET_EMAIL_ACTION_TITLE":"Ticket","CUST_PANEL_PAGE_TICKETS_MSG_FILE_ALREADY_SELECTED":"file already selected.","CUST_PANEL_PAGE_TICKETS_MSG_FILE_TYPE_NOT_ALLOWED":"file type not allowed.","CUST_PANEL_PAGE_TICKETS_MSG_MAX_FILE_SIZE_ERROR":"Filet is too large, Maximum file size :","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY":"Sorted by","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_ASCENDING":"Ascending","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_CREATED_AT":"Date Created","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_DESCENDING":"Descending","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_STATUS":"status","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_SUBJECT":"subject","CUST_PANEL_PAGE_TICKETS_TABLE_SORTED_BY_COLUMNS_UPDATED_AT":"Last Modified","CUST_PANEL_PAGE_TICKETS_TAB_CREATED":"Created:","CUST_PANEL_PAGE_TICKETS_TAB_PRIORITY":"Priority:","CUST_PANEL_PAGE_TICKETS_TAB_REQUESTER":"Requester:","CUST_PANEL_PAGE_TICKETS_TAB_SHORTNAME":"ShortName","CUST_PANEL_PAGE_TICKETS_TAB_STATUS":"Status:","CUST_PANEL_PAGE_TICKETS_TITLE":"Tickets","CUST_PANEL_PAGE_TICKETS_TOOLTIP_NEXT_TICKET":"Next Ticket","CUST_PANEL_PAGE_TICKETS_TOOLTIP_PREVIOUS_TICKET":"Previous Ticket","CUST_PANEL_PAGE_TICKETS_TOOLTIP_REPLY":"Reply","CUST_PANEL_PAGE_TICKET_FIELDS_1":"Requester1","CUST_PANEL_PAGE_TICKET_FIELDS_2":"Subject","CUST_PANEL_PAGE_TICKET_FIELDS_3":"Type","CUST_PANEL_PAGE_TICKET_FIELDS_3_VALUE_11":"NEON","CUST_PANEL_PAGE_TICKET_FIELDS_3_VALUE_7":"Other","CUST_PANEL_PAGE_TICKET_FIELDS_4":"Status","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_13":"Being Processed","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_14":"Awaiting your Reply","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_15":"This ticket has been Resolved","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_16":"This ticket has been Closed","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_17":"This ticket has been All Un Resolved","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_18":"Awaiting your Reply","CUST_PANEL_PAGE_TICKET_FIELDS_4_VALUE_19":"Being Processed","CUST_PANEL_PAGE_TICKET_FIELDS_5":"Priority","CUST_PANEL_PAGE_TICKET_FIELDS_6":"Neon First Group","CUST_PANEL_PAGE_TICKET_FIELDS_7":"Assigned to","CUST_PANEL_PAGE_TICKET_FIELDS_8":"Description","CUST_PANEL_PAGE_TICKET_FIELDS_PRIORITY_VAL_HIGH":"High","CUST_PANEL_PAGE_TICKET_FIELDS_PRIORITY_VAL_LOW":"Low","CUST_PANEL_PAGE_TICKET_FIELDS_PRIORITY_VAL_MEDIUM":"Medium","CUST_PANEL_PAGE_TICKET_FIELDS_PRIORITY_VAL_URGENT":"Urgent","CUST_PANEL_SIDENAV_MENU_ANALYSIS":"Analysis","CUST_PANEL_SIDENAV_MENU_BILLING":"Billing","CUST_PANEL_SIDENAV_MENU_BILLING__ACCOUNT_STATEMENT":"Account Statement","CUST_PANEL_SIDENAV_MENU_BILLING__ANALYSIS":"Analysis","CUST_PANEL_SIDENAV_MENU_BILLING__CRD":"CDR","CUST_PANEL_SIDENAV_MENU_BILLING__INVOICES":"Invoices","CUST_PANEL_SIDENAV_MENU_BILLING__PAYMENTS":"Payments","CUST_PANEL_SIDENAV_MENU_BILLING__PAYMENT_METHOD_PROFILES":"Payment Method Profiles","CUST_PANEL_SIDENAV_MENU_COMMERCIAL":"Commercial","CUST_PANEL_SIDENAV_MENU_DASHBOARD":"Dashboard","CUST_PANEL_SIDENAV_MENU_MOVEMENT_REPORT":"Movement Report","CUST_PANEL_SIDENAV_MENU_NOTICE_BOARD":"Notice Board","CUST_PANEL_SIDENAV_MENU_NOTIFICATIONS":"Notifications","CUST_PANEL_SIDENAV_MENU_PROFILE":"Profile","CUST_PANEL_SIDENAV_MENU_RATES":"Rates","CUST_PANEL_SIDENAV_MENU_TICKET_MANAGEMENT":"Ticket Management","CUST_PANEL_SIDENAV_MENU_TICKET_MANAGEMENT__TICKET":"Ticket","DATATABLE_PROCESSING":"Processing...","DROPDOWN_OPTION_ALL":"All","DROPDOWN_OPTION_SELECT":"Select","HTTP_STATUS_400_MSG":"Bad Request","HTTP_STATUS_403_MSG":"Forbidden","HTTP_STATUS_404_MSG":"Not Found","HTTP_STATUS_408_MSG":"Request Timeout","HTTP_STATUS_410_MSG":"Gone","HTTP_STATUS_500_MSG":"Oops Something went wrong please contact your system administrator","HTTP_STATUS_503_MSG":"Service Unavailable","HTTP_STATUS_504_MSG":"Gateway Timeout","MAIL_LBL_ATTACHMENTS":"Attachments","MAIL_LBL_BCC":"bcc","MAIL_LBL_CC":"cc","MAIL_LBL_FROM":"From","MAIL_LBL_MESSAGE":"Message","MAIL_LBL_REPLIED":"replied","MAIL_LBL_SUBJECT":"Subject","MAIL_LBL_TO":"to","MESSAGE_ADD_AN_ATTACHMENT":"Add an attachment\\u2026","MESSAGE_ARE_YOU_SURE":"Are you Sure?","MESSAGE_ATTACHMENTS_DELETE_SUCCESSFULLY":"Attachments delete successfully","MESSAGE_CONTENT_LOADION":"Content is loading...","MESSAGE_DATA_NOT_AVAILABLE":"No Data","MESSAGE_FAILED_TO_UPLOAD_FILE":"Failed to upload file.","MESSAGE_FIELD_IS_REQUIRED":"field is required","MESSAGE_NO_RESULT_FOUND":"No Result Found","MESSAGE_PLEASE_SUBMIT_REQUIRED_FIELDS":"Please submit required fields.","MESSAGE_PROBLEM_DELETING_EXCEPTION":"Problem Deleting. Exception:","MESSAGE_RECORD_NOT_FOUND":"Record Not Found","MESSAGE_SELECT_END_DATE":"Please Select a End date","MESSAGE_SELECT_START_DATE":"Please Select a Start date","MESSAGE_SOME_PROBLEM_OCCURRED":"Some problem occurred.","MESSAGE_SUCCESSFULLY_UPDATED":"Successfully Updated","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_ACD":"ACD:","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_ASR":"ASR:","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_CALLS":"Calls:","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_COST":"Cost:","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_MARGIN":"Margin(%):","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_MINUTES":"Minutes:","PAGE_DASHBOARD_DATA_WORLDMAP_LBL_TOTAL_MARGIN":"TotalMargin:","PAGE_INVOICE_MSG_ACCOUNT_PROFILE_NOT_SET":"Account Profile not set","PAGE_INVOICE_MSG_INVOICE_NOT_FOUND":"Invoice not found","PAGE_NOTIFICATIONS_FIELD_CALL_MONITOR_CUSTOMER_ALERT_TYPE_DDL_CALL_AFTER_BUSINESS_HOUR":"Call After Business Hour","PAGE_NOTIFICATIONS_FIELD_CALL_MONITOR_CUSTOMER_ALERT_TYPE_DDL_EXPENSIVE_CALLS":"Expensive Calls","PAGE_NOTIFICATIONS_FIELD_CALL_MONITOR_CUSTOMER_ALERT_TYPE_DDL_LONGEST_CALL":"Longest Call","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_AMERICAN_EXPRESS":"American Express","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_AUSTRALIAN_BANKCARD":"Australian BankCard","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_DINERS_CLUB":"Diners Club","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_DISCOVER":"Discover","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_JCB":"JCB","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_MASTERCARD":"MasterCard","PAGE_PAYMENT_FIELD_CREDIT_CARD_TYPE_DDL_VISA":"Visa","PAGE_TICKET_MSG_EMAIL_MESSAGE_REQUIRED":"The email message field is required","PAGE_TICKET_MSG_EMAIL_RECIPIENT_REQUIRED":"The email recipient is required","PAGE_TICKET_MSG_EMAIL_SUBJECT_REQUIRED":"The email Subject is required","PAGE_TICKET_MSG_FAILED_TO_UPDATED_DUE_DATE":"Failed To Updated Due Date.","PAGE_TICKET_MSG_INVALID_TICKET":"invalid Ticket.","PAGE_TICKET_MSG_NOTE_SUCCESSFULLY_CREATED":"Note Successfully Created","PAGE_TICKET_MSG_PROBLEM_SENDING_EMAIL":"Problem Sending Email","PAGE_TICKET_MSG_PROVIDE_VALID_INTEGER_VALUE":"Provide Valid Integer Value.","PAGE_TICKET_MSG_TICKET_NOT_FOUND":"Ticket not found.","PAGE_TICKET_MSG_TICKET_SUCCESSFULLY_CLOSED":"Ticket Successfully Closed","PAGE_TICKET_MSG_TICKET_SUCCESSFULLY_CREATED":"Ticket Successfully Created","PAGE_TICKET_MSG_TICKET_SUCCESSFULLY_DELETED":"Ticket Successfully Deleted","PAGE_TICKET_MSG_TICKET_SUCCESSFULLY_UPDATED":"Ticket Successfully Updated","PAGE_TICKET_MSG_YOU_HAVE_NOT_ACCESS_TO_UPDATE_THIS_TICKET":"You have not access to update this ticket","PAGE_WIDGETS_DATA_REPORT_TBL_ACCOUNT":"Account","PAGE_WIDGETS_DATA_REPORT_TBL_ACD":"ACD (mm:ss)","PAGE_WIDGETS_DATA_REPORT_TBL_ASR_IN_PERCENTAGE":"ASR (%)","PAGE_WIDGETS_DATA_REPORT_TBL_CALLS":"Calls","PAGE_WIDGETS_DATA_REPORT_TBL_COST":"Cost","PAGE_WIDGETS_DATA_REPORT_TBL_DESCRIPTION":"Description","PAGE_WIDGETS_DATA_REPORT_TBL_DESTINATION":"Destination","PAGE_WIDGETS_DATA_REPORT_TBL_GATEWAY":"Gateway","PAGE_WIDGETS_DATA_REPORT_TBL_MARGIN":"Margin","PAGE_WIDGETS_DATA_REPORT_TBL_MARGIN_IN_PERCENTAGE":"Margin (%)","PAGE_WIDGETS_DATA_REPORT_TBL_MINUTES":"Minutes","PAGE_WIDGETS_DATA_REPORT_TBL_PREFIX":"Prefix","PAGE_WIDGETS_DATA_REPORT_TBL_TRUNK":"Trunk","PAYMENT_MSG_BANK_ACCOUNT_NOT_VERIFIED":"Bank Account not verified.","PAYMENT_MSG_BOTH_MICRODEPOSIT_REQUIRED":"Both MicroDeposit Required.","PAYMENT_MSG_CUSTOMER_PROFILE_CREATED_ON_AUTHORIZE_NET":"Customer profile created on authorize.net","PAYMENT_MSG_CUSTOMER_PROFILE_DELETED_ON_AUTHORIZE_NET":"Customer profile deleted on authorize.net","PAYMENT_MSG_ENTER_VALID_CARD_NUMBER":"Please enter valid card number","PAYMENT_MSG_MONTH_MUST_BE_AFTER":"Month must be after ","PAYMENT_MSG_NOT_DELETE_DEFAULT_PROFILE":"You can not delete default profile. Please set as default an other profile first.","PAYMENT_MSG_NO_ACCOUNT_COUNTRY_AVAILABLE":"No account country available","PAYMENT_MSG_NO_ACCOUNT_CURRENCY_AVAILABLE":"No account currency available","PAYMENT_MSG_PAYMENT_METHOD_PROFILE_DELETED":"Payment Method Profile Successfully deleted. Profile deleted too.","PAYMENT_MSG_PAYMENT_METHOD_PROFILE_DELETED_AUTHORIZE_NET":"Payment Method Profile Successfully deleted","PAYMENT_MSG_PAYMENT_METHOD_PROFILE_SUCCESSFULLY_CREATED":"Payment Method Profile Successfully Created","PAYMENT_MSG_PAYMENT_PROFILE_CREATED_ON_AUTHORIZE_NET":"Payment profile created on authorize.net","PAYMENT_MSG_PAYMENT_PROFILE_DELETED_ON_AUTHORIZE_NET":"Payment profile deleted on authorize.net","PAYMENT_MSG_PROBLEM_CREATING_IN_VERIFY":"Problem creating in verify","PAYMENT_MSG_PROBLEM_CREATING_PAYMENT_METHOD_PROFILE":"Problem creating Payment Method Profile","PAYMENT_MSG_PROBLEM_DELETING_PAYMENT_METHOD_PROFILE":"Problem deleting Payment Method Profile.","PAYMENT_MSG_PROBLEM_SAVING_PAYMENT_METHOD_PROFILE":"Problem Saving Payment Method Profile.","PAYMENT_MSG_SHIPPING_ADDRESS_CREATED_ON_AUTHORIZE_NET":"Shipping Address created on authorize.net","PAYMENT_MSG_SHIPPING_ADDRESS_DELETED_ON_AUTHORIZE_NET":"Shipping Address deleted on authorize.net","PAYMENT_MSG_SHIPPING_ADDRESS_UPDATED_ON_AUTHORIZE_NET":"Shipping Address updated on authorize.net","PAYMENT_STRIPEACH_MSG_VERIFICATION_STATUS_IS":"verification status is ","PLACEHOLDER_EMAIL":"Email","PLACEHOLDER_PASSWORD":"Password","TABLE_COLUMN_ACTION":"Action","TABLE_LBL_FILTERED_FROM_MAX_TOTAL_RECORD":"(filtered from _MAX_ total records)","TABLE_LBL_RECORDS_PER_PAGE":"_MENU_ records per page","TABLE_LBL_SEARCH":"Search:","TABLE_LBL_SHOWING_EMPTY_RECORDS":"Showing 0 to 0 of 0 records","TABLE_LBL_SHOWING_RECORDS":"Showing _START_ to _END_ of _TOTAL_ records","TABLE_TOTAL":"TOTAL","THEMES_BHAVIN1NEON_SOFTCOM_FOOTERTEXT":"\\u00a9 2018 Reseller Code Desk","THEMES_BHAVIN1NEON_SOFTCOM_LOGIN_MSG":"Reseller Login","THEMES_BHAVIN1NEON_SOFTCOM_TITLE":"Reseller","THEMES_BHAVIN2NEON_SOFTCOM_FOOTERTEXT":"\\u00a9 2018 Xyz Reseller Code Desk","THEMES_BHAVIN2NEON_SOFTCOM_LOGIN_MSG":"Xyz Reseller Login","THEMES_BHAVIN2NEON_SOFTCOM_TITLE":"Xyz Reseller","THEMES_STAGINGNEON_SOFTCOM_FOOTERTEXT":"\\u00a9 2018 Staging Code Desk","THEMES_STAGINGNEON_SOFTCOM_LOGIN_MSG":"Welcome to the Flexible VoIP Customer Portal <br> By using this website you agree to our Terms and Conditions at http:\\/\\/www.flexiblevoip.com\\/terms.html. ","THEMES_STAGINGNEON_SOFTCOM_TITLE":"Staging"}', '2017-11-09 16:06:40', NULL, '2018-04-27 09:33:58', NULL);


INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1331, 'AccountSubscription.Add', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1330, 'AccountSubscription.Edit', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1329, 'AccountSubscription.Delete', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1328, 'AccountSubscription.View', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1327, 'AccountSubscription.All', 1, 3);

INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.*', 'AccountSubscriptionController.*', 1, 'Sumera Khan', NULL, '2017-05-30 09:53:27.000', '2017-05-30 09:53:27.000', 1327);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.ajax_datagrid', 'AccountSubscriptionController.ajax_datagrid', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1328);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.ajax_datagrid', 'AccountSubscriptionController.ajax_datagrid', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1328);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.ajax_datagrid_page', 'AccountSubscriptionController.ajax_datagrid_page', 1, 'Sumera Khan', NULL, '2017-05-30 09:53:27.000', '2017-05-30 09:53:27.000', 1328);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.delete', 'AccountSubscriptionController.delete', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1329);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.delete', 'AccountSubscriptionController.delete', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1329);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.GetAccountSubscriptions', 'AccountSubscriptionController.GetAccountSubscriptions', 1, 'Sumera Khan', NULL, '2017-05-30 09:53:27.000', '2017-05-30 09:53:27.000', 1328);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.main', 'AccountSubscriptionController.main', 1, 'Sumera Khan', NULL, '2017-05-30 09:53:27.000', '2017-05-30 09:53:27.000', 1328);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.store', 'AccountSubscriptionController.store', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1331);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.store', 'AccountSubscriptionController.store', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1331);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.update', 'AccountSubscriptionController.update', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1330);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('AccountSubscription.update', 'AccountSubscriptionController.update', 1, 'Sumera Saeed', NULL, '2015-11-28 09:37:35.000', '2015-11-28 09:37:35.000', 1330);

DROP PROCEDURE IF EXISTS `prc_applyRateTableTomultipleAccByService`;
DELIMITER //
CREATE PROCEDURE `prc_applyRateTableTomultipleAccByService`(
	IN `p_companyid` INT,
	IN `p_AccountIds` TEXT,
	IN `p_InboundRateTable` INT,
	IN `p_OutboundRateTable` INT,
	IN `p_CreatedBy` VARCHAR(100),
	IN `p_InBoundRateTableChecked` VARCHAR(5),
	IN `p_OutBoundRateTableChecked` VARCHAR(5),
	IN `p_checkedAll` VARCHAR(1),
	IN `p_select_serviceId` INT,
	IN `p_select_currency` INT,
	IN `p_select_ratetableid` INT,
	IN `p_select_accounts` TEXT
)
BEGIN

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
		DROP TEMPORARY TABLE IF EXISTS tmp_service_check;
				CREATE TEMPORARY TABLE tmp_service_check (
					ServiceID INT ,
					AccountID INT,
					CompanyID INT
				);
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_service;
				CREATE TEMPORARY TABLE tmp_service (
					ServiceID INT ,
					AccountID INT,
					CompanyID INT
				);
		
		DROP TEMPORARY TABLE IF EXISTS tmp_service_already;
				CREATE TEMPORARY TABLE tmp_service_already (
					CompanyID INT ,
					AccountID INT,
					ServiceID INT ,
					RateTableID INT,
					InRateTableName VARCHAR(100),
					Type INT
				);
		
		DROP TEMPORARY TABLE IF EXISTS tmp_tarrif;
				CREATE TEMPORARY TABLE tmp_tarrif (
					CompanyID INT ,
					AccountID INT,
					ServiceID INT ,
					RateTableID INT,
					InRateTableName VARCHAR(100),
					Type INT
				);
				

			IF (p_checkedAll = 'N') 
			THEN 
						
						/* Update As per selected acconut */
						
								
						DROP TEMPORARY TABLE IF EXISTS temp_acc_trunk;
							CREATE TEMPORARY TABLE temp_acc_trunk (
								Account_Service text,
								AccountID INT,
								ServiceID INT
						);
						DROP TEMPORARY TABLE IF EXISTS tmp_seprateAccountandService;
							CREATE TEMPORARY TABLE tmp_seprateAccountandService (
								Account_Service text,
								AccountID INT,
								ServiceID INT
						);
						
						/* Insert all comma seprate account with trunk in Account_Trunk field from Parameter "p_AccountIds" like 
						( Account_Trunk  AccountID   TrunkID
						  5009_7           NULL      NULL
						  5009_3           NULL      NULL
						  5009_5           NULL      NULL
						) */							
						set @sql = concat("insert into temp_acc_trunk (Account_Service) values ('", replace(( select distinct p_AccountIds as data), ",", "'),('"),"');");
						prepare stmt1 from @sql;
						execute stmt1;	
						
						
		
						/* Spit(_) Account with trunk field in AccountID and TrunkID like and insert into table (tmp_seprateAccountandTrunk)
							Account_Trunk  AccountID   TrunkID
						   5009_7           5009      7
						   5009_3           5009      3
						   5009_5           5009      5
						*/							
						insert into tmp_seprateAccountandService (Account_Service,AccountID,ServiceID)
						SELECT   Account_Service , SUBSTRING_INDEX(Account_Service,'_',1) AS AccountID , SUBSTRING_INDEX(Account_Service,'_',-1) AS ServiceID FROM temp_acc_trunk;
						
						-- select * from tmp_seprateAccountandService;
						
						
						insert into tmp_service_already (ServiceID,AccountID,CompanyID)  						                     
						select 
						ServiceID,
						AccountID,
						p_companyid as CompanyID
						from tmp_seprateAccountandService sep_acc ;
						
						-- select * from tmp_service_already;
						
						
						
						 if(p_InBoundRateTableChecked = 'on') THEN
								
								/* Insert OR Update RateTable Inbound Ratetable */
								
							   update tblAccountTariff t
								inner join tmp_service_already act on t.CompanyID=act.CompanyID AND t.ServiceID=act.ServiceID AND t.AccountID=act.AccountID
								set t.RateTableID=p_InboundRateTable,t.updated_at=NOW()
								where t.`Type`=2 AND t.ServiceID=act.ServiceID; 
								
								               		
								insert into tmp_tarrif (CompanyID,AccountID,ServiceID,RateTableID,Type)
								select distinct
								p_companyid as CompanyID,
								t.AccountID as AccountID,
								t.ServiceID as ServiceID,
								p_InboundRateTable as RateTableID,
								2 as Type
								from tmp_service_already t 
								left join tblAccountTariff on t.AccountID = tblAccountTariff.AccountID  AND tblAccountTariff.ServiceID=t.ServiceID
								where tblAccountTariff.AccountTariffID is null ;
								
								
								insert into tblAccountTariff (CompanyID,AccountID,ServiceID,RateTableID,Type,created_at)
								select distinct
								p_companyid as CompanyID,
								AccountID as AccountID,
								ServiceID,
								p_InboundRateTable as RateTableID,
								2 as Type,
								NOW() as created_at
								from tmp_tarrif;
							
							
						 END IF;
		
		
						 if(p_OutBoundRateTableChecked = 'on') THEN
						
								/* Insert OR Update RateTable OutBound Ratetable */
							
								update tblAccountTariff t
								inner join tmp_service_already act on t.CompanyID=act.CompanyID AND t.ServiceID=act.ServiceID AND t.AccountID=act.AccountID
								set t.RateTableID=p_OutboundRateTable,t.updated_at=NOW()
								where t.`Type`=1 AND t.ServiceID=act.ServiceID;
								
						
									
								
								insert into tmp_tarrif (CompanyID,AccountID,ServiceID,RateTableID,Type)
								select distinct
								p_companyid as CompanyID,
								t.AccountID as AccountID,
								t.ServiceID as ServiceID,
								p_OutboundRateTable as RateTableID,
								1 as Type
								from tmp_service_already t 
								left join tblAccountTariff on t.AccountID = tblAccountTariff.AccountID  AND tblAccountTariff.ServiceID=t.ServiceID AND tblAccountTariff.`Type`=1
								where tblAccountTariff.AccountTariffID is null ;
								
								select * from tmp_tarrif;
								
								insert into tblAccountTariff (CompanyID,AccountID,ServiceID,RateTableID,Type,created_at)
								select distinct
								p_companyid as CompanyID,
								AccountID as AccountID,
								ServiceID,
								p_OutboundRateTable as RateTableID,
								1 as Type,
								NOW() as created_at
								from tmp_tarrif;
							
							
						 END IF; 
						
						
						
						
			ELSE
			
			
			
			
				
					/* Upload or insert All Accounts as per filter like selectall( All pages ) */
						
					DROP TEMPORARY TABLE IF EXISTS tmp_allaccountByfilter;
							CREATE TEMPORARY TABLE tmp_allaccountByfilter (
								AccountID INT,
								ServiceID INT
						);
						
					 insert into tmp_allaccountByfilter (AccountID,ServiceID)						
							select distinct a.AccountID as AccountID,s.ServiceID as ServiceID
							from  tblAccount a 
							left join tblAccountService ass  on a.AccountID=ass.AccountID
							left join tblService s on ass.ServiceID=s.ServiceID				
							left join tblAccountTariff att on a.AccountID = att.AccountID AND s.ServiceID = att.ServiceID 								
							where 
							CASE 
								  WHEN (p_select_serviceId > 0 AND p_select_ratetableid > 0) THEN				
							
										att.RateTableID=p_select_ratetableid AND ass.ServiceID=p_select_serviceId AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
							
								  WHEN (p_select_serviceId > 0) THEN				
										ass.ServiceID=p_select_serviceId AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
										
								  WHEN (p_select_ratetableid > 0) THEN
								      a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
								  		
							     ELSE
								   	a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1	
							END
							AND  (p_select_accounts='' OR FIND_IN_SET(a.AccountID,p_select_accounts) != 0 ) AND  a.CurrencyId=p_select_currency	;
						
					select * from tmp_allaccountByfilter;
									
						
						
						insert into tmp_service_already (ServiceID,AccountID,CompanyID)  						                     
						select 
						ServiceID,
						AccountID,
						p_companyid as CompanyID
						from tmp_allaccountByfilter sep_acc ;
						
						-- select * from tmp_service_already;
								
						
						
						if(p_InBoundRateTableChecked =  'on') THEN
							
								
							   update tblAccountTariff t
								inner join tmp_service_already act on t.CompanyID=act.CompanyID AND t.ServiceID=act.ServiceID AND t.AccountID=act.AccountID
								set t.RateTableID=p_InboundRateTable,t.updated_at=NOW()
								where t.`Type`=2 AND t.ServiceID=act.ServiceID; 
								
								               		
								insert into tmp_tarrif (CompanyID,AccountID,ServiceID,RateTableID,Type)
								select distinct
								p_companyid as CompanyID,
								t.AccountID as AccountID,
								t.ServiceID as ServiceID,
								p_InboundRateTable as RateTableID,
								2 as Type
								from tmp_service_already t 
								left join tblAccountTariff on t.AccountID = tblAccountTariff.AccountID  AND tblAccountTariff.ServiceID=t.ServiceID
								inner join tmp_allaccountByfilter af on t.AccountID= af.AccountID
								where tblAccountTariff.AccountTariffID is null ;
								
								
								insert into tblAccountTariff (CompanyID,AccountID,ServiceID,RateTableID,Type,created_at)
								select distinct
								p_companyid as CompanyID,
								AccountID as AccountID,
								ServiceID,
								p_InboundRateTable as RateTableID,
								2 as Type,
								NOW() as created_at
								from tmp_tarrif;
							
							
						END IF;
		
		
						if(p_OutBoundRateTableChecked = 'on') THEN
							
								update tblAccountTariff t
								inner join tmp_service_already act on t.CompanyID=act.CompanyID AND t.ServiceID=act.ServiceID AND t.AccountID=act.AccountID
								set t.RateTableID=p_OutboundRateTable,t.updated_at=NOW()
								where t.`Type`=1 AND t.ServiceID=act.ServiceID;
								
						
									
								
								insert into tmp_tarrif (CompanyID,AccountID,ServiceID,RateTableID,Type)
								select distinct
								p_companyid as CompanyID,
								t.AccountID as AccountID,
								t.ServiceID as ServiceID,
								p_OutboundRateTable as RateTableID,
								1 as Type
								from tmp_service_already t 
								left join tblAccountTariff on t.AccountID = tblAccountTariff.AccountID  AND tblAccountTariff.ServiceID=t.ServiceID AND tblAccountTariff.`Type`=1
								inner join tmp_allaccountByfilter af on t.AccountID= af.AccountID
								where tblAccountTariff.AccountTariffID is null ;
								
								select * from tmp_tarrif;
								
								insert into tblAccountTariff (CompanyID,AccountID,ServiceID,RateTableID,Type,created_at)
								select distinct
								p_companyid as CompanyID,
								AccountID as AccountID,
								ServiceID,
								p_OutboundRateTable as RateTableID,
								1 as Type,
								NOW() as created_at
								from tmp_tarrif;
							
							
						 END IF; 
					
					 
					
					
					
					
					
					
					
			END IF;
		
		
                        
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_applyRateTableTomultipleAccByTrunk`;
DELIMITER //
CREATE PROCEDURE `prc_applyRateTableTomultipleAccByTrunk`(
	IN `p_companyid` INT,
	IN `p_AccountIds` TEXT,
	IN `p_ratetableId` INT,
	IN `p_CreatedBy` VARCHAR(100),
	IN `p_checkedAll` VARCHAR(1),
	IN `p_select_trunkId` INT,
	IN `p_select_currency` INT,
	IN `p_select_ratetableid` INT,
	IN `p_select_accounts` TEXT

)
ThisSP:BEGIN

	DECLARE v_codeDeckId int;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_AccountID_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_RateTableID_ INT;
	DECLARE v_Old_CodeDeckID_ INT;
	DECLARE v_Action_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT CodeDeckId INTO v_codeDeckId FROM  tblRateTable WHERE RateTableId = p_ratetableId;

	DROP TEMPORARY TABLE IF EXISTS tmp;
		CREATE TEMPORARY TABLE tmp (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			CustomerTrunkID INT ,
			CompanyID INT ,
			AccountID INT,
			TrunkID INT ,
			RateTableID INT,
			CodeDeckID INT,
			CreatedBy VARCHAR(100)
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_insert;
		CREATE TEMPORARY TABLE tmp_insert (
			CompanyID INT ,
			AccountID INT,
			TrunkID INT ,
			RateTableID INT,
			CreatedBy VARCHAR(100)
	);
		
			
         IF ( p_checkedAll = 'Y')  THEN
         
         	
				
					DROP TEMPORARY TABLE IF EXISTS tmp_allaccountByfilter;
						CREATE TEMPORARY TABLE tmp_allaccountByfilter (
							AccountID INT,
							RateTableID INT,
							TrunkID INT 
					);
         
					/* Get All Acount by filter (p_select_trunkId,p_select_currency,p_select_ratetableid,p_select_accounts)  */
				
						insert into tmp_allaccountByfilter (AccountID,RateTableID,TrunkID)					
						select distinct a.AccountID,r.RateTableId,t.TrunkID from tblAccount a
									join tblTrunk t
									left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
									left join tblRateTable r on ct.RateTableID=r.RateTableId
									where 
									CASE 
										WHEN (p_select_ratetableid > 0 AND p_select_trunkId > 0) THEN
										    r.TrunkID=p_select_trunkId AND r.RateTableId=p_select_ratetableid AND a.CompanyId=p_companyid  
										    
										WHEN (p_select_trunkId > 0) THEN
											 t.TrunkID=p_select_trunkId AND a.CompanyId=p_companyid 
										 
									   WHEN (p_select_ratetableid > 0) THEN
										    r.RateTableId=p_select_ratetableid AND a.CompanyId=p_companyid 
									   ELSE						
											 a.CompanyId=p_companyid				
										
									END
									AND (p_select_accounts='' OR FIND_IN_SET(a.AccountID,p_select_accounts) != 0 )
									AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
									AND a.CurrencyId=p_select_currency AND t.`Status`=1;								
								
					-- select * from tmp_allaccountByfilter;
					
					insert into tmp (CustomerTrunkID,AccountID,TrunkID,RateTableID,CodeDeckID)
					select distinct ct.CustomerTrunkID,a.AccountID,taf.TrunkID,ct.RateTableID,r.CodeDeckId
					from tblAccount a
					join tblTrunk t
					left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
					left join tblRateTable r on ct.RateTableID=r.RateTableId
					right join tmp_allaccountByfilter taf on a.AccountID=taf.AccountID
					where a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1 AND t.TrunkID=taf.TrunkID;
					
					select * from  tmp;
					 
					select * from  tmp where CustomerTrunkID IS NULL;
					select * from  tmp where CustomerTrunkID IS NOT NULL;
												
			
					
					
			ELSE
			
				
							/* Start the selected Account ratetable apply */
			
			
			
							DROP TEMPORARY TABLE IF EXISTS temp_acc_trunk;
								CREATE TEMPORARY TABLE temp_acc_trunk (
									Account_Trunk text,
									AccountID INT,
									TrunkID INT
							);
							DROP TEMPORARY TABLE IF EXISTS tmp_seprateAccountandTrunk;
								CREATE TEMPORARY TABLE tmp_seprateAccountandTrunk (
									Account_Trunk text,
									AccountID INT,
									TrunkID INT
							);
							
							/* Insert all comma seprate account with trunk in Account_Trunk field from Parameter "p_AccountIds" like 
							( Account_Trunk  AccountID   TrunkID
							  5009_7           NULL      NULL
							  5009_3           NULL      NULL
							  5009_5           NULL      NULL
							) */							
							set @sql = concat("insert into temp_acc_trunk (Account_Trunk) values ('", replace(( select distinct p_AccountIds as data), ",", "'),('"),"');");
							prepare stmt1 from @sql;
							execute stmt1;	
							
							
			
							/* Spit(_) Account with trunk field in AccountID and TrunkID like and insert into table (tmp_seprateAccountandTrunk)
								Account_Trunk  AccountID   TrunkID
							   5009_7           5009      7
							   5009_3           5009      3
							   5009_5           5009      5
							*/							
							insert into tmp_seprateAccountandTrunk (Account_Trunk,AccountID,TrunkID)
							SELECT   Account_Trunk , SUBSTRING_INDEX(Account_Trunk,'_',1) AS AccountID , SUBSTRING_INDEX(Account_Trunk,'_',-1) AS TrunkID FROM temp_acc_trunk;
							
							
							insert into tmp (CustomerTrunkID,AccountID,TrunkID,RateTableID,CodeDeckID)
							select distinct ct.CustomerTrunkID,a.AccountID,taf.TrunkID,ct.RateTableID,r.CodeDeckId
							from tblAccount a
							join tblTrunk t
							left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
							left join tblRateTable r on ct.RateTableID=r.RateTableId
							right join tmp_seprateAccountandTrunk taf on a.AccountID=taf.AccountID
							where a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1 AND t.TrunkID=taf.TrunkID;
							
															
				
							
			END IF;
			

			-- archive rate table rate by vasim seta starts -- V-4.17
			SET v_pointer_ = 1;
			SET v_rowCount_ = (SELECT COUNT(*) FROM tmp);
			
			WHILE v_pointer_ <= v_rowCount_
			DO
				SELECT AccountID,TrunkID,RateTableID,CodeDeckID INTO v_AccountID_,v_TrunkID_,v_RateTableID_,v_Old_CodeDeckID_ FROM tmp t WHERE t.RowID = v_pointer_;
				
				IF(v_codeDeckId = v_Old_CodeDeckID_)
				THEN
					SET v_Action_ = 2; -- change ratetable - will archive only ratetable rate
				ELSE
					SET v_Action_ = 1; -- change codedeck - will archive both ratetable rate and customer rate
				END IF;
				
				CALL prc_ChangeCodeDeckRateTable(v_AccountID_,v_TrunkID_,v_RateTableID_,p_CreatedBy, v_Action_);
				
				SET v_pointer_ = v_pointer_ + 1;
			END WHILE;			
			-- archive rate table rate by vasim seta ends -- V-4.17
			
			
			/*DELETE ct FROM tblCustomerRate ct
			inner join tmp on ct.TrunkID = tmp.TrunkID AND ct.CustomerID=tmp.AccountID;*/
			
		
			
			insert into tblCustomerTrunk (AccountID,RateTableID,CodeDeckId,CompanyID,TrunkID,IncludePrefix,RoutinePlanStatus,UseInBilling,Status,CreatedBy)
			select 
			sep_acc.AccountID,
			p_ratetableId as RateTableID,
			v_codeDeckId as CodeDeckId,
			p_companyid as CompanyID,
			sep_acc.TrunkID as TrunkID,
			0 as IncludePrefix,
			0 as RoutinePlanStatus,
			0 as UseInBilling,
			1 as Status,			
			p_CreatedBy as CreatedBy
			from tmp sep_acc
			left join tblCustomerTrunk ct on sep_acc.TrunkID = ct.TrunkID AND sep_acc.AccountID = ct.AccountID
			where sep_acc.CustomerTrunkID IS NULL;
			
			
			
			update tblCustomerTrunk 
			right join tmp sep_tmp on tblCustomerTrunk.AccountID=sep_tmp.AccountID AND tblCustomerTrunk.TrunkID=sep_tmp.TrunkID
			set tblCustomerTrunk.RateTableID=p_ratetableId,tblCustomerTrunk.CodeDeckId=v_codeDeckId,tblCustomerTrunk.`Status`=1, ModifiedBy=p_CreatedBy
			where  tblCustomerTrunk.CustomerTrunkID IS NOT NULL;	
								
		  
		    

						

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ArchiveOldCustomerRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldCustomerRate`(
	IN `p_AccountIds` LONGTEXT,
	IN `p_TrunkIds` LONGTEXT,
	IN `p_DeletedBy` VARCHAR(50)
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	/* SET EndDate of current time to older rates */
	-- for example there are 3 rates, today's date is 2018-04-11
	-- 1. Code 	Rate 	EffectiveDate
	-- 1. 91 	0.1 	2018-04-09
	-- 2. 91 	0.2 	2018-04-10
	-- 3. 91 	0.3 	2018-04-11
	/* Then it will delete 2018-04-09 and 2018-04-10 date's rate */
	UPDATE
		tblCustomerRate cr
	INNER JOIN tblCustomerRate cr2
		ON cr2.CustomerID = cr.CustomerID
		AND cr2.TrunkID = cr.TrunkID
		AND cr2.RateID = cr.RateID
	SET
		cr.EndDate=NOW()
	WHERE
		FIND_IN_SET(cr.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0 AND cr.EffectiveDate <= NOW() AND
		FIND_IN_SET(cr2.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr2.TrunkID,p_TrunkIds) != 0 AND cr2.EffectiveDate <= NOW() AND
		cr.EffectiveDate < cr2.EffectiveDate;


	/*1. Move Rates which EndDate <= now() */

	INSERT INTO tblCustomerRateArchive
	SELECT DISTINCT  null , -- Primary Key column
		`CustomerRateID`,
		`CustomerID`,
		`TrunkID`,
		`RateId`,
		`Rate`,
		`EffectiveDate`,
		IFNULL(`EndDate`,date(now())) as EndDate,
		now() as `created_at`,
		p_DeletedBy AS `created_by`,
		`LastModifiedDate`,
		`LastModifiedBy`,
		`Interval1`,
		`IntervalN`,
		`ConnectionFee`,
		`RoutinePlan`,
		concat('Ends Today rates @ ' , now() ) as `Notes`
	FROM
		tblCustomerRate
	WHERE
		FIND_IN_SET(CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(TrunkID,p_TrunkIds) != 0 AND EndDate <= NOW();


	DELETE  cr
	FROM tblCustomerRate cr
	inner join tblCustomerRateArchive cra
	on cr.CustomerRateID = cra.CustomerRateID
	WHERE  FIND_IN_SET(cr.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ArchiveOldRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldRateTableRate`(
	IN `p_RateTableIds` longtext,
	IN `p_DeletedBy` TEXT
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	/* SET EndDate of current time to older rates */
	-- for example there are 3 rates, today's date is 2018-04-11
	-- 1. Code 	Rate 	EffectiveDate
	-- 1. 91 	0.1 	2018-04-09
	-- 2. 91 	0.2 	2018-04-10
	-- 3. 91 	0.3 	2018-04-11
	/* Then it will delete 2018-04-09 and 2018-04-10 date's rate */
	UPDATE
		tblRateTableRate rtr
	INNER JOIN tblRateTableRate rtr2
		ON rtr2.RateTableId = rtr.RateTableId
		AND rtr2.RateID = rtr.RateID
	SET
		rtr.EndDate=NOW()
	WHERE
		FIND_IN_SET(rtr.RateTableId,p_RateTableIds) != 0 AND rtr.EffectiveDate <= NOW() AND
		FIND_IN_SET(rtr2.RateTableId,p_RateTableIds) != 0 AND rtr2.EffectiveDate <= NOW() AND
		rtr.EffectiveDate < rtr2.EffectiveDate AND rtr.RateTableRateID != rtr2.RateTableRateID;

	/*1. Move Rates which EndDate <= now() */

	INSERT INTO tblRateTableRateArchive
	SELECT DISTINCT  null , -- Primary Key column
		`RateTableRateID`,
		`RateTableId`,
		`RateId`,
		`Rate`,
		`EffectiveDate`,
		IFNULL(`EndDate`,date(now())) as EndDate,
		`updated_at`,
		now() as `created_at`,
		p_DeletedBy AS `created_by`,
		`ModifiedBy`,
		`Interval1`,
		`IntervalN`,
		`ConnectionFee`,
		concat('Ends Today rates @ ' , now() ) as `Notes`
	FROM tblRateTableRate
	WHERE  FIND_IN_SET(RateTableId,p_RateTableIds) != 0 AND EndDate <= NOW();

	/*
	IF (FOUND_ROWS() > 0) THEN
	select concat(FOUND_ROWS() ," Ends Today rates" ) ;
	END IF;
	*/

	DELETE  vr
	FROM tblRateTableRate vr
	inner join tblRateTableRateArchive vra
		on vr.RateTableRateID = vra.RateTableRateID
	WHERE  FIND_IN_SET(vr.RateTableId,p_RateTableIds) != 0;

	/*  IF (FOUND_ROWS() > 0) THEN
	select concat(FOUND_ROWS() ," sane rate " ) ;
	END IF;
	*/

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ChangeCodeDeckRateTable`;
DELIMITER //
CREATE PROCEDURE `prc_ChangeCodeDeckRateTable`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_RateTableID` INT,
	IN `p_DeletedBy` VARCHAR(50),
	IN `p_Action` INT
)
ThisSP:BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	-- p_Action = 1 = change codedeck = when change codedeck then archive both customer and ratetable rates
	-- p_Action = 2 = change ratetable = when change ratetable then archive only ratetable rates

	IF p_Action = 1
	THEN
		-- set ratetableid = 0, no rate table assign to trunk
		UPDATE
			tblCustomerTrunk
		SET
			RateTableID = 0
		WHERE
			AccountID = p_AccountID AND TrunkID = p_TrunkID;

		-- archive all customer rate against this account and trunk
		UPDATE
			tblCustomerRate
		SET
			EndDate = DATE(NOW())
		WHERE
			CustomerID = p_AccountID AND TrunkID = p_TrunkID;

		-- archive Customer Rates
		call prc_ArchiveOldCustomerRate (p_AccountID,p_TrunkID,p_DeletedBy);
	END IF;

	-- archive RateTable Rates
	INSERT INTO tblCustomerRateArchive
	(
		`AccountId`,
		`TrunkID`,
		`RateId`,
		`Rate`,
		`EffectiveDate`,
		`EndDate`,
		`created_at`,
		`created_by`,
		`updated_at`,
		`updated_by`,
		`Interval1`,
		`IntervalN`,
		`ConnectionFee`,
		`Notes`
	)
	SELECT
		p_AccountID AS `AccountId`,
		p_TrunkID AS `TrunkID`,
		`RateID`,
		`Rate`,
		`EffectiveDate`,
		DATE(NOW()) AS `EndDate`,
		DATE(NOW()) AS `created_at`,
		p_DeletedBy AS `created_by`,
		`updated_at`,
		`ModifiedBy`,
		`Interval1`,
		`IntervalN`,
		`ConnectionFee`,
		concat('Ends Today rates @ ' , now() ) as `Notes`
	FROM
		tblRateTableRate
	WHERE
		RateTableID = p_RateTableID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_checkDialstringAndDupliacteCode`;
DELIMITER //
CREATE PROCEDURE `prc_checkDialstringAndDupliacteCode`(
	IN `p_companyId` INT,
	IN `p_processId` VARCHAR(200) ,
	IN `p_dialStringId` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_dialcodeSeparator` VARCHAR(50)
)
ThisSP:BEGIN

	DECLARE totaldialstringcode INT(11) DEFAULT 0;
	DECLARE     v_CodeDeckId_ INT ;
	DECLARE totalduplicatecode INT(11);
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;


	DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_ ;
	CREATE TEMPORARY TABLE `tmp_VendorRateDialString_` (
		`TempVendorRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_2 ;
	CREATE TEMPORARY TABLE `tmp_VendorRateDialString_2` (
		`TempVendorRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_3 ;
	CREATE TEMPORARY TABLE `tmp_VendorRateDialString_3` (
		`TempVendorRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	CALL prc_SplitVendorRate(p_processId,p_dialcodeSeparator);

	IF  p_effectiveImmediately = 1
	THEN
		UPDATE tmp_split_VendorRate_
		SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

		UPDATE tmp_split_VendorRate_
		SET EndDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EndDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

	END IF;

	DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_2;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_split_VendorRate_2 as (SELECT * FROM tmp_split_VendorRate_);

	/*DELETE n1 FROM tmp_split_VendorRate_ n1
	INNER JOIN
	(
	SELECT MAX(TempVendorRateID) AS TempVendorRateID,EffectiveDate,Code
	FROM tmp_split_VendorRate_2 WHERE ProcessId = p_processId
	GROUP BY Code,EffectiveDate
	HAVING COUNT(*)>1
	)n2
	ON n1.Code = n2.Code
	AND n2.EffectiveDate = n1.EffectiveDate AND n1.TempVendorRateID < n2.TempVendorRateID
	WHERE n1.ProcessId = p_processId;*/

	-- v4.16
	INSERT INTO tmp_TempVendorRate_
	SELECT DISTINCT
		`TempVendorRateID`,
		`CodeDeckId`,
		`Code`,
		`Description`,
		`Rate`,
		`EffectiveDate`,
		`EndDate`,
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
									ELSE
										1
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
										1
									END
									END;


	IF  p_effectiveImmediately = 1
	THEN
		UPDATE tmp_TempVendorRate_
			SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
			WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

		UPDATE tmp_TempVendorRate_
			SET EndDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EndDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

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

		WHERE vr.ProcessId = p_processId
		AND ds.DialStringID IS NULL
		AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

		IF totaldialstringcode > 0
		THEN

		/*INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT CONCAT(Code ,' ', vr.DialStringPrefix , ' No PREFIX FOUND')
		FROM tmp_TempVendorRate_ vr
		LEFT JOIN tmp_DialString_ ds

		ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
		WHERE vr.ProcessId = p_processId
		AND ds.DialStringID IS NULL
		AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');*/

		INSERT INTO tblDialStringCode (DialStringID,DialString,ChargeCode,created_by)
		SELECT DISTINCT p_dialStringId,vr.DialStringPrefix, Code, 'RMService'
		FROM tmp_TempVendorRate_ vr
		LEFT JOIN tmp_DialString_ ds

		ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
		WHERE vr.ProcessId = p_processId
		AND ds.DialStringID IS NULL
		AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
		AND (vr.DialStringPrefix is not null AND vr.DialStringPrefix != '')
		AND (Code is not null AND Code != '');

		TRUNCATE tmp_DialString_;
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

		WHERE vr.ProcessId = p_processId
		AND ds.DialStringID IS NULL
		AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

		INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT CONCAT(Code ,' ', vr.DialStringPrefix , ' No PREFIX FOUND')
		FROM tmp_TempVendorRate_ vr
		LEFT JOIN tmp_DialString_ ds

		ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
		WHERE vr.ProcessId = p_processId
		AND ds.DialStringID IS NULL
		AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

		END IF;

		IF totaldialstringcode = 0
		THEN

			INSERT INTO tmp_VendorRateDialString_
				SELECT DISTINCT
				`TempVendorRateID`,
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
				`EndDate`,
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

			ON ( (tblTempVendorRate.Code = ds.ChargeCode AND tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' AND tblTempVendorRate.DialStringPrefix =  ds.DialString AND tblTempVendorRate.Code = ds.ChargeCode  ))

			WHERE tblTempVendorRate.ProcessId = p_processId
			AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');


			/*				INSERT INTO tmp_VendorRateDialString_2
			SELECT * FROM tmp_VendorRateDialString_; */

			INSERT INTO tmp_VendorRateDialString_2
			SELECT *  FROM tmp_VendorRateDialString_ where DialStringPrefix!='';

			Delete From tmp_VendorRateDialString_
			Where DialStringPrefix = ''
			And Code IN (Select DialStringPrefix From tmp_VendorRateDialString_2);

			INSERT INTO tmp_VendorRateDialString_3
			SELECT * FROM tmp_VendorRateDialString_;

			/*

			INSERT INTO tmp_VendorRateDialString_3
			SELECT vrs1.* from tmp_VendorRateDialString_2 vrs1
			LEFT JOIN tmp_VendorRateDialString_ vrs2 ON vrs1.Code=vrs2.Code AND vrs1.CodeDeckId=vrs2.CodeDeckId
			AND vrs1.EffectiveDate=vrs2.EffectiveDate
			AND vrs1.DialStringPrefix != vrs2.DialStringPrefix
			WHERE ( (vrs1.DialStringPrefix ='' AND vrs2.Code IS NULL) OR (vrs1.DialStringPrefix!='' AND vrs2.Code IS NOT NULL)); */

			DELETE  FROM tmp_TempVendorRate_ WHERE  ProcessId = p_processId;

			INSERT INTO tmp_TempVendorRate_(
				`TempVendorRateID`,
				CodeDeckId,
				Code,
				Description,
				Rate,
				EffectiveDate,
				EndDate,
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
				`TempVendorRateID`,
				`CodeDeckId`,
				`Code`,
				`Description`,
				`Rate`,
				`EffectiveDate`,
				`EndDate`,
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

			ON ( (tblTempVendorRate.Code = ds.ChargeCode and tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' and tblTempVendorRate.DialStringPrefix =  ds.DialString and tblTempVendorRate.Code = ds.ChargeCode  ))
			AND tblTempVendorRate.ProcessId = p_processId
			AND ds.Forbidden = 1
			SET tblTempVendorRate.Forbidden = 'B';

			UPDATE tmp_TempVendorRate_ as  tblTempVendorRate
			JOIN tmp_DialString_ ds

			ON ( (tblTempVendorRate.Code = ds.ChargeCode and tblTempVendorRate.DialStringPrefix = '') OR (tblTempVendorRate.DialStringPrefix != '' and tblTempVendorRate.DialStringPrefix =  ds.DialString and tblTempVendorRate.Code = ds.ChargeCode  ))
			AND tblTempVendorRate.ProcessId = p_processId
			AND ds.Forbidden = 0
			SET tblTempVendorRate.Forbidden = 'UB';

			END IF;

		END IF;

	END IF;


END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_checkSippyAutoAccountImportJobInterval`;
DELIMITER //
CREATE PROCEDURE `prc_checkSippyAutoAccountImportJobInterval`(
	IN `p_CompanyID` INT,
	IN `p_CurrentTime` DATETIME

)
BEGIN


	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	-- get after how many minutes next auto account import job to run.
	select value into @Interval from tblCompanyConfiguration where CompanyID = p_CompanyID AND `Key` = 'AUTO_SIPPY_ACCOUNT_IMPORT_INTERVAL';

	IF @Interval  > 0 THEN

		select DATE_ADD(created_at , INTERVAL @Interval MINUTE) into @NextRunTime from
		(
			select created_at from tblJob j
			inner join tblJobType t on j.JobTypeID = t.JobTypeID AND t.Code = 'MGA' -- Missing Gateway Account
			/*where j.CreatedBy = 'System'*/
			order by created_at desc limit 1
		) tmp	;

		IF @NextRunTime is not null AND @NextRunTime <= p_CurrentTime THEN

			select '1' as result , 'Run' as message;

		ELSE

			select '0' as result , concat( 'Wait till ' , @NextRunTime ) as message;

		END IF ;

	ELSE

		select '0' as result, 'Interval is not set' as message;


	END IF ;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CloneRateRuleInRateGenerator`;
DELIMITER //
CREATE PROCEDURE `prc_CloneRateRuleInRateGenerator`(
	IN `p_RateRuleID` INT,
	IN `p_CreatedBy` VARCHAR(100)
)
BEGIN
		select max(`Order`) into @max_order from tblRateRule 		where RateGeneratorId  = (		select RateGeneratorId 		from tblRateRule 		where RateRuleID  = p_RateRuleID	limit 1) ;

		insert into tblRateRule
		(	RateGeneratorId,	Code,	Description, `Order`,	created_at,	CreatedBy)
		select
				RateGeneratorId,	Code,	Description, (@max_order+1) , 	now(),	p_CreatedBy
		from tblRateRule
		where RateRuleID  = p_RateRuleID;

		select LAST_INSERT_ID() into @NewRateRuleID;

		insert into tblRateRuleSource
		(	RateRuleId,AccountId,created_at,CreatedBy )
		select
				@NewRateRuleID,AccountId,	now(), p_CreatedBy
		from tblRateRuleSource
		where RateRuleID  = p_RateRuleID;

		insert into tblRateRuleMargin
		(	RateRuleId,MinRate,MaxRate,AddMargin,FixedValue,created_at,CreatedBy )
		select
				@NewRateRuleID,MinRate,MaxRate,AddMargin,FixedValue,now(),p_CreatedBy
		from tblRateRuleMargin
		where RateRuleID  = p_RateRuleID;

		select @NewRateRuleID as RateRuleID;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_copyResellerData`;
DELIMITER //
CREATE PROCEDURE `prc_copyResellerData`(
	IN `p_companyid` INT,
	IN `p_resellerids` TEXT,
	IN `p_is_product` INT,
	IN `p_product` TEXT,
	IN `p_is_subscription` INT,
	IN `p_subscription` TEXT,
	IN `p_is_trunk` INT,
	IN `p_trunk` TEXT
)
BEGIN
	DECLARE v_resellerId_ INT; 
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ; 	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		
	END;		

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
		DROP TEMPORARY TABLE IF EXISTS tmp_currency;
		CREATE TEMPORARY TABLE tmp_currency (
			`ResellerCompanyID` INT,
			`CompanyId` INT,
			`Code` VARCHAR(50),
			`CurrencyID` INT,
			`NewCurrencyID` INT
		) ENGINE=InnoDB;	
				
		DROP TEMPORARY TABLE IF EXISTS tmp_product;
		CREATE TEMPORARY TABLE tmp_product (
			`ResellerCompanyID` INT,
			`CompanyId` INT,
			`Name` VARCHAR(50),
			`Code` VARCHAR(50),
			`Description` LONGTEXT,
			`Amount` DECIMAL(18,2),
			`Active` TINYINT(3) UNSIGNED,
			`Note` LONGTEXT,
			INDEX tmp_product_ResellerCompanyID (`ResellerCompanyID`),
			INDEX tmp_product_Code (`Code`)
	  	);			
				
		DROP TEMPORARY TABLE IF EXISTS tmp_BillingSubscription;
		CREATE TEMPORARY TABLE tmp_BillingSubscription (
				`ResellerCompanyID` INT,
				`CompanyID` INT(11),
				`Name` VARCHAR(50),
				`Description` LONGTEXT,
				`InvoiceLineDescription` VARCHAR(250),
				`ActivationFee` DECIMAL(18,2),						
				`CurrencyID` INT(11),
				`AnnuallyFee` DECIMAL(18,2),
				`QuarterlyFee` DECIMAL(18,2),
				`MonthlyFee` DECIMAL(18,2),
				`WeeklyFee` DECIMAL(18,2),
				`DailyFee` DECIMAL(18,2),
				`Advance` TINYINT(3) UNSIGNED,
				INDEX tmp_BillingSubscription_ResellerCompanyID (`ResellerCompanyID`),
				INDEX tmp_BillingSubscription_Name (`Name`)
		);	

		DROP TEMPORARY TABLE IF EXISTS tmp_Trunk;
		CREATE TEMPORARY TABLE tmp_Trunk (
				`ResellerCompanyID` INT,
				`Trunk` VARCHAR(50),
				`CompanyId` INT(11),
				`RatePrefix` VARCHAR(50),
				`AreaPrefix` VARCHAR(50),
				`Prefix` VARCHAR(50),
				`Status` TINYINT(1),
				INDEX tmp_Trunk_ResellerCompanyID (`ResellerCompanyID`),
				INDEX tmp_Trunk_TrunkName (`Trunk`)
			);	
			
			
		DROP TEMPORARY TABLE IF EXISTS tmp_resellers;
		CREATE TEMPORARY TABLE tmp_resellers (
			`CompanyID` INT,
			`ResellerID` INT,
			`ResellerCompanyID` INT,
			`AccountID` INT,
			`RowNo` INT,
			INDEX tmp_resellers_ResellerID (`ResellerID`),
			INDEX tmp_resellers_ResellerCompanyID (`ResellerCompanyID`),
			INDEX tmp_resellers_RowNo (`RowNo`)
		);			
				
				INSERT INTO tmp_resellers
				SELECT
					CompanyID,
					ResellerID,
					ChildCompanyID as ResellerCompanyID,
					AccountID,
					@row_num := @row_num+1 AS RowID
				FROM tblReseller,(SELECT @row_num := 0) x
				WHERE CompanyID = p_companyid
					  AND FIND_IN_SET(ResellerID,p_resellerids);
				
					
		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(distinct ResellerCompanyID ) FROM tmp_resellers);
					
		WHILE v_pointer_ <= v_rowCount_
		DO
					
					SET v_resellerId_ = (SELECT ResellerCompanyID FROM tmp_resellers rr WHERE rr.RowNo = v_pointer_);			
					
							/*
							INSERT INTO	tmp_currency(ResellerCompanyID,CompanyId,Code,CurrencyID)	
							SELECT v_resellerId_ as ResellerCompanyID,p_companyid as CompanyId,Code, CurrencyId FROM `tblCurrency` WHERE CompanyId	= p_companyid;	
							
							UPDATE tmp_currency tc LEFT JOIN tblCurrency c ON tc.Code=c.Code AND tc.ResellerCompanyID = v_resellerId_ AND c.CompanyId = v_resellerId_
									set NewCurrencyID = c.CurrencyId
							WHERE c.CurrencyId IS NOT NULL;		*/
					
					IF p_is_product =1
					THEN	
					
						INSERT INTO tmp_product(ResellerCompanyID,CompanyId,Name,Code,Description,Amount,Active,Note)
						SELECT DISTINCT v_resellerId_ as ResellerCompanyID,p_companyid as `CompanyId`,Name,Code,Description,Amount,Active,Note
							FROM RMBilling3.tblProduct
						WHERE CompanyId = p_companyid AND FIND_IN_SET(ProductID,p_product);
					
					END IF;
					
					IF p_is_subscription = 1
					THEN
					
						INSERT INTO tmp_BillingSubscription(`ResellerCompanyID`,`CompanyID`,Name,Description,InvoiceLineDescription,ActivationFee,CurrencyID,AnnuallyFee,QuarterlyFee,MonthlyFee,WeeklyFee,DailyFee,Advance)
						SELECT DISTINCT v_resellerId_ as ResellerCompanyID, `CompanyID`,Name,Description,InvoiceLineDescription,ActivationFee,CurrencyID,AnnuallyFee,QuarterlyFee,MonthlyFee,WeeklyFee,DailyFee,Advance
						FROM RMBilling3.tblBillingSubscription
						WHERE CompanyID = p_companyid AND FIND_IN_SET(SubscriptionID,p_subscription);
					
					END IF;
					
					/*
					IF p_is_trunk = 1
					THEN
					
					INSERT INTO tmp_Trunk(ResellerCompanyID,Trunk,CompanyId,RatePrefix,AreaPrefix,`Prefix`,Status)
							SELECT DISTINCT v_resellerId_ as ResellerCompanyID,Trunk,CompanyId,RatePrefix,AreaPrefix,`Prefix`,Status
								FROM tblTrunk
							WHERE CompanyId = p_companyid AND FIND_IN_SET(TrunkID,p_trunk);
							
					END IF;		*/
					
					 SET v_pointer_ = v_pointer_ + 1;			 
			
		END WHILE;
			
		
		IF p_is_product =1
		THEN	
					INSERT INTO RMBilling3.tblProduct (CompanyId,Name,Code,Description,Amount,Active,Note,CreatedBy,ModifiedBy,created_at,updated_at)
					SELECT DISTINCT tp.ResellerCompanyID as `CompanyId`,tp.Name,tp.Code,tp.Description,tp.Amount,tp.Active,tp.Note,'system' as CreatedBy,'system' as ModifiedBy,NOW(),NOW()
						FROM tmp_product tp 
							LEFT JOIN RMBilling3.tblProduct p
							ON tp.ResellerCompanyID = p.CompanyId
							AND tp.Code=p.Code
					WHERE p.ProductID IS NULL;		
		
		END IF;
		

		
		IF p_is_subscription = 1
		THEN
				
				INSERT INTO RMBilling3.tblBillingSubscription(`CompanyID`,Name,Description,InvoiceLineDescription,ActivationFee,CurrencyID,AnnuallyFee,QuarterlyFee,MonthlyFee,WeeklyFee,DailyFee,Advance,created_at,updated_at,ModifiedBy,CreatedBy)
				SELECT DISTINCT tb.ResellerCompanyID as `CompanyID`,tb.Name,tb.Description,tb.InvoiceLineDescription,tb.ActivationFee,CurrencyID,tb.AnnuallyFee,tb.QuarterlyFee,tb.MonthlyFee,tb.WeeklyFee,tb.DailyFee,tb.Advance,Now(),Now(),'system' as ModifiedBy,'system' as CreatedBy 
					FROM tmp_BillingSubscription tb 
						LEFT JOIN RMBilling3.tblBillingSubscription b
						ON tb.ResellerCompanyID = b.CompanyID
						AND tb.Name = b.Name
				WHERE b.SubscriptionID IS NULL;
		
		END IF;
		/*
		IF p_is_trunk =1
		THEN

				INSERT INTO tblTrunk (Trunk,CompanyId,RatePrefix,AreaPrefix,`Prefix`,Status,created_at,updated_at)
				SELECT DISTINCT tt.Trunk, tt.ResellerCompanyID as `CompanyId`,tt.RatePrefix,tt.AreaPrefix,tt.`Prefix`,tt.Status,Now(),Now()
				FROM tmp_Trunk tt
					LEFT JOIN tblTrunk tr ON tt.ResellerCompanyID = tr.CompanyId AND tt.Trunk = tr.Trunk
				WHERE tr.TrunkID IS NULL;
		
		END IF; */
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CronJobGenerateM2Sheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateM2Sheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_Effective,p_CustomDate);

		SELECT DISTINCT
	       Description  as `Destination`,
		   Code as `Prefix`,
		   Rate as `Rate(USD)`,
		   ConnectionFee as `Connection Fee(USD)`,
		   Interval1 as `Increment`,
		   IntervalN as `Minimal Time`,
		   '0:00:00 'as `Start Time`,
		   '23:59:59' as `End Time`,
		   '' as `Week Day`,
		   EffectiveDate  as `Effective from`,
			RoutinePlanName as `Routing through`
     FROM tmp_customerrateall_ ;

		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CronJobGenerateMorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateMorSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_Effective,p_CustomDate);

    DROP TEMPORARY TABLE IF EXISTS tmp_morrateall_;
    CREATE TEMPORARY TABLE tmp_morrateall_ (
        RateID INT,
        Country VARCHAR(155),
        CountryCode VARCHAR(50),
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50),
        SubCode VARCHAR(50)
    );

    INSERT INTO tmp_morrateall_
     SELECT
		  tc.RateID,
	  	  c.Country,
		  c.ISO3,
		  tc.Code,
		  tc.Description,
		  tc.Interval1,
        tc.IntervalN,
        tc.ConnectionFee,
        tc.RoutinePlanName,
        tc.Rate,
        tc.EffectiveDate,
        tc.LastModifiedDate,
        tc.LastModifiedBy,
        tc.CustomerRateId,
        tc.TrunkID,
        tc.RateTableRateId,
        tc.IncludePrefix,
        tc.Prefix,
        tc.RatePrefix,
        tc.AreaPrefix,
        'FIX' as `SubCode`
	  	 FROM tmp_customerrateall_ tc
	  			 INNER JOIN tblRate r ON tc.RateID = r.RateID
				 LEFT JOIN tblCountry c ON r.CountryID = c.CountryID
					;

	  UPDATE tmp_morrateall_
	  			SET SubCode='MOB'
	  			WHERE Description LIKE '%Mobile%';


		SELECT DISTINCT
	      Country as `Direction` ,
	      Description  as `Destination`,
		   Code as `Prefix`,
		   SubCode as `Subcode`,
		   CountryCode as `Country code`,
		   Rate as `Rate(EUR)`,
		   ConnectionFee as `Connection Fee(EUR)`,
		   Interval1 as `Increment`,
		   IntervalN as `Minimal Time`,
		   '0:00:00 'as `Start Time`,
		   '23:59:59' as `End Time`,
		   '' as `Week Day`
     FROM tmp_morrateall_;

		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateInsert`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerBulkRateInsert`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` INT ,
	IN `p_CodeDeckId` int,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(200) ,
	IN `p_CountryId` INT ,
	IN `p_CompanyId` INT ,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_ConnectionFee` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME ,
	IN `p_EndDate` DATETIME ,
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_RoutinePlan` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
BEGIN

 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	INSERT  INTO tblCustomerRate
	(
		RateID ,
		CustomerID ,
		TrunkID ,
		Rate ,
		ConnectionFee,
		EffectiveDate ,
		EndDate ,
		Interval1,
		IntervalN ,
		RoutinePlan,
		CreatedDate ,
		LastModifiedBy ,
		LastModifiedDate
	)
	SELECT
		r.RateID ,
		r.AccountId ,
		p_TrunkId ,
		p_Rate ,
		p_ConnectionFee,
		p_EffectiveDate ,
		p_EndDate ,
		p_Interval1,
		p_IntervalN,
		RoutinePlan,
		NOW() ,
		p_ModifiedBy ,
		NOW()
	FROM
	(
		SELECT
			RateID,Code,AccountId,CompanyID,CodeDeckId,Description,CountryID,RoutinePlan
		FROM
			tblRate ,
			(
				SELECT
					a.AccountId,
					CASE WHEN ctr.TrunkID IS NOT NULL
					THEN p_RoutinePlan
					ELSE NULL
					END AS RoutinePlan
				FROM tblAccount a
				INNER JOIN tblCustomerTrunk
					ON TrunkID = p_TrunkId
					AND a.AccountID    = tblCustomerTrunk.AccountID
					AND tblCustomerTrunk.Status = 1
				LEFT JOIN tblCustomerTrunk ctr
					ON ctr.TrunkID = p_TrunkId
					AND ctr.AccountID = a.AccountID
					AND ctr.RoutinePlanStatus = 1
				WHERE
					FIND_IN_SET(a.AccountID,p_AccountIdList) != 0
			) a
	) r
	LEFT OUTER JOIN
	(
		SELECT DISTINCT
			RateID ,
			c.CustomerID as AccountId ,
			c.TrunkID,
			c.EffectiveDate
		FROM
			tblCustomerRate c
		INNER JOIN tblCustomerTrunk
			ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
		WHERE
			FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId
	) cr ON r.RateID = cr.RateID
		AND r.AccountId = cr.AccountId
		AND r.CompanyID = p_CompanyId
		and cr.EffectiveDate = p_EffectiveDate
	WHERE
		r.CompanyID = p_CompanyId
		AND r.CodeDeckId=p_CodeDeckId
		AND ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
		AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
		AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
		AND cr.RateID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerBulkRateUpdate`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` INT ,
	IN `p_CodeDeckId` int,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(200) ,
	IN `p_CountryId` INT ,
	IN `p_CompanyId` INT ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_ConnectionFee` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME ,
	IN `p_EndDate` DATETIME ,
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_RoutinePlan` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
BEGIN

 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        PreviousRate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        CreatedDate DATETIME,
        CreatedBy VARCHAR(50),
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        TrunkID INT,
        RoutinePlan INT,
        INDEX tmp_CustomerRates__CustomerRateID (`CustomerRateID`)/*,
        INDEX tmp_CustomerRates__RateID (`RateID`),
        INDEX tmp_CustomerRates__TrunkID (`TrunkID`),
        INDEX tmp_CustomerRates__EffectiveDate (`EffectiveDate`)*/
    );

	-- insert rates in temp table which needs to update (based on grid filter)
	INSERT INTO tmp_CustomerRates_
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	)
	SELECT
		tblCustomerRate.CustomerRateID,
		tblCustomerRate.RateID,
		tblCustomerRate.CustomerID,
		p_Interval1 AS Interval1,
		p_IntervalN AS IntervalN,
		p_Rate AS Rate,
		tblCustomerRate.PreviousRate,
		p_ConnectionFee AS ConnectionFee,
		tblCustomerRate.EffectiveDate,
		tblCustomerRate.EndDate,
		tblCustomerRate.CreatedDate,
		tblCustomerRate.CreatedBy,
		NOW() AS LastModifiedDate,
		p_ModifiedBy AS LastModifiedBy,
		tblCustomerRate.TrunkID,
		tblCustomerRate.RoutinePlan
	FROM
		tblCustomerRate
	INNER JOIN (
		SELECT c.CustomerRateID,
			c.EffectiveDate,
			CASE WHEN ctr.TrunkID IS NOT NULL
			THEN p_RoutinePlan
			ELSE NULL
			END AS RoutinePlan
		FROM   tblCustomerRate c
		INNER JOIN tblCustomerTrunk
			ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
		INNER JOIN tblRate r
			ON c.RateID = r.RateID and r.CodeDeckId=p_CodeDeckId
		LEFT JOIN tblCustomerTrunk ctr
			ON ctr.TrunkID = c.TrunkID
			AND ctr.AccountID = c.CustomerID
			AND ctr.RoutinePlanStatus = 1
		WHERE  ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
			AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
			AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
			AND
			(
				( p_Effective = 'Now' AND c.EffectiveDate <= NOW() )
				OR
				( p_Effective = 'Future' AND c.EffectiveDate > NOW() )
				OR
				( p_Effective = 'CustomDate' AND c.EffectiveDate <= p_CustomDate AND (c.EndDate IS NULL OR c.EndDate > p_CustomDate) )
				OR
				p_Effective = 'All'
			)
			AND c.TrunkID = p_TrunkId
			AND FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0
	) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID; -- and cr.EffectiveDate = p_EffectiveDate;

	-- if custom date then remove duplicate rates of earlier date
	-- for examle custom date is 2018-05-03 today's date is 2018-05-01 and there are 2 rates available for 1 code
	-- Code	Date
	-- 1204	2018-05-01
	-- 1204	2018-05-03
	-- then it will delete 2018-05-01 from temp table and keeps only 2018-05-03 rate to update
	IF p_Effective = 'CustomDate'
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_2_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates_2_ AS (SELECT * FROM tmp_CustomerRates_);

		DELETE
			n1
		FROM
			tmp_CustomerRates_ n1,
			tmp_CustomerRates_2_ n2
		WHERE
			n1.EffectiveDate < n2.EffectiveDate AND
			n1.RateID = n2.RateID AND
			n1.CustomerID = n2.CustomerID AND
			(
				(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
				OR
				(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
			);
	END IF;

	-- update EndDate to Archive rates which needs to update
	UPDATE
		tblCustomerRate cr
	JOIN
		tmp_CustomerRates_ temp ON cr.CustomerRateID=temp.CustomerRateID
	SET
		cr.EndDate = NOW();

	-- archive rates which rates' EndDate < NOW()
	CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_ModifiedBy);

	-- insert rates in tblCustomerRate with updated values
	INSERT INTO tblCustomerRate
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	)
	SELECT
		NULL, -- primary key
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	FROM
		tmp_CustomerRates_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerRateClear`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateClear`(
	IN `p_AccountIdList` LONGTEXT,
	IN `p_TrunkId` INT,
	IN `p_CodeDeckId` int,
	IN `p_CustomerRateId` LONGTEXT,
	IN `p_code` VARCHAR(50),
	IN `p_description` VARCHAR(200),
	IN `p_CountryId` INT,
	IN `p_CompanyId` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	/*delete tblCustomerRate
	from tblCustomerRate
	INNER JOIN (
		SELECT c.CustomerRateID
		FROM   tblCustomerRate c
		INNER JOIN tblCustomerTrunk
			ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
		INNER JOIN tblRate r
			ON c.RateID = r.RateID and r.CodeDeckId=p_CodeDeckId
		WHERE c.TrunkID = p_TrunkId
			AND FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0
			AND ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
			AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
			AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
	) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID;*/

	UPDATE
		tblCustomerRate
	INNER JOIN (
		SELECT
			c.CustomerRateID
		FROM
			tblCustomerRate c
		INNER JOIN tblCustomerTrunk
			ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
		INNER JOIN tblRate r
			ON c.RateID = r.RateID and r.CodeDeckId=p_CodeDeckId
		WHERE
			c.TrunkID = p_TrunkId AND
			( -- if single or selected rates delete
			  p_CustomerRateId IS NOT NULL AND
        FIND_IN_SET(c.CustomerRateId,p_CustomerRateId) != 0
      )
			OR
			( -- if bulk rates delete
				p_CustomerRateId IS NULL AND
				FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0  AND
				( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%'))) AND
				( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%'))) AND
				( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
			)
	) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID
	SET
		tblCustomerRate.EndDate=NOW();

	CALL prc_ArchiveOldCustomerRate(p_AccountIdList,p_TrunkId,p_ModifiedBy);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerRateInsert`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateInsert`(
	IN `p_CompanyId` INT,
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` VARCHAR(100) ,
	IN `p_RateIDList` LONGTEXT,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_ConnectionFee` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME ,
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_RoutinePlan` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
ThisSP:BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	INSERT  INTO tblCustomerRate
	(
		RateID ,
		CustomerID ,
		TrunkID ,
		Rate ,
		ConnectionFee,
		EffectiveDate ,
		EndDate,
		Interval1,
		IntervalN ,
		RoutinePlan,
		CreatedDate ,
		LastModifiedBy ,
		LastModifiedDate
	)
	SELECT
		r.RateID,
		r.AccountId ,
		p_TrunkId ,
		p_Rate ,
		p_ConnectionFee,
		p_EffectiveDate ,
		NULL AS EndDate,
		p_Interval1,
		p_IntervalN,
		RoutinePlan,
		NOW() ,
		p_ModifiedBy ,
		NOW()
	FROM
	(
		SELECT
			tblRate.RateID ,
			a.AccountId,
			tblRate.CompanyID,
			RoutinePlan
		FROM
			tblRate ,
			(
				SELECT
					a.AccountId,
					CASE WHEN ctr.TrunkID IS NOT NULL
					THEN p_RoutinePlan
					ELSE 0
					END AS RoutinePlan
				FROM
					tblAccount a
				INNER JOIN tblCustomerTrunk ON TrunkID = p_TrunkId
					AND a.AccountId = tblCustomerTrunk.AccountID
					AND tblCustomerTrunk.Status = 1
				LEFT JOIN tblCustomerTrunk ctr
					ON ctr.TrunkID = p_TrunkId
					AND ctr.AccountID = a.AccountID
					AND ctr.RoutinePlanStatus = 1
				WHERE  FIND_IN_SET(a.AccountID,p_AccountIdList) != 0
			) a
		WHERE FIND_IN_SET(tblRate.RateID,p_RateIDList) != 0
	) r
	LEFT JOIN
	(
		SELECT DISTINCT
			c.RateID,
			c.CustomerID as AccountId ,
			c.TrunkID,
			c.EffectiveDate
		FROM
			tblCustomerRate c
		INNER JOIN tblCustomerTrunk ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
		WHERE FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId
	) cr ON r.RateID = cr.RateID
		AND r.AccountId = cr.AccountId
		AND r.CompanyID = p_CompanyId
		and cr.EffectiveDate = p_EffectiveDate
	WHERE
		r.CompanyID = p_CompanyId
		and cr.RateID is NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateUpdate`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` VARCHAR(100) ,
	IN `p_CustomerRateIDList` LONGTEXT,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_ConnectionFee` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME ,
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_RoutinePlan` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
ThisSP:BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        PreviousRate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        CreatedDate DATETIME,
        CreatedBy VARCHAR(50),
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        TrunkID INT,
        RoutinePlan INT,
        INDEX tmp_CustomerRates__CustomerRateID (`CustomerRateID`)/*,
        INDEX tmp_CustomerRates__RateID (`RateID`),
        INDEX tmp_CustomerRates__TrunkID (`TrunkID`),
        INDEX tmp_CustomerRates__EffectiveDate (`EffectiveDate`)*/
    );

	-- if p_EffectiveDate null means multiple rates update
	-- and if multiple rates update then we don't allow to change EffectiveDate
	-- we only allow EffectiveDate change when single edit

	-- insert rates in temp table which needs to update
	INSERT INTO tmp_CustomerRates_
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	)
	SELECT
		cr.CustomerRateID,
		cr.RateID,
		cr.CustomerID,
		p_Interval1 AS Interval1,
		p_IntervalN AS IntervalN,
		p_Rate AS Rate,
		cr.PreviousRate,
		p_ConnectionFee AS ConnectionFee,
		IFNULL(p_EffectiveDate,cr.EffectiveDate) AS EffectiveDate, -- if p_EffectiveDate null take exiting EffectiveDate
		cr.EndDate,
		cr.CreatedDate,
		cr.CreatedBy,
		NOW() AS LastModifiedDate,
		p_ModifiedBy AS LastModifiedBy,
		cr.TrunkID,
		CASE WHEN ctr.TrunkID IS NOT NULL
		THEN p_RoutinePlan
		ELSE NULL
		END AS RoutinePlan
	FROM
		tblCustomerRate cr
	LEFT JOIN tblCustomerTrunk ctr
		ON ctr.TrunkID = cr.TrunkID
		AND ctr.AccountID = cr.CustomerID
		AND ctr.RoutinePlanStatus = 1
	LEFT JOIN
	(
		SELECT
			RateID,CustomerID
		FROM
			tblCustomerRate
		WHERE
			EffectiveDate = p_EffectiveDate AND
			FIND_IN_SET(tblCustomerRate.CustomerRateID,p_CustomerRateIDList) = 0
	) crc ON crc.RateID=cr.RateID AND crc.CustomerID=cr.CustomerID
	WHERE
		FIND_IN_SET(cr.CustomerRateID,p_CustomerRateIDList) != 0 AND crc.RateID IS NULL;

	-- update EndDate to Archive rates which needs to update
	UPDATE
		tblCustomerRate cr
	JOIN
		tmp_CustomerRates_ temp ON cr.CustomerRateID=temp.CustomerRateID
	SET
		cr.EndDate = NOW();

	-- archive rates which rates' EndDate < NOW()
	CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_ModifiedBy);

	-- insert rates in tblCustomerRate with updated values
	INSERT INTO tblCustomerRate
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	)
	SELECT
		NULL, -- primary key
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		RoutinePlan
	FROM
		tmp_CustomerRates_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerRateUpdateBySelectedRateId`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateUpdateBySelectedRateId`(
	IN `p_CompanyId` INT,
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_RateIDList` LONGTEXT ,
	IN `p_TrunkId` VARCHAR(100) ,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_ConnectionFee` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME ,
	IN `p_EndDate` DATETIME,
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_RoutinePlan` INT,
	IN `p_ModifiedBy` VARCHAR(50)
)
ThisSP:BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	UPDATE  tblCustomerRate
	INNER JOIN (
		SELECT
			c.CustomerRateID,c.EffectiveDate,
			CASE WHEN ctr.TrunkID IS NOT NULL
			THEN p_RoutinePlan
			ELSE 0
			END AS RoutinePlan
		FROM
			tblCustomerRate c
		INNER JOIN tblCustomerTrunk ON tblCustomerTrunk.TrunkID = c.TrunkID
			AND tblCustomerTrunk.AccountID = c.CustomerID
			AND tblCustomerTrunk.Status = 1
			AND c.EffectiveDate = p_EffectiveDate
		LEFT JOIN tblCustomerTrunk ctr
			ON ctr.TrunkID = c.TrunkID
			AND ctr.AccountID = c.CustomerID
			AND ctr.RoutinePlanStatus = 1
	) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID and cr.EffectiveDate = p_EffectiveDate
	SET
		/*tblCustomerRate.PreviousRate = Rate ,
		tblCustomerRate.Rate = p_Rate ,
		tblCustomerRate.ConnectionFee = p_ConnectionFee,
		tblCustomerRate.EffectiveDate = p_EffectiveDate ,
		tblCustomerRate.Interval1 = p_Interval1,
		tblCustomerRate.IntervalN = p_IntervalN,
		tblCustomerRate.RoutinePlan = cr.RoutinePlan,*/
		tblCustomerRate.LastModifiedBy = p_ModifiedBy ,
		tblCustomerRate.LastModifiedDate = NOW(),
		tblCustomerRate.EndDate = NOW()
	WHERE tblCustomerRate.TrunkID = p_TrunkId
		AND FIND_IN_SET(tblCustomerRate.RateID,p_RateIDList) != 0
		AND FIND_IN_SET(tblCustomerRate.CustomerID,p_AccountIdList) != 0;

   CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_ModifiedBy);

        INSERT  INTO tblCustomerRate
                ( RateID ,
                  CustomerID ,
                  TrunkID ,
                  Rate ,
					   ConnectionFee,
                  EffectiveDate ,
                  EndDate,
                  Interval1,
				  		IntervalN ,
				  		RoutinePlan,
                  CreatedDate ,
                  LastModifiedBy ,
                  LastModifiedDate
                )
                SELECT  r.RateID,
                        r.AccountId ,
                        p_TrunkId ,
                        p_Rate ,
								p_ConnectionFee,
                        p_EffectiveDate ,
                        p_EndDate,
                        p_Interval1,
					    		p_IntervalN,
								RoutinePlan,
                        NOW() ,
                        p_ModifiedBy ,
                        NOW()
                FROM    ( SELECT    tblRate.RateID ,
                                    a.AccountId,
                                    tblRate.CompanyID,
									RoutinePlan
                          FROM      tblRate ,
                                    ( SELECT  a.AccountId,
													CASE WHEN ctr.TrunkID IS NOT NULL
														THEN p_RoutinePlan
														ELSE 0
													END AS RoutinePlan
                                      FROM tblAccount a
												  INNER JOIN tblCustomerTrunk ON TrunkID = p_TrunkId
                                      		AND a.AccountId = tblCustomerTrunk.AccountID
                                          AND tblCustomerTrunk.Status = 1
												LEFT JOIN tblCustomerTrunk ctr
													ON ctr.TrunkID = p_TrunkId
													AND ctr.AccountID = a.AccountID
													AND ctr.RoutinePlanStatus = 1
												WHERE  FIND_IN_SET(a.AccountID,p_AccountIdList) != 0
                                    ) a
                          WHERE FIND_IN_SET(tblRate.RateID,p_RateIDList) != 0
                        ) r
                        LEFT JOIN ( SELECT DISTINCT
                                                    c.RateID,
                                                    c.CustomerID as AccountId ,
                                                    c.TrunkID,
                                                    c.EffectiveDate
                                          FROM      tblCustomerRate c
                                                    INNER JOIN tblCustomerTrunk ON tblCustomerTrunk.TrunkID = c.TrunkID
                                                              AND tblCustomerTrunk.AccountID = c.CustomerID
                                                              AND tblCustomerTrunk.Status = 1
                                          WHERE FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId
                                        ) cr ON r.RateID = cr.RateID
                                                AND r.AccountId = cr.AccountId
                                                AND r.CompanyID = p_CompanyId
                                                and cr.EffectiveDate = p_EffectiveDate
                WHERE
                 r.CompanyID = p_CompanyId
                 and cr.RateID is NULL;

 --  	CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_ModifiedBy);

      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_editpreference`;
DELIMITER //
CREATE PROCEDURE `prc_editpreference`(
	IN `p_groupby` VARCHAR(50),
	IN `p_preference` INT,
	IN `p_accountId` INT,
	IN `p_trunk` INT,
	IN `p_rowcode` INT,
	IN `p_codedeckId` INT,
	IN `p_description` VARCHAR(200),
	IN `p_username` VARCHAR(50)



)
BEGIN

	DECLARE v_description VARCHAR(200);
	DECLARE v_vendorPreferenceId int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	
	DROP TEMPORARY TABLE IF EXISTS tmp_pref0;
	CREATE TEMPORARY TABLE tmp_pref0(	
		RateId INT
	);	
	
	DROP TEMPORARY TABLE IF EXISTS tmp_pref1;
	CREATE TEMPORARY TABLE tmp_pref1(	
		VendorPreferenceID INT,
		Preference INT
	);	
		
		IF p_groupby = 'description' THEN
		
				IF p_preference = 0 THEN
				
					INSERT INTO tmp_pref0
						select RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID 
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Description = p_description) tbl;
						    
					
						INSERT INTO tmp_pref1
						select VendorPreferenceID,Preference
						FROM (
						select vp.VendorPreferenceID,vp.Preference
							 from tblVendorPreference vp
							 	 inner join tmp_pref0 tmp0
								   on vp.RateId=tmp0.RateID 
						    where vp.AccountId = p_accountId AND vp.TrunkID=p_trunk) tbl1;
						
						select max(Preference) as Preference from tmp_pref1;				
						
				ELSE
				
				
					INSERT INTO tmp_pref0
						select RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID 
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Description = p_description) tbl;
						    
					/* Update preference */
					 UPDATE tblVendorPreference 
						INNER JOIN tmp_pref0 temp 
							ON tblVendorPreference.RateId = temp.RateID
						SET tblVendorPreference.Preference = p_preference,created_at=NOW(),CreatedBy=p_username
						WHERE tblVendorPreference.AccountId = p_accountId AND tblVendorPreference.TrunkID = p_trunk ;
						
					 /* insert preference if not in tblVendorPreference */		
					 insert into tblVendorPreference (AccountId,Preference,RateID,TrunkID,CreatedBy,created_at)    
						    select p_accountId as AccountId, p_preference as Preference,tmp0.RateID as RateId,p_trunk as TrunkID ,p_username as CreatedBy,NOW() as created_at
							 from  tmp_pref0 tmp0
							 	 left join tblVendorPreference vp
								   on vp.RateId=tmp0.RateID 
								   AND vp.AccountId = p_accountId AND vp.TrunkID=p_trunk
						    where  vp.VendorPreferenceID IS NULL;
		
								
				END IF;
		ELSE
				
				IF p_preference = 0 THEN
				
						select distinct vp.Preference
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID 
								 inner join tblVendorPreference vp
								   on r.RateID=vp.RateId
						    where vp.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Code = p_rowcode;									
						
				ELSE
					
					
					
						INSERT INTO tmp_pref0
						select RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID 
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Code = p_rowcode) tbl;
						    
					/* Update preference */
					 UPDATE tblVendorPreference 
						INNER JOIN tmp_pref0 temp 
							ON tblVendorPreference.RateId = temp.RateID
						SET tblVendorPreference.Preference = p_preference,created_at=NOW(),CreatedBy=p_username
						WHERE tblVendorPreference.AccountId = p_accountId AND tblVendorPreference.TrunkID = p_trunk ;
						
					 /* insert preference if not in tblVendorPreference */		
					 insert into tblVendorPreference (AccountId,Preference,RateID,TrunkID,CreatedBy,created_at)    
						    select p_accountId as AccountId, p_preference as Preference,tmp0.RateID as RateId,p_trunk as TrunkID ,p_username as CreatedBy,NOW() as created_at
							 from  tmp_pref0 tmp0
							 	 left join tblVendorPreference vp
								   on vp.RateId=tmp0.RateID 
								   AND vp.AccountId = p_accountId AND vp.TrunkID=p_trunk
						    where  vp.VendorPreferenceID IS NULL;
						    
					
								
				END IF;
		
		END IF;
		
			 

		
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetAccountLogs`;
DELIMITER //
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
				d.ColumnName,
				d.OldValue AS OldValue,
				d.NewValue AS NewValue,
				d.created_at,
				d.created_by
			FROM tblAuditDetails AS d
			LEFT JOIN tblAuditHeader AS h
				ON h.AuditHeaderID = d.AuditHeaderID
			LEFT JOIN tblAccountBilling AS ab
				ON h.ParentColumnID = ab.AccountBillingID	
			LEFT JOIN tblAccount AS a
				ON ab.AccountID = a.AccountID
			WHERE   
				h.Type = 'accountbilling' AND 
				h.ParentColumnName = 'AccountBillingID' AND 
				ab.AccountID = p_AccountID
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
				d.ColumnName,
				d.OldValue AS OldValue,
				d.NewValue AS NewValue,
				d.created_at,
				d.created_by
			FROM tblAuditDetails AS d
			LEFT JOIN tblAuditHeader AS h
				ON h.AuditHeaderID = d.AuditHeaderID
			LEFT JOIN tblAccountBilling AS ab
				ON h.ParentColumnID = ab.AccountBillingID	
			LEFT JOIN tblAccount AS a
				ON ab.AccountID = a.AccountID
			WHERE   
				h.Type = 'accountbilling' AND 
				h.ParentColumnName = 'AccountBillingID' AND 
				ab.AccountID = p_AccountID
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
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetAccounts`;
DELIMITER //
CREATE PROCEDURE `prc_GetAccounts`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_IsVendor` int ,
	IN `p_isCustomer` int ,
	IN `p_isReseller` INT,
	IN `p_ResellerID` INT,
	IN `p_activeStatus` int,
	IN `p_VerificationStatus` int,
	IN `p_AccountNo` VARCHAR(100),
	IN `p_ContactName` VARCHAR(50),
	IN `p_AccountName` VARCHAR(50),
	IN `p_tags` VARCHAR(50),
	IN `p_IPCLI` VARCHAR(50),
	IN `p_low_balance` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	DECLARE v_raccountids TEXT;
	DECLARE v_resellercompanyid int;
	SET v_raccountids = '';
	SET v_resellercompanyid = 0;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM tblReseller WHERE ResellerID=p_ResellerID;
		
		SELECT ChildCompanyID INTO v_resellercompanyid FROM tblReseller WHERE ResellerID=p_ResellerID;		
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;
		
	END IF;

	IF p_isExport = 0
	THEN

		SELECT
			tblAccount.AccountID,
			tblAccount.Number,
			tblAccount.AccountName,
			CONCAT(tblAccount.FirstName,' ',tblAccount.LastName) as Ownername,
			tblAccount.Phone,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.SOAOffset,0),v_Round_)) as OutStandingAmount,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as UnbilledAmount,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_)) as PermanentCredit,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)) as AccountExposure,
			tblAccount.Email,
			tblAccount.IsCustomer,
			tblAccount.IsVendor,
			tblAccount.VerificationStatus,
			tblAccount.Address1,
			tblAccount.Address2,
			tblAccount.Address3,
			tblAccount.City,
			tblAccount.Country,
			tblAccount.PostCode,
			tblAccount.Picture,
			IF ( (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount AND abc.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_)) as CUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as VUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)) as AE,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,IF(ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)<0,0,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_))) as ACL,
			abc.BalanceThreshold,
			tblAccount.Blocked
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		LEFT JOIN tblCLIRateTable
			ON tblCLIRateTable.AccountID = tblAccount.AccountID
		WHERE  -- tblAccount.CompanyID = p_CompanyID AND
			 tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_isReseller = 0 OR tblAccount.IsReseller = 1))
			AND (p_ResellerID = 0 OR tblAccount.CompanyID = v_resellercompanyid)
			AND ((p_AccountNo = '' OR tblAccount.Number LIKE p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName LIKE Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR tblCLIRateTable.CLI LIKE CONCAT('%',p_IPCLI,'%') OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags LIKE Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) LIKE CONCAT('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN tblAccount.AccountName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN tblAccount.AccountName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NumberDESC') THEN tblAccount.Number
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NumberASC') THEN tblAccount.Number
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OwnernameDESC') THEN tblUser.FirstName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OwnernameASC') THEN tblUser.FirstName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PhoneDESC') THEN tblAccount.Phone
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PhoneASC') THEN tblAccount.Phone
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutStandingAmountDESC') THEN abc.SOAOffset
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutStandingAmountASC') THEN abc.SOAOffset
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditDESC') THEN abc.PermanentCredit
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditASC') THEN abc.PermanentCredit
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UnbilledAmountDESC') THEN (ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_))
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UnbilledAmountASC') THEN (ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_))
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailDESC') THEN tblAccount.Email
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailASC') THEN tblAccount.Email
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(DISTINCT tblAccount.AccountID) AS totalcount
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		LEFT JOIN tblCLIRateTable
			ON tblCLIRateTable.AccountID = tblAccount.AccountID
		WHERE --  tblAccount.CompanyID = p_CompanyID AND
			 tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_isReseller = 0 OR tblAccount.IsReseller = 1))
			AND (p_ResellerID = 0 OR tblAccount.CompanyID = v_resellercompanyid)
			AND ((p_AccountNo = '' OR tblAccount.Number LIKE p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName LIKE Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR tblCLIRateTable.CLI LIKE CONCAT('%',p_IPCLI,'%') OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags LIKE Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) LIKE CONCAT('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) );

	END IF;
	IF p_isExport = 1
	THEN
		SELECT
			tblAccount.Number as NO,
			tblAccount.AccountName,
			CONCAT(tblAccount.FirstName,' ',tblAccount.LastName) as Name,
			tblAccount.Phone,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.SOAOffset,0),v_Round_)) as 'OutStanding',
			tblAccount.Email,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_)  - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as 'Unbilled Amount',
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_)) as 'Credit Limit',
			CONCAT(tblUser.FirstName,' ',tblUser.LastName) as 'Account Owner',
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)) as AccountExposure
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		LEFT JOIN tblCLIRateTable
			ON tblCLIRateTable.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_isReseller = 0 OR tblAccount.IsReseller = 1))
			AND (p_ResellerID = 0 OR tblAccount.CompanyID = v_resellercompanyid)
			AND ((p_AccountNo = '' OR tblAccount.Number LIKE p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName LIKE Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR tblCLIRateTable.CLI LIKE CONCAT('%',p_IPCLI,'%') OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags LIKE Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) LIKE CONCAT('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID;
	END IF;
	IF p_isExport = 2
	THEN
		SELECT
			tblAccount.AccountID,
			tblAccount.AccountName
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		LEFT JOIN tblCLIRateTable
			ON tblCLIRateTable.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_isReseller = 0 OR tblAccount.IsReseller = 1))
			AND (p_ResellerID = 0 OR tblAccount.CompanyID = v_resellercompanyid)
			AND ((p_AccountNo = '' OR tblAccount.Number LIKE p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName LIKE Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR tblCLIRateTable.CLI LIKE CONCAT('%',p_IPCLI,'%') OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags LIKE Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) LIKE CONCAT('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getAutoImportMail`;
DELIMITER //
CREATE PROCEDURE `prc_getAutoImportMail`(
	IN `p_jobType` INT,
	IN `p_jobStatus` INT,
	IN `p_CompanyID` INT,
	IN `p_search` TEXT,
	IN `p_AccountID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_OffSet_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

					IF (p_isExport = 0) THEN


							select IFNULL(jt.Title, 'Not Match') as jobType,
							CONCAT(  a.Subject, '<br>', a.AccountName, '<br>', a.`From` )  AS header,
							a.created_at,a.JobID,IFNULL(js.Title, 'Not Match') as jobstatus,a.AutoImportID, a.AccountID, IFNULL(ac.AccountName, '') from tblAutoImport a
							left join tblJob j on a.JobID=j.JobID
							left join tblJobType jt on j.JobTypeID = jt.JobTypeID
							left join tblJobStatus js on j.JobStatusID=js.JobStatusID
							left join tblAccount ac on a.AccountID=ac.AccountID
							where
								CASE
									WHEN (p_jobType > 0) THEN
										jt.JobTypeID = p_jobType AND a.CompanyID=p_CompanyID
									WHEN (p_jobStatus > 0) THEN
										js.JobStatusID = p_jobStatus AND a.CompanyID=p_CompanyID
									WHEN (p_search <> '') THEN
										    (  a.Subject LIKE CONCAT('%',p_search,'%')  OR a.JobID LIKE CONCAT('%',p_search,'%') )  AND a.CompanyID=p_CompanyID
								   ELSE
										a.CompanyID=p_CompanyID
								END
								AND ( p_AccountID = 0 OR a.AccountID=p_AccountID )
								ORDER BY
								  CASE WHEN p_lSortCol = 'Type' AND p_SortOrder = 'desc' THEN jobType END DESC,
								  CASE WHEN p_lSortCol = 'Type' THEN jobType END,
								  CASE WHEN p_lSortCol = 'Header' AND p_SortOrder = 'desc' THEN header END DESC,
								  CASE WHEN p_lSortCol = 'Header' THEN header END,
								  CASE WHEN p_lSortCol = 'Created' AND p_SortOrder = 'desc' THEN a.created_at END DESC,
								  CASE WHEN p_lSortCol = 'Created' THEN a.created_at END,
								  CASE WHEN p_lSortCol = 'Status' AND p_SortOrder = 'desc' THEN jobstatus END DESC,
								  CASE WHEN p_lSortCol = 'Status' THEN jobstatus END,
								  CASE WHEN p_lSortCol = 'JobId' AND p_SortOrder = 'desc' THEN a.JobID END DESC,
								  CASE WHEN p_lSortCol = 'JobId' THEN a.JobID END

							LIMIT p_RowspPage OFFSET v_OffSet_;

					ELSE


							select IFNULL(jt.Title, 'Not Match') as jobType,
							CONCAT(  a.Subject, '<br>', a.AccountName, '<br>', a.`From` )  AS header,
							a.created_at,a.JobID,IFNULL(js.Title, 'Not Match') as jobstatus,a.AutoImportID, a.AccountID, IFNULL(ac.AccountName, '') from tblAutoImport a
							left join tblJob j on a.JobID=j.JobID
							left join tblJobType jt on j.JobTypeID = jt.JobTypeID
							left join tblJobStatus js on j.JobStatusID=js.JobStatusID
							left join tblAccount ac on a.AccountID=ac.AccountID
							where
								CASE
									WHEN (p_jobType > 0) THEN
										jt.JobTypeID = p_jobType AND a.CompanyID=p_CompanyID
									WHEN (p_jobStatus > 0) THEN
										js.JobStatusID = p_jobStatus AND a.CompanyID=p_CompanyID
									WHEN (p_search <> '') THEN
										    (  a.Subject LIKE CONCAT('%',p_search,'%')  OR a.JobID LIKE CONCAT('%',p_search,'%') )  AND a.CompanyID=p_CompanyID
								   ELSE
										a.CompanyID=p_CompanyID
								END
								ORDER BY
								  CASE WHEN p_lSortCol = 'Type' AND p_SortOrder = 'desc' THEN jobType END DESC,
								  CASE WHEN p_lSortCol = 'Type' THEN jobType END,
								  CASE WHEN p_lSortCol = 'Header' AND p_SortOrder = 'desc' THEN header END DESC,
								  CASE WHEN p_lSortCol = 'Header' THEN header END,
								  CASE WHEN p_lSortCol = 'Created' AND p_SortOrder = 'desc' THEN a.created_at END DESC,
								  CASE WHEN p_lSortCol = 'Created' THEN a.created_at END,
								  CASE WHEN p_lSortCol = 'Status' AND p_SortOrder = 'desc' THEN jobstatus END DESC,
								  CASE WHEN p_lSortCol = 'Status' THEN jobstatus END,
								  CASE WHEN p_lSortCol = 'JobId' AND p_SortOrder = 'desc' THEN a.JobID END DESC,
								  CASE WHEN p_lSortCol = 'JobId' THEN a.JobID END
							;


					END IF;



					select COUNT(*) AS `totalcount` from tblAutoImport a
							left join tblJob j on a.JobID=j.JobID
							left join tblJobType jt on j.JobTypeID = jt.JobTypeID
							left join tblJobStatus js on j.JobStatusID=js.JobStatusID
							left join tblAccount ac on a.AccountID=ac.AccountID
							where 
								CASE 
									WHEN (p_jobType > 0) THEN
										jt.JobTypeID = p_jobType AND a.CompanyID=p_CompanyID
									WHEN (p_jobStatus > 0) THEN
										js.JobStatusID = p_jobStatus AND a.CompanyID=p_CompanyID
									WHEN (p_search <> '') THEN
										    (  a.Subject LIKE CONCAT('%',p_search,'%')  OR a.JobID LIKE CONCAT('%',p_search,'%') )  AND a.CompanyID=p_CompanyID
								   ELSE
										a.CompanyID=p_CompanyID				
								END
							LIMIT p_RowspPage OFFSET v_OffSet_;
		
		
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getAutoImportSetting_AccountAndRateTable`;
DELIMITER //
CREATE PROCEDURE `prc_getAutoImportSetting_AccountAndRateTable`(
	IN `p_SettingType` INT,
	IN `p_CompanyID` INT,
	IN `p_TrunkID` INT,
	IN `p_typePKID` INT,
	IN `p_search` TEXT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN

	DECLARE v_OffSet_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	
	
	IF (p_SettingType = 1 ) THEN  -- Account Setting
		
					IF (p_isExport = 0) THEN
							
								
							select a.AccountName,t.Trunk , ut.Title,Subject,FileName,SendorEmail,a.AccountID,t.TrunkID,ut.FileUploadTemplateID,AutoImportSettingID from tblAutoImportSetting as s
							inner join tblTrunk as t on s.TrunkID=t.TrunkID
							inner join tblAccount as a on a.AccountID=s.TypePKID
							inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
							
							where 
								  CASE 
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0 AND p_search <> '') THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
										WHEN (p_TrunkID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
									   WHEN (p_typePKID > 0) THEN
										    s.TypePKID = p_typePKID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
										WHEN (p_search <> '') THEN
										     (  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 1				    				    
										     
										    
										ELSE						
											 s.CompanyID = p_CompanyID AND s.`Type`= 1
										
									END
									
								ORDER BY
								  CASE WHEN p_lSortCol = 'AccountName' AND p_SortOrder = 'desc' THEN a.AccountName END DESC,
								  CASE WHEN p_lSortCol = 'AccountName' THEN a.AccountName END,
								  CASE WHEN p_lSortCol = 'Trunk' AND p_SortOrder = 'desc' THEN t.Trunk END DESC,
								  CASE WHEN p_lSortCol = 'Trunk' THEN t.Trunk END,
								  CASE WHEN p_lSortCol = 'Import File Templete' AND p_SortOrder = 'desc' THEN ut.Title END DESC,
								  CASE WHEN p_lSortCol = 'Import File Templete' THEN ut.Title END,
								  CASE WHEN p_lSortCol = 'Subject Match' AND p_SortOrder = 'desc' THEN Subject END DESC,
								  CASE WHEN p_lSortCol = 'Subject Match' THEN Subject END,
								  CASE WHEN p_lSortCol = 'Filename Match' AND p_SortOrder = 'desc' THEN FileName END DESC,
								  CASE WHEN p_lSortCol = 'Filename Match' THEN FileName END,
								  CASE WHEN p_lSortCol = 'Sendor Match' AND p_SortOrder = 'desc' THEN SendorEmail END DESC,
								  CASE WHEN p_lSortCol = 'Sendor Match' THEN SendorEmail END

													
							LIMIT p_RowspPage OFFSET v_OffSet_;
							
					ELSE
							
							
							select a.AccountName,t.Trunk , ut.Title,Subject,SendorEmail,FileName from tblAutoImportSetting as s
							inner join tblTrunk as t on s.TrunkID=t.TrunkID
							inner join tblAccount as a on a.AccountID=s.TypePKID
							inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
							
							where 
								  CASE 
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0 AND p_search <> '') THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
										WHEN (p_TrunkID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
									   WHEN (p_typePKID > 0) THEN
										    s.TypePKID = p_typePKID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
										WHEN (p_search <> '') THEN

										    (  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 1				    				    
										ELSE						
											 s.CompanyID = p_CompanyID AND s.`Type`= 1
										
									END	
								ORDER BY
								  CASE WHEN p_lSortCol = 'AccountName' AND p_SortOrder = 'desc' THEN a.AccountName END DESC,
								  CASE WHEN p_lSortCol = 'AccountName' THEN a.AccountName END,
								  CASE WHEN p_lSortCol = 'Trunk' AND p_SortOrder = 'desc' THEN t.Trunk END DESC,
								  CASE WHEN p_lSortCol = 'Trunk' THEN t.Trunk END,
								  CASE WHEN p_lSortCol = 'Import File Templete' AND p_SortOrder = 'desc' THEN ut.Title END DESC,
								  CASE WHEN p_lSortCol = 'Import File Templete' THEN ut.Title END,
								  CASE WHEN p_lSortCol = 'Subject Match' AND p_SortOrder = 'desc' THEN Subject END DESC,
								  CASE WHEN p_lSortCol = 'Subject Match' THEN Subject END,
								  CASE WHEN p_lSortCol = 'Filename Match' AND p_SortOrder = 'desc' THEN FileName END DESC,
								  CASE WHEN p_lSortCol = 'Filename Match' THEN FileName END,
								  CASE WHEN p_lSortCol = 'Sendor Match' AND p_SortOrder = 'desc' THEN SendorEmail END DESC,
								  CASE WHEN p_lSortCol = 'Sendor Match' THEN SendorEmail END
							;			
							
							
					END IF;
		
	
		select COUNT(*) AS `totalcount` from tblAutoImportSetting as s
		inner join tblTrunk as t on s.TrunkID=t.TrunkID
		inner join tblAccount as a on a.AccountID=s.TypePKID
		inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
		where 
								  CASE 
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0 AND p_search <> '') THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
								  		WHEN (p_TrunkID > 0 AND p_typePKID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 1				    
										WHEN (p_TrunkID > 0) THEN
										    s.TrunkID=p_TrunkID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
									   WHEN (p_typePKID > 0) THEN
										    s.TypePKID = p_typePKID AND  s.CompanyID = p_CompanyID AND s.`Type`= 1
										WHEN (p_search <> '') THEN			    				    
										    (  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 1				    				    
										ELSE						
											 s.CompanyID = p_CompanyID AND s.`Type`= 1
										
									END	
							;		
			
	END IF;
	
	
	
	IF (p_SettingType = 2 ) THEN  -- RateTable Setting
		
		IF (p_isExport = 0) THEN
				
					
				select r.RateTableName,ut.Title,Subject,FileName,SendorEmail,r.RateTableId,ut.FileUploadTemplateID,AutoImportSettingID from tblAutoImportSetting as s
				inner join tblRateTable as r on s.TypePKID = r.RateTableId
				inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
				
				where 
					  CASE 
					  		WHEN (p_typePKID > 0 AND p_search <> '') THEN
							     s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
					  		WHEN (p_typePKID > 0) THEN
							     s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
							WHEN (p_search <> '') THEN

							    (  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 2				    				    
							ELSE						
								 s.CompanyID = p_CompanyID AND s.`Type`= 2
							
						END	
					ORDER BY
					  CASE WHEN p_lSortCol = 'RateTable' AND p_SortOrder = 'desc' THEN r.RateTableName END DESC,
					  CASE WHEN p_lSortCol = 'RateTable' THEN r.RateTableName END,
					  CASE WHEN p_lSortCol = 'Import File Template' AND p_SortOrder = 'desc' THEN ut.Title END DESC,
					  CASE WHEN p_lSortCol = 'Import File Template' THEN ut.Title END,
					  CASE WHEN p_lSortCol = 'Subject Match' AND p_SortOrder = 'desc' THEN Subject END DESC,
					  CASE WHEN p_lSortCol = 'Subject Match' THEN Subject END,
					  CASE WHEN p_lSortCol = 'Filename Match' AND p_SortOrder = 'desc' THEN FileName END DESC,
					  CASE WHEN p_lSortCol = 'Filename Match' THEN FileName END,	
					  CASE WHEN p_lSortCol = 'Sender Match' AND p_SortOrder = 'desc' THEN SendorEmail END DESC,
					  CASE WHEN p_lSortCol = 'Sender Match' THEN SendorEmail END
					  
				LIMIT p_RowspPage OFFSET v_OffSet_;
				
		ELSE
				
				
				select r.RateTableName,ut.Title,Subject,SendorEmail,FileName from tblAutoImportSetting as s
				inner join tblRateTable as r on s.TypePKID = r.RateTableId
				inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
				
				where 
					  CASE 
					  		WHEN (p_typePKID > 0 AND p_search <> '') THEN
							     s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
					  		WHEN (p_typePKID > 0) THEN
							     s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
							WHEN (p_search <> '') THEN

							    (  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 2				    				    
							ELSE						
								 s.CompanyID = p_CompanyID AND s.`Type`= 2
							
						END	
					ORDER BY
					  CASE WHEN p_lSortCol = 'RateTable' AND p_SortOrder = 'desc' THEN r.RateTableName END DESC,
					  CASE WHEN p_lSortCol = 'RateTable' THEN r.RateTableName END,
					  CASE WHEN p_lSortCol = 'Import File Template' AND p_SortOrder = 'desc' THEN ut.Title END DESC,
					  CASE WHEN p_lSortCol = 'Import File Template' THEN ut.Title END,
					  CASE WHEN p_lSortCol = 'Subject Match' AND p_SortOrder = 'desc' THEN Subject END DESC,
					  CASE WHEN p_lSortCol = 'Subject Match' THEN Subject END,
					  CASE WHEN p_lSortCol = 'Filename Match' AND p_SortOrder = 'desc' THEN FileName END DESC,
					  CASE WHEN p_lSortCol = 'Filename Match' THEN FileName END,	
					  CASE WHEN p_lSortCol = 'Sender Match' AND p_SortOrder = 'desc' THEN SendorEmail END DESC,
					  CASE WHEN p_lSortCol = 'Sender Match' THEN SendorEmail END
				;
				
		END IF;
		
	
		select COUNT(*) AS `totalcount` from tblAutoImportSetting as s
				inner join tblRateTable as r on s.TypePKID = r.RateTableId
				inner join tblFileUploadTemplate as ut on ut.FileUploadTemplateID=s.ImportFileTempleteID
				
				where 
					  CASE 
					  		WHEN (p_typePKID > 0 AND p_search <> '') THEN
							     s.TypePKID=p_typePKID AND ( p_search = ''  OR s.Subject LIKE REPLACE(p_search,'*', '%') )  AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
					  		WHEN (p_typePKID > 0) THEN
							     s.TypePKID=p_typePKID AND s.CompanyID = p_CompanyID AND s.`Type`= 2				    
							WHEN (p_search <> '') THEN
								(  s.Subject LIKE CONCAT('%',p_search,'%')  OR SendorEmail LIKE CONCAT('%',p_search,'%') OR ut.Title LIKE CONCAT('%',p_search,'%') ) AND  s.CompanyID = p_CompanyID AND s.`Type`= 2
							ELSE						
								 s.CompanyID = p_CompanyID AND s.`Type`= 2
							
						END	
				;
		

		
			
	END IF;

	
	
	
		
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetCustomerRate`;
DELIMITER //
CREATE PROCEDURE `prc_GetCustomerRate`(
	IN `p_companyid` INT,
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_contryID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_description` VARCHAR(50),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE,
	IN `p_effectedRates` INT,
	IN `p_RoutinePlan` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
   DECLARE v_codedeckid_ INT;
   DECLARE v_ratetableid_ INT;
   DECLARE v_RateTableAssignDate_ DATETIME;
   DECLARE v_NewA2ZAssign_ INT;
   DECLARE v_OffSet_ int;
   DECLARE v_IncludePrefix_ INT;
   DECLARE v_Prefix_ VARCHAR(50);
   DECLARE v_RatePrefix_ VARCHAR(50);
   DECLARE v_AreaPrefix_ VARCHAR(50);

   -- set custome date = current date if custom date is past date
   IF(p_CustomDate < DATE(NOW()))
	THEN
		SET p_CustomDate=DATE(NOW());
	END IF;

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

    SELECT
        CodeDeckId,
        RateTableID,
        RateTableAssignDate,IncludePrefix INTO v_codedeckid_, v_ratetableid_, v_RateTableAssignDate_,v_IncludePrefix_
    FROM tblCustomerTrunk
    WHERE CompanyID = p_companyid
    AND tblCustomerTrunk.TrunkID = p_trunkID
    AND tblCustomerTrunk.AccountID = p_AccountID
    AND tblCustomerTrunk.Status = 1;

    SELECT
        Prefix,RatePrefix,AreaPrefix INTO v_Prefix_,v_RatePrefix_,v_AreaPrefix_
    FROM tblTrunk
    WHERE CompanyID = p_companyid
    AND tblTrunk.TrunkID = p_trunkID
    AND tblTrunk.Status = 1;



    DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        RateID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        RoutinePlan INT,
        INDEX tmp_CustomerRates__RateID (`RateID`),
        INDEX tmp_CustomerRates__TrunkID (`TrunkID`),
        INDEX tmp_CustomerRates__EffectiveDate (`EffectiveDate`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        RateID INT,
        Interval1 INT,
        IntervalN INT,
        Rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        INDEX tmp_RateTableRate__RateID (`RateID`),
        INDEX tmp_RateTableRate__TrunkID (`TrunkID`),
        INDEX tmp_RateTableRate__EffectiveDate (`EffectiveDate`)

    );

    DROP TEMPORARY TABLE IF EXISTS tmp_customerrate_;
    CREATE TEMPORARY TABLE tmp_customerrate_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );


    INSERT INTO tmp_CustomerRates_

            SELECT
                tblCustomerRate.RateID,
                tblCustomerRate.Interval1,
                tblCustomerRate.IntervalN,

                tblCustomerRate.Rate,
                tblCustomerRate.ConnectionFee,
                tblCustomerRate.EffectiveDate,
                tblCustomerRate.EndDate,
                tblCustomerRate.LastModifiedDate,
                tblCustomerRate.LastModifiedBy,
                tblCustomerRate.CustomerRateId,
                NULL AS RateTableRateID,
                p_trunkID as TrunkID,
                tblCustomerRate.RoutinePlan

            FROM tblCustomerRate
            INNER JOIN tblRate
                ON tblCustomerRate.RateID = tblRate.RateID
            WHERE (p_contryID IS NULL OR tblRate.CountryID = p_contryID)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
            AND (tblRate.CompanyID = p_companyid)
            AND tblRate.CodeDeckId = v_codedeckid_
            AND tblCustomerRate.TrunkID = p_trunkID
            AND (p_RoutinePlan = 0 or tblCustomerRate.RoutinePlan = p_RoutinePlan)
            AND CustomerID = p_AccountID

            ORDER BY
                tblCustomerRate.TrunkId, tblCustomerRate.CustomerId,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;







	 	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates4_;
			CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates4_ as (select * from tmp_CustomerRates_);
			DELETE n1 FROM tmp_CustomerRates_ n1, tmp_CustomerRates4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
			AND n1.TrunkID = n2.TrunkID
			AND  n1.RateID = n2.RateID
			AND
			(
				(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
				OR
				(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
			);

	 	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates2_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates2_ as (select * from tmp_CustomerRates_);
		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates3_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates3_ as (select * from tmp_CustomerRates_);
	   DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates5_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates5_ as (select * from tmp_CustomerRates_);

	   ALTER TABLE tmp_CustomerRates2_ ADD  INDEX tmp_CustomerRatesRateID (`RateID`);
	   ALTER TABLE tmp_CustomerRates3_ ADD  INDEX tmp_CustomerRatesRateID (`RateID`);
	   ALTER TABLE tmp_CustomerRates5_ ADD  INDEX tmp_CustomerRatesRateID (`RateID`);

	   ALTER TABLE tmp_CustomerRates2_ ADD  INDEX tmp_CustomerRatesEffectiveDate (`EffectiveDate`);
	   ALTER TABLE tmp_CustomerRates3_ ADD  INDEX tmp_CustomerRatesEffectiveDate (`EffectiveDate`);
	   ALTER TABLE tmp_CustomerRates5_ ADD  INDEX tmp_CustomerRatesEffectiveDate (`EffectiveDate`);

    INSERT INTO tmp_RateTableRate_
            SELECT
                tblRateTableRate.RateID,
                tblRateTableRate.Interval1,
                tblRateTableRate.IntervalN,
                tblRateTableRate.Rate,
                tblRateTableRate.ConnectionFee,

      			 tblRateTableRate.EffectiveDate,
      			 tblRateTableRate.EndDate,
                NULL AS LastModifiedDate,
                NULL AS LastModifiedBy,
                NULL AS CustomerRateId,
                tblRateTableRate.RateTableRateID,
                p_trunkID as TrunkID
            FROM tblRateTableRate
            INNER JOIN tblRate
                ON tblRateTableRate.RateID = tblRate.RateID
            WHERE (p_contryID IS NULL OR tblRate.CountryID = p_contryID)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
            AND (tblRate.CompanyID = p_companyid)
            AND tblRate.CodeDeckId = v_codedeckid_
            AND RateTableID = v_ratetableid_
            AND (
						(
							(SELECT count(*) from tmp_CustomerRates2_ cr where cr.RateID = tblRateTableRate.RateID) >0
							AND tblRateTableRate.EffectiveDate <
								( SELECT MIN(cr.EffectiveDate)
                          FROM tmp_CustomerRates_ as cr
                          WHERE cr.RateID = tblRateTableRate.RateID
								)
							AND (SELECT count(*) from tmp_CustomerRates5_ cr where cr.RateID = tblRateTableRate.RateID AND cr.EffectiveDate <= NOW() ) = 0
						)
						or  (  SELECT count(*) from tmp_CustomerRates3_ cr where cr.RateID = tblRateTableRate.RateID ) = 0
					)

                ORDER BY tblRateTableRate.RateTableId,tblRateTableRate.RateID,tblRateTableRate.effectivedate DESC;




		  DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate4_;
		  CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);
        DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
	 	  AND n1.TrunkID = n2.TrunkID
		  AND  n1.RateID = n2.RateID
		  AND
			(
				(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
				OR
				(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
			);





		  INSERT INTO tmp_customerrate_
        SELECT
        			 r.RateID,
                r.Code,
                r.Description,
                CASE WHEN allRates.Interval1 IS NULL
                THEN
                    r.Interval1
                ELSE
                    allRates.Interval1
                END as Interval1,
                CASE WHEN allRates.IntervalN IS NULL
                THEN
                    r.IntervalN
                ELSE
                    allRates.IntervalN
                END  IntervalN,
                allRates.ConnectionFee,
                allRates.RoutinePlanName,
                allRates.Rate,
                allRates.EffectiveDate,
                allRates.EndDate,
                allRates.LastModifiedDate,
                allRates.LastModifiedBy,
                allRates.CustomerRateId,
                p_trunkID as TrunkID,
                allRates.RateTableRateId,
					v_IncludePrefix_ as IncludePrefix ,
   	         CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.Prefix
               ELSE
               	v_Prefix_
					END AS Prefix,
					CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.RatePrefix
               ELSE
               	v_RatePrefix_
					END AS RatePrefix,
					CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.AreaPrefix
               ELSE
               	v_AreaPrefix_
					END AS AreaPrefix
        FROM tblRate r
        LEFT JOIN (SELECT
                CustomerRates.RateID,
                CustomerRates.Interval1,
                CustomerRates.IntervalN,
                tblTrunk.Trunk as RoutinePlanName,
                CustomerRates.ConnectionFee,
                CustomerRates.Rate,
                CustomerRates.EffectiveDate,
                CustomerRates.EndDate,
                CustomerRates.LastModifiedDate,
                CustomerRates.LastModifiedBy,
                CustomerRates.CustomerRateId,
                NULL AS RateTableRateID,
                p_trunkID as TrunkID,
                RoutinePlan
            FROM tmp_CustomerRates_ CustomerRates
            LEFT JOIN tblTrunk on tblTrunk.TrunkID = CustomerRates.RoutinePlan
            WHERE
                (
					 	( p_Effective = 'Now' AND CustomerRates.EffectiveDate <= NOW() )
					 	OR
					 	( p_Effective = 'Future' AND CustomerRates.EffectiveDate > NOW() )
						OR
						( p_Effective = 'CustomDate' AND CustomerRates.EffectiveDate <= p_CustomDate AND (CustomerRates.EndDate IS NULL OR CustomerRates.EndDate > p_CustomDate) )
					 	OR
						p_Effective = 'All'
					 )


            UNION ALL

            SELECT
            DISTINCT
                rtr.RateID,
                rtr.Interval1,
                rtr.IntervalN,
                NULL,
                rtr.ConnectionFee,
                rtr.Rate,
                rtr.EffectiveDate,
                rtr.EndDate,
                NULL,
                NULL,
                NULL AS CustomerRateId,
                rtr.RateTableRateID,
                p_trunkID as TrunkID,
                NULL AS RoutinePlan
            FROM tmp_RateTableRate_ AS rtr
            LEFT JOIN tmp_CustomerRates2_ as cr
                ON cr.RateID = rtr.RateID AND
						 (
						 	( p_Effective = 'Now' AND cr.EffectiveDate <= NOW() )
						 	OR
						 	( p_Effective = 'Future' AND cr.EffectiveDate > NOW())
						 	OR
							( p_Effective = 'CustomDate' AND cr.EffectiveDate <= p_CustomDate AND (cr.EndDate IS NULL OR cr.EndDate > p_CustomDate) )
						 	OR
							 p_Effective = 'All'
						 )
            WHERE (
                (
                    p_Effective = 'Now' AND rtr.EffectiveDate <= NOW()
                    AND (
                            (cr.RateID IS NULL)
                            OR
                            (cr.RateID IS NOT NULL AND rtr.RateTableRateID IS NULL)
                        )

                )
                OR
                ( p_Effective = 'Future' AND rtr.EffectiveDate > NOW()
                    AND (
                            (cr.RateID IS NULL)
                            OR
                            (
                                cr.RateID IS NOT NULL AND rtr.EffectiveDate < (
                                                                                SELECT IFNULL(MIN(crr.EffectiveDate), rtr.EffectiveDate)
                                                                                FROM tmp_CustomerRates3_ as crr
                                                                                WHERE crr.RateID = rtr.RateID
                                                                                )
                            )
                        )
                )
				OR
				(
					p_Effective = 'CustomDate' AND rtr.EffectiveDate <= p_CustomDate AND (rtr.EndDate IS NULL OR rtr.EndDate > p_CustomDate)
					AND (
                            (cr.RateID IS NULL)
                            OR
                            (cr.RateID IS NOT NULL AND rtr.RateTableRateID IS NULL)
                        )
				)
            OR p_Effective = 'All'

            )

				) allRates
            ON allRates.RateID = r.RateID
         LEFT JOIN tblTrunk on tblTrunk.TrunkID = RoutinePlan
        WHERE (p_contryID IS NULL OR r.CountryID = p_contryID)
        AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
        AND (p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%'))
        AND (r.CompanyID = p_companyid)
        AND r.CodeDeckId = v_codedeckid_
        AND  ((p_effectedRates = 1 AND Rate IS NOT NULL) OR  (p_effectedRates = 0));




    IF p_isExport = 0
    THEN


         SELECT
                RateID,
                Code,
                Description,
                Interval1,
                IntervalN,
                ConnectionFee,
                RoutinePlanName,
                Rate,
                EffectiveDate,
                EndDate,
                LastModifiedDate,
                LastModifiedBy,
                CustomerRateId,
                TrunkID,
                RateTableRateId
            FROM tmp_customerrate_
            ORDER BY
                CASE
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedDateDESC') THEN LastModifiedDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedDateASC') THEN LastModifiedDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedByDESC') THEN LastModifiedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedByASC') THEN LastModifiedBy
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIdDESC') THEN CustomerRateId
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIdASC') THEN CustomerRateId
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(RateID) AS totalcount
        FROM tmp_customerrate_;

    END IF;

    IF p_isExport = 1
    THEN

          select
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate,
            LastModifiedDate,
            LastModifiedBy from tmp_customerrate_;

    END IF;


	IF p_isExport = 2
    THEN

          select
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate from tmp_customerrate_;

    END IF;


    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetCustomerRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetCustomerRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_Codes` LONGTEXT
)
BEGIN
	SELECT
	--	cra.CustomerRateArchiveID,
	--	cra.CustomerRateID,
	--	cra.AccountID,
		r.Code,
		r.Description,
		IFNULL(cra.ConnectionFee,'') AS ConnectionFee,
		CASE WHEN cra.Interval1 IS NOT NULL THEN cra.Interval1 ELSE r.Interval1 END AS Interval1,
		CASE WHEN cra.IntervalN IS NOT NULL THEN cra.IntervalN ELSE r.IntervalN END AS IntervalN,
		cra.Rate,
		cra.EffectiveDate,
		IFNULL(cra.EndDate,'') AS EndDate,
		IFNULL(cra.created_at,'') AS ModifiedDate,
		IFNULL(cra.created_by,'') AS ModifiedBy
	FROM
		tblCustomerRateArchive cra
	JOIN
		tblRate r ON r.RateID=cra.RateId
	WHERE
		r.CompanyID = p_CompanyID AND
		cra.AccountId = p_AccountID AND
		FIND_IN_SET (r.Code, p_Codes) != 0
	ORDER BY
		cra.EffectiveDate DESC, cra.created_at DESC;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getDiscontinuedCustomerRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedCustomerRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_CountryID` INT,
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRate_;
	CREATE TEMPORARY TABLE tmp_CustomerRate_ (
		RateID INT,
		Code VARCHAR(50),
		Description VARCHAR(200),
		Interval1 INT,
		IntervalN INT,
		ConnectionFee VARCHAR(50),
		RoutinePlanName VARCHAR(50),
		Rate DECIMAL(18, 6),
		EffectiveDate DATE,
		EndDate DATE,
		updated_at DATETIME,
		updated_by VARCHAR(50),
		CustomerRateID INT,
		TrunkID INT,
        RateTableRateId INT,
		INDEX tmp_CustomerRate_RateID (`Code`)
	);

	INSERT INTO tmp_CustomerRate_
	SELECT
		cra.RateId,
		r.Code,
		r.Description,
		CASE WHEN cra.Interval1 IS NOT NULL THEN cra.Interval1 ELSE r.Interval1 END AS Interval1,
		CASE WHEN cra.IntervalN IS NOT NULL THEN cra.IntervalN ELSE r.IntervalN END AS IntervalN,
		'' AS ConnectionFee,
		cra.RoutinePlan AS RoutinePlanName,
		cra.Rate,
		cra.EffectiveDate,
		cra.EndDate,
		cra.created_at AS updated_at,
		cra.created_by AS updated_by,
		cra.CustomerRateID,
		p_trunkID AS TrunkID,
		NULL AS RateTableRateID
	FROM
		tblCustomerRateArchive cra
	JOIN
		tblRate r ON r.RateID=cra.RateId
	LEFT JOIN
		tblCustomerRate cr ON cr.CustomerID = cra.AccountId AND cr.TrunkID = cra.TrunkID AND cr.RateId = cra.RateId
	WHERE
		r.CompanyID = p_CompanyID AND
		cra.TrunkID = p_TrunkID AND
		cra.AccountId = p_AccountID AND
		(p_CountryID IS NULL OR r.CountryID = p_CountryID) AND
		(p_code IS NULL OR r.Code LIKE REPLACE(p_code, '*', '%')) AND
		(p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%')) AND
		cr.CustomerRateID is NULL;

	IF p_isExport = 0
	THEN
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRate2_ as (select * from tmp_CustomerRate_);
		DELETE
			n1
		FROM
			tmp_CustomerRate_ n1, tmp_CustomerRate2_ n2
		WHERE
			n1.Code = n2.Code AND n1.CustomerRateID < n2.CustomerRateID;

		SELECT
			RateID,
			Code,
			Description,
			Interval1,
			IntervalN,
			ConnectionFee,
			RoutinePlanName,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			updated_by,
			CustomerRateId,
			TrunkID,
			RateTableRateId
		FROM
			tmp_CustomerRate_
		ORDER BY
			CASE
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN updated_by
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN updated_by
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIDDESC') THEN CustomerRateID
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIDASC') THEN CustomerRateID
			END ASC
		LIMIT
			p_RowspPage
			OFFSET
			v_OffSet_;

		SELECT
			COUNT(code) AS totalcount
		FROM tmp_CustomerRate_;

	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			Code,
			Description,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`
		FROM tmp_CustomerRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getDiscontinuedRateTableRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedRateTableRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_RateTableID` INT,
	IN `p_CountryID` INT,
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_View` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
	CREATE TEMPORARY TABLE tmp_RateTableRate_ (
		RateTableRateID INT,
		Code VARCHAR(50),
		Description VARCHAR(200),
		Interval1 INT,
		IntervalN INT,
		ConnectionFee VARCHAR(50),
		PreviousRate DECIMAL(18, 6),
		Rate DECIMAL(18, 6),
		EffectiveDate DATE,
		EndDate DATE,
		updated_at DATETIME,
		updated_by VARCHAR(50),
		INDEX tmp_RateTableRate_RateID (`Code`)
	);

	INSERT INTO tmp_RateTableRate_
	SELECT
		vra.RateTableRateID,
		r.Code,
		r.Description,
		CASE WHEN vra.Interval1 IS NOT NULL THEN vra.Interval1 ELSE r.Interval1 END AS Interval1,
		CASE WHEN vra.IntervalN IS NOT NULL THEN vra.IntervalN ELSE r.IntervalN END AS IntervalN,
		'' AS ConnectionFee,
		null AS PreviousRate,
		vra.Rate,
		vra.EffectiveDate,
		vra.EndDate,
		vra.created_at AS updated_at,
		vra.created_by AS updated_by
	FROM
		tblRateTableRateArchive vra
	JOIN
		tblRate r ON r.RateID=vra.RateId
	LEFT JOIN
		tblRateTableRate vr ON vr.RateTableId = vra.RateTableId AND vr.RateId = vra.RateId
	WHERE
		r.CompanyID = p_CompanyID AND
		vra.RateTableId = p_RateTableID AND
		(p_CountryID IS NULL OR r.CountryID = p_CountryID) AND
		(p_code IS NULL OR r.Code LIKE REPLACE(p_code, '*', '%')) AND
		(p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%')) AND
		vr.RateTableRateID is NULL;

	IF p_isExport = 0
	THEN
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate2_ as (select * from tmp_RateTableRate_);
		DELETE
			n1
		FROM
			tmp_RateTableRate_ n1, tmp_RateTableRate2_ n2
		WHERE
			n1.Code = n2.Code AND n1.RateTableRateID < n2.RateTableRateID;

		IF p_view = 1
		THEN
			SELECT
				RateTableRateID,
				Code,
				Description,
				Interval1,
				IntervalN,
				ConnectionFee,
				PreviousRate,
				Rate,
				EffectiveDate,
				EndDate,
				updated_at,
				updated_by
			FROM
				tmp_RateTableRate_
			ORDER BY
				CASE
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
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN updated_by
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN updated_by
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN RateTableRateID
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN RateTableRateID
				END ASC
			LIMIT
				p_RowspPage
			OFFSET
				v_OffSet_;

			SELECT
				COUNT(code) AS totalcount
			FROM tmp_RateTableRate_;

		ELSE

			SELECT
				group_concat(RateTableRateID) AS RateTableRateID,
				group_concat(Code),
				Description,
				ConnectionFee,
				Interval1,
				IntervalN,
				ANY_VALUE(PreviousRate),
				Rate,
				EffectiveDate,
				EndDate,
				MAX(updated_at),
				MAX(updated_by)
			FROM
				tmp_RateTableRate_
			GROUP BY
				Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate, EndDate
			ORDER BY
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN ANY_VALUE(Description)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN ANY_VALUE(Description)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN ANY_VALUE(Rate)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN ANY_VALUE(Rate)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ANY_VALUE(ConnectionFee)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ANY_VALUE(ConnectionFee)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN ANY_VALUE(Interval1)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN ANY_VALUE(Interval1)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN ANY_VALUE(IntervalN)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN ANY_VALUE(IntervalN)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN ANY_VALUE(EffectiveDate)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN ANY_VALUE(EffectiveDate)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN ANY_VALUE(EndDate)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN ANY_VALUE(EndDate)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN ANY_VALUE(updated_at)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN ANY_VALUE(updated_at)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN ANY_VALUE(updated_by)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN ANY_VALUE(updated_by)
				END ASC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN ANY_VALUE(RateTableRateID)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN ANY_VALUE(RateTableRateID)
				END ASC
			LIMIT
				p_RowspPage
			OFFSET
				v_OffSet_;


			SELECT COUNT(*) AS `totalcount`
			FROM (
				SELECT
	            Description
	        	FROM tmp_RateTableRate_
					GROUP BY Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate, EndDate
			) totalcount;

		END IF;

	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			Code,
			Description,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`
		FROM tmp_RateTableRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetFileUploadTemplates`;
DELIMITER //
CREATE PROCEDURE `prc_GetFileUploadTemplates`(
	IN `p_CompanyID` INT,
	IN `p_Title` VARCHAR(255),
	IN `p_Type` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_IsExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_IsExport = 0
	THEN
		SELECT
			t.`Title` AS TemplateName,
			tt.`Title` AS TemplateType,
			t.`created_at`,
			t.`FileUploadTemplateID`
		FROM
			tblFileUploadTemplate t
		LEFT JOIN
			tblFileUploadTemplateType tt ON t.FileUploadTemplateTypeID=tt.FileUploadTemplateTypeID
		WHERE
			t.CompanyID = p_CompanyID AND
			(p_Title IS NULL OR t.Title LIKE REPLACE(p_Title, '*', '%')) AND
			(p_Type IS NULL OR t.FileUploadTemplateTypeID = p_Type)
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN t.Title
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN t.Title
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TypeASC') THEN tt.Title
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TypeDESC') THEN tt.Title
			END DESC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		-- total counts for datatable
		SELECT
			COUNT(t.Title) AS totalcount
		FROM
			tblFileUploadTemplate t
		LEFT JOIN
			tblFileUploadTemplateType tt ON t.FileUploadTemplateTypeID=tt.FileUploadTemplateTypeID
		WHERE
			t.CompanyID = p_CompanyID AND
			(p_Title IS NULL OR t.Title LIKE REPLACE(p_Title, '*', '%')) AND
			(p_Type IS NULL OR t.FileUploadTemplateTypeID = p_Type);

	END IF;

	IF p_IsExport = 1
	THEN
		SELECT
			t.`Title` AS TemplateName,
			tt.`Title` AS TemplateType,
			t.`created_at`
		FROM
			tblFileUploadTemplate t
		LEFT JOIN
			tblFileUploadTemplateType tt ON t.FileUploadTemplateTypeID=tt.FileUploadTemplateTypeID
		WHERE
			t.CompanyID = p_CompanyID;
	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCR`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_codedeckID` INT,
	IN `p_CurrencyID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_Description` VARCHAR(250),
	IN `p_AccountIds` TEXT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Preference` INT,
	IN `p_Position` INT,
	IN `p_vendor_block` INT,
	IN `p_groupby` VARCHAR(50),
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_ShowAllVendorCodes` INT,
	IN `p_isExport` INT
)
ThisSP:BEGIN

		DECLARE v_OffSet_ int;

		DECLARE v_Code VARCHAR(50) ;
		DECLARE v_pointer_ int;
		DECLARE v_rowCount_ int;
		DECLARE v_p_code VARCHAR(50);
		DECLARE v_Codlen_ int;
		DECLARE v_position int;
		DECLARE v_p_code__ VARCHAR(50);
		DECLARE v_has_null_position int ;
		DECLARE v_next_position1 VARCHAR(200) ;
		DECLARE v_CompanyCurrencyID_ INT;

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';

		-- just for taking codes -

		SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RowCode VARCHAR(50) ,
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_AccountID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
			RowCode VARCHAR(50) ,
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_AccountID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50),
			FinalRankNumber int
		)
		;

		-- Loop codes

		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			Code  varchar(50),
			INDEX Index1 (Code)
		);

		-- searched codes.

		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_ (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index1 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
		CREATE TEMPORARY TABLE tmp_all_code_ (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index2 (Code)
		)
		;


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
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
			INDEX IX_Code (Code)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			AccountId int,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
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
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
		CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			rankname INT,
			INDEX IX_Code (Code,rankname)
		)
		;

		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;

		-- Search code based on p_code
		IF (p_ShowAllVendorCodes = 1) THEN

	          insert into tmp_search_code_
	          SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
						  SELECT @RowNo  := @RowNo + 1 as RowNo
						  FROM mysql.help_category 
						  ,(SELECT @RowNo := 0 ) x
						  limit 15
	          ) x
	         -- INNER JOIN tblRate AS f          ON f.CompanyID = p_companyid  AND f.CodeDeckId = p_codedeckID
			  INNER JOIN (  
						  	SELECT distinct Code , Description from tblRate 
						  	WHERE CompanyID = p_companyid
							 	AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
	          					AND ( p_Description = ''  OR Description LIKE REPLACE(p_Description,'*', '%') )
			  ) f 
	          ON x.RowNo   <= LENGTH(f.Code) 
	          order by loopCode   desc;
			  

		ELSE

		insert into tmp_search_code_
			SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
					SELECT @RowNo  := @RowNo + 1 as RowNo
					FROM mysql.help_category
						,(SELECT @RowNo := 0 ) x
					limit 15
				) x
				INNER JOIN tblRate AS f
					ON f.CompanyID = p_companyid  AND f.CodeDeckId = p_codedeckID
						 AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR f.Code LIKE REPLACE(p_code,'*', '%') )
						 AND ( p_Description = ''  OR f.Description LIKE REPLACE(p_Description,'*', '%') )
						 AND x.RowNo   <= LENGTH(f.Code)
			order by loopCode   desc;

		END IF;	
		-- distinct vendor rates

		### change v 4.17
		IF p_ShowAllVendorCodes = 1 THEN

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (
							 SELECT distinct tblVendorRate.AccountId,
							    IFNULL(blockCode.VendorBlockingId, 0) AS BlockingId,
							    IFNULL(blockCountry.CountryId, 0)  as BlockingCountryId,
								 tblAccount.AccountName, 
								 tblRate.Code, 
								 tblRate.Description,
								 CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
									 THEN
										 tblVendorRate.Rate
								 WHEN  v_CompanyCurrencyID_ = p_CurrencyID
									 THEN
										 (
											 ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
										 )
								 ELSE
									 (
										 -- Convert to base currrncy and x by RateGenerator Exhange

										 (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
										 * (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
									 )
								 END
								as  Rate,
								 ConnectionFee,
								 DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference
							 FROM      tblVendorRate
								 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID

								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = p_companyid     AND    tblVendorRate.RateId = tblRate.RateID   AND vt.CodeDeckId = tblRate.CodeDeckId
								
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
								  ( CHAR_LENGTH(RTRIM(p_code)) = 0 OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
								 AND (p_Description='' OR tblRate.Description LIKE REPLACE(p_Description,'*','%'))
								 AND ( EffectiveDate <= DATE(p_SelectedEffectiveDate) )
								 AND ( tblVendorRate.EndDate IS NULL OR  tblVendorRate.EndDate > Now() )   -- rate should not end Today
								 AND (p_AccountIds='' OR FIND_IN_SET(tblAccount.AccountID,p_AccountIds) != 0 )
								 AND tblAccount.IsVendor = 1
								 AND tblAccount.Status = 1
								 AND tblAccount.CurrencyId is not NULL
								 AND tblVendorRate.TrunkID = p_trunkID
								  AND
							        (
							           p_vendor_block = 1 OR
							          (
							             p_vendor_block = 0 AND   (
							                 blockCode.RateId IS NULL  AND blockCountry.CountryId IS NULL
							             )
							         )
							       )
								 -- AND blockCode.RateId IS NULL
								 -- AND blockCountry.CountryId IS NULL

						 ) tbl
				order by Code asc;

		ELSE 

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (
							 SELECT distinct tblVendorRate.AccountId,
							    IFNULL(blockCode.VendorBlockingId, 0) AS BlockingId,
							    IFNULL(blockCountry.CountryId, 0)  as BlockingCountryId,
								 tblAccount.AccountName, 
								 tblRate.Code, 
								 tblRate.Description,
								 CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
									 THEN
										 tblVendorRate.Rate
								 WHEN  v_CompanyCurrencyID_ = p_CurrencyID
									 THEN
										 (
											 ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
										 )
								 ELSE
									 (
										 -- Convert to base currrncy and x by RateGenerator Exhange

										 (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
										 * (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
									 )
								 END
																																			 as  Rate,
								 ConnectionFee,
								 DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference
							 FROM      tblVendorRate
								 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID

								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = p_companyid     AND    tblVendorRate.RateId = tblRate.RateID   AND vt.CodeDeckId = tblRate.CodeDeckId
								
								 INNER JOIN tmp_search_code_  SplitCode   on tblRate.Code = SplitCode.Code
								
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
								 ( EffectiveDate <= DATE(p_SelectedEffectiveDate) )
								 AND ( tblVendorRate.EndDate IS NULL OR  tblVendorRate.EndDate > Now() )   -- rate should not end Today
								 AND (p_AccountIds='' OR FIND_IN_SET(tblAccount.AccountID,p_AccountIds) != 0 )
								 AND tblAccount.IsVendor = 1
								 AND tblAccount.Status = 1
								 AND tblAccount.CurrencyId is not NULL
								 AND tblVendorRate.TrunkID = p_trunkID
								  AND
							        (
							           p_vendor_block = 1 OR
							          (
							             p_vendor_block = 0 AND   (
							                 blockCode.RateId IS NULL  AND blockCountry.CountryId IS NULL
							             )
							         )
							       )
								 -- AND blockCode.RateId IS NULL
								 -- AND blockCountry.CountryId IS NULL

						 ) tbl
				order by Code asc;
		END IF;				

		-- filter by Effective Dates

		IF p_groupby = 'description' THEN

		INSERT INTO tmp_VendorCurrentRates_
			Select AccountId,max(BlockingId),max(BlockingCountryId) ,max(AccountName),max(Code),Description, MAX(Rate),max(ConnectionFee),max(EffectiveDate),max(TrunkID),max(CountryID),max(RateID),max(Preference)
			FROM (
						 SELECT * ,
							 @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_Description = Description AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							 @prev_AccountId := AccountID,
							 @prev_TrunkID := TrunkID,
							 @prev_Description := Description,
							 @prev_EffectiveDate := EffectiveDate
						 FROM tmp_VendorCurrentRates1_
							 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
						 ORDER BY AccountId, TrunkID, Description, EffectiveDate DESC
					 ) tbl
			WHERE RowID = 1
			group BY AccountId, TrunkID, Description
			order by Description asc;

		ELSE

		INSERT INTO tmp_VendorCurrentRates_
			Select AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
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

		END IF;
		-- Collect Codes pressent in vendor Rates from above query.
		/*
               9372     9372    1
               9372     937     2
               9372     93      3
               9372     9       4

    */

 		-- ### change
 		IF p_ShowAllVendorCodes = 1 THEN

 				insert into tmp_all_code_ (RowCode,Code,RowNo)
				select RowCode , loopCode,RowNo
				from (
					 select   RowCode , loopCode,
					 	@RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
											 ELSE 1
								END

					 			)      as RowNo,
						 @prev_Code := tbl1.RowCode
				 		from (
						SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
								SELECT @RowNo  := @RowNo + 1 as RowNo
								FROM mysql.help_category
									,(SELECT @RowNo := 0 ) x
								limit 15
							) x
							INNER JOIN tmp_search_code_ AS f
								ON  x.RowNo   <= LENGTH(f.Code)
										AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
							INNER JOIN tblRate as tr on f.Code=tr.Code -- AND tr.CodeDeckId=p_codedeckID
								order by RowCode desc,  LENGTH(loopCode) DESC
							) tbl1
						, ( Select @RowNo := 0 ) x
					 ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;


 		ELSE 

			insert into tmp_all_code_ (RowCode,Code,RowNo)
				select RowCode , loopCode,RowNo
				from (
					 select   RowCode , loopCode,
					 	@RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
											 ELSE 1
								END

					 			)      as RowNo,
						 @prev_Code := tbl1.RowCode
				 		from (
						SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
								SELECT @RowNo  := @RowNo + 1 as RowNo
								FROM mysql.help_category
									,(SELECT @RowNo := 0 ) x
								limit 15
							) x
							INNER JOIN tmp_search_code_ AS f
								ON  x.RowNo   <= LENGTH(f.Code)
										AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
							INNER JOIN tblRate as tr on f.Code=tr.Code AND tr.CodeDeckId=p_codedeckID
								order by RowCode desc,  LENGTH(loopCode) DESC
							) tbl1
						, ( Select @RowNo := 0 ) x
					 ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;

		END IF;	


		/*IF (p_isExport = 0)
		THEN

			insert into tmp_code_
				select * from tmp_all_code_
				order by RowCode	LIMIT p_RowspPage OFFSET v_OffSet_ ;

		ELSE

			insert into tmp_code_
				select * from tmp_all_code_
				order by RowCode	  ;

		END IF;
		*/


		IF p_Preference = 1 THEN

			-- Sort by Preference

			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					AccountID,
					BlockingId ,
					BlockingCountryId,
					AccountName,
					Code,
					Rate,
					ConnectionFee,
					EffectiveDate,
					Description,
					Preference,
					preference_rank
				FROM (SELECT
								AccountID,
								BlockingId ,
								BlockingCountryId,
								AccountName,
								Code,
								Rate,
								ConnectionFee,
								EffectiveDate,
								Description,
								Preference,
								CASE WHEN p_groupby = 'description' THEN
									@preference_rank := CASE WHEN (@prev_Description     = Description AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																		WHEN (@prev_Description     = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1
																END 
								ELSE
									@preference_rank := CASE WHEN (@prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																		WHEN (@prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1
																		END 
								END AS preference_rank,										
								
								@prev_Code := Code,
								@prev_Description := Description,
								@prev_Preference := IFNULL(Preference, 5),
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS preference,
								(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							ORDER BY 
									CASE WHEN p_groupby = 'description' THEN
										preference.Description 
									ELSE
										 preference.Code 
									END ASC ,
								  preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC
						 ) tbl
				WHERE preference_rank <= p_Position
				ORDER BY Code, preference_rank;

		ELSE

			-- Sort by Rate

			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					AccountID,
					BlockingId ,
					BlockingCountryId,
					AccountName,
					Code,
					Rate,
					ConnectionFee,
					EffectiveDate,
					Description,
					Preference,
					RateRank
				FROM (SELECT
								AccountID,
								BlockingId ,
								BlockingCountryId,
								AccountName,
								Code,
								Rate,
								ConnectionFee,
								EffectiveDate,
								Description,
								Preference,
								CASE WHEN p_groupby = 'description' THEN
								@rank := CASE WHEN (@prev_Description    = Description AND @prev_Rate < Rate) THEN @rank + 1
												 WHEN (@prev_Description    = Description AND @prev_Rate = Rate) THEN @rank
												 ELSE 1
												 END
								ELSE
								@rank := CASE WHEN (@prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
												 WHEN (@prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
												 ELSE 1
												 END
								END
									AS RateRank,
								@prev_Code := Code,
								@prev_Description := Description,
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS rank,
								(SELECT @rank := 0 , @prev_Code := '' ,  @prev_Description := '' , @prev_Rate := 0) f
							ORDER BY 
								CASE WHEN p_groupby = 'description' THEN
									rank.Description 
								ELSE
									 rank.Code 
								END ,
								rank.Rate,rank.AccountId 
							
							) tbl
				WHERE RateRank <= p_Position
				ORDER BY Code, RateRank;

		END IF;

		-- --------- Split Logic ----------
		/* DESC             MaxMatchRank 1  MaxMatchRank 2
    923 Pakistan :       *923 V1          92 V1
    923 Pakistan :       *92 V2            -

    now take only where  MaxMatchRank =  1
    */


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

		-- ### change v 4.17	
		IF p_ShowAllVendorCodes = 1 THEN

			 insert ignore into tmp_VendorRate_stage_1 (
		   	     RowCode,
		     	Description ,
		     	AccountId ,
		     	AccountName ,
		     	Code ,
		     	Rate ,
		     	ConnectionFee,                                                           
		     	EffectiveDate , 
		     	Preference
				)
		         SELECT  
		          distinct                                
		   		 RowCode,
		     	Description ,
		     	AccountId ,
		     	AccountName ,
		     	Code ,
		     	Rate ,
		     	ConnectionFee,                                                           
		     	EffectiveDate , 
		     	Preference
					  	
		     	from (	
				     	select 
							CASE WHEN (tr.Code is not null OR tr.Code like concat(v.Code,'%')) THEN
									tr.Code
							ELSE
									v.Code
							END 	as RowCode,
							CASE WHEN (tr.Code is not null OR tr.Code like concat(v.Code,'%')) THEN
									tr.Description
							ELSE 
								concat(v.Description,'*') 
							END 
						 	as Description,
					     	v.AccountId ,
					     	v.AccountName ,
					     	v.Code ,
					     	v.Rate ,
					     	v.ConnectionFee,                                                           
					     	v.EffectiveDate , 
					     	v.Preference
				          FROM tmp_VendorRateByRank_ v  
				          left join  tmp_all_code_ 		SplitCode   on v.Code = SplitCode.Code 
				          
				          LEFT JOIN (	select Code,Description from tblRate where CodeDeckId=p_codedeckID AND 									  
								   	       ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
							          AND ( p_Description = ''  OR Description LIKE REPLACE(p_Description,'*', '%') )
									) tr on tr.Code=SplitCode.Code
		       			  where  SplitCode.Code is not null and rankname <= p_Position 
		       
		  		      ) tmp 
					order by AccountID,RowCode desc ,LENGTH(RowCode), Code desc, LENGTH(Code)  desc;

		ELSE 

		insert ignore into tmp_VendorRate_stage_1 (
			RowCode,
			AccountId ,
			BlockingId,
			BlockingCountryId,
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
				v.BlockingId,
				v.BlockingCountryId,
				v.AccountName ,
				v.Code ,
				v.Rate ,
				v.ConnectionFee,
				v.EffectiveDate ,
				tr.Description,
				-- (select Description from tblRate where tblRate.Code =RowCode AND  tblRate.CodeDeckId=p_codedeckID ) as Description ,
				v.Preference
			FROM tmp_VendorRateByRank_ v
				left join  tmp_all_code_ SplitCode   on v.Code = SplitCode.Code
				inner join tblRate tr  on  RowCode = tr.Code AND  tr.CodeDeckId=p_codedeckID
			where  SplitCode.Code is not null and rankname <= p_Position
			order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;

		END IF;	

		insert ignore into tmp_VendorRate_stage_
			SELECT
				distinct
				RowCode,
				v.AccountId ,
				v.BlockingId,
				v.BlockingCountryId,
				v.AccountName ,
				v.Code ,
				v.Rate ,
				v.ConnectionFee,
				v.EffectiveDate ,
				v.Description ,
				v.Preference,
				@rank := ( CASE WHEN( @prev_AccountID = v.AccountId  and @prev_RowCode     = RowCode   )
					THEN  @rank + 1
									 ELSE 1
									 END
				) AS MaxMatchRank,
				@prev_RowCode := RowCode	 ,
				@prev_AccountID := v.AccountId
			FROM tmp_VendorRate_stage_1 v
				, (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
			order by AccountID,RowCode desc ;



		IF p_groupby = 'description' THEN

			insert ignore into tmp_VendorRate_
				select
				distinct
				AccountId ,
				max(BlockingId) ,
				max(BlockingCountryId),
				max(AccountName) ,
				max(Code) ,
				max(Rate) ,
				max(ConnectionFee),
				max(EffectiveDate) ,
				Description ,
				max(Preference),
				max(RowCode)
			from tmp_VendorRate_stage_
			where MaxMatchRank = 1
			group by AccountId,Description
			order by AccountId,Description asc;

		ELSE

			insert ignore into tmp_VendorRate_
				select
					distinct
					AccountId ,
					BlockingId ,
					BlockingCountryId,
					AccountName ,
					Code ,
					Rate ,
					ConnectionFee,
					EffectiveDate ,
					Description ,
					Preference,
					RowCode
				from tmp_VendorRate_stage_
				where MaxMatchRank = 1
				order by RowCode desc;
		END IF;






		IF( p_Preference = 0 )
		THEN

			IF p_groupby = 'description' THEN
				/* group by description when preference off */

				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						(CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=tbl1.AccountId AND tmp_VendorCurrentRates1_.Description=tbl1.Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						-- (CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=tbl1.AccountId AND tmp_VendorCurrentRates1_.Description=tbl1.Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						BlockingCountryId,
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
								AccountId ,
								BlockingId,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN (@prev_Description    = Description AND  @prev_Rate <  Rate ) THEN @rank+1
											 WHEN (@prev_Description    = Description AND  @prev_Rate = Rate ) THEN @rank
											 ELSE
												 1
											 END
								AS FinalRankNumber,
								@prev_Description  := Description,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_Description := '' , @prev_Rate := 0 ) x
							order by Description,Rate,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;
			ELSE
					/* group by code when preference off */

				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						BlockingId ,
						BlockingCountryId,
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
								AccountId ,
								BlockingId ,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN ( @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
										 WHEN ( @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
										 ELSE
											 1
										 END
								AS FinalRankNumber,
								@prev_RowCode  := RowCode,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 ) x
							order by RowCode,Rate,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;

			END IF;

		ELSE

			IF p_groupby = 'description' THEN
				/* group by description when preference on */
				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						(CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=tbl1.AccountId AND tmp_VendorCurrentRates1_.Description=tbl1.Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						-- (CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=AccountId AND tmp_VendorCurrentRates1_.Description=Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						BlockingCountryId,
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
								AccountId ,
								BlockingId,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@preference_rank := CASE WHEN (@prev_Description     = Description AND @prev_Preference > Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Description     = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1 END AS FinalRankNumber,
								@prev_Description := Description,
								@prev_Preference := Preference,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 , @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							order by Description ASC ,Preference DESC ,Rate ASC ,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;
			ELSE
					/* group by code when preference on */
				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						BlockingId ,
						BlockingCountryId,
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
								AccountId ,
								BlockingId ,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1 END AS FinalRankNumber,
								@prev_Code := RowCode,
								@prev_Preference := Preference,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							order by RowCode ASC ,Preference DESC ,Rate ASC ,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;
			END IF;

		END IF;


		SET @stm_columns = "";

		-- if not export then columns must be max 10
		IF p_isExport = 0 AND p_Position > 10 THEN
			SET p_Position = 10;
		END IF;

		-- if export then all columns
		IF p_isExport = 1 THEN
			SELECT COUNT(*) INTO p_Position FROM tmp_final_VendorRate_;
		END IF;

		-- columns loop 5,10,50,...
		SET v_pointer_=1;
		WHILE v_pointer_ <= p_Position
		DO

			IF (p_isExport = 0)
			THEN
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION ",v_pointer_,"`,");
			ELSE
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y')), NULL))AS `POSITION ",v_pointer_,"`,");
			END IF;

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

		SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

		/* @stm_columns output 
		GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 1`,
		GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 2`,
		GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 3`,
		GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 4`,
		GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 5`
		*/

		IF (p_isExport = 0)
		THEN
			IF p_groupby = 'description' THEN

				SET @stm_query = CONCAT("SELECT CONCAT(max(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  t.Description ORDER BY t.Description ASC LIMIT ",p_RowspPage," OFFSET ",v_OffSet_," ;");
			
			ELSE

				SET @stm_query = CONCAT("SELECT CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,", @stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  RowCode ORDER BY RowCode ASC LIMIT ",p_RowspPage," OFFSET ",v_OffSet_," ;");

			END IF;

			SELECT count(distinct RowCode) as totalcount from tmp_final_VendorRate_
				WHERE  ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') ) ;

		END IF;

		IF p_isExport = 1
		THEN

			SET @stm_query = CONCAT("SELECT CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  RowCode ORDER BY RowCode ASC;");

		END IF;

		PREPARE stm_query FROM @stm_query;
		EXECUTE stm_query;
		DEALLOCATE PREPARE stm_query;

		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetLCRwithPrefix`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCRwithPrefix`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_codedeckID` INT,
	IN `p_CurrencyID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_Description` VARCHAR(250),
	IN `p_AccountIds` TEXT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Preference` INT,
	IN `p_Position` INT,
	IN `p_vendor_block` INT,
	IN `p_groupby` VARCHAR(50),
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_ShowAllVendorCodes` INT,
	IN `p_isExport` INT
)
BEGIN

		DECLARE v_OffSet_ int;
		DECLARE v_Code VARCHAR(50) ;
		DECLARE v_pointer_ int;
		DECLARE v_rowCount_ int;
		DECLARE v_p_code VARCHAR(50);
		DECLARE v_Codlen_ int;
		DECLARE v_position int;
		DECLARE v_p_code__ VARCHAR(50);
		DECLARE v_has_null_position int ;
		DECLARE v_next_position1 VARCHAR(200) ;
		DECLARE v_CompanyCurrencyID_ INT;


		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';

		SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RowCode VARCHAR(50) ,
			AccountId INT ,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_AccountID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
			RowCode VARCHAR(50) ,
			AccountId INT ,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_AccountID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			RateID int,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			RateID int,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50),
			FinalRankNumber int
		)
		;


		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			Code  varchar(50),
			INDEX Index1 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_ (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index1 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
		CREATE TEMPORARY TABLE tmp_all_code_ (
			RowCode  varchar(50),
			Code  varchar(50),

			INDEX Index2 (Code)
		)
		;


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
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
			INDEX IX_Code (Code)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			AccountId int,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
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
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
		CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
			AccountId INT ,
			BlockingId INT DEFAULT 0,
			BlockingCountryId INT DEFAULT 0,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,6) ,
			RateID int,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			rankname INT,
			INDEX IX_Code (Code,rankname)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_block0;
		CREATE TEMPORARY TABLE tmp_block0(
			AccountId INT,
			AccountName VARCHAR(200),
			des VARCHAR(200),
			RateId INT
		);

		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;


		### change v 4.17
		IF p_ShowAllVendorCodes = 1 THEN

				INSERT INTO tmp_VendorCurrentRates1_

				Select DISTINCT AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (

						 SELECT distinct tblVendorRate.AccountId,
						 		IFNULL(blockCode.VendorBlockingId, 0) AS BlockingId,
						 		IFNULL(blockCountry.CountryId, 0)  as BlockingCountryId,
								tblAccount.AccountName, 
								tblRate.Code, 
								tblRate.Description,
								CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
									THEN
										tblVendorRate.Rate
								WHEN  v_CompanyCurrencyID_ = p_CurrencyID
									THEN
										(
											( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
										)
								ELSE
									(

										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
										* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
									)
								END
								as  Rate,
							 ConnectionFee,
																																				DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
							 tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference
						 FROM      tblVendorRate
							 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID

							 INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID
							 INNER JOIN tblRate ON tblRate.CompanyID = p_companyid   AND    tblVendorRate.RateId = tblRate.RateID  AND vt.CodeDeckId = tblRate.CodeDeckId

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
							 ( CHAR_LENGTH(RTRIM(p_code)) = 0 OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
							 AND (p_Description='' OR tblRate.Description LIKE REPLACE(p_Description,'*','%'))
							 AND (p_AccountIds='' OR FIND_IN_SET(tblAccount.AccountID,p_AccountIds) != 0 )
							-- AND EffectiveDate <= NOW()
							 AND EffectiveDate <= DATE(p_SelectedEffectiveDate)
							 AND (tblVendorRate.EndDate is NULL OR tblVendorRate.EndDate > now() )    -- rate should not end Today
							 AND tblAccount.IsVendor = 1
							 AND tblAccount.Status = 1
							 AND tblAccount.CurrencyId is not NULL
							 AND tblVendorRate.TrunkID = p_trunkID
							 AND
						        (
						           p_vendor_block = 1 OR
						          (
						             p_vendor_block = 0 AND   (
						                 blockCode.RateId IS NULL  AND blockCountry.CountryId IS NULL
						             )
						         )
						       )
							 -- AND blockCode.RateId IS NULL
							-- AND blockCountry.CountryId IS NULL
					 ) tbl
					order by Code asc;

		ELSE 

			INSERT INTO tmp_VendorCurrentRates1_

				Select DISTINCT AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (

						 SELECT distinct tblVendorRate.AccountId,
						 		IFNULL(blockCode.VendorBlockingId, 0) AS BlockingId,
						 		IFNULL(blockCountry.CountryId, 0)  as BlockingCountryId,
								tblAccount.AccountName, tblRate.Code, tmpselectedcd.Description,
								CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
									THEN
										tblVendorRate.Rate
								WHEN  v_CompanyCurrencyID_ = p_CurrencyID
									THEN
										(
											( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
										)
								ELSE
									(

										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
										* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
									)
								END
								as  Rate,
							 ConnectionFee,
																																				DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
							 tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference
						 FROM      tblVendorRate
							 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID

							 INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID
							 INNER JOIN tblRate ON tblRate.CompanyID = p_companyid   AND    tblVendorRate.RateId = tblRate.RateID  AND vt.CodeDeckId = tblRate.CodeDeckId


						    INNER JOIN 	(select Code,Description from tblRate where CodeDeckId=p_codedeckID ) tmpselectedcd on tmpselectedcd.Code=tblRate.Code

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
							 ( CHAR_LENGTH(RTRIM(p_code)) = 0 OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
							 AND (p_Description='' OR tblRate.Description LIKE REPLACE(p_Description,'*','%'))
							 AND (p_AccountIds='' OR FIND_IN_SET(tblAccount.AccountID,p_AccountIds) != 0 )
							-- AND EffectiveDate <= NOW()
							 AND EffectiveDate <= DATE(p_SelectedEffectiveDate)
							 AND (tblVendorRate.EndDate is NULL OR tblVendorRate.EndDate > now() )    -- rate should not end Today
							 AND tblAccount.IsVendor = 1
							 AND tblAccount.Status = 1
							 AND tblAccount.CurrencyId is not NULL
							 AND tblVendorRate.TrunkID = p_trunkID
							 AND
						        (
						           p_vendor_block = 1 OR
						          (
						             p_vendor_block = 0 AND   (
						                 blockCode.RateId IS NULL  AND blockCountry.CountryId IS NULL
						             )
						         )
						       )
							 -- AND blockCode.RateId IS NULL
							-- AND blockCountry.CountryId IS NULL
					 ) tbl
					order by Code asc;

			END IF ;				


/* for grooup by description  			*/

			IF p_groupby = 'description' THEN

				INSERT INTO tmp_VendorCurrentRates_
				Select AccountId,max(BlockingId),max(BlockingCountryId) ,max(AccountName),max(Code),Description, MAX(Rate),max(ConnectionFee),max(EffectiveDate),max(TrunkID),max(CountryID),max(RateID),max(Preference)
				FROM (

							 SELECT * ,
								 @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_Description = Description AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := AccountID,
								 @prev_TrunkID := TrunkID,
								 @prev_Description := Description,
								 @prev_EffectiveDate := EffectiveDate
							 FROM tmp_VendorCurrentRates1_
								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

							 ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
						 ) tbl
				WHERE RowID = 1
				group BY AccountId, TrunkID, Description
				order by Description asc;



			Else

/* for grooup by code  */

		INSERT INTO tmp_VendorCurrentRates_
				Select AccountId,BlockingId,BlockingCountryId ,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
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

      END IF;



		IF p_Preference = 1 THEN

			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					AccountID,
					BlockingId ,
					BlockingCountryId,
					AccountName,
					Code,
					Rate,
					RateID,
					ConnectionFee,
					EffectiveDate,
					Description,
					Preference,
					preference_rank
				FROM (SELECT
								AccountID,
								BlockingId ,
								BlockingCountryId,
								AccountName,
								Code,
								Rate,
								RateID,
								ConnectionFee,
								EffectiveDate,
								Description,
								Preference,
								CASE WHEN p_groupby = 'description' THEN
									@preference_rank := CASE WHEN (@prev_Description     = Description AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																		WHEN (@prev_Description     = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1
																END 
								ELSE
									@preference_rank := CASE WHEN (@prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																		WHEN (@prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1
																		END 
								END AS preference_rank,										
								
								@prev_Code := Code,
								@prev_Description := Description,
								@prev_Preference := IFNULL(Preference, 5),
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS preference,
								(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							ORDER BY 
									CASE WHEN p_groupby = 'description' THEN
										preference.Description 
									ELSE
										 preference.Code 
									END ASC ,
								  preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC

						 ) tbl
				WHERE preference_rank <= p_Position
				ORDER BY Code, preference_rank;

		ELSE

			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					AccountID,
					BlockingId ,
					BlockingCountryId,
					AccountName,
					Code,
					Rate,
					RateID,
					ConnectionFee,
					EffectiveDate,
					Description,
					Preference,
					RateRank
				FROM (
				SELECT
								AccountID,
								BlockingId ,
								BlockingCountryId,
								AccountName,
								Code,
								Rate,
								RateID,
								ConnectionFee,
								EffectiveDate,
								Description,
								Preference,
								CASE WHEN p_groupby = 'description' THEN
								@rank := CASE WHEN (@prev_Description    = Description AND @prev_Rate < Rate) THEN @rank + 1
												 WHEN (@prev_Description    = Description AND @prev_Rate = Rate) THEN @rank
												 ELSE 1
												 END
								ELSE
								@rank := CASE WHEN (@prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
												 WHEN (@prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
												 ELSE 1
												 END
								END
									AS RateRank,
								@prev_Code := Code,
								@prev_Description := Description,
								@prev_Rate := Rate
								FROM tmp_VendorCurrentRates_ AS rank,
								(SELECT @rank := 0 , @prev_Code := '' ,  @prev_Description := '' , @prev_Rate := 0) f
								ORDER BY 
									CASE WHEN p_groupby = 'description' THEN
										rank.Description 
									ELSE
										 rank.Code 
									END ,
									rank.Rate,rank.AccountId
								
							) tbl
				WHERE RateRank <= p_Position
				ORDER BY Code, RateRank;

		END IF;


		-- ### change v 4.17	
		IF p_ShowAllVendorCodes = 1 THEN

				insert ignore into tmp_VendorRate_
				select
					distinct
					AccountId ,
					BlockingId ,
					BlockingCountryId,
					AccountName ,
					v.Code ,
					Rate ,
					RateID,
					ConnectionFee,
					EffectiveDate ,
					CASE WHEN (tr.Code is not null) THEN
						tr.Description
					ELSE 
						concat(v.Description,'*') 
					END 
					as Description,
					Preference,
					v.Code as RowCode
				from tmp_VendorRateByRank_ v
				LEFT JOIN (	
							select Code,Description from tblRate 
							where CodeDeckId=p_codedeckID AND 									  
					   				( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
									AND ( p_Description = ''  OR Description LIKE REPLACE(p_Description,'*', '%') )
					) tr on tr.Code=v.Code

				order by RowCode desc;

		ELSE

			insert ignore into tmp_VendorRate_
				select
					distinct
					AccountId ,
					BlockingId ,
					BlockingCountryId,
					AccountName ,
					Code ,
					Rate ,
					RateID,
					ConnectionFee,
					EffectiveDate ,
					Description ,
					Preference,
					Code as RowCode
				from tmp_VendorRateByRank_
				order by RowCode desc;

		END IF;
			
		IF( p_Preference = 0 )
		THEN

			 /* if group by description preference off */
			IF p_groupby = 'description' THEN


				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						BlockingId ,
						BlockingCountryId,
						AccountName ,
						Code ,
						Rate ,
						RateID,
						ConnectionFee,
						EffectiveDate ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								AccountId,
								-- (CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where AccountId=tmp_VendorRate_.AccountId AND Description=tmp_VendorRate_.Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
								(CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=AccountId AND tmp_VendorCurrentRates1_.Description=Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
								BlockingCountryId,
						      AccountName ,
								Code ,
								Rate ,
								RateID,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN (@prev_Description    = Description AND  @prev_Rate <  Rate ) THEN @rank+1
												 WHEN (@prev_Description    = Description AND  @prev_Rate = Rate ) THEN @rank
												 ELSE
													 1
												 END
								AS FinalRankNumber,
								@prev_Rate  := Rate,
								@prev_Description := Description,
								@prev_RateID  := RateID

							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_Description := '' , @prev_Rate := 0 ) x
							order by Description,Rate,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;

			ELSE
					/* if group by code start preference off */
					insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						BlockingId ,
						BlockingCountryId,
						AccountName ,
						Code ,
						Rate ,
						RateID,
						ConnectionFee,
						EffectiveDate ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								AccountId ,
								BlockingId,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								RateID,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN ( @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
												 WHEN ( @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
												 ELSE
													 1
												 END
								AS FinalRankNumber,
								@prev_RowCode  := RowCode,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 ) x
							order by RowCode,Rate,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;
					/* if group by code end  preference off*/
			END IF;

		ELSE

			IF p_groupby = 'description' THEN
				/* group by descrion when preference on */
				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						(CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId=tbl1.AccountId AND tmp_VendorCurrentRates1_.Description=tbl1.Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						-- (CASE WHEN (select COUNT(*) from tmp_VendorCurrentRates1_ where tmp_VendorCurrentRates1_.AccountId = AccountId  AND tmp_VendorCurrentRates1_.Description=Description AND BlockingId=0) > 0 THEN 0 ELSE 1 END) AS  BlockingId,
						BlockingCountryId,
						AccountName ,
						Code ,
						Rate ,
						RateID,
						ConnectionFee,
						EffectiveDate ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								AccountId ,
								BlockingId ,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								RateID,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								@preference_rank := CASE WHEN (@prev_Description    = Description AND @prev_Preference > Preference  )   THEN @preference_rank + 1
											WHEN (@prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
											WHEN (@prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
											ELSE 1 END
									AS FinalRankNumber,
								@prev_Preference := Preference,
								@prev_Description := Description,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 , @prev_Preference := 5, @prev_Description := '',  @prev_Rate := 0) x
							order by Description ASC ,Preference DESC ,Rate ASC ,AccountId ASC

						) tbl1
					where
						FinalRankNumber <= p_Position;
				ELSE

						/* group by code when preference on start*/
						insert into tmp_final_VendorRate_
							SELECT
								AccountId ,
								BlockingId ,
								BlockingCountryId,
								AccountName ,
								Code ,
								Rate ,
								RateID,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RowCode,
								FinalRankNumber
							from
								(
									SELECT
										AccountId ,
										BlockingId ,
										BlockingCountryId,
										AccountName ,
										Code ,
										Rate ,
										RateID,
										ConnectionFee,
										EffectiveDate ,
										Description ,
										Preference,
										RowCode,
										@preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1
													WHEN (@prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
													WHEN (@prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
													ELSE 1 END
										AS FinalRankNumber,
										@prev_Code := RowCode,
										@prev_Preference := Preference,
										@prev_Rate := Rate
									from tmp_VendorRate_
										,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
									order by RowCode ASC ,Preference DESC ,Rate ASC ,AccountId ASC

								) tbl1
							where
								FinalRankNumber <= p_Position;
						/* group by code when preference on end */

				END IF;
		END IF;


		SET @stm_columns = "";

		-- if not export then columns must be max 10
		IF p_isExport = 0 AND p_Position > 10 THEN
			SET p_Position = 10;
		END IF;

		-- if export then all columns
		IF p_isExport = 1 THEN
			SELECT COUNT(*) INTO p_Position FROM tmp_final_VendorRate_;
		END IF;

		-- columns loop 5,10,50,...
		SET v_pointer_=1;
		WHILE v_pointer_ <= p_Position
		DO

			IF (p_isExport = 0)
			THEN
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION ",v_pointer_,"`,");
			ELSE
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y') ), NULL))AS `POSITION ",v_pointer_,"`,");
			END IF;

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

		SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

		IF (p_isExport = 0)
		THEN

		   IF p_groupby = 'description' THEN

				SET @stm_query = CONCAT("SELECT	CONCAT(max(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  t.Description ORDER BY t.Description ASC LIMIT ",p_RowspPage," OFFSET ",v_OffSet_," ;");

					/*SELECT
					   CONCAT(max(t.Description)) as Destination,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 1`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 2`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 3`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 4`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 5`
					FROM tmp_final_VendorRate_  t
					GROUP BY  t.Description
					ORDER BY t.Description ASC
					LIMIT p_RowspPage OFFSET v_OffSet_ ;*/

			ELSE

				SET @stm_query = CONCAT("SELECT	CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  RowCode ORDER BY RowCode ASC LIMIT ",p_RowspPage," OFFSET ",v_OffSet_," ;");

					/*SELECT
					   CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 1`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 2`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 3`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 4`,
						GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.RowCode), '-', ANY_VALUE(t.BlockingCountryId) ), NULL))AS `POSITION 5`
					FROM tmp_final_VendorRate_  t
					GROUP BY  RowCode
					ORDER BY RowCode ASC
					LIMIT p_RowspPage OFFSET v_OffSet_ ;*/

			END IF;


			SELECT count(distinct RowCode) as totalcount from tmp_final_VendorRate_ where ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') );

		ELSE

			IF p_groupby = 'description' THEN

				SET @stm_query = CONCAT("SELECT CONCAT(max(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  t.Description ORDER BY t.Description ASC;");

				/*SELECT
					CONCAT(max(t.Description)) as Destination,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 1`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 2`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 3`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 4`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 5`
				FROM tmp_final_VendorRate_  t
				GROUP BY  t.Description
				ORDER BY t.Description ASC;*/

			ELSE

				SET @stm_query = CONCAT("SELECT CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  t GROUP BY  RowCode ORDER BY RowCode ASC;");

				/*SELECT
					CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 1`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 2`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 3`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 4`,
					GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),''), NULL))AS `POSITION 5`
				FROM tmp_final_VendorRate_  t
				GROUP BY  RowCode
				ORDER BY RowCode ASC;*/

			END IF;

		END IF;

		PREPARE stm_query FROM @stm_query;
		EXECUTE stm_query;
		DEALLOCATE PREPARE stm_query;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getRateTableByAccount`;
DELIMITER //
CREATE PROCEDURE `prc_getRateTableByAccount`(
	IN `p_companyid` INT,
	IN `p_level` VARCHAR(1),
	IN `p_trunkid` INT,
	IN `p_currency` INT,
	IN `p_ratetableId` INT,
	IN `p_AccountIds` TEXT,
	IN `p_services` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN

			DECLARE v_OffSet_ int;

			SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

			SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
			
			DROP TEMPORARY TABLE IF EXISTS tmp_in;
					CREATE TEMPORARY TABLE tmp_in (
						CompanyID INT ,
						AccountID INT,
						ServiceID INT ,
						RateTableID INT,
						InBoundRateTableName VARCHAR(100),
						Type INT
					);
					
			DROP TEMPORARY TABLE IF EXISTS tmp_out;
					CREATE TEMPORARY TABLE tmp_out (
						CompanyID INT ,
						AccountID INT,
						ServiceID INT ,
						RateTableID INT,
						OutBoundRateTableName VARCHAR(100),
						Type INT
					);

			DROP TEMPORARY TABLE IF EXISTS tmp_acc2;
					CREATE TEMPORARY TABLE tmp_acc2 (
						CompanyID INT ,
						AccountID INT,
						ServiceID INT ,
						RateTableID INT,
						Type INT,
						InBountRateTableID INT,
						OutBountRateTableID INT
					);

			DROP TEMPORARY TABLE IF EXISTS tmp_AccountServiceRateTable;
					CREATE TEMPORARY TABLE tmp_AccountServiceRateTable (
						AccountID INT,
						AccountName VARCHAR(100) ,
						InBoundRateTableName VARCHAR(100),			
						OutBoundRateTableName VARCHAR(100),	
						ServiceName VARCHAR(200),				
						ServiceID INT ,
						CurrencyId INT,	
						InBountRateTableID INT,
						OutBountRateTableID INT
						
					);

	/*
		p_level = 'S'  -- Service 
		p_level = 'T'  -- Trunk 
		
			*/
			
			IF (p_level="S") 
			THEN
			 
			 	/*
				Get service wise rate table 
			*/
			
			/*
			
			1. Get account with service 
			2. update service Inbound
			3  update service outbound
			4  update rate table name 
			
			*/
			 	-- 1
				insert into tmp_AccountServiceRateTable (AccountID,AccountName,ServiceName,ServiceID,CurrencyId)
				select distinct a.AccountID,a.AccountName,s.ServiceName,ass.ServiceID,a.CurrencyId 
				from  tblAccount a 
				left join tblAccountService ass  on a.AccountID=ass.AccountID
				left join tblService s on ass.ServiceID=s.ServiceID
				where a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1 AND s.`Status`=1;
			
				 
				-- 2  (Type 2 = Inbound Update)
			 
				update tmp_AccountServiceRateTable ft 
				left join tblAccountTariff att on ft.AccountID = att.AccountID AND ft.ServiceID = att.ServiceID 
				set ft.InBountRateTableID=att.RateTableID
				where att.`Type`=2 AND att.AccountTariffID is not null  ;
				
				
				-- 3 (Type 1 = Outbound Update)
				update tmp_AccountServiceRateTable ft 
				left join tblAccountTariff att on ft.AccountID = att.AccountID AND ft.ServiceID = att.ServiceID 
				set ft.OutBountRateTableID=att.RateTableID
				where att.`Type`=1 AND att.AccountTariffID is not null  ;
				
				 
				-- 4  Update Rate TAble name
				update tmp_AccountServiceRateTable ft 
				inner join tblRateTable rt on ft.InBountRateTableID=rt.RateTableId
				set ft.InBoundRateTableName=rt.RateTableName;
		 	 
		 	 
				update tmp_AccountServiceRateTable ft 
				inner join tblRateTable rt on ft.OutBountRateTableID=rt.RateTableId
				set ft.OutBoundRateTableName=rt.RateTableName;
				
					IF p_isExport = 0
					THEN 
					
						select *  from tmp_AccountServiceRateTable ft
						where
								  CASE 
										WHEN (p_ratetableId > 0 AND p_services > 0) THEN
										    ft.ServiceID=p_services AND (ft.InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
										    
										WHEN (p_services > 0) THEN
											 ft.ServiceID=p_services 
										 
									   WHEN (p_ratetableId > 0) THEN
										    (InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
									   ELSE						
											 ft.AccountName IS NOT NULL 																
									END									 
								 AND  (p_AccountIds='' OR FIND_IN_SET(ft.AccountID,p_AccountIds) != 0 )	AND ft.CurrencyId=p_currency				 
						
						 ORDER BY
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameASC') THEN InBoundRateTableName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameDESC') THEN InBoundRateTableName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameASC') THEN OutBoundRateTableName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameDESC') THEN OutBoundRateTableName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameASC') THEN ServiceName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameDESC') THEN ServiceName
						 END DESC
						 
						 				 
						LIMIT p_RowspPage OFFSET v_OffSet_; 
					 
						
						
						SELECT COUNT(*) AS `totalcount` FROM tmp_AccountServiceRateTable ft
						where
								  CASE 
										WHEN (p_ratetableId > 0 AND p_services > 0) THEN
										    ft.ServiceID=p_services AND (ft.InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
										    
										WHEN (p_services > 0) THEN
											 ft.ServiceID=p_services 
										 
									   WHEN (p_ratetableId > 0) THEN
										    (InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
									   ELSE						
											 ft.AccountName IS NOT NULL 																
									END									 
								 AND  (p_AccountIds='' OR FIND_IN_SET(ft.AccountID,p_AccountIds) != 0 ) AND ft.CurrencyId=p_currency;
				
					 
				   ELSE 
					
						select AccountName,InBoundRateTableName,OutBoundRateTableName,ServiceName  from tmp_AccountServiceRateTable ft
						where
								  CASE 
										WHEN (p_ratetableId > 0 AND p_services > 0) THEN
										    ft.ServiceID=p_services AND (ft.InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
										    
										WHEN (p_services > 0) THEN
											 ft.ServiceID=p_services 
										 
									   WHEN (p_ratetableId > 0) THEN
										    (InBountRateTableID=p_ratetableId OR ft.OutBountRateTableID=p_ratetableId)
									   ELSE						
											 ft.AccountName IS NOT NULL 																
									END									 
								 AND  (p_AccountIds='' OR FIND_IN_SET(ft.AccountID,p_AccountIds) != 0 )	AND ft.CurrencyId=p_currency				 
						
						 ORDER BY
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameASC') THEN InBoundRateTableName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameDESC') THEN InBoundRateTableName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameASC') THEN OutBoundRateTableName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameDESC') THEN OutBoundRateTableName
						 END DESC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameASC') THEN ServiceName
						 END ASC,
						 CASE
								WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameDESC') THEN ServiceName
						 END DESC
						 ;
					
					END IF;
			
				
					
			ELSE
			
			/*
			Get trunk wise rate table 
			*/
					/*
					select a.AccountID,a.AccountName,t.CustomerTrunkID,t.TrunkID from 
					tblAccount a
					left join tblCustomerTrunk t on t.AccountID=a.AccountID
					where a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1; */

					IF p_isExport = 0
					THEN 
						

					
								select distinct a.AccountID,a.AccountName,r.RateTableName,t.Trunk,r.RateTableId,t.TrunkID,ct.`Status` from tblAccount a
								join tblTrunk t
								left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
								left join tblRateTable r on ct.RateTableID=r.RateTableId
								
								where 
								CASE 
									WHEN (p_ratetableId > 0 AND p_trunkid > 0) THEN
									    r.TrunkID=p_trunkid AND
										 r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid 
									    
									WHEN (p_trunkid > 0) THEN
										 t.TrunkID=p_trunkid AND
										 a.CompanyId=p_companyid 
									 
								   WHEN (p_ratetableId > 0) THEN
									    r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid 
								   ELSE						
										 a.CompanyId=p_companyid 					
									
								END
								AND (p_AccountIds='' OR FIND_IN_SET(a.AccountID,p_AccountIds) != 0 )
								AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
								AND a.CurrencyId=p_currency AND t.`Status`=1
								
								ORDER BY	
													
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
								END DESC,
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameASC') THEN r.RateTableName
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameDESC') THEN r.RateTableName
								END DESC,
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutRateTableNameASC') THEN t.Trunk
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutRateTableNameDESC') THEN t.Trunk
								END DESC , r.RateTableName DESC , t.Trunk ASC
														 
								LIMIT p_RowspPage OFFSET v_OffSet_;
							
								
								
								
								select  COUNT(*) AS `totalcount` from  tblAccount a
								join tblTrunk t
								left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
								left join tblRateTable r on ct.RateTableID=r.RateTableId
								
								where 
								CASE 
									WHEN (p_ratetableId > 0 AND p_trunkid > 0) THEN
									    r.TrunkID=p_trunkid AND
										 r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid AND a.IsCustomer=1 
									    
									WHEN (p_trunkid > 0) THEN
										 t.TrunkID=p_trunkid AND
										 a.CompanyId=p_companyid AND a.IsCustomer=1 
									 
								   WHEN (p_ratetableId > 0) THEN
									    r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid AND a.IsCustomer=1
								   ELSE						
										 a.CompanyId=p_companyid AND a.IsCustomer=1 					
									
								END
								AND (p_AccountIds='' OR FIND_IN_SET(a.AccountID,p_AccountIds) != 0 )
								AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
								AND a.CurrencyId=p_currency  AND t.`Status`=1 ;
								 
								
							
								
								
					ELSE
					
								
								select distinct a.AccountName,r.RateTableName,t.Trunk, 
								CASE WHEN (ct.`Status`=1) THEN 'Active' ELSE 'Inactive' END As Statuss from tblAccount a
								join tblTrunk t
								left join tblCustomerTrunk ct on a.AccountID=ct.AccountID AND t.TrunkID=ct.TrunkID								
								left join tblRateTable r on ct.RateTableID=r.RateTableId
								where 
								CASE 
									WHEN (p_ratetableId > 0 AND p_trunkid > 0) THEN
									    r.TrunkID=p_trunkid AND
										 r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid  
									    
									WHEN (p_trunkid > 0) THEN
										 r.TrunkID=p_trunkid AND
										 a.CompanyId=p_companyid 
									 
								   WHEN (p_ratetableId > 0) THEN
									    r.RateTableId=p_ratetableId AND
									    a.CompanyId=p_companyid 
								   ELSE						
										 a.CompanyId=p_companyid				
									
								END
								AND (p_AccountIds='' OR FIND_IN_SET(a.AccountID,p_AccountIds) != 0 )
								AND a.IsCustomer=1 AND a.`Status`=1 AND a.AccountType=1
								AND a.CurrencyId=p_currency AND t.`Status`=1
								
								ORDER BY						
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
								END DESC,
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameASC') THEN r.RateTableName
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InBoundRateTableNameDESC') THEN r.RateTableName
								END DESC,
								CASE
									WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameASC') THEN t.Trunk
								END ASC,
								CASE
											WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutBoundRateTableNameDESC') THEN t.Trunk 
								END DESC
								;
								
								
					END IF;				
						
											
					
			END IF;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetRateTableRate`;
DELIMITER //
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
--	SET sql_mode = '';
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
   CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        ID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
		  ConnectionFee DECIMAL(18, 6),
        PreviousRate DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
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
        null as PreviousRate,
        IFNULL(tblRateTableRate.Rate, 0) as Rate,
        IFNULL(tblRateTableRate.EffectiveDate, NOW()) as EffectiveDate,
        tblRateTableRate.EndDate,
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
    WHERE		(tblRate.CompanyID = p_companyid)
		AND (p_contryID is null OR CountryID = p_contryID)
		AND (p_code is null OR Code LIKE REPLACE(p_code, '*', '%'))
		AND (p_description is null OR Description LIKE REPLACE(p_description, '*', '%'))
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

	-- update Previous Rates
	UPDATE
		tmp_RateTableRate_ tr
	SET
		PreviousRate = (SELECT Rate FROM tblRateTableRate WHERE RateTableID=p_RateTableId AND RateID=tr.RateID AND Code=tr.Code AND EffectiveDate<tr.EffectiveDate ORDER BY EffectiveDate DESC,RateTableRateID DESC LIMIT 1);

	UPDATE
		tmp_RateTableRate_ tr
	SET
		PreviousRate = (SELECT Rate FROM tblRateTableRateArchive WHERE RateTableID=p_RateTableId AND RateID=tr.RateID AND Code=tr.Code AND EffectiveDate<tr.EffectiveDate ORDER BY EffectiveDate DESC,RateTableRateID DESC LIMIT 1)
	WHERE
		PreviousRate is null;

    IF p_isExport = 0
    THEN

		IF p_view = 1
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PreviousRateDESC') THEN PreviousRate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PreviousRateASC') THEN PreviousRate
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
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

		ELSE
			SELECT group_concat(ID) AS ID, group_concat(Code) AS Code,ANY_VALUE(Description),ANY_VALUE(Interval1),ANY_VALUE(Intervaln),ANY_VALUE(ConnectionFee),ANY_VALUE(PreviousRate),ANY_VALUE(Rate),ANY_VALUE(EffectiveDate),ANY_VALUE(EndDate),MAX(updated_at) AS updated_at,MAX(ModifiedBy) AS ModifiedBy,group_concat(ID) AS RateTableRateID,group_concat(RateID) AS RateID FROM tmp_RateTableRate_
					GROUP BY Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate
					ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN ANY_VALUE(Description)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN ANY_VALUE(Description)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PreviousRateDESC') THEN ANY_VALUE(PreviousRate)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PreviousRateASC') THEN ANY_VALUE(PreviousRate)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN ANY_VALUE(Rate)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN ANY_VALUE(Rate)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN ANY_VALUE(Interval1)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN ANY_VALUE(Interval1)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN ANY_VALUE(Interval1)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN ANY_VALUE(Interval1)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN ANY_VALUE(EffectiveDate)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN ANY_VALUE(EffectiveDate)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN ANY_VALUE(EndDate)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN ANY_VALUE(EndDate)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN ANY_VALUE(updated_at)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN ANY_VALUE(updated_at)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN ANY_VALUE(ModifiedBy)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN ANY_VALUE(ModifiedBy)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN ANY_VALUE(RateTableRateID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN ANY_VALUE(RateTableRateID)
                END ASC,
				    CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ANY_VALUE(ConnectionFee)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ANY_VALUE(ConnectionFee)
                END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT COUNT(*) AS `totalcount`
			FROM (
				SELECT
	            Description
	        	FROM tmp_RateTableRate_
					GROUP BY Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate
			) totalcount;


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
            PreviousRate,
            Rate,
            EffectiveDate,
            updated_at,
            ModifiedBy

        FROM   tmp_RateTableRate_;


    END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetRateTableRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetRateTableRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_RateTableID` INT,
	IN `p_Codes` LONGTEXT,
	IN `p_View` INT
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
   CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
		  ConnectionFee VARCHAR(50),
        PreviousRate DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        updated_at DATETIME,
        ModifiedBy VARCHAR(50)
   );

	IF p_View = 1
	THEN
		INSERT INTO tmp_RateTableRate_ (
			Code,
		  	Description,
		  	Interval1,
		  	IntervalN,
		  	ConnectionFee,
--		  	PreviousRate,
		  	Rate,
		  	EffectiveDate,
		  	EndDate,
		  	updated_at,
		  	ModifiedBy
		)
	   SELECT
			r.Code,
			r.Description,
			CASE WHEN vra.Interval1 IS NOT NULL THEN vra.Interval1 ELSE r.Interval1 END AS Interval1,
			CASE WHEN vra.IntervalN IS NOT NULL THEN vra.IntervalN ELSE r.IntervalN END AS IntervalN,
			IFNULL(vra.ConnectionFee,'') AS ConnectionFee,
			vra.Rate,
			vra.EffectiveDate,
			IFNULL(vra.EndDate,'') AS EndDate,
			IFNULL(vra.created_at,'') AS ModifiedDate,
			IFNULL(vra.created_by,'') AS ModifiedBy
		FROM
			tblRateTableRateArchive vra
		JOIN
			tblRate r ON r.RateID=vra.RateId
		WHERE
			r.CompanyID = p_CompanyID AND
			vra.RateTableId = p_RateTableID AND
			FIND_IN_SET (r.Code, p_Codes) != 0
		ORDER BY
			vra.EffectiveDate DESC, vra.created_at DESC;
	ELSE
		INSERT INTO tmp_RateTableRate_ (
			Code,
		  	Description,
		  	Interval1,
		  	IntervalN,
		  	ConnectionFee,
--		  	PreviousRate,
		  	Rate,
		  	EffectiveDate,
		  	EndDate,
		  	updated_at,
		  	ModifiedBy
		)
	   SELECT
			GROUP_CONCAT(r.Code),
			r.Description,
			CASE WHEN vra.Interval1 IS NOT NULL THEN vra.Interval1 ELSE r.Interval1 END AS Interval1,
			CASE WHEN vra.IntervalN IS NOT NULL THEN vra.IntervalN ELSE r.IntervalN END AS IntervalN,
			IFNULL(vra.ConnectionFee,'') AS ConnectionFee,
			vra.Rate,
			vra.EffectiveDate,
			IFNULL(vra.EndDate,'') AS EndDate,
			IFNULL(MAX(vra.created_at),'') AS ModifiedDate,
			IFNULL(MAX(vra.created_by),'') AS ModifiedBy
		FROM
			tblRateTableRateArchive vra
		JOIN
			tblRate r ON r.RateID=vra.RateId
		WHERE
			r.CompanyID = p_CompanyID AND
			vra.RateTableId = p_RateTableID AND
			FIND_IN_SET (r.Code, p_Codes) != 0
		GROUP BY
			Description, Interval1, Intervaln, ConnectionFee, Rate, EffectiveDate, EndDate
		ORDER BY
			vra.EffectiveDate DESC, MAX(vra.created_at) DESC;
	END IF;

	SELECT
		Code,
		Description,
		Interval1,
		IntervalN,
		ConnectionFee,
		Rate,
		EffectiveDate,
		EndDate,
		IFNULL(updated_at,'') AS ModifiedDate,
		IFNULL(ModifiedBy,'') AS ModifiedBy
	FROM tmp_RateTableRate_;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getReviewRateTableRates`;
DELIMITER //
CREATE PROCEDURE `prc_getReviewRateTableRates`(
	IN `p_ProcessID` VARCHAR(50),
	IN `p_Action` VARCHAR(50),
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF p_isExport = 0
	THEN
		SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

		SELECT
			distinct
			IF(p_Action='Deleted',RateTableRateID,TempRateTableRateID) AS RateTableRateID,
			`Code`,`Description`,`Rate`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblRateTableRateChangeLog
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'))
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
			END DESC,
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(*) AS totalcount
		FROM
			tblRateTableRateChangeLog
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			distinct
			`Code`,`Description`,`Rate`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblRateTableRateChangeLog
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetVendorCodes`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorCodes`(IN `p_companyid` INT , IN `p_trunkID` INT, IN `p_contryID` VARCHAR(50) , IN `p_code` VARCHAR(50), IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` NVARCHAR(50) , IN `p_SortOrder` NVARCHAR(5) , IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
        
        IF p_isExport = 0	
		  THEN
		  
		 	 SELECT  RateID,Code FROM(
                                SELECT distinct tblRate.Code as RateID
                                    ,tblRate.Code
                                FROM      tblRate                              
                                WHERE ( tblRate.CompanyID = p_companyid )
                                AND ( p_contryID  = '' OR  FIND_IN_SET(tblRate.CountryID,p_contryID) != 0  )
                                AND ( p_code = '' OR Code LIKE REPLACE(p_code,'*', '%') )
                            ) AS TBL2
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC
				LIMIT p_RowspPage OFFSET v_OffSet_;    
  
				
				      
                                      
                    
    
		
		
		 Select Count(*) AS totalcount
      FROM
      (
      
            SELECT distinct tblRate.Code 
                                FROM      tblRate                              
                                WHERE ( tblRate.CompanyID = p_companyid )
                                AND ( p_contryID  = '' OR  FIND_IN_SET(tblRate.CountryID,p_contryID) != 0  )
                                AND ( p_code = '' OR Code LIKE REPLACE(p_code,'*', '%') )
		)	AS tbl ;
                    
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
       
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetVendorRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_Codes` LONGTEXT
)
BEGIN
	SELECT
	--	vra.VendorRateArchiveID,
	--	vra.VendorRateID,
	--	vra.AccountID,
		r.Code,
		r.Description,
		IFNULL(vra.ConnectionFee,'') AS ConnectionFee,
		CASE WHEN vra.Interval1 IS NOT NULL THEN vra.Interval1 ELSE r.Interval1 END AS Interval1,
		CASE WHEN vra.IntervalN IS NOT NULL THEN vra.IntervalN ELSE r.IntervalN END AS IntervalN,
		vra.Rate,
		vra.EffectiveDate,
		IFNULL(vra.EndDate,'') AS EndDate,
		IFNULL(vra.created_at,'') AS ModifiedDate,
		IFNULL(vra.created_by,'') AS ModifiedBy
	FROM
		tblVendorRateArchive vra
	JOIN
		tblRate r ON r.RateID=vra.RateId
	WHERE
		r.CompanyID = p_CompanyID AND
		vra.AccountId = p_AccountID AND
		FIND_IN_SET (r.Code, p_Codes) != 0
	ORDER BY
		vra.EffectiveDate DESC, vra.created_at DESC;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ImportSettingMatch`;
DELIMITER //
CREATE PROCEDURE `prc_ImportSettingMatch`(
	IN `p_companyID` INT,
	IN `p_FromEmail` TEXT,
	IN `p_subject` TEXT


,
	IN `p_filenames` TEXT

)
test:BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
		DROP TEMPORARY TABLE IF EXISTS tmp_matchRecord;
		CREATE TEMPORARY TABLE tmp_matchRecord(
			`AutoImportSettingID` INT(11),
			`CompanyID` INT(11) DEFAULT '0',
			`Type` TINYINT(1),
			`TypePKID` INT(11),
			`TrunkID` INT(11),
			`ImportFileTempleteID` INT(11),
			`Subject` VARCHAR(255),
			`FileName` VARCHAR(255),
			`SendorEmail` TEXT,
			`options` TEXT
		);
		
		DROP TEMPORARY TABLE IF EXISTS tmp_receivedFiles;
		CREATE TEMPORARY TABLE tmp_receivedFiles(	
			`fileID` INT(11) AUTO_INCREMENT,
			`receivedFilename` text,
			PRIMARY KEY (`fileID`)
		);	
		
		DROP TEMPORARY TABLE IF EXISTS tmp_matchFileLangth;
		CREATE TEMPORARY TABLE tmp_matchFileLangth(
			`lognFileName` TEXT,
			`sortFileName` TEXT,
			`matchlength` INT(11)
		);
		
		  DROP TEMPORARY TABLE IF EXISTS tmp_finalMatch;
		CREATE TEMPORARY TABLE tmp_finalMatch(
			`AutoImportSettingID` INT(11),
			`CompanyID` INT(11) DEFAULT '0',
			`Type` TINYINT(1),
			`TypePKID` INT(11),
			`TrunkID` INT(11),
			`ImportFileTempleteID` INT(11),
			`Subject` VARCHAR(255),
			`FileName` VARCHAR(255),
			`SendorEmail` TEXT,
			`options` TEXT,
			`lognFileName` TEXT,
			`matchlength` INT(11)
		);
		
		SET @values = CONCAT('("', REPLACE(p_filenames, ',', '"), ("'), '")');
		SET @insert = CONCAT('INSERT INTO tmp_receivedFiles(receivedFilename) VALUES', @values); 
		PREPARE stmt FROM @insert;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		insert tmp_matchRecord (AutoImportSettingID, CompanyID, Type, TypePKID, TrunkID, ImportFileTempleteID, Subject, FileName, SendorEmail, options)
					SELECT AutoImportSettingID, acimp.CompanyID, TYPE, TypePKID, TrunkID, acimp.ImportFileTempleteID, Subject, FileName, SendorEmail, TEMPLATE.Options
					FROM tblAutoImportSetting AS acimp
					INNER JOIN tblFileUploadTemplate AS TEMPLATE ON acimp.ImportFileTempleteID =TEMPLATE.FileUploadTemplateID
					WHERE 
					(FIND_IN_SET(LOWER(p_FromEmail), LOWER(SendorEmail)) OR FIND_IN_SET(CONCAT('*@', SUBSTRING_INDEX(LOWER(p_FromEmail),'@',-1)), LOWER(SendorEmail)))
					and 
					lower(p_subject) LIKE CONCAT('%', lower(Subject), '%')
					order by FileName desc;

		insert tmp_matchFileLangth
			select t1.receivedFilename as lognFileName, MAX(t2.FileName) as sortFileName, length(MAX(t2.FileName)) AS matchlength from tmp_receivedFiles t1 
			right join tmp_matchRecord t2 ON t1.receivedFilename like concat('%',t2.FileName,'%')
			where t1.receivedFilename is not null
			group by t1.receivedFilename
			order by matchlength desc;
		  

		  insert tmp_finalMatch 
		select tmp_matchRecord.*, tmp_matchFileLangth.lognFileName, tmp_matchFileLangth.matchlength from tmp_matchRecord inner join tmp_matchFileLangth on sortFileName=FileName;

	  DROP TEMPORARY TABLE IF EXISTS tmp_finalMatch2;
		CREATE TEMPORARY TABLE tmp_finalMatch2 as ( select * from tmp_finalMatch);
	
		select * from tmp_finalMatch where FileName in( select FileName from tmp_finalMatch2 group by FileName having count(FileName)=1 );
		
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_insertResellerData`;
DELIMITER //
CREATE PROCEDURE `prc_insertResellerData`(
	IN `p_companyid` INT,
	IN `p_childcompanyid` INT,
	IN `p_accountname` VARCHAR(100),
	IN `p_firstname` VARCHAR(100),
	IN `p_lastname` VARCHAR(100),
	IN `p_accountid` INT,
	IN `p_email` VARCHAR(100),
	IN `p_password` TEXT,
	IN `p_is_product` INT,
	IN `p_product` TEXT,
	IN `p_is_subscription` INT,
	IN `p_subscription` TEXT,
	IN `p_is_trunk` INT,
	IN `p_trunk` TEXT,
	IN `p_allowwhitelabel` INT
)
BEGIN

	DECLARE companycodedeckid int;
	DECLARE resellercodedeckid int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		SELECT @p2 as Message;
		-- ROLLBACK;
	END;		

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_currency;
	CREATE TEMPORARY TABLE tmp_currency (
		`CompanyId` INT,
		`Code` VARCHAR(50),
		`CurrencyID` INT,
		`NewCurrencyID` INT
	) ENGINE=InnoDB;

	-- START TRANSACTION;

	INSERT INTO	tblUser(CompanyID,FirstName,LastName,EmailAddress,password,AdminUser,updated_at,created_at,created_by,Status,JobNotification)	
	SELECT p_childcompanyid as CompanyID,p_firstname as FirstName,p_lastname as LastName , p_email as EmailAddress,p_password as password, 1 as AdminUser, Now(),Now(),'system' as created_by, '1' as Status, '1' as JobNotification;

	INSERT INTO tblEmailTemplate (CompanyID,TemplateName,Subject,TemplateBody,created_at,CreatedBy,updated_at,`Type`,EmailFrom,StaticType,SystemType,Status,StatusDisabled,TicketTemplate)
	SELECT DISTINCT p_childcompanyid as `CompanyID`,TemplateName,Subject,TemplateBody,NOW(),'system' as CreatedBy,NOW(),`Type`, p_email as `EmailFrom`,StaticType,SystemType,Status,StatusDisabled,TicketTemplate	
	FROM tblEmailTemplate
	WHERE StaticType=1 AND CompanyID = p_companyid ;

	INSERT INTO tblCompanyConfiguration (`CompanyID`,`Key`,`Value`)
	SELECT DISTINCT p_childcompanyid as `CompanyID`,`Key`,`Value`	
	FROM tblCompanyConfiguration
	WHERE CompanyID = p_companyid;

	INSERT INTO tblCronJobCommand (`CompanyID`,GatewayID,Title,Command,Settings,Status,created_at,created_by)
	SELECT DISTINCT p_childcompanyid as `CompanyID`,GatewayID,Title,Command,Settings,Status,created_at,created_by	
	FROM tblCronJobCommand
	WHERE CompanyID = p_companyid;

	INSERT INTO tblTaxRate (CompanyId,Title,Amount,TaxType,FlatStatus,Status,created_at,updated_at)
	SELECT DISTINCT p_childcompanyid as `CompanyId`,Title,Amount,TaxType,FlatStatus,Status,NOW(),NOW()
	FROM tblTaxRate
	WHERE CompanyId = p_companyid;

	/*
	INSERT INTO tblCurrency (CompanyId,Code,Description,Status,created_at,updated_at,Symbol)
	SELECT DISTINCT p_childcompanyid as `CompanyId` ,Code,Description,Status,NOW(),NOW(),Symbol
	FROM tblCurrency
	WHERE CompanyId = p_companyid; */

	IF p_is_product =1
	THEN	

		INSERT INTO RMBilling3.tblProduct (CompanyId,Name,Code,Description,Amount,Active,Note,CreatedBy,ModifiedBy,created_at,updated_at)
		SELECT DISTINCT p_childcompanyid as `CompanyId`,Name,Code,Description,Amount,Active,Note,'system' as CreatedBy,'system' as ModifiedBy,NOW(),NOW()
		FROM RMBilling3.tblProduct
		WHERE CompanyId = p_companyid AND FIND_IN_SET(ProductID,p_product);

	END IF;

	IF p_is_subscription = 1
	THEN

		/*
		INSERT INTO	tmp_currency(CompanyId,Code,CurrencyID)	
		SELECT p_companyid as CompanyId,Code, CurrencyId FROM `tblCurrency` WHERE CompanyId	= p_companyid;	

		UPDATE tmp_currency tc LEFT JOIN tblCurrency c ON tc.Code=c.Code AND c.CompanyId = p_childcompanyid
		set NewCurrencyID = c.CurrencyId
		WHERE c.CurrencyId IS NOT NULL;

		*/

		INSERT INTO RMBilling3.tblBillingSubscription(`CompanyID`,Name,Description,InvoiceLineDescription,ActivationFee,created_at,updated_at,ModifiedBy,CreatedBy,CurrencyID,AnnuallyFee,QuarterlyFee,MonthlyFee,WeeklyFee,DailyFee,Advance)
		SELECT DISTINCT p_childcompanyid as `CompanyID`,Name,Description,InvoiceLineDescription,ActivationFee,created_at,updated_at,ModifiedBy,CreatedBy,CurrencyID,AnnuallyFee,QuarterlyFee,MonthlyFee,WeeklyFee,DailyFee,Advance
		FROM RMBilling3.tblBillingSubscription
		WHERE CompanyID = p_companyid AND FIND_IN_SET(SubscriptionID,p_subscription);

	END IF;

	/*
	IF p_is_trunk =1
	THEN

	INSERT INTO tblTrunk (Trunk,CompanyId,RatePrefix,AreaPrefix,`Prefix`,Status,created_at,updated_at)
	SELECT DISTINCT Trunk, p_childcompanyid as `CompanyId`,RatePrefix,AreaPrefix,`Prefix`,Status,NOW(),NOW()
	FROM tblTrunk
	WHERE CompanyId = p_companyid AND FIND_IN_SET(TrunkID,p_trunk);

	END IF;
	*/

	INSERT INTO tblReseller(ResellerName,CompanyID,ChildCompanyID,AccountID,FirstName,LastName,Email,Password,Status,AllowWhiteLabel,created_at,updated_at,created_by)
	SELECT p_accountname as ResellerName,p_companyid as CompanyID,p_childcompanyid as ChildCompanyID,p_accountid as AccountID,p_firstname as FirstName,p_lastname as LastName,p_email as Email,p_password as Password,'1' as Status,p_allowwhitelabel as AllowWhiteLabel,Now(),Now(),'system' as created_by;

	INSERT INTO tblCompanySetting(`CompanyID`,`Key`,`Value`)
	SELECT p_childcompanyid as `CompanyID`,`Key`,`Value` 
	FROM tblCompanySetting
	WHERE CompanyID = p_companyid AND `Key`='RoundChargesAmount';

	SELECT CodeDeckId INTO companycodedeckid  FROM tblCodeDeck WHERE CompanyId=p_companyid AND DefaultCodedeck=1;

	IF companycodedeckid > 0 THEN
		INSERT INTO tblCodeDeck (CompanyId, CodeDeckName, created_at, CreatedBy, updated_at, ModifiedBy, `Type`, DefaultCodedeck) 
		VALUES (p_childcompanyid, 'Default Codedeck', Now(), 'Dev', Now(), NULL, NULL, 1);

		SELECT CodeDeckId INTO resellercodedeckid  FROM tblCodeDeck WHERE CompanyId=p_childcompanyid AND DefaultCodedeck=1;

		INSERT INTO tblRate(CountryID,CompanyID,CodeDeckId,Code,Description,Interval1,IntervalN,created_at)
		SELECT CountryID,p_childcompanyid as CompanyID,resellercodedeckid as CodeDeckId,Code,Description,Interval1,IntervalN,Now() as created_at FROM tblRate where CodeDeckId=companycodedeckid;


	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_lcrBlockUnblock`;
DELIMITER //
CREATE PROCEDURE `prc_lcrBlockUnblock`(
	IN `p_companyId` INT,
	IN `p_groupby` VARCHAR(200),
	IN `p_blockId` INT,
	IN `p_preference` INT,
	IN `p_accountId` INT,
	IN `p_trunk` INT,
	IN `p_rowcode` VARCHAR(50),
	IN `p_codedeckId` INT,
	IN `p_description` VARCHAR(200),
	IN `p_username` VARCHAR(50)



,
	IN `p_action` VARCHAR(50),
	IN `p_countryBlockingID` INT


)
BEGIN

   DECLARE v_countryID INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_block0;
	CREATE TEMPORARY TABLE tmp_block0(	
		RateId INT(11)
	);	
	
		IF(p_action = '') THEN 
		
				IF p_groupby = 'description' THEN
						
						
						INSERT INTO tmp_block0
								select RateId
								FROM (
								select vr.RateId
									 from tblVendorRate vr
								 	 inner join tblRate r on vr.RateId=r.RateID 
								    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Description = p_description) tbl;
						
									 	
							IF (p_blockId = 0) THEN
							
								/* insert into Vendor Blocking by description */								 
								 insert into tblVendorBlocking (AccountId,RateId,TrunkID,BlockedBy,BlockedDate)    
									    select p_accountId as AccountId, tmp0.RateID as RateId,p_trunk as TrunkID ,p_username as BlockedBy,NOW() as BlockedDate
										 from  tmp_block0 tmp0
										 	 left join tblVendorBlocking vb
											   on vb.RateId=tmp0.RateID 
											   AND vb.AccountId = p_accountId AND vb.TrunkID=p_trunk
									    where  vb.VendorBlockingId IS NULL;
							ELSE 
								select * from tmp_block0;
								/* Delete from Vendor Blocking by description  */
							
								DELETE vb
								FROM tblVendorBlocking vb
								INNER JOIN tmp_block0 t
								  ON vb.RateId = t.RateID
								WHERE vb.AccountId = p_accountId AND vb.TrunkID = p_trunk ; 
		
							END IF;	
							 
								    
								    
								    
				ELSE
					  				
						INSERT INTO tmp_block0
								select RateId
								FROM (						
								select vr.RateId
									 from tblVendorRate vr
								 	 inner join tblRate r on vr.RateId=r.RateID 
								    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Code = p_rowcode) tbl;
									 
						
						IF	(select COUNT(*)
									 from tblVendorRate vr
									 	 inner join tblRate r
										   on vr.RateId=r.RateID 
										 inner join tblVendorBlocking vb
										   on r.RateID=vb.RateId
								    where vb.AccountId = p_accountId AND vr.TrunkID=p_trunk AND r.Code = p_rowcode)	= 0		
						THEN 
						
						
							 insert into tblVendorBlocking (AccountId,RateId,TrunkID,BlockedBy)    
							    select p_accountId as AccountId,tmp0.RateID as RateId,p_trunk as TrunkID ,p_username as BlockedBy
								 from  tmp_block0 tmp0
								 	 left join tblVendorBlocking vb
									   on vb.RateId=tmp0.RateID 
									   AND vb.AccountId = p_accountId AND vb.TrunkID=p_trunk
							    where  vb.VendorBlockingId IS NULL;
							    
							    
						ELSE
							    
							    DELETE FROM `tblVendorBlocking`
								   WHERE VendorBlockingId = p_blockId ;
								/* DELETE FROM `tblVendorBlocking`
								   WHERE AccountId = p_accountId
								    AND TrunkID = p_trunk AND RateId = (select RateId from tmp_block0);*/
								    
								    
						END IF;
						
				
				END IF;
	
		ELSE
		
			   /* Country Blocking Code Start */
			   if(p_action ='country_block')
				  THEN
		
						  IF p_groupby = 'description' THEN	
								  select distinct CountryID into v_countryID from tblRate where Code=p_rowcode AND tblRate.Description=p_description AND tblRate.CountryID is not null AND tblRate.CountryID!=0 AND tblRate.CompanyID=p_companyId;
						  ELSE
								  select distinct CountryID into v_countryID from tblRate where Code=p_rowcode AND tblRate.CountryID is not null AND tblRate.CountryID!=0 AND tblRate.CompanyID=p_companyId;
						  END IF;
								  
							  
							  INSERT INTO tblVendorBlocking
							  (
									 `AccountId`
									 ,CountryId
									 ,`TrunkID`
									 ,`BlockedBy`
							  ) 
							  SELECT  
								p_accountId as AccountId
								,tblCountry.CountryID as CountryId
								,p_trunk as TrunkID
								,p_username as BlockedBy
								FROM    tblCountry
								LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunk AND AccountId = p_accountId
								WHERE  tblCountry.CountryID=v_countryID  AND tblVendorBlocking.VendorBlockingId is null; 
											  
				  END IF;
				  
				  if(p_action ='country_unblock')
				  THEN
				  
				  	delete  from tblVendorBlocking 
					WHERE  AccountId = p_accountId AND TrunkID = p_trunk AND ( p_countryBlockingID ='' OR FIND_IN_SET(CountryId, p_countryBlockingID) );
							
				
				  END IF;
			   /* Country Blocking Code End */
	    END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RateTableCheckDialstringAndDupliacteCode`;
DELIMITER //
CREATE PROCEDURE `prc_RateTableCheckDialstringAndDupliacteCode`(
	IN `p_companyId` INT,
	IN `p_processId` VARCHAR(200) ,
	IN `p_dialStringId` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_dialcodeSeparator` VARCHAR(50)
)
ThisSP:BEGIN

	DECLARE totaldialstringcode INT(11) DEFAULT 0;
	DECLARE v_CodeDeckId_ INT ;
	DECLARE totalduplicatecode INT(11);
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRateDialString_ ;
	CREATE TEMPORARY TABLE `tmp_RateTableRateDialString_` (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRateDialString_2 ;
	CREATE TEMPORARY TABLE `tmp_RateTableRateDialString_2` (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRateDialString_3 ;
	CREATE TEMPORARY TABLE `tmp_RateTableRateDialString_3` (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500),
		INDEX IX_code (code),
		INDEX IX_CodeDeckId (CodeDeckId),
		INDEX IX_Description (Description),
		INDEX IX_EffectiveDate (EffectiveDate),
		INDEX IX_DialStringPrefix (DialStringPrefix)
	);

	CALL prc_SplitRateTableRate(p_processId,p_dialcodeSeparator);

	IF  p_effectiveImmediately = 1
	THEN
		UPDATE tmp_split_RateTableRate_
		SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

		UPDATE tmp_split_RateTableRate_
		SET EndDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EndDate < DATE_FORMAT (NOW(), '%Y-%m-%d');
	END IF;

	DROP TEMPORARY TABLE IF EXISTS tmp_split_RateTableRate_2;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_split_RateTableRate_2 as (SELECT * FROM tmp_split_RateTableRate_);

	INSERT INTO tmp_TempRateTableRate_
	SELECT DISTINCT
		`TempRateTableRateID`,
		`CodeDeckId`,
		`Code`,
		`Description`,
		`Rate`,
		`EffectiveDate`,
		`EndDate`,
		`Change`,
		`ProcessId`,
		`Preference`,
		`ConnectionFee`,
		`Interval1`,
		`IntervalN`,
		`Forbidden`,
		`DialStringPrefix`
	FROM tmp_split_RateTableRate_
	WHERE tmp_split_RateTableRate_.ProcessId = p_processId;

	SELECT CodeDeckId INTO v_CodeDeckId_
	FROM tmp_TempRateTableRate_
	WHERE ProcessId = p_processId  LIMIT 1;

	UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
	LEFT JOIN tblRate
		ON tblRate.Code = tblTempRateTableRate.Code
		AND tblRate.CompanyID = p_companyId
		AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
		AND tblRate.CodeDeckId =  v_CodeDeckId_
	SET
		tblTempRateTableRate.Interval1 = CASE WHEN tblTempRateTableRate.Interval1 is not null  and tblTempRateTableRate.Interval1 > 0
		THEN
			tblTempRateTableRate.Interval1
		ELSE
			CASE WHEN tblRate.Interval1 is not null
			THEN
				tblRate.Interval1
			ELSE
				1
			END
		END,
		tblTempRateTableRate.IntervalN = CASE WHEN tblTempRateTableRate.IntervalN is not null  and tblTempRateTableRate.IntervalN > 0
		THEN
			tblTempRateTableRate.IntervalN
		ELSE
			CASE WHEN tblRate.IntervalN is not null
			THEN
				tblRate.IntervalN
			ElSE
				1
			END
		END;

	IF  p_effectiveImmediately = 1
	THEN
		UPDATE tmp_TempRateTableRate_
		SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

		UPDATE tmp_TempRateTableRate_
		SET EndDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
		WHERE EndDate < DATE_FORMAT (NOW(), '%Y-%m-%d');
	END IF;

	SELECT count(*) INTO totalduplicatecode FROM(
	SELECT count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl;

	IF  totalduplicatecode > 0
	THEN

		SELECT GROUP_CONCAT(code) into errormessage FROM(
		SELECT DISTINCT code, 1 as a FROM(
		SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl) as tbl2 GROUP by a;

		INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT
			CONCAT(code , ' DUPLICATE CODE')
		FROM(
			SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix HAVING c>1) AS tbl;
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
			FROM tmp_TempRateTableRate_ vr
			LEFT JOIN tmp_DialString_ ds
				ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
			WHERE vr.ProcessId = p_processId
				AND ds.DialStringID IS NULL
				AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

			IF totaldialstringcode > 0
			THEN

				/*INSERT INTO tmp_JobLog_ (Message)
				SELECT DISTINCT CONCAT(Code ,' ', vr.DialStringPrefix , ' No PREFIX FOUND')
				FROM tmp_TempRateTableRate_ vr
				LEFT JOIN tmp_DialString_ ds
					ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
				WHERE vr.ProcessId = p_processId
					AND ds.DialStringID IS NULL
					AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');*/

				-- Insert new dialstring if not exist
				INSERT INTO tblDialStringCode (DialStringID,DialString,ChargeCode,created_by)
				  SELECT DISTINCT p_dialStringId,vr.DialStringPrefix, Code, 'RMService'
					FROM tmp_TempRateTableRate_ vr
						LEFT JOIN tmp_DialString_ ds

							ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
						WHERE vr.ProcessId = p_processId
							AND ds.DialStringID IS NULL
							AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

				TRUNCATE tmp_DialString_;
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
				FROM tmp_TempRateTableRate_ vr
					LEFT JOIN tmp_DialString_ ds
						ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))

					WHERE vr.ProcessId = p_processId
						AND ds.DialStringID IS NULL
						AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

				INSERT INTO tmp_JobLog_ (Message)
					  SELECT DISTINCT CONCAT(Code ,' ', vr.DialStringPrefix , ' No PREFIX FOUND')
					  	FROM tmp_TempRateTableRate_ vr
							LEFT JOIN tmp_DialString_ ds

								ON ((vr.Code = ds.ChargeCode and vr.DialStringPrefix = '') OR (vr.DialStringPrefix != '' and vr.DialStringPrefix =  ds.DialString and vr.Code = ds.ChargeCode  ))
							WHERE vr.ProcessId = p_processId
								AND ds.DialStringID IS NULL
								AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

			END IF;

			IF totaldialstringcode = 0
			THEN

				INSERT INTO tmp_RateTableRateDialString_
				SELECT DISTINCT
					`TempRateTableRateID`,
					`CodeDeckId`,
					`DialString`,
					CASE WHEN ds.Description IS NULL OR ds.Description = ''
					THEN
						tblTempRateTableRate.Description
					ELSE
						ds.Description
					END
					AS Description,
					`Rate`,
					`EffectiveDate`,
					`EndDate`,
					`Change`,
					`ProcessId`,
					`Preference`,
					`ConnectionFee`,
					`Interval1`,
					`IntervalN`,
					tblTempRateTableRate.Forbidden as Forbidden ,
					tblTempRateTableRate.DialStringPrefix as DialStringPrefix
				FROM tmp_TempRateTableRate_ as tblTempRateTableRate
				INNER JOIN tmp_DialString_ ds
					ON ( (tblTempRateTableRate.Code = ds.ChargeCode AND tblTempRateTableRate.DialStringPrefix = '') OR (tblTempRateTableRate.DialStringPrefix != '' AND tblTempRateTableRate.DialStringPrefix =  ds.DialString AND tblTempRateTableRate.Code = ds.ChargeCode  ))
				WHERE tblTempRateTableRate.ProcessId = p_processId
					AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

				/*INSERT INTO tmp_RateTableRateDialString_2
				SELECT * FROM tmp_RateTableRateDialString_;*/

				INSERT INTO tmp_VendorRateDialString_2
				SELECT *  FROM tmp_VendorRateDialString_ where DialStringPrefix!='';

				Delete From tmp_VendorRateDialString_
				Where DialStringPrefix = ''
				And Code IN (Select DialStringPrefix From tmp_VendorRateDialString_2);

				INSERT INTO tmp_VendorRateDialString_3
				SELECT * FROM tmp_VendorRateDialString_;

				/*INSERT INTO tmp_RateTableRateDialString_3
				SELECT vrs1.* from tmp_RateTableRateDialString_2 vrs1
				LEFT JOIN tmp_RateTableRateDialString_ vrs2 ON vrs1.Code=vrs2.Code AND vrs1.CodeDeckId=vrs2.CodeDeckId AND vrs1.Description=vrs2.Description AND vrs1.EffectiveDate=vrs2.EffectiveDate AND vrs1.DialStringPrefix != vrs2.DialStringPrefix
				WHERE ( (vrs1.DialStringPrefix ='' AND vrs2.Code IS NULL) OR (vrs1.DialStringPrefix!='' AND vrs2.Code IS NOT NULL));*/

				DELETE  FROM tmp_TempRateTableRate_ WHERE  ProcessId = p_processId;

				INSERT INTO tmp_TempRateTableRate_(
					`TempRateTableRateID`,
					CodeDeckId,
					Code,
					Description,
					Rate,
					EffectiveDate,
					EndDate,
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
					`TempRateTableRateID`,
					`CodeDeckId`,
					`Code`,
					`Description`,
					`Rate`,
					`EffectiveDate`,
					`EndDate`,
					`Change`,
					`ProcessId`,
					`Preference`,
					`ConnectionFee`,
					`Interval1`,
					`IntervalN`,
					`Forbidden`,
					DialStringPrefix
				FROM tmp_RateTableRateDialString_3;

				UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
				JOIN tmp_DialString_ ds
					ON ( (tblTempRateTableRate.Code = ds.ChargeCode and tblTempRateTableRate.DialStringPrefix = '') OR (tblTempRateTableRate.DialStringPrefix != '' and tblTempRateTableRate.DialStringPrefix =  ds.DialString and tblTempRateTableRate.Code = ds.ChargeCode  ))
					AND tblTempRateTableRate.ProcessId = p_processId
					AND ds.Forbidden = 1
				SET tblTempRateTableRate.Forbidden = 'B';

				UPDATE tmp_TempRateTableRate_ as  tblTempRateTableRate
				JOIN tmp_DialString_ ds
					ON ( (tblTempRateTableRate.Code = ds.ChargeCode and tblTempRateTableRate.DialStringPrefix = '') OR (tblTempRateTableRate.DialStringPrefix != '' and tblTempRateTableRate.DialStringPrefix =  ds.DialString and tblTempRateTableRate.Code = ds.ChargeCode  ))
					AND tblTempRateTableRate.ProcessId = p_processId
					AND ds.Forbidden = 0
				SET tblTempRateTableRate.Forbidden = 'UB';

			END IF;

		END IF;

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RateTableRateInsertUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_RateTableRateInsertUpdate`(
	IN `p_CompanyID` INT,
	IN `p_RateTableRateID` LONGTEXT,
	IN `p_RateTableId` INT ,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ConnectionFee` DECIMAL(18, 6),
	IN `p_Critearea` INT,
	IN `p_Critearea_TrunkID` INT,
	IN `p_Critearea_CountryID` INT,
	IN `p_Critearea_Code` VARCHAR(50),
	IN `p_Critearea_Description` VARCHAR(50),
	IN `p_Critearea_Effective` VARCHAR(50),
	IN `p_Update_EffectiveDate` INT,
	IN `p_Update_EndDate` INT,
	IN `p_Update_Rate` INT,
	IN `p_Update_Interval1` INT,
	IN `p_Update_IntervalN` INT,
	IN `p_Update_ConnectionFee` INT,
	IN `p_Action` INT
)
ThisSP:BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_Update_RateTable_;
    CREATE TEMPORARY TABLE tmp_Update_RateTable_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_Insert_RateTable_;
    CREATE TEMPORARY TABLE tmp_Insert_RateTable_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_all_RateId_;
    CREATE TEMPORARY TABLE tmp_all_RateId_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
	  );


    DROP TEMPORARY TABLE IF EXISTS tmp_RateTable_;
      CREATE TEMPORARY TABLE tmp_RateTable_ (
         RateID INT,
         EffectiveDate DATE,
         RateTableRateID INT,
			INDEX tmp_RateTable_RateId (`RateId`)
     );

   IF p_Critearea = 0
	THEN
 		INSERT INTO tmp_RateTable_
			  SELECT RateID,EffectiveDate,RateTableRateID
			   FROM tblRateTableRate
					WHERE (FIND_IN_SET(RateTableRateID,p_RateTableRateID) != 0 );

	END IF;


	IF p_Critearea = 1
	THEN


		 INSERT INTO tmp_RateTable_
				SELECT
					 tblRateTableRate.RateID,
                IFNULL(tblRateTableRate.EffectiveDate, NOW()) as EffectiveDate,
                tblRateTableRate.RateTableRateID
            FROM tblRate
            LEFT JOIN tblRateTableRate
                ON tblRateTableRate.RateID = tblRate.RateID
                AND tblRateTableRate.RateTableId = p_RateTableId
            INNER JOIN tblRateTable
                ON tblRateTable.RateTableId = tblRateTableRate.RateTableId
            WHERE		(tblRate.CompanyID = p_CompanyID)
					AND (p_Critearea_CountryID = 0 OR CountryID = p_Critearea_CountryID)
					AND (p_Critearea_Code IS NULL OR Code LIKE REPLACE(p_Critearea_Code, '*', '%'))
					AND (p_Critearea_Description IS NULL OR Description LIKE REPLACE(p_Critearea_Description, '*', '%'))
					AND TrunkID = p_Critearea_TrunkID
					AND (
							p_Critearea_Effective = 'All'
						OR (p_Critearea_Effective = 'Now' AND EffectiveDate <= NOW() )
						OR (p_Critearea_Effective = 'Future' AND EffectiveDate > NOW())
						);

		  IF p_Critearea_Effective = 'Now'
		  THEN
			 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTable4_ as (select * from tmp_RateTable_);
          DELETE n1 FROM tmp_RateTable_ n1, tmp_RateTable4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
	 	   AND  n1.RateId = n2.RateId;

		  END IF;

	END IF;

	IF p_action = 1
	THEN

	IF p_Update_EffectiveDate = 0
	THEN

	INSERT INTO tmp_Update_RateTable_
		SELECT RateID,EffectiveDate,RateTableRateID
			 FROM tmp_RateTable_ ;

	END IF;

	IF p_Update_EffectiveDate = 1
	THEN


		INSERT INTO tmp_Update_RateTable_
		SELECT tblRateTableRate.RateID,
				p_EffectiveDate,
				tblRateTableRate.RateTableRateID
			 FROM tblRateTableRate
			 	INNER JOIN tmp_RateTable_ r on tblRateTableRate.RateID = r.RateID
			 	 WHERE RateTableId = p_RateTableId
					AND tblRateTableRate.EffectiveDate = p_EffectiveDate;

		INSERT INTO tmp_all_RateId_
		SELECT  tblRateTableRate.RateID,
					MAX(tblRateTableRate.EffectiveDate),
					MAX(tblRateTableRate.RateTableRateID)
				 FROM tblRateTableRate
				 	 INNER JOIN tmp_RateTable_ r on tblRateTableRate.RateID = r.RateID
					 	 WHERE tblRateTableRate.RateTableId = p_RateTableId
						  GROUP BY tblRateTableRate.RateID;

		INSERT INTO tmp_Insert_RateTable_
		SELECT r.RateID,p_EffectiveDate,r.RateTableRateID
			 FROM tmp_all_RateId_ r
			 	 LEFT JOIN tmp_Update_RateTable_ ur
					 ON r.RateID=ur.RateID
			   WHERE ur.RateID is null ;


		INSERT INTO tblRateTableRate (
			RateID,
			RateTableId,
			Rate,
			PreviousRate,
			EffectiveDate,
			created_at,
			CreatedBy,
			Interval1,
			IntervalN,
			ConnectionFee,
			EndDate
		)
	    SELECT DISTINCT  tr.RateID,
		 						RateTableId,
		 						CASE WHEN p_Update_Rate = 1
									THEN
										p_Rate
									ELSE
										tr.Rate
									END
								AS Rate,
								tr.Rate AS PreviousRate,
								p_EffectiveDate as EffectiveDate,
								NOW() as created_at,
								p_ModifiedBy as CreatedBy,
								CASE WHEN p_Update_Interval1 = 1
									THEN
										p_Interval1
									ELSE
										tr.Interval1
									END
								AS Interval1,
								CASE WHEN p_Update_IntervalN = 1
									THEN
										p_IntervalN
									ELSE
										tr.IntervalN
									END
								AS IntervalN,
								CASE WHEN p_Update_ConnectionFee = 1
									THEN
										p_ConnectionFee
									ELSE
										tr.ConnectionFee
									END
								AS ConnectionFee,
								CASE WHEN p_Update_EndDate = 1
									THEN
										p_EndDate
									ELSE
										tr.EndDate
									END
								AS EndDate
			 FROM tblRateTableRate tr
		   	 INNER JOIN tmp_Insert_RateTable_ r
			 		 ON  r.RateID = tr.RateID
			 		 	AND r.RateTableRateID = tr.RateTableRateID
	   		 		AND  RateTableId = p_RateTableId;




			-- update  previous rate with all latest recent entriy of previous effective date
			UPDATE tblRateTableRate rtr
			inner join
			(
				-- get all rates RowID = 1 to remove old to old effective date

				select distinct rt1.* ,
				@row_num := IF(@prev_RateId = rt1.RateID AND @prev_EffectiveDate >= rt1.EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_RateId := rt1.RateID,
				@prev_EffectiveDate := rt1.EffectiveDate
				from tblRateTableRate rt1
				inner join tmp_Insert_RateTable_ rt2
				on rt1.RateTableId = p_RateTableId and rt1.RateID = rt2.RateID
				and rt1.EffectiveDate < rt2.EffectiveDate
				where
				rt1.RateTableID = p_RateTableId
				order by rt1.RateID desc ,rt1.EffectiveDate desc

			) old_rtr on  old_rtr.RateTableID = rtr.RateTableID  and old_rtr.RateID = rtr.RateID and old_rtr.EffectiveDate < rtr.EffectiveDate AND rtr.EffectiveDate =  p_EffectiveDate AND old_rtr.RowID = 1
			SET rtr.PreviousRate = old_rtr.Rate
			where
			rtr.RateTableID = p_RateTableId;


	END IF;



	SET @stm = '';

	IF p_Update_Rate = 1
	THEN
		SET @stm = CONCAT(@stm,',Rate = ',p_Rate);
	END IF;

	IF p_Update_Interval1 = 1
	THEN
		SET @stm = CONCAT(@stm,',Interval1 = ',p_Interval1);
	END IF;

	IF p_Update_IntervalN = 1
	THEN
		SET @stm = CONCAT(@stm,',IntervalN = ',p_IntervalN);
	END IF;

	IF p_Update_ConnectionFee = 1
	THEN
		SET @stm = CONCAT(@stm,',ConnectionFee = ',p_ConnectionFee);
	END IF;

	IF p_Update_EndDate = 1
	THEN
		SET @stm = CONCAT(@stm,',EndDate = ','"',p_EndDate,'"');
	END IF;

	IF @stm != ''
	THEN
			SET @stm = CONCAT('
							UPDATE tblRateTableRate tr
						    INNER JOIN tmp_Update_RateTable_ r
							 	 ON  r.RateID = tr.RateID
							 	 	AND r.RateTableRateID = tr.RateTableRateID
										SET updated_at=NOW(),ModifiedBy="',p_ModifiedBy,'"',@stm,'
								    WHERE  RateTableId = ',p_RateTableId,';
						');

			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;





	END IF;


	-- Update previous rate
   call prc_RateTableRateUpdatePreviousRate(p_RateTableId,p_EffectiveDate);


	CALL prc_ArchiveOldRateTableRate(p_RateTableId,p_ModifiedBy);

	END IF;

	IF p_action = 2
	THEN
		DELETE tblRateTableRate
			 FROM tblRateTableRate
				INNER JOIN tmp_RateTable_
					ON tblRateTableRate.RateTableRateID = tmp_RateTable_.RateTableRateID;


	END IF;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RateTableRateUpdateDelete`;
DELIMITER //
CREATE PROCEDURE `prc_RateTableRateUpdateDelete`(
	IN `p_RateTableId` INT,
	IN `p_RateTableRateId` LONGTEXT,
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Rate` decimal(18,6),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ConnectionFee` decimal(18,6),
	IN `p_Critearea_CountryId` INT,
	IN `p_Critearea_Code` varchar(50),
	IN `p_Critearea_Description` varchar(200),
	IN `p_Critearea_Effective` VARCHAR(50),
	IN `p_ModifiedBy` varchar(50),
	IN `p_Critearea` INT,
	IN `p_action` INT
)
ThisSP:BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--	p_action = 1 = update rates
	--	p_action = 2 = delete rates

	DROP TEMPORARY TABLE IF EXISTS tmp_TempRateTableRate_;
	CREATE TEMPORARY TABLE tmp_TempRateTableRate_ (
		`RateTableRateId` int(11) NOT NULL,
		`RateId` int(11) NOT NULL,
		`RateTableId` int(11) NOT NULL,
		`Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
		`EffectiveDate` datetime NOT NULL,
		`EndDate` datetime DEFAULT NULL,
		`created_at` datetime DEFAULT NULL,
		`updated_at` datetime DEFAULT NULL,
		`CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
		`ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
		`Interval1` int(11) DEFAULT NULL,
		`IntervalN` int(11) DEFAULT NULL,
		`ConnectionFee` decimal(18,6) DEFAULT NULL
	);

	INSERT INTO tmp_TempRateTableRate_
	SELECT
		rtr.RateTableRateId,
		rtr.RateId,
		rtr.RateTableId,
		IFNULL(p_Rate,rtr.Rate) AS Rate,
		IFNULL(p_EffectiveDate,rtr.EffectiveDate) AS EffectiveDate,
		IFNULL(p_EndDate,rtr.EndDate) AS EndDate,
		rtr.created_at,
		NOW() AS updated_at,
		rtr.CreatedBy,
		p_ModifiedBy AS ModifiedBy,
		IFNULL(p_Interval1,rtr.Interval1) AS Interval1,
		IFNULL(p_IntervalN,rtr.IntervalN) AS IntervalN,
		IFNULL(p_ConnectionFee,rtr.ConnectionFee) AS ConnectionFee
	FROM
		tblRateTableRate rtr
	INNER JOIN
		tblRate r ON r.RateID = rtr.RateId
	WHERE
		(
			p_EffectiveDate IS NULL OR rtr.RateID NOT IN (
				SELECT
					RateID
				FROM
					tblRateTableRate
				WHERE
					EffectiveDate=p_EffectiveDate AND
					((p_Critearea = 0 AND (FIND_IN_SET(RateTableRateID,p_RateTableRateID) = 0 )) OR p_Critearea = 1) AND
					RateTableId = p_RateTableId
			)
		)
		AND
		(
			(p_Critearea = 0 AND (FIND_IN_SET(rtr.RateTableRateID,p_RateTableRateID) != 0 )) OR
			(
				p_Critearea = 1 AND
				(
					((p_Critearea_CountryId IS NULL) OR (p_Critearea_CountryId IS NOT NULL AND r.CountryId = p_Critearea_CountryId)) AND
					((p_Critearea_Code IS NULL) OR (p_Critearea_Code IS NOT NULL AND r.Code LIKE REPLACE(p_Critearea_Code,'*', '%'))) AND
					((p_Critearea_Description IS NULL) OR (p_Critearea_Description IS NOT NULL AND r.Description LIKE REPLACE(p_Critearea_Description,'*', '%'))) AND
					(
						p_Critearea_Effective = 'All' OR
						(p_Critearea_Effective = 'Now' AND rtr.EffectiveDate <= NOW() ) OR
						(p_Critearea_Effective = 'Future' AND rtr.EffectiveDate > NOW() )
					)
				)
			)
		) AND
		rtr.RateTableId = p_RateTableId;

	-- if Effective Date needs to change then remove duplicate codes
	IF p_action = 1 AND p_EffectiveDate IS NOT NULL
	THEN
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempRateTableRate_2 as (select * from tmp_TempRateTableRate_);

      DELETE n1 FROM tmp_TempRateTableRate_ n1, tmp_TempRateTableRate_2 n2 WHERE n1.RateTableRateID < n2.RateTableRateID AND  n1.RateID = n2.RateID;
	END IF;

	-- select * from tmp_TempRateTableRate_;leave ThisSP;
	-- archive and delete rates if action is 2 and also delete rates if action is 1 and rates are updating

	UPDATE
		tblRateTableRate rtr
	INNER JOIN
		tmp_TempRateTableRate_ temp ON temp.RateTableRateID = rtr.RateTableRateID
	SET
		rtr.EndDate = NOW()
	WHERE
		temp.RateTableRateID = rtr.RateTableRateID;

	CALL prc_ArchiveOldRateTableRate(p_RateTableId,p_ModifiedBy);

	IF p_action = 1
	THEN

		INSERT INTO tblRateTableRate (
			RateId,
			RateTableId,
			Rate,
			EffectiveDate,
			EndDate,
			created_at,
			updated_at,
			CreatedBy,
			ModifiedBy,
			Interval1,
			IntervalN,
			ConnectionFee
		)
		select
			RateId,
			RateTableId,
			Rate,
			EffectiveDate,
			EndDate,
			created_at,
			updated_at,
			CreatedBy,
			ModifiedBy,
			Interval1,
			IntervalN,
			ConnectionFee
		from
			tmp_TempRateTableRate_;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_SplitAndInsertRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_SplitAndInsertRateTableRate`(
	IN `TempRateTableRateID` INT,
	IN `Code` VARCHAR(500),
	IN `p_countryCode` VARCHAR(50)
)
BEGIN

	DECLARE v_First_ BIGINT;
	DECLARE v_Last_ BIGINT;

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
		INSERT my_splits (TempRateTableRateID,Code,CountryCode) VALUES (TempRateTableRateID,v_Last_,p_countryCode);
		SET v_Last_ = v_Last_ - 1;
	END WHILE;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_SplitAndInsertVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_SplitAndInsertVendorRate`(
	IN `TempVendorRateID` INT,
	IN `Code` VARCHAR(500),
	IN `p_countryCode` VARCHAR(50)
)
BEGIN

	DECLARE v_First_ BIGINT;
	DECLARE v_Last_ BIGINT;

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

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_SplitRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_SplitRateTableRate`(
	IN `p_processId` VARCHAR(200),
	IN `p_dialcodeSeparator` VARCHAR(50)
)
ThisSP:BEGIN

	DECLARE i INTEGER;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_TempRateTableRateID_ INT;
	DECLARE v_Code_ TEXT;
	DECLARE v_CountryCode_ VARCHAR(500);
	DECLARE newcodecount INT(11) DEFAULT 0;

	IF p_dialcodeSeparator !='null'
	THEN

		DROP TEMPORARY TABLE IF EXISTS `my_splits`;
		CREATE TEMPORARY TABLE `my_splits` (
			`TempRateTableRateID` INT(11) NULL DEFAULT NULL,
			`Code` Text NULL DEFAULT NULL,
			`CountryCode` Text NULL DEFAULT NULL
		);

		SET i = 1;
		REPEAT
			INSERT INTO my_splits (TempRateTableRateID, Code, CountryCode)
			SELECT TempRateTableRateID , FnStringSplit(Code, p_dialcodeSeparator, i), CountryCode  FROM tblTempRateTableRate
			WHERE FnStringSplit(Code, p_dialcodeSeparator , i) IS NOT NULL
				AND ProcessId = p_processId;

			SET i = i + 1;
			UNTIL ROW_COUNT() = 0
		END REPEAT;

		UPDATE my_splits SET Code = trim(Code);


		INSERT INTO my_splits (TempVendorRateID, Code, CountryCode)
		SELECT TempVendorRateID , Code, CountryCode  FROM tblTempVendorRate
		WHERE (CountryCode IS NOT NULL AND CountryCode <> '') AND (Code IS NULL OR Code = '')
		AND ProcessId = p_processId;


		DROP TEMPORARY TABLE IF EXISTS tmp_newratetable_splite_;
		CREATE TEMPORARY TABLE tmp_newratetable_splite_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			TempRateTableRateID INT(11) NULL DEFAULT NULL,
			Code VARCHAR(500) NULL DEFAULT NULL,
			CountryCode VARCHAR(500) NULL DEFAULT NULL
		);

		INSERT INTO tmp_newratetable_splite_(TempRateTableRateID,Code,CountryCode)
		SELECT
			TempRateTableRateID,
			Code,
			CountryCode
		FROM my_splits
		WHERE Code like '%-%'
			AND TempRateTableRateID IS NOT NULL;

		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_newratetable_splite_);

		WHILE v_pointer_ <= v_rowCount_
		DO
			SET v_TempRateTableRateID_ = (SELECT TempRateTableRateID FROM tmp_newratetable_splite_ t WHERE t.RowID = v_pointer_);
			SET v_Code_ = (SELECT Code FROM tmp_newratetable_splite_ t WHERE t.RowID = v_pointer_);
			SET v_CountryCode_ = (SELECT CountryCode FROM tmp_newratetable_splite_ t WHERE t.RowID = v_pointer_);

			Call prc_SplitAndInsertRateTableRate(v_TempRateTableRateID_,v_Code_,v_CountryCode_);

			SET v_pointer_ = v_pointer_ + 1;
		END WHILE;

		DELETE FROM my_splits
		WHERE Code like '%-%'
			AND TempRateTableRateID IS NOT NULL;

		DELETE FROM my_splits
		WHERE (Code = '' OR Code IS NULL) AND (CountryCode = '' OR CountryCode IS NULL);

		INSERT INTO tmp_split_RateTableRate_
		SELECT DISTINCT
			my_splits.TempRateTableRateID as `TempRateTableRateID`,
			`CodeDeckId`,
			CONCAT(IFNULL(my_splits.CountryCode,''),my_splits.Code) as Code,
			`Description`,
			`Rate`,
			`EffectiveDate`,
			`EndDate`,
			`Change`,
			`ProcessId`,
			`Preference`,
			`ConnectionFee`,
			`Interval1`,
			`IntervalN`,
			`Forbidden`,
			`DialStringPrefix`
		FROM my_splits
		INNER JOIN tblTempRateTableRate
			ON my_splits.TempRateTableRateID = tblTempRateTableRate.TempRateTableRateID
		WHERE	tblTempRateTableRate.ProcessId = p_processId;

	END IF;

	IF p_dialcodeSeparator = 'null'
	THEN

		INSERT INTO tmp_split_RateTableRate_
		SELECT DISTINCT
			`TempRateTableRateID`,
			`CodeDeckId`,
			CONCAT(IFNULL(tblTempRateTableRate.CountryCode,''),tblTempRateTableRate.Code) as Code,
			`Description`,
			`Rate`,
			`EffectiveDate`,
			`EndDate`,
			`Change`,
			`ProcessId`,
			`Preference`,
			`ConnectionFee`,
			`Interval1`,
			`IntervalN`,
			`Forbidden`,
			`DialStringPrefix`
		FROM tblTempRateTableRate
		WHERE ProcessId = p_processId;

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_SplitVendorRate`;
DELIMITER //
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

	INSERT INTO my_splits (TempVendorRateID, Code, CountryCode)
	SELECT TempVendorRateID , Code, CountryCode  FROM tblTempVendorRate
	WHERE (CountryCode IS NOT NULL AND CountryCode <> '') AND (Code IS NULL OR Code = '')
	AND ProcessId = p_processId;



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
		WHERE (Code = '' OR Code IS NULL) AND (CountryCode = '' OR CountryCode IS NULL);

	 INSERT INTO tmp_split_VendorRate_
	SELECT DISTINCT
		   my_splits.TempVendorRateID as `TempVendorRateID`,
		   `CodeDeckId`,
		   CONCAT(IFNULL(my_splits.CountryCode,''),my_splits.Code) as Code,
		   `Description`,
			`Rate`,
			`EffectiveDate`,
			`EndDate`,
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




	IF p_dialcodeSeparator = 'null'
	THEN

		INSERT INTO tmp_split_VendorRate_
		SELECT DISTINCT
			  `TempVendorRateID`,
			  `CodeDeckId`,
			   CONCAT(IFNULL(tblTempVendorRate.CountryCode,''),tblTempVendorRate.Code) as Code,
			   `Description`,
				`Rate`,
				`EffectiveDate`,
				`EndDate`,
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

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_VendorRateUpdateDelete`;
DELIMITER //
CREATE PROCEDURE `prc_VendorRateUpdateDelete`(
	IN `p_CompanyId` INT,
	IN `p_AccountId` INT,
	IN `p_VendorRateId` LONGTEXT,
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Rate` decimal(18,6),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ConnectionFee` decimal(18,6),
	IN `p_Critearea_CountryId` INT,
	IN `p_Critearea_Code` varchar(50),
	IN `p_Critearea_Description` varchar(200),
	IN `p_Critearea_Effective` VARCHAR(50),
	IN `p_TrunkId` INT,
	IN `p_ModifiedBy` varchar(50),
	IN `p_Critearea` INT,
	IN `p_action` INT
)
ThisSP:BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--	p_action = 1 = update rates
	--	p_action = 2 = delete rates

	DROP TEMPORARY TABLE IF EXISTS tmp_TempVendorRate_;
	CREATE TEMPORARY TABLE tmp_TempVendorRate_ (
		`VendorRateId` int(11) NOT NULL,
		`RateId` int(11) NOT NULL,
		`AccountId` int(11) NOT NULL,
		`TrunkID` int(11) NOT NULL,
		`Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
		`EffectiveDate` datetime NOT NULL,
		`EndDate` datetime DEFAULT NULL,
		`updated_at` datetime DEFAULT NULL,
		`created_at` datetime DEFAULT NULL,
		`created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
		`updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
		`Interval1` int(11) DEFAULT NULL,
		`IntervalN` int(11) DEFAULT NULL,
		`ConnectionFee` decimal(18,6) DEFAULT NULL,
		`MinimumCost` decimal(18,6) DEFAULT NULL
	);

	INSERT INTO tmp_TempVendorRate_
	SELECT
		v.VendorRateId,
		v.RateId,
		v.AccountId,
		v.TrunkID,
		IFNULL(p_Rate,v.Rate) AS Rate,
		IFNULL(p_EffectiveDate,v.EffectiveDate) AS EffectiveDate,
		IFNULL(p_EndDate,v.EndDate) AS EndDate,
		NOW() AS updated_at,
		v.created_at,
		v.created_by,
		p_ModifiedBy AS updated_by,
		IFNULL(p_Interval1,v.Interval1) AS Interval1,
		IFNULL(p_IntervalN,v.IntervalN) AS IntervalN,
		IFNULL(p_ConnectionFee,v.ConnectionFee) AS ConnectionFee,
		v.MinimumCost
	FROM
		tblVendorRate v
	INNER JOIN
		tblRate r ON r.RateID = v.RateId
	INNER JOIN
		tblVendorTrunk vt on vt.trunkID = p_TrunkId AND vt.AccountID = p_AccountId AND vt.CodeDeckId = r.CodeDeckId
	WHERE
		(
			p_EffectiveDate IS NULL OR v.RateID NOT IN (
				SELECT
					RateID
				FROM
					tblVendorRate
				WHERE
					EffectiveDate=p_EffectiveDate AND
					((p_Critearea = 0 AND (FIND_IN_SET(VendorRateID,p_VendorRateID) = 0 )) OR p_Critearea = 1) AND
					AccountId = p_AccountId
			)
		)
		AND
		(
			(p_Critearea = 0 AND (FIND_IN_SET(v.VendorRateID,p_VendorRateID) != 0 )) OR
			(
				p_Critearea = 1 AND
				(
					((p_Critearea_CountryId IS NULL) OR (p_Critearea_CountryId IS NOT NULL AND r.CountryId = p_Critearea_CountryId)) AND
					((p_Critearea_Code IS NULL) OR (p_Critearea_Code IS NOT NULL AND r.Code LIKE REPLACE(p_Critearea_Code,'*', '%'))) AND
					((p_Critearea_Description IS NULL) OR (p_Critearea_Description IS NOT NULL AND r.Description LIKE REPLACE(p_Critearea_Description,'*', '%'))) AND
					(
						p_Critearea_Effective = 'All' OR
						(p_Critearea_Effective = 'Now' AND v.EffectiveDate <= NOW() ) OR
						(p_Critearea_Effective = 'Future' AND v.EffectiveDate > NOW() )
					)
				)
			)
		) AND
		v.AccountId = p_AccountId AND
		v.TrunkID = p_TrunkId;

--	select * from tmp_TempVendorRate_;LEAVE ThisSP;

	-- if Effective Date needs to change then remove duplicate codes
	IF p_action = 1 AND p_EffectiveDate IS NOT NULL
	THEN
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempVendorRate_2 as (select * from tmp_TempVendorRate_);

		DELETE n1 FROM tmp_TempVendorRate_ n1, tmp_TempVendorRate_2 n2 WHERE n1.VendorRateID < n2.VendorRateID AND  n1.RateID = n2.RateID;
	END IF;

	-- archive and delete rates if action is 2 and also delete rates if action is 1 and rates are updating
	UPDATE
		tblVendorRate v
	INNER JOIN
		tmp_TempVendorRate_ temp ON temp.VendorRateID = v.VendorRateID
	SET
		v.EndDate = NOW()
	WHERE
		temp.VendorRateID = v.VendorRateID;

	CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId,p_ModifiedBy);

	IF p_action = 1
	THEN

		INSERT INTO tblVendorRate (
			RateId,
			AccountId,
			TrunkID,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			created_at,
			created_by,
			updated_by,
			Interval1,
			IntervalN,
			ConnectionFee,
			MinimumCost
		)
		select
			RateId,
			AccountId,
			TrunkID,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			created_at,
			created_by,
			updated_by,
			Interval1,
			IntervalN,
			ConnectionFee,
		MinimumCost
		from
			tmp_TempVendorRate_;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldCustomerRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSCronJobDeleteOldCustomerRate`(
	IN `p_DeletedBy` TEXT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

   /*DELETE cr
   FROM tblCustomerRate cr
   INNER JOIN tblCustomerRate cr2
   ON cr2.CustomerID = cr.CustomerID
   AND cr2.TrunkID = cr.TrunkID
   AND cr2.RateID = cr.RateID
   WHERE   cr.EffectiveDate <= NOW() AND cr2.EffectiveDate <= NOW() AND cr.EffectiveDate < cr2.EffectiveDate;*/

   /* SET EndDate of current time to older rates */
	-- for example there are 3 rates, today's date is 2018-04-11
	-- 1. Code 	Rate 	EffectiveDate
	-- 1. 91 	0.1 	2018-04-09
	-- 2. 91 	0.2 	2018-04-10
	-- 3. 91 	0.3 	2018-04-11
	/* Then it will delete 2018-04-09 and 2018-04-10 date's rate */
	UPDATE
		tblCustomerRate cr
	INNER JOIN tblCustomerRate cr2
		ON cr2.CustomerID = cr.CustomerID
		AND cr2.TrunkID = cr.TrunkID
		AND cr2.RateID = cr.RateID
	SET
		cr.EndDate=NOW()
	WHERE
		cr.EffectiveDate <= NOW() AND
		cr2.EffectiveDate <= NOW() AND
		cr.EffectiveDate < cr2.EffectiveDate;

   INSERT INTO tblCustomerRateArchive
	SELECT DISTINCT  null , -- Primary Key column
		`CustomerRateID`,
		`CustomerID`,
		`TrunkID`,
		`RateId`,
		`Rate`,
		`EffectiveDate`,
		IFNULL(`EndDate`,date(now())) as EndDate,
		now() as `created_at`,
		p_DeletedBy AS `created_by`,
		`LastModifiedDate`,
		`LastModifiedBy`,
		`Interval1`,
		`IntervalN`,
		`ConnectionFee`,
		`RoutinePlan`,
		concat('Ends Today rates @ ' , now() ) as `Notes`
	FROM
		tblCustomerRate
	WHERE
		EndDate <= NOW();


	DELETE  cr
	FROM tblCustomerRate cr
	INNER JOIN tblCustomerRateArchive cra
	ON cr.CustomerRateID = cra.CustomerRateID;

   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSCronJobDeleteOldRateTableRate`(
	IN `p_DeletedBy` TEXT
)
ThisSP:BEGIN

/*	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

   DELETE rtr
      FROM tblRateTableRate rtr
      INNER JOIN tblRateTableRate rtr2
      ON rtr.RateTableId = rtr2.RateTableId
      AND rtr.RateID = rtr2.RateID
      WHERE rtr.EffectiveDate <= NOW()
			AND rtr2.EffectiveDate <= NOW()
         AND rtr.EffectiveDate < rtr2.EffectiveDate;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;      */

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	-- UPDATE tblRateTableRate SET EndDate=NULL where EndDate='0000-00-00';

	UPDATE
		tblRateTableRate rtr
	INNER JOIN tblRateTableRate rtr2
		ON rtr2.RateTableId = rtr.RateTableId
		AND rtr2.RateID = rtr.RateID
	SET
		rtr.EndDate=NOW()
	WHERE
		rtr.EffectiveDate <= NOW() AND
		rtr2.EffectiveDate <= NOW() AND
		rtr.EffectiveDate < rtr2.EffectiveDate;

	INSERT INTO tblRateTableRateArchive
   SELECT DISTINCT  null , -- Primary Key column
							vr.`RateTableRateID`,
							vr.`RateTableId`,
							vr.`RateId`,
							vr.`Rate`,
							vr.`EffectiveDate`,
							IFNULL(vr.`EndDate`,date(now())) as EndDate,
							vr.`updated_at`,
							now() as created_at,
							p_DeletedBy AS `created_by`,
							vr.`ModifiedBy`,
							vr.`Interval1`,
							vr.`IntervalN`,
							vr.`ConnectionFee`,
	   					concat('Ends Today rates @ ' , now() ) as `Notes`
      FROM
			tblRateTableRate vr
		WHERE
			vr.EndDate <= NOW();


	DELETE  vr
	FROM tblRateTableRate vr
   inner join tblRateTableRateArchive vra
   on vr.RateTableRateID = vra.RateTableRateID;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSGenerateRateSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateSheet`(
	IN `p_CustomerID` INT,
	IN `p_Trunk` VARCHAR(100)
)
BEGIN
		DECLARE v_trunkDescription_ VARCHAR(50);
		DECLARE v_lastRateSheetID_ INT ;
		DECLARE v_IncludePrefix_ TINYINT;
		DECLARE v_Prefix_ VARCHAR(50);
		DECLARE v_codedeckid_  INT;
		DECLARE v_ratetableid_ INT;
		DECLARE v_RateTableAssignDate_  DATETIME;
		DECLARE v_NewA2ZAssign_ INT;

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


		SELECT trunk INTO v_trunkDescription_
		FROM   tblTrunk
		WHERE  TrunkID = p_Trunk;

		DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetRate_;
		CREATE TEMPORARY TABLE tmp_RateSheetRate_(
			RateID        INT,
			Destination   VARCHAR(200),
			Codes         VARCHAR(50),
			Interval1     INT,
			IntervalN     INT,
			Rate          DECIMAL(18, 6),
			`level`         VARCHAR(50),
			`change`        VARCHAR(50),
			EffectiveDate  DATE,
			EndDate  DATE,
			INDEX tmp_RateSheetRate_RateID (`RateID`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
		CREATE TEMPORARY TABLE tmp_CustomerRates_ (
			RateID INT,
			Interval1 INT,
			IntervalN  INT,
			Rate DECIMAL(18, 6),
			EffectiveDate DATE,
			EndDate DATE,
			LastModifiedDate DATETIME,
			INDEX tmp_CustomerRates_RateId (`RateID`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
		CREATE TEMPORARY TABLE tmp_RateTableRate_ (
			RateID INT,
			Interval1 INT,
			IntervalN  INT,
			Rate DECIMAL(18, 6),
			EffectiveDate DATE,
			EndDate DATE,
			updated_at DATETIME,
			INDEX tmp_RateTableRate_RateId (`RateID`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetDetail_;
		CREATE TEMPORARY TABLE tmp_RateSheetDetail_ (
			ratesheetdetailsid int,
			RateID int ,
			RateSheetID int,
			Destination varchar(200),
			Code varchar(50),
			Rate DECIMAL(18, 6),
			`change` varchar(50),
			EffectiveDate Date,
			EndDate DATE,
			INDEX tmp_RateSheetDetail_RateId (`RateID`,`RateSheetID`)
		);
		SELECT RateSheetID INTO v_lastRateSheetID_
		FROM   tblRateSheet
		WHERE  CustomerID = p_CustomerID
					 AND level = v_trunkDescription_
		ORDER  BY RateSheetID DESC LIMIT 1 ;

		SELECT includeprefix INTO v_IncludePrefix_
		FROM   tblCustomerTrunk
		WHERE  AccountID = p_CustomerID
					 AND TrunkID = p_Trunk;

		SELECT prefix INTO v_Prefix_
		FROM   tblCustomerTrunk
		WHERE  AccountID = p_CustomerID
					 AND TrunkID = p_Trunk;


		SELECT
			CodeDeckId,
			RateTableID,
			RateTableAssignDate
		INTO v_codedeckid_, v_ratetableid_, v_RateTableAssignDate_
		FROM tblCustomerTrunk
		WHERE tblCustomerTrunk.TrunkID = p_Trunk
					AND tblCustomerTrunk.AccountID = p_CustomerID
					AND tblCustomerTrunk.Status = 1;

		INSERT INTO tmp_CustomerRates_
			SELECT  tblCustomerRate.RateID,
				tblCustomerRate.Interval1,
				tblCustomerRate.IntervalN,
				tblCustomerRate.Rate,
				effectivedate,
				tblCustomerRate.EndDate,
				lastmodifieddate
			FROM   tblAccount
				JOIN tblCustomerRate
					ON tblAccount.AccountID = tblCustomerRate.CustomerID
				JOIN tblRate
					ON tblRate.RateId = tblCustomerRate.RateId
						 AND tblRate.CodeDeckId = v_codedeckid_
			WHERE  tblAccount.AccountID = p_CustomerID
						 AND tblCustomerRate.TrunkID = p_Trunk
			ORDER BY tblCustomerRate.CustomerID,tblCustomerRate.TrunkID,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;

		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates4_;
		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates2_;

		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates4_ as (select * from tmp_CustomerRates_);
		DELETE n1 FROM tmp_CustomerRates_ n1, tmp_CustomerRates4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
																																			 AND  n1.RateId = n2.RateId;

		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates2_ as (select * from tmp_CustomerRates_);

		INSERT INTO tmp_RateTableRate_
			SELECT
				tblRateTableRate.RateID,
				tblRateTableRate.Interval1,
				tblRateTableRate.IntervalN,
				tblRateTableRate.Rate,
				tblRateTableRate.EffectiveDate,
				tblRateTableRate.EndDate,
				tblRateTableRate.updated_at
			FROM tblAccount
				JOIN tblCustomerTrunk
					ON tblCustomerTrunk.AccountID = tblAccount.AccountID
				JOIN tblRateTable
					ON tblCustomerTrunk.ratetableid = tblRateTable.ratetableid
				JOIN tblRateTableRate
					ON tblRateTableRate.ratetableid = tblRateTable.ratetableid
				LEFT JOIN tmp_CustomerRates_ trc1
					ON trc1.RateID = tblRateTableRate.RateID
			WHERE  tblAccount.AccountID = p_CustomerID

						 AND tblCustomerTrunk.TrunkID = p_Trunk
						 AND (( tblRateTableRate.EffectiveDate <= Now()
										AND ( ( trc1.RateID IS NULL )
													OR ( trc1.RateID IS NOT NULL
															 AND tblRateTableRate.ratetablerateid IS NULL )
										) )
									OR ( tblRateTableRate.EffectiveDate > Now()
											 AND ( ( trc1.RateID IS NULL )
														 OR ( trc1.RateID IS NOT NULL
																	AND tblRateTableRate.EffectiveDate < (SELECT
																																					IFNULL(MIN(crr.EffectiveDate),
																																								 tblRateTableRate.EffectiveDate)
																																				FROM   tmp_CustomerRates2_ crr
																																				WHERE  crr.RateID =
																																							 tblRateTableRate.RateID
			) ) ) ) )
			ORDER BY tblRateTableRate.RateID,tblRateTableRate.EffectiveDate desc;

		DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate4_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);
		DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
																																			 AND  n1.RateId = n2.RateId;

		INSERt INTO tmp_RateSheetDetail_
			SELECT ratesheetdetailsid,
				RateID,
				RateSheetID,
				Destination,
				Code,
				Rate,
				`change`,
				effectivedate,
				EndDate
			FROM   tblRateSheetDetails
			WHERE  RateSheetID = v_lastRateSheetID_
			ORDER BY RateID,effectivedate desc;

		DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetDetail4_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateSheetDetail4_ as (select * from tmp_RateSheetDetail_);
		DELETE n1 FROM tmp_RateSheetDetail_ n1, tmp_RateSheetDetail4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
																																					 AND  n1.RateId = n2.RateId;


		DROP TABLE IF EXISTS tmp_CloneRateSheetDetail_ ;
		CREATE TEMPORARY TABLE tmp_CloneRateSheetDetail_ LIKE tmp_RateSheetDetail_;
		INSERT tmp_CloneRateSheetDetail_ SELECT * FROM tmp_RateSheetDetail_;


		INSERT INTO tmp_RateSheetRate_
			SELECT tbl.RateID,
				description,
				Code,
				tbl.Interval1,
				tbl.IntervalN,
				tbl.Rate,
				v_trunkDescription_,
				'NEW' as `change`,
				tbl.EffectiveDate,
				tbl.EndDate
			FROM   (
							 SELECT
								 rt.RateID,
								 rt.Interval1,
								 rt.IntervalN,
								 rt.Rate,
								 rt.EffectiveDate,
								 rt.EndDate
							 FROM   tmp_RateTableRate_ rt
								 LEFT JOIN tblRateSheet
									 ON tblRateSheet.RateSheetID =
											v_lastRateSheetID_
								 LEFT JOIN tmp_RateSheetDetail_ as  rsd
									 ON rsd.RateID = rt.RateID AND rsd.RateSheetID = v_lastRateSheetID_
							 WHERE  rsd.ratesheetdetailsid IS NULL

							 UNION

							 SELECT
								 trc2.RateID,
								 trc2.Interval1,
								 trc2.IntervalN,
								 trc2.Rate,
								 trc2.EffectiveDate,
								 trc2.EndDate
							 FROM   tmp_CustomerRates_ trc2
								 LEFT JOIN tblRateSheet
									 ON tblRateSheet.RateSheetID =
											v_lastRateSheetID_
								 LEFT JOIN tmp_CloneRateSheetDetail_ as  rsd2
									 ON rsd2.RateID = trc2.RateID AND rsd2.RateSheetID = v_lastRateSheetID_
							 WHERE  rsd2.ratesheetdetailsid IS NULL

						 ) AS tbl
				INNER JOIN tblRate
					ON tbl.RateID = tblRate.RateID;

		INSERT INTO tmp_RateSheetRate_
			SELECT tbl.RateID,
				description,
				Code,
				tbl.Interval1,
				tbl.IntervalN,
				tbl.Rate,
				v_trunkDescription_,
				tbl.`change`,
				tbl.EffectiveDate,
				tbl.EndDate
			FROM   (SELECT rt.RateID,
								description,
								tblRate.Code,
								rt.Interval1,
								rt.IntervalN,
								rt.Rate,
								rsd5.Rate AS rate2,
								rt.EffectiveDate,
								rt.EndDate,
								CASE
								WHEN rsd5.Rate > rt.Rate
										 AND rsd5.Destination !=
												 description THEN
									'NAME CHANGE & DECREASE'
								ELSE
									CASE
									WHEN rsd5.Rate > rt.Rate
											 AND rt.EffectiveDate <= Now() THEN
										'DECREASE'
									ELSE
										CASE
										WHEN ( rsd5.Rate >
													 rt.Rate
													 AND rt.EffectiveDate > Now()
										)
											THEN
												'PENDING DECREASE'
										ELSE
											CASE
											WHEN ( rsd5.Rate <
														 rt.Rate
														 AND rt.EffectiveDate <=
																 Now() )
												THEN
													'INCREASE'
											ELSE
												CASE
												WHEN ( rsd5.Rate
															 <
															 rt.Rate
															 AND rt.EffectiveDate >
																	 Now() )
													THEN
														'PENDING INCREASE'
												ELSE
													CASE
													WHEN
														rsd5.Destination !=
														description THEN
														'NAME CHANGE'
													ELSE 'NO CHANGE'
													END
												END
											END
										END
									END
								END as `Change`
							FROM   tblRate
								INNER JOIN tmp_RateTableRate_ rt
									ON rt.RateID = tblRate.RateID
								INNER JOIN tblRateSheet
									ON tblRateSheet.RateSheetID = v_lastRateSheetID_
								INNER JOIN tmp_RateSheetDetail_ as  rsd5
									ON rsd5.RateID = rt.RateID
										 AND rsd5.RateSheetID =
												 v_lastRateSheetID_
							UNION
							SELECT trc4.RateID,
								description,
								tblRate.Code,
								trc4.Interval1,
								trc4.IntervalN,
								trc4.Rate,
								rsd6.Rate AS rate2,
								trc4.EffectiveDate,
								trc4.EndDate,
								CASE
								WHEN rsd6.Rate > trc4.Rate
										 AND rsd6.Destination !=
												 description THEN
									'NAME CHANGE & DECREASE'
								ELSE
									CASE
									WHEN rsd6.Rate > trc4.Rate
											 AND trc4.EffectiveDate <= Now() THEN
										'DECREASE'
									ELSE
										CASE
										WHEN ( rsd6.Rate >
													 trc4.Rate
													 AND trc4.EffectiveDate > Now()
										)
											THEN
												'PENDING DECREASE'
										ELSE
											CASE
											WHEN ( rsd6.Rate <
														 trc4.Rate
														 AND trc4.EffectiveDate <=
																 Now() )
												THEN
													'INCREASE'
											ELSE
												CASE
												WHEN ( rsd6.Rate
															 <
															 trc4.Rate
															 AND trc4.EffectiveDate >
																	 Now() )
													THEN
														'PENDING INCREASE'
												ELSE
													CASE
													WHEN
														rsd6.Destination !=
														description THEN
														'NAME CHANGE'
													ELSE 'NO CHANGE'
													END
												END
											END
										END
									END
								END as  `Change`
							FROM   tblRate
								INNER JOIN tmp_CustomerRates_ trc4
									ON trc4.RateID = tblRate.RateID
								INNER JOIN tblRateSheet
									ON tblRateSheet.RateSheetID = v_lastRateSheetID_
								INNER JOIN tmp_CloneRateSheetDetail_ as rsd6
									ON rsd6.RateID = trc4.RateID
										 AND rsd6.RateSheetID =
												 v_lastRateSheetID_
						 ) AS tbl ;

		INSERT INTO tmp_RateSheetRate_
			SELECT tblRateSheetDetails.RateID,
				tblRateSheetDetails.Destination,
				tblRateSheetDetails.Code,
				tblRateSheetDetails.Interval1,
				tblRateSheetDetails.IntervalN,
				tblRateSheetDetails.Rate,
				v_trunkDescription_,
				'DELETE',
				tblRateSheetDetails.EffectiveDate,
				tblRateSheetDetails.EndDate
			FROM   tblRate
				INNER JOIN tblRateSheetDetails
					ON tblRate.RateID = tblRateSheetDetails.RateID
						 AND tblRateSheetDetails.RateSheetID = v_lastRateSheetID_
				LEFT JOIN (SELECT DISTINCT RateID,
										 effectivedate
									 FROM   tmp_RateTableRate_
									 UNION
									 SELECT DISTINCT RateID,
										 effectivedate
									 FROM tmp_CustomerRates_) AS TBL
					ON TBL.RateID = tblRateSheetDetails.RateID
			WHERE  `change` != 'DELETE'
						 AND TBL.RateID IS NULL ;

		DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetRate4_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateSheetRate4_ as (select * from tmp_RateSheetRate_);
		DELETE n1 FROM tmp_RateSheetRate_ n1, tmp_RateSheetRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
																																			 AND  n1.RateId = n2.RateId;

		IF v_IncludePrefix_ = 1
		THEN
			SELECT rsr.RateID AS rateid,
						 rsr.Interval1 AS interval1,
						 rsr.IntervalN AS intervaln,
						 rsr.Destination AS destination,
						 rsr.Codes AS codes,
						 v_Prefix_ AS `tech prefix`,
						 CONCAT(rsr.Interval1,'/',rsr.IntervalN) AS `interval`,
						 FORMAT(rsr.Rate,6) AS `rate per minute (usd)`,
				rsr.`level`,
				rsr.`change`,
						 rsr.EffectiveDate AS `effective date`,
						 rsr.EndDate AS `end date`
			FROM   tmp_RateSheetRate_ rsr

			ORDER BY rsr.Destination,rsr.Codes desc;
		ELSE
			SELECT rsr.RateID AS rateid ,
						 rsr.Interval1 AS interval1,
						 rsr.IntervalN AS intervaln,
						 rsr.Destination AS destination,
						 rsr.Codes AS codes,
						 CONCAT(rsr.Interval1,'/',rsr.IntervalN) AS  `interval`,
						 FORMAT(rsr.Rate, 6) AS `rate per minute (usd)`,
				rsr.`level`,
				rsr.`change`,
						 rsr.EffectiveDate AS `effective date`,
						 rsr.EndDate AS `end date`
			FROM   tmp_RateSheetRate_ rsr

			ORDER BY rsr.Destination,rsr.Codes DESC;
		END IF;

		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTable`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_GroupBy` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50)


)
GenerateRateTable:BEGIN


		DECLARE i INTEGER;
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

		DECLARE v_IncreaseEffectiveDate_ DATETIME ;
		DECLARE v_DecreaseEffectiveDate_ DATETIME ;





		DECLARE v_tmp_code_cnt int ;
		DECLARE v_tmp_code_pointer int;
		DECLARE v_p_code varchar(50);
		DECLARE v_Codlen_ int;
		DECLARE v_p_code__ VARCHAR(50);
		DECLARE v_Commit int;
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW WARNINGS;
			ROLLBACK;
			CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

		END;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; -- change group_concat limit for group by


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
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates_code (`code`) ,
			UNIQUE KEY `unique_code` (`code`)

		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
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
			`Order` INT,
			INDEX tmp_Raterules_code (`code`,`description`),
			INDEX tmp_Raterules_rateruleid (`rateruleid`),
			INDEX tmp_Raterules_RowNo (`RowNo`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_dup;

		CREATE TEMPORARY TABLE tmp_Raterules_dup  (
			rateruleid INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			RowNo INT,
			`Order` INT,
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

		-- when group by description this table use to insert comma seperated codes
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_GroupBy_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_GroupBy_(
			AccountId int,
			AccountName varchar(200),
			Code LONGTEXT,
			Description varchar(200) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int/*,
			INDEX IX_CODE (Code)*/
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

		-- get Increase Decrease date from Job
		SELECT IFNULL(REPLACE(JSON_EXTRACT(Options, '$.IncreaseEffectiveDate'),'"',''), p_EffectiveDate) , IFNULL(REPLACE(JSON_EXTRACT(Options, '$.DecreaseEffectiveDate'),'"',''), p_EffectiveDate)   INTO v_IncreaseEffectiveDate_ , v_DecreaseEffectiveDate_  FROM tblJob WHERE Jobid = p_jobId;


		IF v_IncreaseEffectiveDate_ is null OR v_IncreaseEffectiveDate_ = '' THEN

			SET v_IncreaseEffectiveDate_ = p_EffectiveDate;

		END IF;

		IF v_DecreaseEffectiveDate_ is null OR v_DecreaseEffectiveDate_ = '' THEN

			SET v_DecreaseEffectiveDate_ = p_EffectiveDate;

		END IF;


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
				@row_num := @row_num+1 AS RowID,
				tblRateRule.`Order`
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = p_RateGeneratorId
			ORDER BY tblRateRule.`Order` ASC;  -- <== order of rule is important

		-- v 4.17 fix process rules in order  -- NEON-1292 		Otto Rate Generator issue
		insert into tmp_Raterules_dup (			rateruleid ,		code ,		description ,		RowNo 	,	`Order`)
		select rateruleid ,		code ,		description ,		RowNo, `Order` from tmp_Raterules_;

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
		SET v_rowCount_ = (SELECT COUNT(distinct concat(Code,Description) ) FROM tmp_Raterules_);




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
						 ON   ( rr.code = '' OR (rr.code != '' AND tblRate.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
									AND
									( rr.description = '' OR ( rr.description != '' AND tblRate.Description LIKE (REPLACE(rr.description,'*', '%%')) ) )
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
								 (p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
								 OR
								 (	 p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate
										 AND ( tblVendorRate.EndDate IS NULL OR (tblVendorRate.EndDate > DATE(p_EffectiveDate)) )
								 )  -- rate should not end on selected effective date
							 )
							 AND ( tblVendorRate.EndDate IS NULL OR tblVendorRate.EndDate > now() )  -- rate should not end Today
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

		IF p_GroupBy = 'Desc' -- Group By Description
		THEN
			-- insert all rates and if code is multiple then insert it as comma seperated values
			INSERT INTO tmp_VendorCurrentRates_GroupBy_
				Select AccountId,max(AccountName),GROUP_CONCAT(Code),Description,max(Rate),max(ConnectionFee),max(EffectiveDate),TrunkID,max(CountryID),max(RateID),max(Preference)
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
				GROUP BY AccountId, TrunkID, Description
				order by Description asc;

				-- split and insert comma seperated codes
				SET i = 1;
				REPEAT
					INSERT INTO tmp_VendorCurrentRates_ (AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference)
				  	SELECT
					  	AccountId,AccountName,FnStringSplit(Code, ',', i),Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
					FROM
						tmp_VendorCurrentRates_GroupBy_
				  	WHERE
					  	FnStringSplit(Code, ',' , i) IS NOT NULL;

					SET i = i + 1;
				  	UNTIL ROW_COUNT() = 0
				END REPEAT;

		ELSE

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

		END IF;










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
										 select distinct tmpvr.*
										 from tmp_VendorRate_  tmpvr
											 inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																											 (
																												 ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
																												 OR
																												 ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																											 )
											 left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																											 (
																												 ( rr2.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr2.code,'*', '%%')) )
																												 OR
																												 ( rr2.description != '' AND tmpvr.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																											 )
											 inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
										 	 where rr2.code is null

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

								select distinct tmpvr.*
								from tmp_VendorRate_  tmpvr
									inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																									(
																										( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
																										OR
																										( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																									)
									left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																											(
																												( rr2.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr2.code,'*', '%%')) )
																												OR
																												( rr2.description != '' AND tmpvr.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																											)
									inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
									where rr2.code is null

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

				INSERT IGNORE INTO tmp_Rates_ (code,rate,ConnectionFee,PreviousRate)
                SELECT RowCode,
                    CASE WHEN rule_mgn.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin END)
                            WHEN trim(IFNULL(FixedValue,"")) != '' THEN
                                FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    ConnectionFee,
					null AS PreviousRate
                FROM tmp_Vendorrates_stage3_ vRate
                LEFT join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;




			ELSE

				INSERT IGNORE INTO tmp_Rates_ (code,rate,ConnectionFee,PreviousRate)
                SELECT RowCode,
                    CASE WHEN rule_mgn.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin END)
                            WHEN trim(IFNULL(FixedValue,"")) != '' THEN
                                FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    ConnectionFee,
					null AS PreviousRate
                FROM
                (
                    select RowCode,
                    AVG(Rate) as Rate,
                    AVG(ConnectionFee) as ConnectionFee
                    from tmp_VRatesstage2_
                    group by RowCode
                )  vRate
                LEFT join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;

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
				-- delete all rate table rates of this rate table
				UPDATE
					tblRateTableRate
				SET
					EndDate = NOW()
				WHERE
					tblRateTableRate.RateTableId = p_RateTableId;

				-- delete and archive rates which rate's EndDate <= NOW()
				CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy
			END IF;

			-- set EffectiveDate for which date rates need to generate
			UPDATE tmp_Rates_ SET EffectiveDate = p_EffectiveDate;

			-- update Previous Rates By Vasim Seta Start
			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
			WHERE
				PreviousRate is null;
			-- update Previous Rates By Vasim Seta End

			-- update increase decrease effective date starts
			IF v_IncreaseEffectiveDate_ != v_DecreaseEffectiveDate_ THEN

				UPDATE tmp_Rates_
				SET
					tmp_Rates_.EffectiveDate =
					CASE WHEN tmp_Rates_.PreviousRate < tmp_Rates_.Rate THEN
						v_IncreaseEffectiveDate_
					WHEN tmp_Rates_.PreviousRate > tmp_Rates_.Rate THEN
						v_DecreaseEffectiveDate_
					ELSE p_EffectiveDate
					END
				;

			END IF;
			-- update increase decrease effective date ends

			-- delete rates which needs to insert and with same EffectiveDate and rate is not same
			UPDATE
				tblRateTableRate
			INNER JOIN
				tblRate ON tblRate.RateId = tblRateTableRate.RateId
					AND tblRateTableRate.RateTableId = p_RateTableId
				--	AND tblRateTableRate.EffectiveDate = p_EffectiveDate
			INNER JOIN
				tmp_Rates_ as rate ON rate.code = tblRate.Code AND tblRateTableRate.EffectiveDate = rate.EffectiveDate
			SET
				tblRateTableRate.EndDate = NOW()
			WHERE
				tblRateTableRate.RateTableId = p_RateTableId AND
				tblRate.CodeDeckId = v_codedeckid_ AND
				rate.rate != tblRateTableRate.Rate;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

			-- insert rates
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
					rate.EffectiveDate,
					rate.PreviousRate,
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
							 and tbl2.EffectiveDate = rate.EffectiveDate
							 AND tbl2.RateTableId = p_RateTableId
				WHERE  (    tbl1.RateTableRateID IS NULL
										OR
										(
											tbl2.RateTableRateID IS NULL
											AND  tbl1.EffectiveDate != rate.EffectiveDate

										)
							 )
							 AND tblRate.CodeDeckId = v_codedeckid_;

			-- delete same date's rates which are not in tmp_Rates_
			UPDATE
				tblRateTableRate rtr
			INNER JOIN
				tblRate ON rtr.RateId  = tblRate.RateId
			LEFT JOIN
				tmp_Rates_ rate ON rate.Code=tblRate.Code
			SET
				rtr.EndDate = NOW()
			WHERE
				rate.Code is null AND rtr.RateTableId = p_RateTableId AND rtr.EffectiveDate = rate.EffectiveDate AND tblRate.CodeDeckId = v_codedeckid_;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		END IF;

		-- update EndDate of all Rates of this RateTable By Vasim Seta Starts
		DROP TEMPORARY TABLE IF EXISTS tmp_ALL_RateTableRate_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ALL_RateTableRate_ AS (SELECT * FROM tblRateTableRate WHERE RateTableID=p_RateTableId);

		UPDATE
			tmp_ALL_RateTableRate_ temp
		SET
			EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=p_RateTableId AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
		WHERE
			temp.RateTableId = p_RateTableId;

		UPDATE
			tblRateTableRate rtr
		INNER JOIN
			tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID
		SET
			rtr.EndDate=temp.EndDate
		WHERE
			rtr.RateTableId=p_RateTableId;
		-- update EndDate of all Rates of this RateTable By Vasim Seta Ends

		-- delete and archive rates which rate's EndDate <= NOW()
		CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

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
CREATE PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_GroupBy` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50)


)
GenerateRateTable:BEGIN


		DECLARE i INTEGER;
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

		DECLARE v_IncreaseEffectiveDate_ DATETIME ;
		DECLARE v_DecreaseEffectiveDate_ DATETIME ;


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
		SET SESSION group_concat_max_len = 1000000; -- change group_concat limit for group by

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
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates_code (`code`),
			UNIQUE KEY `unique_code` (`code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
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
         `Order` INT,
			INDEX tmp_Raterules_code (`code`),
			INDEX tmp_Raterules_rateruleid (`rateruleid`),
			INDEX tmp_Raterules_RowNo (`RowNo`)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_dup;
		CREATE TEMPORARY TABLE tmp_Raterules_dup  (
			rateruleid INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			RowNo INT,
         `Order` INT,
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

		-- when group by description this table use to insert comma seperated codes
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_GroupBy_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_GroupBy_(
			AccountId int,
			AccountName varchar(200),
			Code LONGTEXT,
			Description varchar(200) ,
			Rate DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int/*,
			INDEX IX_CODE (Code)*/
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

		-- get Increase Decrease date from Job
		SELECT IFNULL(REPLACE(JSON_EXTRACT(Options, '$.IncreaseEffectiveDate'),'"',''), p_EffectiveDate) , IFNULL(REPLACE(JSON_EXTRACT(Options, '$.DecreaseEffectiveDate'),'"',''), p_EffectiveDate)   INTO v_IncreaseEffectiveDate_ , v_DecreaseEffectiveDate_  FROM tblJob WHERE Jobid = p_jobId;


		IF v_IncreaseEffectiveDate_ is null OR v_IncreaseEffectiveDate_ = '' THEN

			SET v_IncreaseEffectiveDate_ = p_EffectiveDate;

		END IF;

		IF v_DecreaseEffectiveDate_ is null OR v_DecreaseEffectiveDate_ = '' THEN

			SET v_DecreaseEffectiveDate_ = p_EffectiveDate;

		END IF;


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



		-- order is important
		INSERT INTO tmp_Raterules_
			SELECT
				rateruleid,
				tblRateRule.Code,
				tblRateRule.Description,
				@row_num := @row_num+1 AS RowID,
            tblRateRule.`Order`
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = p_RateGeneratorId
			ORDER BY tblRateRule.`Order` ASC;  -- <== order of rule is important

		-- v 4.17 fix process rules in order  -- NEON-1292 		Otto Rate Generator issue
		insert into tmp_Raterules_dup (			rateruleid ,		code ,		description ,		RowNo 		,   `Order`)
			select rateruleid ,		code ,		description ,		RowNo, `Order` from tmp_Raterules_;


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
		SET v_rowCount_ = (SELECT COUNT(distinct concat(Code,Description) ) FROM tmp_Raterules_);







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
								 (p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
								 OR
								 (	 p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate
										 AND ( tblVendorRate.EndDate IS NULL OR (tblVendorRate.EndDate > DATE(p_EffectiveDate)) )
								 )  -- rate should not end on selected effective date
							 )
							 AND ( tblVendorRate.EndDate IS NULL OR tblVendorRate.EndDate > now() )  -- rate should not end Today
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

		IF p_GroupBy = 'Desc' -- Group By Description
		THEN

			INSERT INTO tmp_VendorCurrentRates_GroupBy_ -- tmp_VendorCurrentRates_
				Select AccountId,max(AccountName),GROUP_CONCAT(Code),Description,max(Rate),max(ConnectionFee),max(EffectiveDate),TrunkID,max(CountryID),max(RateID),max(Preference)
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
				GROUP BY AccountId, TrunkID, Description
				order by Description asc;

				-- split and insert comma seperated codes
				SET i = 1;
				REPEAT
					INSERT INTO tmp_VendorCurrentRates_ (AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference)
				  	SELECT
					  	AccountId,AccountName,FnStringSplit(Code, ',', i),Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
					FROM
						tmp_VendorCurrentRates_GroupBy_
				  	WHERE
					  	FnStringSplit(Code, ',' , i) IS NOT NULL;

					SET i = i + 1;
				  	UNTIL ROW_COUNT() = 0
				END REPEAT;

		ELSE

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

		END IF;





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
										 select distinct tmpvr.*
										 from tmp_VendorRate_  tmpvr
											 inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																											 (
																												 ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
																												 OR
																												 ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																											 )
											 left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																													 (
																														 ( rr2.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr2.code,'*', '%%')) )
																														 OR
																														 ( rr2.description != '' AND tmpvr.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																													 )
											 inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
										 where rr2.code is null

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
										 select distinct tmpvr.*
										 from tmp_VendorRate_  tmpvr
											 inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																											 (
																												 ( rr.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) )
																												 OR
																												 ( rr.description != '' AND tmpvr.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																											 )
											 left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																													 (
																														 ( rr2.code != '' AND tmpvr.RowCode LIKE (REPLACE(rr2.code,'*', '%%')) )
																														 OR
																														 ( rr2.description != '' AND tmpvr.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																													 )
											 inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
										 where rr2.code is null

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

				INSERT IGNORE INTO tmp_Rates_ (code,rate,ConnectionFee,PreviousRate)
                SELECT RowCode,
                    CASE WHEN rule_mgn.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin END)
                            WHEN trim(IFNULL(FixedValue,"")) != '' THEN
                                FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    ConnectionFee,
					null AS PreviousRate
                FROM tmp_Vendorrates_stage3_ vRate
                LEFT join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;



			ELSE

				INSERT IGNORE INTO tmp_Rates_ (code,rate,ConnectionFee,PreviousRate)
                SELECT RowCode,
                    CASE WHEN rule_mgn.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin END)
                            WHEN trim(IFNULL(FixedValue,"")) != '' THEN
                                FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    ConnectionFee,
					null AS PreviousRate
                FROM
                    (
                        select RowCode,
                        AVG(Rate) as Rate,
                        AVG(ConnectionFee) as ConnectionFee
                        from tmp_VRatesstage2_
                        group by RowCode
                    )  vRate
                LEFT join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;





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
				-- delete all rate table rates of this rate table
				UPDATE
					tblRateTableRate
				SET
					EndDate = NOW()
				WHERE
					tblRateTableRate.RateTableId = p_RateTableId;

				-- delete and archive rates which rate's EndDate <= NOW()
				CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy
			END IF;

			-- set EffectiveDate for which date rates need to generate
			UPDATE tmp_Rates_ SET EffectiveDate = p_EffectiveDate;

			-- update Previous Rates By Vasim Seta Start
			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
			WHERE
				PreviousRate is null;
			-- update Previous Rates By Vasim Seta End

			-- update increase decrease effective date starts
			IF v_IncreaseEffectiveDate_ != v_DecreaseEffectiveDate_ THEN

				UPDATE tmp_Rates_
				SET
					tmp_Rates_.EffectiveDate =
					CASE WHEN tmp_Rates_.PreviousRate < tmp_Rates_.Rate THEN
						v_IncreaseEffectiveDate_
					WHEN tmp_Rates_.PreviousRate > tmp_Rates_.Rate THEN
						v_DecreaseEffectiveDate_
					ELSE p_EffectiveDate
					END
				;

			END IF;
			-- update increase decrease effective date ends

			-- delete rates which needs to insert and with same EffectiveDate and rate is not same
			UPDATE
				tblRateTableRate
			INNER JOIN
				tblRate ON tblRate.RateId = tblRateTableRate.RateId
					AND tblRateTableRate.RateTableId = p_RateTableId
				--	AND tblRateTableRate.EffectiveDate = p_EffectiveDate
			INNER JOIN
				tmp_Rates_ as rate ON rate.code = tblRate.Code AND tblRateTableRate.EffectiveDate = rate.EffectiveDate
			SET
				tblRateTableRate.EndDate = NOW()
			WHERE
				tblRateTableRate.RateTableId = p_RateTableId AND
				tblRate.CodeDeckId = v_codedeckid_ AND
				rate.rate != tblRateTableRate.Rate;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

			-- insert rates
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
					rate.EffectiveDate,
					rate.PreviousRate,
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
							 and tbl2.EffectiveDate = rate.EffectiveDate
							 AND tbl2.RateTableId = p_RateTableId
				WHERE  (    tbl1.RateTableRateID IS NULL
										OR
										(
											tbl2.RateTableRateID IS NULL
											AND  tbl1.EffectiveDate != rate.EffectiveDate

										)
							 )
							 AND tblRate.CodeDeckId = v_codedeckid_;

			-- delete same date's rates which are not in tmp_Rates_
			UPDATE
				tblRateTableRate rtr
			INNER JOIN
				tblRate ON rtr.RateId  = tblRate.RateId
			LEFT JOIN
				tmp_Rates_ rate ON rate.Code=tblRate.Code
			SET
				rtr.EndDate = NOW()
			WHERE
				rate.Code is null AND rtr.RateTableId = p_RateTableId AND rtr.EffectiveDate = rate.EffectiveDate AND tblRate.CodeDeckId = v_codedeckid_;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		END IF;

		-- update EndDate of all Rates of this RateTable By Vasim Seta Starts
		DROP TEMPORARY TABLE IF EXISTS tmp_ALL_RateTableRate_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ALL_RateTableRate_ AS (SELECT * FROM tblRateTableRate WHERE RateTableID=p_RateTableId);

		UPDATE
			tmp_ALL_RateTableRate_ temp
		SET
			EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=p_RateTableId AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
		WHERE
			temp.RateTableId = p_RateTableId;

		UPDATE
			tblRateTableRate rtr
		INNER JOIN
			tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID
		SET
			rtr.EndDate=temp.EndDate
		WHERE
			rtr.RateTableId=p_RateTableId;
		-- update EndDate of all Rates of this RateTable By Vasim Seta Ends

		-- delete and archive rates which rate's EndDate <= NOW()
		CALL prc_ArchiveOldRateTableRate(p_RateTableId,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

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


DROP PROCEDURE IF EXISTS `prc_WSGenerateSippySheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateSippySheet`(
	IN `p_CustomerID` INT ,
	IN `p_Trunks` VARCHAR(200),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_Effective,p_CustomDate);

	SELECT
		CASE WHEN EndDate IS NOT NULL THEN
			'SA'
		ELSE
			'A'
		END AS `Action [A|D|U|S|SA`,
		'' as id,
		Concat(IFNULL(Prefix,''), Code) as Prefix,
		Description as COUNTRY ,
		Interval1 as `Interval 1`,
		IntervalN as `Interval N`,
		Rate as `Price 1`,
		Rate as `Price N`,
		0  as Forbidden,
		0 as `Grace Period`,
		DATE_FORMAT( EffectiveDate, '%Y-%m-%d %H:%i:%s' ) AS `Activation Date`,
		DATE_FORMAT( EndDate, '%Y-%m-%d %H:%i:%s' )  AS `Expiration Date`
	FROM
		tmp_customerrateall_
	ORDER BY
		Prefix;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVendorVersion3VosSheet`(
	IN `p_VendorID` INT ,
	IN `p_Trunks` varchar(200) ,
	IN `p_Effective` VARCHAR(50),
	IN `p_Format` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
         SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

        call vwVendorVersion3VosSheet(p_VendorID,p_Trunks,p_Effective,p_CustomDate);

        IF p_Effective = 'Now' OR p_Format = 'Vos 2.0'
		  THEN

	        SELECT  `Rate Prefix` ,
	                `Area Prefix` ,
	                `Rate Type` ,
	                `Area Name` ,
	                `Billing Rate` ,
	                `Billing Cycle`,
	                `Minute Cost` ,
	                `Lock Type` ,
	                `Section Rate` ,
	                `Billing Rate for Calling Card Prompt` ,
	                `Billing Cycle for Calling Card Prompt`
	        FROM    tmp_VendorVersion3VosSheet_
	       -- WHERE   AccountID = p_VendorID
	       -- AND  FIND_IN_SET(TrunkId,p_Trunks)!= 0
	        ORDER BY `Rate Prefix`;

        END IF;

        IF ( (p_Effective = 'Future' OR p_Effective = 'All' OR p_Effective = 'CustomDate') AND p_Format = 'Vos 3.2'  )
		  THEN

				DROP TEMPORARY TABLE IF EXISTS tmp_VendorVersion3VosSheet2_ ;
				CREATE TEMPORARY TABLE tmp_VendorVersion3VosSheet2_ SELECT * FROM tmp_VendorVersion3VosSheet_;

				SELECT
					 	 `Time of timing replace`,
						 `Mode of timing replace`,
			  			 `Rate Prefix` ,
	                `Area Prefix` ,
	                `Rate Type` ,
	                `Area Name` ,
	                `Billing Rate` ,
	                `Billing Cycle`,
	                `Minute Cost` ,
	                `Lock Type` ,
	                `Section Rate` ,
	                `Billing Rate for Calling Card Prompt` ,
	                `Billing Cycle for Calling Card Prompt`
	        FROM (
					  SELECT  CONCAT(EffectiveDate,' 00:00') as `Time of timing replace`,
								 'Append replace' as `Mode of timing replace`,
					  			 `Rate Prefix` ,
			                `Area Prefix` ,
			                `Rate Type` ,
			                `Area Name` ,
			                `Billing Rate` ,
			                `Billing Cycle`,
			                `Minute Cost` ,
			                `Lock Type` ,
			                `Section Rate` ,
			                `Billing Rate for Calling Card Prompt` ,
			                `Billing Cycle for Calling Card Prompt`
			        FROM    tmp_VendorVersion3VosSheet2_
			        -- WHERE   AccountID = p_VendorID
			       -- AND  FIND_IN_SET(TrunkId,p_Trunks)!= 0
			       -- ORDER BY `Rate Prefix`

			   	UNION ALL

			        SELECT

					  	  CONCAT(EndDate,' 00:00') as `Time of timing replace`,
						 	'Delete' as `Mode of timing replace`,
					  		`Rate Prefix` ,
			                `Area Prefix` ,
			                `Rate Type` ,
			                `Area Name` ,
			                `Billing Rate` ,
			                `Billing Cycle`,
			                `Minute Cost` ,
			                `Lock Type` ,
			                `Section Rate` ,
			                `Billing Rate for Calling Card Prompt` ,
			                `Billing Cycle for Calling Card Prompt`
			        FROM    tmp_VendorVersion3VosSheet_
			        WHERE  EndDate is not null
					  -- AccountID = p_VendorID
			      --  AND  FIND_IN_SET(TrunkId,p_Trunks) != 0
			      --  ORDER BY `Rate Prefix`;

			   	UNION ALL

			        -- archive records
			        SELECT
			        		distinct
					  	  CONCAT(EndDate,' 00:00') as `Time of timing replace`,
						 	'Delete' as `Mode of timing replace`,
					  		`Rate Prefix` ,
			                `Area Prefix` ,
			                `Rate Type` ,
			                `Area Name` ,
			                `Billing Rate` ,
			                `Billing Cycle`,
			                `Minute Cost` ,
			                `Lock Type` ,
			                `Section Rate` ,
			                `Billing Rate for Calling Card Prompt` ,
			                `Billing Cycle for Calling Card Prompt`
			        FROM    tmp_VendorArhiveVersion3VosSheet_

					  /*WHERE
					     AccountID = p_VendorID
			        AND  FIND_IN_SET(TrunkId,p_Trunks) != 0
			        AND EndDate is not null
			        */
			      --  ORDER BY `Rate Prefix`;


	      ) tmp
	      ORDER BY `Rate Prefix`;



     END IF;


/*
query replaced on above condition

        IF p_Effective = 'All' AND p_Format = 'Vos 3.2'
		  THEN

	        SELECT  CONCAT(tmp_VendorVersion3VosSheet_.EffectiveDate,' 00:00') as `Time of timing replace`,
						 'Append replace' as `Mode of timing replace`,
			  			 `Rate Prefix` ,
	                `Area Prefix` ,
	                `Rate Type` ,
	                `Area Name` ,
	                `Billing Rate` ,
	                `Billing Cycle`,
	                `Minute Cost` ,
	                `Lock Type` ,
	                `Section Rate` ,
	                `Billing Rate for Calling Card Prompt` ,
	                `Billing Cycle for Calling Card Prompt`
	        FROM    tmp_VendorVersion3VosSheet_
	        WHERE   AccountID = p_VendorID
	        AND  FIND_IN_SET(TrunkId,p_Trunks)!= 0
	        ORDER BY `Rate Prefix`;

        END IF;
*/


        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSProcessImportAccount`;
DELIMITER //
CREATE PROCEDURE `prc_WSProcessImportAccount`(
	IN `p_processId` VARCHAR(200) ,
	IN `p_companyId` INT,
	IN `p_companygatewayid` INT,
	IN `p_tempaccountid` TEXT,
	IN `p_option` INT,
	IN `p_importdate` DATETIME,
	IN `p_gateway` VARCHAR(50)








)
ThisSP:BEGIN
    DECLARE v_AffectedRecords_ INT DEFAULT 0;
	DECLARE totalduplicatecode INT(11);
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;
	DECLARE v_accounttype INT DEFAULT 0;

	SET sql_mode = '';
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION sql_mode='';

	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  (
        Message longtext
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_accountimport;
				CREATE TEMPORARY TABLE tmp_accountimport (
				  `AccountType` tinyint(3) default 0,
				  `CompanyId` INT,
				  `Title` VARCHAR(100),
				  `Owner` INT,
				  `Number` VARCHAR(50),
				  `AccountName` VARCHAR(100),
				  `NamePrefix` VARCHAR(50),
				  `FirstName` VARCHAR(50),
				  `LastName` VARCHAR(50),
				  `LeadSource` VARCHAR(50),
				  `Email` VARCHAR(100),
				  `Phone` VARCHAR(50),
				  `Address1` VARCHAR(100),
				  `Address2` VARCHAR(100),
				  `Address3` VARCHAR(100),
				  `City` VARCHAR(50),
				  `PostCode` VARCHAR(50),
				  `Country` VARCHAR(50),
				  `Status` INT,
				  `tags` VARCHAR(250),
				  `Website` VARCHAR(100),
				  `Mobile` VARCHAR(50),
				  `Fax` VARCHAR(50),
				  `Skype` VARCHAR(50),
				  `Twitter` VARCHAR(50),
				  `Employee` VARCHAR(50),
				  `Description` longtext,
				  `BillingEmail` VARCHAR(200),
				  `CurrencyId` INT,
				  `VatNumber` VARCHAR(50),
				  `created_at` datetime,
				  `created_by` VARCHAR(100),
				  `VerificationStatus` tinyint(3) default 0,
				   IsVendor INT,
				   IsCustomer INT
				) ENGINE=InnoDB;

   IF p_option = 0
   THEN

   SELECT DISTINCT(AccountType) INTO v_accounttype from tblTempAccount WHERE ProcessID=p_processId;

	DELETE n1 FROM tblTempAccount n1, tblTempAccount n2 WHERE n1.tblTempAccountID < n2.tblTempAccountID
		AND  n1.CompanyId = n2.CompanyId
		AND  n1.AccountName = n2.AccountName
		AND  n1.ProcessID = n2.ProcessID
 		AND  n1.ProcessID = p_processId and n2.ProcessID = p_processId;

		 select count(*) INTO totalduplicatecode FROM(
				SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1) AS tbl;


		 IF  totalduplicatecode > 0
				THEN
						SELECT GROUP_CONCAT(Number) into errormessage FROM(
							select distinct Number, 1 as a FROM(
								SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1) AS tbl) as tbl2 GROUP by a;

						SELECT 'DUPLICATE AccountNumber : \n\r' INTO errorheader;

						INSERT INTO tmp_JobLog_ (Message)
							 SELECT CONCAT(errorheader ,errormessage);

							 delete FROM tblTempAccount WHERE Number IN (
								  SELECT Number from(
								  	SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1
									  ) as tbl
								);

			END IF;

			INSERT  INTO tblAccount
				  (	AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadStatus,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
					CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus,
					IsVendor,
				   IsCustomer
                   )

				   SELECT  DISTINCT
					ta.AccountType,
					ta.CompanyId,
					ta.Title,
					ta.Owner,
					ta.Number as Number,
					ta.AccountName,
					ta.NamePrefix,
					ta.FirstName,
					ta.LastName,
					ta.LeadStatus,
					ta.LeadSource,
					ta.Email,
					ta.Phone,
					ta.Address1,
					ta.Address2,
					ta.Address3,
					ta.City,
					ta.PostCode,
					ta.Country,
					ta.Status,
					ta.tags,
					ta.Website,
					ta.Mobile,
					ta.Fax,
					ta.Skype,
					ta.Twitter,
					ta.Employee,
					ta.Description,
					ta.BillingEmail,
					ta.Currency as CurrencyId,
					ta.VatNumber,
					p_importdate AS created_at,
					ta.created_by,
					2 as VerificationStatus,
					ta.IsVendor,
				   ta.IsCustomer
					from tblTempAccount ta
						left join tblAccount a on ta.AccountName = a.AccountName
						 	AND ta.CompanyId = a.CompanyId
							AND ta.AccountType = a.AccountType
						where ta.ProcessID = p_processId
						   AND ta.AccountType = v_accounttype
							AND a.AccountID is null
							AND ta.CompanyID = p_companyId;


      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	 INSERT INTO tmp_JobLog_ (Message)
	 SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );


	END IF;


	IF p_option = 1
   THEN
		DELETE tblTempAccount
			FROM tblTempAccount
			INNER JOIN(
				SELECT
					ta.tblTempAccountID
				FROM
					tblTempAccount ta
				LEFT JOIN
					tblAccount a ON ta.AccountName=a.AccountName AND ta.CompanyID=a.CompanyID
				WHERE ta.ProcessID = p_processId AND ta.CompanyID = p_companyId AND ta.IsCustomer=1 AND ta.AccountName=a.AccountName AND ta.CompanyID=a.CompanyID
			) aold ON aold.tblTempAccountID = tblTempAccount.tblTempAccountID;

		DELETE tblTempAccountSippy
			FROM tblTempAccountSippy
			INNER JOIN(
				SELECT
					tas.AccountSippyID
				FROM
					tblTempAccountSippy tas
				LEFT JOIN
					tblAccount a ON tas.AccountName=a.AccountName AND tas.CompanyID=a.CompanyID
				WHERE tas.ProcessID = p_processId AND tas.CompanyID = p_companyId AND tas.i_account!=0 AND tas.AccountName=a.AccountName AND tas.CompanyID=a.CompanyID
			) aold ON aold.AccountSippyID = tblTempAccountSippy.AccountSippyID;

   		INSERT INTO tmp_accountimport
   		(	AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
					CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus,
					IsCustomer,
					IsVendor
                   )
				select ta.AccountType ,
					ta.CompanyId ,
					ta.Title,
					ta.Owner ,
					ta.Number,
					ta.AccountName,
					ta.NamePrefix,
					ta.FirstName,
					ta.LastName,
					ta.LeadSource,
					ta.Email,
					ta.Phone,
					ta.Address1,
					ta.Address2,
					ta.Address3,
					ta.City,
					ta.PostCode,
					ta.Country,
					ta.Status,
					ta.tags,
					ta.Website,
					ta.Mobile,
					ta.Fax,
					ta.Skype,
					ta.Twitter,
					ta.Employee,
					ta.Description,
					ta.BillingEmail,
					ta.Currency as CurrencyId,
					ta.VatNumber,
					p_importdate AS created_at,
					ta.created_by,
					2 as VerificationStatus,
					ta.IsCustomer,
					ta.IsVendor
				 FROM tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					AND ta.CompanyId = a.CompanyId
					AND ta.AccountType = a.AccountType
				where ta.CompanyID = p_companyId
				AND ta.ProcessID = p_processId
				AND ta.AccountType = 1
				AND a.AccountID is null
				AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
				AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
				AND (p_gateway!='SippySFTP' OR (p_gateway='SippySFTP' AND ta.IsCustomer=1))
				group by ta.AccountName;


			SELECT GROUP_CONCAT(Number) into errormessage FROM(
			SELECT distinct ta.Number as Number,1 as an  from tblTempAccount ta
				left join tblAccount a on ta.Number = a.Number
					AND ta.CompanyId = a.CompanyId
					AND ta.AccountType = a.AccountType
				where ta.CompanyID = p_companyId
				AND ta.ProcessID = p_processId
				AND ta.AccountType = 1
				AND a.AccountID is not null
				AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
				AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid)))tbl GROUP by an;

		  IF errormessage is not null
		  THEN

		  		SELECT 'AccountNumber Already EXISTS : \n\r' INTO errorheader;
						INSERT INTO tmp_JobLog_ (Message)
							 SELECT CONCAT(errorheader ,errormessage);

				delete FROM tmp_accountimport WHERE Number IN (
								  SELECT Number from(
								  	SELECT distinct ta.Number as Number,1 as an  from tblTempAccount ta
										left join tblAccount a on ta.Number = a.Number
											AND ta.CompanyId = a.CompanyId
											AND ta.AccountType = a.AccountType
										where ta.CompanyID = p_companyId
										AND ta.ProcessID = p_processId
										AND ta.AccountType = 1
										AND a.AccountID is not null
										AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
										AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
									  ) as tbl
								);

		  END IF;

		INSERT  INTO tblAccount
				  (	AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
				    CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus,
					IsCustomer,
					IsVendor
                   )
			SELECT
					AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
				    CurrencyId,
					VatNumber,
					p_importdate AS created_at,
					created_by,
					VerificationStatus,
					IsCustomer,
					IsVendor
				from tmp_accountimport;


			SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

			INSERT INTO
				tblAccountSippy
				(
					CompanyID,
					AccountID,
					i_account,
					i_vendor,
					AccountName,
					username,
					CompanyGatewayID,
					created_at,
					updated_at
				)
			SELECT
				tas.CompanyID,
				a.AccountID,
				tas.i_account,
				tas.i_vendor,
				tas.AccountName,
				tas.username,
				tas.CompanyGatewayID,
				NOW(),
				NOW()
			FROM
				tblTempAccountSippy tas
			LEFT JOIN
				tmp_accountimport tai
			ON
				tas.AccountName = tai.AccountName
			LEFT JOIN
				tblAccount a
			ON
				tas.AccountName = a.AccountName
			WHERE
				a.AccountName is null AND tas.ProcessID = p_processId;

			
			IF p_gateway = "SippySFTP"
			THEN
				
				UPDATE
					tblAccountSippy asu
				LEFT JOIN
					tblTempAccountSippy tas
				ON
					asu.AccountName=tas.AccountName AND asu.CompanyID=tas.CompanyID
				LEFT JOIN
					tblTempAccount ta
				ON
					tas.AccountName = ta.AccountName
				LEFT JOIN
					tblAccount a
				ON
					ta.AccountName=a.AccountName AND
					ta.CompanyId = a.CompanyId AND
					ta.AccountType = a.AccountType
				SET
					asu.i_vendor=tas.i_vendor,
					asu.updated_at=NOW()
				WHERE
					tas.AccountName = ta.AccountName AND tas.AccountName = a.AccountName
					AND ta.CompanyID = p_companyId
					AND ta.ProcessID = p_processId
					AND ta.AccountType = 1
					AND a.AccountID is not null
					AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
					AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
					AND ta.IsVendor=1
					AND (a.IsVendor=0 OR a.IsVendor is null)
					AND asu.AccountName=tas.AccountName
					AND asu.CompanyID=tas.CompanyID
					AND tas.i_vendor > 0;

				INSERT INTO
					tblAccountSippy
					(
						CompanyID,
						AccountID,
						i_account,
						i_vendor,
						AccountName,
						username,
						CompanyGatewayID,
						created_at,
						updated_at
					)
				SELECT
					tas.CompanyID,
					a.AccountID,
					tas.i_account,
					tas.i_vendor,
					tas.AccountName,
					tas.username,
					tas.CompanyGatewayID,
					NOW(),
					NOW()
				FROM
					tblTempAccountSippy tas
				LEFT JOIN
					tblAccountSippy asu
				ON
					asu.AccountName=tas.AccountName AND asu.CompanyID=tas.CompanyID
				LEFT JOIN
					tblTempAccount ta
				ON
					tas.AccountName = ta.AccountName
				LEFT JOIN
					tblAccount a
				ON
					ta.AccountName=a.AccountName AND
					ta.CompanyId = a.CompanyId AND
					ta.AccountType = a.AccountType
				WHERE
					tas.AccountName = ta.AccountName AND tas.AccountName = a.AccountName
					AND ta.CompanyID = p_companyId
					AND ta.ProcessID = p_processId
					AND ta.AccountType = 1
					AND a.AccountID is not null
					AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
					AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
					AND ta.IsVendor=1
					AND (a.IsVendor=0 OR a.IsVendor is null)
					AND asu.AccountSippyID is null
				group by ta.AccountName;

				
				UPDATE
					tblAccount a
				LEFT JOIN
					tblTempAccount ta
				ON
					ta.AccountName=a.AccountName AND
					ta.CompanyId = a.CompanyId AND
					ta.AccountType = a.AccountType
				SET
					a.IsVendor=1
				WHERE ta.CompanyID = p_companyId
					AND ta.ProcessID = p_processId
					AND ta.AccountType = 1
					AND a.AccountID is not null
					AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
					AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
					AND ta.IsVendor=1
					AND (a.IsVendor=0 OR a.IsVendor is null);

				SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

				
				truncate tmp_accountimport;
				INSERT INTO tmp_accountimport
				(	AccountType ,
						CompanyId ,
						Title,
						Owner ,
						`Number`,
						AccountName,
						NamePrefix,
						FirstName,
						LastName,
						LeadSource,
						Email,
						Phone,
						Address1,
						Address2,
						Address3,
						City,
						PostCode,
						Country,
						Status,
						tags,
						Website,
						Mobile,
						Fax,
						Skype,
						Twitter,
						Employee,
						Description,
						BillingEmail,
						CurrencyId,
						VatNumber,
						created_at,
						created_by,
						VerificationStatus,
						IsCustomer,
						IsVendor
	                   )
					select ta.AccountType ,
						ta.CompanyId ,
						ta.Title,
						ta.Owner ,
						ta.Number,
						ta.AccountName,
						ta.NamePrefix,
						ta.FirstName,
						ta.LastName,
						ta.LeadSource,
						ta.Email,
						ta.Phone,
						ta.Address1,
						ta.Address2,
						ta.Address3,
						ta.City,
						ta.PostCode,
						ta.Country,
						ta.Status,
						ta.tags,
						ta.Website,
						ta.Mobile,
						ta.Fax,
						ta.Skype,
						ta.Twitter,
						ta.Employee,
						ta.Description,
						ta.BillingEmail,
						ta.Currency as CurrencyId,
						ta.VatNumber,
						p_importdate AS created_at,
						ta.created_by,
						2 as VerificationStatus,
						ta.IsCustomer,
						ta.IsVendor
					 FROM tblTempAccount ta
					left join tblAccount a on ta.AccountName=a.AccountName
						AND ta.CompanyId = a.CompanyId
						AND ta.AccountType = a.AccountType
					where ta.CompanyID = p_companyId
					AND ta.ProcessID = p_processId
					AND ta.AccountType = 1
					AND a.AccountID is null
					AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
					AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
					AND ta.IsVendor=1
					group by ta.AccountName;

				INSERT  INTO tblAccount
					  (	AccountType ,
						CompanyId ,
						Title,
						Owner ,
						`Number`,
						AccountName,
						NamePrefix,
						FirstName,
						LastName,
						LeadSource,
						Email,
						Phone,
						Address1,
						Address2,
						Address3,
						City,
						PostCode,
						Country,
						Status,
						tags,
						Website,
						Mobile,
						Fax,
						Skype,
						Twitter,
						Employee,
						Description,
						BillingEmail,
					    CurrencyId,
						VatNumber,
						created_at,
						created_by,
						VerificationStatus,
						IsCustomer,
						IsVendor
	                   )
				SELECT
						AccountType ,
						CompanyId ,
						Title,
						Owner ,
						`Number`,
						AccountName,
						NamePrefix,
						FirstName,
						LastName,
						LeadSource,
						Email,
						Phone,
						Address1,
						Address2,
						Address3,
						City,
						PostCode,
						Country,
						Status,
						tags,
						Website,
						Mobile,
						Fax,
						Skype,
						Twitter,
						Employee,
						Description,
						BillingEmail,
					    CurrencyId,
						VatNumber,
						p_importdate AS created_at,
						created_by,
						VerificationStatus,
						IsCustomer,
						IsVendor
					from tmp_accountimport;

				SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

				INSERT INTO
					tblAccountSippy
					(
						CompanyID,
						AccountID,
						i_account,
						i_vendor,
						AccountName,
						username,
						CompanyGatewayID,
						created_at,
						updated_at
					)
				SELECT
					tas.CompanyID,
					a.AccountID,
					tas.i_account,
					tas.i_vendor,
					tas.AccountName,
					tas.username,
					tas.CompanyGatewayID,
					NOW(),
					NOW()
				FROM
					tblTempAccountSippy tas
				LEFT JOIN
					tmp_accountimport tai
				ON
					tas.AccountName = tai.AccountName
				LEFT JOIN
					tblAccount a
				ON
					tas.AccountName = a.AccountName
				WHERE
					tas.AccountName = tai.AccountName AND tas.AccountName = a.AccountName AND tas.ProcessID = p_processId;

			END IF;


			
			INSERT INTO tmp_JobLog_ (Message)
			SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );

			
			-- insert all records into account sippy which are not present in account sippy.
				INSERT INTO
					tblAccountSippy
					(
						CompanyID,
						AccountID,
						i_account,
						i_vendor,
						AccountName,
						username,
						CompanyGatewayID,
						created_at,
						updated_at
					)
				SELECT
					tas.CompanyID,
					a.AccountID,
					tas.i_account,
					tas.i_vendor,
					tas.AccountName,
					tas.username,
					tas.CompanyGatewayID,
					NOW(),
					NOW()
				FROM
					tblTempAccountSippy tas
				LEFT JOIN
					tblAccountSippy ats
									ON
					ats.i_account = tas.i_account  AND ats.i_vendor = tas.i_vendor
				LEFT JOIN
					tblAccount a	
				ON
					a.AccountName = tas.AccountName
				WHERE
					ats.AccountSippyID is null AND a.AccountID is not null AND tas.ProcessID = p_processId;



			

	END IF;

	DELETE  FROM tblTempAccount WHERE ProcessID = p_processId;
	DELETE  FROM tblTempAccountSippy WHERE ProcessID = p_processId;
 	SELECT * from tmp_JobLog_;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSProcessRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSProcessRateTableRate`(
	IN `p_RateTableId` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT,
	IN `p_forbidden` INT,
	IN `p_preference` INT,
	IN `p_dialstringid` INT,
	IN `p_dialcodeSeparator` VARCHAR(50),
	IN `p_CurrencyID` INT,
	IN `p_list_option` INT,
	IN `p_UserName` TEXT
)
ThisSP:BEGIN

	DECLARE v_AffectedRecords_ INT DEFAULT 0;
	DECLARE v_CodeDeckId_ INT ;
	DECLARE totaldialstringcode INT(11) DEFAULT 0;
	DECLARE newstringcode INT(11) DEFAULT 0;
	DECLARE totalduplicatecode INT(11);
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;
	DECLARE v_RateTableCurrencyID_ INT;
	DECLARE v_CompanyCurrencyID_ INT;

	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
	CREATE TEMPORARY TABLE tmp_JobLog_ (
		Message longtext
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_split_RateTableRate_;
	CREATE TEMPORARY TABLE tmp_split_RateTableRate_ (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500) ,
		INDEX tmp_EffectiveDate (`EffectiveDate`),
		INDEX tmp_Code (`Code`),
		INDEX tmp_CC (`Code`,`Change`),
		INDEX tmp_Change (`Change`)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_TempRateTableRate_;
	CREATE TEMPORARY TABLE tmp_TempRateTableRate_ (
		TempRateTableRateID int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500) ,
		INDEX tmp_EffectiveDate (`EffectiveDate`),
		INDEX tmp_Code (`Code`),
		INDEX tmp_CC (`Code`,`Change`),
		INDEX tmp_Change (`Change`)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Delete_RateTableRate;
	CREATE TEMPORARY TABLE tmp_Delete_RateTableRate (
		RateTableRateID INT,
		RateTableId INT,
		RateId INT,
		Code VARCHAR(50),
		Description VARCHAR(200),
		Rate DECIMAL(18, 6),
		EffectiveDate DATETIME,
		EndDate Datetime ,
		Interval1 INT,
		IntervalN INT,
		ConnectionFee DECIMAL(18, 6),
		deleted_at DATETIME,
		INDEX tmp_RateTableRateDiscontinued_RateTableRateID (`RateTableRateID`)
	);

	/*  1.  Check duplicate code, dial string   */
	CALL  prc_RateTableCheckDialstringAndDupliacteCode(p_companyId,p_processId,p_dialstringid,p_effectiveImmediately,p_dialcodeSeparator);

	SELECT COUNT(*) AS COUNT INTO newstringcode from tmp_JobLog_;

	-- if no error
	IF newstringcode = 0
	THEN
		/*  2.  Send Today EndDate to rates which are marked deleted in review screen  */
		/*  3.  Update interval in temp table */

		-- if review
		IF (SELECT count(*) FROM tblRateTableRateChangeLog WHERE ProcessID = p_processId ) > 0
		THEN
			-- update end date given from tblRateTableRateChangeLog for deleted rates.
			UPDATE
				tblRateTableRate vr
			INNER JOIN tblRateTableRateChangeLog  vrcl
			on vrcl.RateTableRateID = vr.RateTableRateID
			SET
				vr.EndDate = IFNULL(vrcl.EndDate,date(now()))
			WHERE vrcl.ProcessID = p_processId
				AND vrcl.`Action`  ='Deleted';

			-- update end date on temp table
			UPDATE tmp_TempRateTableRate_ tblTempRateTableRate
			JOIN tblRateTableRateChangeLog vrcl
				ON  vrcl.ProcessId = p_processId
				AND vrcl.Code = tblTempRateTableRate.Code
				-- AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
			SET
				tblTempRateTableRate.EndDate = vrcl.EndDate
			WHERE
				vrcl.`Action` = 'Deleted'
				AND vrcl.EndDate IS NOT NULL ;

			-- update intervals.
			UPDATE tmp_TempRateTableRate_ tblTempRateTableRate
			JOIN tblRateTableRateChangeLog vrcl
				ON  vrcl.ProcessId = p_processId
				AND vrcl.Code = tblTempRateTableRate.Code
				-- AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
			SET
				tblTempRateTableRate.Interval1 = vrcl.Interval1 ,
				tblTempRateTableRate.IntervalN = vrcl.IntervalN
			WHERE
				vrcl.`Action` = 'New'
				AND vrcl.Interval1 IS NOT NULL
				AND vrcl.IntervalN IS NOT NULL ;

			/*IF (FOUND_ROWS() > 0) THEN
				INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Updated End Date of Deleted Records. ' );
			END IF;
			*/

		END IF;

		/*  4.  Update EndDate to Today if Replace All existing */
		IF  p_replaceAllRates = 1
		THEN
			UPDATE tblRateTableRate
				SET tblRateTableRate.EndDate = date(now())
			WHERE RateTableId = p_RateTableId;

			/*
			IF (FOUND_ROWS() > 0) THEN
				INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' Records Removed.   ' );
			END IF;
			*/
		END IF;

		/* 5. If Complete File, remove rates not exists in file  */

		IF p_list_option = 1    -- v4.16 p_list_option = 1 : "Completed List", p_list_option = 2 : "Partial List"
		THEN
			-- v4.16 get rates which is not in file and insert it into temp table
			INSERT INTO tmp_Delete_RateTableRate(
				RateTableRateID ,
				RateTableId,
				RateId,
				Code ,
				Description ,
				Rate ,
				EffectiveDate ,
				EndDate ,
				Interval1 ,
				IntervalN ,
				ConnectionFee ,
				deleted_at
			)
			SELECT DISTINCT
				tblRateTableRate.RateTableRateID,
				p_RateTableId AS RateTableId,
				tblRateTableRate.RateId,
				tblRate.Code,
				tblRate.Description,
				tblRateTableRate.Rate,
				tblRateTableRate.EffectiveDate,
				IFNULL(tblRateTableRate.EndDate,date(now())) ,
				tblRateTableRate.Interval1,
				tblRateTableRate.IntervalN,
				tblRateTableRate.ConnectionFee,
				now() AS deleted_at
			FROM tblRateTableRate
			JOIN tblRate
				ON tblRate.RateID = tblRateTableRate.RateId
				AND tblRate.CompanyID = p_companyId
			LEFT JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
				ON tblTempRateTableRate.Code = tblRate.Code
				AND  tblTempRateTableRate.ProcessId = p_processId
				AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
			WHERE tblRateTableRate.RateTableId = p_RateTableId
				AND tblTempRateTableRate.Code IS NULL
				AND ( tblRateTableRate.EndDate is NULL OR tblRateTableRate.EndDate <= date(now()) )
			ORDER BY RateTableRateID ASC;

			/*IF (FOUND_ROWS() > 0) THEN
			INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Records marked deleted as Not exists in File' );
			END IF;*/

			-- set end date will remove at bottom in archive proc
			UPDATE tblRateTableRate
			JOIN tmp_Delete_RateTableRate ON tblRateTableRate.RateTableRateID = tmp_Delete_RateTableRate.RateTableRateID
				SET tblRateTableRate.EndDate = date(now())
			WHERE
				tblRateTableRate.RateTableId = p_RateTableId;

		END IF;

		/* 6. Move Rates to archive which has EndDate <= now()  */
		-- move to archive if EndDate is <= now()
		IF ( (SELECT count(*) FROM tblRateTableRate WHERE  RateTableId = p_RateTableId AND EndDate <= NOW() )  > 0  ) THEN

			-- move to archive
			/*INSERT INTO tblRateTableRateArchive
			SELECT DISTINCT  null , -- Primary Key column
				`RateTableRateID`,
				`RateTableId`,
				`RateId`,
				`Rate`,
				`EffectiveDate`,
				IFNULL(`EndDate`,date(now())) as EndDate,
				`updated_at`,
				`created_at`,
				`created_by`,
				`ModifiedBy`,
				`Interval1`,
				`IntervalN`,
				`ConnectionFee`,
				concat('Ends Today rates @ ' , now() ) as `Notes`
			FROM tblRateTableRate
			WHERE  RateTableId = p_RateTableId AND EndDate <= NOW();

			delete from tblRateTableRate
			WHERE  RateTableId = p_RateTableId AND EndDate <= NOW();*/

			-- Update previous rate before archive
			call prc_RateTableRateUpdatePreviousRate(p_RateTableId,'');

			-- Archive Rates
			call prc_ArchiveOldRateTableRate(p_RateTableId,p_UserName);

		END IF;

		/* 7. Add New code in codedeck  */

		IF  p_addNewCodesToCodeDeck = 1
		THEN
			INSERT INTO tblRate (
				CompanyID,
				Code,
				Description,
				CreatedBy,
				CountryID,
				CodeDeckId,
				Interval1,
				IntervalN
			)
			SELECT DISTINCT
				p_companyId,
				vc.Code,
				vc.Description,
				'RMService',
				fnGetCountryIdByCodeAndCountry (vc.Code ,vc.Description) AS CountryID,
				CodeDeckId,
				Interval1,
				IntervalN
			FROM
			(
				SELECT DISTINCT
					tblTempRateTableRate.Code,
					tblTempRateTableRate.Description,
					tblTempRateTableRate.CodeDeckId,
					tblTempRateTableRate.Interval1,
					tblTempRateTableRate.IntervalN
				FROM tmp_TempRateTableRate_  as tblTempRateTableRate
				LEFT JOIN tblRate
					ON tblRate.Code = tblTempRateTableRate.Code
					AND tblRate.CompanyID = p_companyId
					AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
				WHERE tblRate.RateID IS NULL
					AND tblTempRateTableRate.`Change` NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
			) vc;

			/*IF (FOUND_ROWS() > 0) THEN
					INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - New Code Inserted into Codedeck ' );
			END IF;*/

		ELSE
			SELECT GROUP_CONCAT(code) into errormessage FROM(
				SELECT DISTINCT
					c.Code as code, 1 as a
				FROM
				(
					SELECT DISTINCT
						tblTempRateTableRate.Code,
						tblTempRateTableRate.Description
					FROM tmp_TempRateTableRate_  as tblTempRateTableRate
					LEFT JOIN tblRate
						ON tblRate.Code = tblTempRateTableRate.Code
						AND tblRate.CompanyID = p_companyId
						AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
					WHERE tblRate.RateID IS NULL
						AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
				) c
			) as tbl GROUP BY a;

			IF errormessage IS NOT NULL
			THEN
				INSERT INTO tmp_JobLog_ (Message)
				SELECT DISTINCT
					CONCAT(tbl.Code , ' CODE DOES NOT EXIST IN CODE DECK')
				FROM
				(
					SELECT DISTINCT
						tblTempRateTableRate.Code,
						tblTempRateTableRate.Description
					FROM tmp_TempRateTableRate_  as tblTempRateTableRate
					LEFT JOIN tblRate
						ON tblRate.Code = tblTempRateTableRate.Code
						AND tblRate.CompanyID = p_companyId
						AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
					WHERE tblRate.RateID IS NULL
						AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
				) as tbl;
			END IF;
		END IF;

		/* 8. delete rates which will be map as deleted */

		-- delete rates which will be map as deleted
		UPDATE tblRateTableRate
		INNER JOIN tblRate
			ON tblRate.RateID = tblRateTableRate.RateId
			AND tblRate.CompanyID = p_companyId
		INNER JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblTempRateTableRate.Change IN ('Delete', 'R', 'D', 'Blocked', 'Block')
		SET tblRateTableRate.EndDate = IFNULL(tblTempRateTableRate.EndDate,date(now()))
		WHERE tblRateTableRate.RateTableId = p_RateTableId;

		/*IF (FOUND_ROWS() > 0) THEN
		INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Records marked deleted as mapped in File ' );
		END IF;*/


		-- need to get ratetable rates with latest records ....
		-- and then need to use that table to insert update records in ratetable rate.


		-- ------

		/* 9. Update Interval in tblRate */

		-- Update Interval Changed for Action = "New"
		-- update Intervals which are not maching with tblTempRateTableRate
		-- so as if intervals will not mapped next time it will be same as last file.
		UPDATE tblRate
		JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
			ON 	  tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
			AND tblTempRateTableRate.Code = tblRate.Code
			AND  tblTempRateTableRate.ProcessId = p_processId
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
		SET
			tblRate.Interval1 = tblTempRateTableRate.Interval1,
			tblRate.IntervalN = tblTempRateTableRate.IntervalN
		WHERE
			tblTempRateTableRate.Interval1 IS NOT NULL
			AND tblTempRateTableRate.IntervalN IS NOT NULL
			AND
			(
				tblRate.Interval1 != tblTempRateTableRate.Interval1
				OR
				tblRate.IntervalN != tblTempRateTableRate.IntervalN
			);


		/* 10. Update INTERVAL, ConnectionFee,  */

		UPDATE tblRateTableRate
		INNER JOIN tblRate
			ON tblRateTableRate.RateId = tblRate.RateId
			AND tblRateTableRate.RateTableId = p_RateTableId
		INNER JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
			AND tblRateTableRate.RateId = tblRate.RateId
		SET tblRateTableRate.ConnectionFee = tblTempRateTableRate.ConnectionFee,
			tblRateTableRate.Interval1 = tblTempRateTableRate.Interval1,
			tblRateTableRate.IntervalN = tblTempRateTableRate.IntervalN
			--  tblRateTableRate.EndDate = tblTempRateTableRate.EndDate
		WHERE tblRateTableRate.RateTableId = p_RateTableId;


		/*IF (FOUND_ROWS() > 0) THEN
		INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Updated Existing Records' );
		END IF;*/


		/* 12. Delete rates which are same in file   */

		-- delete rates which are not increase/decreased  (rates = rates)
		DELETE tblTempRateTableRate
		FROM tmp_TempRateTableRate_ as tblTempRateTableRate
		JOIN tblRate
			ON tblRate.Code = tblTempRateTableRate.Code
		JOIN tblRateTableRate
			ON tblRateTableRate.RateId = tblRate.RateId
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
			AND tblRateTableRate.RateTableId = p_RateTableId
			AND tblTempRateTableRate.Rate = tblRateTableRate.Rate
			AND (
				tblRateTableRate.EffectiveDate = tblTempRateTableRate.EffectiveDate
				OR
				(
					DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d')
				)
				OR 1 = (CASE
							WHEN tblTempRateTableRate.EffectiveDate > NOW() THEN 1
							ELSE 0
						END)
			)
		WHERE  tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block');

		/*IF (FOUND_ROWS() > 0) THEN
		INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Discarded no change records' );
		END IF;*/

		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

		SELECT CurrencyID into v_RateTableCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyID FROM tblRateTable WHERE RateTableId=p_RateTableId);
		SELECT CurrencyID into v_CompanyCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblCompany WHERE CompanyID=p_companyId);

		/* 13. update currency   */

		/*UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
		JOIN tblRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
		JOIN tblRateTableRate
			ON tblRateTableRate.RateId = tblRate.RateId
			AND tblRateTableRate.RateTableId = p_RateTableId
		SET tblRateTableRate.Rate = IF (
			p_CurrencyID > 0,
			CASE WHEN p_CurrencyID = v_RateTableCurrencyID_
			THEN
				tblTempRateTableRate.Rate
			WHEN  p_CurrencyID = v_CompanyCurrencyID_
			THEN
			(
				( tblTempRateTableRate.Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ and CompanyID = p_companyId ) )
			)
			ELSE
			(
				(SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ AND CompanyID = p_companyId )
				*
				(tblTempRateTableRate.Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
			)
			END ,
			tblTempRateTableRate.Rate
		)
		WHERE tblTempRateTableRate.Rate <> tblRateTableRate.Rate
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
			AND DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d');

		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();*/

		/* 13. archive same date's rate   */
		DROP TEMPORARY TABLE IF EXISTS tmp_PreviousRate;
		CREATE TEMPORARY TABLE `tmp_PreviousRate` (
			`RateId` int,
			`PreviousRate` decimal(18, 6),
			`EffectiveDate` Datetime
		);

		UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
		JOIN tblRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
		JOIN tblRateTableRate
			ON tblRateTableRate.RateId = tblRate.RateId
			AND tblRateTableRate.RateTableId = p_RateTableId
		SET tblRateTableRate.EndDate = NOW()
		WHERE tblTempRateTableRate.Rate <> tblRateTableRate.Rate
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
			AND DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d');

		INSERT INTO
			tmp_PreviousRate (RateId,PreviousRate,EffectiveDate)
		SELECT
			tblRateTableRate.RateId,tblRateTableRate.Rate,tblTempRateTableRate.EffectiveDate
		FROM
			tmp_TempRateTableRate_ as tblTempRateTableRate
		JOIN tblRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
		JOIN tblRateTableRate
			ON tblRateTableRate.RateId = tblRate.RateId
			AND tblRateTableRate.RateTableId = p_RateTableId
		WHERE tblTempRateTableRate.Rate <> tblRateTableRate.Rate
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
			AND DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d');

		-- archive rates which has EndDate <= today
		call prc_ArchiveOldRateTableRate(p_RateTableId,p_UserName);

		/* 13. insert new rates   */

		INSERT INTO tblRateTableRate (
			RateTableId,
			RateId,
			Rate,
			EffectiveDate,
			EndDate,
			ConnectionFee,
			Interval1,
			IntervalN,
			PreviousRate
		)
		SELECT DISTINCT
			p_RateTableId,
			tblRate.RateID,
			IF (
				p_CurrencyID > 0,
				CASE WHEN p_CurrencyID = v_RateTableCurrencyID_
				THEN
					tblTempRateTableRate.Rate
				WHEN  p_CurrencyID = v_CompanyCurrencyID_
				THEN
				(
					( tblTempRateTableRate.Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ and CompanyID = p_companyId ) )
				)
				ELSE
				(
					(SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ AND CompanyID = p_companyId )
					*
					(tblTempRateTableRate.Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
				)
				END ,
				tblTempRateTableRate.Rate
			) ,
			tblTempRateTableRate.EffectiveDate,
			tblTempRateTableRate.EndDate,
			tblTempRateTableRate.ConnectionFee,
			tblTempRateTableRate.Interval1,
			tblTempRateTableRate.IntervalN,
			IFNULL(tmp_PreviousRate.PreviousRate,0) AS PreviousRate
		FROM tmp_TempRateTableRate_ as tblTempRateTableRate
		JOIN tblRate
			ON tblRate.Code = tblTempRateTableRate.Code
			AND tblRate.CompanyID = p_companyId
			AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
		LEFT JOIN tblRateTableRate
			ON tblRate.RateID = tblRateTableRate.RateId
			AND tblRateTableRate.RateTableId = p_RateTableId
			AND tblTempRateTableRate.EffectiveDate = tblRateTableRate.EffectiveDate
		LEFT JOIN tmp_PreviousRate
			ON tblRate.RateId = tmp_PreviousRate.RateId AND tblTempRateTableRate.EffectiveDate = tmp_PreviousRate.EffectiveDate
		WHERE tblRateTableRate.RateTableRateID IS NULL
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
			AND tblTempRateTableRate.EffectiveDate >= DATE_FORMAT (NOW(), '%Y-%m-%d');

		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

		/*IF (FOUND_ROWS() > 0) THEN
		INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - New Records Inserted.' );
		END IF;
		*/

		/* 13. update enddate in old rates */

		-- loop through effective date to update end date
		DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
		CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			EffectiveDate  Date
		);
		INSERT INTO tmp_EffectiveDates_ (EffectiveDate)
		SELECT distinct
			EffectiveDate
		FROM
		(
			select distinct EffectiveDate
			from 	tblRateTableRate
			WHERE
				RateTableId = p_RateTableId
			Group By EffectiveDate
			order by EffectiveDate desc
		) tmp
		,(SELECT @row_num := 0) x;


		SET v_pointer_ = 1;
		SET v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );

		IF v_rowCount_ > 0 THEN

			WHILE v_pointer_ <= v_rowCount_
			DO
				SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = v_pointer_ );
				SET @row_num = 0;

				UPDATE  tblRateTableRate vr1
				inner join
				(
					select
						RateTableId,
						RateID,
						EffectiveDate
					FROM tblRateTableRate
					WHERE RateTableId = p_RateTableId
						AND EffectiveDate =   @EffectiveDate
					order by EffectiveDate desc
				) tmpvr
				on
					vr1.RateTableId = tmpvr.RateTableId
					AND vr1.RateID  	=        	tmpvr.RateID
					AND vr1.EffectiveDate 	< tmpvr.EffectiveDate
				SET
					vr1.EndDate = @EffectiveDate
				where
					vr1.RateTableId = p_RateTableId
					--	AND vr1.EffectiveDate < @EffectiveDate
					AND vr1.EndDate is null;


				SET v_pointer_ = v_pointer_ + 1;

			END WHILE;

		END IF;

	END IF;

	INSERT INTO tmp_JobLog_ (Message) 	 	SELECT CONCAT(v_AffectedRecords_ , ' Records Uploaded ' );

	-- Update previous rate before archive
	call prc_RateTableRateUpdatePreviousRate(p_RateTableId,'');

	-- archive rates which has EndDate <= today
	call prc_ArchiveOldRateTableRate(p_RateTableId,p_UserName);


	DELETE  FROM tblTempRateTableRate WHERE  ProcessId = p_processId;
	DELETE  FROM tblRateTableRateChangeLog WHERE ProcessID = p_processId;
	SELECT * FROM tmp_JobLog_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSProcessVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSProcessVendorRate`(
	IN `p_accountId` INT,
	IN `p_trunkId` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT,
	IN `p_forbidden` INT,
	IN `p_preference` INT,
	IN `p_dialstringid` INT,
	IN `p_dialcodeSeparator` VARCHAR(50),
	IN `p_CurrencyID` INT,
	IN `p_list_option` INT,
	IN `p_UserName` TEXT
)
ThisSP:BEGIN

		DECLARE v_AffectedRecords_ INT DEFAULT 0;
		DECLARE v_CodeDeckId_ INT ;
		DECLARE totaldialstringcode INT(11) DEFAULT 0;
		DECLARE newstringcode INT(11) DEFAULT 0;
		DECLARE totalduplicatecode INT(11);
		DECLARE errormessage longtext;
		DECLARE errorheader longtext;
		DECLARE v_AccountCurrencyID_ INT;
		DECLARE v_CompanyCurrencyID_ INT;


		DECLARE v_pointer_ INT;
		DECLARE v_rowCount_ INT;


	  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_;
    CREATE TEMPORARY TABLE tmp_split_VendorRate_ (
    		`TempVendorRateID` int,
			  `CodeDeckId` int ,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `EffectiveDate` Datetime ,
			  `EndDate` Datetime ,
			  `Change` varchar(100) ,
			  `ProcessId` varchar(200) ,
			  `Preference` varchar(100) ,
			  `ConnectionFee` decimal(18, 6),
			  `Interval1` int,
			  `IntervalN` int,
			  `Forbidden` varchar(100) ,
			  `DialStringPrefix` varchar(500) ,
			  INDEX tmp_EffectiveDate (`EffectiveDate`),
			  INDEX tmp_Code (`Code`),
        INDEX tmp_CC (`Code`,`Change`),
			  INDEX tmp_Change (`Change`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_TempVendorRate_;
    CREATE TEMPORARY TABLE tmp_TempVendorRate_ (
		    TempVendorRateID int,
			  `CodeDeckId` int ,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `EffectiveDate` Datetime ,
			  `EndDate` Datetime ,
			  `Change` varchar(100) ,
			  `ProcessId` varchar(200) ,
			  `Preference` varchar(100) ,
			  `ConnectionFee` decimal(18, 6),
			  `Interval1` int,
			  `IntervalN` int,
			  `Forbidden` varchar(100) ,
			  `DialStringPrefix` varchar(500) ,
			  INDEX tmp_EffectiveDate (`EffectiveDate`),
			  INDEX tmp_Code (`Code`),
        INDEX tmp_CC (`Code`,`Change`),
			  INDEX tmp_Change (`Change`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_Delete_VendorRate;
    CREATE TEMPORARY TABLE tmp_Delete_VendorRate (
        VendorRateID INT,
        AccountId INT,
        TrunkID INT,
        RateId INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
		EndDate Datetime ,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        deleted_at DATETIME,
        INDEX tmp_VendorRateDiscontinued_VendorRateID (`VendorRateID`)
    );


	/*  1.  Check duplicate code, dial string   */
    CALL  prc_checkDialstringAndDupliacteCode(p_companyId,p_processId,p_dialstringid,p_effectiveImmediately,p_dialcodeSeparator);

    SELECT COUNT(*) AS COUNT INTO newstringcode from tmp_JobLog_;

 -- LEAVE ThisSP;


	-- if no error
    IF newstringcode = 0
    THEN


		/*  2.  Send Today EndDate to rates which are marked deleted in review screen  */
		/*  3.  Update interval in temp table */

		-- if review
		IF (SELECT count(*) FROM tblVendorRateChangeLog WHERE ProcessID = p_processId ) > 0 THEN

			-- v4.16 update end date given from tblVendorRateChangeLog for deleted rates.
			UPDATE
			tblVendorRate vr
			INNER JOIN tblVendorRateChangeLog  vrcl
                    on vrcl.VendorRateID = vr.VendorRateID
			SET
			vr.EndDate = IFNULL(vrcl.EndDate,date(now()))
			WHERE vrcl.ProcessID = p_processId
			AND vrcl.`Action`  ='Deleted';

			-- update end date on temp table
			 UPDATE tmp_TempVendorRate_ tblTempVendorRate
          JOIN tblVendorRateChangeLog vrcl
          		 ON  vrcl.ProcessId = p_processId
          		 AND vrcl.Code = tblTempVendorRate.Code
        			 -- AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
        	SET
			   tblTempVendorRate.EndDate = vrcl.EndDate
		     WHERE
		     vrcl.`Action` = 'Deleted'
        	  AND vrcl.EndDate IS NOT NULL ;


			-- update intervals.
		   UPDATE tmp_TempVendorRate_ tblTempVendorRate
          JOIN tblVendorRateChangeLog vrcl
          		 ON  vrcl.ProcessId = p_processId
          		 AND vrcl.Code = tblTempVendorRate.Code
        			 -- AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
        	SET
			   tblTempVendorRate.Interval1 = vrcl.Interval1 ,
				tblTempVendorRate.IntervalN = vrcl.IntervalN
		     WHERE
		     vrcl.`Action` = 'New'
        	  AND vrcl.Interval1 IS NOT NULL
			  AND vrcl.IntervalN IS NOT NULL ;



			/*IF (FOUND_ROWS() > 0) THEN
				INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Updated End Date of Deleted Records. ' );
			END IF;
			*/


		END IF;

		/*  4.  Update EndDate to Today if Replace All existing */

		IF  p_replaceAllRates = 1
		THEN

          /*
				DELETE FROM tblVendorRate
				WHERE AccountId = p_accountId
				AND TrunkID = p_trunkId;
          */

			UPDATE tblVendorRate
			SET tblVendorRate.EndDate = date(now())
			WHERE AccountId = p_accountId
			AND TrunkID = p_trunkId;




			/*
			IF (FOUND_ROWS() > 0) THEN
				INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' Records Removed.   ' );
			END IF;
			*/

		END IF;

		/* 5. If Complete File, remove rates not exists in file  */

		IF p_list_option = 1    -- v4.16 p_list_option = 1 : "Completed List", p_list_option = 2 : "Partial List"
		THEN


			-- v4.16 get rates which is not in file and insert it into temp table
			INSERT INTO tmp_Delete_VendorRate(
							VendorRateID ,
							AccountId,
							TrunkID ,
							RateId,
							Code ,
							Description ,
							Rate ,
							EffectiveDate ,
							EndDate ,
							Interval1 ,
							IntervalN ,
							ConnectionFee ,
							deleted_at
			)
			SELECT DISTINCT
                    tblVendorRate.VendorRateID,
                    p_accountId AS AccountId,
                    p_trunkId AS TrunkID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.EffectiveDate,
                    IFNULL(tblVendorRate.EndDate,date(now())) ,
                    tblVendorRate.Interval1,
                    tblVendorRate.IntervalN,
                    tblVendorRate.ConnectionFee,
                    now() AS deleted_at
                    FROM tblVendorRate
	                    JOIN tblRate
	                   		 ON tblRate.RateID = tblVendorRate.RateId
									  	AND tblRate.CompanyID = p_companyId
	                    LEFT JOIN tmp_TempVendorRate_ as tblTempVendorRate
	                   		 ON tblTempVendorRate.Code = tblRate.Code
	                   			 AND  tblTempVendorRate.ProcessId = p_processId
	                   			 AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
	                    WHERE tblVendorRate.AccountId = p_accountId
	                   		 AND tblVendorRate.TrunkId = p_trunkId
	                   		 AND tblTempVendorRate.Code IS NULL
	                   		 AND ( tblVendorRate.EndDate is NULL OR tblVendorRate.EndDate <= date(now()) )

                    ORDER BY VendorRateID ASC;


							/*IF (FOUND_ROWS() > 0) THEN
								INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Records marked deleted as Not exists in File' );
							END IF;*/

			-- set end date will remove at bottom in archive proc
			UPDATE tblVendorRate
				JOIN tmp_Delete_VendorRate ON tblVendorRate.VendorRateID = tmp_Delete_VendorRate.VendorRateID
				SET tblVendorRate.EndDate = date(now())
			WHERE
				tblVendorRate.AccountId = p_accountId
		      AND tblVendorRate.TrunkId = p_trunkId;

		-- 	CALL prc_InsertDiscontinuedVendorRate(p_accountId,p_trunkId);


		END IF;

		/* 6. Move Rates to archive which has EndDate <= now()  */
			-- move to archive if EndDate is <= now()
		IF ( (SELECT count(*) FROM tblVendorRate WHERE  AccountId = p_accountId  AND TrunkId = p_trunkId AND EndDate <= NOW() )  > 0  ) THEN

				-- move to archive
				INSERT INTO tblVendorRateArchive
				SELECT DISTINCT  null , -- Primary Key column
				`VendorRateID`,
				`AccountId`,
				`TrunkID`,
				`RateId`,
				`Rate`,
				`EffectiveDate`,
				IFNULL(`EndDate`,date(now())) as EndDate,
				`updated_at`,
				`created_at`,
				`created_by`,
				`updated_by`,
				`Interval1`,
				`IntervalN`,
				`ConnectionFee`,
				`MinimumCost`,
				  concat('Ends Today rates @ ' , now() ) as `Notes`
			      FROM tblVendorRate
			      WHERE  AccountId = p_accountId  AND TrunkId = p_trunkId AND EndDate <= NOW();

			      delete from tblVendorRate
			      WHERE  AccountId = p_accountId  AND TrunkId = p_trunkId AND EndDate <= NOW();


		END IF;

		/* 7. Add New code in codedeck  */

		IF  p_addNewCodesToCodeDeck = 1
            THEN
                INSERT INTO tblRate (
                    CompanyID,
                    Code,
                    Description,
                    CreatedBy,
                    CountryID,
                    CodeDeckId,
                    Interval1,
                    IntervalN
                )
                SELECT DISTINCT
                    p_companyId,
                    vc.Code,
                    vc.Description,
                    'RMService',
                    fnGetCountryIdByCodeAndCountry (vc.Code ,vc.Description) AS CountryID,
                    CodeDeckId,
                    Interval1,
                    IntervalN
                FROM
                (
                    SELECT DISTINCT
                        tblTempVendorRate.Code,
                        tblTempVendorRate.Description,
                        tblTempVendorRate.CodeDeckId,
                        tblTempVendorRate.Interval1,
                        tblTempVendorRate.IntervalN
                    FROM tmp_TempVendorRate_  as tblTempVendorRate
                    LEFT JOIN tblRate
                    ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                    WHERE tblRate.RateID IS NULL
                    AND tblTempVendorRate.`Change` NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                ) vc;


						/*IF (FOUND_ROWS() > 0) THEN
								INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - New Code Inserted into Codedeck ' );
						END IF;*/


						/*
               	SELECT GROUP_CONCAT(Code) into errormessage FROM(
                    SELECT DISTINCT
                        tblTempVendorRate.Code as Code, 1 as a
                    FROM tmp_TempVendorRate_  as tblTempVendorRate
                    INNER JOIN tblRate
                    ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
							      WHERE tblRate.CountryID IS NULL
                    AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
                ) as tbl GROUP BY a;

                IF errormessage IS NOT NULL
                THEN
                    INSERT INTO tmp_JobLog_ (Message)
                    	  SELECT DISTINCT
                          CONCAT(tblTempVendorRate.Code , ' INVALID CODE - COUNTRY NOT FOUND')
                        FROM tmp_TempVendorRate_  as tblTempVendorRate
                        INNER JOIN tblRate
                        ON tblRate.Code = tblTempVendorRate.Code
                          AND tblRate.CompanyID = p_companyId
                          AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        WHERE tblRate.CountryID IS NULL
                          AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
					 	    END IF; */
            ELSE
                SELECT GROUP_CONCAT(code) into errormessage FROM(
                    SELECT DISTINCT
                        c.Code as code, 1 as a
                    FROM
                    (
                        SELECT DISTINCT
                            tblTempVendorRate.Code,
                            tblTempVendorRate.Description
                        FROM tmp_TempVendorRate_  as tblTempVendorRate
                        LEFT JOIN tblRate
				                ON tblRate.Code = tblTempVendorRate.Code
                          AND tblRate.CompanyID = p_companyId
                          AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        WHERE tblRate.RateID IS NULL
                          AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                    ) c
                ) as tbl GROUP BY a;

                IF errormessage IS NOT NULL
                THEN
                    INSERT INTO tmp_JobLog_ (Message)
                    		SELECT DISTINCT
                        CONCAT(tbl.Code , ' CODE DOES NOT EXIST IN CODE DECK')
                        FROM
                        (
                            SELECT DISTINCT
                                tblTempVendorRate.Code,
                                tblTempVendorRate.Description
                            FROM tmp_TempVendorRate_  as tblTempVendorRate
                            LEFT JOIN tblRate
                            ON tblRate.Code = tblTempVendorRate.Code
                              AND tblRate.CompanyID = p_companyId
                              AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                            WHERE tblRate.RateID IS NULL
                              AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                        ) as tbl;
					 	    END IF;
            END IF;

			/* 8. delete rates which will be map as deleted */

				-- delete rates which will be map as deleted
            UPDATE tblVendorRate
                    INNER JOIN tblRate
                        ON tblRate.RateID = tblVendorRate.RateId
                            AND tblRate.CompanyID = p_companyId
                    INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
                        ON tblRate.Code = tblTempVendorRate.Code
                        AND tblTempVendorRate.Change IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                     SET tblVendorRate.EndDate = IFNULL(tblTempVendorRate.EndDate,date(now()))
                     WHERE tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId ;


						/*IF (FOUND_ROWS() > 0) THEN
								INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Records marked deleted as mapped in File ' );
						END IF;*/


			-- need to get vendor rates with latest records ....
			-- and then need to use that table to insert update records in vendor rate.


			-- ------

			  	  -- CALL prc_InsertDiscontinuedVendorRate(p_accountId,p_trunkId);

			/* 9. Update Interval in tblRate */

			-- Update Interval Changed for Action = "New"
			-- update Intervals which are not maching with tblTempVendorRate
			-- so as if intervals will not mapped next time it will be same as last file.
    				UPDATE tblRate
                 JOIN tmp_TempVendorRate_ as tblTempVendorRate
						ON 	  tblRate.CompanyID = p_companyId
							 AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
							 AND tblTempVendorRate.Code = tblRate.Code
							AND  tblTempVendorRate.ProcessId = p_processId
							AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
	         		 SET
                    tblRate.Interval1 = tblTempVendorRate.Interval1,
                    tblRate.IntervalN = tblTempVendorRate.IntervalN
				     WHERE
                		     tblTempVendorRate.Interval1 IS NOT NULL
							 AND tblTempVendorRate.IntervalN IS NOT NULL
                		 AND
							  (
								  tblRate.Interval1 != tblTempVendorRate.Interval1
							  OR
								  tblRate.IntervalN != tblTempVendorRate.IntervalN
							  );




			/* 10. Update INTERVAL, ConnectionFee,  */

            UPDATE tblVendorRate
                INNER JOIN tblRate
                    ON tblVendorRate.RateId = tblRate.RateId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
                INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
                    ON tblRate.Code = tblTempVendorRate.Code
                        AND tblRate.CompanyID = p_companyId
                        AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        AND tblVendorRate.RateId = tblRate.RateId
                SET tblVendorRate.ConnectionFee = tblTempVendorRate.ConnectionFee,
                    tblVendorRate.Interval1 = tblTempVendorRate.Interval1,
                    tblVendorRate.IntervalN = tblTempVendorRate.IntervalN
                  --  tblVendorRate.EndDate = tblTempVendorRate.EndDate
                WHERE tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId ;


						/*IF (FOUND_ROWS() > 0) THEN
								INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Updated Existing Records' );
						END IF;*/

			/* 11. Update VendorBlocking  */

            IF  p_forbidden = 1 OR p_dialstringid > 0
				    THEN
                INSERT INTO tblVendorBlocking
                (
                    `AccountId`,
                    `RateId`,
                    `TrunkID`,
                    `BlockedBy`
                )
                SELECT distinct
                    p_accountId as AccountId,
                    tblRate.RateID as RateId,
                    p_trunkId as TrunkID,
                    'RMService' as BlockedBy
                FROM tmp_TempVendorRate_ as tblTempVendorRate
                INNER JOIN tblRate
                    ON tblRate.Code = tblTempVendorRate.Code
                        AND tblRate.CompanyID = p_companyId
                        AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                LEFT JOIN tblVendorBlocking vb
                    ON vb.AccountId=p_accountId
                        AND vb.RateId = tblRate.RateID
                        AND vb.TrunkID = p_trunkId
                WHERE tblTempVendorRate.Forbidden IN('B')
                    AND vb.VendorBlockingId is null;

            DELETE tblVendorBlocking
                FROM tblVendorBlocking
                INNER JOIN(
                    select VendorBlockingId
                    FROM `tblVendorBlocking` tv
                    INNER JOIN(
                        SELECT
                            tblRate.RateId as RateId
                        FROM tmp_TempVendorRate_ as tblTempVendorRate
                        INNER JOIN tblRate
                            ON tblRate.Code = tblTempVendorRate.Code
                                AND tblRate.CompanyID = p_companyId
                                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        WHERE tblTempVendorRate.Forbidden IN('UB')
                    )tv1 on  tv.AccountId=p_accountId
                    AND tv.TrunkID=p_trunkId
                    AND tv.RateId = tv1.RateID
                )vb2 on vb2.VendorBlockingId = tblVendorBlocking.VendorBlockingId;
				END IF;

		/* 11. Update VendorPreference  */

		IF  p_preference = 1
		THEN
            INSERT INTO tblVendorPreference
            (
                 `AccountId`
                 ,`Preference`
                 ,`RateId`
                 ,`TrunkID`
                 ,`CreatedBy`
                 ,`created_at`
            )
            SELECT
                 p_accountId AS AccountId,
                 tblTempVendorRate.Preference as Preference,
                 tblRate.RateID AS RateId,
                  p_trunkId AS TrunkID,
                  'RMService' AS CreatedBy,
                  NOW() AS created_at
            FROM tmp_TempVendorRate_ as tblTempVendorRate
            INNER JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
            LEFT JOIN tblVendorPreference vp
                ON vp.RateId=tblRate.RateID
                    AND vp.AccountId = p_accountId
                    AND vp.TrunkID = p_trunkId
            WHERE  tblTempVendorRate.Preference IS NOT NULL
                AND  tblTempVendorRate.Preference > 0
                AND  vp.VendorPreferenceID IS NULL;

					  UPDATE tblVendorPreference
                INNER JOIN tblRate
                    ON tblVendorPreference.RateId=tblRate.RateID
                INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
                    ON tblTempVendorRate.Code = tblRate.Code
                        AND tblTempVendorRate.CodeDeckId = tblRate.CodeDeckId
                        AND tblRate.CompanyID = p_companyId
                SET tblVendorPreference.Preference = tblTempVendorRate.Preference
                WHERE tblVendorPreference.AccountId = p_accountId
                    AND tblVendorPreference.TrunkID = p_trunkId
                    AND  tblTempVendorRate.Preference IS NOT NULL
                    AND  tblTempVendorRate.Preference > 0
                    AND tblVendorPreference.VendorPreferenceID IS NOT NULL;

						DELETE tblVendorPreference
							  from	tblVendorPreference
					 	INNER JOIN tblRate
					 		  ON tblVendorPreference.RateId=tblRate.RateID
            INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
							  ON tblTempVendorRate.Code = tblRate.Code
				            AND tblTempVendorRate.CodeDeckId = tblRate.CodeDeckId
				            AND tblRate.CompanyID = p_companyId
            WHERE tblVendorPreference.AccountId = p_accountId
							  AND tblVendorPreference.TrunkID = p_trunkId
							  AND  tblTempVendorRate.Preference IS NOT NULL
							  AND  tblTempVendorRate.Preference = ''
							  AND tblVendorPreference.VendorPreferenceID IS NOT NULL;

				END IF;


		/* 12. Delete rates which are same in file   */

			-- delete rates which are not increase/decreased  (rates = rates)
        DELETE tblTempVendorRate
            FROM tmp_TempVendorRate_ as tblTempVendorRate
            JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
            JOIN tblVendorRate
                ON tblVendorRate.RateId = tblRate.RateId
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
                    AND tblTempVendorRate.Rate = tblVendorRate.Rate
                    AND (
                        tblVendorRate.EffectiveDate = tblTempVendorRate.EffectiveDate
                        OR
                        (
                            DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d')
                        )
                        OR 1 = (CASE
                            WHEN tblTempVendorRate.EffectiveDate > NOW() THEN 1
                            ELSE 0
                        END)
                    )
            WHERE  tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block');

				/*IF (FOUND_ROWS() > 0) THEN
					INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - Discarded no change records' );
				END IF;*/



            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

            SELECT CurrencyID into v_AccountCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblAccount WHERE AccountID=p_accountId);
            SELECT CurrencyID into v_CompanyCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblCompany WHERE CompanyID=p_companyId);

		/* 13. update currency   */

            /*UPDATE tmp_TempVendorRate_ as tblTempVendorRate
            JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
            JOIN tblVendorRate
                ON tblVendorRate.RateId = tblRate.RateId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
				    SET tblVendorRate.Rate = IF (
                    p_CurrencyID > 0,
                    CASE WHEN p_CurrencyID = v_AccountCurrencyID_
                    THEN
                       tblTempVendorRate.Rate
                    WHEN  p_CurrencyID = v_CompanyCurrencyID_
                    THEN
                    (
                        ( tblTempVendorRate.Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ and CompanyID = p_companyId ) )
                    )
                    ELSE
                    (
                        (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ AND CompanyID = p_companyId )
                            *
                        (tblTempVendorRate.Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
                    )
                    END ,
                    tblTempVendorRate.Rate
                )
            WHERE tblTempVendorRate.Rate <> tblVendorRate.Rate
                AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                AND DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d');

 				SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();*/

            UPDATE tmp_TempVendorRate_ as tblTempVendorRate
            JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
            JOIN tblVendorRate
                ON tblVendorRate.RateId = tblRate.RateId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
				    SET tblVendorRate.EndDate = NOW()
            WHERE tblTempVendorRate.Rate <> tblVendorRate.Rate
                AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                AND DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d');

				-- archive rates which has EndDate <= today
				call prc_ArchiveOldVendorRate(p_accountId,p_trunkId,p_UserName);


		/* 13. insert new rates   */

            INSERT INTO tblVendorRate (
                AccountId,
                TrunkID,
                RateId,
                Rate,
                EffectiveDate,
                EndDate,
                ConnectionFee,
                Interval1,
                IntervalN
            )
            SELECT DISTINCT
                p_accountId,
                p_trunkId,
                tblRate.RateID,
                IF (
                    p_CurrencyID > 0,
                    CASE WHEN p_CurrencyID = v_AccountCurrencyID_
                    THEN
                       tblTempVendorRate.Rate
                    WHEN  p_CurrencyID = v_CompanyCurrencyID_
                    THEN
                    (
                        ( tblTempVendorRate.Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ and CompanyID = p_companyId ) )
                    )
                    ELSE
                    (
                        (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ AND CompanyID = p_companyId )
                            *
                        (tblTempVendorRate.Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
                    )
                    END ,
                    tblTempVendorRate.Rate
                ) ,
                tblTempVendorRate.EffectiveDate,
                tblTempVendorRate.EndDate,
                tblTempVendorRate.ConnectionFee,
                tblTempVendorRate.Interval1,
                tblTempVendorRate.IntervalN
            FROM tmp_TempVendorRate_ as tblTempVendorRate
            JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
            LEFT JOIN tblVendorRate
                ON tblRate.RateID = tblVendorRate.RateId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.trunkid = p_trunkId
                    AND tblTempVendorRate.EffectiveDate = tblVendorRate.EffectiveDate
            WHERE tblVendorRate.VendorRateID IS NULL
                AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
                AND tblTempVendorRate.EffectiveDate >= DATE_FORMAT (NOW(), '%Y-%m-%d');

					SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

				/*IF (FOUND_ROWS() > 0) THEN
					INSERT INTO tmp_JobLog_ (Message) SELECT CONCAT(FOUND_ROWS() , ' - New Records Inserted.' );
				END IF;
				*/

			/* 13. update enddate in old rates */


			-- loop through effective date to update end date
			DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
			CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				EffectiveDate  Date
			);
			INSERT INTO tmp_EffectiveDates_ (EffectiveDate)
				SELECT distinct
					EffectiveDate
				FROM
					(	select distinct EffectiveDate
								from 	tblVendorRate
								WHERE
								AccountId = p_accountId
								AND TrunkId = p_trunkId
								Group By EffectiveDate
								order by EffectiveDate desc
					) tmp


					,(SELECT @row_num := 0) x;


			SET v_pointer_ = 1;
			SET v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );

			IF v_rowCount_ > 0 THEN

				WHILE v_pointer_ <= v_rowCount_
				DO

					SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = v_pointer_ );
					SET @row_num = 0;

				UPDATE  tblVendorRate vr1
	         	inner join
	         	(
						select
			         	AccountID,
			         	RateID,
			         	TrunkID,
	   		      	EffectiveDate
	      	   	FROM tblVendorRate
		                    WHERE AccountId = p_accountId
		                   		 AND TrunkId = p_trunkId
		            				AND EffectiveDate =   @EffectiveDate
		         	order by EffectiveDate desc

	         	) tmpvr
	         	on
	         	vr1.AccountID = tmpvr.AccountID
	         	AND vr1.TrunkID  	=       	tmpvr.TrunkID
	         	AND vr1.RateID  	=        	tmpvr.RateID
	         	AND vr1.EffectiveDate 	< tmpvr.EffectiveDate
	         	SET
	         	vr1.EndDate = @EffectiveDate
	         	where
	         		vr1.AccountId = p_accountId
						AND vr1.TrunkID = p_trunkId
					--	AND vr1.EffectiveDate < @EffectiveDate
						AND vr1.EndDate is null;


					SET v_pointer_ = v_pointer_ + 1;


				END WHILE;

			END IF;


		END IF;

   INSERT INTO tmp_JobLog_ (Message) 	 	SELECT CONCAT(v_AffectedRecords_ , ' Records Uploaded ' );

	-- archive rates which has EndDate <= today
	call prc_ArchiveOldVendorRate(p_accountId,p_trunkId,p_UserName);


 	 SELECT * FROM tmp_JobLog_;
   DELETE  FROM tblTempVendorRate WHERE  ProcessId = p_processId;
   DELETE  FROM tblVendorRateChangeLog WHERE ProcessID = p_processId;

	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSReviewRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSReviewRateTableRate`(
	IN `p_RateTableId` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT,
	IN `p_forbidden` INT,
	IN `p_preference` INT,
	IN `p_dialstringid` INT,
	IN `p_dialcodeSeparator` VARCHAR(50),
	IN `p_CurrencyID` INT,
	IN `p_list_option` INT
)
ThisSP:BEGIN

    -- @TODO: code cleanup
	DECLARE newstringcode INT(11) DEFAULT 0;
	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_RateTableCurrencyID_ INT;
	DECLARE v_CompanyCurrencyID_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_split_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_split_RateTableRate_ (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500) ,
		INDEX tmp_EffectiveDate (`EffectiveDate`),
		INDEX tmp_Code (`Code`),
		INDEX tmp_CC (`Code`,`Change`),
		INDEX tmp_Change (`Change`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_TempRateTableRate_;
    CREATE TEMPORARY TABLE tmp_TempRateTableRate_ (
		`TempRateTableRateID` int,
		`CodeDeckId` int ,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`EffectiveDate` Datetime ,
		`EndDate` Datetime ,
		`Change` varchar(100) ,
		`ProcessId` varchar(200) ,
		`Preference` varchar(100) ,
		`ConnectionFee` decimal(18, 6),
		`Interval1` int,
		`IntervalN` int,
		`Forbidden` varchar(100) ,
		`DialStringPrefix` varchar(500) ,
		INDEX tmp_EffectiveDate (`EffectiveDate`),
		INDEX tmp_Code (`Code`),
		INDEX tmp_CC (`Code`,`Change`),
		INDEX tmp_Change (`Change`)
    );

    CALL  prc_RateTableCheckDialstringAndDupliacteCode(p_companyId,p_processId,p_dialstringid,p_effectiveImmediately,p_dialcodeSeparator);

	ALTER TABLE `tmp_TempRateTableRate_`	ADD Column `NewRate` decimal(18, 6) ;

    SELECT COUNT(*) AS COUNT INTO newstringcode from tmp_JobLog_;

    SELECT CurrencyID into v_RateTableCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyID FROM tblRateTable WHERE RateTableId=p_RateTableId);
    SELECT CurrencyID into v_CompanyCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblCompany WHERE CompanyID=p_companyId);

	  -- update all rate on newrate with currency conversion.
	update tmp_TempRateTableRate_
	SET
	NewRate = IF (
                    p_CurrencyID > 0,
                    CASE WHEN p_CurrencyID = v_RateTableCurrencyID_
                    THEN
                        Rate
                    WHEN  p_CurrencyID = v_CompanyCurrencyID_
                    THEN
                    (
                        ( Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ and CompanyID = p_companyId ) )
                    )
                    ELSE
                    (
                        (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ AND CompanyID = p_companyId )
                            *
                        (Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
                    )
                    END ,
                    Rate
                )
    WHERE ProcessID=p_processId;

		-- if no error
    IF newstringcode = 0
    THEN
		-- if rates is not in our database (new rates from file) than insert it into ChangeLog
		INSERT INTO tblRateTableRateChangeLog(
            TempRateTableRateID,
            RateTableRateID,
            RateTableId,
            RateId,
            Code,
            Description,
            Rate,
            EffectiveDate,
            EndDate,
            Interval1,
            IntervalN,
            ConnectionFee,
            `Action`,
            ProcessID,
            created_at
		)
		SELECT
			tblTempRateTableRate.TempRateTableRateID,
			tblRateTableRate.RateTableRateID,
            p_RateTableId AS RateTableId,
            tblRate.RateId,
            tblTempRateTableRate.Code,
            tblTempRateTableRate.Description,
            tblTempRateTableRate.Rate,
			tblTempRateTableRate.EffectiveDate,
			tblTempRateTableRate.EndDate ,
			IFNULL(tblTempRateTableRate.Interval1,tblRate.Interval1 ) as Interval1,		-- take interval from file and update in tblRate if not changed in service
			IFNULL(tblTempRateTableRate.IntervalN , tblRate.IntervalN ) as IntervalN,
			tblTempRateTableRate.ConnectionFee,
			'New' AS `Action`,
			p_processId AS ProcessID,
			now() AS created_at
		FROM tmp_TempRateTableRate_ as tblTempRateTableRate
		LEFT JOIN tblRate
			ON tblTempRateTableRate.Code = tblRate.Code AND tblTempRateTableRate.CodeDeckId = tblRate.CodeDeckId  AND tblRate.CompanyID = p_companyId
		LEFT JOIN tblRateTableRate
			ON tblRate.RateID = tblRateTableRate.RateId AND tblRateTableRate.RateTableId = p_RateTableId
			AND tblRateTableRate.EffectiveDate  <= date(now())
		WHERE tblTempRateTableRate.ProcessID=p_processId AND tblRateTableRate.RateTableRateID IS NULL
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
			-- AND tblTempRateTableRate.EffectiveDate != '0000-00-00 00:00:00';

   		  -- loop through effective date
        DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
		CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
			EffectiveDate  Date,
			RowID int,
			INDEX (RowID)
		);
        INSERT INTO tmp_EffectiveDates_
        SELECT distinct
            EffectiveDate,
            @row_num := @row_num+1 AS RowID
        FROM tmp_TempRateTableRate_
            ,(SELECT @row_num := 0) x
        WHERE  ProcessID = p_processId
         -- AND EffectiveDate <> '0000-00-00 00:00:00'
        group by EffectiveDate
        order by EffectiveDate asc;

        SET v_pointer_ = 1;
        SET v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );

        IF v_rowCount_ > 0 THEN

            WHILE v_pointer_ <= v_rowCount_
            DO

                SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = v_pointer_ );
                SET @row_num = 0;

                -- update  previous rate with all latest recent entriy of previous effective date

                INSERT INTO tblRateTableRateChangeLog(
                    TempRateTableRateID,
                    RateTableRateID,
                    RateTableId,
                    RateId,
                    Code,
                    Description,
                    Rate,
                    EffectiveDate,
                    EndDate,
                    Interval1,
                    IntervalN,
                    ConnectionFee,
                    `Action`,
                    ProcessID,
                    created_at
                )
                SELECT
                    distinct
                    tblTempRateTableRate.TempRateTableRateID,
                    RateTableRate.RateTableRateID,
                    p_RateTableId AS RateTableId,
                    RateTableRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblTempRateTableRate.Rate,
                    tblTempRateTableRate.EffectiveDate,
                    tblTempRateTableRate.EndDate ,
                    tblTempRateTableRate.Interval1,
                    tblTempRateTableRate.IntervalN,
                    tblTempRateTableRate.ConnectionFee,
                    IF(tblTempRateTableRate.NewRate > RateTableRate.Rate, 'Increased', IF(tblTempRateTableRate.NewRate < RateTableRate.Rate, 'Decreased','')) AS `Action`,
                    p_processid AS ProcessID,
                    now() AS created_at
                FROM
                (
                    -- get all rates RowID = 1 to remove old to old effective date
                    select distinct tmp.* ,
                        @row_num := IF(@prev_RateId = tmp.RateID AND @prev_EffectiveDate >= tmp.EffectiveDate, (@row_num + 1), 1) AS RowID,
                        @prev_RateId := tmp.RateID,
                        @prev_EffectiveDate := tmp.EffectiveDate
                    FROM
                    (
                        select distinct vr1.*
                        from tblRateTableRate vr1
                        LEFT outer join tblRateTableRate vr2
                            on vr1.RateTableId = vr2.RateTableId
                            and vr1.RateID = vr2.RateID
                            AND vr2.EffectiveDate  = @EffectiveDate
                        where
                            vr1.RateTableId = p_RateTableId
                            and vr1.EffectiveDate <= COALESCE(vr2.EffectiveDate,@EffectiveDate) -- <= because if same day rate change need to log
                        order by vr1.RateID desc ,vr1.EffectiveDate desc
                    ) tmp ,
                    ( SELECT @row_num := 0 , @prev_RateId := 0 , @prev_EffectiveDate := '' ) x
                      order by RateID desc , EffectiveDate desc
                ) RateTableRate
                JOIN tblRate
                    ON tblRate.CompanyID = p_companyId
                    AND tblRate.RateID = RateTableRate.RateId
                JOIN tmp_TempRateTableRate_ tblTempRateTableRate
                    ON tblTempRateTableRate.Code = tblRate.Code
                    AND tblTempRateTableRate.ProcessID=p_processId
                    --	AND  tblTempRateTableRate.EffectiveDate <> '0000-00-00 00:00:00'
                    AND  RateTableRate.EffectiveDate <= tblTempRateTableRate.EffectiveDate -- <= because if same day rate change need to log
                    AND tblTempRateTableRate.EffectiveDate =  @EffectiveDate
                    AND RateTableRate.RowID = 1
                WHERE
                    RateTableRate.RateTableId = p_RateTableId
                    -- AND tblTempRateTableRate.EffectiveDate <> '0000-00-00 00:00:00'
                    AND tblTempRateTableRate.Code IS NOT NULL
                    AND tblTempRateTableRate.ProcessID=p_processId
                    AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

                SET v_pointer_ = v_pointer_ + 1;

            END WHILE;

        END IF;


        IF p_list_option = 1 -- p_list_option = 1 : "Completed List", p_list_option = 2 : "Partial List"
        THEN
            -- get rates which is not in file and insert it into ChangeLog
            INSERT INTO tblRateTableRateChangeLog(
                RateTableRateID,
                RateTableId,
                RateId,
                Code,
                Description,
                Rate,
                EffectiveDate,
                EndDate,
                Interval1,
                IntervalN,
                ConnectionFee,
                `Action`,
                ProcessID,
                created_at
            )
            SELECT DISTINCT
                tblRateTableRate.RateTableRateID,
                p_RateTableId AS RateTableId,
                tblRateTableRate.RateId,
                tblRate.Code,
                tblRate.Description,
                tblRateTableRate.Rate,
                tblRateTableRate.EffectiveDate,
                tblRateTableRate.EndDate ,
                tblRateTableRate.Interval1,
                tblRateTableRate.IntervalN,
                tblRateTableRate.ConnectionFee,
                'Deleted' AS `Action`,
                p_processId AS ProcessID,
                now() AS deleted_at
            FROM tblRateTableRate
            JOIN tblRate
                ON tblRate.RateID = tblRateTableRate.RateId AND tblRate.CompanyID = p_companyId
            LEFT JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
                ON tblTempRateTableRate.Code = tblRate.Code
                AND tblTempRateTableRate.ProcessID=p_processId
                AND (
                    -- normal condition
                    ( tblTempRateTableRate.EndDate is null AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block') )
                    OR
                    -- skip records just to avoid duplicate records in tblRateTableRateChangeLog tabke - when EndDate is given with delete
                    ( tblTempRateTableRate.EndDate is not null AND tblTempRateTableRate.Change IN ('Delete', 'R', 'D', 'Blocked','Block') )
                )
            WHERE tblRateTableRate.RateTableId = p_RateTableId
                AND ( tblRateTableRate.EndDate is null OR tblRateTableRate.EndDate <= date(now()) )
                AND tblTempRateTableRate.Code IS NULL
            ORDER BY RateTableRateID ASC;

        END IF;


        INSERT INTO tblRateTableRateChangeLog(
            RateTableRateID,
            RateTableId,
            RateId,
            Code,
            Description,
            Rate,
            EffectiveDate,
            EndDate,
            Interval1,
            IntervalN,
            ConnectionFee,
            `Action`,
            ProcessID,
            created_at
        )
        SELECT DISTINCT
            tblRateTableRate.RateTableRateID,
            p_RateTableId AS RateTableId,
            tblRateTableRate.RateId,
            tblRate.Code,
            tblRate.Description,
            tblRateTableRate.Rate,
            tblRateTableRate.EffectiveDate,
            IFNULL(tblTempRateTableRate.EndDate,tblRateTableRate.EndDate) as  EndDate ,
            tblRateTableRate.Interval1,
            tblRateTableRate.IntervalN,
            tblRateTableRate.ConnectionFee,
            'Deleted' AS `Action`,
            p_processId AS ProcessID,
            now() AS deleted_at
        FROM tblRateTableRate
        JOIN tblRate
            ON tblRate.RateID = tblRateTableRate.RateId AND tblRate.CompanyID = p_companyId
        LEFT JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
            ON tblRate.Code = tblTempRateTableRate.Code
            AND tblTempRateTableRate.Change IN ('Delete', 'R', 'D', 'Blocked','Block')
            AND tblTempRateTableRate.ProcessID=p_processId
            -- AND tblTempRateTableRate.EndDate <= date(now())
            -- AND tblTempRateTableRate.ProcessID=p_processId
        WHERE tblRateTableRate.RateTableId = p_RateTableId
            -- AND tblRateTableRate.EndDate <= date(now())
            AND tblTempRateTableRate.Code IS NOT NULL
        ORDER BY RateTableRateID ASC;


    END IF;

    SELECT * FROM tmp_JobLog_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSReviewRateTableRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_WSReviewRateTableRateUpdate`(
	IN `p_RateTableID` INT,
	IN `p_RateIds` TEXT,
	IN `p_ProcessID` VARCHAR(200),
	IN `p_criteria` INT,
	IN `p_Action` VARCHAR(20),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_EndDate` DATETIME,
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50)
)
ThisSP:BEGIN

	DECLARE newstringcode INT(11) DEFAULT 0;
	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );

	SET @stm_and_code = '';
	IF p_Code != ''
	THEN
		SET @stm_and_code = CONCAT(' AND ("',p_Code,'" IS NULL OR "',p_Code,'" = "" OR tvr.Code LIKE "',REPLACE(p_Code, "*", "%"),'")');
	END IF;

	SET @stm_and_desc = '';
	IF p_Description != ''
	THEN
		SET @stm_and_desc = CONCAT(' AND ("',p_Description,'" IS NULL OR "',p_Description,'" = "" OR tvr.Description LIKE "',REPLACE(p_Description, "*", "%"),'")');
	END IF;

    CASE p_Action
		WHEN 'New' THEN
			SET @stm = '';
			IF p_Interval1 > 0
			THEN
				SET @stm = CONCAT(@stm,'tvr.Interval1 = ',p_Interval1);
			END IF;

			IF p_IntervalN > 0
			THEN
				SET @stm = CONCAT(@stm,IF(@stm != '',',',''),'tvr.IntervalN = ',p_IntervalN);
			END IF;

			IF p_criteria = 1
			THEN
				IF @stm != ''
				THEN
					SET @stm1 = CONCAT('UPDATE tblTempRateTableRate tvr LEFT JOIN tblRateTableRateChangeLog vrcl ON tvr.TempRateTableRateID=vrcl.TempRateTableRateID SET ',@stm,' WHERE tvr.TempRateTableRateID=vrcl.TempRateTableRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');
					select @stm1;
					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET ',@stm,' WHERE ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			ELSE
				IF @stm != ''
				THEN
					SET @stm1 = CONCAT('UPDATE tblTempRateTableRate tvr LEFT JOIN tblRateTableRateChangeLog vrcl ON tvr.TempRateTableRateID=vrcl.TempRateTableRateID SET ',@stm,' WHERE tvr.TempRateTableRateID IN (',p_RateIds,') AND tvr.TempRateTableRateID=vrcl.TempRateTableRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET ',@stm,' WHERE TempRateTableRateID IN (',p_RateIds,') AND ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			END IF;

		WHEN 'Deleted' THEN
			IF p_criteria = 1
			THEN
				SET @stm1 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE ProcessID="',p_ProcessID,'" AND `Action`="',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
			ELSE
				SET @stm1 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE RateTableRateID IN (',p_RateIds,')AND Action = "',p_Action,'" AND ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
			END IF;
	END CASE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSReviewVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSReviewVendorRate`(
	IN `p_accountId` INT,
	IN `p_trunkId` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT,
	IN `p_forbidden` INT,
	IN `p_preference` INT,
	IN `p_dialstringid` INT,
	IN `p_dialcodeSeparator` VARCHAR(50),
	IN `p_CurrencyID` INT,
	IN `p_list_option` INT
)
ThisSP:BEGIN


    -- @TODO: code cleanup
     DECLARE newstringcode INT(11) DEFAULT 0;
     DECLARE v_pointer_ INT;
     DECLARE v_rowCount_ INT;


	  DECLARE v_AccountCurrencyID_ INT;
	  DECLARE v_CompanyCurrencyID_ INT;


     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_;
    CREATE TEMPORARY TABLE tmp_split_VendorRate_ (
    		`TempVendorRateID` int,
			  `CodeDeckId` int ,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `EffectiveDate` Datetime ,
			  `EndDate` Datetime ,
			  `Change` varchar(100) ,
			  `ProcessId` varchar(200) ,
			  `Preference` varchar(100) ,
			  `ConnectionFee` decimal(18, 6),
			  `Interval1` int,
			  `IntervalN` int,
			  `Forbidden` varchar(100) ,
			  `DialStringPrefix` varchar(500) ,
			  INDEX tmp_EffectiveDate (`EffectiveDate`),
			  INDEX tmp_Code (`Code`),
        INDEX tmp_CC (`Code`,`Change`),
			  INDEX tmp_Change (`Change`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_TempVendorRate_;
    CREATE TEMPORARY TABLE tmp_TempVendorRate_ (
    		`TempVendorRateID` int,
			  `CodeDeckId` int ,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `EffectiveDate` Datetime ,
			  `EndDate` Datetime ,
			  `Change` varchar(100) ,
			  `ProcessId` varchar(200) ,
			  `Preference` varchar(100) ,
			  `ConnectionFee` decimal(18, 6),
			  `Interval1` int,
			  `IntervalN` int,
			  `Forbidden` varchar(100) ,
			  `DialStringPrefix` varchar(500) ,
			  INDEX tmp_EffectiveDate (`EffectiveDate`),
			  INDEX tmp_Code (`Code`),
        INDEX tmp_CC (`Code`,`Change`),
			  INDEX tmp_Change (`Change`)
    );

    CALL  prc_checkDialstringAndDupliacteCode(p_companyId,p_processId,p_dialstringid,p_effectiveImmediately,p_dialcodeSeparator);


	-- archive vendor rate code
--	CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId);


	ALTER TABLE `tmp_TempVendorRate_`	ADD Column `NewRate` decimal(18, 6) ;



    SELECT COUNT(*) AS COUNT INTO newstringcode from tmp_JobLog_;


	   SELECT CurrencyID into v_AccountCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblAccount WHERE AccountID=p_accountId);
	   SELECT CurrencyID into v_CompanyCurrencyID_ FROM tblCurrency WHERE CurrencyID=(SELECT CurrencyId FROM tblCompany WHERE CompanyID=p_companyId);


	-- update all rate on newrate with currency conversion.
	update tmp_TempVendorRate_
	SET
	NewRate = IF (
                    p_CurrencyID > 0,
                    CASE WHEN p_CurrencyID = v_AccountCurrencyID_
                    THEN
                       Rate
                    WHEN  p_CurrencyID = v_CompanyCurrencyID_
                    THEN
                    (
                        ( Rate  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ and CompanyID = p_companyId ) )
                    )
                    ELSE
                    (
                        (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ AND CompanyID = p_companyId )
                            *
                        (Rate  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
                    )
                    END ,
                    Rate
                )
   WHERE ProcessID=p_processId;


		-- if no error
    IF newstringcode = 0
    THEN
			-- if rates is not in our database (new rates from file) than insert it into ChangeLog
			INSERT INTO tblVendorRateChangeLog(
				TempVendorRateID,
				VendorRateID,
		   	AccountId,
		   	TrunkID,
				RateId,
		   	Code,
		   	Description,
		   	Rate,
		   	EffectiveDate,
		   	EndDate,
		   	Interval1,
		   	IntervalN,
		   	ConnectionFee,
		   	`Action`,
		   	ProcessID,
		   	created_at
			)
			SELECT
				tblTempVendorRate.TempVendorRateID,
				tblVendorRate.VendorRateID,
			   p_accountId AS AccountId,
			   p_trunkId AS TrunkID,
			   tblRate.RateId,
			   tblTempVendorRate.Code,
			   tblTempVendorRate.Description,
			   tblTempVendorRate.Rate,
			  	tblTempVendorRate.EffectiveDate,
				tblTempVendorRate.EndDate ,
			  	IFNULL(tblTempVendorRate.Interval1,tblRate.Interval1 ) as Interval1,		-- take interval from file and update in tblRate if not changed in service
			  	IFNULL(tblTempVendorRate.IntervalN , tblRate.IntervalN ) as IntervalN,
			   tblTempVendorRate.ConnectionFee,
			   'New' AS `Action`,
			   p_processId AS ProcessID,
			   now() AS created_at
			FROM tmp_TempVendorRate_ as tblTempVendorRate
			LEFT JOIN tblRate
			   ON tblTempVendorRate.Code = tblRate.Code AND tblTempVendorRate.CodeDeckId = tblRate.CodeDeckId  AND tblRate.CompanyID = p_companyId
			LEFT JOIN tblVendorRate
				ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountId = p_accountId   AND tblVendorRate.TrunkId = p_trunkId
				AND tblVendorRate.EffectiveDate  <= date(now())
		   WHERE tblTempVendorRate.ProcessID=p_processId AND tblVendorRate.VendorRateID IS NULL
              AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
				 -- AND tblTempVendorRate.EffectiveDate != '0000-00-00 00:00:00';


   		-- loop through effective date
      DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
			CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
				EffectiveDate  Date,
				RowID int,
				INDEX (RowID)
			);
      INSERT INTO tmp_EffectiveDates_
      SELECT distinct
        EffectiveDate,
        @row_num := @row_num+1 AS RowID
      FROM tmp_TempVendorRate_
        ,(SELECT @row_num := 0) x
      WHERE  ProcessID = p_processId
     -- AND EffectiveDate <> '0000-00-00 00:00:00'
      group by EffectiveDate
      order by EffectiveDate asc;


    SET v_pointer_ = 1;
		SET v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );

		IF v_rowCount_ > 0 THEN

			WHILE v_pointer_ <= v_rowCount_
			DO

				SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = v_pointer_ );
				SET @row_num = 0;

	         -- update  previous rate with all latest recent entriy of previous effective date

                       INSERT INTO tblVendorRateChangeLog(
                           TempVendorRateID,
                           VendorRateID,
                           AccountId,
                           TrunkID,
                           RateId,
                           Code,
                           Description,
                           Rate,
                           EffectiveDate,
                           EndDate,
                           Interval1,
                           IntervalN,
                           ConnectionFee,
                           `Action`,
                           ProcessID,
                           created_at
                       )
               			  SELECT
               			  distinct
                       tblTempVendorRate.TempVendorRateID,
                       VendorRate.VendorRateID,
                       p_accountId AS AccountId,
                       p_trunkId AS TrunkID,
                       VendorRate.RateId,
                       tblRate.Code,
                       tblRate.Description,
                       tblTempVendorRate.Rate,
                       tblTempVendorRate.EffectiveDate,
                       tblTempVendorRate.EndDate ,
                       tblTempVendorRate.Interval1,
                       tblTempVendorRate.IntervalN,
                       tblTempVendorRate.ConnectionFee,
                       IF(tblTempVendorRate.NewRate > VendorRate.Rate, 'Increased', IF(tblTempVendorRate.NewRate < VendorRate.Rate, 'Decreased','')) AS `Action`,
                       p_processid AS ProcessID,
                       now() AS created_at
                       FROM
                         (
                         -- get all rates RowID = 1 to remove old to old effective date

                         select distinct tmp.* ,
                         @row_num := IF(@prev_RateId = tmp.RateID AND @prev_EffectiveDate >= tmp.EffectiveDate, (@row_num + 1), 1) AS RowID,
                         @prev_RateId := tmp.RateID,
                         @prev_EffectiveDate := tmp.EffectiveDate
                         FROM
                         (


                         				select distinct vr1.*
	                         	     from tblVendorRate vr1
			                          LEFT outer join tblVendorRate vr2
												on vr1.AccountID = vr2.AccountID
												and vr1.TrunkID = vr2.TrunkID
												and vr1.RateID = vr2.RateID
												AND vr2.EffectiveDate  = @EffectiveDate
			                          where
			                          vr1.AccountID = p_accountId AND vr1.TrunkID = p_trunkId
			                          and vr1.EffectiveDate <= COALESCE(vr2.EffectiveDate,@EffectiveDate)   -- <= because if same day rate change need to log
			                          order by vr1.RateID desc ,vr1.EffectiveDate desc


                         ) tmp ,
								 ( SELECT @row_num := 0 , @prev_RateId := 0 , @prev_EffectiveDate := '' ) x
								  order by RateID desc , EffectiveDate desc


                         ) VendorRate
                      JOIN tblRate
                         ON tblRate.CompanyID = p_companyId
                         AND tblRate.RateID = VendorRate.RateId
                      JOIN tmp_TempVendorRate_ tblTempVendorRate
                         ON tblTempVendorRate.Code = tblRate.Code
								 	AND tblTempVendorRate.ProcessID=p_processId
                         --	AND  tblTempVendorRate.EffectiveDate <> '0000-00-00 00:00:00'
								 AND  VendorRate.EffectiveDate <= tblTempVendorRate.EffectiveDate -- <= because if same day rate change need to log
               				  AND tblTempVendorRate.EffectiveDate =  @EffectiveDate

               				   AND VendorRate.RowID = 1

                       WHERE
                         VendorRate.AccountId = p_accountId
                         AND VendorRate.TrunkId = p_trunkId
                         -- AND tblTempVendorRate.EffectiveDate <> '0000-00-00 00:00:00'
                         AND tblTempVendorRate.Code IS NOT NULL
                         AND tblTempVendorRate.ProcessID=p_processId
                         AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');

				SET v_pointer_ = v_pointer_ + 1;


			END WHILE;

		END IF;


    		IF p_list_option = 1 -- p_list_option = 1 : "Completed List", p_list_option = 2 : "Partial List"
    		THEN

    			-- get rates which is not in file and insert it into ChangeLog
         	          INSERT INTO tblVendorRateChangeLog(
				VendorRateID,
			   	AccountId,
			   	TrunkID,
				RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	EffectiveDate,
			   	EndDate,
			   	Interval1,
			   	IntervalN,
			   	ConnectionFee,
			   	`Action`,
			   	ProcessID,
			   	created_at
				)
				SELECT DISTINCT
                    tblVendorRate.VendorRateID,
                    p_accountId AS AccountId,
                    p_trunkId AS TrunkID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.EffectiveDate,
                    tblVendorRate.EndDate ,
                    tblVendorRate.Interval1,
                    tblVendorRate.IntervalN,
                    tblVendorRate.ConnectionFee,
                    'Deleted' AS `Action`,
			   			p_processId AS ProcessID,
                    now() AS deleted_at
                    FROM tblVendorRate
                    JOIN tblRate
                    ON tblRate.RateID = tblVendorRate.RateId AND tblRate.CompanyID = p_companyId
                    LEFT JOIN tmp_TempVendorRate_ as tblTempVendorRate
                    ON tblTempVendorRate.Code = tblRate.Code

						  AND tblTempVendorRate.ProcessID=p_processId
						  AND (
						  			-- normal condition
								  ( tblTempVendorRate.EndDate is null AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block') )
							  	OR
							  		-- skip records just to avoid duplicate records in tblVendorRateChangeLog tabke - when EndDate is given with delete
								  ( tblTempVendorRate.EndDate is not null AND tblTempVendorRate.Change IN ('Delete', 'R', 'D', 'Blocked','Block') )
							  )
                    WHERE tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
                    AND ( tblVendorRate.EndDate is null OR tblVendorRate.EndDate <= date(now()) )
                    AND tblTempVendorRate.Code IS NULL
                    ORDER BY VendorRateID ASC;

    		END IF;


            INSERT INTO tblVendorRateChangeLog(
				VendorRateID,
			   	AccountId,
			   	TrunkID,
				RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	EffectiveDate,
			   	EndDate,
			   	Interval1,
			   	IntervalN,
			   	ConnectionFee,
			   	`Action`,
			   	ProcessID,
			   	created_at
				)
				SELECT DISTINCT
                    tblVendorRate.VendorRateID,
                    p_accountId AS AccountId,
                    p_trunkId AS TrunkID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.EffectiveDate,
                    IFNULL(tblTempVendorRate.EndDate,tblVendorRate.EndDate) as  EndDate ,
                    tblVendorRate.Interval1,
                    tblVendorRate.IntervalN,
                    tblVendorRate.ConnectionFee,
                    'Deleted' AS `Action`,
			   			p_processId AS ProcessID,
                    now() AS deleted_at
                    FROM tblVendorRate
                    JOIN tblRate
                    ON tblRate.RateID = tblVendorRate.RateId AND tblRate.CompanyID = p_companyId
                    LEFT JOIN tmp_TempVendorRate_ as tblTempVendorRate
	                    ON tblRate.Code = tblTempVendorRate.Code
							  AND tblTempVendorRate.Change IN ('Delete', 'R', 'D', 'Blocked','Block')
							   AND tblTempVendorRate.ProcessID=p_processId
                    -- AND tblTempVendorRate.EndDate <= date(now())
         	           -- AND tblTempVendorRate.ProcessID=p_processId
                    WHERE tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
               	     -- AND tblVendorRate.EndDate <= date(now())
            	        AND tblTempVendorRate.Code IS NOT NULL
                    ORDER BY VendorRateID ASC;



    END IF;

    SELECT * FROM tmp_JobLog_;

	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `vwCustomerArchiveCurrentRates`;
DELIMITER //
CREATE PROCEDURE `vwCustomerArchiveCurrentRates`(
	IN `p_CompanyID` INT,
	IN `p_CustomerID` INT,
	IN `p_TrunkID` INT,
	IN `p_Effective` VARCHAR(20),
	IN `p_CustomDate` DATE
)
BEGIN
	DECLARE v_codedeckid_ INT;
	DECLARE v_IncludePrefix_ INT;
	DECLARE v_Prefix_ VARCHAR(50);
	DECLARE v_RatePrefix_ VARCHAR(50);
	DECLARE v_AreaPrefix_ VARCHAR(50);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	-- set custome date = current date if custom date is past date
	IF(p_CustomDate < DATE(NOW()))
	THEN
		SET p_CustomDate=DATE(NOW());
	END IF;

    SELECT
        CodeDeckId,
		IncludePrefix
		INTO v_codedeckid_,v_IncludePrefix_
    FROM tblCustomerTrunk
    WHERE CompanyID = p_CompanyID
    AND tblCustomerTrunk.TrunkID = p_TrunkID
    AND tblCustomerTrunk.AccountID = p_CustomerID
    AND tblCustomerTrunk.Status = 1;

	SELECT
		Prefix,RatePrefix,AreaPrefix INTO v_Prefix_,v_RatePrefix_,v_AreaPrefix_
	FROM tblTrunk
	WHERE CompanyID = p_CompanyID
		AND tblTrunk.TrunkID = p_TrunkID
		AND tblTrunk.Status = 1;

	DROP TEMPORARY TABLE IF EXISTS tmp_customerrate_archive_;
	CREATE TEMPORARY TABLE tmp_customerrate_archive_ (
		RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
	);


	INSERT INTO tmp_customerrate_archive_
	(
		RateID,
        Code,
        Description,
        Interval1,
        IntervalN,
        ConnectionFee,
        RoutinePlanName,
        Rate,
        EffectiveDate,
        EndDate,
        LastModifiedDate,
        LastModifiedBy,
        CustomerRateId,
        TrunkID,
        RateTableRateId,
        IncludePrefix,
        `Prefix`,
        RatePrefix,
        AreaPrefix
	)
	SELECT
		cra.RateId,
		r.Code,
		r.Description,
		CASE WHEN cra.Interval1 IS NOT NULL THEN cra.Interval1 ELSE r.Interval1 END AS Interval1,
		CASE WHEN cra.IntervalN IS NOT NULL THEN cra.IntervalN ELSE r.IntervalN END AS IntervalN,
		IFNULL(cra.ConnectionFee,'') AS ConnectionFee,
		cra.RoutinePlan,
		cra.Rate,
		cra.EffectiveDate,
		IFNULL(cra.EndDate,'') AS EndDate,
		IFNULL(cra.created_at,'') AS ModifiedDate,
		IFNULL(cra.created_by,'') AS ModifiedBy,
		cra.CustomerRateID,
		cra.TrunkID,
		NULL AS RateTableRateId,
		v_IncludePrefix_ as IncludePrefix,
		CASE  WHEN tblTrunk.TrunkID is not null
		THEN
			tblTrunk.Prefix
		ELSE
			v_Prefix_
		END AS Prefix,
		CASE  WHEN tblTrunk.TrunkID is not null
		THEN
			tblTrunk.RatePrefix
		ELSE
			v_RatePrefix_
		END AS RatePrefix,
		CASE  WHEN tblTrunk.TrunkID is not null
		THEN
			tblTrunk.AreaPrefix
		ELSE
			v_AreaPrefix_
		END AS AreaPrefix
	FROM
		tblCustomerRateArchive cra
	JOIN
		tblRate r ON r.RateID=cra.RateId
	LEFT JOIN
		tblTrunk ON tblTrunk.TrunkID = cra.RoutinePlan
	WHERE
		r.CompanyID = p_CompanyID AND
		cra.AccountId = p_CustomerID AND
		r.CodeDeckId = v_codedeckid_ AND
		(
			cra.EffectiveDate <= NOW() AND date(cra.EndDate) = date(NOW())
			/*( p_Effective = 'Now' AND cra.EffectiveDate <= NOW() )
			OR
			( p_Effective = 'Future' AND cra.EffectiveDate > NOW() )
			OR
			( p_Effective = 'CustomDate' AND cra.EffectiveDate <= p_CustomDate AND (cra.EndDate IS NULL OR cra.EndDate > p_CustomDate) )
			OR
			p_Effective = 'All'*/
		);

	DROP TEMPORARY TABLE IF EXISTS tmp_customerrate_archive_2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_customerrate_archive_2_ as (select * from tmp_customerrate_archive_);
	DELETE n1 FROM tmp_customerrate_archive_ n1, tmp_customerrate_archive_2_ n2 WHERE n1.LastModifiedDate > n2.LastModifiedDate
	AND n1.EffectiveDate = n2.EffectiveDate
	AND n1.TrunkID = n2.TrunkID
	AND  n1.RateID = n2.RateID;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `vwCustomerRate`;
DELIMITER //
CREATE PROCEDURE `vwCustomerRate`(
	IN `p_CustomerID` INT,
	IN `p_Trunks` VARCHAR(200),
	IN `p_Effective` VARCHAR(20),
	IN `p_CustomDate` DATE
)
BEGIN

	DECLARE v_codedeckid_ INT;
    DECLARE v_ratetableid_ INT;
    DECLARE v_RateTableAssignDate_ DATETIME;
    DECLARE v_NewA2ZAssign_ INT;
    DECLARE v_companyid_ INT;
    DECLARE v_TrunkID_ INT;
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


    DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_;
    CREATE TEMPORARY TABLE tmp_customerrateall_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_archive_;
    CREATE TEMPORARY TABLE tmp_customerrateall_archive_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_trunks_;
    CREATE TEMPORARY TABLE tmp_trunks_  (
        TrunkID INT,
        RowNo INT
    );

    SELECT
        CompanyId INTO v_companyid_
    FROM tblAccount
    WHERE AccountID = p_CustomerID;

    INSERT INTO tmp_trunks_
    SELECT TrunkID,
        @row_num := @row_num+1 AS RowID
    FROM tblCustomerTrunk,(SELECT @row_num := 0) x
    WHERE  FIND_IN_SET(tblCustomerTrunk.TrunkID,p_Trunks)!= 0
        AND tblCustomerTrunk.AccountID = p_CustomerID;

    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_trunks_);

    WHILE v_pointer_ <= v_rowCount_
    DO
        SET v_TrunkID_ = (SELECT TrunkID FROM tmp_trunks_ t WHERE t.RowNo = v_pointer_);

        CALL prc_GetCustomerRate(v_companyid_,p_CustomerID,v_TrunkID_,null,null,null,p_Effective,p_CustomDate,1,0,0,0,'','',-1);

        INSERT INTO tmp_customerrateall_
        SELECT * FROM tmp_customerrate_;

        CALL vwCustomerArchiveCurrentRates(v_companyid_,p_CustomerID,v_TrunkID_,p_Effective,p_CustomDate);

        INSERT INTO tmp_customerrateall_archive_
        SELECT * FROM tmp_customerrate_archive_;

        SET v_pointer_ = v_pointer_ + 1;
    END WHILE;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `vwVendorSippySheet`;
DELIMITER //
CREATE PROCEDURE `vwVendorSippySheet`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE

)
BEGIN

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorSippySheet_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorSippySheet_(
			RateID int,
			`Action [A|D|U|S|SA` varchar(50),
			id varchar(10),
			Prefix varchar(50),
			COUNTRY varchar(200),
			Preference int,
			`Interval 1` int,
			`Interval N` int,
			`Price 1` float,
			`Price N` float,
			`1xx Timeout` int,
			`2xx Timeout` INT,
			Huntstop int,
			Forbidden int,
			`Activation Date` varchar(20),
			`Expiration Date` varchar(20),
			AccountID int,
			TrunkID int
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorArhiveSippySheet_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorArhiveSippySheet_(
			RateID int,
			`Action [A|D|U|S|SA` varchar(50),
			id varchar(10),
			Prefix varchar(50),
			COUNTRY varchar(200),
			Preference int,
			`Interval 1` int,
			`Interval N` int,
			`Price 1` float,
			`Price N` float,
			`1xx Timeout` int,
			`2xx Timeout` INT,
			Huntstop int,
			Forbidden int,
			`Activation Date` varchar(20),
			`Expiration Date` varchar(20),
			AccountID int,
			TrunkID int
		);

		call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective,p_CustomDate);

		INSERT INTO tmp_VendorSippySheet_
			SELECT
				NULL AS RateID,
				CASE WHEN EndDate IS NOT NULL THEN
					'SA'
				ELSE 
				'A' 
				END AS `Action [A|D|U|S|SA`,
				'' AS id,
				Concat('' , tblTrunk.Prefix ,vendorRate.Code) AS Prefix,
				vendorRate.Description AS COUNTRY,
				IFNULL(tblVendorPreference.Preference,5) as Preference,
				vendorRate.Interval1 as `Interval 1`,
				vendorRate.IntervalN as `Interval N`,
				vendorRate.Rate AS `Price 1`,
				vendorRate.Rate AS `Price N`,
				10 AS `1xx Timeout`,
				60 AS `2xx Timeout`,
				0 AS Huntstop,
				CASE
				WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND
							FIND_IN_SET(vendorRate.TrunkId,tblVendorBlocking.TrunkId) != 0
							OR
							(blockCountry.VendorBlockingId IS NOT NULL AND
							 FIND_IN_SET(vendorRate.TrunkId,blockCountry.TrunkId) != 0
							)
				) THEN 1
				ELSE 0
				END  AS Forbidden,
				DATE_FORMAT( EffectiveDate, '%Y-%m-%d %H:%i:%s' ) AS `Activation Date`,
				DATE_FORMAT( EndDate, '%Y-%m-%d %H:%i:%s' )  AS `Expiration Date`,
				
				tblAccount.AccountID,
				tblTrunk.TrunkID
			FROM tmp_VendorCurrentRates_ AS vendorRate
				INNER JOIN tblAccount
					ON vendorRate.AccountId = tblAccount.AccountID
				LEFT OUTER JOIN tblVendorBlocking
					ON vendorRate.RateID = tblVendorBlocking.RateId
						 AND tblAccount.AccountID = tblVendorBlocking.AccountId
						 AND vendorRate.TrunkID = tblVendorBlocking.TrunkID
				LEFT OUTER JOIN tblVendorBlocking AS blockCountry
					ON vendorRate.CountryID = blockCountry.CountryId
						 AND tblAccount.AccountID = blockCountry.AccountId
						 AND vendorRate.TrunkID = blockCountry.TrunkID
				LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = vendorRate.AccountId
						 AND tblVendorPreference.TrunkID = vendorRate.TrunkID
						 AND tblVendorPreference.RateId = vendorRate.RateID
				INNER JOIN tblTrunk
					ON tblTrunk.TrunkID = vendorRate.TrunkID
			WHERE (vendorRate.Rate > 0);

		
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnVendorSippySheet`;
DELIMITER //
CREATE PROCEDURE `fnVendorSippySheet`(
	IN `p_AccountID` int,
	IN `p_Trunks` longtext,
	IN `p_Effective` VARCHAR(50)
)
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorSippySheet_(
            RateID int,
            `Action [A|D|U|S|SA` varchar(50),
            id varchar(10),
            Prefix varchar(50),
            COUNTRY varchar(200),
            Preference int,
            `Interval 1` int,
            `Interval N` int,
            `Price 1` float,
            `Price N` float,
            `1xx Timeout` int,
            `2xx Timeout` INT,
            Huntstop int,
            Forbidden int,
            `Activation Date` varchar(10),
            `Expiration Date` varchar(10),
            AccountID int,
            TrunkID int
    );

    call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective);

        SELECT NULL AS RateID,
               'A' AS `Action [A|D|U|S|SA]`,
               '' AS id,
               Concat(tblTrunk.Prefix , vendorRate.Code)  AS PREFIX,
               vendorRate.Description AS COUNTRY,
               5 AS Preference,
               vendorRate.`Interval 1` AS `Interval 1`,
               vendorRate.`Interval N` AS `Interval N`,
               vendorRate.Rate AS `Price 1`,
               vendorRate.Rate AS `Price N`,
               10 AS `1xx Timeout`,
               60 AS `2xx Timeout`,
               0 AS Huntstop,
               CASE WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND  FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0) OR (blockCountry.VendorBlockingId IS NOT NULL AND FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0 )
                THEN 1
                ELSE 0
                END AS Forbidden,
               'NOW' AS `Activation Date`,
               '' AS `Expiration Date`,
               tblAccount.AccountID,
               tblTrunk.TrunkID
        FROM tmp_VendorSippySheet_ AS vendorRate
        INNER JOIN tblAccount ON vendorRate.AccountId = tblAccount.AccountID
        LEFT OUTER JOIN tblVendorBlocking ON vendorRate.RateID = tblVendorBlocking.RateId
        AND tblAccount.AccountID = tblVendorBlocking.AccountId
        AND vendorRate.TrunkID = tblVendorBlocking.TrunkID
        LEFT OUTER JOIN tblVendorBlocking AS blockCountry ON vendorRate.CountryID = blockCountry.CountryId
        AND tblAccount.AccountID = blockCountry.AccountId
        AND vendorRate.TrunkID = blockCountry.TrunkID
        INNER JOIN tblTrunk ON tblTrunk.TrunkID = vendorRate.TrunkID
        WHERE vendorRate.AccountId = p_AccountID
          AND FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0
          AND vendorRate.Rate > 0;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ArchiveOldVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldVendorRate`(
	IN `p_AccountIds` longtext,
	IN `p_TrunkIds` longtext,
	IN `p_DeletedBy` TEXT
)
BEGIN
 	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	 /*1. Move Rates which EndDate <= now() */


	INSERT INTO tblVendorRateArchive
   SELECT DISTINCT  null , -- Primary Key column
							`VendorRateID`,
							`AccountId`,
							`TrunkID`,
							`RateId`,
							`Rate`,
							`EffectiveDate`,
							IFNULL(`EndDate`,date(now())) as EndDate,
							`updated_at`,
							now() as `created_at`,
							p_DeletedBy AS `created_by`,
							`updated_by`,
							`Interval1`,
							`IntervalN`,
							`ConnectionFee`,
							`MinimumCost`,
	  concat('Ends Today rates @ ' , now() ) as `Notes`
      FROM tblVendorRate
      WHERE  FIND_IN_SET(AccountId,p_AccountIds) != 0 AND FIND_IN_SET(TrunkID,p_TrunkIds) != 0 AND EndDate <= NOW();


/*
     IF (FOUND_ROWS() > 0) THEN
	 	select concat(FOUND_ROWS() ," Ends Today rates" ) ;
	  END IF;
*/



	DELETE  vr
	FROM tblVendorRate vr
   inner join tblVendorRateArchive vra
   on vr.VendorRateID = vra.VendorRateID
	WHERE  FIND_IN_SET(vr.AccountId,p_AccountIds) != 0 AND FIND_IN_SET(vr.TrunkID,p_TrunkIds) != 0;


	/*  IF (FOUND_ROWS() > 0) THEN
		 select concat(FOUND_ROWS() ," sane rate " ) ;
	 END IF;

	*/

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CronJobGenerateM2VendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateM2VendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
                        AND
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW())
								  	OR
								  	(p_Effective = 'Future' AND EffectiveDate > NOW())
								  	OR
								  	(p_Effective = 'CustomDate' AND EffectiveDate <= p_CustomDate AND (EndDate IS NULL OR EndDate > p_CustomDate))
								  	OR
								  	(p_Effective = 'All')
								);

		 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);

      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
	   AND
	   (
			(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
		  	OR
		  	(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_m2rateall_;
    CREATE TEMPORARY TABLE tmp_m2rateall_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE
    );

     INSERT INTO tmp_m2rateall_
     SELECT Distinct
			tblRate.RateID as `RateID`,
			tblRate.Code as `Code`,
			tblRate.Description as `Description` ,
			CASE WHEN tblVendorRate.Interval1 IS NOT NULL
			   THEN tblVendorRate.Interval1
			   ElSE tblRate.Interval1
			END AS `Interval1`,
			CASE WHEN tblVendorRate.IntervalN IS NOT NULL
			   THEN tblVendorRate.IntervalN
			   ElSE tblRate.IntervalN
			END  AS `IntervalN`,
			tblVendorRate.ConnectionFee as `ConnectionFee`,
			Abs(tblVendorRate.Rate) as `Rate`,
			tblVendorRate.EffectiveDate as `EffectiveDate`
        FROM    tmp_VendorRate_ as tblVendorRate
            JOIN tblRate on tblVendorRate.RateId =tblRate.RateID;

		SELECT DISTINCT
			Description  as `Destination`,
			Code as `Prefix`,
			Rate as `Rate(USD)`,
			ConnectionFee as `Connection Fee(USD)`,
			Interval1 as `Increment`,
			IntervalN as `Minimal Time`,
			'0:00:00 'as `Start Time`,
			'23:59:59' as `End Time`,
			'' as `Week Day`,
			EffectiveDate  as `Effective from`
		FROM tmp_m2rateall_;

      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CronJobGenerateMorVendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateMorVendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
                        AND
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW())
								  	OR
								  	(p_Effective = 'Future' AND EffectiveDate > NOW())
								  	OR
								  	(p_Effective = 'CustomDate' AND EffectiveDate <= p_CustomDate AND (EndDate IS NULL OR EndDate > p_CustomDate))
								  	OR
								  	(p_Effective = 'All')
								);

		 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);

      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
		AND
	   (
			(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
		  	OR
		  	(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_morrateall_;
    CREATE TEMPORARY TABLE tmp_morrateall_ (
        RateID INT,
        Country VARCHAR(155),
        CountryCode VARCHAR(50),
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        SubCode VARCHAR(50)
    );

     INSERT INTO tmp_morrateall_
     SELECT Distinct
          tblRate.RateID as `RateID`,
			  c.Country as `Country`,
			  c.ISO3 as `CountryCode`,
			  tblRate.Code as `Code`,
               tblRate.Description as `Description` ,
               CASE WHEN tblVendorRate.Interval1 IS NOT NULL
                   THEN tblVendorRate.Interval1
                   ElSE tblRate.Interval1
               END AS `Interval1`,
               CASE WHEN tblVendorRate.IntervalN IS NOT NULL
                   THEN tblVendorRate.IntervalN
                   ElSE tblRate.IntervalN
               END  AS `IntervalN`,
               tblVendorRate.ConnectionFee as `ConnectionFee`,
               Abs(tblVendorRate.Rate) as `Rate`,
               'FIX' as `SubCode`

       FROM    tmp_VendorRate_ as tblVendorRate
               JOIN tblRate on tblVendorRate.RateId =tblRate.RateID
               LEFT JOIN tblCountry as c
                   ON tblRate.CountryID = c.CountryID;

		UPDATE tmp_morrateall_
	  			SET SubCode='MOB'
	  			WHERE Description LIKE '%Mobile%';


		SELECT DISTINCT
	      Country as `Direction` ,
	      Description  as `Destination`,
		   Code as `Prefix`,
		   SubCode as `Subcode`,
		   CountryCode as `Country code`,
		   Rate as `Rate(EUR)`,
		   ConnectionFee as `Connection Fee(EUR)`,
		   Interval1 as `Increment`,
		   IntervalN as `Minimal Time`,
		   '0:00:00 'as `Start Time`,
		   '23:59:59' as `End Time`,
		   '' as `Week Day`
     FROM tmp_morrateall_;

      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaVendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGeneratePortaVendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`,
		  DATE_FORMAT (`EffectiveDate`, '%Y-%m-%d') AS EffectiveDate,
		   `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
                        AND
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW())
								  	OR
								  	(p_Effective = 'Future' AND EffectiveDate > NOW())
								  	OR
								  	(p_Effective = 'CustomDate' AND EffectiveDate <= p_CustomDate AND (EndDate IS NULL OR EndDate > p_CustomDate))
								  	OR
								  	(p_Effective = 'All')
								);

		 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);
      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
		AND
	   (
			(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
		  	OR
		  	(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
		);



	DROP TEMPORARY TABLE IF EXISTS tmp_VendorArchiveCurrentRates_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorArchiveCurrentRates_(
		AccountId int,
		Code varchar(50),
		Description varchar(200),
		Rate float,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Interval1 INT,
		IntervalN varchar(100),
		ConnectionFee float,
		EndDate date
    );

	IF p_Effective = 'Now' || p_Effective = 'All' THEN

  	 	call vwVendorArchiveCurrentRates(p_AccountID,p_Trunks,p_Effective);

	END IF;

       SELECT Distinct  tblRate.Code as `Destination`,
               tblRate.Description as `Description` ,
               CASE WHEN tblVendorRate.Interval1 IS NOT NULL
                   THEN tblVendorRate.Interval1
                   ElSE tblRate.Interval1
               END AS `First Interval`,
               CASE WHEN tblVendorRate.IntervalN IS NOT NULL
                   THEN tblVendorRate.IntervalN
                   ElSE tblRate.IntervalN
               END  AS `Next Interval`,
               Abs(tblVendorRate.Rate) as `First Price`,
               Abs(tblVendorRate.Rate) as `Next Price`,
               DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d')  as `Effective From` ,
               IFNULL(Preference,5) as `Preference`,
               CASE
                   WHEN (blockCode.VendorBlockingId IS NOT NULL AND
                   	FIND_IN_SET(tblVendorRate.TrunkId,blockCode.TrunkId) != 0
                       )OR
                       (blockCountry.VendorBlockingId IS NOT NULL AND
                       FIND_IN_SET(tblVendorRate.TrunkId,blockCountry.TrunkId) != 0
                       ) THEN 'Y'
                   ELSE 'N'
               END AS `Forbidden`,
               CASE WHEN tblVendorRate.Rate < 0 THEN 'Y' ELSE '' END AS 'Payback Rate' ,
               CASE WHEN ConnectionFee > 0 THEN
						CONCAT('SEQ=',ConnectionFee,'&int1x1@price1&intNxN@priceN')
					ELSE
						''
					END as `Formula`,
					'N' AS `Discontinued`
       FROM    tmp_VendorRate_ as tblVendorRate
               JOIN tblRate on tblVendorRate.RateId =tblRate.RateID
               LEFT JOIN tblVendorBlocking as blockCode
                   ON tblVendorRate.RateID = blockCode.RateId
                   AND blockCode.AccountId = p_AccountID
                   AND tblVendorRate.TrunkID = blockCode.TrunkID
               LEFT JOIN tblVendorBlocking AS blockCountry
                   ON tblRate.CountryID = blockCountry.CountryId
                   AND blockCountry.AccountId = p_AccountID
                   AND tblVendorRate.TrunkID = blockCountry.TrunkID
					LEFT JOIN tblVendorPreference
						ON tblVendorPreference.AccountId = p_AccountID
						AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
						AND tblVendorPreference.RateId = tblVendorRate.RateId
       UNION ALL



		SELECT
					Distinct
			    	tblRate.Code AS `Destination`,
			 		tblRate.Description AS `Description` ,

			 		CASE WHEN vrd.Interval1 IS NOT NULL
                   THEN vrd.Interval1
                   ElSE tblRate.Interval1
               END AS `First Interval`,
               CASE WHEN vrd.IntervalN IS NOT NULL
                   THEN vrd.IntervalN
                   ElSE tblRate.IntervalN
               END  AS `Next Interval`,

			 		Abs(vrd.Rate) AS `First Price`,
			 		Abs(vrd.Rate) AS `Next Price`,
			 		DATE_FORMAT (vrd.EffectiveDate, '%Y-%m-%d') AS `Effective From`,
			 		'' AS `Preference`,
			 		'' AS `Forbidden`,
			 		CASE WHEN vrd.Rate < 0 THEN 'Y' ELSE '' END AS 'Payback Rate' ,
			 		CASE WHEN vrd.ConnectionFee > 0 THEN
						CONCAT('SEQ=',vrd.ConnectionFee,'&int1x1@price1&intNxN@priceN')
					ELSE
						''
					END as `Formula`,
			 		'Y' AS `Discontinued`
			FROM tmp_VendorArchiveCurrentRates_ AS vrd
	 		JOIN tblRate on vrd.RateId = tblRate.RateID
			LEFT JOIN tblVendorRate vr
						ON vrd.AccountId = vr.AccountId
							AND vrd.TrunkID = vr.TrunkID
							AND vrd.RateId = vr.RateId
					WHERE FIND_IN_SET(vrd.TrunkID,p_trunks) != 0
						AND vrd.AccountId = p_AccountID
						AND vr.VendorRateID IS NULL
						AND vrd.Rate > 0;


			/*
		    SELECT
			 		vrd.Code AS `Destination`,
			 		vrd.Description AS `Description` ,
			 		vrd.Interval1 AS `First Interval`,
			 		vrd.IntervalN AS `Next Interval`,
			 		Abs(vrd.Rate) AS `First Price`,
			 		Abs(vrd.Rate) AS `Next Price`,
			 		vrd.EffectiveDate AS `Effective From`,
			 		'' AS `Preference`,
			 		'' AS `Forbidden`,
			 		CASE WHEN vrd.Rate < 0 THEN 'Y' ELSE '' END AS 'Payback Rate' ,
			 		CASE WHEN vrd.ConnectionFee > 0 THEN
						CONCAT('SEQ=',vrd.ConnectionFee,'&int1x1@price1&intNxN@priceN')
					ELSE
						''
					END as `Formula`,
			 		'Y' AS `Discontinued`
			  FROM tblVendorRateDiscontinued vrd
					LEFT JOIN tblVendorRate vr
						ON vrd.AccountId = vr.AccountId
							AND vrd.TrunkID = vr.TrunkID
							AND vrd.RateId = vr.RateId
					WHERE FIND_IN_SET(vrd.TrunkID,p_trunks) != 0
						AND vrd.AccountId = p_AccountID
						AND vr.VendorRateID IS NULL ;
*/


      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_DeleteTicketGroup`;
DELIMITER //
CREATE PROCEDURE `prc_DeleteTicketGroup`(
	IN `p_CompanyID` INT,
	IN `p_GroupID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 1
-- delete tblTicketLog

	DELETE tl FROM
		tblTicketLog tl
		inner join tblTickets t
		on tl.TicketID = t.TicketID
	where t.`Group` = p_GroupID
		AND t.CompanyID = p_CompanyID;

-- 2
-- delete tblTicketDashboardTimeline

--	DELETE FROM tblTicketDashboardTimeline where GroupID = p_GroupID AND CompanyID = p_CompanyID;

-- 3
-- delete tblTicketsDetails

	DELETE td FROM
		tblTicketsDetails td
		inner join tblTickets t
		on td.TicketID = t.TicketID
	where t.`Group` = p_GroupID
		AND t.CompanyID = p_CompanyID;


-- 4
-- delete tblTicketsDeletedLog

	DELETE FROM tblTicketsDeletedLog where tblTicketsDeletedLog.`Group` = p_GroupID AND CompanyID = p_CompanyID;

-- 5
-- delete AccountEmailLogDeletedLog

	DELETE ae FROM
		AccountEmailLogDeletedLog ae
		inner join tblTickets t
		on ae.TicketID = t.TicketID
	where t.`Group` = p_GroupID
		AND t.CompanyID = p_CompanyID;


-- 6
-- delete tblTicketsDetails
	DELETE ae FROM
		AccountEmailLog ae
		inner join tblTickets t
		on ae.TicketID = t.TicketID
	where t.`Group` = p_GroupID
		AND t.CompanyID = p_CompanyID;

-- 7
-- delete tblTickets

	DELETE FROM tblTickets where tblTickets.`Group` = p_GroupID AND CompanyID = p_CompanyID;

-- 8
-- delete tblTicketGroups

	DELETE FROM tblTicketGroups where GroupID = p_GroupID AND CompanyID = p_CompanyID;


	DELETE FROM tblTicketGroupAgents where GroupID = p_GroupID;



SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getDiscontinuedVendorRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedVendorRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_CountryID` INT,
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
   CREATE TEMPORARY TABLE tmp_VendorRate_ (
        VendorRateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
		  ConnectionFee VARCHAR(50),
        Interval1 INT,
        IntervalN INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        updated_at DATETIME,
        updated_by VARCHAR(50),
        INDEX tmp_VendorRate_RateID (`Code`)
   );

   INSERT INTO tmp_VendorRate_
		SELECT
			vra.VendorRateID,
			r.Code,
			r.Description,
			'' AS ConnectionFee,
			CASE WHEN vra.Interval1 IS NOT NULL THEN vra.Interval1 ELSE r.Interval1 END AS Interval1,
			CASE WHEN vra.IntervalN IS NOT NULL THEN vra.IntervalN ELSE r.IntervalN END AS IntervalN,
			vra.Rate,
			vra.EffectiveDate,
			vra.EndDate,
			vra.created_at AS updated_at,
			vra.created_by AS updated_by
		FROM
			tblVendorRateArchive vra
		JOIN
			tblRate r ON r.RateID=vra.RateId
		LEFT JOIN
			tblVendorRate vr ON vr.AccountId = vra.AccountId AND vr.TrunkID = vra.TrunkID AND vr.RateId = vra.RateId
		WHERE
			r.CompanyID = p_CompanyID AND
			vra.TrunkID = p_TrunkID AND
			vra.AccountId = p_AccountID AND
			(p_CountryID IS NULL OR r.CountryID = p_CountryID) AND
			(p_code IS NULL OR r.Code LIKE REPLACE(p_code, '*', '%')) AND
			(p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%')) AND
			vr.VendorRateID is NULL;

	IF p_isExport = 0
	THEN
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate2_ as (select * from tmp_VendorRate_);
		DELETE
			n1
		FROM
			tmp_VendorRate_ n1, tmp_VendorRate2_ n2
		WHERE
			n1.Code = n2.Code AND n1.VendorRateID < n2.VendorRateID;

 		SELECT
			VendorRateID,
			Code,
			Description,
			ConnectionFee,
			Interval1,
			IntervalN,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			updated_by
		FROM
			tmp_VendorRate_
		ORDER BY
			CASE
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN EndDate
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN EndDate
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN updated_by
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN updated_by
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorRateIDDESC') THEN VendorRateID
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorRateIDASC') THEN VendorRateID
			END ASC
		LIMIT
			p_RowspPage
		OFFSET
			v_OffSet_;

		SELECT
			COUNT(code) AS totalcount
		FROM tmp_VendorRate_;

	END IF;

   IF p_isExport = 1
	THEN
		SELECT
			Code,
			Description,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`

		FROM tmp_VendorRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetTicketDashboardSummary`;
DELIMITER //
CREATE PROCEDURE `prc_GetTicketDashboardSummary`(
	IN `p_CompanyID` INT,
	IN `P_Group` VARCHAR(100),
	IN `P_Agent` VARCHAR(100)
)
BEGIN

	DECLARE v_Open_ INT;
	DECLARE v_OnHold_ INT;
	DECLARE v_UnResolved_ INT;
	DECLARE v_TotalPaymentOut_ INT;
	DECLARE v_UnAssigned_ INT;
	DECLARE v_OnHoldChech_ VARCHAR(500);
	DECLARE v_UnResolvedCheck_ VARCHAR(500);

	SELECT CONCAT('Pending',',',GROUP_CONCAT(tfv.FieldValueAgent SEPARATOR ',')) as FieldValueAgent INTO v_OnHoldChech_ FROM tblTicketfieldsValues tfv
	WHERE tfv.FieldsID = (SELECT tf.TicketFieldsID FROM tblTicketfields tf WHERE tf.FieldType = 'default_status' LIMIT 1)
	AND tfv.FieldType !=0
	AND (tfv.FieldSlaTime=0)
	AND tfv.FieldValueAgent!='All UnResolved';

	DROP TEMPORARY TABLE IF EXISTS tmp_Tickets_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Tickets_(
		TicketAgentID VARCHAR(50),
		TicketStatusID int,
		TicketStatus VARCHAR(30)
	);

	INSERT INTO tmp_Tickets_
	SELECT
		T.Agent as TicketAgentID,
		TFV.ValuesID as  TicketStatusID,
		TFV.FieldValueAgent  as TicketStatus
	FROM
		tblTickets T
	LEFT JOIN tblTicketfieldsValues TFV
		ON TFV.ValuesID = T.Status
	LEFT JOIN tblTicketPriority TP
		ON TP.PriorityID = T.Priority
	LEFT JOIN tblUser TU
		ON TU.UserID = T.Agent
	LEFT JOIN tblTicketGroups TG
		ON TG.GroupID = T.`Group`
	WHERE
		T.CompanyID = p_CompanyID
		AND (P_Group = '' OR FIND_IN_SET(T.`Group`,P_Group))
		AND (P_Agent = '' OR FIND_IN_SET(T.`Agent`,P_Agent));

	SELECT COUNT(TicketStatusID) INTO v_Open_  FROM	tmp_Tickets_
	WHERE TicketStatus = 'Open';

	SELECT COUNT(TicketStatusID) INTO v_OnHold_  FROM	tmp_Tickets_
	WHERE FIND_IN_SET(TicketStatus,v_OnHoldChech_);

	SELECT COUNT(TicketStatusID) INTO v_UnResolved_  FROM	tmp_Tickets_
	WHERE !FIND_IN_SET(TicketStatus,'All UnResolved,Resolved,Closed');

	SELECT COUNT(TicketStatusID) INTO v_UnAssigned_  FROM	tmp_Tickets_
	WHERE TicketAgentID = 0 AND FIND_IN_SET(TicketStatus,'All UnResolved,Pending,Open');

	SELECT v_Open_ as `Open`, v_OnHold_ as OnHold,v_UnResolved_ as UnResolved, v_UnAssigned_ as UnAssigned;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getVendorCodeRate`;
DELIMITER //
CREATE PROCEDURE `prc_getVendorCodeRate`(
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_RateCDR` INT


)
BEGIN

		IF p_RateCDR = 0
		THEN

			DROP TEMPORARY TABLE IF EXISTS tmp_vcodes_;
			CREATE TEMPORARY TABLE tmp_vcodes_ (
				RateID INT,
				Code VARCHAR(50),
				INDEX tmp_vcodes_RateID (`RateID`),
				INDEX tmp_vcodes_Code (`Code`)
			);

			INSERT INTO tmp_vcodes_
				SELECT
					DISTINCT
					tblRate.RateID,
					tblRate.Code
				FROM tblRate
					INNER JOIN tblVendorRate
						ON tblVendorRate.RateID = tblRate.RateID
				WHERE
					tblVendorRate.AccountId = p_AccountID
					AND tblVendorRate.TrunkID = p_trunkID
					AND tblVendorRate.EffectiveDate <= NOW();

		END IF;

		IF p_RateCDR = 1
		THEN

			DROP TEMPORARY TABLE IF EXISTS tmp_vcodes_;
			CREATE TEMPORARY TABLE tmp_vcodes_ (
				RateID INT,
				Code VARCHAR(50),
				Rate Decimal(18,6),
				ConnectionFee Decimal(18,6),
				Interval1 INT,
				IntervalN INT,
				INDEX tmp_vcodes_RateID (`RateID`),
				INDEX tmp_vcodes_Code (`Code`)
			);

			INSERT INTO tmp_vcodes_
				SELECT
					DISTINCT
					tblRate.RateID,
					tblRate.Code,
					tblVendorRate.Rate,
					tblVendorRate.ConnectionFee,
					tblVendorRate.Interval1,
					tblVendorRate.IntervalN
				FROM tblRate
					INNER JOIN tblVendorRate
						ON tblVendorRate.RateID = tblRate.RateID
				WHERE
					tblVendorRate.AccountId = p_AccountID
					AND tblVendorRate.TrunkID = p_trunkID
					AND tblVendorRate.EffectiveDate <= NOW()
					AND (tblVendorRate.EndDate IS NULL OR tblVendorRate.EndDate > NOW()) ;

		END IF;
	END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_VendorBulkRateDelete`;
DELIMITER //
CREATE PROCEDURE `prc_VendorBulkRateDelete`(
	IN `p_CompanyId` INT,
	IN `p_AccountId` INT,
	IN `p_TrunkId` INT ,
	IN `p_VendorRateIds` TEXT,
	IN `p_code` varchar(50),
	IN `p_description` varchar(200),
	IN `p_CountryId` INT,
	IN `p_effective` VARCHAR(50),
	IN `p_DeletedBy` TEXT,
	IN `p_action` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_Delete_VendorRate;
	CREATE TEMPORARY TABLE tmp_Delete_VendorRate (
     	VendorRateID INT,
      AccountId INT,
      TrunkID INT,
      RateId INT,
      Code VARCHAR(50),
      Description VARCHAR(200),
      Rate DECIMAL(18, 6),
      EffectiveDate DATETIME,
      EndDate DATETIME,
		Interval1 INT,
		IntervalN INT,
		ConnectionFee DECIMAL(18, 6),
		deleted_at DATETIME,
        INDEX tmp_VendorRateDiscontinued_VendorRateID (`VendorRateID`)
	);

	 IF p_action = 1
	 THEN


	 INSERT INTO tmp_Delete_VendorRate(
	 	VendorRateID,
      AccountId,
      TrunkID,
      RateId,
      Code,
      Description,
      Rate,
      EffectiveDate,
      EndDate,
		Interval1,
		IntervalN,
		ConnectionFee,
		deleted_at
	 )
		SELECT
		  VendorRateID,
		  p_AccountId AS AccountId,
		  p_TrunkId AS TrunkID,
		  v.RateId,
		  r.Code,
		  r.Description,
		  Rate,
		  EffectiveDate,
		  EndDate,
		  v.Interval1,
		  v.IntervalN,
		  ConnectionFee,
		  now() AS deleted_at
		FROM tblVendorRate v
		  INNER JOIN tblRate r
		  		ON r.RateID = v.RateId
		  INNER JOIN tblVendorTrunk vt
		  		ON vt.trunkID = p_TrunkId
				   AND vt.AccountID = p_AccountId
					AND vt.CodeDeckId = r.CodeDeckId
		WHERE
			((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId))
			AND ((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%')))
			AND ((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%')))
		 	AND ((p_effective = 'Now' AND v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' AND v.EffectiveDate> NOW()) OR p_effective = 'All')
		 	AND v.AccountId = p_AccountId
			AND v.TrunkID = p_TrunkId;

	 END IF;

	IF p_action = 2
	THEN




		 INSERT INTO tmp_Delete_VendorRate(
		 	VendorRateID,
	      AccountId,
	      TrunkID,
	      RateId,
	      Code,
	      Description,
	      Rate,
	      EffectiveDate,
	      EndDate,
			Interval1,
			IntervalN,
			ConnectionFee,
			deleted_at
		 )
		SELECT
		  VendorRateID,
		  p_AccountId AS AccountId,
		  p_TrunkId AS TrunkID,
		  v.RateId,
		  r.Code,
		  r.Description,
		  Rate,
		  EffectiveDate,
		  EndDate,
		  v.Interval1,
		  v.IntervalN,
		  ConnectionFee,
		  now() AS deleted_at
		FROM tblVendorRate v
		  INNER JOIN tblRate r
		  		ON r.RateID = v.RateId
		WHERE v.AccountId = p_AccountId
				AND v.TrunkID = p_TrunkId
				AND ((p_VendorRateIds IS NULL) OR FIND_IN_SET(VendorRateID,p_VendorRateIds)!=0)
				;
	END IF;


	-- set end date will remove at bottom in archive proc
	UPDATE tblVendorRate
	JOIN tmp_Delete_VendorRate ON tblVendorRate.VendorRateID = tmp_Delete_VendorRate.VendorRateID
	SET tblVendorRate.EndDate = date(now())
	WHERE
	tblVendorRate.AccountId = p_accountId
	AND tblVendorRate.TrunkId = p_trunkId;


	-- archive rates which has EndDate <= today
	call prc_ArchiveOldVendorRate(p_accountId,p_trunkId,p_DeletedBy);

	-- CALL prc_InsertDiscontinuedVendorRate(p_AccountId,p_TrunkId);


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_VendorBulkRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_VendorBulkRateUpdate`(
	IN `p_AccountId` INT,
	IN `p_TrunkId` INT ,
	IN `p_code` varchar(50),
	IN `p_description` varchar(200),
	IN `p_CountryId` INT,
	IN `p_CompanyId` INT,
	IN `p_Rate` decimal(18,6),
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_ConnectionFee` decimal(18,6),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ModifiedBy` varchar(50),
	IN `p_effective` VARCHAR(50),
	IN `p_action` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF p_action = 1

	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_TempVendorRate_;
	  	CREATE TEMPORARY TABLE tmp_TempVendorRate_ (
			`AccountId` int(11) NOT NULL,
			`TrunkID` int(11) NOT NULL,
			`RateId` int(11) NOT NULL,
			`Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
			`EffectiveDate` datetime NOT NULL,
			`EndDate` datetime DEFAULT NULL,
			`updated_at` datetime DEFAULT NULL,
			`created_at` datetime DEFAULT NULL,
			`created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
			`updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
			`Interval1` int(11) DEFAULT NULL,
			`IntervalN` int(11) DEFAULT NULL,
			`ConnectionFee` decimal(18,6) DEFAULT NULL,
			`MinimumCost` decimal(18,6) DEFAULT NULL
		);
	/*UPDATE tblVendorRate

	INNER JOIN
	(
	SELECT VendorRateID
	  FROM tblVendorRate v
	  INNER JOIN tblRate r ON r.RateID = v.RateId
	  INNER JOIN tblVendorTrunk vt on vt.trunkID = p_TrunkId AND vt.AccountID = p_AccountId AND vt.CodeDeckId = r.CodeDeckId
	 WHERE
	 ((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId))
	 AND ((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%')))
	 AND ((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%')))
	 AND  ((p_effective = 'Now' and v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' and v.EffectiveDate> NOW() ) )
	 AND v.AccountId = p_AccountId AND v.TrunkID = p_TrunkId
	 ) vr
	 ON vr.VendorRateID = tblVendorRate.VendorRateID
	 	SET
		Rate = p_Rate,
		EffectiveDate = p_EffectiveDate,
		Interval1 = p_Interval1,
		IntervalN = p_IntervalN,
		updated_by = p_ModifiedBy,
		ConnectionFee = p_ConnectionFee,
		updated_at = NOW();*/

		INSERT INTO tmp_TempVendorRate_
		SELECT
			v.AccountId,
			v.TrunkID,
			v.RateId,
			p_Rate AS Rate,
			v.EffectiveDate, -- p_EffectiveDate AS EffectiveDate,
			IFNULL(p_EndDate,v.EndDate) AS EndDate,
			NOW() AS updated_at,
			v.created_at,
			v.created_by,
			p_ModifiedBy AS updated_by,
			p_Interval1 AS Interval1,
			p_IntervalN AS IntervalN,
			p_ConnectionFee AS ConnectionFee,
			v.MinimumCost
		FROM
			tblVendorRate v
		INNER JOIN
			tblRate r ON r.RateID = v.RateId
		INNER JOIN
			tblVendorTrunk vt on vt.trunkID = p_TrunkId AND vt.AccountID = p_AccountId AND vt.CodeDeckId = r.CodeDeckId
		WHERE
			((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId)) AND
			((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%'))) AND
			((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%'))) AND
			((p_effective = 'Now' and v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' and v.EffectiveDate> NOW() ) ) AND
			v.AccountId = p_AccountId AND
			v.TrunkID = p_TrunkId;

		UPDATE
			tblVendorRate v
		INNER JOIN
			tblRate r ON r.RateID = v.RateId
		INNER JOIN
			tblVendorTrunk vt on vt.trunkID = p_TrunkId AND vt.AccountID = p_AccountId AND vt.CodeDeckId = r.CodeDeckId
		SET
			v.EndDate = NOW()
		WHERE
			((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId)) AND
			((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%'))) AND
			((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%'))) AND
			((p_effective = 'Now' and v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' and v.EffectiveDate> NOW() ) ) AND
			v.AccountId = p_AccountId AND
			v.TrunkID = p_TrunkId;

		CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId,p_ModifiedBy);

		INSERT INTO tblVendorRate (
			AccountId,
			TrunkID,
			RateId,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			created_at,
			created_by,
			updated_by,
			Interval1,
			IntervalN,
			ConnectionFee,
			MinimumCost
		)
		select
			AccountId,
			TrunkID,
			RateId,
			Rate,
			EffectiveDate,
			EndDate,
			updated_at,
			created_at,
			created_by,
			updated_by,
			Interval1,
			IntervalN,
			ConnectionFee,
			MinimumCost
		from
			tmp_TempVendorRate_;

 	END IF;

	-- CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId,p_ModifiedBy);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_WSCronJobDeleteOldVendorRate`(
	IN `p_DeletedBy` TEXT
)
BEGIN


	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	INSERT INTO tblVendorRateArchive
   SELECT DISTINCT  null , -- Primary Key column
							vr.`VendorRateID`,
							vr.`AccountId`,
							vr.`TrunkID`,
							vr.`RateId`,
							vr.`Rate`,
							vr.`EffectiveDate`,
							IFNULL(vr.`EndDate`,date(now())) as EndDate,
							vr.`updated_at`,
							now() as created_at,
							p_DeletedBy AS `created_by`,
							vr.`updated_by`,
							vr.`Interval1`,
							vr.`IntervalN`,
							vr.`ConnectionFee`,
							vr.`MinimumCost`,
	   concat('Ends Today rates @ ' , now() ) as `Notes`
      FROM tblVendorRate vr
     	INNER JOIN tblAccount a on vr.AccountId = a.AccountID
		WHERE a.Status = 1 AND vr.EndDate <= NOW();


	DELETE  vr
	FROM tblVendorRate vr
   inner join tblVendorRateArchive vra
   on vr.VendorRateID = vra.VendorRateID;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorSippySheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVendorSippySheet`(
	IN `p_VendorID` INT  ,
	IN `p_Trunks` varchar(200),
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		call vwVendorSippySheet(p_VendorID,p_Trunks,p_Effective,p_CustomDate);

		SELECT
			`Action [A|D|U|S|SA`,
			id ,
			vendorRate.Prefix,
			COUNTRY,
			Preference ,
			`Interval 1` ,
			`Interval N` ,
			`Price 1` ,
			`Price N` ,
			`1xx Timeout` ,
			`2xx Timeout` ,
			`Huntstop` ,
			Forbidden ,
			`Activation Date` ,
			`Expiration Date`
		FROM    tmp_VendorSippySheet_ vendorRate
		WHERE   vendorRate.AccountId = p_VendorID
						And  FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0;

		/*

    SELECT
     `Action [A|D|U|S|SA`,
            id ,
            Prefix,
            COUNTRY,
            Preference ,
            `Interval 1` ,
            `Interval N` ,
            `Price 1` ,
            `Price N` ,
            `1xx Timeout` ,
            `2xx Timeout` ,
            `Huntstop` ,
            Forbidden ,
            `Activation Date` ,
            `Expiration Date`
    FROM
    (
      SELECT
       `Action [A|D|U|S|SA`,
              id ,
              vendorRate.Prefix,
              COUNTRY,
              Preference ,
              `Interval 1` ,
              `Interval N` ,
              `Price 1` ,
              `Price N` ,
              `1xx Timeout` ,
              `2xx Timeout` ,
              `Huntstop` ,
              Forbidden ,
              `Activation Date` ,
              `Expiration Date`
      FROM    tmp_VendorSippySheet_ vendorRate

      UNION ALL

      SELECT
       `Action [A|D|U|S|SA`,
              id ,
              vendorRate.Prefix,
              COUNTRY,
              Preference ,
              `Interval 1` ,
              `Interval N` ,
              `Price 1` ,
              `Price N` ,
              `1xx Timeout` ,
              `2xx Timeout` ,
              `Huntstop` ,
              Forbidden ,
              `Activation Date` ,
              `Expiration Date`
      FROM    tmp_VendorArhiveSippySheet_ vendorRate
  ) tmp;

    -- WHERE   vendorRate.AccountId = p_VendorID
    -- And  FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0;

    */

		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSGenerateVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVersion3VosSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` varchar(200) ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE,
	IN `p_Format` VARCHAR(50)
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_Effective,p_CustomDate);

	IF p_Effective = 'Now' OR p_Format = 'Vos 2.0'
	THEN

		SELECT distinct
			IFNULL(RatePrefix, '') as `Rate Prefix` ,
			Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
			'International' as `Rate Type` ,
			Description  as `Area Name`,
			Rate / 60  as `Billing Rate`,
			IntervalN as `Billing Cycle`,
			Rate as `Minute Cost` ,
			'No Lock'  as `Lock Type`,
			CASE WHEN Interval1 != IntervalN
			THEN
				Concat('0,', Rate, ',',Interval1)
			ELSE
				''
			END as `Section Rate`,
			0 AS `Billing Rate for Calling Card Prompt`,
			0  as `Billing Cycle for Calling Card Prompt`
		FROM   tmp_customerrateall_
		ORDER BY `Rate Prefix`;

	END IF;

	IF (p_Effective = 'Future' OR  p_Effective = 'All' OR p_Effective = 'CustomDate') AND p_Format = 'Vos 3.2'
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_2_ ;
		CREATE TEMPORARY TABLE tmp_customerrateall_2_ SELECT * FROM tmp_customerrateall_;

		SELECT
			`Time of timing replace`,
			`Mode of timing replace`,
			`Rate Prefix` ,
			`Area Prefix` ,
			`Rate Type` ,
			`Area Name` ,
			`Billing Rate` ,
			`Billing Cycle`,
			`Minute Cost` ,
			`Lock Type` ,
			`Section Rate` ,
			`Billing Rate for Calling Card Prompt` ,
			`Billing Cycle for Calling Card Prompt`
		FROM
		(
			SELECT distinct
				CONCAT(EffectiveDate,' 00:00') as `Time of timing replace`,
				'Append replace' as `Mode of timing replace`,
				IFNULL(RatePrefix, '') as `Rate Prefix` ,
				Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
				'International' as `Rate Type` ,
				Description  as `Area Name`,
				Rate / 60  as `Billing Rate`,
				IntervalN as `Billing Cycle`,
				Rate as `Minute Cost` ,
				'No Lock'  as `Lock Type`,
				CASE WHEN Interval1 != IntervalN
				THEN
					Concat('0,', Rate, ',',Interval1)
				ELSE
					''
				END as `Section Rate`,
				0 AS `Billing Rate for Calling Card Prompt`,
				0  as `Billing Cycle for Calling Card Prompt`
			FROM   tmp_customerrateall_2_
			-- ORDER BY `Rate Prefix`;

			UNION ALL

			SELECT distinct
				CONCAT(EffectiveDate,' 00:00') as `Time of timing replace`,
				'Delete' as `Mode of timing replace`,
				IFNULL(RatePrefix, '') as `Rate Prefix` ,
				Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
				'International' as `Rate Type` ,
				Description  as `Area Name`,
				Rate / 60  as `Billing Rate`,
				IntervalN as `Billing Cycle`,
				Rate as `Minute Cost` ,
				'No Lock'  as `Lock Type`,
				CASE WHEN Interval1 != IntervalN
				THEN
					Concat('0,', Rate, ',',Interval1)
				ELSE
					''
				END as `Section Rate`,
				0 AS `Billing Rate for Calling Card Prompt`,
				0  as `Billing Cycle for Calling Card Prompt`
			FROM   tmp_customerrateall_
			WHERE  EndDate IS NOT NULL

			UNION ALL

			SELECT distinct
				CONCAT(EffectiveDate,' 00:00') as `Time of timing replace`,
				'Delete' as `Mode of timing replace`,
				IFNULL(RatePrefix, '') as `Rate Prefix` ,
				Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
				'International' as `Rate Type` ,
				Description  as `Area Name`,
				Rate / 60  as `Billing Rate`,
				IntervalN as `Billing Cycle`,
				Rate as `Minute Cost` ,
				'No Lock'  as `Lock Type`,
				CASE WHEN Interval1 != IntervalN
				THEN
					Concat('0,', Rate, ',',Interval1)
				ELSE
					''
				END as `Section Rate`,
				0 AS `Billing Rate for Calling Card Prompt`,
				0  as `Billing Cycle for Calling Card Prompt`
			FROM   tmp_customerrateall_archive_
		) tmp
		ORDER BY `Rate Prefix`;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_WSProcessCodeDeck`;
DELIMITER //
CREATE PROCEDURE `prc_WSProcessCodeDeck`(
	IN `p_processId` VARCHAR(200),
	IN `p_companyId` INT
)
BEGIN

    DECLARE v_AffectedRecords_ INT DEFAULT 0;
    DECLARE   v_CodeDeckId_ INT;
    DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
	 DECLARE countrycount INT DEFAULT 0;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  (
        Message longtext
    );

    SELECT CodeDeckId INTO v_CodeDeckId_ FROM tblTempCodeDeck WHERE ProcessId = p_processId AND CompanyId = p_companyId LIMIT 1;

    DELETE n1
	 FROM tblTempCodeDeck n1
	 INNER JOIN (
	 	SELECT MAX(TempCodeDeckRateID) as TempCodeDeckRateID,Code FROM tblTempCodeDeck WHERE ProcessId = p_processId
		GROUP BY Code
		HAVING COUNT(*)>1
	) n2
	 	ON n1.Code = n2.Code AND n1.TempCodeDeckRateID < n2.TempCodeDeckRateID
	WHERE n1.ProcessId = p_processId;


	 SELECT COUNT(*) INTO countrycount FROM tblTempCodeDeck WHERE ProcessId = p_processId AND Country !='';


    UPDATE tblTempCodeDeck
    SET
        tblTempCodeDeck.Interval1 = CASE WHEN tblTempCodeDeck.Interval1 is not null  and tblTempCodeDeck.Interval1 > 0
                                    THEN
                                        tblTempCodeDeck.Interval1
                                    ELSE
                                    	1
                                    END,
        tblTempCodeDeck.IntervalN = CASE WHEN tblTempCodeDeck.IntervalN is not null  and tblTempCodeDeck.IntervalN > 0
                                    THEN
                                        tblTempCodeDeck.IntervalN
                                    ELSE
                                        1
                                    END
    WHERE tblTempCodeDeck.ProcessId = p_processId;

    UPDATE tblTempCodeDeck t
	    SET t.CountryId = fnGetCountryIdByCodeAndCountry (t.Code ,t.Country)
	 WHERE t.ProcessId = p_processId ;

   IF countrycount > 0
   THEN
	  	UPDATE tblTempCodeDeck t
		    SET t.CountryId = fnGetCountryIdByCodeAndCountry (t.Code ,t.Description)
		 WHERE t.ProcessId = p_processId AND  t.CountryId IS NULL;
	END IF;

 IF ( SELECT COUNT(*)
                 FROM   tblTempCodeDeck
                 WHERE  tblTempCodeDeck.ProcessId = p_processId
                        AND tblTempCodeDeck.Action = 'D'
               ) > 0
            THEN
      DELETE  tblRate
            FROM    tblRate
                    INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
                                                  AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
                    LEFT OUTER JOIN tblCustomerRate ON tblRate.RateID = tblCustomerRate.RateID
                    LEFT OUTER JOIN tblRateTableRate ON tblRate.RateID = tblRateTableRate.RateID
                    LEFT OUTER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId
            WHERE   tblTempCodeDeck.Action = 'D'
          AND tblTempCodeDeck.CompanyID = p_companyId
          AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_
          AND tblTempCodeDeck.ProcessId = p_processId
                    AND tblCustomerRate.CustomerRateID IS NULL
                    AND tblRateTableRate.RateTableRateID IS NULL
                    AND tblVendorRate.VendorRateID IS NULL ;
		END IF;
      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();


  		SELECT GROUP_CONCAT(Code) into errormessage FROM(
	      SELECT distinct tblRate.Code as Code,1 as a
	      FROM    tblRate
	                    INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
	      	    AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
	          WHERE   tblTempCodeDeck.Action = 'D'
	          AND tblTempCodeDeck.ProcessId = p_processId
	          AND tblTempCodeDeck.CompanyID = p_companyId AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_)as tbl GROUP BY a;

	   IF errormessage IS NOT NULL
          THEN
                    INSERT INTO tmp_JobLog_ (Message)
                    SELECT distinct
						  CONCAT(tblRate.Code , ' FAILED TO DELETE - CODE IS IN USE')
					      FROM   tblRate
					              INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
					      	    AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
					          WHERE   tblTempCodeDeck.Action = 'D'
					          AND tblTempCodeDeck.ProcessId = p_processId
					          AND tblTempCodeDeck.CompanyID = p_companyId AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_;
	 	END IF;

      UPDATE  tblRate
      JOIN tblTempCodeDeck ON tblRate.Code = tblTempCodeDeck.Code
            AND tblTempCodeDeck.ProcessId = p_processId
            AND tblRate.CompanyID = p_companyId
            AND tblRate.CodeDeckId = v_CodeDeckId_
            AND tblTempCodeDeck.Action != 'D'
		SET   tblRate.Description = tblTempCodeDeck.Description,
            tblRate.Interval1 = tblTempCodeDeck.Interval1,
            tblRate.IntervalN = tblTempCodeDeck.IntervalN;

  		IF countrycount > 0
  		THEN

	  		UPDATE  tblRate
	      JOIN tblTempCodeDeck ON tblRate.Code = tblTempCodeDeck.Code
	            AND tblTempCodeDeck.ProcessId = p_processId
	            AND tblRate.CompanyID = p_companyId
	            AND tblRate.CodeDeckId = v_CodeDeckId_
	            AND tblTempCodeDeck.Action != 'D'
			SET   tblRate.CountryID = tblTempCodeDeck.CountryId;

		END IF;

      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

            INSERT  INTO tblRate
                    ( CountryID ,
                      CompanyID ,
                      CodeDeckId,
                      Code ,
                      Description,
                      Interval1,
                      IntervalN
                    )
                    SELECT  DISTINCT
              tblTempCodeDeck.CountryId ,
                            tblTempCodeDeck.CompanyId ,
                            tblTempCodeDeck.CodeDeckId,
                            tblTempCodeDeck.Code ,
                            tblTempCodeDeck.Description,
                            tblTempCodeDeck.Interval1,
                            tblTempCodeDeck.IntervalN
                    FROM    tblTempCodeDeck left join tblRate on(tblRate.CompanyID = p_companyId AND  tblRate.CodeDeckId = v_CodeDeckId_ AND tblTempCodeDeck.Code=tblRate.Code)
                    WHERE  tblRate.RateID is null
                            AND tblTempCodeDeck.ProcessId = p_processId
              AND tblTempCodeDeck.CompanyID = p_companyId
              AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_
                            AND tblTempCodeDeck.Action != 'D';

      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	 INSERT INTO tmp_JobLog_ (Message)
	 SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );

	DELETE  FROM tblTempCodeDeck WHERE   tblTempCodeDeck.ProcessId = p_processId;
 	 SELECT * from tmp_JobLog_;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT * from tmp_JobLog_ limit 0 , 20;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `vwVendorCurrentRates`;
DELIMITER //
CREATE PROCEDURE `vwVendorCurrentRates`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
		AccountId int,
		Code varchar(50),
		Description varchar(200),
		Rate float,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Interval1 INT,
		IntervalN varchar(100),
		ConnectionFee float,
		EndDate date
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
	 	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        EndDate date,
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee` , tblVendorRate.EndDate
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_Trunks) != 0
                        AND
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW() AND (EndDate IS NULL OR EndDate > NOW() ))
								  	OR
								  	(p_Effective = 'Future' AND EffectiveDate > NOW() AND ( EndDate IS NULL OR EndDate > NOW() ))
								  	OR
								  	(p_Effective = 'CustomDate' AND EffectiveDate <= p_CustomDate AND (EndDate IS NULL OR EndDate > p_CustomDate))
								  	OR
								  	(p_Effective = 'All'  )
								);

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);
      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
		AND
	   (
			(p_Effective = 'CustomDate' AND n1.EffectiveDate <= p_CustomDate AND n2.EffectiveDate <= p_CustomDate)
		  	OR
		  	(p_Effective != 'CustomDate' AND n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW())
		);


    INSERT INTO tmp_VendorCurrentRates_
    SELECT DISTINCT
    p_AccountID,
    r.Code,
    r.Description,
    v_1.Rate,
    DATE_FORMAT (v_1.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
    v_1.TrunkID,
    r.CountryID,
    r.RateID,
   	CASE WHEN v_1.Interval1 is not null
   		THEN v_1.Interval1
    	ELSE r.Interval1
    END as  Interval1,
    CASE WHEN v_1.IntervalN is not null
    	THEN v_1.IntervalN
        ELSE r.IntervalN
    END IntervalN,
    v_1.ConnectionFee,
    v_1.EndDate
    FROM tmp_VendorRate_ AS v_1
	INNER JOIN tblRate AS r
    	ON r.RateID = v_1.RateId;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `vwVendorVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `vwVendorVersion3VosSheet`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN



	DROP TEMPORARY TABLE IF EXISTS tmp_VendorVersion3VosSheet_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorVersion3VosSheet_(
			RateID int,
			`Rate Prefix` varchar(50),
			`Area Prefix` varchar(50),
			`Rate Type` varchar(50),
			`Area Name` varchar(200),
			`Billing Rate` float,
			`Billing Cycle` int,
			`Minute Cost` float,
			`Lock Type` varchar(50),
			`Section Rate` varchar(50),
			`Billing Rate for Calling Card Prompt` float,
			`Billing Cycle for Calling Card Prompt` INT,
			AccountID int,
			TrunkID int,
			EffectiveDate date,
			EndDate date
	);


	DROP TEMPORARY TABLE IF EXISTS tmp_VendorArhiveVersion3VosSheet_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorArhiveVersion3VosSheet_(
			RateID int,
			`Rate Prefix` varchar(50),
			`Area Prefix` varchar(50),
			`Rate Type` varchar(50),
			`Area Name` varchar(200),
			`Billing Rate` float,
			`Billing Cycle` int,
			`Minute Cost` float,
			`Lock Type` varchar(50),
			`Section Rate` varchar(50),
			`Billing Rate for Calling Card Prompt` float,
			`Billing Cycle for Calling Card Prompt` INT,
			AccountID int,
			TrunkID int,
			EffectiveDate date,
			EndDate date
	);


	 Call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective,p_CustomDate);


INSERT INTO tmp_VendorVersion3VosSheet_
SELECT


    NULL AS RateID,
    IFNULL(tblTrunk.RatePrefix, '') AS `Rate Prefix`,
    Concat('' , IFNULL(tblTrunk.AreaPrefix, '') , vendorRate.Code) AS `Area Prefix`,
    'International' AS `Rate Type`,
    vendorRate.Description AS `Area Name`,
    vendorRate.Rate / 60 AS `Billing Rate`,
    vendorRate.IntervalN AS `Billing Cycle`,
    CAST(vendorRate.Rate AS DECIMAL(18, 5)) AS `Minute Cost`,
    CASE
        WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND
        FIND_IN_SET(vendorRate.TrunkId,tblVendorBlocking.TrunkId) != 0
             OR
            (blockCountry.VendorBlockingId IS NOT NULL AND
             FIND_IN_SET(vendorRate.TrunkId,blockCountry.TrunkId) != 0
            )) THEN 'No Lock'
        ELSE 'No Lock'
    END
    AS `Lock Type`,
        CASE WHEN vendorRate.Interval1 != vendorRate.IntervalN
                                      THEN
                    Concat('0,', vendorRate.Rate, ',',vendorRate.Interval1)
                                      ELSE ''
                                 END as `Section Rate`,
    0 AS `Billing Rate for Calling Card Prompt`,
    0 AS `Billing Cycle for Calling Card Prompt`,
    tblAccount.AccountID,
    vendorRate.TrunkId,
    vendorRate.EffectiveDate,
    vendorRate.EndDate
FROM tmp_VendorCurrentRates_ AS vendorRate
INNER JOIN tblAccount
    ON vendorRate.AccountId = tblAccount.AccountID
LEFT OUTER JOIN tblVendorBlocking
    ON vendorRate.TrunkId = tblVendorBlocking.TrunkID
    AND vendorRate.RateID = tblVendorBlocking.RateId
    AND tblAccount.AccountID = tblVendorBlocking.AccountId
LEFT OUTER JOIN tblVendorBlocking AS blockCountry
    ON vendorRate.TrunkId = blockCountry.TrunkID
    AND vendorRate.CountryID = blockCountry.CountryId
    AND tblAccount.AccountID = blockCountry.AccountId
INNER JOIN tblTrunk
    ON tblTrunk.TrunkID = vendorRate.TrunkId
WHERE (vendorRate.Rate > 0);


	 -- for archive rates
	 IF p_Effective != 'Now' THEN

		 	call vwVendorArchiveCurrentRates(p_AccountID,p_Trunks,p_Effective);

			INSERT INTO tmp_VendorArhiveVersion3VosSheet_
			SELECT


			    NULL AS RateID,
			    IFNULL(tblTrunk.RatePrefix, '') AS `Rate Prefix`,
			    Concat('' , IFNULL(tblTrunk.AreaPrefix, '') , vendorArchiveRate.Code) AS `Area Prefix`,
			    'International' AS `Rate Type`,
			    vendorArchiveRate.Description AS `Area Name`,
			    vendorArchiveRate.Rate / 60 AS `Billing Rate`,
			    vendorArchiveRate.IntervalN AS `Billing Cycle`,
			    CAST(vendorArchiveRate.Rate AS DECIMAL(18, 5)) AS `Minute Cost`,
			    'No Lock'   AS `Lock Type`,
			     CASE WHEN vendorArchiveRate.Interval1 != vendorArchiveRate.IntervalN THEN
				           Concat('0,', vendorArchiveRate.Rate, ',',vendorArchiveRate.Interval1)
			   	ELSE ''
			    END as `Section Rate`,
			    0 AS `Billing Rate for Calling Card Prompt`,
			    0 AS `Billing Cycle for Calling Card Prompt`,
			    tblAccount.AccountID,
			    vendorArchiveRate.TrunkId,
			    vendorArchiveRate.EffectiveDate,
			    vendorArchiveRate.EndDate
			FROM tmp_VendorArchiveCurrentRates_ AS vendorArchiveRate
			Left join tmp_VendorVersion3VosSheet_ vendorRate
				 ON vendorArchiveRate.AccountId = vendorRate.AccountID
				 AND vendorArchiveRate.AccountId = vendorRate.TrunkID
 				 AND vendorArchiveRate.RateID = vendorRate.RateID

			INNER JOIN tblAccount
			    ON vendorArchiveRate.AccountId = tblAccount.AccountID
			INNER JOIN tblTrunk
			    ON tblTrunk.TrunkID = vendorArchiveRate.TrunkId
			WHERE vendorRate.RateID is Null AND -- remove all archive rates which are exists in VendorRate
			(vendorArchiveRate.Rate > 0);

	 END IF;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGeneratePortaSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
    
	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_Effective,p_CustomDate);
        
	 SELECT distinct 
       Code as `Destination` ,
       Description  as `Description`,
       Interval1 as `First Interval`,
       IntervalN as `Next Interval`,
       Abs(Rate) as `First Price` ,
       Abs(Rate) as `Next Price`,
       DATE_FORMAT(EffectiveDate ,'%d/%m/%Y') as  `Effective From`,
       CASE WHEN Rate < 0 THEN 'Y' ELSE '' END  `Payback Rate` ,
		 CASE WHEN ConnectionFee > 0 THEN
			CONCAT('SEQ=', ConnectionFee,'&int1x1@price1&intNxN@priceN')
		 ELSE
			''
		 END as `Formula`
     FROM tmp_customerrateall_;
	 
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;



USE `RMBilling3`;

set sql_mode='';

ALTER TABLE `tblAccountSubscription`
	ADD COLUMN `Status` TINYINT(3) NULL DEFAULT '1' AFTER `ServiceID`;

CREATE TABLE IF NOT EXISTS `tblInvoiceHistory` (
  `InvoiceHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `InvoiceID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `BillingType` tinyint(3) unsigned DEFAULT NULL,
  `BillingTimezone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleValue` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingStartDate` date DEFAULT NULL,
  `LastInvoiceDate` date DEFAULT NULL,
  `NextInvoiceDate` date DEFAULT NULL,
  `LastChargeDate` date DEFAULT NULL,
  `NextChargeDate` date DEFAULT NULL,
  `ServiceID` int(11) DEFAULT '0',
  `IssueDate` date DEFAULT NULL,
  `FirstInvoice` int(11) DEFAULT '0',
  PRIMARY KEY (`InvoiceHistoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;	


ALTER TABLE `tblInvoiceDetail`
	CHANGE COLUMN `Qty` `Qty` FLOAT NULL DEFAULT NULL AFTER `Price`;
	
DROP PROCEDURE IF EXISTS `fnServiceUsageDetail`;
DELIMITER //
CREATE PROCEDURE `fnServiceUsageDetail`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_ServiceID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_billing_time` INT


)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetails_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetails_(
			AccountID int,
			ServiceID int,
			AccountName varchar(100),
			GatewayAccountID varchar(100),
			trunk varchar(50),
			area_prefix varchar(50),
			pincode VARCHAR(50),
			extension VARCHAR(50),
			UsageDetailID int,
			duration int,
			billed_duration int,
			billed_second int,
			cli varchar(500),
			cld varchar(500),
			cost decimal(18,6),
			connect_time datetime,
			disconnect_time datetime,
			is_inbound tinyint(1) default 0,
			ID INT
	);
	INSERT INTO tmp_tblUsageDetails_
	SELECT
	*
	FROM (
		SELECT
			uh.AccountID,
			uh.ServiceID,
			a.AccountName,
			uh.GatewayAccountID,
			trunk,
			area_prefix,
			pincode,
			extension,
			UsageDetailID,
			duration,
			billed_duration,
			billed_second,
			cli,
			cld,
			cost,
			connect_time,
			disconnect_time,
			ud.is_inbound,
			ud.ID
		FROM RMCDR3.tblUsageDetails  ud
		INNER JOIN RMCDR3.tblUsageHeader uh
			ON uh.UsageHeaderID = ud.UsageHeaderID
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		LEFT JOIN Ratemanagement3.tblAccountBilling ab
			ON ab.AccountID = a.AccountID AND ab.ServiceID = uh.ServiceID
		WHERE  StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
			AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
			AND uh.CompanyID = p_CompanyID
			AND uh.AccountID is not null
			AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
			AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
			AND ( (p_ServiceID = 0 AND ab.ServiceID IS NULL) OR  ab.ServiceID = p_ServiceID)
	) tbl
	WHERE 
	( (p_billing_time =1 OR p_billing_time =3) and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate);
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `fnUsageDetail`;
DELIMITER //
CREATE PROCEDURE `fnUsageDetail`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_billing_time` INT,
	IN `p_cdr_type` VARCHAR(50),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT


)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetails_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetails_(
		AccountID int,
		AccountName varchar(100),
		GatewayAccountID varchar(100),
		trunk varchar(50),
		area_prefix varchar(50),
		pincode VARCHAR(50),
		extension VARCHAR(50),
		UsageDetailID int,
		duration int,
		billed_duration int,
		billed_second int,
		cli varchar(500),
		cld varchar(500),
		cost decimal(18,6),
		connect_time datetime,
		disconnect_time datetime,
		is_inbound tinyint(1) default 0,
		ID INT,
		ServiceID INT
	);
	INSERT INTO tmp_tblUsageDetails_
	SELECT
	*
	FROM (
		SELECT
			uh.AccountID,
			a.AccountName,
			uh.GatewayAccountID,
			trunk,
			area_prefix,
			pincode,
			extension,
			UsageDetailID,
			duration,
			billed_duration,
			billed_second,
			cli,
			cld,
			cost,
			connect_time,
			disconnect_time,
			ud.is_inbound,
			ud.ID,
			uh.ServiceID
		FROM RMCDR3.tblUsageDetails  ud
		INNER JOIN RMCDR3.tblUsageHeader uh
			ON uh.UsageHeaderID = ud.UsageHeaderID
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE
		(p_cdr_type = '' OR  ud.userfield LIKE CONCAT('%',p_cdr_type,'%'))
		AND  StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
		AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
		AND a.CompanyId = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))
		AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
		AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))
	) tbl
	WHERE
	( (p_billing_time =1 OR p_billing_time =3) AND connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR
	(p_billing_time =2 AND disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	
	
	AND billed_duration > 0
	ORDER BY disconnect_time DESC;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `fnVendorUsageDetail`;
DELIMITER //
CREATE PROCEDURE `fnVendorUsageDetail`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_billing_time` INT,
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_ZeroValueBuyingCost` INT

)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorUsageDetails_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblVendorUsageDetails_(
		AccountID INT,
		AccountName VARCHAR(50),
		trunk VARCHAR(50),
		area_prefix VARCHAR(50),
		VendorCDRID INT,
		billed_duration INT,
		cli VARCHAR(500),
		cld VARCHAR(500),
		selling_cost DECIMAL(18,6),
		buying_cost DECIMAL(18,6),
		connect_time DATETIME,
		disconnect_time DATETIME
	);
	INSERT INTO tmp_tblVendorUsageDetails_
	SELECT
	*
	FROM (
		SELECT
			uh.AccountID,
			a.AccountName,
			trunk,
			area_prefix,
			VendorCDRID,
			billed_duration,
			cli,
			cld,
			selling_cost,
			buying_cost,
			connect_time,
			disconnect_time
		FROM RMCDR3.tblVendorCDR  ud
		INNER JOIN RMCDR3.tblVendorCDRHeader uh
			ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
		AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
		AND uh.CompanyID = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))
		AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
		AND (p_ZeroValueBuyingCost = 0 OR ( p_ZeroValueBuyingCost = 1 AND buying_cost = 0) OR ( p_ZeroValueBuyingCost = 2 AND buying_cost > 0))
	) tbl
	WHERE 
	( ( p_billing_time =1 OR p_billing_time =3 )  AND connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 AND disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	AND billed_duration > 0
	ORDER BY disconnect_time DESC;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ApplyAuthRule`;
DELIMITER //
CREATE PROCEDURE `prc_ApplyAuthRule`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_ServiceID` INT
)
BEGIN
	DECLARE p_NameFormat VARCHAR(10);
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ;

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_AuthenticateRules_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET p_NameFormat = ( SELECT AuthRule FROM tmp_AuthenticateRules_  WHERE RowNo = v_pointer_ );

		IF  p_NameFormat = 'NAMENUB'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				ga.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON CONCAT(a.AccountName , '-' , a.Number) = ga.AccountName
				-- AND ga.CompanyID = a.CompanyId 				
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
		--	AND a.CompanyId = p_CompanyID
			AND a.Status = 1
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.ServiceID = p_ServiceID
			AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NAMENUB' OR aa.VendorAuthRule ='NAMENUB' )) OR
              aa.AccountID IS NULL
          );
	
		END IF;
	
		IF p_NameFormat = 'NUBNAME'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				ga.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON CONCAT(a.Number, '-' , a.AccountName) = ga.AccountName 
				-- AND ga.CompanyID = a.CompanyId
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
		--	AND a.CompanyId = p_CompanyID
			AND a.Status = 1
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.ServiceID = p_ServiceID
			AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NUBNAME' OR aa.VendorAuthRule ='NUBNAME' )) OR
              aa.AccountID IS NULL
          );
	
		END IF;
	
		IF p_NameFormat = 'NUB'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				ga.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON a.Number = ga.AccountNumber 
				-- AND ga.CompanyID = a.CompanyId
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID	
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			-- AND a.CompanyId = p_CompanyID
			AND a.Status = 1
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.ServiceID = p_ServiceID
			AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NUB' OR aa.VendorAuthRule ='NUB' )) OR
              aa.AccountID IS NULL
          );
	
		END IF;
	
		IF p_NameFormat = 'IP'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				aa.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'IP' OR aa.VendorAuthRule ='IP')
			INNER JOIN tblGatewayAccount ga
				ON  ga.ServiceID = p_ServiceID
				-- AND ga.CompanyID = a.CompanyId 
				AND aa.ServiceID = ga.ServiceID 
				AND ( (aa.CustomerAuthRule = 'IP' AND FIND_IN_SET(ga.AccountIP,aa.CustomerAuthValue) != 0) OR (aa.VendorAuthRule ='IP' AND FIND_IN_SET(ga.AccountIP,aa.VendorAuthValue) != 0) )
			WHERE a.`Status` = 1
			-- AND a.CompanyId = p_CompanyID 			 			
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID;
	
		END IF;
	
		IF p_NameFormat = 'CLI'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				aa.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.ServiceID = p_ServiceID
				-- AND ga.CompanyID = a.CompanyId 				 				
			INNER JOIN Ratemanagement3.tblCLIRateTable aa
				ON a.AccountID = aa.AccountID
				AND aa.ServiceID = ga.ServiceID 
				AND ga.AccountCLI = aa.CLI
			WHERE a.`Status` = 1
			-- AND a.CompanyId = p_CompanyID			 			
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID;
	
		END IF;
	
		IF p_NameFormat = '' OR p_NameFormat IS NULL OR p_NameFormat = 'NAME'
		THEN
	
			-- IF sippy add sippy gateway too
			select count(*) into @IsSippy from Ratemanagement3.tblGateway g inner join Ratemanagement3.tblCompanyGateway cg
			on cg.GatewayID = g.GatewayID
			AND cg.`Status` = 1
			AND cg.CompanyGatewayID = p_CompanyGatewayID
			AND g.Name = 'SippySFTP';

			IF (@IsSippy > 0 ) THEN

		
					INSERT INTO tmp_ActiveAccount
					SELECT DISTINCT
						ga.AccountName,
						ga.AccountNumber,
						ga.AccountCLI,
						ga.AccountIP,
						sa.AccountID,
						ga.ServiceID,
						a.CompanyId
					FROM Ratemanagement3.tblAccount  a
					LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa
						ON a.AccountID = aa.AccountID 
					INNER JOIN tblGatewayAccount ga
						ON aa.ServiceID = ga.ServiceID  
					--	AND  ga.CompanyID = a.CompanyId
					--	AND a.AccountName = ga.AccountName -- already comment by someone
					INNER JOIN Ratemanagement3.tblAccountSippy sa
						ON ( (a.IsCustomer = 1	AND ga.AccountNumber = sa.i_account)	OR	( a.IsVendor = 1	AND ga.AccountNumber = sa.i_vendor ) )
						-- sa.CompanyID = a.CompanyId AND						 	
					WHERE a.`Status` = 1 
					-- AND a.CompanyId = p_CompanyID			
					AND ga.ServiceID = p_ServiceID 
					AND GatewayAccountID IS NOT NULL
					AND ga.AccountID IS NULL
					AND ga.CompanyGatewayID = p_CompanyGatewayID
					AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NAME' OR aa.VendorAuthRule ='NAME' )) OR
		              aa.AccountID IS NULL
		          );
		 
			ELSE 
			
			
					INSERT INTO tmp_ActiveAccount
					SELECT DISTINCT
						ga.AccountName,
						ga.AccountNumber,
						ga.AccountCLI,
						ga.AccountIP,
						a.AccountID,
						ga.ServiceID,
						a.CompanyId
					FROM Ratemanagement3.tblAccount  a
					INNER JOIN tblGatewayAccount ga
						ON a.AccountName = ga.AccountName  
						-- AND ga.CompanyID = a.CompanyId
					LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa
						ON a.AccountID = aa.AccountID 
						AND aa.ServiceID = ga.ServiceID 
					WHERE a.`Status` = 1 
					-- AND a.CompanyId = p_CompanyID			
					AND ga.ServiceID = p_ServiceID 
					AND GatewayAccountID IS NOT NULL
					AND ga.AccountID IS NULL
					AND ga.CompanyGatewayID = p_CompanyGatewayID
					AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NAME' OR aa.VendorAuthRule ='NAME' )) OR
		              aa.AccountID IS NULL
		          );
			
				
			END IF;
	 
	
		END IF;
		
		IF p_NameFormat = 'Other'
		THEN
	
			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				ga.AccountName,
				ga.AccountNumber,
				ga.AccountCLI,
				ga.AccountIP,
				a.AccountID,
				aa.ServiceID,
				a.CompanyId
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'Other' OR aa.VendorAuthRule ='Other')
			INNER JOIN tblGatewayAccount ga
				 ON ga.ServiceID = aa.ServiceID 
				--  ga.CompanyID = a.CompanyId AND
				AND ( (aa.VendorAuthRule ='Other' AND aa.VendorAuthValue = ga.AccountName) OR (aa.CustomerAuthRule = 'Other' AND aa.CustomerAuthValue = ga.AccountName) )
			WHERE a.`Status` = 1 
			-- AND a.CompanyId = p_CompanyID			
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.ServiceID = p_ServiceID;
	
		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CreateRerateLog`;
DELIMITER //
CREATE PROCEDURE `prc_CreateRerateLog`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT
)
BEGIN
	DECLARE v_CustomerIDs_ TEXT DEFAULT '';
	DECLARE v_CustomerIDs_Count_ INT DEFAULT 0;

	SELECT GROUP_CONCAT(AccountID) INTO v_CustomerIDs_ FROM tmp_Customers_ GROUP BY CompanyGatewayID;
	SELECT COUNT(*) INTO v_CustomerIDs_Count_ FROM tmp_Customers_;

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
			SELECT DISTINCT a.CompanyId,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Service: ",IFNULL(s.ServiceName,"")," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
			FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
			INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
			LEFT JOIN Ratemanagement3.tblService s on  s.ServiceID = ud.ServiceID
			WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0');

			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

		ELSE

			SET @stm = CONCAT('
			INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
			SELECT DISTINCT a.CompanyId,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
			FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
			INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
			WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 ');

			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

		END IF;

		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT a.CompanyId,ud.CompanyGatewayID,3,  CONCAT( "Account:  " , a.AccountName ,  " - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 1 AND ud.is_rerated = 0 AND ud.billed_second <> 0 ');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @stm = CONCAT('
		INSERT INTO Ratemanagement3.tblTempRateLog (CompanyID,CompanyGatewayID,MessageType,Message,RateDate,SentStatus,created_at)
		SELECT rt.CompanyID,rt.CompanyGatewayID,rt.MessageType,rt.Message,rt.RateDate,0 as SentStatus,NOW() as created_at FROM tmp_tblTempRateLog_ rt
		LEFT JOIN Ratemanagement3.tblTempRateLog rt2
			ON rt.CompanyGatewayID = rt2.CompanyGatewayID
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

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_CustomerPanel_getInvoice`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerPanel_getInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_InvoiceType` INT,
	IN `p_IsOverdue` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT,
	IN `p_zerovalueinvoice` INT


)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_TotalCount int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET  sql_mode='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT DISTINCT cr.Symbol INTO v_CurrencyCode_ from Ratemanagement3.tblCurrency cr INNER JOIN tblInvoice inv where  inv.CurrencyID   = cr.CurrencyId  and inv.AccountID=p_AccountID;

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
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID LIMIT 1) as PaymentDueInDays,
			(SELECT PaymentDate FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID ORDER BY PaymentID DESC LIMIT 1) AS PaymentDate,
			inv.SubTotal,
			inv.TotalTax,
			ac.NominalAnalysisNominalAccountNumber
			FROM tblInvoice inv
			INNER JOIN Ratemanagement3.tblAccount ac on ac.AccountID = inv.AccountID
			LEFT JOIN tblInvoiceDetail invd on invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
			LEFT JOIN Ratemanagement3.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
			WHERE ac.CompanyID = p_CompanyID
					AND (inv.AccountID = p_AccountID)
					AND ( (IFNULL(inv.InvoiceStatus,'') = '') OR  inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting'))
					AND (p_InvoiceNumber = '' OR ( p_InvoiceNumber != '' AND inv.InvoiceNumber = p_InvoiceNumber))
					AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
					AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
					AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
					AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal > 0));
				
	IF p_isExport = 0
	THEN	
		SELECT 
			InvoiceType ,
			AccountName,
			InvoiceNumber,
			IssueDate,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
			InvoiceStatus,
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
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN GrandTotal
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN GrandTotal
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDDESC') THEN InvoiceID
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDASC') THEN InvoiceID
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;


		SELECT COUNT(*) into v_TotalCount FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
							OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
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
		WHERE (p_IsOverdue = 0 
							OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
									AND(PendingAmount>0)
								)
						);
	END IF;
	IF p_isExport = 1
	THEN
		SELECT
			AccountName,
			InvoiceNumber,
			IssueDate,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
			InvoiceStatus,
			InvoiceType,
			ItemInvoice
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
						OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
								AND(PendingAmount>0)
							)
					);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_DeleteCDR`;
DELIMITER //
CREATE PROCEDURE `prc_DeleteCDR`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CDRType` VARCHAR(50),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_ResellerID` INT
)
BEGIN

	DECLARE v_BillingTime_ int;
	DECLARE v_raccountids TEXT;
	SET v_raccountids = '';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM Ratemanagement3.tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM Ratemanagement3.tblReseller WHERE ResellerID=p_ResellerID;
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;		
		
	END IF;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetail_ AS (

		SELECT
		UsageDetailID
		FROM
		(
			SELECT
				uh.AccountID,
				a.AccountName,
				trunk,
				area_prefix,
				UsageDetailID,
				duration,
				billed_duration,
				cli,
				cld,
				cost,
				connect_time,
				disconnect_time
			FROM `RMCDR3`.tblUsageDetails  ud
			INNER JOIN `RMCDR3`.tblUsageHeader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN Ratemanagement3.tblAccount a
				ON uh.AccountID = a.AccountID
			WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
				AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
				AND uh.CompanyID = p_CompanyID
				AND uh.AccountID is not null
				AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
				AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
				AND (p_CDRType = '' OR ud.userfield LIKE CONCAT('%',p_CDRType,'%') )
				AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))
				AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
				AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))
				AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
				AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
				AND (p_trunk = '' OR trunk = p_trunk )
				AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0)

		) tbl
		WHERE

			((v_BillingTime_ =1 OR v_BillingTime_ =3)  and connect_time >= p_StartDate AND connect_time <= p_EndDate)
			OR
			(v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
			AND billed_duration > 0
	);

	DELETE ud.*
	FROM `RMCDR3`.tblRetailUsageDetail ud
	INNER JOIN tmp_tblUsageDetail_ uds
		ON ud.UsageDetailID = uds.UsageDetailID;


	DELETE ud.*
	FROM `RMCDR3`.tblUsageDetails ud
	INNER JOIN tmp_tblUsageDetail_ uds
		ON ud.UsageDetailID = uds.UsageDetailID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_DeleteVCDR`;
DELIMITER //
CREATE PROCEDURE `prc_DeleteVCDR`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CLI` VARCHAR(250),
	IN `p_CLD` VARCHAR(250),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)


)
    COMMENT 'Delete Vendor CDR'
BEGIN

    DECLARE v_BillingTime_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
        
        
        CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetail_ AS 
        (

	   
	        SELECT
	        VendorCDRID
	        
	        FROM (SELECT
	            ud.VendorCDRID,
	            billed_duration,
	            connect_time,
	            disconnect_time,
	            cli,
	            cld,
	            buying_cost,
	            CompanyGatewayID,
	            uh.AccountID
	
	
			FROM `RMCDR3`.tblVendorCDR  ud 
			INNER JOIN `RMCDR3`.tblVendorCDRHeader uh
				ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
	        LEFT JOIN Ratemanagement3.tblAccount a
	            ON uh.AccountID = a.AccountID
	        WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
			  AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
	        AND uh.CompanyID = p_CompanyID
	        AND uh.AccountID is not null
	        AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	        AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
	        AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
			  AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
			  AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			  AND (p_trunk = '' OR trunk = p_trunk )	
				AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND buying_cost = 0) OR ( p_zerovaluecost = 2 AND buying_cost > 0))
			  AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	        ) tbl
	        WHERE 
	    
	        ( (v_BillingTime_ =1 OR v_BillingTime_ =3)  and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	        OR 
	        (v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	        AND billed_duration > 0
        );


		
		 delete ud.*
        From `RMCDR3`.tblVendorCDR ud
        inner join tmp_tblUsageDetail_ uds on ud.VendorCDRID = uds.VendorCDRID;
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getAccountSubscription`;
DELIMITER //
CREATE PROCEDURE `prc_getAccountSubscription`(
	IN `p_AccountID` INT,
	IN `p_ServiceID` INT
)
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		tblAccountSubscription.*
	FROM tblAccountSubscription
		INNER JOIN tblBillingSubscription
			ON tblAccountSubscription.SubscriptionID = tblBillingSubscription.SubscriptionID
		INNER JOIN Ratemanagement3.tblAccountService
			ON tblAccountService.AccountID = tblAccountSubscription.AccountID AND tblAccountService.ServiceID = tblAccountSubscription.ServiceID 
		LEFT JOIN Ratemanagement3.tblAccountBilling 
			ON tblAccountBilling.AccountID = tblAccountSubscription.AccountID AND tblAccountBilling.ServiceID =  tblAccountSubscription.ServiceID
	WHERE tblAccountSubscription.AccountID = p_AccountID
		AND tblAccountSubscription.`Status` = 1
		AND Ratemanagement3.tblAccountService.`Status`=1
		AND ( (p_ServiceID = 0 AND tblAccountBilling.ServiceID IS NULL) OR  tblAccountBilling.ServiceID = p_ServiceID)
	ORDER BY SequenceNo ASC;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetAccountSubscriptions`;
DELIMITER //
CREATE PROCEDURE `prc_GetAccountSubscriptions`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_ServiceID` VARCHAR(50),
	IN `p_SubscriptionName` VARCHAR(50),
	IN `p_Status` INT,
	IN `p_Date` DATE,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT

)
BEGIN 
	DECLARE v_OffSet_ INT;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_isExport = 0
	THEN 
		SELECT
			sa.SequenceNo,
			a.AccountName,
			s.ServiceName,
			sb.Name,
			sa.InvoiceDescription,
			sa.Qty,
			sa.StartDate,
			IF(sa.EndDate = '0000-00-00','',sa.EndDate) as EndDate,
			sa.ActivationFee,
			sa.DailyFee,
			sa.WeeklyFee,
			sa.MonthlyFee,
			sa.QuarterlyFee,
			sa.AnnuallyFee,
			sa.AccountSubscriptionID,
			sa.SubscriptionID,	
			sa.ExemptTax,
			a.AccountID,
			s.ServiceID,
			sa.`Status`
		FROM tblAccountSubscription sa
			INNER JOIN tblBillingSubscription sb
				ON sb.SubscriptionID = sa.SubscriptionID
			INNER JOIN Ratemanagement3.tblAccount a
				ON sa.AccountID = a.AccountID
			INNER JOIN Ratemanagement3.tblService s
				ON sa.ServiceID = s.ServiceID
		WHERE 	(p_AccountID = 0 OR a.AccountID = p_AccountID)
			AND (p_SubscriptionName is null OR sb.Name LIKE concat('%',p_SubscriptionName,'%'))
			AND (p_Status = sa.`Status`)
			AND (p_ServiceID = 0 OR s.ServiceID = p_ServiceID)
		ORDER BY
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SequenceNoASC') THEN sa.SequenceNo
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SequenceNoDESC') THEN sa.SequenceNo
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN a.AccountName
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN a.AccountName
			END DESC,			
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameASC') THEN s.ServiceName
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ServiceNameDESC') THEN s.ServiceName
			END DESC,			
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN sb.Name
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN sb.Name
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QtyASC') THEN sa.Qty
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QtyDESC') THEN sa.Qty
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StartDateASC') THEN sa.StartDate
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StartDateDESC') THEN sa.StartDate
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateASC') THEN sa.EndDate
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EndDateDESC') THEN sa.EndDate
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActivationFeeASC') THEN sa.ActivationFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActivationFeeDESC') THEN sa.ActivationFee
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeASC') THEN sa.DailyFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeDESC') THEN sa.DailyFee
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeASC') THEN sa.WeeklyFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeDESC') THEN sa.WeeklyFee
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeASC') THEN sa.MonthlyFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeDESC') THEN sa.MonthlyFee
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuarterlyFeeASC') THEN sa.QuarterlyFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuarterlyFeeDESC') THEN sa.QuarterlyFee
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AnnuallyFeeASC') THEN sa.AnnuallyFee
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AnnuallyFeeDESC') THEN sa.AnnuallyFee
			END DESC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(*) AS totalcount
		FROM tblAccountSubscription sa
			INNER JOIN tblBillingSubscription sb
				ON sb.SubscriptionID = sa.SubscriptionID
			INNER JOIN Ratemanagement3.tblAccount a
				ON sa.AccountID = a.AccountID
			INNER JOIN Ratemanagement3.tblService s
				ON sa.ServiceID = s.ServiceID
		WHERE 	(p_AccountID = 0 OR a.AccountID = p_AccountID)
			AND (p_SubscriptionName is null OR sb.Name LIKE concat('%',p_SubscriptionName,'%'))
			AND (p_Status = sa.`Status`)
			AND (p_ServiceID = 0 OR s.ServiceID = p_ServiceID);
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			sa.SequenceNo,
			a.AccountName,
			s.ServiceName,
			sb.Name,
			sa.InvoiceDescription,
			sa.Qty,
			sa.StartDate,
			IF(sa.EndDate = '0000-00-00','',sa.EndDate) as EndDate,
			sa.ActivationFee,
			sa.DailyFee,
			sa.WeeklyFee,
			sa.MonthlyFee,
			sa.QuarterlyFee,
			sa.AnnuallyFee,
			sa.AccountSubscriptionID,
			sa.SubscriptionID,	
			sa.ExemptTax,
			sa.`Status`
		FROM tblAccountSubscription sa
			INNER JOIN tblBillingSubscription sb
				ON sb.SubscriptionID = sa.SubscriptionID
			INNER JOIN Ratemanagement3.tblAccount a
				ON sa.AccountID = a.AccountID
			INNER JOIN Ratemanagement3.tblService s
				ON sa.ServiceID = s.ServiceID
		WHERE 	(p_AccountID = 0 OR a.AccountID = p_AccountID)
			AND (p_SubscriptionName is null OR sb.Name LIKE concat('%',p_SubscriptionName,'%'))
			AND (p_Status = sa.`Status`)
			AND (p_ServiceID =0 OR s.ServiceID = p_ServiceID);
	END IF;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getActiveGatewayAccount`;
DELIMITER //
CREATE PROCEDURE `prc_getActiveGatewayAccount`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_NameFormat` VARCHAR(50)
)
BEGIN

	DECLARE v_NameFormat_ VARCHAR(10);
	DECLARE v_RTR_ INT;
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ;
	DECLARE v_ServiceID_ INT ;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_ActiveAccount;
	CREATE TEMPORARY TABLE tmp_ActiveAccount (
		AccountName varchar(100),
		AccountNumber varchar(100),
		AccountCLI varchar(100),
		AccountIP varchar(100),
		AccountID INT,
		ServiceID INT,
		CompanyID INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_AuthenticateRules_;
	CREATE TEMPORARY TABLE tmp_AuthenticateRules_ (
		RowNo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AuthRule VARCHAR(50)
	);

	
	IF p_NameFormat = ''
	THEN
		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT
			CASE WHEN Settings LIKE '%"NameFormat":"NAMENUB"%'
			THEN 'NAMENUB'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NUBNAME"%'
			THEN 'NUBNAME'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NUB"%'
			THEN 'NUB'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"IP"%'
			THEN 'IP'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"CLI"%'
			THEN 'CLI'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NAME"%'
			THEN 'NAME'
			ELSE 'NAME' END END END END END END   AS  NameFormat
		FROM Ratemanagement3.tblCompanyGateway
		WHERE Settings LIKE '%NameFormat%' 
		AND CompanyGatewayID = p_CompanyGatewayID
		LIMIT 1;

	END IF;

	IF p_NameFormat != ''
	THEN
		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT p_NameFormat;

	END IF;
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Service_);
	 
	IF v_rowCount_ > 0
	THEN

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Service_ t WHERE t.RowID = v_pointer_);

			INSERT INTO tmp_AuthenticateRules_  (AuthRule)
			SELECT DISTINCT CustomerAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CustomerAuthRule IS NOT NULL AND ServiceID = v_ServiceID_ 
			UNION
			SELECT DISTINCT VendorAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE VendorAuthRule IS NOT NULL AND ServiceID = v_ServiceID_; -- CompanyID = p_CompanyID AND

			CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,v_ServiceID_);

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

	END IF;

	
	IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountAuthenticate WHERE ServiceID = 0) > 0
	THEN


		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT DISTINCT CustomerAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CustomerAuthRule IS NOT NULL AND ServiceID = 0
		UNION
		SELECT DISTINCT VendorAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE VendorAuthRule IS NOT NULL AND ServiceID = 0;

		CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,0);

	END IF;

	CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,0);

	UPDATE tblGatewayAccount
	INNER JOIN tmp_ActiveAccount a
		ON a.AccountName = tblGatewayAccount.AccountName
		AND a.AccountNumber = tblGatewayAccount.AccountNumber
		AND a.AccountCLI = tblGatewayAccount.AccountCLI
		AND a.AccountIP = tblGatewayAccount.AccountIP
		AND tblGatewayAccount.CompanyGatewayID = p_CompanyGatewayID
		AND tblGatewayAccount.ServiceID = a.ServiceID
	SET tblGatewayAccount.AccountID = a.AccountID,tblGatewayAccount.CompanyID=a.CompanyID
	WHERE tblGatewayAccount.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetCDR`;
DELIMITER //
CREATE PROCEDURE `prc_GetCDR`(
	IN `p_company_id` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT ,
	IN `p_ResellerID` INT,
	IN `p_CDRType` VARCHAR(50),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT

)
BEGIN

	DECLARE v_OffSet_ INT;
	DECLARE v_BillingTime_ INT;
	DECLARE v_Round_ INT;
	DECLARE v_raccountids TEXT;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	SET v_raccountids = '';

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_company_id) INTO v_Round_;

	SELECT cr.Symbol INTO v_CurrencyCode_ FROM Ratemanagement3.tblCurrency cr WHERE cr.CurrencyId =p_CurrencyID;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	Call fnUsageDetail(p_company_id,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CDRType,p_CLI,p_CLD,p_zerovaluecost);
	
	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM Ratemanagement3.tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM Ratemanagement3.tblReseller WHERE ResellerID=p_ResellerID;
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;
		
	END IF;

	IF p_isExport = 0
	THEN
		SELECT
			uh.UsageDetailID,
			uh.AccountName,
			uh.connect_time,
			uh.disconnect_time,
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(uh.cost)+0) AS cost,
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(ROUND((uh.cost/uh.billed_duration)*60.0,6))+0) AS rate,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk,
			s.ServiceName,
			uh.AccountID,
			p_CompanyGatewayID AS CompanyGatewayID,
			p_start_date AS StartDate,
			p_end_date AS EndDate,
			uh.is_inbound AS CDRType
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		LEFT JOIN Ratemanagement3.tblService s
			ON uh.ServiceID = s.ServiceID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk )
			AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0)
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(*) AS totalcount,
			fnFormateDuration(sum(billed_duration)) AS total_duration,
			sum(cost) AS total_cost,
			v_CurrencyCode_ AS CurrencyCode
		FROM  tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk )
			AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0);

	END IF;

	IF p_isExport = 1
	THEN

		SELECT
			uh.AccountName AS 'Account Name',
			uh.connect_time AS 'Connect Time',
			uh.disconnect_time AS 'Disconnect Time',
			uh.billed_duration AS 'Billed Duration (sec)' ,
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(uh.cost)+0) AS 'Cost',
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(ROUND((uh.cost/uh.billed_duration)*60.0,6))+0) AS 'Avg. Rate/Min',
			uh.cli AS 'CLI',
			uh.cld AS 'CLD',
			uh.area_prefix AS 'Prefix',
			uh.trunk AS 'Trunk',
			IF(uh.is_inbound = 0 , 'OutBound','InBound') AS 'Type'
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk )
			AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getInvoiceUsage`;
DELIMITER //
CREATE PROCEDURE `prc_getInvoiceUsage`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_ServiceID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_ShowZeroCall` INT







)
BEGIN

	DECLARE v_InvoiceCount_ INT; 
	DECLARE v_BillingTime_ INT; 
	DECLARE v_CDRType_ INT; 
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	CALL fnServiceUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_ServiceID,p_StartDate,p_EndDate,v_BillingTime_);

	SELECT 
		it.CDRType  INTO v_CDRType_
	FROM Ratemanagement3.tblAccountBilling ab
	INNER JOIN  Ratemanagement3.tblBillingClass b
		ON b.BillingClassID = ab.BillingClassID
	INNER JOIN tblInvoiceTemplate it
		ON it.InvoiceTemplateID = b.InvoiceTemplateID
	WHERE ab.AccountID = p_AccountID
		AND ab.ServiceID = p_ServiceID
	LIMIT 1;

	IF( v_CDRType_ = 2) 
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_tblSummaryUsageDetails_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblSummaryUsageDetails_(
	AccountID int,
	area_prefix varchar(50),
	trunk varchar(50),
	UsageDetailID int,
	duration int,
	billed_duration int,
	cost decimal(18,6),
	ServiceID INT,
	AvgRate decimal(18,6)
);

INSERT INTO tmp_tblSummaryUsageDetails_
SELECT
	AccountID,
	area_prefix, 
	trunk,			
	UsageDetailID,
	duration,
	billed_duration,
	cost,
	ServiceID,
	ROUND((uh.cost/uh.billed_duration)*60.0,6) as AvgRate 
FROM tmp_tblUsageDetails_ uh;

SELECT
			area_prefix AS AreaPrefix,
			Trunk,
			(SELECT 
			Country
			FROM Ratemanagement3.tblRate r
			INNER JOIN Ratemanagement3.tblCountry c
			ON c.CountryID = r.CountryID
			WHERE  r.Code = ud.area_prefix limit 1)
			AS Country,
			(SELECT Description
			FROM Ratemanagement3.tblRate r
			WHERE  r.Code = ud.area_prefix limit 1 )
			AS Description,
			COUNT(UsageDetailID) AS NoOfCalls,
			CONCAT( FLOOR(SUM(duration ) / 60), ':' , SUM(duration ) % 60) AS Duration,
			CONCAT( FLOOR(SUM(billed_duration ) / 60),':' , SUM(billed_duration ) % 60) AS BillDuration,
			SUM(cost) AS ChargedAmount,
			SUM(duration ) as DurationInSec,
			SUM(billed_duration ) as BillDurationInSec,
			ud.ServiceID,
			ud.AvgRate as AvgRatePerMin
		FROM tmp_tblSummaryUsageDetails_ ud
		GROUP BY ud.area_prefix,ud.Trunk,ud.AccountID,ud.ServiceID,ud.AvgRate;

	ELSE

		SELECT
			trunk AS Trunk,
			area_prefix AS Prefix,
			CONCAT("'",cli) AS CLI,
			CONCAT("'",cld) AS CLD,
			connect_time AS ConnectTime,
			disconnect_time AS DisconnectTime,
			billed_duration AS BillDuration,
			cost AS ChargedAmount,
			ServiceID
		FROM tmp_tblUsageDetails_ ud
		WHERE ((p_ShowZeroCall =0 AND ud.cost >0 ) OR (p_ShowZeroCall =1 AND ud.cost >= 0))
		ORDER BY connect_time ASC;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getSOA`;
DELIMITER //
CREATE PROCEDURE `prc_getSOA`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_StartDate` datetime,
	IN `p_EndDate` datetime,
	IN `p_isExport` INT 





)
BEGIN
  
  
    	
    DECLARE v_start_date DATETIME ;
	DECLARE v_bf_InvoiceOutAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_PaymentInAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_InvoiceInAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_PaymentOutAmountTotal NUMERIC(18, 8);


    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';


   DROP TEMPORARY TABLE IF EXISTS tmp_Invoices;
    CREATE TEMPORARY TABLE tmp_Invoices (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        IssueDate Datetime,
        Amount NUMERIC(18, 8),
        InvoiceType int,
        AccountID int,
        InvoiceID INT
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_broghtf;
    CREATE TEMPORARY TABLE tmp_Invoices_broghtf (
        Amount NUMERIC(18, 8),
        InvoiceType int
    );

    
    DROP TEMPORARY TABLE IF EXISTS tmp_Payments;
    CREATE TEMPORARY TABLE tmp_Payments (
        InvoiceNo VARCHAR(50),
        PaymentDate VARCHAR(50),
        IssueDate datetime,
        Amount NUMERIC(18, 8),
        PaymentID INT,
        PaymentType VARCHAR(50),
        InvoiceID INT
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Payments_broghtf;
    CREATE TEMPORARY TABLE tmp_Payments_broghtf (
        Amount NUMERIC(18, 8),
        PaymentType VARCHAR(50)
    );

    
    DROP TEMPORARY TABLE IF EXISTS tmp_Disputes;
    CREATE TEMPORARY TABLE tmp_Disputes (
        InvoiceNo VARCHAR(50),
        created_at datetime,
        DisputeAmount NUMERIC(18, 8),
        InvoiceType VARCHAR(50),
        DisputeID INT,
        AccountID INT,
        InvoiceID INT

    );
  
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceOutWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceOutWithDisputes (
        InvoiceOut_InvoiceNo VARCHAR(50),
        InvoiceOut_PeriodCover VARCHAR(50),
        InvoiceOut_IssueDate datetime,
        InvoiceOut_Amount NUMERIC(18, 8),
        InvoiceOut_DisputeAmount NUMERIC(18, 8),
        InvoiceOut_DisputeID INT,
       InvoiceOut_AccountID INT,
       InvoiceOut_InvoiceID INT
    );
    
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceInWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceInWithDisputes (
        InvoiceIn_InvoiceNo VARCHAR(50),
        InvoiceIn_PeriodCover VARCHAR(50),
        InvoiceIn_IssueDate datetime,
        InvoiceIn_Amount NUMERIC(18, 8),
        InvoiceIn_DisputeAmount NUMERIC(18, 8),
        InvoiceIn_DisputeID INT,
        InvoiceIn_AccountID INT,
        InvoiceIn_InvoiceID INT
    );
  
  


    
     
    INSERT into tmp_Invoices
    SELECT
      DISTINCT 
         tblInvoice.InvoiceNumber,
         CASE
          WHEN (tblInvoice.ItemInvoice = 1 ) THEN
                DATE_FORMAT(tblInvoice.IssueDate,'%d/%m/%Y')
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0 ) THEN
          Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'<br>' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
          (select Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'-' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y')) from tblInvoiceDetail where tblInvoiceDetail.InvoiceID= tblInvoice.InvoiceID order by InvoiceDetailID  limit 1)  
       END AS PeriodCover,
         tblInvoice.IssueDate,
         tblInvoice.GrandTotal,
         tblInvoice.InvoiceType,
        tblInvoice.AccountID,
        tblInvoice.InvoiceID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail         
		  ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
        AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') <= p_EndDate ) )
      AND tblInvoice.GrandTotal != 0
      Order by tblInvoice.IssueDate asc;
    
	IF ( p_StartDate = '0000-00-00' ) THEN
		  SELECT min(IssueDate) into  v_start_date from tmp_Invoices;
	END IF;
	
	
        INSERT into tmp_Invoices_broghtf
      SELECT 
		GrandTotal ,
		InvoiceType
		FROM (
		
		SELECT
		 DISTINCT 
         tblInvoice.InvoiceNumber,
         CASE
          WHEN (tblInvoice.ItemInvoice = 1 ) THEN
                DATE_FORMAT(tblInvoice.IssueDate,'%d/%m/%Y')
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0 ) THEN
          Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'<br>' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
          (select Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'-' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y')) from tblInvoiceDetail where tblInvoiceDetail.InvoiceID= tblInvoice.InvoiceID order by InvoiceDetailID  limit 1)  
       END AS PeriodCover,
         tblInvoice.IssueDate,
         tblInvoice.GrandTotal,
         tblInvoice.InvoiceType,
        tblInvoice.AccountID,
        tblInvoice.InvoiceID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail         
		  ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
        AND ( (p_StartDate = '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') < v_start_date ) OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') < p_StartDate ) )
        AND tblInvoice.GrandTotal != 0
      Order by tblInvoice.IssueDate asc
		) t;

	
     
     INSERT into tmp_Payments
       SELECT
        DISTINCT
            tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType,
            tblPayment.InvoiceID
        FROM tblPayment
        WHERE 
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') <= p_EndDate ) )
    Order by tblPayment.PaymentDate desc;

	
	
    INSERT into tmp_Payments_broghtf
    	SELECT 
    	Amount,
    	PaymentType
    	FROM (
       SELECT
         DISTINCT
           tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType,
            tblPayment.InvoiceID
        FROM tblPayment
        WHERE 
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND ( ( p_StartDate = '0000-00-00' AND DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') < v_start_date )  OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') < p_StartDate ) )
    Order by tblPayment.PaymentDate desc
	 ) t;
        
     
     INSERT INTO tmp_Disputes
       SELECT
            InvoiceNo,
        created_at,
            DisputeAmount,
            InvoiceType,
            DisputeID,
            AccountID,
            0 as InvoiceID
      FROM tblDispute 
        WHERE 
            CompanyID = p_CompanyID
      AND AccountID = p_accountID
      AND Status = 0 
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') <= p_EndDate ) )
      order by created_at;

        DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Disputes_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Payments_dup;        

          
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_dup AS (SELECT * FROM tmp_Invoices);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Disputes_dup AS (SELECT * FROM tmp_Disputes);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payments_dup AS (SELECT * FROM tmp_Payments);
              
     
    INSERT INTO tmp_InvoiceOutWithDisputes
      SELECT  
    InvoiceNo as InvoiceOut_InvoiceNo,
    PeriodCover as InvoiceOut_PeriodCover,
    IssueDate as InvoiceOut_IssueDate,
    Amount as InvoiceOut_Amount,
    ifnull(DisputeAmount,0) as InvoiceOut_DisputeAmount,
    DisputeID as InvoiceOut_DisputeID,
    AccountID as InvoiceOut_AccountID,
    InvoiceID as InvoiceOut_InvoiceID
    
    FROM
     (
      SELECT
      		DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
       	   iv.AccountID,
       	   iv.InvoiceID
            
        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds on ds.InvoiceNo = iv.InvoiceNo AND ds.InvoiceType = iv.InvoiceType  AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 1          
       
    
     UNION ALL
    
     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
        ds.AccountID,
        iv.InvoiceID
      FROM tmp_Disputes_dup ds 
      LEFT JOIN  tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo and iv.InvoiceType = ds.InvoiceType 
        WHERE 
        ds.InvoiceType = 1  
        AND iv.InvoiceNo is null
        
   
    ) tbl  ;
    
    
    
    
    SELECT 
      InvoiceOut_InvoiceNo,
      InvoiceOut_PeriodCover,
      ifnull(InvoiceOut_Amount,0) as InvoiceOut_Amount,
      InvoiceOut_DisputeAmount,
      InvoiceOut_DisputeID,
      ifnull(PaymentIn_PeriodCover,'') as PaymentIn_PeriodCover,
      PaymentIn_Amount,
      PaymentIn_PaymentID
    FROM
    (
      SELECT 
      DISTINCT
      InvoiceOut_InvoiceNo,
      InvoiceOut_PeriodCover,
      InvoiceOut_IssueDate,
      InvoiceOut_Amount,
      InvoiceOut_DisputeAmount,
      InvoiceOut_DisputeID,
      tmp_Payments.PaymentDate as PaymentIn_PeriodCover,
      tmp_Payments.Amount as PaymentIn_Amount,
      tmp_Payments.PaymentID as PaymentIn_PaymentID
      FROM tmp_InvoiceOutWithDisputes 
      INNER JOIN Ratemanagement3.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
      LEFT JOIN tmp_Payments
      ON tmp_Payments.PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo != '' AND 
      tmp_Payments.InvoiceID = tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceID
		
      
      UNION ALL

      select 
      DISTINCT
      '' as InvoiceOut_InvoiceNo,
      '' as InvoiceOut_PeriodCover,
      tmp_Payments.IssueDate as InvoiceOut_IssueDate,
      0  as InvoiceOut_Amount,
      0 as InvoiceOut_DisputeAmount,
      0 as InvoiceOut_DisputeID,
      tmp_Payments.PaymentDate as PaymentIn_PeriodCover,
      tmp_Payments.Amount as PaymentIn_Amount,
      tmp_Payments.PaymentID as PaymentIn_PaymentID
      from tmp_Payments_dup as tmp_Payments
      where PaymentType = 'Payment In' 
      
		AND  tmp_Payments.InvoiceID = 0
  
    ) tbl
    order by InvoiceOut_IssueDate desc,InvoiceOut_InvoiceNo desc;
     
    
    


    
    INSERT INTO tmp_InvoiceInWithDisputes
    SELECT 
    InvoiceNo as InvoiceIn_InvoiceNo,
    PeriodCover as InvoiceIn_PeriodCover,
    IssueDate as InvoiceIn_IssueDate,
    Amount as InvoiceIn_Amount,
    ifnull(DisputeAmount,0) as InvoiceIn_DisputeAmount,
    DisputeID as InvoiceIn_DisputeID,
    AccountID as InvoiceIn_AccountID,
    InvoiceID as InvoiceIn_InvoiceID
    FROM
     (  SELECT
        DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            iv.AccountID,
            iv.InvoiceID
        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds  on  ds.InvoiceNo = iv.InvoiceNo   AND ds.InvoiceType = iv.InvoiceType AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 2          
        
    
     UNION ALL
    
     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            ds.AccountID,
            ds.InvoiceID
      From tmp_Disputes_dup ds 
        LEFT JOIN tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo AND iv.InvoiceType = ds.InvoiceType 
        WHERE  ds.InvoiceType = 2  
        AND iv.InvoiceNo is null
        
    )tbl;
      
      
     
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_InvoiceInWithDisputes_dup AS (SELECT * FROM tmp_InvoiceInWithDisputes);
 
     
    SELECT 
      InvoiceIn_InvoiceNo,
      InvoiceIn_PeriodCover,
      ifnull(InvoiceIn_Amount,0) as InvoiceIn_Amount,
      InvoiceIn_DisputeAmount,
      InvoiceIn_DisputeID,
      ifnull(PaymentOut_PeriodCover,'') as PaymentOut_PeriodCover,
      ifnull(PaymentOut_Amount,0) as PaymentOut_Amount,
      PaymentOut_PaymentID
    FROM
    (
      SELECT 
      DISTINCT
      InvoiceIn_InvoiceNo,
      InvoiceIn_PeriodCover,
      InvoiceIn_IssueDate,
      InvoiceIn_Amount,
      InvoiceIn_DisputeAmount,
      InvoiceIn_DisputeID,
      tmp_Payments.PaymentDate as PaymentOut_PeriodCover,
      tmp_Payments.Amount as PaymentOut_Amount,
      tmp_Payments.PaymentID as PaymentOut_PaymentID
      FROM tmp_InvoiceInWithDisputes 
      INNER JOIN Ratemanagement3.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
      LEFT JOIN tmp_Payments ON tmp_Payments.PaymentType = 'Payment Out' AND tmp_InvoiceInWithDisputes.InvoiceIn_InvoiceNo = tmp_Payments.InvoiceNo 
      
      UNION ALL

      select 
      DISTINCT
      '' as InvoiceIn_InvoiceNo,
      '' as InvoiceIn_PeriodCover,
      tmp_Payments.IssueDate  as InvoiceIn_IssueDate,
      0 as InvoiceIn_Amount,
      0 as InvoiceIn_DisputeAmount,
      0 as InvoiceIn_DisputeID,
      tmp_Payments.PaymentDate as PaymentOut_PeriodCover,
      tmp_Payments.Amount as PaymentOut_Amount,
      tmp_Payments.PaymentID as PaymentOut_PaymentID
      from tmp_Payments_dup as tmp_Payments
       where PaymentType = 'Payment Out' AND 
      (
			tmp_Payments.InvoiceNo = ''		
			OR 
			tmp_Payments.InvoiceNo NOT in  ( select InvoiceIn_InvoiceNo from  tmp_InvoiceInWithDisputes_dup )
		)
  
    ) tbl
    order by InvoiceIn_IssueDate desc;

   
	
    select sum(Amount) as InvoiceOutAmountTotal 
    from tmp_Invoices where InvoiceType = 1 ;
    

    
    select sum(DisputeAmount) as InvoiceOutDisputeAmountTotal 
    from tmp_Disputes where InvoiceType = 1; 

    
    select sum(Amount) as PaymentInAmountTotal 
    from tmp_Payments where PaymentType = 'Payment In' ; 
    

    
    select sum(Amount) as InvoiceInAmountTotal 
    from tmp_Invoices where InvoiceType = 2 ;
    
    
    
    select sum(DisputeAmount) as InvoiceInDisputeAmountTotal
    from tmp_Disputes where InvoiceType = 2; 


    
    select sum(Amount) as PaymentOutAmountTotal 
    from tmp_Payments where PaymentType = 'Payment Out' ; 
    
	
	
	
	select sum(ifnull(Amount,0)) as InvoiceOutAmountTotal  into v_bf_InvoiceOutAmountTotal 
    from tmp_Invoices_broghtf where InvoiceType = 1 ;
    
    select sum(ifnull(Amount,0)) as PaymentInAmountTotal into v_bf_PaymentInAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment In' ; 
    
    select sum(ifnull(Amount,0)) as InvoiceInAmountTotal into v_bf_InvoiceInAmountTotal
    from tmp_Invoices_broghtf where InvoiceType = 2 ;
    
    select sum(ifnull(Amount,0)) as PaymentOutAmountTotal into v_bf_PaymentOutAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment Out' ; 

	SELECT (ifnull(v_bf_InvoiceOutAmountTotal,0) - ifnull(v_bf_PaymentInAmountTotal,0)) - ( ifnull(v_bf_InvoiceInAmountTotal,0) - ifnull(v_bf_PaymentOutAmountTotal,0)) as BroughtForwardOffset;
	
	


  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_InsertTempReRateCDR`;
DELIMITER //
CREATE PROCEDURE `prc_InsertTempReRateCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_ProcessID` VARCHAR(50),
	IN `p_tbltempusagedetail_name` VARCHAR(50),
	IN `p_CDRType` VARCHAR(50),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_ResellerID` INT
)
BEGIN
	DECLARE v_BillingTime_ INT;
	DECLARE v_raccountids TEXT;
	SET v_raccountids = '';
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;
	
	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM Ratemanagement3.tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM Ratemanagement3.tblReseller WHERE ResellerID=p_ResellerID;
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;
		
	END IF;

	SET @stm1 = CONCAT('

	INSERT INTO RMCDR3.`' , p_tbltempusagedetail_name , '` (
		CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		GatewayAccountPKID,
		AccountID,
		ServiceID,
		connect_time,
		disconnect_time,
		billed_duration,
		area_prefix,
		trunk,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		ProcessID,
		ID,
		is_inbound,
		billed_second,
		disposition,
		userfield,
		AccountName,
		AccountNumber,
		AccountCLI,
		AccountIP,
		cc_type
	)

	SELECT
	*
	FROM (SELECT
		Distinct 
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		uh.GatewayAccountPKID,
		uh.AccountID,
		uh.ServiceID,
		connect_time,
		disconnect_time,
		billed_duration,
		CASE WHEN   "' , p_RateMethod , '" = "SpecifyRate"
		THEN
			area_prefix
		ELSE
			"Other"
		END
		AS area_prefix,
		CASE WHEN   "' , p_RateMethod , '" = "SpecifyRate"
		THEN
			trunk
		ELSE
			"Other"
		END
		AS trunk,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		"',p_ProcessID,'",
		ud.ID,
		is_inbound,
		billed_second,
		disposition,
		userfield,
		IFNULL(ga.AccountName,""),
		IFNULL(ga.AccountNumber,""),
		IFNULL(ga.AccountCLI,""),
		IFNULL(ga.AccountIP,""),
        dr.cc_type
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	LEFT JOIN RMCDR3.tblRetailUsageDetail dr on ud.UsageDetailID = dr.UsageDetailID AND ud.ID = dr.ID	
	INNER JOIN Ratemanagement3.tblAccount a
		ON uh.AccountID = a.AccountID
	LEFT JOIN tblGatewayAccount ga
		ON ga.GatewayAccountPKID = uh.GatewayAccountPKID
WHERE
	( "' , p_CDRType , '" = "" OR  ud.userfield LIKE  CONCAT("%","' , p_CDRType , '","%"))
	AND  StartDate >= DATE_ADD( "' , p_StartDate , '",INTERVAL -1 DAY)
	AND StartDate <= DATE_ADD( "' , p_EndDate , '",INTERVAL 1 DAY)
	AND uh.CompanyID =  "' , p_CompanyID , '"
	AND uh.AccountID is not null
	AND ( "' , p_AccountID , '" = 0 OR uh.AccountID = "' , p_AccountID , '")
	AND ( "' , p_CompanyGatewayID , '" = 0 OR uh.CompanyGatewayID = "' , p_CompanyGatewayID , '")
	AND ( "' , p_CurrencyID ,'" = "0" OR a.CurrencyId = "' , p_CurrencyID , '")
	AND ( "' , p_CLI , '" = "" OR cli LIKE REPLACE("' , p_CLI , '", "*", "%"))
	AND ( "' , p_CLD , '" = "" OR cld LIKE REPLACE("' , p_CLD , '", "*", "%"))
	AND ( "' , p_trunk , '" = ""  OR  trunk = "' , p_trunk , '")
	AND ( "' , p_area_prefix , '" = "" OR area_prefix LIKE REPLACE( "' , p_area_prefix , '", "*", "%"))
	AND ( "' , p_zerovaluecost , '" = 0 OR (  "' , p_zerovaluecost , '" = 1 AND cost = 0) OR (  "' , p_zerovaluecost , '" = 2 AND cost > 0))
	AND ( "' , p_ResellerID , '" = 0 OR FIND_IN_SET(uh.AccountID, "' , v_raccountids ,'" ) != 0)

	) tbl
	WHERE
	( ( "' , v_BillingTime_ , '" =1 OR  "' , v_BillingTime_ , '" = 3 ) AND connect_time >=  "' , p_StartDate , '" AND connect_time <=  "' , p_EndDate , '")
	OR
	("' , v_BillingTime_ , '" =2 AND disconnect_time >=  "' , p_StartDate , '" AND disconnect_time <=  "' , p_EndDate , '")
	AND billed_duration > 0;
	');

	
	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ProcessCDRAccount`;
DELIMITER //
CREATE PROCEDURE `prc_ProcessCDRAccount`(
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
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.AccountName = ud.AccountName
		AND ga.AccountNumber = ud.AccountNumber
		AND ga.AccountCLI = ud.AccountCLI
		AND ga.AccountIP = ud.AccountIP		 
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
		ON  ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.AccountName = uh.AccountName
		AND ga.AccountNumber = uh.AccountNumber
		AND ga.AccountCLI = uh.AccountCLI
		AND ga.AccountIP = uh.AccountIP
		AND ga.ServiceID = uh.ServiceID
	SET uh.GatewayAccountPKID = ga.GatewayAccountPKID
	WHERE uh.ProcessID = "' , p_processId , '" ;
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
		ON  ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.AccountName = uh.AccountName
		AND ga.AccountNumber = uh.AccountNumber
		AND ga.AccountCLI = uh.AccountCLI
		AND ga.AccountIP = uh.AccountIP
		AND ga.ServiceID = uh.ServiceID
	SET uh.AccountID = ga.AccountID,uh.CompanyID = ga.CompanyID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
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
--	AND uh.CompanyID = p_CompanyID
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
--		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ProcessCDRService`;
DELIMITER //
CREATE PROCEDURE `prc_ProcessCDRService`(
	IN `p_CompanyID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)

)
BEGIN

	DECLARE v_ServiceAccountID_CLI_Count_ INT;
	DECLARE v_ServiceAccountID_IP_Count_ INT;

	SELECT COUNT(*) INTO v_ServiceAccountID_CLI_Count_ 
	FROM Ratemanagement3.tblAccountAuthenticate aa
	INNER JOIN Ratemanagement3.tblCLIRateTable crt ON crt.AccountID = aa.AccountID
	WHERE -- aa.CompanyID = p_CompanyID AND 
	(CustomerAuthRule = 'CLI' OR VendorAuthRule = 'CLI') AND crt.ServiceID > 0 ;

	IF v_ServiceAccountID_CLI_Count_ > 0
	THEN

		
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
		INNER JOIN Ratemanagement3.tblCLIRateTable ga
			ON ga.CLI = uh.cli
		SET uh.ServiceID = ga.ServiceID
		WHERE ga.ServiceID > 0
		AND uh.ProcessID = "' , p_processId , '" AND uh.ServiceID IS NOT NULL;
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;
	
	SELECT COUNT(*) INTO v_ServiceAccountID_IP_Count_ 
	FROM Ratemanagement3.tblAccountAuthenticate aa
	WHERE -- aa.CompanyID = p_CompanyID AND
	 (CustomerAuthRule = 'IP' OR VendorAuthRule = 'IP') AND ServiceID > 0;

	IF v_ServiceAccountID_IP_Count_ > 0
	THEN

		
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
		INNER JOIN Ratemanagement3.tblAccountAuthenticate ga
			ON  ( FIND_IN_SET(uh.GatewayAccountID,ga.CustomerAuthValue) != 0 OR FIND_IN_SET(uh.GatewayAccountID,ga.VendorAuthValue) != 0 )
		SET uh.ServiceID = ga.ServiceID
		WHERE ga.ServiceID > 0
		AND uh.ProcessID = "' , p_processId , '"  AND uh.ServiceID IS NOT NULL;
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_ProcesssCDR`;
DELIMITER //
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
	IN `p_InboundTableID` INT,
	IN `p_RerateAccounts` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	CALL prc_autoAddIP(p_CompanyID,p_CompanyGatewayID); -- only if AutoAddIP is on
	
	CALL prc_ProcessCDRService(p_CompanyID,p_processId,p_tbltempusagedetail_name); -- update service ID based on IP or cli


	DROP TEMPORARY TABLE IF EXISTS tmp_Customers_;
	CREATE TEMPORARY TABLE tmp_Customers_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		CompanyGatewayID INT
	);

	IF p_RerateAccounts!=0
	THEN
		-- selected customer 
      SET @sql1 = concat("insert into tmp_Customers_ (AccountID) values ('", replace(( select TRIM(REPLACE(group_concat(distinct IFNULL(REPLACE(REPLACE(json_extract(Settings, '$.Accounts'), '[', ''), ']', ''),0)),'"','')) as AccountID from Ratemanagement3.tblCompanyGateway), ",", "'),('"),"');");
      PREPARE stmt1 FROM @sql1;
      EXECUTE stmt1;
      DEALLOCATE PREPARE stmt1;
      DELETE FROM tmp_Customers_ WHERE AccountID=0;
      UPDATE tmp_Customers_ SET CompanyGatewayID=p_CompanyGatewayID WHERE 1;
  END IF;

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
	WHERE tblService.ServiceID > 0 AND tblService.CompanyGatewayID > 0 AND ud.ServiceID IS NULL
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;



	CALL prc_ProcessCDRAccount(p_CompanyID,p_CompanyGatewayID,p_processId,p_tbltempusagedetail_name,p_NameFormat);

	

	-- p_OutboundTableID is for cdr upload
	IF ( ( SELECT COUNT(*) FROM tmp_Service_ ) > 0 OR p_OutboundTableID > 0)
	THEN


		CALL prc_RerateOutboundService(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate,p_OutboundTableID);

	ELSE


		CALL prc_RerateOutboundTrunk(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate);


		CALL prc_autoUpdateTrunk(p_CompanyID,p_CompanyGatewayID);

	END IF;

	 -- no rerate and prefix format

	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN

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


		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);


		CALL prc_updateDefaultPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;


	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate,p_InboundTableID);


	-- for mirta only
	IF (  p_RateCDR = 1 )
	THEN
		-- update cost = 0 where cc_type = 4 (OUTNOCHARGE)
		SET @stm = CONCAT('
	UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN  RMCDR3.`' , p_tbltempusagedetail_name ,'_Retail' , '` udr ON ud.TempUsageDetailID = udr.TempUsageDetailID AND ud.ProcessID = udr.ProcessID
	SET cost = 0
  WHERE ud.ProcessID="' , p_processId , '" AND udr.cc_type = 4 ;
	');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

	END IF;
	
	
	
	CALL prc_CreateRerateLog(p_processId,p_tbltempusagedetail_name,p_RateCDR);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RerateInboundCalls`;
DELIMITER //
CREATE PROCEDURE `prc_RerateInboundCalls`(
	IN `p_CompanyID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_InboundTableID` INT
)
BEGIN

	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_ServiceID_ INT;
	DECLARE v_cld_ VARCHAR(500);
	DECLARE v_CustomerIDs_ TEXT DEFAULT '';
	DECLARE v_CustomerIDs_Count_ INT DEFAULT 0;

	SELECT GROUP_CONCAT(AccountID) INTO v_CustomerIDs_ FROM tmp_Customers_ GROUP BY CompanyGatewayID;
	SELECT COUNT(*) INTO v_CustomerIDs_Count_ FROM tmp_Customers_;

	IF p_RateCDR = 1
	THEN

		IF (SELECT COUNT(*) FROM Ratemanagement3.tblCLIRateTable WHERE RateTableID > 0) > 0
		THEN


			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				ServiceID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,ServiceID,cld)
			SELECT DISTINCT AccountID,ServiceID,cld FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;
			
		END IF;

		IF ( SELECT COUNT(*) FROM tmp_Service_ ) > 0
		THEN


			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				ServiceID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,ServiceID,cld)
			SELECT DISTINCT AccountID,ServiceID,"" FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;

		ELSE


			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				ServiceID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,ServiceID,cld)
			SELECT DISTINCT AccountID,ServiceID,"" FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;

		END IF;
		
		IF (SELECT COUNT(*) FROM Ratemanagement3.tblCLIRateTable WHERE RateTableID > 0) > 0
		THEN


			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				ServiceID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,ServiceID,cld)
			SELECT DISTINCT AccountID,ServiceID,cld FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;
			
		END IF;

		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

		IF p_InboundTableID > 0
		THEN

			CALL Ratemanagement3.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_,p_InboundTableID);
		END IF;

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
			SET v_cld_ = (SELECT cld FROM tmp_Account_ t WHERE t.RowID = v_pointer_);

			IF (v_CustomerIDs_Count_=0 OR (v_CustomerIDs_Count_>0 AND FIND_IN_SET(v_AccountID_,v_CustomerIDs_)>0))
			THEN
				IF p_InboundTableID =  0
				THEN

					SET p_InboundTableID = (SELECT RateTableID FROM Ratemanagement3.tblAccountTariff  WHERE AccountID = v_AccountID_ AND ServiceID = v_ServiceID_ AND Type = 2 LIMIT 1);
					SET p_InboundTableID = IFNULL(p_InboundTableID,0);

					CALL Ratemanagement3.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_,p_InboundTableID);
				END IF;


				CALL prc_updateInboundPrefix(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_,v_ServiceID_);


				CALL prc_updateInboundRate(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_,v_ServiceID_,p_RateMethod,p_SpecifyRate);
			END IF;

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_reseller_ProcesssCDR`;
DELIMITER //
CREATE PROCEDURE `prc_reseller_ProcesssCDR`(
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
	IN `p_InboundTableID` INT,
	IN `p_RerateAccounts` INT

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	/* created in prc_autoAddIP */
	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Customers_;
	CREATE TEMPORARY TABLE tmp_Customers_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		CompanyGatewayID INT
	);


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
	WHERE tblService.ServiceID > 0 AND tblService.CompanyGatewayID > 0 AND ud.ServiceID IS NULL
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;


	-- p_OutboundTableID is for cdr upload
	IF ( ( SELECT COUNT(*) FROM tmp_Service_ ) > 0 OR p_OutboundTableID > 0)
	THEN


		CALL prc_RerateOutboundService(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate,p_OutboundTableID);

	ELSE


		CALL prc_RerateOutboundTrunk(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate);


		CALL prc_autoUpdateTrunk(p_CompanyID,p_CompanyGatewayID);

	END IF;

	 -- no rerate and prefix format

	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN

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


		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);


		CALL prc_updateDefaultPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;


	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate,p_InboundTableID);


	CALL prc_CreateRerateLog(p_processId,p_tbltempusagedetail_name,p_RateCDR);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

USE `RMCDR3`;

CREATE TABLE IF NOT EXISTS `tblRetailUsageDetail` (
  `RetailUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `UsageDetailID` int(11) NOT NULL,
  `ID` int(11) NOT NULL,
  `cc_type` tinyint(1) NOT NULL DEFAULT '0',
  `ProcessID` bigint(20) NOT NULL,
  PRIMARY KEY (`RetailUsageDetailID`),
  KEY `IX_cc_type` (`cc_type`),
  KEY `IX_UsageDetailID` (`UsageDetailID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP PROCEDURE IF EXISTS `prc_DeleteDuplicateUniqueID`;
DELIMITER //
CREATE PROCEDURE `prc_DeleteDuplicateUniqueID`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_ProcessID` VARCHAR(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @stm1 = CONCAT('DELETE tud FROM     `' , p_tbltempusagedetail_name , '` tud
	INNER JOIN tblUsageDetails ud ON tud.ID =ud.ID
	INNER JOIN  tblUsageHeader uh on uh.UsageHeaderID = ud.UsageHeaderID
		AND tud.CompanyGatewayID = uh.CompanyGatewayID
	WHERE
		  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt1 FROM @stm1;
   EXECUTE stmt1;
   DEALLOCATE PREPARE stmt1;
   
   SET @stm2 = CONCAT('DELETE tud FROM     `' , p_tbltempusagedetail_name , '` tud
	INNER JOIN tblUsageDetailFailedCall ud ON tud.ID =ud.ID
	INNER JOIN  tblUsageHeader uh on uh.UsageHeaderID = ud.UsageHeaderID
		AND tud.CompanyGatewayID = uh.CompanyGatewayID
	WHERE  
		  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt2 FROM @stm2;
   EXECUTE stmt2;
   DEALLOCATE PREPARE stmt2;
	
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_insertCDR`;
DELIMITER //
CREATE PROCEDURE `prc_insertCDR`(
	IN `p_processId` varchar(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	SET @stm2 = CONCAT('
	INSERT INTO   tblUsageHeader (CompanyID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountID,StartDate,created_at,ServiceID)
	SELECT DISTINCT d.CompanyID,d.CompanyGatewayID,d.GatewayAccountPKID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW(),d.ServiceID
	FROM `' , p_tbltempusagedetail_name , '` d
	LEFT JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE h.GatewayAccountID IS NULL AND processid = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET @stm3 = CONCAT('
	INSERT INTO tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE   processid = "' , p_processId , '"
		AND billed_duration = 0 AND cost = 0 AND ( disposition <> "ANSWERED" OR disposition IS NULL);

	');

	PREPARE stmt3 FROM @stm3;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SET @stm4 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  AND billed_duration = 0 AND cost = 0 AND ( disposition <> "ANSWERED" OR disposition IS NULL);
	');

	PREPARE stmt4 FROM @stm4;
	EXECUTE stmt4;
	DEALLOCATE PREPARE stmt4;

	SET @stm5 = CONCAT('
	INSERT INTO tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE   processid = "' , p_processId , '" ;
	');

	PREPARE stmt5 FROM @stm5;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;

	SET @stm6 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stmt6 FROM @stm6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_InsertTemptResellerCDR`;
DELIMITER //
CREATE PROCEDURE `prc_InsertTemptResellerCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_ProcessID` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_Today` INT

)
ThisSP:BEGIN
	
	DECLARE v_raccountids TEXT;
	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_ResellerID_ INT;
	DECLARE v_ResellerAccountName_ VARCHAR(100);
	SET v_raccountids = '';

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_usageheader;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_usageheader(
		UsageHeaderID INT,
		CompanyID INT,
		CompanyGatewayID INT,
		GatewayAccountID VARCHAR(100),
		AccountID INT,
		StartDate DATETIME,
		updated_at DATETIME,
		created_at DATETIME,
		ServiceID INT,
		GatewayAccountPKID INT
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_resellers;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_resellers(
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		ResellerID INT,
		CompanyID INT,
		ChildCompanyID INT,
		AccountID INT,
		TotalAccount INT
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
		AccountID int
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_allaccounts_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_allaccounts_(
		ResellerID INT,
		ResellerCompanyID INT,
		ResellerAccountID INT,
		ResellerAccountName VARCHAR(100),
		CustomerAccountID INT,
		CustomerAccountName VARCHAR(100)
	);
	
	Insert into tmp_usageheader
	select distinct uh.*
	From tblUsageHeader uh
	WHERE uh.CompanyGatewayID = p_CompanyGatewayID
	AND ((p_Today = 1 AND uh.StartDate BETWEEN DATE_FORMAT(SUBDATE(Now(),INTERVAL 2 hour) ,"%Y-%m-%d") AND DATE_FORMAT(Now() ,"%Y-%m-%d") ) OR (p_Today =0 AND uh.StartDate BETWEEN p_StartDate AND p_EndDate ));
	
	INSERT INTO tmp_resellers(ResellerID,CompanyID,ChildCompanyID,AccountID,TotalAccount)
	SELECT DISTINCT
		ResellerID,
		CompanyID,
		ChildCompanyID,
		AccountID,
		(SELECT count(*) FROM Ratemanagement3.tblAccount a WHERE a.CompanyId=ChildCompanyID AND a.IsCustomer=1 AND a.`Status`=1) as TotalAccount		
	FROM Ratemanagement3.tblReseller WHERE CompanyID =p_CompanyID 
		AND Status=1
	HAVING TotalAccount > 0;
	  
	 
 		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_resellers);
	 
		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_ResellerID_ = (SELECT ResellerID FROM tmp_resellers t WHERE t.RowID = v_pointer_);
			SET v_ResellerAccountName_ = (SELECT AccountName FROM Ratemanagement3.tblAccount WHERE AccountID=(SELECT AccountID FROM tmp_resellers t WHERE t.RowID = v_pointer_));
			
			INSERT INTO tmp_allaccounts_
			SELECT 
			  tr.ResellerID,
			  tr.ChildCompanyID AS ResellerCompanyID,
			  tr.AccountID AS ResellerAccountID,
			  v_ResellerAccountName_ AS  ResellerAccountName,
			  a.AccountID AS CustomerAccountID,
			  a.AccountName CustomerAccountName
			FROM Ratemanagement3.tblAccount a
			     INNER JOIN tmp_resellers tr
			     ON a.CompanyId = tr.ChildCompanyID
			     AND tr.RowID = v_pointer_
			WHERE a.IsCustomer = 1 AND a.`Status` =1;

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;
		
		/** delete todays reseller cdrs */
		
--		Leave ThisSP;
				
		DELETE ud 
		FROM tblUsageDetailFailedCall  ud
			INNER JOIN tmp_usageheader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN tmp_allaccounts_ ta
				ON uh.AccountID = ta.ResellerAccountID	
		WHERE uh.CompanyGatewayID = p_CompanyGatewayID;
		
		DELETE ud 
		FROM tblUsageDetails  ud
			INNER JOIN tmp_usageheader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN tmp_allaccounts_ ta
				ON uh.AccountID = ta.ResellerAccountID	
		WHERE uh.CompanyGatewayID = p_CompanyGatewayID;
		
		
		/* insert reseller cdrs in temp table */
		
		SET @stm2 = CONCAT('
	    INSERT INTO `' , p_tbltempusagedetail_name , '` (CompanyID,AccountID,ProcessID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountNumber,connect_time,disconnect_time,billed_duration,billed_second,trunk,area_prefix,cli,cld,cost,ServiceID,duration,is_inbound,is_rerated,disposition,userfield)
		SELECT "' , p_CompanyID , '" as CompanyID,ta.ResellerAccountID as `AccountID`,"' ,p_ProcessID ,'" as ProcessID,uh.CompanyGatewayID,uh.GatewayAccountPKID,uh.GatewayAccountID,uh.GatewayAccountID as AccountNumber,ud.connect_time,ud.disconnect_time,ud.billed_duration,ud.billed_second,"Other" as `trunk`,"Other" as `area_prefix`,ud.cli,ud.cld,ud.cost,uh.ServiceID,ud.duration,ud.is_inbound,0 as `is_rerated`,ud.disposition,ud.userfield
		FROM tblUsageDetails  ud
			INNER JOIN tmp_usageheader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN tmp_allaccounts_ ta
				ON uh.AccountID = ta.CustomerAccountID	
		WHERE uh.CompanyGatewayID = "',p_CompanyGatewayID,'";
		');

		PREPARE stmt2 FROM @stm2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;

		SET @stm3 = CONCAT('
		INSERT INTO `' , p_tbltempusagedetail_name , '` (CompanyID,AccountID,ProcessID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountNumber,connect_time,disconnect_time,billed_duration,billed_second,trunk,area_prefix,cli,cld,cost,ServiceID,duration,is_inbound,is_rerated,disposition,userfield)		
		SELECT "' , p_CompanyID , '" as CompanyID,tb.ResellerAccountID as `AccountID`,' ,p_ProcessID ,' as ProcessID,uh.CompanyGatewayID,uh.GatewayAccountPKID,uh.GatewayAccountID,uh.GatewayAccountID as AccountNumber,ud.connect_time,ud.disconnect_time,ud.billed_duration,ud.billed_second,"Other" as `trunk`,"Other" as `area_prefix`,ud.cli,ud.cld,ud.cost,uh.ServiceID,ud.duration,ud.is_inbound,0 as `is_rerated`,ud.disposition,ud.userfield 
		FROM tblUsageDetailFailedCall  ud
			INNER JOIN tblUsageHeader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN tmp_allaccounts_ tb
				ON uh.AccountID = tb.CustomerAccountID	
		WHERE uh.CompanyGatewayID ="',p_CompanyGatewayID,'";	
		');

		PREPARE stmt3 FROM @stm3;
		EXECUTE stmt3;
		DEALLOCATE PREPARE stmt3;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_InvoiceManagementReport`;
DELIMITER //
CREATE PROCEDURE `prc_InvoiceManagementReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME


)
BEGIN

	DECLARE v_ShowZeroCall_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	
	SELECT tblInvoiceTemplate.ShowZeroCall INTO v_ShowZeroCall_ 
	FROM Ratemanagement3.tblAccountBilling  
	INNER JOIN Ratemanagement3.tblBillingClass ON tblBillingClass.BillingClassID = tblAccountBilling.BillingClassID
	INNER JOIN RMBilling3.tblInvoiceTemplate ON tblInvoiceTemplate.InvoiceTemplateID = tblBillingClass.InvoiceTemplateID
	WHERE AccountID = p_AccountID
	LIMIT 1;
	
	SET v_ShowZeroCall_ = IFNULL(v_ShowZeroCall_,1);
	
	SELECT 
		cli as col1,
		cld as col2,
		ROUND(billed_duration/60) as col3,
		cost as col4
	FROM tblUsageDetails  ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND StartDate BETWEEN p_StartDate AND p_EndDate
	AND ((v_ShowZeroCall_ =0 AND ud.cost >0 ) OR (v_ShowZeroCall_ =1 AND ud.cost >= 0))
	ORDER BY billed_duration DESC LIMIT 10;

	
	SELECT 
		cli as col1,
		cld as col2,
		ROUND(billed_duration/60) as col3,
		cost as col4
	FROM tblUsageDetails  ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND StartDate BETWEEN p_StartDate AND p_EndDate
	AND ((v_ShowZeroCall_ =0 AND ud.cost >0 ) OR (v_ShowZeroCall_ =1 AND ud.cost >= 0))
	ORDER BY cost DESC LIMIT 10;

	
	SELECT 
		cld as col1,
		count(*) AS col2,
		ROUND(SUM(billed_duration)/60) AS col3,
		SUM(cost) AS col4
	FROM tblUsageDetails  ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND StartDate BETWEEN p_StartDate AND p_EndDate
	AND ((v_ShowZeroCall_ =0 AND ud.cost >0 ) OR (v_ShowZeroCall_ =1 AND ud.cost >= 0))
	GROUP BY cld
	ORDER BY col2 DESC
	LIMIT 10;

	
	SELECT 
		DATE(StartDate) as col1,
		count(*) AS col2,
		ROUND(SUM(billed_duration)/60) AS col3,
		SUM(cost) AS col4
	FROM tblUsageDetails  ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND StartDate BETWEEN p_StartDate AND p_EndDate
	AND ((v_ShowZeroCall_ =0 AND ud.cost >0 ) OR (v_ShowZeroCall_ =1 AND ud.cost >= 0))
	GROUP BY StartDate
	ORDER BY StartDate;

		
	SELECT
		(SELECT Description
		FROM Ratemanagement3.tblRate r
		WHERE  r.Code = ud.area_prefix limit 1 )
		AS col1,
		COUNT(UsageDetailID) AS col2,
		CONCAT( FLOOR(SUM(billed_duration ) / 60),':' , SUM(billed_duration ) % 60) AS col3,
		SUM(cost) AS col4
	FROM tblUsageDetails  ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND StartDate BETWEEN p_StartDate AND p_EndDate
	AND ((v_ShowZeroCall_ =0 AND ud.cost >0 ) OR (v_ShowZeroCall_ =1 AND ud.cost >= 0))
	GROUP BY col1;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_reseller_insertCDR`;
DELIMITER //
CREATE PROCEDURE `prc_reseller_insertCDR`(
	IN `p_processId` varchar(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	SET @stm2 = CONCAT('
	INSERT INTO   tblUsageHeader (CompanyID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountID,StartDate,created_at,ServiceID)
	SELECT DISTINCT d.CompanyID,d.CompanyGatewayID,d.GatewayAccountPKID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW(),d.ServiceID
	FROM `' , p_tbltempusagedetail_name , '` d
	LEFT JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		AND h.AccountID = d.AccountID
	WHERE h.GatewayAccountID IS NULL AND processid = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET @stm3 = CONCAT('
	INSERT INTO tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		AND h.AccountID = d.AccountID
	WHERE   processid = "' , p_processId , '"
		AND billed_duration = 0 AND cost = 0 AND ( disposition <> "ANSWERED" OR disposition IS NULL);

	');

	PREPARE stmt3 FROM @stm3;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SET @stm4 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  AND billed_duration = 0 AND cost = 0 AND ( disposition <> "ANSWERED" OR disposition IS NULL);
	');

	PREPARE stmt4 FROM @stm4;
	EXECUTE stmt4;
	DEALLOCATE PREPARE stmt4;

	SET @stm5 = CONCAT('
	INSERT INTO tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		AND h.AccountID = d.AccountID
	WHERE   processid = "' , p_processId , '" ;
	');

	PREPARE stmt5 FROM @stm5;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;

	SET @stm6 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stmt6 FROM @stm6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_RetailMonitorCalls`;
DELIMITER //
CREATE PROCEDURE `prc_RetailMonitorCalls`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Type` VARCHAR(50)



)
BEGIN

	DECLARE v_raccountids TEXT;
	SET v_raccountids ='';
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM Ratemanagement3.tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM Ratemanagement3.tblReseller WHERE ResellerID=p_ResellerID;
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;
		
	END IF;
	
		
	IF p_Type = 'call_duraition'
	THEN

		SELECT 
			cli,
			cld,
			billed_duration  
		FROM tblUsageDetails  ud
		INNER JOIN tblUsageHeader uh
			ON uh.UsageHeaderID = ud.UsageHeaderID
		WHERE uh.CompanyID = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND StartDate BETWEEN p_StartDate AND p_EndDate
		AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0)
		ORDER BY billed_duration DESC LIMIT 10;

	END IF;

		
	IF p_Type = 'call_cost'
	THEN

		SELECT 
			cli,
			cld,
			cost,
			billed_duration
		FROM tblUsageDetails  ud
		INNER JOIN tblUsageHeader uh
			ON uh.UsageHeaderID = ud.UsageHeaderID
		WHERE uh.CompanyID = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND StartDate BETWEEN p_StartDate AND p_EndDate
		AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0)
		ORDER BY cost DESC LIMIT 10;

	END IF;
	
	
	IF p_Type = 'most_dialed'
	THEN

		SELECT 
			cld,
			count(*) AS dail_count,
			SUM(billed_duration) AS billed_duration
		FROM tblUsageDetails  ud
		INNER JOIN tblUsageHeader uh
			ON uh.UsageHeaderID = ud.UsageHeaderID
		WHERE uh.CompanyID = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND StartDate BETWEEN p_StartDate AND p_EndDate
		AND (p_ResellerID = 0 OR FIND_IN_SET(uh.AccountID, v_raccountids) != 0)
		GROUP BY cld
		ORDER BY dail_count DESC
		LIMIT 10;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_updateSippyCustomerSetupTime`;
DELIMITER //
CREATE PROCEDURE `prc_updateSippyCustomerSetupTime`(
	IN `p_ProcessID` INT,
	IN `p_customertable` VARCHAR(50),
	IN `p_vendortable` VARCHAR(50)


)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	-- for sippy update connect_time from vendor (setup time)  cdr to customer cdr

	SET @stmt = CONCAT('
	UPDATE `' , p_customertable , '` cd
	INNER JOIN  `' , p_vendortable , '` vd ON cd.ID = vd.ID
		SET cd.connect_time = vd.connect_time
	WHERE cd.ProcessID =  "' , p_ProcessID , '"
		AND vd.ProcessID =  "' , p_ProcessID , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	-- return no of rows updated
	select FOUND_ROWS() as rows_updated;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;
	
Use `StagingReport`;	

ALTER TABLE `tblHeader`
	DROP INDEX `Unique_key`,
	ADD UNIQUE INDEX `Unique_key` (`DateID`, `AccountID`, `CompanyID`);

DROP PROCEDURE IF EXISTS `fnGetUsageForSummary`;
DELIMITER //
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
		extension,
		ID
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
		extension,
		ID
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = ' , p_CompanyID , '
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
		extension,
		ID
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
		extension,
		ID
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

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `fnUsageSummary`;
DELIMITER //
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
	IN `p_CDRType` VARCHAR(50),
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT,
	IN `p_Detail` INT

,
	IN `p_ResellerID` INT

)
BEGIN
	DECLARE v_TimeId_ INT;
	DECLARE v_raccountids TEXT;
	SET v_raccountids ='';
	
	IF p_ResellerID > 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_reselleraccounts_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reselleraccounts_(
			AccountID int
		);
	
		INSERT INTO tmp_reselleraccounts_
		SELECT AccountID FROM Ratemanagement3.tblAccountDetails WHERE ResellerOwner=p_ResellerID
		UNION
		SELECT AccountID FROM Ratemanagement3.tblReseller WHERE ResellerID=p_ResellerID;
	
		SELECT IFNULL(GROUP_CONCAT(AccountID),'') INTO v_raccountids FROM tmp_reselleraccounts_;
		
	END IF;
	

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
				`userfield` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',				
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalCost` DOUBLE NULL DEFAULT NULL,
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
			us.userfield,
			us.CountryID,
			us.TotalCharges,
			us.TotalCost,
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
		AND (p_CDRType = '' OR us.userfield LIKE CONCAT('%',p_CDRType,'%'))
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_ResellerID = 0 OR FIND_IN_SET(sh.AccountID, v_raccountids) != 0);

		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			us.CompanyGatewayID,
			us.Trunk,
			us.AreaPrefix,
			us.userfield,
			us.CountryID,
			us.TotalCharges,
			us.TotalCost,
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
		AND (p_CDRType = '' OR us.userfield LIKE CONCAT('%',p_CDRType,'%'))
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_ResellerID = 0 OR FIND_IN_SET(sh.AccountID, v_raccountids) != 0);

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
				`userfield` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',				
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalCost` DOUBLE NULL DEFAULT NULL,
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
			usd.userfield,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalCost,
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
		AND (p_CDRType = '' OR usd.userfield LIKE CONCAT('%',p_CDRType,'%'))
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_ResellerID = 0 OR FIND_IN_SET(sh.AccountID, v_raccountids) != 0);

		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			usd.CompanyGatewayID,
			usd.Trunk,
			usd.AreaPrefix,
			usd.userfield,
			usd.CountryID,
			usd.TotalCharges,
			usd.TotalCost,
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
		AND (p_CDRType = '' OR usd.userfield LIKE CONCAT('%',p_CDRType,'%'))
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_ResellerID = 0 OR FIND_IN_SET(sh.AccountID, v_raccountids) != 0);

	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getAccountReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getAccountReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* account by call count */	
	SELECT AccountName ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage,
	MAX(AccountID) as AccountID
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
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,
		FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin
	FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT
			AccountName  as Name,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)` ,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 account by call count */	
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 account by call cost */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 account by call minutes */	
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getACD_ASR_Alert`;
DELIMITER //
CREATE PROCEDURE `prc_getACD_ASR_Alert`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT
)
BEGIN
	
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummaryDetail(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,0,1);

	IF p_AccountID = ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageSummary_ us;
		
	END IF;
	
	IF p_AccountID != ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			AccountID,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountID;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getDescReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getDescReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	/* grid display*/
	IF p_isExport = 0
	THEN

		/* Description by call count */	
			
		SELECT IFNULL(Description,'Other') AS Description ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR,
			FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
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
		END ASC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
		END ASC,
		CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
		END DESC,
		CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
		END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin FROM(
			SELECT IFNULL(Description,'Other') AS Description ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) AS TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) AS ASR,
				ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
				ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
			FROM tmp_tblUsageSummary_ us
			LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
			GROUP BY c.Description
		)tbl;

	END IF;

	/* export data*/
	IF p_isExport = 1
	THEN

		SELECT
			SQL_CALC_FOUND_ROWS IFNULL(Description,'Other') AS Description,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)` ,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description;

	END IF;

	/* chart display*/
	IF p_isExport = 2
	THEN

		/* top 10 Description by call count */
		
		SELECT Description AS ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;

		/* top 10 Description by call cost */
		
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) AS TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;

		/* top 10 Description by call minutes */
		
		SELECT Description AS ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) AS TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) AS ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) AS ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tmp_codes_ c ON c.Code = us.AreaPrefix
		GROUP BY Description HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getDestinationReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getDestinationReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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
		 
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* country by call count */	
		
	SELECT IFNULL(Country,'Other') as Country ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR,
		FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
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
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	

	SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin FROM(
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT
			SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as  Country,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)` ,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 country by call count */	
			
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 country by call cost */	
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 country by call minutes */	
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getGatewayReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getGatewayReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* CompanyGatewayID by call count */	
		
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage,
		CompanyGatewayID
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
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT
			fnGetCompanyGatewayName(CompanyGatewayID)  as Name,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)`,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 CompanyGatewayID by call count */	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call cost */	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 CompanyGatewayID by call minutes */	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getHourlyReport`;
DELIMITER //
CREATE PROCEDURE `prc_getHourlyReport`(
	IN `p_CompanyID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_CDRType` VARCHAR(50)


)
BEGIN
	
	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_StartDate,p_EndDate,'','',0,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);
	
	/* total cost */
	SELECT ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_;
	
	/* cost per hour*/
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	/* total duration or minutes*/
	SELECT ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes FROM tmp_tblUsageSummary_;
	
	/* minutes pre hour*/
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalBilledDuration),0) / 60,0) as TotalMinutes FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getPrefixReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getPrefixReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* AreaPrefix by call count */	
		
	SELECT AreaPrefix ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
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
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT
			AreaPrefix,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)` ,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 AreaPrefix by call count */	
			
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call cost */	
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 AreaPrefix by call minutes */	
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getReportByTime`;
DELIMITER //
CREATE PROCEDURE `prc_getReportByTime`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_ReportType` INT







)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE V_Detail INT;

	SET V_Detail = 2;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,V_Detail,p_ResellerID);

	/* hourly report */
	IF p_ReportType =1
	THEN
	
		SELECT 
			CONCAT(dt.hour,' Hour') as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY  us.DateID,dt.hour;

	END IF;

	/* daily report */
	IF p_ReportType =2
	THEN

		SELECT 
			dd.date as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  us.DateID;
	END IF;

	/* weekly report */
	IF p_ReportType =3
	THEN

		SELECT 
			ANY_VALUE(dd.week_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.week_of_year
		ORDER BY dd.year,dd.week_of_year;

	END IF;

	/* monthly report */
	IF p_ReportType =4
	THEN

		SELECT 
			ANY_VALUE(dd.month_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.month_of_year
		ORDER BY dd.year,dd.month_of_year;

	END IF;

	/* queterly report */
	IF p_ReportType =5
	THEN

		SELECT 
			CONCAT('Q-',ANY_VALUE(dd.quarter_year_name)) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.quarter_of_year
		ORDER BY dd.year,dd.quarter_of_year;

	END IF;

	/* yearly report */
	IF p_ReportType =6
	THEN

		SELECT 
			dd.year as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getReportHistory`;
DELIMITER //
CREATE PROCEDURE `prc_getReportHistory`(
	IN `p_CompanyID` INT,
	IN `p_ReportScheduleID` INT,
	IN `p_ReportID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_SearchText` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT

)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT
			tblReportSchedule.Name,
			tblReportScheduleLog.send_at,
			AccountEmailLog.Subject,
			AccountEmailLog.Message,
			AccountEmailLog.AttachmentPaths,
			AccountEmailLog.AccountEmailLogID
		FROM tblReportSchedule
		INNER JOIN tblReportScheduleLog 
			ON tblReportSchedule.ReportScheduleID = tblReportScheduleLog.ReportScheduleID
		INNER JOIN Ratemanagement3.AccountEmailLog 
			ON tblReportScheduleLog.AccountEmailLogID = AccountEmailLog.AccountEmailLogID
		WHERE tblReportSchedule.CompanyID = p_CompanyID
			AND (p_ReportScheduleID = 0 OR tblReportSchedule.ReportScheduleID = p_ReportScheduleID)
			AND (p_ReportID = 0 OR tblReportSchedule.ReportID = p_ReportID)
			AND tblReportScheduleLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblReportSchedule.Name LIKE CONCAT('%',p_SearchText,'%'))
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageDESC') THEN tblReportSchedule.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageASC') THEN tblReportSchedule.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblReportScheduleLog.send_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblReportScheduleLog.send_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(tblReportScheduleLog.ReportScheduleLogID) as totalcount
		FROM tblReportSchedule
		INNER JOIN tblReportScheduleLog 
			ON tblReportSchedule.ReportScheduleID = tblReportScheduleLog.ReportScheduleID
		WHERE CompanyID = p_CompanyID
			AND (p_ReportScheduleID = 0 OR tblReportSchedule.ReportScheduleID = p_ReportScheduleID)
			AND (p_ReportID = 0 OR tblReportSchedule.ReportID = p_ReportID)
			AND tblReportScheduleLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblReportSchedule.Name LIKE CONCAT('%',p_SearchText,'%'));
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			tblReportSchedule.Name,
			tblReportScheduleLog.send_at
		FROM tblReportSchedule
		INNER JOIN tblReportScheduleLog 
			ON tblReportSchedule.ReportScheduleID = tblReportScheduleLog.ReportScheduleID
		WHERE CompanyID = p_CompanyID
			AND (p_ReportScheduleID = 0 OR tblReportSchedule.ReportScheduleID = p_ReportScheduleID)
			AND (p_ReportID = 0 OR tblReportSchedule.ReportID = p_ReportID)
			AND tblReportScheduleLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblReportSchedule.Name LIKE CONCAT('%',p_SearchText,'%'));
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getTrunkReportAll`;
DELIMITER //
CREATE PROCEDURE `prc_getTrunkReportAll`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
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
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	
	/* grid display*/
	IF p_isExport = 0
	THEN
	
	/* Trunk by call count */	
		
	SELECT Trunk ,FORMAT(SUM(NoOfCalls),0) AS CallCount,FORMAT(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalSeconds,FORMAT(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,	
		FORMAT(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		FORMAT( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
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
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMarginASC') THEN ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageDESC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MarginPercentageASC') THEN ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_)
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,FORMAT(SUM(CallCount),0) AS TotalCall,FORMAT(SUM(TotalSeconds)/60,0) AS TotalDuration,FORMAT(SUM(TotalCost),v_Round_) AS TotalCost,FORMAT(SUM(TotalMargin),v_Round_) AS TotalMargin FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	/* export data*/
	IF p_isExport = 1
	THEN
		SELECT
			Trunk,
			SUM(NoOfCalls) AS `No. of Calls`,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as `Billed Duration (Min.)`,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as `Charged Amount`,
			IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as `ACD (mm:ss)` ,
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as `ASR (%)`,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as `Margin`,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as `Margin (%)`
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	/* chart display*/
	IF p_isExport = 2
	THEN
	
		/* top 10 Trunk by call count */	
			
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
		/* top 10 Trunk by call cost */	
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
		/* top 10 Trunk by call minutes */	
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
			ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getWorldMap`;
DELIMITER //
CREATE PROCEDURE `prc_getWorldMap`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_ResellerID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_CDRType` VARCHAR(50),
	IN `p_UserID` INT,
	IN `p_isAdmin` INT





)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnGetCountry();

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_CDRType,p_UserID,p_isAdmin,2,p_ResellerID);

	/* get all country call counts*/
	SELECT 
		Country,
		SUM(NoOfCalls) AS CallCount,
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,
		IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD,
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		ROUND(COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0), v_Round_) as TotalMargin,
		ROUND( (COALESCE(SUM(TotalCharges),0) - COALESCE(SUM(TotalCost),0)) / SUM(TotalCharges)*100, v_Round_) as MarginPercentage,
		MAX(ISO2) AS ISO_Code,
		tblCountry.CountryID
	FROM tmp_tblUsageSummary_
	INNER JOIN temptblCountry AS tblCountry 
		ON tblCountry.CountryID = tmp_tblUsageSummary_.CountryID
	GROUP BY Country,tblCountry.CountryID 
	HAVING SUM(NoOfCalls) > 0
	ORDER BY CallCount DESC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_verifySummary`;
DELIMITER //
CREATE PROCEDURE `prc_verifySummary`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_verify_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_verify_(
	   AccountID INT,
	   TotalCall INT,
	   TotalCharges decimal(18,6),
	   TotalSecond BIGINT,
	   Summary INT,
	   CDR INT
   );
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	CALL RMBilling3.fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	INSERT INTO tmp_verify_ (AccountID,TotalCall,TotalCharges,TotalSecond,Summary,CDR)
	SELECT p_AccountID,COUNT(*) as TotalCall,SUM(cost) as TotalCost,SUM(billed_duration) as TotalSecond,0,1 FROM RMBilling3.tmp_tblUsageDetails_;
	
	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_StartDate,p_EndDate,'','',0,0,1,1);
	
	INSERT INTO tmp_verify_ (AccountID,TotalCall,TotalCharges,TotalSecond,Summary,CDR)
	SELECT p_AccountID,SUM(NoOfCalls) as TotalCall,SUM(TotalCharges) as TotalCost,SUM(TotalBilledDuration) as TotalSecond,1,0 FROM tmp_tblUsageSummary_;
	
	SELECT * FROM tmp_verify_;

	


END//
DELIMITER ;	