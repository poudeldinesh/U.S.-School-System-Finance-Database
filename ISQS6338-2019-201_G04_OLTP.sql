/*FCP_Group_Project_2_G04_OLTP
Group Members:
Dinesh Poudel
Anurag Sharma
Khaza Towfik Akbar
Luciano Vecchio

Submission Date: 07/31/2019 */


########################################################################################################
/* Creatinng 'cbsa'  table*/
CREATE TABLE cbsa (
  cbsa_id INT NOT NULL,
  cbsa_desc 	VARCHAR(30) NULL,
  PRIMARY KEY (cbsa_id)
);

/* Inserting data in table 'cbsa'*/
INSERT INTO cbsa(cbsa_id)
SELECT DISTINCT CBSA
FROM FCP_Dataset.full_dataset
WHERE CBSA IS NOT NULL;

########################################################################################################
/* Creatinng 'csa'  table*/
CREATE TABLE csa (
  csa_id INT(3) NOT NULL,
  csa_desc VARCHAR(30) NULL,
  PRIMARY KEY (csa_id)
);

/* Inserting data in table 'csa'*/
INSERT INTO csa(csa_id)
SELECT DISTINCT CSA
FROM FCP_Dataset.full_dataset
WHERE CSA IS NOT NULL;

########################################################################################################
/* Creatinng 'states'  table*/
CREATE TABLE states(
  st_name VARCHAR(50),
  usps_code CHAR(2),
  PRIMARY KEY (usps_code)
);

/* Inserting data in table 'states'*/
INSERT INTO states(usps_code, st_name)
 VALUES ('AL', 'Alabama'),
('AK', 'Alaska'),
('AZ', 'Arizona'),
('AR', 'Arkansas'),
('CA', 'California'),
('CO', 'Colorado'),
('CT', 'Connecticut'),
('DE', 'Delaware'),
('DC', 'District of Columbia'),
('FL', 'Florida'),
('GA', 'Georgia'),
('HI', 'Hawaii'),
('ID', 'Idaho'),
('IL', 'Illinois'),
('IN', 'Indiana'),
('IA', 'Iowa'),
('KS', 'Kansas'),
('KY', 'Kentucky'),
('LA', 'Louisiana'),
('ME', 'Maine'),
('MD', 'Maryland'),
('MA', 'Massachusetts'),
('MI', 'Michigan'),
('MN', 'Minnesota'),
('MS', 'Mississippi'),
('MO', 'Missouri'),
('MT', 'Montana'),
('NE', 'Nebraska'),
('NV', 'Nevada'),
('NH', 'New Hampshire'),
('NJ', 'New Jersey'),
('NM', 'New Mexico'),
('NY', 'New York'),
('NC', 'North Carolina'),
('ND', 'North Dakota'),
('OH', 'Ohio'),
('OK', 'Oklahoma'),
('OR', 'Oregon'),
('PA', 'Pennsylvania'),
('RI', 'Rhode Island'),
('SC', 'South Carolina'),
('SD', 'South Dakota'),
('TN', 'Tennessee'),
('TX', 'Texas'),
('UT', 'Utah'),
('VT', 'Vermont'),
('VA', 'Virginia'),
('WA', 'Washington'),
('WV', 'West Virginia'),
('WI', 'Wisconsin'),
('WY', 'Wyoming');

########################################################################################################
/* Creatinng 'countys'  table*/
CREATE TABLE countys (
  conum INT NOT NULL,
  co_name VARCHAR(100)  NULL,
  usps_code CHAR(2),
  PRIMARY KEY (conum),
  CONSTRAINT states_fk FOREIGN KEY(usps_code) REFERENCES states(usps_code)
);

/* Inserting data in table 'countys'*/
INSERT INTO countys(conum, co_name, usps_code)
SELECT conum, co_name, usps_code
FROM countys_name_online;


########################################################################################################
/* Creatinng 'type_gov'  table*/
CREATE TABLE type_gov(
  tg_id INT(1) NOT NULL,
  tg_name CHAR(5),
  tg_desc CHAR(50),
  PRIMARY KEY (tg_id)
);

