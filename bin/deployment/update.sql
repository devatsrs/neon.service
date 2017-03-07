-- Ratemanagement3
-- Abubakar
USE `Ratemanagement3`;

INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardSummaryWidgets.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardMissingGatewayWidget.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardInvoiceExpenseWidgets.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardPincodeWidget.View', '1');

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardSummaryWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardSummaryWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total_widget';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardMissingGatewayWidget.View' limit 1) WHERE  `ResourceName`='Dashboard.ajax_get_missing_accounts';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardInvoiceExpenseWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_chart';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardPincodeWidget.View' limit 1) WHERE  `ResourceName`='BillingDashboard.ajax_top_pincode';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardInvoiceExpenseWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total_widget';

DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskDomain';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskEmail';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='Freshdeskkey';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskPassword';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='PAYPAL_IPN';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='OUTLOOKCALENDAR_API';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='EXTRA_SMTP';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='Amazon';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='ErrorEmail';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FILE_RETENTION_EMAIL';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='SIPPY_CSVDECODER';

UPDATE `tblCompanyConfiguration` SET `Key`='UPLOAD_PATH' WHERE  `Key`='UPLOADPATH';
UPDATE `tblCompanyConfiguration` SET `Key`='WEB_URL' WHERE  `Key`='SITE_URL';
UPDATE `tblCompanyConfiguration` SET `Key`='NEON_API_URL' WHERE  `Key`='Neon_API_URL';
UPDATE `tblCompanyConfiguration` SET `Key`='PHP_EXE_PATH' WHERE  `Key`='PHPExePath';
UPDATE `tblCompanyConfiguration` SET `Key`='RM_ARTISAN_FILE_LOCATION' WHERE  `Key`='RMArtisanFileLocation';
UPDATE `tblCompanyConfiguration` SET `Key`='QUICKBOOK' WHERE  `Key`='Quickbook';

INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'BILLING_DASHBOARD_CUSTOMER', '_BILLING_DASHBOARD_CUSTOMER_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'EMAIL_TO_CUSTOMER', '1');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'ACC_DOC_PATH','_ACC_DOC_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'PAYMENT_PROOF_PATH', '_PAYMENT_PROOF_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'CRM_ALLOWED_FILE_UPLOAD_EXTENSIONS', 'bmp,csv,doc,docx,gif,ini,jpg,msg,odt,pdf,png,ppt,pptx,rar,rtf,txt,xls,xlsx,zip,7z');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'SUPER_ADMIN_EMAILS', '{"registration":{"from":"","from_name":"","email":""}}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'CACHE_EXPIRE', '60');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'MAX_UPLOAD_FILE_SIZE', '5M');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'PAGE_SIZE', '50');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_PREFERENCE', '5');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'WEB_URL', '_WEB_URL_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEMO_DATA_PATH', '');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'TRANSACTION_LOG_EMAIL_FREQUENCY', 'Daily');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_TIMEZONE', 'GMT');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_BILLING_TIMEZONE', 'Europe/London');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DELETE_CDR_TIME', '3 month');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DELETE_SUMMARY_TIME', '4 days');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'NEON_API_URL', '_NEON_API_URL_');

-- Dev

ALTER TABLE `tblVendorRateDiscontinued`	ADD INDEX `UK_tblVendorRateDiscontinued` (`AccountId`, `RateId`);
-- Duplicate index same column index exists with unique key
ALTER TABLE tblVendorRate DROP INDEX IX_VendorRate_Accountid_EffectiveDate_TrunkID_RateID;


-- Girish

USE `Ratemanagement3`;

