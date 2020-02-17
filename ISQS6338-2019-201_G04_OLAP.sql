/***********************************************************************************************
 ***********************************************************************************************
  Author:	Dinesh Poudel, Anurag Sharma, Khaza Towfik Akbar & Luciano Vecchio
  Date:		08-09-2019
  Title:	Statement examples for creating and populating the OLTP database for the ISQS 6338 Final
			Course Project (FCP).
************************************************************************************************
************************************************************************************************/
# create county_state dimension table
CREATE TABLE 201_G04_OLAP.dim_county_state (
  co_id INT NOT NULL AUTO_INCREMENT,
  conum CHAR(5) NOT NULL UNIQUE,
  co_name VARCHAR(50) NULL,
  state_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (co_id));


# insert county_state dimension table data
INSERT INTO 201_G04_OLAP.dim_county_state (conum,co_name, state_name)
	SELECT DISTINCT c.conum, c.co_name, s.st_name
    FROM 201_G04_OLTP.countys c
    LEFT JOIN 201_G04_OLTP.states s ON c.usps_code = s.usps_code;
    
     /*************************************************************************************************/
 /* Creatinng dim_meberships'  table*/
CREATE TABLE dim_memberships(
  mem_id INT NOT NULL AUTO_INCREMENT,
  mem_num INT(6),
  mem_year INT(2) NOT NULL,
  ncesid VARCHAR(30),
  PRIMARY KEY (mem_id));

/* Inserting data in dim_membership table'*/

INSERT INTO dim_memberships(mem_num, mem_year, ncesid)
SELECT mem_num, mem_year, ncesid
FROM 201_G04_OLTP.memberships;

/*************************************************************************************************/
# create school_districts dimension table
CREATE TABLE 201_G04_OLAP.dim_school_districts (
  districtID INT(5) NOT NULL AUTO_INCREMENT,
  ncesid CHAR(7) NOT NULL UNIQUE,
  idcensus CHAR(14),
  dis_name VARCHAR(100) NULL,
  csa INT(5) NULL,
  cbsa INT(5) NULL,
  sl_id INT(5) NULL,
  tg_id INT(5) NULL,
  sl_name CHAR(50) NULL,
  gov_name CHAR(50) NULL,
  conum CHAR(5) NOT NULL,
  PRIMARY KEY (districtID),
  CONSTRAINT school_districts_fk FOREIGN KEY(conum)
  REFERENCES 201_G04_OLAP.dim_county_state(conum));

# insert school_districts dimension table data
INSERT INTO 201_G04_OLAP.dim_school_districts (ncesid,idcensus,dis_name,csa, cbsa, sl_id, tg_id, sl_name, gov_name, conum)
	SELECT d.ncesid, d.idcensus, d.dis_name,cs.csa_id, cb.cbsa_id, sl.sl_id, tg.tg_id, sl.sl_name, tg.tg_desc, d.conum
	FROM 201_G04_OLTP.districts d
    LEFT JOIN 201_G04_OLTP.cbsa cb ON d.cbsa_id= cb.cbsa_id
    LEFT JOIN 201_G04_OLTP.csa cs ON d.csa_id= cs.csa_id
    LEFT JOIN 201_G04_OLTP.sch_levels sl ON d.sl_id= sl.sl_id
    LEFT JOIN 201_G04_OLTP.type_gov tg ON d.tg_id= tg.tg_id;
 /*************************************************************************************************/  
 
# create rev_type_sources dimension table
CREATE TABLE 201_G04_OLAP.dim_rev_type_sources (
  rt_id INT NOT NULL AUTO_INCREMENT,
  rt_name VARCHAR(150) NULL,
  rt_desc TEXT NULL,
  rt_code CHAR (4),
  src_name CHAR(7),
  src_desc CHAR(50),
  PRIMARY KEY (rt_id));
  
  
  
# insert rev_type_sources dimension table data
INSERT INTO 201_G04_OLAP.dim_rev_type_sources (rt_name, rt_desc, rt_code, src_name, src_desc)
	SELECT rt.rt_name, rt.rt_desc, rt.rt_code, rs.src_name, rs.src_desc
	FROM 201_G04_OLTP.rev_types rt
    LEFT JOIN 201_G04_OLTP.rev_sources rs ON rt.rs_id= rs.rs_id;
    
/*************************************************************************************************/ 
# create year dimension table
CREATE TABLE 201_G04_OLAP.dim_year (
  y_id INT NOT NULL AUTO_INCREMENT,
  year_name INT(2),
  PRIMARY KEY (y_id));
  
# insert year dimension data table
INSERT INTO 201_G04_OLAP.dim_year (year_name)
VALUES(10),(11),(12), (13),(14),(15),(16);
########################################################################################################
 # create fact_revenue table
CREATE TABLE 201_G04_OLAP.fact_revenue (
  rev_id INT NOT NULL AUTO_INCREMENT,
  rt_id INT,
  y_id INT,
  ncesid CHAR(7),
  rev_amount INT NULL,
  mem_id INT(11) NULL,
  PRIMARY KEY(rev_id),
  CONSTRAINT rev_revtyp_fk FOREIGN KEY(rt_id)
	REFERENCES 201_G04_OLAP.dim_rev_type_sources(rt_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    
  CONSTRAINT rev_dis_fk FOREIGN KEY(ncesid)
	REFERENCES 201_G04_OLAP.dim_school_districts(ncesid)
    ON DELETE CASCADE ON UPDATE CASCADE,
    
  CONSTRAINT year_fk FOREIGN KEY(y_id)
	REFERENCES 201_G04_OLAP.dim_year(y_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    
    CONSTRAINT membership_fk FOREIGN KEY(mem_id)
	REFERENCES 201_G04_OLAP.dim_memberships(mem_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION);
    
 SET FOREIGN_KEY_CHECKS = 0;
 
# insert fact_revenue data
INSERT INTO 201_G04_OLAP.fact_revenue(rt_id, y_id, ncesid, rev_amount, mem_id)
SELECT r.rt_id, r.YEAR, r.ncesid, r.rev_amount, (SELECT mem_id FROM 201_G04_OLTP.memberships ms WHERE r.ncesid=ms.ncesid AND  r.YEAR=ms.mem_year)
FROM 201_G04_OLTP.revenue r;

 /*************************************************************************************************/ 
    
    

 
 
    
  






    
    
    
    
    
    
    
    
    
    
    
    
    
    