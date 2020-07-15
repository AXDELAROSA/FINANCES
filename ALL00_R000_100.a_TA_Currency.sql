-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		DATA_02
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200213
-- ////////////////////////////////////////////////////////////// 

USE [BD_GENERAL]
GO

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CURRENCY]') AND type in (N'U'))
	DROP TABLE [dbo].[CURRENCY]
GO

-- //////////////////////////////////////////////////////////////
-- // CURRENCY
-- // TABLA QUE CONTIENE LOS TIPOS DE MONEDA CON SUS SIGLAS
-- // DE ACUERDO AL ISO 4217
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM CURRENCY
CREATE TABLE [dbo].[CURRENCY] (
	[K_CURRENCY]					[INT]				NOT NULL,
	[D_CURRENCY]					[VARCHAR]	(250)	NOT NULL,
	[S_CURRENCY]					[VARCHAR]	(10)	NOT NULL,
	[O_CURRENCY]					[INT]				NOT NULL,
	[C_CURRENCY]					[VARCHAR]	(500)	NOT NULL,
	[L_CURRENCY]					[INT]				NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CURRENCY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CURRENCY]
GO

CREATE PROCEDURE [dbo].[PG_CI_CURRENCY]
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_CURRENCY		INT,
	@PP_D_CURRENCY		VARCHAR(100),
	@PP_S_CURRENCY		VARCHAR(10),
	@PP_O_CURRENCY		INT,
	@PP_C_CURRENCY		VARCHAR(255),
	@PP_L_CURRENCY		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXIST	INT

	SELECT	@VP_K_EXIST =	K_CURRENCY
							FROM	CURRENCY
							WHERE	K_CURRENCY=@PP_K_CURRENCY

	-- ===============================

	IF @VP_K_EXIST IS NULL
		INSERT INTO CURRENCY	
			(	K_CURRENCY,				D_CURRENCY, 
				S_CURRENCY,				O_CURRENCY,
				C_CURRENCY,
				L_CURRENCY				)		
		VALUES	
			(	@PP_K_CURRENCY,			@PP_D_CURRENCY,	
				@PP_S_CURRENCY,			@PP_O_CURRENCY,
				@PP_C_CURRENCY,
				@PP_L_CURRENCY			)
	ELSE
		UPDATE	CURRENCY
		SET		D_CURRENCY	= @PP_D_CURRENCY,	
				S_CURRENCY	= @PP_S_CURRENCY,			
				O_CURRENCY	= @PP_O_CURRENCY,
				C_CURRENCY	= @PP_C_CURRENCY,
				L_CURRENCY	= @PP_L_CURRENCY	
		WHERE	K_CURRENCY=@PP_K_CURRENCY

	-- =========================================================
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================