/* Inserting data in table 'type_gov'*/
INSERT INTO type_gov(tg_id,tg_name, tg_desc)
VALUES(0, 'SDSS', 'State Dependent School System'), (1, 'CODSS', 'County Dependent School System'), (2, 'CDSS', 'City Dependent School System'), 
      (3, 'TDSS', 'Township Dependent School System'), (5, 'ISS', 'Independent School System');

########################################################################################################
/* Creatinng 'sch_levels'  table*/
CREATE TABLE sch_levels(
  sl_id INT(2) NOT NULL,
  sl_name CHAR(5),
  sl_desc CHAR(50),
  PRIMARY KEY (sl_id)
);

/* Inserting data in table 'sch_levels'*/
INSERT INTO sch_levels(sl_id,sl_name, sl_desc)
VALUES(01, 'ESSO', 'Elementary School System Only'), (02, 'SSSO', 'Secondary School System Only'), (03, 'ESSS', 'Elementary-Secondary School System '), 
      (05, 'VSESS', 'Vocational or Special Education School System'), (06, 'NSS', 'Nonoperating School System'), (07, 'ESA', 'Educational Service Agency ');

########################################################################################################
/* Creatinng 'districts'  table*/
CREATE TABLE districts (
  ncesid varchar(10) NOT NULL,
  idcensus VARCHAR(30) NOT NULL,
  dis_name CHAR(100),
  csa_id INT(3),
  cbsa_id INT(5),
  conum INT(10),
  sl_id INT(1),
  tg_id INT(2),
  PRIMARY KEY (ncesid),
  CONSTRAINT csa_fk FOREIGN KEY(csa_id) REFERENCES csa(csa_id),
  CONSTRAINT cbsa_fk FOREIGN KEY(cbsa_id) REFERENCES cbsa(cbsa_id),
  CONSTRAINT countys_fk FOREIGN KEY(conum) REFERENCES countys(conum),
  CONSTRAINT sch_levels_fk FOREIGN KEY(sl_id) REFERENCES sch_levels(sl_id),
  CONSTRAINT type_gov_fk FOREIGN KEY(tg_id) REFERENCES type_gov(tg_id)
);

/* Inserting data in table 'districts'*/
INSERT INTO districts(ncesid, idcensus, dis_name, csa_id, cbsa_id, conum, sl_id, tg_id )
SELECT DISTINCT NCESID,IDCENSUS, NAME, CSA, CBSA, CONUM, SCHLEV, SUBSTRING(IDCENSUS, 3,1)
FROM FCP_Dataset.full_dataset;
########################################################################################################

/* Creatinng 'memberships'  table*/
CREATE TABLE memberships(
  mem_id INT NOT NULL AUTO_INCREMENT,
  mem_num INT(6),
  mem_year INT(2) NOT NULL,
  PRIMARY KEY (mem_id),
  ncesid VARCHAR(30),
  CONSTRAINT districts_fk FOREIGN KEY(ncesid) REFERENCES districts(ncesid)
);

/* Inserting data in table 'memberships'*/

INSERT INTO memberships(mem_num, mem_year, ncesid)
SELECT V33, YRDATA, NCESID
FROM FCP_Dataset.full_dataset;
########################################################################################################

/* Creatinng 'rev_sources'  table*/
CREATE TABLE rev_sources(
  rs_id INT(2) NOT NULL,
  src_name CHAR(7),
  src_desc CHAR(50),
  PRIMARY KEY (rs_id)
);

/* Inserting data in table 'rev_sources'*/
INSERT INTO rev_sources(rs_id, src_name, src_desc)
VALUES(1, 'TFEDREV ', 'Total Revenue from Federal Sources'), (2, 'TSTREV ', 'Total Revenue from State Sources'), (3, 'TLOCREV', 'Total Revenue from Local Sources ');

