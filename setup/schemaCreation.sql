-- -----------------------------------------------------
-- Table `affablebean`.`customer`
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.customer';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.customer (
  id NUMBER(10) CHECK (id > 0) NOT NULL ,
  name VARCHAR2(45) NOT NULL ,
  email VARCHAR2(45) NOT NULL ,
  phone VARCHAR2(45) NOT NULL ,
  address VARCHAR2(45) NOT NULL ,
  city_region VARCHAR2(2) NOT NULL ,
  cc_number VARCHAR2(19) NOT NULL ,
  PRIMARY KEY (id) )
;

COMMENT ON TABLE affablebean.customer IS 'maintains customer details'

-- Generate ID using sequence and trigger
CREATE SEQUENCE affablebean.customer_seq START WITH 1 INCREMENT BY 1;


-- -----------------------------------------------------
-- Table `affablebean`.`customer_order`
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.customer_order';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.customer_order (
  id NUMBER(10) CHECK (id > 0) NOT NULL ,
  amount NUMBER(6,2) NOT NULL ,
  date_created TIMESTAMP(0) DEFAULT SYSTIMESTAMP NOT NULL ,
  confirmation_number NUMBER(10) CHECK (confirmation_number > 0) NOT NULL ,
  customer_id NUMBER(10) CHECK (customer_id > 0) NOT NULL ,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_cust_order_cust
    FOREIGN KEY (customer_id )
    REFERENCES affablebean.customer (id )
   )
;

COMMENT ON TABLE affablebean.customer_order IS 'maintains customer order details'

-- Generate ID using sequence and trigger
CREATE SEQUENCE affablebean.customer_order_seq START WITH 1 INCREMENT BY 1;

CREATE INDEX fk_cust_order_cust ON affablebean.customer_order (customer_id ASC);


-- -----------------------------------------------------
-- Table `affablebean`.`category`
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.category';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.category (
  id NUMBER(3) CHECK (id > 0) NOT NULL ,
  name VARCHAR2(45) NOT NULL ,
  PRIMARY KEY (id) )
;

COMMENT ON TABLE affablebean.category IS 'contains product categories, e.g., dairy, meats, etc.'

-- Generate ID using sequence and trigger
CREATE SEQUENCE affablebean.category_seq START WITH 1 INCREMENT BY 1;

-- -----------------------------------------------------
-- Table `affablebean`.`product`
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.product';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.product (
  id NUMBER(10) CHECK (id > 0) NOT NULL ,
  name VARCHAR2(45) NOT NULL ,
  price NUMBER(5,2) NOT NULL ,
  description VARCHAR2(255) NULL ,
  last_update TIMESTAMP(0) DEFAULT SYSTIMESTAMP NOT NULL ,
  category_id NUMBER(3) CHECK (category_id > 0) NOT NULL ,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id )
    REFERENCES affablebean.category (id )
   )
;

COMMENT ON TABLE affablebean.product IS 'contains product details'

-- Generate ID using sequence and trigger
CREATE SEQUENCE affablebean.product_seq START WITH 1 INCREMENT BY 1;

CREATE INDEX fk_prod_category ON affablebean.product (category_id ASC);



-- -----------------------------------------------------
-- Table `affablebean`.`ordered_product`
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.ordered_product';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.ordered_product (
  customer_order_id NUMBER(10) CHECK (customer_order_id > 0) NOT NULL ,
  product_id NUMBER(10) CHECK (product_id > 0) NOT NULL ,
  quantity NUMBER(5) DEFAULT 1 CHECK (quantity > 0) NOT NULL ,
  PRIMARY KEY (customer_order_id, product_id)
  ,
  CONSTRAINT fk_ord_prod_cust_order
    FOREIGN KEY (customer_order_id )
    REFERENCES affablebean.customer_order (id )
   ,
  CONSTRAINT fk_ord_prod_prod
    FOREIGN KEY (product_id )
    REFERENCES affablebean.product (id )
    )
;

COMMENT ON TABLE affablebean.ordered_product IS 'matches products with customer orders and records their quantity'

CREATE INDEX fk_ord_prod_cust_order ON affablebean.ordered_product (customer_order_id ASC);
CREATE INDEX fk_ord_prod_prod ON affablebean.ordered_product (product_id ASC);

-- -----------------------------------------------------
-- Scheduled Delivery
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE affablebean.delivery';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/ 

CREATE  TABLE affablebean.delivery (
  id NUMBER(3) CHECK (id > 0) NOT NULL ,
  name VARCHAR2(45) NOT NULL ,
  address VARCHAR2(45) NOT NULL ,
  order_placed TIMESTAMP NOT NULL,
  PRIMARY KEY (id));

COMMENT ON TABLE affablebean.category IS 'contains delivery requests'

-- Generate ID using sequence and trigger
CREATE SEQUENCE affablebean.delivery_seq START WITH 1 INCREMENT BY 1;




/* SET SQL_MODE=@OLD_SQL_MODE; */
/* SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS; */
/* SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS; */