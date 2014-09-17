-- SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
-- SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, AUTOCOMMIT=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema STAMPIT
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `STAMPIT` ;
CREATE SCHEMA IF NOT EXISTS `STAMPIT` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `STAMPIT` ;

-- -----------------------------------------------------
-- Table `STAMPIT`.`CUSTOMERS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CUSTOMERS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CUSTOMERS` (
  `ID_CUSTOMER` BIGINT NOT NULL AUTO_INCREMENT,
  `USERNAME` VARCHAR(16) NOT NULL UNIQUE,
  `PASSWORD` VARCHAR(50) NOT NULL,
  `FIRST_NAME` VARCHAR(45) NOT NULL,
  `LAST_NAME` VARCHAR(45) NOT NULL,
  `EMAIL` VARCHAR(45) NOT NULL,
  `PHONE` VARCHAR(45) NULL,
   PRIMARY KEY (`ID_CUSTOMER`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`MERCHANT_CATEGORIES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`MERCHANT_CATEGORIES` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`MERCHANT_CATEGORIES` (
  `ID_CATEGORY` BIGINT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(100) NOT NULL,
  `DESCRIPTION` VARCHAR(1000) NULL,
  PRIMARY KEY (`ID_CATEGORY`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`MERCHANTS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`MERCHANTS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`MERCHANTS` (
  `ID_MERCHANT` BIGINT NOT NULL AUTO_INCREMENT,  
  `USERNAME` VARCHAR(16) NOT NULL UNIQUE,
  `PASSWORD` VARCHAR(12) NOT NULL,
  `NAME` VARCHAR(200) NOT NULL,
  `VAT` VARCHAR(45) NOT NULL,
  `PHONE` VARCHAR(45) NOT NULL,
  `ADDRESS` VARCHAR(200) NOT NULL,
  `CITY` VARCHAR(45) NOT NULL,
  `COUNTRY` VARCHAR(45) NOT NULL,
  `WEBSITE` VARCHAR(100) NULL,
  `CLOSING_DAY` ENUM('0','1','2','3','4','5','6') NULL,
  `OPENING_TIME` TIME NULL,
  `CLOSING_TIME` TIME NULL,
  `GPS_COORDINATES` GEOMETRY NULL,
  `GPS_COORDINATES_TEXT` varchar(45) DEFAULT NULL,
  `EMAIL` VARCHAR(45) NOT NULL,
  `MERCHANT_CATEGORY` BIGINT NOT NULL,
   PRIMARY KEY (`ID_MERCHANT`),
  INDEX `MERCHANT_CATEGORY_idx` (`MERCHANT_CATEGORY` ASC),
  CONSTRAINT `MERCHANT_CATEGORY`
    FOREIGN KEY (`MERCHANT_CATEGORY`)
    REFERENCES `STAMPIT`.`MERCHANT_CATEGORIES` (`ID_CATEGORY`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`CARDS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CARDS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CARDS` (
  `ID_CARD` BIGINT NOT NULL AUTO_INCREMENT,
  `ID_MERCHANT` BIGINT NOT NULL,
  `SLOTS_NUM` INT NOT NULL,
  `EXPIRE_DATE` DATE NOT NULL,
  PRIMARY KEY (`ID_CARD`),
  INDEX `ID_MERCHANT_idx` (`ID_MERCHANT` ASC),
  CONSTRAINT `ID_MERCHANT`
    FOREIGN KEY (`ID_MERCHANT`)
    REFERENCES `STAMPIT`.`MERCHANTS` (`ID_MERCHANT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`ACTIVE_CARDS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`ACTIVE_CARDS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`ACTIVE_CARDS` (
  `ID_ACTIVE_CARD` BIGINT NOT NULL AUTO_INCREMENT,
  `STAMPS_NUMBER` INT NOT NULL,
  `RATING` INT NULL,
  `ID_CUSTOMER` BIGINT NOT NULL,
  `ID_CARD` BIGINT NOT NULL,
  PRIMARY KEY (`ID_ACTIVE_CARD`),
  INDEX `ID_CUSTOMER_idx` (`ID_CUSTOMER` ASC),
  INDEX `ID_CARD_idx` (`ID_CARD` ASC),
  CONSTRAINT `ID_CUSTOMER`
    FOREIGN KEY (`ID_CUSTOMER`)
    REFERENCES `STAMPIT`.`CUSTOMERS` (`ID_CUSTOMER`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `ID_CARD`
    FOREIGN KEY (`ID_CARD`)
    REFERENCES `STAMPIT`.`CARDS` (`ID_CARD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`LOGS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`LOGS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`LOGS` (
  `ID_LOG` BIGINT NOT NULL AUTO_INCREMENT,
  `INS_DATE` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LOCATION` GEOMETRY NULL,
  `STAMPS_NUM` INT NULL,  
  `ID_ACTIVE_CARD` BIGINT NULL,
  PRIMARY KEY (`ID_LOG`),
  INDEX `ID_ACTIVE_CARD_idx` (`ID_ACTIVE_CARD` ASC),
  CONSTRAINT `ID_ACTIVE_CARD`
    FOREIGN KEY (`ID_ACTIVE_CARD`)
    REFERENCES `STAMPIT`.`ACTIVE_CARDS` (`ID_ACTIVE_CARD`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`STAMP_PARAMETERS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`STAMP_PARAMETERS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`STAMP_PARAMETERS` (
  `ID_STAMP_PARAMS` BIGINT NOT NULL AUTO_INCREMENT,
  `MEASURE_UNIT` VARCHAR(100) NOT NULL,
  `VALUE` FLOAT NOT NULL,
  `STAMPS_NUM` INT NOT NULL,
  PRIMARY KEY (`ID_STAMP_PARAMS`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`CODES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CODES` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CODES` (
  `ID_CODE` BIGINT NOT NULL AUTO_INCREMENT,
  `CODE` VARCHAR(8000) NOT NULL , -- impossibile impostare UNIQUE un campo con dimensione maggiore di 767 byte
  `ID_CARD` BIGINT NOT NULL,
  `ID_STAMP_PARAMS` BIGINT NOT NULL,
  PRIMARY KEY (`ID_CODE`),
  INDEX `ID_CARD_idx` (`ID_CARD` ASC),
  INDEX `ID_STAMP_PARAMS_idx` (`ID_STAMP_PARAMS` ASC),
  CONSTRAINT `ID_CARD_2`
    FOREIGN KEY (`ID_CARD`)
    REFERENCES `STAMPIT`.`CARDS` (`ID_CARD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ID_STAMP_PARAMS`
    FOREIGN KEY (`ID_STAMP_PARAMS`)
    REFERENCES `STAMPIT`.`STAMP_PARAMETERS` (`ID_STAMP_PARAMS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`PRIZES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`PRIZES` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`PRIZES` (
  `ID_PRIZE` BIGINT NOT NULL AUTO_INCREMENT,
  `DESCRIPTION` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`ID_PRIZE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`BONUSES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`BONUSES` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`BONUSES` (
  `ID_BONUS` BIGINT NOT NULL AUTO_INCREMENT,
  `SLOT_POS` INT NOT NULL,
  `ID_CARD` BIGINT NOT NULL,
  `ID_PREMIO` BIGINT NULL,
  PRIMARY KEY (`ID_BONUS`),
  INDEX `ID_CARD_idx` (`ID_CARD` ASC),
  INDEX `ID_PREMIO_idx` (`ID_PREMIO` ASC),
  CONSTRAINT `ID_CARD_3`
    FOREIGN KEY (`ID_CARD`)
    REFERENCES `STAMPIT`.`CARDS` (`ID_CARD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ID_PRIZE`
    FOREIGN KEY (`ID_PREMIO`)
    REFERENCES `STAMPIT`.`PRIZES` (`ID_PRIZE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`ACHIEVED_BONUSES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`ACHIEVED_BONUSES` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`ACHIEVED_BONUSES` (
  `ID_ACHIEVED_BONUSES` BIGINT NOT NULL AUTO_INCREMENT,
  `ID_BONUS` BIGINT NULL,
  `ID_ACTIVE_CARD` BIGINT NULL,
  `USED` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`ID_ACHIEVED_BONUSES`),
  INDEX `ID_BONUS_idx` (`ID_BONUS` ASC),
  INDEX `ID_ACTIVE_CARD_idx` (`ID_ACTIVE_CARD` ASC),
  CONSTRAINT `ID_BONUS`
    FOREIGN KEY (`ID_BONUS`)
    REFERENCES `STAMPIT`.`BONUSES` (`ID_BONUS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ID_ACTIVE_CARD_2`
    FOREIGN KEY (`ID_ACTIVE_CARD`)
    REFERENCES `STAMPIT`.`ACTIVE_CARDS` (`ID_ACTIVE_CARD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`CUSTOMER_FEEDBACKS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CUSTOMER_FEEDBACKS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CUSTOMER_FEEDBACKS` (
  `ID_FEEDBACK` BIGINT NOT NULL AUTO_INCREMENT,
  `MESSAGE` VARCHAR(1000) NOT NULL,
  `INS_DATE` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID_CUSTOMER` BIGINT NOT NULL,
  PRIMARY KEY (`ID_FEEDBACK`),
  INDEX `ID_CUSTOMER_idx` (`ID_CUSTOMER` ASC),
  CONSTRAINT `ID_CUSTOMER_2`
    FOREIGN KEY (`ID_CUSTOMER`)
    REFERENCES `STAMPIT`.`CUSTOMERS` (`ID_CUSTOMER`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`MERCHANT_FEEDBACKS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`MERCHANT_FEEDBACKS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`MERCHANT_FEEDBACKS` (
  `ID_FEEDBACK` BIGINT NOT NULL AUTO_INCREMENT,
  `MESSAGE` VARCHAR(1000) NOT NULL,
  `INS_DATE` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID_MERCHANT` BIGINT NULL,
  PRIMARY KEY (`ID_FEEDBACK`),
  INDEX `ID_MERCHANT_idx` (`ID_MERCHANT` ASC),
  CONSTRAINT `ID_MERCHANT_2`
    FOREIGN KEY (`ID_MERCHANT`)
    REFERENCES `STAMPIT`.`MERCHANTS` (`ID_MERCHANT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `STAMPIT`.`CATEGORIES_PARAMS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CATEGORIES_PARAMS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CATEGORIES_PARAMS` (
  `ID_PARAM` BIGINT NOT NULL,
  `ID_CATEGORY` BIGINT NOT NULL,
  PRIMARY KEY (`ID_PARAM`, `ID_CATEGORY`),
  INDEX `ID_CATEGORY_idx` (`ID_CATEGORY` ASC),
  CONSTRAINT `ID_PARAM`
    FOREIGN KEY (`ID_PARAM`)
    REFERENCES `STAMPIT`.`STAMP_PARAMETERS` (`ID_STAMP_PARAMS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ID_CATEGORY`
    FOREIGN KEY (`ID_CATEGORY`)
    REFERENCES `STAMPIT`.`MERCHANT_CATEGORIES` (`ID_CATEGORY`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `STAMPIT`.`customers_confirmations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`CUSTOMERS_CONFIRMATIONS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`CUSTOMERS_CONFIRMATIONS` (
  `ID_CUSTOMER` BIGINT NOT NULL,
  `CONFIRMATION_KEY` VARCHAR(40) NULL,
  `CONFIRMED` TINYINT(1) NULL,
  PRIMARY KEY (`ID_CUSTOMER`),
  CONSTRAINT `ID_CUSTOMER_FK`
    FOREIGN KEY (`ID_CUSTOMER`)
    REFERENCES `STAMPIT`.`CUSTOMERS` (`ID_CUSTOMER`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `STAMPIT`.`DATABASE_VERSIONS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `STAMPIT`.`DATABASE_VERSIONS` ;

CREATE TABLE IF NOT EXISTS `STAMPIT`.`DATABASE_VERSIONS` (
  `ID_VERSION` BIGINT NOT NULL AUTO_INCREMENT,
  `VERSION` INT NOT NULL,
  `VERSION_DATE` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_VERSION`) ) 
ENGINE = InnoDB;

-- -----------------------------------------------------
-- TRIGGERS
-- -----------------------------------------------------
USE `STAMPIT`;

DELIMITER $$

USE `STAMPIT`$$
DROP TRIGGER IF EXISTS `STAMPIT`.`MERCHANTS_BINS` $$
USE `STAMPIT`$$
CREATE TRIGGER `MERCHANTS_BINS` BEFORE INSERT ON `MERCHANTS` 
FOR EACH ROW BEGIN
    SET NEW.gps_coordinates_text = astext(NEW.gps_coordinates);
END;
$$


USE `STAMPIT`$$
DROP TRIGGER IF EXISTS `STAMPIT`.`MERCHANTS_BUPD` $$
USE `STAMPIT`$$
CREATE TRIGGER `MERCHANTS_BUPD` BEFORE UPDATE ON `MERCHANTS` 
FOR EACH ROW
BEGIN
    SET NEW.gps_coordinates_text = astext(NEW.gps_coordinates);
END;$$


DELIMITER ;

-- DATABASE_VERSION --
insert into DATABASE_VERSIONS(VERSION) values(2);

-- CUSTOMERS --
insert into CUSTOMERS values(1,'giuliorossi', 'pass1', 'Giulio', 'Rossi', 'giulio.rossi@test.com', '332444447723');
insert into CUSTOMERS values(2,'guidomarro', ' pass2', 'Guido', 'Marro', 'guido.marro@test.com', '33248847723');
insert into CUSTOMERS values(3,'aldozero', 'pass3', 'Aldo', 'Zero', 'aldo.zero@test.com', '3324442217723');
insert into CUSTOMERS values(4,'giorgiosalerno', 'pass4', 'Giorgio', 'Salerno', 'giorgio.salerno@test.com', '33289444447723');
insert into CUSTOMERS values(5,'lucagiallo', 'pass5', 'Luca', 'Giallo', 'luca.giallo@test.com', '33284444447723');
insert into CUSTOMERS values(6,'marionero', 'pass6', 'Mario', 'Nero', 'mario.nero@test.com', '3328944444556');
insert into CUSTOMERS values(7,'francescoverde', 'pass7', 'Francesco', 'Verde', 'francesco.verde@test.com', '3328944232347723');
insert into CUSTOMERS values(8,'davidebianco', 'pass8', 'Davide', 'Bianco', 'davide.bianco@test.com', '332894444111');
insert into CUSTOMERS values(9,'gianniviola', 'pass9', 'Gianni', 'Viola', 'gianni.viola@test.com', '332895454447723');
insert into CUSTOMERS values(10,'marcobrandi', 'pass10', 'Marco', 'Brandi', 'marco.brandi@test.com', '33389412447723');

-- MERCHANT CATEGORIES --
insert into MERCHANT_CATEGORIES values(1, 'bar', 'nessuna descrizione');
insert into MERCHANT_CATEGORIES values(2, 'ristorante', 'nessuna descrizione');
insert into MERCHANT_CATEGORIES values(3, 'pizzeria', 'nessuna descrizione');
insert into MERCHANT_CATEGORIES values(4, 'pub', 'nessuna descrizione');
insert into MERCHANT_CATEGORIES values(5, 'enoteca', 'nessuna descrizione');
insert into MERCHANT_CATEGORIES values(6, 'mensa', 'nessuna descrizione');

-- MERCHANTS --
insert into MERCHANTS values(1, 'merchant1', 'pass1', 'Bar Roma', '0764352056C', '33921456789876', 'Via Achille Benedetti 2', 'Roma', 'Italy', 'www.barroma.it', '1', '07:00', '23:00', GeomFromText('POINT(41.912458 12.544012)'), null,'barroma@test.com', '1');
insert into MERCHANTS values(2, 'merchant2', 'pass2', 'Bar Milano', '0864352056C', '33921456789856', 'Via Vincenzo Foppa 10', 'Milano', 'Italy', 'www.barmilano.it', '2', '07:00', '23:30', GeomFromText('POINT(45.458437 9.162792)'), null,'barmilano@test.com', '1');
insert into MERCHANTS values(3, 'merchant3', 'pass3', 'Bar Torino', '0864352058C', '3392145678234', 'Corso Trapani 195', 'Torino', 'Italy', 'www.bartorino.it', '2', '06:00', '23:30', GeomFromText('POINT(45.060677 7.635199)'), null,'bartorino@test.com', '1');
insert into MERCHANTS values(4, 'merchant4', 'pass4', 'Ristorante Verona', '0864353058C', '3332145678234', 'Stradone Porta Palio 70', 'Verona', 'Italy', 'www.ristoranteverona.it', '2', '11:00', '23:30', GeomFromText('POINT(45.436728 10.982822)'), null, 'ristoranteverona@test.com', '2');
insert into MERCHANTS values(5, 'merchant5', 'pass5', 'Ristorante Genova', '0874353058C', '3282145678246', 'Via Antonio Burlando 5', 'Genova', 'Italy', 'www.ristorantegenova.it', '3', '11:00', '23:30', GeomFromText('POINT(44.418172 8.945073)'), null,'ristorantegenova@test.com', '2');
insert into MERCHANTS values(6, 'merchant6', 'pass6', 'Ristorante Napoli', '0874343058C', '3282143478246', 'Via Nuova Brecce 214', 'Napoli', 'Italy', 'www.ristorantenapoli.it', '3', '11:00', '23:30', GeomFromText('POINT(40.853485 14.304132)'), null,'ristorantenapoli@test.com', '2');
insert into MERCHANTS values(7, 'merchant7', 'pass7', 'Pizzeria Palermo', '0874342358C', '3283453478246', 'Corso Tukory 211', 'Palermo', 'Italy', 'www.pizzeriapalermo.it', '4', '11:00', '23:45', GeomFromText('POINT(38.108296, 13.356598)'), null,'pizzeriapalermo@test.com', '3');
insert into MERCHANTS values(8, 'merchant8', 'pass8', 'Pizzeria Messina', '0984342358C', '3283453478212', 'Via Cesare Battisti 100', 'Messina', 'Italy', 'www.pizzeriamessina.it', '3', '11:00', '23:45', GeomFromText('POINT(38.187286 15.552748)'), null,'pizzeriamessina@test.com', '3');
insert into MERCHANTS values(9, 'merchant9', 'pass9', 'Mensa Cagliari', '0994342358C', '3283233479212', 'Via Alessandro Manzoni 	 6', 'Cagliari', 'Italy', 'www.mensacagliari.it', '0', '11:00', '15:00', GeomFromText('POINT(39.221614, 9.123947)'), null,'mensacagliari@test.com', '6');

-- CARDS --
insert into CARDS values(1, 1, 20, '2015-04-15');
insert into CARDS values(2, 2, 20, '2015-02-16');
insert into CARDS values(3, 3, 25, '2015-02-15');
insert into CARDS values(4, 4, 22, '2015-01-15');
insert into CARDS values(5, 5, 10, '2015-04-25');
insert into CARDS values(6, 6, 20, '2015-02-15');
insert into CARDS values(7, 7, 20, '2015-04-15');
insert into CARDS values(8, 8, 15, '2015-04-01');
insert into CARDS values(9, 9, 10, '2015-04-15');
insert into CARDS values(10, 1, 30, '2015-06-15');
insert into CARDS values(11, 2, 35, '2015-04-15');
insert into CARDS values(12, 3, 40, '2015-06-15');
insert into CARDS values(13, 4, 30, '2015-03-20');
insert into CARDS values(14, 5, 30, '2015-04-15');
insert into CARDS values(15, 6, 30, '2015-03-15');

-- PRIZES --
insert into PRIZES values(1, '1 caffè');
insert into PRIZES values(2, '1 caffè 1 cornetto');
insert into PRIZES values(3, '1 primo');
insert into PRIZES values(4, '1 primo + 1 secondo');
insert into PRIZES values(5, '1 pasto completo');
insert into PRIZES values(6, '1 pizza a scelta');

-- BONUSES --
insert into BONUSES values(1, 20, 1, 1);
insert into BONUSES values(2, 20, 2, 1);
insert into BONUSES values(3, 25, 3, 1);
insert into BONUSES values(4, 22, 4, 5);
insert into BONUSES values(5, 10, 5, 5);
insert into BONUSES values(6, 20, 6, 5);
insert into BONUSES values(7, 20, 7, 6);
insert into BONUSES values(8, 15, 8, 6);
insert into BONUSES values(9, 10, 9, 5);
insert into BONUSES values(10, 20, 10, 1);
insert into BONUSES values(11, 30, 10, 2);
insert into BONUSES values(12, 20, 11, 1);
insert into BONUSES values(13, 35, 11, 2);
insert into BONUSES values(14, 30, 12, 1);
insert into BONUSES values(15, 40, 12, 2);
insert into BONUSES values(16, 20, 13, 3);
insert into BONUSES values(17, 30, 13, 5);
insert into BONUSES values(18, 20, 14, 4);
insert into BONUSES values(19, 30, 14, 5);

-- STAMP_PARAMETERS --
insert into STAMP_PARAMETERS values(1, 'caffè', 1, 1);
insert into STAMP_PARAMETERS values(2, 'caffè + cornetto', 1, 3);
insert into STAMP_PARAMETERS values(3, '€', 10, 2);
insert into STAMP_PARAMETERS values(4, '€', 6, 1);
insert into STAMP_PARAMETERS values(5, '€', 20, 5);

-- CATEGORIES_PARAMS --
insert into CATEGORIES_PARAMS values(1, 1);
insert into CATEGORIES_PARAMS values(2, 1);
insert into CATEGORIES_PARAMS values(3, 2);
insert into CATEGORIES_PARAMS values(4, 2);
insert into CATEGORIES_PARAMS values(5, 2);
insert into CATEGORIES_PARAMS values(3, 3);
insert into CATEGORIES_PARAMS values(4, 3);
insert into CATEGORIES_PARAMS values(5, 3);
insert into CATEGORIES_PARAMS values(3, 4);
insert into CATEGORIES_PARAMS values(4, 4);
insert into CATEGORIES_PARAMS values(5, 4);
insert into CATEGORIES_PARAMS values(3, 5);
insert into CATEGORIES_PARAMS values(4, 5);
insert into CATEGORIES_PARAMS values(3, 6);
insert into CATEGORIES_PARAMS values(4, 6);

-- CODES --
insert into CODES values(1, 'prova1', 1, 1);
insert into CODES values(2, 'prova2', 1, 2);
insert into CODES values(3, 'prova3', 2, 1);
insert into CODES values(4, 'prova4', 2, 2);
insert into CODES values(5, 'prova5', 3, 1);
insert into CODES values(6, 'prova6', 3, 2);
insert into CODES values(7, 'prova7', 4, 3);
insert into CODES values(8, 'prova8', 4, 4);
insert into CODES values(9, 'prova9', 4, 5);
insert into CODES values(10, 'prova10', 5, 3);
insert into CODES values(11, 'prova11', 5, 4);
insert into CODES values(12, 'prova12', 5, 5);
insert into CODES values(13, 'prova13', 6, 3);
insert into CODES values(14, 'prova14', 6, 4);
insert into CODES values(15, 'prova15', 6, 5);
insert into CODES values(16, 'prova16', 7, 3);
insert into CODES values(17, 'prova17', 7, 4);
insert into CODES values(18, 'prova18', 7, 5);
insert into CODES values(19, 'prova19', 8, 3);
insert into CODES values(20, 'prova20', 8, 4);
insert into CODES values(21, 'prova21', 8, 5);
insert into CODES values(22, 'prova22', 9, 3);
insert into CODES values(23, 'prova23', 9, 4);
insert into CODES values(24, 'prova24', 10, 1);
insert into CODES values(25, 'prova25', 10, 2);
insert into CODES values(26, 'prova26', 11, 1);
insert into CODES values(27, 'prova27', 11, 2);
insert into CODES values(28, 'prova28', 12, 1);
insert into CODES values(29, 'prova29', 12, 2);
insert into CODES values(30, 'prova30', 13, 3);
insert into CODES values(31, 'prova31', 13, 4);
insert into CODES values(32, 'prova32', 13, 5);
insert into CODES values(33, 'prova33', 14, 3);
insert into CODES values(34, 'prova34', 14, 4);
insert into CODES values(35, 'prova35', 14, 5);
insert into CODES values(36, 'prova36', 15, 3);
insert into CODES values(37, 'prova37', 15, 4);
insert into CODES values(38, 'prova38', 15, 5);

-- ACTIVE_CARDS --
insert into ACTIVE_CARDS(stamps_number, rating, id_customer, id_card) values(0, 1, 1, 2);

-- LOGS --
insert into LOGS(location, stamps_num, id_active_card) values(GeomFromText('POINT(41.912458 12.544012)'), 2, 1);


COMMIT;

SET SQL_MODE=@OLD_SQL_MODE;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;