########################################################################################################
/* Creatinng 'rev_types'  table*/
CREATE TABLE rev_types(
  rt_id INT NOT NULL AUTO_INCREMENT,
  rt_name VARCHAR(50),
  rt_desc VARCHAR(75),
  rt_code CHAR(50),
  rs_id INT(2),
  PRIMARY KEY (rt_id),
  CONSTRAINT rev_sources_fk FOREIGN KEY(rs_id) REFERENCES rev_sources(rs_id)
);

/* Inserting data in table 'rev_types'*/
INSERT INTO rev_types(rt_name, rt_desc, rt_code, rs_id)
VALUES('FRS-TI','Federal Revenue through the state- Title I','C14',1),('FRS-CD','Federal Revenue through the state- children with disabilities- IDEA','C15',1),
('FRS-MST','Federal Revenue through the state- Math, Science and teacher quality','C16',1),('FRS-TSDF','Federal Revenue through the state- Safe and drug-free schools','C17',1),
('FRS-VT','Federal Revenue through the state- Vocational and technical education','C19',1),('FRS-BE','Federal Revenue through the state-Bilingual education','B11',1),
('FRS-AO','Federal Revenue through the state- All other','C20',1),('FRS-CN','Federal Revenue through the state- Child nutrition programs', 'C25',1),
('FR-N','Federal Revenue- Non specified','C36',1),('DFR-IA','Direct federal revenue- Impact aid','B10',1),('DFR-NA','Direct federal revenue- Native American education','B12',1),
('DFR-A0','Direct federal revenue- All other','B13',1),

('GFA','General formula assistance','C01',2),('SIP','Staff improvement programs','C04',2),('SEP','Special education programs','C05',2),
('CBSAP','Compensatory and basic skills attainment programs','C06',2),('BEP','Bilingual education programs','C07',2),
('GTP','Gifted and talented programs','C08',2),('VEP','Vocational education programs','C09',2),('SLP','School lunch programs','C10',2),
('CODSP','Capital outlay and debt service programs','C11',2),('TP','Transportation programs','C12',2),('AORSS','All other revenue from state sources','C13',2),
('CS-NCES','Census state, NCES local revenue','C24',2),('SR-N','State revenue- unspecified','C35',2),('SPB-B','State paymemts on behalf- Benefits','C38',2),
('SPB-N','State paymemts on behalf- Nonbenefits','C39',2),


('PGC','Parent government contributions','T02',3),('PT','Property taxes','T06',3),('GSGRT','General sales or gross receipts taxes','T09',3),
('PUT','Public utility taxes','T15',3),('ICIT','Individual and corporate income taxes','T40',3),('AOT','All other taxes','T99',3),
('RFOSS','Revenue from other school systems','D11',3),('RFCC','Revenue from cities and counties','D23',3),('TFFPP','Tuition fees from pupils, parents and other private sources','A07',3),
('TFFPPO','Transportation fees from pupils, parents and other private sources','A08',3),
('SLR','School lunch revenues','A09',3),('TSR','Textbook sales and rentals','A11',3),('DAR','District activity receipts','A13',3),
('SF-N','Student fees , nonspecified','A15',3),('OSSR','Other sales and service revenues','A20',3),('RR','Rents and royalties','A40',3),
('SP','Sale of property','U11',3),('IE','Interest Earnings','U22',3),('FAF','Fines and forfeits','U30',3),('PC','Private contributions','U50',3),
('MOLR','Miscellaneous other local revenues','U97',3);

########################################################################################################################################
/* Creatinng 'revenue'  table*/
CREATE TABLE revenue(
  rev_id INT NOT NULL AUTO_INCREMENT,
  rt_id INT(2),
  ncesid varchar(10),
  rev_amount BIGINT(15),
  YEAR INT(2),
  PRIMARY KEY (rev_id),
  CONSTRAINT rev_stypes_fk FOREIGN KEY(rt_id) REFERENCES rev_types(rt_id),
  CONSTRAINT dis_rev_fk FOREIGN KEY(ncesid) REFERENCES districts(ncesid)
);

