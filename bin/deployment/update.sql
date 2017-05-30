USE `Ratemanagement3`;

ALTER TABLE `tblAccountBilling` DROP INDEX `AccountID`;

ALTER TABLE `tblAccountDiscountPlan` DROP INDEX `AccountID`;

ALTER TABLE `tblAccountNextBilling` DROP INDEX `AccountID`;

ALTER TABLE `AccountEmailLog`
  ADD COLUMN `TicketID` int(11) NOT NULL DEFAULT '0';

ALTER TABLE `tblAccountAuthenticate`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountBilling`
  DROP COLUMN `PaymentDueInDays`
  , DROP COLUMN `RoundChargesAmount`
  , DROP COLUMN `CDRType`
  , DROP COLUMN `InvoiceTemplateID`
  , DROP COLUMN `TaxRateId`  ;

ALTER TABLE `tblAccountBilling`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountBilling` ADD UNIQUE KEY `AccountID`(`ServiceID`,`AccountID`);

ALTER TABLE `tblAccountBillingPeriod`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountDiscountPlan`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountDiscountPlan` ADD UNIQUE KEY `AccountID`(`Type`,`AccountID`,`ServiceID`);

ALTER TABLE `tblAccountDiscountPlanHistory`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountNextBilling`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountNextBilling` ADD UNIQUE KEY `AccountID`(`ServiceID`,`AccountID`);

CREATE TABLE `tblAccountService` (
  `AccountServiceID` int(11) NOT NULL auto_increment,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `ServiceID` int(3) NOT NULL DEFAULT '0',
  `CompanyID` int(3) NOT NULL DEFAULT '0',
  `Status` int(3) NOT NULL DEFAULT '1',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `ServiceTitle` varchar(50) NULL,
  PRIMARY KEY (`AccountServiceID`)
) ENGINE=InnoDB;

