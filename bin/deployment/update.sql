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

INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('RecurringInvoice.Add', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('RecurringInvoice.Edit', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('RecurringInvoice.Delete','1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('RecurringInvoice.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('RecurringInvoice.All', '1');


UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Add' limit 1) WHERE  `ResourceName`='RecurringInvoice.create';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Add' limit 1) WHERE  `ResourceName`='RecurringInvoice.store';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Edit' limit 1) WHERE  `ResourceName`='RecurringInvoice.edit';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Edit' limit 1) WHERE  `ResourceName`='RecurringInvoice.update';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.getAccountInfo';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.getBillingClassInfo';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.index';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.recurringinvoicelog';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Edit' limit 1) WHERE  `ResourceName`='RecurringInvoice.startstop';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.ajax_datagrid';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.ajax_recurringinvoicelog_datagrid';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.View' limit 1) WHERE  `ResourceName`='RecurringInvoice.calculate_total';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='RecurringInvoice.Delete' limit 1) WHERE  `ResourceName`='RecurringInvoice.delete';


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
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='SITE_URL';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='Neon_API_URL';

UPDATE `tblCompanyConfiguration` SET `Key`='UPLOAD_PATH' WHERE  `Key`='UPLOADPATH';
UPDATE `tblCompanyConfiguration` SET `Key`='PHP_EXE_PATH' WHERE  `Key`='PHPExePath';
UPDATE `tblCompanyConfiguration` SET `Key`='QUICKBOOK' WHERE  `Key`='Quickbook';
UPDATE `tblCompanyConfiguration` SET `Key`='RM_ARTISAN_FILE_LOCATION' WHERE  `Key`='RMArtisanFileLocation';

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