/* Inserting data in table 'revenue'*/
INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C14, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C14')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C15, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C15')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C16, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C16')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C17, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C17')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C19, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C19')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, B11, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'B11')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C20, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C20')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C25, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C25')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C36, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C36')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, B10, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'B10')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, B12, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'B12')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, B13, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'B13')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C01, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C01')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C04, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C04')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C05, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C05')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C06, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C06')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C07, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C07')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C14, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C14')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C08, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C08')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C09, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C09')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C10, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C10')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C11, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C11')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C12, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C12')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C13, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C13')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C24, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C24')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C35, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C35')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C38, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C38')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, C39, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'C39')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T02, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T02')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T06, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T06')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T09, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T09')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T15, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T15')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T40, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T40')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, T99, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'T99')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, D11, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'D11')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, D23, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'D23')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A07, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A07')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A08, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A08')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A09, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A09')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A11, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A11')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A13, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A13')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A15, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A15')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A20, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A20')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, A40, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'A40')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, U11, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'U11')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, U22, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'U22')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, U30, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'U30')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, U50, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'U50')
FROM FCP_Dataset.full_dataset;

INSERT INTO revenue(ncesid, rev_amount, year, rt_id)
SELECT NCESID, U97, YRDATA, (SELECT rt_id FROM rev_types WHERE rt_code = 'U97')
FROM FCP_Dataset.full_dataset;


########################################################################################################################################
/* Creatinng 'other_financials'  table*/
CREATE TABLE other_financials (
  of_id INT NOT NULL AUTO_INCREMENT,
  of_name CHAR(50),
  of_desc VARCHAR(150),
  of_code CHAR(50),
  PRIMARY KEY (of_id)
);


/* Inserting data 'other_financials'  table*/


INSERT INTO other_financials(of_name, of_desc, of_code)
VALUES ('TSW','Total salaries and wages','Z32'),
('TSWI','Total salaries and wages - Instruction','Z33'),
('TSW-PS','Total salaries and wages - Pupil support','V11'),
('TSWISS','Total salaries and wages - Instructional staff support','V13'),
('TSWGA','Total salaries and wages - General administration','V15'),
('TSWSA','Total salaries and wages - School administration','V17'),
('TSWOMP','Total salaries and wages - Operation and maintenance of plant','V21'),
('TSWST','Total salaries and wages - Student transportation','V23'),
('TSWBCSS','Total salaries and wages - Business/central/other support services','V37'),
('TSWFS','Total salaries and wages - Food services','V29'),
('TEBP','Total employee benefit payments','Z34'),
('TEBPI','Total employee benefit payments - Instruction','V10'),
('TEBPPS','Total employee benefit payments - Pupil support','V12'),
('TEBPIS','Total employee benefit payments - Instructional staff','V14'),
('TEBPGA','Total employee benefit payments - General administration','V16'),
('TEBPSA','Total employee benefit payments - School administration','V18'),
('TEBPI','Total employee benefit payments - Operation and maintenance of plant','V22'),
('TEBPST','Total employee benefit payments - Student transportation','V24'),
('TEBPBCSS','Total employee benefit payments - Business/central/other support services','V38'),
('TEBPFS','Total employee benefit payments - Food services','V30'),
('TEBPEO','Total employee benefit payments - Enterprise operations','V32'),
('LDOBFY','Long-term debt outstanding at beginning of the fiscal year','_19H'),
('LDIBFY','Long-term debt issued during the fiscal year','_21F'),
('LDIDFY','Long-term debt retired during the fiscal year','_31F'),
('LDOEFY','Long-term debt outstanding at end of fiscal year','_41F'),
('SDOBFY','Short-term debt outstanding at beginning of the fiscal year','_61V'),
('SDOEFY','Short-term debt outstanding at end of the fiscal year','_66V'),
('CDDSV','Cash and deposits, held at end of fiscal year - Debt service funds','W01'),
('CDBF','Cash and deposits, held at end of fiscal year - Bond funds','W31'),
('CDOF','Cash and deposits, held at end of fiscal year - Other funds','W61');


########################################################################################################################################