CREATE TABLE `tblAccountTariff` (
  `AccountTariffID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `AccountID` int(11) NOT NULL,
  `ServiceID` int(11) NOT NULL,
  `RateTableID` int(11) NOT NULL,
  `Type` tinyint(4) NULL DEFAULT 1,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  PRIMARY KEY (`AccountTariffID`)
) ENGINE=InnoDB;

ALTER TABLE `tblCLIRateTable`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblEmailTemplate`
  ADD COLUMN `TicketTemplate` tinyint(4) NULL DEFAULT 0;

ALTER TABLE `tblHelpDeskTickets`
  ADD COLUMN `ContactID` int(11) NULL;


ALTER TABLE `tblNote`
  ADD COLUMN `UserID` int(11) NOT NULL DEFAULT '0'
  , ADD COLUMN `TicketID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblResourceCategories`
  ADD COLUMN `CategoryGroupID` int(11) NULL DEFAULT '0';

CREATE TABLE `tblResourceCategoriesGroups` (
  `CategoriesGroupID` int(11) NOT NULL auto_increment,
  `GroupName` varchar(100) NULL,
  KEY `Index 1`(`CategoriesGroupID`)
) ENGINE=InnoDB;

CREATE TABLE `tblService` (
  `ServiceID` int(11) NOT NULL auto_increment,
  `ServiceName` varchar(200) NOT NULL,
  `ServiceType` varchar(200) NULL,
  `CompanyID` int(11) NOT NULL,
  `Status` tinyint(1) NULL,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `CompanyGatewayID` int(11) NULL,
  PRIMARY KEY (`ServiceID`)
) ENGINE=InnoDB;

ALTER TABLE `tblTempAccount`
  ADD COLUMN `IsVendor` tinyint(1) NULL
  , ADD COLUMN `IsCustomer` tinyint(1) NULL;

CREATE TABLE `tblTicketBusinessHolidays` (
  `HolidayID` int(11) NOT NULL auto_increment,
  `BusinessHoursID` int(11) NOT NULL DEFAULT '0',
  `HolidayMonth` int(11) NOT NULL DEFAULT '0',
  `HolidayDay` int(11) NOT NULL DEFAULT '0',
  `HolidayName` varchar(100) NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`HolidayID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketBusinessHours` (
  `ID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL,
  `IsDefault` tinyint(4) NOT NULL DEFAULT 0,
  `Name` varchar(100) NULL,
  `Description` text NULL,
  `Timezone` varchar(100) NULL DEFAULT '0',
  `HoursType` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for default, 2 for change able',
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `created_by` varchar(50) NULL,
  `updated_by` varchar(50) NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketDashboardTimeline` (
  `TicketDashboardTimelineID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `TimelineType` int(11) NULL,
  `UserName` varchar(100) NULL,
  `UserID` int(11) NULL,
  `CustomerID` int(11) NULL,
  `CustomerType` int(11) NULL DEFAULT '0' COMMENT '0 for user,1 for Account,2 for Contact',
  `EmailCall` int(11) NULL,
  `TicketID` int(11) NULL,
  `TicketSubmit` int(11) NULL,
  `Subject` varchar(500) NULL,
  `RecordID` int(11) NULL,
  `AgentID` int(11) NULL,
  `GroupID` int(11) NULL,
  `TicketFieldID` int(11) NULL,
  `TicketFieldValueFromID` int(11) NULL,
  `TicketFieldValueToID` int(11) NULL,
  `created_at` datetime NULL,
  `created_at_table` datetime NULL,
  PRIMARY KEY (`TicketDashboardTimelineID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketGroupAgents` (
  `GroupAgentsID` int(11) NOT NULL auto_increment,
  `GroupID` int(11) NOT NULL DEFAULT '0',
  `UserID` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`GroupAgentsID`),
  KEY `FK_tblTicketGroupAgents_tblTicketGroups`(`GroupID`),
  KEY `FK_tblTicketGroupAgents_tblUser`(`UserID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketGroups` (
  `GroupID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `GroupName` varchar(100) NOT NULL,
  `GroupDescription` varchar(500) NOT NULL,
  `GroupBusinessHours` int(11) NOT NULL DEFAULT '0',
  `GroupAssignTime` int(11) NOT NULL DEFAULT '0',
  `GroupAssignEmail` int(11) NOT NULL DEFAULT '0',
  `GroupAuomatedReply` text NULL,
  `GroupEmailAddress` varchar(100) NULL,
  `GroupEmailServer` varchar(100) NULL,
  `GroupEmailPassword` varchar(100) NULL,
  `GroupReplyAddress` varchar(100) NULL,
  `GroupEmailStatus` tinyint(4) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`GroupID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketImportRule` (
  `TicketImportRuleID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '1',
  `Title` varchar(100) NOT NULL,
  `Description` varchar(250) NOT NULL,
  `Match` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = Match Any 2 = Match All',
  `Status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketImportRuleID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketImportRuleAction` (
  `TicketImportRuleActionID` int(11) NOT NULL auto_increment,
  `TicketImportRuleID` int(11) NOT NULL,
  `TicketImportRuleActionTypeID` int(11) NOT NULL,
  `Value` varchar(250) NULL,
  `Order` int(11) NOT NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketImportRuleActionID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketImportRuleActionType` (
  `TicketImportRuleActionTypeID` int(11) NOT NULL auto_increment,
  `Action` varchar(50) NOT NULL,
  `ActionText` varchar(50) NOT NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketImportRuleActionTypeID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketImportRuleCondition` (
  `TicketImportRuleConditionID` int(11) NOT NULL auto_increment,
  `TicketImportRuleID` int(11) NOT NULL DEFAULT '0',
  `TicketImportRuleConditionTypeID` int(11) NOT NULL,
  `Operand` varchar(50) NOT NULL,
  `Value` varchar(500) NOT NULL,
  `Order` int(11) NOT NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketImportRuleConditionID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketImportRuleConditionType` (
  `TicketImportRuleConditionTypeID` int(11) NOT NULL auto_increment,
  `Condition` varchar(50) NOT NULL,
  `ConditionText` varchar(50) NOT NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketImportRuleConditionTypeID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketLog` (
  `TicketLogID` int(11) NOT NULL auto_increment,
  `UserID` int(11) NULL DEFAULT '0',
  `AccountID` int(11) NULL DEFAULT '0',
  `CompanyID` int(11) NULL,
  `TicketID` int(11) NULL,
  `TicketFieldID` int(11) NULL DEFAULT '0',
  `TicketFieldValueFromID` int(11) NULL DEFAULT '0',
  `TicketFieldValueToID` int(11) NULL DEFAULT '0',
  `NewTicket` tinyint(4) NULL DEFAULT 0 COMMENT 'default 0, on new ticket 1',
  `created_at` datetime NULL,
  PRIMARY KEY (`TicketLogID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketPriority` (
  `PriorityID` int(11) NOT NULL auto_increment,
  `PriorityValue` varchar(100) NULL,
  KEY `Index 1`(`PriorityID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketSla` (
  `TicketSlaID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `IsDefault` tinyint(1) NOT NULL DEFAULT 0,
  `Name` varchar(250) NOT NULL,
  `Description` text NULL,
  `Status` tinyint(4) NULL DEFAULT 1,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketSlaID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketSlaPolicyApplyTo` (
  `ApplyToID` int(11) NOT NULL auto_increment,
  `TicketSlaID` int(11) NOT NULL DEFAULT '0',
  `GroupFilter` varchar(100) NOT NULL DEFAULT '0',
  `TypeFilter` varchar(100) NOT NULL DEFAULT '0',
  `CompanyFilter` varchar(100) NOT NULL DEFAULT '0',
  `created_at` datetime NULL,
  `CreatedBy` varchar(100) NULL,
  `updated_at` datetime NULL,
  `ModifiedBy` varchar(100) NULL,
  PRIMARY KEY (`ApplyToID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketSlaPolicyViolation` (
  `ViolationID` int(11) NOT NULL auto_increment,
  `TicketSlaID` int(11) NOT NULL DEFAULT '0',
  `Time` varchar(100) NOT NULL DEFAULT '0',
  `Value` varchar(100) NOT NULL DEFAULT '0',
  `VoilationType` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL,
  `CreatedBy` varchar(100) NULL,
  `updated_at` datetime NULL,
  `ModifiedBy` varchar(100) NULL,
  PRIMARY KEY (`ViolationID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketSlaTarget` (
  `SlaTargetID` int(11) NOT NULL auto_increment,
  `TicketSlaID` int(11) NOT NULL DEFAULT '0',
  `PriorityID` tinyint(4) NOT NULL DEFAULT 0,
  `RespondValue` int(11) NULL DEFAULT '0',
  `RespondType` varchar(100) NULL,
  `ResolveValue` int(11) NULL DEFAULT '0',
  `ResolveType` varchar(100) NULL,
  `OperationalHrs` varchar(100) NULL,
  `EscalationEmail` tinyint(4) NULL DEFAULT 1 COMMENT '0 for disable , 1 for enable',
  `created_at` datetime NULL,
  `CreatedBy` varchar(100) NULL,
  `updated_at` datetime NULL,
  `ModifiedBy` varchar(100) NULL,
  PRIMARY KEY (`SlaTargetID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketfields` (
  `TicketFieldsID` int(11) NOT NULL auto_increment,
  `FieldType` varchar(100) NULL,
  `FieldStaticType` tinytext NOT NULL COMMENT '0 for static 1 for dynamic',
  `FieldHtmlType` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for Text,2 for Textarea,3 for checkbox,4 for text number,5 for dropdown,6 for date,7 for decimal',
  `FieldDomType` varchar(100) NULL,
  `FieldName` varchar(100) NULL,
  `FieldDesc` varchar(200) NULL,
  `AgentReqSubmit` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `AgentReqClose` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerDisplay` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerEdit` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerReqSubmit` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `AgentLabel` varchar(100) NULL,
  `CustomerLabel` varchar(100) NULL,
  `AgentCcDisplay` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerCcDisplay` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  KEY `Index 1`(`TicketFieldsID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketfieldsValues` (
  `ValuesID` int(11) NOT NULL auto_increment,
  `FieldsID` int(11) NOT NULL DEFAULT '0',
  `FieldType` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for static 1, for dynmaic',
  `FieldValueAgent` varchar(100) NULL,
  `FieldValueCustomer` varchar(100) NULL,
  `FieldSlaTime` tinyint(1) NULL COMMENT '0 for disable, 1 for active, 2 for inactive',
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`ValuesID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTickets` (
  `TicketID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `Requester` varchar(100) NULL,
  `RequesterName` varchar(100) NULL,
  `RequesterCC` varchar(300) NULL,
  `RequesterBCC` varchar(300) NULL,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `ContactID` int(11) NOT NULL DEFAULT '0',
  `UserID` int(11) NOT NULL DEFAULT '0',
  `Subject` varchar(200) NULL,
  `Type` int(11) NOT NULL DEFAULT '0',
  `Status` int(11) NOT NULL DEFAULT '0',
  `Priority` int(11) NOT NULL DEFAULT '0',
  `Group` int(11) NOT NULL DEFAULT '0',
  `Agent` int(11) NOT NULL DEFAULT '0',
  `Description` text NOT NULL,
  `AttachmentPaths` longtext NULL,
  `TicketType` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for ticket , 1 for email',
  `AccountEmailLogID` int(11) NOT NULL DEFAULT '0',
  `Read` tinyint(4) NOT NULL DEFAULT 0,
  `EscalationEmail` tinyint(4) NOT NULL DEFAULT 0,
  `TicketSlaID` int(11) NULL,
  `RespondSlaPolicyVoilationEmailStatus` tinyint(4) NULL DEFAULT 0,
  `ResolveSlaPolicyVoilationEmailStatus` tinyint(4) NULL DEFAULT 0,
  `DueDate` datetime NULL,
  `CustomDueDate` tinyint(1) NOT NULL DEFAULT 0,
  `AgentRepliedDate` datetime NULL,
  `CustomerRepliedDate` datetime NULL,
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`TicketID`)
) ENGINE=InnoDB COMMENT='System tickets saves here
All static fields data will be saved here
tblTicketDetails will have dynamic values of ticket';

CREATE TABLE `tblTicketsDetails` (
  `TicketsDetailsID` int(11) NOT NULL auto_increment,
  `TicketID` int(11) NOT NULL DEFAULT '0',
  `FieldID` int(11) NOT NULL DEFAULT '0',
  `FieldValue` varchar(200) NULL,
  KEY `Index 1`(`TicketsDetailsID`)
) ENGINE=InnoDB;

CREATE TABLE `tblTicketsWorkingDays` (
  `ID` int(11) NOT NULL auto_increment,
  `BusinessHoursID` int(11) NOT NULL DEFAULT '0',
  `Day` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for monday....  7 for sunday',
  `Status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 for disabled 1 for enabled',
  `StartTime` time NOT NULL DEFAULT '00:00:00',
  `EndTime` time NOT NULL DEFAULT '00:00:00',
  `created_at` datetime NULL,
  `created_by` varchar(100) NULL,
  `updated_at` datetime NULL,
  `updated_by` varchar(100) NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

ALTER TABLE `tbl_Account_Contacts_Activity` COMMENT = 'temp table';

DROP FUNCTION `fnFIND_IN_SET`;

DELIMITER |
CREATE FUNCTION `fnFIND_IN_SET`(
	`p_String1` LONGTEXT,
	`p_String2` LONGTEXT



) RETURNS int(11)
BEGIN
	DECLARE i int;
	DECLARE counter int;
	
	DROP TEMPORARY TABLE IF EXISTS `table1`;
	CREATE TEMPORARY TABLE `table1` (
	  `splitted_column` varchar(45) NOT NULL
	);
	
	DROP TEMPORARY TABLE IF EXISTS `table2`;
	CREATE TEMPORARY TABLE `table2` (
	  `splitted_column` varchar(45) NOT NULL
	);


	SET i = 1;
	REPEAT
		INSERT INTO table1
		SELECT Ratemanagement3.FnStringSplit(p_String1, ',', i) WHERE Ratemanagement3.FnStringSplit(p_String1, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
	
	SET i = 1;
	REPEAT
		INSERT INTO table2
		SELECT Ratemanagement3.FnStringSplit(p_String2, ',', i) WHERE Ratemanagement3.FnStringSplit(p_String2, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
	
	SELECT COUNT(*) INTO counter
	FROM table1 
	INNER JOIN table2 ON table1.splitted_column = table2.splitted_column;
	
	RETURN counter;

END|
DELIMITER ;

DROP FUNCTION `fnGetRoundingPoint`;

DELIMITER |
CREATE FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT

) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID AND cs.Value <> '';

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `migrateService`()
BEGIN

IF ( (SELECT COUNT(*) FROM RMBilling3.tblAccountSubscription ) > 0 OR (SELECT COUNT(*) FROM RMBilling3.tblAccountOneOffCharge ) > 0  OR (SELECT COUNT(*) FROM tblCLIRateTable WHERE CompanyID =1) > 0)
THEN

INSERT INTO `tblService` (`ServiceID`, `ServiceName`, `ServiceType`, `CompanyID`, `Status`, `created_at`, `updated_at`, `CompanyGatewayID`) VALUES (1, 'Default Service', 'voice', 1, 1, '2017-05-08 13:02:01', '2017-05-09 02:00:41', 0);

INSERT INTO tblAccountService (AccountID,ServiceID,CompanyID,Status)
SELECT AccountID,1,CompanyId,1 FROM tblAccount WHERE AccountType = 1 AND Status =1 AND VerificationStatus = 2 AND CompanyId = 1;

UPDATE RMBilling3.tblAccountSubscription SET ServiceID =1 WHERE ServiceID = 0;
UPDATE RMBilling3.tblAccountOneOffCharge SET ServiceID =1 WHERE ServiceID = 0;
UPDATE tblCLIRateTable SET ServiceID =1 WHERE CompanyID =1 AND ServiceID = 0;
UPDATE tblAccountDiscountPlan SET ServiceID =1 WHERE ServiceID = 0;

END IF;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_AccountPaymentReminder`;

DELIMITER |
CREATE PROCEDURE `prc_AccountPaymentReminder`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_BillingClassID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL RMBilling3.prc_updateSOAOffSet(p_CompanyID,p_AccountID);
	
	
	SELECT
		DISTINCT
		a.AccountID,
		ab.SOAOffset
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN tblAccountBilling abg 
		ON abg.AccountID  = a.AccountID
	INNER JOIN tblBillingClass b
		ON b.BillingClassID = abg.BillingClassID
	WHERE a.CompanyId = p_CompanyID
	AND (p_AccountID = 0 OR  a.AccountID = p_AccountID)
	AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
	AND ab.SOAOffset > 0
	AND a.`Status` = 1;
	
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
	-- AND accauth.ServiceID = p_ServiceID
	AND ((CustomerAuthRule = p_IPCLICheck) OR (VendorAuthRule = p_IPCLICheck))
	WHERE (SELECT fnFIND_IN_SET(CONCAT(IFNULL(accauth.CustomerAuthValue,''),',',IFNULL(accauth.VendorAuthValue,'')),p_IPCLIString)) > 0;
	
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

DROP PROCEDURE IF EXISTS `prc_applyAccountDiscountPlan`;

DELIMITER |
CREATE PROCEDURE `prc_applyAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_processId` INT,
	IN `p_inbound` INT,
	IN `p_ServiceID` INT
)
BEGIN
	
	DECLARE v_DiscountPlanID_ INT;
	DECLARE v_AccountDiscountPlanID_ INT;
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
		EndDate 
	INTO  
		v_AccountDiscountPlanID_,
		v_DiscountPlanID_,
		v_StartDate,
		v_EndDate 
	FROM tblAccountDiscountPlan 
	WHERE AccountID = p_AccountID 
	AND  ServiceID = p_ServiceID
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
			AND adc.DiscountID = d.DiscountID AND adp.AccountDiscountPlanID = d.AccountDiscountPlanID
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

END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_AssignSlaToTicket`(
	IN `p_CompanyID` INT,
	IN `p_TicketID` INT














)
BEGIN


DECLARE v_HasCompanyFilter int;

DECLARE v_HasGroupFilter int;

DECLARE v_HasTypeFilter int;


DECLARE v_Group int;

DECLARE v_Type int;

DECLARE v_AccountID int;

DECLARE v_SlaPolicyID int;

DECLARE v_TicketSlaID int;

DECLARE v_DueDate datetime;

DECLARE v_resolve_in_min int;

DECLARE v_created_at datetime;

DECLARE v_OperationalHrs tinyint;

DECLARE v_GroupBusinessHours int;

DECLARE v_HoursType tinyint;

DECLARE v_PriorityID int;


SET SESSION TRANSACTION ISOLATION LEVEL READ  COMMITTED; 

SELECT 
`Priority` ,
`created_at` ,
`Group` , 
`Type` ,
`AccountID` into 

 v_PriorityID , 
 v_created_at , 
 v_Group , 
 v_Type ,  
 v_AccountID
from tblTickets where TicketID = p_TicketID;


-- if there is only one sla
IF ((select count(*) from tblTicketSla where CompanyID=p_CompanyID) = 1 ) THEN


	-- check for any match
	select sla.TicketSlaID  into v_TicketSlaID
	from tblTicketSla sla
	inner join tblTicketSlaPolicyApplyTo pol on pol.TicketSlaID = sla.TicketSlaID
		where sla.CompanyID=p_CompanyID
			and
			(
				(pol.CompanyFilter = ''  OR (pol.CompanyFilter is not null and FIND_IN_SET(v_AccountID,pol.CompanyFilter) > 0 ))
				OR
				(pol.GroupFilter = ''  OR (pol.GroupFilter is not null and FIND_IN_SET(v_Group,pol.GroupFilter) > 0) )
				OR
				(pol.TypeFilter = '' OR (pol.TypeFilter is not null and FIND_IN_SET(v_Type,pol.TypeFilter) > 0) )
			)
		limit 1	;



ELSE -- if there is many slas


		DROP TEMPORARY TABLE IF EXISTS `tmp_tblTicketSla`;
		CREATE TEMPORARY TABLE `tmp_tblTicketSla` (
			`TicketSlaID` INT NOT NULL,
			numMatches  INT NOT NULL
		);

		-- check max exact matches

		INSERT INTO tmp_tblTicketSla
		SELECT TicketSlaID , numMatches
	   FROM (SELECT (CASE WHEN (pol.CompanyFilter is not null and FIND_IN_SET(v_AccountID,pol.CompanyFilter) > 0 OR pol.CompanyFilter = '' ) THEN 1 ELSE 0 END +
		                CASE WHEN (pol.GroupFilter is not null and FIND_IN_SET(v_Group,pol.GroupFilter) > 0 OR pol.GroupFilter = '' ) THEN 1 ELSE 0 END +
							CASE WHEN (pol.TypeFilter is not null and FIND_IN_SET(v_Type,pol.TypeFilter) > 0 OR pol.TypeFilter = '' ) THEN 1 ELSE 0 END
		               ) AS numMatches,
		               sla.TicketSlaID
			          from tblTicketSla sla
						inner join tblTicketSlaPolicyApplyTo pol on pol.TicketSlaID = sla.TicketSlaID
						where sla.CompanyID=p_CompanyID
		       ) tmptable
		 WHERE numMatches > 0
		 ORDER BY numMatches DESC ;


		IF ( ( SELECT count(*) FROM tmp_tblTicketSla where  numMatches = 3 limit 1 ) > 0 ) THEN

			select TicketSlaID into v_TicketSlaID from tmp_tblTicketSla where  numMatches = 3 limit 1;

		ELSEIF ( ( SELECT count(*) FROM tmp_tblTicketSla where  numMatches = 2 limit 1 ) > 0 ) THEN

			select TicketSlaID into v_TicketSlaID from tmp_tblTicketSla where  numMatches = 2 limit 1;

		ELSEIF ( ( SELECT count(*) FROM tmp_tblTicketSla where  numMatches = 1 limit 1 ) > 0 ) THEN

			select TicketSlaID into v_TicketSlaID from tmp_tblTicketSla where  numMatches = 1 limit 1;

		END IF;


			-- if  no exact match found
		IF ( v_TicketSlaID is null ) THEN

				-- check for any match

					select sla.TicketSlaID  into v_TicketSlaID 
					from tblTicketSla sla
					inner join tblTicketSlaPolicyApplyTo pol on pol.TicketSlaID = sla.TicketSlaID
					where sla.CompanyID=p_CompanyID
					and
					(
						(pol.CompanyFilter = ''  OR (pol.CompanyFilter != '' and FIND_IN_SET(v_AccountID,pol.CompanyFilter) > 0 ))
						OR
						(pol.GroupFilter = ''  OR (pol.GroupFilter != '' and FIND_IN_SET(v_Group,pol.GroupFilter) > 0) )
						OR
						(pol.TypeFilter = '' OR (pol.TypeFilter != '' and FIND_IN_SET(v_Type,pol.TypeFilter) > 0) )
					) limit 1;

	  END IF;



END IF;

	--  select v_TicketSlaID;


	-- update v_TicketSlaID;

	/*UPDATE tblTickets
	SET  TicketSlaID = v_TicketSlaID
	WHERE TicketID = p_TicketID;
	*/

	IF ( v_TicketSlaID > 0 ) THEN

			
			-- ###########################################################
			
			SELECT
				(	CASE WHEN (tat.ResolveType = 'Minute') THEN
						DATE_ADD(t.created_at, INTERVAL tat.ResolveValue Minute)
					WHEN (ResolveType = 'Hour') THEN
						DATE_ADD(t.created_at, INTERVAL tat.ResolveValue Hour)
					WHEN (tat.ResolveType = 'Day') THEN
						DATE_ADD(t.created_at, INTERVAL tat.ResolveValue Day)
					WHEN (tat.ResolveType = 'Month') THEN
						DATE_ADD(t.created_at, INTERVAL tat.ResolveValue Month)
					END
			  ) as DueDate   into v_DueDate  
			FROM
				tblTickets t
			INNER join tblTicketSlaTarget tat on tat.TicketSlaID  = v_TicketSlaID AND tat.PriorityID = t.Priority
			WHERE
			t.TicketID = p_TicketID ;
			
			-- select v_DueDate;
			
			--	Resolve_in_min  
			SELECT
			   	CASE WHEN (tat.ResolveType = 'Minute') THEN
						(tat.ResolveValue) 
					WHEN (ResolveType = 'Hour') THEN
						 (tat.ResolveValue * 60)
					WHEN (tat.ResolveType = 'Day') THEN
						tat.ResolveValue * 60 * 24
					WHEN (tat.ResolveType = 'Month') THEN
						 (tat.ResolveValue*30*24*60)
					END
			  as Resolve_in_min into v_Resolve_in_min
			FROM
				tblTickets t
			INNER join tblTicketSlaTarget tat on tat.TicketSlaID  = v_TicketSlaID AND tat.PriorityID = t.Priority
			WHERE
			t.TicketID = p_TicketID ;
			
			-- select v_Resolve_in_min;
			 
			select OperationalHrs into v_OperationalHrs from tblTicketSlaTarget where TicketSlaID = v_TicketSlaID and PriorityID = v_PriorityID limit 1;
			
				-- OperationalHrs
				-- BusinessHours		  =		1;
				-- CalendarHours		  =		0;

	
		      -- CalendarHours  -- do nothing 
				-- 24x7 
					
			-- select v_OperationalHrs;
						
			IF (v_OperationalHrs = 1) THEN 	-- BusinessHours
			
					SELECT  GroupBusinessHours into v_GroupBusinessHours from  tblTicketGroups	where GroupID=v_Group limit 1;

					-- select v_GroupBusinessHours;
									
					
					IF v_GroupBusinessHours is null THEN
							-- take default business hours
						SELECT  ID into v_GroupBusinessHours  from tblTicketBusinessHours where CompanyID = p_CompanyID and  IsDefault = 1 limit 1;
											
					END IF;
					


					
					SELECT  HoursType into v_HoursType from  tblTicketBusinessHours	where ID=v_GroupBusinessHours;					

				-- select v_HoursType;

					-- HoursType
					-- HelpdeskHours247				=	1;
					-- HelpdeskHoursCustom				=	2;
					
					-- 24x7 do nothing
						
					-- not 24x7	
					IF v_HoursType = 2 THEN  
						
							-- if due day is off day or dueday timing is not betweek working days or (created or duedate is on holiday)
							IF ( 	
									( SELECT count(*) FROM tblTicketsWorkingDays WHERE BusinessHoursID = v_GroupBusinessHours and `Status` = 1 and `Day` = DAYOFWEEK(v_DueDate) ) = 0
									OR
									(SELECT count(*) FROM tblTicketsWorkingDays WHERE BusinessHoursID = v_GroupBusinessHours and `Status` = 1 and `Day` = DAYOFWEEK(v_DueDate) and TIME(v_DueDate) BETWEEN StartTime and EndTime) = 0 
  							  	   OR 
									(select count(*) from tblTicketBusinessHolidays where BusinessHoursID = v_GroupBusinessHours and ( (`HolidayDay` = DAY(v_created_at) and  HolidayMonth = Month(v_created_at) ) OR ( `HolidayDay` = DAY(v_DueDate) and  HolidayMonth = Month(v_DueDate) )  )  limit 1 ) = 1  
									
								) THEN 
 
 								-- 	select "logic ";
								
								--  logic here only ....
								 
								   SET @WorkingDays = (SELECT count(*) from tblTicketsWorkingDays WHERE BusinessHoursID = v_GroupBusinessHours and `Status` = 1 );
   
								   SET @v_date = DATE_FORMAT(v_created_at, '%Y-%m-%d %H:%i:00') ;  

								   SET @v_end_date = DATE_FORMAT(DATE_ADD(v_DueDate, INTERVAL 8 Day) , '%Y-%m-%d %H:%i:00'); -- this can be changed if holidays are added ... 
									
								 
									
								-- insert date range with status of working hours.
								
								-- select   @v_date , @v_end_date;
								 
								 	SET @v_min_counter = 0;
								 	
								 	-- SELECT v_GroupBusinessHours, @v_date , @v_end_date , v_DueDate, @v_min_counter , v_resolve_in_min ;
								 	
								   WHILE @v_date <= @v_end_date AND @v_min_counter <= v_resolve_in_min DO
								   
								   		
									   IF (select count(*) from tblTicketBusinessHolidays where BusinessHoursID = v_GroupBusinessHours and `HolidayDay` = DAY(@v_date) and  HolidayMonth = Month(@v_date)  limit 1) > 0  THEN
										
										   SET @v_Status  = 0;
										   
										   SET @v_date = DATE_ADD( date(@v_date), INTERVAL 1 Day );

										  --  SELECT @v_date  ,  @v_min_counter;
										   
										  
										ELSEIF (select count(*) from tblTicketsWorkingDays where BusinessHoursID = v_GroupBusinessHours and `Status` = 1 and `Day` = DAYOFWEEK(@v_date) and  Time(@v_date) between StartTime and EndTime limit 1) > 0 THEN
										
											SET @v_Status  = 1;
										 
										ELSEIF v_resolve_in_min >= 1440  and ( select count(*) from tblTicketsWorkingDays where BusinessHoursID = v_GroupBusinessHours and `Status` = 1 and `Day` = DAYOFWEEK(@v_date) limit 1) > 0 THEN
											-- when >= 1 day due time then take off time to consider 
											-- i.e. due in 2 day ,  creation date 2017-04-25 06:00:00  => due date =>2017-04-27 06:01:00
											SET @v_Status  = 1;
											
										ELSE 	
										
											SET @v_Status  = 0;
											
											
										   -- SELECT @v_date;
									
										END IF;
										
										
										IF ( @v_Status = 1) THEN
										
											-- only add time with enabled status
										 
											
											SET @v_min_counter =  @v_min_counter + 1;
										
										END IF ;
										
										SET @v_date = DATE_ADD(@v_date, INTERVAL 1 Minute);
										
								 END WHILE;
								 
								 
								-- select * from tmp_tblDimDate_;
								 
								-- select v_resolve_in_min;
								SET  v_DueDate = DATE_ADD(@v_date, INTERVAL -1 Minute); -- remove last min
								 
 								-- select v_DueDate;
 								
								-- ####################
								 
					 	
						END IF;
						
						  
						
					END IF;
					 
			
			END IF;
			
			 
			-- ###########################################################
			-- update v_TicketSlaID and v_DueDate;
		 

			-- update due dates which are not customized yet
			UPDATE tblTickets
 			SET   TicketSlaID = v_TicketSlaID,
					 DueDate =  v_DueDate
			WHERE
			 TicketID = p_TicketID AND 
			 CustomDueDate = 0;
			 



	END IF;



SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_checkCustomerCli`;

DELIMITER |
CREATE PROCEDURE `prc_checkCustomerCli`(
	IN `p_CompanyID` INT,
	IN `p_CustomerCLI` varchar(50)
)
BEGIN
     
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    SELECT AccountID
    FROM tblCLIRateTable 
    WHERE CompanyID = p_CompanyID AND  CLI = p_CustomerCLI;
    
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_CheckDueTickets`(
	IN `p_CompanyID` int,
	IN `p_currentDateTime` DATETIME,
	IN `P_Group` VARCHAR(50),
	IN `P_Agent` VARCHAR(50)
)
BEGIN
	DECLARE V_Status varchar(100);
	DECLARE V_OverDue int(11);
	DECLARE V_DueToday int(11);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET  sql_mode='';

	SELECT
		 group_concat(TFV.ValuesID separator ',') INTO V_Status FROM tblTicketfieldsValues TFV
	LEFT JOIN tblTicketfields TF
		ON TF.TicketFieldsID = TFV.FieldsID
	WHERE
		TF.FieldType = 'default_status' AND TFV.FieldValueAgent!='Closed' AND TFV.FieldValueAgent!='Resolved';

	 DROP TEMPORARY TABLE IF EXISTS tmp_tickets_sla_voilation_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tickets_sla_voilation_(
		TicketID int,
		TicketSlaID int,
		CreatedDate datetime,
		DueDate datetime,
		IsResolvedVoilation int
	);
		insert into tmp_tickets_sla_voilation_
		SELECT
			T.TicketID,
			T.TicketSlaID as TicketSlaID,
			T.created_at as CreatedDate,	  
		   T.DueDate,
		   T.ResolveSlaPolicyVoilationEmailStatus AS IsResolvedVoilation
		FROM
			tblTickets T
		LEFT JOIN tblTicketSlaTarget TST
			ON TST.TicketSlaID = T.TicketSlaID
		WHERE
			T.CompanyID = p_CompanyID
			AND TST.PriorityID = T.Priority
			AND (V_Status = '' OR find_in_set(T.`Status`,V_Status))
			AND (T.RespondSlaPolicyVoilationEmailStatus = 0 OR T.ResolveSlaPolicyVoilationEmailStatus = 0)
			AND T.TicketSlaID>0
			AND (P_Group = '' OR FIND_IN_SET(T.`Group`,P_Group))
			AND (P_Agent = '' OR FIND_IN_SET(T.`Agent`,P_Agent));


			UPDATE tmp_tickets_sla_voilation_ TSV SET
			TSV.IsResolvedVoilation  =
			CASE
				WHEN p_currentDateTime>=TSV.DueDate THEN 1 ELSE 0
			END;

			
			select count(*) as OverDue INTO V_OverDue from tmp_tickets_sla_voilation_ where IsResolvedVoilation >0;
			select count(*) as DueToday INTO V_DueToday from tmp_tickets_sla_voilation_ where IsResolvedVoilation >0 and DATE(p_currentDateTime) = DATE(DueDate);

			SELECT V_OverDue as OverDue,V_DueToday as DueToday;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_CheckTicketsSlaVoilation`(
	IN `p_CompanyID` int,
	IN `p_currentDateTime` DATETIME
)
BEGIN
	DECLARE P_Status varchar(100);
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET  sql_mode='';
	
	SELECT 
		 group_concat(TFV.ValuesID separator ',') INTO P_Status FROM tblTicketfieldsValues TFV 
	LEFT JOIN tblTicketfields TF 
		ON TF.TicketFieldsID = TFV.FieldsID
	WHERE 
		TF.FieldType = 'default_status' AND TFV.FieldValueAgent!='Closed' AND TFV.FieldValueAgent!='Resolved';
				
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
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))
			AND (T.RespondSlaPolicyVoilationEmailStatus = 0 OR T.ResolveSlaPolicyVoilationEmailStatus = 0)
			AND T.TicketSlaID>0;		
	
	    	/*UPDATE tmp_tickets_sla_voilation_ TSV
	    	SET TSV.RespondEmailTime = 
			CASE WHEN
			exists
				 (SELECT AE.created_at FROM AccountEmailLog AE  
		    	WHERE AE.TicketID = TSV.TicketID AND AE.EmailParent >  0 AND 
				AE.AccountID is null AND AE.ContactID is null  AND AE.UserID > 0
				order by AE.AccountEmailLogID desc limit 1) 
		   THEN 
				(SELECT AE.created_at FROM AccountEmailLog AE  
		    	WHERE AE.TicketID = TSV.TicketID AND AE.EmailParent >  0 AND 
				AE.AccountID is null AND AE.ContactID is null  AND AE.UserID > 0
				order by AE.AccountEmailLogID desc limit 1)
			 ELSE p_currentDateTime
			end;*/
			
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
		
			
			/*SELECT TicketID,IsResolvedVoilation,IsRespondedVoilation,EscalationEmail FROM tmp_tickets_sla_voilation_;*/
			
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountDiscountPlan`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_Type` INT,
	IN `p_ServiceID` INT
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
		AND Type = p_Type;
	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetAccounts`;

DELIMITER |
CREATE PROCEDURE `prc_GetAccounts`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_IsVendor` int ,
	IN `p_isCustomer` int ,
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
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

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
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
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
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
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
			CONCAT(tblUser.FirstName,' ',tblUser.LastName) as 'Account Owner'
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
			AND ((p_AccountNo = '' OR tblAccount.Number LIKE p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName LIKE Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR tblCLIRateTable.CLI LIKE CONCAT('%',p_IPCLI,'%') OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags LIKE Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) LIKE CONCAT('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_getAccountService`(
	IN `p_AccountID` INT,
	IN `p_ServiceID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT
		tblAccountService.*
	FROM tblAccountService
	LEFT JOIN tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccountService.AccountID AND tblAccountBilling.ServiceID =  tblAccountService.ServiceID
	WHERE tblAccountService.AccountID = p_AccountID
	AND Status = 1
	AND ( (p_ServiceID = 0 AND tblAccountBilling.ServiceID IS NULL) OR  tblAccountBilling.ServiceID = p_ServiceID);
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountTimeLine`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountTimeLine`(
	IN `p_AccountID` INT,
	IN `p_CompanyID` INT,
	IN `p_TicketType` INT,
	IN `p_GUID` VARCHAR(100),
	IN `p_Time` DATE,
	IN `p_Start` INT,
	IN `p_RowspPage` INT


)
BEGIN
DECLARE v_OffSet_ int;
DECLARE v_ActiveSupportDesk int;
DECLARE v_contacts_ids varchar(200);
DECLARE v_contacts_emails varchar(200);
DECLARE v_account_emails varchar(200);
DECLARE v_account_contacts_emails varchar(300);

SET v_OffSet_ = p_Start;
SET sql_mode = 'ALLOW_INVALID_DATES';

/*delete 2 days old records*/
if(p_Start>0)
THEN
	DELETE FROM tbl_Account_Contacts_Activity  WHERE  `TableCreated_at` < DATE_SUB(p_Time, INTERVAL 2 DAY);
END IF;
if(p_Start= 0)
THEN
		/*storing contact ids and email addresses*/
		SELECT 
			group_concat(CC.ContactID separator ',')
		FROM
			tblContact CC
		WHERE 
			CC.Owner = p_AccountID	INTO v_contacts_ids;
			
		SELECT 
			group_concat(DISTINCT CC.Email separator ',')
		FROM
			tblContact CC
		WHERE 
			CC.Owner = p_AccountID	INTO v_contacts_emails;
			
		/*storing account emails*/	
		SELECT 
		(CASE WHEN tac.Email = tac.BillingEmail THEN tac.Email ELSE concat(tac.Email,',',tac.BillingEmail) END) 
		FROM
			tblAccount tac
		WHERE 
			tac.AccountID = p_AccountID	INTO v_contacts_emails;	
		/*combining account and contacts emails*/
		select concat(v_contacts_emails,',',v_contacts_emails) into v_account_contacts_emails;


		/*SELECT
			count(*) INTO v_ActiveSupportDesk 
		FROM 
			`tblIntegration`
		INNER JOIN 
			`tblIntegrationConfiguration` on
			`tblIntegrationConfiguration`.`IntegrationID` = `tblIntegration`.`IntegrationID` 
		WHERE
			(`tblIntegration`.`CompanyID` = p_CompanyID) AND
			(`tblIntegration`.`ParentID` = '1') AND
			(`tblIntegrationConfiguration`.`Status` = '1') 
			LIMIT 1;
		*/	
			
			/*tasks start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
				SELECT 
				1 as Timeline_type,
				t.Subject,
				  concat(u.FirstName,' ',u.LastName) as Name,		
				 case when t.Priority =1
					  then 'High'
					  else
					   'Low' end  as Priority,
					DueDate,
				t.Description,
				bc.BoardColumnName as TaskStatus,
				t.Task_type,
				t.TaskID,
				'' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,0 as NoteID,'' as Note ,
				0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,
				t.CreatedBy,t.created_at, t.updated_at,p_GUID as GUID,p_Time as TableCreated_at
			FROM tblTask t
			INNER JOIN tblCRMBoardColumn bc on  t.BoardColumnID = bc.BoardColumnID	
			JOIN tblUser u on  u.UserID = t.UsersIDs		
			WHERE t.AccountIDs = p_AccountID and t.CompanyID =p_CompanyID;
			/*tasks end*/
			
			
			/*emails start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 2 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus,0 as Task_type,0 as TaskID, Emailfrom, EmailTo,	
			case when concat(tu.FirstName,' ',tu.LastName) IS NULL or concat(tu.FirstName,' ',tu.LastName) = ''
					then ael.EmailTo
					else concat(tu.FirstName,' ',tu.LastName)
			   end as EmailToName, 
			Subject,Message,Cc,Bcc,AttachmentPaths as EmailAttachments,AccountEmailLogID,0 as NoteID,'' as Note ,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,ael.CreatedBy,ael.created_at, ael.updated_at,p_GUID as GUID,p_Time as TableCreated_at
			from `AccountEmailLog` ael
			left JOIN tblUser tu
				ON tu.EmailAddress = ael.EmailTo
			where ael.CompanyID = p_CompanyID AND ((ael.AccountID = p_AccountID) OR (FIND_IN_SET(ael.ContactID,(v_contacts_ids)) ))			
			and ael.EmailParent=0 and ael.TicketID = 0
			/*not Exists (SELECT 1 FROM tblTickets t where t.AccountEmailLogID = ael.AccountEmailLogID) */			 
			order by ael.created_at desc;
			/*emails end*/
			
			/*nots start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblNote` 
			where (`CompanyID` = p_CompanyID and `AccountID` = p_AccountID and TicketID =0) order by created_at desc;
			
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `ContactNoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblContactNote` where (`CompanyID` = p_CompanyID and FIND_IN_SET(ContactID,(v_contacts_ids)))  order by created_at desc;
			/*notes end*/
			
			/*tickets start*/
			/*IF v_ActiveSupportDesk=1*/
				
			IF p_TicketType=2 /*FRESH DESK TICKETS*/
			THEN
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 4 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
			TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at,p_GUID as GUID,p_Time as TableCreated_at 
			from 
				`tblHelpDeskTickets` TAT 
			where 
				(TAT.`CompanyID` = p_CompanyID and TAT.`AccountID` = p_AccountID and TAT.GUID = p_GUID);
			END IF;

			IF p_TicketType=1 /*SYSTEM TICKETS*/
			THEN
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
				select 4 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
				TT.TicketID,TT.Subject as 	TicketSubject,	TFV.FieldValueAgent  as	TicketStatus,	TT.Requester as 	RequestEmail,TP.PriorityValue as TicketPriority,	TFVV.FieldValueAgent as 	TicketType,	TG.GroupName as TicketGroup,	TT.`Description` as TicketDescription,TT.created_by,TT.created_at,TT.updated_at,p_GUID as GUID,p_Time as TableCreated_at 
			from 
				`tblTickets` TT
			LEFT JOIN tblTicketfieldsValues TFV
				ON TFV.ValuesID = TT.Status		
			LEFT JOIN tblTicketPriority TP
				ON TP.PriorityID = TT.Priority
			LEFT JOIN tblTicketGroups TG
				ON TG.GroupID = TT.`Group`
			LEFT JOIN tblTicketfieldsValues TFVV
				ON TFVV.ValuesID = TT.Type
			/*LEFT JOIN tblAccount TA
				ON TA.Email = TT.Requester	
			LEFT JOIN tblAccount TAT
				ON TAT.BillingEmail = TT.Requester	
			LEFT JOIN tblContact TC
				ON TC.Email = TT.Requester	*/
			where 			
				TT.`CompanyID` = p_CompanyID and 
			/*(((TA.`AccountID` = p_AccountID) OR (TAT.`AccountID` = p_AccountID) ) OR (TC.ContactID IN (v_contacts_ids)))*/
			FIND_IN_SET(TT.Requester,(v_account_contacts_emails));	
			END IF;
			/*tickets end*/
END IF;
	select * from tbl_Account_Contacts_Activity where GUID = p_GUID order by created_at desc LIMIT p_RowspPage OFFSET v_OffSet_ ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetAjaxResourceList`;

DELIMITER |
CREATE PROCEDURE `prc_GetAjaxResourceList`(
	IN `p_CompanyID` INT,
	IN `p_userid` LONGTEXT,
	IN `p_roleids` LONGTEXT,
	IN `p_action` int
)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF p_action = 1
    THEN

        select distinct tblResourceCategories.ResourceCategoryID,tblResourceCategories.ResourceCategoryName,tblResourceCategories.CategoryGroupID,usrper.AddRemove,rolres.Checked
			from tblResourceCategories
			LEFT OUTER JOIN(
			select distinct rs.ResourceID, rs.ResourceName,usrper.AddRemove
			from tblResource rs
			inner join tblUserPermission usrper on usrper.resourceID = rs.ResourceID and FIND_IN_SET(usrper.UserID ,p_userid) != 0 ) usrper
			on usrper.ResourceID = tblResourceCategories.ResourceCategoryID
			LEFT OUTER JOIN(
			select distinct res.ResourceID, res.ResourceName,'true' as Checked
			from `tblResource` res
			inner join `tblRolePermission` rolper on rolper.resourceID = res.ResourceID and FIND_IN_SET(rolper.roleID ,p_roleids) != 0) rolres
			on rolres.ResourceID = tblResourceCategories.ResourceCategoryID
			where tblResourceCategories.CompanyID= p_CompanyID order by rolres.Checked desc,usrper.AddRemove desc,tblResourceCategories.ResourceCategoryName;


	END IF;

	IF p_action = 2
	THEN

		select  distinct `tblResourceCategories`.`ResourceCategoryID`, `tblResourceCategories`.`ResourceCategoryName`,tblResourceCategories.CategoryGroupID, tblRolePermission.resourceID as Checked ,case when tblRolePermission.resourceID>0
	 then
		1
     else
	    0
     end as check2
		from tblResourceCategories left join tblRolePermission on `tblRolePermission`.`resourceID` = `tblResourceCategories`.`ResourceCategoryID`
		and `tblRolePermission`.`CompanyID` = p_CompanyID and FIND_IN_SET(`tblRolePermission`.`roleID`,p_roleids) != 0
		order by
		case when tblRolePermission.resourceID>0
	 then
		1
     else
	    0
     end
	  desc,`tblResourceCategories`.`ResourceCategoryName` asc;


	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_getBillingAccounts`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATE,
	IN `p_skip_accounts` TEXT

)
BEGIN
   
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

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
	AND tblAccountBilling.BillingCycleType IS NOT NULL 
	AND FIND_IN_SET(tblAccount.AccountID,p_skip_accounts) = 0	
	ORDER BY tblAccount.AccountID ASC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetBlockUnblockAccount`;

DELIMITER |
CREATE PROCEDURE `prc_GetBlockUnblockAccount`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT
		DISTINCT
		a.AccountID,
		a.Number,
		a.AccountName,
		(COALESCE(ab.BalanceAmount,0) - COALESCE(ab.PermanentCredit,0)) as Balance,
		IF((COALESCE(ab.BalanceAmount,0) - COALESCE(ab.PermanentCredit,0)) > 0 AND a.`Status` = 1 ,1,0) as BlockStatus,
		a.`Status`,
		a.BillingEmail,
		a.Blocked
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN RMBilling3.tblGatewayAccount ga
		ON ga.AccountID = a.AccountID
	WHERE a.CompanyId = p_CompanyID
	AND a.AccountType = 1
	AND ( p_CompanyGatewayID = 0 OR ga.CompanyGatewayID = p_CompanyGatewayID)
	ORDER BY BlockStatus,a.AccountID;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getContactTimeLine`;

DELIMITER |
CREATE PROCEDURE `prc_getContactTimeLine`(
	IN `p_ContactID` INT,
	IN `p_CompanyID` INT,
	IN `p_TicketType` INT,
	IN `p_GUID` VARCHAR(100),
	IN `p_Start` INT,
	IN `p_RowspPage` INT



)
BEGIN
DECLARE v_OffSet_ int;
DECLARE v_ActiveSupportDesk int;
SET v_OffSet_ = p_Start;
SET sql_mode = 'ALLOW_INVALID_DATES';
/*SELECT
	count(*) INTO v_ActiveSupportDesk 
FROM 
	`tblIntegration`
INNER JOIN 
	`tblIntegrationConfiguration` on
	`tblIntegrationConfiguration`.`IntegrationID` = `tblIntegration`.`IntegrationID` 
WHERE
	(`tblIntegration`.`CompanyID` = p_CompanyID) AND
	(`tblIntegration`.`ParentID` = '1') AND
	(`tblIntegrationConfiguration`.`Status` = '1') 
	LIMIT 1;
*/	
	DROP TEMPORARY TABLE IF EXISTS tmp_actvity_timeline_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_actvity_timeline_(
		`Timeline_type` int(11),		
		Emailfrom varchar(50),
		EmailTo varchar(50),
		EmailToName varchar(50),
		EmailSubject varchar(200),
		EmailMessage LONGTEXT,
		EmailCc varchar(500),
		EmailBcc varchar(500),
		EmailAttachments LONGTEXT,
		AccountEmailLogID int(11),
	    NoteID int(11),
		Note longtext,		
		TicketID int(11),
		TicketSubject varchar(200),
		TicketStatus varchar(100),
		RequestEmail varchar(100),
		TicketPriority varchar(100),
		TicketType varchar(100),
		TicketGroup varchar(100),
		TicketDescription LONGTEXT,		
		CreatedBy varchar(50),
		created_at datetime,
		updated_at datetime		
	);
	
	/*INSERT INTO tmp_actvity_timeline_	
		SELECT 
		1 as Timeline_type,
		'' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,0 as NoteID,'' as Note ,
		0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,
		t.CreatedBy,t.created_at, t.updated_at
	FROM tblTask t
	INNER JOIN tblCRMBoardColumn bc on  t.BoardColumnID = bc.BoardColumnID	
	JOIN tblUser u on  u.UserID = t.UsersIDs		
	WHERE t.AccountIDs = p_AccountID and t.CompanyID =p_CompanyID;*/	
	
	
	INSERT INTO tmp_actvity_timeline_
	select 2 as Timeline_type, Emailfrom, EmailTo,	
	case when concat(tu.FirstName,' ',tu.LastName) IS NULL or concat(tu.FirstName,' ',tu.LastName) = ''
            then ael.EmailTo
            else concat(tu.FirstName,' ',tu.LastName)
       end as EmailToName, 
	Subject,Message,Cc,Bcc,AttachmentPaths as EmailAttachments,AccountEmailLogID,0 as NoteID,'' as Note ,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,ael.CreatedBy,ael.created_at, ael.updated_at 
	from `AccountEmailLog` ael
	left JOIN tblUser tu
		ON tu.EmailAddress = ael.EmailTo
	where 
	ael.ContactID = p_ContactID and
	ael.CompanyID = p_CompanyID and 
	ael.UserType=1 and
	ael.EmailParent=0 and
	/*ael.AccountEmailLogID NOT IN (SELECT AccountEmailLogID FROM tblTickets)*/
	/*not Exists (SELECT 1 FROM tblTickets t where t.AccountEmailLogID = ael.AccountEmailLogID)*/
	ael.TicketID = 0
	order by ael.created_at desc;
	
	INSERT INTO tmp_actvity_timeline_
	select 3 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at 
	from `tblContactNote` where (`CompanyID` = p_CompanyID and `ContactID` = p_ContactID) order by created_at desc;
	/*IF v_ActiveSupportDesk=1*/

	IF p_TicketType=2 /*FRESH DESK TICKETS*/
	THEN
	INSERT INTO tmp_actvity_timeline_
	select 4 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
	TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at from `tblHelpDeskTickets` TAT where (TAT.`CompanyID` = p_CompanyID and TAT.`ContactID` = p_ContactID and TAT.GUID = p_GUID);
	END IF;

	IF p_TicketType=1 /*SYSTEM TICKETS*/
	THEN
	INSERT INTO tmp_actvity_timeline_
		select 4 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
		TT.TicketID,TT.Subject as 	TicketSubject,	TFV.FieldValueAgent  as	TicketStatus,	TT.Requester as 	RequestEmail,TP.PriorityValue as TicketPriority,	TFVV.FieldValueAgent as 	TicketType,	TG.GroupName as TicketGroup,	TT.`Description` as TicketDescription,TT.created_by,TT.created_at,TT.updated_at 
	from 
		`tblTickets` TT
	LEFT JOIN tblTicketfieldsValues TFV
		ON TFV.ValuesID = TT.Status		
	LEFT JOIN tblTicketPriority TP
		ON TP.PriorityID = TT.Priority
	LEFT JOIN tblTicketGroups TG
		ON TG.GroupID = TT.`Group`
	LEFT JOIN tblTicketfieldsValues TFVV
		ON TFVV.ValuesID = TT.Type
	LEFT JOIN tblContact TC
		ON TC.Email = TT.Requester		
	where 			
		(TT.`CompanyID` = p_CompanyID and TC.`ContactID` = p_ContactID);	
	END IF;
	
	select * from tmp_actvity_timeline_ order by created_at desc LIMIT p_RowspPage OFFSET v_OffSet_ ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesManager`;

DELIMITER |
CREATE PROCEDURE `prc_GetCrmDashboardSalesManager`(
	IN `p_CompanyID` INT,
	IN `p_OwnerID` VARCHAR(500),
	IN `p_CurrencyID` INT,
	IN `p_ListType` VARCHAR(50),
	IN `p_Start` DATETIME,
	IN `p_End` DATETIME
)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ INT;

	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_invoices_(
		AssignedUserText VARCHAR(100),
		AssignedUserID INT,
		Revenue decimal(18,8),
		`Year` INT,
		`Month` INT,
		`Week` INT
	);

	INSERT INTO tmp_Dashboard_invoices_
	SELECT
		CONCAT(tu.FirstName,' ',tu.LastName) AS `AssignedUserText`,
		 tu.UserID AS  AssignedUserID,
		sum(`inv`.`GrandTotal`) AS `Revenue`,
		YEAR(inv.IssueDate) AS Year,
		MONTH(inv.IssueDate) AS Month,
		WEEK(inv.IssueDate)	 AS `Week`
	FROM RMBilling3.tblInvoice inv
	Inner JOIN tblAccount ac 
		ON ac.AccountID = inv.AccountID 
	INNER JOIN tblUser tu 
		ON tu.UserID = ac.Owner
	WHERE
		ac.`Status` = 1
	AND tu.`Status` = 1 		
	AND (p_CurrencyID = '' OR ( p_CurrencyID !=''  AND ac.CurrencyId = p_CurrencyID))
	AND ac.CompanyID = p_CompanyID
	AND (p_OwnerID = '' OR   FIND_IN_SET(tu.UserID,p_OwnerID))
	AND `inv`.`InvoiceType` = 1
	AND `inv`.GrandTotal != 0
	AND (inv.IssueDate BETWEEN p_Start AND p_End)
	GROUP BY
		YEAR(inv.IssueDate) 
		,MONTH(inv.IssueDate)
		,WEEK(inv.IssueDate)
		,CONCAT(tu.FirstName,' ',tu.LastName)
		,tu.UserID;
			
	IF p_ListType = 'Monthly'
	THEN

		SELECT	
			td.AssignedUserText AS AssignedUserText,
			td.AssignedUserID AS AssignedUserID,
			ROUND(sum(td.Revenue),v_Round_) AS Revenue,
			v_CurrencyCode_,
			CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName,
			v_Round_ AS round_number
		FROM tmp_Dashboard_invoices_  td
		GROUP BY 
			td.Month,
			td.Year,
			td.AssignedUserID,
			td.AssignedUserText;

	END IF;

	IF p_ListType = 'Weekly'
	THEN
		SELECT	
			td.AssignedUserText AS AssignedUserText,
			td.AssignedUserID,
			ROUND(sum(td.Revenue),v_Round_) AS Revenue,
			v_CurrencyCode_,
			CONCAT(td.`Week`,'-',MAX( td.Year)) AS `Week`,
			MAX( td.Year) AS `Year`,
			td.`Week` AS `Weekday`,
			v_Round_ AS round_number
		FROM  tmp_Dashboard_invoices_  td 
		GROUP BY
			td.`Week`
			,td.AssignedUserText
			,td.AssignedUserID
		ORDER BY
			`Year`,
			`Weekday` ASC;
	END IF;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesUser`;

DELIMITER |
CREATE PROCEDURE `prc_GetCrmDashboardSalesUser`(
	IN `p_CompanyID` INT,
	IN `p_OwnerID` VARCHAR(500),
	IN `p_CurrencyID` INT,
	IN `p_ListType` VARCHAR(50),
	IN `p_Start` DATETIME,
	IN `p_End` VARCHAR(50),
	IN `p_WeekOrMonth` INT,
	IN `p_Year` INT
)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ int;

	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_user_invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_user_invoices_(
		AssignedUserText varchar(100),
		Revenue decimal(18,8)
	);

	INSERT INTO tmp_Dashboard_user_invoices_
	SELECT
		ac.AccountName  AS `AssignedUserText`,
		SUM(`inv`.`GrandTotal`) AS `Revenue`
	FROM RMBilling3.tblInvoice inv
	INNER JOIN  tblAccount ac 
		ON ac.AccountID = inv.AccountID
	INNER JOIN tblUser tu 
		ON tu.UserID = ac.Owner
	WHERE
		ac.`Status` = 1
	AND tu.`Status` = 1
	AND (p_CurrencyID = '' OR ( p_CurrencyID !=''  AND ac.CurrencyId = p_CurrencyID))
	AND ac.CompanyID = p_CompanyID
	AND (p_OwnerID = '' OR   FIND_IN_SET(tu.UserID,p_OwnerID))
	AND `inv`.`InvoiceType` = 1
	AND (inv.IssueDate BETWEEN p_Start AND p_End)
	AND (( p_ListType = 'Weekly' AND WEEK(inv.IssueDate) = p_WeekOrMonth AND YEAR(inv.IssueDate) = p_Year) OR ( p_ListType = 'Monthly' AND MONTH(inv.IssueDate) = p_WeekOrMonth AND YEAR(inv.IssueDate) = p_Year))
	GROUP BY
		ac.AccountName;

	SELECT	
		td.AssignedUserText,
		ROUND(td.Revenue,v_Round_) AS Revenue,
		v_CurrencyCode_ AS CurrencyCode,
		v_Round_ AS round_number
	FROM  tmp_Dashboard_user_invoices_  td;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getCustomerCodeRate`;

DELIMITER |
CREATE PROCEDURE `prc_getCustomerCodeRate`(
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_RateTableID` INT

)
BEGIN
	DECLARE v_codedeckid_ INT;
	DECLARE v_ratetableid_ INT;
	
	IF p_RateTableID > 0
	THEN

		SELECT
			CodeDeckId,
			RateTableId
		INTO  
			v_codedeckid_, 
			v_ratetableid_
		FROM tblRateTable
		WHERE RateTableId = p_RateTableID;
	
	ELSE

		SELECT
			CodeDeckId,
			RateTableID
		INTO  
			v_codedeckid_, 
			v_ratetableid_
		FROM tblCustomerTrunk
		WHERE tblCustomerTrunk.TrunkID = p_trunkID
		AND tblCustomerTrunk.AccountID = p_AccountID
		AND tblCustomerTrunk.Status = 1;
	
	END IF;

	

	IF p_RateCDR = 0
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
		CREATE TEMPORARY TABLE tmp_codes_ (
			RateID INT,
			Code VARCHAR(50),
			INDEX tmp_codes_RateID (`RateID`),
			INDEX tmp_codes_Code (`Code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_codes2_;
		CREATE TEMPORARY TABLE tmp_codes2_ (
			RateID INT,
			Code VARCHAR(50),
			INDEX tmp_codes2_RateID (`RateID`),
			INDEX tmp_codes2_Code (`Code`)
		);
	
		INSERT INTO tmp_codes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code
		FROM tblRate
		INNER JOIN tblCustomerRate
		ON tblCustomerRate.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND CustomerID = p_AccountID
		AND tblCustomerRate.TrunkID = p_trunkID
		AND tblCustomerRate.EffectiveDate <= NOW();
	
		INSERT INTO tmp_codes2_ 
		SELECT * FROM tmp_codes_;
		
		INSERT INTO tmp_codes_
		SELECT
			DISTINCT
			tblRate.RateID,
			tblRate.Code
		FROM tblRate
		INNER JOIN tblRateTableRate
			ON tblRateTableRate.RateID = tblRate.RateID
		LEFT JOIN  tmp_codes2_ c ON c.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND RateTableID = v_ratetableid_
		AND c.RateID IS NULL
		AND tblRateTableRate.EffectiveDate <= NOW();

	END IF;
	
	IF p_RateCDR = 1
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
		CREATE TEMPORARY TABLE tmp_codes_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_codes_RateID (`RateID`),
			INDEX tmp_codes_Code (`Code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_codes2_;
		CREATE TEMPORARY TABLE tmp_codes2_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_codes2_RateID (`RateID`),
			INDEX tmp_codes2_Code (`Code`)
		);
	
		INSERT INTO tmp_codes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblCustomerRate.Rate,
			tblCustomerRate.ConnectionFee,
			tblCustomerRate.Interval1,
			tblCustomerRate.IntervalN
		FROM tblRate
		INNER JOIN tblCustomerRate
		ON tblCustomerRate.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND CustomerID = p_AccountID
		AND tblCustomerRate.TrunkID = p_trunkID
		AND tblCustomerRate.EffectiveDate <= NOW();
	
		INSERT INTO tmp_codes2_ 
		SELECT * FROM tmp_codes_;
		
		INSERT INTO tmp_codes_
		SELECT
			DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblRateTableRate.Rate,
			tblRateTableRate.ConnectionFee,
			tblRateTableRate.Interval1,
			tblRateTableRate.IntervalN
		FROM tblRate
		INNER JOIN tblRateTableRate
			ON tblRateTableRate.RateID = tblRate.RateID
		LEFT JOIN  tmp_codes2_ c ON c.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND RateTableID = v_ratetableid_
		AND c.RateID IS NULL
		AND tblRateTableRate.EffectiveDate <= NOW();

		/* if Specify Rate is set when cdr rerate */
		IF p_RateMethod = 'SpecifyRate'
		THEN
		
			UPDATE tmp_codes_ SET Rate=p_SpecifyRate;
			
		END IF;

	END IF;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getCustomerInboundRate`;

DELIMITER |
CREATE PROCEDURE `prc_getCustomerInboundRate`(
	IN `p_AccountID` INT,
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_CLD` VARCHAR(500),
	IN `p_InboundTableID` INT
)
BEGIN

	DECLARE v_inboundratetableid_ INT;

	IF p_CLD != ''
	THEN
		
		SELECT
			RateTableID INTO v_inboundratetableid_
		FROM tblCLIRateTable
		WHERE AccountID = p_AccountID AND CLI = p_CLD;
		
	ELSEIF p_InboundTableID > 0
	THEN 
		
		SET v_inboundratetableid_ = p_InboundTableID;

	ELSE
		
		SELECT
			InboudRateTableID INTO v_inboundratetableid_
		FROM tblAccount
		WHERE AccountID = p_AccountID;
	
	END IF;
	
	IF p_RateCDR = 1
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_inboundcodes_;
		CREATE TEMPORARY TABLE tmp_inboundcodes_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_inboundcodes_RateID (`RateID`),
			INDEX tmp_inboundcodes_Code (`Code`)
		);
		INSERT INTO tmp_inboundcodes_
		SELECT
			DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblRateTableRate.Rate,
			tblRateTableRate.ConnectionFee,
			tblRateTableRate.Interval1,
			tblRateTableRate.IntervalN
		FROM tblRate
		INNER JOIN tblRateTableRate
			ON tblRateTableRate.RateID = tblRate.RateID
		WHERE RateTableID = v_inboundratetableid_
		AND tblRateTableRate.EffectiveDate <= NOW();
		
		/* if Specify Rate is set when cdr rerate */
		IF p_RateMethod = 'SpecifyRate'
		THEN
		
			UPDATE tmp_inboundcodes_ SET Rate=p_SpecifyRate;
			
		END IF;

	END IF;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetSystemTicket`(
	IN `p_CompanyID` int,
	IN `p_Search` VARCHAR(100),
	IN `P_Status` VARCHAR(100),
	IN `P_Priority` VARCHAR(100),
	IN `P_Group` VARCHAR(100),
	IN `P_Agent` VARCHAR(100),
	IN `P_DueBy` VARCHAR(50),
	IN `P_CurrentDate` DATETIME,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	DECLARE v_Groups_ varchar(200);
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_isExport = 0
	THEN	
		SELECT 
			T.TicketID,
			T.Subject,
			/*CASE WHEN (ISNULL(T.RequesterName) OR T.RequesterName='')  THEN T.Requester ElSE concat(T.RequesterName," (",T.Requester,")") END as Requester,*/
			/*IFNULL(IFNULL((select AccountName from tblAccount TACC where 	TACC.Email = T.Requester or TACC.BillingEmail =T.Requester limit 1),(select CONCAT(TA.FirstName,' ',TA.LastName) from tblContact TA where 	TA.Email = T.Requester  limit 1)),CASE WHEN (ISNULL(T.RequesterName) OR T.RequesterName='')  THEN T.Requester ElSE concat(T.RequesterName," (",T.Requester,")") END) AS Requester,				*/
  CASE   	
 	 WHEN T.AccountID>0   THEN     (SELECT CONCAT(IFNULL(TAA.AccountName,''),' (',T.Requester,')') FROM tblAccount TAA WHERE TAA.AccountID = T.AccountID  ) 
  	 WHEN T.ContactID>0   THEN     (select CONCAT(IFNULL(TCCC.FirstName,''),' ',IFNULL(TCCC.LastName,''),' (',T.Requester,')') FROM tblContact TCCC WHERE TCCC.ContactID = T.ContactID) 
     WHEN T.UserID>0      THEN  	 (select CONCAT(IFNULL(TUU.FirstName,''),' ',IFNULL(TUU.LastName,''),' (',T.Requester,')') FROM tblUser TUU WHERE TUU.UserID = T.UserID )  
    ELSE CONCAT(T.RequesterName,' (',T.Requester,')')
  END AS Requester,
			T.Requester as RequesterEmail,		
			TFV.FieldValueAgent  as TicketStatus,
			TP.PriorityValue,
			concat(TU.FirstName,' ',TU.LastName) as Agent,
			TG.GroupName,			
			T.created_at,
			/*(select tc.Emailfrom from AccountEmailLog tc where tc.TicketID = T.TicketID  and tc.EmailCall =1 order by tc.AccountEmailLogID desc limit 1) as CustomerResponse,			*/
			(select tc.created_at from AccountEmailLog tc where tc.TicketID = T.TicketID  and tc.EmailCall =1 and tc.EmailParent>0 order by tc.AccountEmailLogID desc limit 1) as CustomerResponse,
		    (select tc.created_at from AccountEmailLog tc where tc.TicketID = T.TicketID  and tc.EmailCall =0  order by tc.AccountEmailLogID desc limit 1) as AgentResponse,	
			(select TAC.AccountID from tblAccount TAC where 	TAC.Email = T.Requester or TAC.BillingEmail =T.Requester limit 1) as ACCOUNTID,
			T.`Read` as `Read`,
			T.TicketSlaID,
			T.DueDate,
			T.updated_at,
         T.Status,
         T.AgentRepliedDate,
         T.CustomerRepliedDate
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND (
					P_DueBy = '' OR
					(  P_DueBy != '' AND
						(
							   (find_in_set('Today',P_DueBy) AND DATE(T.DueDate) = DATE(P_CurrentDate))
							OR (find_in_set('Tomorrow',P_DueBy) AND DATE(T.DueDate) =  DATE(DATE_ADD(P_CurrentDate, INTERVAL 1 Day)))
							OR (find_in_set('Next_8_hours',P_DueBy) AND T.DueDate BETWEEN P_CurrentDate AND DATE_ADD(P_CurrentDate, INTERVAL 8 Hour))
							OR (find_in_set('Overdue',P_DueBy) AND P_CurrentDate >=  T.DueDate )
						)
					)	
				)
			
			/*AND ((p_AccessPermission = 1) OR (p_AccessPermission=2 and find_in_set(T.`Group`,v_Groups_)) OR (p_AccessPermission=3 and find_in_set(T.`Agent`,p_User)))		*/
			ORDER BY		
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectASC') THEN T.Subject
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectDESC') THEN T.Subject
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN TicketStatus
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN TicketStatus
			END DESC,	
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AgentASC') THEN TU.FirstName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AgentDESC') THEN TU.FirstName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN T.created_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN T.created_at
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN T.updated_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN T.updated_at
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RequesterASC') THEN T.Requester
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RequesterDESC') THEN T.Requester
			END DESC
			LIMIT
				p_RowspPage OFFSET v_OffSet_;
		
		SELECT 
			COUNT(*) AS totalcount
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND ((P_DueBy = '' 
			OR (find_in_set('Today',P_DueBy) AND DATE(T.DueDate) = DATE(P_CurrentDate)))
			OR (find_in_set('Tomorrow',P_DueBy) AND DATE(T.DueDate) =  DATE(DATE_ADD(P_CurrentDate, INTERVAL 1 Day)))
			OR (find_in_set('Next_8_hours',P_DueBy) AND T.DueDate BETWEEN P_CurrentDate AND DATE_ADD(P_CurrentDate, INTERVAL 8 Hour))
			OR (find_in_set('Overdue',P_DueBy) AND P_CurrentDate >=  T.DueDate));

	SELECT 
			DISTINCT(TG.GroupID),
			TG.GroupName
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND ((P_DueBy = '' 
			OR (find_in_set('Today',P_DueBy) AND DATE(T.DueDate) = DATE(P_CurrentDate)))
			OR (find_in_set('Tomorrow',P_DueBy) AND DATE(T.DueDate) =  DATE(DATE_ADD(P_CurrentDate, INTERVAL 1 Day)))
			OR (find_in_set('Next_8_hours',P_DueBy) AND T.DueDate BETWEEN P_CurrentDate AND DATE_ADD(P_CurrentDate, INTERVAL 8 Hour))
			OR (find_in_set('Overdue',P_DueBy) AND P_CurrentDate >=  T.DueDate ) );			
		/*select v_OffSet_,p_RowspPage;*/		
	END IF;
	IF p_isExport = 1	
	THEN
	SELECT 
			T.TicketID,
			T.Subject,
			T.Requester,
			T.RequesterCC as 'CC',									
			TFV.FieldValueAgent  as 'Status',
			TP.PriorityValue as 'Priority',			
			concat(TU.FirstName,' ',TU.LastName) as Agent,
			T.created_at as 'Date Created',
			TG.GroupName as 'Group'
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
		LEFT JOIN tblContact TCC
			ON TCC.Email = T.`Requester`
			
		WHERE   
			T.CompanyID = p_CompanyID			
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND ((P_DueBy = '' 
			OR (find_in_set('Today',P_DueBy) AND DATE(T.DueDate) = DATE(P_CurrentDate)))
			OR (find_in_set('Tomorrow',P_DueBy) AND DATE(T.DueDate) =  DATE(DATE_ADD(P_CurrentDate, INTERVAL 1 Day)))
			OR (find_in_set('Next_8_hours',P_DueBy) AND T.DueDate BETWEEN P_CurrentDate AND DATE_ADD(P_CurrentDate, INTERVAL 8 Hour))
			OR (find_in_set('Overdue',P_DueBy) AND P_CurrentDate >=  T.DueDate ));
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetSystemTicketCustomer`(
	IN `p_CompanyID` int,
	IN `p_Search` VARCHAR(100),
	IN `P_Status` VARCHAR(100),
	IN `P_Priority` VARCHAR(100),
	IN `P_Group` VARCHAR(100),
	IN `P_Agent` VARCHAR(100),
	IN `P_EmailAddresses` VARCHAR(200),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_isExport = 0
	THEN
		SELECT 
			T.TicketID,
			T.Subject,
			CASE WHEN (ISNULL(T.RequesterName) OR T.RequesterName='')  THEN T.Requester ElSE concat(T.RequesterName," (",T.Requester,")") END as Requester,				
			T.Requester as RequesterEmail,		
			TFV.FieldValueCustomer  as TicketStatus,
			TP.PriorityValue,
			concat(TU.FirstName,' ',TU.LastName) as Agent,		
			T.created_at,			
			(select tc.created_at from AccountEmailLog tc where tc.TicketID = T.TicketID  and tc.EmailCall =1 and tc.EmailParent>0 order by tc.AccountEmailLogID desc limit 1) as CustomerResponse,
		    (select tc.created_at from AccountEmailLog tc where tc.TicketID = T.TicketID  and tc.EmailCall =0  order by tc.AccountEmailLogID desc limit 1) as AgentResponse	
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))	
			AND (P_EmailAddresses = '' OR find_in_set(T.`Requester`,P_EmailAddresses))
			ORDER BY		
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectASC') THEN T.Subject
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectDESC') THEN T.Subject
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN TicketStatus
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN TicketStatus
			END DESC,	
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AgentASC') THEN TU.FirstName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AgentDESC') THEN TU.FirstName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN T.created_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN T.created_at
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN T.updated_at
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN T.updated_at
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RequesterASC') THEN T.Requester
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RequesterDESC') THEN T.Requester
			END DESC
			LIMIT
				p_RowspPage OFFSET v_OffSet_;
		
		SELECT 
			COUNT(*) AS totalcount
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))						
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND (P_EmailAddresses = '' OR find_in_set(T.`Requester`,P_EmailAddresses));	
	
		SELECT 
				DISTINCT(TG.GroupID),
				TG.GroupName
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%') OR  T.Requester like Concat('%',p_Search,'%') OR  T.RequesterName like Concat('%',p_Search,'%')   ))						
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND (P_EmailAddresses = '' OR find_in_set(T.`Requester`,P_EmailAddresses))
			AND TG.GroupName IS NOT NULL;	
	
	END IF;
	IF p_isExport = 1	
	THEN
	SELECT 
			T.TicketID,
			T.Subject,
			T.Requester,
			T.RequesterCC as 'CC',						
			TFV.FieldValueCustomer  as 'Status',
			TP.PriorityValue as 'Priority',			
			/*concat(TU.FirstName,' ',TU.LastName) as Agent,*/
			T.created_at as 'Date Created'			
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
			AND (p_Search = '' OR (T.Subject like Concat('%',p_Search,'%') OR  T.Description like Concat('%',p_Search,'%')))
			AND (P_Status = '' OR find_in_set(T.`Status`,P_Status))	
			AND (P_Priority = '' OR find_in_set(T.`Priority`,P_Priority))
			AND (P_Group = '' OR find_in_set(T.`Group`,P_Group))
			AND (P_Agent = '' OR find_in_set(T.`Agent`,P_Agent))
			AND (P_EmailAddresses = '' OR find_in_set(T.`Requester`,P_EmailAddresses));
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetTicketBusinessHours`(
	IN `p_CompanyID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(30),
	IN `p_SortOrder` VARCHAR(10),
	IN `p_isExport` INT
)
BEGIN

