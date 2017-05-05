--- Version Neon 4.10
-- Abubakar

USE `Ratemanagement3`;

/*
ALTER TABLE `tblNote`
	ADD COLUMN `UserID` INT(11) NOT NULL AFTER `AccountID`;
*/

UPDATE `tblResourceCategories` SET `ResourceCategoryName` = 'RecurringInvoice.Add' WHERE `ResourceCategoryName`= 'RecurringProfile.Add';
UPDATE `tblResourceCategories` SET `ResourceCategoryName` = 'RecurringInvoice.Edit' WHERE `ResourceCategoryName`= 'RecurringProfile.Edit';
UPDATE `tblResourceCategories` SET `ResourceCategoryName` = 'RecurringInvoice.Delete' WHERE `ResourceCategoryName`= 'RecurringProfile.Delete';
UPDATE `tblResourceCategories` SET `ResourceCategoryName` = 'RecurringInvoice.View' WHERE `ResourceCategoryName`= 'RecurringProfile.View';
UPDATE `tblResourceCategories` SET `ResourceCategoryName` = 'RecurringInvoice.All' WHERE `ResourceCategoryName`= 'RecurringProfile.All';

DROP PROCEDURE IF EXISTS `prc_GetCronJobHistory`;
DELIMITER ;;
CREATE PROCEDURE `prc_GetCronJobHistory`(
	IN `p_CronJobID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_SearchText` VARCHAR(50),
	IN `p_Status` VARCHAR(50),
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
                tblCronJobCommand.Title,
                tblCronJobLog.CronJobStatus,
                tblCronJobLog.Message,
                tblCronJobLog.created_at
            FROM tblCronJob
            INNER JOIN tblCronJobLog
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN tblCronJobCommand.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN tblCronJobCommand.Title
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CronJobStatusDESC') THEN tblCronJobLog.CronJobStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CronJobStatusASC') THEN tblCronJobLog.CronJobStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageDESC') THEN tblCronJobLog.Message
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageASC') THEN tblCronJobLog.Message
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblCronJobLog.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblCronJobLog.created_at
                END ASC
           LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(tblCronJobLog.CronJobID) as totalcount
        FROM tblCronJob
            INNER JOIN tblCronJobLog
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID;
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
            tblCronJobCommand.Title,
            tblCronJobLog.CronJobStatus,
            tblCronJobLog.Message,
            tblCronJobLog.created_at
        FROM tblCronJob
        INNER JOIN tblCronJobLog
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
        INNER JOIN tblCronjobCommand
            ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID;
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;

-- Dev
USE `Ratemanagement3`;

UPDATE `tblGateway` SET Title = 'PBX' WHERE Title = 'Mirta';

-- Girish