/* Creatinng 'district_financials'  table*/
CREATE TABLE district_financials(
  df_id INT NOT NULL AUTO_INCREMENT,
  of_id INT(2),
  ncesid varchar(10),
  df_amount BIGINT(15),
  YEAR INT(2),
  PRIMARY KEY (df_id),
  CONSTRAINT other_financials_fk FOREIGN KEY(of_id) REFERENCES other_financials(of_id),
  CONSTRAINT dist_finan_fk FOREIGN KEY(ncesid) REFERENCES districts(ncesid)
);

/* Inserting data into 'districts_financials'  table*/

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, L12, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'L12')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, M12, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'M12')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, Q11, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'Q11')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, I86, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'I86')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, Z32, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'Z32')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, Z33, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'Z33')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V11, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V11')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V13, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V13')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V15, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V15')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V17, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V17')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V21, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V21')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V23, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V23')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V37, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V37')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V29, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V29')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, Z34, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'Z34')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V10, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V10')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V12, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V12')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V14, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V14')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V16, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V16')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V18, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V18')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V22, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V22')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V24, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V24')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V38, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V38')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, V30, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'V30')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _19H, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_19H')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _21F, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_21F')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _31F, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_31F')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _41F, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_41F')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _61V, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_61V')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, _66V, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = '_66V')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, W01, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'W01')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, W31, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'W31')
FROM FCP_Dataset.full_dataset;

INSERT INTO district_financials(ncesid, df_amount, year, of_id)
SELECT NCESID, W61, YRDATA, (SELECT of_id FROM other_financials WHERE of_code = 'W61')
FROM FCP_Dataset.full_dataset;

########################################################################################################################################
/* Creatinng 'exp_categorys'  table*/
CREATE TABLE exp_categorys(
  ec_id INT(2) NOT NULL,
  ec_desc VARCHAR(150),
  ec_code CHAR(50),
  parent_ec_id INT(2),
  CONSTRAINT exp_categorys FOREIGN KEY(parent_ec_id) REFERENCES exp_categorys(ec_id),
  PRIMARY KEY (ec_id)
);

/* Inserting data into 'exp_categorys'  table*/
INSERT INTO exp_categorys(ec_id, ec_code, ec_desc, parent_ec_id)
VALUES(1, 'TOTALEXP', 'TOTAL ELEMENTARY-SECONDARY EXPENDITURE',1), 
(2, 'TCURELSC', 'TOTAL CURRENT SPENDING FOR ELEMENTARY-SECONDARY PROGRAMS',1), 
(3, 'TCURINST ', 'TOTAL CURRENT SPENDING FOR INSTRUCTIONs',2), 
(4, 'TCURSSVC ', 'TOTAL CURRENT SPENDING FOR SUPPORT SERVICES',2), 
(5, 'TCUROTH', 'TOTAL CURRENT SPENDING FOR OTHER ELEMENTARYSECONDARY PROGRAMS',2),
(6, 'NONELSEC', 'TOTAL CURRENT SPENDING FOR NONELEMENTARY-SECONDARY PROGRAMS',1),
(7, 'TCAPOUT', 'TOTAL CAPITAL OUTLAY EXPENDITURE',1),
(8, 'MISCOUT', 'MISCELLANEOUS EXPENDITURE',1);


########################################################################################################
/* Creatinng 'exp_types'  table*/
CREATE TABLE exp_types(
  et_id INT NOT NULL AUTO_INCREMENT,
  et_desc VARCHAR(75),
  et_code CHAR(50),
  ec_id INT(2),
  PRIMARY KEY (et_id),
  CONSTRAINT exp_categorys_fk FOREIGN KEY(ec_id) REFERENCES exp_categorys(ec_id)
);