DECLARE v_OffSet_ int;

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	/*SELECT concat('myvar is ', v_OffSet_);*/ 
	
	IF p_isExport = 0
	THEN
		SELECT Name,Description,ID,IsDefault 
		FROM tblTicketBusinessHours  
		WHERE (CompanyID = p_CompanyID) 			
		ORDER BY
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
            END ASC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
            END DESC,
            CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
            END DESC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
            END ASC				
							                    
			LIMIT p_RowspPage OFFSET v_OffSet_;
				
		SELECT COUNT(*) AS totalcount
		FROM tblTicketBusinessHours
		WHERE (CompanyID = p_CompanyID);
	END IF;
	
	IF p_isExport = 1
	THEN
	SELECT Name,Description,IsDefault as DefaultData
		FROM tblTicketBusinessHours  
		WHERE (CompanyID = p_CompanyID);
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
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
	WHERE TicketAgentID = 0;

	SELECT v_Open_ as `Open`, v_OnHold_ as OnHold,v_UnResolved_ as UnResolved, v_UnAssigned_ as UnAssigned;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetTicketDashboardTimeline`(
	IN `p_CompanyID` INT,
	IN `P_Group` INT,
	IN `P_Agent` INT,
	IN `p_Time` DATETIME,
	IN `p_TicketID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowsPage` INT




)
BEGIN
	DECLARE v_MAXDATE DATETIME;

	SELECT MAX(created_at) as created_at INTO v_MAXDATE FROM tblTicketDashboardTimeline;
	IF(p_PageNumber=0)
	THEN
		DELETE FROM tblTicketDashboardTimeline WHERE created_at_table < DATE_SUB(p_Time, INTERVAL 1 MONTH);
		INSERT INTO tblTicketDashboardTimeline
		SELECT
			NULL,
			tc.CompanyID,
			1 as TimeLineType,
			CONCAT(IFNULL(u.FirstName,''),' ',IFNULL(u.LastName,'')) as UserName,
			u.UserID,
			CASE WHEN tc.AccountID != 0 THEN tc.AccountID
					WHEN tc.ContactID != 0 THEN tc.ContactID
					ELSE 0 END as CustomerID,
			CASE WHEN tc.AccountID != 0 THEN 1
					WHEN tc.ContactID != 0 THEN 2
					ELSE 0 END as CustomerType,
			acel.EmailCall,
			tc.TicketID,
		/*	CASE WHEN tc.AccountEmailLogID != 0 AND acel.EmailParent=0 THEN 1 ELSE 0 END as TicketSubmit,*/
		   0 as TicketSubmit,
			tc.Subject,
			acel.AccountEmailLogID as ID,
			tc.Agent,
			tc.`Group`,
			0 as TicketFieldID,
			0 as TicketFieldValueFromID,
			0 as TicketFieldValueToID,
			acel.created_at,
			p_Time
		FROM AccountEmailLog acel
		INNER JOIN tblTickets tc ON tc.TicketID = acel.TicketID
		LEFT JOIN tblAccount ac ON ac.AccountID = acel.AccountID
		LEFT JOIN tblUser u ON u.UserID = acel.UserID
		WHERE acel.CompanyID = p_CompanyID
		AND (v_MAXDATE IS NULL OR acel.created_at > v_MAXDATE)
		/*AND acel.EmailCall = 0*/
		AND (p_TicketID = 0 OR (tc.TicketID = p_TicketID))
		AND u.UserID IS NOT NULL;

		INSERT INTO tblTicketDashboardTimeline
		SELECT
		NULL,
		tc.CompanyID,
		2 as TimeLineType,
		CONCAT(IFNULL(u.FirstName,''),' ',IFNULL(u.LastName,''))  as UserName,
		TN.UserID as UserID,
		0 as CustomerID,
		0 as CustomerType,
		0 as EmailCall,
		tc.TicketID,
		0 as TicketSubmit,
		tc.Subject,
		TN.NoteID as ID,
		tc.Agent,
		tc.`Group`,
		0 as TicketFieldID,
		0 as TicketFieldValueFromID,
		0 as TicketFieldValueToID,
		TN.created_at,
		p_Time
		FROM `tblNote` TN
		INNER JOIN tblTickets tc ON tc.TicketID = TN.TicketID
		INNER JOIN tblUser u ON u.UserID = TN.UserID
		WHERE TN.CompanyID = p_CompanyID
		AND (v_MAXDATE IS NULL OR TN.created_at > v_MAXDATE)
		AND (p_TicketID = 0 OR (tc.TicketID = p_TicketID));

		INSERT INTO tblTicketDashboardTimeline
		SELECT
			NULL,
			tc.CompanyID,
			3 as TimeLineType,
			CASE WHEN tl.AccountID = 0 THEN CONCAT(IFNULL(u.FirstName,''),' ',IFNULL(u.LastName,'')) ELSE CONCAT(IFNULL(a.FirstName,''),' ',IFNULL(a.LastName,''))  END as UserName,
			tl.UserID as UserID,
			CASE WHEN tl.TicketFieldID = 0 THEN
				CASE WHEN tc.AccountID != 0 THEN tc.AccountID
						WHEN tc.ContactID != 0 THEN tc.ContactID
						ELSE 0 END
			ELSE
				tl.AccountID
			END as CustomerID,
			CASE WHEN tl.TicketFieldID = 0 THEN
				CASE WHEN tc.AccountID != 0 THEN 1
						WHEN tc.ContactID != 0 THEN 2
						ELSE 0 END
				ELSE 0 END as CustomerType,
			0 as EmailCall,
			tc.TicketID,
			IF(tl.NewTicket = 0,0,1) as TicketSubmit,
			tc.Subject,
			tl.TicketLogID as ID,
			tc.Agent,
			tc.`Group`,
			tl.TicketFieldID,
			tl.TicketFieldValueFromID,
			tl.TicketFieldValueToID,
			tl.created_at,
			p_Time
		FROM tblTicketLog tl
		INNER JOIN tblTickets tc ON tc.TicketID = tl.TicketID
		LEFT JOIN tblUser u ON u.UserID = tl.UserID
		LEFT JOIN tblAccount a ON a.AccountID = tl.AccountID
		WHERE tl.CompanyID = p_CompanyID
		AND (v_MAXDATE IS NULL OR tl.created_at > v_MAXDATE)
		AND (p_TicketID = 0 OR (tc.TicketID = p_TicketID));
	END IF;
	SELECT * FROM tblTicketDashboardTimeline tl
	WHERE (P_Agent = 0 OR tl.AgentID = p_Agent)
	AND(P_Group = 0 OR tl.`GroupID` = p_Group)
	AND (p_TicketID = 0 OR (tl.TicketID = p_TicketID))
	ORDER BY created_at DESC
	LIMIT p_RowsPage OFFSET p_PageNumber;	
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetTicketGroups`(
	IN `p_CompanyID` int,
	IN `p_Search` VARCHAR(100),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT 
)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_isExport = 0
	THEN
		SELECT 
			TG.GroupID,
			TG.GroupName,
			(CONCAT(TG.GroupEmailAddress,' <br>(', CASE WHEN TG.GroupEmailStatus >0 THEN 'Verified'  ELSE 'Unverified' END,')')) as GroupEmailAddress,
			(SELECT count(TGA.GroupAgentsID) FROM tblTicketGroupAgents TGA WHERE TGA.GroupID = TG.GroupID ) as TotalAgents,
			TG.GroupAssignTime,
			(select concat(tu.FirstName,' ',tu.LastName)  from tblUser tu where tu.UserID = TG.GroupAssignEmail) as AssignUser,
			(select count(*)  from tblTickets tt where tt.Group = TG.GroupID) as GroupTickets
		FROM 
			tblTicketGroups TG				
		WHERE   
			TG.CompanyID = p_CompanyID			
			AND (p_Search = '' OR (TG.GroupName like Concat('%',p_Search,'%') OR  TG.GroupDescription like Concat('%',p_Search,'%')))
			group by TG.GroupID
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupNameASC') THEN TG.GroupName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupNameDESC') THEN TG.GroupName
			END DESC,			 							
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupAssignTimeASC') THEN TG.GroupAssignTime
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupAssignTimeDESC') THEN TG.GroupAssignTime
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalAgentsASC') THEN TotalAgents
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalAgentsDESC') THEN TotalAgents
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupEmailAddressASC') THEN GroupEmailAddress
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GroupEmailAddressDESC') THEN GroupEmailAddress
			END DESC,			
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AssignUserASC') THEN AssignUser
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AssignUserDESC') THEN AssignUser
			END DESC		
					
					
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(TG.GroupID) AS totalcount
		FROM tblTicketGroups TG			
		WHERE   TG.CompanyID = p_CompanyID			
			AND (p_Search = '' OR (TG.GroupName like Concat('%',p_Search,'%') OR  TG.GroupDescription like Concat('%',p_Search,'%'))); 

	END IF;
	IF p_isExport = 1	
	THEN
	SELECT 
			TG.GroupID,
			TG.GroupName,
			(CONCAT(TG.GroupEmailAddress,' (', CASE WHEN TG.GroupEmailStatus >0 THEN 'verified'  ELSE 'Unverified'	END,')')) as GroupEmailAddress,
			(SELECT count(TGA.GroupAgentsID) FROM tblTicketGroupAgents TGA WHERE TGA.GroupID = TG.GroupID ) as TotalAgents,
			TG.GroupAssignTime,
			(select  CASE WHEN TG.GroupAssignEmail >0 THEN concat(tu.FirstName,' ',tu.LastName) ELSE 'None' END as AssignUser from tblUser tu where tu.UserID = TG.GroupAssignEmail) as AssignUser
		FROM 
			tblTicketGroups TG				
		WHERE   
			TG.CompanyID = p_CompanyID			
			AND (p_Search = '' OR (TG.GroupName like Concat('%',p_Search,'%') OR  TG.GroupDescription like Concat('%',p_Search,'%')))
			group by TG.GroupID;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetTicketImportRules`(
	IN `p_CompanyID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(30),
	IN `p_SortOrder` VARCHAR(10),
	IN `p_isExport` INT

)
BEGIN

DECLARE v_OffSet_ int;

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	/*SELECT concat('myvar is ', v_OffSet_);*/ 
	
	IF p_isExport = 0
	THEN
		SELECT `Title`,`Status`,`TicketImportRuleID` 
		FROM tblTicketImportRule  
		WHERE (CompanyID = p_CompanyID) 			
		ORDER BY
			CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN Title
            END ASC,
			CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN Title
            END DESC,
           CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN Status
            END DESC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN Status
            END ASC				
							                    
			LIMIT p_RowspPage OFFSET v_OffSet_;
				
		SELECT COUNT(*) AS totalcount
		FROM tblTicketImportRule
		WHERE (CompanyID = p_CompanyID);
	END IF;
	
	IF p_isExport = 1
	THEN
	SELECT Title,Description,Status
		FROM tblTicketImportRule  
		WHERE (CompanyID = p_CompanyID);
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_GetTicketSLA`(
	IN `p_CompanyID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(30),
	IN `p_SortOrder` VARCHAR(10),
	IN `p_isExport` INT
)
BEGIN

DECLARE v_OffSet_ int;

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	/*SELECT concat('myvar is ', v_OffSet_);*/ 
	
	IF p_isExport = 0
	THEN
		SELECT Name,Description,TicketSlaID,IsDefault 
		FROM tblTicketSla  
		WHERE (CompanyID = p_CompanyID) 			
		ORDER BY
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
            END ASC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
            END DESC,
           CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
            END DESC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
            END ASC				
							                    
			LIMIT p_RowspPage OFFSET v_OffSet_;
				
		SELECT COUNT(*) AS totalcount
		FROM tblTicketSla
		WHERE (CompanyID = p_CompanyID);
	END IF;
	
	IF p_isExport = 1
	THEN
	SELECT Name,Description,IsDefault as DefaultData
		FROM tblTicketSla  
		WHERE (CompanyID = p_CompanyID);
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_getTicketTimeline`(
	IN `p_CompanyID` INT,
	IN `p_TicketID` INT,
	IN `p_isCustomer` INT







)
BEGIN

DECLARE v_EmailParent int;	
	select AccountEmailLogID into v_EmailParent from tblTickets where TicketID = p_TicketID;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_ticket_timeline_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ticket_timeline_(
		`Timeline_type` int(11),		
		EmailCall int(11),
		EmailfromName varchar(200),
		EmailTo varchar(200),
		Emailfrom varchar(200),
		EmailMessage LONGTEXT,
		EmailCc varchar(500),
		EmailBcc varchar(500),
		AttachmentPaths LONGTEXT,
		AccountEmailLogID int(11),
	    NoteID int(11),
		Note longtext,			
		CreatedBy varchar(50),
		created_at datetime,
		updated_at datetime		
	);

	INSERT INTO tmp_ticket_timeline_
	select 1 as Timeline_type,EmailCall,EmailfromName,EmailTo,Emailfrom,Message,Cc,Bcc,IFNULL(AttachmentPaths,'a:0:{}'),AccountEmailLogID,0 as NoteID,'' as Note,ael.CreatedBy,ael.created_at, ael.updated_at 
	from `AccountEmailLog` ael	
	where 
	/*ael.EmailParent = v_EmailParent and*/
	ael.TicketID = p_TicketID and
	ael.CompanyID = p_CompanyID 
	and ael.EmailParent > 0
	/*and ael.AccountEmailLogID NOT IN (SELECT AEE.AccountEmailLogID FROM AccountEmailLog AEE WHERE AEE.EmailParent = 0 )	*/
	order by ael.created_at desc;
	
	IF p_isCustomer =0
	THEN
	
	INSERT INTO tmp_ticket_timeline_
	select 2 as Timeline_type,0 as EmailCall,'' as EmailfromName,'' as EmailTo,'' as Emailfrom,'' as Message,'' as Cc,'' as Bcc,'a:0:{}' as AttachmentPaths,0 as AccountEmailLogID,NoteID,Note,TN.created_by,TN.created_at, TN.updated_at 
	from `tblNote` TN	
	where 
	TN.TicketID = p_TicketID and
	TN.CompanyID = p_CompanyID  	
	order by TN.created_at desc;
END IF;
	select * from tmp_ticket_timeline_  order by created_at asc;		
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_LowBalanceReminder`;

DELIMITER |
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
		IF ( (CASE WHEN ab.BalanceThreshold LIKE '%p' THEN REPLACE(ab.BalanceThreshold, 'p', '')/ 100 * ab.PermanentCredit ELSE ab.BalanceThreshold END) < ab.BalanceAmount AND ab.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
		a.AccountID
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN tblAccountBilling abg 
		ON abg.AccountID  = a.AccountID
	INNER JOIN tblBillingClass b
		ON b.BillingClassID = abg.BillingClassID
	WHERE a.CompanyId = p_CompanyID
	AND (p_AccountID = 0 OR  a.AccountID = p_AccountID)
	AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
	AND ab.PermanentCredit IS NOT NULL
	AND ab.BalanceThreshold IS NOT NULL
	AND a.`Status` = 1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_ProcessDiscountPlan`;

DELIMITER |
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
	
	/* temp accounts*/
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
		
		/* apply discount plan*/
		CALL prc_applyAccountDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,0,v_ServiceID_);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	/* temp accounts*/
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
		
		/* apply discount plan*/
		CALL prc_applyAccountDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,1,v_ServiceID_);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_RateTableRateInsertUpdate`;

DELIMITER |
CREATE PROCEDURE `prc_RateTableRateInsertUpdate`(IN `p_CompanyID` INT, IN `p_RateTableRateID` LONGTEXT
, IN `p_RateTableId` INT 
, IN `p_Rate` DECIMAL(18, 6) 
, IN `p_EffectiveDate` DATETIME
, IN `p_ModifiedBy` VARCHAR(50)
, IN `p_Interval1` INT
, IN `p_IntervalN` INT
, IN `p_ConnectionFee` DECIMAL(18, 6)
, IN `p_Critearea` INT
, IN `p_Critearea_TrunkID` INT
, IN `p_Critearea_CountryID` INT
, IN `p_Critearea_Code` VARCHAR(50)
, IN `p_Critearea_Description` VARCHAR(50)
, IN `p_Critearea_Effective` VARCHAR(50)
, IN `p_Update_EffectiveDate` INT
, IN `p_Update_Rate` INT
, IN `p_Update_Interval1` INT
, IN `p_Update_IntervalN` INT
, IN `p_Update_ConnectionFee` INT
, IN `p_Action` INT
)
BEGIN
              
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
			EffectiveDate,
			created_at,
			CreatedBy,
			Interval1,
			IntervalN,
			ConnectionFee
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
								AS ConnectionFee	
			 FROM tblRateTableRate tr
		   	 INNER JOIN tmp_Insert_RateTable_ r
			 		 ON  r.RateID = tr.RateID
			 		 	AND r.RateTableRateID = tr.RateTableRateID
	   		 		AND  RateTableId = p_RateTableId; 
	
	END IF; 
	
	
	-- bulk update
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
		
	CALL prc_ArchiveOldRateTableRate(p_RateTableId); 
	
	END IF;
	
	IF p_action = 2
	THEN
		DELETE tblRateTableRate
			 FROM tblRateTableRate
				INNER JOIN tmp_RateTable_ 
					ON tblRateTableRate.RateTableRateID = tmp_RateTable_.RateTableRateID;
		
		
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	 
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_setAccountDiscountPlan`;

DELIMITER |
CREATE PROCEDURE `prc_setAccountDiscountPlan`(
	IN `p_AccountID` INT,
	IN `p_DiscountPlanID` INT,
	IN `p_Type` INT,
	IN `p_BillingDays` INT,
	IN `p_DayDiff` INT,
	IN `p_CreatedBy` VARCHAR(50),
	IN `p_Today` DATETIME,
	IN `p_ServiceID` INT

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
	
	INSERT INTO tblAccountDiscountPlanHistory(AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,Applied,Changed,StartDate,EndDate,ServiceID)
	SELECT AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,created_at,p_Today,StartDate,EndDate,ServiceID FROM tblAccountDiscountPlan WHERE AccountID = p_AccountID AND ServiceID = p_ServiceID AND Type = p_Type;
	
	INSERT INTO tblAccountDiscountSchemeHistory (AccountDiscountSchemeID,AccountDiscountPlanID,DiscountID,Threshold,Discount,Unlimited,SecondsUsed)
	SELECT ads.AccountDiscountSchemeID,ads.AccountDiscountPlanID,ads.DiscountID,ads.Threshold,ads.Discount,ads.Unlimited,ads.SecondsUsed 
	FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
		AND adp.ServiceID = p_ServiceID
		AND Type = p_Type;
	
	DELETE ads FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
	   AND adp.ServiceID = p_ServiceID
		AND Type = p_Type;
		
	DELETE FROM tblAccountDiscountPlan WHERE AccountID = p_AccountID AND ServiceID = p_ServiceID AND Type = p_Type; 
	
	IF p_DiscountPlanID > 0
	THEN
	 
		INSERT INTO tblAccountDiscountPlan (AccountID,DiscountPlanID,Type,CreatedBy,created_at,StartDate,EndDate,ServiceID)
		VALUES (p_AccountID,p_DiscountPlanID,p_Type,p_CreatedBy,p_Today,v_StartDate,v_EndDate,p_ServiceID);
		
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

END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_UpdateTicketSLADueDate`(
	IN `p_TicketID` INT,
	IN `p_PrevFieldValue` INT,
	IN `p_NewFieldValue` INT









)
BEGIN

	DECLARE 	v_created_at_from DATETIME;
	DECLARE 	v_created_at_to DATETIME;
	DECLARE 	v_DueDate DATETIME;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	-- update due date only when Status changed from SLATimer = 0 to 1 
	
	IF
	(
		(SELECT count(*) FROM tblTicketfieldsValues where FieldSlaTime = 0 and ValuesID=p_PrevFieldValue) > 0 AND
		(SELECT count(*) FROM tblTicketfieldsValues where FieldSlaTime = 1 and ValuesID=p_NewFieldValue) > 0
	) THEN


		SELECT DueDate into v_DueDate FROM tblTickets WHERE TicketID= p_TicketID;

          -- Previous entry - current entry
		SELECT created_at into v_created_at_from  FROM tblTicketLog where TicketID = p_TicketID order by TicketLogID desc limit 1,1;
          SELECT created_at into v_created_at_to FROM tblTicketLog where TicketID = p_TicketID  order by TicketLogID desc limit 1;

		-- Select DATE_ADD(v_DueDate, INTERVAL TIMESTAMPDIFF(Minute , v_created_at_from,v_created_at_to) Minute);

		UPDATE tblTickets
		SET DueDate = DATE_ADD(v_DueDate, INTERVAL TIMESTAMPDIFF(Minute , v_created_at_from,v_created_at_to) Minute)
		Where TicketID = p_TicketID;

		
	END IF;

 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_WSProcessImportAccount`;

DELIMITER |
CREATE PROCEDURE `prc_WSProcessImportAccount`(
	IN `p_processId` VARCHAR(200) ,
	IN `p_companyId` INT,
	IN `p_companygatewayid` INT,
	IN `p_tempaccountid` TEXT,
	IN `p_option` INT

)
BEGIN
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

   IF p_option = 0 /* Csv Import */
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
					ta.created_at,
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

	  DELETE  FROM tblTempAccount WHERE   tblTempAccount.ProcessID = p_processId;

	END IF;


	IF p_option = 1 /* Import from gateway */
   THEN

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
					VerificationStatus
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
					ta.created_at,
					ta.created_by,
					2 as VerificationStatus
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

		  		SELECT 'AccountNumber Already EXITS : \n\r' INTO errorheader;
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
					VerificationStatus
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
					created_at,
					created_by,
					VerificationStatus
				from tmp_accountimport;


			SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

			INSERT INTO tmp_JobLog_ (Message)
			SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );

		-- DELETE  FROM tblTempAccount WHERE FIND_IN_SET(tblTempAccountID,p_tempaccountid);

   END IF;

 	 SELECT * from tmp_JobLog_;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

USE `RMBilling3`;

ALTER TABLE `tblAccountOneOffCharge`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblAccountSubscription`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblEstimate`
  ADD COLUMN `BillingClassID` int(11) NULL;

ALTER TABLE `tblGatewayAccount`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblInvoice`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0'
  , ADD COLUMN `BillingClassID` int(11) NULL;

ALTER TABLE `tblInvoiceDetail`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblInvoiceTemplate`
  ADD COLUMN `InvoiceTo` longtext NULL
  , ADD COLUMN `ServiceSplit` int(11) NULL DEFAULT '0'
  , ADD COLUMN `UsageColumn` longtext NULL
  , ADD COLUMN `GroupByService` int(11) NULL DEFAULT '0'
  , ADD COLUMN `CDRType` int(11) NULL DEFAULT '0';

DROP TABLE `tblUsageDaily`;

DROP TABLE `tblUsageHourly`;

DROP FUNCTION `fnGetBillingTime`;

DELIMITER |
CREATE FUNCTION `fnGetBillingTime`(
	`p_GatewayID` INT,
	`p_AccountID` INT

) RETURNS int(11)
BEGIN

	DECLARE v_BillingTime_ INT;

	SELECT 
		CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.BillingTime'),'"','') > 0
		THEN
			CAST(REPLACE(JSON_EXTRACT(cg.Settings, '$.BillingTime'),'"','') AS UNSIGNED INTEGER)
		ELSE
			NULL
		END
	INTO v_BillingTime_
	FROM Ratemanagement3.tblCompanyGateway cg
	INNER JOIN tblGatewayAccount ga ON ga.CompanyGatewayID = cg.CompanyGatewayID
	WHERE (p_AccountID = 0 OR AccountID = p_AccountID ) AND (p_GatewayID = 0 OR ga.CompanyGatewayID = p_GatewayID)
	LIMIT 1;
	
	SET v_BillingTime_ = IFNULL(v_BillingTime_,1);

	RETURN v_BillingTime_;
END|
DELIMITER ;

DROP FUNCTION `FnGetInvoiceNumber`;

DELIMITER |
CREATE FUNCTION `FnGetInvoiceNumber`(
	`p_CompanyID` INT,
	`p_AccountID` INT,
	`p_BillingClassID` INT



) RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Return Next Invoice Number'
BEGIN
	DECLARE v_LastInv VARCHAR(50);
	DECLARE v_FoundVal INT(11);
	DECLARE v_InvoiceTemplateID INT(11);

	SET v_InvoiceTemplateID =
	CASE WHEN p_BillingClassID=0
	THEN (
		SELECT 
			b.InvoiceTemplateID 
		FROM Ratemanagement3.tblAccountBilling ab
		INNER JOIN Ratemanagement3.tblBillingClass b
			ON b.BillingClassID = ab.BillingClassID
		WHERE AccountID = p_AccountID AND ServiceID = 0
	)
	ELSE (
		SELECT b.InvoiceTemplateID
		FROM  Ratemanagement3.tblBillingClass b
		WHERE b.BillingClassID = p_BillingClassID
	) END;

	SELECT IF(LastInvoiceNumber=0,InvoiceStartNumber,LastInvoiceNumber) INTO v_LastInv FROM tblInvoiceTemplate WHERE InvoiceTemplateID =v_InvoiceTemplateID;

	-- select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber) = '64123';

	SET v_FoundVal = (SELECT COUNT(*) AS total_res FROM tblInvoice WHERE CompanyID = p_CompanyID AND InvoiceNumber=v_LastInv);
	IF v_FoundVal>=1 THEN
	WHILE v_FoundVal>0 DO
		SET v_LastInv = v_LastInv+1;
		SET v_FoundVal = (SELECT COUNT(*) AS total_res FROM tblInvoice WHERE CompanyID = p_CompanyID AND InvoiceNumber=v_LastInv);
	END WHILE;
	END IF;

RETURN v_LastInv;
END|
DELIMITER ;

DROP FUNCTION `fnGetRoundingPoint`;

DELIMITER |
CREATE FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT
) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from Ratemanagement3.tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID AND cs.Value <> '';

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END|
DELIMITER ;

DELIMITER |
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
	(p_billing_time =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate);
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageDetail`;

DELIMITER |
CREATE PROCEDURE `fnUsageDetail`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_billing_time` INT,
	IN `p_cdr_type` CHAR(1),
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
		(p_cdr_type = '' OR  ud.is_inbound = p_cdr_type)
		AND  StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
		AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
		AND uh.CompanyID = p_CompanyID
		AND uh.AccountID IS NOT NULL
		AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
		AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))
		AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
		AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))
	) tbl
	WHERE 
	(p_billing_time =1 AND connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 AND disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	AND billed_duration > 0
	ORDER BY disconnect_time DESC;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageDetailbyProcessID`;

DELIMITER |
CREATE PROCEDURE `fnUsageDetailbyProcessID`(IN `p_ProcessID` VARCHAR(200)

)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetailsProcess_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetailsProcess_(
			CompanyID int,
			CompanyGatewayID int,
			AccountID int,
			trunk varchar(50),			
			area_prefix varchar(50),			
			pincode varchar(50),
			extension VARCHAR(50),
			UsageDetailID int,
			duration int,
			billed_duration int,
			cli varchar(100),
			cld varchar(100),
			cost float,
			connect_time datetime,
			disconnect_time datetime
	);
	INSERT INTO tmp_tblUsageDetailsProcess_
	 SELECT
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.AccountID,
		trunk,
		area_prefix,
		pincode,
		extension,
		UsageDetailID,
		duration,
		billed_duration,
		cli,
		cld,
		cost,
		connect_time,
		disconnect_time
	FROM RMCDR3.tblUsageDetails ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.AccountID is not null
	AND  ud.ProcessID = p_ProcessID;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnUsageDetailbyUsageHeaderID`;

DELIMITER |
CREATE PROCEDURE `fnUsageDetailbyUsageHeaderID`( 
	p_UsageHeaderID INT

)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetailswithHeader_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetailswithHeader_(
			CompanyID int,
			CompanyGatewayID int,
			AccountID int,
			trunk varchar(50),			
			area_prefix varchar(50),			
			UsageDetailID int,
			duration int,
			billed_duration int,
			cli varchar(100),
			cld varchar(100),
			cost float,
			connect_time datetime,
			disconnect_time datetime
	);
	INSERT INTO tmp_tblUsageDetailswithHeader_
	 SELECT
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.AccountID,
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
	FROM RMCDR3.tblUsageDetails ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.AccountID is not null
	AND  uh.UsageHeaderID = p_UsageHeaderID;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnVendorUsageDetail`;

DELIMITER |
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
	(p_billing_time =1 AND connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 AND disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	AND billed_duration > 0
	ORDER BY disconnect_time DESC;
END|
DELIMITER ;

DELIMITER |
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
				GatewayAccountID,
				a.AccountID,
				ga.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId
				AND CONCAT(a.AccountName , '-' , a.Number) = ga.AccountName
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND a.CompanyId = p_CompanyID
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
				GatewayAccountID,
				a.AccountID,
				ga.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId
				AND CONCAT(a.Number, '-' , a.AccountName) = ga.AccountName
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND a.CompanyId = p_CompanyID
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
				GatewayAccountID,
				a.AccountID,
				ga.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId
				AND a.Number = ga.AccountName
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa 
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID	
			WHERE GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND a.CompanyId = p_CompanyID
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
				GatewayAccountID,
				a.AccountID,
				aa.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'IP' OR aa.VendorAuthRule ='IP')
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId 
				AND ga.ServiceID = p_ServiceID AND aa.ServiceID = ga.ServiceID 
				AND ( FIND_IN_SET(ga.AccountName,aa.CustomerAuthValue) != 0 OR FIND_IN_SET(ga.AccountName,aa.VendorAuthValue) != 0 )
			WHERE a.CompanyId = p_CompanyID
			AND a.`Status` = 1
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID;

		END IF;

		IF p_NameFormat = 'CLI'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				aa.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId 
			INNER JOIN Ratemanagement3.tblCLIRateTable aa
				ON a.AccountID = aa.AccountID
				AND ga.ServiceID = p_ServiceID AND aa.ServiceID = ga.ServiceID 
				AND ga.AccountName = aa.CLI
			WHERE a.CompanyId = p_CompanyID
			AND a.`Status` = 1
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID;

		END IF;

		IF p_NameFormat = '' OR p_NameFormat IS NULL OR p_NameFormat = 'NAME'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				ga.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId 
				AND a.AccountName = ga.AccountName
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID 
				AND aa.ServiceID = ga.ServiceID 
			WHERE a.CompanyId = p_CompanyID
			AND a.`Status` = 1			
			AND ga.ServiceID = p_ServiceID 
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ( ( aa.AccountID IS NOT NULL AND (aa.CustomerAuthRule = 'NAME' OR aa.VendorAuthRule ='NAME' )) OR
					aa.AccountID IS NULL
				);

		END IF;

		IF p_NameFormat = 'Other'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				aa.ServiceID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'Other' OR aa.VendorAuthRule ='Other')
			INNER JOIN tblGatewayAccount ga
				ON ga.CompanyID = a.CompanyId
				AND ga.ServiceID = aa.ServiceID 
				AND ( aa.VendorAuthValue = ga.AccountName OR aa.CustomerAuthValue = ga.AccountName )
			WHERE a.CompanyId = p_CompanyID
			AND a.`Status` = 1
			AND GatewayAccountID IS NOT NULL
			AND ga.AccountID IS NULL
			AND ga.CompanyGatewayID = p_CompanyGatewayID
			AND ga.ServiceID = p_ServiceID;

		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_checkCDRIsLoadedOrNot`;

DELIMITER |
CREATE PROCEDURE `prc_checkCDRIsLoadedOrNot`(IN `p_AccountID` INT, IN `p_CompanyID` INT, IN `p_UsageEndDate` DATETIME )
BEGIN

    DECLARE v_end_time_ DATE;
    DECLARE v_notInGateeway_ INT;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SELECT COUNT(*) INTO v_notInGateeway_ FROM tblGatewayAccount ga
	 INNER  JOIN  Ratemanagement3.tblCompanyGateway cg ON cg.CompanyGatewayID  = ga.CompanyGatewayID AND cg.Status = 1 
	 WHERE ga.AccountID = p_AccountID and ga.CompanyID  = p_CompanyID;    


    IF v_notInGateeway_ > 0 
    THEN

        SELECT DATE_FORMAT(MIN(end_time), '%y-%m-%d') INTO v_end_time_  
        FROM  (
            SELECT  MAX(tmpusglog.end_time) AS end_time ,ga.CompanyGatewayID  
            FROM  tblGatewayAccount ga  
            INNER  JOIN  tblTempUsageDownloadLog tmpusglog on tmpusglog.CompanyGatewayID = ga.CompanyGatewayID
            INNER  JOIN  Ratemanagement3.tblCompanyGateway cg ON cg.CompanyGatewayID  = ga.CompanyGatewayID AND cg.Status = 1 
            WHERE  ga.AccountID = p_AccountID and ga.CompanyID  = p_CompanyID
            GROUP BY ga.CompanyGatewayID
            )TBL;        

        IF p_UsageEndDate < v_end_time_ 
        THEN
            SELECT '1' AS isLoaded;
        ELSE
            SELECT '0' AS isLoaded;
        END IF;
    
    ELSE
        SELECT '1' AS isLoaded;
    END IF;

 	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_Convert_Invoices_to_Estimates`;