USE `Ratemanagement3`;

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateSheet`;
DELIMITER ;;
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
        `level`         VARCHAR(10),
        `change`        VARCHAR(50),
        EffectiveDate  DATE,
			  INDEX tmp_RateSheetRate_RateID (`RateID`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        RateID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
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
      SELECT  RateID,
              Interval1,
              IntervalN,
              tblCustomerRate.Rate,
              effectivedate,
              lastmodifieddate
      FROM   tblAccount
         JOIN tblCustomerRate
           ON tblAccount.AccountID = tblCustomerRate.CustomerID
      WHERE  tblAccount.AccountID = p_CustomerID
          AND tblCustomerRate.Rate > 0
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
         AND tblRateTableRate.Rate > 0
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
                     effectivedate
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
             tbl.EffectiveDate
      FROM   (
			SELECT
				rt.RateID,				
				rt.Interval1,
				rt.IntervalN,
				rt.Rate,
				rt.EffectiveDate
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
            trc2.EffectiveDate
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
             tbl.EffectiveDate
      FROM   (SELECT rt.RateID,
                     description,
                     tblRate.Code,
                     rt.Interval1,
                     rt.IntervalN,
                     rt.Rate,
                     rsd5.Rate AS rate2,
                     rt.EffectiveDate,
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
             tblRateSheetDetails.EffectiveDate
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
                 rsr.EffectiveDate AS `effective date`
            FROM   tmp_RateSheetRate_ rsr
            WHERE rsr.Rate > 0
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
                           rsr.EffectiveDate AS `effective date`
            FROM   tmp_RateSheetRate_ rsr
            WHERE rsr.Rate > 0
          	ORDER BY rsr.Destination,rsr.Codes DESC;
        END IF; 
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;

-- Umer

USE `Ratemanagement3`;
-- ###NEON-812#####
DROP PROCEDURE IF EXISTS `prc_GetAccounts`;
DELIMITER ;;
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
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
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
			COUNT(tblAccount.AccountID) AS totalcount
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
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
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;

USE `Ratemanagement3`;

-- #NEON-819##############################################################
DROP PROCEDURE IF EXISTS `prc_GetFromEmailAddress`;
DELIMITER ;;
CREATE PROCEDURE `prc_GetFromEmailAddress`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_Ticket` INT,
	IN `p_Admin` INT
)
BEGIN
	DECLARE V_Ticket_Permission int;
	DECLARE V_Ticket_Permission_level int;
	DECLARE V_User_Groups varchar(100);
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;	
	SELECT 0 INTO V_Ticket_Permission;
	SELECT 0 into V_Ticket_Permission_level;			
	IF p_Ticket = 1
	THEN	
		IF p_Admin > 0
		THEN
			SELECT 1 INTO V_Ticket_Permission;
		END IF;
		
		IF p_Admin < 1 
		THEN		
			SELECT 
				count(*) into V_Ticket_Permission
			FROM 
				tblUser u
			inner join 
				tblUserPermission up on u.UserID = up.UserID
			inner join 
				tblResourceCategories tc on up.resourceID = tc.ResourceCategoryID
			WHERE 
				tc.ResourceCategoryName = 'Tickets.View.GlobalAccess'  and u.UserID = p_userID;
		END IF;
		
		IF V_Ticket_Permission > 0 
		THEN
			SELECT 1 into V_Ticket_Permission_level;			
			IF p_Admin > 0
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
		END IF;
		
		IF V_Ticket_Permission_level = 0
			THEN
				SELECT 0 into V_Ticket_Permission;
				SELECT 
				/*distinct u.userid, up.AddRemove,tc.ResourceCategoryName as permname*/
				count(*) into V_Ticket_Permission
			FROM 
				tblUser u
			inner join 
				tblUserPermission up on u.UserID = up.UserID
			inner join 
				tblResourceCategories tc on up.resourceID = tc.ResourceCategoryID
			WHERE 
				tc.ResourceCategoryName = 'Tickets.View.GroupAccess'  and u.UserID = p_userID;
		END IF;

		IF V_Ticket_Permission > 0 and V_Ticket_Permission_level = 0 
		THEN
			SELECT 2 into V_Ticket_Permission_level;
			
			SELECT GROUP_CONCAT(GroupID SEPARATOR ',') into V_User_Groups FROM tblTicketGroupAgents TGA where TGA.UserID = p_userID;
			
			IF p_Admin > 0
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL AND FIND_IN_SET(GroupID,V_User_Groups)
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL AND FIND_IN_SET(GroupID,V_User_Groups)
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
			
		END IF;

		IF V_Ticket_Permission_level = 0 
		THEN
			SELECT 0 into V_Ticket_Permission;
			SELECT 3 into V_Ticket_Permission_level;
			IF p_Admin > 0
			THEN
				SELECT DISTINCT TG.GroupEmailAddress as EmailFrom FROM tblTicketGroups TG INNER JOIN tblTickets TT ON TT.Group = TG.GroupID where TG.CompanyID = p_CompanyID and GroupEmailStatus = 1 and TG.GroupEmailAddress IS NOT NULL AND TT.Agent = p_userID					
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT TG.GroupEmailAddress as EmailFrom FROM tblTicketGroups TG INNER JOIN tblTickets TT ON TT.Group = TG.GroupID where TG.CompanyID = p_CompanyID and GroupEmailStatus = 1 and TG.GroupEmailAddress IS NOT NULL AND TT.Agent = p_userID
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
			
		END IF;		
	END IF;
	
	IF p_Ticket = 0
	THEN
		IF p_Admin > 0
		THEN
			SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
				UNION ALL
			SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
		END IF;
		IF p_Admin < 1	
		THEN
			SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
				UNION ALL
			SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
		END IF;
	END IF;
	/*SELECT V_Ticket_Permission_level;*/
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
-- ###############################################################

