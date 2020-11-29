-- Labs2018 Schema Script 
--    NAME
--     labs2018engv5.sql - Create data objects for labs2018 schema
--
--    DESCRIPTION
--      This creates a modified department Store schema including 
--      deliveryitem, Saleitem event tables
--      It is a combination of   
--      labs2018v6 and labs2018rowsv3
--    NOTES
--
--    CREATED by Greg Wadley, David Eccles
--
--    MODIFIED   (MM/DD/YY)
--    farah       07/25/19 - upper case SQL keywords
--    farah		    07/09/19 - updated the names of variables to be consistent
--    deccles     02/21/19 - removed back quotes to remove camel case compliance
--    deccles     02/23/18 - corrected typos and db
--    deccles     02/12/18 - readded FK & remerged row insert
--    deccles     02/12/18 - version 5 DDL updates incorporated
--    deccles     02/08/18 - merged schema and row insert scripts 
--    deccles     01/24/18 - fixed ref integrity errors
--    deccles     01/18/18 - modified for event tables attributes
--    gwadley     12/14/17 - gwadley created the revised ER Model


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Schema labs2018
-- UNCOMMENT the following section for BYOD installs
-- -----------------------------------------------------
-- DROP SCHEMA IF EXISTS labs2018 ;
-- CREATE SCHEMA IF NOT EXISTS labs2018 DEFAULT CHARACTER SET utf8 ;

-- USE labs2018 ;
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table supplier
-- -----------------------------------------------------
DROP TABLE IF EXISTS supplier ;

CREATE TABLE IF NOT EXISTS supplier (
  SupplierID SMALLINT(6) NOT NULL,
  Name VARCHAR(25) NOT NULL,
  Phone CHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (SupplierID))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table delivery
-- -----------------------------------------------------
DROP TABLE IF EXISTS delivery ;