DELIMITER |
CREATE PROCEDURE `prc_Convert_Invoices_to_Estimates`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` VARCHAR(50),
	IN `p_EstimateNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_EstimateStatus` VARCHAR(50),
	IN `p_EstimateID` VARCHAR(50),
	IN `p_convert_all` INT



)
    COMMENT 'test'
BEGIN
	DECLARE estimate_ids int;
	DECLARE note_text varchar(50);
 	SET sql_mode = 'ALLOW_INVALID_DATES'; 	
	set note_text = 'Created From Estimate: ';
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
update tblInvoice  set EstimateID = '';
INSERT INTO tblInvoice (`CompanyID`, `AccountID`, `Address`, `InvoiceNumber`, `IssueDate`, `CurrencyID`, `PONumber`, `InvoiceType`, `SubTotal`, `TotalDiscount`, `TaxRateID`, `TotalTax`, `InvoiceTotal`, `GrandTotal`, `Description`, `Attachment`, `Note`, `Terms`, `InvoiceStatus`, `PDF`, `UsagePath`, `PreviousBalance`, `TotalDue`, `Payment`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ItemInvoice`, `FooterTerm`,BillingClassID,EstimateID)
 	select te.CompanyID,
	 		 te.AccountID,
			 te.Address,
			 FNGetInvoiceNumber(p_CompanyID,te.AccountID,te.BillingClassID) as InvoiceNumber,
			 DATE(NOW()) as IssueDate,
			 te.CurrencyID,
			 te.PONumber,
			 1 as InvoiceType,
			 te.SubTotal,
			 te.TotalDiscount,
			 te.TaxRateID,
			 te.TotalTax,
			 te.EstimateTotal,
			 te.GrandTotal,
			 te.Description,
			 te.Attachment,
			 te.Note,
			 te.Terms,
			 'awaiting' as InvoiceStatus,
			 te.PDF,
			 '' as UsagePath, 
			 0 as PreviousBalance,
			 0 as TotalDue,
			 0 as Payment,
			 te.CreatedBy,
			 '' as ModifiedBy,
			NOW() as created_at,
			NOW() as updated_at,
			1 as ItemInvoice,
			te.FooterTerm,
			te.BillingClassID,
			te.EstimateID			
			from tblEstimate te		
			where
			(p_convert_all=0 and te.EstimateID = p_EstimateID)
			OR
			(p_EstimateID = '' and p_convert_all =1 and (te.CompanyID = p_CompanyID)		
			AND (p_AccountID = '' OR ( p_AccountID != '' AND te.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND te.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND te.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND te.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND te.EstimateStatus = p_EstimateStatus)) );
			

 select 	InvoiceID from tblInvoice inv