/*Inserting data into 'exp_types'  table*/
INSERT INTO exp_types(et_desc, et_code, ec_id)
VALUES('Current operation expenditure - Instruction','E13',3),
      ('State payments on behalf - Instruction benefits','J13',3),
      ('Own retirement system transfer - Instruction','J12',3),
      ('State payments on behalf - Instruction nonbenefits','J14',3),
      ('Exhibit - Payments to private schools','V91',3),
      ('Exhibit - Payments to charter schools','V92',3),
      
      
      ('Current operation expenditure - Pupil support','E17',4),
      ('Current operation expenditure - Instructional staff support','E07',4),
      ('Current operation expenditure - General administration','E08',4),
      ('Current operation expenditure - School administration','E09',4),
      ('Current operation expenditure - Operation and maintenance of plant','V40',4),
      ('Current operation expenditure - Business/central/other support services','V90',4),
      ('Current operation expenditure - Nonspecified support services','V85',4),
      ('State payments on behalf - Pupil support benefits','J17',4),
      ('State payments on behalf - Instructional staff support benefits','J07',4),
      ('State payments on behalf - General administration benefits','J08',4),
      ('State payments on behalf - School administration benefits','J09',4),
      ('State payments on behalf - Operation and maintenance of plant benefits','J40',4),
      ('State payments on behalf - Student transportation benefits','J45',4),
      ('State payments on behalf - Business/central/other support services benefits','J90',4),
      ('Own retirement system transfer - Support services','J11',4),
      ('State payments on behalf - Support services, nonbenefits','J96',4),
      
      
	  ('Current operation expenditure - Food services','E11',5),
      ('Current operation expenditure - Enterprise operations','V60',5),
      ('Current operation expenditure - Other elementary-secondary programs','V65',5),
      ('State payments on behalf - Other benefits','J10',5),
      ('State payments on behalf - Noninstructional and nonbenefits','J97',5),
      
      
	  ('Current operation expenditure - Community services','V70',6),
	  ('Current operation expenditure - Adult education','V75',6),
	  ('Current operation expenditure - Other nonelementary-secondary programs','V80',6),
	  ('State payments on behalf - Nonelementary-secondary programs','J98',6),
      
      
	  ('Construction','F12',7),
	  ('Purchase of land and existing structures','G15',7),
	  ('Instructional equipment','K09',7),
	  ('Other equipment','K10',7),
	  ('Nonspecified equipmen','K11',7),
	  ('State payments on behalf - Capital outlay','J99',7),
      
      ('Payments to state governments','L12',8),
      ('Payments to local governments','M12',8),
      ('Payments to other school systems','Q11',8),
      ('Interest on school system debt','I86',8);
      
         
########################################################################################################
/* Creatinng 'expenditure'  table*/
CREATE TABLE expenditure(
  exp_id INT NOT NULL AUTO_INCREMENT,
  et_id INT(2),
  ncesid varchar(10),
  exp_amount BIGINT(15),
  YEAR INT(2),
  PRIMARY KEY (exp_id),
  CONSTRAINT exp_types_fk FOREIGN KEY(et_id) REFERENCES exp_types(et_id),
  CONSTRAINT dis_exp_fk FOREIGN KEY(ncesid) REFERENCES districts(ncesid)
);

/* Inserting data into'expenditure'  table*/

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E13, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E13')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J13, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J13')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J12, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J12')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J14, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J14')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V91, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V91')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V92, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V92')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E17, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E17')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E07, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E07')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E08, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E08')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E09, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E09')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V40, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V40')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V45, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V45')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V90, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V90')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V85, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V85')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J17, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J17')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J07, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J07')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J08, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J08')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J09, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J09')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J40, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J40')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J45, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J45')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J90, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J90')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J11, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J11')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J96, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J96')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, E11, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'E11')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V60, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V60')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V65, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V65')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J10, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J10')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J97, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J97')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V70, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V70')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V75, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V75')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, V80, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'V80')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J98, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J98')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, F12, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'F12')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, G15, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'G15')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, K09, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'K09')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, K10, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'K10')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, K11, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'K11')
FROM FCP_Dataset.full_dataset;

INSERT INTO expenditure(ncesid, exp_amount, year, et_id)
SELECT NCESID, J99, YRDATA, (SELECT et_id FROM exp_types WHERE et_code = 'J99')
FROM FCP_Dataset.full_dataset;