-- Billing
-- Abubakar

USE `RMBilling3`;

ALTER TABLE `tblBillingSubscription`
	ADD COLUMN `AnnuallyFee` DECIMAL(18,2) NULL DEFAULT NULL AFTER `CurrencyID`,
	ADD COLUMN `QuarterlyFee` DECIMAL(18,2) NULL DEFAULT NULL AFTER `AnnuallyFee`;

ALTER TABLE `tblAccountSubscription`
  ADD COLUMN `AnnuallyFee` DECIMAL(18,2) NULL DEFAULT NULL AFTER `ActivationFee`,
	ADD COLUMN `QuarterlyFee` DECIMAL(18,2) NULL DEFAULT NULL AFTER `AnnuallyFee`;

DROP PROCEDURE IF EXISTS `prc_getBillingSubscription`;
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
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.MonthlyFee) AS MonthlyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.WeeklyFee) AS WeeklyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.DailyFee) AS DailyFeeWithSymbol,
			tblBillingSubscription.Advance,
			tblBillingSubscription.SubscriptionID,
			tblBillingSubscription.ActivationFee,
			tblBillingSubscription.CurrencyID,
			tblBillingSubscription.InvoiceLineDescription,
			tblBillingSubscription.Description,			
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
END ;;
DELIMITER ;


-- Girish

USE `RMBilling3`;