INNER JOIN tblEstimate ti ON  inv.EstimateID =  ti.EstimateID
where (p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR
		(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))		
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)) );
        
		INSERT INTO tblInvoiceDetail ( `InvoiceID`, `ProductID`, `Description`, `StartDate`, `EndDate`, `Price`, `Qty`, `Discount`, `TaxRateID`,`TaxRateID2`, `TaxAmount`, `LineTotal`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ProductType`)
			select 
				inv.InvoiceID,
				ted.ProductID,
				ted.Description,
				'' as StartDate,
				'' as EndDate,
				ted.Price,
				ted.Qty,
				ted.Discount,
				ted.TaxRateID,
				ted.TaxRateID2,
				ted.TaxAmount,
				ted.LineTotal,
				ted.CreatedBy,
				ted.ModifiedBy,	
				ted.created_at,	
				NOW() as updated_at,
				ted.ProductType	
from tblEstimateDetail ted
INNER JOIN tblInvoice inv ON  inv.EstimateID = ted.EstimateID
INNER JOIN tblEstimate ti ON  ti.EstimateID = ted.EstimateID
where	 
		 (p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)	
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))			
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)));
			
	INSERT INTO tblInvoiceTaxRate ( `InvoiceID`, `TaxRateID`, `TaxAmount`,`InvoiceTaxType`,`Title`, `CreatedBy`,`ModifiedBy`)
	SELECT 
		MIN(inv.InvoiceID),
		ted.TaxRateID,
		SUM(ted.TaxAmount),
		case when MIN(ted.EstimateTaxType) =2
		then 0 else  MIN(ted.EstimateTaxType)
		end as EstimateTaxType,		
		/*MIN(ted.EstimateTaxType),*/
		MIN(ted.Title),
		MIN(ted.CreatedBy),
		MIN(ted.ModifiedBy)
	FROM tblEstimateTaxRate ted
	INNER JOIN tblInvoice inv ON  inv.EstimateID = ted.EstimateID
	INNER JOIN tblEstimate ti ON  ti.EstimateID = ted.EstimateID
	WHERE	(p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(
			p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)	
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))			
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus))
		)
	GROUP BY ted.EstimateID,ted.TaxRateID,EstimateTaxType = 0 OR EstimateTaxType= 2;
		
insert into tblInvoiceLog (InvoiceID,Note,InvoiceLogStatus,created_at)
select inv.InvoiceID,concat(note_text, CONCAT(LTRIM(RTRIM(IFNULL(it.EstimateNumberPrefix,''))), LTRIM(RTRIM(ti.EstimateNumber)))) as Note,1 as InvoiceLogStatus,NOW() as created_at  from tblInvoice inv
INNER JOIN tblEstimate ti ON  inv.EstimateID =  ti.EstimateID
INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
INNER JOIN Ratemanagement3.tblBillingClass b ON inv.BillingClassID = b.BillingClassID
LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
where
			(p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)	
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))		
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)));
		
		
update tblEstimate te set te.EstimateStatus='accepted'
where  
			(p_convert_all=0 and te.EstimateID = p_EstimateID)
			OR
			(p_EstimateID = '' and p_convert_all =1 and (te.CompanyID = p_CompanyID)	
			AND (p_AccountID = '' OR ( p_AccountID != '' AND te.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND te.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND te.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND te.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND te.EstimateStatus = p_EstimateStatus)));
	
	UPDATE tblInvoice 
	INNER JOIN tblEstimate ON  tblInvoice.EstimateID =  tblEstimate.EstimateID
	INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblInvoice.AccountID
	INNER JOIN Ratemanagement3.tblBillingClass ON tblInvoice.BillingClassID = tblBillingClass.BillingClassID
	INNER JOIN tblInvoiceTemplate ON tblBillingClass.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
	SET FullInvoiceNumber = IF(InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(tblInvoice.InvoiceNumber))),ltrim(rtrim(tblInvoice.InvoiceNumber)))
	WHERE FullInvoiceNumber IS NULL AND tblInvoice.CompanyID = p_CompanyID AND tblInvoice.InvoiceType = 1;
			
				SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_CreateInvoiceFromRecurringInvoice`;

DELIMITER |
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
    
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_Note = CONCAT('Recurring Invoice Generated by ',p_ModifiedBy,' ');
	
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
	
	INSERT INTO tmp_Invoices_ /*insert invoices in temp table on the bases of filter*/
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
			 
		/*Fill error message for recurring invoices with date check*/
     SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with INVOICE DATE ',DATE(temp.NextInvoiceDate)) separator '\n\r') INTO v_SkippedWIthDate
	  FROM tmp_Invoices_ temp
	  WHERE (DATE(temp.NextInvoiceDate) > DATE(p_CurrentDate));
	  
	  /*Fill error message for recurring invoices with occurrence check*/
	  SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with exceding limit Occurrence ',(SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID)) separator '\n\r') INTO v_SkippedWIthOccurence
	  FROM tmp_Invoices_ temp
	  	WHERE (temp.Occurrence > 0 
		  	AND (SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID) >= temp.Occurrence);
     
     /*return message either fill or empty*/
     SELECT CASE 
	  				WHEN ((v_SkippedWIthDate IS NOT NULL) OR (v_SkippedWIthOccurence IS NOT NULL)) 
					THEN CONCAT(IFNULL(v_SkippedWIthDate,''),'\n\r',IFNULL(v_SkippedWIthOccurence,'')) ELSE '' 
				END as message INTO v_Message;

	IF(v_Message="") THEN
        /*insert new invoices and its related detail, texes and updating logs.*/

		INSERT INTO tblInvoice (`CompanyID`, `AccountID`, `Address`, `InvoiceNumber`, `IssueDate`, `CurrencyID`, `PONumber`, `InvoiceType`, `SubTotal`, `TotalDiscount`, `TaxRateID`, `TotalTax`, `InvoiceTotal`, `GrandTotal`, `Description`, `Attachment`, `Note`, `Terms`, `InvoiceStatus`, `PDF`, `UsagePath`, `PreviousBalance`, `TotalDue`, `Payment`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ItemInvoice`, `FooterTerm`,RecurringInvoiceID,ProcessID)
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
		p_ProsessID
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
				
		INSERT INTO tblInvoiceTaxRate ( `InvoiceID`, `TaxRateID`, `TaxAmount`,`InvoiceTaxType`,`Title`, `CreatedBy`,`ModifiedBy`)
		SELECT 
			inv.InvoiceID,
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
			
			/*add log for recurring invoice*/
		INSERT INTO tblRecurringInvoiceLog (RecurringInvoiceID,Note,RecurringInvoiceLogStatus,created_at)
		SELECT inv.RecurringInvoiceID,CONCAT(v_Note, CONCAT(LTRIM(RTRIM(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.InvoiceNumber)))) as Note,p_LogStatus as InvoiceLogStatus,p_CurrentDate as created_at  
		FROM tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN Ratemanagement3.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;
		
		
		/*update full invoice number related to curring processID*/
		UPDATE tblInvoice inv 
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN Ratemanagement3.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		SET FullInvoiceNumber = IF(inv.InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(inv.InvoiceNumber))),ltrim(rtrim(inv.InvoiceNumber)))
		WHERE inv.CompanyID = p_CompanyID 
		AND inv.InvoiceID = v_InvoiceID;
	
	END IF;
	
	SELECT v_Message as Message, IFNULL(v_InvoiceID,0) as InvoiceID;
			
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_CreateRerateLog`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL
	);

	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( "Account:  " , ga.AccountName ," - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga 
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.GatewayAccountID = ud.GatewayAccountID
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

DROP PROCEDURE IF EXISTS `prc_CustomerPanel_getInvoice`;

DELIMITER |
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_DeleteCDR`;

DELIMITER |
CREATE PROCEDURE `prc_DeleteCDR`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)
)
BEGIN

	DECLARE v_BillingTime_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

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
				AND (p_CDRType = '' OR ud.is_inbound = p_CDRType)
				AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
				AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))	
				AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))
				AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
				AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
				AND (p_trunk = '' OR trunk = p_trunk )

		) tbl
		WHERE 

			(v_BillingTime_ =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
			OR 
			(v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
			AND billed_duration > 0
	);


		
	DELETE ud.*
	FROM `RMCDR3`.tblUsageDetails ud
	INNER JOIN tmp_tblUsageDetail_ uds 
		ON ud.UsageDetailID = uds.UsageDetailID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_DeleteVCDR`;

DELIMITER |
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
	    
	        (v_BillingTime_ =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	        OR 
	        (v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	        AND billed_duration > 0
        );


		
		 delete ud.*
        From `RMCDR3`.tblVendorCDR ud
        inner join tmp_tblUsageDetail_ uds on ud.VendorCDRID = uds.VendorCDRID;
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountInvoiceTotal`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountInvoiceTotal`(
	IN `p_AccountID` INT,
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_ServiceID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_checkDuplicate` INT,
	IN `p_InvoiceDetailID` INT
)
BEGIN 
	DECLARE v_InvoiceCount_ INT; 
	DECLARE v_BillingTime_ INT; 
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

	CALL fnServiceUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_ServiceID,p_StartDate,p_EndDate,v_BillingTime_);

	IF p_checkDuplicate = 1 THEN

		SELECT COUNT(inv.InvoiceID) INTO v_InvoiceCount_
		FROM tblInvoice inv
		LEFT JOIN tblInvoiceDetail invd ON invd.InvoiceID = inv.InvoiceID
		WHERE inv.CompanyID = p_CompanyID AND (p_InvoiceDetailID = 0 OR (p_InvoiceDetailID > 0 AND invd.InvoiceDetailID != p_InvoiceDetailID)) AND AccountID = p_AccountID AND
		(
			(p_StartDate BETWEEN invd.StartDate AND invd.EndDate) OR
			(p_EndDate BETWEEN invd.StartDate AND invd.EndDate) OR
			(invd.StartDate BETWEEN p_StartDate AND p_EndDate) 
		) AND inv.InvoiceStatus != 'cancel'; 

		IF v_InvoiceCount_ = 0 THEN

			SELECT IFNULL(CAST(SUM(cost) AS DECIMAL(18,8)), 0) AS TotalCharges
			FROM tmp_tblUsageDetails_ ud; 
		ELSE
			SELECT 0 AS TotalCharges; 
		END IF; 

	ELSE
		SELECT IFNULL(CAST(SUM(cost) AS DECIMAL(18,8)), 0) AS TotalCharges
		FROM tmp_tblUsageDetails_ ud; 
	END IF; 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountNameByGatway`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountNameByGatway`(IN `p_company_id` INT, IN `p_gatewayid` INT
)
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    
     SELECT DISTINCT
                    a.AccountID,
                    a.AccountName                    
                FROM Ratemanagement3.tblAccount a
                INNER JOIN tblGatewayAccount ga ON a.AccountiD = ga.AccountiD AND a.Status = 1
                WHERE GatewayAccountID IS NOT NULL                
                AND a.CompanyId = p_company_id
                AND ga.CompanyGatewayID = p_gatewayid 
					 order by a.AccountName ASC;
					 
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	             
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_getAccountOneOffCharge`(
	IN `p_AccountID` INT,
	IN `p_ServiceID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		tblAccountOneOffCharge.*
	FROM tblAccountOneOffCharge
	INNER JOIN Ratemanagement3.tblAccountService
		ON tblAccountService.AccountID = tblAccountOneOffCharge.AccountID AND tblAccountService.ServiceID = tblAccountOneOffCharge.ServiceID 
	LEFT JOIN Ratemanagement3.tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccountOneOffCharge.AccountID AND tblAccountBilling.ServiceID = tblAccountOneOffCharge.ServiceID
	WHERE tblAccountOneOffCharge.AccountID = p_AccountID
	AND tblAccountOneOffCharge.Date BETWEEN p_StartDate AND p_EndDate
	AND tblAccountService.Status = 1
	AND ( (p_ServiceID = 0 AND tblAccountBilling.ServiceID IS NULL) OR  tblAccountBilling.ServiceID = p_ServiceID);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DELIMITER |
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
	AND Status = 1
	AND ( (p_ServiceID = 0 AND tblAccountBilling.ServiceID IS NULL) OR  tblAccountBilling.ServiceID = p_ServiceID)
	ORDER BY SequenceNo ASC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DELIMITER |
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
		s.ServiceID
		FROM tblAccountSubscription sa
		INNER JOIN tblBillingSubscription sb
		   ON sb.SubscriptionID = sa.SubscriptionID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sa.AccountID = a.AccountID
		INNER JOIN Ratemanagement3.tblService s
			ON sa.ServiceID = s.ServiceID
		WHERE 	(p_AccountID = 0 OR a.AccountID = p_AccountID)
			AND (p_SubscriptionName is null OR sb.Name LIKE concat('%',p_SubscriptionName,'%'))
			AND CASE p_Status 
				WHEN 1 
					THEN (sa.EndDate>=p_Date or sa.EndDate='0000-00-00')
					ELSE (sa.EndDate<p_Date and sa.EndDate <> '0000-00-00')
				END
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
			AND CASE p_Status 
         WHEN 1 
	         THEN (sa.EndDate>=p_Date or sa.EndDate='0000-00-00')
   	      ELSE (sa.EndDate<p_Date and sa.EndDate <> '0000-00-00')
         END
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
		sa.ExemptTax
		FROM tblAccountSubscription sa
		INNER JOIN tblBillingSubscription sb
		   ON sb.SubscriptionID = sa.SubscriptionID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sa.AccountID = a.AccountID
		INNER JOIN Ratemanagement3.tblService s
			ON sa.ServiceID = s.ServiceID
		WHERE 	(p_AccountID = 0 OR a.AccountID = p_AccountID)
			AND (p_SubscriptionName is null OR sb.Name LIKE concat('%',p_SubscriptionName,'%'))
			AND CASE p_Status 
				WHEN 1 
					THEN (sa.EndDate>=p_Date or sa.EndDate='0000-00-00')
					ELSE (sa.EndDate<p_Date and sa.EndDate <> '0000-00-00')
				END
			AND (p_ServiceID =0 OR s.ServiceID = p_ServiceID);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getActiveGatewayAccount`;

DELIMITER |
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
		GatewayAccountID varchar(100),
		AccountID INT,
		ServiceID INT,
		AccountName varchar(100)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_AuthenticateRules_;
	CREATE TEMPORARY TABLE tmp_AuthenticateRules_ (
		RowNo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AuthRule VARCHAR(50)
	);

	/* gateway level authentication rule */
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
	/* service level authentication rule */ 
	IF v_rowCount_ > 0
	THEN

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Service_ t WHERE t.RowID = v_pointer_);

			INSERT INTO tmp_AuthenticateRules_  (AuthRule)
			SELECT DISTINCT CustomerAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CompanyID = p_CompanyID AND CustomerAuthRule IS NOT NULL AND ServiceID = v_ServiceID_
			UNION
			SELECT DISTINCT VendorAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CompanyID = p_CompanyID AND VendorAuthRule IS NOT NULL AND ServiceID = v_ServiceID_;

			CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,v_ServiceID_);

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

	END IF;

	/* account level authentication rule */
	IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountAuthenticate WHERE CompanyID = p_CompanyID AND ServiceID = 0) > 0
	THEN


		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT DISTINCT CustomerAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CompanyID = p_CompanyID AND CustomerAuthRule IS NOT NULL AND ServiceID = 0
		UNION
		SELECT DISTINCT VendorAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CompanyID = p_CompanyID AND VendorAuthRule IS NOT NULL AND ServiceID = 0;

		CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,0);

	END IF;

	CALL prc_ApplyAuthRule(p_CompanyID,p_CompanyGatewayID,0);

	UPDATE tblGatewayAccount
	INNER JOIN tmp_ActiveAccount a
		ON a.GatewayAccountID = tblGatewayAccount.GatewayAccountID
		AND tblGatewayAccount.CompanyGatewayID = p_CompanyGatewayID
		AND tblGatewayAccount.ServiceID = a.ServiceID
	SET tblGatewayAccount.AccountID = a.AccountID
	WHERE tblGatewayAccount.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getBillingSubscription`;

DELIMITER |
CREATE PROCEDURE `prc_getBillingSubscription`(
	IN `p_CompanyID` INT,
	IN `p_Advance` INT,
	IN `p_Name` VARCHAR(50),
	IN `p_CurrencyID` INT,
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
	   
   	IF p_Export = 0
	THEN
		SELECT   
			tblBillingSubscription.Name,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.AnnuallyFee) AS AnnuallyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.QuarterlyFee) AS QuarterlyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.MonthlyFee) AS MonthlyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.WeeklyFee) AS WeeklyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.DailyFee) AS DailyFeeWithSymbol,
			tblBillingSubscription.Advance,
			tblBillingSubscription.SubscriptionID,
			tblBillingSubscription.ActivationFee,
			tblBillingSubscription.CurrencyID,
			tblBillingSubscription.InvoiceLineDescription,
			tblBillingSubscription.Description,
			tblBillingSubscription.AnnuallyFee,
			tblBillingSubscription.QuarterlyFee,
			tblBillingSubscription.MonthlyFee,
			tblBillingSubscription.WeeklyFee,
			tblBillingSubscription.DailyFee
    	FROM tblBillingSubscription
    	LEFT JOIN Ratemanagement3.tblCurrency on tblBillingSubscription.CurrencyID =tblCurrency.CurrencyId 
    	WHERE tblBillingSubscription.CompanyID = p_CompanyID
	        AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'))
		ORDER BY
			CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
            END DESC,
            CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AnnuallyFeeDESC') THEN AnnuallyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AnnuallyFeeASC') THEN AnnuallyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuarterlyFeeDESC') THEN QuarterlyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'QuarterlyFeeASC') THEN QuarterlyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeDESC') THEN MonthlyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeASC') THEN MonthlyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeDESC') THEN WeeklyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeASC') THEN WeeklyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeDESC') THEN DailyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeASC') THEN DailyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AdvanceDESC') THEN Advance
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AdvanceASC') THEN Advance
           	END ASC
         LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
        	COUNT(tblBillingSubscription.SubscriptionID) AS totalcount
     	FROM tblBillingSubscription
     	WHERE tblBillingSubscription.CompanyID = p_CompanyID
			AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'));
 	END IF;
      
      
    IF p_Export = 1
	THEN
		
		SELECT   
			tblBillingSubscription.Name,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.AnnuallyFee) AS AnnuallyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.QuarterlyFee) AS QuarterlyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.MonthlyFee) AS MonthlyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.WeeklyFee) AS WeeklyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.DailyFee) AS DailyFee,
			tblBillingSubscription.ActivationFee,
			tblBillingSubscription.InvoiceLineDescription,
			tblBillingSubscription.Description,
			tblBillingSubscription.Advance
        FROM tblBillingSubscription
        LEFT JOIN Ratemanagement3.tblCurrency on tblBillingSubscription.CurrencyID =tblCurrency.CurrencyId 
        WHERE tblBillingSubscription.CompanyID = p_CompanyID
	    	AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'));
				
	END IF;       
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetCDR`;

DELIMITER |
CREATE PROCEDURE `prc_GetCDR`(
	IN `p_company_id` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT ,
	IN `p_CDRType` CHAR(1),
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
	DECLARE v_CurrencyCode_ VARCHAR(50);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_company_id) INTO v_Round_;

	SELECT cr.Symbol INTO v_CurrencyCode_ FROM Ratemanagement3.tblCurrency cr WHERE cr.CurrencyId =p_CurrencyID;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	Call fnUsageDetail(p_company_id,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CDRType,p_CLI,p_CLD,p_zerovaluecost);

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
			AND (p_trunk = '' OR trunk = p_trunk );

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
			uh.is_inbound
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk );
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpense`;

DELIMITER |
CREATE PROCEDURE `prc_getDashboardinvoiceExpense`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_EndDate` VARCHAR(50),
	IN `p_ListType` VARCHAR(50)
)
BEGIN
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_MonthlyTotalDue_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_MonthlyTotalDue_(
		`Year` int,
		`Month` int,
		`Week` int,
		MonthName varchar(50),
		TotalAmount float,
		CurrencyID int,
		InvoiceStatus VARCHAR(50)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_MonthlyTotalReceived_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_MonthlyTotalReceived_(
		`Year` int,
		`Month` int,
		`Week` int,
		MonthName varchar(50),
		TotalAmount float,
		OutAmount float,
		CurrencyID int
	);
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	INSERT INTO tmp_MonthlyTotalDue_
	SELECT YEAR(IssueDate) as Year
			,MONTH(IssueDate) as Month
			,WEEK(IssueDate) as Week
			,MONTHNAME(MAX(IssueDate)) as  MonthName
			,ROUND(COALESCE(SUM(GrandTotal),0),v_Round_)as TotalAmount
			,CurrencyID
			,InvoiceStatus
	FROM tblInvoice
	WHERE 
		CompanyID = p_CompanyID
		AND CurrencyID = p_CurrencyID
		AND InvoiceType = 1 -- Invoice Out
		AND InvoiceStatus NOT IN ( 'cancel' , 'draft' )
		AND (
			(p_EndDate = '0' AND fnGetMonthDifference(IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate <> '0' AND IssueDate between p_StartDate AND p_EndDate)
			)
		AND (p_AccountID = 0 or AccountID = p_AccountID)
	GROUP BY 
			YEAR(IssueDate)
			,MONTH(IssueDate)
			,Week
			,CurrencyID
			,InvoiceStatus
	ORDER BY 
			Year
			,Month
			,Week;


	DROP TEMPORARY TABLE IF EXISTS tmp_tblPayment_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblPayment_(
		PaymentDate Date,
		Amount float,
		OutAmount float,
		CurrencyID int
	);
	/* payment recevied invoice*/
	INSERT INTO tmp_tblPayment_ (PaymentDate,Amount,OutAmount,CurrencyID)
	SELECT
		PaymentDate,
		SUM(Amount),
		IF(inv.InvoiceStatus='paid' OR inv.InvoiceStatus='partially_paid' ,inv.GrandTotal - SUM(Amount),-SUM(Amount)) as OutAmount,
		TBL.CurrencyId
	FROM	
		(
		SELECT 
			CASE WHEN inv.InvoiceID IS NOT NULL
			THEN
				inv.IssueDate
			ELSE
				p.PaymentDate
			END as PaymentDate,
			p.Amount,
			inv.InvoiceID,
			ac.CurrencyId
			
		FROM tblPayment p 
		INNER JOIN Ratemanagement3.tblAccount ac 
			ON ac.AccountID = p.AccountID
		LEFT JOIN tblInvoice inv ON p.AccountID = inv.AccountID
			AND p.InvoiceID = inv.InvoiceID
			AND p.Status = 'Approved' 
			AND p.AccountID = inv.AccountID 
			AND p.Recall=0
			AND InvoiceType = 1 
		WHERE 
				p.CompanyID = p_CompanyID
			AND ac.CurrencyId = p_CurrencyID
			AND (
				(p_EndDate = '0' AND ((fnGetMonthDifference(p.PaymentDate,NOW()) <= p_StartDate) OR (fnGetMonthDifference(inv.IssueDate,NOW()) <= p_StartDate))) OR
				(p_EndDate<>'0' AND ( p.PaymentDate BETWEEN p_StartDate AND p_EndDate  OR  inv.IssueDate BETWEEN p_StartDate AND p_EndDate))
				)
			AND p.Status = 'Approved'
			AND p.Recall=0
			AND p.PaymentType = 'Payment In'
			AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
			)TBL
	LEFT JOIN tblInvoice inv
		ON TBL.InvoiceID = inv.InvoiceID	
	GROUP BY TBL.PaymentDate,TBL.InvoiceID;

	
		
	IF p_ListType = 'Weekly'
	THEN
	
		INSERT INTO tmp_MonthlyTotalReceived_
		SELECT YEAR(p.PaymentDate) as Year
				,MONTH(p.PaymentDate) as Month
				,WEEK(p.PaymentDate) as week
				,MONTHNAME(MAX(p.PaymentDate)) as  MonthName
				,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
				,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
				,CurrencyID
		FROM tmp_tblPayment_ p 
		GROUP BY 
			YEAR(p.PaymentDate)
			,MONTH(p.PaymentDate)
			,week
			,CurrencyID		
		ORDER BY 
			Year
			,Month
			,week;
		
		SELECT 
			CONCAT(td.`Week`,'-',MAX( td.Year)) AS MonthName ,
			MAX( td.Year) AS `Year`,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,  
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived, 
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Weekly' as ftype 
		FROM  
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr 
			ON td.Week = tr.Week 
			AND td.Year = tr.Year 
			AND td.Month = tr.Month 
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY 
			td.Week,
			td.Year,
			td.CurrencyID
		ORDER BY 
			td.Year
			,td.Week;
	END IF;

	IF p_ListType = 'Monthly'
	THEN
		INSERT INTO tmp_MonthlyTotalReceived_
		SELECT YEAR(p.PaymentDate) as Year
				,MONTH(p.PaymentDate) as Month
				,1			
				,MONTHNAME(MAX(p.PaymentDate)) as  MonthName				
				,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
				,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
				,CurrencyID
		FROM tmp_tblPayment_ p 
		GROUP BY 
			YEAR(p.PaymentDate)
			,MONTH(p.PaymentDate)		
			,CurrencyID		
		ORDER BY 
			Year
			,Month;
		
		
		SELECT 
			CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName ,
			td.Year,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,  
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived, 
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Monthly' as ftype
		FROM  
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr 
			ON td.Month = tr.Month 
			AND td.Year = tr.Year 
			-- AND td.Week = tr.Week 
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY 
			td.Month,
			td.Year,
			td.CurrencyID
		ORDER BY 
			td.Year
			,td.Month;
	END IF;

	IF p_ListType = 'Yearly'
	THEN
			INSERT INTO tmp_MonthlyTotalReceived_
			SELECT YEAR(p.PaymentDate) as Year
					,1 -- MONTH(p.PaymentDate) as Month
					,1			
					,'Oct' as  MonthName
					,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
					,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
					,CurrencyID
			FROM tmp_tblPayment_ p 
			GROUP BY 
				YEAR(p.PaymentDate)
			 	-- ,MONTH(p.PaymentDate)		
				,CurrencyID		
			ORDER BY 
				Year;
			-- 	,Month;
			
		SELECT 
			td.Year as MonthName,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,  
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived, 
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Yearly' as ftype
		FROM  
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr 
			ON td.Year = tr.Year 
		-- 	AND td.Week = tr.Week 
		-- 	AND td.Month = tr.Month 
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY 
			td.Year,
			td.CurrencyID
		ORDER BY 
			td.Year;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpenseDrilDown`;

DELIMITER |
CREATE PROCEDURE `prc_getDashboardinvoiceExpenseDrilDown`(IN `p_CompanyID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` VARCHAR(50), IN `p_EndDate` VARCHAR(50), IN `p_Type` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_CustomerID` INT, IN `p_Export` INT)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_TotalCount int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT cr.Symbol INTO v_CurrencyCode_ from Ratemanagement3.tblCurrency cr WHERE cr.CurrencyId =p_CurrencyID;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_Type = 1  -- Payment Recived

	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_Payment_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payment_(
			AccountName varchar(100),
			Amount decimal(18,6),
			PaymentDate datetime,
			CreatedBy varchar(50),
			InvoiceNo varchar(50),
			Notes varchar(500),
			AmountWithSymbol varchar(30)
		);
		
		INSERT INTO tmp_Payment_
		SELECT 
			ac.AccountName,
			ROUND(p.Amount,v_Round_) AS Amount,
			CASE WHEN inv.InvoiceID IS NOT NULL
			THEN
				inv.IssueDate
			ELSE
				p.PaymentDate
			END as PaymentDate,
			p.CreatedBy,
			p.InvoiceNo,
			p.Notes,
			CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(p.Amount,v_Round_)) as AmountWithSymbol
		FROM tblPayment p 
		INNER JOIN Ratemanagement3.tblAccount ac 
			ON ac.AccountID = p.AccountID
		LEFT JOIN tblInvoice inv on p.InvoiceID = inv.InvoiceID 
			AND p.Status = 'Approved' 
			AND p.AccountID = inv.AccountID 
			AND p.Recall=0
			AND InvoiceType = 1 
		WHERE 
			p.CompanyID = p_CompanyID
			AND ac.CurrencyId = p_CurrencyID
			AND (p_CustomerID=0 OR ac.AccountID = p_CustomerID)
			AND p.Status = 'Approved'
			AND p.Recall=0
			AND p.PaymentType = 'Payment In';

		IF  p_Export = 0
		THEN
			SELECT 
				AccountName,
				InvoiceNo,
				AmountWithSymbol,
				PaymentDate,
				CreatedBy,
				Notes
			FROM tmp_Payment_
			WHERE (PaymentDate BETWEEN p_StartDate AND p_EndDate)
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
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateDESC') THEN PaymentDate
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateASC') THEN PaymentDate
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN CreatedBy
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN CreatedBy
					END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;
			
			
			SELECT COUNT(AccountName) AS totalcount,ROUND(COALESCE(SUM(Amount),0),v_Round_) as totalsum
			FROM tmp_Payment_
			WHERE (PaymentDate BETWEEN p_StartDate AND p_EndDate);
		END IF;
		
		IF p_Export=1
		THEN
			SELECT 
				AccountName,
				Amount,
				PaymentDate,
				CreatedBy,
				InvoiceNo,
				Notes
			FROM tmp_Payment_
			WHERE (PaymentDate BETWEEN p_StartDate AND p_EndDate); 
		END IF;
	END IF;
	
	IF p_Type=2 OR p_Type=3 -- 2. Total Invoices 3. Total OutStanding

	THEN
	
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
			AccountID int,
			ItemInvoice tinyint(1),
			BillingEmail varchar(255),
			AccountNumber varchar(100),
			PaymentDueInDays int,
			PaymentDate datetime,
			SubTotal decimal(18,6)
		);
	
		INSERT INTO tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			inv.FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			inv.GrandTotal as GrandTotal,
			(SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (SELECT IFNULL(sum(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			inv.InvoiceID,
			inv.AccountID,
			inv.ItemInvoice,
			IFNULL(ac.BillingEmail,'') as BillingEmail,
			ac.Number,
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID LIMIT 1) as PaymentDueInDays,
			(SELECT PaymentDate FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID ORDER BY PaymentID DESC LIMIT 1) AS PaymentDate,
			inv.SubTotal
		FROM tblInvoice inv
		INNER JOIN Ratemanagement3.tblAccount ac ON inv.AccountID = ac.AccountID
		AND (p_CustomerID=0 OR ac.AccountID = p_CustomerID)
		LEFT JOIN tblInvoiceDetail invd on invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
		LEFT JOIN Ratemanagement3.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
		WHERE inv.CompanyID = p_CompanyID
			AND cr.CurrencyID = p_CurrencyID
			AND (IssueDate BETWEEN p_StartDate AND p_EndDate)
			AND InvoiceType = 1
			AND ((p_Type=2 AND inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' )) OR (p_Type=3 AND inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'paid')))
			AND (GrandTotal<>0);
		IF p_Export = 0
		THEN
			SELECT 
				AccountName,
				InvoiceNumber,
				IssueDate,
				InvoicePeriod,
				CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
				CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
				InvoiceStatus,
				InvoiceID,
				AccountID,
				PendingAmount as OutstandingAmount,
				ItemInvoice,
				BillingEmail,
				GrandTotal
			FROM tmp_Invoices_
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

				SELECT COUNT(*) AS totalcount,
					ROUND(COALESCE(SUM(GrandTotal),0),v_Round_) as totalsum, 
					ROUND(COALESCE(SUM(TotalPayment),0),v_Round_) totalpaymentsum,
					ROUND(COALESCE(SUM(PendingAmount),0),v_Round_) totalpendingsum,
					v_CurrencyCode_ as currencySymbol
				FROM tmp_Invoices_;

		END IF;
		IF p_Export=1
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
			FROM tmp_Invoices_;
		END IF;
	END IF;
		
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpenseTotalOutstanding`;

DELIMITER |
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

	/* all disputes with pending status*/
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

	/* all estimates with are pending to conevert invoice*/
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
	
	/* all invoice sent and recived*/
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

	/* all payments recevied and sent*/
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

	
	/* total outstanding 
	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) INTO v_TotalInvoiceOut_,v_TotalInvoiceIn_
	FROM tmp_Invoices_;
	
	SELECT 
		SUM(IF(PaymentType='Payment In',PaymentAmount,0)),
		SUM(IF(PaymentType='Payment Out',PaymentAmount,0)) INTO v_TotalPaymentIn_,v_TotalPaymentOut_
	FROM tmp_Payment_;
	
	SELECT (IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)) INTO v_TotalOutstanding_;*/
	
	/* outstanding */
	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) INTO v_TotalInvoiceOut_,v_TotalInvoiceIn_
	FROM tmp_Invoices_;
	
	SELECT 
		SUM(IF(PaymentType='Payment In',PaymentAmount,0)),
		SUM(IF(PaymentType='Payment Out',PaymentAmount,0)) INTO v_TotalPaymentIn_,v_TotalPaymentOut_
	FROM tmp_Payment_;

	SELECT (IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)) INTO v_Outstanding_;
	
	/* Invoice Sent Total */
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceSentTotal_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1;

	/* Invoice Received Total*/
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceRecvTotal_
	FROM tmp_Invoices_ 
	WHERE  InvoiceType = 2;
	
	/* Payment Received */
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentRecvTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment In';
	
	/* Payment Sent */
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentSentTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment Out';
	
	/*Total Unpaid Invoices*/	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalUnpaidInvoices_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1
	AND InvoiceStatus <> 'paid' 
	AND PendingAmount > 0;
		
	/*Total Overdue Invoices*/	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalOverdueInvoices_
	FROM tmp_Invoices_ 
	WHERE ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting'))
							AND(PendingAmount>0)
						);
	/*Total Paid Invoices*/	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalPaidInvoices_
	FROM tmp_Invoices_ 
	WHERE (InvoiceStatus IN('Paid') AND (PendingAmount=0));
	
	/*Total Dispute*/	
	SELECT IFNULL(SUM(DisputeAmount),0) INTO v_TotalDispute_
	FROM tmp_Dispute_;
	
	/*Total Estimate*/
	SELECT IFNULL(SUM(EstimateTotal),0) INTO v_TotalEstimate_
	FROM tmp_Estimate_;
	
	SELECT 
			/*ROUND(v_TotalOutstanding_,v_Round_) AS TotalOutstanding,*/
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashBoardPinCodes`;

DELIMITER |
CREATE PROCEDURE `prc_getDashBoardPinCodes`(IN `p_CompanyID` INT, IN `p_StartDate` DATE, IN `p_EndDate` DATE, IN `p_AccountID` INT, IN `p_Type` INT, IN `p_Limit` INT, IN `p_PinExt` VARCHAR(50), IN `p_CurrencyID` INT)
    COMMENT 'Top 10 pincodes p_Type = 1 = cost,p_Type =2 =Duration'
BEGIN
	DECLARE v_Round_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	CALL fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	IF p_Type =1 AND  p_PinExt = 'pincode' /* Top Pincodes by cost*/
	THEN 
	
		SELECT ROUND(SUM(ud.cost),v_Round_) as PincodeValue,IFNULL(ud.pincode,'n/a') as Pincode  FROM tmp_tblUsageDetails_ ud 
		INNER JOIN Ratemanagement3.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.pincode IS NOT NULL AND ud.pincode != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.pincode
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =2 AND  p_PinExt = 'pincode' /* Top Pincodes by Duration*/
	THEN 
	
		SELECT SUM(ud.billed_duration) as PincodeValue,IFNULL(ud.pincode,'n/a') as Pincode FROM tmp_tblUsageDetails_ ud
		INNER JOIN Ratemanagement3.tblAccount a on ud.AccountID = a.AccountID  
		WHERE  ud.cost>0 AND ud.pincode IS NOT NULL AND ud.pincode != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.pincode
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =1 AND  p_PinExt = 'extension' /* Top Extension by cost*/
	THEN 
	
		SELECT ROUND(SUM(ud.cost),v_Round_) as PincodeValue,IFNULL(ud.extension,'n/a') as Pincode  FROM tmp_tblUsageDetails_ ud 
		INNER JOIN Ratemanagement3.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.extension IS NOT NULL AND ud.extension != ''
			AND a.CurrencyId = p_CurrencyID 
		GROUP BY ud.extension
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =2 AND  p_PinExt = 'extension' /* Top Extension by Duration*/
	THEN 
	
		SELECT SUM(ud.billed_duration) as PincodeValue,IFNULL(ud.extension,'n/a') as Pincode FROM tmp_tblUsageDetails_ ud
		INNER JOIN Ratemanagement3.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.extension IS NOT NULL AND ud.extension != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.extension
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDashboardTotalOutStanding`;

DELIMITER |
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
		AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft') )  )
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
	
	--	SELECT ROUND((v_TotalInvoice_ - v_TotalPayment_),v_Round_) AS TotalOutstanding ;
	SELECT 
		ROUND((IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)),v_Round_) AS TotalOutstanding,
		ROUND((IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)),v_Round_) AS TotalReceivable,
		ROUND((IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)),v_Round_) AS TotalPayable;
	


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDisputeDetail`;

DELIMITER |
CREATE PROCEDURE `prc_getDisputeDetail`(IN `p_CompanyID` INT, IN `p_DisputeID` INT)
BEGIN

 
 
 
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 

				SELECT   
				ds.DisputeID,
				CASE WHEN ds.InvoiceType = 2 THEN 'Invoice Received' 
				     WHEN ds.InvoiceType = 1 THEN 'Invoice Sent' 
				     ELSE ''
				END as InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				ds.Notes,
 			   CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at,
				ds.CreatedBy,
		 		ds.Attachment,
		 		ds.updated_at
            from tblDispute ds
            inner join Ratemanagement3.tblAccount a on a.CompanyId = ds.CompanyID and a.AccountID = ds.AccountID
            where ds.CompanyID = p_CompanyID
            AND ds.DisputeID = p_DisputeID
				limit 1;
            
            

 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
 

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDisputes`;

DELIMITER |
CREATE PROCEDURE `prc_getDisputes`(IN `p_CompanyID` INT, IN `p_InvoiceType` INT, IN `p_AccountID` INT, IN `p_InvoiceNumber` VARCHAR(100), IN `p_Status` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_Export` INT)
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
		 		ds.Notes
		 		
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
            
            
	ELSE

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

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getDueInvoice`;

DELIMITER |
CREATE PROCEDURE `prc_getDueInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_BillingClassID` INT
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT * FROM(
		SELECT
			inv.InvoiceID AS InvoiceID,
			inv.GrandTotal,
			inv.GrandTotal - (SELECT COALESCE(SUM(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) AS InvoiceOutStanding,
			inv.FullInvoiceNumber as InvoiceNumber,
			DATE_ADD(inv.IssueDate,INTERVAL b.PaymentDueInDays DAY) as DueDate,
			DATEDIFF(NOW(),DATE_ADD(inv.IssueDate,INTERVAL b.PaymentDueInDays DAY)) as DueDay,
			a.AccountID,
			a.created_at as AccountCreationDate
		FROM tblInvoice inv
		INNER JOIN Ratemanagement3.tblAccount a
			ON inv.AccountID = a.AccountID
		INNER JOIN Ratemanagement3.tblAccountBilling ab
			ON ab.AccountID = a.AccountID	AND ab.ServiceID = inv.ServiceID
		INNER JOIN Ratemanagement3.tblBillingClass b
			ON b.BillingClassID = ab.BillingClassID
		WHERE inv.CompanyID = p_CompanyID
		AND ( p_AccountID = 0 OR inv.AccountID =   p_AccountID)
		AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
		AND InvoiceStatus NOT IN('awaiting','draft','Cancel')
		AND inv.GrandTotal <> 0
	)tbl
	WHERE InvoiceOutStanding > 0 ;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getEstimate`;

DELIMITER |
CREATE PROCEDURE `prc_getEstimate`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_EstimateNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_EstimateStatus` VARCHAR(50),
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
        CONCAT(LTRIM(RTRIM(IFNULL(it.EstimateNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber))) AS EstimateNumber,
        inv.IssueDate,
        CONCAT(IFNULL(cr.Symbol,''),ROUND(inv.GrandTotal,v_Round_)) AS GrandTotal2,		
        inv.EstimateStatus,
        inv.EstimateID,
        inv.Description,
        inv.Attachment,
        inv.AccountID,		  
		  IFNULL(ac.BillingEmail,'') AS BillingEmail,
		  ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
		  inv.converted
        FROM tblEstimate inv
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
        /*INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = ac.AccountID AND ab.ServiceID = 0
        INNER JOIN Ratemanagement3.tblBillingClass b ON ab.BillingClassID = b.BillingClassID*/
		INNER JOIN Ratemanagement3.tblBillingClass b ON inv.BillingClassID = b.BillingClassID	
		LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        LEFT JOIN Ratemanagement3.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID))
        ORDER BY
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ac.AccountName
            END DESC,
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ac.AccountName
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateStatusDESC') THEN inv.EstimateStatus
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateStatusASC') THEN inv.EstimateStatus
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateNumberASC') THEN inv.EstimateNumber
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateNumberDESC') THEN inv.EstimateNumber
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN inv.IssueDate
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN inv.IssueDate
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN inv.GrandTotal
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN inv.GrandTotal
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateIDDESC') THEN inv.EstimateID
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateIDASC') THEN inv.EstimateID
            END ASC
        
        LIMIT p_RowspPage OFFSET v_OffSet_;
        
        
        SELECT
            COUNT(*) AS totalcount,  ROUND(SUM(inv.GrandTotal),v_Round_) AS total_grand,v_CurrencyCode_ as currency_symbol
        FROM
        tblEstimate inv
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
        /*INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = ac.AccountID AND ab.ServiceID = 0
        INNER JOIN Ratemanagement3.tblBillingClass b ON ab.BillingClassID = b.BillingClassID*/
		INNER JOIN Ratemanagement3.tblBillingClass b ON inv.BillingClassID = b.BillingClassID
		LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF;
    IF p_isExport = 1
    THEN
        SELECT ac.AccountName ,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber)))) AS EstimateNumber,
        inv.IssueDate,
        ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
        inv.EstimateStatus
        FROM tblEstimate inv
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
        /*INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = ac.AccountID AND ab.ServiceID = 0
        INNER JOIN Ratemanagement3.tblBillingClass b ON ab.BillingClassID = b.BillingClassID*/
		INNER JOIN Ratemanagement3.tblBillingClass b ON inv.BillingClassID = b.BillingClassID
	    LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF;
     IF p_isExport = 2
    THEN
        SELECT ac.AccountID ,
        ac.AccountName,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber)))) AS EstimateNumber,
        inv.IssueDate,
		  ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
        inv.EstimateStatus,
        inv.EstimateID
        FROM tblEstimate inv
        INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
       /* INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = ac.AccountID AND ab.ServiceID = 0
        INNER JOIN Ratemanagement3.tblBillingClass b ON ab.BillingClassID = b.BillingClassID*/
		INNER JOIN Ratemanagement3.tblBillingClass b ON inv.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF; 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetEstimateLog`;

DELIMITER |
CREATE PROCEDURE `prc_GetEstimateLog`(IN `p_CompanyID` INT, IN `p_EstimateID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    IF p_isExport = 0
    THEN

       
            SELECT
                el.Note,
                el.EstimateLogStatus,
                el.created_at,                
                es.EstimateID                
            FROM tblEstimate es
            INNER JOIN Ratemanagement3.tblAccount ac
                ON ac.AccountID = es.AccountID
            INNER JOIN tblEstimateLog el
                ON el.EstimateID = es.EstimateID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_EstimateID = '' 
            OR (p_EstimateID != ''
            AND es.EstimateID = p_EstimateID))
             ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateLogStatusDESC') THEN el.EstimateLogStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateLogStatusASC') THEN el.EstimateLogStatus
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
        FROM tblEstimate es
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblEstimateLog el
            ON el.EstimateID = es.EstimateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_EstimateID = ''
        OR (p_EstimateID != ''
        AND es.EstimateID = p_EstimateID));

    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            el.Note,
            el.created_at,
            el.EstimateLogStatus,
            es.EstimateNumber
        FROM tblEstimate es
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblEstimateLog el
            ON el.EstimateID = es.EstimateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_EstimateID = ''
        OR (p_EstimateID != ''
        AND es.EstimateID = p_EstimateID));


    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

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
	IN `p_InvoiceID` LONGTEXT

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
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID AND ab.ServiceID = inv.ServiceID LIMIT 1) as PaymentDueInDays,
			(SELECT PaymentDate FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID ORDER BY PaymentID DESC LIMIT 1) AS PaymentDate,
			inv.SubTotal,
			inv.TotalTax,
			ac.NominalAnalysisNominalAccountNumber
			FROM tblInvoice inv
			INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
			LEFT JOIN tblInvoiceDetail invd ON invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
			LEFT JOIN Ratemanagement3.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
			WHERE ac.CompanyID = p_CompanyID
			AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
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

		-- just extra field InvoiceID

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
			-- mark as paid invoice that are sage export

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
			4 AS SYSTraderTranType, -- 4 - Sales invoice (SI)
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

DROP PROCEDURE IF EXISTS `prc_GetInvoiceLog`;

DELIMITER |
CREATE PROCEDURE `prc_GetInvoiceLog`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT
)
BEGIN


	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	            
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


    IF p_isExport = 0
    THEN

       
            SELECT
                tl.Note,
                tl.InvoiceLogStatus,
                tl.created_at,                
                inv.InvoiceID
                
            FROM tblInvoice inv
            INNER JOIN Ratemanagement3.tblAccount ac
                ON ac.AccountID = inv.AccountID
            INNER JOIN tblInvoiceLog tl
                ON tl.InvoiceID = inv.InvoiceID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_InvoiceID = '' 
            OR (p_InvoiceID != ''
            AND inv.InvoiceID = p_InvoiceID))
             ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceLogStatusDESC') THEN tl.InvoiceLogStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceLogStatusASC') THEN tl.InvoiceLogStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tl.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tl.created_at
                END ASC
					LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblInvoice inv
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblInvoiceLog tl
            ON tl.InvoiceID = inv.InvoiceID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));

    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            tl.Note,
            tl.created_at,
            tl.InvoiceLogStatus,
            inv.InvoiceNumber
        FROM tblInvoice inv
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblInvoiceLog tl
            ON tl.InvoiceID = inv.InvoiceID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));


    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetInvoiceTransactionLog`;

DELIMITER |
CREATE PROCEDURE `prc_GetInvoiceTransactionLog`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` int



)
BEGIN
    
    DECLARE v_OffSet_ int;
    DECLARE v_Round_ int;
    DECLARE v_Currency_ VARCHAR(10);
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	/*SELECT cr.Symbol INTO v_Currency_ FROM Ratemanagement3.tblCurrency cr
	INNER JOIN Ratemanagement3.tblAccount ac ON ac.CurrencyId = cr.CurrencyId
	WHERE ac.AccountID = p_AccountID;*/


    IF p_isExport = 0
    THEN

         
            SELECT
                `Transaction`,
                tl.Notes,
                ROUND(tl.Amount,v_Round_) as Amount,
                /*CONCAT(v_Currency_,ROUND(tl.Amount,v_Round_)) as Amount,*/
                tl.Status,
                tl.created_at,
                inv.InvoiceID
                
            FROM tblInvoice inv
            INNER JOIN Ratemanagement3.tblAccount ac
                ON ac.AccountID = inv.AccountID
            INNER JOIN tblTransactionLog tl
                ON tl.InvoiceID = inv.InvoiceID
                AND tl.CompanyID = inv.CompanyID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_AccountID = 0
            OR (p_AccountID != 0
            AND inv.AccountID = p_AccountID))
            AND (p_InvoiceID = ''
            OR (p_InvoiceID != ''
            AND inv.InvoiceID = p_InvoiceID)) 
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN tl.Amount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN tl.Amount
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tl.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tl.Status
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tl.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tl.created_at
                END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblInvoice inv
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblTransactionLog tl
            ON tl.InvoiceID = inv.InvoiceID
            AND tl.CompanyID = inv.CompanyID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0
        OR (p_AccountID != 0
        AND inv.AccountID = p_AccountID))
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));

    END IF;
    
    IF p_isExport = 1
    THEN

        SELECT
            inv.InvoiceNumber,
				`Transaction`,
            tl.Notes,
            tl.created_at,
            ROUND(tl.Amount,v_Round_) as Amount,
            /*CONCAT(v_Currency_,ROUND(tl.Amount,v_Round_)) as Amount,*/
            tl.Status,
            inv.InvoiceID
        FROM tblInvoice inv
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblTransactionLog tl
            ON tl.InvoiceID = inv.InvoiceID
            AND tl.CompanyID = inv.CompanyID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0
        OR (p_AccountID != 0
        AND inv.AccountID = p_AccountID))
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));
		  
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getInvoiceUsage`;

DELIMITER |
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
			ud.ServiceID
		FROM tmp_tblUsageDetails_ ud
		GROUP BY ud.area_prefix,ud.Trunk,ud.AccountID,ud.ServiceID;

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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getMissingAccounts`;

DELIMITER |
CREATE PROCEDURE `prc_getMissingAccounts`(IN `p_CompanyID` int, IN `p_CompanyGatewayID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT cg.Title,ga.AccountName from tblGatewayAccount ga
	inner join Ratemanagement3.tblCompanyGateway cg on ga.CompanyGatewayID = cg.CompanyGatewayID
	where ga.GatewayAccountID is not null and ga.CompanyID =p_CompanyID and ga.AccountID is null AND cg.`Status` =1
	AND (p_CompanyGatewayID = 0 or ga.CompanyGatewayID = p_CompanyGatewayID )
	ORDER BY ga.CompanyGatewayID,ga.AccountName;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getPaymentPendingInvoice`;

DELIMITER |
CREATE PROCEDURE `prc_getPaymentPendingInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_PaymentDueInDays` INT 
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		MAX(i.InvoiceID) AS InvoiceID,
		(IFNULL(MAX(i.GrandTotal), 0) - IFNULL(SUM(p.Amount), 0)) AS RemaingAmount
	FROM tblInvoice i
	INNER JOIN Ratemanagement3.tblAccount a
		ON i.AccountID = a.AccountID
	INNER JOIN Ratemanagement3.tblAccountBilling ab 
		ON ab.AccountID = a.AccountID AND ab.ServiceID = i.ServiceID
	INNER JOIN Ratemanagement3.tblBillingClass b
		ON b.BillingClassID = ab.BillingClassID
	LEFT JOIN tblPayment p
		ON p.AccountID = i.AccountID
		AND p.InvoiceID = i.InvoiceID AND p.Status = 'Approved' AND p.AccountID = i.AccountID
		AND p.Status = 'Approved'
		AND p.Recall = 0
	WHERE i.CompanyID = p_CompanyID
	AND i.InvoiceStatus != 'cancel'
	AND i.AccountID = p_AccountID
	AND (p_PaymentDueInDays =0  OR (p_PaymentDueInDays =1 AND TIMESTAMPDIFF(DAY, i.IssueDate, NOW()) >= IFNULL(b.PaymentDueInDays,0) ) )

	GROUP BY i.InvoiceID,
			 p.AccountID
	HAVING (IFNULL(MAX(i.GrandTotal), 0) - IFNULL(SUM(p.Amount), 0)) > 0;
	
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
	IN `p_isExport` INT 



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
			AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
			AND((p_FullInvoiceNumber = '' OR tblPayment.InvoiceNo = p_FullInvoiceNumber))
			AND((p_Status IS NULL OR tblPayment.Status = p_Status))
			AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
			AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);
	END IF;
	
	-- export data for customer panel
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

DROP PROCEDURE IF EXISTS `prc_getPincodesGrid`;

DELIMITER |
CREATE PROCEDURE `prc_getPincodesGrid`(IN `p_CompanyID` INT, IN `p_Pincode` VARCHAR(50), IN `p_PinExt` VARCHAR(50), IN `p_StartDate` DATE, IN `p_EndDate` DATE, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_isExport` INT)
    COMMENT 'Pincodes Grid For DashBorad'
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	CALL fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	
	IF p_isExport = 0
	THEN
		SELECT
      	cld as DestinationNumber,
         CONCAT(IFNULL(c.Symbol,''),ROUND(SUM(cost),v_Round_)) AS TotalCharges,
 			COUNT(UsageDetailID) AS NoOfCalls
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a ON a.AccountID = uh.AccountID
		LEFT  JOIN Ratemanagement3.tblCurrency c ON c.CurrencyId = a.CurrencyId
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld
		ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DestinationNumberDESC') THEN DestinationNumber
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DestinationNumberASC') THEN DestinationNumber
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID) 
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID) 
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT COUNT(*) as totalcount FROM(SELECT
      	DISTINCT cld 
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a on a.AccountID = uh.AccountID
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld) tbl;
		
	END IF;
	
	IF p_isExport = 1
	THEN
		SELECT
      	cld as `Destination Number`,
         CONCAT(IFNULL(c.Symbol,''),ROUND(SUM(cost),v_Round_)) AS `Total Cost`,
 			COUNT(UsageDetailID) AS `Number of Times Dialed`
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a on a.AccountID = uh.AccountID
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetRecurringInvoiceLog`;

DELIMITER |
CREATE PROCEDURE `prc_GetRecurringInvoiceLog`(
	IN `p_CompanyID` INT,
	IN `p_RecurringInvoiceID` INT,
	IN `p_Status` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT

)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;         
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
   IF p_isExport = 0
    THEN
      SELECT
          rinvlg.Note,
          rinvlg.RecurringInvoiceLogStatus,
          rinvlg.created_at,                
          inv.RecurringInvoiceID
          
      FROM tblRecurringInvoice inv
      INNER JOIN Ratemanagement3.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status)
       ORDER BY
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceLogStatusDESC') THEN rinvlg.RecurringInvoiceLogStatus
          END DESC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceLogStatusASC') THEN rinvlg.RecurringInvoiceLogStatus
          END ASC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN rinvlg.created_at
          END DESC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN rinvlg.created_at
          END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;

     SELECT
         COUNT(*) AS totalcount
     FROM tblRecurringInvoice inv
      INNER JOIN Ratemanagement3.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status);
    END IF;
    IF p_isExport = 1
    THEN
     SELECT
         rinvlg.Note,
         rinvlg.created_at,
         rinvlg.InvoiceLogStatus,
         inv.InvoiceNumber
     FROM tblRecurringInvoice inv
      INNER JOIN Ratemanagement3.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status);
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getRecurringInvoices`;

DELIMITER |
CREATE PROCEDURE `prc_getRecurringInvoices`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_Status` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ INT;
	DECLARE v_Round_ INT;    
	SET sql_mode = 'ALLOW_INVALID_DATES';
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	     
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	IF p_isExport = 0
	THEN
	  SELECT
	  rinv.RecurringInvoiceID,
	  rinv.Title, 
	  ac.AccountName,
	  DATE(rinv.LastInvoicedDate),
	  DATE(rinv.NextInvoiceDate),
	  CONCAT(IFNULL(cr.Symbol,''),ROUND(rinv.GrandTotal,v_Round_)) AS GrandTotal2,		
	  rinv.`Status`,
	  rinv.Occurrence,
	  (SELECT COUNT(InvoiceID) FROM tblInvoice WHERE (InvoiceStatus!='awaiting' AND InvoiceStatus!='cancel' ) AND RecurringInvoiceID = rinv.RecurringInvoiceID) as Sent,
	  rinv.BillingCycleType,
	  rinv.BillingCycleValue,
	  rinv.AccountID,
	  ROUND(rinv.GrandTotal,v_Round_) AS GrandTotal
	  FROM tblRecurringInvoice rinv
	  INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN Ratemanagement3.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status)
	  ORDER BY
	  		CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN rinv.Title
	      END DESC,
	          CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN rinv.Title
	      END ASC,
	   	CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ac.AccountName
	      END DESC,
	          CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ac.AccountName
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastInvoicedDateDESC') THEN rinv.LastInvoicedDate
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastInvoicedDateASC') THEN rinv.LastInvoicedDate
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextInvoiceDateDESC') THEN rinv.NextInvoiceDate
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextInvoiceDateASC') THEN rinv.NextInvoiceDate
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceStatusDESC') THEN rinv.`Status`
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceStatusASC') THEN rinv.`Status`
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN rinv.GrandTotal
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN rinv.GrandTotal
	      END ASC
	  
	  LIMIT p_RowspPage OFFSET v_OffSet_;
	  
	  
	  SELECT
	      COUNT(*) AS totalcount,  ROUND(SUM(rinv.GrandTotal),v_Round_) AS total_gran 
	  FROM tblRecurringInvoice rinv
	  INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN Ratemanagement3.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status);
	END IF;
	IF p_isExport = 1
	THEN
	  SELECT 
	  ac.AccountName,
	  rinv.LastInvoiceNumber,
	  rinv.LastInvoicedDate,		
	  rinv.Description,		  
	  IFNULL(ac.BillingEmail,'') AS BillingEmail,
	  ROUND(rinv.GrandTotal,v_Round_) AS GrandTotal
	  FROM tblRecurringInvoice rinv
	  INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN Ratemanagement3.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status);
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getSOA`;

DELIMITER |
CREATE PROCEDURE `prc_getSOA`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_StartDate` datetime,
	IN `p_EndDate` datetime,
	IN `p_isExport` INT 




)
BEGIN
  
  
    	-- Broght forward - to find balance offset before given range ( if start date = 24/02/2017  - balance offset before 24/02/2017  ).
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
  
  

/*
      New Logic

      -- 1  Invoice In/Out into tmp
      -- 2  Invoice in/out for balance brought forward into tmp
      -- 3  Payment In/Out  into tmp
      -- 4  Payment in/out for balance brought forward into tmp
      -- 5  Unresolved desputes ( Status = 0) into tmp
      -- 6  Invoice Out With Disputes  into tmp
      -- 7  SELECT Invoice Out with Disputes and Payments
      -- 8  Invoice In With Disputes into tmp
      -- 9  SELECT Invoice In With Disputes and Payments
      -- 10 SELECT Total Invoice Sent Amount
      -- 11 SELECT Total Invoice Out Dispute Amount
      -- 12 SELECT Total Payment In Amount
      -- 13 SELECT Total Invoice In Amount
      -- 14 SELECT Total Invoice In Dispute Amount
      -- 15 SELECT Total Payment Out Amount
      -- 16 SELECT Bought forward Total Invoice Out Amount
      -- 17 SELECT Bought forward Total Payment In Amount
      -- 18 SELECT Bought forward Total Invoice In Amount
      -- 19 SELECT Bought forward Total Payment Out Amount
    */
    
     
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
	
	-- Balance Broght forward
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

	
	-- Balance Broght forward
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
      where PaymentType = 'Payment Out' AND  tmp_Payments.InvoiceNo = ''
  
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
    
	
	-- ------------ broght forward
	
	select sum(ifnull(Amount,0)) as InvoiceOutAmountTotal  into v_bf_InvoiceOutAmountTotal 
    from tmp_Invoices_broghtf where InvoiceType = 1 ;
    
    select sum(ifnull(Amount,0)) as PaymentInAmountTotal into v_bf_PaymentInAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment In' ; 
    
    select sum(ifnull(Amount,0)) as InvoiceInAmountTotal into v_bf_InvoiceInAmountTotal
    from tmp_Invoices_broghtf where InvoiceType = 2 ;
    
    select sum(ifnull(Amount,0)) as PaymentOutAmountTotal into v_bf_PaymentOutAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment Out' ; 

	SELECT (ifnull(v_bf_InvoiceOutAmountTotal,0) - ifnull(v_bf_PaymentInAmountTotal,0)) - ( ifnull(v_bf_InvoiceInAmountTotal,0) - ifnull(v_bf_PaymentOutAmountTotal,0)) as BroughtForwardOffset;
	
	-- -------


  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getSOA_invoicenumber`;

DELIMITER |
CREATE PROCEDURE `prc_getSOA_invoicenumber`(IN `p_CompanyID` INT, IN `p_accountID` INT, IN `p_StartDate` datetime, IN `p_EndDate` datetime, IN `p_isExport` INT )
BEGIN
  
  -- - New ---- 
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';


   DROP TEMPORARY TABLE IF EXISTS tmp_Invoices;
    CREATE TEMPORARY TABLE tmp_Invoices (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        IssueDate Datetime,
        Amount NUMERIC(18, 8),
        InvoiceType int,
        AccountID int
    );
    
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Payments;
    CREATE TEMPORARY TABLE tmp_Payments (
        InvoiceNo VARCHAR(50),
        PaymentDate VARCHAR(50),
        IssueDate datetime,
        Amount NUMERIC(18, 8),
        PaymentID INT,
        PaymentType VARCHAR(50)
    );
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Disputes;
    CREATE TEMPORARY TABLE tmp_Disputes (
        InvoiceNo VARCHAR(50),
        created_at datetime,
        DisputeAmount NUMERIC(18, 8),
        InvoiceType VARCHAR(50),
        DisputeID INT,
        AccountID INT

    );
  
  
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceOutWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceOutWithDisputes (
        InvoiceOut_InvoiceNo VARCHAR(50),
        InvoiceOut_PeriodCover VARCHAR(50),
        InvoiceOut_IssueDate datetime,
        InvoiceOut_Amount NUMERIC(18, 8),
        InvoiceOut_DisputeAmount NUMERIC(18, 8),
        InvoiceOut_DisputeID INT,
       InvoiceOut_AccountID INT
    );
    
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceInWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceInWithDisputes (
        InvoiceIn_InvoiceNo VARCHAR(50),
        InvoiceIn_PeriodCover VARCHAR(50),
        InvoiceIn_IssueDate datetime,
        InvoiceIn_Amount NUMERIC(18, 8),
        InvoiceIn_DisputeAmount NUMERIC(18, 8),
        InvoiceIn_DisputeID INT,
        InvoiceIn_AccountID INT
    );
  
  
    /*
      New Logic
    
      -- 1 Invoice Sent with Disputes 
      -- 2 Invoice Out With Disputes + Payment Received 
      
      -- 3 Invoice In With Disputes 
      -- 4 Invoice In With Disputes + Payment Received 

    */

     -- 1 Invoices
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
        tblInvoice.AccountID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail         
		  ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )/* ProductType =2 = INVOICE USAGE AND InvoiceType = 1 Invoice sent and InvoiceType =2 invoice recevied */
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
        AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') <= p_EndDate ) )
      AND tblInvoice.GrandTotal != 0
      Order by tblInvoice.IssueDate asc;
    
   
     -- 2 Payments
     INSERT into tmp_Payments
       SELECT
        DISTINCT
            tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType
        FROM tblPayment
        WHERE 
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') <= p_EndDate ) )
    Order by tblPayment.PaymentDate desc;
    
        
     -- 3 Disputes 
     INSERT INTO tmp_Disputes
       SELECT
            InvoiceNo,
        created_at,
            DisputeAmount,
            InvoiceType,
            DisputeID,
            AccountID
      FROM tblDispute 
        WHERE 
            CompanyID = p_CompanyID
      AND AccountID = p_accountID
      AND Status = 0 
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') <= p_EndDate ) )
      order by created_at
      ;
        ###################################################
      
        DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Disputes_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Payments_dup;        

          
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_dup AS (SELECT * FROM tmp_Invoices);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Disputes_dup AS (SELECT * FROM tmp_Disputes);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payments_dup AS (SELECT * FROM tmp_Payments);
              
     -- Invoice Sent with Disputes  
    INSERT INTO tmp_InvoiceOutWithDisputes
      SELECT  
    InvoiceNo as InvoiceOut_InvoiceNo,
    PeriodCover as InvoiceOut_PeriodCover,
    IssueDate as InvoiceOut_IssueDate,
    Amount as InvoiceOut_Amount,
    ifnull(DisputeAmount,0) as InvoiceOut_DisputeAmount,
    DisputeID as InvoiceOut_DisputeID,
    AccountID as InvoiceOut_AccountID
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
       	   iv.AccountID
            
        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds on ds.InvoiceNo = iv.InvoiceNo AND ds.InvoiceType = iv.InvoiceType  AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 1          -- Only Invoice In Disputes
       
    
     UNION ALL
    
     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
        ds.AccountID
      FROM tmp_Disputes_dup ds 
      LEFT JOIN  tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo and iv.InvoiceType = ds.InvoiceType 
        WHERE 
        ds.InvoiceType = 1  -- Only Invoice Sent Disputes
        AND iv.InvoiceNo is null
        
   
    ) tbl  ;
    
    
    -- Invoice Out With Disputes & Payment Received
    
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
      INNER JOIN tblInvoiceTemplate  on ab.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
      LEFT JOIN tmp_Payments
      ON tmp_Payments.PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo != '' AND (tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceNo = tmp_Payments.InvoiceNo OR REPLACE(tmp_Payments.InvoiceNo,'-','') = concat( ltrim(rtrim(REPLACE(tblInvoiceTemplate.InvoiceNumberPrefix,'-',''))) , ltrim(rtrim(tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceNo)) ) )
      
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
      where PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo = ''
  
    ) tbl
    order by InvoiceOut_IssueDate desc;
     
    
    /* ##############################################################################################################################*/


    -- Invoice Received with Disputes 
    INSERT INTO tmp_InvoiceInWithDisputes
    SELECT 
    InvoiceNo as InvoiceIn_InvoiceNo,
    PeriodCover as InvoiceIn_PeriodCover,
    IssueDate as InvoiceIn_IssueDate,
    Amount as InvoiceIn_Amount,
    ifnull(DisputeAmount,0) as InvoiceIn_DisputeAmount,
    DisputeID as InvoiceIn_DisputeID,
    AccountID as InvoiceIn_AccountID
    FROM
     (  SELECT
        DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            iv.AccountID
        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds  on  ds.InvoiceNo = iv.InvoiceNo   AND ds.InvoiceType = iv.InvoiceType AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 2          -- Only Invoice In Disputes
        
    
     UNION ALL
    
     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            ds.AccountID
      From tmp_Disputes_dup ds 
        LEFT JOIN tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo AND iv.InvoiceType = ds.InvoiceType 
        WHERE  ds.InvoiceType = 2  -- Only Invoice In Disputes
        AND iv.InvoiceNo is null
        
    )tbl;
      
      

    /* Invoice Received Dispute and  Payment Sent */ 
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
      INNER JOIN tblInvoiceTemplate  on ab.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
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
      where PaymentType = 'Payment Out' AND  tmp_Payments.InvoiceNo = ''
  
    ) tbl

   order by InvoiceIn_IssueDate desc
   ;
     
     
    ##########################
    -- Counts 
    
    -- Total Invoice Sent Amount
    select sum(Amount) as InvoiceOutAmountTotal
    from tmp_Invoices where InvoiceType = 1 ;-- Invoice Sent
    

    -- Total Invoice Sent Amount
    select sum(DisputeAmount) as InvoiceOutDisputeAmountTotal
    from tmp_Disputes where InvoiceType = 1; -- Invoice Sent

    -- Total Payment  IN Amount
    select sum(Amount) as PaymentInAmountTotal
    from tmp_Payments where PaymentType = 'Payment In' ; 
    

    -- Total Invoice IN Amount
    select sum(Amount) as InvoiceInAmountTotal
    from tmp_Invoices where InvoiceType = 2 ;-- Invoice Sent
    
    
    -- Total Invoice IN Amount
    select sum(DisputeAmount) as InvoiceInDisputeAmountTotal
    from tmp_Disputes where InvoiceType = 2; -- Invoice Sent


    -- Total Payment Out Amount
    select sum(Amount) as PaymentOutAmountTotal
    from tmp_Payments where PaymentType = 'Payment Out' ; 
    
     
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getSummaryReportByCountry`;

DELIMITER |
CREATE PROCEDURE `prc_getSummaryReportByCountry`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Country` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
    
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 
  
    IF p_isExport = 0
    THEN
            SELECT
                MAX(uh.AccountName) AS AccountName,
                MAX(c.Country) AS Country,
                COUNT(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
               CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
         INNER JOIN Ratemanagement3.tblAccount a
         	ON a.AccountID = uh.AccountID
         LEFT JOIN Ratemanagement3.tblCurrency cc
         	ON cc.CurrencyId = a.CurrencyId          	
            WHERE (p_Country = '' OR c.CountryID = p_Country)
            group by 
            c.Country,uh.AccountID
				ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN MAX(c.Country)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN MAX(c.Country)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC

        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT count(*) as totalcount from (SELECT DISTINCT uh.AccountID ,c.Country 
        FROM tmp_tblUsageDetails_ uh
            LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE (p_Country = '' OR c.CountryID = p_Country)
        ) As TBL;

    END IF;
    IF p_isExport = 1
    THEN
        
            SELECT
                MAX(AccountName) AS AccountName,
                MAX(c.Country) AS Country,
                COUNT(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                SUM(cost) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE (p_Country = '' OR c.CountryID = p_Country)
            group by 
            c.Country,uh.AccountID;
            

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getSummaryReportByCustomer`;

DELIMITER |
CREATE PROCEDURE `prc_getSummaryReportByCustomer`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN
     
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

  CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 

    IF p_isExport = 0
    THEN
            SELECT
                MAX(uh.AccountName) as AccountName,
                count(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            INNER JOIN Ratemanagement3.tblAccount a
         	ON a.AccountID = uh.AccountID
         LEFT JOIN Ratemanagement3.tblCurrency cc
         	ON cc.CurrencyId = a.CurrencyId
            group by 
            uh.AccountID
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN count(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN count(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
            
        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT count(*) as totalcount from (SELECT DISTINCT AccountID  
        FROM tmp_tblUsageDetails_
        ) As TBL;
             

    END IF;
    IF p_isExport = 1
    THEN
        
            SELECT
                MAX(AccountName) as AccountName,
                count(UsageDetailID) AS NoOfCalls,
                Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,	
                SUM(cost) AS TotalCharges

            FROM tmp_tblUsageDetails_
            group by 
            AccountID;

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getSummaryReportByPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_getSummaryReportByPrefix`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Prefix` VARCHAR(50),
	IN `p_Country` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
     
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
     

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
  CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 

    IF p_isExport = 0
    THEN
         
            SELECT
                MAX(uh.AccountName) AS AccountName,
                area_prefix as AreaPrefix,
                MAX(c.Country) AS Country,
                MAX(r.Description) AS Description,
                count(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
                
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
            LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
            INNER JOIN Ratemanagement3.tblAccount a
         		ON a.AccountID = uh.AccountID
         	LEFT JOIN Ratemanagement3.tblCurrency cc
	         	ON cc.CurrencyId = a.CurrencyId
            WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
			GROUP BY uh.area_prefix,
                     uh.AccountID
                     ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN area_prefix
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN area_prefix
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN MAX(c.Country)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN MAX(c.Country)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN MAX(r.Description)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN MAX(r.Description)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT
            COUNT(*) AS totalcount
        FROM (
            SELECT DISTINCT
                area_prefix as AreaPrefix,
                uh.AccountID
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
            LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
        ) AS TBL;


    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            MAX(AccountName) AS AccountName,
            area_prefix as AreaPrefix,
            MAX(c.Country) AS Country,
            MAX(r.Description) AS Description,
            COUNT(UsageDetailID) AS NoOfCalls,
  			Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
            SUM(cost) AS TotalCharges
        FROM tmp_tblUsageDetails_ uh
		
		LEFT JOIN Ratemanagement3.tblRate r
                ON r.Code = uh.area_prefix 
        LEFT JOIN Ratemanagement3.tblCountry c
                ON r.CountryID = c.CountryID
        WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
        GROUP BY uh.area_prefix,
                 uh.AccountID;

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetTransactionsLogbyInterval`;

DELIMITER |
CREATE PROCEDURE `prc_GetTransactionsLogbyInterval`(IN `p_CompanyID` int, IN `p_Interval` varchar(50) )
BEGIN
   
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
        SELECT
			ac.AccountName,
			inv.InvoiceNumber,
            tl.Transaction,
            tl.Notes,
            tl.created_at,
            tl.Amount,
            Case WHEN tl.Status = 1 then 'Success' ELSE 'Failed'  
			END as Status
		FROM   tblTransactionLog tl
		INNER JOIN tblInvoice inv
            ON tl.CompanyID = inv.CompanyID 
            AND tl.InvoiceID = inv.InvoiceID
        INNER JOIN Ratemanagement3.tblAccount ac
            ON ac.AccountID = inv.AccountID
        
        WHERE ac.CompanyID = p_CompanyID 
        AND (
			( p_Interval = 'Daily' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 DAY),'%Y-%m-%d') )
			OR
			( p_Interval = 'Weekly' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 WEEK),'%Y-%m-%d') )
			OR
			( p_Interval = 'Monthly' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 MONTH),'%Y-%m-%d') )
		);
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetVendorCDR`;

DELIMITER |
CREATE PROCEDURE `prc_GetVendorCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_ZeroValueBuyingCost` INT,
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

	DECLARE v_OffSet_ int;
	DECLARE v_BillingTime_ int;
	DECLARE v_Round_ INT;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	SELECT cr.Symbol INTO v_CurrencyCode_ from Ratemanagement3.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	
	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	Call fnVendorUsageDetail(p_CompanyID,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CLI,p_CLD,p_ZeroValueBuyingCost);

	IF p_isExport = 0
	THEN 
	
		SELECT
			uh.VendorCDRID,	
			uh.AccountName as AccountName,
			uh.connect_time,
			uh.disconnect_time,
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),uh.buying_cost) AS buying_cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk,
			uh.AccountID,
			p_CompanyGatewayID as CompanyGatewayID,
			p_start_date as StartDate,
			p_end_date as EndDate  
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE 	(p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk )
		LIMIT p_RowspPage OFFSET v_OffSet_;
	 
		SELECT
			COUNT(*) AS totalcount,
			fnFormateDuration(SUM(uh.billed_duration)) as total_billed_duration,
			SUM(uh.buying_cost) as total_cost,
			v_CurrencyCode_ as CurrencyCode
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk );
	END IF;
	
	IF p_isExport = 1
	THEN
	
		SELECT
			uh.AccountName,        
			uh.connect_time,
			uh.disconnect_time,        
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),uh.buying_cost) AS Cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN Ratemanagement3.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk );
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_insertPayments`;

