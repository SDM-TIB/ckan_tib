--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: nested; Type: TYPE; Schema: public; Owner: ckan
--

CREATE TYPE nested AS (
	json json,
	extra text
);


ALTER TYPE nested OWNER TO ckan;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "0b15b724-fe12-49c9-9b17-e114c025af24" (
    _id integer NOT NULL,
    _full_text tsvector,
    user_id text,
    cust_sex text,
    cert_age numeric,
    area text,
    cust_type text,
    "innet_month(月)" numeric,
    is_innet text
);


ALTER TABLE "0b15b724-fe12-49c9-9b17-e114c025af24" OWNER TO ckan;

--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".user_id; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".user_id IS '{"notes": "Usename of the user", "type_override": "text", "label": "Username"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cust_sex; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cust_sex IS '{"notes": "Gender of the user", "type_override": "text", "label": "Gender"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cert_age; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cert_age IS '{"notes": "Age of the user", "type_override": "numeric", "label": "Age"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".area; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".area IS '{"notes": "Living area of the user", "type_override": "text", "label": "Area"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cust_type; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".cust_type IS '{"notes": "Type of service:\r\n\r\n* Type 1\r\n* Type 2\r\n* Type 3\r\n", "type_override": "text", "label": "Type"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24"."innet_month(月)"; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24"."innet_month(月)" IS '{"notes": "Number of months using our services", "type_override": "numeric", "label": "Month with service"}';


--
-- Name: COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".is_innet; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "0b15b724-fe12-49c9-9b17-e114c025af24".is_innet IS '{"notes": "Wether the user has internet or not", "type_override": "text", "label": "Internet"}';


--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24__id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE "0b15b724-fe12-49c9-9b17-e114c025af24__id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "0b15b724-fe12-49c9-9b17-e114c025af24__id_seq" OWNER TO ckan;

--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE "0b15b724-fe12-49c9-9b17-e114c025af24__id_seq" OWNED BY "0b15b724-fe12-49c9-9b17-e114c025af24"._id;


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "16f7cc6d-3d97-4072-836b-b5180ed980b5" (
    _id integer NOT NULL,
    _full_text tsvector,
    user_id text,
    service_type text,
    product_type text
);


ALTER TABLE "16f7cc6d-3d97-4072-836b-b5180ed980b5" OWNER TO ckan;

--
-- Name: COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".user_id; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".user_id IS '{"notes": "Username of the user", "type_override": "text", "label": "Username"}';


--
-- Name: COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".service_type; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".service_type IS '{"notes": "Type of our service", "type_override": "text", "label": "Service type"}';


--
-- Name: COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".product_type; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "16f7cc6d-3d97-4072-836b-b5180ed980b5".product_type IS '{"notes": "Bandwich available to the user", "type_override": "text", "label": "Product type"}';


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE "16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq" OWNER TO ckan;

--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE "16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq" OWNED BY "16f7cc6d-3d97-4072-836b-b5180ed980b5"._id;


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" (
    _id integer NOT NULL,
    _full_text tsvector,
    user_id text,
    label_name text,
    label_name1 text,
    label_name2 text
);


ALTER TABLE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" OWNER TO ckan;

--
-- Name: COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".user_id; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".user_id IS '{"notes": "Username of the user", "type_override": "text", "label": "Username"}';


--
-- Name: COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name IS '{"notes": "Service", "type_override": "text", "label": "Label"}';


--
-- Name: COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name1; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name1 IS '{"notes": "Service 1", "type_override": "text", "label": "Label 1"}';


--
-- Name: COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name2; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3".label_name2 IS '{"notes": "Service 2", "type_override": "text", "label": "Label 2"}';


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq" OWNER TO ckan;

--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq" OWNED BY "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3"._id;


--
-- Name: _table_metadata; Type: VIEW; Schema: public; Owner: ckan
--

CREATE VIEW _table_metadata AS
 SELECT DISTINCT substr(md5(((dependee.relname)::text || (COALESCE(dependent.relname, ''::name))::text)), 0, 17) AS _id,
    dependee.relname AS name,
    dependee.oid,
    dependent.relname AS alias_of
   FROM (((pg_class dependee
     LEFT JOIN pg_rewrite r ON ((r.ev_class = dependee.oid)))
     LEFT JOIN pg_depend d ON ((d.objid = r.oid)))
     LEFT JOIN pg_class dependent ON ((d.refobjid = dependent.oid)))
  WHERE (((dependee.oid <> dependent.oid) OR (dependent.oid IS NULL)) AND ((dependee.relname IN ( SELECT pg_tables.tablename
           FROM pg_tables)) OR (dependee.relname IN ( SELECT pg_views.viewname
           FROM pg_views))) AND (dependee.relnamespace = ( SELECT pg_namespace.oid
           FROM pg_namespace
          WHERE (pg_namespace.nspname = 'public'::name))))
  ORDER BY dependee.oid DESC;


ALTER TABLE _table_metadata OWNER TO ckan;

--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "a42f0a61-e0de-4cf6-add8-4fe21c29676a" (
    _id integer NOT NULL,
    _full_text tsvector,
    user_id text,
    month numeric,
    day numeric,
    prov text,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    current_lac text,
    current_ci text,
    eventtype text
);


ALTER TABLE "a42f0a61-e0de-4cf6-add8-4fe21c29676a" OWNER TO ckan;

--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".user_id; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".user_id IS '{"notes": "Username of the user", "type_override": "text", "label": "Username"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".month; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".month IS '{"notes": "Month and year of the event", "type_override": "numeric", "label": "Month and Year"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".day; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".day IS '{"notes": "Day of the service", "type_override": "text", "label": "Day"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".prov; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".prov IS '{"notes": "Location where the event occurred", "type_override": "text", "label": "Province"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".start_time; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".start_time IS '{"notes": "Start time of the event", "type_override": "timestamp", "label": "Start time"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".end_time; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".end_time IS '{"notes": "End time of the event", "type_override": "text", "label": "End time"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".current_lac; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".current_lac IS '{"notes": "", "type_override": "text", "label": "LAC"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".current_ci; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".current_ci IS '{"notes": "", "type_override": "text", "label": "CI"}';


--
-- Name: COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".eventtype; Type: COMMENT; Schema: public; Owner: ckan
--

COMMENT ON COLUMN "a42f0a61-e0de-4cf6-add8-4fe21c29676a".eventtype IS '{"notes": "Type of event attended\r\n\r\n### Types \r\n\r\n* Type 1\r\n* Type 2", "type_override": "text", "label": "Event type"}';


--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE "a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq" OWNER TO ckan;

--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE "a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq" OWNED BY "a42f0a61-e0de-4cf6-add8-4fe21c29676a"._id;


--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24 _id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "0b15b724-fe12-49c9-9b17-e114c025af24" ALTER COLUMN _id SET DEFAULT nextval('"0b15b724-fe12-49c9-9b17-e114c025af24__id_seq"'::regclass);


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5 _id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "16f7cc6d-3d97-4072-836b-b5180ed980b5" ALTER COLUMN _id SET DEFAULT nextval('"16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq"'::regclass);


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3 _id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" ALTER COLUMN _id SET DEFAULT nextval('"3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq"'::regclass);


--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a _id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "a42f0a61-e0de-4cf6-add8-4fe21c29676a" ALTER COLUMN _id SET DEFAULT nextval('"a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq"'::regclass);


--
-- Data for Name: 0b15b724-fe12-49c9-9b17-e114c025af24; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "0b15b724-fe12-49c9-9b17-e114c025af24" (_id, _full_text, user_id, cust_sex, cert_age, area, cust_type, "innet_month(月)", is_innet) FROM stdin;
1	'36':4 '53':3 'f2263d71e6bacff58de7b0817d0d1f09':2 '公众客户':1 '北京市':6 '女':5 '本期在网':7	F2263D71E6BACFF58DE7B0817D0D1F09	女	36	北京市	公众客户	53	本期在网
2	'44':3 '67':5 '76a785aa113dc1f9fb0be97caaeb2a40':2 '公众客户':1 '北京市':6 '女':4 '本期在网':7	76A785AA113DC1F9FB0BE97CAAEB2A40	女	44	北京市	公众客户	67	本期在网
3	'164':4 '37d6032e04ecae6a210b2afdec537d94':7 '52':2 '公众客户':1 '北京市':5 '本期在网':6 '男':3	37D6032E04ECAE6A210B2AFDEC537D94	男	52	北京市	公众客户	164	本期在网
4	'27':2 '32':3 'cf037f15bb662931dc722e673d885ad2':5 '公众客户':1 '北京市':6 '女':4 '本期在网':7	CF037F15BB662931DC722E673D885AD2	女	32	北京市	公众客户	27	本期在网
5	'25':1 '57':4 'cf99990bee2020f72345e16e29bea442':3 '公众客户':2 '北京市':6 '本期在网':7 '男':5	CF99990BEE2020F72345E16E29BEA442	男	57	北京市	公众客户	25	本期在网
6	'60e3200':2 '61':4 '68':6 'a2da2279a0cbbc6e69c2a66ec':3 '公众客户':1 '北京市':7 '本期在网':8 '男':5	60E3200A2DA2279A0CBBC6E69C2A66EC	男	61	北京市	公众客户	68	本期在网
7	'30':2 '6':6 '69e85':3 'cbb13444f45b87c1d6511d55a6c':4 '公众客户':1 '北京市':7 '女':5 '本期在网':8	69E85CBB13444F45B87C1D6511D55A6C	女	30	北京市	公众客户	6	本期在网
8	'44':3 '54':2 '729a4bae41b2a294c64c561778216699':4 '公众客户':1 '北京市':6 '本期在网':7 '男':5	729A4BAE41B2A294C64C561778216699	男	44	北京市	公众客户	54	本期在网
9	'25':1 '62':3 '6f573533f089ebd4ac08b11811e6706c':5 '公众客户':2 '北京市':6 '女':4 '本期在网':7	6F573533F089EBD4AC08B11811E6706C	女	25	北京市	公众客户	62	本期在网
10	'39':1 '61abd0a27c639121b47acc11c2e3b747':3 '70':5 '公众客户':2 '北京市':6 '本期在网':7 '男':4	61ABD0A27C639121B47ACC11C2E3B747	男	39	北京市	公众客户	70	本期在网
\.


--
-- Data for Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "16f7cc6d-3d97-4072-836b-b5180ed980b5" (_id, _full_text, user_id, service_type, product_type) FROM stdin;
1	'200m流量':2 '407aaaa19c1cab68d09a950539f140f7':1 '4g业务':3	407AAAA19C1CAB68D09A950539F140F7	4G业务	200M流量
2	'4g业务':1 '62f0904a43c28e9a6b574f64e6da305b':3 '基本套餐':2	62F0904A43C28E9A6B574F64E6DA305B	4G业务，基本套餐	\N
3	'4755f92173b779c423f49ab6ea287625':1 '4g业务':2 '基本套餐':3	4755F92173B779C423F49AB6EA287625	4G业务	基本套餐
4	'4g业务':4 '6a25ed5aae1b651ded7125415c1a3edd':5 '校园专属':2 '校园专属-非小区a套餐':1 '非小区a套餐':3	6A25ED5AAE1B651DED7125415C1A3EDD	4G业务	校园专属-非小区A套餐
5	'4g业务':1 '4g本地行业套餐':3 '64880161c2ddc3d047308133444cbc95':2	64880161C2DDC3D047308133444CBC95	4G业务	4G本地行业套餐
6	'4g业务':1 'c6be808278f4146eb03a267117857b96':2 '校园专属':4 '校园专属-非小区b套餐':3 '非小区b套餐':5	C6BE808278F4146EB03A267117857B96	4G业务	校园专属-非小区B套餐
7	'4g业务':1 '52f816b009e7f0846bdbf8419ef9b126':2 '基本套餐':3	52F816B009E7F0846BDBF8419EF9B126	4G业务	基本套餐
8	'4g业务':1 '4g本地行业套餐':3 '724dd0117d5022193254ec925bcdeb27':2	724DD0117D5022193254EC925BCDEB27	4G业务	4G本地行业套餐
9	'4g业务':1 'fdfbc73845ac1ccf3f1d10968e5ee17e':2 '基本套餐':3	FDFBC73845AC1CCF3F1D10968E5EE17E	4G业务	基本套餐
10	'4g业务':2 'eb8254524454d6ab5431ab68319d20c9':1 '基本套餐':3	EB8254524454D6AB5431AB68319D20C9	4G业务	基本套餐
\.


--
-- Data for Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" (_id, _full_text, user_id, label_name, label_name1, label_name2) FROM stdin;
1	'5f248e63f3c8789bc72de6c376971074':2 '地图导航':3 '生活服务':1	5F248E63F3C8789BC72DE6C376971074	地图导航	生活服务	地图导航
2	'5f248e63f3c8789bc72de6c376971074':1 '商务应用':2 '网上购物':3	5F248E63F3C8789BC72DE6C376971074	网上购物	商务应用	网上购物
3	'a7eddac7e0634d2693318d3bd66ee772':3 '母婴资讯':2 '生活服务':1	A7EDDAC7E0634D2693318D3BD66EE772	母婴资讯	生活服务	母婴资讯
4	'b8205064bb63a0f436c3907d430b0072':1 '生活服务':2 '生活综合':3	B8205064BB63A0F436C3907D430B0072	生活综合	生活服务	生活综合
5	'9243a19c24160a1174143bdf1a26448b':3 '工具软件':1 '浏览器':2	9243A19C24160A1174143BDF1A26448B	浏览器	工具软件	浏览器
6	'670856a2575509d3e50061a914f194e6':2 '生活服务':1 '生活综合':3	670856A2575509D3E50061A914F194E6	生活综合	生活服务	生活综合
7	'd9ea768ca8d949967eeb14a63c5988b8':1 '网上营业厅':2 '自有业务':3	D9EA768CA8D949967EEB14A63C5988B8	网上营业厅	自有业务	网上营业厅
8	'd9ea768ca8d949967eeb14a63c5988b8':1 '安全杀毒':2 '工具软件':3	D9EA768CA8D949967EEB14A63C5988B8	安全杀毒	工具软件	安全杀毒
9	'1a7c573fedf0cc3a75bdbd94f6306b98':3 '娱乐休闲':1 '手机阅读':2 '期刊杂志':4	1A7C573FEDF0CC3A75BDBD94F6306B98	期刊杂志	娱乐休闲	手机阅读
10	'37d6032e04ecae6a210b2afdec537d94':3 '娱乐休闲':2 '摄影图片':1	37D6032E04ECAE6A210B2AFDEC537D94	摄影图片	娱乐休闲	摄影图片
\.


--
-- Data for Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "a42f0a61-e0de-4cf6-add8-4fe21c29676a" (_id, _full_text, user_id, month, day, prov, start_time, end_time, current_lac, current_ci, eventtype) FROM stdin;
1	'-11':6,15 '-30':7,16 '02':9 '2016':5,14 '201611':12 '28':18 '30':3 '37.411560':19 '3c6d4f6a20e08ad47557b4fc5e67dbc8':2 '4d035d9363b8ea2e0b9e507652356c8b':13 '57.709859':10 'c45008212f7bdf6eab6050c2a564435a':11 'mo呼叫':1 't11':8,17 '河北':4	4D035D9363B8EA2E0B9E507652356C8B	201611	30	河北	2016-11-30 11:02:57.709859	2016-11-30 11:28:37.41156	C45008212F7BDF6EAB6050C2A564435A	3C6D4F6A20E08AD47557B4FC5E67DBC8	MO呼叫
2	'-11':7,15 '-30':8,16 '10':18 '12':10 '2016':6,14 '201611':12 '21.675537':11 '30':4 '56.240188':19 '8c0f24a304f10044bcb756fd2ab2370f':3 '8d74bf8864f7a59c6f96db6eb5a59289':13 'd0e252c435653c99e5ab2b10a74c5d9c':1 'mo呼叫':2 't11':9,17 '河北':5	D0E252C435653C99E5AB2B10A74C5D9C	201611	30	河北	2016-11-30 11:10:56.240188	2016-11-30 11:12:21.675537	8C0F24A304F10044BCB756FD2AB2370F	8D74BF8864F7A59C6F96DB6EB5A59289	MO呼叫
3	'-11':7,15 '-30':8,16 '2016':6,14 '201611':12 '28':10,18 '30':4 '37.905308':19 '38.485847':11 '3802a790a46bbd07be516237da0ff53d':2 'db4db5ec58a9433419cb104eeab915c2':3 'dec1e5301a9bb8588d3e554e9060267f':13 'mo呼叫':1 't11':9,17 '河北':5	DEC1E5301A9BB8588D3E554E9060267F	201611	30	河北	2016-11-30 11:28:37.905308	2016-11-30 11:28:38.485847	DB4DB5EC58A9433419CB104EEAB915C2	3802A790A46BBD07BE516237DA0FF53D	MO呼叫
4	'-11':5,13 '-30':6,14 '2016':4,12 '201611':11 '21.242639':17 '21675fc8afec8db716b774649f566ce3':10 '30':2 '31':8,16 '48.233599':9 '9340ebc648b62d55fb18ab88aaa8fecd':19 'c3d140f52645a0c80f9b051b35c74317':18 'mo呼叫':1 't11':7,15 '河北':3	C3D140F52645A0C80F9B051B35C74317	201611	30	河北	2016-11-30 11:31:21.242639	2016-11-30 11:31:48.233599	9340EBC648B62D55FB18AB88AAA8FECD	21675FC8AFEC8DB716B774649F566CE3	MO呼叫
5	'-11':7,15 '-30':8,16 '18.465888':19 '2016':6,14 '201611':12 '28':10,18 '30':4 '38.525167':11 '3802a790a46bbd07be516237da0ff53d':2 'db4db5ec58a9433419cb104eeab915c2':3 'dec1e5301a9bb8588d3e554e9060267f':13 'mo呼叫':1 't11':9,17 '河北':5	DEC1E5301A9BB8588D3E554E9060267F	201611	30	河北	2016-11-30 11:28:18.465888	2016-11-30 11:28:38.525167	DB4DB5EC58A9433419CB104EEAB915C2	3802A790A46BBD07BE516237DA0FF53D	MO呼叫
6	'-11':4,10 '-30':5,11 '06.205497':14 '20.730899':8 '2016':3,9 '201611':17 '30':15 '31':13 '32':7 'a0715b3d3eeed8446fc3bf227c1e4b83':1 'a197697ac348ad657dd4403d10df2169':19 'e71bef2e0416dc1a97bf95f99265440e':18 'mo呼叫':2 't11':6,12 '河北':16	A197697AC348AD657DD4403D10DF2169	201611	30	河北	2016-11-30 11:31:06.205497	2016-11-30 11:32:20.730899	A0715B3D3EEED8446FC3BF227C1E4B83	E71BEF2E0416DC1A97BF95F99265440E	MO呼叫
7	'-11':4,15 '-30':5,16 '12':7,18 '2016':3,14 '201611':13 '30':10 '33.942723':19 '35.143656':8 '39ac91f2a28396c0057f2677e2a8fda3':9 '4c92d46d3b1aad8a64eb35d7312d067c':1 '77aa696166c4109391739cc12d86db4b':12 'mo呼叫':2 't11':6,17 '河北':11	77AA696166C4109391739CC12D86DB4B	201611	30	河北	2016-11-30 11:12:33.942723	2016-11-30 11:12:35.143656	39AC91F2A28396C0057F2677E2A8FDA3	4C92D46D3B1AAD8A64EB35D7312D067C	MO呼叫
8	'-11':6,14 '-30':7,15 '2016':5,13 '201611':11 '24.980069':18 '30':3 '32':9,17 '34.679693':10 '4ddc45a9de1065695a90e87be37471c0':1 '6b640eee4dfe787ecb9f969379d6adcc':12 'e18b6f179b6a5a068a01655542f9b6de':19 'mo呼叫':2 't11':8,16 '河北':4	6B640EEE4DFE787ECB9F969379D6ADCC	201611	30	河北	2016-11-30 11:32:24.980069	2016-11-30 11:32:34.679693	4DDC45A9DE1065695A90E87BE37471C0	E18B6F179B6A5A068A01655542F9B6DE	MO呼叫
9	'-11':5,13 '-30':6,14 '06.445677':17 '17':8 '18':16 '2016':4,12 '201611':20 '30':10 '43e530':2 '59.847738':9 'acb29a9a375fe8383172c8e24838effc':18 'c8a5728d7738fbf989900cd2bc':3 'f9e817650f505b7c38f29416dfd0ba69':19 'mo呼叫':1 't11':7,15 '河北':11	ACB29A9A375FE8383172C8E24838EFFC	201611	30	河北	2016-11-30 11:17:59.847738	2016-11-30 11:18:06.445677	F9E817650F505B7C38F29416DFD0BA69	43E530C8A5728D7738FBF989900CD2BC	MO呼叫
10	'-11':5,12 '-30':6,13 '08.235825':16 '11':8 '12':15 '2016':4,11 '201611':19 '30':17 '30.558418':9 '359e233993':1 '3d3b11c82385c3cc8c48ae6b1c8bb780':20 '945beadd1794ee1affd8a65dad8b844e':10 'd8d2f9790b8265373433d6':2 'mo呼叫':3 't11':7,14 '河北':18	3D3B11C82385C3CC8C48AE6B1C8BB780	201611	30	河北	2016-11-30 11:11:30.558418	2016-11-30 11:12:08.235825	359E233993D8D2F9790B8265373433D6	945BEADD1794EE1AFFD8A65DAD8B844E	MO呼叫
\.


--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24__id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('"0b15b724-fe12-49c9-9b17-e114c025af24__id_seq"', 10, true);


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('"16f7cc6d-3d97-4072-836b-b5180ed980b5__id_seq"', 10, true);


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('"3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3__id_seq"', 10, true);


--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('"a42f0a61-e0de-4cf6-add8-4fe21c29676a__id_seq"', 10, true);


--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24 0b15b724-fe12-49c9-9b17-e114c025af24_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "0b15b724-fe12-49c9-9b17-e114c025af24"
    ADD CONSTRAINT "0b15b724-fe12-49c9-9b17-e114c025af24_pkey" PRIMARY KEY (_id);


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5 16f7cc6d-3d97-4072-836b-b5180ed980b5_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "16f7cc6d-3d97-4072-836b-b5180ed980b5"
    ADD CONSTRAINT "16f7cc6d-3d97-4072-836b-b5180ed980b5_pkey" PRIMARY KEY (_id);


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3"
    ADD CONSTRAINT "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3_pkey" PRIMARY KEY (_id);


--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a a42f0a61-e0de-4cf6-add8-4fe21c29676a_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "a42f0a61-e0de-4cf6-add8-4fe21c29676a"
    ADD CONSTRAINT "a42f0a61-e0de-4cf6-add8-4fe21c29676a_pkey" PRIMARY KEY (_id);


--
-- Name: 0cfab68492bf2203c8d5764888072411daa11215; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "0cfab68492bf2203c8d5764888072411daa11215" ON "16f7cc6d-3d97-4072-836b-b5180ed980b5" USING gist (to_tsvector('english'::regconfig, service_type));


--
-- Name: 179e9be9379ffb087ee6e0f4c547447928272d94; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "179e9be9379ffb087ee6e0f4c547447928272d94" ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (to_tsvector('english'::regconfig, is_innet));


--
-- Name: 2438c42d37065628baa8881fa03a570a2dc8dcca; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "2438c42d37065628baa8881fa03a570a2dc8dcca" ON "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" USING gist (to_tsvector('english'::regconfig, label_name1));


--
-- Name: 2e541653ac7dbe45a6cac8e873726558994a7e82; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "2e541653ac7dbe45a6cac8e873726558994a7e82" ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (to_tsvector('english'::regconfig, area));


--
-- Name: 344befd5487e0f0aa6676631df85d39378118268; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "344befd5487e0f0aa6676631df85d39378118268" ON "16f7cc6d-3d97-4072-836b-b5180ed980b5" USING gist (_full_text);


--
-- Name: 39bff87e7c2a4a5f9d05f2ce6ad13cd17d14c19a; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "39bff87e7c2a4a5f9d05f2ce6ad13cd17d14c19a" ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (to_tsvector('english'::regconfig, user_id));


--
-- Name: 3b6f73ee36a294f034ce956005e5fcb0a60ba938; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "3b6f73ee36a294f034ce956005e5fcb0a60ba938" ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (to_tsvector('english'::regconfig, current_ci));


--
-- Name: 485582b0a3df6587ced49a0e1fb04f72cada6aee; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "485582b0a3df6587ced49a0e1fb04f72cada6aee" ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (to_tsvector('english'::regconfig, current_lac));


--
-- Name: 4c2dcfb517fd6c8eba51ac1879c7b45212e3d678; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "4c2dcfb517fd6c8eba51ac1879c7b45212e3d678" ON "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" USING gist (to_tsvector('english'::regconfig, label_name));


--
-- Name: 6a9aa9697529f708e958425690d83512ef41fba7; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "6a9aa9697529f708e958425690d83512ef41fba7" ON "16f7cc6d-3d97-4072-836b-b5180ed980b5" USING gist (to_tsvector('english'::regconfig, user_id));


--
-- Name: 6c829aba1a29084abbe48585dd14d760c6db67b6; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "6c829aba1a29084abbe48585dd14d760c6db67b6" ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (to_tsvector('english'::regconfig, eventtype));


--
-- Name: 8075135a16bdf060fcabd61da067701edd4789e8; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "8075135a16bdf060fcabd61da067701edd4789e8" ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (_full_text);


--
-- Name: 91e8ce5ecdb119e8d933da2303d8e6092a96d259; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "91e8ce5ecdb119e8d933da2303d8e6092a96d259" ON "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" USING gist (to_tsvector('english'::regconfig, label_name2));


--
-- Name: 9daf1e578d5e2d4043c66e36c4e4f74823f1d332; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "9daf1e578d5e2d4043c66e36c4e4f74823f1d332" ON "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" USING gist (_full_text);


--
-- Name: 9fd8a362d8b0ee3d54c4e23e0a381897bc090e20; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX "9fd8a362d8b0ee3d54c4e23e0a381897bc090e20" ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (_full_text);


--
-- Name: b9677d9040fd1c81b08cba6f2b7e6b9f05a8f334; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX b9677d9040fd1c81b08cba6f2b7e6b9f05a8f334 ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (to_tsvector('english'::regconfig, prov));


--
-- Name: c6c27494013956251b406baff20fc9e3c00f5053; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX c6c27494013956251b406baff20fc9e3c00f5053 ON "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" USING gist (to_tsvector('english'::regconfig, user_id));


--
-- Name: cdb83a36d90a36c510cbf7d77a1f0113e46f2bc3; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX cdb83a36d90a36c510cbf7d77a1f0113e46f2bc3 ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (to_tsvector('english'::regconfig, cust_type));


--
-- Name: d5d52e9581400764d25ad48ac65a44da34c8f578; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX d5d52e9581400764d25ad48ac65a44da34c8f578 ON "a42f0a61-e0de-4cf6-add8-4fe21c29676a" USING gist (to_tsvector('english'::regconfig, user_id));


--
-- Name: df9508e887f2092bb2d115eb0df5f3d9d9135dce; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX df9508e887f2092bb2d115eb0df5f3d9d9135dce ON "16f7cc6d-3d97-4072-836b-b5180ed980b5" USING gist (to_tsvector('english'::regconfig, product_type));


--
-- Name: ef1dc571eb89916e9aa40ce14e8828aa6c0ac7f6; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX ef1dc571eb89916e9aa40ce14e8828aa6c0ac7f6 ON "0b15b724-fe12-49c9-9b17-e114c025af24" USING gist (to_tsvector('english'::regconfig, cust_sex));


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO datastore_default;
GRANT ALL ON SCHEMA public TO ckan;


--
-- Name: 0b15b724-fe12-49c9-9b17-e114c025af24; Type: ACL; Schema: public; Owner: ckan
--

GRANT SELECT ON TABLE "0b15b724-fe12-49c9-9b17-e114c025af24" TO datastore_default;


--
-- Name: 16f7cc6d-3d97-4072-836b-b5180ed980b5; Type: ACL; Schema: public; Owner: ckan
--

GRANT SELECT ON TABLE "16f7cc6d-3d97-4072-836b-b5180ed980b5" TO datastore_default;


--
-- Name: 3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3; Type: ACL; Schema: public; Owner: ckan
--

GRANT SELECT ON TABLE "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3" TO datastore_default;


--
-- Name: _table_metadata; Type: ACL; Schema: public; Owner: ckan
--

GRANT SELECT ON TABLE _table_metadata TO datastore_default;


--
-- Name: a42f0a61-e0de-4cf6-add8-4fe21c29676a; Type: ACL; Schema: public; Owner: ckan
--

GRANT SELECT ON TABLE "a42f0a61-e0de-4cf6-add8-4fe21c29676a" TO datastore_default;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: ckan
--

ALTER DEFAULT PRIVILEGES FOR ROLE ckan IN SCHEMA public REVOKE ALL ON TABLES  FROM ckan;
ALTER DEFAULT PRIVILEGES FOR ROLE ckan IN SCHEMA public GRANT SELECT ON TABLES  TO datastore_default;


--
-- PostgreSQL database dump complete
--