CREATE TABLE IF NOT EXISTS delivery (
  DeliveryID INT(11) NOT NULL,
  SupplierID SMALLINT(6) NOT NULL,
  DeliveryDate DATE NOT NULL,
  PRIMARY KEY (DeliveryID),
  INDEX SupplierID (SupplierID ASC),
  CONSTRAINT fk_delivery_supplier
    FOREIGN KEY (SupplierID)
    REFERENCES supplier (SupplierID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table item
-- -----------------------------------------------------
DROP TABLE IF EXISTS item ;

CREATE TABLE IF NOT EXISTS item (
  ItemID SMALLINT(6) NOT NULL DEFAULT '0',
  Name VARCHAR(50) NOT NULL,
  Type CHAR(1) NOT NULL,
  Colour VARCHAR(20) NULL DEFAULT NULL,
  ItemPrice DECIMAL(9,2) NULL DEFAULT NULL,
  PRIMARY KEY (ItemID))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table employee
-- -----------------------------------------------------
DROP TABLE IF EXISTS employee ;

CREATE TABLE IF NOT EXISTS employee (
  EmployeeID SMALLINT(6) NOT NULL DEFAULT '0',
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Salary DECIMAL(8,2) NULL DEFAULT NULL,
  DepartmentID SMALLINT(6) NOT NULL,
  BossID SMALLINT(6) NULL DEFAULT NULL,
  DateOfBirth DATE NULL DEFAULT NULL,
  PRIMARY KEY (EmployeeID),
  INDEX DepartmentID (DepartmentID ASC),
  INDEX fk_employee_employee1_idx (BossID ASC),
  CONSTRAINT fk_employee_employee1
    FOREIGN KEY (EmployeeID)
    REFERENCES employee (BossID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table department
-- -----------------------------------------------------
DROP TABLE IF EXISTS department ;

CREATE TABLE IF NOT EXISTS department (
  DepartmentID SMALLINT(6) NOT NULL DEFAULT '0',
  Name VARCHAR(50) NOT NULL,
  Floor TINYINT(4) NOT NULL,
  Phone CHAR(10) NULL DEFAULT NULL,
  ManagerID SMALLINT(6) NULL DEFAULT NULL,
  PRIMARY KEY (DepartmentID),
  INDEX ManagerID (ManagerID ASC),
  CONSTRAINT fk_department_employee1
    FOREIGN KEY (ManagerID)
    REFERENCES employee (EmployeeID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_department_employee2
    FOREIGN KEY (DepartmentID)
    REFERENCES employee (DepartmentID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table deliveryitem
-- -----------------------------------------------------
DROP TABLE IF EXISTS deliveryitem ;

CREATE TABLE IF NOT EXISTS deliveryitem (
  DeliveryId INT(11) NOT NULL,
  ItemID SMALLINT(6) NOT NULL,
  DepartmentID SMALLINT(6) NOT NULL,
  Quantity TINYINT(4) NOT NULL,
  WholesalePrice DECIMAL(9,2) NULL DEFAULT NULL,
  PRIMARY KEY (DeliveryId, ItemID, DepartmentID),
  INDEX fk_deliveryitem_item1_idx (ItemID ASC),
  INDEX fk_deliveryitem_department1_idx (DepartmentID ASC),
  CONSTRAINT fk_deliveryitem_delivery1
    FOREIGN KEY (DeliveryId)
    REFERENCES delivery (DeliveryID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_deliveryitem_item1
    FOREIGN KEY (ItemID)
    REFERENCES item (ItemID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_deliveryitem_department1
    FOREIGN KEY (DepartmentID)
    REFERENCES department (DepartmentID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table sale
-- -----------------------------------------------------
DROP TABLE IF EXISTS sale ;

CREATE TABLE IF NOT EXISTS sale (
  SaleID INT(11) NOT NULL,
  DepartmentID SMALLINT(6) NOT NULL,
  SaleDate DATE NOT NULL,
  PRIMARY KEY (SaleID),
  INDEX DepartmentID (DepartmentID ASC),
  CONSTRAINT fk_sale_department1
    FOREIGN KEY (DepartmentID)
    REFERENCES department (DepartmentID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table saleitem
-- -----------------------------------------------------
DROP TABLE IF EXISTS saleitem ;

CREATE TABLE IF NOT EXISTS saleitem (
  SaleId INT(11) NOT NULL,
  ItemID SMALLINT(6) NOT NULL,
  Quantity TINYINT(4) NOT NULL,
  PRIMARY KEY (SaleId, ItemID),
  INDEX fk_Saleitem_item1_idx (ItemID ASC),
  CONSTRAINT fk_saleitem_item1
    FOREIGN KEY (ItemID)
    REFERENCES item (ItemID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_saleitem_sale1
    FOREIGN KEY (SaleId)
    REFERENCES sale (SaleID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

COMMIT;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- labs2018rows 
-- add rows

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- supplier labs2018

INSERT INTO supplier VALUES (101,'Global Books & Maps',55240007);
INSERT INTO supplier VALUES (102,'Nepalese Corp.',55244552);
INSERT INTO supplier VALUES (103,'All Sports Manufacturing',55478252);
INSERT INTO supplier VALUES (104,'Sweatshops Unlimited',55244500);
INSERT INTO supplier VALUES (105,'All Points_ Inc.',54585252);
INSERT INTO supplier VALUES (106,'Sao Paulo Manufacturing',54572755);

-- delivery labs2018
INSERT INTO delivery VALUES (11,101,'2017-03-03');
INSERT INTO delivery VALUES (12,102,'2017-03-14');
INSERT INTO delivery VALUES (13,104,'2017-03-25');
INSERT INTO delivery VALUES (14,103,'2017-04-05');
INSERT INTO delivery VALUES (15,105,'2017-04-16');
INSERT INTO delivery VALUES (16,106,'2017-04-27');
INSERT INTO delivery VALUES (17,102,'2017-05-08');
INSERT INTO delivery VALUES (18,101,'2017-05-19');
INSERT INTO delivery VALUES (19,106,'2017-05-30');
INSERT INTO delivery VALUES (20,103,'2017-06-10');
INSERT INTO delivery VALUES (21,105,'2017-06-21');
INSERT INTO delivery VALUES (22,106,'2017-07-02');
INSERT INTO delivery VALUES (23,102,'2017-07-13');
INSERT INTO delivery VALUES (24,106,'2017-07-24');
INSERT INTO delivery VALUES (25,105,'2017-08-04');
INSERT INTO delivery VALUES (26,101,'2017-08-15');


-- employee labs2018
INSERT INTO employee VALUES (1,'Alice','Munro',125000,1,NULL,'1966-12-14');
INSERT INTO employee VALUES (2,'Ned','Kelly',85000,11,1,'1970-07-16');
INSERT INTO employee VALUES (3,'Andrew','Jackson',55000,11,2,'1958-04-01');
INSERT INTO employee VALUES (4,'Clare','Underwood',52000,11,2,'1982-09-22');
INSERT INTO employee VALUES (5,'Todd','Beamer',68000,8,1,'1965-05-24');
INSERT INTO employee VALUES (6,'Nancy','Cartwright',52000,8,5,'1993-04-11');
INSERT INTO employee VALUES (7,'Brier','Patch',73000,9,1,'1981-10-16');
INSERT INTO employee VALUES (8,'Sarah','Fergusson',86000,9,7,'1978-11-15');
INSERT INTO employee VALUES (9,'Sophie','Monk',75000,10,1,'1986-12-15');
INSERT INTO employee VALUES (10,'Sanjay','Patel',45000,6,3,'1984-01-28');
INSERT INTO employee VALUES (11,'Rita','Skeeter',45000,2,4,'1988-02-22');
INSERT INTO employee VALUES (12,'Gigi','Montez',46000,3,4,'1992-03-20');
INSERT INTO employee VALUES (13,'Maggie','Smith',46000,3,4,'1991-04-29');
INSERT INTO employee VALUES (14,'Paul','Innit ',41000,4,3,'1998-06-02');
INSERT INTO employee VALUES (15,'James','Mason',45000,4,3,'1995-07-30');
INSERT INTO employee VALUES (16,'Pat','Clarkson',45000,5,3,'1997-08-28');
INSERT INTO employee VALUES (17,'Mark','Zhang',45000,7,3,'1996-10-01');

-- department labs2018
INSERT INTO department VALUES (1,'Management',5,34,1);
INSERT INTO department VALUES (2,'Books',1,81,4);
INSERT INTO department VALUES (3,'Clothes',2,24,4);
INSERT INTO department VALUES (4,'Equipment',3,57,3);
INSERT INTO department VALUES (5,'Furniture',4,14,3);
INSERT INTO department VALUES (6,'Navigation',1,41,3);
INSERT INTO department VALUES (7,'Recreation',2,29,4);
INSERT INTO department VALUES (8,'Accounting',5,35,5);
INSERT INTO department VALUES (9,'Purchasing',5,36,7);
INSERT INTO department VALUES (10,'Personnel',5,37,9);
INSERT INTO department VALUES (11,'Marketing',5,38,2);

-- deliveryitem labs2018
INSERT INTO deliveryitem VALUES (11,3,6,4,12.5);
INSERT INTO deliveryitem VALUES (11,6,6,2,53);
INSERT INTO deliveryitem VALUES (11,10,6,3,11);
INSERT INTO deliveryitem VALUES (11,11,6,10,4);
INSERT INTO deliveryitem VALUES (11,17,6,19,4);
INSERT INTO deliveryitem VALUES (12,3,2,2,13);
INSERT INTO deliveryitem VALUES (12,3,6,4,13);
INSERT INTO deliveryitem VALUES (12,5,2,8,9);
INSERT INTO deliveryitem VALUES (12,5,6,8,9);
INSERT INTO deliveryitem VALUES (12,5,7,8,9);
INSERT INTO deliveryitem VALUES (12,6,6,4,53);
INSERT INTO deliveryitem VALUES (12,9,2,8,11);
INSERT INTO deliveryitem VALUES (12,9,6,2,10);
INSERT INTO deliveryitem VALUES (12,9,7,2,11);
INSERT INTO deliveryitem VALUES (12,10,6,5,11);
INSERT INTO deliveryitem VALUES (12,11,6,10,4);
INSERT INTO deliveryitem VALUES (12,12,6,8,93);
INSERT INTO deliveryitem VALUES (12,13,6,4,26);
INSERT INTO deliveryitem VALUES (12,14,7,3,12);
INSERT INTO deliveryitem VALUES (12,15,4,1,21);
INSERT INTO deliveryitem VALUES (12,16,4,3,22);
INSERT INTO deliveryitem VALUES (12,17,2,8,4);
INSERT INTO deliveryitem VALUES (12,17,3,15,4);
INSERT INTO deliveryitem VALUES (12,17,4,12,4);
INSERT INTO deliveryitem VALUES (12,17,5,15,4);
INSERT INTO deliveryitem VALUES (12,17,6,17,4);
INSERT INTO deliveryitem VALUES (12,19,7,37,148);
INSERT INTO deliveryitem VALUES (13,12,3,8,95);
INSERT INTO deliveryitem VALUES (13,17,6,23,3.75);
INSERT INTO deliveryitem VALUES (14,3,4,8,13.25);
INSERT INTO deliveryitem VALUES (14,6,2,2,53);
INSERT INTO deliveryitem VALUES (14,11,6,10,4);
INSERT INTO deliveryitem VALUES (14,12,3,4,94);
INSERT INTO deliveryitem VALUES (14,17,2,1,4);
INSERT INTO deliveryitem VALUES (15,1,3,4,87);
INSERT INTO deliveryitem VALUES (15,8,3,20,13);
INSERT INTO deliveryitem VALUES (15,12,3,4,88);
INSERT INTO deliveryitem VALUES (15,14,3,3,15);
INSERT INTO deliveryitem VALUES (15,22,3,6,80);
INSERT INTO deliveryitem VALUES (15,23,3,8,59);
INSERT INTO deliveryitem VALUES (15,24,3,3,107);
INSERT INTO deliveryitem VALUES (15,25,3,5,111);
INSERT INTO deliveryitem VALUES (16,12,4,5,95);
INSERT INTO deliveryitem VALUES (16,14,4,4,16);
INSERT INTO deliveryitem VALUES (16,17,4,5,4);
INSERT INTO deliveryitem VALUES (12,20,7,5,291);
INSERT INTO deliveryitem VALUES (12,21,7,2,237);
INSERT INTO deliveryitem VALUES (17,5,2,8,9);
INSERT INTO deliveryitem VALUES (17,5,7,1,9);
INSERT INTO deliveryitem VALUES (17,9,2,2,11);
INSERT INTO deliveryitem VALUES (17,9,7,2,11);
INSERT INTO deliveryitem VALUES (18,3,6,4,12.5);
INSERT INTO deliveryitem VALUES (18,6,6,4,53);
INSERT INTO deliveryitem VALUES (18,10,6,2,11);
INSERT INTO deliveryitem VALUES (18,11,6,10,4);
INSERT INTO deliveryitem VALUES (19,12,4,5,95);
INSERT INTO deliveryitem VALUES (19,14,4,4,15);
INSERT INTO deliveryitem VALUES (19,17,4,12,4);
INSERT INTO deliveryitem VALUES (20,6,2,1,53);
INSERT INTO deliveryitem VALUES (21,8,3,15,13.5);
INSERT INTO deliveryitem VALUES (22,14,4,4,14);
INSERT INTO deliveryitem VALUES (23,5,2,8,9);
INSERT INTO deliveryitem VALUES (23,5,6,2,9);
INSERT INTO deliveryitem VALUES (23,5,7,1,9);
INSERT INTO deliveryitem VALUES (24,12,4,5,95);
INSERT INTO deliveryitem VALUES (24,14,4,4,13);
INSERT INTO deliveryitem VALUES (24,17,4,14,4);
INSERT INTO deliveryitem VALUES (25,1,3,2,91);
INSERT INTO deliveryitem VALUES (25,2,4,1,702);
INSERT INTO deliveryitem VALUES (25,3,4,1,14);
INSERT INTO deliveryitem VALUES (25,8,3,20,14.5);
INSERT INTO deliveryitem VALUES (25,12,2,1,88);
INSERT INTO deliveryitem VALUES (25,12,3,2,88);
INSERT INTO deliveryitem VALUES (25,12,4,10,88);
INSERT INTO deliveryitem VALUES (25,12,5,1,88);
INSERT INTO deliveryitem VALUES (25,12,6,2,88);
INSERT INTO deliveryitem VALUES (25,17,4,5,4);
INSERT INTO deliveryitem VALUES (25,14,2,1,15);
INSERT INTO deliveryitem VALUES (25,14,3,2,14);
INSERT INTO deliveryitem VALUES (25,14,4,4,13);
INSERT INTO deliveryitem VALUES (25,14,5,9,13);
INSERT INTO deliveryitem VALUES (25,14,6,3,14);
INSERT INTO deliveryitem VALUES (25,14,7,1,15);
INSERT INTO deliveryitem VALUES (25,18,3,47,8);
INSERT INTO deliveryitem VALUES (25,22,3,2,80);
INSERT INTO deliveryitem VALUES (25,23,3,2,59);
INSERT INTO deliveryitem VALUES (25,24,3,1,107);
INSERT INTO deliveryitem VALUES (25,25,3,5,111);
INSERT INTO deliveryitem VALUES (26,3,6,6,12.5);
INSERT INTO deliveryitem VALUES (26,5,6,2,9);
INSERT INTO deliveryitem VALUES (26,6,6,3,53);
INSERT INTO deliveryitem VALUES (26,9,6,2,10);
INSERT INTO deliveryitem VALUES (26,10,6,2,11);
INSERT INTO deliveryitem VALUES (26,11,6,10,4);
INSERT INTO deliveryitem VALUES (26,13,6,4,26);
INSERT INTO deliveryitem VALUES (26,17,6,6,4);
INSERT INTO deliveryitem VALUES (26,17,2,1,4);


-- sale labs2018
INSERT INTO sale VALUES (100,7,'2017-08-19');
INSERT INTO sale VALUES (110,6,'2017-08-25');
INSERT INTO sale VALUES (120,2,'2017-08-30');
INSERT INTO sale VALUES (130,6,'2017-09-05');
INSERT INTO sale VALUES (140,5,'2017-09-15');
INSERT INTO sale VALUES (150,3,'2017-09-17');
INSERT INTO sale VALUES (160,6,'2017-09-25');
INSERT INTO sale VALUES (170,4,'2017-10-08');
INSERT INTO sale VALUES (180,4,'2017-10-09');
INSERT INTO sale VALUES (190,5,'2017-10-12');
INSERT INTO sale VALUES (230,2,'2017-10-13');
INSERT INTO sale VALUES (200,3,'2017-10-13');
INSERT INTO sale VALUES (220,3,'2017-10-13');
INSERT INTO sale VALUES (240,6,'2017-10-13');
INSERT INTO sale VALUES (210,6,'2017-10-13');
INSERT INTO sale VALUES (250,7,'2017-10-14');
INSERT INTO sale VALUES (260,7,'2017-10-15');
INSERT INTO sale VALUES (270,4,'2017-10-17');
INSERT INTO sale VALUES (280,3,'2017-10-18');
INSERT INTO sale VALUES (290,2,'2017-10-20');
INSERT INTO sale VALUES (300,6,'2017-10-22');
INSERT INTO sale VALUES (310,7,'2017-10-24');
INSERT INTO sale VALUES (330,2,'2017-10-25');
INSERT INTO sale VALUES (320,7,'2017-10-25');
INSERT INTO sale VALUES (340,2,'2017-10-26');
INSERT INTO sale VALUES (350,3,'2017-10-27');
INSERT INTO sale VALUES (360,3,'2017-10-28');
INSERT INTO sale VALUES (370,4,'2017-10-29');
INSERT INTO sale VALUES (380,6,'2017-11-04');
INSERT INTO sale VALUES (390,4,'2017-11-15');
INSERT INTO sale VALUES (400,2,'2017-11-23');
INSERT INTO sale VALUES (410,6,'2017-11-24');
INSERT INTO sale VALUES (420,6,'2017-11-27');
INSERT INTO sale VALUES (430,5,'2017-12-04');
INSERT INTO sale VALUES (440,6,'2017-12-07');
INSERT INTO sale VALUES (450,6,'2017-12-07');
INSERT INTO sale VALUES (460,6,'2017-12-10');
INSERT INTO sale VALUES (480,3,'2017-12-14');
INSERT INTO sale VALUES (470,4,'2017-12-14');
INSERT INTO sale VALUES (490,7,'2017-12-14');
INSERT INTO sale VALUES (500,3,'2017-12-16');
INSERT INTO sale VALUES (510,5,'2017-12-18');
INSERT INTO sale VALUES (520,6,'2017-12-20');

-- saleitem labs2018
INSERT INTO saleitem VALUES (100,14,1);
INSERT INTO saleitem VALUES (100,20,1);
INSERT INTO saleitem VALUES (110,6,1);
INSERT INTO saleitem VALUES (110,17,3);
INSERT INTO saleitem VALUES (120,5,1);
INSERT INTO saleitem VALUES (120,9,1);
INSERT INTO saleitem VALUES (130,6,1);
INSERT INTO saleitem VALUES (130,12,2);
INSERT INTO saleitem VALUES (140,12,1);
INSERT INTO saleitem VALUES (140,17,1);
INSERT INTO saleitem VALUES (150,14,1);
INSERT INTO saleitem VALUES (150,17,2);
INSERT INTO saleitem VALUES (150,22,1);
INSERT INTO saleitem VALUES (160,17,2);
INSERT INTO saleitem VALUES (170,3,2);
INSERT INTO saleitem VALUES (170,12,1);
INSERT INTO saleitem VALUES (170,14,1);
INSERT INTO saleitem VALUES (180,3,1);
INSERT INTO saleitem VALUES (180,12,1);
INSERT INTO saleitem VALUES (190,14,1);
INSERT INTO saleitem VALUES (190,17,1);
INSERT INTO saleitem VALUES (200,8,2);
INSERT INTO saleitem VALUES (200,14,1);
INSERT INTO saleitem VALUES (200,17,2);
INSERT INTO saleitem VALUES (200,18,3);
INSERT INTO saleitem VALUES (200,25,1);
INSERT INTO saleitem VALUES (210,14,1);
INSERT INTO saleitem VALUES (220,8,1);
INSERT INTO saleitem VALUES (220,14,1);
INSERT INTO saleitem VALUES (220,17,2);
INSERT INTO saleitem VALUES (220,18,1);
INSERT INTO saleitem VALUES (220,23,1);
INSERT INTO saleitem VALUES (220,24,1);
INSERT INTO saleitem VALUES (230,1,1);
INSERT INTO saleitem VALUES (230,5,1);
INSERT INTO saleitem VALUES (230,6,1);
INSERT INTO saleitem VALUES (230,9,1);
INSERT INTO saleitem VALUES (230,17,1);
INSERT INTO saleitem VALUES (240,3,1);
INSERT INTO saleitem VALUES (240,10,1);
INSERT INTO saleitem VALUES (240,17,4);
INSERT INTO saleitem VALUES (250,19,1);
INSERT INTO saleitem VALUES (260,19,1);
INSERT INTO saleitem VALUES (260,21,1);
INSERT INTO saleitem VALUES (270,3,1);
INSERT INTO saleitem VALUES (270,12,1);
INSERT INTO saleitem VALUES (270,14,1);
INSERT INTO saleitem VALUES (270,17,1);
INSERT INTO saleitem VALUES (280,14,1);
INSERT INTO saleitem VALUES (280,24,2);
INSERT INTO saleitem VALUES (290,1,1);
INSERT INTO saleitem VALUES (290,3,1);
INSERT INTO saleitem VALUES (290,6,1);
INSERT INTO saleitem VALUES (290,17,1);
INSERT INTO saleitem VALUES (300,6,1);
INSERT INTO saleitem VALUES (300,14,1);
INSERT INTO saleitem VALUES (310,19,1);
INSERT INTO saleitem VALUES (320,14,2);
INSERT INTO saleitem VALUES (320,19,2);
INSERT INTO saleitem VALUES (330,5,1);
INSERT INTO saleitem VALUES (330,9,1);
INSERT INTO saleitem VALUES (330,14,1);
INSERT INTO saleitem VALUES (330,17,1);
INSERT INTO saleitem VALUES (340,1,1);
INSERT INTO saleitem VALUES (340,9,1);
INSERT INTO saleitem VALUES (340,17,1);
INSERT INTO saleitem VALUES (350,8,2);
INSERT INTO saleitem VALUES (350,24,1);
INSERT INTO saleitem VALUES (360,8,4);
INSERT INTO saleitem VALUES (370,15,1);
INSERT INTO saleitem VALUES (370,16,2);
INSERT INTO saleitem VALUES (380,3,1);
INSERT INTO saleitem VALUES (380,10,3);
INSERT INTO saleitem VALUES (380,11,3);
INSERT INTO saleitem VALUES (380,12,3);
INSERT INTO saleitem VALUES (380,17,3);
INSERT INTO saleitem VALUES (390,3,1);
INSERT INTO saleitem VALUES (390,12,1);
INSERT INTO saleitem VALUES (390,14,1);
INSERT INTO saleitem VALUES (390,17,1);
INSERT INTO saleitem VALUES (400,1,1);
INSERT INTO saleitem VALUES (400,3,1);
INSERT INTO saleitem VALUES (400,6,1);
INSERT INTO saleitem VALUES (400,12,1);
INSERT INTO saleitem VALUES (400,17,1);
INSERT INTO saleitem VALUES (410,3,1);
INSERT INTO saleitem VALUES (410,6,1);
INSERT INTO saleitem VALUES (420,11,1);
INSERT INTO saleitem VALUES (420,14,1);
INSERT INTO saleitem VALUES (430,17,1);
INSERT INTO saleitem VALUES (440,3,1);
INSERT INTO saleitem VALUES (440,9,1);
INSERT INTO saleitem VALUES (440,11,1);
INSERT INTO saleitem VALUES (440,12,2);
INSERT INTO saleitem VALUES (450,3,1);
INSERT INTO saleitem VALUES (450,11,3);
INSERT INTO saleitem VALUES (450,12,1);
INSERT INTO saleitem VALUES (460,3,1);
INSERT INTO saleitem VALUES (460,9,1);
INSERT INTO saleitem VALUES (460,10,1);
INSERT INTO saleitem VALUES (460,11,1);
INSERT INTO saleitem VALUES (460,12,1);
INSERT INTO saleitem VALUES (460,17,1);
INSERT INTO saleitem VALUES (470,12,1);
INSERT INTO saleitem VALUES (470,14,1);
INSERT INTO saleitem VALUES (480,12,2);
INSERT INTO saleitem VALUES (480,14,1);
INSERT INTO saleitem VALUES (480,17,1);
INSERT INTO saleitem VALUES (480,18,1);
INSERT INTO saleitem VALUES (490,14,1);
INSERT INTO saleitem VALUES (490,20,1);
INSERT INTO saleitem VALUES (500,8,1);
INSERT INTO saleitem VALUES (500,17,1);
INSERT INTO saleitem VALUES (500,18,1);
INSERT INTO saleitem VALUES (500,25,1);
INSERT INTO saleitem VALUES (510,17,1);
INSERT INTO saleitem VALUES (520,3,1);
INSERT INTO saleitem VALUES (520,9,1);
INSERT INTO saleitem VALUES (520,10,1);
INSERT INTO saleitem VALUES (520,11,1);
INSERT INTO saleitem VALUES (520,12,1);
INSERT INTO saleitem VALUES (520,17,1);

-- item labs2018
INSERT INTO item VALUES (1,'Boots Riding','C','Brown',235);
INSERT INTO item VALUES (2,'Horse saddle','R','Brown',1895);
INSERT INTO item VALUES (3,'Compass - Silva','N','',35.5);
INSERT INTO item VALUES (4,'Polo Mallet ','R','Bamboo',45);
INSERT INTO item VALUES (5,'Exploring in 10 Easy Lessons','B','',23.95);
INSERT INTO item VALUES (6,'Geo positioning system','N','',142.85);
INSERT INTO item VALUES (7,'Hammock','F','Multicolour',95.95);
INSERT INTO item VALUES (8,'Sun Hat','C','White',35);
INSERT INTO item VALUES (9,'How to Win Foreign Friends','B','',29.35);
INSERT INTO item VALUES (10,'Map case','E','Brown',30);
INSERT INTO item VALUES (11,'Map measure','N','',9.95);
INSERT INTO item VALUES (12,'Gortex Rain Coat','C','Green',249.75);
INSERT INTO item VALUES (13,'Pocket knife - Steadfast ','E','Brown',70);
INSERT INTO item VALUES (14,'Pocket knife - Essential','E','Brown',33);
INSERT INTO item VALUES (15,'Camping chair','F','Red',55.95);
INSERT INTO item VALUES (16,'BBQ  - Jumbuk','F','',58.9);
INSERT INTO item VALUES (17,'Torch','E','',11.75);
INSERT INTO item VALUES (18,'Polar Fleece Beanie ','C','Black',22.5);
INSERT INTO item VALUES (19,'Tent - 2 person','F','Khaki',399.95);
INSERT INTO item VALUES (20,'Tent - 8 person','F','Khaki',785.96);
INSERT INTO item VALUES (21,'Tent - 4 person','F','Blue',638.95);
INSERT INTO item VALUES (22,'Cowboy Hat','C','Black',215);
INSERT INTO item VALUES (23,'Boots - Womens Hiking','C','Grey',160);
INSERT INTO item VALUES (24,'Boots - Womens Goretex','C','Grey',289.95);
INSERT INTO item VALUES (25,'Boots - Mens Hiking','C','Grey',299.95);


SET SQL_MODE=@OLD_SQL_MODE;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

COMMIT;