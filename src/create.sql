-- Table: public.customer_info

-- DROP TABLE IF EXISTS public.customer_info;

CREATE TABLE IF NOT EXISTS public.customer_info
(
    id integer NOT NULL DEFAULT nextval('customer_info_id_seq'::regclass),
    first_name character varying COLLATE pg_catalog."default",
    last_name character varying COLLATE pg_catalog."default",
    CONSTRAINT customer_info_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer_info
    OWNER to postgres;

-- Table: public.customer_address

-- DROP TABLE IF EXISTS public.customer_address;

CREATE TABLE IF NOT EXISTS public.customer_address
(
    house_no integer NOT NULL,
    street character varying COLLATE pg_catalog."default" NOT NULL,
    city character varying COLLATE pg_catalog."default" NOT NULL,
    state character varying COLLATE pg_catalog."default" NOT NULL,
    postal_code character varying COLLATE pg_catalog."default" NOT NULL,
    customer_id integer,
    CONSTRAINT customer_address_pkey PRIMARY KEY (house_no, street, city, state, postal_code),
    CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer_address
    OWNER to postgres;

-- Table: public.customer_contact

-- DROP TABLE IF EXISTS public.customer_contact;

CREATE TABLE IF NOT EXISTS public.customer_contact
(
    phone_no character varying COLLATE pg_catalog."default" NOT NULL,
    customer_id integer,
    CONSTRAINT customer_contact_pkey PRIMARY KEY (phone_no),
    CONSTRAINT customer_contact_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer_contact
    OWNER to postgres;

-- Table: public.employee_info

-- DROP TABLE IF EXISTS public.employee_info;

CREATE TABLE IF NOT EXISTS public.employee_info
(
    id integer NOT NULL DEFAULT nextval('employee_info_id_seq'::regclass),
    first_name character varying COLLATE pg_catalog."default",
    last_name character varying COLLATE pg_catalog."default",
    date_of_birth date,
    gender character(1) COLLATE pg_catalog."default",
    "position" character varying COLLATE pg_catalog."default",
    hire_date date,
    salary numeric,
    CONSTRAINT employee_info_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employee_info
    OWNER to postgres;

-- Table: public.employee_address

-- DROP TABLE IF EXISTS public.employee_address;

CREATE TABLE IF NOT EXISTS public.employee_address
(
    house_no integer NOT NULL,
    street character varying COLLATE pg_catalog."default" NOT NULL,
    city character varying COLLATE pg_catalog."default" NOT NULL,
    state character varying COLLATE pg_catalog."default" NOT NULL,
    postal_code character varying COLLATE pg_catalog."default" NOT NULL,
    employee_id integer,
    CONSTRAINT employee_address_pkey PRIMARY KEY (house_no, street, city, state, postal_code),
    CONSTRAINT employee_address_employee_id_fkey FOREIGN KEY (employee_id)
        REFERENCES public.employee_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employee_address
    OWNER to postgres;

-- Table: public.employee_contact

-- DROP TABLE IF EXISTS public.employee_contact;

CREATE TABLE IF NOT EXISTS public.employee_contact
(
    employee_id integer,
    phone_no character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT employee_contact_pkey PRIMARY KEY (phone_no),
    CONSTRAINT employee_contact_employee_id_fkey FOREIGN KEY (employee_id)
        REFERENCES public.employee_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employee_contact
    OWNER to postgres;

-- Table: public.inventory

-- DROP TABLE IF EXISTS public.inventory;

CREATE TABLE IF NOT EXISTS public.inventory
(
    item_id integer NOT NULL DEFAULT nextval('inventory_item_id_seq'::regclass),
    item_name character varying(100) COLLATE pg_catalog."default",
    category character varying(50) COLLATE pg_catalog."default",
    quantity integer,
    unit_of_measurement character varying(20) COLLATE pg_catalog."default",
    purchase_price numeric(10,2),
    sale_price numeric(10,2),
    reorder_level integer,
    supplier_name character varying(100) COLLATE pg_catalog."default",
    expiration_date date,
    last_updated timestamp without time zone,
    menu_item_id integer,
    CONSTRAINT inventory_pkey PRIMARY KEY (item_id),
    CONSTRAINT inventory_menu_item_id_fkey FOREIGN KEY (menu_item_id)
        REFERENCES public.menu (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.inventory
    OWNER to postgres;

-- Table: public.menu

-- DROP TABLE IF EXISTS public.menu;

CREATE TABLE IF NOT EXISTS public.menu
(
    id integer NOT NULL DEFAULT nextval('menu_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    price integer,
    category character varying COLLATE pg_catalog."default",
    CONSTRAINT menu_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.menu
    OWNER to postgres;
-- Index: idx_menu_id

-- DROP INDEX IF EXISTS public.idx_menu_id;

CREATE INDEX IF NOT EXISTS idx_menu_id
    ON public.menu USING btree
    (id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.orders

-- DROP TABLE IF EXISTS public.orders;

CREATE TABLE IF NOT EXISTS public.orders
(
    id integer NOT NULL DEFAULT nextval('orders_id_seq'::regclass),
    customer_id integer,
    order_date date,
    type character varying COLLATE pg_catalog."default",
    total_price numeric,
    CONSTRAINT orders_pkey PRIMARY KEY (id),
    CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orders
    OWNER to postgres;
-- Index: idx_orders_id

-- DROP INDEX IF EXISTS public.idx_orders_id;

CREATE INDEX IF NOT EXISTS idx_orders_id
    ON public.orders USING btree
    (id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_orders_order_item

-- DROP INDEX IF EXISTS public.idx_orders_order_item;

CREATE INDEX IF NOT EXISTS idx_orders_order_item
    ON public.orders USING btree
    (id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.order_item

-- DROP TABLE IF EXISTS public.order_item;

CREATE TABLE IF NOT EXISTS public.order_item
(
    id integer NOT NULL DEFAULT nextval('order_item_id_seq1'::regclass),
    order_id integer,
    item_id integer,
    quantity integer,
    CONSTRAINT order_item_pkey PRIMARY KEY (id),
    CONSTRAINT order_item_order_id_item_id_key UNIQUE (order_id, item_id),
    CONSTRAINT order_item_item_id_fkey FOREIGN KEY (item_id)
        REFERENCES public.menu (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id)
        REFERENCES public.orders (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.order_item
    OWNER to postgres;

-- Table: public.review

-- DROP TABLE IF EXISTS public.review;

CREATE TABLE IF NOT EXISTS public.review
(
    id integer NOT NULL DEFAULT nextval('review_id_seq'::regclass),
    customer_id integer,
    item_id integer,
    rating integer,
    comment character varying COLLATE pg_catalog."default",
    CONSTRAINT review_pkey PRIMARY KEY (id),
    CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT review_item_id_fkey FOREIGN KEY (item_id)
        REFERENCES public.menu (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.review
    OWNER to postgres;