-- MySQL dump 10.13  Distrib 5.7.11, for Linux (x86_64)
--
-- Host: localhost    Database: wavetelwholesaleCDR
-- ------------------------------------------------------
-- Server version	5.7.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tblCDRPostProcess`
--

DROP TABLE IF EXISTS `tblCDRPostProcess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCDRPostProcess` (
  `CDRPostProcessID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`CDRPostProcessID`),
  KEY `IX_tblCDRPostProcess_CID` (`CompanyID`),
  KEY `IX_tblCDRPostProcess_PID_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=218128633 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCDRPostProcess_copy`
--

DROP TABLE IF EXISTS `tblCDRPostProcess_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCDRPostProcess_copy` (
  `CDRPostProcessID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`CDRPostProcessID`),
  KEY `IX_tblCDRPostProcess_CID` (`CompanyID`),
  KEY `IX_tblCDRPostProcess_PID_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=5006598 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_111`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_111` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_111PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=17355149 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_112`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_112` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_112PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=37303852 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_112cdr`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_112cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_112cdr` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_112cdrPID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_13`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_13` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_13PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=28744044 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_13cdr`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_13cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_13cdr` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_13cdrPID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_18`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_18` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_18PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=29295595 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_18_copy`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_18_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_18_copy` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_18PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=35509885 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_18cdr`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_18cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_18cdr` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_18cdrPID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDetail_18recal`
--

DROP TABLE IF EXISTS `tblTempUsageDetail_18recal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDetail_18recal` (
  `TempUsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempUsageDetailID`),
  KEY `IX_tblTempUsageDetail_18recalPID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorCDR_111`
--

DROP TABLE IF EXISTS `tblTempVendorCDR_111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorCDR_111` (
  `TempVendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorCDRID`),
  KEY `IX_tblTempVendorCDR_111PID_I_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=24484695 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorCDR_112`
--

DROP TABLE IF EXISTS `tblTempVendorCDR_112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorCDR_112` (
  `TempVendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorCDRID`),
  KEY `IX_tblTempVendorCDR_112PID_I_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=32007334 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorCDR_13`
--

DROP TABLE IF EXISTS `tblTempVendorCDR_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorCDR_13` (
  `TempVendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorCDRID`),
  KEY `IX_tblTempVendorCDR_13PID_I_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=14728172 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorCDR_13cdr`
--

DROP TABLE IF EXISTS `tblTempVendorCDR_13cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorCDR_13cdr` (
  `TempVendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorCDRID`),
  KEY `IX_tblTempVendorCDR_13cdrPID_I_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorCDR_18`
--

DROP TABLE IF EXISTS `tblTempVendorCDR_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorCDR_18` (
  `TempVendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TrunkPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `is_rerated` tinyint(1) DEFAULT '0',
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorCDRID`),
  KEY `IX_tblTempVendorCDR_18PID_I_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=19089462 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetailFailedCall`
--

DROP TABLE IF EXISTS `tblUsageDetailFailedCall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetailFailedCall` (
  `UsageDetailFailedCallID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UsageDetailFailedCallID`),
  KEY `IXtblUsageDetailFailedCall_ID` (`ID`),
  KEY `IXtblUsageDetailFailedCall_UsageHeaderID` (`UsageHeaderID`),
  KEY `IXtblUsageDetailFailedCall_ProcessID` (`ProcessID`)
) ENGINE=InnoDB AUTO_INCREMENT=330213321 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetailFailedCall_9_03_2017`
--

DROP TABLE IF EXISTS `tblUsageDetailFailedCall_9_03_2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetailFailedCall_9_03_2017` (
  `UsageDetailFailedCallID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  PRIMARY KEY (`UsageDetailFailedCallID`),
  KEY `IX_ID` (`ID`),
  KEY `IX_UsageHeaderID` (`UsageHeaderID`),
  KEY `IX_ProcessID` (`ProcessID`)
) ENGINE=InnoDB AUTO_INCREMENT=474090523 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetailFailedCall_new_delete`
--

DROP TABLE IF EXISTS `tblUsageDetailFailedCall_new_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetailFailedCall_new_delete` (
  `UsageDetailFailedCallID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UsageDetailFailedCallID`),
  KEY `IXtblUsageDetailFailedCall_ID` (`ID`),
  KEY `IXtblUsageDetailFailedCall_UsageHeaderID` (`UsageHeaderID`),
  KEY `IXtblUsageDetailFailedCall_ProcessID` (`ProcessID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetails`
--

DROP TABLE IF EXISTS `tblUsageDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetails` (
  `UsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(18,6) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UsageDetailID`),
  KEY `IX_UsageDetailCMP_GaTGatACPrID` (`UsageHeaderID`),
  KEY `IX_Index_ID` (`ID`),
  KEY `IX_ProcessID` (`ProcessID`)
) ENGINE=InnoDB AUTO_INCREMENT=43571584 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetails_09_03_2017`
--

DROP TABLE IF EXISTS `tblUsageDetails_09_03_2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetails_09_03_2017` (
  `UsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(18,6) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  PRIMARY KEY (`UsageDetailID`),
  KEY `IXUsageDetailCMP_GaTGatACPrID` (`UsageHeaderID`),
  KEY `Index_ID` (`ID`),
  KEY `Index_ProcessID` (`ProcessID`)
) ENGINE=InnoDB AUTO_INCREMENT=760600672 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDetails_new_delete`
--

DROP TABLE IF EXISTS `tblUsageDetails_new_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDetails_new_delete` (
  `UsageDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `UsageHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(18,6) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_inbound` tinyint(1) DEFAULT '0',
  `billed_second` int(11) DEFAULT NULL,
  `disposition` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UsageDetailID`),
  KEY `IX_UsageDetailCMP_GaTGatACPrID` (`UsageHeaderID`),
  KEY `IX_Index_ID` (`ID`),
  KEY `IX_ProcessID` (`ProcessID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageHeader`
--

DROP TABLE IF EXISTS `tblUsageHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageHeader` (
  `UsageHeaderID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`UsageHeaderID`),
  KEY `Index_Com_GA_CG_A` (`CompanyID`,`GatewayAccountID`,`CompanyGatewayID`,`AccountID`),
  KEY `Index_A_STD_CG` (`AccountID`,`StartDate`,`CompanyGatewayID`)
) ENGINE=InnoDB AUTO_INCREMENT=214656 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVCDRPostProcess`
--

DROP TABLE IF EXISTS `tblVCDRPostProcess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVCDRPostProcess` (
  `VCDRPostProcessID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `ProcessID` bigint(20) unsigned DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  PRIMARY KEY (`VCDRPostProcessID`),
  KEY `IX_tblVCDRPostProcess_CID` (`CompanyID`),
  KEY `IX_tblVCDRPostProcess_PID_AID` (`ProcessID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=217783628 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDR`
--

DROP TABLE IF EXISTS `tblVendorCDR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDR` (
  `VendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorCDRHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  PRIMARY KEY (`VendorCDRID`),
  KEY `IX_ProcessID` (`ProcessID`),
  KEY `Index 4` (`connect_time`),
  KEY `IX_VendorCDRHeaderID` (`VendorCDRHeaderID`,`connect_time`,`disconnect_time`),
  KEY `IX_VendorCDRHeaderID2` (`VendorCDRHeaderID`)
) ENGINE=InnoDB AUTO_INCREMENT=951806398 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDRFailed`
--

DROP TABLE IF EXISTS `tblVendorCDRFailed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDRFailed` (
  `VendorCDRFailedID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `VendorCDRHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  PRIMARY KEY (`VendorCDRFailedID`),
  KEY `IX_ProcessID` (`ProcessID`),
  KEY `IX_VendorCDRHeaderID` (`VendorCDRHeaderID`)
) ENGINE=InnoDB AUTO_INCREMENT=644702613 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDRFailed_2016`
--

DROP TABLE IF EXISTS `tblVendorCDRFailed_2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDRFailed_2016` (
  `VendorCDRFailedID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorCDRHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billed_second` int(11) DEFAULT NULL,
  PRIMARY KEY (`VendorCDRFailedID`),
  KEY `IX_ProcessID` (`ProcessID`),
  KEY `IX_VendorCDRHeaderID` (`VendorCDRHeaderID`)
) ENGINE=InnoDB AUTO_INCREMENT=2147481962 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDRFailed_old`
--

DROP TABLE IF EXISTS `tblVendorCDRFailed_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDRFailed_old` (
  `VendorCDRFailedID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorCDRHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`VendorCDRFailedID`),
  KEY `IX_ProcessID` (`ProcessID`),
  KEY `IX_VendorCDRHeaderID` (`VendorCDRHeaderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDRHeader`
--

DROP TABLE IF EXISTS `tblVendorCDRHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDRHeader` (
  `VendorCDRHeaderID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`VendorCDRHeaderID`),
  KEY `Index_A_S_CG` (`AccountID`,`StartDate`,`CompanyGatewayID`),
  KEY `Index_C_CG_A_GA` (`CompanyID`,`CompanyGatewayID`,`GatewayAccountID`,`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=133243 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCDR_old`
--

DROP TABLE IF EXISTS `tblVendorCDR_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCDR_old` (
  `VendorCDRID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorCDRHeaderID` int(11) NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `selling_cost` double DEFAULT NULL,
  `buying_cost` double DEFAULT NULL,
  `cli` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cld` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`VendorCDRID`),
  KEY `IX_ProcessID` (`ProcessID`),
  KEY `IX_VendorCDRHeaderID` (`VendorCDRHeaderID`)
) ENGINE=InnoDB AUTO_INCREMENT=456116166 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tempcdrs`
--

DROP TABLE IF EXISTS `tempcdrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempcdrs` (
  `Caller` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Original CLI` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CLI` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Original CLD` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CLD` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Billing Prefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Setup Time` datetime DEFAULT NULL,
  `Connect Time` datetime DEFAULT NULL,
  `Disconnect Time` datetime DEFAULT NULL,
  `Duration, sec` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Billed Duration, sec` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Cost` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Currency` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Result` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Remote IP` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LRN Original CLD` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LRN CLD` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Area Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Error Message` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `Index 1` (`CLD`),
  KEY `Index 2` (`Connect Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'wavetelwholesaleCDR'
--
/*!50003 DROP PROCEDURE IF EXISTS `prc_deleteCustomerCDRByRetention` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_deleteCustomerCDRByRetention`(IN `p_CompanyID` INT, IN `p_DeleteDate` DATETIME)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	
	
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
		
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_DeleteDuplicateUniqueID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_DeleteDuplicateUniqueID`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_ProcessID` VARCHAR(200), IN `p_tbltempusagedetail_name` VARCHAR(200))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_deleteVendorCDRByRetention` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_deleteVendorCDRByRetention`(IN `p_CompanyID` INT, IN `p_DeleteDate` DATETIME)
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	
	
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
		
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertCDR`(
	IN `p_processId` varchar(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)


)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;
 
    
    
    
    set @stm2 = CONCAT('
	insert into   tblUsageHeader (CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,StartDate,created_at)
	select distinct d.CompanyID,d.CompanyGatewayID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW()  
	from `' , p_tbltempusagedetail_name , '` d
	left join tblUsageHeader h 
		on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		where h.GatewayAccountID is null and processid = "' , p_processId , '";
	');

    PREPARE stmt2 FROM @stm2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    

	set @stm3 = CONCAT('
	insert into tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	select UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblUsageHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	where   processid = "' , p_processId , '"
	and billed_duration = 0 and cost = 0 AND ( disposition <> "ANSWERED" or disposition IS NULL);
	');

    PREPARE stmt3 FROM @stm3;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;
    
    
	set @stm4 = CONCAT('    
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  and billed_duration = 0 and cost = 0 AND ( disposition <> "ANSWERED" or disposition IS NULL);
	');

    PREPARE stmt4 FROM @stm4;
    EXECUTE stmt4;
    DEALLOCATE PREPARE stmt4;

	set @stm5 = CONCAT(' 
	insert into tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	select UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblUsageHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	where   processid = "' , p_processId , '" ;
	');
    PREPARE stmt5 FROM @stm5;
    EXECUTE stmt5;
    DEALLOCATE PREPARE stmt5;

 	set @stm6 = CONCAT(' 
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');
    PREPARE stmt6 FROM @stm6;
    EXECUTE stmt6;
    DEALLOCATE PREPARE stmt6;
    

	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertPostProcessCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertPostProcessCDR`(IN `p_ProcessID` VarCHAR(200))
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	INSERT INTO tblCDRPostProcess(CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID)
	SELECT
		CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		AccountID,
		connect_time,
		disconnect_time,
		billed_duration,
		billed_second,
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
		ID
	FROM tblUsageDetails ud
	INNER JOIN tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE  uh.AccountID IS NOT NULL
		AND ud.ProcessID = p_ProcessID;
	
	INSERT INTO tblVCDRPostProcess(CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	SELECT
		CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		AccountID,
		billed_duration,
		billed_second, 
		ID, 
		selling_cost, 
		buying_cost, 
		connect_time, 
		disconnect_time,
		cli, 
		cld,
		trunk,
		area_prefix,  
		remote_ip, 
		ProcessID
	FROM tblVendorCDR ud
	INNER JOIN tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
	WHERE  uh.AccountID IS NOT NULL
		AND ud.ProcessID = p_ProcessID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertVendorCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertVendorCDR`(IN `p_processId` VARCHAR(200), IN `p_tbltempusagedetail_name` VARCHAR(50))
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

 
	set @stm2 = CONCAT('
	insert into   tblVendorCDRHeader (CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,StartDate,created_at)
	select distinct d.CompanyID,d.CompanyGatewayID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW()  
	from `' , p_tbltempusagedetail_name , '` d
	left join tblVendorCDRHeader h 
		on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")  

		where h.GatewayAccountID is null and processid = "' , p_processId , '";
		');
		
	PREPARE stmt2 FROM @stm2;
   EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;
	
	set @stm6 = CONCAT('
	insert into tblVendorCDRFailed (VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	select VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblVendorCDRHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		
	where   processid = "' , p_processId , '" AND  billed_duration = 0 and buying_cost = 0 ;
	');
	
	PREPARE stmt6 FROM @stm6;
   EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;

     
	
	set @stm3 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  and billed_duration = 0 and buying_cost = 0;
	');
	
	PREPARE stmt3 FROM @stm3;
   EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	set @stm4 = CONCAT('
	insert into tblVendorCDR (VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID)
	select VendorCDRHeaderID,billed_duration,billed_second, ID, selling_cost, buying_cost, connect_time, disconnect_time,cli, cld,trunk,area_prefix,  remote_ip, ProcessID
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblVendorCDRHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d") 
	where   processid = "' , p_processId , '" ;
	');
	
	PREPARE stmt4 FROM @stm4;
   EXECUTE stmt4;
	DEALLOCATE PREPARE stmt4;

   set @stm5 = CONCAT(' 
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');
	
	PREPARE stmt5 FROM @stm5;
   EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_invoice_in_reconcile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_invoice_in_reconcile`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `StartTime` DATETIME, IN `EndTime` DATETIME)
BEGIN


		SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		
		select ifnull(sum(vc.buying_cost),0) as DisputeTotal , ifnull(sum(billed_duration),0) as DisputeMinutes 
		from tblVendorCDR vc
		inner join tblVendorCDRHeader vh on vh.VendorCDRHeaderID = vc.VendorCDRHeaderID
		where vh.CompanyID = p_CompanyID and vh.AccountID = p_AccountID 
		and connect_time >= StartTime and connect_time <= EndTime;
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_PostProcessCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_PostProcessCDR`(IN `p_CompanyID` INT)
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
	SELECT TempUsageDownloadLogID,ProcessID FROM  wavetelwholesaleBilling.tblTempUsageDownloadLog WHERE CompanyID = p_CompanyID AND PostProcessStatus=0 LIMIT 50;
	
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
	INNER JOIN  wavetelwholesaleRM.tblCountry ON area_prefix LIKE CONCAT(Prefix , "%")
	SET tblCDRPostProcess.CountryID =tblCountry.CountryID
	WHERE tblCDRPostProcess.CompanyID = p_CompanyID;
	
	UPDATE tblVCDRPostProcess 
	INNER JOIN  wavetelwholesaleRM.tblCountry ON area_prefix LIKE CONCAT(Prefix , "%")
	SET tblVCDRPostProcess.CountryID =tblCountry.CountryID
	WHERE tblVCDRPostProcess.CompanyID = p_CompanyID;
	
	SELECT * FROM tmp_ProcessIDS;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_RetailMonitorCalls` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_RetailMonitorCalls`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Type` VARCHAR(50)

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
		
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_unsetCDRUsageAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_unsetCDRUsageAccount`(
	IN `p_CompanyID` INT,
	IN `p_IPs` LONGTEXT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_Confirm` INT




)
BEGIN

	DECLARE v_AccountID int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_AccountID = 0;
		SELECT DISTINCT GAC.AccountID INTO v_AccountID 
		FROM wavetelwholesaleBilling.tblGatewayAccount GAC
		WHERE GAC.CompanyID = p_CompanyID
		AND AccountID IS NOT NULL
		AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0
		LIMIT 1;
	
	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblUsageHeader UH
			WHERE UH.CompanyID = p_CompanyID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(UH.CompanyGatewayID, p_IPs) > 0
			LIMIT 1; 
	END IF;
	
	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblVendorCDRHeader VH
			WHERE VH.CompanyID = p_CompanyID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(VH.GatewayAccountID, p_IPs) > 0
			LIMIT 1; 
	END IF;
	IF v_AccountID >0 AND p_Confirm = 1 THEN
			UPDATE wavetelwholesaleBilling.tblGatewayAccount GAC SET GAC.AccountID = NULL
			WHERE GAC.CompanyID = p_CompanyID
			AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0;
	
			Update tblUsageHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0			
			AND StartDate >= p_StartDate;
						
			Update tblVendorCDRHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0
			AND StartDate >= p_StartDate;
	SET v_AccountID = -1;
	END IF;

	SELECT v_AccountID as `Status`;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-03 11:35:49