DELIMITER |
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
			
	
	/* Delete tmp table */		
	 delete from tblTempPayment where CompanyID = p_CompanyID and ProcessID = p_ProcessID;
	 
			
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_InsertTempReRateCDR`;

DELIMITER |
CREATE PROCEDURE `prc_InsertTempReRateCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_ProcessID` VARCHAR(50),
	IN `p_tbltempusagedetail_name` VARCHAR(50),
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)
)
BEGIN
	DECLARE v_BillingTime_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	SET @stm1 = CONCAT('

	INSERT INTO RMCDR3.`' , p_tbltempusagedetail_name , '` (
		CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		AccountID,
		ServiceID,
		connect_time,
		disconnect_time,
		billed_duration,
		area_prefix,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		trunk,
		ProcessID,
		ID,
		is_inbound,
		billed_second,
		disposition
	)

	SELECT
	*
	FROM (SELECT
		uh.CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		uh.AccountID,
		uh.ServiceID,
		connect_time,
		disconnect_time,
		billed_duration,
		"Other" as area_prefix,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		"Other" as trunk,
		"',p_ProcessID,'",
		ID,
		is_inbound,
		billed_second,
		disposition
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	INNER JOIN Ratemanagement3.tblAccount a
		ON uh.AccountID = a.AccountID
	WHERE
	( "' , p_CDRType , '" = "" OR  ud.is_inbound =  "' , p_CDRType , '")
	AND  StartDate >= DATE_ADD( "' , p_StartDate , '",INTERVAL -1 DAY)
	AND StartDate <= DATE_ADD( "' , p_EndDate , '",INTERVAL 1 DAY)
	AND uh.CompanyID =  "' , p_CompanyID , '"
	AND uh.AccountID is not null
	AND ( "' , p_AccountID , '" = 0 OR uh.AccountID = "' , p_AccountID , '")
	AND ( "' , p_CompanyGatewayID , '" = 0 OR CompanyGatewayID = "' , p_CompanyGatewayID , '")
	AND ( "' , p_CurrencyID ,'" = "0" OR a.CurrencyId = "' , p_CurrencyID , '")
	AND ( "' , p_CLI , '" = "" OR cli LIKE REPLACE("' , p_CLI , '", "*", "%"))	
	AND ( "' , p_CLD , '" = "" OR cld LIKE REPLACE("' , p_CLD , '", "*", "%"))
	AND ( "' , p_trunk , '" = ""  OR  trunk = "' , p_trunk , '")
	AND ( "' , p_area_prefix , '" = "" OR area_prefix LIKE REPLACE( "' , p_area_prefix , '", "*", "%"))	
	AND ( "' , p_zerovaluecost , '" = 0 OR (  "' , p_zerovaluecost , '" = 1 AND cost = 0) OR (  "' , p_zerovaluecost , '" = 2 AND cost > 0))	
	) tbl
	WHERE 
	("' , v_BillingTime_ , '" =1 and connect_time >=  "' , p_StartDate , '" AND connect_time <=  "' , p_EndDate , '")
	OR 
	("' , v_BillingTime_ , '" =2 and disconnect_time >=  "' , p_StartDate , '" AND disconnect_time <=  "' , p_EndDate , '")
	AND billed_duration > 0;
	');

	
	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

DELIMITER |
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
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName,ServiceID)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID,
		ud.ServiceID
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	LEFT JOIN tblGatewayAccount ga
		ON ga.GatewayAccountID = ud.GatewayAccountID
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

	/* active new account */
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,p_NameFormat);

	/* update cdr account */
	SET @stm = CONCAT('
	UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.GatewayAccountID = uh.GatewayAccountID
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
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.GatewayAccountID = uh.GatewayAccountID
		AND ga.ServiceID = uh.ServiceID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = p_CompanyID
	AND uh.CompanyGatewayID = p_CompanyGatewayID;

	IF v_NewAccountIDCount_ > 0
	THEN

		/* update header cdr account */
		UPDATE RMCDR3.tblUsageHeader uh
		INNER JOIN tblGatewayAccount ga
			ON  ga.CompanyID = uh.CompanyID
			AND ga.CompanyGatewayID = uh.CompanyGatewayID
			AND ga.GatewayAccountID = uh.GatewayAccountID
			AND ga.ServiceID = uh.ServiceID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;

	END IF;

END|
DELIMITER ;

DELIMITER |
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
	WHERE aa.CompanyID = p_CompanyID AND (CustomerAuthRule = 'CLI' OR VendorAuthRule = 'CLI') AND crt.ServiceID > 0 ;

	IF v_ServiceAccountID_CLI_Count_ > 0
	THEN

		/* update cdr service */
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
		INNER JOIN Ratemanagement3.tblCLIRateTable ga
			ON  ga.CompanyID = uh.CompanyID
			AND ga.CLI = uh.GatewayAccountID
		SET uh.ServiceID = ga.ServiceID
		WHERE ga.ServiceID > 0
		AND uh.CompanyID = ' ,  p_CompanyID , '
		AND uh.ProcessID = "' , p_processId , '" ;
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;
	
	SELECT COUNT(*) INTO v_ServiceAccountID_IP_Count_ 
	FROM Ratemanagement3.tblAccountAuthenticate aa
	WHERE aa.CompanyID = p_CompanyID AND (CustomerAuthRule = 'IP' OR VendorAuthRule = 'IP') AND ServiceID > 0;

	IF v_ServiceAccountID_IP_Count_ > 0
	THEN

		/* update cdr service */
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
		INNER JOIN Ratemanagement3.tblAccountAuthenticate ga
			ON  ga.CompanyID = uh.CompanyID
			AND ( FIND_IN_SET(uh.GatewayAccountID,ga.CustomerAuthValue) != 0 OR FIND_IN_SET(uh.GatewayAccountID,ga.VendorAuthValue) != 0 )
		SET uh.ServiceID = ga.ServiceID
		WHERE ga.ServiceID > 0
		AND uh.CompanyID = ' ,  p_CompanyID , '
		AND uh.ProcessID = "' , p_processId , '" ;
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

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

DROP PROCEDURE IF EXISTS `prc_ProcesssVCDR`;

DELIMITER |
CREATE PROCEDURE `prc_ProcesssVCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50)
)
BEGIN
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_NewAccountIDCount_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
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
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName,IsVendor)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID,
		1 as IsVendor
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	LEFT JOIN tblGatewayAccount ga
		ON ga.GatewayAccountID = ud.GatewayAccountID
		AND ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
	WHERE ProcessID =  "' , p_processId , '"
		AND ga.GatewayAccountID IS NULL
		AND ud.GatewayAccountID IS NOT NULL;
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
		AND ga.GatewayAccountID = uh.GatewayAccountID
	SET uh.AccountID = ga.AccountID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = ' ,  p_companyid , '
	AND uh.ProcessID = "' , p_processId , '" ;
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT COUNT(*) INTO v_NewAccountIDCount_ 
	FROM RMCDR3.tblVendorCDRHeader uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.GatewayAccountID = uh.GatewayAccountID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = p_CompanyID
	AND uh.CompanyGatewayID = p_CompanyGatewayID;

	IF v_NewAccountIDCount_ > 0
	THEN
		/* update header cdr account */
		UPDATE RMCDR3.tblVendorCDRHeader uh
		INNER JOIN tblGatewayAccount ga
			ON  ga.CompanyID = uh.CompanyID
			AND ga.CompanyGatewayID = uh.CompanyGatewayID
			AND ga.GatewayAccountID = uh.GatewayAccountID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;

	END IF;

	/* if rate format is prefix base not charge code*/
	IF p_RateFormat = 2
	THEN

		

		/* update trunk with use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblVendorTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 1 AND cld LIKE CONCAT(ct.Prefix , "%")
		INNER JOIN Ratemanagement3.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
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
	IF p_RateCDR = 1
	THEN
		SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET selling_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

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
		CALL Ratemanagement3.prc_getVendorCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR);
		
		/* update prefix outbound process*/
		/* if rate format is prefix base not charge code*/
		IF p_RateFormat = 2
		THEN
			CALL prc_updateVendorPrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;
		
		
		/* outbound rerate process*/
		IF p_RateCDR = 1
		THEN
			CALL prc_updateVendorRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
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
		
			
		/* get default code */
		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);
		
		/* update prefix from default codes 
		 if rate format is prefix base not charge code*/
		CALL prc_updateDefaultVendorPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;
	
	
	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( "Account:  " , ga.AccountName ," - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga 
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.GatewayAccountID = ud.GatewayAccountID
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
		WHERE ud.ProcessID = "' , p_processid  , '" AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
		
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_RerateInboundCalls`;

DELIMITER |
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

	IF p_RateCDR = 1
	THEN

		IF (SELECT COUNT(*) FROM Ratemanagement3.tblCLIRateTable WHERE CompanyID = p_CompanyID AND RateTableID > 0) > 0
		THEN

			/* temp accounts*/
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

		ELSEIF ( SELECT COUNT(*) FROM tmp_Service_ ) > 0
		THEN

			/* temp accounts*/
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

			/* temp accounts*/
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

		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

		IF p_InboundTableID > 0
		THEN 
			/* get inbound rate process*/
			CALL Ratemanagement3.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_,p_InboundTableID);
		END IF;

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
			SET v_cld_ = (SELECT cld FROM tmp_Account_ t WHERE t.RowID = v_pointer_);

			IF p_InboundTableID =  0
			THEN 

				SET p_InboundTableID = (SELECT RateTableID FROM Ratemanagement3.tblAccountTariff  WHERE AccountID = v_AccountID_ AND ServiceID = v_ServiceID_ AND Type = 2 LIMIT 1);
				/* get inbound rate process*/
				CALL Ratemanagement3.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_,p_InboundTableID);
			END IF;

			/* update prefix inbound process*/
			CALL prc_updateInboundPrefix(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_,v_ServiceID_);

			/* inbound rerate process*/
			CALL prc_updateInboundRate(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_,v_ServiceID_);

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

	END IF;

END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_RerateOutboundService`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_OutboundTableID` INT
)
BEGIN
	
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_ServiceID_ INT;
	DECLARE v_RateTableID_ INT;
	
	IF p_RateCDR = 1  
	THEN
	
		/* temp accounts*/
		DROP TEMPORARY TABLE IF EXISTS tmp_AccountService2_;
		CREATE TEMPORARY TABLE tmp_AccountService2_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT,
			ServiceID INT
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_AccountService2_(AccountID,ServiceID)
		SELECT DISTINCT AccountID,ServiceID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 0;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_AccountService2_);
		IF p_OutboundTableID > 0
		THEN
			/* get outbound rate process*/
			CALL Ratemanagement3.prc_getCustomerCodeRate(v_AccountID_,0,p_RateCDR,p_RateMethod,p_SpecifyRate,p_OutboundTableID);
		END IF;

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_AccountID_ = (SELECT AccountID FROM tmp_AccountService2_ t WHERE t.RowID = v_pointer_);
			SET v_ServiceID_ = (SELECT ServiceID FROM tmp_AccountService2_ t WHERE t.RowID = v_pointer_);
			
			
			IF p_OutboundTableID = 0
			THEN
				SET v_RateTableID_ = (SELECT RateTableID FROM Ratemanagement3.tblAccountTariff  WHERE AccountID = v_AccountID_ AND ServiceID = v_ServiceID_ AND Type = 1 LIMIT 1);
				/* get outbound rate process*/
				CALL Ratemanagement3.prc_getCustomerCodeRate(v_AccountID_,0,p_RateCDR,p_RateMethod,p_SpecifyRate,v_RateTableID_);
			END IF;
			
			
			/* update prefix outbound process*/
			/* if rate format is prefix base not charge code*/
			IF p_RateFormat = 2
			THEN
				CALL prc_updatePrefix(v_AccountID_,0, p_processId, p_tbltempusagedetail_name,v_ServiceID_);
			END IF;
			
			/* outbound rerate process*/
			IF p_RateCDR = 1
			THEN
				CALL prc_updateOutboundRate(v_AccountID_,0, p_processId, p_tbltempusagedetail_name,v_ServiceID_);
			END IF;
			
			SET v_pointer_ = v_pointer_ + 1;
			
		END WHILE;

	END IF;


END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_RerateOutboundTrunk`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN

	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_CDRUpload_ INT;
	DECLARE v_cld_ VARCHAR(500);

	/* temp accounts and trunks*/
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunkCdrUpload_;
	CREATE TEMPORARY TABLE tmp_AccountTrunkCdrUpload_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunkCdrUpload_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
	');

	SET v_CDRUpload_ = (SELECT COUNT(*) FROM tmp_AccountTrunkCdrUpload_);

	IF v_CDRUpload_ > 0
	THEN
		/* update UseInBilling when cdr upload*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.TrunkID = ud.TrunkID AND ct.Status =1
		INNER JOIN Ratemanagement3.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '";
		');
	END IF;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* if rate format is prefix base not charge code*/
	IF p_RateFormat = 2
	THEN

		/* update trunk with use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 1 AND cld LIKE CONCAT(ct.Prefix , "%")
		INNER JOIN Ratemanagement3.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		/* update trunk without use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 0 
		INNER JOIN Ratemanagement3.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;
	
	/* if rerate on */
	IF p_RateCDR = 1
	THEN

		SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

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
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
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
		CALL Ratemanagement3.prc_getCustomerCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR,p_RateMethod,p_SpecifyRate,0);

		/* update prefix outbound process*/
		/* if rate format is prefix base not charge code*/
		IF p_RateFormat = 2
		THEN
			CALL prc_updatePrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name,0);
		END IF;

		/* outbound rerate process*/
		IF p_RateCDR = 1
		THEN
			CALL prc_updateOutboundRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name,0);
		END IF;

		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_start_end_time`;

DELIMITER |
CREATE PROCEDURE `prc_start_end_time`(IN `p_ProcessID` VARCHAR(2000), IN `p_tbltempusagedetail_name` VARCHAR(50))
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    set @stm1 = CONCAT('select 
   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date
   from RMCDR3.`' , p_tbltempusagedetail_name , '` where ProcessID = "' , p_ProcessID , '"');
   
   PREPARE stmt1 FROM @stm1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateDefaultPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_updateDefaultPrefix`(IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	DECLARE v_pointer_ INT;	
	DECLARE v_partition_limit_ INT;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID(`TempUsageDetailID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID2(`TempUsageDetailID`)
	);
	

	/* find prefix from default codes and accounts doen't have active trunks */
	
	SET v_pointer_ = 0;
	SET v_partition_limit_ = 1000;
	SET @stm = CONCAT('
		SET @rowCount = (SELECT   COUNT(*)   FROM RMCDR3.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND ProcessID = "' , p_processId , '"  );
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	WHILE v_pointer_ <= @rowCount
	DO
		
			
		DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetailPart_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetailPart_(
			TempUsageDetailID int,
			cld varchar(500),
			INDEX IX_TempUsageDetailID(`TempUsageDetailID`),
			INDEX IX_cld(`cld`)
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetailPart_
		SELECT 
			TempUsageDetailID,
			cld
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		LEFT JOIN tmp_Accounts_ a
			ON a.AccountID = ud.AccountID
		WHERE a.AccountID IS NULL 
			AND ProcessID = "' , p_processId , '"  
			AND area_prefix = "Other"  
		LIMIT ',v_partition_limit_,' OFFSET ',v_pointer_,';
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM tmp_TempUsageDetailPart_ ud
		INNER JOIN Ratemanagement3.tmp_codes_ c 
			ON  cld like  CONCAT(c.Code,"%");
			
		SET v_pointer_ = v_pointer_ + v_partition_limit_;
		
	END WHILE;
	
	


	INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateDefaultVendorPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_updateDefaultVendorPrefix`(IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	DECLARE v_pointer_ INT;	
	DECLARE v_partition_limit_ INT;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID(`TempVendorCDRID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID2(`TempVendorCDRID`)
	);
	

	/* find prefix from default codes and accounts doen't have active trunks */
	
	SET v_pointer_ = 0;
	SET v_partition_limit_ = 1000;
	SET @stm = CONCAT('
		SET @rowCount = (SELECT   COUNT(*)   FROM RMCDR3.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND ProcessID = "' , p_processId , '"  );
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	WHILE v_pointer_ <= @rowCount
	DO
		
			
		DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetailPart_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetailPart_(
			TempVendorCDRID int,
			cld varchar(500),
			INDEX IX_TempVendorCDRID(`TempVendorCDRID`),
			INDEX IX_cld(`cld`)
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetailPart_
		SELECT 
			TempVendorCDRID,
			cld
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		LEFT JOIN tmp_Accounts_ a
			ON a.AccountID = ud.AccountID
		WHERE a.AccountID IS NULL 
			AND ProcessID = "' , p_processId , '"  
			AND area_prefix = "Other"  
		LIMIT ',v_partition_limit_,' OFFSET ',v_pointer_,';
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempVendorCDRID,
			c.code AS prefix
		FROM tmp_TempUsageDetailPart_ ud
		INNER JOIN Ratemanagement3.tmp_codes_ c 
			ON  cld like  CONCAT(c.Code,"%");
			
		SET v_pointer_ = v_pointer_ + v_partition_limit_;
		
	END WHILE;
	
	


	INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempVendorCDRID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempVendorCDRID;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempVendorCDRID = tbl.TempVendorCDRID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateInboundPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_updateInboundPrefix`(
	IN `p_AccountID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_CLD` VARCHAR(500),
	IN `p_ServiceID` INT
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID(`TempUsageDetailID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID2(`TempUsageDetailID`)
	);

	IF p_CLD != ''
	THEN 
		
		/* find prefix */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud 
		INNER JOIN Ratemanagement3.tmp_inboundcodes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 1 
			AND ud.AccountID = ' , p_AccountID , '
			AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '")
			AND ud.area_prefix = "Other"
			AND cli like  CONCAT(c.Code,"%");
		');
		
	ELSE
		
		/* find prefix */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud 
		INNER JOIN Ratemanagement3.tmp_inboundcodes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 1 
			AND ud.AccountID = ' , p_AccountID , '
			AND ud.ServiceID = ' , p_ServiceID , '
			AND ud.area_prefix = "Other"
			AND cld like  CONCAT(c.Code,"%");
		');
	
	END IF;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateInboundRate`;

DELIMITER |
CREATE PROCEDURE `prc_updateInboundRate`(
	IN `p_AccountID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_CLD` VARCHAR(500),
	IN `p_ServiceID` INT
)
BEGIN

	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND ServiceID = "',p_ServiceID ,'" AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '") AND is_inbound = 1 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN Ratemanagement3.tmp_inboundcodes_ cr ON cr.Code = ud.area_prefix
	SET cost = 
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
	AND ServiceID = "',p_ServiceID ,'"
	AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '")
	AND is_inbound = 1') ;
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateOutboundRate`;

DELIMITER |
CREATE PROCEDURE `prc_updateOutboundRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_ServiceID` INT
)
BEGIN

	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND ServiceID = "',p_ServiceID ,'" AND ("',p_TrunkID ,'" = 0 OR TrunkID = "',p_TrunkID ,'") AND is_inbound = 0 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN Ratemanagement3.tmp_codes_ cr ON cr.Code = ud.area_prefix
	SET cost = 
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
	AND ServiceID = "',p_ServiceID ,'" 
	AND ("',p_TrunkID ,'" = 0 OR TrunkID = "',p_TrunkID ,'")
	AND is_inbound = 0') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updatePrefix`;

DELIMITER |
CREATE PROCEDURE `prc_updatePrefix`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_ServiceID` INT
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID(`TempUsageDetailID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID2(`TempUsageDetailID`)
	);

	IF p_TrunkID > 0
	THEN
		/* find prefix without use in billing */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN Ratemanagement3.tmp_codes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 0 
			AND ud.AccountID = ' , p_AccountID , '
			AND ud.TrunkID = ' , p_TrunkID , '
			AND ud.UseInBilling = 0
			AND ud.area_prefix = "Other"
			AND ( extension <> cld or extension IS NULL)
			AND cld REGEXP "^[0-9]+$"
			AND cld like  CONCAT(c.Code,"%");
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		/* find prefix with use in billing */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN Ratemanagement3.tmp_codes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 0
			AND ud.AccountID = ' , p_AccountID , '
			AND ud.TrunkID = ' , p_TrunkID , '
			AND ud.UseInBilling = 1 
			AND ud.area_prefix = "Other"
			AND ( extension <> cld or extension IS NULL)
			AND cld REGEXP "^[0-9]+$"
			AND cld like  CONCAT(ud.TrunkPrefix,c.Code,"%");
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	ELSE

		/* find prefix */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN Ratemanagement3.tmp_codes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 0 
			AND ud.AccountID = ' , p_AccountID , '
			AND ud.ServiceID = ' , p_ServiceID , '
			AND ud.area_prefix = "Other"
			AND ( extension <> cld or extension IS NULL)
			AND cld REGEXP "^[0-9]+$"
			AND cld like  CONCAT(c.Code,"%");
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateSOAOffSet`;

DELIMITER |
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
		InvoiceType int
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountSOABal;
	CREATE TEMPORARY TABLE tmp_AccountSOABal (
		AccountID INT,
		Amount NUMERIC(18, 8)
	);

     -- 1 Invoices
	INSERT into tmp_AccountSOA(AccountID,Amount,InvoiceType)
	SELECT
		tblInvoice.AccountID,
		tblInvoice.GrandTotal,
		tblInvoice.InvoiceType
	FROM tblInvoice
	WHERE tblInvoice.CompanyID = p_CompanyID
	AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
	AND (p_AccountID = 0 OR  tblInvoice.AccountID = p_AccountID);

     -- 2 Payments
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
	
	INSERT INTO tmp_AccountSOABal
	SELECT AccountID,(SUM(IF(InvoiceType=1,Amount,0)) -  SUM(IF(PaymentType='Payment In',Amount,0))) - (SUM(IF(InvoiceType=2,Amount,0)) - SUM(IF(PaymentType='Payment Out',Amount,0))) as SOAOffSet 
	FROM tmp_AccountSOA 
	GROUP BY AccountID;
	
	INSERT INTO tmp_AccountSOABal
	SELECT DISTINCT tblAccount.AccountID ,0 FROM Ratemanagement3.tblAccount
	LEFT JOIN tmp_AccountSOA ON tblAccount.AccountID = tmp_AccountSOA.AccountID
	WHERE tblAccount.CompanyID = p_CompanyID
	AND tmp_AccountSOA.AccountID IS NULL
	AND (p_AccountID = 0 OR  tblAccount.AccountID = p_AccountID);
	
	UPDATE Ratemanagement3.tblAccountBalance
	INNER JOIN tmp_AccountSOABal 
		ON  tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	SET SOAOffset=tmp_AccountSOABal.Amount;
	
	UPDATE Ratemanagement3.tblAccountBalance SET tblAccountBalance.BalanceAmount = COALESCE(tblAccountBalance.SOAOffset,0) + COALESCE(tblAccountBalance.UnbilledAmount,0)  - COALESCE(tblAccountBalance.VendorUnbilledAmount,0);
	
	INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,BalanceAmount,UnbilledAmount,SOAOffset)
	SELECT tmp_AccountSOABal.AccountID,tmp_AccountSOABal.Amount,0,tmp_AccountSOABal.Amount
	FROM tmp_AccountSOABal 
	LEFT JOIN Ratemanagement3.tblAccountBalance
		ON tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	WHERE tblAccountBalance.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateVendorPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_updateVendorPrefix`(IN `p_AccountID` INT, IN `p_TrunkID` INT, IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID(`TempVendorCDRID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID2(`TempVendorCDRID`)
	);

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempVendorCDRID,
		c.code AS prefix
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN Ratemanagement3.tmp_vcodes_ c 
	ON ud.ProcessID = ' , p_processId , '
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 0
		AND ud.area_prefix = "Other"
		AND cld like  CONCAT(c.Code,"%");
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempVendorCDRID,
		c.code AS prefix
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN Ratemanagement3.tmp_vcodes_ c 
	ON ud.ProcessID = ' , p_processId , '
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 1 
		AND ud.area_prefix = "Other"
		AND cld like  CONCAT(ud.TrunkPrefix,c.Code,"%");
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	SET @stm = CONCAT('INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempVendorCDRID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempVendorCDRID;');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempVendorCDRID = tbl.TempVendorCDRID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateVendorRate`;

DELIMITER |
CREATE PROCEDURE `prc_updateVendorRate`(IN `p_AccountID` INT, IN `p_TrunkID` INT, IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	
	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET selling_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND TrunkID = "',p_TrunkID ,'"') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN Ratemanagement3.tmp_vcodes_ cr ON cr.Code = ud.area_prefix
	SET selling_cost = 
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_validatePayments`;

DELIMITER |
CREATE PROCEDURE `prc_validatePayments`(
	IN `p_CompanyID` INT,
	IN `p_ProcessID` VARCHAR(50)

)
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION group_concat_max_len=5000;


	DROP TEMPORARY TABLE IF EXISTS tmp_error_;
	CREATE TEMPORARY TABLE tmp_error_(
		`ErrorMessage` VARCHAR(500)
	);
	
		INSERT INTO tmp_error_	
	SELECT DISTINCT CONCAT('Future payments will not be uploaded - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage
	FROM tblTempPayment pt
	INNER JOIN Ratemanagement3.tblAccount ac on ac.AccountID = pt.AccountID
	WHERE pt.CompanyID = p_CompanyID
		AND pt.PaymentDate > NOW()
		AND pt.ProcessID = p_ProcessID;

	INSERT INTO tmp_error_
	SELECT distinct CONCAT('Duplicate payment in file - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage  
	FROM tblTempPayment pt
	INNER JOIN Ratemanagement3.tblAccount ac on ac.AccountID = pt.AccountID
	INNER JOIN tblTempPayment tp on tp.ProcessID = pt.ProcessID
		AND tp.AccountID = pt.AccountID
		AND tp.PaymentDate = pt.PaymentDate
		AND tp.Amount = pt.Amount
		AND tp.PaymentType = pt.PaymentType
		AND tp.PaymentMethod = pt.PaymentMethod
	WHERE pt.CompanyID = p_CompanyID
		AND pt.ProcessID = p_ProcessID
 	GROUP BY pt.InvoiceNo,pt.AccountID,pt.PaymentDate,pt.PaymentType,pt.PaymentMethod,pt.Amount having count(*)>=2;
 	
	INSERT INTO tmp_error_	
	SELECT DISTINCT
		CONCAT('Duplicate payment in system - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage
	FROM tblTempPayment pt
	INNER JOIN Ratemanagement3.tblAccount ac on ac.AccountID = pt.AccountID
	INNER JOIN tblPayment p on p.CompanyID = pt.CompanyID 
		AND p.AccountID = pt.AccountID
		AND p.PaymentDate = pt.PaymentDate
		AND p.Amount = pt.Amount
		AND p.PaymentType = pt.PaymentType
		AND p.Recall = 0
	WHERE pt.CompanyID = p_CompanyID
		AND pt.ProcessID = p_ProcessID;
		
		
		INSERT INTO tmp_error_	
	SELECT DISTINCT
		CONCAT('Currency Not Set - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage
	FROM tblTempPayment pt
	INNER JOIN Ratemanagement3.tblAccount ac on ac.AccountID = pt.AccountID
			and ac.AccountType = 1
		WHERE pt.CompanyID = p_CompanyID
		   AND ac.CurrencyId IS NULL
			AND pt.ProcessID = p_ProcessID;
	
	
	IF (SELECT COUNT(*) FROM tmp_error_) > 0
	THEN
	SELECT GROUP_CONCAT(ErrorMessage SEPARATOR "\r\n" ) as ErrorMessage FROM	tmp_error_;
		
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

UPDATE tblInvoiceTemplate SET  InvoiceTo = '{AccountName}
{Address1}
{Address2}
{Address3}
{City}
{PostCode}
{Country}' WHERE InvoiceTo IS NULL;


UPDATE tblInvoiceTemplate SET
UsageColumn = '{"Summary":[{"Title":"Trunk","ValuesID":"1","UsageName":"Trunk","Status":true,"FieldOrder":1},{"Title":"AreaPrefix","ValuesID":"2","UsageName":"Prefix","Status":true,"FieldOrder":2},{"Title":"Country","ValuesID":"3","UsageName":"Country","Status":true,"FieldOrder":3},{"Title":"Description","ValuesID":"4","UsageName":"Description","Status":true,"FieldOrder":4},{"Title":"NoOfCalls","ValuesID":"5","UsageName":"No of calls","Status":true,"FieldOrder":5},{"Title":"Duration","ValuesID":"6","UsageName":"Duration","Status":true,"FieldOrder":6},{"Title":"BillDuration","ValuesID":"7","UsageName":"Billed Duration","Status":true,"FieldOrder":7},{"Title":"AvgRatePerMin","ValuesID":"8","UsageName":"Avg Rate\/Min","Status":true,"FieldOrder":8},{"Title":"ChargedAmount","ValuesID":"7","UsageName":"Cost","Status":true,"FieldOrder":9}],"Detail":[{"Title":"Prefix","ValuesID":"1","UsageName":"Prefix","Status":true,"FieldOrder":1},{"Title":"CLI","ValuesID":"2","UsageName":"CLI","Status":true,"FieldOrder":2},{"Title":"CLD","ValuesID":"3","UsageName":"CLD","Status":true,"FieldOrder":3},{"Title":"ConnectTime","ValuesID":"4","UsageName":"Connect Time","Status":true,"FieldOrder":4},{"Title":"DisconnectTime","ValuesID":"4","UsageName":"Disconnect Time","Status":true,"FieldOrder":5},{"Title":"BillDuration","ValuesID":"6","UsageName":"Duration","Status":true,"FieldOrder":6},{"Title":"ChargedAmount","ValuesID":"7","UsageName":"Cost","Status":true,"FieldOrder":7}]}'
WHERE UsageColumn IS NULL;


UPDATE tblInvoiceTemplate SET  GroupByService = 0;

UPDATE tblInvoiceTemplate
INNER JOIN Ratemanagement3.tblBillingClass
ON tblBillingClass.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
SET tblInvoiceTemplate.CDRType = tblBillingClass.CDRType
WHERE tblBillingClass.CDRType IS NOT NULL;

UPDATE tblInvoiceTemplate SET CDRType = 1 WHERE CDRType IS NULL;

USE `RMCDR3`;

ALTER TABLE `tblUsageHeader`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblCDRPostProcess`
  MODIFY COLUMN `CDRPostProcessID` bigint(20) unsigned NOT NULL auto_increment;

ALTER TABLE `tblUsageDetailFailedCall`
  MODIFY COLUMN `UsageDetailFailedCallID` bigint(20) unsigned NOT NULL auto_increment;

ALTER TABLE `tblUsageDetails`
  MODIFY COLUMN `UsageDetailID` bigint(20) unsigned NOT NULL auto_increment;

ALTER TABLE `tblVCDRPostProcess`
  MODIFY COLUMN `VCDRPostProcessID` bigint(20) unsigned NOT NULL auto_increment;

ALTER TABLE `tblVendorCDR`
  MODIFY COLUMN `VendorCDRID` bigint(20) unsigned NOT NULL auto_increment;

CREATE INDEX `IX_ID` ON `tblVendorCDR`(`ID`);

ALTER TABLE `tblVendorCDRFailed`
  MODIFY COLUMN `VendorCDRFailedID` bigint(20) unsigned NOT NULL auto_increment;

CREATE INDEX `IX_ID` ON `tblVendorCDRFailed`(`ID`);

ALTER TABLE `tblVendorCDRHeader`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

DROP PROCEDURE IF EXISTS `prc_DeleteDuplicateUniqueID`;

DELIMITER |
CREATE PROCEDURE `prc_DeleteDuplicateUniqueID`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_ProcessID` VARCHAR(200), IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @stm1 = CONCAT('DELETE tud FROM     `' , p_tbltempusagedetail_name , '` tud
	INNER JOIN tblUsageDetails ud ON tud.ID =ud.ID
	INNER JOIN  tblUsageHeader uh on uh.UsageHeaderID = ud.UsageHeaderID
		AND tud.CompanyID = uh.CompanyID
		AND tud.CompanyGatewayID = uh.CompanyGatewayID
	WHERE
	 	  tud.CompanyID = "' , p_CompanyID , '"
	AND  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt1 FROM @stm1;
   EXECUTE stmt1;
   DEALLOCATE PREPARE stmt1;
   
   SET @stm2 = CONCAT('DELETE tud FROM     `' , p_tbltempusagedetail_name , '` tud
	INNER JOIN tblUsageDetailFailedCall ud ON tud.ID =ud.ID
	INNER JOIN  tblUsageHeader uh on uh.UsageHeaderID = ud.UsageHeaderID
		AND tud.CompanyID = uh.CompanyID
		AND tud.CompanyGatewayID = uh.CompanyGatewayID
	WHERE  
		  tud.CompanyID = "' , p_CompanyID , '"
	AND  tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
	AND  tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt2 FROM @stm2;
   EXECUTE stmt2;
   DEALLOCATE PREPARE stmt2;
	
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_DeleteDuplicateUniqueID2`;

DELIMITER |

CREATE PROCEDURE `prc_DeleteDuplicateUniqueID2`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_ProcessID` VARCHAR(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @stm1 = CONCAT('
		DELETE tud FROM `' , p_tbltempusagedetail_name , '` tud
		INNER JOIN tblVendorCDR ud ON tud.ID =ud.ID
		INNER JOIN  tblVendorCDRHeader uh on uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
			AND tud.CompanyID = uh.CompanyID
			AND tud.CompanyGatewayID = uh.CompanyGatewayID
		WHERE tud.CompanyID = "' , p_CompanyID , '"
		AND tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
		AND tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

	SET @stm2 = CONCAT('
		DELETE tud FROM `' , p_tbltempusagedetail_name , '` tud
		INNER JOIN tblVendorCDRFailed ud ON tud.ID =ud.ID
		INNER JOIN  tblVendorCDRHeader uh on uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
			AND tud.CompanyID = uh.CompanyID
			AND tud.CompanyGatewayID = uh.CompanyGatewayID
		WHERE tud.CompanyID = "' , p_CompanyID , '"
		AND tud.CompanyGatewayID = "' , p_CompanyGatewayID , '"
		AND tud.ProcessID = "' , p_processId , '";
	');
	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_insertCDR`;

DELIMITER |
CREATE PROCEDURE `prc_insertCDR`(
	IN `p_processId` varchar(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;

	SET @stm2 = CONCAT('
	INSERT INTO   tblUsageHeader (CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,StartDate,created_at,ServiceID)
	SELECT DISTINCT d.CompanyID,d.CompanyGatewayID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW(),d.ServiceID
	FROM `' , p_tbltempusagedetail_name , '` d
	LEFT JOIN tblUsageHeader h
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.ServiceID = d.ServiceID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE h.GatewayAccountID IS NULL AND processid = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET @stm3 = CONCAT('
	INSERT INTO tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.ServiceID = d.ServiceID
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
	INSERT INTO tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	SELECT UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
	FROM  `' , p_tbltempusagedetail_name , '` d
	INNER JOIN tblUsageHeader h
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.ServiceID = d.ServiceID
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_insertVendorCDR`;

DELIMITER |
CREATE PROCEDURE `prc_insertVendorCDR`(
	IN `p_processId` VARCHAR(200),
	IN `p_tbltempusagedetail_name` VARCHAR(50)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @stm2 = CONCAT('
	INSERT INTO   tblVendorCDRHeader (CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,StartDate,created_at,ServiceID)
	SELECT DISTINCT d.CompanyID,d.CompanyGatewayID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW(),d.ServiceID
	FROM `' , p_tbltempusagedetail_name , '` d
	LEFT JOIN tblVendorCDRHeader h 
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.ServiceID = d.ServiceID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE h.GatewayAccountID IS NULL AND processid = "' , p_processId , '";
	');

	PREPARE stmt2 FROM @stm2;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;

	SET @stm6 = CONCAT('
	INSERT INTO tblVendorCDRFailed (VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	SELECT VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
	FROM `' , p_tbltempusagedetail_name , '` d 
	INNER JOIN tblVendorCDRHeader h	 
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.ServiceID = d.ServiceID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	WHERE processid = "' , p_processId , '" AND  billed_duration = 0 AND buying_cost = 0 ;
	');

	PREPARE stmt6 FROM @stm6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

	SET @stm3 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  AND billed_duration = 0 AND buying_cost = 0;
	');
	
	PREPARE stmt3 FROM @stm3;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SET @stm4 = CONCAT('
	INSERT INTO tblVendorCDR (VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	SELECT VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
	FROM `' , p_tbltempusagedetail_name , '` d 
	INNER JOIN tblVendorCDRHeader h	 
	ON h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.ServiceID = d.ServiceID
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

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_PostProcessCDR`;

DELIMITER |
CREATE PROCEDURE `prc_PostProcessCDR`(IN `p_CompanyID` INT)
BEGIN

	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_ProcessID_ VARCHAR(200);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_ProcessIDS;
	CREATE TEMPORARY TABLE tmp_ProcessIDS  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempUsageDownloadLogID INT,
		ProcessID VARCHAR(200)
	);
	
	INSERT INTO tmp_ProcessIDS(TempUsageDownloadLogID,ProcessID)
	SELECT TempUsageDownloadLogID,ProcessID FROM  RMBilling3.tblTempUsageDownloadLog WHERE CompanyID = p_CompanyID AND PostProcessStatus=0 LIMIT 50;
	
	DELETE FROM tblCDRPostProcess WHERE CompanyID = p_CompanyID;
	DELETE FROM tblVCDRPostProcess WHERE CompanyID = p_CompanyID;
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_ProcessIDS);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_ProcessID_ = (SELECT ProcessID FROM tmp_ProcessIDS t WHERE t.RowID = v_pointer_);
		
		CALL prc_insertPostProcessCDR(v_ProcessID_); 
		
	SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	UPDATE tblCDRPostProcess 
	INNER JOIN  Ratemanagement3.tblCountry ON area_prefix LIKE CONCAT(Prefix , "%")
	SET tblCDRPostProcess.CountryID =tblCountry.CountryID
	WHERE tblCDRPostProcess.CompanyID = p_CompanyID;
	
	UPDATE tblVCDRPostProcess 
	INNER JOIN  Ratemanagement3.tblCountry ON area_prefix LIKE CONCAT(Prefix , "%")
	SET tblVCDRPostProcess.CountryID =tblCountry.CountryID
	WHERE tblVCDRPostProcess.CompanyID = p_CompanyID;
	
	SELECT * FROM tmp_ProcessIDS;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_RetailMonitorCalls`;

DELIMITER |
CREATE PROCEDURE `prc_RetailMonitorCalls`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Type` VARCHAR(50)

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	/* lognest duration call*/	
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
		ORDER BY billed_duration DESC LIMIT 10;

	END IF;

	/* most expensive call */	
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
		ORDER BY cost DESC LIMIT 10;

	END IF;
	
	/* most dailed numner*/
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
		GROUP BY cld
		ORDER BY dail_count DESC
		LIMIT 10;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_unsetCDRUsageAccount`;

DELIMITER |
CREATE PROCEDURE `prc_unsetCDRUsageAccount`(
	IN `p_CompanyID` INT,
	IN `p_IPs` LONGTEXT,
	IN `p_StartDate` VARCHAR(100),
	IN `p_Confirm` INT,
	IN `p_ServiceID` INT
)
BEGIN

	DECLARE v_AccountID int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_AccountID = 0;
		SELECT DISTINCT GAC.AccountID INTO v_AccountID 
		FROM RMBilling3.tblGatewayAccount GAC
		WHERE GAC.CompanyID = p_CompanyID
		AND GAC.ServiceID = p_ServiceID
		AND AccountID IS NOT NULL
		AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0
		LIMIT 1;
	
	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblUsageHeader UH
			WHERE UH.CompanyID = p_CompanyID
			AND UH.ServiceID = p_ServiceID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(UH.CompanyGatewayID, p_IPs) > 0
			LIMIT 1; 
	END IF;
	
	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblVendorCDRHeader VH
			WHERE VH.CompanyID = p_CompanyID
			AND VH.ServiceID = p_ServiceID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(VH.GatewayAccountID, p_IPs) > 0
			LIMIT 1; 
	END IF;
	IF v_AccountID >0 AND p_Confirm = 1 THEN
			UPDATE RMBilling3.tblGatewayAccount GAC SET GAC.AccountID = NULL
			WHERE GAC.CompanyID = p_CompanyID
			AND GAC.ServiceID = p_ServiceID
			AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0;
	
			Update tblUsageHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND ServiceID = p_ServiceID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0			
			AND StartDate >= p_StartDate;
						
			Update tblVendorCDRHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND ServiceID = p_ServiceID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0
			AND StartDate >= p_StartDate;
	SET v_AccountID = -1;
	END IF;

	SELECT v_AccountID as `Status`;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END|
DELIMITER ;

USE `StagingReport`;

CREATE TABLE IF NOT EXISTS `tblHeader` (
	`HeaderID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`DateID` BIGINT(20) NOT NULL,
	`CompanyID` INT(11) NULL DEFAULT NULL,
	`AccountID` INT(11) NULL DEFAULT NULL,
	`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`TotalCharges` DOUBLE NULL DEFAULT NULL,
	`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
	`TotalDuration` INT(11) NULL DEFAULT NULL,
	`NoOfCalls` INT(11) NULL DEFAULT NULL,
	`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`HeaderID`),
	UNIQUE INDEX `Unique_key` (`DateID`, `AccountID`),
	INDEX `FK_tblSummaryHeaderNew_dim_date` (`DateID`),
	INDEX `IX_CompanyID` (`CompanyID`),
	CONSTRAINT `tblHeader_ibfk_1` FOREIGN KEY (`DateID`) REFERENCES `tblDimDate` (`DateID`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `tblHeaderV` (
	`HeaderVID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`DateID` BIGINT(20) NOT NULL,
	`CompanyID` INT(11) NULL DEFAULT NULL,
	`VAccountID` INT(11) NULL DEFAULT NULL,
	`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`TotalCharges` DOUBLE NULL DEFAULT NULL,
	`TotalSales` DOUBLE NULL DEFAULT NULL,
	`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
	`TotalDuration` INT(11) NULL DEFAULT NULL,
	`NoOfCalls` INT(11) NULL DEFAULT NULL,
	`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`HeaderVID`),
	UNIQUE INDEX `Unique_key` (`DateID`, `VAccountID`),
	INDEX `FK_tblHeaderV_dim_date` (`DateID`),
	INDEX `IX_CompanyID` (`CompanyID`),
	CONSTRAINT `tblHeader_ibfk_2` FOREIGN KEY (`DateID`) REFERENCES `tblDimDate` (`DateID`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB;

DROP INDEX `IX_CompanyID` ON `tblHeader`;

CREATE INDEX `IX_CompanyID` ON `tblHeader`(`CompanyID`);

DROP INDEX `IX_CompanyID` ON `tblHeaderV`;

CREATE INDEX `IX_CompanyID` ON `tblHeaderV`(`CompanyID`);

ALTER TABLE `tblSummaryHeader`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tblSummaryVendorHeader`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_SummaryHeader`  
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_SummaryHeaderLive`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_SummaryVendorHeader`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_SummaryVendorHeaderLive`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_UsageSummary`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_UsageSummaryLive`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_VendorUsageSummary`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_VendorUsageSummaryLive`
  ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblUsageDetailsReport`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblUsageDetailsReportLive`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblVendorUsageDetailsReport`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

ALTER TABLE `tmp_tblVendorUsageDetailsReportLive`
   ADD COLUMN `ServiceID` int(11) NULL DEFAULT '0';

DROP FUNCTION `fnGetCompanyGatewayName`;

DELIMITER |
CREATE FUNCTION `fnGetCompanyGatewayName`(`p_CompanyGatewayID` INT) RETURNS varchar(200) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
DECLARE v_Title_ VARCHAR(200);

SELECT cg.Title INTO v_Title_ from Ratemanagement3.tblCompanyGateway cg where cg.CompanyGatewayID = p_CompanyGatewayID;

RETURN v_Title_;
END|
DELIMITER ;

DROP FUNCTION `fngetLastInvoiceDate`;

DELIMITER |
CREATE FUNCTION `fngetLastInvoiceDate`(
	`p_AccountID` INT

) RETURNS date
BEGIN
	
	DECLARE v_LastInvoiceDate_ DATE;
	
	SELECT 
		CASE WHEN tblAccountBilling.LastInvoiceDate IS NOT NULL AND tblAccountBilling.LastInvoiceDate <> '' 
		THEN 
			DATE_FORMAT(tblAccountBilling.LastInvoiceDate,'%Y-%m-%d')
		ELSE 
			CASE WHEN tblAccountBilling.BillingStartDate IS NOT NULL AND tblAccountBilling.BillingStartDate <> ''
			THEN
				DATE_FORMAT(tblAccountBilling.BillingStartDate,'%Y-%m-%d')
			ELSE DATE_FORMAT(tblAccount.created_at,'%Y-%m-%d')
			END 
		END
		INTO v_LastInvoiceDate_ 
	FROM Ratemanagement3.tblAccount
	LEFT JOIN Ratemanagement3.tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID AND tblAccountBilling.ServiceID = 0
	WHERE tblAccount.AccountID = p_AccountID
	LIMIT 1;
	
	RETURN v_LastInvoiceDate_;
	
END|
DELIMITER ;

DROP FUNCTION `fngetLastVendorInvoiceDate`;

DELIMITER |
CREATE FUNCTION `fngetLastVendorInvoiceDate`(
	`p_AccountID` INT





) RETURNS datetime
BEGIN
	
	DECLARE v_LastInvoiceDate_ DATETIME;
	
	SELECT
		CASE WHEN EndDate IS NOT NULL AND EndDate <> '' AND EndDate <> '0000-00-00 00:00:00'
		THEN 
			EndDate
		ELSE 
			CASE WHEN BillingStartDate IS NOT NULL AND BillingStartDate <> ''
			THEN
				DATE_FORMAT(BillingStartDate,'%Y-%m-%d')
			ELSE DATE_FORMAT(tblAccount.created_at,'%Y-%m-%d')
			END 
		END  INTO v_LastInvoiceDate_
 	FROM Ratemanagement3.tblAccount
	LEFT JOIN Ratemanagement3.tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID AND tblAccountBilling.ServiceID = 0
	LEFT JOIN RMBilling3.tblInvoice 
		ON tblAccount.AccountID = tblInvoice.AccountID AND InvoiceType =2
	LEFT JOIN RMBilling3.tblInvoiceDetail
		ON tblInvoice.InvoiceID =  tblInvoiceDetail.InvoiceID
	WHERE tblAccount.AccountID = p_AccountID 
	ORDER BY IssueDate DESC 
	LIMIT 1;

	RETURN v_LastInvoiceDate_;

END|
DELIMITER ;

DROP FUNCTION `fnGetRoundingPoint`;

DELIMITER |
CREATE FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT

) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from Ratemanagement3.tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID AND cs.Value <> '';

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetCountry`;

DELIMITER |
CREATE PROCEDURE `fnGetCountry`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS temptblCountry;
CREATE TEMPORARY TABLE IF NOT EXISTS `temptblCountry` (
	`CountryID` INT(11) NOT NULL AUTO_INCREMENT,
	`Prefix` VARCHAR(50) NULL DEFAULT NULL,
	`Country` VARCHAR(100) NULL DEFAULT NULL,
	`ISO2` VARCHAR(5)  NULL DEFAULT NULL,
	`ISO3` VARCHAR(5) NULL DEFAULT NULL,
	PRIMARY KEY (`CountryID`),
	INDEX tempCountry_Prefix(`Prefix`)
);
INSERT INTO temptblCountry(CountryID,Prefix,Country,ISO2,ISO3)
SELECT CountryID,Prefix,Country,ISO2,ISO3 FROM Ratemanagement3.tblCountry;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fngetDefaultCodes`;

DELIMITER |
CREATE PROCEDURE `fngetDefaultCodes`(IN `p_CompanyID` INT)
BEGIN
	
	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		CountryID INT,
		Code VARCHAR(50),
		INDEX tmp_codes_CountryID (`CountryID`),
		INDEX tmp_codes_Code (`Code`)
	);

	INSERT INTO tmp_codes_
	SELECT
	DISTINCT
		tblRate.CountryID,
		tblRate.Code
	FROM Ratemanagement3.tblRate
	INNER JOIN Ratemanagement3.tblCodeDeck
		ON tblCodeDeck.CodeDeckId = tblRate.CodeDeckId
	WHERE tblCodeDeck.CompanyId = p_CompanyID
	AND tblCodeDeck.DefaultCodedeck = 1 ;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetUsageForSummary`;

DELIMITER |
CREATE PROCEDURE `fnGetUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblUsageDetailsReport WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
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
		1 as call_status
	FROM RMCDR3.tblUsageDetails  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
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
		2 as call_status
	FROM RMCDR3.tblUsageDetailFailedCall  ud
	INNER JOIN RMCDR3.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetUsageForSummaryLive`;

DELIMITER |
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
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummary`;

DELIMITER |
CREATE PROCEDURE `fnGetVendorUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReport WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummaryLive`;

DELIMITER |
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
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
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
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

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
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummary us
			ON us.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryLive us
			ON us.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
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
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryDetail usd
			ON usd.SummaryHeaderID = sh.SummaryHeaderID 
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
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryDetailLive usd
			ON usd.SummaryHeaderID = sh.SummaryHeaderID 
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
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
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
			`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryDetail usd
		ON usd.SummaryHeaderID = sh.SummaryHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);
		
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryDetailLive usd
		ON usd.SummaryHeaderID = sh.SummaryHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%') )
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
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
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummary us
			ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryLive us
			ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN Ratemanagement3.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
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
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryDetail usd
			ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
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
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryDetailLive usd
			ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
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
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
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
			`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
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
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryDetail usd
		ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);
	
	INSERT INTO tmp_tblUsageVendorSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryDetailLive usd
		ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN Ratemanagement3.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN Ratemanagement3.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateSummary`;

DELIMITER |
CREATE PROCEDURE `prc_generateSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE




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
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);
 
 	
 	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.ServiceID,ud.CompanyID;

	UPDATE tmp_UsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummary.CountryID =code.CountryID
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;
	
	START TRANSACTION;
	
	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummary us
	LEFT JOIN tmp_SummaryHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;
	
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummary us 
	INNER JOIN tblSummaryHeader sh ON us.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblUsageSummaryDetail usd
	INNER JOIN tblSummaryHeader sh ON usd.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblUsageSummary (SummaryHeaderID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryHeaderID),SUM(us.TotalCharges),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;
	
	INSERT INTO tblUsageSummaryDetail (SummaryHeaderID,TimeID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryHeaderID,TimeID,us.TotalCharges,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID;

	DELETE h FROM tblHeader h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeader(DateID,CompanyID,AccountID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		u.DateID,
		u.CompanyID,
		u.AccountID,
		SUM(u.TotalCharges) as TotalCharges,
		SUM(u.TotalBilledDuration) as TotalBilledDuration,
		SUM(u.TotalDuration) as TotalDuration,
		SUM(u.NoOfCalls) as NoOfCalls,
		SUM(u.NoOfFailCalls) as NoOfFailCalls
	FROM tmp_UsageSummary u 
	WHERE u.CompanyID = p_CompanyID
	GROUP BY u.DateID,u.AccountID,u.CompanyID;

	COMMIT;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateSummaryLive`;

DELIMITER |
CREATE PROCEDURE `prc_generateSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE




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
	CALL fnGetUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);
	 
 	
 	DELETE FROM tmp_UsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReportLive ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.ServiceID,ud.CompanyID;

	UPDATE tmp_UsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummaryLive us
	LEFT JOIN tmp_SummaryHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummaryLive us 
	INNER JOIN tblSummaryHeader sh ON us.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID; 

	DELETE usd FROM tblUsageSummaryDetailLive usd
	INNER JOIN tblSummaryHeader sh ON usd.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageSummaryLive (SummaryHeaderID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryHeaderID),SUM(us.TotalCharges),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix; 
	
	INSERT INTO tblUsageSummaryDetailLive (SummaryHeaderID,TimeID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryHeaderID,TimeID,us.TotalCharges,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID;
	
	DELETE h FROM tblHeader h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeader(DateID,CompanyID,AccountID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		u.DateID,
		u.CompanyID,
		u.AccountID,
		SUM(u.TotalCharges) as TotalCharges,
		SUM(u.TotalBilledDuration) as TotalBilledDuration,
		SUM(u.TotalDuration) as TotalDuration,
		SUM(u.NoOfCalls) as NoOfCalls,
		SUM(u.NoOfFailCalls) as NoOfFailCalls
	FROM tmp_UsageSummaryLive u 
	WHERE u.CompanyID = p_CompanyID
	GROUP BY u.DateID,u.AccountID,u.CompanyID;
	

	COMMIT;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateVendorSummary`;

DELIMITER |
CREATE PROCEDURE `prc_generateVendorSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE





)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);

 	/* insert into success summary*/
 	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.ServiceID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummary.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummary us
	LEFT JOIN tmp_SummaryVendorHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageVendorSummary us 
	INNER JOIN tblSummaryVendorHeader sh ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblUsageVendorSummaryDetail usd
	INNER JOIN tblSummaryVendorHeader sh ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageVendorSummary (SummaryVendorHeaderID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryVendorHeaderID),SUM(us.TotalCharges),SUM(us.TotalSales),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)	 
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	AND sh.ServiceID = us.ServiceID
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;

	INSERT INTO tblUsageVendorSummaryDetail (SummaryVendorHeaderID,TimeID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryVendorHeaderID,TimeID,us.TotalCharges,us.TotalSales,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)
	ON 
		sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	AND sh.ServiceID = us.ServiceID;

	DELETE h FROM tblHeaderV h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeaderV(DateID,CompanyID,VAccountID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		u.DateID,
		u.CompanyID,
		u.AccountID,
		SUM(u.TotalCharges) as TotalCharges,
		SUM(u.TotalSales) as TotalSales,
		SUM(u.TotalBilledDuration) as TotalBilledDuration,
		SUM(u.TotalDuration) as TotalDuration,
		SUM(u.NoOfCalls) as NoOfCalls,
		SUM(u.NoOfFailCalls) as NoOfFailCalls
	FROM tmp_VendorUsageSummary u 
	WHERE u.CompanyID = p_CompanyID
	GROUP BY u.DateID,u.AccountID,u.CompanyID;
	
	COMMIT;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_generateVendorSummaryLive`;

DELIMITER |
CREATE PROCEDURE `prc_generateVendorSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE





)
BEGIN
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);

 	/* insert into success summary*/
 	DELETE FROM tmp_VendorUsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,ServiceID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.ServiceID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReportLive ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.ServiceID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummaryLive us
	LEFT JOIN tmp_SummaryVendorHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	AND us.ServiceID = sh.ServiceID
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,ServiceID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.ServiceID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageVendorSummaryLive us 
	INNER JOIN tblSummaryVendorHeader sh ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblUsageVendorSummaryDetailLive usd
	INNER JOIN tblSummaryVendorHeader sh ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageVendorSummaryLive (SummaryVendorHeaderID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryVendorHeaderID),SUM(us.TotalCharges),SUM(us.TotalSales),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)	 
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	AND sh.ServiceID = us.ServiceID
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.ServiceID,us.Trunk,us.AreaPrefix;

	INSERT INTO tblUsageVendorSummaryDetailLive (SummaryVendorHeaderID,TimeID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryVendorHeaderID,TimeID,us.TotalCharges,us.TotalSales,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	AND sh.ServiceID = us.ServiceID;
	
	DELETE h FROM tblHeaderV h 
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)u
		ON h.DateID = u.DateID 
		AND h.CompanyID = u.CompanyID
	WHERE u.CompanyID = p_CompanyID;
	
	INSERT INTO tblHeaderV(DateID,CompanyID,VAccountID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		u.DateID,
		u.CompanyID,
		u.AccountID,
		SUM(u.TotalCharges) as TotalCharges,
		SUM(u.TotalSales) as TotalSales,
		SUM(u.TotalBilledDuration) as TotalBilledDuration,
		SUM(u.TotalDuration) as TotalDuration,
		SUM(u.NoOfCalls) as NoOfCalls,
		SUM(u.NoOfFailCalls) as NoOfFailCalls
	FROM tmp_VendorUsageSummaryLive u 
	WHERE u.CompanyID = p_CompanyID
	GROUP BY u.DateID,u.AccountID,u.CompanyID;

	COMMIT;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getAccountExpense`;

DELIMITER |
CREATE PROCEDURE `prc_getAccountExpense`(IN `p_CompanyID` INT, IN `p_AccountID` INT)
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
		sh.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummary us
		ON us.SummaryHeaderID = sh.SummaryHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryLive us
		ON us.SummaryHeaderID = sh.SummaryHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	/* insert vendor summary */
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummary us
		ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryLive us
		ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
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

DROP PROCEDURE IF EXISTS  `prc_getDashboardPayableReceivable`;

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
		SELECT DISTINCT tblSummaryHeader.AccountID  FROM tblSummaryHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryHeader.AccountID WHERE tblSummaryHeader.CompanyID = 1;

		UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastInvoiceDate(AccountID);

		INSERT INTO tmp_Account2_ (AccountID)
		SELECT DISTINCT tblSummaryVendorHeader.AccountID  FROM tblSummaryVendorHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryVendorHeader.AccountID WHERE tblSummaryVendorHeader.CompanyID = p_CompanyID;

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

DROP PROCEDURE IF EXISTS `prc_getDashboardProfitLoss`;

DELIMITER |
CREATE PROCEDURE `prc_getDashboardProfitLoss`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_ListType` VARCHAR(50)

)
BEGIN
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	DROP TEMPORARY TABLE IF EXISTS tmp_Customerbilled_;
	CREATE TEMPORARY TABLE tmp_Customerbilled_  (
		DateID INT,
		Customerbill DOUBLE
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorbilled_;
	CREATE TEMPORARY TABLE tmp_Vendorbilled_  (
		DateID INT,
		Vendrorbill DOUBLE
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_FinalResult_;
	CREATE TEMPORARY TABLE tmp_FinalResult_  (
		Customerbill DOUBLE,
		Vendrorbill DOUBLE,
		date DATE
	);

	INSERT INTO tmp_Customerbilled_(DateID,Customerbill)
	SELECT 
		dd.DateID,
		SUM(h.TotalCharges)
	FROM tblDimDate dd
	INNER JOIN tblHeader h
		ON h.DateID = dd.DateID
	WHERE dd.date BETWEEN p_StartDate AND p_EndDate
	AND (p_AccountID = 0 or AccountID = p_AccountID)
	GROUP BY dd.date;

	INSERT INTO tmp_Vendorbilled_ (DateID,Vendrorbill)
	SELECT 
		dd.DateID,
		SUM(h.TotalCharges)
	FROM tblDimDate dd
	INNER JOIN tblHeaderV h
		ON h.DateID = dd.DateID
	WHERE dd.date BETWEEN p_StartDate AND p_EndDate
	AND (p_AccountID = 0 or VAccountID = p_AccountID)
	GROUP BY dd.date;

	INSERT INTO tmp_FinalResult_(Customerbill,Vendrorbill,date)
	SELECT 
		IFNULL(Customerbill,0) AS Customerbill,
		IFNULL(Vendrorbill,0) AS Vendrorbill,
		date
	FROM(
		SELECT 
			dd.date,
			Customerbill,
			Vendrorbill
		FROM tblDimDate dd 
		LEFT JOIN tmp_Customerbilled_ cu 
			ON cu.DateID = dd.DateID
		LEFT JOIN tmp_Vendorbilled_ vu
			ON vu.DateID = dd.DateID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND (cu.DateID IS NOT NULL OR vu.DateID IS NOT NULL)
		ORDER BY dd.date
	)tbl;
	
	IF p_ListType = 'Daily'
	THEN

		SELECT
			ROUND(Customerbill - Vendrorbill,v_Round_) AS PL,
			date AS Date
		FROM  tmp_FinalResult_
		ORDER BY date;

	END IF;

	IF p_ListType = 'Weekly'
	THEN

		SELECT 
			ROUND(SUM(Customerbill) - SUM(Vendrorbill),v_Round_) AS PL,
			CONCAT( YEAR(MAX(date)),' - ',WEEK(MAX(date))) AS Date
		FROM	tmp_FinalResult_
		GROUP BY 
			YEAR(date),
			WEEK(date)
		ORDER BY
			YEAR(date),
			WEEK(date);

	END IF;
	
	IF p_ListType = 'Monthly'
	THEN

		SELECT 
			ROUND(SUM(Customerbill) - SUM(Vendrorbill),v_Round_) AS PL,
			CONCAT( YEAR(MAX(date)),' - ',MONTHNAME(MAX(date))) AS Date
		FROM	tmp_FinalResult_
		GROUP BY
			YEAR(date)
			,MONTH(date)
		ORDER BY 
			YEAR(date)
			,MONTH(date);

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
	SELECT DISTINCT tblSummaryHeader.AccountID  FROM tblSummaryHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryHeader.AccountID WHERE tblSummaryHeader.CompanyID = p_CompanyID;
	
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
	SELECT DISTINCT tblSummaryVendorHeader.AccountID  FROM tblSummaryVendorHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryVendorHeader.AccountID WHERE tblSummaryVendorHeader.CompanyID = p_CompanyID;
	
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

DROP PROCEDURE IF EXISTS `prc_verifySummary`;

DELIMITER |
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

	


END|
DELIMITER ;

USE `Ratemanagement3`;

INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (8, 'MOR', 'MOR', 1, 'RateManagementSystem', '2017-01-28 12:41:23', NULL, NULL);

INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (71, 8, 'MOR Server', 'dbserver', 1, '2015-07-09 13:56:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (72, 8, 'MOR Username', 'username', 1, '2015-07-09 13:56:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (73, 8, 'MOR Password', 'password', 1, '2015-07-09 13:56:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (74, 8, 'Authentication Rule', 'NameFormat', 1, '2015-07-09 13:56:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (75, 8, 'CDR ReRate', 'RateCDR', 1, '2015-12-21 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (76, 8, 'Rate Format', 'RateFormat', 1, '2015-12-21 11:19:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (77, 8, 'CLI Translation Rule', 'CLITranslationRule', 1, '2016-09-19 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (78, 8, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2016-09-19 10:39:33', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (79, 8, 'Allow Account Import', 'AllowAccountImport', 1, '2016-03-18 11:19:00', 'RateManagementSystem', NULL, NULL);

INSERT INTO `tblCronJobCommand` (`CronJobCommandID`, `CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (83, 1, 8, 'Download MOR CDR', 'moraccountusage', '[[{"title":"MOR Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-07-09 13:56:13', 'RateManagementSystem');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'MOR_CRONJOB', '{"MaxInterval":"1440","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"error@neon-soft.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');

INSERT INTO `tblResourceCategoriesGroups` (`CategoriesGroupID`, `GroupName`) VALUES
	(1, 'All'),
	(2, 'Dashboard'),
	(3, 'Accounts'),
	(4, 'Ticket Management'),
	(5, 'Rate Management'),
	(6, 'CRM'),
	(7, 'Billing'),
	(8, 'Settings'),
	(9, 'Admin'),
	(10, 'Jobs'),
	(11, 'Others'),
	(12, 'Integration');
	
update tblResourceCategories trc set trc.CategoryGroupID = '3' where trc.ResourceCategoryName like '%Account.%';

update tblResourceCategories trc set trc.CategoryGroupID = '2' where trc.ResourceCategoryName like '%Dashboard.%';

update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%ticket%';


update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%TicketDashboard%';
update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%TicketsFields%';
update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%TicketsGroups%';
update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%TicketsSla%';
update tblResourceCategories trc set trc.CategoryGroupID = '4' where trc.ResourceCategoryName like '%TicketsBusinessHours%';


update tblResourceCategories trc set trc.CategoryGroupID = '5' where trc.ResourceCategoryName like '%RateTables%';

update tblResourceCategories trc set trc.CategoryGroupID = '5' where trc.ResourceCategoryName like '%LCR.%';

update tblResourceCategories trc set trc.CategoryGroupID = '5' where trc.ResourceCategoryName like '%VendorProfiling%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Estimates%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Invoices%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%RecurringInvoice%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Dispute%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%BillingSubscription%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Payments%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%AccountStatement%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Products%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%InvoiceTemplates%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%TaxRates%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%CDR%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Discount%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%BillingClass%';

update tblResourceCategories trc set trc.CategoryGroupID = '6' where trc.ResourceCategoryName like '%OpportunityBoard%';

update tblResourceCategories trc set trc.CategoryGroupID = '6' where trc.ResourceCategoryName like '%Task%';

update tblResourceCategories trc set trc.CategoryGroupID = '6' where trc.ResourceCategoryName like '%Dashboard%';

update tblResourceCategories trc set trc.CategoryGroupID = '5' where trc.ResourceCategoryName like '%RateGenerator%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%invoice%';

update tblResourceCategories trc set trc.CategoryGroupID = '8' where trc.ResourceCategoryName like '%Currency%';

update tblResourceCategories trc set trc.CategoryGroupID = '6' where trc.ResourceCategoryName like '%Leads%';

update tblResourceCategories trc set trc.CategoryGroupID = '8' where trc.ResourceCategoryName like '%CodeDecks%';

update tblResourceCategories trc set trc.CategoryGroupID = '10' where trc.ResourceCategoryName like '%Jobs%';

update tblResourceCategories trc set trc.CategoryGroupID = '10' where trc.ResourceCategoryName like '%CronJob%';

update tblResourceCategories trc set trc.CategoryGroupID = '10' where trc.ResourceCategoryName like '%ActiveCronJob%';

update tblResourceCategories trc set trc.CategoryGroupID = '6' where trc.ResourceCategoryName like '%Opportunity%';

update tblResourceCategories trc set trc.CategoryGroupID = '7' where trc.ResourceCategoryName like '%Estimate%';

update tblResourceCategories trc set trc.CategoryGroupID = '9' where trc.ResourceCategoryName like '%ServerInfo%';

update tblResourceCategories trc set trc.CategoryGroupID = '11' where trc.ResourceCategoryName like '%MyProfile%';

update tblResourceCategories trc set trc.CategoryGroupID = '9' where trc.ResourceCategoryName like '%Retention%';

update tblResourceCategories trc set trc.CategoryGroupID = '8' where trc.ResourceCategoryName like '%Destination%';

update tblResourceCategories trc set trc.CategoryGroupID = '12' where trc.ResourceCategoryName like '%Integration%';

update tblResourceCategories trc set trc.CategoryGroupID = '12' where trc.ResourceCategoryName like '%Gateway%';

update tblResourceCategories trc set trc.CategoryGroupID = '11' where trc.ResourceCategoryName like '%Company%';

update tblResourceCategories trc set trc.CategoryGroupID = '8' where trc.ResourceCategoryName like '%Trunk%';

update tblResourceCategories trc set trc.CategoryGroupID = '11' where trc.ResourceCategoryName like '%Users%';

update tblResourceCategories trc set trc.CategoryGroupID = '3' where trc.ResourceCategoryName like '%CustomersRates%';

update tblResourceCategories trc set trc.CategoryGroupID = '3' where trc.ResourceCategoryName like '%VendorRates%';

update tblResourceCategories trc set trc.CategoryGroupID = '8' where trc.ResourceCategoryName like '%DialStrings%';

update tblResourceCategories trc set trc.CategoryGroupID = '9' where trc.ResourceCategoryName like '%Alert%';

update tblResourceCategories trc set trc.CategoryGroupID = '2' where trc.ResourceCategoryName like '%analysis%';

update tblResourceCategories trc set trc.CategoryGroupID = '11' where trc.ResourceCategoryName like '%Pages.%';

update tblResourceCategories trc set trc.CategoryGroupID = 2 where trc.ResourceCategoryName like '%MonitorDashboard%';

DELETE from tblResourceCategories where ResourceCategoryName like '%Messages%';	


INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES	(1, 'TICKETING_SYSTEM', '0');


INSERT INTO `tblTicketBusinessHours` (`ID`, `CompanyID`, `IsDefault`, `Name`, `Description`, `Timezone`, `HoursType`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES	(1, 1, 1, 'Default', 'Default Business Calendar', '0', 2, '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL);
INSERT INTO `tblTicketsWorkingDays` (`ID`, `BusinessHoursID`, `Day`, `Status`, `StartTime`, `EndTime`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
	(1, 1, 2, 1, '08:00:00', '17:00:00', '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL),
	(2, 1, 3, 1, '08:00:00', '17:00:00', '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL),
	(3, 1, 4, 1, '08:00:00', '17:00:00', '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL),
	(4, 1, 5, 1, '08:00:00', '17:00:00', '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL),
	(5, 1, 6, 1, '08:00:00', '17:00:00', '2017-04-26 11:29:58', NULL, '2017-04-26 11:29:58', NULL);


INSERT INTO `tblTicketSla` (`TicketSlaID`, `CompanyID`, `IsDefault`, `Name`, `Description`, `Status`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES	(1, 1, 1, 'Default SLA', 'Default SLA', 1, '2017-05-08 10:44:16', NULL, '2017-05-08 10:44:16', NULL);
	
INSERT INTO `tblTicketSlaTarget` (`SlaTargetID`, `TicketSlaID`, `PriorityID`, `RespondValue`, `RespondType`, `ResolveValue`, `ResolveType`, `OperationalHrs`, `EscalationEmail`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES
(1, 1, 4, 15, 'Minute', 1, 'Hour', '1', 1, '2017-05-08 10:44:16', NULL, '2017-05-08 10:44:16', NULL),
(2, 1, 3, 30, 'Minute', 2, 'Hour', '1', 1, '2017-05-08 10:44:16', NULL, '2017-05-08 10:44:16', NULL),
(3, 1, 2, 1, 'Hour', 2, 'Hour', '1', 1, '2017-05-08 10:44:16', NULL, '2017-05-08 10:44:16', NULL),
(4, 1, 1, 2, 'Hour', 1, 'Day', '1', 1, '2017-05-08 10:44:16', NULL, '2017-05-08 10:44:16', NULL);

INSERT INTO `tblTicketSlaPolicyApplyTo` (`TicketSlaID`) VALUES ('1');


INSERT INTO `tblTicketSlaPolicyViolation` (`ViolationID`, `TicketSlaID`, `Time`, `Value`, `VoilationType`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES
	(1, 1, 'immediately', '0', 0, '2017-05-08 10:44:18', NULL, '2017-05-08 10:44:18', NULL),
	(2, 1, 'immediately', '0', 1, '2017-05-08 10:44:22', NULL, '2017-05-08 10:44:22', NULL);

	
INSERT INTO `tblEmailTemplate` ( `CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES ( 1, 'Notification - Invoice Paid by Customer', 'Invoice {{InvoiceNumber}} from {{CompanyName}} Paid by {{FirstName}} {{LastName}}', '<br>Invoice {{InvoiceNumber}} from {{CompanyName}} Paid by Customer {{FirstName}} {{LastName}}<br>\r\n\r\nto view paid invoice please click the below link.<br><br>\r\n\r\n\r\n<div><!--[if mso]>\r\n  <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="{{InvoiceLink}}" style="height:30px;v-text-anchor:middle;width:100px;" arcsize="10%" strokecolor="#ff9600" fillcolor="#ff9600">\r\n    <w:anchorlock/>\r\n    <center style="color:#ffffff;font-family:sans-serif;font-size:13px;font-weight:bold;">View</center>\r\n  </v:roundrect>\r\n<![endif]-->\r\n<a href="{{InvoiceLink}}" style="background-color:#ff9600;border:1px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{InvoiceLink}}">View</a></div>\r\n<br><br>', '2017-04-11 19:30:19', 'System', '2017-04-11 19:34:24', 'System', NULL, 0, '', 1, 'InvoicePaidNotification', 1, 0, 0);
INSERT INTO `tblEmailTemplate` ( `CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES ( 1, 'Dispute Raised', 'A dispute from {{CompanyName}} ', 'Hi {{AccountName}}<br><br>\r\n\r\n\r\n{{CompanyName}} has added a dispute of {{DisputeAmount}} {{Currency}} against {{InvoiceNumber}}\r\n\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}', '2017-04-13 18:28:39', 'System', '2017-04-13 18:28:39', 'System', NULL, 0, '', 1, 'DisputeEmailCustomer', 1, 0, 0);	

INSERT INTO `tblEmailTemplate` ( `CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES
	(1, 'Agent Response SlaVoilation', 'Response time SLA violated - [#{{TicketID}}] {{Subject}}', '<p style="margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding: 0px; outline: 0px; font-size: 13px; font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; vertical-align: baseline; border: 0px; line-height: 1.3; word-break: normal; word-wrap: break-word; color: rgb(51, 51, 51);">Hi,<br><br>There has been no response from the helpdesk for Ticket ID #{{TicketID}}.<br><br>Ticket Details:&nbsp;<br><br>Subject - {{Subject}}<br><br>Requestor - {{Requester}}<br><br>Regards,<br>{{CompanyName}}<br></p><p></p>', '2017-01-25 15:35:02', 'System', '2017-03-30 12:40:55', 'System', NULL, 4, '', 1, 'AgentResponseSlaVoilation', 1, 0, 1),
	(1, 'Agent Resolve SlaVoilation', 'Response time SLA violated - [#{{TicketID}}] {{Subject}}', '<p style="margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding: 0px; outline: 0px; font-size: 13px; font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; vertical-align: baseline; border: 0px; line-height: 1.3; word-break: normal; word-wrap: break-word; color: rgb(51, 51, 51);">Hi,<br><br>There has been no response from the helpdesk for Ticket ID #{{TicketID}}.<br><br>Ticket Details:&nbsp;<br><br>Subject - {{Subject}}<br><br>Requestor - {{Requester}}<br><br>Regards,<br>{{CompanyName}}&nbsp;&nbsp;&nbsp;&nbsp;<br></p><p></p>', '2017-01-25 15:35:02', 'System', '2017-03-30 12:40:55', 'System', NULL, 4, '', 1, 'AgentResolveSlaVoilation', 1, 0, 1);




INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (1, 'from_email', 'Requester Email', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (2, 'to_email', 'To Email', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (3, 'subject', 'Subject', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (4, 'description', 'Description', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (5, 'subject_or_description', 'Subject or Description', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (6, 'priority', 'Priority', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (7, 'status', 'Status', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (8, 'agent', 'Agent', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleConditionType` (`TicketImportRuleConditionTypeID`, `Condition`, `ConditionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (9, 'group', 'Group', NULL, NULL, NULL, NULL);


INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (1, 'delete_ticket', 'Delete the Ticket', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (2, 'skip_notification', 'Skip New Ticket Email Notifications', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (3, 'set_priority', 'Set Priority as', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (4, 'set_status', 'Set Status as', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (5, 'set_agent', 'Assign to Agent', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (6, 'set_group', 'Assign to Group', NULL, NULL, NULL, NULL);
INSERT INTO `tblTicketImportRuleActionType` (`TicketImportRuleActionTypeID`, `Action`, `ActionText`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (7, 'set_type', 'Set Type as', NULL, NULL, NULL, NULL);

INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (1, 'default_requester', '0', 1, 'text', 'Search a requester', NULL, 1, 1, 1, 1, 1, 'Search a requester', 'Requester1', 2, 3, 3, NULL, NULL, '2017-05-17 13:51:53', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (2, 'default_subject', '0', 1, 'text', 'Subject', NULL, 1, 0, 1, 1, 1, 'Subject', 'Subject', 0, 0, 2, NULL, NULL, '2017-01-11 21:28:49', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (3, 'default_ticket_type', '0', 5, 'dropdown', 'Type', NULL, 1, 1, 1, 1, 1, 'Type', 'Type', 0, 0, 5, NULL, NULL, '2017-04-26 15:13:07', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (4, 'default_status', '0', 5, 'dropdown', 'Status', NULL, 1, 0, 1, 1, 0, 'Status', 'Status', 0, 0, 4, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (5, 'default_priority', '0', 5, 'dropdown', 'Priority', NULL, 1, 0, 1, 1, 1, 'Priority', 'Priority', 0, 0, 6, NULL, NULL, '2017-03-28 22:55:32', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (6, 'default_group', '0', 5, 'dropdown', 'Group', NULL, 1, 1, 1, 1, 1, 'Group', 'Neon First Group', 0, 0, 7, NULL, NULL, '2017-04-26 15:13:07', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (8, 'default_description', '0', 2, 'paragraph', 'Description', NULL, 1, 0, 1, 1, 0, 'Description', 'Description', 0, 0, 9, NULL, NULL, '2017-05-17 08:47:16', 'System');
INSERT INTO `tblTicketfields` (`TicketFieldsID`, `FieldType`, `FieldStaticType`, `FieldHtmlType`, `FieldDomType`, `FieldName`, `FieldDesc`, `AgentReqSubmit`, `AgentReqClose`, `CustomerDisplay`, `CustomerEdit`, `CustomerReqSubmit`, `AgentLabel`, `CustomerLabel`, `AgentCcDisplay`, `CustomerCcDisplay`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (7, 'default_agent', '0', 5, 'dropdown_blank', 'Agent', NULL, 0, 0, 0, 0, 0, 'Agent', 'Assigned to', 0, 0, 8, NULL, NULL, '2017-04-26 15:13:07', 'System');


INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (7, 3, 1, 'Other', 'Other', 0, 2, NULL, NULL, '2017-03-28 22:56:22', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (11, 3, 1, 'NEON', 'NEON', 0, 1, NULL, NULL, '2017-03-28 22:56:22', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (13, 4, 0, 'Open', 'Being Processed', 1, 4, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (14, 4, 0, 'Pending', 'Awaiting your Reply', 0, 1, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (15, 4, 0, 'Resolved', 'This ticket has been Resolved', 0, 2, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (16, 4, 0, 'Closed', 'This ticket has been Closed', 0, 3, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (17, 4, 0, 'All UnResolved', 'This ticket has been All Un Resolved', 0, 7, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (18, 4, 1, 'Waiting on Customer', 'Awaiting your Reply', 0, 5, NULL, NULL, '2017-05-17 08:46:54', 'System');
INSERT INTO `tblTicketfieldsValues` (`ValuesID`, `FieldsID`, `FieldType`, `FieldValueAgent`, `FieldValueCustomer`, `FieldSlaTime`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES (19, 4, 1, 'Waiting on Third Party', 'Being Processed', 1, 6, NULL, NULL, '2017-05-17 08:46:54', 'System');

DELETE FROM `tblResourceCategories` WHERE ResourceCategoryID between 1249 AND 1298;
DELETE FROM `tblResource` WHERE CategoryID between 1249 AND 1298;

INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1298, 'AccountService.All', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1297, 'AccountService.View', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1296, 'AccountService.Delete', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1295, 'AccountService.Edit', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1294, 'AccountService.Add', 1, 3);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1293, 'Service.Add', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1292, 'Service.Delete', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1291, 'Service.Edit', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1290, 'Service.View', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1289, 'Service.All', 1, 7);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1282, 'TicketDashboard.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1281, 'TicketsBusinessHours.All', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1280, 'TicketsBusinessHours.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1279, 'TicketsBusinessHours.Delete', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1278, 'TicketsBusinessHours.Edit', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1277, 'TicketsBusinessHours.Add', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1276, 'TicketsSla.All', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1275, 'TicketsSla.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1274, 'TicketsSla.Delete', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1273, 'TicketsSla.Edit', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1271, 'TicketsSla.Add', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1270, 'TicketDashboardTimeLineWidgets.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1269, 'TicketDashboardSummaryWidgets.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1268, 'RecurringProfile.All', 1, 0);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1267, 'RecurringProfile.View', 1, 0);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1266, 'RecurringProfile.Delete', 1, 0);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1265, 'RecurringProfile.Edit', 1, 0);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1264, 'RecurringProfile.Add', 1, 0);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1263, 'Tickets.View.RestrictedAccess', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1262, 'Tickets.View.GroupAccess', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1261, 'Tickets.View.GlobalAccess', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1260, 'TicketsGroups.Delete', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1259, 'TicketsGroups.Edit', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1258, 'TicketsGroups.Add', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1257, 'TicketsGroups.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1256, 'TicketsGroups.All', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1255, 'TicketsFields.Edit', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1254, 'Tickets.Delete', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1253, 'Tickets.Edit', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1252, 'Tickets.Add', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1251, 'Tickets.View', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1250, 'Tickets.All', 1, 4);
INSERT INTO `tblResourceCategories` (`ResourceCategoryID`, `ResourceCategoryName`, `CompanyID`, `CategoryGroupID`) VALUES (1299, 'BillingDashboardPaybleWidget.View', 1, 7);


INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.index', 'TicketsController.index', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.*', 'TicketsController.*', 1, 1250);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.ajax_datagrid_groups', 'TicketsController.ajax_datagrid_groups', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.Activate_support_email', 'TicketsGroupController.Activate_support_email', 1, 1257);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.index', 'RecurringInvoiceController.index', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.create', 'RecurringInvoiceController.create', 1, 1264);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.store', 'RecurringInvoiceController.store', 1, 1264);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.edit', 'RecurringInvoiceController.edit', 1, 1265);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.delete', 'RecurringInvoiceController.delete', 1, 1266);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.ajax_datagrid', 'RecurringInvoiceController.ajax_datagrid', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.calculate_total', 'RecurringInvoiceController.calculate_total', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.getAccountInfo', 'RecurringInvoiceController.getAccountInfo', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.getBillingClassInfo', 'RecurringInvoiceController.getBillingClassInfo', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.recurringinvoicelog', 'RecurringInvoiceController.recurringinvoicelog', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.ajax_recurringinvoicelog_datagrid', 'RecurringInvoiceController.ajax_recurringinvoicelog_datagrid', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.startstop', 'RecurringInvoiceController.startstop', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('RecurringInvoice.generate', 'RecurringInvoiceController.generate', 1, 1267);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.index', 'TicketsGroupController.index', 1, 1257);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.*', 'TicketsGroupController.*', 1, 1256);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.add', 'TicketsGroupController.add', 1, 1258);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.Store', 'TicketsGroupController.Store', 1, 1258);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.ajax_datagrid', 'TicketsGroupController.ajax_datagrid', 1, 1257);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.Edit', 'TicketsGroupController.Edit', 1, 1259);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.Update', 'TicketsGroupController.Update', 1, 1259);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.delete', 'TicketsGroupController.delete', 1, 1260);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.send_activation_single', 'TicketsGroupController.send_activation_single', 1, 1257);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.get_group_agents', 'TicketsGroupController.get_group_agents', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.index', 'TicketsFieldsController.index', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.*', 'TicketsFieldsController.*', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.iframe', 'TicketsFieldsController.iframe', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.iframeSubmit', 'TicketsFieldsController.iframeSubmit', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.ajax_ticketsfields', 'TicketsFieldsController.ajax_ticketsfields', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.Ajax_Ticketsfields_Choices', 'TicketsFieldsController.Ajax_Ticketsfields_Choices', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.Save_Single_Field', 'TicketsFieldsController.Save_Single_Field', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsFields.Update_Fields_Sorting', 'TicketsFieldsController.Update_Fields_Sorting', 1, 1255);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.ajex_result', 'TicketsController.ajex_result', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.add', 'TicketsController.add', 1, 1252);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.uploadFile', 'TicketsController.uploadFile', 1, 1252);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.deleteUploadFile', 'TicketsController.deleteUploadFile', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.Store', 'TicketsController.Store', 1, 1252);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.edit', 'TicketsController.edit', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.Update', 'TicketsController.Update', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.UpdateDetailPage', 'TicketsController.UpdateDetailPage', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.delete', 'TicketsController.delete', 1, 1254);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.Detail', 'TicketsController.Detail', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.TicketAction', 'TicketsController.TicketAction', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.UpdateTicketAttributes', 'TicketsController.UpdateTicketAttributes', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.ActionSubmit', 'TicketsController.ActionSubmit', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.getConversationAttachment', 'TicketsController.getConversationAttachment', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.GetTicketAttachment', 'TicketsController.GetTicketAttachment', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.CloseTicket', 'TicketsController.CloseTicket', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.ComposeEmail', 'TicketsController.ComposeEmail', 1, 1252);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.SendMail', 'TicketsController.SendMail', 1, 1252);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.add_note', 'TicketsController.add_note', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsGroup.validatesmtp', 'TicketsGroupController.validatesmtp', 1, 1257);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Dashboard.TicketDashboard', 'DashboardController.TicketDashboard', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.index', 'TicketsSlaController.index', 1, 1275);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.*', 'TicketsSlaController.*', 1, 1276);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.edit', 'TicketsSlaController.edit', 1, 1273);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.ajax_datagrid', 'TicketsSlaController.ajax_datagrid', 1, 1275);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.add', 'TicketsSlaController.add', 1, 1271);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.store', 'TicketsSlaController.store', 1, 1271);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.delete', 'TicketsSlaController.delete', 1, 1274);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsSla.update', 'TicketsSlaController.update', 1, 1273);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.ajex_result_export', 'TicketsController.ajex_result_export', 1, 1251);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.UpdateTicketDueTime', 'TicketsController.UpdateTicketDueTime', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.index', 'TicketsBusinessHoursController.index', 1, 1280);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.*', 'TicketsBusinessHoursController.*', 1, 1281);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.ajax_datagrid', 'TicketsBusinessHoursController.ajax_datagrid', 1, 1280);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.create', 'TicketsBusinessHoursController.create', 1, 1277);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.store', 'TicketsBusinessHoursController.store', 1, 1277);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.delete', 'TicketsBusinessHoursController.delete', 1, 1279);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.edit', 'TicketsBusinessHoursController.edit', 1, 1278);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketsBusinessHours.update', 'TicketsBusinessHoursController.update', 1, 1278);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.BulkAction', 'TicketsController.BulkAction', 1, 1253);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Tickets.BulkDelete', 'TicketsController.BulkDelete', 1, 1254);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketDashboard.ticketSummaryWidget', 'TicketDashboardController.ticketSummaryWidget', 1, 1269);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('TicketDashboard.ticketTimeLineWidget', 'TicketDashboardController.ticketTimeLineWidget', 1, 1270);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.index', 'ServicesController.index', 1, 1290);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.*', 'ServicesController.*', 1, 1289);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.ajax_datagrid', 'ServicesController.ajax_datagrid', 1, 1290);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.store', 'ServicesController.store', 1, 1293);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.update', 'ServicesController.update', 1, 1291);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.delete', 'ServicesController.delete', 1, 1292);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('Services.exports', 'ServicesController.exports', 1, 1290);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.addservices', 'AccountServiceController.addservices', 1, 1294);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.edit', 'AccountServiceController.edit', 1, 1295);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.ajax_datagrid', 'AccountServiceController.ajax_datagrid', 1, 1297);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.update', 'AccountServiceController.update', 1, 1295);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.changestatus', 'AccountServiceController.changestatus', 1, 1295);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.delete', 'AccountServiceController.delete', 1, 1296);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('AccountService.*', 'AccountServiceController.*', 1, 1298);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CategoryID`) VALUES ('BillingDashboard@GetDashboardPR', 'BillingDashboard.GetDashboardPR', 1,1299);


CALL migrateService();

USE `RMCDR3`;

SET @tables = NULL;
SELECT GROUP_CONCAT('`', table_schema, '`.`', table_name,'`') INTO @tables FROM information_schema.tables 
WHERE table_schema = 'RMCDR3' AND table_name LIKE BINARY 'tblTemp%';

SET @tables = CONCAT('DROP TABLE ', @tables);
PREPARE stmt1 FROM @tables;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;