DROP PROCEDURE IF EXISTS `prc_ProcesssCDR`;
DELIMITER ;;
CREATE PROCEDURE `prc_ProcesssCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_CDRUpload_ INT;
	DECLARE v_NewAccountIDCount_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL	
	);

	
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID
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

	
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,'0','1',p_NameFormat);

	
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
	FROM RMCDR3.tblUsageHeader uh
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

		
		UPDATE RMCDR3.tblUsageHeader uh
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

	
	IF p_RateFormat = 2
	THEN

		
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

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

	END IF;

	
	IF p_RateCDR = 1
	THEN

		SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	
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

		
		CALL Ratemanagement3.prc_getCustomerCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR,p_RateMethod,p_SpecifyRate);

		
		
		IF p_RateFormat = 2
		THEN
			CALL prc_updatePrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		
		IF p_RateCDR = 1
		THEN
			CALL prc_updateOutboundRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	
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

	
	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate);

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
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
		
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
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
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END ;;
DELIMITER ;

DROP FUNCTION IF EXISTS `FnGetInvoiceNumber`;
DELIMITER ;;
CREATE FUNCTION `FnGetInvoiceNumber`(
	`p_account_id` INT,
	`p_BillingClassID` INT
) RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Return Next Invoice Number'
BEGIN
DECLARE v_LastInv VARCHAR(50);
DECLARE v_FoundVal INT(11);
DECLARE v_InvoiceTemplateID INT(11);

SET v_InvoiceTemplateID = CASE WHEN p_BillingClassID=0 THEN (SELECT b.InvoiceTemplateID FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID = ab.BillingClassID WHERE AccountID = p_account_id) ELSE (SELECT b.InvoiceTemplateID FROM  Ratemanagement3.tblBillingClass b WHERE b.BillingClassID = p_BillingClassID) END;

SELECT LastInvoiceNumber INTO v_LastInv FROM tblInvoiceTemplate WHERE InvoiceTemplateID =v_InvoiceTemplateID;

set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
IF v_FoundVal>=1 then
WHILE v_FoundVal>0 DO
	set v_LastInv = v_LastInv+1;
	set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
END WHILE;
END IF;

return v_LastInv;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getInvoiceUsage`;
CREATE PROCEDURE `prc_getInvoiceUsage`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
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

	CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,0,1,v_BillingTime_,'','','',0); 

	SELECT b.CDRType  INTO v_CDRType_ FROM Ratemanagement3.tblAccountBilling ab INNER JOIN  Ratemanagement3.tblBillingClass b  ON b.BillingClassID = ab.BillingClassID WHERE ab.AccountID = p_AccountID;


            
        
            
    IF( v_CDRType_ = 2) 
    Then

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
            SUM(cost) AS TotalCharges,
            SUM(duration ) as DurationInSec,
            SUM(billed_duration ) as BillDurationInSec

        FROM tmp_tblUsageDetails_ ud
        GROUP BY ud.area_prefix,ud.Trunk,ud.AccountID;

         
    ELSE
        
        
            select
            trunk,
            area_prefix,
            concat("'",cli) as cli,
            concat("'",cld) as cld,
            connect_time,
            disconnect_time,
            billed_duration,
            cost
            FROM tmp_tblUsageDetails_ ud
            WHERE
             ((p_ShowZeroCall =0 and ud.cost >0 )or (p_ShowZeroCall =1 and ud.cost >= 0));
            
    END IF;    
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_ProcesssVCDR`;
DELIMITER ;;
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
	
	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL	
	);
	
	
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
	
	
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,'0','1',p_NameFormat);
	
	
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
	
	
	IF p_RateFormat = 2
	THEN
		
		
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
		
	END IF;
		
	
	IF p_RateCDR = 1
	THEN
   	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET selling_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
   
   END IF;
	
	
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
		
		
		CALL Ratemanagement3.prc_getVendorCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR);
		
		
		
		IF p_RateFormat = 2
		THEN
			CALL prc_updateVendorPrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;
		
		
		
		IF p_RateCDR = 1
		THEN
			CALL prc_updateVendorRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;
		
 	
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
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

END ;;
DELIMITER ;

-- Report
-- Girish

USE `StagingReport`;

DROP FUNCTION `fngetLastInvoiceDate`;

DELIMITER ;;
CREATE DEFINER=`neon-user`@`117.247.87.156` FUNCTION `fngetLastInvoiceDate`(
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
		ON tblAccountBilling.AccountID = tblAccount.AccountID
	WHERE tblAccount.AccountID = p_AccountID;
	
	RETURN v_LastInvoiceDate_;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fngetLastVendorInvoiceDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fngetLastVendorInvoiceDate`(
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
		ON tblAccountBilling.AccountID = tblAccount.AccountID
	LEFT JOIN RMBilling3.tblInvoice 
		ON tblAccount.AccountID = tblInvoice.AccountID AND InvoiceType =2
	LEFT JOIN RMBilling3.tblInvoiceDetail
		ON tblInvoice.InvoiceID =  tblInvoiceDetail.InvoiceID
	WHERE tblAccount.AccountID = p_AccountID 
	ORDER BY IssueDate DESC 
	LIMIT 1;

	RETURN v_LastInvoiceDate_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetMonthDifference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetMonthDifference`(`p_Date1` DATE, `p_Date2` DATE) RETURNS int(11)
BEGIN

DECLARE v_Month INT;

SELECT 12 * (YEAR(p_Date2) - YEAR(p_Date1)) + MONTH(p_Date2) -  MONTH(p_Date1) INTO v_Month;

RETURN v_Month;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetRoundingPoint` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT
) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from Ratemanagement3.tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID;

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetCountry`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fngetDefaultCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fngetDefaultCodes`(IN `p_CompanyID` INT)
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
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetUsageForSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblUsageDetailsReport WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)  
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
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

	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)   
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetUsageForSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	
	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status) 
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
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

	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)  
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetVendorUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReport WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 as call_status
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 as call_status
	FROM RMCDR3.tblVendorCDRFailed  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetVendorUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 as call_status
	FROM RMCDR3.tblVendorCDR  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status) 
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 as call_status
	FROM RMCDR3.tblVendorCDRFailed  ud
	INNER JOIN RMCDR3.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageSummary`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageSummaryDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageSummaryDetail`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageVendorSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageVendorSummary`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageVendorSummaryDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageVendorSummaryDetail`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_datedimbuild` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_datedimbuild`(IN `p_start_date` DATE, IN `p_end_date` DATE)
