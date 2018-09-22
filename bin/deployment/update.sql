USE `Ratemanagement3`;
set sql_mode='';

INSERT INTO `tblEmailTemplate` (`CompanyID`, `LanguageID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES (1, 43, 'AccountBalanceEmailReminder', '{{AccountName}} - Account Balance', '<p>Please find below your account balance details.</p><p>{{AccountBalance}}</p>', '2018-05-22 16:42:31', 'Vasim Seta', '2018-05-23 16:20:17', 'Vasim Seta', NULL, 0, '', 1, 'AccountBalanceEmailReminder', 1, 1, 0);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `LanguageID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES (1, 43, 'Credit Note Send', 'New credit note {{CreditNotesNumber}} from {{CompanyName}} ', 'Hi {{AccountName}},<br><br>\r\n\r\n\r\n{{CompanyName}} has sent you an credit note of {{CreditnotesGrandTotal}} {{Currency}}, \r\nto download copy of your credit note please click the below link. <br><br>\r\n\r\n\r\n<div>\r\n<!--[if mso]>\r\n<v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="{{CreditNotesLink}}" style="height:30px;v-text-anchor:middle;width:100px;" arcsize="10%" strokecolor="#ff9600" fillcolor="#ff9600">\r\n <w:anchorlock/>\r\n <center style="color:#ffffff;font-family:sans-serif;font-size:13px;font-weight:bold;">View CreditNote</center>\r\n </v:roundrect>\r\n<![endif]--> \r\n<!--[if !mso]><!-- ><![endif]--> \r\n\r\n<a href="{{CreditNotesLink}}" style="background-color:#ff9600;border:2px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{CreditNotesLink}}">View CreditNote</a>\r\n</div>\r\n<br><br>\r\n\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}\r\n<br>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-04-17 11:15:19', 'Sumera Saeed', NULL, 5, 'sumera.staging@code-desk.com', 1, 'CreditNotesSingleSend', 1, 1, 0);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `LanguageID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES (1, 43, 'PBX Account Block Email', '{{AccountName}} - PBX Account Status Changed', '<p>Hi<br></p><p>Account&nbsp; Current Status is {{AccountBlocked}}.</p><p>Regards,</p><p>{{CompanyName}}<br></p>', '2018-05-22 16:42:31', 'System', '2018-05-28 15:38:59', 'System', NULL, 0, '', 1, 'PBXAccountBlockEmail', 1, 0, 0);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `LanguageID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES (1, 43, 'PBX Account UnBlock Email', '{{AccountName}} - PBX Account Status Changed', '<p>Hi<br></p><p>Account&nbsp; Current Status is {{AccountBlocked}}.</p><p>Regards,</p><p>{{CompanyName}}<br></p>', '2018-05-22 16:42:31', 'System', '2018-05-28 15:38:59', 'System', NULL, 0, '', 1, 'PBXAccountUnBlockEmail', 1, 0, 0);

ALTER TABLE `tblAccountBilling`	ADD COLUMN `AutoPayMethod` INT(11) NULL DEFAULT '0' AFTER `AutoPaymentSetting`;
ALTER TABLE `tblAccountBilling` ADD COLUMN `ServiceBilling` INT(11) NULL DEFAULT '0' AFTER `AutoPayMethod`;

ALTER TABLE `tblBillingClass` ADD COLUMN `DeductCallChargeInAdvance` TINYINT(1) NULL DEFAULT '0' AFTER `SendInvoiceSetting`;
ALTER TABLE `tblBillingClass` ADD COLUMN `SuspendAccount` TINYINT(1) NULL DEFAULT '0' AFTER `DeductCallChargeInAdvance`;
ALTER TABLE `tblBillingClass` 
	ADD COLUMN `AutoPaymentSetting` VARCHAR(50) NULL DEFAULT NULL AFTER `SuspendAccount`,	
	ADD COLUMN `AutoPayMethod` INT(11) NULL DEFAULT '0' AFTER `AutoPaymentSetting`;
ALTER TABLE `tblBillingClass`
	ADD COLUMN `BalanceWarningStatus` TINYINT(4) NULL DEFAULT NULL AFTER `LowBalanceReminderSettings`,
	ADD COLUMN `BalanceWarningSettings` VARCHAR(5000) NULL DEFAULT NULL AFTER `BalanceWarningStatus`;

INSERT INTO `tblIntegration` (`IntegrationID`, `CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (25, 1, 'MerchantWarrior', 'merchantwarrior', 4, 'N');
INSERT INTO `tblIntegration` (`IntegrationID`, `CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (26, 1, 'Quickbook Desktop', 'quickbookdesktop', 15, 'N');

INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (15, 'Sippy SQL', 'SippySQL', '1', 'RateManagementSystem', '2018-06-07 16:59:07', NULL, '2018-06-07 16:59:10');
INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (16, 'Voip.ms', 'VoipMS', 1, 'RateManagementSystem', '2018-06-21 16:59:07', NULL, '2018-06-21 16:59:10');

INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Database Server', 'dbserver', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Database Name', 'dbname', 1, '2018-06-15 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Database User Name', 'username', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Database Password', 'password', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Authentication Rule', 'NameFormat', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Billing Time', 'BillingTime', 1, '2018-08-13 07:58:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'CDR ReRate', 'RateCDR', 1, '2018-12-21 11:19:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Rate Format', 'RateFormat', 1, '2018-12-21 11:19:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'CLI Translation Rule', 'CLITranslationRule', 1, '2018-05-29 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2018-05-29 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2018-05-29 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'Allow Account Import', 'AllowAccountImport', 1, '2018-05-29 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'API Url', 'api_url', 1, '2017-10-13 17:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'API User', 'api_username', 1, '2017-10-13 17:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (15, 'API Password', 'api_password', 1, '2017-10-13 17:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'API Url', 'api_url', 1, '2018-06-21 15:38:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'API Username', 'username', 1, '2018-06-21 15:38:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'API Password', 'password', 1, '2018-06-21 15:38:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'Authentication Rule', 'NameFormat', 1, '2018-06-21 07:46:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'Billing Time', 'BillingTime', 1, '2018-06-21 07:58:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'CDR ReRate', 'RateCDR', 1, '2018-06-21 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'Rate Format', 'RateFormat', 1, '2018-06-21 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'Allow Account Import', 'AllowAccountImport', 1, '2018-06-21 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'CLI Translation Rule', 'CLITranslationRule', 1, '2018-06-21 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2018-06-21 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (16, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2018-06-21 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (6, 'Database Server', 'dbserver', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (6, 'Database Name', 'dbname', 1, '2018-06-15 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (6, 'Database User Name', 'dbusername', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (6, 'Database Password', 'dbpassword', 1, '2018-05-29 13:06:00', NULL, NULL, NULL);

UPDATE tblGatewayConfig SET Name='dbpassword' WHERE GatewayID=15 and Name='password';
UPDATE tblGatewayConfig SET Name='dbusername' WHERE GatewayID=15 and Name='username';

INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 15, 'Download SippySQL CDR', 'sippysqlaccountusage', '[[{"title":"SippySQL Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2018-06-08 06:25:14', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, NULL, 'Process Call Charges', 'processcallcharges', '[[{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, NULL, NULL);
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 16, 'Download Voip.MS CDR', 'voipmsaccountusage', '[[{"title":"Voip.ms Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2018-06-22 06:25:14', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, NULL, 'Sippy Rate File Status', 'sippyratefilestatus', '[[{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2018-08-01 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 4, 'Import Pbx Payments', 'importpbxpayments', '[[{"title":"Import Days Limit","type":"text","value":"2","name":"importdayslimit"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2016-06-09 19:33:05', NULL);
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`)VALUES (1, 4, 'Export Pbx Payments', 'exportpbxpayments', '[[{"title":"Export Days Limit","type":"text","value":"2","name":"exportdayslimit"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2016-06-09 19:33:05', NULL);
UPDATE tblCronJobCommand SET Title='PBX Account Block' WHERE Title='Mirta Account Block';

ALTER TABLE `tblJobType` ALTER `Code` DROP DEFAULT;
ALTER TABLE `tblJobType` CHANGE COLUMN `Code` `Code` VARCHAR(4) NOT NULL COLLATE 'utf8_unicode_ci' AFTER `JobTypeID`;
INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('RCV', 'Vendor CDR Recalculate', NULL, '2018-07-03 15:17:27', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('QPP', 'QuickBook Payment Post', NULL, '2018-07-06 18:20:26', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('SCRP', 'Sippy Customer Rate Push', NULL, '2018-07-27 18:20:26', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('DR', 'Dispute Bulk Email', NULL, '2018-07-27 18:20:26', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('BDS', 'Bulk Dispute Send', NULL, '2018-09-17 17:33:45', 'System', NULL, NULL);

INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VOIPMS_CRONJOB', '{"MaxInterval":"1440","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');

ALTER TABLE `tblAccountDiscountPlan`
	ADD COLUMN `AccountSubscriptionID` INT(11) NULL DEFAULT '0' AFTER `ServiceID`,
	ADD COLUMN `AccountName` VARCHAR(255) NULL DEFAULT NULL AFTER `AccountSubscriptionID`,
	ADD COLUMN `AccountCLI` VARCHAR(255) NULL DEFAULT NULL AFTER `AccountName`,
	ADD COLUMN `SubscriptionDiscountPlanID` INT NULL DEFAULT '0' AFTER `AccountCLI`;
	
ALTER TABLE `tblAccountDiscountPlanHistory`
	ADD COLUMN `AccountSubscriptionID` INT NULL DEFAULT '0' AFTER `ServiceID`,
	ADD COLUMN `AccountName` VARCHAR(255) NULL DEFAULT NULL AFTER `AccountSubscriptionID`,
	ADD COLUMN `AccountCLI` VARCHAR(50) NULL DEFAULT NULL AFTER `AccountName`,
	ADD COLUMN `SubscriptionDiscountPlanID` INT NULL DEFAULT '0' AFTER `AccountCLI`;	
	
ALTER TABLE `tblAccountDiscountPlan`
	DROP INDEX `AccountID`,
	Add UNIQUE INDEX `AccountID` (`Type`, `AccountID`, `ServiceID`, `AccountSubscriptionID`, `AccountName`, `AccountCLI`, `SubscriptionDiscountPlanID`);	
	
RENAME TABLE `tblRateSheetDetailsArchive` TO `tblRateSheetDetailsArchive__not_in_use`;
RENAME TABLE `tblRateSheetArchive` TO `tblRateSheetArchive__not_in_use`;	


CREATE TABLE IF NOT EXISTS `tblSubscriptionDiscountPlan` (
	`SubscriptionDiscountPlanID` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountID` INT(11) NULL DEFAULT '0',
	`ServiceID` INT(11) NULL DEFAULT '0',
	`AccountSubscriptionID` INT(11) NULL DEFAULT '0',
	`AccountName` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`AccountCLI` VARCHAR(300) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`InboundDiscountPlans` INT(11) NULL DEFAULT '0',
	`OutboundDiscountPlans` INT(11) NULL DEFAULT '0',
	`created_at` DATETIME NULL DEFAULT NULL,
	`updated_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`SubscriptionDiscountPlanID`),
	UNIQUE INDEX `IX_UNIQUE_ACCOUNTCLI` (`AccountCLI`),
	UNIQUE INDEX `IX_UNIQUE_ACCOUNTNAME` (`AccountName`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB;	


CREATE TABLE IF NOT EXISTS `tblRegistarionApiLog` (
  `RegistarionApiLogID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `AccountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequestUrl` text COLLATE utf8_unicode_ci,
  `ApiJson` longtext COLLATE utf8_unicode_ci,
  `PaymentGateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentAmount` float DEFAULT NULL,
  `PaymentStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentResponse` longtext COLLATE utf8_unicode_ci,
  `NeonAccountStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FinalApiResponse` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RegistarionApiLogID`)
) ENGINE=InnoDB COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblTimezones` (
	`TimezonesID` INT(11) NOT NULL AUTO_INCREMENT,
	`Title` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
	`FromTime` VARCHAR(10) NOT NULL COLLATE 'utf8_unicode_ci',
	`ToTime` VARCHAR(10) NOT NULL COLLATE 'utf8_unicode_ci',
	`DaysOfWeek` VARCHAR(100) NOT NULL COLLATE 'utf8_unicode_ci',
	`DaysOfMonth` VARCHAR(100) NOT NULL COLLATE 'utf8_unicode_ci',
	`Months` VARCHAR(100) NOT NULL COLLATE 'utf8_unicode_ci',
	`ApplyIF` VARCHAR(100) NOT NULL COLLATE 'utf8_unicode_ci',
	`Status` TINYINT(4) NOT NULL DEFAULT '1',
	`created_at` DATETIME NOT NULL,
	`created_by` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
	`updated_at` DATETIME NOT NULL,
	`updated_by` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`TimezonesID`),
	UNIQUE INDEX `IX_tblTimezones_Title` (`Title`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

INSERT INTO `tblTimezones` (`TimezonesID`, `Title`, `FromTime`, `ToTime`, `DaysOfWeek`, `DaysOfMonth`, `Months`, `ApplyIF`, `Status`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (1, 'Default', '0:00', '23:59', '', '', '', 'start', 1, '2018-05-22 11:46:21', 'System', '2018-05-29 11:41:57', 'System');

ALTER TABLE `tblVendorRate`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `TrunkID`,
	DROP INDEX `IXUnique_AccountId_TrunkId_RateId_EffectiveDate`,
	ADD UNIQUE INDEX `IXUnique_AccountId_TrunkId_RateId_EffectiveDate` (`AccountId`, `TrunkID`, `TimezonesID`, `RateId`, `EffectiveDate`);

ALTER TABLE `tblRateTableRate`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `RateTableId`,
	DROP INDEX `IX_Unique_RateID_RateTableId_EffectiveDate`,
	ADD UNIQUE INDEX `IX_Unique_RateID_RateTableId_TimezonesID_EffectiveDate` (`RateID`, `RateTableId`, `TimezonesID`, `EffectiveDate`);

ALTER TABLE `tblCustomerRate`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `TrunkID`,
	DROP INDEX `IXUnique_RateId_CustomerId_TrunkId_EffectiveDate`,
	ADD UNIQUE INDEX `IXUnique_RateId_CustomerId_TrunkId_TimezonesID_EffectiveDate` (`RateID`, `CustomerID`, `TrunkID`, `TimezonesID`, `EffectiveDate`);

ALTER TABLE `tblVendorRateArchive`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `TrunkID`;

ALTER TABLE `tblRateTableRateArchive`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `RateTableId`;

ALTER TABLE `tblCustomerRateArchive`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `TrunkID`;

ALTER TABLE `tblTempVendorRate`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `CountryCode`;

ALTER TABLE `tblTempRateTableRate`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `CountryCode`;

ALTER TABLE `tblVendorRateChangeLog`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `TrunkID`;

ALTER TABLE `tblRateTableRateChangeLog`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `RateTableId`;

ALTER TABLE `tblRateSheet`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL DEFAULT '1' AFTER `Level`;

ALTER TABLE `tblTempVendorRate`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblTempRateTableRate`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblVendorRateChangeLog`
	ADD COLUMN `RateN` DECIMAL(18,6) NULL DEFAULT NULL AFTER `Rate`;

ALTER TABLE `tblRateTableRateChangeLog`
	ADD COLUMN `RateN` DECIMAL(18,6) NULL DEFAULT NULL AFTER `Rate`;

ALTER TABLE `tblVendorRate`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblRateTableRate`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblCustomerRate`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblVendorRateArchive`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblRateTableRateArchive`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblCustomerRateArchive`
	ADD COLUMN `RateN` DECIMAL(18,6) NOT NULL DEFAULT '0.000000' AFTER `Rate`;

ALTER TABLE `tblVendorPreference`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL AFTER `TrunkID`,
	DROP INDEX `IX_UniqueAccountId_Pref_RateId_TrunkId`,
	ADD UNIQUE INDEX `IX_UniqueAccountId_Pref_RateId_TrunkId_TimezonesID` (`AccountId`, `Preference`, `RateId`, `TrunkID`, `TimezonesID`),
	DROP INDEX `IX_AccountID_TrunkID_RateID`,
	ADD INDEX `IX_AccountID_TrunkID_TimezonesID_RateID` (`AccountId`, `TrunkID`, `TimezonesID`, `RateId`);

ALTER TABLE `tblVendorBlocking`
	ADD COLUMN `TimezonesID` INT(11) NOT NULL AFTER `TrunkID`,
	DROP INDEX `IX_UniqueAccountId_TrunkId_RateId_CountryId`,
	ADD UNIQUE INDEX `IX_UniqueAccountId_TrunkId_TimezonesID_RateId_CountryId` (`TrunkID`, `TimezonesID`, `RateId`, `CountryId`, `AccountId`),
	DROP INDEX `IX_tblVendorBlocking_CountryId_TrunkID`,
	ADD INDEX `IX_tblVendorBlocking_AccountId_CountryId_TrunkID_TimezonesID` (`AccountId`, `CountryId`, `TrunkID`, `TimezonesID`),
	ADD INDEX `IX_tblVendorBlocking_TimezonesID` (`TimezonesID`);

ALTER TABLE `tblRateTable`
	ADD COLUMN `RoundChargedAmount` INT(11) NULL AFTER `CurrencyID`;

ALTER TABLE `tblRateGenerator`
	ADD COLUMN `Timezones` VARCHAR(50) NULL DEFAULT NULL AFTER `Policy`;

ALTER TABLE `tblRateGenerator`
	ADD COLUMN `IsMerge` TINYINT NULL DEFAULT '0' AFTER `Timezones`,
	ADD COLUMN `TakePrice` TINYINT NULL DEFAULT '0' AFTER `IsMerge`,
	ADD COLUMN `MergeInto` INT NULL DEFAULT NULL AFTER `TakePrice`;

ALTER TABLE `tblTicketGroups`
	ADD COLUMN `GroupEmailPort` SMALLINT(4) NULL DEFAULT NULL AFTER `GroupEmailServer`;

ALTER TABLE `tblTicketGroups`
	ADD COLUMN `GroupEmailIsSSL` TINYINT(1) NULL DEFAULT '0' AFTER `GroupEmailPort`;

INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (10, 'type', 'Type', NULL, NULL, NULL, NULL);


ALTER TABLE `tblTickets`
	CHANGE COLUMN `RequesterCC` `RequesterCC` TEXT NULL DEFAULT NULL COLLATE 'utf8_unicode_ci' AFTER `RequesterName`;


ALTER TABLE `AccountEmailLog`
	ADD COLUMN `CcMessageID` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci' AFTER `MessageID`;	
	
ALTER TABLE `tblDynamicFields`
	ADD COLUMN `ItemTypeID` INT(11) NULL DEFAULT '0' AFTER `updated_by`,
	ADD COLUMN `Minimum` INT(11) NULL DEFAULT '0' AFTER `ItemTypeID`,
	ADD COLUMN `Maximum` INT(11) NULL DEFAULT '0' AFTER `Minimum`,
	ADD COLUMN `DefaultValue` VARCHAR(255) NULL DEFAULT NULL AFTER `Maximum`,
	ADD COLUMN `SelectVal` TEXT NULL AFTER `DefaultValue`;
	
ALTER TABLE `tblCronJob`
	ADD COLUMN `ProcessID` VARCHAR(200) NULL DEFAULT NULL AFTER `CdrBehindDuration`,
	ADD COLUMN `MysqlPID` VARCHAR(200) NULL DEFAULT NULL AFTER `ProcessID`;	

INSERT INTO `tblDynamicFields` (`CompanyID`, `Type`, `FieldDomType`, `FieldName`, `FieldSlug`, `FieldDescription`, `FieldOrder`, `Status`, `created_at`, `created_by`, `updated_at`, `updated_by`, `ItemTypeID`, `Minimum`, `Maximum`, `DefaultValue`, `SelectVal`) VALUES (1, 'account', 'select', 'Pbx Account Status', 'pbxaccountstatus', 'PBX Account Status', 0, 1, '2018-08-25 13:44:18', 'System', NULL, NULL, 0, 0, 0, NULL, NULL);
INSERT INTO `tblDynamicFields` (`CompanyID`, `Type`, `FieldDomType`, `FieldName`, `FieldSlug`, `FieldDescription`, `FieldOrder`, `Status`, `created_at`, `created_by`, `updated_at`, `updated_by`, `ItemTypeID`, `Minimum`, `Maximum`, `DefaultValue`, `SelectVal`) VALUES (1, 'account', 'boolean', 'Auto Block', 'autoblock', 'PBX Auto Block', 0, 1, '2018-08-25 13:46:10', 'System', NULL, NULL, 0, 0, 0, NULL, NULL);


INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1370, 'Disputes.Delete', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1369, 'Leads.Import', 1, 6);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1368, 'AuthenticationRule.Delete', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1367, 'Disputes.Email', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1366, 'Disputes.Send', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1365, 'StockHistory.All', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1364, 'StockHistory.View', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1363, 'DynamicField.All', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1362, 'DynamicField.View', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1361, 'DynamicField.Delete', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1360, 'DynamicField.Edit', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1359, 'DynamicField.Add', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1358, 'ItemType.All', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1357, 'ItemType.View', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1356, 'ItemType.Delete', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1355, 'ItemType.Edit', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1354, 'ItemType.Add', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1353, 'Dynamiclink.All', 1, 9);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1352, 'Dynamiclink.View', 1, 9);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1351, 'Dynamiclink.Delete', 1, 9);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1350, 'Dynamiclink.Edit', 1, 9);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1349, 'Dynamiclink.Add', 1, 9);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1348, 'Analysis.AccountManager', 1, 2);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1347, 'Analysis.Vendor', 1, 2);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1346, 'Analysis.Customer', 1, 2);

INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.import_leads', 'ImportsController.import_leads', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.leads_check_upload', 'ImportsController.leads_check_upload', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.leads_ajaxfilegrid', 'ImportsController.leads_ajaxfilegrid', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.leads_storeTemplate', 'ImportsController.leads_storeTemplate', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.leads_download_sample_excel_file', 'ImportsController.leads_download_sample_excel_file', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dispute.delete', 'DisputeController.delete', 1, 'Sumera Saeed', NULL, '2016-05-23 14:46:01.000', '2016-05-23 14:46:01.000', 1370);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.index', 'AnalysisController.index', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.ajax_datagrid', 'AnalysisController.ajax_datagrid', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.getAnalysisData', 'AnalysisController.getAnalysisData', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.getAnalysisBarData', 'AnalysisController.getAnalysisBarData', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ChartDashboard.getMonitorDashboradCall', 'ChartDashboardController.getMonitorDashboradCall', 1, 'Sumera Khan', NULL, '2017-01-13 07:02:14.000', '2017-01-13 07:02:14.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Translate.datatable_Label', 'TranslateController.datatable_Label', 1, 'Vishal Jagani', NULL, '2018-03-12 08:16:33.000', '2018-03-12 08:16:33.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ChartDashboard.getWorldMap', 'ChartDashboardController.getWorldMap', 1, 'Sumera Khan', NULL, '2016-12-21 05:57:01.000', '2016-12-21 05:57:01.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('VendorAnalysis.index', 'VendorAnalysisController.index', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('VendorAnalysis.ajax_datagrid', 'VendorAnalysisController.ajax_datagrid', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('VendorAnalysis.getAnalysisData', 'VendorAnalysisController.getAnalysisData', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('VendorAnalysis.getAnalysisBarData', 'VendorAnalysisController.getAnalysisBarData', 1, 'Sumera Saeed', NULL, '2016-05-25 11:40:14.000', '2016-05-25 11:40:14.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Translate.datatable_Label', 'TranslateController.datatable_Label', 1, 'Vishal Jagani', NULL, '2018-03-12 08:16:33.000', '2018-03-12 08:16:33.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ChartDashboard.getVendorWorldMap', 'ChartDashboardController.getVendorWorldMap', 1, 'Sumera Khan', NULL, '2016-12-21 05:57:01.000', '2016-12-21 05:57:01.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_leads', 'AnalysisController.get_leads', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_account', 'AnalysisController.get_account', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_account_manager_revenue', 'AnalysisController.get_account_manager_revenue', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_account_manager_margin', 'AnalysisController.get_account_manager_margin', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_account_manager_revenue_report', 'AnalysisController.get_account_manager_revenue_report', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.get_account_manager_margin_report', 'AnalysisController.get_account_manager_margin_report', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.account_revenue_margin', 'AnalysisController.account_revenue_margin', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.getAnalysisManager', 'AnalysisController.getAnalysisManager', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1346);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.getAnalysisManager', 'AnalysisController.getAnalysisManager', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1347);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Analysis.getAnalysisManager', 'AnalysisController.getAnalysisManager', 1, 'Sumera Saeed', NULL, '2017-12-05 06:06:36.000', '2017-12-05 06:06:36.000', 1348);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.index', 'DynamiclinkController.index', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1352);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.*', 'DynamiclinkController.*', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1353);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.ajax_datagrid', 'DynamiclinkController.ajax_datagrid', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1352);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.create', 'DynamiclinkController.create', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1349);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.update', 'DynamiclinkController.update', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1350);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dynamiclink.delete', 'DynamiclinkController.delete', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:00.000', '2018-08-14 13:56:00.000', 1351);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.index', 'ItemTypeController.index', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1357);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.*', 'ItemTypeController.*', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1358);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.ajax_datagrid', 'ItemTypeController.ajax_datagrid', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1357);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.create', 'ItemTypeController.create', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1354);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.update', 'ItemTypeController.update', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1355);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('ItemType.delete', 'ItemTypeController.delete', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1356);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.index', 'DynamicFieldController.index', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1362);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.*', 'DynamicFieldController.*', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1363);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.ajax_datagrid', 'DynamicFieldController.ajax_datagrid', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1362);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.create', 'DynamicFieldController.create', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1359);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.update', 'DynamicFieldController.update', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1360);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('DynamicField.delete', 'DynamicFieldController.delete', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1361);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('StockHistory.index', 'StockHistoryController.index', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1364);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('StockHistory.*', 'StockHistoryController.*', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1365);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('StockHistory.ajax_datagrid', 'StockHistoryController.ajax_datagrid', 1, 'Sumera Khan', NULL, '2018-08-14 13:56:01.000', '2018-08-14 13:56:01.000', 1364);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dispute.disputes_email', 'DisputeController.disputes_email', 1, 'Sumera Khan', NULL, '2018-09-14 10:03:27.000', '2018-09-14 10:03:27.000', 1366);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dispute.send', 'DisputeController.send', 1, 'Sumera Saeed', NULL, '2018-09-14 15:52:32.000', '2018-09-14 15:52:33.000', 1366);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dispute.email', 'DisputeController.email', 1, 'Sumera Saeed', NULL, '2018-09-14 16:10:48.000', '2018-09-14 16:10:50.000', 1367);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Authentication.authenticate_store', 'AuthenticationController.authenticate_store', 1, 'Khurram Saeed', NULL, '2016-02-04 13:12:34.000', '2016-02-04 13:12:34.000', 153);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ( 'Authentication.addIps', 'AuthenticationController.addIps', 1, 'Sumera Saeed', NULL, '2016-06-28 15:01:08.000', '2016-06-28 15:01:08.000', 153);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ( 'Authentication.deleteips', 'AuthenticationController.deleteips', 1, 'Sumera Saeed', NULL, '2016-06-28 15:01:08.000', '2016-06-28 15:01:08.000', 1368);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ( 'Authentication.addclis', 'AuthenticationController.addclis', 1, 'Sumera Saeed', NULL, '2016-07-16 15:42:10.000', '2016-07-16 15:42:10.000', 153);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Authentication.deleteclis', 'AuthenticationController.deleteclis', 1, 'Sumera Saeed', NULL, '2016-07-16 15:42:10.000', '2016-07-16 15:42:10.000', 1368);
INSERT INTO `tblResource` ( `ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ( 'Authentication.addipclis', 'AuthenticationController.addipclis', 1, 'Sumera Saeed', NULL, '2016-07-21 13:00:46.000', '2016-07-21 13:00:46.000', 153);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Imports.import_leads', 'ImportsController.import_leads', 1, 'Sumera Saeed', NULL, '2016-05-19 19:22:44.000', '2016-05-19 19:22:44.000', 1369);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Dispute.delete', 'DisputeController.delete', 1, 'Sumera Saeed', NULL, '2016-05-23 14:46:01.000', '2016-05-23 14:46:01.000', 1370);

UPDATE `Ratemanagement3`.`tblResourceCategories` SET `CategoryGroupID`='3' WHERE  `ResourceCategoryName`='AuthenticationRule.Add';
UPDATE `Ratemanagement3`.`tblResourceCategories` SET `CategoryGroupID`='3' WHERE  `ResourceCategoryName`='AuthenticationRule.View';

CREATE TABLE IF NOT EXISTS `tblDynamiclink` (
	`DynamicLinkID` INT(11) NOT NULL AUTO_INCREMENT,
	`CompanyID` INT(11) NOT NULL DEFAULT '0',
	`Title` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`Link` TEXT NULL COLLATE 'utf8_unicode_ci',
	`Currency` INT(11) NULL DEFAULT NULL,
	`created_at` DATETIME NULL DEFAULT NULL,
	`updated_at` DATETIME NULL DEFAULT NULL,
	`CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`DynamicLinkID`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

USE `RMBilling3`;
set sql_mode='';
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `IgnoreCallCharge` TINYINT(1) NULL DEFAULT '0' AFTER `ManagementReport`;
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `ShowPaymentWidgetInvoice` TINYINT(1) NULL DEFAULT '0' AFTER `IgnoreCallCharge`;
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `DefaultTemplate` INT NULL DEFAULT '0' AFTER `ShowPaymentWidgetInvoice`;
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `FooterDisplayOnlyFirstPage` INT NULL DEFAULT '0' AFTER `DefaultTemplate`;
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `ShowTaxesOnSeparatePage` INT(11) NULL DEFAULT '0' AFTER `FooterDisplayOnlyFirstPage`;	
ALTER TABLE `tblInvoiceTemplate` ADD COLUMN `ShowTotalInMultiCurrency` INT(11) NULL DEFAULT '0' AFTER `ShowTaxesOnSeparatePage`;	

ALTER TABLE `tblInvoiceTemplate`
    ADD COLUMN `CreditNotesNumberPrefix` VARCHAR(50) NULL DEFAULT NULL AFTER `LastEstimateNumber`,
	ADD COLUMN `CreditNotesStartNumber` VARCHAR(50) NULL DEFAULT NULL AFTER `CreditNotesNumberPrefix`,
	ADD COLUMN `LastCreditNotesNumber` BIGINT(20) NULL DEFAULT NULL AFTER `CreditNotesStartNumber`;

ALTER TABLE `tblPayment`
	ADD COLUMN `CreditNotesID` INT(11) NULL DEFAULT '0' AFTER `TransactionID`,
	ADD COLUMN `UsageStartDate` DATE NULL DEFAULT NULL AFTER `CreditNotesID`,
	ADD COLUMN `UsageEndDate` DATE NULL DEFAULT NULL AFTER `UsageStartDate`;
	
ALTER TABLE `tblAccountOneOffCharge`
	CHANGE COLUMN `Qty` `Qty` DECIMAL(18,6) NULL DEFAULT NULL AFTER `Price`;

ALTER TABLE `tblProduct`
	ADD COLUMN `ItemTypeID` INT(11) NULL DEFAULT '0' AFTER `AppliedTo`,
	ADD COLUMN `Buying_price` DECIMAL(18,2) NULL DEFAULT '0.00' AFTER `ItemTypeID`,
	ADD COLUMN `Quantity` INT(11) NULL DEFAULT '0' AFTER `Buying_price`,
	ADD COLUMN `Low_stock_level` INT(11) NULL DEFAULT '0' AFTER `Quantity`,
	ADD COLUMN `Enable_stock` TINYINT(1) NULL DEFAULT '0' AFTER `Low_stock_level`;
	
ALTER TABLE `tblInvoiceTaxRate`
	ADD COLUMN `InvoiceDetailID` INT(11) NOT NULL DEFAULT '0' AFTER `InvoiceID`;

ALTER TABLE `tblInvoiceTaxRate`
 DROP INDEX `IX_InvoiceTaxRateUnique`,
 ADD INDEX `IX_InvoiceTaxRateUnique` (`InvoiceID`, `TaxRateID`, `InvoiceTaxType`);
 
 ALTER TABLE `tblInvoiceTaxRate`
	DROP INDEX `IX_InvoiceTaxRateDetailIDUnique`; 

ALTER TABLE `tblRecurringInvoiceTaxRate`
	DROP INDEX `RecurringInvoiceTaxRateUnique`;
	
ALTER TABLE `tblRecurringInvoiceTaxRate`
	ADD COLUMN `RecurringInvoiceDetailID` INT(11) NOT NULL DEFAULT '0' AFTER `RecurringInvoiceID`;

ALTER TABLE `tblEstimateTaxRate`
	DROP INDEX `IX_EstimateTaxRateUnique`;

ALTER TABLE `tblEstimateTaxRate`
	ADD COLUMN `EstimateDetailID` INT(11) NOT NULL DEFAULT '0' AFTER `EstimateID`;	
	

CREATE TABLE IF NOT EXISTS `tblItemType` (
	`ItemTypeID` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`Active` TINYINT(1) NULL DEFAULT '0',
	`CompanyID` INT(11) NULL DEFAULT '0',
	`created_at` DATETIME NOT NULL,
	`created_by` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`updated_at` DATETIME NULL DEFAULT NULL,
	`updated_by` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`ItemTypeID`),
	UNIQUE INDEX `UI_title` (`title`),
	INDEX `IX_title` (`title`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `tblStockHistory` (
	`StockHistoryID` INT(11) NOT NULL AUTO_INCREMENT,
	`CompanyID` INT(11) NULL DEFAULT '0',
	`ProductID` INT(11) NULL DEFAULT '0',
	`InvoiceID` INT(11) NULL DEFAULT '0',
	`InvoiceNumber` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`Stock` INT(11) NULL DEFAULT '0',
	`Quantity` INT(11) NULL DEFAULT '0',
	`Reason` TEXT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NOT NULL,
	`created_by` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`updated_at` DATETIME NOT NULL,
	`updated_by` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`StockHistoryID`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;
	
CREATE TABLE IF NOT EXISTS `tblProcessCallChargesLog` (
  `LogID` bigint(20) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `ServiceID` int(11) NOT NULL DEFAULT '0',
  `InvoiceDate` date NOT NULL,
  `Description` text COLLATE utf8_unicode_ci,
  `Amount` decimal(18,6) DEFAULT NULL,
  `PaymentStatus` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`LogID`),
  UNIQUE KEY `Unique_IX_AccountID_ServiceID_InvoiceDate` (`AccountID`,`ServiceID`,`InvoiceDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	
CREATE TABLE IF NOT EXISTS `tblTempPBXPaymentDetail` (
	`TempPBXPaymentDetailID` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`ProcessID` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`CompanyID` INT(11) NULL DEFAULT NULL,
	`Note` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`PaymentDate` DATETIME NULL DEFAULT NULL,
	`Amount` DECIMAL(20,5) NULL DEFAULT NULL,
	`GatewayAccountID` VARCHAR(255) NULL DEFAULT NULL COMMENT 'AccountNumber' COLLATE 'utf8_unicode_ci',
	`AccountID` INT(11) NULL DEFAULT NULL,
	`CurrencyID` INT(11) NULL DEFAULT NULL,
	`TransactionID` VARCHAR(155) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`TempPBXPaymentDetailID`)
)COLLATE='utf8_unicode_ci' ENGINE=InnoDB;	

CREATE TABLE IF NOT EXISTS `tblCreditNotes` (
	`CreditNotesID` INT(11) NOT NULL AUTO_INCREMENT,
	`CompanyID` INT(11) NULL DEFAULT NULL,
	`AccountID` INT(11) NULL DEFAULT NULL,
	`Address` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`CreditNotesNumber` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`IssueDate` DATETIME NULL DEFAULT NULL,
	`CurrencyID` INT(11) NULL DEFAULT NULL,
	`CreditNotesType` INT(11) NULL DEFAULT NULL,
	`SubTotal` DECIMAL(18,6) NULL DEFAULT NULL,
	`TotalDiscount` DECIMAL(18,2) NULL DEFAULT '0.00',
	`TaxRateID` INT(11) NULL DEFAULT NULL,
	`TotalTax` DECIMAL(18,6) NULL DEFAULT '0.000000',
	`CreditNotesTotal` DECIMAL(18,6) NULL DEFAULT NULL,
	`GrandTotal` DECIMAL(18,6) NULL DEFAULT NULL,
	`Description` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`Attachment` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`Note` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`Terms` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`CreditNotesStatus` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`PDF` VARCHAR(500) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`UsagePath` VARCHAR(500) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`PreviousBalance` DECIMAL(18,6) NULL DEFAULT NULL,
	`TotalDue` DECIMAL(18,6) NULL DEFAULT NULL,
	`Payment` DECIMAL(18,6) NULL DEFAULT NULL,
	`CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NULL DEFAULT NULL,
	`updated_at` DATETIME NULL DEFAULT NULL,
	`FooterTerm` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`RecurringInvoiceID` INT(11) NULL DEFAULT '0',
	`ProcessID` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`FullCreditNotesNumber` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ServiceID` INT(11) NULL DEFAULT '0',
	`BillingClassID` INT(11) NULL DEFAULT NULL,
	`PaidAmount` DECIMAL(18,6) NULL DEFAULT '0.000000',
	PRIMARY KEY (`CreditNotesID`),
	INDEX `IX_AccountID_Status_CompanyID` (`AccountID`, `CreditNotesStatus`, `CompanyID`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `tblCreditNotesDetail` (
	`CreditNotesDetailID` INT(11) NOT NULL AUTO_INCREMENT,
	`CreditNotesID` INT(11) NOT NULL,
	`ProductID` INT(11) NULL DEFAULT NULL,
	`Description` VARCHAR(250) NOT NULL COLLATE 'utf8_unicode_ci',
	`Price` DECIMAL(18,6) NOT NULL,
	`Qty` INT(11) NULL DEFAULT NULL,
	`Discount` DECIMAL(18,2) NULL DEFAULT NULL,
	`TaxRateID` INT(11) NULL DEFAULT NULL,
	`TaxRateID2` INT(11) NULL DEFAULT NULL,
	`TaxAmount` DECIMAL(18,6) NOT NULL DEFAULT '0.000000',
	`LineTotal` DECIMAL(18,6) NOT NULL,
	`CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NULL DEFAULT NULL,
	`updated_at` DATETIME NULL DEFAULT NULL,
	`ProductType` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`CreditNotesDetailID`)
)COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

CREATE TABLE `tblCreditNotesLog` (
	`CreditNotesLogID` INT(11) NOT NULL AUTO_INCREMENT,
	`CreditNotesID` INT(11) NULL DEFAULT NULL,
	`Note` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`CreditNotesLogStatus` INT(11) NULL DEFAULT NULL,
	`created_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`CreditNotesLogID`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblCreditNotesTaxRate` (
	`CreditNotesTaxRateID` INT(11) NOT NULL AUTO_INCREMENT,
	`CreditNotesID` INT(11) NOT NULL,
	`TaxRateID` INT(11) NOT NULL,
	`CreditNotesDetailID` INT(11) NOT NULL DEFAULT '0',
	`TaxAmount` DECIMAL(18,6) NOT NULL,
	`Title` VARCHAR(500) NOT NULL COLLATE 'utf8_unicode_ci',
	`CreditNotesTaxType` TINYINT(4) NOT NULL DEFAULT '0',
	`CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`CreditNotesTaxRateID`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

USE `RMCDR3`;

ALTER TABLE `tblRetailUsageDetail`
	ALTER `UsageDetailID` DROP DEFAULT;
ALTER TABLE `tblRetailUsageDetail`
	CHANGE COLUMN `UsageDetailID` `UsageDetailID` BIGINT NOT NULL AFTER `RetailUsageDetailID`,
	CHANGE COLUMN `ID` `ID` BIGINT(20) NULL DEFAULT NULL AFTER `UsageDetailID`;
	
USE `Ratemanagement3`;

DROP PROCEDURE IF EXISTS `prc_applyAccountDiscountPlan`;
DELIMITER //
CREATE PROCEDURE `prc_applyAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_processId` INT,
	IN `p_inbound` INT,
	IN `p_ServiceID` INT,
	IN `p_AccountDiscountPlanID` INT,
	IN `p_accountname` INT,
	IN `p_accountcli` INT
)
ThisSP:BEGIN
	
	DECLARE v_DiscountPlanID_ INT;
	DECLARE v_AccountDiscountPlanID_ INT;
	DECLARE v_AccountName_ VARCHAR(255);
	DECLARE v_AccountCLI_ VARCHAR(255);
	DECLARE v_StartDate DATE;
	DECLARE v_EndDate DATE;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		RateID INT,
		Code VARCHAR(50),
		DiscountID INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_discountsecons_;
	CREATE TEMPORARY TABLE tmp_discountsecons_ (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempUsageDetailID INT,
		TotalSecond INT,
		AccountDiscountPlanID INT,
		DiscountID INT,
		RemainingSecond INT,
		Discount INT,
		ThresholdReached INT DEFAULT 0,
		Unlimited INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_discountsecons2_;
	CREATE TEMPORARY TABLE tmp_discountsecons2_ (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempUsageDetailID INT,
		TotalSecond INT,
		AccountDiscountPlanID INT,
		DiscountID INT,
		RemainingSecond INT,
		Discount INT,
		ThresholdReached INT DEFAULT 0,
		Unlimited INT
	);

	/* get discount plan id*/
	SELECT 
		AccountDiscountPlanID,
		DiscountPlanID,
		StartDate,
		EndDate,
		IFNULL(AccountName,''),
		IFNULL(AccountCLI,'')		
	INTO  
		v_AccountDiscountPlanID_,
		v_DiscountPlanID_,
		v_StartDate,
		v_EndDate,
		v_AccountName_,
		v_AccountCLI_
	FROM tblAccountDiscountPlan 
	WHERE AccountID = p_AccountID 
	AND  ServiceID = p_ServiceID
	And  AccountDiscountPlanID = p_AccountDiscountPlanID
	AND  ( (p_inbound = 0 AND Type = 1) OR  (p_inbound = 1 AND Type = 2 ) );
	
		
	IF v_DiscountPlanID_ > 0
	THEN 
		
				/* get codes from discount destination group*/

		INSERT INTO tmp_codes_
		SELECT 
			r.RateID,
			r.Code,
			d.DiscountID
		FROM tblDiscountPlan dp
		INNER JOIN tblDiscount d ON d.DiscountPlanID = dp.DiscountPlanID
		INNER JOIN tblDestinationGroupCode dgc ON dgc.DestinationGroupID = d.DestinationGroupID
		INNER JOIN tblRate r ON r.RateID = dgc.RateID
		WHERE dp.DiscountPlanID = v_DiscountPlanID_;
		
		
				/* get minutes total in cdr table by disconnect time*/

		SET @stm = CONCAT('
		INSERT INTO tmp_discountsecons_ (TempUsageDetailID,TotalSecond,DiscountID)
		SELECT 
			d.TempUsageDetailID,
			@t := IF(@pre_DiscountID = d.DiscountID, @t + TotalSecond,TotalSecond) as TotalSecond,
			@pre_DiscountID := d.DiscountID
		FROM
		(
			SELECT 
				billed_duration as TotalSecond,
				TempUsageDetailID,
				area_prefix,
				DiscountID,
				AccountID
			FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
			INNER JOIN tmp_codes_ c
				ON ud.ProcessID = ' , p_processId , '
				AND ud.is_inbound = ',p_inbound,' 
				AND ud.AccountID = ' , p_AccountID , '
				AND ud.ServiceID = ' , p_ServiceID , '
				AND area_prefix =  c.Code				
				AND (("',p_accountname,'" = 0) OR  ("',p_accountname,'" = 1 AND ud.extension= "',v_AccountName_,'"))
				AND (("',p_accountcli,'" = 0) OR  ("',p_accountname,'" = 1 AND ud.AccountCLI= "',v_AccountCLI_,'"))
				AND DATE(ud.disconnect_time) >= "', v_StartDate ,'"
				AND DATE(ud.disconnect_time) < "',v_EndDate, '"
			ORDER BY c.DiscountID asc , disconnect_time asc
		) d
		CROSS JOIN (SELECT @t := 0) i
		CROSS JOIN (SELECT @pre_DiscountID := 0) j
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
							
						/* update account discount plan id*/

		UPDATE tmp_discountsecons_ SET AccountDiscountPlanID  = v_AccountDiscountPlanID_;

				/* update remaining minutes and discount */
		UPDATE tmp_discountsecons_ d
		INNER JOIN tblAccountDiscountPlan adp 
	 		ON adp.AccountID = p_AccountID AND adp.ServiceID = p_ServiceID
		INNER JOIN tblAccountDiscountScheme adc 
			ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
			AND adc.DiscountID = d.DiscountID 
			AND adp.AccountDiscountPlanID = d.AccountDiscountPlanID
		SET d.RemainingSecond = (adc.Threshold - adc.SecondsUsed),d.Discount=adc.Discount,d.Unlimited = adc.Unlimited;

				/* remove call which cross the threshold */

		UPDATE  tmp_discountsecons_ SET ThresholdReached=1   WHERE Unlimited = 0 AND TotalSecond > RemainingSecond;

				 
		INSERT INTO tmp_discountsecons2_
		SELECT * FROM tmp_discountsecons_;

				/* update call cost which are under threshold */

		SET @stm = CONCAT('
		UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' ud  INNER JOIN
		tmp_discountsecons_ d ON d.TempUsageDetailID = ud.TempUsageDetailID 
		SET cost = (cost - d.Discount*cost/100)
		WHERE ThresholdReached = 0;
		');

		PREPARE stmt FROM @stm;
	 	EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	

				/* update remaining minutes in account discount */

		UPDATE tblAccountDiscountPlan adp 
		INNER JOIN tblAccountDiscountScheme adc 
			ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
		INNER JOIN(
			SELECT 
				MAX(TotalSecond) as SecondsUsed,
				DiscountID,
				AccountDiscountPlanID 
			FROM tmp_discountsecons_
			WHERE ThresholdReached = 0
			GROUP BY DiscountID,AccountDiscountPlanID
		)d 
		ON adc.DiscountID = d.DiscountID
		SET adc.SecondsUsed = adc.SecondsUsed+d.SecondsUsed
		WHERE adp.AccountID = p_AccountID 
		AND adp.ServiceID = p_ServiceID
		AND adp.AccountDiscountPlanID = d.AccountDiscountPlanID;

		/* update call cost which reach threshold and update seconds also*/
		
		SET @stm =CONCAT('
		UPDATE tmp_discountsecons_ d
		INNER JOIN( 
			SELECT MIN(RowID) as RowID  FROM tmp_discountsecons2_ WHERE ThresholdReached = 1
		GROUP BY DiscountID
		) tbl ON tbl.RowID = d.RowID
		INNER JOIN RMCDR3.' , p_tbltempusagedetail_name , ' ud
			ON ud.TempUsageDetailID = d.TempUsageDetailID
		INNER JOIN tblAccountDiscountPlan adp 
		 		ON adp.AccountID = ',p_AccountID,' AND adp.ServiceID = ', p_ServiceID ,'
		INNER JOIN tblAccountDiscountScheme adc 
				ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
				AND adc.DiscountID = d.DiscountID AND d.AccountDiscountPlanID = adp.AccountDiscountPlanID
		SET ud.cost = cost*(TotalSecond - RemainingSecond)/billed_duration,adc.SecondsUsed = adc.SecondsUsed + billed_duration - (TotalSecond - RemainingSecond);
		');

		PREPARE stmt FROM @stm;
	 	EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_ArchiveOldCustomerRate
DROP PROCEDURE IF EXISTS `prc_ArchiveOldCustomerRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldCustomerRate`(
	IN `p_AccountIds` LONGTEXT,
	IN `p_TrunkIds` LONGTEXT,
	IN `p_TimezonesIDs` LONGTEXT,
	IN `p_DeletedBy` VARCHAR(50)
)
ThisSP:BEGIN
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
		AND cr2.TimezonesID = cr.TimezonesID
		AND cr2.RateID = cr.RateID
	SET
		cr.EndDate=NOW()
	WHERE
		(FIND_IN_SET(cr.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(cr.TimezonesID,p_TimezonesIDs) != 0) AND cr.EffectiveDate <= NOW()) AND
		(FIND_IN_SET(cr2.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr2.TrunkID,p_TrunkIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(cr2.TimezonesID,p_TimezonesIDs) != 0) AND cr2.EffectiveDate <= NOW()) AND
		cr.EffectiveDate < cr2.EffectiveDate AND cr.CustomerRateID != cr2.CustomerRateID;

	-- leave ThisSP;
	/*1. Move Rates which EndDate <= now() */

	INSERT INTO tblCustomerRateArchive
	SELECT DISTINCT  null , -- Primary Key column
		`CustomerRateID`,
		`CustomerID`,
		`TrunkID`,
		`TimezonesID`,
		`RateId`,
		`Rate`,
		`RateN`,
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
		FIND_IN_SET(CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(TrunkID,p_TrunkIds) != 0 AND
		(p_TimezonesIDs IS NULL OR FIND_IN_SET(TimezonesID,p_TimezonesIDs) != 0) AND EndDate <= NOW();


	DELETE  cr
	FROM tblCustomerRate cr
	inner join tblCustomerRateArchive cra
	on cr.CustomerRateID = cra.CustomerRateID
	WHERE  FIND_IN_SET(cr.CustomerID,p_AccountIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(cr.TimezonesID,p_TimezonesIDs) != 0);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_ArchiveOldRateTableRate
DROP PROCEDURE IF EXISTS `prc_ArchiveOldRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldRateTableRate`(
	IN `p_RateTableIds` LONGTEXT,
	IN `p_TimezonesIDs` LONGTEXT,
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
		(FIND_IN_SET(rtr.RateTableId,p_RateTableIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(rtr.TimezonesID,p_TimezonesIDs) != 0) AND rtr.EffectiveDate <= NOW()) AND
		(FIND_IN_SET(rtr2.RateTableId,p_RateTableIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(rtr2.TimezonesID,p_TimezonesIDs) != 0) AND rtr2.EffectiveDate <= NOW()) AND
		rtr.EffectiveDate < rtr2.EffectiveDate AND rtr.RateTableRateID != rtr2.RateTableRateID;

	/*1. Move Rates which EndDate <= now() */

	INSERT INTO tblRateTableRateArchive
	SELECT DISTINCT  null , -- Primary Key column
		`RateTableRateID`,
		`RateTableId`,
		`TimezonesID`,
		`RateId`,
		`Rate`,
		`RateN`,
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
	WHERE FIND_IN_SET(RateTableId,p_RateTableIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(TimezonesID,p_TimezonesIDs) != 0) AND EndDate <= NOW();

	/*
	IF (FOUND_ROWS() > 0) THEN
	select concat(FOUND_ROWS() ," Ends Today rates" ) ;
	END IF;
	*/

	DELETE  rtr
	FROM tblRateTableRate rtr
	inner join tblRateTableRateArchive rtra
		on rtr.RateTableRateID = rtra.RateTableRateID
	WHERE  FIND_IN_SET(rtr.RateTableId,p_RateTableIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(rtr.TimezonesID,p_TimezonesIDs) != 0);

	/*  IF (FOUND_ROWS() > 0) THEN
	select concat(FOUND_ROWS() ," sane rate " ) ;
	END IF;
	*/

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_ArchiveOldVendorRate
DROP PROCEDURE IF EXISTS `prc_ArchiveOldVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_ArchiveOldVendorRate`(
	IN `p_AccountIds` LONGTEXT,
	IN `p_TrunkIds` LONGTEXT,
	IN `p_TimezonesIDs` LONGTEXT,
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
							`TimezonesID`,
							`RateId`,
							`Rate`,
							`RateN`,
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
      WHERE  FIND_IN_SET(AccountId,p_AccountIds) != 0 AND FIND_IN_SET(TrunkID,p_TrunkIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(TimezonesID,p_TimezonesIDs) != 0) AND EndDate <= NOW();


/*
     IF (FOUND_ROWS() > 0) THEN
	 	select concat(FOUND_ROWS() ," Ends Today rates" ) ;
	  END IF;
*/



	DELETE  vr
	FROM tblVendorRate vr
   inner join tblVendorRateArchive vra
   on vr.VendorRateID = vra.VendorRateID
	WHERE  FIND_IN_SET(vr.AccountId,p_AccountIds) != 0 AND FIND_IN_SET(vr.TrunkID,p_TrunkIds) != 0 AND (p_TimezonesIDs IS NULL OR FIND_IN_SET(vr.TimezonesID,p_TimezonesIDs) != 0);


	/*  IF (FOUND_ROWS() > 0) THEN
		 select concat(FOUND_ROWS() ," sane rate " ) ;
	 END IF;

	*/

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_BlockVendorCodes
DROP PROCEDURE IF EXISTS `prc_BlockVendorCodes`;
DELIMITER //
CREATE PROCEDURE `prc_BlockVendorCodes`(
	IN `p_companyid` INT ,
	IN `p_AccountId` TEXT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
	IN `p_CountryIDs` TEXT,
	IN `p_Codes` TEXT,
	IN `p_Username` VARCHAR(100),
	IN `p_action` INT,
	IN `p_isCountry` INT,
	IN `p_isAllCountry` INT,
	IN `p_criteria` INT
)
BEGIN


	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



  	IF p_isAllCountry = 1
	THEN
		SELECT GROUP_CONCAT(CountryID) INTO p_CountryIDs  FROM tblCountry;
	END IF;

	IF p_isCountry = 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_codes_(
				Code varchar(20)
		);
	END IF;

   		IF p_criteria = 0 and p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_Codes  = '' OR FIND_IN_SET(tblRate.Code,p_Codes) != 0 );
        END IF;

        IF p_criteria = 1 and p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_Codes  = '' OR Code LIKE REPLACE(p_Codes,'*', '%') );
        END IF;

		IF p_criteria = 2 and p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryIDs  = 0 OR FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 );
        END IF;

		IF p_criteria = 3 and p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID
           WHERE    tblRate.CompanyID = p_companyid;
        END IF;


	IF p_isCountry = 0 AND p_action = 1
   THEN

		INSERT INTO tblVendorBlocking (AccountId,RateId,TrunkID,TimezonesID,BlockedBy)
			SELECT DISTINCT tblVendorRate.AccountID,tblRate.RateID,tblVendorRate.TrunkID,tblVendorRate.TimezonesID,p_Username
			FROM tblVendorRate
			INNER JOIN tblRate ON tblRate.RateID = tblVendorRate.RateId
				AND tblRate.CompanyID = p_companyid
			Inner join tmp_codes_ c on c.Code = tblRate.Code
			LEFT JOIN tblVendorBlocking ON tblVendorBlocking.AccountId = tblVendorRate.AccountId
				AND tblVendorBlocking.RateId = tblRate.RateID
				AND tblVendorBlocking.TrunkID = p_trunkID
				AND tblVendorBlocking.TimezonesID = p_TimezonesID
			WHERE tblVendorBlocking.VendorBlockingId IS NULL
			 AND tblVendorRate.TrunkID = p_trunkID
			 AND tblVendorRate.TimezonesID = p_TimezonesID
			 AND FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0 ;
	END IF;

	IF p_isCountry = 0 AND p_action = 0
	THEN
		DELETE  tblVendorBlocking
	  	FROM      tblVendorBlocking
	  	INNER JOIN tblVendorRate ON tblVendorRate.RateID = tblVendorBlocking.RateId
			AND tblVendorRate.TrunkID =  p_trunkID
			AND tblVendorRate.TimezonesID =  p_TimezonesID
	  	INNER JOIN tblRate ON  tblRate.RateID = tblVendorRate.RateId AND tblRate.CompanyID = p_companyid
	  	Inner join tmp_codes_ c on c.Code = tblRate.Code
		WHERE FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0 ;
	END IF;


	IF p_isCountry = 1 AND p_action = 1
	THEN
		INSERT INTO tblVendorBlocking (AccountId,CountryId,TrunkID,TimezonesID,BlockedBy)
		SELECT DISTINCT tblVendorRate.AccountID,tblRate.CountryID,p_trunkID,p_TimezonesID,p_Username
		FROM tblVendorRate
		INNER JOIN tblRate ON tblVendorRate.RateId = tblRate.RateID
			AND tblRate.CompanyID = p_companyid
			AND  FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0
		LEFT JOIN tblVendorBlocking ON tblVendorBlocking.AccountId = tblVendorRate.AccountID
			AND tblRate.CountryID = tblVendorBlocking.CountryId
			AND tblVendorBlocking.TrunkID = p_trunkID
			AND tblVendorBlocking.TimezonesID = p_TimezonesID
		WHERE tblVendorBlocking.VendorBlockingId IS NULL AND FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.TimezonesID = p_TimezonesID;

	END IF;


	IF p_isCountry = 1 AND p_action = 0
	THEN
		DELETE FROM tblVendorBlocking
		WHERE tblVendorBlocking.TrunkID = p_trunkID AND tblVendorBlocking.TimezonesID = p_TimezonesID AND FIND_IN_SET (tblVendorBlocking.AccountId,p_AccountId) !=0 AND FIND_IN_SET(tblVendorBlocking.CountryID,p_CountryIDs) != 0;
	END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_ChangeCodeDeckRateTable
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
		call prc_ArchiveOldCustomerRate (p_AccountID,p_TrunkID, NULL,p_DeletedBy);
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

-- Dumping structure for procedure Ratemanagement3.prc_checkDialstringAndDupliacteCode
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID`,
		`Code`,
		`Description`,
		`Rate`,
		`RateN`,
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
	SELECT count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl;


	IF  totalduplicatecode > 0
	THEN


		SELECT GROUP_CONCAT(code) into errormessage FROM(
		SELECT DISTINCT code, 1 as a FROM(
		SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl) as tbl2 GROUP by a;

		INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT
		CONCAT(code , ' DUPLICATE CODE')
		FROM(
		SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl;

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

		ON vr.DialStringPrefix = ds.DialString AND ds.DialStringID = p_dialStringId
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
				`TimezonesID`,
				`DialString`,
				CASE WHEN ds.Description IS NULL OR ds.Description = ''
				THEN
				tblTempVendorRate.Description
				ELSE
				ds.Description
				END
				AS Description,
				`Rate`,
				`RateN`,
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
				TimezonesID,
				Code,
				Description,
				Rate,
				RateN,
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
				`TimezonesID`,
				`Code`,
				`Description`,
				`Rate`,
				`RateN`,
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

-- Dumping structure for procedure Ratemanagement3.prc_CronJobAllPending
DROP PROCEDURE IF EXISTS `prc_CronJobAllPending`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobAllPending`(
	IN `p_CompanyID` INT



)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CDR'
		AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
	ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CDR'
		AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID,
	   TBL1.JobLoggedUserID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BI'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BI'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;




	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		tblCronJobCommand.Command,
		tblCronJob.CronJobID
	FROM tblCronJob
	INNER JOIN tblCronJobCommand
		ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
	WHERE tblCronJob.CompanyID = p_CompanyID
	AND tblCronJob.Status = 1
	AND tblCronJob.Active = 0;






	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BIS'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BIS'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'RCC'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'RCC'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;




	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'RCV'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'RCV'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;





	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'INU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'INU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
			AND j.Options like '%"Format":"Rate Sheet"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
			AND j.Options like '%"Format":"Rate Sheet"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BIR'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BIR'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BLE'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BLE'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BAE'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BAE'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VU'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VU'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


    SELECT
    	  "CodeDeckUpload",
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			   @prev_JobLoggedUserID  := j.JobLoggedUserID,
 			   @prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'CDU'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'CDU'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;


    SELECT
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
				@prev_JobLoggedUserID  := j.JobLoggedUserID,
				@prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'IR'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'IR'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;




	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;




	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND (j.Options like '%"Format":"Vos 3.2"%' OR j.Options like '%"Format":"Vos 2.0"%')
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND (j.Options like '%"Format":"Vos 3.2"%' OR j.Options like '%"Format":"Vos 2.0"%')
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND (j.Options like '%"Format":"Vos 3.2"%' OR j.Options like '%"Format":"Vos 2.0"%')
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND (j.Options like '%"Format":"Vos 3.2"%' OR j.Options like '%"Format":"Vos 2.0"%')
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'GRT'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'GRT'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'RTU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'RTU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


    SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VDR'
		AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
	ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VDR'
		AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;




	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'MGA'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'MGA'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'DSU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'DSU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'QIP'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'QIP'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'ICU'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'ICU'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'IU'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'IU'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Mor"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Mor"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Mor"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Mor"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	-- Xero Invoice Post

	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'XIP'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'XIP'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	-- M2 coustomer rate sehet download

	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"M2"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"M2"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	-- M2 vendor rate sehet download

	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"M2"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"M2"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'QPP'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'QPP'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	SELECT
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
				@prev_JobLoggedUserID  := j.JobLoggedUserID,
				@prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'BDS'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'BDS'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;
    
    
    
    
    SELECT
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
				@prev_JobLoggedUserID  := j.JobLoggedUserID,
				@prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'DR'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'DR'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGenerateM2Sheet
DROP PROCEDURE IF EXISTS `prc_CronJobGenerateM2Sheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateM2Sheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

	SELECT DISTINCT
		CONCAT(IF(tblCountry.Country IS NULL,'',CONCAT(tblCountry.Country,' - ')),tmpRate.Description) as `Destination`,
		tmpRate.Code as `Prefix`,
		tmpRate.Rate as `Rate(USD)`,
		tmpRate.ConnectionFee as `Connection Fee(USD)`,
		tmpRate.Interval1 as `Increment`,
		tmpRate.IntervalN as `Minimal Time`,
		'0:00:00 'as `Start Time`,
		'23:59:59' as `End Time`,
		'' as `Week Day`,
		tmpRate.EffectiveDate  as `Effective from`,
		tmpRate.RoutinePlanName as `Routing through`
	FROM
		tmp_customerrateall_ tmpRate
	JOIN
		tblRate ON tblRate.RateID = tmpRate.RateID
	LEFT JOIN
		tblCountry ON tblCountry.CountryID = tblRate.CountryID
	;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGenerateM2VendorSheet
DROP PROCEDURE IF EXISTS `prc_CronJobGenerateM2VendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateM2VendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
        TimezonesID INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `TimezonesID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
								AND tblVendorRate.TimezonesID = p_TimezonesID
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
 	   AND n1.TimezonesID=n2.TimezonesID
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
			CONCAT(IF(tblCountry.Country IS NULL,'',CONCAT(tblCountry.Country,' - ')),tmpRate.Description) as `Destination`,
			tmpRate.Code as `Prefix`,
			tmpRate.Rate as `Rate(USD)`,
			tmpRate.ConnectionFee as `Connection Fee(USD)`,
			tmpRate.Interval1 as `Increment`,
			tmpRate.IntervalN as `Minimal Time`,
			'0:00:00 'as `Start Time`,
			'23:59:59' as `End Time`,
			'' as `Week Day`,
			tmpRate.EffectiveDate  as `Effective from`
		FROM
			tmp_m2rateall_ AS tmpRate
		JOIN
			tblRate ON tblRate.RateID = tmpRate.RateID
		LEFT JOIN
			tblCountry ON tblCountry.CountryID = tblRate.CountryID;

      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGenerateMorSheet
DROP PROCEDURE IF EXISTS `prc_CronJobGenerateMorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateMorSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGenerateMorVendorSheet
DROP PROCEDURE IF EXISTS `prc_CronJobGenerateMorVendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGenerateMorVendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
        TimezonesID INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `TimezonesID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
								AND tblVendorRate.TimezonesID = p_TimezonesID
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
 	   AND n1.TimezonesID = n2.TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGeneratePortaSheet
DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGeneratePortaSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` VARCHAR(200) ,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

	 SELECT distinct
       Code as `Destination` ,
       Description  as `Description`,
       Interval1 as `First Interval`,
       IntervalN as `Next Interval`,
       Abs(Rate) as `First Price` ,
       Abs(RateN) as `Next Price`,
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

-- Dumping structure for procedure Ratemanagement3.prc_CronJobGeneratePortaVendorSheet
DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaVendorSheet`;
DELIMITER //
CREATE PROCEDURE `prc_CronJobGeneratePortaVendorSheet`(
	IN `p_AccountID` INT ,
	IN `p_trunks` VARCHAR(200),
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
        TimezonesID INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        RateN DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `TimezonesID`, `RateId`, `Rate`, `RateN`,
		  DATE_FORMAT (`EffectiveDate`, '%Y-%m-%d') AS EffectiveDate,
		   `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0
								AND tblVendorRate.TimezonesID = p_TimezonesID
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
 	   AND n1.TimezonesID = n2.TimezonesID
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
		RateN float,
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

  	 	call vwVendorArchiveCurrentRates(p_AccountID,p_Trunks,p_TimezonesID,p_Effective);

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
               Abs(tblVendorRate.RateN) as `Next Price`,
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
			 		Abs(vrd.RateN) AS `Next Price`,
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

-- Dumping structure for procedure Ratemanagement3.prc_CustomerBulkRateInsert
DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateInsert`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerBulkRateInsert`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` INT ,
	IN `p_TimezonesID` INT,
	IN `p_CodeDeckId` int,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(200) ,
	IN `p_CountryId` INT ,
	IN `p_CompanyId` INT ,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_RateN` DECIMAL(18,6),
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
		TimezonesID,
		Rate ,
		RateN ,
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
		p_TimezonesID,
		p_Rate ,
		p_RateN ,
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
			FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId AND c.TimezonesID = p_TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_CustomerBulkRateUpdate
DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerBulkRateUpdate`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` INT ,
	IN `p_TimezonesID` INT,
	IN `p_CodeDeckId` int,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(200) ,
	IN `p_CountryId` INT ,
	IN `p_CompanyId` INT ,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_RateN` DECIMAL(18, 6) ,
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
        RateN DECIMAL(18, 6),
        PreviousRate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        CreatedDate DATETIME,
        CreatedBy VARCHAR(50),
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        TrunkID INT,
        TimezonesID INT,
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
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	)
	SELECT
		tblCustomerRate.CustomerRateID,
		tblCustomerRate.RateID,
		tblCustomerRate.CustomerID,
		p_Interval1 AS Interval1,
		p_IntervalN AS IntervalN,
		p_Rate AS Rate,
		p_RateN AS RateN,
		tblCustomerRate.PreviousRate,
		p_ConnectionFee AS ConnectionFee,
		tblCustomerRate.EffectiveDate,
		tblCustomerRate.EndDate,
		tblCustomerRate.CreatedDate,
		tblCustomerRate.CreatedBy,
		NOW() AS LastModifiedDate,
		p_ModifiedBy AS LastModifiedBy,
		tblCustomerRate.TrunkID,
		tblCustomerRate.TimezonesID,
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
			AND c.TimezonesID = p_TimezonesID
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
			n1.TrunkID = n2.TrunkId AND
			n1.TimezonesID = n2.TimezonesID AND
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
	CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_TimezonesID, p_ModifiedBy);

	-- insert rates in tblCustomerRate with updated values
	INSERT INTO tblCustomerRate
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	)
	SELECT
		NULL, -- primary key
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	FROM
		tmp_CustomerRates_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_CustomerRateClear
DROP PROCEDURE IF EXISTS `prc_CustomerRateClear`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateClear`(
	IN `p_AccountIdList` LONGTEXT,
	IN `p_TrunkId` INT,
	IN `p_TimezonesID` INT,
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
			c.TimezonesID = p_TimezonesID AND
			(
				( -- if single or selected rates delete
					p_CustomerRateId IS NOT NULL AND FIND_IN_SET(c.CustomerRateId,p_CustomerRateId) != 0
				)
				OR
				( -- if bulk rates delete
					p_CustomerRateId IS NULL AND
					FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0  AND
					( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%'))) AND
					( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%'))) AND
					( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
				)
			)
	) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID
	SET
		tblCustomerRate.EndDate=NOW();

	CALL prc_ArchiveOldCustomerRate(p_AccountIdList,p_TrunkId,p_TimezonesID,p_ModifiedBy);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_CustomerRateInsert
DROP PROCEDURE IF EXISTS `prc_CustomerRateInsert`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateInsert`(
	IN `p_CompanyId` INT,
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` VARCHAR(100) ,
	IN `p_TimezonesID` INT,
	IN `p_RateIDList` LONGTEXT,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_RateN` DECIMAL(18, 6) ,
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
		TimezonesID,
		Rate ,
		RateN ,
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
		p_TimezonesID,
		p_Rate ,
		p_RateN ,
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
		WHERE FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId AND c.TimezonesID = p_TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_CustomerRateUpdate
DROP PROCEDURE IF EXISTS `prc_CustomerRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_CustomerRateUpdate`(
	IN `p_AccountIdList` LONGTEXT ,
	IN `p_TrunkId` VARCHAR(100) ,
	IN `p_TimezonesID` INT,
	IN `p_CustomerRateIDList` LONGTEXT,
	IN `p_Rate` DECIMAL(18, 6) ,
	IN `p_RateN` DECIMAL(18, 6) ,
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
        RateN DECIMAL(18, 6),
        PreviousRate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        CreatedDate DATETIME,
        CreatedBy VARCHAR(50),
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        TrunkID INT,
        TimezonesID INT,
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
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	)
	SELECT
		cr.CustomerRateID,
		cr.RateID,
		cr.CustomerID,
		p_Interval1 AS Interval1,
		p_IntervalN AS IntervalN,
		p_Rate AS Rate,
		p_RateN AS RateN,
		cr.PreviousRate,
		p_ConnectionFee AS ConnectionFee,
		IFNULL(p_EffectiveDate,cr.EffectiveDate) AS EffectiveDate, -- if p_EffectiveDate null take exiting EffectiveDate
		cr.EndDate,
		cr.CreatedDate,
		cr.CreatedBy,
		NOW() AS LastModifiedDate,
		p_ModifiedBy AS LastModifiedBy,
		cr.TrunkID,
		cr.TimezonesID,
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
		 cr.TimezonesID = p_TimezonesID AND FIND_IN_SET(cr.CustomerRateID,p_CustomerRateIDList) != 0 AND crc.RateID IS NULL;

	-- update EndDate to Archive rates which needs to update
	UPDATE
		tblCustomerRate cr
	JOIN
		tmp_CustomerRates_ temp ON cr.CustomerRateID=temp.CustomerRateID
	SET
		cr.EndDate = NOW();

	-- archive rates which rates' EndDate < NOW()
	CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId, p_TimezonesID, p_ModifiedBy);

	-- insert rates in tblCustomerRate with updated values
	INSERT INTO tblCustomerRate
	(
		CustomerRateID,
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	)
	SELECT
		NULL, -- primary key
		RateID,
		CustomerID,
		Interval1,
		IntervalN,
		Rate,
		RateN,
		PreviousRate,
		ConnectionFee,
		EffectiveDate,
		EndDate,
		CreatedDate,
		CreatedBy,
		LastModifiedDate,
		LastModifiedBy,
		TrunkID,
		TimezonesID,
		RoutinePlan
	FROM
		tmp_CustomerRates_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_deleteArchiveOldRate
DROP PROCEDURE IF EXISTS `prc_deleteArchiveOldRate`;
DELIMITER //
CREATE PROCEDURE `prc_deleteArchiveOldRate`(
	IN `p_CompanyID` INT,
	IN `p_DeleteDate` DATETIME


)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	  
	  DELETE
			tblCustomerRateArchive
	  FROM tblCustomerRateArchive 
	  INNER JOIN tblAccount 
		ON tblAccount.AccountID=tblCustomerRateArchive.AccountId
	  WHERE 
	  tblAccount.CompanyId=p_CompanyID
	  AND tblCustomerRateArchive.EffectiveDate <= p_DeleteDate;

		
	  DELETE
	  		tblVendorRateArchive
	  FROM tblVendorRateArchive 
	  INNER JOIN tblAccount 
		ON tblAccount.AccountID=tblVendorRateArchive.AccountId
	  WHERE
		tblAccount.CompanyId=p_CompanyID
	  AND EffectiveDate <= p_DeleteDate;


	  DELETE
	  		tblRateTableRateArchive
	  FROM tblRateTableRateArchive 
	  INNER JOIN tblRateTable 
	  ON tblRateTable.RateTableId=tblRateTableRateArchive.RateTableId
	  WHERE 
	  tblRateTable.CompanyId=p_CompanyID
	  AND tblRateTableRateArchive.EffectiveDate <= p_DeleteDate;	  	  
	  
	 
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_DeleteDynamicFieldStatus
DROP PROCEDURE IF EXISTS `prc_DeleteDynamicFieldStatus`;
DELIMITER //
CREATE PROCEDURE `prc_DeleteDynamicFieldStatus`(
	IN `d_CompanyID` INT,
	IN `d_user_name` VARCHAR(50),
	IN `d_Type` VARCHAR(50),
	IN `d_FieldName` VARCHAR(50),
	IN `d_FieldDomType` VARCHAR(50),
	IN `d_ItemTypeID` VARCHAR(50),
	IN `d_Status` INT
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	delete tblDynamicFields from tblDynamicFields left join tblDynamicFieldsValue on tblDynamicFieldsValue.DynamicFieldsID = tblDynamicFields.DynamicFieldsID
	where tblDynamicFieldsValue.DynamicFieldsID is null
		AND tblDynamicFields.CompanyID = d_CompanyID
		AND tblDynamicFields.`Type`= d_Type
		AND(d_FieldName = '' OR tblDynamicFields.FieldName like Concat('%',d_FieldName,'%'))
		AND(d_FieldDomType = '' OR tblDynamicFields.FieldDomType like Concat('%',d_FieldDomType,'%'))
      AND(d_Status = 9 OR tblDynamicFields.Status = d_Status)
      ;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_deleteTickets
DROP PROCEDURE IF EXISTS `prc_deleteTickets`;
DELIMITER //
CREATE PROCEDURE `prc_deleteTickets`(
	IN `p_CompanyID` INT,
	IN `p_DeleteDate` DATETIME






)
BEGIN
 	DECLARE p_status INT;
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 	
 	DROP TEMPORARY TABLE IF EXISTS tmp_attachments_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_attachments_(
		attachment LONGTEXT
	);
	  
	  -- get closed StatusID
	  SELECT 
	  		tblTicketfieldsValues.ValuesID INTO p_status 
	  FROM tblTicketfields 
	  INNER JOIN tblTicketfieldsValues 
	 	 	ON tblTicketfields.TicketFieldsID=tblTicketfieldsValues.FieldsID 
	  WHERE tblTicketfields.FieldType='default_status' 
		  AND tblTicketfieldsValues.FieldValueAgent='Closed';
	  
	  
	  DELETE
	  		tblJunkTicketEmail
	  FROM tblJunkTicketEmail 
	  INNER JOIN tblTickets
	  ON tblTickets.TicketID=tblJunkTicketEmail.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND tblTickets.updated_at <= p_DeleteDate;
	  	  
	  DELETE
	  		tblTicketLog
	  FROM tblTicketLog 
	  INNER JOIN tblTickets
	  ON tblTickets.TicketID=tblTicketLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND tblTickets.updated_at <= p_DeleteDate;
	  
	  -- get attachment to delete files later
	  INSERT INTO tmp_attachments_
	  SELECT 
	  tblTicketsDeletedLog.AttachmentPaths
	  FROM tblTicketsDeletedLog
	  INNER JOIN tblTickets
	  	ON tblTickets.TicketID=tblTicketsDeletedLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND tblTicketsDeletedLog.AttachmentPaths!=''
	  AND tblTickets.updated_at <= p_DeleteDate;
	  
	  DELETE
	  		tblTicketsDeletedLog
	  FROM tblTicketsDeletedLog 
	  INNER JOIN tblTickets
	  	ON tblTickets.TicketID=tblTicketsDeletedLog.TicketID
	  WHERE 
	  	tblTickets.CompanyID=p_CompanyID
	  	AND tblTickets.`Status`=p_status
	  	AND tblTickets.updated_at <= p_DeleteDate;
	  
	  
	  	
	  
	  INSERT INTO tmp_attachments_
	  SELECT 
	  AccountEmailLogDeletedLog.AttachmentPaths
	  FROM AccountEmailLogDeletedLog
	  INNER JOIN tblTickets
	  ON tblTickets.TicketID=AccountEmailLogDeletedLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND AccountEmailLogDeletedLog.AttachmentPaths!=''
	  AND tblTickets.updated_at <= p_DeleteDate;
	  
	  DELETE
	  		AccountEmailLogDeletedLog
	  FROM AccountEmailLogDeletedLog 
	  INNER JOIN tblTickets
	  	ON tblTickets.TicketID=AccountEmailLogDeletedLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND tblTickets.updated_at <= p_DeleteDate;
	  
	   
	  
	  INSERT INTO tmp_attachments_
	  SELECT 
	  AccountEmailLog.AttachmentPaths
	  FROM AccountEmailLog
	  INNER JOIN tblTickets
	  	ON tblTickets.TicketID=AccountEmailLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND AccountEmailLog.AttachmentPaths!=''
	  AND tblTickets.updated_at <= p_DeleteDate;
	  	  
	  DELETE
	  		AccountEmailLog
	  FROM AccountEmailLog 
	  INNER JOIN tblTickets
	  	ON tblTickets.TicketID=AccountEmailLog.TicketID
	  WHERE 
	  tblTickets.CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND tblTickets.updated_at <= p_DeleteDate;
	  
	  
	  INSERT INTO tmp_attachments_
	  SELECT
	  		AttachmentPaths
	  FROM tblTickets
	  WHERE 
	  CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND AttachmentPaths!=''
	  AND updated_at <= p_DeleteDate;
	  
	  DELETE 
	  FROM tblTickets
	  WHERE 
	  CompanyID=p_CompanyID
	  AND tblTickets.`Status`=p_status
	  AND updated_at <= p_DeleteDate; 
	  
	  	  
	   
	  SELECT * FROM tmp_attachments_;

		 
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_editpreference
DROP PROCEDURE IF EXISTS `prc_editpreference`;
DELIMITER //
CREATE PROCEDURE `prc_editpreference`(
	IN `p_groupby` VARCHAR(50),
	IN `p_preference` INT,
	IN `p_accountId` INT,
	IN `p_trunk` INT,
	IN `p_TimezonesID` INT,
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
						select DISTINCT RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID = p_TimezonesID AND r.Description = p_description) tbl;


						INSERT INTO tmp_pref1
						select VendorPreferenceID,Preference
						FROM (
						select vp.VendorPreferenceID,vp.Preference
							 from tblVendorPreference vp
							 	 inner join tmp_pref0 tmp0
								   on vp.RateId=tmp0.RateID
						    where vp.AccountId = p_accountId AND vp.TrunkID=p_trunk AND vp.TimezonesID = p_TimezonesID) tbl1;

						select max(Preference) as Preference from tmp_pref1;

				ELSE


					INSERT INTO tmp_pref0
						select DISTINCT RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID = p_TimezonesID AND r.Description = p_description) tbl;

					/* Update preference */
					 UPDATE tblVendorPreference
						INNER JOIN tmp_pref0 temp
							ON tblVendorPreference.RateId = temp.RateID
						SET tblVendorPreference.Preference = p_preference,created_at=NOW(),CreatedBy=p_username
						WHERE tblVendorPreference.AccountId = p_accountId AND tblVendorPreference.TrunkID = p_trunk AND tblVendorPreference.TimezonesID = p_TimezonesID ;

					 /* insert preference if not in tblVendorPreference */
					 insert into tblVendorPreference (AccountId,Preference,RateID,TrunkID,TimezonesID,CreatedBy,created_at)
						    select p_accountId as AccountId, p_preference as Preference,tmp0.RateID as RateId,p_trunk as TrunkID, p_TimezonesID AS TimezonesID,p_username as CreatedBy,NOW() as created_at
							 from  tmp_pref0 tmp0
							 	 left join tblVendorPreference vp
								   on vp.RateId=tmp0.RateID
								   AND vp.AccountId = p_accountId AND vp.TrunkID=p_trunk AND vp.TimezonesID = p_TimezonesID
						    where  vp.VendorPreferenceID IS NULL;


				END IF;
		ELSE

				IF p_preference = 0 THEN

						select distinct vp.Preference
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID
								 inner join tblVendorPreference vp
								   on r.RateID=vp.RateId and vr.AccountId=vp.AccountId and vr.TrunkID=vp.TrunkID and vr.TimezonesID=vp.TimezonesID
						    where vp.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID = p_TimezonesID AND r.Code = p_rowcode;

				ELSE



						INSERT INTO tmp_pref0
						select DISTINCT RateId
						FROM (
						select vr.RateId
							 from tblVendorRate vr
							 	 inner join tblRate r
								   on vr.RateId=r.RateID
						    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID = p_TimezonesID AND r.Code = p_rowcode) tbl;

					/* Update preference */
					 UPDATE tblVendorPreference
						INNER JOIN tmp_pref0 temp
							ON tblVendorPreference.RateId = temp.RateID
						SET tblVendorPreference.Preference = p_preference,created_at=NOW(),CreatedBy=p_username
						WHERE tblVendorPreference.AccountId = p_accountId AND tblVendorPreference.TrunkID = p_trunk AND tblVendorPreference.TimezonesID = p_TimezonesID;

					 /* insert preference if not in tblVendorPreference */
					 insert into tblVendorPreference (AccountId,Preference,RateID,TrunkID,TimezonesID,CreatedBy,created_at)
						    select p_accountId as AccountId, p_preference as Preference,tmp0.RateID as RateId,p_trunk as TrunkID,p_TimezonesID AS TimezonesID,p_username as CreatedBy,NOW() as created_at
							 from  tmp_pref0 tmp0
							 	 left join tblVendorPreference vp
								   on vp.RateId=tmp0.RateID
								   AND vp.AccountId = p_accountId AND vp.TrunkID=p_trunk AND vp.TimezonesID = p_TimezonesID
						    where  vp.VendorPreferenceID IS NULL;



				END IF;

		END IF;




SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getAccountDiscountPlan
DROP PROCEDURE IF EXISTS `prc_getAccountDiscountPlan`;
DELIMITER //
CREATE PROCEDURE `prc_getAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_Type` INT,
	IN `p_ServiceID` INT,
	IN `p_AccountSubscriptionID` INT,
	IN `p_SubscriptionDiscountPlanID` INT
)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT 
		dg.Name,
		ROUND(adc.Threshold/60,0) as Threshold,
		IF (adc.Unlimited=1,'Unlimited','') as Unlimited,
		ROUND(adc.SecondsUsed/60,0) as MinutesUsed,
		StartDate,
		EndDate,
		adp.created_at,
		adp.CreatedBy
	FROM tblAccountDiscountPlan adp
	INNER JOIN tblAccountDiscountScheme adc
		ON adc.AccountDiscountPlanID = adp.AccountDiscountPlanID
	INNER JOIN tblDiscount d
		ON d.DiscountID = adc.DiscountID
	INNER JOIN tblDestinationGroup dg
		ON dg.DestinationGroupID = d.DestinationGroupID
	WHERE AccountID = p_AccountID 
	   AND adp.ServiceID = p_ServiceID
	   AND adp.AccountSubscriptionID = p_AccountSubscriptionID
	   AND adp.SubscriptionDiscountPlanID = p_SubscriptionDiscountPlanID
		AND Type = p_Type;
	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetAccounts
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
	--	IF ( (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount AND abc.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
	     IF ( (
				CASE WHEN abc.BalanceThreshold LIKE '%p' 
					THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit 
						ELSE abc.BalanceThreshold END
				) > CASE WHEN abg.BillingType = 1 THEN (CASE WHEN abc.BalanceAmount <0 THEN ABS(abc.BalanceAmount) ELSE (abc.BalanceAmount * -1) END) ELSE abc.BalanceAmount END  AND abc.BalanceThreshold <> 0 ,1,0) as BalanceWarning, 
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_)) as CUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as VUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)) as AE,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,IF(ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)<0,0,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_))) as ACL,
			abc.BalanceThreshold,
			tblAccount.Blocked
		FROM tblAccount
		LEFT JOIN tblAccountBilling abg 
			ON tblAccount.AccountID = abg.AccountID  AND abg.ServiceID = 0
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
		WHERE  
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
	 --	AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND  (
				CASE WHEN abc.BalanceThreshold LIKE '%p' 
					THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit 
						ELSE abc.BalanceThreshold END
				) > CASE WHEN abg.BillingType = 1 THEN (CASE WHEN abc.BalanceAmount <0 THEN ABS(abc.BalanceAmount) ELSE (abc.BalanceAmount * -1) END) ELSE abc.BalanceAmount END)) 
		GROUP BY tblAccount.AccountID,abg.BillingType
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
		LEFT JOIN tblAccountBilling abg 
		 ON tblAccount.AccountID = abg.AccountID AND abg.ServiceID = 0
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
		WHERE 
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
		--	AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) );
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND  (
				CASE WHEN abc.BalanceThreshold LIKE '%p' 
					THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit 
						ELSE abc.BalanceThreshold END
				) > CASE WHEN abg.BillingType = 1 THEN (CASE WHEN abc.BalanceAmount <0 THEN ABS(abc.BalanceAmount) ELSE (abc.BalanceAmount * -1) END) ELSE abc.BalanceAmount END)) ;

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
		LEFT JOIN tblAccountBilling abg 
			ON tblAccount.AccountID = abg.AccountID AND abg.ServiceID = 0
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
		--	AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND  (
				CASE WHEN abc.BalanceThreshold LIKE '%p' 
					THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit 
						ELSE abc.BalanceThreshold END
				) > CASE WHEN abg.BillingType = 1 THEN (CASE WHEN abc.BalanceAmount <0 THEN ABS(abc.BalanceAmount) ELSE (abc.BalanceAmount * -1) END) ELSE abc.BalanceAmount END)) 
		GROUP BY tblAccount.AccountID,abg.BillingType;
	END IF;
	IF p_isExport = 2
	THEN
		SELECT
			tblAccount.AccountID,
			tblAccount.AccountName
		FROM tblAccount
		LEFT JOIN tblAccountBilling abg 
			ON tblAccount.AccountID = abg.AccountID AND abg.ServiceID = 0
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
			-- AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
				AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND  (
				CASE WHEN abc.BalanceThreshold LIKE '%p' 
					THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit 
						ELSE abc.BalanceThreshold END
				) > CASE WHEN abg.BillingType = 1 THEN (CASE WHEN abc.BalanceAmount <0 THEN ABS(abc.BalanceAmount) ELSE (abc.BalanceAmount * -1) END) ELSE abc.BalanceAmount END)) 
		GROUP BY tblAccount.AccountID,abg.BillingType;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetActiveCronJob
DROP PROCEDURE IF EXISTS `prc_GetActiveCronJob`;
DELIMITER //
CREATE PROCEDURE `prc_GetActiveCronJob`(
	IN `p_companyid` INT,
	IN `p_Title` VARCHAR(500),
	IN `p_Status` INT,
	IN `p_Active` INT,
	IN `p_Type` INT,
	IN `p_CurrentDateTime` DATETIME,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT 


)
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	
    IF p_isExport = 0
    THEN
         
		SELECT
			jb.Active,
			CONCAT(jb.PID,CASE WHEN jb.MysqlPID !='' THEN '-' ELSE '' END,CASE when jb.MysqlPID!='' THEN jb.MysqlPID ELSE '' END) as PID,
			jb.JobTitle,                
			CONCAT(TIMESTAMPDIFF(HOUR,LastRunTime,p_CurrentDateTime),' Hours, ',TIMESTAMPDIFF(minute,LastRunTime,p_CurrentDateTime)%60,' Minutes, ',TIMESTAMPDIFF(second,LastRunTime,p_CurrentDateTime)%60 , ' Seconds' ) AS RunningTime,
			
 			jb.LastRunTime,
			jb.NextRunTime,			
			jb.CronJobID,
			jb.Status,	                 	
          jb.CronJobCommandID,
          jb.Settings	,
 		   (select CronJobStatus from tblCronJobLog where tblCronJobLog.CronJobID = jb.CronJobID order by  CronJobLogID desc limit 1)  as  CronJobStatus
			 	                 							
		FROM tblCronJob jb
		INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
      WHERE jb.CompanyID = p_companyid 
		AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
		AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
		 AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
		 AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) )
      ORDER BY                
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleDESC') THEN jb.JobTitle
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleASC') THEN jb.JobTitle
			END ASC,				
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PIDDESC') THEN jb.PID
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PIDASC') THEN jb.PID
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastRunTimeASC') THEN jb.LastRunTime
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastRunTimeDESC') THEN jb.LastRunTime
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextRunTimeASC') THEN jb.NextRunTime
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextRunTimeDESC') THEN jb.NextRunTime
			END DESC
		
		LIMIT p_RowspPage OFFSET v_OffSet_;


     SELECT
         COUNT(jb.CronJobID) as totalcount
     FROM tblCronJob jb
		INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
      WHERE jb.CompanyID = p_companyid 
		AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
		AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
		AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
		AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) );
		 
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
			jb.Active,
			jb.PID,
			jb.JobTitle,                
			CONCAT(TIMESTAMPDIFF(HOUR,LastRunTime,p_CurrentDateTime),' Hours, ',TIMESTAMPDIFF(minute,LastRunTime,p_CurrentDateTime)%60,' Minutes, ',TIMESTAMPDIFF(second,LastRunTime,p_CurrentDateTime)%60 , ' Seconds' ) AS RunningTime,
 			jb.LastRunTime,
			jb.NextRunTime
        FROM tblCronJob jb
			INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
	      WHERE jb.CompanyID = p_companyid 
			AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
			AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
			AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
			AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) );
		 	
		 	
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_getBillingAccounts`;
DELIMITER //
CREATE PROCEDURE `prc_getBillingAccounts`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATE,
	IN `p_skip_accounts` TEXT,
	IN `p_singleinvoice_accounts` TEXT
)
BEGIN
   
--	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

IF (p_singleinvoice_accounts = 0)
THEN
	SELECT 
		DISTINCT
		tblAccount.AccountID, 
		tblAccountBilling.NextInvoiceDate,
		AccountName, 
		tblAccountBilling.ServiceID
	FROM tblAccount 
	LEFT JOIN tblAccountService 
		ON tblAccountService.AccountID = tblAccount.AccountID
	LEFT JOIN tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID
		AND (( tblAccountBilling.ServiceID = 0  ) OR ( tblAccountService.ServiceID > 0 AND tblAccountBilling.ServiceID = tblAccountService.ServiceID AND tblAccountService.Status = 1)  ) 
	WHERE tblAccount.CompanyId = p_CompanyID 
	AND tblAccount.Status = 1 
	AND AccountType = 1 
	AND Billing = 1	
	AND tblAccountBilling.NextInvoiceDate <= p_Today
	AND (tblAccountBilling.BillingCycleType IS NOT NULL AND tblAccountBilling.BillingCycleType <> 'manual') 
	AND FIND_IN_SET(tblAccount.AccountID,p_skip_accounts) = 0	
	ORDER BY tblAccount.AccountID ASC;
	
ELSE

	SELECT 
		DISTINCT
		tblAccount.AccountID, 
		tblAccountBilling.NextInvoiceDate,
		AccountName, 
		tblAccountBilling.ServiceID
	FROM tblAccount 
	LEFT JOIN tblAccountService 
		ON tblAccountService.AccountID = tblAccount.AccountID
	LEFT JOIN tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID
		AND (( tblAccountBilling.ServiceID = 0  ) OR ( tblAccountService.ServiceID > 0 AND tblAccountBilling.ServiceID = tblAccountService.ServiceID AND tblAccountService.Status = 1)  ) 
	WHERE tblAccount.CompanyId = p_CompanyID 
	AND tblAccount.Status = 1 
	AND AccountType = 1 
	AND Billing = 1	
	AND tblAccountBilling.NextInvoiceDate <= p_Today
	AND (tblAccountBilling.BillingCycleType IS NOT NULL AND tblAccountBilling.BillingCycleType <> 'manual') 
	AND FIND_IN_SET(tblAccount.AccountID,p_singleinvoice_accounts) != 0	
	AND FIND_IN_SET(tblAccount.AccountID,p_skip_accounts) = 0	
	ORDER BY tblAccount.AccountID ASC;

END IF;	

--	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_GetBlockUnblockVendor`;
DELIMITER //
CREATE PROCEDURE `prc_GetBlockUnblockVendor`(
	IN `p_companyid` INT,
	IN `p_UserID` int ,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
	IN `p_CountryIDs` TEXT,
	IN `p_CountryCodes` TEXT,
	IN `p_isCountry` int ,
	IN `p_action` VARCHAR(10),
	IN `p_isAllCountry` int ,
	IN `p_criteria` INT
)
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



		IF p_isCountry = 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_codes_(
				Code varchar(20),
			INDEX tmp_Code (`Code`)
		);
	END IF;
   		IF p_criteria = 0 AND p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryCodes  = '' OR FIND_IN_SET(tblRate.Code,p_CountryCodes) != 0 );
        END IF;

        IF p_criteria = 1 AND  p_isCountry = 0
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryCodes  = '' OR Code LIKE REPLACE(p_CountryCodes,'*', '%') );
        END IF;

		IF p_criteria =2 AND p_isCountry = 0
		THEN

			insert into tmp_codes_
			SELECT  distinct tblRate.Code
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid
		   AND ( FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 );

		END IF;

		IF p_criteria =3 AND p_isCountry = 0
		THEN

			insert into tmp_codes_
			SELECT  distinct tblRate.Code
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid;

		END IF;

	if p_isCountry  = 0 AND p_action = 0
	Then
			SELECT SQL_CALC_FOUND_ROWS DISTINCT tblVendorRate.AccountId , tblAccount.AccountName
				from tblVendorRate
				inner join tblAccount on tblVendorRate.AccountId = tblAccount.AccountID
						and tblAccount.Status = 1
						and tblAccount.CompanyID = p_companyid
						AND tblAccount.IsVendor = 1
						and tblAccount.AccountType = 1
				inner join tblRate on tblVendorRate.RateId  = tblRate.RateId
					and tblVendorRate.TrunkID = p_TrunkID
					and tblVendorRate.TimezonesID = p_TimezonesID
				Inner join tmp_codes_ c on c.Code = tblRate.Code
				inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
					and tblVendorTrunk.AccountID =	tblVendorRate.AccountID
					and tblVendorTrunk.Status = 1
					and tblVendorTrunk.TrunkID = p_TrunkID
				LEFT OUTER JOIN tblVendorBlocking
					ON tblVendorRate.AccountId = tblVendorBlocking.AccountId
						AND tblVendorTrunk.TrunkID = tblVendorBlocking.TrunkID
						AND tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID
						AND tblRate.RateID = tblVendorBlocking.RateId
			WHERE tblVendorBlocking.VendorBlockingId IS NULL
			ORDER BY tblAccount.AccountName;

			SELECT FOUND_ROWS() as totalcount ;

	END IF;

	if p_isCountry = 0 AND p_action = 1

	Then
		select SQL_CALC_FOUND_ROWS DISTINCT tblVendorBlocking.AccountId, tblAccount.AccountName
			from tblVendorBlocking
			inner join tblAccount on tblVendorBlocking.AccountId = tblAccount.AccountID
								and tblAccount.Status = 1
								and tblAccount.CompanyID = p_companyid
								AND tblAccount.IsVendor = 1
								and tblAccount.AccountType = 1
			inner join tblRate on tblVendorBlocking.RateId  = tblRate.RateId
				and tblVendorBlocking.TrunkID = p_TrunkID
					and tblVendorBlocking.TimezonesID = p_TimezonesID
			Inner join tmp_codes_ c on c.Code = tblRate.Code
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
				and tblVendorTrunk.AccountID = tblVendorBlocking.AccountID
				and tblVendorTrunk.Status = 1
				and tblVendorTrunk.TrunkID = p_TrunkID
			inner join tblVendorRate on tblVendorRate.RateId = tblRate.RateId
				and tblVendorRate.AccountID = tblVendorBlocking.AccountID
				and tblVendorRate.TrunkID = p_TrunkID
				and tblVendorRate.TimezonesID = p_TimezonesID
		ORDER BY tblAccount.AccountName;

		SELECT FOUND_ROWS() as totalcount;

	END IF;



	if p_isCountry = 1 AND p_action = 0
	Then

		SELECT SQL_CALC_FOUND_ROWS DISTINCT  tblVendorRate.AccountId , tblAccount.AccountName
			from tblVendorRate
			inner join tblAccount on tblVendorRate.AccountId = tblAccount.AccountID
					and tblAccount.Status = 1
					and tblAccount.CompanyID = p_companyid
					AND tblAccount.IsVendor = 1
					and tblAccount.AccountType = 1
			inner join tblRate on tblVendorRate.RateId  = tblRate.RateId
				and  (
						(p_isAllCountry = 1 and p_isCountry = 1 and  tblRate.CountryID in  (SELECT CountryID FROM tblCountry) )
						OR
						(FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 )

					)
				and tblVendorRate.TrunkID = p_TrunkID
				and tblVendorRate.TimezonesID = p_TimezonesID
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
				and tblVendorTrunk.AccountID =	tblVendorRate.AccountID
				and tblVendorTrunk.Status = 1
				and tblVendorTrunk.TrunkID = p_TrunkID
			LEFT OUTER JOIN tblVendorBlocking
				ON tblVendorRate.AccountId = tblVendorBlocking.AccountId
					AND tblVendorTrunk.TrunkID = tblVendorBlocking.TrunkID
					AND tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID
					AND tblRate.CountryId = tblVendorBlocking.CountryId
		WHERE tblVendorBlocking.VendorBlockingId IS NULL
			ORDER BY tblAccount.AccountName;

			SELECT FOUND_ROWS() as totalcount;

	END IF;

	if p_isCountry = 1 AND p_action = 1

	Then
		select SQL_CALC_FOUND_ROWS DISTINCT tblVendorBlocking.AccountId , tblAccount.AccountName
			from tblVendorBlocking
				inner join tblAccount on tblVendorBlocking.AccountId = tblAccount.AccountID
								and tblAccount.Status = 1
								and tblAccount.CompanyID = p_companyid
								AND tblAccount.IsVendor = 1
								and tblAccount.AccountType = 1
			inner join tblRate on tblVendorBlocking.CountryId  = tblRate.CountryId
				and  (
						(p_isAllCountry = 1 and p_isCountry = 1 and tblRate.CountryID in(SELECT CountryID FROM tblCountry) )
						OR
						( FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 )

					)
 				and tblVendorBlocking.TrunkID = p_TrunkID
				and tblVendorBlocking.TimezonesID = p_TimezonesID
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
				and tblVendorTrunk.AccountID = tblVendorBlocking.AccountID
				and tblVendorTrunk.Status = 1
				and tblVendorTrunk.TrunkID = p_TrunkID
			inner join tblVendorRate on tblVendorRate.RateId = tblRate.RateId
				and tblVendorRate.AccountID = tblVendorBlocking.AccountID
				and tblVendorRate.TrunkID = p_TrunkID
				and tblVendorRate.TimezonesID = p_TimezonesID
			ORDER BY tblAccount.AccountName;

		SELECT FOUND_ROWS() as totalcount;

	END IF;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetCustomerRate
DROP PROCEDURE IF EXISTS `prc_GetCustomerRate`;
DELIMITER //
CREATE PROCEDURE `prc_GetCustomerRate`(
	IN `p_companyid` INT,
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
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
ThisSP:BEGIN
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
        RateN DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        TimezonesID INT,
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
        RateN DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        EndDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        TimezonesID INT,
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
        RateN DECIMAL(18, 6),
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
                tblCustomerRate.RateN,
                tblCustomerRate.ConnectionFee,
                tblCustomerRate.EffectiveDate,
                tblCustomerRate.EndDate,
                tblCustomerRate.LastModifiedDate,
                tblCustomerRate.LastModifiedBy,
                tblCustomerRate.CustomerRateId,
                NULL AS RateTableRateID,
                p_trunkID as TrunkID,
                p_TimezonesID as TimezonesID,
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
            AND (p_TimezonesID IS NULL OR tblCustomerRate.TimezonesID = p_TimezonesID)
            AND (p_RoutinePlan = 0 or tblCustomerRate.RoutinePlan = p_RoutinePlan)
            AND CustomerID = p_AccountID

            ORDER BY
                tblCustomerRate.TrunkId, tblCustomerRate.CustomerId,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;







	 	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates4_;
			CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates4_ as (select * from tmp_CustomerRates_);
			DELETE n1 FROM tmp_CustomerRates_ n1, tmp_CustomerRates4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
			AND n1.TrunkID = n2.TrunkID
         AND (p_TimezonesID IS NULL OR n1.TimezonesID = n2.TimezonesID)
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
                tblRateTableRate.RateN,
                tblRateTableRate.ConnectionFee,
      			 tblRateTableRate.EffectiveDate,
      			 tblRateTableRate.EndDate,
                NULL AS LastModifiedDate,
                NULL AS LastModifiedBy,
                NULL AS CustomerRateId,
                tblRateTableRate.RateTableRateID,
                p_trunkID as TrunkID,
                p_TimezonesID as TimezonesID
            FROM tblRateTableRate
            INNER JOIN tblRate
                ON tblRateTableRate.RateID = tblRate.RateID
            WHERE (p_contryID IS NULL OR tblRate.CountryID = p_contryID)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
            AND (tblRate.CompanyID = p_companyid)
            AND tblRate.CodeDeckId = v_codedeckid_
            AND RateTableID = v_ratetableid_
            AND (p_TimezonesID IS NULL OR tblRateTableRate.TimezonesID = p_TimezonesID)
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
		  AND (p_TimezonesID IS NULL OR n1.TimezonesID = n2.TimezonesID)
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
                allRates.RateN,
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
                CustomerRates.RateN,
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
                rtr.RateN,
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
                RateN,
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
            RateN,
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
            RateN,
            EffectiveDate from tmp_customerrate_;

    END IF;


    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetCustomerRatesArchiveGrid
DROP PROCEDURE IF EXISTS `prc_GetCustomerRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetCustomerRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TimezonesID` INT,
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
		cra.RateN,
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
		cra.TimezonesID = p_TimezonesID AND
		FIND_IN_SET (r.Code, p_Codes) != 0
	ORDER BY
		cra.EffectiveDate DESC, cra.created_at DESC;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDeductCallChargeAccounts
DROP PROCEDURE IF EXISTS `prc_getDeductCallChargeAccounts`;
DELIMITER //
CREATE PROCEDURE `prc_getDeductCallChargeAccounts`(
	IN `p_CompanyID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		DISTINCT
		a.AccountID,
		ab.NextInvoiceDate,
		AccountName,
		ab.ServiceID
	FROM tblAccount a
	INNER JOIN tblAccountBilling ab
		ON ab.AccountID = a.AccountID and ab.ServiceID = 0
	INNER JOIN tblBillingClass bc
		ON bc.BillingClassID = ab.BillingClassID
	WHERE a.CompanyId = p_CompanyID
	AND a.Status = 1
	AND AccountType = 1
	AND Billing = 1
	AND a.AccountID IN (111)
	AND (ab.BillingCycleType IS NOT NULL AND ab.BillingCycleType <> 'manual')
	AND bc.DeductCallChargeInAdvance = 1
	ORDER BY a.AccountID ASC;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDiscontinuedCustomerRateGrid
DROP PROCEDURE IF EXISTS `prc_getDiscontinuedCustomerRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedCustomerRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
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
		RateN DECIMAL(18, 6),
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
		cra.RateN,
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
		cra.TimezonesID = p_TimezonesID AND
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
			RateN,
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
			RateN,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`
		FROM tmp_CustomerRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDiscontinuedRateTableRateGrid
DROP PROCEDURE IF EXISTS `prc_getDiscontinuedRateTableRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedRateTableRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_RateTableID` INT,
	IN `p_TimezonesID` INT,
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
		RateN DECIMAL(18, 6),
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
		vra.RateN,
		vra.EffectiveDate,
		vra.EndDate,
		vra.created_at AS updated_at,
		vra.created_by AS updated_by
	FROM
		tblRateTableRateArchive vra
	JOIN
		tblRate r ON r.RateID=vra.RateId
	LEFT JOIN
		tblRateTableRate vr ON vr.RateTableId = vra.RateTableId AND vr.RateId = vra.RateId AND vr.TimezonesID = vra.TimezonesID
	WHERE
		r.CompanyID = p_CompanyID AND
		vra.RateTableId = p_RateTableID AND
		vra.TimezonesID = p_TimezonesID AND
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
				RateN,
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
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
				RateN,
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
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN ANY_VALUE(RateN)
				END DESC,
				CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN ANY_VALUE(RateN)
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
			RateN,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`
		FROM tmp_RateTableRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDiscontinuedVendorRateGrid
DROP PROCEDURE IF EXISTS `prc_getDiscontinuedVendorRateGrid`;
DELIMITER //
CREATE PROCEDURE `prc_getDiscontinuedVendorRateGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
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
        RateN DECIMAL(18, 6),
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
			vra.RateN,
			vra.EffectiveDate,
			vra.EndDate,
			vra.created_at AS updated_at,
			vra.created_by AS updated_by
		FROM
			tblVendorRateArchive vra
		JOIN
			tblRate r ON r.RateID=vra.RateId
		LEFT JOIN
			tblVendorRate vr ON vr.AccountId = vra.AccountId AND vr.TrunkID = vra.TrunkID AND vr.RateId = vra.RateId AND vr.TimezonesID = vra.TimezonesID
		WHERE
			r.CompanyID = p_CompanyID AND
			vra.TrunkID = p_TrunkID AND
			vra.TimezonesID = p_TimezonesID AND
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
			RateN,
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
			RateN,
			EffectiveDate,
			EndDate,
			updated_at AS `Modified Date`,
			updated_by AS `Modified By`

		FROM tmp_VendorRate_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDynamiclinks
DROP PROCEDURE IF EXISTS `prc_getDynamiclinks`;
DELIMITER //
CREATE PROCEDURE `prc_getDynamiclinks`(
	IN `p_CompanyID` INT,
	IN `p_Title` VARCHAR(255),
	IN `p_Currency` INT(11),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT





)
BEGIN
     DECLARE v_OffSet_ int;
     
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
		tblDynamiclink.Title,
		tblDynamiclink.Link,
		tblCurrency.Code as Currency,
		tblDynamiclink.created_at,
		tblDynamiclink.CurrencyID,
		tblDynamiclink.DynamicLinkID
		from tblDynamiclink LEFT JOIN tblCurrency ON tblDynamiclink.CurrencyID = tblCurrency.CurrencyId
		where tblDynamiclink.CompanyID = p_CompanyID
		AND (p_Title ='' OR tblDynamiclink.Title like Concat('%',p_Title,'%'))
		AND (p_Currency ='' OR tblDynamiclink.CurrencyID = p_Currency)
            
        ORDER BY
   
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN tblDynamiclink.Title
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN tblDynamiclink.Title
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CurrencyDESC') THEN tblDynamiclink.CurrencyID
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CurrencyASC') THEN tblDynamiclink.CurrencyID
			END ASC,
			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblDynamiclink.created_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblDynamiclink.created_at
			END ASC
			
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
		COUNT(tblDynamiclink.DynamicLinkID) AS totalcount
		from tblDynamiclink
		where tblDynamiclink.CompanyID = p_CompanyID
		AND (p_Title ='' OR tblDynamiclink.Title like Concat('%',p_Title,'%'))
		AND (p_Currency ='' OR tblDynamiclink.CurrencyID = p_Currency);

	ELSE
	
		SELECT
			tblDynamiclink.Title,
			tblDynamiclink.Link,
			tblCurrency.Code as Currency,
			tblDynamiclink.created_at as CreatedDate
         from tblDynamiclink LEFT JOIN tblCurrency ON tblDynamiclink.CurrencyID = tblCurrency.CurrencyId
			where tblDynamiclink.CompanyID = p_CompanyID
			AND (p_Title ='' OR tblDynamiclink.Title like Concat('%',p_Title,'%'))
			AND (p_Currency ='' OR tblDynamiclink.CurrencyID = p_Currency);

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getDynamicTypes
DROP PROCEDURE IF EXISTS `prc_getDynamicTypes`;
DELIMITER //
CREATE PROCEDURE `prc_getDynamicTypes`(
	IN `p_CompanyID` INT,
	IN `p_FieldName` VARCHAR(50),
	IN `p_FieldDomType` VARCHAR(50),
	IN `p_Active` VARCHAR(1),
	IN `p_Type` VARCHAR(100),
	IN `p_ItemTypeID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT


)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblDynamicFields.DynamicFieldsID,
			IFNULL(tblItemType.title,'All') AS title,
			tblDynamicFields.FieldName,
			tblDynamicFields.FieldDomType,
			tblDynamicFields.created_at,
			tblDynamicFields.Status,
			tblDynamicFields.FieldDescription,
			tblDynamicFields.FieldOrder,			
			tblDynamicFields.FieldSlug,
			tblDynamicFields.Type,
			tblItemType.ItemTypeID,
			tblDynamicFields.Minimum,
			tblDynamicFields.Maximum,	
			tblDynamicFields.DefaultValue,
			tblDynamicFields.SelectVal
            from tblDynamicFields LEFT JOIN RMBilling3.tblItemType ON tblDynamicFields.ItemTypeID = tblItemType.ItemTypeID
            where tblDynamicFields.`Type`= p_Type AND tblDynamicFields.CompanyID = p_CompanyID
			AND (p_FieldName ='' OR tblDynamicFields.FieldName like Concat('%',p_FieldName,'%'))
				AND ((p_FieldDomType ='' OR tblDynamicFields.FieldDomType like CONCAT(p_FieldDomType,'%')))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_Active = '' OR tblDynamicFields.Status = p_Active))
         ORDER BY
         	CASE
                 WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DynamicFieldsIDDESC') THEN tblDynamicFields.DynamicFieldsID
             END DESC,
             CASE
                 WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DynamicFieldsIDASC') THEN tblDynamicFields.DynamicFieldsID
             END ASC,
             
      		CASE
                 WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleDESC') THEN tblItemType.title
             END DESC,
             CASE
                 WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleASC') THEN tblItemType.title
             END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FieldNameDESC') THEN tblDynamicFields.FieldName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FieldNameASC') THEN tblDynamicFields.FieldName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FieldDomTypeDESC') THEN tblDynamicFields.FieldDomType
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FieldDomTypeASC') THEN tblDynamicFields.FieldDomType
                END ASC,
                
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblDynamicFields.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblDynamicFields.created_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tblDynamicFields.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tblDynamicFields.Status
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblDynamicFields.DynamicFieldsID) AS totalcount
            from tblDynamicFields LEFT JOIN RMBilling3.tblItemType ON tblDynamicFields.ItemTypeID = tblItemType.ItemTypeID
            where tblDynamicFields.`Type`= p_Type AND tblDynamicFields.CompanyID = p_CompanyID
			AND (p_FieldName ='' OR tblDynamicFields.FieldName like Concat('%',p_FieldName,'%'))
				AND ((p_FieldDomType ='' OR tblDynamicFields.FieldDomType like CONCAT(p_FieldDomType,'%')))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_Active = '' OR tblDynamicFields.Status = p_Active));
            

	ELSE

			SELECT
			tblDynamicFields.DynamicFieldsID,
			IFNULL(tblItemType.title,'All') AS title,
			tblDynamicFields.FieldName,
			tblDynamicFields.FieldDomType,
			tblDynamicFields.created_at,
			tblDynamicFields.Status,
			tblDynamicFields.FieldDescription,
			tblDynamicFields.FieldOrder,			
			tblDynamicFields.FieldSlug,
			tblDynamicFields.Type,
			tblItemType.ItemTypeID,
			tblDynamicFields.Minimum,
			tblDynamicFields.Maximum,	
			tblDynamicFields.DefaultValue,
			tblDynamicFields.SelectVal
            from tblDynamicFields LEFT JOIN RMBilling3.tblItemType ON tblDynamicFields.ItemTypeID = tblItemType.ItemTypeID
			where tblDynamicFields.`Type`= p_Type AND tblDynamicFields.CompanyID = p_CompanyID
			AND (p_FieldName ='' OR tblDynamicFields.FieldName like Concat('%',p_FieldName,'%'))
				AND ((p_FieldDomType ='' OR tblDynamicFields.FieldDomType like CONCAT(p_FieldDomType,'%')))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_Active = '' OR tblDynamicFields.Status = p_Active));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetLCR
DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCR`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
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
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																		 		 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID
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
								 AND tblVendorRate.TimezonesID = p_TimezonesID
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
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																				 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID
							 WHERE
								 ( EffectiveDate <= DATE(p_SelectedEffectiveDate) )
								 AND ( tblVendorRate.EndDate IS NULL OR  tblVendorRate.EndDate > Now() )   -- rate should not end Today
								 AND (p_AccountIds='' OR FIND_IN_SET(tblAccount.AccountID,p_AccountIds) != 0 )
								 AND tblAccount.IsVendor = 1
								 AND tblAccount.Status = 1
								 AND tblAccount.CurrencyId is not NULL
								 AND tblVendorRate.TrunkID = p_trunkID
								 AND tblVendorRate.TimezonesID = p_TimezonesID
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
				WHERE p_isExport = 1 OR (p_isExport = 0 AND preference_rank <= p_Position)
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
				WHERE p_isExport = 1 OR (p_isExport = 0 AND RateRank <= p_Position)
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
		       			  where  SplitCode.Code is not null and (p_isExport = 1 OR (p_isExport = 0 AND rankname <= p_Position))

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
			where  SplitCode.Code is not null and (p_isExport = 1 OR (p_isExport = 0 AND rankname <= p_Position))
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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);

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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
			END IF;

		END IF;


		SET @stm_columns = "";

		-- if not export then columns must be max 10
		IF p_isExport = 0 AND p_Position > 10 THEN
			SET p_Position = 10;
		END IF;

		-- if export then all columns
		IF p_isExport = 1 THEN
			SELECT MAX(FinalRankNumber) INTO p_Position FROM tmp_final_VendorRate_;
		END IF;

		-- columns loop 5,10,50,...
		SET v_pointer_=1;
		WHILE v_pointer_ <= p_Position
		DO

			IF (p_isExport = 0)
			THEN
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Description), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(t.BlockingId), '-', ANY_VALUE(t.AccountId), '-', ANY_VALUE(t.Code), '-', ANY_VALUE(t.BlockingCountryId) ), NULL)) AS `POSITION ",v_pointer_,"`,");
			ELSE
				SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",v_pointer_,", CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Description), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y')), NULL))  AS `POSITION ",v_pointer_,"`,");
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

-- Dumping structure for procedure Ratemanagement3.prc_GetLCRwithPrefix
DROP PROCEDURE IF EXISTS `prc_GetLCRwithPrefix`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCRwithPrefix`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
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
										AND vp.TimezonesID = tblVendorRate.TimezonesID
										AND vp.RateId = tblVendorRate.RateId
							 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																	 AND tblVendorRate.AccountId = blockCode.AccountId
																																	 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																	 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
							 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																			 AND tblVendorRate.AccountId = blockCountry.AccountId
																																			 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																			 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID
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
							 AND tblVendorRate.TimezonesID = p_TimezonesID
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
										AND vp.TimezonesID = tblVendorRate.TimezonesID
										AND vp.RateId = tblVendorRate.RateId
							 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																	 AND tblVendorRate.AccountId = blockCode.AccountId
																																	 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																	 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
							 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																			 AND tblVendorRate.AccountId = blockCountry.AccountId
																																			 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																			 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID
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
							 AND tblVendorRate.TimezonesID = p_TimezonesID
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
				WHERE p_isExport = 1 OR (p_isExport = 0 AND preference_rank <= p_Position)
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
				WHERE p_isExport = 1 OR (p_isExport = 0 AND RateRank <= p_Position)
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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);

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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
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
						p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
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
								p_isExport = 1 OR (p_isExport = 0 AND FinalRankNumber <= p_Position);
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
			SELECT MAX(FinalRankNumber) INTO p_Position FROM tmp_final_VendorRate_;
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

-- Dumping structure for procedure Ratemanagement3.prc_GetRateTableRate
DROP PROCEDURE IF EXISTS `prc_GetRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_GetRateTableRate`(
	IN `p_companyid` INT,
	IN `p_RateTableId` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
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
	SET SESSION GROUP_CONCAT_MAX_LEN = 1000000; -- group_concat limit bydefault is 1024, so we have increase it
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
        RateN DECIMAL(18, 6),
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
        IFNULL(tblRateTableRate.RateN, 0) as RateN,
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
		AND tblRateTableRate.TimezonesID = p_TimezonesID
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
		PreviousRate = (SELECT Rate FROM tblRateTableRate WHERE RateTableID=p_RateTableId AND TimezonesID = p_TimezonesID AND RateID=tr.RateID AND Code=tr.Code AND EffectiveDate<tr.EffectiveDate ORDER BY EffectiveDate DESC,RateTableRateID DESC LIMIT 1);

	UPDATE
		tmp_RateTableRate_ tr
	SET
		PreviousRate = (SELECT Rate FROM tblRateTableRateArchive WHERE RateTableID=p_RateTableId AND TimezonesID = p_TimezonesID AND RateID=tr.RateID AND Code=tr.Code AND EffectiveDate<tr.EffectiveDate ORDER BY EffectiveDate DESC,RateTableRateID DESC LIMIT 1)
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
			SELECT group_concat(ID) AS ID, group_concat(Code) AS Code,ANY_VALUE(Description),ANY_VALUE(Interval1),ANY_VALUE(Intervaln),ANY_VALUE(ConnectionFee),ANY_VALUE(PreviousRate),ANY_VALUE(Rate),ANY_VALUE(RateN),ANY_VALUE(EffectiveDate),ANY_VALUE(EndDate),MAX(updated_at) AS updated_at,MAX(ModifiedBy) AS ModifiedBy,group_concat(ID) AS RateTableRateID,group_concat(RateID) AS RateID FROM tmp_RateTableRate_
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN ANY_VALUE(RateN)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN ANY_VALUE(RateN)
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
            RateN,
            EffectiveDate,
            updated_at,
            ModifiedBy

        FROM   tmp_RateTableRate_;


    END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetRateTableRatesArchiveGrid
DROP PROCEDURE IF EXISTS `prc_GetRateTableRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetRateTableRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_RateTableID` INT,
	IN `p_TimezonesID` INT,
	IN `p_Codes` LONGTEXT,
	IN `p_View` INT
)
BEGIN

	SET SESSION GROUP_CONCAT_MAX_LEN = 1000000; -- group_concat limit bydefault is 1024, so we have increase it

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
   CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
		  ConnectionFee VARCHAR(50),
        PreviousRate DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        RateN DECIMAL(18, 6),
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
		  	RateN,
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
			vra.RateN,
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
			vra.TimezonesID = p_TimezonesID AND
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
			vra.TimezonesID = p_TimezonesID AND
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
		RateN,
		EffectiveDate,
		EndDate,
		IFNULL(updated_at,'') AS ModifiedDate,
		IFNULL(ModifiedBy,'') AS ModifiedBy
	FROM tmp_RateTableRate_;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getReviewRateTableRates
DROP PROCEDURE IF EXISTS `prc_getReviewRateTableRates`;
DELIMITER //
CREATE PROCEDURE `prc_getReviewRateTableRates`(
	IN `p_ProcessID` VARCHAR(50),
	IN `p_Action` VARCHAR(50),
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_Timezone` INT,
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
			`Code`,`Description`,tz.Title,`Rate`,`RateN`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblRateTableRateChangeLog
		JOIN
			tblTimezones tz ON tblRateTableRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblRateTableRateChangeLog.TimezonesID = p_Timezone
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
		JOIN
			tblTimezones tz ON tblRateTableRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblRateTableRateChangeLog.TimezonesID = p_Timezone
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			distinct
			`Code`,`Description`,tz.Title,`Rate`,`RateN`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblRateTableRateChangeLog
		JOIN
			tblTimezones tz ON tblRateTableRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblRateTableRateChangeLog.TimezonesID = p_Timezone
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getReviewVendorRates
DROP PROCEDURE IF EXISTS `prc_getReviewVendorRates`;
DELIMITER //
CREATE PROCEDURE `prc_getReviewVendorRates`(
	IN `p_ProcessID` VARCHAR(50),
	IN `p_Action` VARCHAR(50),
	IN `p_Code` VARCHAR(50),
	IN `p_Description` VARCHAR(50),
	IN `p_Timezone` INT,
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
			IF(p_Action='Deleted',VendorRateID,TempVendorRateID) AS VendorRateID,
			`Code`,`Description`,tz.Title,`Rate`,`RateN`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblVendorRateChangeLog
		JOIN
			tblTimezones tz ON tblVendorRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblVendorRateChangeLog.TimezonesID = p_Timezone
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
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
			tblVendorRateChangeLog
		JOIN
			tblTimezones tz ON tblVendorRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblVendorRateChangeLog.TimezonesID = p_Timezone
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			distinct
			`Code`,`Description`,tz.Title,`Rate`,`RateN`,`EffectiveDate`,`EndDate`,`ConnectionFee`,`Interval1`,`IntervalN`
		FROM
			tblVendorRateChangeLog
		JOIN
			tblTimezones tz ON tblVendorRateChangeLog.TimezonesID = tz.TimezonesID
		WHERE
			ProcessID = p_ProcessID AND Action = p_Action
			AND
				tblVendorRateChangeLog.TimezonesID = p_Timezone
			AND
			(p_Code IS NULL OR p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
			AND
			(p_Description IS NULL OR p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'));
	END IF;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetTimezones
DROP PROCEDURE IF EXISTS `prc_GetTimezones`;
DELIMITER //
CREATE PROCEDURE `prc_GetTimezones`(
	IN `p_Title` varchar(100),
	IN `p_Status` INT,
	IN `p_PageNumber` INT ,
	IN `p_RowspPage` INT ,
	IN `p_lSortCol` VARCHAR(50) ,
	IN `p_SortOrder` VARCHAR(5) ,
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	DROP TEMPORARY TABLE IF EXISTS tmp_Timezones_;
	CREATE TEMPORARY TABLE tmp_Timezones_ (
		`TimezonesID` int(11) NOT NULL,
		`Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
		`FromTime` varchar(10) NOT NULL,
		`ToTime` varchar(10) NOT NULL,
		`DaysOfWeek` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
		`DaysOfMonth` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
		`Months` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
		`ApplyIF` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
		`Status` TINYINT(4) NOT NULL,
		`created_at` datetime NOT NULL,
		`created_by` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
		`updated_at` datetime NOT NULL,
		`updated_by` varchar(50) COLLATE utf8_unicode_ci NOT NULL
	);

	INSERT INTO tmp_Timezones_
	SELECT
		`TimezonesID`,
		`Title`,
		`FromTime`,
		`ToTime`,
		`DaysOfWeek`,
		`DaysOfMonth`,
		`Months`,
		`ApplyIF`,
		`Status`,
		`created_at`,
		`created_by`,
		`updated_at`,
		`updated_by`
	FROM
		tblTimezones
	WHERE
		(p_Title IS NULL OR Title LIKE REPLACE(p_Title, '*', '%')) AND
		`Status` = p_Status;

	IF p_isExport = 0
	THEN
		SELECT
			`TimezonesID`,
			`Title`,
			`FromTime`,
			`ToTime`,
			`DaysOfWeek`,
			`DaysOfMonth`,
			`Months`,
			`ApplyIF`,
			`updated_at`,
			`updated_by`,
			`Status`
		FROM
			tmp_Timezones_
		ORDER BY
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN Title
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN Title
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FromTimeDESC') THEN FromTime
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FromTimeASC') THEN FromTime
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ToTimeDESC') THEN ToTime
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ToTimeASC') THEN ToTime
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DaysOfWeekDESC') THEN DaysOfWeek
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DaysOfWeekASC') THEN DaysOfWeek
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DaysOfMonthDESC') THEN DaysOfMonth
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DaysOfMonthASC') THEN DaysOfMonth
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthsDESC') THEN Months
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthsASC') THEN Months
			END ASC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ApplyIFDESC') THEN ApplyIF
			END DESC,
			CASE
			WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ApplyIFASC') THEN ApplyIF
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
			END ASC
		LIMIT
			p_RowspPage OFFSET v_OffSet_;

		SELECT
		COUNT(code) AS totalcount
		FROM tmp_Timezones_;

	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			`Title`,
			`FromTime`,
			`ToTime`,
			`DaysOfWeek`,
			`DaysOfMonth`,
			`Months`,
			`ApplyIF`,
			`updated_at`,
			`updated_by`
		FROM
			tmp_Timezones_;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetVendorBlockByCode
DROP PROCEDURE IF EXISTS `prc_GetVendorBlockByCode`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorBlockByCode`(
	IN `p_companyid` INT ,
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
	IN `p_contryID` INT ,
	IN `p_status` VARCHAR(50) ,
	IN `p_code` VARCHAR(50),
	IN `p_PageNumber` INT ,
	IN `p_RowspPage` INT ,
	IN `p_lSortCol` VARCHAR(50) ,
	IN `p_SortOrder` VARCHAR(5) ,
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

   IF p_isExport = 0
   THEN

		SELECT  Distinct
            `tblRate`.RateID
           ,`tblRate`.Code
           ,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
           ,`tblRate`.Description
           ,VendorBlockingId
	    FROM      `tblRate`
       INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
	    INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID
       LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
		 WHERE ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
             AND ( tblRate.CompanyID = p_companyid )
             AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
             AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)
		 ORDER BY
		 		 	CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
					END DESC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
					END ASC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN tblRate.Description
					END DESC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN tblRate.Description
					END ASC,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN VendorBlockingId
					END DESC,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN VendorBlockingId
					END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;


		SELECT COUNT(DISTINCT tblRate.RateID) AS totalcount
      FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
      WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);
	END IF;

   IF p_isExport = 1
   THEN
		SELECT Distinct  Code
      		,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
            ,tblRate.Description

		FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
		WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)
		ORDER BY Code,Status  ;
   END IF;
   IF p_isExport = 2
   THEN
		SELECT Distinct
			    tblRate.RateID as RateID
				,Code
      		,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
            ,tblRate.Description

		FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID AND tblVendorRate.TimezonesID = p_TimezonesID
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
		WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)
		ORDER BY Code,Status  ;
   END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetVendorBlockByCountry
DROP PROCEDURE IF EXISTS `prc_GetVendorBlockByCountry`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorBlockByCountry`(
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
	IN `p_contryID` INT ,
	IN `p_status` VARCHAR(50) ,
	IN `p_PageNumber` INT ,
	IN `p_RowspPage` INT ,
	IN `p_lSortCol` VARCHAR(50) ,
	IN `p_SortOrder` VARCHAR(5) ,
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
   THEN

		SELECT
      	tblCountry.CountryID,
         Country,
         CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM      tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND TimezonesID = p_TimezonesID AND AccountId = p_AccountID
      WHERE         ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)
      ORDER BY
	   	CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	      END DESC ,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC')	THEN Country
	      END ASC ,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN VendorBlockingId
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN VendorBlockingId
	      END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT  COUNT(tblCountry.CountryID) AS totalcount
      FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND TimezonesID = p_TimezonesID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);
	END IF;

   IF p_isExport = 1
   THEN

   	SELECT   Country,
      			CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND TimezonesID = p_TimezonesID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);
	END IF;
	IF p_isExport = 2
   THEN

   	SELECT   tblCountry.CountryID,
					Country,
      			CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND TimezonesID = p_TimezonesID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getVendorCodeRate
DROP PROCEDURE IF EXISTS `prc_getVendorCodeRate`;
DELIMITER //
CREATE PROCEDURE `prc_getVendorCodeRate`(
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN

	DECLARE v_CompanyID_ INT;

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
		AND (tblVendorRate.EndDate IS NULL OR tblVendorRate.EndDate >= NOW()) ;

		IF p_RateMethod = 'SpecifyRate'
		THEN
			IF (SELECT COUNT(*) FROM tmp_vcodes_) = 0
			THEN

				SET v_CompanyID_ = (SELECT CompanyId FROM tblAccount WHERE AccountID = p_AccountID);
				INSERT INTO tmp_vcodes_
				SELECT
					DISTINCT
					tblRate.RateID,
					tblRate.Code,
					p_SpecifyRate,
					0,
					IFNULL(tblRate.Interval1,1),
					IFNULL(tblRate.IntervalN,1)
				FROM tblRate
				INNER JOIN tblCodeDeck
					ON tblCodeDeck.CodeDeckId = tblRate.CodeDeckId
				WHERE tblCodeDeck.CompanyId = v_CompanyID_
				AND tblCodeDeck.DefaultCodedeck = 1 ;

			END IF;

			UPDATE tmp_vcodes_ SET Rate=p_SpecifyRate;

		END IF;

	END IF;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetVendorPreference
DROP PROCEDURE IF EXISTS `prc_GetVendorPreference`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorPreference`(
	IN `p_companyid` INT ,
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_TimezoneID` INT,
	IN `p_contryID` INT ,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(50) ,
	IN `p_PageNumber` INT ,
	IN `p_RowspPage` INT ,
	IN `p_lSortCol` VARCHAR(50) ,
	IN `p_SortOrder` VARCHAR(5) ,
	IN `p_isExport` INT
)
BEGIN


		DECLARE v_CodeDeckId_ int;
		DECLARE v_OffSet_ int;
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

		select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;

         IF p_isExport = 0
			THEN

				SELECT
				   DISTINCT
					tblRate.RateID,
					Code,
					Preference,
					Description,
					VendorPreferenceID
				FROM  tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.TimezonesID = tblVendorRate.TimezonesID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
				WHERE (p_contryID IS NULL OR CountryID = p_contryID)
				AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND tblVendorRate.TrunkID = p_trunkID
				AND tblVendorRate.TimezonesID = p_TimezoneID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_
				ORDER BY CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Preference
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Preference
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorPreferenceIDDESC') THEN VendorPreferenceID
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorPreferenceIDASC') THEN VendorPreferenceID
					END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;



				SELECT
					COUNT(DISTINCT RateID) AS totalcount
				FROM (SELECT
					tblRate.RateId,
					EffectiveDate
				FROM tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.TimezonesID = tblVendorRate.TimezonesID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
				WHERE (p_contryID IS NULL
				OR CountryID = p_contryID)
				AND (p_code IS NULL
				OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL
				OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND tblVendorRate.TrunkID = p_trunkID
				AND tblVendorRate.TimezonesID = p_TimezoneID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_

			) AS tbl2;

		END IF;

		IF p_isExport = 1
		THEN

			SELECT DISTINCT
				Code,
				tblVendorPreference.Preference,
				Description
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.TimezonesID = tblVendorRate.TimezonesID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.TimezonesID = p_TimezoneID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;

		END IF;
		IF p_isExport = 2
		THEN

			SELECT DISTINCT
				tblRate.RateID as RateID,
            Code,
            tblVendorPreference.Preference,
            Description
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.TimezonesID = tblVendorRate.TimezonesID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.TimezonesID = p_TimezoneID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;

		END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetVendorRates
DROP PROCEDURE IF EXISTS `prc_GetVendorRates`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorRates`(
	IN `p_companyid` INT ,
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
	IN `p_contryID` INT ,
	IN `p_code` VARCHAR(50) ,
	IN `p_description` VARCHAR(50) ,
	IN `p_effective` varchar(100),
	IN `p_PageNumber` INT ,
	IN `p_RowspPage` INT ,
	IN `p_lSortCol` VARCHAR(50) ,
	IN `p_SortOrder` VARCHAR(5) ,
	IN `p_isExport` INT
)
BEGIN


	DECLARE v_CodeDeckId_ int;
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


		select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
	   CREATE TEMPORARY TABLE tmp_VendorRate_ (
	        VendorRateID INT,
	        Code VARCHAR(50),
	        Description VARCHAR(200),
			  ConnectionFee DECIMAL(18, 6),
	        Interval1 INT,
	        IntervalN INT,
	        Rate DECIMAL(18, 6),
	        RateN DECIMAL(18, 6),
	        EffectiveDate DATE,
	        EndDate DATE,
	        updated_at DATETIME,
	        updated_by VARCHAR(50),
	        INDEX tmp_VendorRate_RateID (`Code`)
	    );

	    INSERT INTO tmp_VendorRate_
		 SELECT
					VendorRateID,
					Code,
					tblRate.Description,
					tblVendorRate.ConnectionFee,
					CASE WHEN tblVendorRate.Interval1 IS NOT NULL
					THEN tblVendorRate.Interval1
					ELSE tblRate.Interval1
					END AS Interval1,
					CASE WHEN tblVendorRate.IntervalN IS NOT NULL
					THEN tblVendorRate.IntervalN
					ELSE tblRate.IntervalN
					END AS IntervalN ,
					Rate,
					RateN,
					EffectiveDate,
					EndDate,
					tblVendorRate.updated_at,
					tblVendorRate.updated_by
				FROM tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				WHERE (p_contryID IS NULL
				OR CountryID = p_contryID)
				AND (p_code IS NULL
				OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL
				OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND TrunkID = p_trunkID
				AND TimezonesID = p_TimezonesID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_
				AND
					(
					(p_effective = 'Now' AND EffectiveDate <= NOW() )
					OR
					(p_effective = 'Future' AND EffectiveDate > NOW())
					OR
					p_effective = 'All'
					);
		IF p_effective = 'Now'
		THEN
		   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate2_ as (select * from tmp_VendorRate_);
         DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate2_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
		   AND  n1.Code = n2.Code;
		END IF;

		IF p_effective = 'All'
		THEN
		   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate2_ as (select * from tmp_VendorRate_);
         DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate2_ n2 WHERE n1.EffectiveDate <= NOW() AND n2.EffectiveDate <= NOW() AND n1.EffectiveDate < n2.EffectiveDate
		   AND  n1.Code = n2.Code;
		END IF;


		   IF p_isExport = 0
			THEN
		 		SELECT
					VendorRateID,
					Code,
					Description,
					ConnectionFee,
					Interval1,
					IntervalN,
					Rate,
					RateN,
					EffectiveDate,
					EndDate,
					updated_at,
					updated_by

				FROM  tmp_VendorRate_
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
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNDESC') THEN RateN
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateNASC') THEN RateN
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
				LIMIT p_RowspPage OFFSET v_OffSet_;



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
				RateN,
				EffectiveDate,
				EndDate,
				updated_at AS `Modified Date`,
				updated_by AS `Modified By`

			FROM tmp_VendorRate_;
		END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetVendorRatesArchiveGrid
DROP PROCEDURE IF EXISTS `prc_GetVendorRatesArchiveGrid`;
DELIMITER //
CREATE PROCEDURE `prc_GetVendorRatesArchiveGrid`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
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
		vra.RateN,
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
		vra.TrunkID = p_TrunkID AND
		vra.TimezonesID = p_TimezonesID AND
		FIND_IN_SET (r.Code, p_Codes) != 0
	ORDER BY
		vra.EffectiveDate DESC, vra.created_at DESC;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_lcrBlockUnblock
DROP PROCEDURE IF EXISTS `prc_lcrBlockUnblock`;
DELIMITER //
CREATE PROCEDURE `prc_lcrBlockUnblock`(
	IN `p_companyId` INT,
	IN `p_groupby` VARCHAR(200),
	IN `p_blockId` INT,
	IN `p_preference` INT,
	IN `p_accountId` INT,
	IN `p_trunk` INT,
	IN `p_TimezonesID` INT,
	IN `p_rowcode` VARCHAR(50),
	IN `p_codedeckId` INT,
	IN `p_description` VARCHAR(200),
	IN `p_username` VARCHAR(50),
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
								select DISTINCT RateId
								FROM (
								select vr.RateId
									 from tblVendorRate vr
								 	 inner join tblRate r on vr.RateId=r.RateID
								    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID=p_TimezonesID AND r.Description = p_description) tbl;


							IF (p_blockId = 0) THEN

								/* insert into Vendor Blocking by description */
								 insert into tblVendorBlocking (AccountId,RateId,TrunkID,TimezonesID,BlockedBy,BlockedDate)
									    select p_accountId as AccountId, tmp0.RateID as RateId,p_trunk as TrunkID, p_TimezonesID AS TimezonesID,p_username as BlockedBy,NOW() as BlockedDate
										 from  tmp_block0 tmp0
										 	 left join tblVendorBlocking vb
											   on vb.RateId=tmp0.RateID
											   AND vb.AccountId = p_accountId AND vb.TrunkID=p_trunk AND vb.TimezonesID=p_TimezonesID
									    where  vb.VendorBlockingId IS NULL;
							ELSE
								select * from tmp_block0;
								/* Delete from Vendor Blocking by description  */

								DELETE vb
								FROM tblVendorBlocking vb
								INNER JOIN tmp_block0 t
								  ON vb.RateId = t.RateID
								WHERE vb.AccountId = p_accountId AND vb.TrunkID = p_trunk AND vb.TimezonesID=p_TimezonesID ;

							END IF;




				ELSE

						INSERT INTO tmp_block0
								select DISTINCT RateId
								FROM (
								select vr.RateId
									 from tblVendorRate vr
								 	 inner join tblRate r on vr.RateId=r.RateID
								    where vr.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID=p_TimezonesID AND r.Code = p_rowcode) tbl;


						IF	(select COUNT(*)
									 from tblVendorRate vr
									 	 inner join tblRate r
										   on vr.RateId=r.RateID
										 inner join tblVendorBlocking vb
										   on r.RateID=vb.RateId
								    where vb.AccountId = p_accountId AND vr.TrunkID=p_trunk AND vr.TimezonesID=p_TimezonesID AND r.Code = p_rowcode)	= 0
						THEN


							 insert into tblVendorBlocking (AccountId,RateId,TrunkID,TimezonesID,BlockedBy)
							    select p_accountId as AccountId,tmp0.RateID as RateId,p_trunk as TrunkID, p_TimezonesID AS TimezonesID,p_username as BlockedBy
								 from  tmp_block0 tmp0
								 	 left join tblVendorBlocking vb
									   on vb.RateId=tmp0.RateID
									   AND vb.AccountId = p_accountId AND vb.TrunkID=p_trunk AND vb.TimezonesID=p_TimezonesID
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

							 -- select distinct CountryID into v_countryID from tblRate where Code=p_rowcode AND tblRate.CountryID is not null AND tblRate.CountryID!=0;
							  select distinct CountryID into v_countryID from tblRate where Code=p_rowcode AND tblRate.CountryID is not null AND tblRate.CountryID!=0 AND tblRate.CompanyID=p_companyId;
							  INSERT INTO tblVendorBlocking
							  (
									 `AccountId`
									 ,CountryId
									 ,`TrunkID`
									 ,`TimezonesID`
									 ,`BlockedBy`
							  )
							  SELECT
								p_accountId as AccountId
								,tblCountry.CountryID as CountryId
								,p_trunk as TrunkID
								,p_TimezonesID AS TimezonesID
								,p_username as BlockedBy
								FROM    tblCountry
								LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunk AND TimezonesID = p_TimezonesID AND AccountId = p_accountId
								WHERE  tblCountry.CountryID=v_countryID  AND tblVendorBlocking.VendorBlockingId is null;

				  END IF;

				  if(p_action ='country_unblock')
				  THEN

				  	delete  from tblVendorBlocking
					WHERE  AccountId = p_accountId AND TrunkID = p_trunk AND TimezonesID = p_TimezonesID AND ( p_countryBlockingID ='' OR FIND_IN_SET(CountryId, p_countryBlockingID) );


				  END IF;
			   /* Country Blocking Code End */
	    END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_LowBalanceReminder
DROP PROCEDURE IF EXISTS `prc_LowBalanceReminder`;
DELIMITER //
CREATE PROCEDURE `prc_LowBalanceReminder`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_BillingClassID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL RMBilling3.prc_updateSOAOffSet(p_CompanyID,p_AccountID);
	
	
	SELECT
			DISTINCT
			IF ( (
					CASE WHEN ab.BalanceThreshold LIKE '%p' 
						THEN REPLACE(ab.BalanceThreshold, 'p', '')/ 100 * ab.PermanentCredit 
							ELSE ab.BalanceThreshold END
					) > CASE WHEN abg.BillingType = 1 THEN 
					        (CASE WHEN ab.BalanceAmount <0 THEN ABS(ab.BalanceAmount) ELSE (ab.BalanceAmount * -1) END) ELSE ab.BalanceAmount END 
							  	 AND ab.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
			a.AccountID
		FROM tblAccountBalance ab 
		INNER JOIN tblAccount a 
			ON a.AccountID = ab.AccountID
		INNER JOIN tblAccountBilling abg
			ON abg.AccountID  = a.AccountID  AND abg.ServiceID = 0
		INNER JOIN tblBillingClass b
			ON b.BillingClassID = abg.BillingClassID
		WHERE a.CompanyId = p_CompanyID
		AND (p_AccountID = 0 OR  a.AccountID = p_AccountID)
		AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
		AND ab.PermanentCredit IS NOT NULL
		AND ab.BalanceThreshold IS NOT NULL
		AND a.`Status` = 1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_ProcessDiscountPlan
DROP PROCEDURE IF EXISTS `prc_ProcessDiscountPlan`;
DELIMITER //
CREATE PROCEDURE `prc_ProcessDiscountPlan`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN
	
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_AccountID_ INT;
	DECLARE v_ServiceID_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
	DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
	CREATE TEMPORARY TABLE tmp_Accounts_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		ServiceID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_Accounts_(AccountID,ServiceID)
	SELECT DISTINCT ud.AccountID,ud.ServiceID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN tblAccountDiscountPlan adp
		ON ud.AccountID = adp.AccountID 
		AND ud.ServiceID = adp.ServiceID
		AND Type = 1
	WHERE ProcessID="' , p_processId , '" AND ud.is_inbound = 0;
	');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;	

	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_Accounts_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_AccountID_ = (SELECT AccountID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
		SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
			
		 CALL prc_putDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,0,v_ServiceID_);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
	CREATE TEMPORARY TABLE tmp_Accounts_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		ServiceID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_Accounts_(AccountID,ServiceID)
	SELECT DISTINCT ud.AccountID,ud.ServiceID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN tblAccountDiscountPlan adp
		ON ud.AccountID = adp.AccountID 
		AND ud.ServiceID = adp.ServiceID
		AND Type = 2
	WHERE ProcessID="' , p_processId , '" AND ud.is_inbound = 1;
	');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
		
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_Accounts_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_AccountID_ = (SELECT AccountID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
		SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
		
		 CALL prc_putDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,1,v_ServiceID_);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_putDiscountPlan
DROP PROCEDURE IF EXISTS `prc_putDiscountPlan`;
DELIMITER //
CREATE PROCEDURE `prc_putDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_processId` INT,
	IN `p_inbound` INT,
	IN `p_ServiceID` INT
)
ThisSP:BEGIN

	DECLARE v_pointer_ INT;
	DECLARE v_pointer_AccountName_ INT;
	DECLARE v_pointer_AccountCLI_ INT;
	DECLARE v_rowCount_AccountName_ INT;
	DECLARE v_rowCount_AccountCLI_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_ServiceID_ INT;
	DECLARE v_AccountDiscountPlanID_ INT;
	

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_Discount_AccountName;
	CREATE TEMPORARY TABLE tmp_Discount_AccountName  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		AccountDiscountPlanID INT,
		ServiceID INT
	);
	
		INSERT INTO tmp_Discount_AccountName(AccountID,AccountDiscountPlanID,ServiceID)
		SELECT AccountID,AccountDiscountPlanID,ServiceID
		FROM tblAccountDiscountPlan
		WHERE AccountID=p_AccountID
				AND ( (p_inbound = 0 AND Type = 1) OR  (p_inbound = 1 AND Type = 2 ) )
		      AND ServiceID=p_ServiceID
				AND AccountName!='';
		
		SET v_pointer_AccountName_ = 1;
		SET v_rowCount_AccountName_ = (SELECT COUNT(*)FROM tmp_Discount_AccountName);

		WHILE v_pointer_AccountName_ <= v_rowCount_AccountName_
		DO

			SET v_AccountID_ = (SELECT AccountID FROM tmp_Discount_AccountName t WHERE t.RowID = v_pointer_AccountName_);
			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Discount_AccountName t WHERE t.RowID = v_pointer_AccountName_);
			SET v_AccountDiscountPlanID_ = (SELECT AccountDiscountPlanID FROM tmp_Discount_AccountName t WHERE t.RowID = v_pointer_AccountName_);

			 CALL prc_applyAccountDiscountPlan(v_AccountID_, p_tbltempusagedetail_name, p_processId, p_inbound, v_ServiceID_, v_AccountDiscountPlanID_, 1, 0);
			
			SET v_pointer_AccountName_ = v_pointer_AccountName_ + 1;
		END WHILE;


	DROP TEMPORARY TABLE IF EXISTS tmp_Discount_AccountCLI;
	CREATE TEMPORARY TABLE tmp_Discount_AccountCLI  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		AccountDiscountPlanID INT,
		ServiceID INT
	);

	INSERT INTO tmp_Discount_AccountCLI(AccountID,AccountDiscountPlanID,ServiceID)
	SELECT AccountID,AccountDiscountPlanID,ServiceID FROM tblAccountDiscountPlan where AccountID=p_AccountID AND ( (p_inbound = 0 AND Type = 1) OR  (p_inbound = 1 AND Type = 2 ) ) AND ServiceID=p_ServiceID AND AccountCLI!='';
	
	SET v_pointer_AccountCLI_ = 1;
	SET v_rowCount_AccountCLI_ = (SELECT COUNT(*)FROM tmp_Discount_AccountCLI);

	WHILE v_pointer_AccountCLI_ <= v_rowCount_AccountCLI_
	DO

		SET v_AccountID_ = (SELECT AccountID FROM tmp_Discount_AccountCLI t WHERE t.RowID = v_pointer_AccountCLI_);
		SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Discount_AccountCLI t WHERE t.RowID = v_pointer_AccountCLI_);
		SET v_AccountDiscountPlanID_ = (SELECT AccountDiscountPlanID FROM tmp_Discount_AccountCLI t WHERE t.RowID = v_pointer_AccountName_);
		
		 CALL prc_applyAccountDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,p_inbound,v_ServiceID_,v_AccountDiscountPlanID_,0,1);
		
		SET v_pointer_AccountCLI_ = v_pointer_AccountCLI_ + 1;
	END WHILE;
	
	SET v_AccountDiscountPlanID_ = 0;
	
		/* get discount plan id*/
	SELECT 
		AccountDiscountPlanID
	INTO  
		v_AccountDiscountPlanID_
	FROM tblAccountDiscountPlan 
	WHERE AccountID = p_AccountID 
	AND  ServiceID = p_ServiceID
	AND  (AccountSubscriptionID = 0)
	AND  ( (p_inbound = 0 AND Type = 1) OR  (p_inbound = 1 AND Type = 2 ) );
	

	IF (v_AccountDiscountPlanID_ > 0)
	THEN 				
			CALL prc_applyAccountDiscountPlan(p_AccountID,p_tbltempusagedetail_name,p_processId,p_inbound,p_ServiceID,v_AccountDiscountPlanID_,0,0); 
	
	END IF; 
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_RateCompare
DROP PROCEDURE IF EXISTS `prc_RateCompare`;
DELIMITER //
CREATE PROCEDURE `prc_RateCompare`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` INT,
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


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_tmp;
		CREATE TEMPORARY TABLE tmp_VendorRate_tmp (
			AccountId INT ,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			RateID INT,
			Description VARCHAR(200) ,
			Rate DECIMAL(18,6),
			EffectiveDate DATE ,
			TrunkID INT ,
			VendorRateID INT,

			index (AccountId),
			index (RateID),
			index (EffectiveDate)

		);

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
			VendorRateID INT,

			index (AccountId),
			index (RateID),
			index (EffectiveDate)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRate_tmp;
		CREATE TEMPORARY TABLE tmp_CustomerRate_tmp (
			AccountId INT ,
			AccountName VARCHAR(100) ,
			Code VARCHAR(50) ,
			RateID INT,
			Description VARCHAR(200) ,
			Rate DECIMAL(18,6) ,
			EffectiveDate DATE ,
			TrunkID INT,
			CustomerRateId INT,

			index (AccountId),
			index (RateID),
			index (EffectiveDate)
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
			CustomerRateId INT,

			index (AccountId),
			index (RateID),
			index (EffectiveDate)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_tmp;
		CREATE TEMPORARY TABLE tmp_RateTableRate_tmp (
			RateTableName VARCHAR(200) ,
			RateID INT,
			Code VARCHAR(50) ,
			Description VARCHAR(200) ,
			Rate DECIMAL(18,6) ,
			EffectiveDate DATE ,
			RateTableID INT,
			RateTableRateID INT,

			index (RateTableID),
			index (RateID),
			index (EffectiveDate)
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
			RateTableRateID INT,

			index (RateTableID),
			index (RateID),
			index (EffectiveDate)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_ (
			Code  varchar(50),
			Description  varchar(250),
			RateID int,
			INDEX Index1 (Code),
			INDEX Index2 (Description)
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

			INSERT INTO tmp_VendorRate_tmp ( AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , VendorRateID )


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
								 AND tblVendorRate.TimezonesID = p_TimezonesID
								 AND blockCode.RateId IS NULL
								 AND blockCountry.CountryId IS NULL
								 AND ( tblVendorRate.EndDate IS NULL OR  tblVendorRate.EndDate > Now() )
								 AND
								 (
									 ( p_Effective = 'Now' AND tblVendorRate.EffectiveDate <= NOW() )
									 OR
									 ( p_Effective = 'Future' AND tblVendorRate.EffectiveDate > NOW())
									 OR (

										 p_Effective = 'Selected' AND tblVendorRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
										 AND ( tblVendorRate.EndDate IS NULL OR (tblVendorRate.EndDate > DATE(p_SelectedEffectiveDate)) )
									 )
								 )
				ORDER BY tblRate.Code asc;

				 INSERT INTO tmp_VendorRate_
					  Select AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , VendorRateID
				      FROM (
							  SELECT * ,
								@row_num := IF(@prev_AccountId = AccountID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								@prev_AccountId := AccountID,
								@prev_RateId := RateID,
								@prev_EffectiveDate := EffectiveDate
							  FROM tmp_VendorRate_tmp
							  ,(SELECT @row_num := 1,  @prev_AccountId := '', @prev_RateId := '', @prev_EffectiveDate := '') x
				           ORDER BY AccountId, RateId, EffectiveDate DESC
						) tbl
						 WHERE RowID = 1
						order by Code asc;


		END IF;

		IF p_source_customers != '' OR p_destination_customers != '' THEN

			INSERT INTO tmp_CustomerRate_tmp ( AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , CustomerRateID )
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
						AND tblCustomerRate.TimezonesID = p_TimezonesID
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


			 		  INSERT INTO tmp_CustomerRate_
					  Select AccountId ,AccountName ,		Code ,		RateID , 	Description , Rate , EffectiveDate , TrunkID , CustomerRateID
				      FROM (
							  SELECT * ,
								@row_num := IF(@prev_AccountId = AccountID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								@prev_AccountId := AccountID,
								@prev_RateId := RateID,
								@prev_EffectiveDate := EffectiveDate
							  FROM tmp_CustomerRate_tmp
							  ,(SELECT @row_num := 1,  @prev_AccountId := '', @prev_RateId := '', @prev_EffectiveDate := '') x
				           ORDER BY AccountId, RateId, EffectiveDate DESC
						) tbl
						 WHERE RowID = 1
						order by Code asc;


		END IF;


		IF p_source_rate_tables != '' OR p_destination_rate_tables != '' THEN

			INSERT INTO tmp_RateTableRate_tmp ( RateTableName ,RateID ,		Code , Description , Rate , EffectiveDate , RateTableID , RateTableRateID )
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
					tblRateTableRate.TimezonesID = p_TimezonesID AND
					(
						( p_Effective = 'Now' AND tblRateTableRate.EffectiveDate <= NOW() )
						OR
						( p_Effective = 'Future' AND tblRateTableRate.EffectiveDate > NOW())
						OR (

							p_Effective = 'Selected' AND tblRateTableRate.EffectiveDate <= DATE(p_SelectedEffectiveDate)
						)
					)

				ORDER BY Code asc;


				INSERT INTO tmp_RateTableRate_
					  Select RateTableName ,RateID ,		Code , Description , Rate , EffectiveDate , RateTableID , RateTableRateID
				      FROM (
							  SELECT * ,
								@row_num := IF(@prev_RateTableID = RateTableID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								@prev_RateTableID := RateTableID,
								@prev_RateId := RateID,
								@prev_EffectiveDate := EffectiveDate
							  FROM tmp_RateTableRate_tmp
							  ,(SELECT @row_num := 1,  @prev_RateTableID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
				           ORDER BY RateTableID, RateId, EffectiveDate DESC
						) tbl
						 WHERE RowID = 1
						order by Code asc;

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

-- Dumping structure for procedure Ratemanagement3.prc_RateTableCheckDialstringAndDupliacteCode
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID`,
		`Code`,
		`Description`,
		`Rate`,
		`RateN`,
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
	SELECT count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl;

	IF  totalduplicatecode > 0
	THEN

		SELECT GROUP_CONCAT(code) into errormessage FROM(
		SELECT DISTINCT code, 1 as a FROM(
		SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl) as tbl2 GROUP by a;

		INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT
			CONCAT(code , ' DUPLICATE CODE')
		FROM(
			SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate,DialStringPrefix,TimezonesID HAVING c>1) AS tbl;
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

							ON vr.DialStringPrefix = ds.DialString AND ds.DialStringID = p_dialStringId
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
					`TimezonesID`,
					`DialString`,
					CASE WHEN ds.Description IS NULL OR ds.Description = ''
					THEN
						tblTempRateTableRate.Description
					ELSE
						ds.Description
					END
					AS Description,
					`Rate`,
					`RateN`,
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
					TimezonesID,
					Code,
					Description,
					Rate,
					RateN,
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
					`TimezonesID`,
					`Code`,
					`Description`,
					`Rate`,
					`RateN`,
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

-- Dumping structure for procedure Ratemanagement3.prc_RateTableRateUpdateDelete
DROP PROCEDURE IF EXISTS `prc_RateTableRateUpdateDelete`;
DELIMITER //
CREATE PROCEDURE `prc_RateTableRateUpdateDelete`(
	IN `p_RateTableId` INT,
	IN `p_RateTableRateId` LONGTEXT,
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Rate` DECIMAL(18,6),
	IN `p_RateN` DECIMAL(18,6),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ConnectionFee` decimal(18,6),
	IN `p_Critearea_CountryId` INT,
	IN `p_Critearea_Code` varchar(50),
	IN `p_Critearea_Description` varchar(200),
	IN `p_Critearea_Effective` VARCHAR(50),
	IN `p_TimezonesID` INT,
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
		`TimezonesID` int(11) NOT NULL,
		`Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
		`RateN` decimal(18,6) NOT NULL DEFAULT '0.000000',
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
		rtr.TimezonesID,
		IFNULL(p_Rate,rtr.Rate) AS Rate,
		IFNULL(p_RateN,rtr.RateN) AS RateN,
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
					EffectiveDate=p_EffectiveDate AND TimezonesID=p_TimezonesID AND
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
		rtr.RateTableId = p_RateTableId AND
		rtr.TimezonesID = p_TimezonesID;

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

	CALL prc_ArchiveOldRateTableRate(p_RateTableId,p_TimezonesID,p_ModifiedBy);

	IF p_action = 1
	THEN

		INSERT INTO tblRateTableRate (
			RateId,
			RateTableId,
			TimezonesID,
			Rate,
			RateN,
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
			TimezonesID,
			Rate,
			RateN,
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

-- Dumping structure for procedure Ratemanagement3.prc_RateTableRateUpdatePreviousRate
DROP PROCEDURE IF EXISTS `prc_RateTableRateUpdatePreviousRate`;
DELIMITER //
CREATE PROCEDURE `prc_RateTableRateUpdatePreviousRate`(
	IN `p_RateTableID` INT,
	IN `p_EffectiveDate` VARCHAR(50)
)
BEGIN

	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;


	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;




	IF p_EffectiveDate != '' THEN

			-- front end update , tmp_Update_RateTable_ table required

			SET  @EffectiveDate = STR_TO_DATE(p_EffectiveDate , '%Y-%m-%d');


			SET @row_num = 0;

			-- update  previous rate with all latest recent entriy of previous effective date
			UPDATE tblRateTableRate rtr
			inner join
			(
				-- get all rates RowID = 1 to remove old to old effective date
				select distinct tmp.* ,
				@row_num := IF(@prev_RateId = tmp.RateID AND @prev_EffectiveDate >= tmp.EffectiveDate, (@row_num + 1), 1) AS RowID,
				@prev_RateId := tmp.RateID,
				@prev_EffectiveDate := tmp.EffectiveDate
				FROM
				(
					select distinct rt1.*
					from tblRateTableRate rt1
					inner join tblRateTableRate rt2
					on rt1.RateTableId = p_RateTableId and rt1.RateID = rt2.RateID AND rt1.TimezonesID = rt2.TimezonesID
					where
					rt1.RateTableID = p_RateTableId
					and rt1.EffectiveDate < rt2.EffectiveDate AND rt2.EffectiveDate  = @EffectiveDate
					order by rt1.RateID desc ,rt1.EffectiveDate desc
				) tmp

			) old_rtr on  old_rtr.RateTableID = rtr.RateTableID  and old_rtr.RateID = rtr.RateID AND plo_rtr.TimezonesID = rtr.TimezonesID
			and old_rtr.EffectiveDate < rtr.EffectiveDate AND rtr.EffectiveDate =  @EffectiveDate AND old_rtr.RowID = 1
			SET rtr.PreviousRate = old_rtr.Rate
			where
			rtr.RateTableID = p_RateTableId;


	ELSE

		-- update for job

		DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
			CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
				EffectiveDate  Date,
				RowID int,
				INDEX (RowID)
			);



		-- loop through effective date to update previous rate

		INSERT INTO tmp_EffectiveDates_
		SELECT distinct
			EffectiveDate,
			@row_num := @row_num+1 AS RowID
		FROM tblRateTableRate a
			,(SELECT @row_num := 0) x
		WHERE  RateTableID = p_RateTableID
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
				UPDATE tblRateTableRate rtr
				inner join
				(
					-- get all rates RowID = 1 to remove old to old effective date

					select distinct tmp.* ,
					@row_num := IF(@prev_RateId = tmp.RateID AND @prev_EffectiveDate >= tmp.EffectiveDate, (@row_num + 1), 1) AS RowID,
					@prev_RateId := tmp.RateID,
					@prev_EffectiveDate := tmp.EffectiveDate
					FROM
					(
						select distinct rt1.*
						from tblRateTableRate rt1
						inner join tblRateTableRate rt2
						on rt1.RateTableId = p_RateTableId and rt1.RateID = rt2.RateID AND rt1.TimezonesID=rt2.TimezonesID
						where
						rt1.RateTableID = p_RateTableId
						and rt1.EffectiveDate < rt2.EffectiveDate AND rt2.EffectiveDate  = @EffectiveDate
						order by rt1.RateID desc ,rt1.EffectiveDate desc
					) tmp


				) old_rtr on  old_rtr.RateTableID = rtr.RateTableID  and old_rtr.RateID = rtr.RateID AND old_rtr.TimezonesID = rtr.TimezonesID and old_rtr.EffectiveDate < rtr.EffectiveDate
				AND rtr.EffectiveDate =  @EffectiveDate  AND old_rtr.RowID = 1
				SET rtr.PreviousRate = old_rtr.Rate
				where
				rtr.RateTableID = p_RateTableID;


				SET v_pointer_ = v_pointer_ + 1;


			END WHILE;

		END IF;

		-- Previous rate update


	END IF;


	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_setAccountDiscountPlan
DROP PROCEDURE IF EXISTS `prc_setAccountDiscountPlan`;
DELIMITER //
CREATE PROCEDURE `prc_setAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_DiscountPlanID` INT,
	IN `p_Type` INT,
	IN `p_BillingDays` INT,
	IN `p_DayDiff` INT,
	IN `p_CreatedBy` VARCHAR(50),
	IN `p_Today` DATETIME,
	IN `p_ServiceID` INT,
	IN `p_AccountSubscriptionID` INT,
	IN `p_AccountName` VARCHAR(255),
	IN `p_AccountCLI` VARCHAR(255),
	IN `p_SubscriptionDiscountPlanID` INT
)
BEGIN
	
	DECLARE v_AccountDiscountPlanID INT;
	DECLARE v_StartDate DATE;
	DECLARE v_EndDate DATE;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF (SELECT COUNT(*) FROM tblAccountBilling WHERE AccountID = p_AccountID AND ServiceID = p_ServiceID) > 0
	THEN
		SELECT StartDate,EndDate INTO v_StartDate,v_EndDate FROM tblAccountBillingPeriod WHERE AccountID = p_AccountID AND ServiceID = p_ServiceID AND StartDate <= DATE(p_Today) AND EndDate > DATE(p_Today);
	ELSE
		SELECT StartDate,EndDate INTO v_StartDate,v_EndDate FROM tblAccountBillingPeriod WHERE AccountID = p_AccountID AND ServiceID = 0 AND StartDate <= DATE(p_Today) AND EndDate > DATE(p_Today);
	END IF;
	

	INSERT INTO tblAccountDiscountPlanHistory(AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,Applied,Changed,StartDate,EndDate,ServiceID,AccountSubscriptionID,AccountName,AccountCLI,SubscriptionDiscountPlanID)
	SELECT AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,created_at,p_Today,StartDate,EndDate,ServiceID,AccountSubscriptionID,AccountName,AccountCLI,SubscriptionDiscountPlanID 
		FROM tblAccountDiscountPlan
	WHERE AccountID = p_AccountID 
			AND ServiceID = p_ServiceID
			AND Type = p_Type
			AND AccountSubscriptionID=p_AccountSubscriptionID
			AND AccountName=p_AccountName
			AND AccountCLI=p_AccountCLI
			AND SubscriptionDiscountPlanID=p_SubscriptionDiscountPlanID;
	

	INSERT INTO tblAccountDiscountSchemeHistory (AccountDiscountSchemeID,AccountDiscountPlanID,DiscountID,Threshold,Discount,Unlimited,SecondsUsed)
	SELECT ads.AccountDiscountSchemeID,ads.AccountDiscountPlanID,ads.DiscountID,ads.Threshold,ads.Discount,ads.Unlimited,ads.SecondsUsed 
	FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
		AND adp.ServiceID = p_ServiceID
		AND Type = p_Type
		AND AccountSubscriptionID=p_AccountSubscriptionID
		AND AccountName=p_AccountName
		AND AccountCLI=p_AccountCLI
		AND SubscriptionDiscountPlanID=p_SubscriptionDiscountPlanID;
	
	DELETE ads FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
	   AND adp.ServiceID = p_ServiceID
		AND Type = p_Type
		AND AccountSubscriptionID=p_AccountSubscriptionID
		AND AccountName=p_AccountName
		AND AccountCLI=p_AccountCLI
		AND SubscriptionDiscountPlanID=p_SubscriptionDiscountPlanID;
		
	DELETE FROM tblAccountDiscountPlan
	WHERE AccountID = p_AccountID
			AND ServiceID = p_ServiceID
			AND Type = p_Type
			AND AccountSubscriptionID=p_AccountSubscriptionID
			AND AccountName=p_AccountName
			AND AccountCLI=p_AccountCLI
			AND SubscriptionDiscountPlanID=p_SubscriptionDiscountPlanID; 
	
	IF p_DiscountPlanID > 0
	THEN
	 
		INSERT INTO tblAccountDiscountPlan (AccountID,DiscountPlanID,Type,CreatedBy,created_at,StartDate,EndDate,ServiceID,AccountSubscriptionID,AccountName,AccountCLI,SubscriptionDiscountPlanID)
		VALUES (p_AccountID,p_DiscountPlanID,p_Type,p_CreatedBy,p_Today,v_StartDate,v_EndDate,p_ServiceID,p_AccountSubscriptionID,p_AccountName,p_AccountCLI,p_SubscriptionDiscountPlanID);
		
		SET v_AccountDiscountPlanID = LAST_INSERT_ID(); 
		
		INSERT INTO tblAccountDiscountScheme(AccountDiscountPlanID,DiscountID,Threshold,Discount,Unlimited)
		SELECT v_AccountDiscountPlanID,d.DiscountID,Threshold*(p_DayDiff/p_BillingDays),Discount,Unlimited
		FROM tblDiscountPlan dp
		INNER JOIN tblDiscount d 
			ON d.DiscountPlanID = dp.DiscountPlanID
		INNER JOIN tblDiscountScheme ds
			ON ds.DiscountID = d.DiscountID
		WHERE dp.DiscountPlanID = p_DiscountPlanID;
	
	END IF;
  
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_SplitAndInsertRateTableRate
DROP PROCEDURE IF EXISTS `prc_SplitAndInsertRateTableRate`;
DELIMITER //
CREATE PROCEDURE `prc_SplitAndInsertRateTableRate`(
	IN `TempRateTableRateID` INT,
	IN `Code` VARCHAR(500),
	IN `p_countryCode` VARCHAR(50)
)
BEGIN

	DECLARE v_First_ VARCHAR(255);
	DECLARE v_Last_ VARCHAR(255);

	SELECT  REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 1)
					, LENGTH(SUBSTRING_INDEX(Code, '-', 0)) + 1)
					, '-'
					, '') INTO v_First_;

	SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 2)
					, LENGTH(SUBSTRING_INDEX(Code, '-', 1)) + 1)
					, '-'
					, '') INTO v_Last_;

	SET v_First_ = CONCAT(p_countryCode,v_First_);
	SET v_Last_ = CONCAT(p_countryCode,v_Last_);

	WHILE v_Last_ >= v_First_
	DO
		INSERT my_splits (TempRateTableRateID,Code,CountryCode) VALUES (TempRateTableRateID,v_Last_,'');
		SET v_Last_ = v_Last_ - 1;
	END WHILE;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_SplitAndInsertVendorRate
DROP PROCEDURE IF EXISTS `prc_SplitAndInsertVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_SplitAndInsertVendorRate`(
	IN `TempVendorRateID` INT,
	IN `Code` VARCHAR(500),
	IN `p_countryCode` VARCHAR(50)
)
BEGIN

	DECLARE v_First_ VARCHAR(255);
	DECLARE v_Last_ VARCHAR(255);

	SELECT  REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 1)
			, LENGTH(SUBSTRING_INDEX(Code, '-', 0)) + 1)
			, '-'
			, '') INTO v_First_;

	SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 2)
			, LENGTH(SUBSTRING_INDEX(Code, '-', 1)) + 1)
			, '-'
			, '') INTO v_Last_;

	SET v_First_ = CONCAT(p_countryCode,v_First_);
	SET v_Last_ = CONCAT(p_countryCode,v_Last_);

	WHILE v_Last_ >= v_First_
	DO
		INSERT my_splits (TempVendorRateID,Code,CountryCode) VALUES (TempVendorRateID,v_Last_,'');
		SET v_Last_ = v_Last_ - 1;
	END WHILE;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_SplitRateTableRate
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
			`TimezonesID`,
			CONCAT(IFNULL(my_splits.CountryCode,''),my_splits.Code) as Code,
			`Description`,
			`Rate`,
			`RateN`,
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
			`TimezonesID`,
			CONCAT(IFNULL(tblTempRateTableRate.CountryCode,''),tblTempRateTableRate.Code) as Code,
			`Description`,
			`Rate`,
			`RateN`,
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

-- Dumping structure for procedure Ratemanagement3.prc_SplitVendorRate
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
		   `TimezonesID`,
		   CONCAT(IFNULL(my_splits.CountryCode,''),my_splits.Code) as Code,
		   `Description`,
			`Rate`,
			`RateN`,
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
			  `TimezonesID`,
			   CONCAT(IFNULL(tblTempVendorRate.CountryCode,''),tblTempVendorRate.Code) as Code,
			   `Description`,
				`Rate`,
				`RateN`,
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

-- Dumping structure for procedure Ratemanagement3.prc_UpdateDynamicFieldStatus
DROP PROCEDURE IF EXISTS `prc_UpdateDynamicFieldStatus`;
DELIMITER //
CREATE PROCEDURE `prc_UpdateDynamicFieldStatus`(
	IN `d_CompanyID` INT,
	IN `d_user_name` VARCHAR(50),
	IN `d_Type` VARCHAR(50),
	IN `d_FieldName` VARCHAR(50),
	IN `d_FieldDomType` VARCHAR(50),
	IN `d_ItemTypeID` VARCHAR(50),
	IN `d_Status` INT,
	IN `d_status_set` INT


)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	UPDATE tblDynamicFields d
	SET d.Status=d_status_set 
	WHERE d.CompanyID = d_CompanyID
		AND d.`Type`= d_Type
		AND(d_FieldName = '' OR d.FieldName like Concat('%',d_FieldName,'%'))
		AND(d_FieldDomType = '' OR d.FieldDomType like Concat('%',d_FieldDomType,'%'))
      AND(d_Status = 9 OR d.Status = d_Status)
      ;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_UpdateMysqlPID
DROP PROCEDURE IF EXISTS `prc_UpdateMysqlPID`;
DELIMITER //
CREATE PROCEDURE `prc_UpdateMysqlPID`(
	IN `p_processId` VARCHAR(200)

)
BEGIN
	DECLARE MysqlPID VARCHAR(200);
	  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		
		SELECT CONNECTION_ID() into MysqlPID;
		
		UPDATE tblCronJob
			SET MysqlPID=MysqlPID
		WHERE ProcessID=p_processId;

	  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_VendorBlockUnblockByAccount
DROP PROCEDURE IF EXISTS `prc_VendorBlockUnblockByAccount`;
DELIMITER //
CREATE PROCEDURE `prc_VendorBlockUnblockByAccount`(
	IN `p_CompanyId` int,
	IN `p_AccountId` int,
	IN `p_code` VARCHAR(50),
	IN `p_RateId` longtext,
	IN `p_CountryId` longtext,
	IN `p_TrunkID` varchar(50) ,
	IN `p_TimezonesID` INT,
	IN `p_Username` varchar(100),
	IN `p_action` varchar(100)
)
BEGIN

  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  if(p_action ='country_block')
  THEN

			  INSERT INTO tblVendorBlocking
			  (
					 `AccountId`
					 ,CountryId
					 ,`TrunkID`
					 ,`TimezonesID`
					 ,`BlockedBy`
			  )
			  SELECT
				p_AccountId as AccountId
				,tblCountry.CountryID as CountryId
				,p_TrunkID as TrunkID
				,p_TimezonesID as TimezonesID
				,p_Username as BlockedBy
				FROM    tblCountry
				LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_TrunkID AND TimezonesID = p_TimezonesID AND AccountId = p_AccountId
				WHERE  ( p_CountryId ='' OR  FIND_IN_SET(tblCountry.CountryID, p_CountryId) ) AND tblVendorBlocking.VendorBlockingId is null;

  END IF;

  if(p_action ='country_unblock')
  THEN

	delete  from tblVendorBlocking
	WHERE  AccountId = p_AccountId AND TrunkID = p_TrunkID AND TimezonesID = p_TimezonesID AND ( p_CountryId ='' OR FIND_IN_SET(CountryId, p_CountryId) );


  END IF;

  IF(p_action ='code_block')
  THEN

					IF(p_RateId = '' )
					THEN

					  INSERT INTO tblVendorBlocking
					  (
						 `AccountId`
						 ,`RateId`
						 ,`TrunkID`
					 	 ,`TimezonesID`
						 ,`BlockedBy`
					  )
					  SELECT tblVendorRate.AccountID, tblVendorRate.RateId ,tblVendorRate.TrunkID,tblVendorRate.TimezonesID,p_Username as BlockedBy
					  FROM    `tblRate`
					  INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountID = p_AccountId AND tblVendorRate.TrunkID = p_TrunkID AND tblVendorRate.TimezonesID = p_TimezonesID
					  INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountId AND tblVendorTrunk.TrunkID = p_TrunkID
					  LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
					  WHERE tblVendorBlocking.VendorBlockingId is null AND ( tblRate.CompanyID = p_CompanyId ) AND ( p_code = '' OR  tblRate.Code LIKE REPLACE(p_code,'*', '%') );

					ELSE

						  INSERT INTO tblVendorBlocking
						  (
							 `AccountId`
							 ,`RateId`
							 ,`TrunkID`
					 	 	 ,`TimezonesID`
							 ,`BlockedBy`
						  )
						  SELECT p_AccountId as AccountId, RateID ,p_TrunkID as TrunkID ,p_TimezonesID as TimezonesID ,p_Username as BlockedBy
						  FROM tblRate
						  WHERE FIND_IN_SET(RateId, p_RateId) > 0 AND CompanyID = p_CompanyId;


			 		END IF;

END IF;
 IF(p_action ='code_unblock')
  THEN

			IF(p_RateId = ''  ) THEN


				delete tblVendorBlocking from tblVendorBlocking
					INNER JOIN(
						select VendorBlockingId
						FROM `tblVendorBlocking` vb
						INNER JOIN
						(
							SELECT tblRate.RateID ,tblVendorRate.AccountID
								FROM    `tblRate`
							INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountID = p_AccountId AND tblVendorRate.TrunkID = p_TrunkID AND tblVendorRate.TimezonesID = p_TimezonesID
							INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountId AND tblVendorTrunk.TrunkID = p_TrunkID
							LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.TimezonesID = tblVendorBlocking.TimezonesID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
							WHERE ( tblRate.CompanyID = p_CompanyId )
							 AND ( p_code = '' OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
						) v on v.AccountID = vb.AccountId  AND  vb.RateID = v.RateID AND vb.TrunkID = p_TrunkID AND vb.TimezonesID = p_TimezonesID

					)vb2 on vb2.VendorBlockingId=tblVendorBlocking.VendorBlockingId;

			ELSE


				delete tblVendorBlocking from tblVendorBlocking WHERE AccountId = p_AccountId AND TrunkID = p_TrunkID AND TimezonesID = p_TimezonesID AND FIND_IN_SET(RateId, p_RateId) > 0;


			END IF;

  END IF;

  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_VendorPreferenceUpdateBySelectedRateId
DROP PROCEDURE IF EXISTS `prc_VendorPreferenceUpdateBySelectedRateId`;
DELIMITER //
CREATE PROCEDURE `prc_VendorPreferenceUpdateBySelectedRateId`(
	IN `p_CompanyId` INT,
	IN `p_AccountId` LONGTEXT ,
	IN `p_RateIDList` LONGTEXT ,
	IN `p_TrunkId` INT,
	IN `p_TimezonesID` INT,
	IN `p_Preference` INT,
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_contryID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_description` VARCHAR(50),
	IN `p_action` INT
)
BEGIN


	DECLARE v_CodeDeckId_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;

	IF p_action = 0
	THEN
			  DROP TEMPORARY TABLE IF EXISTS tblVendorRate_;
			  CREATE TEMPORARY TABLE tblVendorRate_  (
				RateID INT(11),
				INDEX tmp_RateID (`RateID`)
			  );

			  INSERT INTO tblVendorRate_
			  SELECT RateID from tblRate
				where FIND_IN_SET(RateID,p_RateIDList);

			  SELECT *FROM	tblVendorRate_;
	END IF;

	IF p_action = 1
	THEN
			DROP TEMPORARY TABLE IF EXISTS tblVendorRate_;
			  CREATE TEMPORARY TABLE tblVendorRate_  (
				RateID INT(11),
				INDEX tmp_RateID (`RateID`)
			  );

			INSERT INTO tblVendorRate_
			SELECT
				tblRate.RateID as RateID
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.TimezonesID = tblVendorRate.TimezonesID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.TimezonesID = p_TimezonesID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;
	END IF;

			UPDATE  tblVendorPreference v
		    INNER JOIN (
			select  tvp.VendorPreferenceID,tvp.RateId from tblVendorPreference tvp
			LEFT JOIN tblVendorRate_ vr on tvp.RateId = vr.RateID
			  where tvp.AccountId = p_AccountId
				and tvp.TrunkID = p_TrunkId
				and tvp.TimezonesID = p_TimezonesID
				and vr.RateID IS NOT NULL
		    )vp on vp.VendorPreferenceID = v.VendorPreferenceID
			SET Preference = p_Preference;

			INSERT  INTO tblVendorPreference
		   (  RateID ,
			AccountId ,
			  TrunkID ,
			  TimezonesID ,
			  Preference,
			  CreatedBy,
			  created_at
		   )

		   SELECT  DISTINCT
			 vr.RateID,
			 p_AccountId ,
			 p_TrunkId,
			 p_TimezonesID,
			 p_Preference ,
			 p_ModifiedBy,
			 NOW()
			 from tblVendorRate_ vr
			 LEFT JOIN tblVendorPreference vp
				ON vr.RateID = vp.RateID and vp.AccountId = p_AccountId and vp.TrunkID = p_TrunkId and vp.TimezonesID = p_TimezonesID
				where vp.RateID is null;

			IF p_Preference = 0
			THEN
			delete tblVendorPreference FROM tblVendorPreference INNER JOIN(
				select vr.RateId FROM tblVendorRate_ vr)
				tr on tr.RateId=tblVendorPreference.RateID WHERE tblVendorPreference.AccountId = p_AccountId
	            AND tblVendorPreference.TrunkID = p_TrunkId
					AND tblVendorPreference.TimezonesID = p_TimezonesID;
			END IF;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_VendorRateUpdateDelete
DROP PROCEDURE IF EXISTS `prc_VendorRateUpdateDelete`;
DELIMITER //
CREATE PROCEDURE `prc_VendorRateUpdateDelete`(
	IN `p_CompanyId` INT,
	IN `p_AccountId` INT,
	IN `p_VendorRateId` LONGTEXT,
	IN `p_EffectiveDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Rate` DECIMAL(18,6),
	IN `p_RateN` DECIMAL(18,6),
	IN `p_Interval1` INT,
	IN `p_IntervalN` INT,
	IN `p_ConnectionFee` decimal(18,6),
	IN `p_Critearea_CountryId` INT,
	IN `p_Critearea_Code` varchar(50),
	IN `p_Critearea_Description` varchar(200),
	IN `p_Critearea_Effective` VARCHAR(50),
	IN `p_TrunkId` INT,
	IN `p_TimezonesID` INT,
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
		`TimezonesID` int(11) NOT NULL,
		`Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
		`RateN` decimal(18,6) NOT NULL DEFAULT '0.000000',
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
		v.TimezonesID,
		IFNULL(p_Rate,v.Rate) AS Rate,
		IFNULL(p_RateN,v.Rate) AS RateN,
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
					EffectiveDate=p_EffectiveDate AND TimezonesID=p_TimezonesID AND TrunkID = p_TrunkId AND
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
		v.TrunkID = p_TrunkId AND
		v.TimezonesID = p_TimezonesID;

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

	CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId,p_TimezonesID,p_ModifiedBy);

	IF p_action = 1
	THEN

		INSERT INTO tblVendorRate (
			RateId,
			AccountId,
			TrunkID,
			TimezonesID,
			Rate,
			RateN,
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
			TimezonesID,
			Rate,
			RateN,
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

-- Dumping structure for procedure Ratemanagement3.prc_WSDeleteOldRateSheetDetails
DROP PROCEDURE IF EXISTS `prc_WSDeleteOldRateSheetDetails`;
DELIMITER //
CREATE PROCEDURE `prc_WSDeleteOldRateSheetDetails`(
	IN `p_LatestRateSheetID` INT ,
	IN `p_customerID` INT ,
	IN `p_rateSheetCategory` VARCHAR(50),
	IN `p_TimezonesID` INT
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

        DELETE  tblRateSheetDetails
        FROM    tblRateSheetDetails
                JOIN tblRateSheet ON tblRateSheet.RateSheetID = tblRateSheetDetails.RateSheetID
        WHERE   CustomerID = p_customerID
                AND Level = p_rateSheetCategory
                AND TimezonesID = p_TimezonesID
                AND tblRateSheetDetails.RateSheetID <> p_LatestRateSheetID;
      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateRateSheet
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateSheet`(
	IN `p_CustomerID` INT,
	IN `p_Trunk` VARCHAR(100),
	IN `p_TimezonesID` INT
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
					 AND TimezonesID = p_TimezonesID
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
						 AND tblCustomerRate.TimezonesID = p_TimezonesID
			ORDER BY tblCustomerRate.CustomerID,tblCustomerRate.TrunkID,tblCustomerRate.TimezonesID,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;

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
						 AND tblRateTableRate.TimezonesID = p_TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateRateTable
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTable`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_TimezonesID` VARCHAR(50),
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_GroupBy` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_IsMerge` INT,
	IN `p_TakePrice` INT,
	IN `p_MergeInto` INT
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
		DECLARE v_TimezonesID int;

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW WARNINGS;
			ROLLBACK;
			INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable generation failed');
			-- CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

		END;

		DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
		CREATE TEMPORARY TABLE tmp_JobLog_ (
			Message longtext
		);

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; -- change group_concat limit for group by


		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



		SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
		SET v_TimezonesID = IF(p_IsMerge=1,p_MergeInto,p_TimezonesID);

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
				INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable Name is already exist, Please try using another RateTable Name');
				-- CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
				LEAVE GenerateRateTable;
			END IF;
		END IF;

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates_code (`code`),
			INDEX  tmp_Rates_description (`description`),
			UNIQUE KEY `unique_code` (`code`)

		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates2_code (`code`),
			INDEX  tmp_Rates_description (`description`)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Rates3_;
		CREATE TEMPORARY TABLE tmp_Rates3_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			UNIQUE KEY `unique_code` (`code`),
			INDEX  tmp_Rates_description (`description`)
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
			rateN DECIMAL(18, 6),
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
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			FinalRankNumber int,
			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
			RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			FinalRankNumber int,
			INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
		CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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



		IF(p_IsMerge = 1) -- merge by timezones
		THEN
			-- p_TakePrice = 0 = Lowest
			-- p_TakePrice = 1 = Highest
			-- p_MergeInto is timezone for which we need to generate rates

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,MAX(AccountName) AS AccountName,MAX(Code) AS Code,MAX(Description) AS Description, ROUND(IF(p_TakePrice=1,MAX(Rate),MIN(Rate)), 6) AS Rate, ROUND(IF(p_TakePrice=1,MAX(RateN),MIN(RateN)), 6) AS RateN,IF(p_TakePrice=1,MAX(ConnectionFee),MIN(ConnectionFee)) AS ConnectionFee,EffectiveDate,TrunkID,p_MergeInto AS TimezonesID,MAX(CountryID) AS CountryID,RateID,MAX(Preference) AS Preference
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
																																					END as  Rate,
																																					CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
																																						THEN
																																							tblVendorRate.RateN
																																					WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
																																						THEN
																																							(
																																								( tblVendorRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
																																							)
																																					ELSE
																																						(

																																							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
																																							* (tblVendorRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
																																						)
																																					END as  RateN,
								 ConnectionFee,
																																					DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
																																					@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_TimezonesID = tblVendorRate.TimezonesID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := tblVendorRate.AccountID,
								 @prev_TrunkID := tblVendorRate.TrunkID,
								 @prev_TimezonesID := tblVendorRate.TimezonesID,
								 @prev_RateId := tblVendorRate.RateID,
								 @prev_EffectiveDate := tblVendorRate.EffectiveDate
							 FROM      tblVendorRate
								 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  v_trunk_
								 Inner join tblTimezones t on t.TimezonesID = tblVendorRate.TimezonesID AND t.Status = 1
								 inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
								 LEFT JOIN tblVendorPreference vp
									 ON vp.AccountId = tblVendorRate.AccountId
											AND vp.TrunkID = tblVendorRate.TrunkID
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																				 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID

								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

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
								 AND FIND_IN_SET(tblVendorRate.TimezonesID,p_TimezonesID) != 0
								 AND blockCode.RateId IS NULL
								 AND blockCountry.CountryId IS NULL
								 AND ( @IncludeAccountIds = NULL
											 OR ( @IncludeAccountIds IS NOT NULL
														AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
											 )
								 )
							 ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
						 ) tbl
				GROUP BY RateID, AccountId, TrunkID, EffectiveDate
				order by Code asc;
--			leave GenerateRateTable;

		ELSE

				INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
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
																																					END as  Rate,
																																					CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
																																						THEN
																																							tblVendorRate.RateN
																																					WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
																																						THEN
																																							(
																																								( tblVendorRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
																																							)
																																					ELSE
																																						(

																																							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
																																							* (tblVendorRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
																																						)
																																					END as  RateN,
								 ConnectionFee,
																																					DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
																																					@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_TimezonesID = tblVendorRate.TimezonesID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := tblVendorRate.AccountID,
								 @prev_TrunkID := tblVendorRate.TrunkID,
								 @prev_TimezonesID := tblVendorRate.TimezonesID,
								 @prev_RateId := tblVendorRate.RateID,
								 @prev_EffectiveDate := tblVendorRate.EffectiveDate
							 FROM      tblVendorRate
								 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  v_trunk_
								 Inner join tblTimezones t on t.TimezonesID = tblVendorRate.TimezonesID AND t.Status = 1
								 inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
								 LEFT JOIN tblVendorPreference vp
									 ON vp.AccountId = tblVendorRate.AccountId
											AND vp.TrunkID = tblVendorRate.TrunkID
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																				 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID

								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

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
								 AND tblVendorRate.TimezonesID = v_TimezonesID
								 AND blockCode.RateId IS NULL
								 AND blockCountry.CountryId IS NULL
								 AND ( @IncludeAccountIds = NULL
											 OR ( @IncludeAccountIds IS NOT NULL
														AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
											 )
								 )
							 ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
						 ) tbl
				order by Code asc;

		END IF;

/*		IF p_GroupBy = 'Desc' -- Group By Description
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
*/



	INSERT INTO tmp_VendorCurrentRates_
				Select AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
				FROM (
							 SELECT * ,
								 @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_TimezonesID = TimezonesID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := AccountID,
								 @prev_TrunkID := TrunkID,
								 @prev_TimezonesID := TimezonesID,
								 @prev_RateId := RateID,
								 @prev_EffectiveDate := EffectiveDate
							 FROM tmp_VendorCurrentRates1_
								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
							 ORDER BY AccountId, TrunkID, TimezonesID, RateId, EffectiveDate DESC
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




		/* -----------		*/
		IF p_GroupBy = 'Desc' -- Group By Description
		THEN
			-- insert all rates and if code is multiple then insert it as comma seperated values
			INSERT INTO tmp_VendorCurrentRates_GroupBy_
				Select AccountId,max(AccountName),max(Code),Description,max(Rate),max(RateN),max(ConnectionFee),max(EffectiveDate),TrunkID,TimezonesID,max(CountryID),max(RateID),max(Preference)
				FROM
				(

					Select AccountId,AccountName,r.Code,r.Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,r.CountryID,r.RateID,Preference
					FROM tmp_VendorCurrentRates_ v
					Inner join  tmp_all_code_ SplitCode   on v.Code = SplitCode.Code
					Inner join  tblRate r   on r.CodeDeckId = v_codedeckid_ AND r.Code = SplitCode.RowCode


				) tmp
				GROUP BY AccountId, TrunkID, TimezonesID, Description
				order by Description asc;


				truncate table tmp_VendorCurrentRates_;

				INSERT INTO tmp_VendorCurrentRates_ (AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference)
			  		SELECT AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
					FROM tmp_VendorCurrentRates_GroupBy_;


		END IF;
		/* -----------		*/



		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

		insert ignore into tmp_VendorRate_stage_1 (
			RowCode,
			AccountId ,
			AccountName ,
			Code ,
			Rate ,
			RateN ,
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
				v.RateN ,
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
				v.RateN ,
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
				RateN ,
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


				INSERT INTO tmp_Rates2_ (code,description,rate,rateN,ConnectionFee)
				select  code,description,rate,rateN,ConnectionFee from tmp_Rates_;



				IF p_GroupBy = 'Desc' -- Group By Description
				THEN

						-- collect codes from all vendor against rule
						INSERT IGNORE INTO tmp_Rates3_ (code,description)
						 select distinct r.code,r.description
						from tmp_VendorCurrentRates1_  tmpvr
						Inner join  tblRate r   on r.CodeDeckId = v_codedeckid_ AND r.Code = tmpvr.Code
						inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																 (
																	 ( rr.code != '' AND r.Code LIKE (REPLACE(rr.code,'*', '%%')) )
																	 OR
																	 ( rr.description != '' AND r.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																 )
						left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																		 (
																			 ( rr2.code != '' AND r.Code LIKE (REPLACE(rr2.code,'*', '%%')) )
																			 OR
																			 ( rr2.description != '' AND r.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																		 )
						inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
						where rr2.code is null;

				END IF;



			truncate tmp_final_VendorRate_;

			IF( v_Use_Preference_ = 0 )
			THEN

				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						AccountName ,
						Code ,
						Rate ,
						RateN ,
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
								vr.RateN ,
								vr.ConnectionFee,
								vr.EffectiveDate ,
								vr.Description ,
								vr.Preference,
								vr.RowCode,
								CASE WHEN p_GroupBy = 'Desc'  THEN
													@rank := CASE WHEN ( @prev_Description = vr.Description  AND @prev_Rate <=  vr.Rate ) THEN @rank+1
													 ELSE
														 1
													 END

								ELSE	@rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate ) THEN @rank+1

													 ELSE
														 1
													 END
								END
									AS FinalRankNumber,
								@prev_RowCode  := vr.RowCode,
								@prev_Description  := vr.Description,
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
								,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 , @prev_Description := ''  ) x
							order by
								CASE WHEN p_GroupBy = 'Desc'  THEN
									vr.Description
								ELSE
									vr.RowCode
								END , vr.Rate,vr.AccountId

						) tbl1
					where FinalRankNumber <= v_RatePosition_;

			ELSE


				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						AccountName ,
						Code ,
						Rate ,
						RateN ,
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
								vr.RateN ,
								vr.ConnectionFee,
								vr.EffectiveDate ,
								vr.Description ,
								vr.Preference,
								vr.RowCode,

								CASE WHEN p_GroupBy = 'Desc'  THEN

										@preference_rank := CASE WHEN (@prev_Description  = vr.Description  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1

																		ELSE 1 END
								ELSE
												@preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1

																		ELSE 1 END
								END

								AS FinalRankNumber,
								@prev_Code := vr.RowCode,
								@prev_Description  := vr.Description,
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

								,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0, @prev_Description := '') x
							order by -- vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC
							CASE WHEN p_GroupBy = 'Desc'  THEN
									vr.Description
								ELSE
									vr.RowCode
								END , vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC
						) tbl1
					where FinalRankNumber <= v_RatePosition_;


			END IF;



			truncate   tmp_VRatesstage2_;

			INSERT INTO tmp_VRatesstage2_
				SELECT
					vr.RowCode,
					vr.code,
					vr.description,
					vr.rate,
					vr.rateN,
					vr.ConnectionFee,
					vr.FinalRankNumber
				FROM tmp_final_VendorRate_ vr
					left join tmp_Rates2_ rate on rate.Code = vr.RowCode
				WHERE  rate.code is null
				order by vr.FinalRankNumber desc ;



			IF v_Average_ = 0
			THEN


				IF p_GroupBy = 'Desc' -- Group By Description
				THEN

						insert into tmp_dupVRatesstage2_
						SELECT max(RowCode) , description,   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY description;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.description = vr2.description AND  vr.FinalRankNumber = vr2.FinalRankNumber);


				ELSE

					insert into tmp_dupVRatesstage2_
						SELECT RowCode , MAX(description),   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY RowCode;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

				END IF;


				INSERT IGNORE INTO tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
                SELECT RowCode,
		                description,
                    CASE WHEN rule_mgn1.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
                            WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
                                rule_mgn1.FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    CASE WHEN rule_mgn2.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
                                vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
                            WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
                                rule_mgn2.FixedValue
                            ELSE
                                vRate.rateN
                            END
                    ELSE
                        vRate.rateN
                    END as RateN,
                    ConnectionFee,
					null AS PreviousRate
                FROM tmp_Vendorrates_stage3_ vRate
                LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = v_rateRuleId_ and vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate;




			ELSE

				INSERT IGNORE INTO tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
                SELECT RowCode,
		                description,
                    CASE WHEN rule_mgn1.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
                            WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
                                rule_mgn1.FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    CASE WHEN rule_mgn2.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
                                vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
                            WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
                                rule_mgn2.FixedValue
                            ELSE
                                vRate.rateN
                            END
                    ELSE
                        vRate.rateN
                    END as RateN,
                    ConnectionFee,
					null AS PreviousRate
                FROM
                (
                     select
                        max(RowCode) AS RowCode,
                        max(description) AS description,
                        AVG(Rate) as Rate,
                        AVG(RateN) as RateN,
                        AVG(ConnectionFee) as ConnectionFee
                        from tmp_VRatesstage2_
                        group by
                        CASE WHEN p_GroupBy = 'Desc' THEN
                          description
                        ELSE  RowCode
      						END

                )  vRate
                LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = v_rateRuleId_ and vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate;

			END IF;


			SET v_pointer_ = v_pointer_ + 1;


		END WHILE;


		IF p_GroupBy = 'Desc' -- Group By Description
		THEN

			truncate table tmp_Rates2_;
			insert into tmp_Rates2_ select * from tmp_Rates_;

				insert ignore into tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
				select
				distinct
					vr.Code,
					vr.Description,
					vd.rate,
					vd.rateN,
					vd.ConnectionFee,
					vd.PreviousRate
				from  tmp_Rates3_ vr
				inner JOIN tmp_Rates2_ vd on  vd.Description = vr.Description and vd.Code != vr.Code
				where vd.Rate is not null;

		END IF;


		START TRANSACTION;

		IF p_RateTableId = -1
		THEN

			INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
			VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

			SET p_RateTableId = LAST_INSERT_ID();

			INSERT INTO tblRateTableRate (RateID,
																		RateTableId,
																		TimezonesID,
																		Rate,
																		RateN,
																		EffectiveDate,
																		PreviousRate,
																		Interval1,
																		IntervalN,
																		ConnectionFee
			)
				SELECT DISTINCT
					RateId,
					p_RateTableId,
					v_TimezonesID,
					Rate,
					RateN,
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
				-- delete all rate table rates of this rate table and specified timezone
				UPDATE
					tblRateTableRate
				SET
					EndDate = NOW()
				WHERE
					tblRateTableRate.RateTableId = p_RateTableId AND tblRateTableRate.TimezonesID = v_TimezonesID;

				-- delete and archive rates which rate's EndDate <= NOW()
				CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy
			END IF;

			-- set EffectiveDate for which date rates need to generate
			UPDATE tmp_Rates_ SET EffectiveDate = p_EffectiveDate;

			-- update Previous Rates By Vasim Seta Start
			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
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
				tmp_Rates_ as rate ON

				-- rate.code = tblRate.Code AND
				tblRateTableRate.EffectiveDate = p_EffectiveDate -- rate.EffectiveDate
			SET
				tblRateTableRate.EndDate = NOW()
			WHERE
				(
					(p_GroupBy != 'Desc'  AND rate.code = tblRate.Code )

					OR
					(p_GroupBy = 'Desc' AND rate.description = tblRate.description )
				)
				AND
				tblRateTableRate.TimezonesID = v_TimezonesID AND
				tblRateTableRate.RateTableId = p_RateTableId AND
				tblRate.CodeDeckId = v_codedeckid_ AND
				rate.rate != tblRateTableRate.Rate;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

			-- insert rates
			INSERT INTO tblRateTableRate (RateID,
																		RateTableId,
																		TimezonesID,
																		Rate,
																		RateN,
																		EffectiveDate,
																		PreviousRate,
																		Interval1,
																		IntervalN,
																		ConnectionFee
			)
				SELECT DISTINCT
					tblRate.RateId,
					p_RateTableId AS RateTableId,
					v_TimezonesID AS TimezonesID,
					rate.Rate,
					rate.RateN,
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
							 AND tbl1.TimezonesID = v_TimezonesID
					LEFT JOIN tblRateTableRate tbl2
						ON tblRate.RateId = tbl2.RateId
							 and tbl2.EffectiveDate = rate.EffectiveDate
							 AND tbl2.RateTableId = p_RateTableId
							 AND tbl2.TimezonesID = v_TimezonesID
					WHERE ( tbl1.RateTableRateID IS NULL
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
				rate.Code is null AND rtr.RateTableId = p_RateTableId AND rtr.TimezonesID = v_TimezonesID AND rtr.EffectiveDate = rate.EffectiveDate AND tblRate.CodeDeckId = v_codedeckid_;






	-- delete rates which needs to insert and with same EffectiveDate and rate is not same
			UPDATE
				tblRateTableRate
			INNER JOIN
				tblRate ON tblRate.RateId = tblRateTableRate.RateId
					AND tblRateTableRate.RateTableId = p_RateTableId
				--	AND tblRateTableRate.EffectiveDate = p_EffectiveDate
			INNER JOIN
				tmp_Rates_ as rate ON

				-- rate.code = tblRate.Code AND
				tblRateTableRate.EffectiveDate = p_EffectiveDate -- rate.EffectiveDate
			SET
				tblRateTableRate.EndDate = NOW()
			WHERE
				(
					(p_GroupBy != 'Desc'  AND rate.code = tblRate.Code )

					OR
					(p_GroupBy = 'Desc' AND rate.description = tblRate.description )
				)
				AND
				tblRateTableRate.RateTableId = p_RateTableId AND
				tblRateTableRate.TimezonesID = v_TimezonesID AND
				tblRate.CodeDeckId = v_codedeckid_ AND
				rate.rate != tblRateTableRate.Rate;








			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		END IF;

		-- update EndDate of all Rates of this RateTable By Vasim Seta Starts
		DROP TEMPORARY TABLE IF EXISTS tmp_ALL_RateTableRate_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ALL_RateTableRate_ AS (SELECT * FROM tblRateTableRate WHERE RateTableID=p_RateTableId AND TimezonesID=v_TimezonesID);

		UPDATE
			tmp_ALL_RateTableRate_ temp
		SET
			EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
		WHERE
			temp.RateTableId = p_RateTableId AND temp.TimezonesID = v_TimezonesID;

		UPDATE
			tblRateTableRate rtr
		INNER JOIN
			tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID AND rtr.TimezonesID=temp.TimezonesID
		SET
			rtr.EndDate=temp.EndDate
		WHERE
			rtr.RateTableId=p_RateTableId AND
			rtr.TimezonesID=v_TimezonesID;
		-- update EndDate of all Rates of this RateTable By Vasim Seta Ends

		-- delete and archive rates which rate's EndDate <= NOW()
		CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		UPDATE tblRateTable
		SET RateGeneratorID = p_RateGeneratorId,
			TrunkID = v_trunk_,
			CodeDeckId = v_codedeckid_,
			updated_at = now()
		WHERE RateTableID = p_RateTableId;

		-- SELECT p_RateTableId as RateTableID;

		INSERT INTO tmp_JobLog_ (Message) VALUES (p_RateTableId);
		-- CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

		SELECT * FROM tmp_JobLog_;

		COMMIT;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



	END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateRateTableWithPrefix
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_TimezonesID` VARCHAR(50),
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_GroupBy` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_IsMerge` INT,
	IN `p_TakePrice` INT,
	IN `p_MergeInto` INT
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
		DECLARE v_TimezonesID int;

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			show warnings;
			ROLLBACK;
			INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable generation failed');
			-- CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

		END;

		DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
		CREATE TEMPORARY TABLE tmp_JobLog_ (
			Message longtext
		);

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; -- change group_concat limit for group by

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;



		SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
		SET v_TimezonesID = IF(p_IsMerge=1,p_MergeInto,p_TimezonesID);


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
				INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable Name is already exist, Please try using another RateTable Name');
				-- CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
				LEAVE GenerateRateTable;
			END IF;
		END IF;

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates_code (`code`),
			INDEX  tmp_Rates_description (`description`),
			UNIQUE KEY `unique_code` (`code`)

		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			PreviousRate DECIMAL(18, 6),
			EffectiveDate DATE DEFAULT NULL,
			INDEX tmp_Rates2_code (`code`),
			INDEX  tmp_Rates_description (`description`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates3_;
		CREATE TEMPORARY TABLE tmp_Rates3_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			UNIQUE KEY `unique_code` (`code`),
			INDEX  tmp_Rates_description (`description`)
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
			rateN DECIMAL(18, 6),
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
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
			ConnectionFee DECIMAL(18, 6),
			FinalRankNumber int,
			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
			RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			FinalRankNumber int,
			INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
		CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 6),
			rateN DECIMAL(18, 6),
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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



		IF(p_IsMerge = 1) -- merge by timezones
		THEN
			-- p_TakePrice = 0 = Lowest
			-- p_TakePrice = 1 = Highest
			-- p_MergeInto is timezone for which we need to generate rates

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,MAX(AccountName) AS AccountName,MAX(Code) AS Code,MAX(Description) AS Description, ROUND(IF(p_TakePrice=1,MAX(Rate),MIN(Rate)), 6) AS Rate, ROUND(IF(p_TakePrice=1,MAX(RateN),MIN(RateN)), 6) AS RateN,IF(p_TakePrice=1,MAX(ConnectionFee),MIN(ConnectionFee)) AS ConnectionFee,EffectiveDate,TrunkID,p_MergeInto AS TimezonesID,MAX(CountryID) AS CountryID,RateID,MAX(Preference) AS Preference
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
																																					END as Rate,
																																					CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
																																						THEN
																																							tblVendorRate.RateN
																																					WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
																																						THEN
																																							(
																																								( tblVendorRate.rateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
																																							)
																																					ELSE
																																						(

																																							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
																																							* (tblVendorRate.rateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
																																						)
																																					END as RateN,
								 ConnectionFee,
																																					DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
																																					@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := tblVendorRate.AccountID,
								 @prev_TrunkID := tblVendorRate.TrunkID,
								 @prev_TimezonesID := tblVendorRate.TimezonesID,
								 @prev_RateId := tblVendorRate.RateID,
								 @prev_EffectiveDate := tblVendorRate.EffectiveDate
							 FROM      tblVendorRate

								 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and

																								 vt.Status =  1 and vt.TrunkID =  v_trunk_
								 Inner join tblTimezones t on t.TimezonesID = tblVendorRate.TimezonesID AND t.Status = 1
								 inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
								 LEFT JOIN tblVendorPreference vp
									 ON vp.AccountId = tblVendorRate.AccountId
											AND vp.TrunkID = tblVendorRate.TrunkID
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																				 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID

								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

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
								 AND FIND_IN_SET(tblVendorRate.TimezonesID,p_TimezonesID) != 0
								 AND blockCode.RateId IS NULL
								 AND blockCountry.CountryId IS NULL
								 AND ( @IncludeAccountIds = NULL
											 OR ( @IncludeAccountIds IS NOT NULL
														AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
											 )
								 )
							 ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
						 ) tbl
				GROUP BY RateID, AccountId, TrunkID, EffectiveDate
				order by Code asc;

		ELSE

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
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
																																					END as Rate,
																																					CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
																																						THEN
																																							tblVendorRate.RateN
																																					WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
																																						THEN
																																							(
																																								( tblVendorRate.rateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
																																							)
																																					ELSE
																																						(

																																							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
																																							* (tblVendorRate.rateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
																																						)
																																					END as RateN,
								 ConnectionFee,
																																					DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
																																					@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_AccountId := tblVendorRate.AccountID,
								 @prev_TrunkID := tblVendorRate.TrunkID,
								 @prev_TimezonesID := tblVendorRate.TimezonesID,
								 @prev_RateId := tblVendorRate.RateID,
								 @prev_EffectiveDate := tblVendorRate.EffectiveDate
							 FROM      tblVendorRate

								 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and

																								 vt.Status =  1 and vt.TrunkID =  v_trunk_
								 Inner join tblTimezones t on t.TimezonesID = tblVendorRate.TimezonesID AND t.Status = 1
								 inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
								 LEFT JOIN tblVendorPreference vp
									 ON vp.AccountId = tblVendorRate.AccountId
											AND vp.TrunkID = tblVendorRate.TrunkID
											AND vp.TimezonesID = tblVendorRate.TimezonesID
											AND vp.RateId = tblVendorRate.RateId
								 LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																																		 AND tblVendorRate.AccountId = blockCode.AccountId
																																		 AND tblVendorRate.TrunkID = blockCode.TrunkID
																																		 AND tblVendorRate.TimezonesID = blockCode.TimezonesID
								 LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																																				 AND tblVendorRate.AccountId = blockCountry.AccountId
																																				 AND tblVendorRate.TrunkID = blockCountry.TrunkID
																																				 AND tblVendorRate.TimezonesID = blockCountry.TimezonesID

								 ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

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
								 AND tblVendorRate.TimezonesID = v_TimezonesID
								 AND blockCode.RateId IS NULL
								 AND blockCountry.CountryId IS NULL
								 AND ( @IncludeAccountIds = NULL
											 OR ( @IncludeAccountIds IS NOT NULL
														AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
											 )
								 )
							 ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.TimezonesID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
						 ) tbl
				order by Code asc;

		END IF;


-- leave GenerateRateTable;

		INSERT INTO tmp_VendorCurrentRates_
		Select AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
		FROM (
					 SELECT * ,
						 @row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_TimezonesID = TimezonesID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
						 @prev_AccountId := AccountID,
						 @prev_TrunkID := TrunkID,
						 @prev_TimezonesID := TimezonesID,
						 @prev_RateId := RateID,
						 @prev_EffectiveDate := EffectiveDate
					 FROM tmp_VendorCurrentRates1_
						 ,(SELECT @row_num := 1,  @prev_AccountId := 0 ,@prev_TrunkID := 0 ,@prev_TimezonesID := 0, @prev_RateId := 0, @prev_EffectiveDate := '') x
					 ORDER BY AccountId, TrunkID, TimezonesID, RateId, EffectiveDate DESC
				 ) tbl
		WHERE RowID = 1
		order by Code asc;



		IF p_GroupBy = 'Desc' -- Group By Description
		THEN




			-- insert all rates and if code is multiple then insert it as comma seperated values
			INSERT INTO tmp_VendorCurrentRates_GroupBy_
				Select AccountId,max(AccountName),max(Code),Description,max(Rate),max(RateN),max(ConnectionFee),max(EffectiveDate),TrunkID,TimezonesID,max(CountryID),max(RateID),max(Preference)
				FROM
				(
					Select AccountId,AccountName,r.Code,r.Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,r.CountryID,r.RateID,Preference
					FROM tmp_VendorCurrentRates_ v
					Inner join  tblRate r   on r.CodeDeckId = v_codedeckid_ AND r.Code = v.Code
				) tmp
				GROUP BY AccountId, TrunkID, TimezonesID, Description
				order by Description asc;


/*
IF  p_rateTableName  = 'Wholesale Premium Rate - USD - DevTest 1' THEN

	--	select * from tmp_VendorCurrentRates_ where  Code like '1809201' or description like 'Dominican Republic-Mobile Other';

		leave GenerateRateTable;
END IF;
*/

				truncate table tmp_VendorCurrentRates_;

				INSERT INTO tmp_VendorCurrentRates_ (AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference)
			  		SELECT AccountId,AccountName,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference
					FROM tmp_VendorCurrentRates_GroupBy_;


		END IF;


		insert into tmp_VendorRate_
			select
				AccountId ,
				AccountName ,
				Code ,
				Rate ,
				RateN ,
				ConnectionFee,
				EffectiveDate ,
				Description ,
				Preference,
				Code as RowCode
			from tmp_VendorCurrentRates_;

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);


			INSERT INTO tmp_Rates2_ (code,description,rate,rateN,ConnectionFee)
				select  code,description,rate,rateN,ConnectionFee from tmp_Rates_;

				IF p_GroupBy = 'Desc' -- Group By Description
				THEN

						-- collect codes from all vendor against rule
						INSERT IGNORE INTO tmp_Rates3_ (code,description)
						 select distinct r.code,r.description
						from tmp_VendorCurrentRates1_  tmpvr
						Inner join  tblRate r   on r.CodeDeckId = v_codedeckid_ AND r.Code = tmpvr.Code
						inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and
																 (
																	 ( rr.code != '' AND r.Code LIKE (REPLACE(rr.code,'*', '%%')) )
																	 OR
																	 ( rr.description != '' AND r.Description LIKE (REPLACE(rr.description,'*', '%%')) )
																 )
						left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
																		 (
																			 ( rr2.code != '' AND r.Code LIKE (REPLACE(rr2.code,'*', '%%')) )
																			 OR
																			 ( rr2.description != '' AND r.Description LIKE (REPLACE(rr2.description,'*', '%%')) )
																		 )
						inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
						where rr2.code is null;

				END IF;

			truncate tmp_final_VendorRate_;

			IF( v_Use_Preference_ = 0 )
			THEN

				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						AccountName ,
						Code ,
						Rate ,
						RateN ,
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
								vr.RateN ,
								vr.ConnectionFee,
								vr.EffectiveDate ,
								vr.Description ,
								vr.Preference,
								vr.RowCode,
								CASE WHEN p_GroupBy = 'Desc'  THEN
													@rank := CASE WHEN ( @prev_Description = vr.Description  AND @prev_Rate <=  vr.Rate ) THEN @rank+1
													 ELSE
														 1
													 END

								ELSE	@rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate ) THEN @rank+1

													 ELSE
														 1
													 END
								END
									AS FinalRankNumber,
								@prev_RowCode  := vr.RowCode,
								@prev_Description  := vr.Description,
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
								,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 , @prev_Description := '' ) x
							order by
								CASE WHEN p_GroupBy = 'Desc'  THEN
									vr.Description
								ELSE
									vr.RowCode
								END , vr.Rate,vr.AccountId

						) tbl1
					where FinalRankNumber <= v_RatePosition_;

			ELSE

				insert into tmp_final_VendorRate_
					SELECT
						AccountId ,
						AccountName ,
						Code ,
						Rate ,
						RateN ,
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
								vr.RateN ,
								vr.ConnectionFee,
								vr.EffectiveDate ,
								vr.Description ,
								vr.Preference,
								vr.RowCode,

								CASE WHEN p_GroupBy = 'Desc'  THEN

										@preference_rank := CASE WHEN (@prev_Description  = vr.Description  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1

																		ELSE 1 END
								ELSE
												@preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1

																		ELSE 1 END
								END

								AS FinalRankNumber,
								@prev_Code := vr.RowCode,
								@prev_Description  := vr.Description,
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

								,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0, @prev_Description := '') x
							order by -- vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC
							CASE WHEN p_GroupBy = 'Desc'  THEN
									vr.Description
								ELSE
									vr.RowCode
								END , vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC
						) tbl1
					where FinalRankNumber <= v_RatePosition_;

			END IF;



			truncate   tmp_VRatesstage2_;

			INSERT INTO tmp_VRatesstage2_
				SELECT
					vr.RowCode,
					vr.code,
					vr.description,
					vr.rate,
					vr.rateN,
					vr.ConnectionFee,
					vr.FinalRankNumber
				FROM tmp_final_VendorRate_ vr
					left join tmp_Rates2_ rate on rate.Code = vr.RowCode
				WHERE  rate.code is null
				order by vr.FinalRankNumber desc ;



			IF v_Average_ = 0
			THEN


				IF p_GroupBy = 'Desc' -- Group By Description
				THEN

						insert into tmp_dupVRatesstage2_
						SELECT max(RowCode) , description,   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY description;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.description = vr2.description AND  vr.FinalRankNumber = vr2.FinalRankNumber);


				ELSE

					insert into tmp_dupVRatesstage2_
						SELECT RowCode , MAX(description),   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY RowCode;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

				END IF;

				INSERT IGNORE INTO tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
                SELECT RowCode,
		                description,
                    CASE WHEN rule_mgn1.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
                            WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
                                rule_mgn1.FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    CASE WHEN rule_mgn2.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
                                vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
                            WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
                                rule_mgn2.FixedValue
                            ELSE
                                vRate.rateN
                            END
                    ELSE
                        vRate.rateN
                    END as RateN,
                    ConnectionFee,
					null AS PreviousRate
                FROM tmp_Vendorrates_stage3_ vRate
                LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = v_rateRuleId_ and vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate;



			ELSE

				INSERT IGNORE INTO tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
                SELECT RowCode,
		                description,
                    CASE WHEN rule_mgn1.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
                                vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
                            WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
                                rule_mgn1.FixedValue
                            ELSE
                                vRate.rate
                            END
                    ELSE
                        vRate.rate
                    END as Rate,
                    CASE WHEN rule_mgn2.RateRuleId is not null
                        THEN
                            CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
                                vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
                            WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
                                rule_mgn2.FixedValue
                            ELSE
                                vRate.rateN
                            END
                    ELSE
                        vRate.rateN
                    END as RateN,
                    ConnectionFee,
					null AS PreviousRate
                FROM
                    (
                        select
                        max(RowCode) AS RowCode,
                        max(description) AS description,
                        AVG(Rate) as Rate,
                        AVG(RateN) as RateN,
                        AVG(ConnectionFee) as ConnectionFee
                        from tmp_VRatesstage2_
                        group by
                        CASE WHEN p_GroupBy = 'Desc' THEN
                          description
                        ELSE  RowCode
      									END

                    )  vRate
                LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = v_rateRuleId_ and vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate;





			END IF;


			SET v_pointer_ = v_pointer_ + 1;


		END WHILE;

	--	LEAVE GenerateRateTable;

		IF p_GroupBy = 'Desc' -- Group By Description
		THEN

			truncate table tmp_Rates2_;
			insert into tmp_Rates2_ select * from tmp_Rates_;

			insert ignore into tmp_Rates_ (code,description,rate,rateN,ConnectionFee,PreviousRate)
				select
				distinct
					vr.Code,
					vr.Description,
					vd.rate,
					vd.rateN,
					vd.ConnectionFee,
					vd.PreviousRate
				from  tmp_Rates3_ vr
				inner JOIN tmp_Rates2_ vd on  vd.Description = vr.Description and vd.Code != vr.Code
				where vd.Rate is not null;

		END IF;


		START TRANSACTION;

		IF p_RateTableId = -1
		THEN

			INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
			VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

			SET p_RateTableId = LAST_INSERT_ID();

			INSERT INTO tblRateTableRate (RateID,
																		RateTableId,
																		TimezonesID,
																		Rate,
																		RateN,
																		EffectiveDate,
																		PreviousRate,
																		Interval1,
																		IntervalN,
																		ConnectionFee
			)
				SELECT DISTINCT
					RateId,
					p_RateTableId,
					v_TimezonesID,
					Rate,
					RateN,
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
					tblRateTableRate.RateTableId = p_RateTableId AND tblRateTableRate.TimezonesID = v_TimezonesID;

				-- delete and archive rates which rate's EndDate <= NOW()
				CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy
			END IF;

			-- set EffectiveDate for which date rates need to generate
			UPDATE tmp_Rates_ SET EffectiveDate = p_EffectiveDate;

			-- update Previous Rates By Vasim Seta Start
			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

			UPDATE
				tmp_Rates_ tr
			SET
				PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
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
				tblRateTableRate.TimezonesID = v_TimezonesID AND
				tblRateTableRate.RateTableId = p_RateTableId AND
				tblRate.CodeDeckId = v_codedeckid_ AND
				rate.rate != tblRateTableRate.Rate;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

			-- insert rates
			INSERT INTO tblRateTableRate (RateID,
																		RateTableId,
																		TimezonesID,
																		Rate,
																		RateN,
																		EffectiveDate,
																		PreviousRate,
																		Interval1,
																		IntervalN,
																		ConnectionFee
			)
				SELECT DISTINCT
					tblRate.RateId,
					p_RateTableId AS RateTableId,
					v_TimezonesID AS TimezonesID,
					rate.Rate,
					rate.RateN,
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
							 AND tbl1.TimezonesID = v_TimezonesID
					LEFT JOIN tblRateTableRate tbl2
						ON tblRate.RateId = tbl2.RateId
							 and tbl2.EffectiveDate = rate.EffectiveDate
							 AND tbl2.RateTableId = p_RateTableId
							 AND tbl2.TimezonesID = v_TimezonesID
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
				rate.Code is null AND rtr.RateTableId = p_RateTableId AND rtr.TimezonesID = v_TimezonesID AND rtr.EffectiveDate = rate.EffectiveDate AND tblRate.CodeDeckId = v_codedeckid_;

			-- delete and archive rates which rate's EndDate <= NOW()
			CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		END IF;

		-- update EndDate of all Rates of this RateTable By Vasim Seta Starts
		DROP TEMPORARY TABLE IF EXISTS tmp_ALL_RateTableRate_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ALL_RateTableRate_ AS (SELECT * FROM tblRateTableRate WHERE RateTableID=p_RateTableId AND TimezonesID=v_TimezonesID);

		UPDATE
			tmp_ALL_RateTableRate_ temp
		SET
			EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=p_RateTableId AND rtr.TimezonesID=v_TimezonesID AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
		WHERE
			temp.RateTableId = p_RateTableId AND
			temp.TimezonesID = v_TimezonesID;

		UPDATE
			tblRateTableRate rtr
		INNER JOIN
			tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID AND rtr.TimezonesID=temp.TimezonesID
		SET
			rtr.EndDate=temp.EndDate
		WHERE
			rtr.RateTableId=p_RateTableId AND
			rtr.TimezonesID=v_TimezonesID;
		-- update EndDate of all Rates of this RateTable By Vasim Seta Ends

		-- delete and archive rates which rate's EndDate <= NOW()
		CALL prc_ArchiveOldRateTableRate(p_RateTableId,v_TimezonesID,CONCAT(p_ModifiedBy,'|RateGenerator')); -- p_ModifiedBy

		UPDATE tblRateTable
		SET RateGeneratorID = p_RateGeneratorId,
			TrunkID = v_trunk_,
			CodeDeckId = v_codedeckid_,
			updated_at = now()
		WHERE RateTableID = p_RateTableId;

		-- SELECT p_RateTableId as RateTableID;

		INSERT INTO tmp_JobLog_ (Message) VALUES (p_RateTableId);
		-- CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

		SELECT * FROM tmp_JobLog_;

		COMMIT;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



	END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateSippySheet
DROP PROCEDURE IF EXISTS `prc_WSGenerateSippySheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateSippySheet`(
	IN `p_CustomerID` INT ,
	IN `p_Trunks` VARCHAR(200),
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

		-- get customer rates
		CALL vwCustomerRate(p_CustomerID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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
			RateN as `Price N`,
			0  as Forbidden,
			0 as `Grace Period`,

			-- DATE_FORMAT( EffectiveDate, '%Y-%m-%d %H:%i:%s' ) AS `Activation Date`,
			CASE WHEN EffectiveDate < NOW()  THEN
				'NOW'
			ELSE
				DATE_FORMAT( EffectiveDate, '%Y-%m-%d %H:%i:%s' )
			END AS `Activation Date`,
			DATE_FORMAT( EndDate, '%Y-%m-%d %H:%i:%s' )  AS `Expiration Date`
		FROM
			tmp_customerrateall_
		ORDER BY
			Prefix;

	END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateVendorSippySheet
DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorSippySheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVendorSippySheet`(
	IN `p_VendorID` INT  ,
	IN `p_Trunks` varchar(200),
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE
)
BEGIN

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		call vwVendorSippySheet(p_VendorID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateVendorVersion3VosSheet
DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVendorVersion3VosSheet`(
	IN `p_VendorID` INT ,
	IN `p_Trunks` varchar(200) ,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_Format` VARCHAR(50),
	IN `p_CustomDate` DATE


)
BEGIN
         SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

        call vwVendorVersion3VosSheet(p_VendorID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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

			   	/*UNION ALL

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
			        WHERE  EndDate is not null*/
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

-- Dumping structure for procedure Ratemanagement3.prc_WSGenerateVersion3VosSheet
DROP PROCEDURE IF EXISTS `prc_WSGenerateVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateVersion3VosSheet`(
	IN `p_CustomerID` INT ,
	IN `p_trunks` varchar(200) ,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50),
	IN `p_CustomDate` DATE,
	IN `p_Format` VARCHAR(50)
)
BEGIN

	-- get customer rates
	CALL vwCustomerRate(p_CustomerID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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

			/*UNION ALL

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
			WHERE  EndDate IS NOT NULL*/

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

-- Dumping structure for procedure Ratemanagement3.prc_WSProcessImportAccount
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
						 	-- AND ta.CompanyId = a.CompanyId
							AND ta.AccountType = a.AccountType
						where ta.ProcessID = p_processId
						   AND ta.AccountType = v_accounttype
							AND a.AccountID is null
							AND ta.CompanyID = p_companyId
							;


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
					tblAccount a ON ta.AccountName=a.AccountName -- AND ta.CompanyID=a.CompanyID
				WHERE ta.ProcessID = p_processId AND ta.CompanyID = p_companyId AND ta.IsCustomer=1 AND ta.AccountName=a.AccountName -- AND ta.CompanyID=a.CompanyID
			) aold ON aold.tblTempAccountID = tblTempAccount.tblTempAccountID;

		DELETE tblTempAccountSippy
			FROM tblTempAccountSippy
			INNER JOIN(
				SELECT
					tas.AccountSippyID
				FROM
					tblTempAccountSippy tas
				LEFT JOIN
					tblAccount a ON tas.AccountName=a.AccountName -- AND tas.CompanyID=a.CompanyID
				WHERE tas.ProcessID = p_processId AND tas.CompanyID = p_companyId AND tas.i_account!=0 AND tas.AccountName=a.AccountName -- AND tas.CompanyID=a.CompanyID
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
					-- AND ta.CompanyId = a.CompanyId
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
					-- AND ta.CompanyId = a.CompanyId
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
											-- AND ta.CompanyId = a.CompanyId
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
					asu.AccountName=tas.AccountName -- AND asu.CompanyID=tas.CompanyID
				LEFT JOIN
					tblTempAccount ta
				ON
					tas.AccountName = ta.AccountName
				LEFT JOIN
					tblAccount a
				ON
					ta.AccountName=a.AccountName AND
					-- ta.CompanyId = a.CompanyId AND
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
					-- AND asu.CompanyID=tas.CompanyID
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
					asu.AccountName=tas.AccountName -- AND asu.CompanyID=tas.CompanyID
				LEFT JOIN
					tblTempAccount ta
				ON
					tas.AccountName = ta.AccountName
				LEFT JOIN
					tblAccount a
				ON
					ta.AccountName=a.AccountName AND
					-- ta.CompanyId = a.CompanyId AND
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
					-- ta.CompanyId = a.CompanyId AND
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
						-- AND ta.CompanyId = a.CompanyId
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

-- Dumping structure for procedure Ratemanagement3.prc_WSProcessRateTableRate
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		TimezonesID INT,
		RateId INT,
		Code VARCHAR(50),
		Description VARCHAR(200),
		Rate DECIMAL(18, 6),
		RateN DECIMAL(18, 6),
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
				TimezonesID,
				RateId,
				Code ,
				Description ,
				Rate ,
				RateN ,
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
				tblRateTableRate.TimezonesID,
				tblRateTableRate.RateId,
				tblRate.Code,
				tblRate.Description,
				tblRateTableRate.Rate,
				tblRateTableRate.RateN,
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
				AND tblTempRateTableRate.TimezonesID = tblRateTableRate.TimezonesID
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
			call prc_ArchiveOldRateTableRate(p_RateTableId, NULL,p_UserName);

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
			AND tblTempRateTableRate.TimezonesID = tblRateTableRate.TimezonesID
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
			AND tblTempRateTableRate.TimezonesID = tblRateTableRate.TimezonesID
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
			AND tblRateTableRate.TimezonesID = tblTempRateTableRate.TimezonesID
			AND tblTempRateTableRate.Rate = tblRateTableRate.Rate
			/*AND (
				tblRateTableRate.EffectiveDate = tblTempRateTableRate.EffectiveDate
				OR
				(
					DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d')
				)
				OR 1 = (CASE
							WHEN tblTempRateTableRate.EffectiveDate > NOW() THEN 1
							ELSE 0
						END)
			)*/
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
			AND tblRateTableRate.TimezonesID = tblTempRateTableRate.TimezonesID
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
			AND tblRateTableRate.TimezonesID = tblTempRateTableRate.TimezonesID
		WHERE tblTempRateTableRate.Rate <> tblRateTableRate.Rate
			AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
			AND DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d');

		-- archive rates which has EndDate <= today
		call prc_ArchiveOldRateTableRate(p_RateTableId, NULL,p_UserName);

		/* 13. insert new rates   */

		INSERT INTO tblRateTableRate (
			RateTableId,
			TimezonesID,
			RateId,
			Rate,
			RateN,
			EffectiveDate,
			EndDate,
			ConnectionFee,
			Interval1,
			IntervalN,
			PreviousRate
		)
		SELECT DISTINCT
			p_RateTableId,
			tblTempRateTableRate.TimezonesID,
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
			) AS Rate,
			IF (
				p_CurrencyID > 0,
				CASE WHEN p_CurrencyID = v_RateTableCurrencyID_
				THEN
					tblTempRateTableRate.RateN
				WHEN  p_CurrencyID = v_CompanyCurrencyID_
				THEN
				(
					( tblTempRateTableRate.RateN  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ and CompanyID = p_companyId ) )
				)
				ELSE
				(
					(SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_RateTableCurrencyID_ AND CompanyID = p_companyId )
					*
					(tblTempRateTableRate.RateN  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
				)
				END ,
				tblTempRateTableRate.Rate
			) AS RateN,
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
			AND tblRateTableRate.TimezonesID = tblTempRateTableRate.TimezonesID
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
						EffectiveDate,
						TimezonesID
					FROM tblRateTableRate
					WHERE RateTableId = p_RateTableId
						AND EffectiveDate =   @EffectiveDate
					order by EffectiveDate desc
				) tmpvr
				on
					vr1.RateTableId = tmpvr.RateTableId
					AND vr1.RateID  	=        	tmpvr.RateID
					AND vr1.TimezonesID = tmpvr.TimezonesID
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
	call prc_ArchiveOldRateTableRate(p_RateTableId, NULL,p_UserName);


	DELETE  FROM tblTempRateTableRate WHERE  ProcessId = p_processId;
	DELETE  FROM tblRateTableRateChangeLog WHERE ProcessID = p_processId;
	SELECT * FROM tmp_JobLog_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSProcessVendorRate
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
			  `TimezonesID` INT,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `RateN` decimal(18, 6) ,
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
			  `TimezonesID` INT,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `RateN` decimal(18, 6) ,
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
		  TimezonesID INT,
        RateId INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Rate DECIMAL(18, 6),
		  RateN DECIMAL(18, 6) ,
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
							TimezonesID,
							RateId,
							Code ,
							Description ,
							Rate ,
							RateN ,
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
                    tblVendorRate.TimezonesID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.RateN,
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
	                   		 	 AND tblTempVendorRate.TimezonesID = tblVendorRate.TimezonesID
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
				`TimezonesID`,
				`RateId`,
				`Rate`,
				`RateN`,
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
                        AND tblTempVendorRate.TimezonesID = tblVendorRate.TimezonesID
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
                    AND tblTempVendorRate.TimezonesID = tblVendorRate.TimezonesID
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
                    `TimezonesID`,
                    `BlockedBy`
                )
                SELECT distinct
                    p_accountId as AccountId,
                    tblRate.RateID as RateId,
                    p_trunkId as TrunkID,
                    tblTempVendorRate.TimezonesID AS TimezonesID,
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
                        AND vb.TimezonesID = tblTempVendorRate.TimezonesID
                WHERE tblTempVendorRate.Forbidden IN('B')
                    AND vb.VendorBlockingId is null;

            DELETE tblVendorBlocking
                FROM tblVendorBlocking
                INNER JOIN(
                    select VendorBlockingId
                    FROM `tblVendorBlocking` tv
                    INNER JOIN(
                        SELECT
                            tblRate.RateId as RateId,
                            tblTempVendorRate.TimezonesID
                        FROM tmp_TempVendorRate_ as tblTempVendorRate
                        INNER JOIN tblRate
                            ON tblRate.Code = tblTempVendorRate.Code
                                AND tblRate.CompanyID = p_companyId
                                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        WHERE tblTempVendorRate.Forbidden IN('UB')
                    )tv1 on  tv.AccountId=p_accountId
                    AND tv.TrunkID=p_trunkId
                    AND tv.TimezonesID=tv1.TimezonesID
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
                 ,`TimezonesID`
                 ,`CreatedBy`
                 ,`created_at`
            )
            SELECT
                 p_accountId AS AccountId,
                 tblTempVendorRate.Preference as Preference,
                 tblRate.RateID AS RateId,
                  p_trunkId AS TrunkID,
                  tblTempVendorRate.TimezonesID as TimezonesID,
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
                    AND vp.TimezonesID = tblTempVendorRate.TimezonesID
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
                    AND tblVendorPreference.TimezonesID = tblTempVendorRate.TimezonesID
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
                    	  AND tblVendorPreference.TimezonesID = tblTempVendorRate.TimezonesID
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
                    AND tblVendorRate.TimezonesID = tblTempVendorRate.TimezonesID
                    AND tblTempVendorRate.Rate = tblVendorRate.Rate
                    /*AND (
                        tblVendorRate.EffectiveDate = tblTempVendorRate.EffectiveDate
                        OR
                        (
                            DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d')
                        )
                        OR 1 = (CASE
                            WHEN tblTempVendorRate.EffectiveDate > NOW() THEN 1
                            ELSE 0
                        END)
                    )*/
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
                    AND tblVendorRate.TimezonesID = tblTempVendorRate.TimezonesID
				    SET tblVendorRate.EndDate = NOW()
            WHERE tblTempVendorRate.Rate <> tblVendorRate.Rate
                AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
                AND DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d');

				-- archive rates which has EndDate <= today
				call prc_ArchiveOldVendorRate(p_accountId,p_trunkId,NULL,p_UserName);


		/* 13. insert new rates   */

            INSERT INTO tblVendorRate (
                AccountId,
                TrunkID,
                TimezonesID,
                RateId,
                Rate,
                RateN,
                EffectiveDate,
                EndDate,
                ConnectionFee,
                Interval1,
                IntervalN
            )
            SELECT DISTINCT
                p_accountId,
                p_trunkId,
                tblTempVendorRate.TimezonesID,
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
                ) AS Rate,
                IF (
                    p_CurrencyID > 0,
                    CASE WHEN p_CurrencyID = v_AccountCurrencyID_
                    THEN
                       tblTempVendorRate.RateN
                    WHEN  p_CurrencyID = v_CompanyCurrencyID_
                    THEN
                    (
                        ( tblTempVendorRate.RateN  * (SELECT Value from tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ and CompanyID = p_companyId ) )
                    )
                    ELSE
                    (
                        (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = v_AccountCurrencyID_ AND CompanyID = p_companyId )
                            *
                        (tblTempVendorRate.RateN  / (SELECT Value FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = p_CurrencyID AND CompanyID = p_companyId ))
                    )
                    END ,
                    tblTempVendorRate.RateN
                ) AS RateN,
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
                    AND tblVendorRate.TimezonesID = tblTempVendorRate.TimezonesID
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
			         	TimezonesID,
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
	         	AND vr1.TimezonesID = tmpvr.TimezonesID
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
	call prc_ArchiveOldVendorRate(p_accountId,p_trunkId,NULL,p_UserName);


 	 SELECT * FROM tmp_JobLog_;
    DELETE  FROM tblTempVendorRate WHERE  ProcessId = p_processId;
    DELETE  FROM tblVendorRateChangeLog WHERE ProcessID = p_processId;

	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSReviewRateTableRate
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
		`TimezonesID` INT,
		`Code` varchar(50) ,
		`Description` varchar(200) ,
		`Rate` decimal(18, 6) ,
		`RateN` decimal(18, 6) ,
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
            TimezonesID,
            RateId,
            Code,
            Description,
            Rate,
            RateN,
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
            tblTempRateTableRate.TimezonesID,
            tblRate.RateId,
            tblTempRateTableRate.Code,
            tblTempRateTableRate.Description,
            tblTempRateTableRate.Rate,
            tblTempRateTableRate.RateN,
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
			ON tblRate.RateID = tblRateTableRate.RateId AND tblRateTableRate.RateTableId = p_RateTableId AND tblRateTableRate.TimezonesID = tblTempRateTableRate.TimezonesID
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
                    TimezonesID,
                    RateId,
                    Code,
                    Description,
                    Rate,
                    RateN,
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
                    tblTempRateTableRate.TimezonesID,
                    RateTableRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblTempRateTableRate.Rate,
                    tblTempRateTableRate.RateN,
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
                            AND vr1.TimezonesID = vr2.TimezonesID
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
                    AND tblTempRateTableRate.TimezonesID = RateTableRate.TimezonesID
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
                TimezonesID,
                RateId,
                Code,
                Description,
                Rate,
                RateN,
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
                tblRateTableRate.TimezonesID,
                tblRateTableRate.RateId,
                tblRate.Code,
                tblRate.Description,
                tblRateTableRate.Rate,
                tblRateTableRate.RateN,
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
                AND tblTempRateTableRate.TimezonesID = tblRateTableRate.TimezonesID
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
            TimezonesID,
            RateId,
            Code,
            Description,
            Rate,
            RateN,
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
            tblRateTableRate.TimezonesID,
            tblRateTableRate.RateId,
            tblRate.Code,
            tblRate.Description,
            tblRateTableRate.Rate,
            tblRateTableRate.RateN,
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
            AND tblTempRateTableRate.TimezonesID = tblRateTableRate.TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_WSReviewRateTableRateUpdate
DROP PROCEDURE IF EXISTS `prc_WSReviewRateTableRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_WSReviewRateTableRateUpdate`(
	IN `p_RateTableID` INT,
	IN `p_TimezonesID` INT,
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
					SET @stm1 = CONCAT('UPDATE tblTempRateTableRate tvr LEFT JOIN tblRateTableRateChangeLog vrcl ON tvr.TempRateTableRateID=vrcl.TempRateTableRateID SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND tvr.TempRateTableRateID=vrcl.TempRateTableRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');
					select @stm1;
					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			ELSE
				IF @stm != ''
				THEN
					SET @stm1 = CONCAT('UPDATE tblTempRateTableRate tvr LEFT JOIN tblRateTableRateChangeLog vrcl ON tvr.TempRateTableRateID=vrcl.TempRateTableRateID SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND tvr.TempRateTableRateID IN (',p_RateIds,') AND tvr.TempRateTableRateID=vrcl.TempRateTableRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND TempRateTableRateID IN (',p_RateIds,') AND ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			END IF;

		WHEN 'Deleted' THEN
			IF p_criteria = 1
			THEN
				SET @stm1 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE tvr.TimezonesID=',p_TimezonesID,' AND ProcessID="',p_ProcessID,'" AND `Action`="',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
			ELSE
				SET @stm1 = CONCAT('UPDATE tblRateTableRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE tvr.TimezonesID=',p_TimezonesID,' AND RateTableRateID IN (',p_RateIds,')AND Action = "',p_Action,'" AND ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
			END IF;
	END CASE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_WSReviewVendorRate
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
			  `TimezonesID` INT,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `RateN` decimal(18, 6) ,
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
			  `TimezonesID` INT,
			  `Code` varchar(50) ,
			  `Description` varchar(200) ,
			  `Rate` decimal(18, 6) ,
			  `RateN` decimal(18, 6) ,
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
			   TimezonesID,
				RateId,
		   	Code,
		   	Description,
		   	Rate,
		   	RateN,
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
			   tblTempVendorRate.TimezonesID,
			   tblRate.RateId,
			   tblTempVendorRate.Code,
			   tblTempVendorRate.Description,
			   tblTempVendorRate.Rate,
			   tblTempVendorRate.RateN,
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
				ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountId = p_accountId   AND tblVendorRate.TrunkId = p_trunkId AND tblVendorRate.TimezonesID = tblTempVendorRate.TimezonesID
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
                           TimezonesID,
                           RateId,
                           Code,
                           Description,
                           Rate,
                           RateN,
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
                       tblTempVendorRate.TimezonesID,
                       VendorRate.RateId,
                       tblRate.Code,
                       tblRate.Description,
                       tblTempVendorRate.Rate,
			   			  tblTempVendorRate.RateN,
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
												AND vr1.TimezonesID = vr2.TimezonesID
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
                    			AND tblTempVendorRate.TimezonesID = VendorRate.TimezonesID
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
			   	TimezonesID,
				RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	RateN,
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
                    tblVendorRate.TimezonesID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.RateN,
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
						  AND tblTempVendorRate.TimezonesID = tblVendorRate.TimezonesID
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
			   	TimezonesID,
				RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	RateN,
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
                    tblVendorRate.TimezonesID,
                    tblVendorRate.RateId,
                    tblRate.Code,
                    tblRate.Description,
                    tblVendorRate.Rate,
                    tblVendorRate.RateN,
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
	                    AND tblTempVendorRate.TimezonesID = tblVendorRate.TimezonesID
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

-- Dumping structure for procedure Ratemanagement3.prc_WSReviewVendorRateUpdate
DROP PROCEDURE IF EXISTS `prc_WSReviewVendorRateUpdate`;
DELIMITER //
CREATE PROCEDURE `prc_WSReviewVendorRateUpdate`(
	IN `p_AccountId` INT,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
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
					SET @stm1 = CONCAT('UPDATE tblTempVendorRate tvr LEFT JOIN tblVendorRateChangeLog vrcl ON tvr.TempVendorRateID=vrcl.TempVendorRateID SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND tvr.TempVendorRateID=vrcl.TempVendorRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');
					select @stm1;
					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblVendorRateChangeLog tvr SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID, ' AND ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			ELSE
				IF @stm != ''
				THEN
					SET @stm1 = CONCAT('UPDATE tblTempVendorRate tvr LEFT JOIN tblVendorRateChangeLog vrcl ON tvr.TempVendorRateID=vrcl.TempVendorRateID SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND tvr.TempVendorRateID IN (',p_RateIds,') AND tvr.TempVendorRateID=vrcl.TempVendorRateID AND vrcl.Action = "',p_Action,'" AND tvr.ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stmt1 FROM @stm1;
					EXECUTE stmt1;
					DEALLOCATE PREPARE stmt1;

					SET @stm2 = CONCAT('UPDATE tblVendorRateChangeLog tvr SET ',@stm,' WHERE tvr.TimezonesID=',p_TimezonesID,' AND TempVendorRateID IN (',p_RateIds,') AND ProcessID = "',p_ProcessID,'" AND Action = "',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

					PREPARE stm2 FROM @stm2;
					EXECUTE stm2;
					DEALLOCATE PREPARE stm2;
				END IF;
			END IF;

		WHEN 'Deleted' THEN
			IF p_criteria = 1
			THEN
				-- UPDATE tblVendorRate vr LEFT JOIN tblVendorRateChangeLog vrcl ON vr.VendorRateID=vrcl.VendorRateID SET vr.EndDate=p_EndDate WHERE vr.VendorRateID=vrcl.VendorRateID AND vr.AccountId=p_AccountId AND vr.TrunkID=p_TrunkID AND vrcl.ProcessID=p_ProcessID;
				SET @stm1 = CONCAT('UPDATE tblVendorRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE tvr.TimezonesID=',p_TimezonesID,' AND ProcessID="',p_ProcessID,'" AND `Action`="',p_Action,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
			ELSE
				-- UPDATE tblVendorRate vr LEFT JOIN tblVendorRateChangeLog vrcl ON vr.VendorRateID=vrcl.VendorRateID SET vr.EndDate=p_EndDate WHERE vr.VendorRateID IN (p_RateIds) AND vr.VendorRateID=vrcl.VendorRateID AND vr.AccountId=p_AccountId AND vr.TrunkID=p_TrunkID AND vrcl.ProcessID=p_ProcessID;

				SET @stm1 = CONCAT('UPDATE tblVendorRateChangeLog tvr SET EndDate="',p_EndDate,'" WHERE tvr.TimezonesID=',p_TimezonesID,' AND VendorRateID IN (',p_RateIds,')AND Action = "',p_Action,'" AND ProcessID = "',p_ProcessID,'" ',@stm_and_code,' ',@stm_and_desc,';');

				PREPARE stmt1 FROM @stm1;
				EXECUTE stmt1;
				DEALLOCATE PREPARE stmt1;
				-- UPDATE tblVendorRateChangeLog SET EndDate=p_EndDate WHERE VendorRateID IN (p_RateIds) AND ProcessID=p_ProcessID AND `Action`=p_Action;
			END IF;
	END CASE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.vwCustomerArchiveCurrentRates
DROP PROCEDURE IF EXISTS `vwCustomerArchiveCurrentRates`;
DELIMITER //
CREATE PROCEDURE `vwCustomerArchiveCurrentRates`(
	IN `p_CompanyID` INT,
	IN `p_CustomerID` INT,
	IN `p_TrunkID` INT,
	IN `p_TimezonesID` INT,
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
		cra.TimezonesID = p_TimezonesID AND
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

-- Dumping structure for procedure Ratemanagement3.vwCustomerRate
DROP PROCEDURE IF EXISTS `vwCustomerRate`;
DELIMITER //
CREATE PROCEDURE `vwCustomerRate`(
	IN `p_CustomerID` INT,
	IN `p_Trunks` VARCHAR(200),
	IN `p_TimezonesID` INT,
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
        RateN DECIMAL(18, 6),
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

        	CALL prc_GetCustomerRate(v_companyid_,p_CustomerID,v_TrunkID_,p_TimezonesID,null,null,null,p_Effective,p_CustomDate,1,0,0,0,'','',-1);

        	INSERT INTO tmp_customerrateall_
        	SELECT * FROM tmp_customerrate_;

        	CALL vwCustomerArchiveCurrentRates(v_companyid_,p_CustomerID,v_TrunkID_,p_TimezonesID,p_Effective,p_CustomDate);

        	INSERT INTO tmp_customerrateall_archive_
        	SELECT * FROM tmp_customerrate_archive_;

      	SET v_pointer_ = v_pointer_ + 1;

    END WHILE;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.vwVendorArchiveCurrentRates
DROP PROCEDURE IF EXISTS `vwVendorArchiveCurrentRates`;
DELIMITER //
CREATE PROCEDURE `vwVendorArchiveCurrentRates`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_TimezonesID` INT,
	IN `p_Effective` VARCHAR(50)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorArchiveCurrentRates_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorArchiveCurrentRates_(
		AccountId int,
		Code varchar(50),
		Description varchar(200),
		Rate float,
		RateN float,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Interval1 INT,
		IntervalN varchar(100),
		ConnectionFee float,
		EndDate date
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateArchive_;
    CREATE TEMPORARY TABLE tmp_VendorRateArchive_ (
        TrunkId INT,
        TimezonesID INT,
	 	  RateId INT,
        Rate DECIMAL(18,6),
        RateN DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        EndDate date,
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRateArchive_
        SELECT   `TrunkID`, `TimezonesID`, `RateId`, `Rate`, `RateN`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee` , tblVendorRateArchive.EndDate
		  FROM tblVendorRateArchive WHERE tblVendorRateArchive.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRateArchive.TrunkId,p_Trunks) != 0
								AND tblVendorRateArchive.TimezonesID = p_TimezonesID
                        AND
                        (
										-- p_Effective = 'EndToday'
									EffectiveDate <= NOW() AND date(EndDate) = date(NOW())
								)
								;

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateArchive4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRateArchive4_ as (select * from tmp_VendorRateArchive_);
      DELETE n1 FROM tmp_VendorRateArchive_ n1, tmp_VendorRateArchive4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
 	   AND n1.TrunkID = n2.TrunkID
 	   AND n1.TimezonesID = n2.TimezonesID
	   AND  n1.RateId = n2.RateId
		AND n1.EffectiveDate <= NOW()
		AND n2.EffectiveDate <= NOW();


    INSERT INTO tmp_VendorArchiveCurrentRates_
    SELECT DISTINCT
    p_AccountID,
    r.Code,
    r.Description,
    v_1.Rate,
    v_1.RateN,
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
    FROM tmp_VendorRateArchive_ AS v_1
	INNER JOIN tblRate AS r
    	ON r.RateID = v_1.RateId;

END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.vwVendorCurrentRates
DROP PROCEDURE IF EXISTS `vwVendorCurrentRates`;
DELIMITER //
CREATE PROCEDURE `vwVendorCurrentRates`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_TimezonesID` INT,
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
		RateN float,
		EffectiveDate date,
		TrunkID int,
		TimezonesID int,
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
        TimezonesID INT,
	 	  RateId INT,
        Rate DECIMAL(18,6),
        RateN DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        EndDate date,
        INDEX tmp_RateTable_RateId (`RateId`)
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `TimezonesID`, `RateId`, `Rate`, `RateN`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee` , tblVendorRate.EndDate
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_Trunks) != 0
								AND tblVendorRate.TimezonesID = p_TimezonesID
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
 	   AND n1.TimezonesID = n2.TimezonesID
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
    v_1.RateN,
    DATE_FORMAT (v_1.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
    v_1.TrunkID,
    v_1.TimezonesID,
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

-- Dumping structure for procedure Ratemanagement3.vwVendorSippySheet
DROP PROCEDURE IF EXISTS `vwVendorSippySheet`;
DELIMITER //
CREATE PROCEDURE `vwVendorSippySheet`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_TimezonesID` INT,
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

		call vwVendorCurrentRates(p_AccountID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);

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
				vendorRate.RateN AS `Price N`,
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
				CASE WHEN EffectiveDate < NOW()  THEN
					'NOW'
				ELSE
					DATE_FORMAT( EffectiveDate, '%Y-%m-%d %H:%i:%s' )
				END AS `Activation Date`,
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
						 AND vendorRate.TimezonesID = tblVendorBlocking.TimezonesID
				LEFT OUTER JOIN tblVendorBlocking AS blockCountry
					ON vendorRate.CountryID = blockCountry.CountryId
						 AND tblAccount.AccountID = blockCountry.AccountId
						 AND vendorRate.TrunkID = blockCountry.TrunkID
						 AND vendorRate.TimezonesID = blockCountry.TimezonesID
				LEFT JOIN tblVendorPreference
					ON tblVendorPreference.AccountId = vendorRate.AccountId
						 AND tblVendorPreference.TrunkID = vendorRate.TrunkID
						 AND tblVendorPreference.TimezonesID = vendorRate.TimezonesID
						 AND tblVendorPreference.RateId = vendorRate.RateID
				INNER JOIN tblTrunk
					ON tblTrunk.TrunkID = vendorRate.TrunkID
			WHERE (vendorRate.Rate > 0);


	END//
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.vwVendorVersion3VosSheet
DROP PROCEDURE IF EXISTS `vwVendorVersion3VosSheet`;
DELIMITER //
CREATE PROCEDURE `vwVendorVersion3VosSheet`(
	IN `p_AccountID` INT,
	IN `p_Trunks` LONGTEXT,
	IN `p_TimezonesID` INT,
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


	 Call vwVendorCurrentRates(p_AccountID,p_Trunks,p_TimezonesID,p_Effective,p_CustomDate);


INSERT INTO tmp_VendorVersion3VosSheet_
SELECT


    vendorRate.RateID AS RateID,
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
    AND vendorRate.TimezonesID = tblVendorBlocking.TimezonesID
    AND vendorRate.RateID = tblVendorBlocking.RateId
    AND tblAccount.AccountID = tblVendorBlocking.AccountId
LEFT OUTER JOIN tblVendorBlocking AS blockCountry
    ON vendorRate.TrunkId = blockCountry.TrunkID
    AND vendorRate.TimezonesID = blockCountry.TimezonesID
    AND vendorRate.CountryID = blockCountry.CountryId
    AND tblAccount.AccountID = blockCountry.AccountId
INNER JOIN tblTrunk
    ON tblTrunk.TrunkID = vendorRate.TrunkId
WHERE (vendorRate.Rate > 0);


	 -- for archive rates
	 IF p_Effective != 'Now' THEN

		 	call vwVendorArchiveCurrentRates(p_AccountID,p_Trunks,p_TimezonesID,p_Effective);

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
				 AND vendorArchiveRate.TrunkID = vendorRate.TrunkID
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

USE `RMBilling3`;

-- Dumping structure for procedure RMBilling3.fnVendorUsageDetail
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
		AND ((p_ZeroValueBuyingCost = 0) OR ( p_ZeroValueBuyingCost = 1 AND buying_cost = 0) OR ( p_ZeroValueBuyingCost = 2 AND buying_cost > 0))
	) tbl
	WHERE
	( ( p_billing_time =1 OR p_billing_time =3 )  AND connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR
	(p_billing_time =2 AND disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
--	AND billed_duration > 0      (  Sumera : Insert Vendor CDR :  only if  billed_duration = 0 AND buying_cost = 0 AND selling_cost =  0  ; then only insert into failed call)
	ORDER BY disconnect_time DESC;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_CreateInvoiceFromRecurringInvoice
DROP PROCEDURE IF EXISTS `prc_CreateInvoiceFromRecurringInvoice`;
DELIMITER //
CREATE PROCEDURE `prc_CreateInvoiceFromRecurringInvoice`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceIDs` VARCHAR(200),
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_LogStatus` INT,
	IN `p_ProsessID` VARCHAR(50),
	IN `p_CurrentDate` DATETIME

)
    COMMENT 'test'
BEGIN
	DECLARE v_Note VARCHAR(100);
	DECLARE v_Check int;
	DECLARE v_SkippedWIthDate VARCHAR(200);
	DECLARE v_SkippedWIthOccurence VARCHAR(200);
	DECLARE v_Message VARCHAR(200);
	DECLARE v_InvoiceID int;
	DECLARE cnt_stock int;
	DECLARE v_StockErrorMessage VARCHAR(200);
	
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_Note = CONCAT('Recurring Invoice Generated by ',p_ModifiedBy,' ');
	SET v_StockErrorMessage = '';
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		CompanyID int,
		Title varchar(50),
		AccountID int,
		Address varchar(500),
		InvoiceNumber varchar(30),
		IssueDate datetime,
		CurrencyID int,
		PONumber varchar(30),
		InvoiceType int,
		SubTotal decimal(18,6),
		TotalDiscount decimal(18,6),
		TaxRateID int,
		TotalTax decimal(18,6),
		RecurringInvoiceTotal decimal(18,6),
		GrandTotal decimal(18,6),
		Description varchar(100),
		Attachment varchar(200),
		Note  longtext,
		Terms longtext,
		InvoiceStatus varchar(50),
		PDF varchar(500),
		UsagePath varchar(500),
		PreviousBalance decimal(18,6),
		TotalDue decimal(18,6),
		Payment decimal(18,6),
		CreatedBy varchar(50),
		ModifiedBy varchar(50),
		created_at datetime,
		updated_at datetime,
		ItemInvoice tinyint(3),
		FooterTerm longtext,
		RecurringInvoiceID int,
		ProsessID varchar(50),
		NextInvoiceDate datetime,
		Occurrence int,
		BillingClassID int
	);

	INSERT INTO tmp_Invoices_ 
 	SELECT rinv.CompanyID,
 				rinv.Title,
	 		 rinv.AccountID,
			 rinv.Address,
			 null as InvoiceNumber,
			 DATE(p_CurrentDate) as IssueDate,
			 rinv.CurrencyID,
			 '' as PONumber,
			 1 as InvoiceType,
			 rinv.SubTotal,
			 rinv.TotalDiscount,
			 rinv.TaxRateID,
			 rinv.TotalTax,
			 rinv.RecurringInvoiceTotal,
			 rinv.GrandTotal,
			 rinv.Description,
			 rinv.Attachment,
			 rinv.Note,
			 rinv.Terms,
			 'awaiting' as InvoiceStatus,
			 rinv.PDF,
			 '' as UsagePath,
			 0 as PreviousBalance,
			 0 as TotalDue,
			 0 as Payment,
			 rinv.CreatedBy,
			 '' as ModifiedBy,
			p_CurrentDate as created_at,
			p_CurrentDate as updated_at,
			1 as ItemInvoice,
			rinv.FooterTerm,
			rinv.RecurringInvoiceID,
			p_ProsessID,
			rinv.NextInvoiceDate,
			rinv.Occurrence,
			rinv.BillingClassID
		FROM tblRecurringInvoice rinv
		WHERE rinv.CompanyID = p_CompanyID
		AND rinv.RecurringInvoiceID=p_InvoiceIDs;

		
     SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with INVOICE DATE ',DATE(temp.NextInvoiceDate)) separator '\n\r') INTO v_SkippedWIthDate
	  FROM tmp_Invoices_ temp
	  WHERE (DATE(temp.NextInvoiceDate) > DATE(p_CurrentDate));

	  
	  SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with exceding limit Occurrence ',(SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID)) separator '\n\r') INTO v_SkippedWIthOccurence
	  FROM tmp_Invoices_ temp
	  	WHERE (temp.Occurrence > 0
		  	AND (SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID) >= temp.Occurrence);

     
     SELECT CASE
    								
	  				WHEN ((v_SkippedWIthDate IS NOT NULL) OR (v_SkippedWIthOccurence IS NOT NULL))
					THEN CONCAT(IFNULL(v_SkippedWIthDate,''),'\n\r',IFNULL(v_SkippedWIthOccurence,'')) 
							
				ELSE ''
				END as message INTO v_Message;
				

	IF(v_Message="") THEN
        

		INSERT INTO tblInvoice (`CompanyID`, `AccountID`, `Address`, `InvoiceNumber`, `IssueDate`, `CurrencyID`, `PONumber`, `InvoiceType`, `SubTotal`, `TotalDiscount`, `TaxRateID`, `TotalTax`, `InvoiceTotal`, `GrandTotal`, `Description`, `Attachment`, `Note`, `Terms`, `InvoiceStatus`, `PDF`, `UsagePath`, `PreviousBalance`, `TotalDue`, `Payment`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ItemInvoice`, `FooterTerm`,`RecurringInvoiceID`,`ProcessID`,`BillingClassID`)
	 	SELECT
		 rinv.CompanyID,
		 rinv.AccountID,
		 rinv.Address,
		 FNGetInvoiceNumber(p_CompanyID,rinv.AccountID,rinv.BillingClassID) as InvoiceNumber,
		 DATE(p_CurrentDate) as IssueDate,
		 rinv.CurrencyID,
		 '' as PONumber,
		 1 as InvoiceType,
		 rinv.SubTotal,
		 rinv.TotalDiscount,
		 rinv.TaxRateID,
		 rinv.TotalTax,
		 rinv.RecurringInvoiceTotal,
		 rinv.GrandTotal,
		 rinv.Description,
		 rinv.Attachment,
		 rinv.Note,
		 rinv.Terms,
		 'awaiting' as InvoiceStatus,
		 rinv.PDF,
		 '' as UsagePath,
		 0 as PreviousBalance,
		 0 as TotalDue,
		 0 as Payment,
		 rinv.CreatedBy,
		 '' as ModifiedBy,
		p_CurrentDate as created_at,
		p_CurrentDate as updated_at,
		1 as ItemInvoice,
		rinv.FooterTerm,
		rinv.RecurringInvoiceID,
		p_ProsessID,
		rinv.BillingClassID
		FROM tmp_Invoices_ rinv;

		SET v_InvoiceID = LAST_INSERT_ID();

		INSERT INTO tblInvoiceDetail ( `InvoiceID`, `ProductID`, `Description`, `StartDate`, `EndDate`, `Price`, `Qty`, `Discount`, `TaxRateID`,`TaxRateID2`, `TaxAmount`, `LineTotal`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ProductType`)
			select
				inv.InvoiceID,
				rinvd.ProductID,
				rinvd.Description,
				null as StartDate,
				null as EndDate,
				rinvd.Price,
				rinvd.Qty,
				rinvd.Discount,
				rinvd.TaxRateID,
				rinvd.TaxRateID2,
				rinvd.TaxAmount,
				rinvd.LineTotal,
				rinvd.CreatedBy,
				rinvd.ModifiedBy,
				rinvd.created_at,
				p_CurrentDate as updated_at,
				rinvd.ProductType
				FROM tblRecurringInvoiceDetail rinvd
				INNER JOIN tblInvoice inv ON  inv.RecurringInvoiceID = rinvd.RecurringInvoiceID
				INNER JOIN tblRecurringInvoice rinv ON  rinv.RecurringInvoiceID = rinvd.RecurringInvoiceID
				WHERE rinv.CompanyID = p_CompanyID
				AND inv.InvoiceID = v_InvoiceID;

		INSERT INTO tblInvoiceTaxRate ( `InvoiceID`,`InvoiceDetailID`, `TaxRateID`, `TaxAmount`,`InvoiceTaxType`,`Title`, `CreatedBy`,`ModifiedBy`)
		SELECT
			inv.InvoiceID,
			rinvt.RecurringInvoiceDetailID,
			rinvt.TaxRateID,
			rinvt.TaxAmount,
			rinvt.RecurringInvoiceTaxType,
			rinvt.Title,
			rinvt.CreatedBy,
			rinvt.ModifiedBy
		FROM tblRecurringInvoiceTaxRate rinvt
		INNER JOIN tblInvoice inv ON  inv.RecurringInvoiceID = rinvt.RecurringInvoiceID
		INNER JOIN tblRecurringInvoice rinv ON  rinv.RecurringInvoiceID = rinvt.RecurringInvoiceID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;

		INSERT INTO tblInvoiceLog (InvoiceID,Note,InvoiceLogStatus,created_at)
		SELECT inv.InvoiceID,CONCAT(v_Note, CONCAT(LTRIM(RTRIM(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.InvoiceNumber)))) as Note,1 as InvoiceLogStatus,p_CurrentDate as created_at
		FROM tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN Ratemanagement3.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;

			
		INSERT INTO tblRecurringInvoiceLog (RecurringInvoiceID,Note,RecurringInvoiceLogStatus,created_at)
		SELECT inv.RecurringInvoiceID,CONCAT(v_Note, CONCAT(LTRIM(RTRIM(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.InvoiceNumber)))) as Note,p_LogStatus as InvoiceLogStatus,p_CurrentDate as created_at
		FROM tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN Ratemanagement3.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;


		
		UPDATE tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN Ratemanagement3.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		SET FullInvoiceNumber = IF(inv.InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(inv.InvoiceNumber))),ltrim(rtrim(inv.InvoiceNumber)))
		WHERE inv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_TaxRateDetail_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TaxRateDetail_(
			InvoiceTaxRateID int,
			InvoiceDetailID int
		);
	
		INSERT INTO tmp_TaxRateDetail_
		SELECT 
		tblInvoiceTaxRate.InvoiceTaxRateID,
		tblInvoiceDetail.InvoiceDetailID
		FROM tblInvoiceTaxRate
		JOIN tblRecurringInvoiceDetail on tblRecurringInvoiceDetail.RecurringInvoiceDetailID=tblInvoiceTaxRate.InvoiceDetailID 
		JOIN tblInvoiceDetail on tblInvoiceDetail.InvoiceID=v_InvoiceID AND tblInvoiceDetail.ProductID=tblRecurringInvoiceDetail.ProductID AND tblInvoiceDetail.Price=tblRecurringInvoiceDetail.Price
		WHERE tblInvoiceTaxRate.InvoiceID = v_InvoiceID AND tblInvoiceTaxRate.InvoiceDetailID !=0
		GROUP BY tblInvoiceTaxRate.InvoiceTaxRateID,tblInvoiceDetail.InvoiceDetailID
		;
		
		UPDATE tblInvoiceTaxRate a
		INNER JOIN tmp_TaxRateDetail_ b ON a.InvoiceTaxRateID=b.InvoiceTaxRateID
		SET a.InvoiceDetailID=b.InvoiceDetailID
		WHERE a.InvoiceTaxRateID=b.InvoiceTaxRateID;
		
		CALL prc_StockManageRecurringInvoice(p_CompanyID,p_InvoiceIDs,v_InvoiceID,p_ModifiedBy);
		
			
	END IF;

	SELECT v_Message as Message, IFNULL(v_InvoiceID,0) as InvoiceID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getAccountSubscription
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

-- Dumping structure for procedure RMBilling3.prc_getCreditNoteInvoices
DROP PROCEDURE IF EXISTS `prc_getCreditNoteInvoices`;
DELIMITER //
CREATE PROCEDURE `prc_getCreditNoteInvoices`(
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT
)
BEGIN
DECLARE v_OffSet_ int;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

DROP TEMPORARY TABLE IF EXISTS tmp_CreditNotes_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CreditNotes_(
		InvoiceID int,		
		FullInvoiceNumber varchar(100),
		IssueDate datetime,	
		GrandTotal decimal(18,6),
		TotalPayment decimal(18,6),
		AccountID int
	);

		INSERT INTO tmp_CreditNotes_
		select 
			`tblInvoice`.`InvoiceID`,
 			`tblInvoice`.`FullInvoiceNumber`,
  			`tblInvoice`.`IssueDate`,
   		`tblInvoice`.`GrandTotal`,
			(select IFNULL(SUM(Amount),0) from tblPayment where tblPayment.InvoiceID=tblInvoice.InvoiceID and tblPayment.Recall=0) as TotalPayment,
			p_AccountID as AccountID
			from `tblInvoice` 
			where `tblInvoice`.`AccountID` = p_AccountID 
			and `tblInvoice`.`GrandTotal` <> 0 
		  	and (p_InvoiceNumber = '' OR ( p_InvoiceNumber != '' AND `tblInvoice`.`FullInvoiceNumber` = p_InvoiceNumber))
			and `tblInvoice`.`InvoiceStatus` in ('partially_paid','send','awaiting');
			
			
			select 	*
			from `tmp_CreditNotes_`
			where `tmp_CreditNotes_`.`GrandTotal` > `tmp_CreditNotes_`.`TotalPayment` 
			
			 LIMIT p_RowspPage OFFSET v_OffSet_;		
			 
		 SELECT
            COUNT(*) AS totalcount
        FROM
        tmp_CreditNotes_ cn
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = cn.AccountID;
			
			SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getCreditNotes
DROP PROCEDURE IF EXISTS `prc_getCreditNotes`;
DELIMITER //
CREATE PROCEDURE `prc_getCreditNotes`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_CreditNotesNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_CreditNotesStatus` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_CurrencyID` INT,
	IN `p_isExport` INT
)
BEGIN
    
    DECLARE v_OffSet_ INT;
    DECLARE v_Round_ INT;    
    DECLARE v_CurrencyCode_ VARCHAR(50);
 	 SET sql_mode = 'ALLOW_INVALID_DATES';
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	        
 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
 	 SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	 SELECT cr.Symbol INTO v_CurrencyCode_ from Ratemanagement3.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
    IF p_isExport = 0
    THEN
        SELECT 
        ac.AccountName,
        CONCAT(LTRIM(RTRIM(cn.CreditNotesNumber))) AS CreditNotesNumber,
        cn.IssueDate,
        CONCAT(IFNULL(cr.Symbol,''),ROUND(cn.GrandTotal,v_Round_)) AS GrandTotal2,		
        cn.CreditNotesStatus,
        cn.CreditNotesID,
        cn.Description,
        cn.Attachment,
        cn.AccountID,		  
		  IFNULL(ac.BillingEmail,'') AS BillingEmail,
		  ROUND(cn.GrandTotal,v_Round_) AS GrandTotal,
		  IFNULL(cn.GrandTotal - cn.PaidAmount,0) AS CreditNoteAmount
		  
        FROM tblCreditNotes cn
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = cn.AccountID
        
		INNER JOIN Ratemanagement3.tblBillingClass b ON cn.BillingClassID = b.BillingClassID	
		LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        LEFT JOIN Ratemanagement3.tblCurrency cr ON cn.CurrencyID   = cr.CurrencyId 
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND cn.AccountID = p_AccountID))
        AND (p_CreditNotesNumber = '' OR ( p_CreditNotesNumber != '' AND cn.CreditNotesNumber = p_CreditNotesNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND cn.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND cn.IssueDate <= p_IssueDateEnd))
        AND (p_CreditNotesStatus = '' OR ( p_CreditNotesStatus != '' AND cn.CreditNotesStatus = p_CreditNotesStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND cn.CurrencyID = p_CurrencyID))
        ORDER BY
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ac.AccountName
            END DESC,
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ac.AccountName
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesStatusDESC') THEN cn.CreditNotesStatus
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesStatusASC') THEN cn.CreditNotesStatus
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesNumberASC') THEN cn.CreditNotesNumber
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesNumberDESC') THEN cn.CreditNotesNumber
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN cn.IssueDate
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN cn.IssueDate
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN cn.GrandTotal
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN cn.GrandTotal
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesIDDESC') THEN cn.CreditNotesID
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesIDASC') THEN cn.CreditNotesID
            END ASC
        
        LIMIT p_RowspPage OFFSET v_OffSet_;
        
        
        SELECT
            COUNT(*) AS totalcount,  ROUND(SUM(cn.GrandTotal),v_Round_) AS total_grand,v_CurrencyCode_ as currency_symbol
        FROM
        tblCreditNotes cn
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = cn.AccountID
        
		INNER JOIN Ratemanagement3.tblBillingClass b ON cn.BillingClassID = b.BillingClassID
		LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND cn.AccountID = p_AccountID))
        AND (p_CreditNotesNumber = '' OR ( p_CreditNotesNumber != '' AND cn.CreditNotesNumber = p_CreditNotesNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND cn.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND cn.IssueDate <= p_IssueDateEnd))
        AND (p_CreditNotesStatus = '' OR ( p_CreditNotesStatus != '' AND cn.CreditNotesStatus = p_CreditNotesStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND cn.CurrencyID = p_CurrencyID));
    END IF;
    IF p_isExport = 1
    THEN
        SELECT ac.AccountName ,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(cn.CreditNotesNumber)))) AS CreditNotesNumber,
        cn.IssueDate,
        ROUND(cn.GrandTotal,v_Round_) AS GrandTotal,        
        cn.CreditNotesStatus
        FROM tblCreditNotes cn
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = cn.AccountID
        
		INNER JOIN Ratemanagement3.tblBillingClass b ON cn.BillingClassID = b.BillingClassID
	    LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND cn.AccountID = p_AccountID))
        AND (p_CreditNotesNumber = '' OR ( p_CreditNotesNumber != '' AND cn.CreditNotesNumber = p_CreditNotesNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND cn.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND cn.IssueDate <= p_IssueDateEnd))
        AND (p_CreditNotesStatus = '' OR ( p_CreditNotesStatus != '' AND cn.CreditNotesStatus = p_CreditNotesStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND cn.CurrencyID = p_CurrencyID));
    END IF;
     IF p_isExport = 2
    THEN
        SELECT ac.AccountID ,
        ac.AccountName,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(cn.CreditNotesNumber)))) AS CreditNotesNumber,
        cn.IssueDate,
		  ROUND(cn.GrandTotal,v_Round_) AS GrandTotal,		  
        cn.CreditNotesStatus,
        cn.CreditNotesID
        FROM tblCreditNotes cn
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = cn.AccountID
       
		INNER JOIN Ratemanagement3.tblBillingClass b ON cn.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND cn.AccountID = p_AccountID))
        AND (p_CreditNotesNumber = '' OR ( p_CreditNotesNumber != '' AND cn.CreditNotesNumber = p_CreditNotesNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND cn.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND cn.IssueDate <= p_IssueDateEnd))
        AND (p_CreditNotesStatus = '' OR ( p_CreditNotesStatus != '' AND cn.CreditNotesStatus = p_CreditNotesStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND cn.CurrencyID = p_CurrencyID));
    END IF; 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_GetCreditNotesLog
DROP PROCEDURE IF EXISTS `prc_GetCreditNotesLog`;
DELIMITER //
CREATE PROCEDURE `prc_GetCreditNotesLog`(IN `p_CompanyID` INT, IN `p_CreditNotesID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    IF p_isExport = 0
    THEN

       
            SELECT
                el.Note,
                el.CreditNotesLogStatus,
                el.created_at,                
                es.CreditNotesID                
            FROM tblCreditNotes es
            INNER JOIN Ratemanagement3.tblAccount ac
                ON ac.AccountID = es.AccountID
            INNER JOIN tblCreditNotesLog el
                ON el.CreditNotesID = es.CreditNotesID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_CreditNotesID = '' 
            OR (p_CreditNotesID != ''
            AND es.CreditNotesID = p_CreditNotesID))
             ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesLogStatusDESC') THEN el.CreditNotesLogStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreditNotesLogStatusASC') THEN el.CreditNotesLogStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN el.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN el.created_at
                END ASC
					LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblCreditNotes es
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblCreditNotesLog el
            ON el.CreditNotesID = es.CreditNotesID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_CreditNotesID = ''
        OR (p_CreditNotesID != ''
        AND es.CreditNotesID = p_CreditNotesID));

    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            el.Note,
            el.created_at,
            el.CreditNotesLogStatus,
            es.CreditNotesNumber
        FROM tblCreditNotes es
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblCreditNotesLog el
            ON el.CreditNotesID = es.CreditNotesID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_CreditNotesID = ''
        OR (p_CreditNotesID != ''
        AND es.CreditNotesID = p_CreditNotesID));


    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getDashboardinvoiceExpenseTotalOutstanding
DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpenseTotalOutstanding`;
DELIMITER //
CREATE PROCEDURE `prc_getDashboardinvoiceExpenseTotalOutstanding`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_EndDate` VARCHAR(50)

)
BEGIN

	DECLARE v_Round_ INT;
	
	DECLARE v_TotalInvoiceIn_ DECIMAL(18,6);
	DECLARE v_TotalInvoiceOut_ DECIMAL(18,6);
	DECLARE v_TotalPaymentIn_ DECIMAL(18,6);
	DECLARE v_TotalPaymentOut_ DECIMAL(18,6);
	DECLARE v_TotalOutstanding_ DECIMAL(18,6);	
	DECLARE v_Outstanding_ DECIMAL(18,6);

	DECLARE v_InvoiceSentTotal_ DECIMAL(18,6);
	DECLARE v_InvoiceRecvTotal_ DECIMAL(18,6);
	DECLARE v_PaymentSentTotal_ DECIMAL(18,6);
	DECLARE v_PaymentRecvTotal_ DECIMAL(18,6);

	DECLARE v_TotalUnpaidInvoices_ DECIMAL(18,6);
	DECLARE v_TotalOverdueInvoices_ DECIMAL(18,6);
	DECLARE v_TotalPaidInvoices_ DECIMAL(18,6);
	DECLARE v_TotalDispute_ DECIMAL(18,6);
	DECLARE v_TotalEstimate_ DECIMAL(18,6);
	DECLARE v_TotalTopUP_ DECIMAL(18,6);	
	

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		InvoiceType TINYINT(1),
		IssueDate DATETIME,
		GrandTotal DECIMAL(18,6),
		InvoiceStatus VARCHAR(50),
		PaymentDueInDays INT,
		PendingAmount DECIMAL(18,6),
		AccountID INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Payment_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payment_(
		PaymentAmount DECIMAL(18,6),
		PaymentDate DATETIME,
		PaymentType VARCHAR(50)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Dispute_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dispute_(
		DisputeAmount DECIMAL(18,6)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Estimate_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Estimate_(
		EstimateTotal DECIMAL(18,6)
	);

	
	INSERT INTO tmp_Dispute_
	SELECT 
		ds.DisputeAmount 
	FROM tblDispute ds
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = ds.AccountID
	WHERE ds.CompanyID = p_CompanyID
	AND ac.CurrencyId = p_CurrencyID
	AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
	AND ds.Status = 0
	AND ((p_EndDate = '0' AND fnGetMonthDifference(ds.created_at,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND ds.created_at between p_StartDate AND p_EndDate));

	
	INSERT INTO tmp_Estimate_
	SELECT 
		es.GrandTotal 
	FROM tblEstimate es
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = es.AccountID
	WHERE es.CompanyID = p_CompanyID
	AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
	AND ac.CurrencyId = p_CurrencyID
	AND es.EstimateStatus NOT IN ('draft','accepted','rejected')
	AND ((p_EndDate = '0' AND fnGetMonthDifference(es.IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND es.IssueDate between p_StartDate AND p_EndDate));
	
	
	INSERT INTO tmp_Invoices_
	SELECT 
		inv.InvoiceType,
		inv.IssueDate,
		inv.GrandTotal,
		inv.InvoiceStatus,
		(SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID LIMIT 1 ) as PaymentDueInDays,
		(inv.GrandTotal -  (SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
		ac.AccountID
	FROM tblInvoice inv
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = inv.AccountID 
		AND inv.CompanyID = p_CompanyID
		AND inv.CurrencyID = p_CurrencyID
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
		AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft') )  )
		AND ((p_EndDate = '0' AND fnGetMonthDifference(IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND IssueDate BETWEEN p_StartDate AND p_EndDate));

	
	INSERT INTO tmp_Payment_
	SELECT 
		p.Amount,
		p.PaymentDate,
		p.PaymentType
		FROM tblPayment p 
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = p.AccountID
	WHERE 
		p.CompanyID = p_CompanyID
		AND ac.CurrencyId = p_CurrencyID
		AND p.Status = 'Approved'
		AND p.Recall=0
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
		AND (
			(p_EndDate = '0' AND fnGetMonthDifference(PaymentDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND PaymentDate between p_StartDate AND p_EndDate)
			);

	
	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) INTO v_TotalInvoiceOut_,v_TotalInvoiceIn_
	FROM tmp_Invoices_;
	
	SELECT 
		SUM(IF(PaymentType='Payment In',PaymentAmount,0)),
		SUM(IF(PaymentType='Payment Out',PaymentAmount,0)) INTO v_TotalPaymentIn_,v_TotalPaymentOut_
	FROM tmp_Payment_;
	
	/* calculate TopUp Amount*/
	SELECT SUM(id.LineTotal)
	INTO
		v_TotalTopUP_
	FROM tblInvoiceDetail id 
			INNER JOIN tblInvoice inv ON id.InvoiceID=inv.InvoiceID		
			INNER JOIN tblProduct p ON id.ProductID=p.ProductID AND p.Code='topup'
	WHERE 
		inv.CompanyID = p_CompanyID
		AND inv.CurrencyID = p_CurrencyID
		AND (p_AccountID = 0 or inv.AccountID = p_AccountID)
		AND ( (inv.InvoiceType = 2) OR ( inv.InvoiceType = 1 AND inv.InvoiceStatus NOT IN ( 'cancel' , 'draft','awaiting') )  )
		AND ((p_EndDate = '0' AND fnGetMonthDifference(inv.IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND inv.IssueDate BETWEEN p_StartDate AND p_EndDate));

	SELECT (IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)) - (IFNULL(v_TotalTopUP_,0)) INTO v_Outstanding_;
	
	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceSentTotal_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1;

	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceRecvTotal_
	FROM tmp_Invoices_ 
	WHERE  InvoiceType = 2;
	
	
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentRecvTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment In';
	
	
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentSentTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment Out';
	
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalUnpaidInvoices_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1
	AND InvoiceStatus <> 'paid' 
	AND PendingAmount > 0;
		
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalOverdueInvoices_
	FROM tmp_Invoices_ 
	WHERE ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting'))
							AND(PendingAmount>0)
						);
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalPaidInvoices_
	FROM tmp_Invoices_ 
	WHERE (InvoiceStatus IN('Paid') AND (PendingAmount=0));
	
		
	SELECT IFNULL(SUM(DisputeAmount),0) INTO v_TotalDispute_
	FROM tmp_Dispute_;
	
	
	SELECT IFNULL(SUM(EstimateTotal),0) INTO v_TotalEstimate_
	FROM tmp_Estimate_;
	
	SELECT 
			
			ROUND(v_Outstanding_,v_Round_) AS Outstanding,
			ROUND(v_PaymentRecvTotal_,v_Round_) AS TotalPaymentsIn,
			ROUND(v_PaymentSentTotal_,v_Round_) AS TotalPaymentsOut,
			ROUND(v_InvoiceRecvTotal_,v_Round_) AS TotalInvoiceIn,
			ROUND(v_InvoiceSentTotal_,v_Round_) AS TotalInvoiceOut,
			ROUND(v_TotalUnpaidInvoices_,v_Round_) as TotalDueAmount,
			ROUND(v_TotalOverdueInvoices_,v_Round_) as TotalOverdueAmount,
			ROUND(v_TotalPaidInvoices_,v_Round_) as TotalPaidAmount,
			ROUND(v_TotalDispute_,v_Round_) as TotalDispute,
			ROUND(v_TotalEstimate_,v_Round_) as TotalEstimate,
			v_Round_ as `Round`;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getDashboardTotalOutStanding
DROP PROCEDURE IF EXISTS `prc_getDashboardTotalOutStanding`;
DELIMITER //
CREATE PROCEDURE `prc_getDashboardTotalOutStanding`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT
)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_TotalInvoiceOut_ decimal(18,6);
	DECLARE v_TotalPaymentIn_ decimal(18,6);
	DECLARE v_TotalInvoiceIn_ decimal(18,6);
	DECLARE v_TotalPaymentOut_ decimal(18,6);
	DECLARE v_TotalTopUP_ decimal(18,6);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) 
	INTO 
		v_TotalInvoiceOut_,
		v_TotalInvoiceIn_
	FROM tblInvoice 
	WHERE 
		CompanyID = p_CompanyID
		AND CurrencyID = p_CurrencyID		
		AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft','awaiting') )  )
		AND (p_AccountID = 0 or AccountID = p_AccountID);
		
	SELECT 
		SUM(IF(PaymentType='Payment In',p.Amount,0)),
		SUM(IF(PaymentType='Payment Out',p.Amount,0)) 
	INTO 
		v_TotalPaymentIn_,
		v_TotalPaymentOut_
	FROM tblPayment p 
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON ac.AccountID = p.AccountID
	WHERE 
		p.CompanyID = p_CompanyID
		AND ac.CurrencyId = p_CurrencyID	
		AND p.Status = 'Approved'
		AND p.Recall=0
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID);
		
		
	/* calculate TopUp Amount*/	
	SELECT 
		SUM(id.LineTotal)
	INTO
		v_TotalTopUP_
	FROM tblInvoiceDetail id 
			INNER JOIN tblInvoice i ON id.InvoiceID=i.InvoiceID					
			INNER JOIN tblProduct p ON id.ProductID=p.ProductID AND p.Code='topup'
	WHERE 
		i.CompanyID = p_CompanyID
		AND i.CurrencyID = p_CurrencyID 
		AND ( (i.InvoiceType = 2) OR ( i.InvoiceType = 1 AND i.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
		AND (p_AccountID = 0 OR  i.AccountID = p_AccountID);
	
	
	SELECT 
		ROUND((IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)) - (IFNULL(v_TotalTopUP_,0)),v_Round_) AS TotalOutstanding,
		ROUND((IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)),v_Round_) AS TotalReceivable,
		ROUND((IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)),v_Round_) AS TotalPayable;
	


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getDisputes
DROP PROCEDURE IF EXISTS `prc_getDisputes`;
DELIMITER //
CREATE PROCEDURE `prc_getDisputes`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceType` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(100),
	IN `p_Status` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Export` INT



)
BEGIN

     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    			SELECT   
    			ds.InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				 CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at as `CreatedDate`,
				ds.CreatedBy,
				CASE WHEN LENGTH(ds.Notes) > 100 THEN CONCAT(SUBSTRING(ds.Notes, 1, 100) , '...')
						 ELSE  ds.Notes 
						 END as ShortNotes ,
		 		ds.DisputeID,
		 	   ds.Attachment,
		 	   a.AccountID,
		 		ds.Notes,
		 		ds.Ref
		 		
            from tblDispute ds
            inner join Ratemanagement3.tblAccount a on a.AccountID = ds.AccountID

				where ds.CompanyID = p_CompanyID

			   AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
            AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
           AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) 
            
         ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoDESC') THEN InvoiceNo
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoASC') THEN InvoiceNo
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeAmountDESC') THEN DisputeAmount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeAmountASC') THEN DisputeAmount
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN ds.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN ds.created_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN ds.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN ds.Status
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeIDDESC') THEN DisputeID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeIDASC') THEN DisputeID
                END ASC 			 
					 					 					    	             
                
            LIMIT p_RowspPage OFFSET v_OffSet_;

		 

				 SELECT   
		 		COUNT(ds.DisputeID) AS totalcount,
		 		sum(ds.DisputeAmount) as TotalDisputeAmount
            from tblDispute ds
            inner join Ratemanagement3.tblAccount a on a.AccountID = ds.AccountID
				where ds.CompanyID = p_CompanyID

				AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
            AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
            AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) ;
            
   END IF;         
	IF p_Export = 1
	THEN

				SELECT   
				ds.InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				 CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at as `CreatedDate`,
				ds.CreatedBy,
		 		ds.Notes
				

            from tblDispute ds
            inner join Ratemanagement3.tblAccount a on a.AccountID = ds.AccountID
            
            
				where ds.CompanyID = p_CompanyID
            
            AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
				AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
           AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) ;

	END IF;
	
	IF p_Export = 2
	THEN

				SELECT   
					ds.DisputeID,
				ds.InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				 CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at as `CreatedDate`,
				ds.CreatedBy,
		 		ds.Notes,
		 		a.AccountID
				

            from tblDispute ds
            inner join Ratemanagement3.tblAccount a on a.AccountID = ds.AccountID
            
            
				where ds.CompanyID = p_CompanyID
            
            AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
				AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
           AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) ;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getInvoice
DROP PROCEDURE IF EXISTS `prc_getInvoice`;
DELIMITER //
CREATE PROCEDURE `prc_getInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_InvoiceType` INT,
	IN `p_InvoiceStatus` LONGTEXT,
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
		Currency varchar(50),
		GrandTotal decimal(18,6),
		TotalPayment decimal(18,6),
		PendingAmount decimal(18,6),
		InvoiceStatus varchar(50),
		CreditNoteAmount decimal(18,6),
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
		NominalAnalysisNominalAccountNumber varchar(100),
		TotalMinutes BIGINT(20)
	);

		INSERT INTO tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			cr.Code AS Currency,
			inv.GrandTotal as GrandTotal,
			(SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			
         (SELECT IFNULL(sum(GrandTotal) - sum(PaidAmount),0)  FROM tblCreditNotes c WHERE c.AccountID = inv.AccountID and c.CreditNotesStatus='open' and inv.InvoiceType=1) as CreditNoteAmount,
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
			ac.NominalAnalysisNominalAccountNumber,
			IFNULL((SELECT SUM(IFNULL(TotalMinutes,0)) FROM tblInvoiceDetail tid WHERE tid.InvoiceID=inv.InvoiceID GROUP BY tid.InvoiceID),0) AS TotalMinutes
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
			IF(InvoiceStatus IN ('send','awaiting'), IF(DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))) > 0,DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))),''), '') AS DueDays,
			InvoiceID,
			Description,
			Attachment,
			AccountID,
			PendingAmount as OutstandingAmount,
			ItemInvoice,
			BillingEmail,
			GrandTotal,
			CreditNoteAmount
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
			CreditNoteAmount,
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
			CreditNoteAmount,
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
	
	IF p_isExport = 3 -- api
	THEN

		SELECT
			InvoiceID,
			AccountName,
			InvoiceNumber,
			IssueDate,
			InvoicePeriod,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
			InvoiceStatus,
			DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY)) AS DueDate,
			IF(InvoiceStatus IN ('send','awaiting'), IF(DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))) > 0,DATEDIFF(CURDATE(),DATE(DATE_ADD(IssueDate, INTERVAL IFNULL(PaymentDueInDays,0) DAY))),''), '') AS DueDays,
			Currency,
			InvoiceID,
			Description,
			Attachment,
			AccountID,
			PendingAmount as OutstandingAmount,
			ItemInvoice,
			BillingEmail,
			GrandTotal,
			TotalMinutes
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
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getItemTypes
DROP PROCEDURE IF EXISTS `prc_getItemTypes`;
DELIMITER //
CREATE PROCEDURE `prc_getItemTypes`(
	IN `p_CompanyID` INT,
	IN `p_title` VARCHAR(50),
	IN `p_Active` VARCHAR(1),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT

)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblItemType.ItemTypeID,
			tblItemType.title,
			tblItemType.updated_at,
			tblItemType.Active
            from tblItemType
            where tblItemType.CompanyID = p_CompanyID
			AND(p_title ='' OR tblItemType.title like Concat('%',p_title,'%'))
            AND((p_Active = '' OR tblItemType.Active = p_Active))
         ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleDESC') THEN title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleASC') THEN title
                END ASC,
				
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN tblItemType.updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN tblItemType.updated_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveDESC') THEN Active
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveASC') THEN Active
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblItemType.ItemTypeID) AS totalcount
            from tblItemType
            where tblItemType.CompanyID = p_CompanyID
			AND(p_title ='' OR tblItemType.title like Concat('%',p_title,'%'))
            AND((p_Active = '' OR tblItemType.Active = p_Active));

	ELSE

			SELECT
			tblItemType.ItemTypeID,
			tblItemType.title,
			tblItemType.updated_at,
			tblItemType.Active
            from tblItemType
			where tblItemType.CompanyID = p_CompanyID
			AND(p_title ='' OR tblItemType.title like Concat('%',p_title,'%'))
            AND((p_Active = '' OR tblItemType.Active = p_Active));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getLowStockItemsAlert
DROP PROCEDURE IF EXISTS `prc_getLowStockItemsAlert`;
DELIMITER //
CREATE PROCEDURE `prc_getLowStockItemsAlert`(
	IN `p_CompanyID` INT(11)


)
BEGIN
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Products_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Products_(
		`StockHistoryID` int,
		`ProductID` int
	);
	
	INSERT INTO tmp_Products_
	SELECT MAX(StockHistoryID),ProductID from tblStockHistory GROUP BY ProductID;
	
	SELECT  
		it.title AS title,
		p.Name,
		p.Code,
		sh.Stock,
		p.Low_stock_level 
	FROM tmp_Products_ tp
		INNER JOIN tblStockHistory sh ON sh.StockHistoryID = tp.StockHistoryID
		INNER join tblProduct p on p.ProductID=tp.ProductID 
		LEFT join tblItemType it on it.ItemTypeID=p.ItemTypeID 
	WHERE p.Enable_stock=1
		AND p.Low_stock_level > 0 
		AND p.CompanyId=p_CompanyID 
		AND sh.Stock <= p.Low_stock_level 
		AND p.Active=1;
	
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getPBXExportPayment
DROP PROCEDURE IF EXISTS `prc_getPBXExportPayment`;
DELIMITER //
CREATE PROCEDURE `prc_getPBXExportPayment`(
	IN `p_start_date` INT

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		select ac.Number,Notes,PaymentDate,Amount
		from tblPayment inner join Ratemanagement3.tblAccount as ac on ac.AccountID=tblPayment.AccountID
		where
		PaymentType='Payment In' and tblPayment.Status='Approved' and Recall=0 and PaymentDate>p_start_date;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getProducts
DROP PROCEDURE IF EXISTS `prc_getProducts`;
DELIMITER //
CREATE PROCEDURE `prc_getProducts`(
	IN `p_CompanyID` INT,
	IN `p_Name` VARCHAR(50),
	IN `p_Code` VARCHAR(50),
	IN `p_Active` VARCHAR(1),
	IN `p_AppliedTo` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_ItemTypeID` INT,
	IN `p_Export` INT


)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblProduct.ProductID,
			tblItemType.title,
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Buying_price,
			tblProduct.Amount,
			tblProduct.Quantity,
			tblProduct.updated_at,
			tblProduct.Active,
			tblProduct.Description,
			tblProduct.Note,
			tblProduct.AppliedTo,
			tblProduct.Low_stock_level,
			tblProduct.ItemTypeID	
            from tblProduct LEFT JOIN tblItemType ON tblProduct.ItemTypeID = tblItemType.ItemTypeID
            where tblProduct.CompanyID = p_CompanyID
			AND (p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
				AND ((p_ItemTypeID ='' OR tblProduct.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active))
            AND((p_AppliedTo is null OR tblProduct.AppliedTo = p_AppliedTo))
         ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
                END ASC,
            CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Buying_priceDESC') THEN Buying_price
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Buying_priceASC') THEN Buying_price
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuantityDESC') THEN Quantity
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuantityASC') THEN Quantity
                END ASC,
                
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN tblProduct.updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN tblProduct.updated_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveDESC') THEN tblProduct.Active
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveASC') THEN tblProduct.Active
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblProduct.ProductID) AS totalcount
            from tblProduct
            where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active))
				AND((p_AppliedTo is null OR tblProduct.AppliedTo = p_AppliedTo));

	ELSE

			SELECT   
			tblProduct.ProductID,
			tblItemType.title,
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Buying_price,
			tblProduct.Amount,
			tblProduct.Quantity,
			tblProduct.updated_at,
			tblProduct.Active,
			tblProduct.Description,
			tblProduct.Note,
			tblProduct.AppliedTo,
			tblProduct.Low_stock_level,
			tblProduct.Enable_stock
            from tblProduct LEFT JOIN tblItemType ON tblProduct.ItemTypeID = tblItemType.ItemTypeID
            where tblProduct.CompanyID = p_CompanyID
			AND (p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
				AND ((p_ItemTypeID ='' OR tblProduct.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active))
            AND((p_AppliedTo is null OR tblProduct.AppliedTo = p_AppliedTo));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getProductsByItemType
DROP PROCEDURE IF EXISTS `prc_getProductsByItemType`;
DELIMITER //
CREATE PROCEDURE `prc_getProductsByItemType`(
	IN `p_CompanyID` INT,
	IN `p_ItemType` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_Name` VARCHAR(255),
	IN `p_Description` VARCHAR(255)



)
    DETERMINISTIC
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_fieldName VARCHAR(255);
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_products;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_products(
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		ProductID INT,
		ItemTypeID INT		
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_products_fields;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_products_fields(
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		DynamicFieldsID INT(11),
		FieldName Varchar(100),
		FieldType Varchar(100)
	);
		

	IF p_ItemType!='' THEN
	
		INSERT INTO tmp_products (ProductID,ItemTypeID)
			SELECT
					tblProduct.ProductID,
					tblProduct.ItemTypeID
			FROM tblItemType
			INNER JOIN  tblProduct 
				ON tblProduct.ItemTypeID=tblItemType.ItemTypeID
			WHERE 
				tblProduct.CompanyId=p_CompanyID
				AND tblItemType.title=p_ItemType
				AND tblProduct.Quantity > 0
				AND tblProduct.Active=1
				AND(
						(p_Name ='' OR tblProduct.Name like CONCAT(p_Name,'%'))
					OR
						(p_Description ='' OR tblProduct.Description like CONCAT('%',p_Description,'%'))	
					)
				
			 LIMIT p_RowspPage OFFSET v_OffSet_;
			 
			 
			 SELECT 
			 	count(*) as totalcount
			FROM tblItemType
			INNER JOIN  tblProduct 
				ON tblProduct.ItemTypeID=tblItemType.ItemTypeID
			WHERE 
				tblProduct.CompanyId=p_CompanyID
				AND tblItemType.title=p_ItemType
				AND tblProduct.Quantity > 0
				AND tblProduct.Active=1
				AND(
						(p_Name ='' OR tblProduct.Name like CONCAT(p_Name,'%'))
					OR
						(p_Description ='' OR tblProduct.Description like CONCAT('%',p_Description,'%'))	
					);
			 
			 
			 
	ELSE 
	
		INSERT INTO tmp_products (ProductID,ItemTypeID)
			SELECT
				tblProduct.ProductID,
				tblProduct.ItemTypeID
			FROM tblProduct
			WHERE
				tblProduct.CompanyId=p_CompanyID
				AND tblProduct.Quantity > 0
				AND tblProduct.Active=1
				AND(
						(p_Name ='' OR tblProduct.Name like CONCAT(p_Name,'%'))
						OR
						(p_Description ='' OR tblProduct.Description like CONCAT('%',p_Description,'%'))
					)
				
			LIMIT p_RowspPage OFFSET v_OffSet_;
			
			SELECT 
				count(*) as totalcount
			FROM tblProduct
			WHERE
				tblProduct.CompanyId=p_CompanyID
				AND tblProduct.Quantity > 0
				AND tblProduct.Active=1
				AND(
						(p_Name ='' OR tblProduct.Name like CONCAT(p_Name,'%'))
						OR
						(p_Description ='' OR tblProduct.Description like CONCAT('%',p_Description,'%'))
					);
			
	END IF;
			 
				
			INSERT INTO tmp_products_fields (FieldName,DynamicFieldsID,FieldType)
			SELECT 
				DISTINCT a.FieldName,
				a.DynamicFieldsID,
				a.FieldDomType
			FROM Ratemanagement3.tblDynamicFields a
			INNER JOIN tmp_products b
			ON a.ItemTypeID=b.ItemTypeID
			WHERE 
				a.Type='product'
				AND a.CompanyID=p_CompanyID
				AND a.`Status`=1;	
						 
			SET @v_pointer_1 = 1;
			SET @v_rowCount_1 = (SELECT COUNT(*) FROM tmp_products_fields);
		
		 WHILE @v_pointer_1 <= @v_rowCount_1
		  DO
		
			SET @fieldname = (SELECT FieldName from tmp_products_fields where RowID = @v_pointer_1);
			 
			SET @statement2 =  CONCAT('ALTER TABLE tmp_products ADD COLUMN `', @fieldname ,'` TEXT NULL;');
	 	
			PREPARE stm_query FROM @statement2;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;
			
			SET @dynamicFieldID=	(SELECT DynamicFieldsID from tmp_products_fields where RowID = @v_pointer_1);
		
			SET @v_pointer_ = 1;
			SET @v_rowCount_ = (SELECT COUNT(*) FROM tmp_products);
			WHILE @v_pointer_ <= @v_rowCount_
		  	DO	
		  	
			 SET @ProductID=(select ProductID FROM tmp_products WHERE RowID=@v_pointer_);
			 
				SET @upateq=CONCAT('UPDATE tmp_products prod
		  	  	INNER JOIN Ratemanagement3.tblDynamicFieldsValue b ON b.DynamicFieldsID=',@dynamicFieldID,'
		  	  	INNER JOIN Ratemanagement3.tblDynamicFields a ON a.DynamicFieldsID=b.DynamicFieldsID
		  		SET `prod`.`',@fieldname,'`=b.FieldValue
		  		
		  		WHERE 
				  prod.ProductID=',@ProductID,'
				  AND b.ParentID=',@ProductID);
				  
				   -- select @upateq;
				  
				  PREPARE stm_query1 FROM @upateq;
				  EXECUTE stm_query1;
				  DEALLOCATE PREPARE stm_query1;
		  		
		  	SET @v_pointer_ = @v_pointer_ + 1;
		  	
		  	END WHILE;
		
			SET @v_pointer_1 = @v_pointer_1 + 1;
	
	  END WHILE;
	  

		SELECT 
		 	tblProduct.CompanyId,	
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Description,
			tblProduct.Amount,
			tblProduct.AppliedTo,
			tblProduct.Note,
			tblProduct.Buying_price,	
			tblProduct.Quantity,
			tblProduct.Low_stock_level,
			tblProduct.Enable_stock,
			tmp_products.*	 	
		FROM 
		tmp_products
		INNER JOIN tblProduct ON tblProduct.ProductID=tmp_products.ProductID;
		
		/*select count(*) as totalcount
			FROM 
		tmp_products
		INNER JOIN tblProduct ON tblProduct.ProductID=tmp_products.ProductID;*/
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_getStockHistory
DROP PROCEDURE IF EXISTS `prc_getStockHistory`;
DELIMITER //
CREATE PROCEDURE `prc_getStockHistory`(
	IN `p_CompanyID` INT,
	IN `p_Name` VARCHAR(50),
	IN `p_ItemTypeID` INT(11),
	IN `p_InvoiceNumber` VARCHAR(255),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT



)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblItemType.title,
			tblProduct.Name,
			tblStockHistory.Stock,
			tblStockHistory.Quantity,
			tblStockHistory.InvoiceNumber,
			tblStockHistory.Reason,
			tblStockHistory.created_at
            from tblStockHistory LEFT JOIN tblProduct ON tblStockHistory.ProductID = tblProduct.ProductID
            LEFT JOIN tblItemType ON tblProduct.ItemTypeID = tblItemType.ItemTypeID
            where tblStockHistory.CompanyID = p_CompanyID
			AND (p_Name ='' OR tblProduct.ProductID=p_Name)
				AND ((p_ItemTypeID ='' OR tblProduct.ItemTypeID = p_ItemTypeID))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID = p_ItemTypeID))
            AND((p_InvoiceNumber = '' OR tblStockHistory.InvoiceNumber like CONCAT(p_InvoiceNumber,'%')))
         ORDER BY
         	CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StockHistoryIDDESC') THEN tblStockHistory.StockHistoryID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StockHistoryIDASC') THEN tblStockHistory.StockHistoryID
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleDESC') THEN tblItemType.title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'titleASC') THEN tblItemType.title
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN tblProduct.Name
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN tblProduct.Name
                END ASC,
         	CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StockDESC') THEN tblStockHistory.Stock
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StockASC') THEN tblStockHistory.Stock
                END ASC,
            CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuantityDESC') THEN tblStockHistory.Quantity
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuantityASC') THEN tblStockHistory.Quantity
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblStockHistory.StockHistoryID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblStockHistory.StockHistoryID
                END ASC
				
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblStockHistory.StockHistoryID) AS totalcount
            from tblStockHistory LEFT JOIN tblProduct ON tblStockHistory.ProductID = tblProduct.ProductID
            LEFT JOIN tblItemType ON tblProduct.ItemTypeID = tblItemType.ItemTypeID
            where tblStockHistory.CompanyID = p_CompanyID
			AND (p_Name ='' OR tblProduct.ProductID=p_Name)
				AND ((p_ItemTypeID ='' OR tblProduct.ItemTypeID = p_ItemTypeID))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID = p_ItemTypeID))
            AND((p_InvoiceNumber = '' OR tblStockHistory.InvoiceNumber like CONCAT(p_InvoiceNumber,'%')));

	ELSE

			SELECT
			tblItemType.title,
			tblProduct.Name,
			tblStockHistory.Stock,
			tblStockHistory.Quantity,
			tblStockHistory.InvoiceNumber,
			tblStockHistory.Reason,
			tblStockHistory.created_at
            from tblStockHistory LEFT JOIN tblProduct ON tblStockHistory.ProductID = tblProduct.ProductID
            LEFT JOIN tblItemType ON tblProduct.ItemTypeID = tblItemType.ItemTypeID
            where tblStockHistory.CompanyID = p_CompanyID
			AND (p_Name ='' OR tblProduct.ProductID=p_Name)
				AND ((p_ItemTypeID ='' OR tblProduct.ItemTypeID = p_ItemTypeID))
            AND((p_ItemTypeID ='' OR tblItemType.ItemTypeID like CONCAT(p_ItemTypeID,'%')))
            AND((p_InvoiceNumber = '' OR tblStockHistory.InvoiceNumber = p_InvoiceNumber))
				order by tblStockHistory.StockHistoryID desc;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_importPaymentAccounting
DROP PROCEDURE IF EXISTS `prc_importPaymentAccounting`;
DELIMITER //
CREATE PROCEDURE `prc_importPaymentAccounting`(
	IN `p_ProcessID` VARCHAR(50)

)
BEGIN
		DECLARE v_AffectedRecords_ INT DEFAULT 0;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
	CREATE TEMPORARY TABLE tmp_JobLog_(
		`Message` VARCHAR(500)
	);

	-- Delete Already Done Payment

	DELETE
		tmpp
	FROM tblTempPaymentAccounting tmpp
	INNER JOIN tblPayment p
	ON p.CompanyID = tmpp.CompanyID
	AND p.TransactionID = tmpp.TransactionID
	WHERE tmpp.ProcessID= p_ProcessID ;

	-- update temp table invoiceid and other detail with invoice number matching

	Update tblTempPaymentAccounting ta LEFT JOIN tblInvoice inv ON inv.FullInvoiceNumber = ta.InvoiceNumber
		SET ta.InvoiceID = inv.InvoiceID, ta.AccountID = inv.AccountID, ta.CurrencyID = inv.CurrencyID
		WHERE ta.ProcessID= p_ProcessID AND inv.InvoiceID IS NOT NULL ;


	INSERT INTO tblPayment (
			CompanyID,
			AccountID,
			CurrencyID,
			Amount,
			PaymentDate,
			PaymentType,
			TransactionID,
			`Status`,
			PaymentMethod,
			Notes,
			created_at,
			updated_at,
			CreatedBy,
			ModifyBy,
			RecallReasoan,
			RecallBy
		)
	SELECT
		CompanyID,
		AccountID,
		CurrencyId,
		Amount,
		PaymentDate,
		IF(Amount >= 0 , 'Payment in', 'Payment out' ) AS PaymentType,
		TransactionID,
		'Approved' AS `Status`,
		'Cash' AS PaymentMethod,
		Notes,
		Now() AS created_at,
		Now() AS updated_at,
		'System Imported' AS CreatedBy,
		'System Imported' AS ModifyBy,
		'' as RecallReasoan,
		'' as RecallBy
	FROM tblTempPaymentAccounting
		WHERE ProcessID= p_ProcessID AND InvoiceID IS NOT NULL;

		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT CONCAT(' Invalid InvoiceNumber : ',IFNULL(InvoiceNumber,''))
		FROM tblTempPaymentAccounting
		WHERE ProcessID = p_ProcessID AND InvoiceID IS NULL;


		    INSERT INTO tmp_JobLog_ (Message)
	 	SELECT CONCAT(v_AffectedRecords_ , ' Records Imported \n\r ' );

		SELECT * FROM tmp_JobLog_;

		DELETE FROM tblTempPaymentAccounting WHERE ProcessID = p_ProcessID;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_importPBXPaymentAccounting
DROP PROCEDURE IF EXISTS `prc_importPBXPaymentAccounting`;
DELIMITER //
CREATE PROCEDURE `prc_importPBXPaymentAccounting`(
	IN `p_ProcessID` VARCHAR(50)
)
BEGIN
		DECLARE v_AffectedRecords_ INT DEFAULT 0;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
	CREATE TEMPORARY TABLE tmp_JobLog_(
		`Message` VARCHAR(500)
	);

	-- Delete Already Done Payment

	DELETE
		tmpp
	FROM tblTempPBXPaymentDetail tmpp
	INNER JOIN tblPayment p
	ON p.TransactionID = tmpp.TransactionID
	WHERE tmpp.ProcessID= p_ProcessID ;

	-- update temp table AccountID and other detail with tblAccount number matching

	Update tblTempPBXPaymentDetail ta LEFT JOIN Ratemanagement3.tblAccount ac ON ac.Number = ta.GatewayAccountID
		SET ta.AccountID = ac.AccountID, ta.CurrencyID = ac.CurrencyID, ta.CompanyID = ac.CompanyID
		WHERE ta.ProcessID= p_ProcessID;


	INSERT INTO tblPayment (
			CompanyID,
			AccountID,
			CurrencyID,
			Amount,
			PaymentDate,
			PaymentType,
			TransactionID,
			`Status`,
			PaymentMethod,
			Notes,
			created_at,
			updated_at,
			CreatedBy,
			ModifyBy,
			RecallReasoan,
			RecallBy
		)
	SELECT
		CompanyID,
		AccountID,
		CurrencyId,
		Amount,
		PaymentDate,
		'Payment in' AS PaymentType,
		TransactionID,
		'Approved' AS `Status`,
		'Cash' AS PaymentMethod,
		Note,
		Now() AS created_at,
		Now() AS updated_at,
		'System Imported' AS CreatedBy,
		'System Imported' AS ModifyBy,
		'' as RecallReasoan,
		'' as RecallBy
	FROM tblTempPBXPaymentDetail
		WHERE ProcessID= p_ProcessID AND AccountID IS NOT NULL AND CurrencyID IS NOT NULL and Note NOT LIKE '%calls made%';

		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	INSERT INTO tmp_JobLog_ (Message)
		SELECT DISTINCT CONCAT(' Invalid Tenants Code : ',IFNULL(GatewayAccountID,''))
		FROM tblTempPBXPaymentDetail
		WHERE ProcessID = p_ProcessID AND AccountID IS NULL AND CurrencyID IS NULL;


		    INSERT INTO tmp_JobLog_ (Message)
	 	SELECT CONCAT(v_AffectedRecords_ , ' Records Imported \n\r ' );

		SELECT * FROM tmp_JobLog_;

		DELETE FROM tblTempPBXPaymentDetail WHERE ProcessID = p_ProcessID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_insertPayments
DROP PROCEDURE IF EXISTS `prc_insertPayments`;
DELIMITER //
CREATE PROCEDURE `prc_insertPayments`(
	IN `p_CompanyID` INT,
	IN `p_ProcessID` VARCHAR(100),
	IN `p_UserID` INT



)
BEGIN

	
	DECLARE v_UserName varchar(30);
 	
 	SELECT CONCAT(u.FirstName,CONCAT(' ',u.LastName)) as name into v_UserName from Ratemanagement3.tblUser u where u.UserID=p_UserID;
 	
 	INSERT INTO tblPayment (
	 		CompanyID,
	 		 AccountID,
			 InvoiceNo,
			 PaymentDate,
			 PaymentMethod,
			 PaymentType,
			 Notes,
			 Amount,
			 CurrencyID,
			 Recall,
			 `Status`,
			 created_at,
			 updated_at,
			 CreatedBy,
			 ModifyBy,
			 RecallReasoan,
			 RecallBy,
			 BulkUpload,
			 InvoiceID
			 )
 	select tp.CompanyID,
	 		 tp.AccountID,
			 COALESCE(tp.InvoiceNo,''),
			 tp.PaymentDate,
			 tp.PaymentMethod,
			 tp.PaymentType,
			 tp.Notes,
			 tp.Amount,
			 ac.CurrencyId,
			 0 as Recall,
			 tp.Status,
			 Now() as created_at,
			 Now() as updated_at,
			 v_UserName as CreatedBy,
			 '' as ModifyBy,
			 '' as RecallReasoan,
			 '' as RecallBy,
			 1 as BulkUpload,
			 InvoiceID
	from tblTempPayment tp
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON  ac.AccountID = tp.AccountID  and ac.AccountType = 1 and ac.CurrencyId IS NOT NULL
	where tp.ProcessID = p_ProcessID
			AND tp.PaymentDate <= NOW()
			AND tp.CompanyID = p_CompanyID;
			
	DROP TEMPORARY TABLE IF EXISTS tmp_UpdateInvoiceStatus_;
	CREATE TEMPORARY TABLE tmp_UpdateInvoiceStatus_  (
		InvoiceID INT,
		AccountID INT,
		Status Varchar(255),
		Note TEXT
	);
	
	INSERT INTO tmp_UpdateInvoiceStatus_ (
	 		InvoiceID,
	 		 AccountID,
			 Status,
			 Note			 
			 )
 	select 			 
			 tp.InvoiceID,
			 tp.AccountID,			 
		CASE WHEN (tp.Amount>= (inv.GrandTotal -  (SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ))
 		then 
 		'paid' 
				ELSE 'partially_paid' 
			END
			as status,
			'' as Note
	from tblTempPayment tp
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON  ac.AccountID = tp.AccountID  and ac.AccountType = 1 and ac.CurrencyId IS NOT NULL
		INNER JOIN tblInvoice inv ON tp.InvoiceID=inv.InvoiceID
	where tp.ProcessID = p_ProcessID
			AND tp.PaymentDate <= NOW()
			AND tp.CompanyID = p_CompanyID;
			
	 Update tblInvoice i INNER JOIN tmp_UpdateInvoiceStatus_ tmp ON i.InvoiceID=tmp.InvoiceID 
	 SET i.InvoiceStatus = tmp.Status;
	 
	INSERT INTO tblInvoiceLog (
	 		InvoiceID,			 
			 Note,
			 created_at,
			 updated_at			 
			 )
 	select 			 
			 tp.InvoiceID,			 	
			'Paid By System' as Note,
			 Now() as created_at,
			 Now() as updated_at	
	from tblTempPayment tp
	INNER JOIN Ratemanagement3.tblAccount ac 
		ON  ac.AccountID = tp.AccountID  and ac.AccountType = 1 and ac.CurrencyId IS NOT NULL
		INNER JOIN tblInvoice inv ON tp.InvoiceID=inv.InvoiceID
	where tp.ProcessID = p_ProcessID
			AND tp.PaymentDate <= NOW()
			AND tp.CompanyID = p_CompanyID;
			
	 delete from tblTempPayment where CompanyID = p_CompanyID and ProcessID = p_ProcessID;
	 
			
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_InsertTempReRateVendorCDR
DROP PROCEDURE IF EXISTS `prc_InsertTempReRateVendorCDR`;
DELIMITER //
CREATE PROCEDURE `prc_InsertTempReRateVendorCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_ProcessID` VARCHAR(50),
	IN `p_tbltempvendorcdrl_name` VARCHAR(50),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluebuyingcost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50)
)
BEGIN
	DECLARE v_BillingTime_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	SET @stm1 = CONCAT('

	INSERT INTO RMCDR3.`' , p_tbltempvendorcdrl_name , '` (
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
		cli,
		cld,
		selling_cost,
		buying_cost,
		remote_ip,
		duration,
		ProcessID,
		ID,
		billed_second,
		AccountName,
		AccountNumber,
		AccountCLI,
		AccountIP
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
		cli,
		cld,
		selling_cost,
		buying_cost,
		remote_ip,
		duration,
		"',p_ProcessID,'",
		ud.ID,
		billed_second,
		IFNULL(ga.AccountName,""),
		IFNULL(ga.AccountNumber,""),
		IFNULL(ga.AccountCLI,""),
		IFNULL(ga.AccountIP,"")
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
	INNER JOIN Ratemanagement3.tblAccount a
		ON uh.AccountID = a.AccountID
	LEFT JOIN tblGatewayAccount ga
		ON ga.GatewayAccountPKID = uh.GatewayAccountPKID
WHERE
	StartDate >= DATE_ADD( "' , p_StartDate , '",INTERVAL -1 DAY)
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
	AND ( "' , p_zerovaluebuyingcost , '" = 0 OR (  "' , p_zerovaluebuyingcost , '" = 1 AND buying_cost = 0) OR (  "' , p_zerovaluebuyingcost , '" = 2 AND buying_cost > 0))

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

-- Dumping structure for procedure RMBilling3.prc_ProcesssCDR
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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_processId);
		 
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

		--	IF p_RateCDR = 0 AND p_RateFormat = 2 -- Removed by Sumera
		 
-- if re ratig is OFF OR re rating is ON but only rating few accounts not all 
	IF ((p_RateCDR = 0 AND p_RateFormat = 2) OR (p_RerateAccounts!= 0 & p_RateCDR = 1 AND p_RateFormat = 2))
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
	
	-- update cost with rounding
	call prc_UpdateCDRRounding(p_tbltempusagedetail_name,p_processId);
	
	
	CALL prc_CreateRerateLog(p_processId,p_tbltempusagedetail_name,p_RateCDR);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_processId);
	
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
	
	IF ( ( SELECT COUNT(*) FROM tmp_Service_ ) > 0 OR p_OutboundTableID > 0)
	THEN
		CALL prc_RerateOutboundService(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate,p_OutboundTableID);
	ELSE
		CALL prc_RerateOutboundTrunk(p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateFormat,p_RateMethod,p_SpecifyRate);
		CALL prc_autoUpdateTrunk(p_CompanyID,p_CompanyGatewayID);
	END IF;	 

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

	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate,p_InboundTableID);		-- for mirta only	
	IF (  p_RateCDR = 1 )
	THEN
		
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


-- Dumping structure for procedure RMBilling3.prc_ProcesssVCDR
DROP PROCEDURE IF EXISTS `prc_ProcesssVCDR`;
DELIMITER //
CREATE PROCEDURE `prc_ProcesssVCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_RerateAccounts` INT
)
BEGIN
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_CDRUpload_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_NewAccountIDCount_ INT;
	DECLARE v_VendorIDs_ TEXT DEFAULT '';
	DECLARE v_VendorIDs_Count_ INT DEFAULT 0;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	CALL prc_ProcessCDRService(p_CompanyID,p_processId,p_tbltempusagedetail_name);


	DROP TEMPORARY TABLE IF EXISTS tmp_Vendors_;
	CREATE TEMPORARY TABLE tmp_Vendors_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		CompanyGatewayID INT
	);

	IF p_RerateAccounts!=0
	THEN
      SET @sql1 = concat("insert into tmp_Vendors_ (AccountID) values ('", replace(( select TRIM(REPLACE(group_concat(distinct IFNULL(REPLACE(REPLACE(json_extract(Settings, '$.Accounts'), '[', ''), ']', ''),0)),'"','')) as AccountID from Ratemanagement3.tblCompanyGateway WHERE CompanyGatewayID=p_CompanyGatewayID), ",", "'),('"),"');");
      PREPARE stmt1 FROM @sql1;
      EXECUTE stmt1;
      DEALLOCATE PREPARE stmt1;
      DELETE FROM tmp_Vendors_ WHERE AccountID=0;
      UPDATE tmp_Vendors_ SET CompanyGatewayID=p_CompanyGatewayID WHERE 1;
  END IF;

	SELECT GROUP_CONCAT(AccountID) INTO v_VendorIDs_ FROM tmp_Vendors_ GROUP BY CompanyGatewayID;
	SELECT COUNT(*) INTO v_VendorIDs_Count_ FROM tmp_Vendors_;

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

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL
	);

	/* insert new account */
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName,AccountNumber,AccountCLI,AccountIP,ServiceID,IsVendor)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.AccountName,
		ud.AccountNumber,
		ud.AccountCLI,
		ud.AccountIP,
		ud.ServiceID,
		1 as IsVendor
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	LEFT JOIN tblGatewayAccount ga
		ON ga.AccountName = ud.AccountName
		AND ga.AccountNumber = ud.AccountNumber
		AND ga.AccountCLI = ud.AccountCLI
		AND ga.AccountIP = ud.AccountIP
		AND ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.ServiceID = ud.ServiceID
		AND ga.CompanyID = ud.CompanyID
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
	FROM RMCDR3.tblVendorCDRHeader uh
	INNER JOIN tblGatewayAccount ga
		ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = p_CompanyID
	AND uh.CompanyGatewayID = p_CompanyGatewayID;

	IF v_NewAccountIDCount_ > 0
	THEN
		/* update header cdr account */
		UPDATE RMCDR3.tblVendorCDRHeader uh
		INNER JOIN tblGatewayAccount ga
			ON  uh.GatewayAccountPKID = ga.GatewayAccountPKID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;

	END IF;

	/* temp accounts and trunks*/
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunkCdrUpload_;
	CREATE TEMPORARY TABLE tmp_AccountTrunkCdrUpload_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunkCdrUpload_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET v_CDRUpload_ = (SELECT COUNT(*) FROM tmp_AccountTrunkCdrUpload_);

	IF v_CDRUpload_ > 0
	THEN
		/* update UseInBilling when cdr upload*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblVendorTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.TrunkID = ud.TrunkID AND ct.Status =1
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '";
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;



	/* if rate format is prefix base not charge code*/
	IF p_RateFormat = 2
	THEN

		/* update trunk with use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblVendorTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.Status =1
			AND ct.UseInBilling = 1 AND (cld LIKE CONCAT(ct.Prefix , "%") OR (ct.Prefix IS NOT NULL AND ct.Prefix <> "" AND vendor_trunk_type = ct.Prefix))
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix,area_prefix = TRIM(LEADING ct.Prefix FROM area_prefix )
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.TrunkID IS NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

		/* update trunk without use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblVendorTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.Status =1
			AND ct.UseInBilling = 0
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	/* if rerate on */
	IF p_RateCDR = 1 AND v_VendorIDs_Count_ = 0
	THEN

		SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET buying_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	ELSEIF p_RateCDR = 1 AND v_VendorIDs_Count_ > 0
	THEN

		SET @stm = CONCAT('UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET buying_cost = 0,is_rerated=0, area_prefix="Other"  WHERE ProcessID = "',p_processId,'" AND ( FIND_IN_SET(AccountID,"',v_VendorIDs_,'")>0) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @stm = CONCAT('UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET is_rerated=1  WHERE ProcessID = "',p_processId,'" AND ( FIND_IN_SET(AccountID,"',v_VendorIDs_,'")=0) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	/* temp accounts and trunks*/
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_AccountTrunk_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_TrunkID_ = (SELECT TrunkID FROM tmp_AccountTrunk_ t WHERE t.RowID = v_pointer_);
		SET v_AccountID_ = (SELECT AccountID FROM tmp_AccountTrunk_ t WHERE t.RowID = v_pointer_);

		/* get outbound rate process*/
		CALL Ratemanagement3.prc_getVendorCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR,p_RateMethod,p_SpecifyRate);

		/* update prefix outbound process*/
		/* if rate format is prefix base not charge code*/
		IF p_RateFormat = 2
		THEN
			CALL prc_updateVendorPrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;


		/* outbound rerate process*/
		IF p_RateCDR = 1 AND (v_VendorIDs_Count_=0 OR (v_VendorIDs_Count_>0 AND FIND_IN_SET(v_AccountID_,v_VendorIDs_)>0))
		THEN
			CALL prc_updateVendorRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name,p_RateMethod,p_SpecifyRate);
		END IF;

		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

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



		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);


		CALL prc_updateDefaultVendorPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;


	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( " Account Name : ( " , ga.AccountName ," ) Number ( " , ga.AccountNumber ," ) IP  ( " , ga.AccountIP ," ) CLI  ( " , ga.AccountCLI," ) - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga
		ON ga.AccountName = ud.AccountName
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
		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",ud.cld," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" AND ud.is_rerated = 0 AND ud.billed_second <> 0');

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

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_StockManageRecurringInvoice
DROP PROCEDURE IF EXISTS `prc_StockManageRecurringInvoice`;
DELIMITER //
CREATE PROCEDURE `prc_StockManageRecurringInvoice`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceIDs` VARCHAR(200)

,
	IN `p_InvoiceID` INT,
	IN `p_createdby` VARCHAR(100)








)
BEGIN
	DECLARE v_Message VARCHAR(200);
	DECLARE TotItem INT(10);
	DECLARE Reason VARCHAR(200);
	DECLARE FullInvoiceNumber1 VARCHAR(200);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_StockMaintain;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_StockMaintain(
		CompanyID int,
		ProductID int(11),
		Stock int(11),
		Qty int(11),
		Low_stock_level int(11),
		Name varchar(255),
		Code varchar(50),
		RecurringInvoiceID int(11),
		Note varchar(255)
	);
	
	INSERT INTO tmp_StockMaintain
	SELECT
		tblProduct.CompanyId,
		tblProduct.ProductID,
		(SELECT Stock FROM tblStockHistory WHERE ProductID=tblProduct.ProductID ORDER BY StockHistoryID DESC LIMIT 1) AS Stock,
		tblRecurringInvoiceDetail.Qty,
		tblProduct.Low_stock_level,
		tblProduct.Name,
		tblProduct.Code,
		tblRecurringInvoiceDetail.RecurringInvoiceID,
		CONCAT('')
	FROM tblRecurringInvoiceDetail 
		INNER JOIN tblProduct ON tblRecurringInvoiceDetail.ProductID=tblProduct.ProductID 
	WHERE  tblRecurringInvoiceDetail.RecurringInvoiceID=p_InvoiceIDs
		AND tblRecurringInvoiceDetail.ProductType=1 
		AND tblProduct.CompanyId=p_CompanyID 
		AND tblProduct.Active=1 
		AND tblProduct.Enable_stock=1
	;
	 	
	
	UPDATE tmp_StockMaintain
	SET Note='This Product is below the lowstock level'
	WHERE Stock <= Low_stock_level;
	
	
		 SET FullInvoiceNumber1 ='';
		SELECT FullInvoiceNumber INTO FullInvoiceNumber1 FROM (SELECT FullInvoiceNumber  FROM tblInvoice WHERE CompanyID = p_CompanyID AND InvoiceID = p_InvoiceID) AS tb2;
	   	
		INSERT INTO tblStockHistory (CompanyID,ProductID,InvoiceID,InvoiceNumber,Stock,Quantity,Reason,created_at,created_by,updated_at) 
		SELECT 
			CompanyID,
			ProductID,
			p_InvoiceID AS InvoiceID,
			FullInvoiceNumber1 AS InvoiceNumber,
			(Stock - SUM(Qty)) AS Stock,
			SUM(Qty) AS Quantity,
			CONCAT('Invoice Generated Qty -', CAST(SUM(Qty) as CHAR(50)),' ',Note) AS Reason,
			NOW() AS created_at,
			p_createdby as created_by,
			NOW() AS updated_at		
		FROM tmp_StockMaintain 
			GROUP BY CompanyID,ProductID,Stock,Name,Note ;
		
		DROP TEMPORARY TABLE IF EXISTS tmp_ProductStockUpdate;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ProductStockUpdate(
			CompanyID int,
			ProductID int(11),
			Stock int(11)
		);
		
		INSERT INTO tmp_ProductStockUpdate(CompanyID,ProductID,Stock)
		SELECT
			CompanyID,
			ProductID,
			(Stock - SUM(Qty)) AS Stock
		FROM tmp_StockMaintain 
			GROUP BY ProductID,CompanyID,Stock ;
			
			UPDATE 
				tblProduct
			INNER JOIN tmp_ProductStockUpdate ON tblProduct.ProductID=tmp_ProductStockUpdate.ProductID
				SET 
				tblProduct.Quantity=tmp_ProductStockUpdate.Stock
			WHERE 
				tblProduct.CompanyId=tmp_ProductStockUpdate.CompanyID
			AND tblProduct.ProductID=tmp_ProductStockUpdate.ProductID;
				

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_UpdateCDRRounding
DROP PROCEDURE IF EXISTS `prc_UpdateCDRRounding`;
DELIMITER //
CREATE PROCEDURE `prc_UpdateCDRRounding`(
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_processId` INT

)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SET @stm = CONCAT('
		UPDATE 
			RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		LEFT JOIN  
			Ratemanagement3.`tblCustomerTrunk` ct ON ct.AccountID = ud.AccountID AND ct.TrunkID = ud.TrunkID AND ct.Status =1
		INNER JOIN
			Ratemanagement3.`tblRateTable` rt ON rt.RateTableID = ct.RateTableID
		SET 
			cost = ROUND(cost, rt.RoundChargedAmount)
		WHERE 
			ct.AccountID IS NOT NULL AND
			rt.RoundChargedAmount IS NOT NULL AND
			ud.ProcessID="' , p_processId , '";
	');
	
	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_UpdateItemTypeStatus
DROP PROCEDURE IF EXISTS `prc_UpdateItemTypeStatus`;
DELIMITER //
CREATE PROCEDURE `prc_UpdateItemTypeStatus`(
	IN `i_CompanyID` INT,
	IN `i_user_name` VARCHAR(50),
	IN `i_Title` VARCHAR(50),
	IN `i_Active` INT,
	IN `i_status_set` INT

)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	UPDATE tblItemType i
	SET i.Active=i_status_set 
	WHERE i.CompanyID = i_CompanyID
		AND(i_Title = '' OR i.title like Concat('%',i_Title,'%'))
      AND(i_Active = 9 OR i.Active = i_Active)
      ;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_updateSOAOffSet
DROP PROCEDURE IF EXISTS `prc_updateSOAOffSet`;
DELIMITER //
CREATE PROCEDURE `prc_updateSOAOffSet`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT

)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountSOA;
	CREATE TEMPORARY TABLE tmp_AccountSOA (
		AccountID INT,
		Amount NUMERIC(18, 8),
		PaymentType VARCHAR(50),
		InvoiceType INT,
		TopUpType VARCHAR(50),
		CreditNoteType VARCHAR (50)
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountSOABal;
	CREATE TEMPORARY TABLE tmp_AccountSOABal (
		AccountID INT,
		Amount NUMERIC(18, 8)
	);

   --   tblInvoice.InvoiceType = 2 Invoice IN
   --   tblInvoice.InvoiceType = 1 Invoice OUT  -- not ( 'cancel' , 'draft' , 'awaiting')
	INSERT into tmp_AccountSOA(AccountID,Amount,InvoiceType)
	SELECT
		tblInvoice.AccountID,
		tblInvoice.GrandTotal,
		tblInvoice.InvoiceType
	FROM tblInvoice
	WHERE tblInvoice.CompanyID = p_CompanyID
	AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
	AND (p_AccountID = 0 OR  tblInvoice.AccountID = p_AccountID);

     
	INSERT into tmp_AccountSOA(AccountID,Amount,PaymentType)
	SELECT
		tblPayment.AccountID,
		tblPayment.Amount,
		tblPayment.PaymentType
	FROM tblPayment
	WHERE tblPayment.CompanyID = p_CompanyID
	AND tblPayment.Status = 'Approved'
	AND tblPayment.Recall = 0
	AND (p_AccountID = 0 OR  tblPayment.AccountID = p_AccountID);
	
	INSERT into tmp_AccountSOA(AccountID,Amount,TopUpType)
	SELECT
		i.AccountID,
		id.LineTotal as Amount,
		'topup' as TopUpType
	FROM tblInvoiceDetail id 
			INNER JOIN tblInvoice i ON id.InvoiceID=i.InvoiceID					
			INNER JOIN tblProduct p ON id.ProductID=p.ProductID AND p.Code='topup'
	WHERE i.CompanyID = p_CompanyID 
	AND ( (i.InvoiceType = 2) OR ( i.InvoiceType = 1 AND i.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
	AND (p_AccountID = 0 OR  i.AccountID = p_AccountID);
	
	INSERT into tmp_AccountSOA(AccountID,Amount,CreditNoteType)
	SELECT
		AccountID,
		(GrandTotal - PaidAmount) as Amount,
		'creditnote' as TopUpType
	FROM tblCreditNotes
	WHERE CompanyID = p_CompanyID 
	AND CreditNotesStatus IN ('open')
	AND (p_AccountID = 0 OR  AccountID = p_AccountID);
	
	/** SOAOffSet = soa( invoiceOut-PaymentIn - InvoiceIn - PaymentOut)    - topup - creditnotes	 */
	INSERT INTO tmp_AccountSOABal
	SELECT AccountID,(SUM(IF(InvoiceType=1,Amount,0)) -  SUM(IF(PaymentType='Payment In',Amount,0))) - (SUM(IF(InvoiceType=2,Amount,0)) - SUM(IF(PaymentType='Payment Out',Amount,0))) - (SUM(IF(TopUpType='topup',Amount,0))) - (SUM(IF(CreditNoteType='creditnote',Amount,0))) as SOAOffSet
	FROM tmp_AccountSOA 
	GROUP BY AccountID;
	
	
	-- SOABalance= 0 where AccountID not found 
	INSERT INTO tmp_AccountSOABal
	SELECT DISTINCT tblAccount.AccountID ,0 FROM Ratemanagement3.tblAccount
	LEFT JOIN tmp_AccountSOA ON tblAccount.AccountID = tmp_AccountSOA.AccountID
	WHERE tblAccount.CompanyID = p_CompanyID
	AND tmp_AccountSOA.AccountID IS NULL
	AND (p_AccountID = 0 OR  tblAccount.AccountID = p_AccountID);
	
	-- update SOAOffset (used in Credit Control / AccountBalance )
	UPDATE Ratemanagement3.tblAccountBalance
	INNER JOIN tmp_AccountSOABal 
		ON  tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	SET SOAOffset=tmp_AccountSOABal.Amount;
	
	UPDATE Ratemanagement3.tblAccountBalance SET tblAccountBalance.BalanceAmount = COALESCE(tblAccountBalance.SOAOffset,0) + COALESCE(tblAccountBalance.UnbilledAmount,0)  - COALESCE(tblAccountBalance.VendorUnbilledAmount,0);
	
	-- New Account entry for tblAccountBalance
	INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,BalanceAmount,UnbilledAmount,SOAOffset)
	SELECT tmp_AccountSOABal.AccountID,tmp_AccountSOABal.Amount,0,tmp_AccountSOABal.Amount
	FROM tmp_AccountSOABal 
	LEFT JOIN Ratemanagement3.tblAccountBalance
		ON tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	WHERE tblAccountBalance.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_updateVendorRate
DROP PROCEDURE IF EXISTS `prc_updateVendorRate`;
DELIMITER //
CREATE PROCEDURE `prc_updateVendorRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN

	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET buying_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND TrunkID = "',p_TrunkID ,'"') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN Ratemanagement3.tmp_vcodes_ cr ON cr.Code = ud.area_prefix
	SET buying_cost =
		CASE WHEN  billed_second >= Interval1
		THEN
			(Rate/60.0)*Interval1+CEILING((billed_second-Interval1)/IntervalN)*(Rate/60.0)*IntervalN+IFNULL(ConnectionFee,0)
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Rate+IFNULL(ConnectionFee,0)
			ELSE
				0
			END
		END
	,is_rerated=1
	,duration=billed_second
	,billed_duration =
		CASE WHEN  billed_second >= Interval1
		THEN
			Interval1+CEILING((billed_second-Interval1)/IntervalN)*IntervalN
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Interval1
			ELSE
				0
			END
		END
	WHERE ProcessID = "',p_processId,'"
	AND AccountID = "',p_AccountID ,'"
	AND TrunkID = "',p_TrunkID ,'"') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF p_RateMethod = 'SpecifyRate'
	THEN

		SET @stm = CONCAT('
		UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		LEFT JOIN Ratemanagement3.tmp_vcodes_ cr ON cr.Code = ud.area_prefix
		SET buying_cost =
		CASE WHEN  billed_second >= Interval1
		THEN
			(Rate/60.0)*Interval1+CEILING((billed_second-Interval1)/IntervalN)*(Rate/60.0)*IntervalN+IFNULL(ConnectionFee,0)
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Rate+IFNULL(ConnectionFee,0)
			ELSE
				0
			END
		END
		,is_rerated=1
		,duration = billed_second
		,billed_duration =
			CASE WHEN  billed_second >= 1
			THEN
				1+CEILING((billed_second-1)/1)*1
			ElSE
				CASE WHEN  billed_second > 0
				THEN
					1
				ELSE
					0
				END
			END
		WHERE ProcessID = "',p_processId,'"
		AND AccountID = "',p_AccountID ,'"
		AND cr.Code IS NULL
		AND ("',p_TrunkID ,'" = 0 OR TrunkID = "',p_TrunkID ,'")
		') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

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
test:BEGIN

	DECLARE v_InvoiceCount_ INT; 
	DECLARE v_BillingTime_ INT; 
	DECLARE v_CDRType_ INT; 
	DECLARE v_AvgRound_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	CALL fnServiceUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_ServiceID,p_StartDate,p_EndDate,v_BillingTime_);

	SELECT 
		it.CDRType,b.RoundChargesAmount  INTO v_CDRType_, v_AvgRound_
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
	ROUND((uh.cost/uh.billed_duration)*60.0,v_AvgRound_) as AvgRate 
FROM tmp_tblUsageDetails_ uh;

SELECT
			area_prefix AS AreaPrefix,
			Trunk,
			(SELECT 
			Country
			FROM Ratemanagement3.tblRate r
			INNER JOIN Ratemanagement3.tblCountry c
			ON c.CountryID = r.CountryID
			WHERE  r.CompanyID = p_CompanyID AND r.Code = ud.area_prefix limit 1)
			AS Country,
			(SELECT Description
			FROM Ratemanagement3.tblRate r
			WHERE  r.CompanyID = p_CompanyID AND r.Code = ud.area_prefix limit 1 )
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
			(SELECT 
			Country
			FROM Ratemanagement3.tblRate r
			INNER JOIN Ratemanagement3.tblCountry c
			ON c.CountryID = r.CountryID
			WHERE r.CompanyID = p_CompanyID AND r.Code = ud.area_prefix limit 1)
			AS Country,
			(SELECT 
			Description
			FROM Ratemanagement3.tblRate r
			INNER JOIN Ratemanagement3.tblCountry c
			ON c.CountryID = r.CountryID
			WHERE r.CompanyID = p_CompanyID AND  r.Code = ud.area_prefix limit 1)
			AS Description,
			CASE 
				WHEN is_inbound=1 then 'Incoming' 
				ELSE 'Outgoing' 
			END
			as CallType,
			connect_time AS ConnectTime,
			disconnect_time AS DisconnectTime,
			billed_duration AS BillDuration,
			SEC_TO_TIME(billed_duration) AS BillDurationMinutes,
			cost AS ChargedAmount,
			ServiceID
		FROM tmp_tblUsageDetails_ ud
		WHERE ((p_ShowZeroCall =0 AND ud.cost >0 ) OR (p_ShowZeroCall =1 AND ud.cost >= 0))
		ORDER BY connect_time ASC;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

USE `RMCDR3`;

DROP PROCEDURE IF EXISTS `prc_deleteCustomerCDRByRetention`;
DELIMITER //
CREATE PROCEDURE `prc_deleteCustomerCDRByRetention`(
	IN `p_CompanyID` INT,
	IN `p_DeleteDate` DATETIME,
	IN `p_ActionName` VARCHAR(200)	
)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_ActionName = 'CDR'
	THEN

		DELETE tblUsageDetails
		 FROM tblUsageDetails
			 INNER JOIN tblUsageHeader
			 	 ON tblUsageDetails.UsageHeaderID = tblUsageHeader.UsageHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
		 
		 DELETE tblUsageDetailFailedCall
		  FROM tblUsageDetailFailedCall
		 	 INNER JOIN tblUsageHeader
			  	 ON tblUsageDetailFailedCall.UsageHeaderID = tblUsageHeader.UsageHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
		  
		  DELETE FROM tblUsageHeader
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;

	END IF;
		
	IF (p_ActionName = 'CDRFailedCalls')
	THEN

		DELETE tblUsageDetailFailedCall
		  FROM tblUsageDetailFailedCall
		 	 INNER JOIN tblUsageHeader
			  	 ON tblUsageDetailFailedCall.UsageHeaderID = tblUsageHeader.UsageHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
	
	END IF;	
		
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_deleteVendorCDRByRetention`;
DELIMITER //
CREATE PROCEDURE `prc_deleteVendorCDRByRetention`(
	IN `p_CompanyID` INT,
	IN `p_DeleteDate` DATETIME,
	IN `p_ActionName` VARCHAR(200)
)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_ActionName = 'CDR'
	THEN
	
		DELETE tblVendorCDR
		 FROM tblVendorCDR
			 INNER JOIN tblVendorCDRHeader
			 	 ON tblVendorCDR.VendorCDRHeaderID = tblVendorCDRHeader.VendorCDRHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
		 
		 
		 
		 DELETE tblVendorCDRFailed
		  FROM tblVendorCDRFailed
		 	 INNER JOIN tblVendorCDRHeader
			  	 ON tblVendorCDRFailed.VendorCDRHeaderID = tblVendorCDRHeader.VendorCDRHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
		
		
		
		DELETE FROM tblVendorCDRHeader
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;

	END IF;
	
	IF (p_ActionName = 'CDRFailedCalls')
	THEN

		DELETE tblVendorCDRFailed
		  FROM tblVendorCDRFailed
		 	 INNER JOIN tblVendorCDRHeader
			  	 ON tblVendorCDRFailed.VendorCDRHeaderID = tblVendorCDRHeader.VendorCDRHeaderID
		 WHERE StartDate = p_DeleteDate
		  AND CompanyID = p_CompanyID;
	
	END IF;	
		
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

	CALL Ratemanagement3.prc_UpdateMysqlPID(p_processId);
	
	-- Find Gateway Name for Mirta only
	SET @gateway_name  = '';
	SET @stm1 = CONCAT('select g.Name into @gateway_name   FROM  `' , p_tbltempusagedetail_name , '` d
			INNER JOIN Ratemanagement3.tblCompanyGateway cg on d.CompanyGatewayID = cg.CompanyGatewayID
			INNER JOIN Ratemanagement3.tblGateway g on g.GatewayID = cg.GatewayID
			WHERE processid = "' , p_processId , '" AND g.Name = "PBX" limit 1 ');
	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;
 


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
		AND (h.AccountID = d.AccountID OR (d.AccountID is null AND h.AccountID is null))
	WHERE   processid = "' , p_processId , '"
		AND billed_duration = 0 AND cost = 0 AND ( disposition <> "ANSWERED" OR disposition IS NULL );

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


	-- FOR MIRTA ONLY 

	 IF (@gateway_name = 'PBX') THEN
   	
			SET @stm31 = CONCAT('
			INSERT INTO tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
			SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
			FROM  `' , p_tbltempusagedetail_name , '` d
			INNER JOIN tblUsageHeader h
			ON h.GatewayAccountPKID = d.GatewayAccountPKID
				AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
				AND (h.AccountID = d.AccountID OR (d.AccountID is null AND h.AccountID is null))
			WHERE   processid = "' , p_processId , '"
				AND disposition IS NOT NULL AND disposition <> "ANSWERED"; 
		
			');
		
			PREPARE stmt31 FROM @stm31;
			EXECUTE stmt31;
			DEALLOCATE PREPARE stmt31;
		
			SET @stm41 = CONCAT('
			DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  AND disposition IS NOT NULL AND disposition <> "ANSWERED";
			'); 
		
			PREPARE stmt41 FROM @stm41;
			EXECUTE stmt41;
			DEALLOCATE PREPARE stmt41; 
	END IF;
	-- for mirta only over
	 
	


	SET @stm5 = CONCAT('
	INSERT INTO tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition,userfield
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		AND (h.AccountID = d.AccountID OR (d.AccountID is null AND h.AccountID is null))
	WHERE   processid = "' , p_processId , '" ;
	');

	PREPARE stmt5 FROM @stm5;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;
	
	
	-- for Mirta retail only
   IF (@gateway_name = 'PBX') THEN
   
		SET @stm51 = CONCAT('
		INSERT INTO  tblRetailUsageDetail (UsageDetailID,ID,cc_type,ProcessID)
		SELECT Distinct d.UsageDetailID,rd.ID,rd.cc_type,rd.ProcessID
		FROM   `' , p_tbltempusagedetail_name , '_Retail` rd
		INNER JOIN tblUsageDetails d
		ON d.ProcessID = rd.ProcessID  AND d.ID = rd.ID 
		WHERE   d.ProcessID = "' , p_processId , '" ;
		');
		PREPARE stmt51 FROM @stm51;
		EXECUTE stmt51;
		DEALLOCATE PREPARE stmt51;

   END IF;

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
	
	INSERT INTO tmp_usageheader
	SELECT DISTINCT uh.*
	From tblUsageHeader uh
	WHERE uh.CompanyGatewayID = p_CompanyGatewayID
	AND ((p_Today = 1 AND uh.StartDate BETWEEN DATE_FORMAT(SUBDATE(Now(),INTERVAL 2 hour) ,"%Y-%m-%d") AND DATE_FORMAT(Now() ,"%Y-%m-%d") ) OR (p_Today =0 AND uh.StartDate BETWEEN p_StartDate AND p_EndDate ));
	
	INSERT INTO tmp_resellers(ResellerID,CompanyID,ChildCompanyID,AccountID,TotalAccount)
	SELECT DISTINCT
		ResellerID,
		CompanyID,
		ChildCompanyID,
		AccountID,
		(SELECT count(*) FROM Ratemanagement3.tblAccount a WHERE a.CompanyId=ChildCompanyID) as TotalAccount		
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
			     AND tr.RowID = v_pointer_;
			-- WHERE a.`Status` =1;

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;
		
		
		DELETE urd 
		FROM tblRetailUsageDetail urd
			INNER JOIN tblUsageDetails  ud
			   ON ud.UsageDetailID = urd.UsageDetailID
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
		
		
		
		
		SET @stm2 = CONCAT('
			    INSERT INTO `' , p_tbltempusagedetail_name , '` (CompanyID,AccountID,ProcessID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountNumber,connect_time,disconnect_time,billed_duration,billed_second,trunk,area_prefix,cli,cld,cost,ServiceID,duration,is_inbound,is_rerated,disposition,userfield,cc_type,ID,extension,pincode)
				SELECT "' , p_CompanyID , '" as CompanyID,ta.ResellerAccountID as `AccountID`,"' ,p_ProcessID ,'" as ProcessID,uh.CompanyGatewayID,uh.GatewayAccountPKID,uh.GatewayAccountID,uh.GatewayAccountID as AccountNumber,ud.connect_time,ud.disconnect_time,ud.billed_duration,ud.billed_second,"Other" as `trunk`,"Other" as `area_prefix`,ud.cli,ud.cld,ud.cost,uh.ServiceID,ud.duration,ud.is_inbound,0 as `is_rerated`,ud.disposition,ud.userfield,cc_type,ud.ID,ud.extension,ud.pincode
				FROM tblUsageDetails  ud
					INNER JOIN tmp_usageheader uh
						ON uh.UsageHeaderID = ud.UsageHeaderID
					INNER JOIN tmp_allaccounts_ ta
						ON uh.AccountID = ta.CustomerAccountID	
					LEFT JOIN tblRetailUsageDetail rd
						ON rd.UsageDetailID = ud.UsageDetailID	
				WHERE uh.CompanyGatewayID = "',p_CompanyGatewayID,'";
		');

		PREPARE stmt2 FROM @stm2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;

		SET @stm4 = CONCAT('
			    INSERT INTO `' , p_tbltempusagedetail_name ,'_Retail' , '` (TempUsageDetailID,ID,cc_type,ProcessID)
				SELECT TempUsageDetailID,ID,IFNULL(cc_type,0),ProcessID
				FROM `' , p_tbltempusagedetail_name , '`  
				WHERE ProcessID = "',p_ProcessID,'";
		');

		PREPARE stmt4 FROM @stm4;
		EXECUTE stmt4;
		DEALLOCATE PREPARE stmt4;
		/*
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
		DEALLOCATE PREPARE stmt3; */
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_insertVendorCDR`;
DELIMITER //
CREATE PROCEDURE `prc_insertVendorCDR`(
	IN `p_processId` VARCHAR(200),
	IN `p_tbltempusagedetail_name` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	SET @stm2 = CONCAT('
	INSERT INTO   tblVendorCDRHeader (CompanyID,CompanyGatewayID,GatewayAccountPKID,GatewayAccountID,AccountID,StartDate,created_at,ServiceID)
	SELECT DISTINCT d.CompanyID,d.CompanyGatewayID,d.GatewayAccountPKID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW(),d.ServiceID
	FROM `' , p_tbltempusagedetail_name , '` d
	LEFT JOIN tblVendorCDRHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE h.GatewayAccountID IS NULL AND processid = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

-- changed by sumera billed_duration = 0 AND buying_cost = 0 AND selling_cost =  0
	SET @stm6 = CONCAT('
	INSERT INTO tblVendorCDRFailed (VendorCDRHeaderID,billed_duration,duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	SELECT VendorCDRHeaderID,billed_duration,duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
	FROM `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblVendorCDRHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE processid = "' , p_processId , '" AND  billed_duration = 0 AND buying_cost = 0 AND selling_cost =  0  ;
	');

	PREPARE stmt6 FROM @stm6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

	SET @stm3 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  AND billed_duration = 0 AND buying_cost = 0 AND selling_cost =  0 ;
	');

	PREPARE stmt3 FROM @stm3;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SET @stm4 = CONCAT('
	INSERT INTO tblVendorCDR (VendorCDRHeaderID,billed_duration,duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	SELECT VendorCDRHeaderID,billed_duration,duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
	FROM `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblVendorCDRHeader h
	ON h.GatewayAccountPKID = d.GatewayAccountPKID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stmt4 FROM @stm4;
	EXECUTE stmt4;
	DEALLOCATE PREPARE stmt4;

	SET @stm5 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stmt5 FROM @stm5;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;

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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_processId);

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

	-- for Mirta retail only
	
	SET @stm51 = CONCAT('
	INSERT INTO  tblRetailUsageDetail (UsageDetailID,ID,cc_type,ProcessID)
	SELECT Distinct d.UsageDetailID,rd.ID,rd.cc_type,rd.ProcessID
	FROM   `' , p_tbltempusagedetail_name , '_Retail` rd
	INNER JOIN tblUsageDetails d
	ON d.ProcessID = rd.ProcessID AND rd.ID=d.ID
	WHERE   d.ProcessID = "' , p_processId , '" ;
	');
	PREPARE stmt51 FROM @stm51;
	EXECUTE stmt51;
	DEALLOCATE PREPARE stmt51;


	SET @stm52 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '_Retail` WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stm52 FROM @stm52;
	EXECUTE stm52;
	DEALLOCATE PREPARE stm52;

	SET @stm6 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');

	PREPARE stmt6 FROM @stm6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;
	
USE `StagingReport`;

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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);

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
		a.CompanyID,
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
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = ' , p_CompanyID , '
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
		extension,
		ID
	)
	SELECT 
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		a.CompanyID,
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
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetUsageForSummaryLive`;
DELIMITER //
CREATE PROCEDURE `fnGetUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DELETE FROM tmp_tblUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	
	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		a.CompanyID,
		uh.CompanyGatewayID,
		uh.ServiceID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 AS call_status
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		a.CompanyID,
		uh.CompanyGatewayID,
		uh.ServiceID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 AS call_status
	FROM RMCDR3.tblUsageDetailFailedCall  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummary`;
DELIMITER //
CREATE PROCEDURE `fnGetVendorUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE,
	IN `p_UniqueID` VARCHAR(50)

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);

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
		call_status_v,
		ID
	)
	SELECT 
		ud.VendorCDRID,
		uh.AccountID,
		a.CompanyID,
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
		1 AS call_status,
		ID
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID		
	WHERE
		a.CompanyID = ' , p_CompanyID , '
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
		call_status_v,
		ID
	)
	SELECT 
		ud.VendorCDRFailedID,
		uh.AccountID,
		a.CompanyID,
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
		2 AS call_status,
		ID
	FROM RMCDR3.tblVendorCDRFailed  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = ' , p_CompanyID , '
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN "' , p_StartDate , '" AND "' , p_EndDate , '";
	');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummaryLive`;
DELIMITER //
CREATE PROCEDURE `fnGetVendorUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	
	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		a.CompanyID,
		uh.CompanyGatewayID,
		uh.ServiceID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 AS call_status
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		a.CompanyID,
		uh.CompanyGatewayID,
		uh.ServiceID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 AS call_status
	FROM RMCDR3.tblVendorCDRFailed  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = uh.AccountID	
	WHERE
		a.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_generateSummary`;
DELIMITER //
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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);
	
	CALL fngetDefaultCodes(p_CompanyID); 
	
	
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
		userfield,
		TotalCharges,
		TotalCost,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		a.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		ud.userfield,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCost ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = ud.AccountID
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE a.CompanyID = ',p_CompanyID,'
		AND ud.AccountID IS NOT NULL
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk,ud.userfield;
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_UsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummary.CountryID =code.CountryID
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;
	
	DELETE us FROM tblUsageSummaryDay us 
	INNER JOIN tblHeader sh ON us.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblUsageSummaryHour usd
	INNER JOIN tblHeader sh ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
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
		TotalCost,
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
		SUM(TotalCost) as TotalCost,
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

	INSERT INTO tblUsageSummaryDay (
		HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		userfield,
		CountryID,
		TotalCharges,
		TotalCost,
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
		userfield,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalCost),
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
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderID,us.userfield;
	
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
		userfield,
		CountryID,
		TotalCharges,
		TotalCost,
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
		userfield,
		CountryID,
		us.TotalCharges,
		us.TotalCost,
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
	
 	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_generateSummaryLive`;
DELIMITER //
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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);

	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateCustomerLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
	CALL fnUpdateVendorLink(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);

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
		userfield,
		TotalCharges,
		TotalCost,
		TotalBilledDuration,
		TotalDuration,
		NoOfCalls,
		NoOfFailCalls
	)
	SELECT 
		d.DateID,
		t.TimeID,
		a.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ud.GatewayAccountPKID,
		ud.GatewayVAccountPKID,
		ud.AccountID,
		ud.VAccountID,
		ud.trunk,
		ud.area_prefix,
		ud.userfield,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCost ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN Ratemanagement3.tblAccount a
		ON a.AccountID = ud.AccountID	
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE a.CompanyID = ',p_CompanyID,'
		AND ud.AccountID IS NOT NULL
	GROUP BY d.DateID,t.TimeID,ud.CompanyID,ud.CompanyGatewayID,ud.ServiceID,ud.GatewayAccountPKID,ud.GatewayVAccountPKID,ud.AccountID,ud.VAccountID,ud.area_prefix,ud.trunk,ud.userfield;
	');


	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	UPDATE tmp_UsageSummaryLive
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	START TRANSACTION;

	DELETE us FROM tblUsageSummaryDayLive us 
	INNER JOIN tblHeader sh ON us.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblUsageSummaryHourLive usd
	INNER JOIN tblHeader sh ON usd.HeaderID = sh.HeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

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
		TotalCost,
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
		SUM(TotalCost) as TotalCost,
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

	INSERT INTO tblUsageSummaryDayLive (
		HeaderID,
		CompanyGatewayID,
		ServiceID,
		GatewayAccountPKID,
		GatewayVAccountPKID,
		VAccountID,
		Trunk,
		AreaPrefix,
		userfield,
		CountryID,
		TotalCharges,
		TotalCost,
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
		userfield,
		CountryID,
		SUM(us.TotalCharges),
		SUM(us.TotalCost),
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
	GROUP BY us.DateID,us.CompanyID,us.CompanyGatewayID,us.ServiceID,us.GatewayAccountPKID,us.GatewayVAccountPKID,us.AccountID,us.VAccountID,us.AreaPrefix,us.Trunk,us.CountryID,sh.HeaderID,us.userfield;

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
		userfield,
		CountryID,
		TotalCharges,
		TotalCost,
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
		userfield,
		CountryID,
		us.TotalCharges,
		us.TotalCost,
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

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_generateVendorSummary`;
DELIMITER //
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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);
	
	CALL fngetDefaultCodes(p_CompanyID);
		
-- 	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID); 
-- 	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate,p_UniqueID);
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
		SUM(IF(ud.call_status_v=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status_v=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
		AND ud.VAccountID IS NOT NULL
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
	
	DELETE us FROM tblVendorSummaryDay us 
	INNER JOIN tblHeaderV sh ON us.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblVendorSummaryHour usd
	INNER JOIN tblHeaderV sh ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
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
		TotalSales,
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
		SUM(TotalSales) as TotalSales,		
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
		TotalSales,
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
		SUM(us.TotalSales),
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
		TotalSales,
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
		us.TotalSales,
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
	
	SET @stmt = CONCAT('TRUNCATE TABLE tmp_tblUsageDetailsReport_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @stmt = CONCAT('TRUNCATE TABLE tmp_tblVendorUsageDetailsReport_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	/*SET @stmt = CONCAT('TRUNCATE TABLE tblTempCallDetail_2_',p_UniqueID,';');

	PREPARE stmt FROM @stmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;*/
	
	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;
	
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_generateVendorSummaryLive`;
DELIMITER //
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
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(CONCAT(p_UniqueID,'vendor'));
	
	CALL fngetDefaultCodes(p_CompanyID);

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
		SUM(IF(ud.call_status_v=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status_v=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport_',p_UniqueID,' ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	WHERE ud.CompanyID = ',p_CompanyID,'
		AND ud.VAccountID IS NOT NULL
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

	DELETE us FROM tblVendorSummaryDayLive us 
	INNER JOIN tblHeaderV sh ON us.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblVendorSummaryHourLive usd
	INNER JOIN tblHeaderV sh ON usd.HeaderVID = sh.HeaderVID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

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
		TotalSales,
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
		SUM(TotalSales) as TotalSales,
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
		TotalSales,
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
		SUM(us.TotalSales),
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
		TotalSales,
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
		us.TotalSales,
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

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateLiveTables`;
DELIMITER //
CREATE PROCEDURE `prc_updateLiveTables`(
	IN `p_CompanyID` INT,
	IN `p_UniqueID` VARCHAR(50)
)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL Ratemanagement3.prc_UpdateMysqlPID(p_UniqueID);

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

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;
	