--EXECUTE [dbo].[PG_CI_CURRENCY] 0, 0, 'NOT ASSIGNED',	'??',   1,  '', 1
EXECUTE [dbo].[PG_CI_CURRENCY] 0,  1, 'Mexican Peso' , 'MXN', 484 , 'MEXICO' , 1
--EXECUTE [dbo].[PG_CI_CURRENCY] 0, 2, 'US Dollar' , 'USD', 840 , 'UNITED STATES MINOR OUTLYING ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 3, 'US Dollar' , 'USD', 840 , 'UNITED STATES OF AMERICA (THE)' , 1
--EXECUTE [dbo].[PG_CI_CURRENCY] 0, 4, 'US Dollar (Next day)' , 'USN', 997 , 'UNITED STATES OF AMERICA (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 5, 'Afghani' , 'AFN', 971 , 'AFGHANISTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 6, 'Euro' , 'EUR', 978 , 'ÅLAND ISLANDS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 7, 'Lek' , 'ALL', 8 , 'ALBANIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 8, 'Algerian Dinar' , 'DZD', 12 , 'ALGERIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 9, 'US Dollar' , 'USD', 840 , 'AMERICAN SAMOA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 10, 'Euro' , 'EUR', 978 , 'ANDORRA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 11, 'Kwanza' , 'AOA', 973 , 'ANGOLA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 12, 'East Caribbean Dollar' , 'XCD', 951 , 'ANGUILLA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 13, 'No universal currency' , '', 0 , 'ANTARCTICA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 14, 'East Caribbean Dollar' , 'XCD', 951 , 'ANTIGUA AND BARBUDA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 15, 'Argentine Peso' , 'ARS', 32 , 'ARGENTINA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 16, 'Armenian Dram' , 'AMD', 51 , 'ARMENIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 17, 'Aruban Florin' , 'AWG', 533 , 'ARUBA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 18, 'Australian Dollar' , 'AUD', 36 , 'AUSTRALIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 19, 'Euro' , 'EUR', 978 , 'AUSTRIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 20, 'Azerbaijan Manat' , 'AZN', 944 , 'AZERBAIJAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 21, 'Bahamian Dollar' , 'BSD', 44 , 'BAHAMAS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 22, 'Bahraini Dinar' , 'BHD', 48 , 'BAHRAIN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 23, 'Taka' , 'BDT', 50 , 'BANGLADESH' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 24, 'Barbados Dollar' , 'BBD', 52 , 'BARBADOS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 25, 'Belarusian Ruble' , 'BYN', 933 , 'BELARUS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 26, 'Euro' , 'EUR', 978 , 'BELGIUM' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 27, 'Belize Dollar' , 'BZD', 84 , 'BELIZE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 28, 'CFA Franc BCEAO' , 'XOF', 952 , 'BENIN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 29, 'Bermudian Dollar' , 'BMD', 60 , 'BERMUDA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 30, 'Indian Rupee' , 'INR', 356 , 'BHUTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 31, 'Ngultrum' , 'BTN', 64 , 'BHUTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 32, 'Boliviano' , 'BOB', 68 , 'BOLIVIA (PLURINATIONAL STATE OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 33, 'Mvdol' , 'BOV', 984 , 'BOLIVIA (PLURINATIONAL STATE OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 34, 'US Dollar' , 'USD', 840 , 'BONAIRE, SINT EUSTATIUS AND SABA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 35, 'Convertible Mark' , 'BAM', 977 , 'BOSNIA AND HERZEGOVINA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 36, 'Pula' , 'BWP', 72 , 'BOTSWANA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 37, 'Norwegian Krone' , 'NOK', 578 , 'BOUVET ISLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 38, 'Brazilian Real' , 'BRL', 986 , 'BRAZIL' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 39, 'US Dollar' , 'USD', 840 , 'BRITISH INDIAN OCEAN TERRITORY (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 40, 'Brunei Dollar' , 'BND', 96 , 'BRUNEI DARUSSALAM' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 41, 'Bulgarian Lev' , 'BGN', 975 , 'BULGARIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 42, 'CFA Franc BCEAO' , 'XOF', 952 , 'BURKINA FASO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 43, 'Burundi Franc' , 'BIF', 108 , 'BURUNDI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 44, 'Cabo Verde Escudo' , 'CVE', 132 , 'CABO VERDE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 45, 'Riel' , 'KHR', 116 , 'CAMBODIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 46, 'CFA Franc BEAC' , 'XAF', 950 , 'CAMEROON' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 47, 'Canadian Dollar' , 'CAD', 124 , 'CANADA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 48, 'Cayman Islands Dollar' , 'KYD', 136 , 'CAYMAN ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 49, 'CFA Franc BEAC' , 'XAF', 950 , 'CENTRAL AFRICAN REPUBLIC (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 50, 'CFA Franc BEAC' , 'XAF', 950 , 'CHAD' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 51, 'Chilean Peso' , 'CLP', 152 , 'CHILE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 52, 'Unidad de Fomento' , 'CLF', 990 , 'CHILE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 53, 'Yuan Renminbi' , 'CNY', 156 , 'CHINA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 54, 'Australian Dollar' , 'AUD', 36 , 'CHRISTMAS ISLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 55, 'Australian Dollar' , 'AUD', 36 , 'COCOS (KEELING) ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 56, 'Colombian Peso' , 'COP', 170 , 'COLOMBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 57, 'Unidad de Valor Real' , 'COU', 970 , 'COLOMBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 58, 'Comorian Franc ' , 'KMF', 174 , 'COMOROS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 59, 'Congolese Franc' , 'CDF', 976 , 'CONGO (THE DEMOCRATIC REPUBLIC OF THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 60, 'CFA Franc BEAC' , 'XAF', 950 , 'CONGO (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 61, 'New Zealand Dollar' , 'NZD', 554 , 'COOK ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 62, 'Costa Rican Colon' , 'CRC', 188 , 'COSTA RICA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 63, 'CFA Franc BCEAO' , 'XOF', 952 , 'CÔTE D IVOIRE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 64, 'Kuna' , 'HRK', 191 , 'CROATIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 65, 'Cuban Peso' , 'CUP', 192 , 'CUBA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 66, 'Peso Convertible' , 'CUC', 931 , 'CUBA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 67, 'Netherlands Antillean Guilder' , 'ANG', 532 , 'CURAÇAO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 68, 'Euro' , 'EUR', 978 , 'CYPRUS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 69, 'Czech Koruna' , 'CZK', 203 , 'CZECHIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 70, 'Danish Krone' , 'DKK', 208 , 'DENMARK' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 71, 'Djibouti Franc' , 'DJF', 262 , 'DJIBOUTI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 72, 'East Caribbean Dollar' , 'XCD', 951 , 'DOMINICA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 73, 'Dominican Peso' , 'DOP', 214 , 'DOMINICAN REPUBLIC (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 74, 'US Dollar' , 'USD', 840 , 'ECUADOR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 75, 'Egyptian Pound' , 'EGP', 818 , 'EGYPT' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 76, 'El Salvador Colon' , 'SVC', 222 , 'EL SALVADOR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 77, 'US Dollar' , 'USD', 840 , 'EL SALVADOR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 78, 'CFA Franc BEAC' , 'XAF', 950 , 'EQUATORIAL GUINEA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 79, 'Nakfa' , 'ERN', 232 , 'ERITREA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 80, 'Euro' , 'EUR', 978 , 'ESTONIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 81, 'Ethiopian Birr' , 'ETB', 230 , 'ETHIOPIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 82, 'Euro' , 'EUR', 978 , 'EUROPEAN UNION' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 83, 'Falkland Islands Pound' , 'FKP', 238 , 'FALKLAND ISLANDS (THE) [MALVINAS]' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 84, 'Danish Krone' , 'DKK', 208 , 'FAROE ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 85, 'Fiji Dollar' , 'FJD', 242 , 'FIJI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 86, 'Euro' , 'EUR', 978 , 'FINLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 87, 'Euro' , 'EUR', 978 , 'FRANCE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 88, 'Euro' , 'EUR', 978 , 'FRENCH GUIANA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 89, 'CFP Franc' , 'XPF', 953 , 'FRENCH POLYNESIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 90, 'Euro' , 'EUR', 978 , 'FRENCH SOUTHERN TERRITORIES (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 91, 'CFA Franc BEAC' , 'XAF', 950 , 'GABON' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 92, 'Dalasi' , 'GMD', 270 , 'GAMBIA (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 93, 'Lari' , 'GEL', 981 , 'GEORGIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 94, 'Euro' , 'EUR', 978 , 'GERMANY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 95, 'Ghana Cedi' , 'GHS', 936 , 'GHANA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 96, 'Gibraltar Pound' , 'GIP', 292 , 'GIBRALTAR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 97, 'Euro' , 'EUR', 978 , 'GREECE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 98, 'Danish Krone' , 'DKK', 208 , 'GREENLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 99, 'East Caribbean Dollar' , 'XCD', 951 , 'GRENADA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 100, 'Euro' , 'EUR', 978 , 'GUADELOUPE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 101, 'US Dollar' , 'USD', 840 , 'GUAM' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 102, 'Quetzal' , 'GTQ', 320 , 'GUATEMALA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 103, 'Pound Sterling' , 'GBP', 826 , 'GUERNSEY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 104, 'Guinean Franc' , 'GNF', 324 , 'GUINEA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 105, 'CFA Franc BCEAO' , 'XOF', 952 , 'GUINEA-BISSAU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 106, 'Guyana Dollar' , 'GYD', 328 , 'GUYANA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 107, 'Gourde' , 'HTG', 332 , 'HAITI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 108, 'US Dollar' , 'USD', 840 , 'HAITI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 109, 'Australian Dollar' , 'AUD', 36 , 'HEARD ISLAND AND McDONALD ISLANDS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 110, 'Euro' , 'EUR', 978 , 'HOLY SEE (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 111, 'Lempira' , 'HNL', 340 , 'HONDURAS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 112, 'Hong Kong Dollar' , 'HKD', 344 , 'HONG KONG' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 113, 'Forint' , 'HUF', 348 , 'HUNGARY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 114, 'Iceland Krona' , 'ISK', 352 , 'ICELAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 115, 'Indian Rupee' , 'INR', 356 , 'INDIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 116, 'Rupiah' , 'IDR', 360 , 'INDONESIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 117, 'SDR (Special Drawing Right)' , 'XDR', 960 , 'INTERNATIONAL MONETARY FUND (IMF) ' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 118, 'Iranian Rial' , 'IRR', 364 , 'IRAN (ISLAMIC REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 119, 'Iraqi Dinar' , 'IQD', 368 , 'IRAQ' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 120, 'Euro' , 'EUR', 978 , 'IRELAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 121, 'Pound Sterling' , 'GBP', 826 , 'ISLE OF MAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 122, 'New Israeli Sheqel' , 'ILS', 376 , 'ISRAEL' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 123, 'Euro' , 'EUR', 978 , 'ITALY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 124, 'Jamaican Dollar' , 'JMD', 388 , 'JAMAICA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 125, 'Yen' , 'JPY', 392 , 'JAPAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 126, 'Pound Sterling' , 'GBP', 826 , 'JERSEY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 127, 'Jordanian Dinar' , 'JOD', 400 , 'JORDAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 128, 'Tenge' , 'KZT', 398 , 'KAZAKHSTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 129, 'Kenyan Shilling' , 'KES', 404 , 'KENYA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 130, 'Australian Dollar' , 'AUD', 36 , 'KIRIBATI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 131, 'North Korean Won' , 'KPW', 408 , 'KOREA (THE DEMOCRATIC PEOPLE’S REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 132, 'Won' , 'KRW', 410 , 'KOREA (THE REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 133, 'Kuwaiti Dinar' , 'KWD', 414 , 'KUWAIT' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 134, 'Som' , 'KGS', 417 , 'KYRGYZSTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 135, 'Lao Kip' , 'LAK', 418 , 'LAO PEOPLE’S DEMOCRATIC REPUBLIC (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 136, 'Euro' , 'EUR', 978 , 'LATVIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 137, 'Lebanese Pound' , 'LBP', 422 , 'LEBANON' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 138, 'Loti' , 'LSL', 426 , 'LESOTHO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 139, 'Rand' , 'ZAR', 710 , 'LESOTHO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 140, 'Liberian Dollar' , 'LRD', 430 , 'LIBERIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 141, 'Libyan Dinar' , 'LYD', 434 , 'LIBYA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 142, 'Swiss Franc' , 'CHF', 756 , 'LIECHTENSTEIN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 143, 'Euro' , 'EUR', 978 , 'LITHUANIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 144, 'Euro' , 'EUR', 978 , 'LUXEMBOURG' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 145, 'Pataca' , 'MOP', 446 , 'MACAO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 146, 'Denar' , 'MKD', 807 , 'MACEDONIA (THE FORMER YUGOSLAV REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 147, 'Malagasy Ariary' , 'MGA', 969 , 'MADAGASCAR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 148, 'Malawi Kwacha' , 'MWK', 454 , 'MALAWI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 149, 'Malaysian Ringgit' , 'MYR', 458 , 'MALAYSIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 150, 'Rufiyaa' , 'MVR', 462 , 'MALDIVES' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 151, 'CFA Franc BCEAO' , 'XOF', 952 , 'MALI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 152, 'Euro' , 'EUR', 978 , 'MALTA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 153, 'US Dollar' , 'USD', 840 , 'MARSHALL ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 154, 'Euro' , 'EUR', 978 , 'MARTINIQUE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 155, 'Ouguiya' , 'MRU', 929 , 'MAURITANIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 156, 'Mauritius Rupee' , 'MUR', 480 , 'MAURITIUS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 157, 'Euro' , 'EUR', 978 , 'MAYOTTE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 158, 'ADB Unit of Account' , 'XUA', 965 , 'MEMBER COUNTRIES OF THE AFRICAN DEVELOPMENT BANK GROUP' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 159, 'Mexican Unidad de Inversion (UDI)' , 'MXV', 979 , 'MEXICO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 160, 'US Dollar' , 'USD', 840 , 'MICRONESIA (FEDERATED STATES OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 161, 'Moldovan Leu' , 'MDL', 498 , 'MOLDOVA (THE REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 162, 'Euro' , 'EUR', 978 , 'MONACO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 163, 'Tugrik' , 'MNT', 496 , 'MONGOLIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 164, 'Euro' , 'EUR', 978 , 'MONTENEGRO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 165, 'East Caribbean Dollar' , 'XCD', 951 , 'MONTSERRAT' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 166, 'Moroccan Dirham' , 'MAD', 504 , 'MOROCCO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 167, 'Mozambique Metical' , 'MZN', 943 , 'MOZAMBIQUE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 168, 'Kyat' , 'MMK', 104 , 'MYANMAR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 169, 'Namibia Dollar' , 'NAD', 516 , 'NAMIBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 170, 'Rand' , 'ZAR', 710 , 'NAMIBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 171, 'Australian Dollar' , 'AUD', 36 , 'NAURU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 172, 'Nepalese Rupee' , 'NPR', 524 , 'NEPAL' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 173, 'Euro' , 'EUR', 978 , 'NETHERLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 174, 'CFP Franc' , 'XPF', 953 , 'NEW CALEDONIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 175, 'New Zealand Dollar' , 'NZD', 554 , 'NEW ZEALAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 176, 'Cordoba Oro' , 'NIO', 558 , 'NICARAGUA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 177, 'CFA Franc BCEAO' , 'XOF', 952 , 'NIGER (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 178, 'Naira' , 'NGN', 566 , 'NIGERIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 179, 'New Zealand Dollar' , 'NZD', 554 , 'NIUE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 180, 'Australian Dollar' , 'AUD', 36 , 'NORFOLK ISLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 181, 'US Dollar' , 'USD', 840 , 'NORTHERN MARIANA ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 182, 'Norwegian Krone' , 'NOK', 578 , 'NORWAY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 183, 'Rial Omani' , 'OMR', 512 , 'OMAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 184, 'Pakistan Rupee' , 'PKR', 586 , 'PAKISTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 185, 'US Dollar' , 'USD', 840 , 'PALAU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 186, 'No universal currency' , '', 0 , 'PALESTINE, STATE OF' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 187, 'Balboa' , 'PAB', 590 , 'PANAMA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 188, 'US Dollar' , 'USD', 840 , 'PANAMA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 189, 'Kina' , 'PGK', 598 , 'PAPUA NEW GUINEA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 190, 'Guarani' , 'PYG', 600 , 'PARAGUAY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 191, 'Sol' , 'PEN', 604 , 'PERU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 192, 'Philippine Peso' , 'PHP', 608 , 'PHILIPPINES (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 193, 'New Zealand Dollar' , 'NZD', 554 , 'PITCAIRN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 194, 'Zloty' , 'PLN', 985 , 'POLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 195, 'Euro' , 'EUR', 978 , 'PORTUGAL' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 196, 'US Dollar' , 'USD', 840 , 'PUERTO RICO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 197, 'Qatari Rial' , 'QAR', 634 , 'QATAR' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 198, 'Euro' , 'EUR', 978 , 'RÉUNION' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 199, 'Romanian Leu' , 'RON', 946 , 'ROMANIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 200, 'Russian Ruble' , 'RUB', 643 , 'RUSSIAN FEDERATION (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 201, 'Rwanda Franc' , 'RWF', 646 , 'RWANDA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 202, 'Euro' , 'EUR', 978 , 'SAINT BARTHÉLEMY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 203, 'Saint Helena Pound' , 'SHP', 654 , 'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 204, 'East Caribbean Dollar' , 'XCD', 951 , 'SAINT KITTS AND NEVIS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 205, 'East Caribbean Dollar' , 'XCD', 951 , 'SAINT LUCIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 206, 'Euro' , 'EUR', 978 , 'SAINT MARTIN (FRENCH PART)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 207, 'Euro' , 'EUR', 978 , 'SAINT PIERRE AND MIQUELON' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 208, 'East Caribbean Dollar' , 'XCD', 951 , 'SAINT VINCENT AND THE GRENADINES' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 209, 'Tala' , 'WST', 882 , 'SAMOA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 210, 'Euro' , 'EUR', 978 , 'SAN MARINO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 211, 'Dobra' , 'STN', 930 , 'SAO TOME AND PRINCIPE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 212, 'Saudi Riyal' , 'SAR', 682 , 'SAUDI ARABIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 213, 'CFA Franc BCEAO' , 'XOF', 952 , 'SENEGAL' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 214, 'Serbian Dinar' , 'RSD', 941 , 'SERBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 215, 'Seychelles Rupee' , 'SCR', 690 , 'SEYCHELLES' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 216, 'Leone' , 'SLL', 694 , 'SIERRA LEONE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 217, 'Singapore Dollar' , 'SGD', 702 , 'SINGAPORE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 218, 'Netherlands Antillean Guilder' , 'ANG', 532 , 'SINT MAARTEN (DUTCH PART)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 219, 'Sucre' , 'XSU', 994 , 'SISTEMA UNITARIO DE COMPENSACION REGIONAL DE PAGOS "SUCRE"' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 220, 'Euro' , 'EUR', 978 , 'SLOVAKIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 221, 'Euro' , 'EUR', 978 , 'SLOVENIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 222, 'Solomon Islands Dollar' , 'SBD', 90 , 'SOLOMON ISLANDS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 223, 'Somali Shilling' , 'SOS', 706 , 'SOMALIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 224, 'Rand' , 'ZAR', 710 , 'SOUTH AFRICA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 225, 'No universal currency' , '', 0 , 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 226, 'South Sudanese Pound' , 'SSP', 728 , 'SOUTH SUDAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 227, 'Euro' , 'EUR', 978 , 'SPAIN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 228, 'Sri Lanka Rupee' , 'LKR', 144 , 'SRI LANKA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 229, 'Sudanese Pound' , 'SDG', 938 , 'SUDAN (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 230, 'Surinam Dollar' , 'SRD', 968 , 'SURINAME' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 231, 'Norwegian Krone' , 'NOK', 578 , 'SVALBARD AND JAN MAYEN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 232, 'Lilangeni' , 'SZL', 748 , 'ESWATINI' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 233, 'Swedish Krona' , 'SEK', 752 , 'SWEDEN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 234, 'Swiss Franc' , 'CHF', 756 , 'SWITZERLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 235, 'WIR Euro' , 'CHE', 947 , 'SWITZERLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 236, 'WIR Franc' , 'CHW', 948 , 'SWITZERLAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 237, 'Syrian Pound' , 'SYP', 760 , 'SYRIAN ARAB REPUBLIC' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 238, 'New Taiwan Dollar' , 'TWD', 901 , 'TAIWAN (PROVINCE OF CHINA)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 239, 'Somoni' , 'TJS', 972 , 'TAJIKISTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 240, 'Tanzanian Shilling' , 'TZS', 834 , 'TANZANIA, UNITED REPUBLIC OF' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 241, 'Baht' , 'THB', 764 , 'THAILAND' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 242, 'US Dollar' , 'USD', 840 , 'TIMOR-LESTE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 243, 'CFA Franc BCEAO' , 'XOF', 952 , 'TOGO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 244, 'New Zealand Dollar' , 'NZD', 554 , 'TOKELAU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 245, 'Pa’anga' , 'TOP', 776 , 'TONGA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 246, 'Trinidad and Tobago Dollar' , 'TTD', 780 , 'TRINIDAD AND TOBAGO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 247, 'Tunisian Dinar' , 'TND', 788 , 'TUNISIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 248, 'Turkish Lira' , 'TRY', 949 , 'TURKEY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 249, 'Turkmenistan New Manat' , 'TMT', 934 , 'TURKMENISTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 250, 'US Dollar' , 'USD', 840 , 'TURKS AND CAICOS ISLANDS (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 251, 'Australian Dollar' , 'AUD', 36 , 'TUVALU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 252, 'Uganda Shilling' , 'UGX', 800 , 'UGANDA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 253, 'Hryvnia' , 'UAH', 980 , 'UKRAINE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 254, 'UAE Dirham' , 'AED', 784 , 'UNITED ARAB EMIRATES (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 255, 'Pound Sterling' , 'GBP', 826 , 'UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND (THE)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 256, 'Peso Uruguayo' , 'UYU', 858 , 'URUGUAY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 257, 'Uruguay Peso en Unidades Indexadas (UI)' , 'UYI', 940 , 'URUGUAY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 258, 'Unidad Previsional' , 'UYW', 927 , 'URUGUAY' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 259, 'Uzbekistan Sum' , 'UZS', 860 , 'UZBEKISTAN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 260, 'Vatu' , 'VUV', 548 , 'VANUATU' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 261, 'Bolívar Soberano' , 'VES', 928 , 'VENEZUELA (BOLIVARIAN REPUBLIC OF)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 262, 'Dong' , 'VND', 704 , 'VIET NAM' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 263, 'US Dollar' , 'USD', 840 , 'VIRGIN ISLANDS (BRITISH)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 264, 'US Dollar' , 'USD', 840 , 'VIRGIN ISLANDS (U.S.)' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 265, 'CFP Franc' , 'XPF', 953 , 'WALLIS AND FUTUNA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 266, 'Moroccan Dirham' , 'MAD', 504 , 'WESTERN SAHARA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 267, 'Yemeni Rial' , 'YER', 886 , 'YEMEN' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 268, 'Zambian Kwacha' , 'ZMW', 967 , 'ZAMBIA' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 269, 'Zimbabwe Dollar' , 'ZWL', 932 , 'ZIMBABWE' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 270, 'Bond Markets Unit European Composite Unit (EURCO)' , 'XBA', 955 , 'ZZ01_Bond Markets Unit European_EURCO' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 271, 'Bond Markets Unit European Monetary Unit (E.M.U.-6)' , 'XBB', 956 , 'ZZ02_Bond Markets Unit European_EMU-6' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 272, 'Bond Markets Unit European Unit of Account 9 (E.U.A.-9)' , 'XBC', 957 , 'ZZ03_Bond Markets Unit European_EUA-9' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 273, 'Bond Markets Unit European Unit of Account 17 (E.U.A.-17)' , 'XBD', 958 , 'ZZ04_Bond Markets Unit European_EUA-17' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 274, 'Codes specifically reserved for testing purposes' , 'XTS', 963 , 'ZZ06_Testing_Code' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 275, 'The codes assigned for transactions where no currency is involved' , 'XXX', 999 , 'ZZ07_No_Currency' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 276, 'Gold' , 'XAU', 959 , 'ZZ08_Gold' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 277, 'Palladium' , 'XPD', 964 , 'ZZ09_Palladium' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 278, 'Platinum' , 'XPT', 962 , 'ZZ10_Platinum' , 0
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 279, 'Silver' , 'XAG', 961 , 'ZZ11_Silver' , 0

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CURRENCY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CURRENCY]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////