-- ##########################################################
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES
	(1, 'Invoice Send', 'New Invoice {{InvoiceNumber}} from {{CompanyName}} ', 'Hi {{AccountName}}<br><br>\r\n\r\n\r\n{{CompanyName}} has sent you an invoice of {{InvoiceGrandTotal}} {{Currency}}, \r\nto download copy of your invoice please click the below link.&nbsp;<br><br>\r\n\r\n\r\n<div><a href="{{InvoiceLink}}" style="background-color:#ff9600;border:1px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{InvoiceLink}}">View</a></div>\r\n<br>Best Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}<br>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-03-08 12:42:51', 'Sumera Khan', NULL, 2, 'test@test.com', 1, 'InvoiceSingleSend', 1, 1),
	(1, 'Estimate Send', 'New estimate {{EstimateNumber}} from {{CompanyName}} ', 'Hi {{AccountName}},<br><br>\r\n\r\n\r\n{{CompanyName}} has sent you an estimate of {{EstimateGrandTotal}} {{Currency}}, \r\nto download copy of your estimate please click the below link. <br><br>\r\n\r\n\r\n<div><a href="{{EstimateLink}}" style="background-color:#ff9600;border:2px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{EstimateLink}}">View Estimate</a></div>\r\n<br><br>\r\n\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}\r\n<br>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-03-08 12:34:20', 'Sumera Khan', NULL, 5, 'test@test.com', 1, 'EstimateSingleSend', 1, 1),
	(1, 'New Comment on Estimate', 'New Comment added to Estimate {{EstimateNumber}}', 'Dear {{AccountName}},<br><br>\r\n\r\nComment added to Estimate {{EstimateNumber}}<br>\r\n{{Comment}}<br><br>\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n{{CompanyName}}<br>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-03-01 16:18:45', 'Sumera Khan', NULL, 5, 'sumera.staging@code-desk.com', 1, 'EstimateSingleComment', 1, 0),
	(1, 'New Comment on Task', 'New Comment by {{User}} on Task', '<div>\r\n<table align="center" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px"><img src="{{Logo}}" border="0" width=""></td>\r\n    </tr>\r\n    </tbody>\r\n</table>\r\n<table align="center" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td width="5%"></td>\r\n        <td width="90%" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 16px; text-align: center; padding-top: 16px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n            <div style="width: 90%; padding-bottom: 12px; padding-top: 12px; padding-left: 16px; margin: 0px auto; display: block; padding-right: 16px">\r\n                <h6 style="font-size: 20px; font-family: \'helvetica\', \'arial\', sans-serif; word-break: normal; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px 0px 12px; line-height: 1.3; padding-right: 0px">Update\r\n                </h6>\r\n                <table class="phenom" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 12px 0px; border-spacing: 0; padding-right: 0px" width="100%">\r\n                    <tbody>\r\n                    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n                        <td class="phenom-details" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n                            <div style="float: left;clear:left;">\r\n                                <strong>{{User}}</strong> Commented on {{subject}}\r\n                                <p style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; font-weight: normal; color: #4d4d4d; text-align: left; margin: 0px 0px 10px; line-height: 19px; padding: 10px;background-color:#ffffff;border-color: #d6cfcf;border-radius: 10px;border-style: solid;border-width: 1px 3px 3px 1px;margin: 5px;max-width: 95%;padding: 5px;">\r\n                                    {{Comment}}\r\n                                </p>\r\n                            </div>\r\n                        </td>\r\n                    </tr>\r\n                    </tbody>\r\n                </table>\r\n            </div>\r\n        </td>\r\n        <td width="5%"></td>\r\n    </tr>\r\n    </tbody>\r\n</table>\r\n</div>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-03-08 12:32:47', 'Sumera Khan', NULL, 8, 'test@test.com', 1, 'TaskCommentEmail', 1, 0),
	(1, 'New Comment on Opportunity', 'New Comment by {{User}} on Opportunity', '<div>\r\n<table align="center" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px"><img src="{{Logo}}" border="0" width=""></td>\r\n    </tr>\r\n    </tbody>\r\n</table>\r\n<table align="center" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td width="5%"></td>\r\n        <td width="90%" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 16px; text-align: center; padding-top: 16px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n            <div style="width: 90%; padding-bottom: 12px; padding-top: 12px; padding-left: 16px; margin: 0px auto; display: block; padding-right: 16px">\r\n                <h6 style="font-size: 20px; font-family: \'helvetica\', \'arial\', sans-serif; word-break: normal; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px 0px 12px; line-height: 1.3; padding-right: 0px">Update\r\n                </h6>\r\n                <table class="phenom" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 12px 0px; border-spacing: 0; padding-right: 0px" width="100%">\r\n                    <tbody>\r\n                    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n                        <td class="phenom-details" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n                            <div style="float: left;clear:left;">\r\n                                <strong>{{User}}</strong> Commented on {{subject}}\r\n                                <p style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; font-weight: normal; color: #4d4d4d; text-align: left; margin: 0px 0px 10px; line-height: 19px; padding: 10px;background-color:#ffffff;border-color: #d6cfcf;border-radius: 10px;border-style: solid;border-width: 1px 3px 3px 1px;margin: 5px;max-width: 95%;padding: 5px;">\r\n                                    {{Comment}}\r\n                                </p>\r\n                            </div>\r\n                        </td>\r\n                    </tr>\r\n                    </tbody>\r\n                </table>\r\n            </div>\r\n        </td>\r\n        <td width="5%"></td>\r\n    </tr>\r\n    </tbody>\r\n</table>\r\n</div>', '2017-02-13 10:28:29', 'Sumera Saeed', '2017-03-08 12:33:05', 'Sumera Khan', NULL, 9, 'test@test.com', 1, 'OpportunityCommentEmail', 1, 0);
-- ###########################################################
update tblEmailTemplate set EmailFrom = (select Email from tblCompany);
-- ###########################################################

-- Abubakar
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
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

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
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoiceLog` (
  `RecurringInvoicesLogID` int(11) NOT NULL auto_increment,
  `RecurringInvoiceID` int(11) NULL,
  `Note` longtext NULL,
  `RecurringInvoiceLogStatus` int(11) NULL,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  PRIMARY KEY (`RecurringInvoicesLogID`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tblRecurringInvoiceTaxRate` (
	`RecurringInvoiceTaxRateID` INT(11) NOT NULL AUTO_INCREMENT,
	`RecurringInvoiceID` INT(11) NOT NULL,
	`TaxRateID` INT(11) NOT NULL,
	`TaxAmount` DECIMAL(18,6) NOT NULL,
	`Title` VARCHAR(500) NOT NULL COLLATE 'utf8_unicode_ci',
	`RecurringInvoiceTaxType` TINYINT(4) NOT NULL DEFAULT '0',
	`CreatedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`RecurringInvoiceTaxRateID`),
	UNIQUE INDEX `RecurringInvoiceTaxRateUnique` (`RecurringInvoiceID`, `TaxRateID`, `RecurringInvoiceTaxType`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

-- Girish
USE `RMCDR3`;

ALTER TABLE `tblUsageDetailFailedCall`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;
ALTER TABLE `tblUsageDetails`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;