BEGIN
    DECLARE v_full_date DATE;

     DELETE FROM tblDimDate;

    SET v_full_date = p_start_date;
    WHILE v_full_date < p_end_date DO

        INSERT INTO tblDimDate (
            	`date`,
					`day`,
					`day_abbrev`,
					`day_of_week`,
					`day_of_month`,
					`day_of_quarter`,
					`day_of_semester`,
					`day_of_year`,
					`weekend`,
					`week_of_month`,
					`week_of_quarter`,
					`week_of_semester`,
					`week_of_year`,
					`month`,
					`month_abbrev`,
					`month_of_quarter`,
					`month_of_year`,
					`quarter_of_year`,
					`previous_day`,
					`next_day`,
					`start_week`,
					`end_week`,
					`start_month`,
					`end_month`,
					`start_quarter`,
					`end_quarter`,
					`year`,
					`week_month_name`,
					`week_quarter_name`,
					`week_year_name`,
					`month_quarter_name`,
					`month_year_name`,
					`quarter_year_name`
        ) VALUES (
        			v_full_date,
					DATE_FORMAT( v_full_date , "%W" ),
					DATE_FORMAT( v_full_date , "%a"),
					DAYOFWEEK(v_full_date),
					DAYOFMONTH(v_full_date),
					NULL,
					NULL,
					DAYOFYEAR(v_full_date),
					IF( DATE_FORMAT( v_full_date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
					WEEK(v_full_date) - WEEK(DATE_ADD(v_full_date,INTERVAL -DAY(v_full_date)+1 DAY)),
					NULL,
					NULL,
					WEEKOFYEAR(v_full_date),
					DATE_FORMAT( v_full_date , "%M"),
					DATE_FORMAT( v_full_date , "%b"),
					MOD(MONTH('2016-02-20')-1,3)+1,
					MONTH(v_full_date),
					QUARTER(v_full_date),
					DATE_ADD(v_full_date, INTERVAL -1 DAY),
					DATE_ADD(v_full_date, INTERVAL +1 DAY),
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					YEAR(v_full_date),
					CONCAT(WEEK(v_full_date) - WEEK(DATE_ADD(v_full_date,INTERVAL -DAY(v_full_date)+1 DAY)),'-',DATE_FORMAT( v_full_date , "%M")),
					NULL,
					CONCAT(WEEK(date),'-',DATE_FORMAT( date , "%Y")),
					NULL,
					CONCAT(month_abbrev,'-',year),
					CONCAT(quarter_of_year,'-',year)
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 DAY);
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateSummary`(
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
	
	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);
 
 	
 	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
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
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_UsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummary.CountryID =code.CountryID
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_UsageSummary
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_UsageSummary 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_UsageSummary.AreaPrefix = TBL.AreaPrefix
	SET tmp_UsageSummary.CountryID =TBL.CountryID 
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND tmp_UsageSummary.CountryID IS NULL;
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
 	
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;
	
	START TRANSACTION;
	
	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummary us
	LEFT JOIN tmp_SummaryHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;
	
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
 	
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
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
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;
	
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
	AND us.AreaPrefix = sh.AreaPrefix;

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateSummaryLive`(
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

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);
	 
 	
 	DELETE FROM tmp_UsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
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
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_UsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_UsageSummaryLive
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_UsageSummaryLive 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_UsageSummaryLive.AreaPrefix = TBL.AreaPrefix
	SET tmp_UsageSummaryLive.CountryID =TBL.CountryID 
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND tmp_UsageSummaryLive.CountryID IS NULL ;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummaryLive us
	LEFT JOIN tmp_SummaryHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
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
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix; 
	
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
	AND us.AreaPrefix = sh.AreaPrefix;	

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateVendorSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateVendorSummary`(
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

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);

 	
 	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
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
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummary.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_VendorUsageSummary
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_VendorUsageSummary 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_VendorUsageSummary.AreaPrefix = TBL.AreaPrefix
	SET tmp_VendorUsageSummary.CountryID =TBL.CountryID 
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND tmp_VendorUsageSummary.CountryID IS NULL ;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummary us
	LEFT JOIN tmp_SummaryVendorHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
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
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

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
	AND sh.AreaPrefix = us.AreaPrefix;
	
	COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateVendorSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateVendorSummaryLive`(
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

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);

 	
 	DELETE FROM tmp_VendorUsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
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
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_VendorUsageSummaryLive
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_VendorUsageSummaryLive 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_VendorUsageSummaryLive.AreaPrefix = TBL.AreaPrefix
	SET tmp_VendorUsageSummaryLive.CountryID =TBL.CountryID 
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND tmp_VendorUsageSummaryLive.CountryID IS NULL ;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummaryLive us
	LEFT JOIN tmp_SummaryVendorHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
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
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

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
	AND sh.AreaPrefix = us.AreaPrefix;

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountExpense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountExpense`(IN `p_CompanyID` INT, IN `p_AccountID` INT)
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
	
	
	SELECT 
		ROUND(SUM(IF(CustomerVendor=1,TotalCharges,0)),v_Round_) AS  CustomerTotal,
		ROUND(SUM(IF(CustomerVendor=2,TotalCharges,0)),v_Round_) AS  VendorTotal,
		dd.year as Year,
		dd.month_of_year as Month
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	GROUP BY dd.year,dd.month_of_year;
	
	
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
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getACD_ASR_Alert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getACD_ASR_Alert`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDestinationReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDestinationReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
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
	

	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM(
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getGatewayReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getGatewayReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getHourlyReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getHourlyReport`(
	IN `p_CompanyID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME
)
BEGIN
	
	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_StartDate,p_EndDate,'','',0,p_UserID,p_isAdmin,2);
	
	
	SELECT ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_;
	
	
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	
	SELECT ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes FROM tmp_tblUsageSummary_;
	
	
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalBilledDuration),0) / 60,0) as TotalMinutes FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getPrefixReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getPrefixReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getReportByTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getReportByTime`(
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
	IN `p_ReportType` INT



)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE V_Detail INT;

	SET V_Detail = 2;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,V_Detail);

	
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getTrunkReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getTrunkReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
 	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getUnbilledReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_Detail_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	IF p_Detail = 3
	THEN 
		SET v_Detail_ = 1;
	ELSE 
		SET v_Detail_ = p_Detail;
	END IF;
	
	
	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_LastInvoiceDate,p_Today,'','',0,0,1,v_Detail_);
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY us.DateID;
	
	END IF;
	
	IF p_Detail = 2
	THEN
	
		SELECT 
			dd.date,
			dt.fulltime,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY us.DateID,us.TimeID;
	
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
		FROM tmp_tblUsageSummary_ us;
	
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorAccountReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorAccountReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorACD_ASR_Alert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorACD_ASR_Alert`(
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
	
	CALL fnUsageVendorSummaryDetail(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,0,1);

	IF p_AccountID = ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageVendorSummary_ us;
		
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
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountID;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorBalanceReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorBalanceReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` TEXT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME
)
BEGIN
	
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummaryDetail(p_CompanyID,'',p_AccountID,0,p_StartDate,p_EndDate,'','','',0,1);

	SELECT
		MAX(AccountName) as AccountName,
		IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		AccountID,
		DATE(Time) as Date,
		HOUR(Time) as Hour,
		COALESCE(SUM(TotalCharges),0) as Cost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
		COALESCE(SUM(NoOfCalls),0) as Connected,
		COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AccountID,DATE(Time),HOUR(Time);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorDestinationReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorDestinationReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorGatewayReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorGatewayReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorPrefixReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorPrefixReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorReportByTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorReportByTime`(
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
	IN `p_ReportType` INT

)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE V_Detail INT;

	SET V_Detail = 2;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,V_Detail);

	
	IF p_ReportType =1
	THEN

		SELECT 
			CONCAT(dt.hour,' Hour') as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY  us.DateID,dt.hour;

	END IF;

	
	IF p_ReportType =2
	THEN

		SELECT 
			dd.date as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  us.DateID;

	END IF;

	
	IF p_ReportType =3
	THEN

		SELECT 
			ANY_VALUE(dd.week_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.week_of_year
		ORDER BY dd.year,dd.week_of_year;

	END IF;

	
	IF p_ReportType =4
	THEN

		SELECT 
			ANY_VALUE(dd.month_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.month_of_year
		ORDER BY dd.year,dd.month_of_year;

	END IF;

	
	IF p_ReportType =5
	THEN

		SELECT 
			CONCAT('Q-',ANY_VALUE(dd.quarter_year_name)) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.quarter_of_year
		ORDER BY dd.year,dd.quarter_of_year;

	END IF;

	
	IF p_ReportType =6
	THEN

		SELECT 
			dd.year as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorTrunkReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorTrunkReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
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
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorUnbilledReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_Detail_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	IF p_Detail = 3
	THEN 
		SET v_Detail_ = 1;
	ELSE 
		SET v_Detail_ = p_Detail;
	END IF;
	
	
	CALL fnUsageVendorSummary(p_CompanyID,0,p_AccountID,0,p_LastInvoiceDate,p_Today,'','',0,0,1,v_Detail_);
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY us.DateID;
	
	END IF;
	
	IF p_Detail = 2
	THEN
	
		SELECT 
			dd.date,
			dt.fulltime,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY us.DateID,us.TimeID;
	
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
		FROM tmp_tblUsageVendorSummary_ us;
	
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorWorldMap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorWorldMap`(
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
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnGetCountry();

	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

		
	SELECT 
		Country,
		SUM(NoOfCalls) AS CallCount,
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,
		IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD,
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		MAX(ISO2) AS ISO_Code,
		tblCountry.CountryID
	FROM tmp_tblUsageVendorSummary_ AS us
	INNER JOIN temptblCountry AS tblCountry 
		ON tblCountry.CountryID = us.CountryID
	GROUP BY Country,tblCountry.CountryID 
	HAVING SUM(NoOfCalls) > 0
	ORDER BY CallCount DESC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `prc_getWorldMap`(
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
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnGetCountry();

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

		
	SELECT 
		Country,
		SUM(NoOfCalls) AS CallCount,
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,
		IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD,
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		MAX(ISO2) AS ISO_Code,
		tblCountry.CountryID
	FROM tmp_tblUsageSummary_
	INNER JOIN temptblCountry AS tblCountry 
		ON tblCountry.CountryID = tmp_tblUsageSummary_.CountryID
	GROUP BY Country,tblCountry.CountryID 
	HAVING SUM(NoOfCalls) > 0
	ORDER BY CallCount DESC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `prc_timedimbuild`()
BEGIN
    DECLARE v_full_date DATETIME;

    DELETE FROM tblDimTime;

    SET v_full_date = '2009-03-01 00:00:00';
    WHILE v_full_date < '2009-03-02 00:00:00' DO

        INSERT INTO tblDimTime (
            fulltime ,
            hour ,
            minute ,
            second ,
            ampm
        ) VALUES (
            TIME(v_full_date),
            HOUR(v_full_date),
            MINUTE(v_full_date),
            SECOND(v_full_date),
            DATE_FORMAT(v_full_date,'%p')
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 SECOND);
    END WHILE;
END ;;
DELIMITER ;
