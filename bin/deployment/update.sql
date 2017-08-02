USE `Ratemanagement3`;
CREATE TABLE `tblAuditHeader` (
	`AuditHeaderID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`UserID` INT(11) NOT NULL,
	`CompanyID` INT(11) NOT NULL,
	`Date` DATE NULL DEFAULT NULL COMMENT 'account, product etc',
	`ParentColumnName` TEXT NULL COLLATE 'utf8_unicode_ci',
	`ParentColumnID` INT(11) NOT NULL,
	`Type` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`IP` TEXT NULL COLLATE 'utf8_unicode_ci',
	`UserType` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`AuditHeaderID`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;


CREATE TABLE `tblAuditDetails` (
	`AuditDetailID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`AuditHeaderID` INT(11) UNSIGNED NOT NULL,
	`ColumnName` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`OldValue` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`NewValue` LONGTEXT NULL COLLATE 'utf8_unicode_ci',
	`created_at` DATETIME NULL DEFAULT NULL,
	`created_by` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`AuditDetailID`),
	INDEX `IX_AuditHeaderID` (`AuditHeaderID`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;
	
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

DROP PROCEDURE IF EXISTS `prc_getTrunkByMaxMatch`;
DELIMITER |
CREATE PROCEDURE `prc_getTrunkByMaxMatch`(
	IN `p_CompanyID` INT,
	IN `p_Trunk` VARCHAR(200)
)
BEGIN


	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	DROP TEMPORARY TABLE IF EXISTS tmp_all_trunk_;
   CREATE TEMPORARY TABLE tmp_all_trunk_ (
     RowTrunk  varchar(50),
     TrunkID INT,
     Trunk  varchar(50),
     RowNo int
   );



 insert into tmp_all_trunk_
  SELECT  distinct t.Trunk , t.TrunkID , RIGHT(t.Trunk, x.RowNo) as loopCode , RowNo
			 FROM (
		          SELECT @RowNo  := @RowNo + 1 as RowNo
		          FROM mysql.help_category
		          ,(SELECT @RowNo := 0 ) x
		          limit 20
          ) x
          INNER JOIN tblTrunk AS t
          ON t.CompanyId = p_CompanyID and x.RowNo   <= LENGTH(t.Trunk)
          and ( p_Trunk like concat('%' , t.Trunk ) )
          order by LENGTH(t.Trunk) desc , RowNo desc ;

	-- select TrunkID from tmp_all_trunk_ order by RowNo desc limit 1;

	select TrunkID from tmp_all_trunk_ where ( @p_Trunk like concat('%' , Trunk ) ) order by  RowNo desc limit 1;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetSingleTicket`;
DELIMITER |	
CREATE PROCEDURE `prc_GetSingleTicket`(
	IN `p_TicketID` INT

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	select t.* , eal.EmailTo from tblTickets t
	left join AccountEmailLog eal on t.TicketID = eal.TicketID and eal.EmailParent = 0
	where t.TicketID =  p_TicketID limit 1;



	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;


END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_CustomerRatesFileImport`;
DELIMITER |
CREATE PROCEDURE `prc_CustomerRatesFileImport`(
	IN `p_ProcessID` VARCHAR(200),
	IN `p_tbltemp_name` VARCHAR(200)
)
BEGIN

	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_codedeckid_ INT;
	DECLARE v_companyid_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM `' , p_tbltemp_name , '` ud WHERE ProcessID="' , p_ProcessID , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
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
		SET v_codedeckid_ = (SELECT CodeDeckId FROM tblCustomerTrunk WHERE tblCustomerTrunk.TrunkID = v_TrunkID_ AND tblCustomerTrunk.AccountID = v_AccountID_ AND tblCustomerTrunk.Status = 1);

		IF v_codedeckid_ IS NOT NULL AND (SELECT COUNT(*) FROM tblCodeDeck WHERE CodeDeckId = v_codedeckid_)>0
		THEN

			SET v_companyid_ = (SELECT CompanyId FROM tblCodeDeck WHERE CodeDeckId = v_codedeckid_);			

			-- code insert and update rate id in temp table
			CALL prc_updateRateID(v_AccountID_,v_codedeckid_,p_tbltemp_name,p_ProcessID);

			-- CALL prc_GetCustomerRate(v_companyid_,v_AccountID_,v_TrunkID_,null,null,null,'All',1,0,0,0,'','',-1);
			
			-- customerrate insert,update and delete
			CALL prc_putCustomerCodeRate(v_AccountID_,v_TrunkID_,p_tbltemp_name,p_ProcessID);

		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

	SET @stm = CONCAT('
	DELETE FROM `' , p_tbltemp_name , '` WHERE ProcessID="' , p_ProcessID , '" ;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm; 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_putCustomerCodeRate`;
DELIMITER |
CREATE PROCEDURE `prc_putCustomerCodeRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_tbltemp_name` VARCHAR(200),
	IN `p_ProcessID` VARCHAR(200)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempLog_(
		`Message` VARCHAR(500) NOT NULL	
	);
	/* delete codes which are not exist in temp table*/
	SET @stm = CONCAT('
	DELETE cr FROM `' , p_tbltemp_name , '` cr 
	LEFT JOIN (SELECT AccountID,TrunkID,RateID,MAX(EffectiveDate) as EffectiveDate FROM `' , p_tbltemp_name , '`  WHERE ProcessID = "' , p_ProcessID , '" AND EffectiveDate <= NOW()  GROUP BY  AccountID,TrunkID,RateID )tbl
		ON tbl.AccountID = cr.AccountID  
		AND tbl.TrunkID = cr.TrunkID
		AND tbl.RateID = cr.RateID
		AND tbl.EffectiveDate = cr.EffectiveDate
	WHERE tbl.EffectiveDate IS NULL AND cr.EffectiveDate <= NOW() AND cr.ProcessID = "' , p_ProcessID , '";');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Old Effective Dates Records Deleted ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	/* delete codes which are not exist in temp table*/
	SET @stm = CONCAT('
	DELETE tblCustomerRate FROM tblCustomerRate
	LEFT JOIN `' , p_tbltemp_name , '` temp 
		ON tblCustomerRate.RateID = temp.RateID
		AND tblCustomerRate.TrunkID = temp.TrunkID
		AND CustomerID  = AccountID
		AND tblCustomerRate.EffectiveDate = temp.EffectiveDate
		AND ProcessID = "' , p_ProcessID , '"
	WHERE TempRatesImportID IS NULL AND CustomerID = "' , p_AccountID , '" AND tblCustomerRate.TrunkID = "' , p_TrunkID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Deleted ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	-- 	 update codes which are exist in temp table
	SET @stm = CONCAT('
	UPDATE tblCustomerRate 
	INNER JOIN `' , p_tbltemp_name , '` temp 
		ON tblCustomerRate.RateID = temp.RateID
		AND tblCustomerRate.TrunkID = temp.TrunkID
		AND CustomerID  = AccountID
		AND tblCustomerRate.EffectiveDate = temp.EffectiveDate
	SET tblCustomerRate.PreviousRate = tblCustomerRate.Rate,tblCustomerRate.Rate = temp.Rate,tblCustomerRate.ConnectionFee = temp.ConnectionFee
	WHERE CustomerID = "' , p_AccountID , '" AND tblCustomerRate.TrunkID = "' , p_TrunkID , '" AND ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Updated ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	-- insert codes which are not exist in customer table
	SET @stm = CONCAT('
	INSERT INTO tblCustomerRate (RateID,CustomerID,TrunkID,LastModifiedDate,LastModifiedBy,Rate,EffectiveDate,Interval1,IntervalN,ConnectionFee)
	SELECT temp.RateID,temp.AccountID,temp.TrunkID,now(),"SYSTEM IMPORTED",temp.Rate,temp.EffectiveDate,temp.Interval1,temp.IntervalN,temp.ConnectionFee FROM `' , p_tbltemp_name , '` temp
	LEFT JOIN tblCustomerRate
		ON tblCustomerRate.RateID = temp.RateID
		AND tblCustomerRate.TrunkID = temp.TrunkID
		AND CustomerID  = AccountID
		AND tblCustomerRate.EffectiveDate = temp.EffectiveDate
		AND ProcessID = "' , p_ProcessID , '"
	WHERE CustomerRateID IS NULL AND AccountID = "' , p_AccountID , '" AND temp.TrunkID = "' , p_TrunkID , '" AND temp.RateID IS NOT NULL;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Inserted ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	SELECT * FROM tmp_tblTempLog_;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_putVendorCodeRate`;
DELIMITER |
CREATE PROCEDURE `prc_putVendorCodeRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_tbltemp_name` VARCHAR(200),
	IN `p_ProcessID` VARCHAR(200)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempLog_(
		`Message` VARCHAR(500) NOT NULL	
	);
	
	/* delete old dates rate */
	SET @stm = CONCAT('
	DELETE cr FROM `' , p_tbltemp_name , '` cr 
	LEFT JOIN (SELECT AccountID,TrunkID,RateID,MAX(EffectiveDate) as EffectiveDate FROM `' , p_tbltemp_name , '`  WHERE ProcessID = "' , p_ProcessID , '" AND EffectiveDate <= NOW() GROUP BY  AccountID,TrunkID,RateID )tbl
		ON tbl.AccountID = cr.AccountID  
		AND tbl.TrunkID = cr.TrunkID
		AND tbl.RateID = cr.RateID
		AND tbl.EffectiveDate = cr.EffectiveDate
	WHERE tbl.EffectiveDate IS NULL AND cr.EffectiveDate <= NOW() AND cr.ProcessID = "' , p_ProcessID , '";');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Old Effective Dates Records Deleted ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	/* delete codes which are not exist in temp table*/
	SET @stm = CONCAT('
	DELETE tblVendorRate FROM tblVendorRate
	LEFT JOIN `' , p_tbltemp_name , '` temp 
		ON tblVendorRate.RateId = temp.RateID
		AND tblVendorRate.TrunkID = temp.TrunkID
		AND tblVendorRate. AccountId  = temp.AccountID
		AND tblVendorRate.EffectiveDate = temp.EffectiveDate
		AND ProcessID = "' , p_ProcessID , '"
	WHERE TempRatesImportID IS NULL AND tblVendorRate.AccountId = "' , p_AccountID , '" AND tblVendorRate.TrunkID = "' , p_TrunkID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Deleted  ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	/* update codes which are exist in temp table*/
	SET @stm = CONCAT('
	UPDATE tblVendorRate 
	INNER JOIN `' , p_tbltemp_name , '` temp 
		ON tblVendorRate.RateId = temp.RateID
		AND tblVendorRate.TrunkID = temp.TrunkID
		AND tblVendorRate.AccountId  = temp.AccountID
		AND tblVendorRate.EffectiveDate = temp.EffectiveDate
	SET tblVendorRate.Interval1 = temp.Interval1,tblVendorRate.IntervalN = temp.IntervalN,tblVendorRate.Rate = temp.Rate,tblVendorRate.ConnectionFee = temp.ConnectionFee,updated_at=NOW(),updated_by="SYSTEM IMPORTED"
	WHERE tblVendorRate.AccountId = "' , p_AccountID , '" AND tblVendorRate.TrunkID = "' , p_TrunkID , '" AND ProcessID = "' , p_ProcessID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;
	
	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Updated ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	/* insert codes which are not exist in customer table*/
	SET @stm = CONCAT('
	INSERT INTO tblVendorRate (RateId,AccountId,TrunkID,created_at,created_by,Rate,EffectiveDate,Interval1,IntervalN,ConnectionFee)
	SELECT temp.RateID,temp.AccountID,temp.TrunkID,now(),"SYSTEM IMPORTED",temp.Rate,temp.EffectiveDate,temp.Interval1,temp.IntervalN,temp.ConnectionFee FROM `' , p_tbltemp_name , '` temp
	LEFT JOIN tblVendorRate
		ON tblVendorRate.RateId = temp.RateID
		AND tblVendorRate.TrunkID = temp.TrunkID
		AND tblVendorRate.AccountId  = temp.AccountID
		AND tblVendorRate.EffectiveDate = temp.EffectiveDate
		AND ProcessID = "' , p_ProcessID , '"
	WHERE VendorRateID IS NULL AND temp.AccountID = "' , p_AccountID , '" AND temp.TrunkID = "' , p_TrunkID , '" AND temp.RateID IS NOT NULL;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	INSERT INTO tmp_tblTempLog_ (Message)
	SELECT CONCAT(AccountName,' Records Inserted ',FOUND_ROWS()) FROM tblAccount WHERE AccountID = p_AccountID;

	SELECT * FROM tmp_tblTempLog_;
	
	CALL prc_putVendorPreference(p_AccountID,p_TrunkID,p_tbltemp_name,p_ProcessID);

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_putVendorPreference`;
DELIMITER |
CREATE PROCEDURE `prc_putVendorPreference`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_tbltemp_name` VARCHAR(200),
	IN `p_ProcessID` VARCHAR(200)
)
BEGIN

	/* delete codes which are not exist in temp table*/
	SET @stm = CONCAT('
	DELETE tblVendorPreference FROM tblVendorPreference
	LEFT JOIN `' , p_tbltemp_name , '` temp 
		ON tblVendorPreference.RateId = temp.RateID
		AND tblVendorPreference.TrunkID = temp.TrunkID
		AND tblVendorPreference. AccountId  = temp.AccountID
		AND ProcessID = "' , p_ProcessID , '"
	WHERE TempRatesImportID IS NULL AND tblVendorPreference.AccountId = "' , p_AccountID , '" AND tblVendorPreference.TrunkID = "' , p_TrunkID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	/* update codes which are exist in temp table*/
	SET @stm = CONCAT('
	UPDATE tblVendorPreference 
	INNER JOIN `' , p_tbltemp_name , '` temp 
		ON tblVendorPreference.RateId = temp.RateID
		AND tblVendorPreference.TrunkID = temp.TrunkID
		AND tblVendorPreference.AccountId  = temp.AccountID
		AND tblVendorPreference.EffectiveDate = temp.EffectiveDate
	SET tblVendorPreference.Preference = temp.Interval1,created_at=NOW(),CreatedBy="SYSTEM IMPORTED"
	WHERE tblVendorPreference.AccountId = "' , p_AccountID , '" AND tblVendorPreference.TrunkID = "' , p_TrunkID , '" AND ProcessID = "' , p_ProcessID , ' AND tblVendorPreference.Preference <> 0";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;
	
	/* insert codes which are not exist in customer table*/
	SET @stm = CONCAT('
	INSERT INTO tblVendorPreference (AccountId,RateId,TrunkID,created_at,CreatedBy)
	SELECT DISTINCT temp.AccountID,temp.RateID,temp.TrunkID,now(),"SYSTEM IMPORTED" FROM `' , p_tbltemp_name , '` temp
	LEFT JOIN tblVendorPreference
		ON tblVendorPreference.RateId = temp.RateID
		AND tblVendorPreference.TrunkID = temp.TrunkID
		AND tblVendorPreference.AccountId  = temp.AccountID
		AND tblVendorPreference.EffectiveDate = temp.EffectiveDate
		AND ProcessID = "' , p_ProcessID , '"
	WHERE VendorRateID IS NULL AND temp.AccountID = "' , p_AccountID , '" AND temp.TrunkID = "' , p_TrunkID , '" AND tblVendorPreference.Preference <> 0 AND temp.RateID IS NOT NULL;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateRateID`;
DELIMITER |
CREATE PROCEDURE `prc_updateRateID`(
	IN `p_AccountID` INT,
	IN `p_CodeDeckID` INT,
	IN `p_tbltemp_name` VARCHAR(200),
	IN `p_ProcessID` VARCHAR(200)
)
BEGIN

	SET @rowcount = 1;

	WHILE @rowcount  > 0 DO

		SET @stm = CONCAT('
		INSERT IGNORE INTO tblRate (CountryID,Description,CompanyID,CodeDeckId,Code,Interval1,IntervalN,CreatedBy)
		SELECT DISTINCT fnGetCountryIdByCodeAndCountry(temp.Code,temp.Description),temp.Description,temp.CompanyID,"' , p_CodeDeckID , '",temp.Code,temp.Interval1,temp.IntervalN,"SYSTEM IMPOERTED"
		FROM `' , p_tbltemp_name , '` temp 
		LEFT JOIN tblRate code ON code.CompanyID = temp.CompanyID AND code.Code = temp.Code AND code.CodeDeckId="' , p_CodeDeckID , '"
		WHERE ProcessID="' , p_ProcessID , '" AND code.RateID IS NULL
		LIMIT 1000;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;
		SET @stm = CONCAT('

		SELECT COUNT(DISTINCT temp.Code) INTO @rowcount
		FROM `' , p_tbltemp_name , '` temp 
		LEFT JOIN tblRate code ON code.CompanyID = temp.CompanyID AND code.Code = temp.Code AND code.CodeDeckId="' , p_CodeDeckID , '"
		WHERE ProcessID="' , p_ProcessID , '" AND code.RateID IS NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

	END WHILE;

	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		RateID INT,
		Code VARCHAR(50),
		INDEX tmp_codes_RateID (`RateID`),
		INDEX tmp_codes_Code (`Code`)
	);
	INSERT INTO tmp_codes_
	SELECT
	DISTINCT
		tblRate.RateID,
		tblRate.Code
	FROM tblRate
	WHERE
		 tblRate.CodeDeckId = p_CodeDeckID;

	SET @stm = CONCAT('
	UPDATE `' , p_tbltemp_name , '` temp 
	INNER JOIN tmp_codes_ code ON code.Code = temp.Code
		SET temp.RateID = code.RateID
	WHERE ProcessID="' , p_ProcessID , '";
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_VendorRatesFileImport`;
DELIMITER |
CREATE PROCEDURE `prc_VendorRatesFileImport`(
	IN `p_ProcessID` VARCHAR(200),
	IN `p_tbltemp_name` VARCHAR(200)
)
BEGIN

	DECLARE v_pointer_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_codedeckid_ INT;
	DECLARE v_companyid_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM `' , p_tbltemp_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
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
		SET v_codedeckid_ = (SELECT CodeDeckId FROM tblVendorTrunk WHERE tblVendorTrunk.TrunkID = v_TrunkID_ AND tblVendorTrunk.AccountID = v_AccountID_ AND tblVendorTrunk.Status = 1);

		IF v_codedeckid_ IS NOT NULL AND (SELECT COUNT(*) FROM tblCodeDeck WHERE CodeDeckId = v_codedeckid_)>0
		THEN

			SET v_companyid_ = (SELECT CompanyId FROM tblCodeDeck WHERE CodeDeckId = v_codedeckid_);			

			-- code insert and update rate id in temp table
			CALL prc_updateRateID(v_AccountID_,v_codedeckid_,p_tbltemp_name,p_ProcessID);

			-- CALL prc_GetCustomerRate(v_companyid_,v_AccountID_,v_TrunkID_,null,null,null,'All',1,0,0,0,'','',-1);
			
			-- vendorrate insert,update and delete
			CALL prc_putVendorCodeRate(v_AccountID_,v_TrunkID_,p_tbltemp_name,p_ProcessID);

		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

	SET @stm = CONCAT('
	DELETE FROM `' , p_tbltemp_name , '` WHERE ProcessID="' , p_processId , '" ;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm; 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblDynamicFields` (
  `DynamicFieldsID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `Type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'account, product etc',
  `FieldDomType` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldSlug` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldDescription` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `Status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DynamicFieldsID`),
  KEY `IX_Type` (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `tblDynamicFields` (`DynamicFieldsID`, `CompanyID`, `Type`, `FieldDomType`, `FieldName`, `FieldSlug`, `FieldDescription`, `FieldOrder`, `Status`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
	(1, 1, 'account', 'multiselect', 'Gateway', 'accountgateway', 'Account Gateway', 0, 0, '2017-07-04 13:05:54', 'System', NULL, NULL),
	(2, 1, 'account', 'text', 'Vendor Name', 'vendorname', 'Vendor Name', 0, 0, '2017-07-04 13:05:54', 'System', NULL, NULL),
	(3, 1, 'product', 'text', 'Barcode', 'barcode', 'Product Barcode', 0, 0, '2017-07-05 18:04:45', 'System', NULL, NULL);

CREATE TABLE IF NOT EXISTS `tblDynamicFieldsDetail` (
  `DynamicFieldsDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `DynamicFieldsID` int(11) NOT NULL DEFAULT '0',
  `FieldType` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'gateway, item, account, users etc',
  `Options` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'json = numeric field , limit etc',
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DynamicFieldsDetailID`),
  KEY `IX_DynamicFieldsID` (`DynamicFieldsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `tblDynamicFieldsDetail` (`DynamicFieldsDetailID`, `CompanyID`, `DynamicFieldsID`, `FieldType`, `Options`, `FieldOrder`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
	(1, 1, 1, 'gateway', NULL, 0, NULL, NULL, NULL, NULL),
	(2, 1, 3, 'is_unique', '1', 0, NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tblDynamicFieldsValue` (
  `DynamicFieldsValueID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `ParentID` int(11) NOT NULL DEFAULT '0',
  `DynamicFieldsID` int(11) NOT NULL DEFAULT '0',
  `FieldValue` text COLLATE utf8_unicode_ci,
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DynamicFieldsValueID`),
  UNIQUE KEY `IXUnique_ParentID_DynamicFieldsID` (`ParentID`,`DynamicFieldsID`),
  KEY `IX_ParentID_DynamicFieldsID` (`DynamicFieldsID`,`ParentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP PROCEDURE IF EXISTS `prc_WSProcessImportAccount`;
DELIMITER |
CREATE PROCEDURE `prc_WSProcessImportAccount`(
	IN `p_processId` VARCHAR(200) ,
	IN `p_companyId` INT,
	IN `p_companygatewayid` INT,
	IN `p_tempaccountid` TEXT,
	IN `p_option` INT,
	IN `p_importdate` DATETIME
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

			INSERT INTO tmp_JobLog_ (Message)
			SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );

		

   END IF;

	DELETE  FROM tblTempAccount WHERE ProcessID = p_processId;
 	 SELECT * from tmp_JobLog_;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;








DROP PROCEDURE IF EXISTS `prc_CronJobAllPending`;
DELIMITER |
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


	-- product upload
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


   	SELECT end_time INTO v_last_time FROM tblAccountAuditExportLog WHERE CompanyID=p_CompanyID AND CompanyGatewayID=p_GatewayID AND Status=1 ORDER BY AccountAuditExportLogID DESC LIMIT 1;

   	IF (v_last_time IS NOT NULL AND v_last_time != '')
   	THEN
	   		-- SELECT end_time INTO v_last_time FROM tblAccountAuditExportLog WHERE CompanyID=p_CompanyID AND CompanyGatewayID=p_GatewayID AND Status=1 ORDER BY AccountAuditExportLogID DESC LIMIT 1;

	   		SELECT
	   			 MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
	   		FROM
	   			tblAuditHeader AS tah
	   		LEFT JOIN
	   			tblAuditDetails AS tad
	   		ON
	   			tah.AuditHeaderID=tad.AuditHeaderID
	   		WHERE
	   			tah.Type='account' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_last_time + INTERVAL 1 DAY) AND tad.created_at>v_last_time;

	   		INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, v_start_time, v_end_time, v_cur_time);

	   		SELECT
	   			tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
	   		FROM
	   			tblAuditHeader AS tah
	   		LEFT JOIN
	   			tblAuditDetails AS tad
	   		ON
	   			tah.AuditHeaderID=tad.AuditHeaderID
	   		WHERE
	   			tah.Type='account' AND tah.Date>=DATE(v_last_time) AND tah.Date<=DATE(v_last_time + INTERVAL 1 DAY) AND tad.created_at>v_last_time;

	ELSE
		SELECT
	   		MIN(tad.created_at), MAX(tad.created_at) INTO v_start_time, v_end_time
   		FROM
   			tblAuditHeader AS tah
   		LEFT JOIN
   			tblAuditDetails AS tad
   		ON
   			tah.AuditHeaderID=tad.AuditHeaderID
   		WHERE
   			tah.Type='account' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;

		INSERT INTO tblAccountAuditExportLog (CompanyID,CompanyGatewayID,start_time,end_time,created_at) VALUES (p_CompanyID, p_GatewayID, v_start_time, v_end_time, v_cur_time);
		
		SELECT
	   		tah.ParentColumnID,tah.ParentColumnName,tad.ColumnName,tad.OldValue,tad.NewValue,v_start_time AS start_time,v_end_time AS end_time,v_cur_time AS created_at
   		FROM
   			tblAuditHeader AS tah
   		LEFT JOIN
   			tblAuditDetails AS tad
   		ON
   			tah.AuditHeaderID=tad.AuditHeaderID
   		WHERE
   			tah.Type='account' AND tah.Date>=(v_cur_date - INTERVAL 1 DAY) AND tah.Date<=v_cur_date AND tad.created_at<=v_cur_time;
   	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


END|
DELIMITER ;

USE `RMBilling3`;
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
	AND i.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'paid','post')
	AND ( (i.ItemInvoice IS NULL) OR (i.ItemInvoice=1 AND i.RecurringInvoiceID IS NOT NULL))
	AND i.InvoiceType =1
	AND i.AccountID = p_AccountID
	AND (p_PaymentDueInDays =0  OR (p_PaymentDueInDays =1 AND TIMESTAMPDIFF(DAY, i.IssueDate, NOW()) >= IFNULL(b.PaymentDueInDays,0) ) )

	GROUP BY i.InvoiceID,
			 p.AccountID
	HAVING (IFNULL(MAX(i.GrandTotal), 0) - IFNULL(SUM(p.Amount), 0)) > 0;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_updateDefaultPrefix`;
DELIMITER |
CREATE PROCEDURE `prc_updateDefaultPrefix`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
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
		SET @rowCount = (SELECT   COUNT(*)   FROM RMCDR3.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND area_prefix = "Other" AND ProcessID = "' , p_processId , '"  );
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
CREATE PROCEDURE `prc_updateDefaultVendorPrefix`(
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
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
		SET @rowCount = (SELECT   COUNT(*)   FROM RMCDR3.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND area_prefix = "Other" AND ProcessID = "' , p_processId , '"  );
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
			AND REPLACE(cld,ud.TrunkPrefix,"") REGEXP "^[0-9]+$"
			AND cld like  CONCAT(ud.TrunkPrefix,c.Code,"%");
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	ELSE

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

DROP PROCEDURE IF EXISTS `prc_importFromTempPaymentImportExport`;
DELIMITER |
CREATE PROCEDURE `prc_importFromTempPaymentImportExport`(
	IN `p_ProcessID` VARCHAR(50),
	IN `p_CurrentDate` DATETIME
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE
		tmpp
	FROM tblTempPaymentImportExport tmpp
	INNER JOIN tblPayment p
	ON p.CompanyID = tmpp.CompanyID
	AND p.TransactionID = tmpp.TransactionID
	WHERE tmpp.ProcessID= p_ProcessID ;

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
			CreatedBy
		)
	SELECT
		a.CompanyID,
		a.AccountID,
		a.CurrencyId,
		tmpp.Amount,
		tmpp.PaymentDate,
		IF(tmpp.Amount >= 0 , 'Payment in', 'Payment out' ) AS PaymentType,
		tmpp.TransactionID,
		'Approved' AS `Status`,
		'Cash' AS PaymentMethod,
		Notes,
		p_CurrentDate AS created_at,
		'System Imported' AS CreatedBy
	FROM tblTempPaymentImportExport tmpp
	INNER JOIN Ratemanagement3.tblAccount a
	ON a.CompanyID = tmpp.CompanyID
	AND (tmpp.AccountNumber = a.Number OR tmpp.AccountNumber = a.AccountName) AND a.CurrencyId > 0
	WHERE tmpp.ProcessID= p_ProcessID ;

	SELECT AccountNumber AS `Account Number` ,Amount,PaymentDate AS `Payment Date` ,PaymentType AS `Payment Type`,TransactionID AS `Transaction ID`,`Action`
	FROM
	(

		SELECT
			tmpp.* ,
			'Imported' AS `Action`
		FROM tblTempPaymentImportExport tmpp
		INNER JOIN Ratemanagement3.tblAccount a
		ON a.CompanyID = tmpp.CompanyID
		AND (tmpp.AccountNumber = a.Number OR tmpp.AccountNumber = a.AccountName) AND a.CurrencyId IS NOT NULL
		WHERE tmpp.ProcessID= p_ProcessID

		UNION

		SELECT
			tmpp.* ,
			CONCAT('Skipped (',IF(a.AccountID,"Currency is not setup against Account" ,"Account doesn't exists in System" ),' )') as `Action`
		FROM tblTempPaymentImportExport tmpp
		LEFT JOIN Ratemanagement3.tblAccount a
		ON a.CompanyID = tmpp.CompanyID
		AND (tmpp.AccountNumber = a.Number OR tmpp.AccountNumber = a.AccountName)
		WHERE tmpp.ProcessID= p_ProcessID AND ( a.AccountID IS NULL OR a.CurrencyId IS NULL)

	) tmp;

	DELETE FROM tblTempPaymentImportExport WHERE ProcessID = p_ProcessID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblTempProduct` (
  `ProductID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `Amount` decimal(18,2) DEFAULT NULL,
  `Active` tinyint(3) unsigned DEFAULT '1',
  `Note` longtext COLLATE utf8_unicode_ci,
  `BarCode` longtext COLLATE utf8_unicode_ci,
  `Change` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ProductID`),
  KEY `IX_ProcessID` (`ProcessID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tblTempDynamicFieldsValue` (
  `DynamicFieldsValueID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ParentID` int(11) NOT NULL DEFAULT '0',
  `DynamicFieldsID` int(11) NOT NULL DEFAULT '0',
  `FieldValue` text COLLATE utf8_unicode_ci,
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DynamicFieldsValueID`),
  UNIQUE KEY `IXUnique_ParentID_DynamicFieldsID` (`ParentID`,`DynamicFieldsID`),
  KEY `IX_ParentID_DynamicFieldsID` (`DynamicFieldsID`,`ParentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP PROCEDURE IF EXISTS `prc_WSProcessItemUpload`;
DELIMITER |
CREATE PROCEDURE `prc_WSProcessItemUpload`(
	IN `p_processId` VARCHAR(50),
	IN `p_companyId` INT
	)
BEGIN
   	DECLARE v_AffectedRecords_ INT DEFAULT 0;
	DECLARE totalexistingcode INT(11) DEFAULT 0;
	DECLARE duplicate_c_records INT DEFAULT 0;
	DECLARE dynamic_columns_count INT DEFAULT 0;
	DECLARE dynamic_column_type VARCHAR(20) DEFAULT 'product';
	DECLARE duplicate_f_records INT DEFAULT 0;
	DECLARE current_datetime DATETIME DEFAULT NOW();
	DECLARE updated_records INT DEFAULT 0;
		
	SET sql_mode = '';	    
   	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   	SET SESSION sql_mode='';
    
	DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
   	CREATE TEMPORARY TABLE tmp_JobLog_  ( 
			Message longtext     
   	);
    
	-- starts delete duplicate Code record from temp table
	SELECT COUNT(*) INTO duplicate_c_records FROM (SELECT count(Code)
		FROM tblTempProduct 
		GROUP BY Code
		HAVING COUNT(*)>1) AS tbl;
		
	IF duplicate_c_records > 0
	THEN
		INSERT INTO tmp_JobLog_ (Message)
			  SELECT DISTINCT 
			  CONCAT( 'Duplicate Code in excel file - (',c_duplicate_count,' occurences) - ', Code)
			  		FROM(
						SELECT count(Code) AS c_duplicate_count, Code AS Code
						FROM tblTempProduct 
						GROUP BY Code
						HAVING COUNT(*)>1) AS tbl;
	END IF;
    
	DELETE n1,fv
		FROM tblTempProduct n1
		INNER JOIN (
			SELECT MIN(ProductID) as minid,Code FROM tblTempProduct WHERE ProcessID = p_processId
			GROUP BY Code
			HAVING COUNT(1)>1
		) n2 ON n2.Code = n1.Code AND minid <> n1.ProductID
		LEFT JOIN tblTempDynamicFieldsValue AS fv
		ON fv.ParentID = n1.ProductID
		WHERE n1.ProcessID = p_processId;
	-- ends delete duplicate Code record from temp table
	
	-- starts disable products which has delete action in csv or excel file
	UPDATE tblProduct p
	LEFT JOIN tblTempProduct tp ON tp.Code=p.Code
	SET p.Active=0, p.updated_at=current_datetime, p.ModifiedBy='system'
	WHERE tp.Code=p.Code AND tp.Change='D' AND tp.ProcessID=p_processId;

	-- log updated status records
	SELECT COUNT(*) INTO updated_records
		FROM tblProduct p
		LEFT JOIN tblTempProduct tp ON p.Code=tp.Code
		WHERE tp.Code=p.Code AND tp.Change='D' AND tp.ProcessID=p_processId;
		
	IF updated_records > 0
	THEN
		INSERT INTO tmp_JobLog_ (Message) VALUES(CONCAT(updated_records, ' Item(s) has been deleted!'));
	END IF;
	-- ends disable products which has delete action in csv or excel file

	-- starts delete all duplicate records from temp table if dynamic column is unique
	-- check if there is any dynamic columns for product table
	SELECT count(*) INTO dynamic_columns_count FROM Ratemanagement3.tblDynamicFields WHERE Type = dynamic_column_type AND Status = 1;

	IF dynamic_columns_count > 0
	THEN
		SELECT COUNT(*) INTO duplicate_f_records FROM (SELECT count(FieldValue)
			FROM 
				tblTempDynamicFieldsValue 
			WHERE
				DynamicFieldsID IN (
					SELECT
						f.DynamicFieldsID
					FROM 
						Ratemanagement3.tblDynamicFields AS f
					LEFT JOIN
						Ratemanagement3.tblDynamicFieldsDetail AS fd
					ON
						f.DynamicFieldsID = fd.DynamicFieldsID
					WHERE 
						f.Type = dynamic_column_type AND 
						f.Status = 1 AND
						fd.FieldType = 'is_unique' AND
						fd.Options = 1
				)
			GROUP BY FieldValue,DynamicFieldsID
			HAVING COUNT(*)>1) AS tbl;
			
		IF duplicate_f_records > 0
		THEN
			INSERT INTO tmp_JobLog_ (Message)
			  	SELECT DISTINCT 
				  	CONCAT( 'Duplicate ',FieldName,' in excel file - (',f_duplicate_count,' occurences) - ', FieldValue)
				  		FROM(
							SELECT 
								count(fv.FieldValue) AS f_duplicate_count, fv.FieldValue AS FieldValue, f.FieldName AS FieldName
							FROM 
								tblTempDynamicFieldsValue AS fv
							LEFT JOIN
								Ratemanagement3.tblDynamicFields AS f
							ON
								fv.DynamicFieldsID = f.DynamicFieldsID
							WHERE
								fv.DynamicFieldsID IN (
									SELECT
										f1.DynamicFieldsID
									FROM 
										Ratemanagement3.tblDynamicFields AS f1
									LEFT JOIN
										Ratemanagement3.tblDynamicFieldsDetail AS fd
									ON
										f1.DynamicFieldsID = fd.DynamicFieldsID
									WHERE 
										f1.Type = dynamic_column_type AND 
										f1.Status = 1 AND
										fd.FieldType = 'is_unique' AND
										fd.Options = 1
								)
							GROUP BY fv.FieldValue,fv.DynamicFieldsID
							HAVING COUNT(*)>1) AS tbl;
			-- if dynamic column is unique than delete all duplicate records from temp table
			DELETE fv1, p
				FROM tblTempDynamicFieldsValue fv1 
				INNER JOIN (
					SELECT MIN(DynamicFieldsValueID) AS minid, DynamicFieldsID, FieldValue FROM tblTempDynamicFieldsValue
					WHERE ProcessID = p_processId
			     	GROUP BY FieldValue,DynamicFieldsID
					HAVING COUNT(1) > 1
				) AS fv2
			   ON (fv2.FieldValue = fv1.FieldValue
			   AND fv1.DynamicFieldsID = fv2.DynamicFieldsID
			   AND fv2.minid <> fv1.DynamicFieldsValueID)
			   INNER JOIN
					tblTempProduct AS p
				ON
					fv1.ParentID = p.ProductID
				LEFT JOIN
					Ratemanagement3.tblDynamicFields AS f
				ON
					fv1.DynamicFieldsID = f.DynamicFieldsID
				WHERE
					fv1.DynamicFieldsID IN (
						SELECT
							f1.DynamicFieldsID
						FROM 
							Ratemanagement3.tblDynamicFields AS f1
						LEFT JOIN
							Ratemanagement3.tblDynamicFieldsDetail AS fd
						ON
							f1.DynamicFieldsID = fd.DynamicFieldsID
						WHERE 
							f1.Type = dynamic_column_type AND 
							f1.Status = 1 AND
							fd.FieldType = 'is_unique' AND
							fd.Options = 1
					)
				AND
					fv1.ProcessID = p_processId;

		END IF;
	END IF;
	-- ends delete all duplicate records from temp table if dynamic column is unique

	-- starts check unique dynamic column and delete it if exist in tblDynamicFieldsValue
	-- check unique dynamic column (if exist in tblDynamicFieldsValue)
	SELECT 
		count(fv1.FieldValue) INTO duplicate_f_records
	FROM 
		tblTempDynamicFieldsValue fv1
	LEFT JOIN
		Ratemanagement3.tblDynamicFieldsValue fv2 
	ON 
		fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
		fv1.FieldValue = fv2.FieldValue
	WHERE
		fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
		fv1.FieldValue = fv2.FieldValue AND
		fv1.DynamicFieldsID IN (
								SELECT
									f1.DynamicFieldsID
								FROM 
									Ratemanagement3.tblDynamicFields AS f1
								LEFT JOIN
									Ratemanagement3.tblDynamicFieldsDetail AS fd
								ON
									f1.DynamicFieldsID = fd.DynamicFieldsID
								WHERE 
									f1.Type = dynamic_column_type AND 
									f1.Status = 1 AND
									fd.FieldType = 'is_unique' AND
									fd.Options = 1
							);

	IF duplicate_f_records > 0
	THEN
		INSERT INTO tmp_JobLog_ (Message)
			  SELECT DISTINCT 
			  CONCAT( 'Existing ',FieldName,' - ', FieldValue)
			  		FROM(
						SELECT 
							fv1.FieldValue AS FieldValue, f.FieldName AS FieldName
						FROM 
							tblTempDynamicFieldsValue fv1
						LEFT JOIN
							Ratemanagement3.tblDynamicFieldsValue fv2
						ON 
							fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
							fv1.FieldValue = fv2.FieldValue
						LEFT JOIN
							Ratemanagement3.tblDynamicFields AS f
						ON
							fv1.DynamicFieldsID = f.DynamicFieldsID
						WHERE
							fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
							fv1.FieldValue = fv2.FieldValue AND
							fv1.DynamicFieldsID IN (
													SELECT
														f1.DynamicFieldsID
													FROM 
														Ratemanagement3.tblDynamicFields AS f1
													LEFT JOIN
														Ratemanagement3.tblDynamicFieldsDetail AS fd
													ON
														f1.DynamicFieldsID = fd.DynamicFieldsID
													WHERE 
														f1.Type = dynamic_column_type AND 
														f1.Status = 1 AND
														fd.FieldType = 'is_unique' AND
														fd.Options = 1
												)
						) AS tbl;
	END IF;

	-- delete duplicate data from temp table which is already exist in main table (dynamic column which is unique)
	DELETE
		fv1, p
	FROM
		tblTempDynamicFieldsValue fv1
	LEFT JOIN
		Ratemanagement3.tblDynamicFieldsValue fv2
	ON 
		fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
		fv1.FieldValue = fv2.FieldValue
	LEFT JOIN
		Ratemanagement3.tblDynamicFields AS f
	ON
		fv1.DynamicFieldsID = f.DynamicFieldsID
	INNER JOIN
		tblTempProduct AS p
	WHERE
		fv1.ParentID = p.ProductID AND
		fv1.DynamicFieldsID = fv2.DynamicFieldsID AND
		fv1.FieldValue = fv2.FieldValue AND
		fv1.DynamicFieldsID IN (
								SELECT
									f1.DynamicFieldsID
								FROM 
									Ratemanagement3.tblDynamicFields AS f1
								LEFT JOIN
									Ratemanagement3.tblDynamicFieldsDetail AS fd
								ON
									f1.DynamicFieldsID = fd.DynamicFieldsID
								WHERE 
									f1.Type = 'product' AND 
									f1.Status = 1 AND
									fd.FieldType = 'is_unique' AND
									fd.Options = 1
							);
	-- ends check unique dynamic column and delete it if exist in tblDynamicFieldsValue

	-- start product update if already exist
	UPDATE 
		tblProduct p
	LEFT JOIN
		tblTempProduct tp ON tp.Code = p.Code
	SET 
		p.Name=tp.Name,p.Description=tp.Description,p.Amount=tp.Amount,p.Active=tp.Active,p.Note=tp.Note,p.ModifiedBy='system',p.updated_at=current_datetime
	WHERE 
		tp.Code = p.Code AND  tp.Change!='D' AND tp.ProcessID = p_processId;
	-- ends product update if already exist

	-- starts count and log updated records
	SELECT 
		count(ttp1.Code) INTO totalexistingcode
	FROM 
		tblTempProduct ttp1
	LEFT JOIN
		tblProduct ttp2 ON ttp1.Code = ttp2.Code
	WHERE
		ttp1.Code = ttp2.Code;

	IF totalexistingcode > 0
	THEN
		INSERT INTO tmp_JobLog_ (Message)
			  SELECT DISTINCT 
			  CONCAT(record_to_update, ' Records updated!')
			  		FROM(
						SELECT 
							count(ttp3.Code) AS record_to_update
						FROM 
							tblTempProduct ttp3
						LEFT JOIN
							tblProduct ttp4 ON ttp3.Code = ttp4.Code
						WHERE
							ttp3.Code = ttp4.Code) AS tbl;
	END IF;
	-- ends count and log updated records

	-- start insert dynamic columns if not exist of item to be updated
	INSERT INTO
		Ratemanagement3.tblDynamicFieldsValue (`CompanyId`,`ParentID`,`DynamicFieldsID`,`FieldValue`,`created_at`,`created_by`)
	SELECT
		ttdfv.CompanyId,ttp4.ProductID,ttdfv.DynamicFieldsID,ttdfv.FieldValue,ttdfv.created_at,ttdfv.created_by
	FROM
		tblTempDynamicFieldsValue ttdfv
	LEFT JOIN
		tblTempProduct ttp3 ON ttp3.ProductID = ttdfv.ParentID
	LEFT JOIN
		tblProduct ttp4 ON ttp3.Code = ttp4.Code
	WHERE
		NOT EXISTS (
		    SELECT * FROM Ratemanagement3.tblDynamicFieldsValue WHERE ParentID = ttp4.ProductID
		) AND
		ttp3.ProductID = ttdfv.ParentID AND
		ttp3.ProcessID = ttdfv.ProcessID AND
		ttp3.Code = ttp4.Code AND
		ttdfv.ProcessID = p_processId;
	-- ends insert dynamic columns if not exist of item to be updated

	-- start update dynamic columns if exist of item to be updated
	DROP TEMPORARY TABLE IF EXISTS tmp_DynamicFieldsValue_;
	CREATE TEMPORARY TABLE tmp_DynamicFieldsValue_  ( 
		ProductID INT,
		DynamicFieldsID INT,
		FieldValue LONGTEXT,
		ProcessID  LONGTEXT
	);

	INSERT INTO tmp_DynamicFieldsValue_ (ProductID,DynamicFieldsID,FieldValue,ProcessID)
	SELECT
		ttp4.ProductID,ttdfv.DynamicFieldsID,ttdfv.FieldValue,ttdfv.ProcessID
	FROM
		tblTempDynamicFieldsValue ttdfv
	LEFT JOIN
		tblTempProduct ttp3 ON ttp3.ProductID=ttdfv.ParentID
	LEFT JOIN
		tblProduct ttp4 ON ttp3.Code=ttp4.Code
	WHERE
		EXISTS (
		    SELECT * FROM Ratemanagement3.tblDynamicFieldsValue WHERE ParentID=ttp4.ProductID AND DynamicFieldsID=ttdfv.DynamicFieldsID
		) AND
		ttp3.ProductID=ttdfv.ParentID AND
		ttp3.ProcessID=ttdfv.ProcessID AND
		ttp3.Code=ttp4.Code AND
		ttdfv.ProcessID=p_processId;

	UPDATE
		Ratemanagement3.tblDynamicFieldsValue fv
	LEFT JOIN
		tmp_DynamicFieldsValue_ tfv
	ON 
		tfv.ProductID=fv.ParentID AND tfv.DynamicFieldsID=fv.DynamicFieldsID
	SET
		fv.FieldValue=tfv.FieldValue,fv.updated_at=current_datetime,fv.updated_by='system'
	WHERE
		tfv.ProductID=fv.ParentID AND tfv.DynamicFieldsID=fv.DynamicFieldsID AND tfv.ProcessID=p_processId;
	-- ends update dynamic columns if exist of item to be updated


	-- starts dynamic column insert of products to be inserted
	INSERT INTO
		Ratemanagement3.tblDynamicFieldsValue (`CompanyId`,`ParentID`,`DynamicFieldsID`,`FieldValue`,`created_at`,`created_by`)
	SELECT
		ttdfv.CompanyId,ttdfv.ParentID,ttdfv.DynamicFieldsID,ttdfv.FieldValue,ttdfv.created_at,ttdfv.created_by
	FROM
		tblTempDynamicFieldsValue ttdfv
	LEFT JOIN
		tblTempProduct ttp3 ON ttp3.ProductID = ttdfv.ParentID
	LEFT JOIN
		tblProduct ttp4 ON ttp3.Code = ttp4.Code
	WHERE
		ttp3.ProductID = ttdfv.ParentID AND
		ttp3.ProcessID = ttdfv.ProcessID AND
		ttp4.Code IS NULL AND
		ttdfv.ProcessID = p_processId;
	-- ends dynamic column insert of products to be inserted

	-- start product insert
	INSERT INTO 
		tblProduct (`CompanyId`,`Name`,`Code`,`Description`,`Amount`,`Active`,`Note`,`created_at`,`CreatedBy`,`ModifiedBy`,`updated_at`)
	SELECT 
		tp3.CompanyId,tp3.Name,tp3.Code,tp3.Description,tp3.Amount,tp3.Active,tp3.Note,tp3.created_at,tp3.Created_By,tp3.Created_By,tp3.created_at
	FROM 
		tblTempProduct tp3
	LEFT JOIN 
		tblProduct tp2 ON tp3.Code = tp2.Code
	WHERE 
		tp2.Code IS NULL AND ProcessID = p_processId;
	-- ends product insert

	SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	INSERT INTO tmp_JobLog_ (Message)
	SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded!' );	
	
	-- starts dynamic column update ParentID of inserted products
	UPDATE 
		Ratemanagement3.tblDynamicFieldsValue tdfv
	LEFT JOIN
		tblTempProduct ttp ON tdfv.ParentID = ttp.ProductID
	LEFT JOIN
		tblProduct tp ON tp.Code = ttp.Code
	SET 
		ParentID = tp.ProductID
	WHERE
		tp.Name = ttp.Name AND 
		tp.Code = ttp.Code AND 
		tp.CompanyId = ttp.CompanyId AND 
		tp.Description = ttp.Description AND 
		tp.Amount = ttp.Amount AND
		tp.Note = ttp.Note AND
		tp.created_at = ttp.created_at AND
		tp.CreatedBy = ttp.created_by AND
		ttp.ProcessID = p_processId AND
		tdfv.ParentID = ttp.ProductID;
	-- ends dynamic column update ParentID of inserted products


		DELETE  FROM tblTempProduct WHERE ProcessID = p_processId;
		DELETE  FROM tblTempDynamicFieldsValue WHERE ProcessID = p_processId;
		
		SELECT * from tmp_JobLog_; 					
	      
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;




DROP PROCEDURE IF EXISTS `prc_getProductByBarCode`;
DELIMITER |
CREATE PROCEDURE `prc_getProductByBarCode`(
	IN `p_fieldvalue` LONGTEXT,
	IN `p_dynamicfieldsid` INT
)
BEGIN
	
	SELECT 
		`P`.`ProductID`, `P`.`Name`, `P`.`Description`, `P`.`Amount` 
		FROM 
			`tblProduct` AS `P` 
		LEFT JOIN 
			`Ratemanagement3`.`tblDynamicFieldsValue` AS `B` 
		ON 
			`P`.`ProductID` = `B`.`ParentID` 
		WHERE 
			`B`.`FieldValue` = p_fieldvalue AND 
			`B`.`DynamicFieldsID` = p_dynamicfieldsid;
	
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getProducts`;
DELIMITER |
CREATE PROCEDURE `prc_getProducts`(
	IN `p_CompanyID` INT,
	IN `p_Name` VARCHAR(50),
	IN `p_Code` VARCHAR(50),
	IN `p_Active` VARCHAR(1),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblProduct.ProductID,
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Amount,
			tblProduct.updated_at,
			tblProduct.Active,
			tblProduct.Description,
			tblProduct.Note
            from tblProduct
            where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active))
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
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN tblProduct.updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN tblProduct.updated_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveDESC') THEN Active
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveASC') THEN Active
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblProduct.ProductID) AS totalcount
            from tblProduct
            where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active));

	ELSE

			SELECT
			tblProduct.ProductID,
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Amount,
			tblProduct.updated_at,
			tblProduct.Active,
			tblProduct.Description,
			tblProduct.Note
            from tblProduct
			where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END|
DELIMITER ;

USE `Ratemanagement3`;

ALTER TABLE `tblAccountBilling`
	ADD COLUMN `AutoPaymentSetting` VARCHAR(50) NULL DEFAULT NULL;

ALTER TABLE `tblAccountService`
	ADD COLUMN `ServiceDescription` TEXT NULL DEFAULT NULL;

INSERT INTO `tblIntegration` (`IntegrationID`, `CompanyId`, `Title`, `Slug`, `ParentID`, `MultiOption`) VALUES (20, 1, 'Stripe ACH', 'stripeach', 4, 'N');
	
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`, `TicketTemplate`) VALUES ( 1, 'Auto Invoice Paid', '{{InvoiceNumber}} Invoice Paid', '<p>Hi</p><p>We hereby confirm that we have received payment..</p><h4>Payment Detail</h4><p>Account Name : {{AccountName}}</p><p>Paid Amount : {{PaidAmount}}</p><p>Status : {{PaidStatus}}</p><p>Payment Method : {{PaymentMethod}}</p><p>Payment Notes : {{PaymentNotes}}</p><p><br></p><h4>Best Regards</h4><p>{{CompanyName}}<br></p><p><br></p>', '2017-07-28 11:12:25', NULL, '2017-07-28 16:02:36', 'System', NULL, 10, '', 1, 'AutoInvoicePayment', 0, 0, 0);


INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ( 1, 'CALLSHOP_CRONJOB', '{"MaxInterval":"1440","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"error@neon-soft.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_DOWNLOAD_CDR_CRONJOB', '{"MaxInterval":"1440","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_CUSTOMER_RATE_FILE_GEN_CRONJOB', '{"customers":[],"CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_VENDOR_RATE_FILE_GEN_CRONJOB', '{"vendors":[],"CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_RATE_FILE_DOWNLOAD_CRONJOB', '{"gateway":"","vendors":"","FilesDownloadLimit":"","FileLocationFrom":"","FileLocationTo":"","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_RATE_FILE_PROCESS_CRONJOB', '{"gateway":"","FilesMaxProcess":"","FilesDownloadLimit":"","FileLocation":"","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'STREAMCO_ACCOUNT_IMPORT', '{"ThresholdTime":"60","SuccessEmail":"","ErrorEmail":"","JobTime":"MINUTE","JobInterval":"10","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":"25"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_RATE_FILE_IMPORT_CRONJOB', '{"customers":[],"ScriptLocation":"","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VENDOR_RATE_FILE_IMPORT_CRONJOB', '{"vendors":[],"ScriptLocation":"","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');

INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (9, 'Locutorios', 'CallShop', 1, 'RateManagementSystem', '2017-07-14 00:00:00', NULL, NULL);
INSERT INTO `tblGateway` (`GatewayID`, `Title`, `Name`, `Status`, `CreatedBy`, `created_at`, `ModifiedBy`, `updated_at`) VALUES (10, 'Streamco', 'Streamco', 1, 'RateManagementSystem', '2017-07-22 11:09:43', NULL, NULL);

INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (88, 9, 'Locutorios Server', 'dbserver', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (89, 9, 'Locutorios Username', 'username', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (90, 9, 'Locutorios Password', 'password', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (91, 9, 'Authentication Rule', 'NameFormat', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (92, 9, 'CDR ReRate', 'RateCDR', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (93, 9, 'Rate Format', 'RateFormat', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (94, 9, 'CLI Translation Rule', 'CLITranslationRule', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (95, 9, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (96, 9, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (97, 9, 'Allow Account Import', 'AllowAccountImport', 1, '2017-07-14 00:00:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (100, 10, 'Host', 'host', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (101, 10, 'Database Username', 'dbusername', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (102, 10, 'Database Password', 'dbpassword', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (103, 10, 'SSH Host', 'sshhost', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (104, 10, 'SSH Username', 'sshusername', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (105, 10, 'SSH Password', 'sshpassword', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (106, 10, 'Authentication Rule', 'NameFormat', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (107, 10, 'Rate Format', 'RateFormat', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (108, 10, 'CDR ReRate', 'RateCDR', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (109, 10, 'CLI Translation Rule', 'CLITranslationRule', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (110, 10, 'CLD Translation Rule', 'CLDTranslationRule', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (111, 10, 'Prefix Translation Rule', 'PrefixTranslationRule', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);
INSERT INTO `tblGatewayConfig` (`GatewayConfigID`, `GatewayID`, `Title`, `Name`, `Status`, `Created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`) VALUES (112, 10, 'Allow Account Import', 'AllowAccountImport', 1, '2017-07-22 07:15:00', 'RateManagementSystem', NULL, NULL);

INSERT INTO `tblCronJobCommand` ( `CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES ( 1, 9, 'Download Locutorios CDR', 'callshopaccountusage', '[[{"title":"Locutorios Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-07-14 00:00:00', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Vendor Rate File Process', 'vendorratefileprocess', '[[{"title":"Files Max Process","type":"text","value":"","name":"FilesMaxProcess"},{"title":"File Location (Path)","type":"text","value":"","name":"FileLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Customer Rate File Process', 'customerratefileprocess', '[[{"title":"Files Max Process","type":"text","value":"","name":"FilesMaxProcess"},{"title":"File Location (Path)","type":"text","value":"","name":"FileLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Vendor Rate File Download', 'vendorratefiledownload', '[[{"title":"Max File Download Limit","type":"text","value":"","name":"FilesDownloadLimit"},{"title":"File Download From Location (Path)","type":"text","value":"","name":"FileLocationFrom"},{"title":"File Download To Location (Path)","type":"text","value":"","name":"FileLocationTo"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Customer Rate File Download', 'customerratefiledownload', '[[{"title":"Max File Download Limit","type":"text","value":"","name":"FilesDownloadLimit"},{"title":"File Download From Location (Path)","type":"text","value":"","name":"FileLocationFrom"},{"title":"File Download To Location (Path)","type":"text","value":"","name":"FileLocationTo"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Vendor Rate File Export', 'vendorratefileexport', '[[{"title":"File Generation Location (Path)","type":"text","value":"","name":"FileLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Customer Rate File Export', 'customerratefileexport', '[[{"title":"File Generation Location (Path)","type":"text","value":"","name":"FileLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2015-04-21 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Download Streamco CDR', 'streamcoaccountusage', '[[{"title":"STREMCO Max Interval","type":"text","value":"","name":"MaxInterval"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-07-22 08:22:13', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Streamco Account Import', 'streamcoaccountimport', '[[{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-07-27 15:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Customer Rate File Generation', 'customerratefilegeneration', '[[{"title":"Script Location (Path)","type":"text","value":"","name":"ScriptLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-07-29 14:11:06', 'RateManagementSystem');
INSERT INTO `tblCronJobCommand` (`CompanyID`, `GatewayID`, `Title`, `Command`, `Settings`, `Status`, `created_at`, `created_by`) VALUES (1, 10, 'Vendor Rate File Generation', 'vendorratefilegeneration', '[[{"title":"Script Location (Path)","type":"text","value":"","name":"ScriptLocation"},{"title":"Threshold Time (Minute)","type":"text","value":"","name":"ThresholdTime"},{"title":"Success Email","type":"text","value":"","name":"SuccessEmail"},{"title":"Error Email","type":"text","value":"","name":"ErrorEmail"}]]', 1, '2017-07-29 14:11:06', 'RateManagementSystem');

INSERT INTO `tblJobType` (`Code`, `Title`, `Description`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`) VALUES ('IU', 'Item Upload', NULL, '2017-07-04 12:25:46', 'System', NULL, NULL);

INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.upload', 'ProductsController.upload', 1, 'System', NULL, '2017-07-18 16:45:52.000', '2017-07-18 16:45:52.000', 53);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.check_upload', 'ProductsController.check_upload', 1, 'System', NULL, '2017-07-18 16:45:52.000', '2017-07-18 16:45:52.000', 53);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.ajaxfilegrid', 'ProductsController.ajaxfilegrid', 1, 'System', NULL, '2017-07-18 16:45:53.000', '2017-07-18 16:45:53.000', 53);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.storeTemplate', 'ProductsController.storeTemplate', 1, 'System', NULL, '2017-07-18 16:45:53.000', '2017-07-18 16:45:53.000', 53);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.getProductByBarCode', 'ProductsController.getProductByBarCode', 1, 'System', NULL, '2017-07-18 16:45:53.000', '2017-07-18 16:45:53.000', 36);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.getProductByBarCode', 'ProductsController.getProductByBarCode', 1, 'System', NULL, '2017-07-18 16:45:53.000', '2017-07-18 16:45:53.000', 41);
INSERT INTO `tblResource` (`ResourceName`, `ResourceValue`, `CompanyID`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `CategoryID`) VALUES ('Products.download_sample_excel_file', 'ProductsController.download_sample_excel_file', 1, 'System', NULL, '2017-07-18 16:45:54.000', '2017-07-18 16:45:54.000', 53)