CREATE TABLE IF NOT EXISTS `tblCLIRateTable` (
  `CLIRateTableID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `CLI` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateTableID` int(11) NOT NULL,
  PRIMARY KEY (`CLIRateTableID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- Umer
USE `Ratemanagement3`;

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='Alert.View' limit 1) WHERE  `ResourceName`='Dashboard.getTopAlerts';

CREATE TABLE IF NOT EXISTS `tblHelpDeskTickets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TicketID` int(11) DEFAULT NULL,
  `Subject` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Description` text COLLATE utf8_unicode_ci NOT NULL,
  `Priority` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GUID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Group` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `to_emails` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequestEmail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketType` tinyint(4) NOT NULL DEFAULT '0',
  `TicketAgent` int(11) NOT NULL DEFAULT '0',
  `ApiCreatedDate` datetime DEFAULT NULL,
  `ApiUpdateDate` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Fresh desk tickets will save  here temporarily\r\nprc_getAccountTimeLine will use it';

-- ##############################################################
-- ALTER TABLE `tblAccountTickets`	ADD COLUMN `TicketType` TINYINT NULL DEFAULT '0' AFTER `RequestEmail`;
-- ALTER TABLE `tblAccountTickets`	CHANGE COLUMN `TicketType` `TicketType` TINYINT(4) NOT NULL DEFAULT '0' AFTER `RequestEmail`;
-- ALTER TABLE `tblAccountTickets`	ADD COLUMN `TicketAgent` INT NOT NULL DEFAULT '0' AFTER `TicketType`;
-- ##############################################################
-- INSERT INTO tblHelpDeskTickets FROM tblAccountTickets;
-- ##############################################################
insert into tblHelpDeskTickets (CompanyID,AccountID,TicketID,Subject,Description,Priority,`Status`,`Type`,GUID,`Group`,to_emails,RequestEmail,TicketType,TicketAgent,ApiCreatedDate,ApiUpdateDate,created_at,created_by,updated_at,updated_by)
select CompanyID,AccountID,TicketID,Subject,Description,Priority,`Status`,`Type`,GUID,`Group`,to_emails,RequestEmail,0 as TicketType, 0 as TicketAgent,ApiCreatedDate,ApiUpdateDate,created_at,created_by,updated_at,updated_by from tblAccountTickets;
-- ##############################################################
ALTER TABLE `AccountEmailLog`
	ADD COLUMN `ContactID` INT(11) NULL DEFAULT NULL AFTER `AccountID`,
	ADD COLUMN `UserType` TINYINT NULL DEFAULT '0' COMMENT '0 for account,1 for contact' AFTER `ContactID`;
-- ##############################################################
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `EmailFrom` VARCHAR(100) NULL DEFAULT NULL AFTER `Type`,
	ADD COLUMN `StaticType` TINYINT NULL DEFAULT '0' COMMENT '0 for allow deleted,1 for not  allowed to delete' AFTER `EmailFrom`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `SystemType` VARCHAR(100) NULL DEFAULT NULL AFTER `StaticType`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `Status` TINYINT NULL DEFAULT '1' AFTER `SystemType`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `StatusDisabled` TINYINT(4) NULL DEFAULT '0' AFTER `Status`;
ALTER TABLE `tblEmailTemplate`
	CHANGE COLUMN `StatusDisabled` `StatusDisabled` TINYINT(4) NULL DEFAULT '0' COMMENT '0 for allow disable,1 for not  allow disable' AFTER `Status`;
-- ##############################################################
CREATE TABLE IF NOT EXISTS `tbl_Account_Contacts_Activity` (
  `Timeline_id` int(11) NOT NULL AUTO_INCREMENT,
  `Timeline_type` int(11) NOT NULL DEFAULT '0',
  `TaskTitle` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaskName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaskPriority` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DueDate` datetime DEFAULT NULL,
  `TaskDescription` longtext COLLATE utf8_unicode_ci,
  `TaskStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `followup_task` int(11) DEFAULT NULL,
  `TaskID` int(11) DEFAULT NULL,
  `Emailfrom` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailTo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailToName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailSubject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailMessage` longtext COLLATE utf8_unicode_ci,
  `EmailCc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailBcc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailAttachments` longtext COLLATE utf8_unicode_ci,
  `AccountEmailLogID` int(11) DEFAULT NULL,
  `NoteID` int(11) DEFAULT NULL,
  `ContactNoteID` int(11) DEFAULT '0',
  `Note` longtext COLLATE utf8_unicode_ci,
  `TicketID` int(11) DEFAULT NULL,
  `TicketSubject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketStatus` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequestEmail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketPriority` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketType` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketGroup` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketDescription` longtext COLLATE utf8_unicode_ci,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `TableCreated_at` datetime DEFAULT NULL,
  `GUID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Timeline_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
-- ##############################################################

--Abubakar
USE `RMBilling3`;

ALTER TABLE `tblInvoice`
	ADD COLUMN `RecurringInvoiceID` INT(50) NULL DEFAULT NULL AFTER `EstimateID`,
	ADD COLUMN `ProcessID` VARCHAR(50) NULL DEFAULT NULL AFTER `RecurringInvoiceID`;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoice` (
  `RecurringInvoiceID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NULL,
  `Title` varchar(100) NULL,
  `AccountID` int(11) NULL,
  `Address` varchar(200) NULL,
  `BillingClassID` int(11) NULL,
  `BillingCycleType` varchar(50) NULL,
  `BillingCycleValue` varchar(50) NULL,
  `Occurrence` int(11) NULL DEFAULT '0',
  `PONumber` varchar(50) NULL,
  `Status` int(11) NULL,
  `LastInvoicedDate` datetime NULL,
  `NextInvoiceDate` datetime NULL,
  `CurrencyID` int(11) NULL,
  `InvoiceType` int(11) NULL,
  `SubTotal` decimal(18,6) NULL,
  `TotalDiscount` decimal(18,2) NULL,
  `TaxRateID` int(11) NULL,
  `TotalTax` decimal(10,6) NULL,
  `RecurringInvoiceTotal` decimal(10,6) NULL,
  `GrandTotal` decimal(10,6) NULL,
  `Description` varchar(50) NULL,
  `Attachment` varchar(50) NULL,
  `Note` longtext NULL,
  `Terms` longtext NULL,
  `ItemInvoice` tinyint(3) NULL,
  `FooterTerm` longtext NULL,
  `PDF` varchar(500) NULL,
  `UsagePath` varchar(500) NULL,
  `CreatedBy` varchar(50) NULL,
  `ModifiedBy` varchar(50) NULL,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  PRIMARY KEY (`RecurringInvoiceID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoiceDetail` (
  `RecurringInvoiceDetailID` int(11) NOT NULL auto_increment,
  `RecurringInvoiceID` int(11) NOT NULL,
  `ProductID` int(11) NULL,
  `Description` varchar(250) NOT NULL,
  `Price` decimal(18,6) NOT NULL,
  `Qty` int(11) NULL,
  `Discount` decimal(18,2) NULL,
  `TaxRateID` int(11) NULL,
  `TaxRateID2` int(11) NULL,
  `TaxAmount` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `LineTotal` decimal(18,6) NOT NULL,
  `CreatedBy` varchar(50) NULL,
  `ModifiedBy` varchar(50) NULL,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `ProductType` int(11) NULL,
  PRIMARY KEY (`RecurringInvoiceDetailID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoiceLog` (
  `RecurringInvoicesLogID` int(11) NOT NULL auto_increment,
  `RecurringInvoiceID` int(11) NULL,
  `Note` longtext NULL,
  `RecurringInvoiceLogStatus` int(11) NULL,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  PRIMARY KEY (`RecurringInvoicesLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoiceTaxRate` (
  `RecurringInvoiceTaxRateID` int(11) NOT NULL auto_increment,
  `RecurringInvoiceID` int(11) NOT NULL,
  `TaxRateID` int(11) NOT NULL,
  `TaxAmount` decimal(18,6) NOT NULL,
  `Title` varchar(500) NOT NULL,
  `RecurringInvoiceTaxType` tinyint(4) NOT NULL DEFAULT 0,
  `CreatedBy` varchar(50) NULL,
  `ModifiedBy` varchar(50) NULL,
  `created_at` datetime NULL DEFAULT 'CURRENT_TIMESTAMP',
  `updated_at` datetime NULL DEFAULT 'CURRENT_TIMESTAMP' on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`RecurringInvoiceTaxRateID`),
  UNIQUE KEY `RecurringInvoiceTaxRateUnique`(`RecurringInvoiceID`,`TaxRateID`,`RecurringInvoiceTaxType`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--Girish
USE `RMCDR3`;

ALTER TABLE `tblUsageDetailFailedCall`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;
ALTER TABLE `tblUsageDetails`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;
