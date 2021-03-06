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
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: ckan
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO ckan;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: ckan
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO ckan;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: ckan
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO ckan;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: ckan
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE activity (
    id text NOT NULL,
    "timestamp" timestamp without time zone,
    user_id text,
    object_id text,
    revision_id text,
    activity_type text,
    data text
);


ALTER TABLE activity OWNER TO ckan;

--
-- Name: activity_detail; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE activity_detail (
    id text NOT NULL,
    activity_id text,
    object_id text,
    object_type text,
    activity_type text,
    data text
);


ALTER TABLE activity_detail OWNER TO ckan;

--
-- Name: authorization_group; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE authorization_group (
    id text NOT NULL,
    name text,
    created timestamp without time zone
);


ALTER TABLE authorization_group OWNER TO ckan;

--
-- Name: authorization_group_user; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE authorization_group_user (
    authorization_group_id text NOT NULL,
    user_id text NOT NULL,
    id text NOT NULL
);


ALTER TABLE authorization_group_user OWNER TO ckan;

--
-- Name: dashboard; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE dashboard (
    user_id text NOT NULL,
    activity_stream_last_viewed timestamp without time zone NOT NULL,
    email_last_sent timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone NOT NULL
);


ALTER TABLE dashboard OWNER TO ckan;

--
-- Name: group; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "group" (
    id text NOT NULL,
    name text NOT NULL,
    title text,
    description text,
    created timestamp without time zone,
    state text,
    revision_id text,
    type text NOT NULL,
    approval_status text,
    image_url text,
    is_organization boolean DEFAULT false
);


ALTER TABLE "group" OWNER TO ckan;

--
-- Name: group_extra; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE group_extra (
    id text NOT NULL,
    group_id text,
    key text,
    value text,
    state text,
    revision_id text
);


ALTER TABLE group_extra OWNER TO ckan;

--
-- Name: group_extra_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE group_extra_revision (
    id text NOT NULL,
    group_id text,
    key text,
    value text,
    state text,
    revision_id text NOT NULL,
    continuity_id text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean
);


ALTER TABLE group_extra_revision OWNER TO ckan;

--
-- Name: group_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE group_revision (
    id text NOT NULL,
    name text NOT NULL,
    title text,
    description text,
    created timestamp without time zone,
    state text,
    revision_id text NOT NULL,
    continuity_id text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean,
    type text NOT NULL,
    approval_status text,
    image_url text,
    is_organization boolean DEFAULT false
);


ALTER TABLE group_revision OWNER TO ckan;

--
-- Name: member; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE member (
    id text NOT NULL,
    table_id text NOT NULL,
    group_id text,
    state text,
    revision_id text,
    table_name text NOT NULL,
    capacity text NOT NULL
);


ALTER TABLE member OWNER TO ckan;

--
-- Name: member_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE member_revision (
    id text NOT NULL,
    table_id text NOT NULL,
    group_id text,
    state text,
    revision_id text NOT NULL,
    continuity_id text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean,
    table_name text NOT NULL,
    capacity text NOT NULL
);


ALTER TABLE member_revision OWNER TO ckan;

--
-- Name: migrate_version; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE migrate_version (
    repository_id character varying(250) NOT NULL,
    repository_path text,
    version integer
);


ALTER TABLE migrate_version OWNER TO ckan;

--
-- Name: package; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package (
    id text NOT NULL,
    name character varying(100) NOT NULL,
    title text,
    version character varying(100),
    url text,
    notes text,
    license_id text,
    revision_id text,
    author text,
    author_email text,
    maintainer text,
    maintainer_email text,
    state text,
    type text,
    owner_org text,
    private boolean DEFAULT false,
    metadata_modified timestamp without time zone,
    creator_user_id text,
    metadata_created timestamp without time zone
);


ALTER TABLE package OWNER TO ckan;

--
-- Name: package_extra; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_extra (
    id text NOT NULL,
    package_id text,
    key text,
    value text,
    revision_id text,
    state text
);


ALTER TABLE package_extra OWNER TO ckan;

--
-- Name: package_extra_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_extra_revision (
    id text NOT NULL,
    package_id text,
    key text,
    value text,
    revision_id text NOT NULL,
    continuity_id text,
    state text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean
);


ALTER TABLE package_extra_revision OWNER TO ckan;

--
-- Name: package_relationship; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_relationship (
    id text NOT NULL,
    subject_package_id text,
    object_package_id text,
    type text,
    comment text,
    revision_id text,
    state text
);


ALTER TABLE package_relationship OWNER TO ckan;

--
-- Name: package_relationship_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_relationship_revision (
    id text NOT NULL,
    subject_package_id text,
    object_package_id text,
    type text,
    comment text,
    revision_id text NOT NULL,
    continuity_id text,
    state text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean
);


ALTER TABLE package_relationship_revision OWNER TO ckan;

--
-- Name: package_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_revision (
    id text NOT NULL,
    name character varying(100) NOT NULL,
    title text,
    version character varying(100),
    url text,
    notes text,
    license_id text,
    revision_id text NOT NULL,
    continuity_id text,
    author text,
    author_email text,
    maintainer text,
    maintainer_email text,
    state text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean,
    type text,
    owner_org text,
    private boolean DEFAULT false,
    metadata_modified timestamp without time zone,
    creator_user_id text,
    metadata_created timestamp without time zone
);


ALTER TABLE package_revision OWNER TO ckan;

--
-- Name: package_tag; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_tag (
    id text NOT NULL,
    package_id text,
    tag_id text,
    revision_id text,
    state text
);


ALTER TABLE package_tag OWNER TO ckan;

--
-- Name: package_tag_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE package_tag_revision (
    id text NOT NULL,
    package_id text,
    tag_id text,
    revision_id text NOT NULL,
    continuity_id text,
    state text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean
);


ALTER TABLE package_tag_revision OWNER TO ckan;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE rating (
    id text NOT NULL,
    user_id text,
    user_ip_address text,
    package_id text,
    rating double precision,
    created timestamp without time zone
);


ALTER TABLE rating OWNER TO ckan;

--
-- Name: resource; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE resource (
    id text NOT NULL,
    url text NOT NULL,
    format text,
    description text,
    "position" integer,
    revision_id text,
    hash text,
    state text,
    extras text,
    name text,
    resource_type text,
    mimetype text,
    mimetype_inner text,
    size bigint,
    last_modified timestamp without time zone,
    cache_url text,
    cache_last_updated timestamp without time zone,
    webstore_url text,
    webstore_last_updated timestamp without time zone,
    created timestamp without time zone,
    url_type text,
    package_id text DEFAULT ''::text NOT NULL
);


ALTER TABLE resource OWNER TO ckan;

--
-- Name: resource_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE resource_revision (
    id text NOT NULL,
    url text NOT NULL,
    format text,
    description text,
    "position" integer,
    revision_id text NOT NULL,
    continuity_id text,
    hash text,
    state text,
    extras text,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean,
    name text,
    resource_type text,
    mimetype text,
    mimetype_inner text,
    size bigint,
    last_modified timestamp without time zone,
    cache_url text,
    cache_last_updated timestamp without time zone,
    webstore_url text,
    webstore_last_updated timestamp without time zone,
    created timestamp without time zone,
    url_type text,
    package_id text DEFAULT ''::text NOT NULL
);


ALTER TABLE resource_revision OWNER TO ckan;

--
-- Name: resource_view; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE resource_view (
    id text NOT NULL,
    resource_id text,
    title text,
    description text,
    view_type text NOT NULL,
    "order" integer NOT NULL,
    config text
);


ALTER TABLE resource_view OWNER TO ckan;

--
-- Name: revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE revision (
    id text NOT NULL,
    "timestamp" timestamp without time zone,
    author character varying(200),
    message text,
    state text,
    approved_timestamp timestamp without time zone
);


ALTER TABLE revision OWNER TO ckan;

--
-- Name: system_info; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE system_info (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    revision_id text,
    state text DEFAULT 'active'::text NOT NULL
);


ALTER TABLE system_info OWNER TO ckan;

--
-- Name: system_info_id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE system_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE system_info_id_seq OWNER TO ckan;

--
-- Name: system_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE system_info_id_seq OWNED BY system_info.id;


--
-- Name: system_info_revision; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE system_info_revision (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    revision_id text NOT NULL,
    continuity_id integer,
    state text DEFAULT 'active'::text NOT NULL,
    expired_id text,
    revision_timestamp timestamp without time zone,
    expired_timestamp timestamp without time zone,
    current boolean
);


ALTER TABLE system_info_revision OWNER TO ckan;

--
-- Name: system_info_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: ckan
--

CREATE SEQUENCE system_info_revision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE system_info_revision_id_seq OWNER TO ckan;

--
-- Name: system_info_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan
--

ALTER SEQUENCE system_info_revision_id_seq OWNED BY system_info_revision.id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE tag (
    id text NOT NULL,
    name character varying(100) NOT NULL,
    vocabulary_id character varying(100)
);


ALTER TABLE tag OWNER TO ckan;

--
-- Name: task_status; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE task_status (
    id text NOT NULL,
    entity_id text NOT NULL,
    entity_type text NOT NULL,
    task_type text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    state text,
    error text,
    last_updated timestamp without time zone
);


ALTER TABLE task_status OWNER TO ckan;

--
-- Name: term_translation; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE term_translation (
    term text NOT NULL,
    term_translation text NOT NULL,
    lang_code text NOT NULL
);


ALTER TABLE term_translation OWNER TO ckan;

--
-- Name: tracking_raw; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE tracking_raw (
    user_key character varying(100) NOT NULL,
    url text NOT NULL,
    tracking_type character varying(10) NOT NULL,
    access_timestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE tracking_raw OWNER TO ckan;

--
-- Name: tracking_summary; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE tracking_summary (
    url text NOT NULL,
    package_id text,
    tracking_type character varying(10) NOT NULL,
    count integer NOT NULL,
    running_total integer DEFAULT 0 NOT NULL,
    recent_views integer DEFAULT 0 NOT NULL,
    tracking_date date
);


ALTER TABLE tracking_summary OWNER TO ckan;

--
-- Name: user; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE "user" (
    id text NOT NULL,
    name text NOT NULL,
    apikey text,
    created timestamp without time zone,
    about text,
    openid text,
    password text,
    fullname text,
    email text,
    reset_key text,
    sysadmin boolean DEFAULT false,
    activity_streams_email_notifications boolean DEFAULT false,
    state text DEFAULT 'active'::text NOT NULL
);


ALTER TABLE "user" OWNER TO ckan;

--
-- Name: user_following_dataset; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE user_following_dataset (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE user_following_dataset OWNER TO ckan;

--
-- Name: user_following_group; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE user_following_group (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE user_following_group OWNER TO ckan;

--
-- Name: user_following_user; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE user_following_user (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE user_following_user OWNER TO ckan;

--
-- Name: vocabulary; Type: TABLE; Schema: public; Owner: ckan
--

CREATE TABLE vocabulary (
    id text NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE vocabulary OWNER TO ckan;

--
-- Name: system_info id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info ALTER COLUMN id SET DEFAULT nextval('system_info_id_seq'::regclass);


--
-- Name: system_info_revision id; Type: DEFAULT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info_revision ALTER COLUMN id SET DEFAULT nextval('system_info_revision_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY activity (id, "timestamp", user_id, object_id, revision_id, activity_type, data) FROM stdin;
34f2c423-e8b4-40b3-8ffe-d22e751ec5e7	2017-08-08 16:45:41.113149	17755db4-395a-4b3b-ac09-e8e3484ca700	17755db4-395a-4b3b-ac09-e8e3484ca700	\N	new user	\N
349ee903-ed55-4d30-984f-4b1fe9a6df35	2017-08-08 16:46:26.188993	17755db4-395a-4b3b-ac09-e8e3484ca700	724ae83b-ae78-433c-8586-69e7202931c4	729f6192-b932-4413-904c-a72e21f8ef69	new organization	{"group": {"description": "China United Network Communications Group Co., Ltd. (Chinese: 中国联合网络通信集团有限公司) or China Unicom (Chinese: 中国联通) is a Chinese state-owned telecommunications operator in the People's Republic of China. China Unicom is the world's fourth-largest mobile service provider by subscriber base.", "title": "China UNICOM", "created": "2017-08-08T16:46:26.164305", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "https://upload.wikimedia.org/wikipedia/en/thumb/f/fa/China_Unicom.svg/252px-China_Unicom.svg.png", "revision_id": "729f6192-b932-4413-904c-a72e21f8ef69", "type": "organization", "id": "724ae83b-ae78-433c-8586-69e7202931c4", "name": "china-unicom"}}
79cd60d9-b153-4584-8e8b-c2418b824b01	2017-08-08 16:50:27.383826	17755db4-395a-4b3b-ac09-e8e3484ca700	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	new package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:26.707978", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "2b61e1eb-c56d-4852-b55c-47f0e7308c6e", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
ee660257-e306-4c18-adb7-721940032324	2017-08-08 16:50:50.711252	17755db4-395a-4b3b-ac09-e8e3484ca700	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	3d4c3cf2-2604-49a3-b846-bcfca91c4b22	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:49.591262", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "2b61e1eb-c56d-4852-b55c-47f0e7308c6e", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
c2459c06-478a-4893-98c9-c2bc1c9d8045	2017-08-08 16:50:51.427455	17755db4-395a-4b3b-ac09-e8e3484ca700	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	bffaa2dd-7e21-45e1-9c62-336b10a1381d	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:50.837755", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "bffaa2dd-7e21-45e1-9c62-336b10a1381d", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
d5c7c2f1-11ba-40e7-a9cf-387cfbe4f9da	2017-08-08 16:52:30.212465	17755db4-395a-4b3b-ac09-e8e3484ca700	903d964e-9c2c-47d2-8708-25363ef8d772	65a08933-48aa-426b-bf8a-d11aa32dca95	new package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:29.614984", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "65a08933-48aa-426b-bf8a-d11aa32dca95", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
3e8e8301-501f-4e6f-9b5e-5ba0b4b47767	2017-08-08 16:52:49.548884	17755db4-395a-4b3b-ac09-e8e3484ca700	903d964e-9c2c-47d2-8708-25363ef8d772	15c99021-e05b-4678-b035-a1e8203dd9e1	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:48.402586", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "65a08933-48aa-426b-bf8a-d11aa32dca95", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
8d57bc35-165b-455c-bce7-202977427302	2017-08-08 16:52:50.181502	17755db4-395a-4b3b-ac09-e8e3484ca700	903d964e-9c2c-47d2-8708-25363ef8d772	ba506755-adf8-4f97-bf70-90355c658dd7	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:49.648987", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "ba506755-adf8-4f97-bf70-90355c658dd7", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
856541dc-535f-4a05-aa53-6173b63b6c80	2017-08-08 16:54:35.903892	17755db4-395a-4b3b-ac09-e8e3484ca700	817668d7-be70-479e-92c6-c7e4e8182603	8b393d77-16b0-4e7c-b64e-63acf71345d5	new package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:54:35.136352", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "8b393d77-16b0-4e7c-b64e-63acf71345d5", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
977f7a94-cd3c-4284-9260-cd73d8b5ecc9	2017-08-08 16:55:28.396814	17755db4-395a-4b3b-ac09-e8e3484ca700	817668d7-be70-479e-92c6-c7e4e8182603	4537cbb8-b49b-4611-9721-a775af0095fe	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:55:27.253651", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "8b393d77-16b0-4e7c-b64e-63acf71345d5", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
a2db6a75-ed2e-40cf-8ec5-0a54cea6b228	2017-08-08 16:55:29.097122	17755db4-395a-4b3b-ac09-e8e3484ca700	817668d7-be70-479e-92c6-c7e4e8182603	d2a0b75b-4856-4b6c-affc-729a99bbe985	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:55:28.497851", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "d2a0b75b-4856-4b6c-affc-729a99bbe985", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
92ab1224-9afe-422a-9a03-5337c6805189	2017-08-08 16:57:30.780325	17755db4-395a-4b3b-ac09-e8e3484ca700	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	new package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:30.243013", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "dd70f0dc-ac9d-4ea3-8888-ddb077b44502", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
0fd4c8b8-6bee-4b9b-a0ee-d17059501409	2017-08-08 16:57:43.011765	17755db4-395a-4b3b-ac09-e8e3484ca700	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	1815b63f-6afc-43d0-aac9-d8a9daec8f93	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:41.818903", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "dd70f0dc-ac9d-4ea3-8888-ddb077b44502", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
667f1e21-dd0f-4c38-896b-81c6a3f80682	2017-08-08 16:57:43.644775	17755db4-395a-4b3b-ac09-e8e3484ca700	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	18ca3b06-e9d5-4129-b12c-1eacc9c8de32	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:43.112965", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "18ca3b06-e9d5-4129-b12c-1eacc9c8de32", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
af4d03ce-89ab-4aee-bf36-2180e3a461a2	2017-08-09 09:04:45.585197	17755db4-395a-4b3b-ac09-e8e3484ca700	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	9280682a-0335-4e81-85d6-52933a06e3c9	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-09T09:04:44.595145", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "18ca3b06-e9d5-4129-b12c-1eacc9c8de32", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
95939c34-a48c-4b67-845b-034d3c67bf17	2017-11-23 17:07:42.114419	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	1d7a208f-a535-4f6d-ad3c-18d8c9866feb	new package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:07:42.009865", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "1d7a208f-a535-4f6d-ad3c-18d8c9866feb", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
29dde80c-6d54-45d6-b46c-513673c9592b	2017-11-23 17:07:50.774252	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	d74a18d9-14a3-40a4-b848-d1d9148e2102	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:07:50.644778", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "1d7a208f-a535-4f6d-ad3c-18d8c9866feb", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
fcdef847-909e-438e-bdf4-a31cdaf1f4c3	2017-11-23 17:07:50.910006	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	76a15254-7ed3-4c64-94e0-4c93fd886a70	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:07:50.816957", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
f1caf191-27d6-4fa1-9514-f5182198c9cb	2017-11-23 17:10:49.456915	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	61558a1e-8f38-4eea-be11-4831ab21f9ab	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:10:49.355965", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
5427f274-8abe-4927-8d90-6c7dcd9fcb53	2017-11-23 17:11:24.080889	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	4609ef6f-b90f-49f1-aef7-0381acb539ba	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:11:23.957264", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
b33f9a10-c386-4940-930a-6ff16982dccc	2017-11-23 17:13:07.283322	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	b832bb18-8732-45d7-858a-97f2a9f85006	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:13:07.174920", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
c0ec79c3-71cf-4dc0-a210-6fd6433196c2	2017-11-23 17:13:31.509843	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	c84a2f2b-7aae-4ce0-9746-ed5ff839a497	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:13:31.390334", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
3f35f708-51ee-4aeb-a4a1-20ca344c80fb	2017-11-23 17:15:23.580018	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	be62d02b-aac3-4fa9-adda-5f7055efe684	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:15:23.475276", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
6cfd936e-6149-4354-96a6-b1686928340c	2017-11-23 17:15:54.520296	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	54de6fec-f172-4558-8292-950fa99f513a	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:15:54.401224", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
8de8fc21-e9ab-4170-83b4-cedda5daf96c	2017-11-23 17:16:10.4882	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	99077077-577e-48cc-bd73-2f28656f45f5	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:16:10.380381", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
5b3ccd7e-4d3e-429a-a469-09668048e259	2017-11-23 17:23:12.635455	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	cd6b8c3c-4df5-42a5-a76a-db925c99dbde	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:23:12.524274", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
0e647a87-b993-44ad-8f2f-1290d2f3ba14	2017-11-23 17:23:33.353019	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	ad0c12ae-80f3-437a-8f31-ce5bef87b962	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:23:33.217281", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
2c31cc42-0ae9-487a-a7a6-bf1ebb4c38f8	2017-11-23 17:25:49.986004	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	2d0e5c97-33d8-47d3-9c65-f334df5365fc	changed package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:25:49.828970", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
931b2bed-223e-4fda-8843-eb51282d69d1	2017-11-23 17:28:58.796512	17755db4-395a-4b3b-ac09-e8e3484ca700	54f83106-f2bf-45a8-8523-53a415c99e47	b8777631-802d-4981-aa3a-b71e40e44ea9	deleted package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:25:49.828970", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "b8777631-802d-4981-aa3a-b71e40e44ea9", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
2766a7e7-4a1a-4992-b441-d78cdb584065	2017-11-23 17:29:52.584551	17755db4-395a-4b3b-ac09-e8e3484ca700	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	78e33def-565f-45dc-b9a4-a1dda81e1ce1	deleted package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:50.837755", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "78e33def-565f-45dc-b9a4-a1dda81e1ce1", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
c6dad858-18de-4062-bbbc-d6aba021ebbd	2017-11-23 17:29:52.647157	17755db4-395a-4b3b-ac09-e8e3484ca700	817668d7-be70-479e-92c6-c7e4e8182603	201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	deleted package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:55:28.497851", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "201d00c8-1f94-43d3-ac75-e9bfeb22a2f4", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
a4aa87f8-fa10-4f5f-844e-81529fa3a411	2017-11-23 17:29:52.785419	17755db4-395a-4b3b-ac09-e8e3484ca700	903d964e-9c2c-47d2-8708-25363ef8d772	7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9	deleted package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:49.648987", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
dffcf571-4cb3-40fe-aef7-1fdc2f345233	2017-11-23 17:30:37.763902	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	34c3de5f-7e58-4806-9177-733da1fca73c	new organization	{"group": {"description": "", "title": "TIB iASiS", "created": "2017-11-23T17:30:37.757128", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "", "revision_id": "34c3de5f-7e58-4806-9177-733da1fca73c", "type": "organization", "id": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "name": "tib-iasis"}}
4e28330a-cc18-4736-9e4a-71dbdada03a7	2017-11-23 17:37:00.449098	17755db4-395a-4b3b-ac09-e8e3484ca700	476cdf71-1048-4a6f-a28a-58fff547dae5	f732828b-2166-4541-9128-f838a260ae1b	new package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:37:00.362905", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f732828b-2166-4541-9128-f838a260ae1b", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
46fe0eca-6275-4d0b-8a5e-df73f411e7dc	2017-11-23 17:37:20.164102	17755db4-395a-4b3b-ac09-e8e3484ca700	476cdf71-1048-4a6f-a28a-58fff547dae5	5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:37:20.059543", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
505a69df-026a-4e8a-9484-855bd449580b	2017-11-23 17:40:23.320077	17755db4-395a-4b3b-ac09-e8e3484ca700	476cdf71-1048-4a6f-a28a-58fff547dae5	f4499856-fe22-47ba-9e93-ac6f2c547685	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:40:23.210138", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
399cb478-9920-4de7-9543-5e8792a122b7	2017-11-23 17:40:57.543313	17755db4-395a-4b3b-ac09-e8e3484ca700	476cdf71-1048-4a6f-a28a-58fff547dae5	40aaa8c6-d66d-4632-bfab-bf3daad5244d	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:40:57.417452", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
78b8e6e8-47a3-44de-8061-3670b189bad0	2017-11-24 13:40:21.973859	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	6d7701f6-3ad0-4073-a1a9-262f793ac188	changed organization	{"group": {"description": "The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.", "title": "TIB", "created": "2017-11-23T17:30:37.757128", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png", "revision_id": "6a333863-cac8-4957-9ed5-968dc91c74be", "type": "organization", "id": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "name": "tib-iasis"}}
11c1f4ab-cfef-4494-aff1-87562f0064ec	2017-11-23 17:29:52.70055	17755db4-395a-4b3b-ac09-e8e3484ca700	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	19ac713d-48f0-48b9-9cd5-7061843bc62f	deleted package	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-09T09:04:44.595145", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "19ac713d-48f0-48b9-9cd5-7061843bc62f", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
f1d2e7db-b0cd-4216-b4df-f222295fa7b6	2017-11-23 17:31:36.658912	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	935c959c-8191-4dc4-81b0-50e9e829d325	changed organization	{"group": {"description": "", "title": "TIB iASiS", "created": "2017-11-23T17:30:37.757128", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png", "revision_id": "34c3de5f-7e58-4806-9177-733da1fca73c", "type": "organization", "id": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "name": "tib-iasis"}}
e3683d94-253c-4730-ae84-19ebe61f2128	2017-11-23 17:32:08.014374	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	6a333863-cac8-4957-9ed5-968dc91c74be	changed organization	{"group": {"description": "The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.", "title": "TIB iASiS", "created": "2017-11-23T17:30:37.757128", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png", "revision_id": "935c959c-8191-4dc4-81b0-50e9e829d325", "type": "organization", "id": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "name": "tib-iasis"}}
3647c32f-8a96-4c6a-8c4c-c4948e364f7f	2017-11-23 17:35:47.492877	17755db4-395a-4b3b-ac09-e8e3484ca700	acc9dc22-eff3-486b-a715-9a69ef93ade0	00277d2f-879f-426e-98e9-39839776d89d	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-videos", "metadata_modified": "2017-11-23T17:35:47.357177", "author": "", "url": "", "notes": "", "title": "Example videos", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "00277d2f-879f-426e-98e9-39839776d89d", "type": "dataset", "id": "acc9dc22-eff3-486b-a715-9a69ef93ade0", "metadata_created": "2017-11-23T17:32:40.506721"}}
ab5731ed-4566-4d86-a364-e1c8a3c7b6eb	2017-11-23 17:37:20.0145	17755db4-395a-4b3b-ac09-e8e3484ca700	476cdf71-1048-4a6f-a28a-58fff547dae5	469f7ad0-8cce-4220-8859-7f640494206b	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:37:19.887042", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f732828b-2166-4541-9128-f838a260ae1b", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
5137f9dd-9882-4bb7-a7b8-0f0fe02a78f5	2017-11-24 12:31:07.787952	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f4b8e39c-ebec-4108-b18e-146f213a6a3b	changed organization	{"group": {"description": "The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.", "title": "TIB iASiS", "created": "2017-11-23T17:30:37.757128", "approval_status": "approved", "is_organization": true, "state": "active", "image_url": "https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png", "revision_id": "6a333863-cac8-4957-9ed5-968dc91c74be", "type": "organization", "id": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "name": "tib-iasis"}}
b6b56eb0-bd29-4995-a1ec-e9d8bf056af0	2017-12-01 11:56:50.818499	17755db4-395a-4b3b-ac09-e8e3484ca700	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	c0d32fee-6737-4a91-920a-d8aab223e545	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T11:56:50.590910", "author": "", "url": "", "notes": "", "title": "Example CAD 2", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "c0d32fee-6737-4a91-920a-d8aab223e545", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
1c0cc55f-1748-43f3-91b4-977ff52f15d3	2017-12-01 11:57:19.470172	17755db4-395a-4b3b-ac09-e8e3484ca700	bf46d212-6fde-4670-ab59-52bb38c513bc	78462af9-3e29-41e7-b739-815aa263ff3d	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "test-jupyter", "metadata_modified": "2017-12-01T11:57:19.351983", "author": "", "url": "", "notes": "", "title": "Test jupyter", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "78462af9-3e29-41e7-b739-815aa263ff3d", "type": "dataset", "id": "bf46d212-6fde-4670-ab59-52bb38c513bc", "metadata_created": "2017-11-28T19:31:59.868119"}}
c9b28971-06de-4022-a7c2-716558a8cd4c	2017-12-01 11:57:31.760832	17755db4-395a-4b3b-ac09-e8e3484ca700	54920aae-f322-4fca-bd09-cd091946632c	beb04331-d499-485b-9369-1f57aa6f7395	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T11:57:31.640981", "author": "", "url": "", "notes": "", "title": "Example video 2", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "beb04331-d499-485b-9369-1f57aa6f7395", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
b8806ae8-b2c3-4970-883f-040d37783bec	2017-12-01 12:26:03.511705	17755db4-395a-4b3b-ac09-e8e3484ca700	acc9dc22-eff3-486b-a715-9a69ef93ade0	f8632874-e874-4ec3-97ce-c15bffe12f28	deleted package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-videos", "metadata_modified": "2017-11-23T17:35:47.357177", "author": "", "url": "", "notes": "", "title": "Example videos", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f8632874-e874-4ec3-97ce-c15bffe12f28", "type": "dataset", "id": "acc9dc22-eff3-486b-a715-9a69ef93ade0", "metadata_created": "2017-11-23T17:32:40.506721"}}
5f389a45-31ea-429b-9247-12758057a04b	2017-12-01 12:26:27.680642	17755db4-395a-4b3b-ac09-e8e3484ca700	54920aae-f322-4fca-bd09-cd091946632c	f69e3832-0198-44c5-a4f2-f52a65fe3ca2	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:26:27.564010", "author": "", "url": "", "notes": "", "title": "Example video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f69e3832-0198-44c5-a4f2-f52a65fe3ca2", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
13df1fff-32cf-4fd2-9abd-ef82e3d75593	2017-12-01 12:27:24.246594	17755db4-395a-4b3b-ac09-e8e3484ca700	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	f42bf4cf-a31c-4645-bb98-9ecbdf58d1ca	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T12:27:24.137068", "author": "", "url": "", "notes": "", "title": "Example CAD Pangaea", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f42bf4cf-a31c-4645-bb98-9ecbdf58d1ca", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
530af8ab-a4ac-46d0-9596-f2413d305e6a	2017-12-01 12:26:42.761463	17755db4-395a-4b3b-ac09-e8e3484ca700	bf46d212-6fde-4670-ab59-52bb38c513bc	4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75	deleted package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "test-jupyter", "metadata_modified": "2017-12-01T11:57:19.351983", "author": "", "url": "", "notes": "", "title": "Test jupyter", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75", "type": "dataset", "id": "bf46d212-6fde-4670-ab59-52bb38c513bc", "metadata_created": "2017-11-28T19:31:59.868119"}}
c3354d91-317e-4469-be79-9bfe6b175946	2017-12-01 12:42:21.114566	17755db4-395a-4b3b-ac09-e8e3484ca700	54920aae-f322-4fca-bd09-cd091946632c	0489aebe-7484-4f6b-a051-9907f1b31b20	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:42:20.934980", "author": "", "url": "", "notes": "", "title": "Example video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f69e3832-0198-44c5-a4f2-f52a65fe3ca2", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
c351585b-0db7-47aa-a58f-7f2a8c01df3a	2017-12-01 12:43:40.032307	17755db4-395a-4b3b-ac09-e8e3484ca700	54920aae-f322-4fca-bd09-cd091946632c	29af1387-94a1-460f-b0d1-fdfb7de377e7	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:43:39.909737", "author": "", "url": "", "notes": "", "title": "Example video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f69e3832-0198-44c5-a4f2-f52a65fe3ca2", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
c28d5815-58c9-4a23-a270-b7e95f9dca25	2017-12-01 12:51:37.580585	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	3951536e-4b6f-4e7a-add1-b55c5002dcc0	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:51:37.466460", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
caf40a6b-9a5b-4a50-a544-09e2cb86e849	2017-12-01 12:51:49.643808	17755db4-395a-4b3b-ac09-e8e3484ca700	54920aae-f322-4fca-bd09-cd091946632c	b0de1461-ba0a-4971-8682-f14af889ae40	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:51:49.532303", "author": "", "url": "", "notes": "", "title": "Video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "b0de1461-ba0a-4971-8682-f14af889ae40", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
284b516c-c10f-4133-81c5-918978e6d54d	2017-12-01 12:52:07.501333	17755db4-395a-4b3b-ac09-e8e3484ca700	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	997a3d54-bb90-4c1e-88bf-417e4c95ba21	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T12:52:07.397075", "author": "", "url": "", "notes": "", "title": "Pangaea CAD files", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "997a3d54-bb90-4c1e-88bf-417e4c95ba21", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
377f88b8-6a7e-4b6c-902f-9e90187aa41d	2017-12-01 12:52:47.260241	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	6fc03502-641d-4cd0-96d6-e56dfb3caa62	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:52:47.135742", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
bf856c8e-87f1-4191-93e3-4f728bcb6056	2017-12-01 12:54:05.246275	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	2e56ef3c-2f4f-4f73-b213-4214ece22001	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:54:05.118474", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
e2fa6206-3c5a-4427-9fb1-8ff54506186a	2017-12-01 12:55:06.805108	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	41602a5a-b63a-4104-ba15-52f0c1c35526	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:55:06.664533", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
69c19d68-b662-4693-8d6a-c81d00649dc9	2017-12-01 12:56:06.997013	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	670dffd1-3172-40b8-8e0d-8956760a084a	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:56:06.851631", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
dc0f5775-5264-4f9e-9f88-e62031625f6a	2017-12-01 12:58:36.002139	17755db4-395a-4b3b-ac09-e8e3484ca700	1abefb2e-6a83-4004-b7db-74c34b545d2e	ec55548e-a397-4b9c-afac-2f24518f3991	changed package	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:58:35.867409", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
\.


--
-- Data for Name: activity_detail; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY activity_detail (id, activity_id, object_id, object_type, activity_type, data) FROM stdin;
3896ce97-a020-4edf-994e-396ec9113952	79cd60d9-b153-4584-8e8b-c2418b824b01	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	Package	new	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:26.707978", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "2b61e1eb-c56d-4852-b55c-47f0e7308c6e", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
13b8a5ff-9afa-4a92-87da-36bcd370d12a	79cd60d9-b153-4584-8e8b-c2418b824b01	7e0928b6-a479-4718-98fe-b18d8f63ae0f	tag	added	{"tag": {"vocabulary_id": null, "id": "013c0ce4-51f9-4946-94e3-8e8713360f16", "name": "users"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:26.707978", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "2b61e1eb-c56d-4852-b55c-47f0e7308c6e", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
3b752c99-214a-45ac-b65e-39263826340a	79cd60d9-b153-4584-8e8b-c2418b824b01	8a55bb6b-dc69-4622-a3fc-5bef515beac2	tag	added	{"tag": {"vocabulary_id": null, "id": "5564f2e8-9c79-4125-a2a8-077f38a246ef", "name": "event"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:26.707978", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "2b61e1eb-c56d-4852-b55c-47f0e7308c6e", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
a24e230f-d6ce-46bb-be5c-4b7e21eaa47b	ee660257-e306-4c18-adb7-721940032324	a42f0a61-e0de-4cf6-add8-4fe21c29676a	Resource	new	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Gathered during the year 2017", "format": "CSV", "url": "http://download1815.mediafireuserdownload.com/edzj903mi86g/30c6acs902ing3x/samplespacelocationtrack.csv", "created": "2017-08-08T16:50:49.635222", "extras": {}, "cache_last_updated": null, "package_id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "3d4c3cf2-2604-49a3-b846-bcfca91c4b22", "size": null, "url_type": null, "id": "a42f0a61-e0de-4cf6-add8-4fe21c29676a", "resource_type": null, "name": "Data 2017"}}
b91befbc-a55f-4fdc-b8e6-93b873a8e914	c2459c06-478a-4893-98c9-c2bc1c9d8045	a42f0a61-e0de-4cf6-add8-4fe21c29676a	Resource	changed	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Gathered during the year 2017", "format": "CSV", "url": "http://download1815.mediafireuserdownload.com/edzj903mi86g/30c6acs902ing3x/samplespacelocationtrack.csv", "created": "2017-08-08T16:50:49.635222", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "bffaa2dd-7e21-45e1-9c62-336b10a1381d", "size": null, "url_type": null, "id": "a42f0a61-e0de-4cf6-add8-4fe21c29676a", "resource_type": null, "name": "Data 2017"}}
3331e737-1b5d-4623-9f93-4693f46d11f4	c2459c06-478a-4893-98c9-c2bc1c9d8045	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	Package	changed	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:50.837755", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "bffaa2dd-7e21-45e1-9c62-336b10a1381d", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
eb2d8c09-31e1-4e51-a8bd-705f3a1641c1	d5c7c2f1-11ba-40e7-a9cf-387cfbe4f9da	903d964e-9c2c-47d2-8708-25363ef8d772	Package	new	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:29.614984", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "65a08933-48aa-426b-bf8a-d11aa32dca95", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
0a685b5a-b1a4-478c-b492-5e5fa5c4f793	d5c7c2f1-11ba-40e7-a9cf-387cfbe4f9da	71bb7993-7b91-446a-a653-54b5543de071	tag	added	{"tag": {"vocabulary_id": null, "id": "cd8f07aa-76ab-4a1a-9567-ba2b7b19779b", "name": "services"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:29.614984", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "65a08933-48aa-426b-bf8a-d11aa32dca95", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
2200c786-fc71-4175-a74d-f07b7614c7e2	3e8e8301-501f-4e6f-9b5e-5ba0b4b47767	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	Resource	new	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Latest information of our services", "format": "CSV", "url": "http://download1640.mediafireuserdownload.com/hf6n735anfwg/k151xmpos9ojip9/samplespacenetfavor.csv", "created": "2017-08-08T16:52:48.427175", "extras": {}, "cache_last_updated": null, "package_id": "903d964e-9c2c-47d2-8708-25363ef8d772", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "15c99021-e05b-4678-b035-a1e8203dd9e1", "size": null, "url_type": null, "id": "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3", "resource_type": null, "name": "Latest"}}
cbffc7f4-fe55-4f8d-962c-5f690c006b86	ab5731ed-4566-4d86-a364-e1c8a3c7b6eb	4ee0ec1c-c72b-4bad-be73-364a735cea5c	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://autode.sk/2zsNALP", "created": "2017-11-23T17:37:19.897441", "extras": {}, "cache_last_updated": null, "package_id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "469f7ad0-8cce-4220-8859-7f640494206b", "size": null, "url_type": null, "id": "4ee0ec1c-c72b-4bad-be73-364a735cea5c", "resource_type": null, "name": "Example .dwg file"}}
e106735a-d0df-4643-89e8-c680ed2a8187	8d57bc35-165b-455c-bce7-202977427302	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	Resource	changed	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Latest information of our services", "format": "CSV", "url": "http://download1640.mediafireuserdownload.com/hf6n735anfwg/k151xmpos9ojip9/samplespacenetfavor.csv", "created": "2017-08-08T16:52:48.427175", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "903d964e-9c2c-47d2-8708-25363ef8d772", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "ba506755-adf8-4f97-bf70-90355c658dd7", "size": null, "url_type": null, "id": "3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3", "resource_type": null, "name": "Latest"}}
d9b61d82-e47e-47fe-bbcc-9f842c003ecc	8d57bc35-165b-455c-bce7-202977427302	903d964e-9c2c-47d2-8708-25363ef8d772	Package	changed	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:49.648987", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "ba506755-adf8-4f97-bf70-90355c658dd7", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
a8263b58-533c-40c0-a18d-a4df5448ed58	856541dc-535f-4a05-aa53-6173b63b6c80	817668d7-be70-479e-92c6-c7e4e8182603	Package	new	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:54:35.136352", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "8b393d77-16b0-4e7c-b64e-63acf71345d5", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
57ecacf2-34e1-48e0-ac5f-0593fc560a70	856541dc-535f-4a05-aa53-6173b63b6c80	b0c0609f-0cd5-43b9-9e76-6fcab0907ecb	tag	added	{"tag": {"vocabulary_id": null, "id": "8c8c1220-8129-4a02-bd2f-8e9b6529c212", "name": "internet"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:54:35.136352", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "8b393d77-16b0-4e7c-b64e-63acf71345d5", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
5f431691-fb26-4ab0-b9b6-1cad9944aa00	856541dc-535f-4a05-aa53-6173b63b6c80	2b65bccf-ad8a-4ddd-86b6-65587312f176	tag	added	{"tag": {"vocabulary_id": null, "id": "a81cb4bd-b2c8-4fc9-9682-9be570d13072", "name": "dsl"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:54:35.136352", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "8b393d77-16b0-4e7c-b64e-63acf71345d5", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
258d52b6-f597-443d-95cb-40b7a0c818e9	977f7a94-cd3c-4284-9260-cd73d8b5ecc9	0b15b724-fe12-49c9-9b17-e114c025af24	Resource	new	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Dataset with information from September 2018 to October 2018", "format": "CSV", "url": "http://download2230.mediafireuserdownload.com/gsxn969vw0mg/3h6uup3epq8sb70/samplespacenormalfeature.csv", "created": "2017-08-08T16:55:27.286294", "extras": {}, "cache_last_updated": null, "package_id": "817668d7-be70-479e-92c6-c7e4e8182603", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "4537cbb8-b49b-4611-9721-a775af0095fe", "size": null, "url_type": null, "id": "0b15b724-fe12-49c9-9b17-e114c025af24", "resource_type": null, "name": "SEPT - OCT 2018"}}
b5273d65-0b93-4f6f-8033-637336602765	a2db6a75-ed2e-40cf-8ec5-0a54cea6b228	817668d7-be70-479e-92c6-c7e4e8182603	Package	changed	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:55:28.497851", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "d2a0b75b-4856-4b6c-affc-729a99bbe985", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
483c0184-02ef-41a7-b57e-506f2ef1608f	a2db6a75-ed2e-40cf-8ec5-0a54cea6b228	0b15b724-fe12-49c9-9b17-e114c025af24	Resource	changed	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Dataset with information from September 2018 to October 2018", "format": "CSV", "url": "http://download2230.mediafireuserdownload.com/gsxn969vw0mg/3h6uup3epq8sb70/samplespacenormalfeature.csv", "created": "2017-08-08T16:55:27.286294", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "817668d7-be70-479e-92c6-c7e4e8182603", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "d2a0b75b-4856-4b6c-affc-729a99bbe985", "size": null, "url_type": null, "id": "0b15b724-fe12-49c9-9b17-e114c025af24", "resource_type": null, "name": "SEPT - OCT 2018"}}
2b0da495-03cb-4a55-8c42-136a09da53e9	92ab1224-9afe-422a-9a03-5337c6805189	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	Package	new	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:30.243013", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "dd70f0dc-ac9d-4ea3-8888-ddb077b44502", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
678f6811-1274-4347-ab41-700da5133cc3	92ab1224-9afe-422a-9a03-5337c6805189	be82423d-7268-44af-8a1e-b9b47ff9480e	tag	added	{"tag": {"vocabulary_id": null, "id": "0f6bdfbd-7412-4e5c-a788-c5fec06b5dd8", "name": "mobile"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:30.243013", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "dd70f0dc-ac9d-4ea3-8888-ddb077b44502", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
e9205015-581f-4a4f-9b9c-676e9f3cb66c	92ab1224-9afe-422a-9a03-5337c6805189	5ff6ca59-1110-4e7c-a81f-41ea212eab2c	tag	added	{"tag": {"vocabulary_id": null, "id": "69a1e7a9-0a51-4267-9fb3-db0642f03959", "name": "4g"}, "package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:30.243013", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "dd70f0dc-ac9d-4ea3-8888-ddb077b44502", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
fb2e9499-dd5e-4835-ae35-e4dafd3fb1ab	0fd4c8b8-6bee-4b9b-a0ee-d17059501409	16f7cc6d-3d97-4072-836b-b5180ed980b5	Resource	new	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "CSV", "url": "http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv", "created": "2017-08-08T16:57:41.840862", "extras": {}, "cache_last_updated": null, "package_id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "1815b63f-6afc-43d0-aac9-d8a9daec8f93", "size": null, "url_type": null, "id": "16f7cc6d-3d97-4072-836b-b5180ed980b5", "resource_type": null, "name": "Mobile 001"}}
249a7b8d-6b97-4b4f-9423-8f70979eab10	667f1e21-dd0f-4c38-896b-81c6a3f80682	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	Package	changed	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-08T16:57:43.112965", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "18ca3b06-e9d5-4129-b12c-1eacc9c8de32", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
ab65dd11-f1da-4ac8-a779-056751ce6f7a	667f1e21-dd0f-4c38-896b-81c6a3f80682	16f7cc6d-3d97-4072-836b-b5180ed980b5	Resource	changed	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "CSV", "url": "http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv", "created": "2017-08-08T16:57:41.840862", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "18ca3b06-e9d5-4129-b12c-1eacc9c8de32", "size": null, "url_type": null, "id": "16f7cc6d-3d97-4072-836b-b5180ed980b5", "resource_type": null, "name": "Mobile 001"}}
8101ae04-27f8-485f-9405-b372a644b14d	af4d03ce-89ab-4aee-bf36-2180e3a461a2	16f7cc6d-3d97-4072-836b-b5180ed980b5	Resource	changed	{"resource": {"mimetype": "text/csv", "cache_url": null, "state": "active", "hash": "", "description": "Description of mobile phone users", "format": "CSV", "url": "http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv", "created": "2017-08-08T16:57:41.840862", "extras": {"datastore_active": true}, "cache_last_updated": null, "package_id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "9280682a-0335-4e81-85d6-52933a06e3c9", "size": null, "url_type": null, "id": "16f7cc6d-3d97-4072-836b-b5180ed980b5", "resource_type": null, "name": "Mobile 001"}}
d527fd00-f4d3-45aa-a5f4-e13314fb5607	95939c34-a48c-4b67-845b-034d3c67bf17	54f83106-f2bf-45a8-8523-53a415c99e47	Package	new	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:07:42.009865", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "1d7a208f-a535-4f6d-ad3c-18d8c9866feb", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
063feaba-c3f6-4c03-8a55-e1f224b3944c	29dde80c-6d54-45d6-b46c-513673c9592b	a011526b-bd2f-4f0b-ad32-fbcc419c1814	Resource	new	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:07:50.654379", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:07:50.637397", "position": 0, "revision_id": "d74a18d9-14a3-40a4-b848-d1d9148e2102", "size": 8399839, "url_type": "upload", "id": "a011526b-bd2f-4f0b-ad32-fbcc419c1814", "resource_type": null, "name": "aaaaa"}}
04e67fc2-30e6-480a-8abb-35e168d2baf8	fcdef847-909e-438e-bdf4-a31cdaf1f4c3	a011526b-bd2f-4f0b-ad32-fbcc419c1814	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4", "created": "2017-11-23T17:07:50.654379", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:07:50.637397", "position": 0, "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "size": 8399839, "url_type": "upload", "id": "a011526b-bd2f-4f0b-ad32-fbcc419c1814", "resource_type": null, "name": "aaaaa"}}
6c214eee-d31c-4fd3-87b3-d900f4e18c9e	fcdef847-909e-438e-bdf4-a31cdaf1f4c3	54f83106-f2bf-45a8-8523-53a415c99e47	Package	changed	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:07:50.816957", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "76a15254-7ed3-4c64-94e0-4c93fd886a70", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
d36a8e1e-9a59-4681-b3f4-4d3f18a994f8	f1caf191-27d6-4fa1-9514-f5182198c9cb	a011526b-bd2f-4f0b-ad32-fbcc419c1814	Resource	deleted	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "deleted", "hash": "", "description": "", "format": "video/mp4", "url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4", "created": "2017-11-23T17:07:50.654379", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:07:50.637397", "position": 0, "revision_id": "61558a1e-8f38-4eea-be11-4831ab21f9ab", "size": 8399839, "url_type": "upload", "id": "a011526b-bd2f-4f0b-ad32-fbcc419c1814", "resource_type": null, "name": "aaaaa"}}
d3f3456c-a203-430d-9bcd-786ce8ff8ebb	5427f274-8abe-4927-8d90-6c7dcd9fcb53	79820f1e-1f3d-4254-977a-860af37e456e	Resource	new	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:11:23.965466", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:11:23.949866", "position": 0, "revision_id": "4609ef6f-b90f-49f1-aef7-0381acb539ba", "size": 8399839, "url_type": "upload", "id": "79820f1e-1f3d-4254-977a-860af37e456e", "resource_type": null, "name": "ssfdfsfsd"}}
fafd2754-7960-4d29-adc3-dc8c38303872	b33f9a10-c386-4940-930a-6ff16982dccc	79820f1e-1f3d-4254-977a-860af37e456e	Resource	deleted	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "deleted", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:11:23.965466", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:11:23.949866", "position": 0, "revision_id": "b832bb18-8732-45d7-858a-97f2a9f85006", "size": 8399839, "url_type": "upload", "id": "79820f1e-1f3d-4254-977a-860af37e456e", "resource_type": null, "name": "ssfdfsfsd"}}
ef611087-0efb-4fac-9956-dacefc2df9bb	c0ec79c3-71cf-4dc0-a210-6fd6433196c2	fea700ad-7abb-4dc9-8219-ec94e7d7f505	Resource	new	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "sadasd", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:13:31.399555", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:13:31.382671", "position": 0, "revision_id": "c84a2f2b-7aae-4ce0-9746-ed5ff839a497", "size": 8399839, "url_type": "upload", "id": "fea700ad-7abb-4dc9-8219-ec94e7d7f505", "resource_type": null, "name": "sdffsdfsd"}}
96dc7e22-0fbb-4a77-aa7d-adc8a4ab260e	3f35f708-51ee-4aeb-a4a1-20ca344c80fb	c49a76a9-4a48-4785-994e-9c991b32946e	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "", "created": "2017-11-23T17:15:23.485571", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": null, "position": 1, "revision_id": "be62d02b-aac3-4fa9-adda-5f7055efe684", "size": null, "url_type": null, "id": "c49a76a9-4a48-4785-994e-9c991b32946e", "resource_type": null, "name": "PRUEBAS"}}
42042033-5501-4a6e-b091-146ebea379c8	3f35f708-51ee-4aeb-a4a1-20ca344c80fb	fea700ad-7abb-4dc9-8219-ec94e7d7f505	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "sadasd", "format": "video/mp4", "url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/fea700ad-7abb-4dc9-8219-ec94e7d7f505/download/earth_zoom_in.mp4", "created": "2017-11-23T17:13:31.399555", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:13:31.382671", "position": 0, "revision_id": "be62d02b-aac3-4fa9-adda-5f7055efe684", "size": 8399839, "url_type": "upload", "id": "fea700ad-7abb-4dc9-8219-ec94e7d7f505", "resource_type": null, "name": "sdffsdfsd"}}
59fb1905-52d9-4ef9-9e78-2d34b1aeaeac	6cfd936e-6149-4354-96a6-b1686928340c	c49a76a9-4a48-4785-994e-9c991b32946e	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "", "created": "2017-11-23T17:15:23.485571", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": null, "position": 1, "revision_id": "54de6fec-f172-4558-8292-950fa99f513a", "size": null, "url_type": null, "id": "c49a76a9-4a48-4785-994e-9c991b32946e", "resource_type": null, "name": "PRUEBAS"}}
fd216be9-06eb-404a-822c-926389955cde	8de8fc21-e9ab-4170-83b4-cedda5daf96c	c49a76a9-4a48-4785-994e-9c991b32946e	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:15:23.485571", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:16:10.374535", "position": 1, "revision_id": "99077077-577e-48cc-bd73-2f28656f45f5", "size": 8399839, "url_type": "upload", "id": "c49a76a9-4a48-4785-994e-9c991b32946e", "resource_type": null, "name": "PRUEBAS"}}
17037131-503f-467b-8d25-43d7f3c1cb02	5b3ccd7e-4d3e-429a-a469-09668048e259	c49a76a9-4a48-4785-994e-9c991b32946e	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:15:23.485571", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:23:12.517099", "position": 1, "revision_id": "cd6b8c3c-4df5-42a5-a76a-db925c99dbde", "size": 8399839, "url_type": "upload", "id": "c49a76a9-4a48-4785-994e-9c991b32946e", "resource_type": null, "name": "PRUEBAS"}}
a1abad92-9719-4440-969f-2c66dcbe40da	0e647a87-b993-44ad-8f2f-1290d2f3ba14	df517ee3-17b3-451e-afaf-98115f06aaef	Resource	new	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:23:33.228623", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:23:33.208929", "position": 2, "revision_id": "ad0c12ae-80f3-437a-8f31-ce5bef87b962", "size": 8399839, "url_type": "upload", "id": "df517ee3-17b3-451e-afaf-98115f06aaef", "resource_type": null, "name": "asdfadas"}}
dbe8166b-d4ef-4a9c-903c-e87ee1ac2dc7	0e647a87-b993-44ad-8f2f-1290d2f3ba14	c49a76a9-4a48-4785-994e-9c991b32946e	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/c49a76a9-4a48-4785-994e-9c991b32946e/download/earth_zoom_in.mp4", "created": "2017-11-23T17:15:23.485571", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:23:12.517099", "position": 1, "revision_id": "ad0c12ae-80f3-437a-8f31-ce5bef87b962", "size": 8399839, "url_type": "upload", "id": "c49a76a9-4a48-4785-994e-9c991b32946e", "resource_type": null, "name": "PRUEBAS"}}
70fbafec-1bc3-48be-9dd2-4444bec0d7c4	2c31cc42-0ae9-487a-a7a6-bf1ebb4c38f8	e0b75bf6-e19e-4a05-b145-fcf770148a89	Resource	new	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "earth_zoom_in.mp4", "created": "2017-11-23T17:25:49.842967", "extras": {}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:25:49.820354", "position": 3, "revision_id": "2d0e5c97-33d8-47d3-9c65-f334df5365fc", "size": 8399839, "url_type": "upload", "id": "e0b75bf6-e19e-4a05-b145-fcf770148a89", "resource_type": null, "name": "Pruena 4"}}
d45b9915-9f18-496c-8fbf-01a393b8060d	2c31cc42-0ae9-487a-a7a6-bf1ebb4c38f8	df517ee3-17b3-451e-afaf-98115f06aaef	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/df517ee3-17b3-451e-afaf-98115f06aaef/download/earth_zoom_in.mp4", "created": "2017-11-23T17:23:33.228623", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54f83106-f2bf-45a8-8523-53a415c99e47", "mimetype_inner": null, "last_modified": "2017-11-23T17:23:33.208929", "position": 2, "revision_id": "2d0e5c97-33d8-47d3-9c65-f334df5365fc", "size": 8399839, "url_type": "upload", "id": "df517ee3-17b3-451e-afaf-98115f06aaef", "resource_type": null, "name": "asdfadas"}}
24c20458-e59f-4bf7-8225-6d7becb0de86	931b2bed-223e-4fda-8843-eb51282d69d1	54f83106-f2bf-45a8-8523-53a415c99e47	Package	deleted	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "aaaa", "metadata_modified": "2017-11-23T17:25:49.828970", "author": "", "url": "", "notes": "", "title": "aaaa", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "b8777631-802d-4981-aa3a-b71e40e44ea9", "type": "dataset", "id": "54f83106-f2bf-45a8-8523-53a415c99e47", "metadata_created": "2017-11-23T17:07:42.009859"}}
dee862ae-bf36-4413-99d3-8bd0710f17d5	2766a7e7-4a1a-4992-b441-d78cdb584065	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	Package	deleted	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "event-information", "metadata_modified": "2017-08-08T16:50:50.837755", "author": "", "url": "", "notes": "Events where several users participated", "title": "Event information", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "78e33def-565f-45dc-b9a4-a1dda81e1ce1", "type": "dataset", "id": "611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc", "metadata_created": "2017-08-08T16:50:26.707962"}}
a38c8160-118d-4f2d-b271-ef6d1f121111	c6dad858-18de-4062-bbbc-d6aba021ebbd	817668d7-be70-479e-92c6-c7e4e8182603	Package	deleted	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "maintainer@email.com", "name": "internet-dataset", "metadata_modified": "2017-08-08T16:55:28.497851", "author": "Unicom", "url": "", "notes": "Information about the users of our internet services.", "title": "Internet dataset", "private": false, "maintainer_email": "maintainer@email.com", "author_email": "unicom@email.com", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "201d00c8-1f94-43d3-ac75-e9bfeb22a2f4", "type": "dataset", "id": "817668d7-be70-479e-92c6-c7e4e8182603", "metadata_created": "2017-08-08T16:54:35.136338"}}
ce0bbe29-97b5-4f6a-86cd-05e3b4bc86f0	11c1f4ab-cfef-4494-aff1-87562f0064ec	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	Package	deleted	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "mobile-plans", "metadata_modified": "2017-08-09T09:04:44.595145", "author": "", "url": "", "notes": "Users and their mobile plans", "title": "Mobile plans", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "19ac713d-48f0-48b9-9cd5-7061843bc62f", "type": "dataset", "id": "4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64", "metadata_created": "2017-08-08T16:57:30.243005"}}
8385428b-a5e7-4e59-b103-922d26c7be30	a4aa87f8-fa10-4f5f-844e-81529fa3a411	903d964e-9c2c-47d2-8708-25363ef8d772	Package	deleted	{"package": {"owner_org": "724ae83b-ae78-433c-8586-69e7202931c4", "maintainer": "", "name": "services-information", "metadata_modified": "2017-08-08T16:52:49.648987", "author": "", "url": "", "notes": "Several services offered in our company", "title": "Services information", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9", "type": "dataset", "id": "903d964e-9c2c-47d2-8708-25363ef8d772", "metadata_created": "2017-08-08T16:52:29.614969"}}
98c66815-aacf-4905-a829-c407533bdf68	3647c32f-8a96-4c6a-8c4c-c4948e364f7f	acc9dc22-eff3-486b-a715-9a69ef93ade0	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-videos", "metadata_modified": "2017-11-23T17:35:47.357177", "author": "", "url": "", "notes": "", "title": "Example videos", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "00277d2f-879f-426e-98e9-39839776d89d", "type": "dataset", "id": "acc9dc22-eff3-486b-a715-9a69ef93ade0", "metadata_created": "2017-11-23T17:32:40.506721"}}
80c6a1e4-664d-4eb2-9a7e-03b6ae6bfede	4e28330a-cc18-4736-9e4a-71dbdada03a7	476cdf71-1048-4a6f-a28a-58fff547dae5	Package	new	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:37:00.362905", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "draft", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f732828b-2166-4541-9128-f838a260ae1b", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
485654b2-7b7c-4ef6-b4f3-b1f31cdad5c3	46fe0eca-6275-4d0b-8a5e-df73f411e7dc	4ee0ec1c-c72b-4bad-be73-364a735cea5c	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://autode.sk/2zsNALP", "created": "2017-11-23T17:37:19.897441", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5", "size": null, "url_type": null, "id": "4ee0ec1c-c72b-4bad-be73-364a735cea5c", "resource_type": null, "name": "Example .dwg file"}}
aa36a58c-46ea-48ff-9150-34bd28e571db	46fe0eca-6275-4d0b-8a5e-df73f411e7dc	476cdf71-1048-4a6f-a28a-58fff547dae5	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad", "metadata_modified": "2017-11-23T17:37:20.059543", "author": "", "url": "", "notes": "", "title": "Example CAD", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5", "type": "dataset", "id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "metadata_created": "2017-11-23T17:37:00.362900"}}
1f0cc475-4890-405d-8962-ebfdd8308f1d	505a69df-026a-4e8a-9484-855bd449580b	1342ec64-f18e-4860-93cc-f6dd194d56ec	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://autode.sk/2zZs3JO", "created": "2017-11-23T17:40:23.217872", "extras": {}, "cache_last_updated": null, "package_id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "mimetype_inner": null, "last_modified": null, "position": 1, "revision_id": "f4499856-fe22-47ba-9e93-ac6f2c547685", "size": null, "url_type": null, "id": "1342ec64-f18e-4860-93cc-f6dd194d56ec", "resource_type": null, "name": "Example 3D .dwg file"}}
1ac71597-178d-4ab8-8a22-cfe909ee4047	399cb478-9920-4de7-9543-5e8792a122b7	1342ec64-f18e-4860-93cc-f6dd194d56ec	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://autode.sk/2zZs3JO", "created": "2017-11-23T17:40:23.217872", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "mimetype_inner": null, "last_modified": null, "position": 1, "revision_id": "40aaa8c6-d66d-4632-bfab-bf3daad5244d", "size": null, "url_type": null, "id": "1342ec64-f18e-4860-93cc-f6dd194d56ec", "resource_type": null, "name": "Example 3D .dwg file"}}
8581090f-e7f8-4646-8480-15f372b0f45b	399cb478-9920-4de7-9543-5e8792a122b7	4ee0ec1c-c72b-4bad-be73-364a735cea5c	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://autode.sk/2zsNALP", "created": "2017-11-23T17:37:19.897441", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "476cdf71-1048-4a6f-a28a-58fff547dae5", "mimetype_inner": null, "last_modified": null, "position": 0, "revision_id": "40aaa8c6-d66d-4632-bfab-bf3daad5244d", "size": null, "url_type": null, "id": "4ee0ec1c-c72b-4bad-be73-364a735cea5c", "resource_type": null, "name": "Example 2D .dwg file"}}
1d4197b6-9917-4f72-8951-1a8233bca7c6	b6b56eb0-bd29-4995-a1ec-e9d8bf056af0	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T11:56:50.590910", "author": "", "url": "", "notes": "", "title": "Example CAD 2", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "c0d32fee-6737-4a91-920a-d8aab223e545", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
b808f7f2-b6da-45c7-b054-9a1360c32ba1	1c0cc55f-1748-43f3-91b4-977ff52f15d3	bf46d212-6fde-4670-ab59-52bb38c513bc	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "test-jupyter", "metadata_modified": "2017-12-01T11:57:19.351983", "author": "", "url": "", "notes": "", "title": "Test jupyter", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "78462af9-3e29-41e7-b739-815aa263ff3d", "type": "dataset", "id": "bf46d212-6fde-4670-ab59-52bb38c513bc", "metadata_created": "2017-11-28T19:31:59.868119"}}
24c9c949-d13e-48a8-a208-c0bf33da6fdc	c9b28971-06de-4022-a7c2-716558a8cd4c	54920aae-f322-4fca-bd09-cd091946632c	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T11:57:31.640981", "author": "", "url": "", "notes": "", "title": "Example video 2", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "beb04331-d499-485b-9369-1f57aa6f7395", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
42679f8a-3fa1-4e93-b92c-68d8347c2d44	b8806ae8-b2c3-4970-883f-040d37783bec	acc9dc22-eff3-486b-a715-9a69ef93ade0	Package	deleted	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-videos", "metadata_modified": "2017-11-23T17:35:47.357177", "author": "", "url": "", "notes": "", "title": "Example videos", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f8632874-e874-4ec3-97ce-c15bffe12f28", "type": "dataset", "id": "acc9dc22-eff3-486b-a715-9a69ef93ade0", "metadata_created": "2017-11-23T17:32:40.506721"}}
f332b8c5-0e89-4dd3-a65c-db9de2a34278	5f389a45-31ea-429b-9247-12758057a04b	54920aae-f322-4fca-bd09-cd091946632c	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:26:27.564010", "author": "", "url": "", "notes": "", "title": "Example video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f69e3832-0198-44c5-a4f2-f52a65fe3ca2", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
3685b034-8aba-4123-8115-dfeaf8ce3f5c	530af8ab-a4ac-46d0-9596-f2413d305e6a	bf46d212-6fde-4670-ab59-52bb38c513bc	Package	deleted	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "test-jupyter", "metadata_modified": "2017-12-01T11:57:19.351983", "author": "", "url": "", "notes": "", "title": "Test jupyter", "private": false, "maintainer_email": "", "author_email": "", "state": "deleted", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75", "type": "dataset", "id": "bf46d212-6fde-4670-ab59-52bb38c513bc", "metadata_created": "2017-11-28T19:31:59.868119"}}
2afa222e-ce3b-43be-9788-1e338801eb54	13df1fff-32cf-4fd2-9abd-ef82e3d75593	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T12:27:24.137068", "author": "", "url": "", "notes": "", "title": "Example CAD Pangaea", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "f42bf4cf-a31c-4645-bb98-9ecbdf58d1ca", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
b59a6f44-94ac-46e8-a61b-f680d9840eee	c3354d91-317e-4469-be79-9bfe6b175946	8649545f-f1d0-49d2-b9cd-88f2593ec059	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "stf50_autocombustions_with_varying_phi_v2_hd.mp4", "created": "2017-11-24T13:42:36.237930", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54920aae-f322-4fca-bd09-cd091946632c", "mimetype_inner": null, "last_modified": "2017-12-01T12:42:20.928656", "position": 0, "revision_id": "0489aebe-7484-4f6b-a051-9907f1b31b20", "size": 71194509, "url_type": "upload", "id": "8649545f-f1d0-49d2-b9cd-88f2593ec059", "resource_type": null, "name": "Video TIB"}}
d6fcb633-9fae-4829-9a48-7ae7a285c874	c351585b-0db7-47aa-a58f-7f2a8c01df3a	8649545f-f1d0-49d2-b9cd-88f2593ec059	Resource	changed	{"resource": {"mimetype": "video/mp4", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "video/mp4", "url": "stf50_autocombustions_with_varying_phi_v2_hd.mp4", "created": "2017-11-24T13:42:36.237930", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "54920aae-f322-4fca-bd09-cd091946632c", "mimetype_inner": null, "last_modified": "2017-12-01T12:42:20.928656", "position": 0, "revision_id": "29af1387-94a1-460f-b0d1-fdfb7de377e7", "size": 71194509, "url_type": "upload", "id": "8649545f-f1d0-49d2-b9cd-88f2593ec059", "resource_type": null, "name": "STF50 autocombustions with varying Phi"}}
6946c816-56b4-441d-acfe-ac4f4484623e	c28d5815-58c9-4a23-a270-b7e95f9dca25	1abefb2e-6a83-4004-b7db-74c34b545d2e	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "jupyter-notebooks", "metadata_modified": "2017-12-01T12:51:37.466460", "author": "", "url": "", "notes": "", "title": "Jupyter notebooks", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "3951536e-4b6f-4e7a-add1-b55c5002dcc0", "type": "dataset", "id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "metadata_created": "2017-12-01T12:51:12.218503"}}
acb89038-b42a-4783-b765-f2ff8c050d0c	caf40a6b-9a5b-4a50-a544-09e2cb86e849	54920aae-f322-4fca-bd09-cd091946632c	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-video-2", "metadata_modified": "2017-12-01T12:51:49.532303", "author": "", "url": "", "notes": "", "title": "Video", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "b0de1461-ba0a-4971-8682-f14af889ae40", "type": "dataset", "id": "54920aae-f322-4fca-bd09-cd091946632c", "metadata_created": "2017-11-24T13:42:19.407543"}}
45191cfd-0248-49c6-b8e7-a126145bb86f	284b516c-c10f-4133-81c5-918978e6d54d	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	Package	changed	{"package": {"owner_org": "0c5362f5-b99e-41db-8256-3d0d7549bf4d", "maintainer": "", "name": "example-cad-2", "metadata_modified": "2017-12-01T12:52:07.397075", "author": "", "url": "", "notes": "", "title": "Pangaea CAD files", "private": false, "maintainer_email": "", "author_email": "", "state": "active", "version": "", "creator_user_id": "17755db4-395a-4b3b-ac09-e8e3484ca700", "license_id": "cc-by", "revision_id": "997a3d54-bb90-4c1e-88bf-417e4c95ba21", "type": "dataset", "id": "ca8c20ad-77b6-46d7-a940-1f6a351d7d0b", "metadata_created": "2017-11-24T13:36:15.887852"}}
78e77292-51a0-4afb-bbac-73734b7a59e3	377f88b8-6a7e-4b6c-902f-9e90187aa41d	1e335b61-123e-4ba4-9c5b-9d1d6309dba9	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "example-machine-learning-notebook.ipynb", "created": "2017-12-01T12:51:28.891625", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:51:28.875743", "position": 0, "revision_id": "6fc03502-641d-4cd0-96d6-e56dfb3caa62", "size": 703819, "url_type": "upload", "id": "1e335b61-123e-4ba4-9c5b-9d1d6309dba9", "resource_type": null, "name": "Example Machine Learning notebook"}}
a022417d-8878-421d-a7dd-c37bfa8ef9b9	bf856c8e-87f1-4191-93e3-4f728bcb6056	036bcac0-c857-4bf0-bc71-1c78ed35d93a	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "labeled-faces-in-the-wild-recognition.ipynb", "created": "2017-12-01T12:54:05.127144", "extras": {}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:54:05.110953", "position": 1, "revision_id": "2e56ef3c-2f4f-4f73-b213-4214ece22001", "size": 717993, "url_type": "upload", "id": "036bcac0-c857-4bf0-bc71-1c78ed35d93a", "resource_type": null, "name": "Labeled Faces in the Wild recognition"}}
4429f538-9dc5-41b9-8de2-6d11e2168499	bf856c8e-87f1-4191-93e3-4f728bcb6056	1e335b61-123e-4ba4-9c5b-9d1d6309dba9	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/1e335b61-123e-4ba4-9c5b-9d1d6309dba9/download/example-machine-learning-notebook.ipynb", "created": "2017-12-01T12:51:28.891625", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:51:28.875743", "position": 0, "revision_id": "2e56ef3c-2f4f-4f73-b213-4214ece22001", "size": 703819, "url_type": "upload", "id": "1e335b61-123e-4ba4-9c5b-9d1d6309dba9", "resource_type": null, "name": "Example Machine Learning notebook"}}
6b2b82c1-1c40-4926-a51a-a670f9290ed0	e2fa6206-3c5a-4427-9fb1-8ff54506186a	e4cc8bf6-5e32-4c1f-b22e-109d47340c96	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "satellite_example.ipynb", "created": "2017-12-01T12:55:06.673960", "extras": {}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:55:06.657141", "position": 2, "revision_id": "41602a5a-b63a-4104-ba15-52f0c1c35526", "size": 7216, "url_type": "upload", "id": "e4cc8bf6-5e32-4c1f-b22e-109d47340c96", "resource_type": null, "name": "Satellite example"}}
77db426d-060c-4fde-a8ff-f5f6b5a36b15	e2fa6206-3c5a-4427-9fb1-8ff54506186a	036bcac0-c857-4bf0-bc71-1c78ed35d93a	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/036bcac0-c857-4bf0-bc71-1c78ed35d93a/download/labeled-faces-in-the-wild-recognition.ipynb", "created": "2017-12-01T12:54:05.127144", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:54:05.110953", "position": 1, "revision_id": "41602a5a-b63a-4104-ba15-52f0c1c35526", "size": 717993, "url_type": "upload", "id": "036bcac0-c857-4bf0-bc71-1c78ed35d93a", "resource_type": null, "name": "Labeled Faces in the Wild recognition"}}
c5b1e746-8f18-47c1-89a0-765f2cd5dcef	69c19d68-b662-4693-8d6a-c81d00649dc9	4577e551-96f8-4e13-ac81-012a866d00ac	Resource	new	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "gw150914_tutorial.ipynb", "created": "2017-12-01T12:56:06.860736", "extras": {}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:56:06.844366", "position": 3, "revision_id": "670dffd1-3172-40b8-8e0d-8956760a084a", "size": 2683661, "url_type": "upload", "id": "4577e551-96f8-4e13-ac81-012a866d00ac", "resource_type": null, "name": "GW150914 tutorial"}}
cd77c395-6447-407f-b5c1-dfc2389bbce1	69c19d68-b662-4693-8d6a-c81d00649dc9	e4cc8bf6-5e32-4c1f-b22e-109d47340c96	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/e4cc8bf6-5e32-4c1f-b22e-109d47340c96/download/satellite_example.ipynb", "created": "2017-12-01T12:55:06.673960", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:55:06.657141", "position": 2, "revision_id": "670dffd1-3172-40b8-8e0d-8956760a084a", "size": 7216, "url_type": "upload", "id": "e4cc8bf6-5e32-4c1f-b22e-109d47340c96", "resource_type": null, "name": "Satellite example"}}
a90dc818-c7f2-4a55-a97c-5fb36ff3a2b8	dc0f5775-5264-4f9e-9f88-e62031625f6a	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Resource	new	{"resource": {"mimetype": "application/x-tar", "cache_url": null, "state": "active", "hash": "", "description": "", "format": "TAR", "url": "12-steps-to-navier-stokes.tar.gz", "created": "2017-12-01T12:58:35.877330", "extras": {}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:58:35.858976", "position": 4, "revision_id": "ec55548e-a397-4b9c-afac-2f24518f3991", "size": 5708395, "url_type": "upload", "id": "ec1c5422-b8ab-4401-96fb-0792dacb8e40", "resource_type": null, "name": "12 steps to Navier-Stokes"}}
cbe28ce5-78ee-4bf3-81ca-76ece6a344a4	dc0f5775-5264-4f9e-9f88-e62031625f6a	4577e551-96f8-4e13-ac81-012a866d00ac	Resource	changed	{"resource": {"mimetype": null, "cache_url": null, "state": "active", "hash": "", "description": "", "format": "", "url": "http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/4577e551-96f8-4e13-ac81-012a866d00ac/download/gw150914_tutorial.ipynb", "created": "2017-12-01T12:56:06.860736", "extras": {"datastore_active": false}, "cache_last_updated": null, "package_id": "1abefb2e-6a83-4004-b7db-74c34b545d2e", "mimetype_inner": null, "last_modified": "2017-12-01T12:56:06.844366", "position": 3, "revision_id": "ec55548e-a397-4b9c-afac-2f24518f3991", "size": 2683661, "url_type": "upload", "id": "4577e551-96f8-4e13-ac81-012a866d00ac", "resource_type": null, "name": "GW150914 tutorial"}}
\.


--
-- Data for Name: authorization_group; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY authorization_group (id, name, created) FROM stdin;
\.


--
-- Data for Name: authorization_group_user; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY authorization_group_user (authorization_group_id, user_id, id) FROM stdin;
\.


--
-- Data for Name: dashboard; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY dashboard (user_id, activity_stream_last_viewed, email_last_sent) FROM stdin;
17755db4-395a-4b3b-ac09-e8e3484ca700	2017-12-01 12:42:01.050365	2017-08-08 16:45:41.143096
\.


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "group" (id, name, title, description, created, state, revision_id, type, approval_status, image_url, is_organization) FROM stdin;
724ae83b-ae78-433c-8586-69e7202931c4	china-unicom	China UNICOM	China United Network Communications Group Co., Ltd. (Chinese: 中国联合网络通信集团有限公司) or China Unicom (Chinese: 中国联通) is a Chinese state-owned telecommunications operator in the People's Republic of China. China Unicom is the world's fourth-largest mobile service provider by subscriber base.	2017-08-08 16:46:26.164305	deleted	ccfec652-355d-4640-b04e-9404427ece66	organization	approved	https://upload.wikimedia.org/wikipedia/en/thumb/f/fa/China_Unicom.svg/252px-China_Unicom.svg.png	t
0c5362f5-b99e-41db-8256-3d0d7549bf4d	tib-iasis	TIB	The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.	2017-11-23 17:30:37.757128	active	6d7701f6-3ad0-4073-a1a9-262f793ac188	organization	approved	https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png	t
\.


--
-- Data for Name: group_extra; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY group_extra (id, group_id, key, value, state, revision_id) FROM stdin;
\.


--
-- Data for Name: group_extra_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY group_extra_revision (id, group_id, key, value, state, revision_id, continuity_id, expired_id, revision_timestamp, expired_timestamp, current) FROM stdin;
\.


--
-- Data for Name: group_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY group_revision (id, name, title, description, created, state, revision_id, continuity_id, expired_id, revision_timestamp, expired_timestamp, current, type, approval_status, image_url, is_organization) FROM stdin;
724ae83b-ae78-433c-8586-69e7202931c4	china-unicom	China UNICOM	China United Network Communications Group Co., Ltd. (Chinese: 中国联合网络通信集团有限公司) or China Unicom (Chinese: 中国联通) is a Chinese state-owned telecommunications operator in the People's Republic of China. China Unicom is the world's fourth-largest mobile service provider by subscriber base.	2017-08-08 16:46:26.164305	deleted	ccfec652-355d-4640-b04e-9404427ece66	724ae83b-ae78-433c-8586-69e7202931c4	\N	2017-11-23 17:29:52.793785	9999-12-31 00:00:00	\N	organization	approved	https://upload.wikimedia.org/wikipedia/en/thumb/f/fa/China_Unicom.svg/252px-China_Unicom.svg.png	t
724ae83b-ae78-433c-8586-69e7202931c4	china-unicom	China UNICOM	China United Network Communications Group Co., Ltd. (Chinese: 中国联合网络通信集团有限公司) or China Unicom (Chinese: 中国联通) is a Chinese state-owned telecommunications operator in the People's Republic of China. China Unicom is the world's fourth-largest mobile service provider by subscriber base.	2017-08-08 16:46:26.164305	active	729f6192-b932-4413-904c-a72e21f8ef69	724ae83b-ae78-433c-8586-69e7202931c4	\N	2017-08-08 16:46:26.136217	2017-11-23 17:29:52.793785	\N	organization	approved	https://upload.wikimedia.org/wikipedia/en/thumb/f/fa/China_Unicom.svg/252px-China_Unicom.svg.png	t
0c5362f5-b99e-41db-8256-3d0d7549bf4d	tib-iasis	TIB iASiS		2017-11-23 17:30:37.757128	active	34c3de5f-7e58-4806-9177-733da1fca73c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	\N	2017-11-23 17:30:37.750126	2017-11-23 17:31:36.655707	\N	organization	approved		t
0c5362f5-b99e-41db-8256-3d0d7549bf4d	tib-iasis	TIB iASiS		2017-11-23 17:30:37.757128	active	935c959c-8191-4dc4-81b0-50e9e829d325	0c5362f5-b99e-41db-8256-3d0d7549bf4d	\N	2017-11-23 17:31:36.655707	2017-11-23 17:32:08.010838	\N	organization	approved	https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png	t
0c5362f5-b99e-41db-8256-3d0d7549bf4d	tib-iasis	TIB	The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.	2017-11-23 17:30:37.757128	active	6d7701f6-3ad0-4073-a1a9-262f793ac188	0c5362f5-b99e-41db-8256-3d0d7549bf4d	\N	2017-11-24 13:40:21.970443	9999-12-31 00:00:00	\N	organization	approved	https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png	t
0c5362f5-b99e-41db-8256-3d0d7549bf4d	tib-iasis	TIB iASiS	The German National Library of Science and Technology, abbreviated TIB, is the national library of the Federal Republic of Germany for all fields of engineering, technology, and the natural sciences.	2017-11-23 17:30:37.757128	active	6a333863-cac8-4957-9ed5-968dc91c74be	0c5362f5-b99e-41db-8256-3d0d7549bf4d	\N	2017-11-23 17:32:08.010838	2017-11-24 13:40:21.970443	\N	organization	approved	https://www.tib.eu/typo3conf/ext/tib_tmpl_bootstrap/Resources/Public/images/TIB_Logo_en.png	t
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY member (id, table_id, group_id, state, revision_id, table_name, capacity) FROM stdin;
d2b27305-ea4e-45d9-999d-e6d91d8fb620	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	3d4c3cf2-2604-49a3-b846-bcfca91c4b22	package	public
8623a263-c980-43b0-a44b-486b4234d014	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	deleted	15c99021-e05b-4678-b035-a1e8203dd9e1	package	public
a12d3530-7d39-440a-959d-0d50c8a96db4	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	deleted	4537cbb8-b49b-4611-9721-a775af0095fe	package	public
af91382a-f6df-4f5a-ad44-5d3a1f053a0c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	deleted	1815b63f-6afc-43d0-aac9-d8a9daec8f93	package	public
93198c10-9de3-464d-bc9a-190ef299f80c	15589e3b-0b24-48de-b724-4216f1b28a9f	724ae83b-ae78-433c-8586-69e7202931c4	deleted	79e552b7-ddc1-4eea-b3af-94653149dc1b	package	organization
6be6100e-8269-40c4-abd9-bbaf9b0e1f24	c5895f45-e257-4137-9310-5155f2ec2b22	724ae83b-ae78-433c-8586-69e7202931c4	deleted	11460728-1a99-41d2-aa3e-21b670cecf88	package	organization
c4a20d0e-dc53-496f-92ec-157dae4185cb	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	deleted	d3d16ded-e5ec-4ca5-9710-cce9eaf61cff	package	public
28d19ab4-6c8d-460d-90a2-55d8443425ac	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	deleted	6b3e479d-9737-4ca7-b32d-b98bf437a60c	package	organization
e385af4c-8676-4dd1-9c64-5c2cc034f8e2	3eafe76b-5d42-43ff-98cb-248a69d3e0cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	62396fd7-e314-4b1f-bdc8-cd3410ff795e	package	organization
ac6f2039-a306-4534-bcc6-0b9816adb655	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	deleted	d74a18d9-14a3-40a4-b848-d1d9148e2102	package	public
3a6f7351-6fbb-45bb-a3c6-3e336741a5e0	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	deleted	b8777631-802d-4981-aa3a-b71e40e44ea9	package	organization
e70bae4f-f333-4bc9-9f77-60613f9750ee	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	78e33def-565f-45dc-b9a4-a1dda81e1ce1	package	organization
73042b26-2536-4ce0-a73c-aee0f2803814	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	deleted	201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	package	organization
aaef9a5e-97fb-42c5-bfd1-817d87f1d89c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	deleted	19ac713d-48f0-48b9-9cd5-7061843bc62f	package	organization
435ee122-ae72-4742-b422-732604093dab	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	deleted	7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9	package	organization
b32880e4-f971-4093-ae9e-ee131df87fcc	17755db4-395a-4b3b-ac09-e8e3484ca700	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	user	admin
dbb6a2b2-30dd-43c3-88eb-d4d57443bd00	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	package	organization
dc32aaff-4770-4835-b785-972587d83eb1	599fea7c-9744-4392-b9cb-5863b4e55756	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	package	organization
2349c535-486b-4b4f-b74f-1e1a8ac355da	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	34c3de5f-7e58-4806-9177-733da1fca73c	user	admin
6641f04b-0d64-4996-9618-cac9317168fa	476cdf71-1048-4a6f-a28a-58fff547dae5	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	f732828b-2166-4541-9128-f838a260ae1b	package	organization
60680459-ed13-4359-902b-4aec19c38343	476cdf71-1048-4a6f-a28a-58fff547dae5	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	469f7ad0-8cce-4220-8859-7f640494206b	package	public
2ae80d7e-b440-4d08-950a-7cd64eb8e88b	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	39eb3d69-8ca4-477c-b7c6-7556c833986b	package	organization
26393b5a-1621-416b-b35c-0ab0c3e53c30	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	31c7be31-940b-409d-91b1-7f665f3de66a	package	public
2b690504-675f-4169-b3ac-b8f40ad4ae42	54920aae-f322-4fca-bd09-cd091946632c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	261614c5-63db-4f81-83d2-45690db30b97	package	organization
8ff5bbde-d923-46bf-8cde-21c4fbce0f57	54920aae-f322-4fca-bd09-cd091946632c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	5efbd00b-0986-4ceb-8b66-5a7dde3e1586	package	public
901a122c-ebc5-41d1-a7f9-e15f2a4171c7	acc9dc22-eff3-486b-a715-9a69ef93ade0	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	f8632874-e874-4ec3-97ce-c15bffe12f28	package	organization
0ae88343-e605-4008-9778-c3151a7cec40	bf46d212-6fde-4670-ab59-52bb38c513bc	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75	package	organization
c9b0341e-4b50-4eb1-84d9-3f9500f57b07	1abefb2e-6a83-4004-b7db-74c34b545d2e	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	91daa1ea-e394-4b70-a9e0-366b7c0b95fe	package	organization
1e801919-000a-48b7-855a-d1536eb3a808	1abefb2e-6a83-4004-b7db-74c34b545d2e	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	971f6de4-cde5-4773-9196-fe7fccb4c9ac	package	public
\.


--
-- Data for Name: member_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY member_revision (id, table_id, group_id, state, revision_id, continuity_id, expired_id, revision_timestamp, expired_timestamp, current, table_name, capacity) FROM stdin;
d2b27305-ea4e-45d9-999d-e6d91d8fb620	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	3d4c3cf2-2604-49a3-b846-bcfca91c4b22	d2b27305-ea4e-45d9-999d-e6d91d8fb620	\N	2017-08-08 16:50:49.589423	9999-12-31 00:00:00	\N	package	public
d2b27305-ea4e-45d9-999d-e6d91d8fb620	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	active	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	d2b27305-ea4e-45d9-999d-e6d91d8fb620	\N	2017-08-08 16:50:26.684564	2017-08-08 16:50:49.589423	\N	package	public
8623a263-c980-43b0-a44b-486b4234d014	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	active	65a08933-48aa-426b-bf8a-d11aa32dca95	8623a263-c980-43b0-a44b-486b4234d014	\N	2017-08-08 16:52:29.604017	2017-08-08 16:52:48.401496	\N	package	public
8623a263-c980-43b0-a44b-486b4234d014	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	deleted	15c99021-e05b-4678-b035-a1e8203dd9e1	8623a263-c980-43b0-a44b-486b4234d014	\N	2017-08-08 16:52:48.401496	9999-12-31 00:00:00	\N	package	public
a12d3530-7d39-440a-959d-0d50c8a96db4	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	active	8b393d77-16b0-4e7c-b64e-63acf71345d5	a12d3530-7d39-440a-959d-0d50c8a96db4	\N	2017-08-08 16:54:35.123783	2017-08-08 16:55:27.252098	\N	package	public
a12d3530-7d39-440a-959d-0d50c8a96db4	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	deleted	4537cbb8-b49b-4611-9721-a775af0095fe	a12d3530-7d39-440a-959d-0d50c8a96db4	\N	2017-08-08 16:55:27.252098	9999-12-31 00:00:00	\N	package	public
af91382a-f6df-4f5a-ad44-5d3a1f053a0c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	active	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	af91382a-f6df-4f5a-ad44-5d3a1f053a0c	\N	2017-08-08 16:57:30.229943	2017-08-08 16:57:41.818059	\N	package	public
af91382a-f6df-4f5a-ad44-5d3a1f053a0c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	deleted	1815b63f-6afc-43d0-aac9-d8a9daec8f93	af91382a-f6df-4f5a-ad44-5d3a1f053a0c	\N	2017-08-08 16:57:41.818059	9999-12-31 00:00:00	\N	package	public
93198c10-9de3-464d-bc9a-190ef299f80c	15589e3b-0b24-48de-b724-4216f1b28a9f	724ae83b-ae78-433c-8586-69e7202931c4	deleted	79e552b7-ddc1-4eea-b3af-94653149dc1b	93198c10-9de3-464d-bc9a-190ef299f80c	\N	2017-11-23 16:51:07.974293	9999-12-31 00:00:00	\N	package	organization
93198c10-9de3-464d-bc9a-190ef299f80c	15589e3b-0b24-48de-b724-4216f1b28a9f	724ae83b-ae78-433c-8586-69e7202931c4	active	454d15f3-840e-4b08-939e-59a7b5419c85	93198c10-9de3-464d-bc9a-190ef299f80c	\N	2017-11-23 16:44:34.681607	2017-11-23 16:51:07.974293	\N	package	organization
6be6100e-8269-40c4-abd9-bbaf9b0e1f24	c5895f45-e257-4137-9310-5155f2ec2b22	724ae83b-ae78-433c-8586-69e7202931c4	active	82682f2c-fa0b-4c03-bb4e-b4b9688a30fe	6be6100e-8269-40c4-abd9-bbaf9b0e1f24	\N	2017-11-23 15:46:09.672312	2017-11-23 16:51:17.292185	\N	package	organization
6be6100e-8269-40c4-abd9-bbaf9b0e1f24	c5895f45-e257-4137-9310-5155f2ec2b22	724ae83b-ae78-433c-8586-69e7202931c4	deleted	11460728-1a99-41d2-aa3e-21b670cecf88	6be6100e-8269-40c4-abd9-bbaf9b0e1f24	\N	2017-11-23 16:51:17.292185	9999-12-31 00:00:00	\N	package	organization
c4a20d0e-dc53-496f-92ec-157dae4185cb	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	deleted	d3d16ded-e5ec-4ca5-9710-cce9eaf61cff	c4a20d0e-dc53-496f-92ec-157dae4185cb	\N	2017-11-23 16:54:09.765566	9999-12-31 00:00:00	\N	package	public
c4a20d0e-dc53-496f-92ec-157dae4185cb	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	active	0308d025-a61d-4912-927c-b83a259af206	c4a20d0e-dc53-496f-92ec-157dae4185cb	\N	2017-11-23 16:54:02.990389	2017-11-23 16:54:09.765566	\N	package	public
28d19ab4-6c8d-460d-90a2-55d8443425ac	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	deleted	6b3e479d-9737-4ca7-b32d-b98bf437a60c	28d19ab4-6c8d-460d-90a2-55d8443425ac	\N	2017-11-23 16:55:10.759507	9999-12-31 00:00:00	\N	package	organization
28d19ab4-6c8d-460d-90a2-55d8443425ac	46a43786-223c-4bd8-b4d0-ca1997e78e70	724ae83b-ae78-433c-8586-69e7202931c4	active	0308d025-a61d-4912-927c-b83a259af206	28d19ab4-6c8d-460d-90a2-55d8443425ac	\N	2017-11-23 16:54:02.990389	2017-11-23 16:55:10.759507	\N	package	organization
e385af4c-8676-4dd1-9c64-5c2cc034f8e2	3eafe76b-5d42-43ff-98cb-248a69d3e0cc	724ae83b-ae78-433c-8586-69e7202931c4	active	a40e9a0b-920d-4831-be14-2143eff3e1f5	e385af4c-8676-4dd1-9c64-5c2cc034f8e2	\N	2017-11-23 16:52:07.134719	2017-11-23 16:55:17.143128	\N	package	organization
e385af4c-8676-4dd1-9c64-5c2cc034f8e2	3eafe76b-5d42-43ff-98cb-248a69d3e0cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	62396fd7-e314-4b1f-bdc8-cd3410ff795e	e385af4c-8676-4dd1-9c64-5c2cc034f8e2	\N	2017-11-23 16:55:17.143128	9999-12-31 00:00:00	\N	package	organization
ac6f2039-a306-4534-bcc6-0b9816adb655	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	deleted	d74a18d9-14a3-40a4-b848-d1d9148e2102	ac6f2039-a306-4534-bcc6-0b9816adb655	\N	2017-11-23 17:07:50.644253	9999-12-31 00:00:00	\N	package	public
ac6f2039-a306-4534-bcc6-0b9816adb655	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	active	1d7a208f-a535-4f6d-ad3c-18d8c9866feb	ac6f2039-a306-4534-bcc6-0b9816adb655	\N	2017-11-23 17:07:42.003088	2017-11-23 17:07:50.644253	\N	package	public
3a6f7351-6fbb-45bb-a3c6-3e336741a5e0	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	deleted	b8777631-802d-4981-aa3a-b71e40e44ea9	3a6f7351-6fbb-45bb-a3c6-3e336741a5e0	\N	2017-11-23 17:28:58.690985	9999-12-31 00:00:00	\N	package	organization
e70bae4f-f333-4bc9-9f77-60613f9750ee	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	active	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	e70bae4f-f333-4bc9-9f77-60613f9750ee	\N	2017-08-08 16:50:26.684564	2017-11-23 17:29:52.524044	\N	package	organization
73042b26-2536-4ce0-a73c-aee0f2803814	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	active	8b393d77-16b0-4e7c-b64e-63acf71345d5	73042b26-2536-4ce0-a73c-aee0f2803814	\N	2017-08-08 16:54:35.123783	2017-11-23 17:29:52.589459	\N	package	organization
aaef9a5e-97fb-42c5-bfd1-817d87f1d89c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	active	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	aaef9a5e-97fb-42c5-bfd1-817d87f1d89c	\N	2017-08-08 16:57:30.229943	2017-11-23 17:29:52.65148	\N	package	organization
435ee122-ae72-4742-b422-732604093dab	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	active	65a08933-48aa-426b-bf8a-d11aa32dca95	435ee122-ae72-4742-b422-732604093dab	\N	2017-08-08 16:52:29.604017	2017-11-23 17:29:52.708328	\N	package	organization
b32880e4-f971-4093-ae9e-ee131df87fcc	17755db4-395a-4b3b-ac09-e8e3484ca700	724ae83b-ae78-433c-8586-69e7202931c4	active	729f6192-b932-4413-904c-a72e21f8ef69	b32880e4-f971-4093-ae9e-ee131df87fcc	\N	2017-08-08 16:46:26.136217	2017-11-23 17:29:52.793785	\N	user	admin
dbb6a2b2-30dd-43c3-88eb-d4d57443bd00	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	724ae83b-ae78-433c-8586-69e7202931c4	active	2379ec08-54f7-4f8a-9cb8-a550f3535800	dbb6a2b2-30dd-43c3-88eb-d4d57443bd00	\N	2017-11-23 16:59:32.133562	2017-11-23 17:29:52.793785	\N	package	organization
3a6f7351-6fbb-45bb-a3c6-3e336741a5e0	54f83106-f2bf-45a8-8523-53a415c99e47	724ae83b-ae78-433c-8586-69e7202931c4	active	1d7a208f-a535-4f6d-ad3c-18d8c9866feb	3a6f7351-6fbb-45bb-a3c6-3e336741a5e0	\N	2017-11-23 17:07:42.003088	2017-11-23 17:28:58.690985	\N	package	organization
e70bae4f-f333-4bc9-9f77-60613f9750ee	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	724ae83b-ae78-433c-8586-69e7202931c4	deleted	78e33def-565f-45dc-b9a4-a1dda81e1ce1	e70bae4f-f333-4bc9-9f77-60613f9750ee	\N	2017-11-23 17:29:52.524044	9999-12-31 00:00:00	\N	package	organization
73042b26-2536-4ce0-a73c-aee0f2803814	817668d7-be70-479e-92c6-c7e4e8182603	724ae83b-ae78-433c-8586-69e7202931c4	deleted	201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	73042b26-2536-4ce0-a73c-aee0f2803814	\N	2017-11-23 17:29:52.589459	9999-12-31 00:00:00	\N	package	organization
aaef9a5e-97fb-42c5-bfd1-817d87f1d89c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	724ae83b-ae78-433c-8586-69e7202931c4	deleted	19ac713d-48f0-48b9-9cd5-7061843bc62f	aaef9a5e-97fb-42c5-bfd1-817d87f1d89c	\N	2017-11-23 17:29:52.65148	9999-12-31 00:00:00	\N	package	organization
435ee122-ae72-4742-b422-732604093dab	903d964e-9c2c-47d2-8708-25363ef8d772	724ae83b-ae78-433c-8586-69e7202931c4	deleted	7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9	435ee122-ae72-4742-b422-732604093dab	\N	2017-11-23 17:29:52.708328	9999-12-31 00:00:00	\N	package	organization
b32880e4-f971-4093-ae9e-ee131df87fcc	17755db4-395a-4b3b-ac09-e8e3484ca700	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	b32880e4-f971-4093-ae9e-ee131df87fcc	\N	2017-11-23 17:29:52.793785	9999-12-31 00:00:00	\N	user	admin
dbb6a2b2-30dd-43c3-88eb-d4d57443bd00	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	dbb6a2b2-30dd-43c3-88eb-d4d57443bd00	\N	2017-11-23 17:29:52.793785	9999-12-31 00:00:00	\N	package	organization
dc32aaff-4770-4835-b785-972587d83eb1	599fea7c-9744-4392-b9cb-5863b4e55756	724ae83b-ae78-433c-8586-69e7202931c4	deleted	ccfec652-355d-4640-b04e-9404427ece66	dc32aaff-4770-4835-b785-972587d83eb1	\N	2017-11-23 17:29:52.793785	9999-12-31 00:00:00	\N	package	organization
dc32aaff-4770-4835-b785-972587d83eb1	599fea7c-9744-4392-b9cb-5863b4e55756	724ae83b-ae78-433c-8586-69e7202931c4	active	b4332ffc-49c7-4942-bdcb-2c53f2229dc1	dc32aaff-4770-4835-b785-972587d83eb1	\N	2017-11-23 14:57:51.835359	2017-11-23 17:29:52.793785	\N	package	organization
2349c535-486b-4b4f-b74f-1e1a8ac355da	17755db4-395a-4b3b-ac09-e8e3484ca700	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	34c3de5f-7e58-4806-9177-733da1fca73c	2349c535-486b-4b4f-b74f-1e1a8ac355da	\N	2017-11-23 17:30:37.750126	9999-12-31 00:00:00	\N	user	admin
6641f04b-0d64-4996-9618-cac9317168fa	476cdf71-1048-4a6f-a28a-58fff547dae5	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	f732828b-2166-4541-9128-f838a260ae1b	6641f04b-0d64-4996-9618-cac9317168fa	\N	2017-11-23 17:37:00.356594	9999-12-31 00:00:00	\N	package	organization
60680459-ed13-4359-902b-4aec19c38343	476cdf71-1048-4a6f-a28a-58fff547dae5	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	f732828b-2166-4541-9128-f838a260ae1b	60680459-ed13-4359-902b-4aec19c38343	\N	2017-11-23 17:37:00.356594	2017-11-23 17:37:19.886163	\N	package	public
60680459-ed13-4359-902b-4aec19c38343	476cdf71-1048-4a6f-a28a-58fff547dae5	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	469f7ad0-8cce-4220-8859-7f640494206b	60680459-ed13-4359-902b-4aec19c38343	\N	2017-11-23 17:37:19.886163	9999-12-31 00:00:00	\N	package	public
2ae80d7e-b440-4d08-950a-7cd64eb8e88b	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	39eb3d69-8ca4-477c-b7c6-7556c833986b	2ae80d7e-b440-4d08-950a-7cd64eb8e88b	\N	2017-11-24 13:36:15.8815	9999-12-31 00:00:00	\N	package	organization
26393b5a-1621-416b-b35c-0ab0c3e53c30	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	39eb3d69-8ca4-477c-b7c6-7556c833986b	26393b5a-1621-416b-b35c-0ab0c3e53c30	\N	2017-11-24 13:36:15.8815	2017-11-24 13:37:06.590149	\N	package	public
26393b5a-1621-416b-b35c-0ab0c3e53c30	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	31c7be31-940b-409d-91b1-7f665f3de66a	26393b5a-1621-416b-b35c-0ab0c3e53c30	\N	2017-11-24 13:37:06.590149	9999-12-31 00:00:00	\N	package	public
2b690504-675f-4169-b3ac-b8f40ad4ae42	54920aae-f322-4fca-bd09-cd091946632c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	261614c5-63db-4f81-83d2-45690db30b97	2b690504-675f-4169-b3ac-b8f40ad4ae42	\N	2017-11-24 13:42:19.401789	9999-12-31 00:00:00	\N	package	organization
8ff5bbde-d923-46bf-8cde-21c4fbce0f57	54920aae-f322-4fca-bd09-cd091946632c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	5efbd00b-0986-4ceb-8b66-5a7dde3e1586	8ff5bbde-d923-46bf-8cde-21c4fbce0f57	\N	2017-11-24 13:42:36.230296	9999-12-31 00:00:00	\N	package	public
8ff5bbde-d923-46bf-8cde-21c4fbce0f57	54920aae-f322-4fca-bd09-cd091946632c	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	261614c5-63db-4f81-83d2-45690db30b97	8ff5bbde-d923-46bf-8cde-21c4fbce0f57	\N	2017-11-24 13:42:19.401789	2017-11-24 13:42:36.230296	\N	package	public
901a122c-ebc5-41d1-a7f9-e15f2a4171c7	acc9dc22-eff3-486b-a715-9a69ef93ade0	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	f8632874-e874-4ec3-97ce-c15bffe12f28	901a122c-ebc5-41d1-a7f9-e15f2a4171c7	\N	2017-12-01 12:26:03.416187	9999-12-31 00:00:00	\N	package	organization
901a122c-ebc5-41d1-a7f9-e15f2a4171c7	acc9dc22-eff3-486b-a715-9a69ef93ade0	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	dea564f1-30b2-4e1a-85dc-f13abbd0803e	901a122c-ebc5-41d1-a7f9-e15f2a4171c7	\N	2017-11-23 17:32:40.502714	2017-12-01 12:26:03.416187	\N	package	organization
0ae88343-e605-4008-9778-c3151a7cec40	bf46d212-6fde-4670-ab59-52bb38c513bc	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	9c5af1cf-98c7-4a89-8c5d-4acc9a801b72	0ae88343-e605-4008-9778-c3151a7cec40	\N	2017-11-28 19:31:59.859318	2017-12-01 12:26:42.710983	\N	package	organization
0ae88343-e605-4008-9778-c3151a7cec40	bf46d212-6fde-4670-ab59-52bb38c513bc	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75	0ae88343-e605-4008-9778-c3151a7cec40	\N	2017-12-01 12:26:42.710983	9999-12-31 00:00:00	\N	package	organization
c9b0341e-4b50-4eb1-84d9-3f9500f57b07	1abefb2e-6a83-4004-b7db-74c34b545d2e	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	91daa1ea-e394-4b70-a9e0-366b7c0b95fe	c9b0341e-4b50-4eb1-84d9-3f9500f57b07	\N	2017-12-01 12:51:12.212384	9999-12-31 00:00:00	\N	package	organization
1e801919-000a-48b7-855a-d1536eb3a808	1abefb2e-6a83-4004-b7db-74c34b545d2e	0c5362f5-b99e-41db-8256-3d0d7549bf4d	deleted	971f6de4-cde5-4773-9196-fe7fccb4c9ac	1e801919-000a-48b7-855a-d1536eb3a808	\N	2017-12-01 12:51:28.881885	9999-12-31 00:00:00	\N	package	public
1e801919-000a-48b7-855a-d1536eb3a808	1abefb2e-6a83-4004-b7db-74c34b545d2e	0c5362f5-b99e-41db-8256-3d0d7549bf4d	active	91daa1ea-e394-4b70-a9e0-366b7c0b95fe	1e801919-000a-48b7-855a-d1536eb3a808	\N	2017-12-01 12:51:12.212384	2017-12-01 12:51:28.881885	\N	package	public
\.


--
-- Data for Name: migrate_version; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY migrate_version (repository_id, repository_path, version) FROM stdin;
Ckan	/usr/lib/ckan/default/src/ckan/ckan/migration	85
\.


--
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package (id, name, title, version, url, notes, license_id, revision_id, author, author_email, maintainer, maintainer_email, state, type, owner_org, private, metadata_modified, creator_user_id, metadata_created) FROM stdin;
599fea7c-9744-4392-b9cb-5863b4e55756	example	example				cc-by	b4332ffc-49c7-4942-bdcb-2c53f2229dc1					draft	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 14:57:51.841043	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 14:57:51.841037
46a43786-223c-4bd8-b4d0-ca1997e78e70	http-www-imagen-com-mx-assets-img-imagen_share-png	http://www.imagen.com.mx/assets/img/imagen_share.png				cc-by	6b3e479d-9737-4ca7-b32d-b98bf437a60c					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:54:59.028887	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:54:02.995668
3eafe76b-5d42-43ff-98cb-248a69d3e0cc	http-autode-sk-2zzs3jo	http://autode.sk/2zZs3JO				cc-by	62396fd7-e314-4b1f-bdc8-cd3410ff795e					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:52:15.890938	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:52:07.139253
15589e3b-0b24-48de-b724-4216f1b28a9f	15589e3b-0b24-48de-b724-4216f1b28a9f	prueba				cc-by	2379ec08-54f7-4f8a-9cb8-a550f3535800					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:44:55.763186	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:44:34.687173
c5895f45-e257-4137-9310-5155f2ec2b22	laala	laala				cc-by	11460728-1a99-41d2-aa3e-21b670cecf88					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:16:22.224683	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 15:46:09.677967
54f83106-f2bf-45a8-8523-53a415c99e47	aaaa	aaaa				cc-by	b8777631-802d-4981-aa3a-b71e40e44ea9					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-11-23 17:25:49.82897	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:07:42.009859
611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	event-information	Event information			Events where several users participated	cc-by	78e33def-565f-45dc-b9a4-a1dda81e1ce1					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:50:50.837755	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:50:26.707962
817668d7-be70-479e-92c6-c7e4e8182603	internet-dataset	Internet dataset			Information about the users of our internet services.	cc-by	201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	Unicom	unicom@email.com	maintainer@email.com	maintainer@email.com	deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:55:28.497851	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:54:35.136338
4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	mobile-plans	Mobile plans			Users and their mobile plans	cc-by	19ac713d-48f0-48b9-9cd5-7061843bc62f					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-09 09:04:44.595145	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:57:30.243005
903d964e-9c2c-47d2-8708-25363ef8d772	services-information	Services information			Several services offered in our company	cc-by	7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:52:49.648987	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:52:29.614969
acc9dc22-eff3-486b-a715-9a69ef93ade0	example-videos	Example videos				cc-by	f8632874-e874-4ec3-97ce-c15bffe12f28					deleted	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:35:47.357177	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:32:40.506721
476cdf71-1048-4a6f-a28a-58fff547dae5	example-cad	Example CAD				cc-by	5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5					active	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:40:57.417452	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:37:00.3629
cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	prueba	prueba				cc-by	01835081-84bb-447b-92b7-cc793a8ec18a					deleted	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 17:06:26.176559	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:59:32.14173
bf46d212-6fde-4670-ab59-52bb38c513bc	test-jupyter	Test jupyter				cc-by	4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75					deleted	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 11:57:19.351983	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-28 19:31:59.868119
1abefb2e-6a83-4004-b7db-74c34b545d2e	jupyter-notebooks	Jupyter notebooks				cc-by	3951536e-4b6f-4e7a-add1-b55c5002dcc0					active	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:58:35.867409	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-12-01 12:51:12.218503
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Video				cc-by	b0de1461-ba0a-4971-8682-f14af889ae40					active	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:51:49.532303	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Pangaea CAD files				cc-by	997a3d54-bb90-4c1e-88bf-417e4c95ba21					active	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:52:07.397075	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
\.


--
-- Data for Name: package_extra; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_extra (id, package_id, key, value, revision_id, state) FROM stdin;
\.


--
-- Data for Name: package_extra_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_extra_revision (id, package_id, key, value, revision_id, continuity_id, state, expired_id, revision_timestamp, expired_timestamp, current) FROM stdin;
\.


--
-- Data for Name: package_relationship; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_relationship (id, subject_package_id, object_package_id, type, comment, revision_id, state) FROM stdin;
\.


--
-- Data for Name: package_relationship_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_relationship_revision (id, subject_package_id, object_package_id, type, comment, revision_id, continuity_id, state, expired_id, revision_timestamp, expired_timestamp, current) FROM stdin;
\.


--
-- Data for Name: package_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_revision (id, name, title, version, url, notes, license_id, revision_id, continuity_id, author, author_email, maintainer, maintainer_email, state, expired_id, revision_timestamp, expired_timestamp, current, type, owner_org, private, metadata_modified, creator_user_id, metadata_created) FROM stdin;
611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	event-information	Event information			Events where several users participated	cc-by	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc					draft	\N	2017-08-08 16:50:26.684564	2017-08-08 16:50:50.836029	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:50:26.707978	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:50:26.707962
903d964e-9c2c-47d2-8708-25363ef8d772	services-information	Services information			Several services offered in our company	cc-by	65a08933-48aa-426b-bf8a-d11aa32dca95	903d964e-9c2c-47d2-8708-25363ef8d772					draft	\N	2017-08-08 16:52:29.604017	2017-08-08 16:52:49.648027	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:52:29.614984	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:52:29.614969
817668d7-be70-479e-92c6-c7e4e8182603	internet-dataset	Internet dataset			Information about the users of our internet services.	cc-by	8b393d77-16b0-4e7c-b64e-63acf71345d5	817668d7-be70-479e-92c6-c7e4e8182603	Unicom	unicom@email.com	maintainer@email.com	maintainer@email.com	draft	\N	2017-08-08 16:54:35.123783	2017-08-08 16:55:28.496897	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:54:35.136352	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:54:35.136338
4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	mobile-plans	Mobile plans			Users and their mobile plans	cc-by	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64					draft	\N	2017-08-08 16:57:30.229943	2017-08-08 16:57:43.111847	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:57:30.243013	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:57:30.243005
599fea7c-9744-4392-b9cb-5863b4e55756	example	example				cc-by	b4332ffc-49c7-4942-bdcb-2c53f2229dc1	599fea7c-9744-4392-b9cb-5863b4e55756					draft	\N	2017-11-23 14:57:51.835359	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 14:57:51.841043	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 14:57:51.841037
c5895f45-e257-4137-9310-5155f2ec2b22	laala	laala				cc-by	82682f2c-fa0b-4c03-bb4e-b4b9688a30fe	c5895f45-e257-4137-9310-5155f2ec2b22					draft	\N	2017-11-23 15:46:09.672312	2017-11-23 15:46:18.641891	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 15:46:09.677974	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 15:46:09.677967
15589e3b-0b24-48de-b724-4216f1b28a9f	prueba	prueba				cc-by	454d15f3-840e-4b08-939e-59a7b5419c85	15589e3b-0b24-48de-b724-4216f1b28a9f					draft	\N	2017-11-23 16:44:34.681607	2017-11-23 16:44:55.762789	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:44:34.68718	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:44:34.687173
15589e3b-0b24-48de-b724-4216f1b28a9f	prueba	prueba				cc-by	b5b9f114-0ecf-4d96-bda8-0b0cde5b04d6	15589e3b-0b24-48de-b724-4216f1b28a9f					active	\N	2017-11-23 16:44:55.762789	2017-11-23 16:51:07.974293	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:44:55.763186	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:44:34.687173
c5895f45-e257-4137-9310-5155f2ec2b22	laala	laala				cc-by	ac630955-9972-4f00-b6fa-13a3ca87a7dc	c5895f45-e257-4137-9310-5155f2ec2b22					active	\N	2017-11-23 15:46:18.641891	2017-11-23 16:51:17.292185	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 15:46:18.642522	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 15:46:09.677967
c5895f45-e257-4137-9310-5155f2ec2b22	laala	laala				cc-by	11460728-1a99-41d2-aa3e-21b670cecf88	c5895f45-e257-4137-9310-5155f2ec2b22					deleted	\N	2017-11-23 16:51:17.292185	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:16:22.224683	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 15:46:09.677967
3eafe76b-5d42-43ff-98cb-248a69d3e0cc	http-autode-sk-2zzs3jo	http://autode.sk/2zZs3JO				cc-by	a40e9a0b-920d-4831-be14-2143eff3e1f5	3eafe76b-5d42-43ff-98cb-248a69d3e0cc					draft	\N	2017-11-23 16:52:07.134719	2017-11-23 16:52:15.890366	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:52:07.139258	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:52:07.139253
46a43786-223c-4bd8-b4d0-ca1997e78e70	http-www-imagen-com-mx-assets-img-imagen_share-png	http://www.imagen.com.mx/assets/img/imagen_share.png				cc-by	0308d025-a61d-4912-927c-b83a259af206	46a43786-223c-4bd8-b4d0-ca1997e78e70					draft	\N	2017-11-23 16:54:02.990389	2017-11-23 16:54:09.967897	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:54:02.995673	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:54:02.995668
46a43786-223c-4bd8-b4d0-ca1997e78e70	http-www-imagen-com-mx-assets-img-imagen_share-png	http://www.imagen.com.mx/assets/img/imagen_share.png				cc-by	edc363a9-dcaa-4ad2-8d16-30c2cfd6ad5e	46a43786-223c-4bd8-b4d0-ca1997e78e70					active	\N	2017-11-23 16:54:09.967897	2017-11-23 16:55:10.759507	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:54:09.968595	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:54:02.995668
46a43786-223c-4bd8-b4d0-ca1997e78e70	http-www-imagen-com-mx-assets-img-imagen_share-png	http://www.imagen.com.mx/assets/img/imagen_share.png				cc-by	6b3e479d-9737-4ca7-b32d-b98bf437a60c	46a43786-223c-4bd8-b4d0-ca1997e78e70					deleted	\N	2017-11-23 16:55:10.759507	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:54:59.028887	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:54:02.995668
3eafe76b-5d42-43ff-98cb-248a69d3e0cc	http-autode-sk-2zzs3jo	http://autode.sk/2zZs3JO				cc-by	a35cfd73-4f2e-4fb3-aed5-a5b285bca02d	3eafe76b-5d42-43ff-98cb-248a69d3e0cc					active	\N	2017-11-23 16:52:15.890366	2017-11-23 16:55:17.143128	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:52:15.890938	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:52:07.139253
3eafe76b-5d42-43ff-98cb-248a69d3e0cc	http-autode-sk-2zzs3jo	http://autode.sk/2zZs3JO				cc-by	62396fd7-e314-4b1f-bdc8-cd3410ff795e	3eafe76b-5d42-43ff-98cb-248a69d3e0cc					deleted	\N	2017-11-23 16:55:17.143128	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:52:15.890938	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:52:07.139253
611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	event-information	Event information			Events where several users participated	cc-by	bffaa2dd-7e21-45e1-9c62-336b10a1381d	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc					active	\N	2017-08-08 16:50:50.836029	2017-11-23 17:29:52.524044	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:50:50.837755	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:50:26.707962
817668d7-be70-479e-92c6-c7e4e8182603	internet-dataset	Internet dataset			Information about the users of our internet services.	cc-by	d2a0b75b-4856-4b6c-affc-729a99bbe985	817668d7-be70-479e-92c6-c7e4e8182603	Unicom	unicom@email.com	maintainer@email.com	maintainer@email.com	active	\N	2017-08-08 16:55:28.496897	2017-11-23 17:29:52.589459	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:55:28.497851	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:54:35.136338
4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	mobile-plans	Mobile plans			Users and their mobile plans	cc-by	18ca3b06-e9d5-4129-b12c-1eacc9c8de32	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64					active	\N	2017-08-08 16:57:43.111847	2017-11-23 17:29:52.65148	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:57:43.112965	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:57:30.243005
903d964e-9c2c-47d2-8708-25363ef8d772	services-information	Services information			Several services offered in our company	cc-by	ba506755-adf8-4f97-bf70-90355c658dd7	903d964e-9c2c-47d2-8708-25363ef8d772					active	\N	2017-08-08 16:52:49.648027	2017-11-23 17:29:52.708328	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:52:49.648987	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:52:29.614969
15589e3b-0b24-48de-b724-4216f1b28a9f	prueba	prueba				cc-by	79e552b7-ddc1-4eea-b3af-94653149dc1b	15589e3b-0b24-48de-b724-4216f1b28a9f					deleted	\N	2017-11-23 16:51:07.974293	2017-11-23 16:59:32.133562	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:44:55.763186	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:44:34.687173
15589e3b-0b24-48de-b724-4216f1b28a9f	15589e3b-0b24-48de-b724-4216f1b28a9f	prueba				cc-by	2379ec08-54f7-4f8a-9cb8-a550f3535800	15589e3b-0b24-48de-b724-4216f1b28a9f					deleted	\N	2017-11-23 16:59:32.133562	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:44:55.763186	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:44:34.687173
cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	prueba	prueba				cc-by	2379ec08-54f7-4f8a-9cb8-a550f3535800	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d					draft	\N	2017-11-23 16:59:32.133562	2017-11-23 16:59:46.590922	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:59:32.141736	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:59:32.14173
54f83106-f2bf-45a8-8523-53a415c99e47	aaaa	aaaa				cc-by	1d7a208f-a535-4f6d-ad3c-18d8c9866feb	54f83106-f2bf-45a8-8523-53a415c99e47					draft	\N	2017-11-23 17:07:42.003088	2017-11-23 17:07:50.816393	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-11-23 17:07:42.009865	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:07:42.009859
54f83106-f2bf-45a8-8523-53a415c99e47	aaaa	aaaa				cc-by	b8777631-802d-4981-aa3a-b71e40e44ea9	54f83106-f2bf-45a8-8523-53a415c99e47					deleted	\N	2017-11-23 17:28:58.690985	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-11-23 17:25:49.82897	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:07:42.009859
54f83106-f2bf-45a8-8523-53a415c99e47	aaaa	aaaa				cc-by	76a15254-7ed3-4c64-94e0-4c93fd886a70	54f83106-f2bf-45a8-8523-53a415c99e47					active	\N	2017-11-23 17:07:50.816393	2017-11-23 17:28:58.690985	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-11-23 17:07:50.816957	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:07:42.009859
611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	event-information	Event information			Events where several users participated	cc-by	78e33def-565f-45dc-b9a4-a1dda81e1ce1	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc					deleted	\N	2017-11-23 17:29:52.524044	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:50:50.837755	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:50:26.707962
817668d7-be70-479e-92c6-c7e4e8182603	internet-dataset	Internet dataset			Information about the users of our internet services.	cc-by	201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	817668d7-be70-479e-92c6-c7e4e8182603	Unicom	unicom@email.com	maintainer@email.com	maintainer@email.com	deleted	\N	2017-11-23 17:29:52.589459	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:55:28.497851	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:54:35.136338
4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	mobile-plans	Mobile plans			Users and their mobile plans	cc-by	19ac713d-48f0-48b9-9cd5-7061843bc62f	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64					deleted	\N	2017-11-23 17:29:52.65148	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-09 09:04:44.595145	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:57:30.243005
903d964e-9c2c-47d2-8708-25363ef8d772	services-information	Services information			Several services offered in our company	cc-by	7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9	903d964e-9c2c-47d2-8708-25363ef8d772					deleted	\N	2017-11-23 17:29:52.708328	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	f	2017-08-08 16:52:49.648987	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-08-08 16:52:29.614969
acc9dc22-eff3-486b-a715-9a69ef93ade0	example-videos	Example videos				cc-by	dea564f1-30b2-4e1a-85dc-f13abbd0803e	acc9dc22-eff3-486b-a715-9a69ef93ade0					draft	\N	2017-11-23 17:32:40.502714	2017-11-23 17:33:31.668229	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-23 17:32:40.506726	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:32:40.506721
acc9dc22-eff3-486b-a715-9a69ef93ade0	example-videos	Example videos				cc-by	ce2b7558-924a-445d-a0be-3cfad1f498c2	acc9dc22-eff3-486b-a715-9a69ef93ade0					active	\N	2017-11-23 17:33:31.668229	2017-11-23 17:35:47.356658	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-23 17:33:31.668724	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:32:40.506721
476cdf71-1048-4a6f-a28a-58fff547dae5	example-cad	Example CAD				cc-by	f732828b-2166-4541-9128-f838a260ae1b	476cdf71-1048-4a6f-a28a-58fff547dae5					draft	\N	2017-11-23 17:37:00.356594	2017-11-23 17:37:20.059045	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:37:00.362905	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:37:00.3629
476cdf71-1048-4a6f-a28a-58fff547dae5	example-cad	Example CAD				cc-by	5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5	476cdf71-1048-4a6f-a28a-58fff547dae5					active	\N	2017-11-23 17:37:20.059045	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:37:20.059543	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:37:00.3629
cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	prueba	prueba				cc-by	4fc2baf4-0ca3-4ea1-9d25-597e6a6143eb	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d					active	\N	2017-11-23 16:59:46.590922	2017-11-24 12:35:58.757075	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 16:59:46.591475	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:59:32.14173
cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d	prueba	prueba				cc-by	01835081-84bb-447b-92b7-cc793a8ec18a	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d					deleted	\N	2017-11-24 12:35:58.757075	9999-12-31 00:00:00	\N	dataset	724ae83b-ae78-433c-8586-69e7202931c4	t	2017-11-23 17:06:26.176559	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 16:59:32.14173
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Example CAD 2				cc-by	39eb3d69-8ca4-477c-b7c6-7556c833986b	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b					draft	\N	2017-11-24 13:36:15.8815	2017-11-24 13:37:06.717505	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-24 13:36:15.887858	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Example video 2				cc-by	261614c5-63db-4f81-83d2-45690db30b97	54920aae-f322-4fca-bd09-cd091946632c					draft	\N	2017-11-24 13:42:19.401789	2017-11-24 13:42:36.379722	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-24 13:42:19.407548	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Example CAD 2				cc-by	07d39bd8-2ebc-4e4f-9018-6edc75251e06	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b					active	\N	2017-11-24 13:37:06.717505	2017-12-01 11:56:50.587446	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-24 13:37:06.718115	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
bf46d212-6fde-4670-ab59-52bb38c513bc	test-jupyter	Test jupyter				cc-by	d22239f4-6828-4fa1-be3f-4736fc8b354d	bf46d212-6fde-4670-ab59-52bb38c513bc					active	\N	2017-11-28 19:32:29.449516	2017-12-01 11:57:19.351494	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-28 19:32:29.450007	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-28 19:31:59.868119
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Example video 2				cc-by	1c58622d-c7db-4a68-8693-f42da07e9c4e	54920aae-f322-4fca-bd09-cd091946632c					active	\N	2017-11-24 13:42:36.379722	2017-12-01 11:57:31.640309	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-24 13:42:36.380309	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
acc9dc22-eff3-486b-a715-9a69ef93ade0	example-videos	Example videos				cc-by	00277d2f-879f-426e-98e9-39839776d89d	acc9dc22-eff3-486b-a715-9a69ef93ade0					active	\N	2017-11-23 17:35:47.356658	2017-12-01 12:26:03.416187	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:35:47.357177	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:32:40.506721
bf46d212-6fde-4670-ab59-52bb38c513bc	test-jupyter	Test jupyter				cc-by	9c5af1cf-98c7-4a89-8c5d-4acc9a801b72	bf46d212-6fde-4670-ab59-52bb38c513bc					draft	\N	2017-11-28 19:31:59.859318	2017-11-28 19:32:29.449516	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-11-28 19:31:59.868127	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-28 19:31:59.868119
acc9dc22-eff3-486b-a715-9a69ef93ade0	example-videos	Example videos				cc-by	f8632874-e874-4ec3-97ce-c15bffe12f28	acc9dc22-eff3-486b-a715-9a69ef93ade0					deleted	\N	2017-12-01 12:26:03.416187	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-11-23 17:35:47.357177	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-23 17:32:40.506721
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Example video 2				cc-by	beb04331-d499-485b-9369-1f57aa6f7395	54920aae-f322-4fca-bd09-cd091946632c					active	\N	2017-12-01 11:57:31.640309	2017-12-01 12:26:27.563253	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 11:57:31.640981	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
bf46d212-6fde-4670-ab59-52bb38c513bc	test-jupyter	Test jupyter				cc-by	78462af9-3e29-41e7-b739-815aa263ff3d	bf46d212-6fde-4670-ab59-52bb38c513bc					active	\N	2017-12-01 11:57:19.351494	2017-12-01 12:26:42.710983	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 11:57:19.351983	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-28 19:31:59.868119
bf46d212-6fde-4670-ab59-52bb38c513bc	test-jupyter	Test jupyter				cc-by	4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75	bf46d212-6fde-4670-ab59-52bb38c513bc					deleted	\N	2017-12-01 12:26:42.710983	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 11:57:19.351983	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-28 19:31:59.868119
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Example CAD 2				cc-by	c0d32fee-6737-4a91-920a-d8aab223e545	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b					active	\N	2017-12-01 11:56:50.587446	2017-12-01 12:27:24.136585	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 11:56:50.59091	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
1abefb2e-6a83-4004-b7db-74c34b545d2e	jupyter-notebooks	Jupyter notebooks				cc-by	91daa1ea-e394-4b70-a9e0-366b7c0b95fe	1abefb2e-6a83-4004-b7db-74c34b545d2e					draft	\N	2017-12-01 12:51:12.212384	2017-12-01 12:51:29.035769	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-12-01 12:51:12.21851	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-12-01 12:51:12.218503
1abefb2e-6a83-4004-b7db-74c34b545d2e	jupyter-notebooks	Jupyter notebooks				cc-by	9a2f4e77-4520-4878-b51b-359e8adcba17	1abefb2e-6a83-4004-b7db-74c34b545d2e					active	\N	2017-12-01 12:51:29.035769	2017-12-01 12:51:37.465931	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	t	2017-12-01 12:51:29.036414	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-12-01 12:51:12.218503
1abefb2e-6a83-4004-b7db-74c34b545d2e	jupyter-notebooks	Jupyter notebooks				cc-by	3951536e-4b6f-4e7a-add1-b55c5002dcc0	1abefb2e-6a83-4004-b7db-74c34b545d2e					active	\N	2017-12-01 12:51:37.465931	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:51:37.46646	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-12-01 12:51:12.218503
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Example video				cc-by	f69e3832-0198-44c5-a4f2-f52a65fe3ca2	54920aae-f322-4fca-bd09-cd091946632c					active	\N	2017-12-01 12:26:27.563253	2017-12-01 12:51:49.531837	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:26:27.56401	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
54920aae-f322-4fca-bd09-cd091946632c	example-video-2	Video				cc-by	b0de1461-ba0a-4971-8682-f14af889ae40	54920aae-f322-4fca-bd09-cd091946632c					active	\N	2017-12-01 12:51:49.531837	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:51:49.532303	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:42:19.407543
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Example CAD Pangaea				cc-by	f42bf4cf-a31c-4645-bb98-9ecbdf58d1ca	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b					active	\N	2017-12-01 12:27:24.136585	2017-12-01 12:52:07.396644	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:27:24.137068	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
ca8c20ad-77b6-46d7-a940-1f6a351d7d0b	example-cad-2	Pangaea CAD files				cc-by	997a3d54-bb90-4c1e-88bf-417e4c95ba21	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b					active	\N	2017-12-01 12:52:07.396644	9999-12-31 00:00:00	\N	dataset	0c5362f5-b99e-41db-8256-3d0d7549bf4d	f	2017-12-01 12:52:07.397075	17755db4-395a-4b3b-ac09-e8e3484ca700	2017-11-24 13:36:15.887852
\.


--
-- Data for Name: package_tag; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_tag (id, package_id, tag_id, revision_id, state) FROM stdin;
8a55bb6b-dc69-4622-a3fc-5bef515beac2	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	5564f2e8-9c79-4125-a2a8-077f38a246ef	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	active
7e0928b6-a479-4718-98fe-b18d8f63ae0f	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	013c0ce4-51f9-4946-94e3-8e8713360f16	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	active
71bb7993-7b91-446a-a653-54b5543de071	903d964e-9c2c-47d2-8708-25363ef8d772	cd8f07aa-76ab-4a1a-9567-ba2b7b19779b	65a08933-48aa-426b-bf8a-d11aa32dca95	active
b0c0609f-0cd5-43b9-9e76-6fcab0907ecb	817668d7-be70-479e-92c6-c7e4e8182603	8c8c1220-8129-4a02-bd2f-8e9b6529c212	8b393d77-16b0-4e7c-b64e-63acf71345d5	active
2b65bccf-ad8a-4ddd-86b6-65587312f176	817668d7-be70-479e-92c6-c7e4e8182603	a81cb4bd-b2c8-4fc9-9682-9be570d13072	8b393d77-16b0-4e7c-b64e-63acf71345d5	active
be82423d-7268-44af-8a1e-b9b47ff9480e	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	0f6bdfbd-7412-4e5c-a788-c5fec06b5dd8	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	active
5ff6ca59-1110-4e7c-a81f-41ea212eab2c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	69a1e7a9-0a51-4267-9fb3-db0642f03959	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	active
\.


--
-- Data for Name: package_tag_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY package_tag_revision (id, package_id, tag_id, revision_id, continuity_id, state, expired_id, revision_timestamp, expired_timestamp, current) FROM stdin;
7e0928b6-a479-4718-98fe-b18d8f63ae0f	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	013c0ce4-51f9-4946-94e3-8e8713360f16	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	7e0928b6-a479-4718-98fe-b18d8f63ae0f	active	\N	2017-08-08 16:50:26.684564	9999-12-31 00:00:00	\N
8a55bb6b-dc69-4622-a3fc-5bef515beac2	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc	5564f2e8-9c79-4125-a2a8-077f38a246ef	2b61e1eb-c56d-4852-b55c-47f0e7308c6e	8a55bb6b-dc69-4622-a3fc-5bef515beac2	active	\N	2017-08-08 16:50:26.684564	9999-12-31 00:00:00	\N
71bb7993-7b91-446a-a653-54b5543de071	903d964e-9c2c-47d2-8708-25363ef8d772	cd8f07aa-76ab-4a1a-9567-ba2b7b19779b	65a08933-48aa-426b-bf8a-d11aa32dca95	71bb7993-7b91-446a-a653-54b5543de071	active	\N	2017-08-08 16:52:29.604017	9999-12-31 00:00:00	\N
b0c0609f-0cd5-43b9-9e76-6fcab0907ecb	817668d7-be70-479e-92c6-c7e4e8182603	8c8c1220-8129-4a02-bd2f-8e9b6529c212	8b393d77-16b0-4e7c-b64e-63acf71345d5	b0c0609f-0cd5-43b9-9e76-6fcab0907ecb	active	\N	2017-08-08 16:54:35.123783	9999-12-31 00:00:00	\N
2b65bccf-ad8a-4ddd-86b6-65587312f176	817668d7-be70-479e-92c6-c7e4e8182603	a81cb4bd-b2c8-4fc9-9682-9be570d13072	8b393d77-16b0-4e7c-b64e-63acf71345d5	2b65bccf-ad8a-4ddd-86b6-65587312f176	active	\N	2017-08-08 16:54:35.123783	9999-12-31 00:00:00	\N
be82423d-7268-44af-8a1e-b9b47ff9480e	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	0f6bdfbd-7412-4e5c-a788-c5fec06b5dd8	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	be82423d-7268-44af-8a1e-b9b47ff9480e	active	\N	2017-08-08 16:57:30.229943	9999-12-31 00:00:00	\N
5ff6ca59-1110-4e7c-a81f-41ea212eab2c	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64	69a1e7a9-0a51-4267-9fb3-db0642f03959	dd70f0dc-ac9d-4ea3-8888-ddb077b44502	5ff6ca59-1110-4e7c-a81f-41ea212eab2c	active	\N	2017-08-08 16:57:30.229943	9999-12-31 00:00:00	\N
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY rating (id, user_id, user_ip_address, package_id, rating, created) FROM stdin;
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY resource (id, url, format, description, "position", revision_id, hash, state, extras, name, resource_type, mimetype, mimetype_inner, size, last_modified, cache_url, cache_last_updated, webstore_url, webstore_last_updated, created, url_type, package_id) FROM stdin;
a42f0a61-e0de-4cf6-add8-4fe21c29676a	http://download1815.mediafireuserdownload.com/edzj903mi86g/30c6acs902ing3x/samplespacelocationtrack.csv	CSV	Gathered during the year 2017	0	bffaa2dd-7e21-45e1-9c62-336b10a1381d		active	{"datastore_active": true}	Data 2017	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:50:49.635222	\N	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc
3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	http://download1640.mediafireuserdownload.com/hf6n735anfwg/k151xmpos9ojip9/samplespacenetfavor.csv	CSV	Latest information of our services	0	ba506755-adf8-4f97-bf70-90355c658dd7		active	{"datastore_active": true}	Latest	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:52:48.427175	\N	903d964e-9c2c-47d2-8708-25363ef8d772
0b15b724-fe12-49c9-9b17-e114c025af24	http://download2230.mediafireuserdownload.com/gsxn969vw0mg/3h6uup3epq8sb70/samplespacenormalfeature.csv	CSV	Dataset with information from September 2018 to October 2018	0	d2a0b75b-4856-4b6c-affc-729a99bbe985		active	{"datastore_active": true}	SEPT - OCT 2018	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:55:27.286294	\N	817668d7-be70-479e-92c6-c7e4e8182603
16f7cc6d-3d97-4072-836b-b5180ed980b5	http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv	CSV	Description of mobile phone users	0	9280682a-0335-4e81-85d6-52933a06e3c9		active	{"datastore_active": true}	Mobile 001	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:57:41.840862	\N	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64
ea350acb-36d2-4d3c-8a9a-8684deacd13e	http://autode.sk/2zZs3JO	dwg		0	05868de0-c21f-4edd-8afb-40b218b9faf6		active	\N	Example	\N	video/mp4	\N	8399839	2017-11-23 15:47:05.220516	\N	\N	\N	\N	2017-11-23 15:46:18.460223		c5895f45-e257-4137-9310-5155f2ec2b22
b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb	http://192.76.241.143:5000/dataset/15589e3b-0b24-48de-b724-4216f1b28a9f/resource/b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb/download/earth_zoom_in.mp4	mp4		0	b5b9f114-0ecf-4d96-bda8-0b0cde5b04d6		active	{"datastore_active": false}	Prueba	\N	video/mp4	\N	8399839	2017-11-23 16:44:55.621957	\N	\N	\N	\N	2017-11-23 16:44:55.638727	upload	15589e3b-0b24-48de-b724-4216f1b28a9f
c910c15e-4b03-42be-918a-672099d6342e	http://autode.sk/2zZs3JO	dwg		0	a35cfd73-4f2e-4fb3-aed5-a5b285bca02d		active	{"datastore_active": false}		\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:52:15.731348	\N	3eafe76b-5d42-43ff-98cb-248a69d3e0cc
3252dcf3-45be-4bd6-a353-5d5cfeef14f5	http://www.imagen.com.mx/assets/img/imagen_share.png	PNG		0	b66ffafa-45f9-4548-87d0-6c706c736eeb		deleted	{"datastore_active": false}		\N	image/png	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:54:09.774576	\N	46a43786-223c-4bd8-b4d0-ca1997e78e70
351cca2e-fa9f-4a32-a990-a42c92756cbc	earth_zoom_in.mp4	mp4		0	87ab6ae0-0d32-41e4-8446-a648e652c8db		active	{"datastore_active": false}	prueba	\N	video/mp4	\N	8399839	2017-11-23 17:06:26.169895	\N	\N	\N	\N	2017-11-23 16:59:46.410746	upload	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d
a011526b-bd2f-4f0b-ad32-fbcc419c1814	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4	video/mp4		0	61558a1e-8f38-4eea-be11-4831ab21f9ab		deleted	{"datastore_active": false}	aaaaa	\N	video/mp4	\N	8399839	2017-11-23 17:07:50.637397	\N	\N	\N	\N	2017-11-23 17:07:50.654379	upload	54f83106-f2bf-45a8-8523-53a415c99e47
79820f1e-1f3d-4254-977a-860af37e456e	earth_zoom_in.mp4	video/mp4		0	b832bb18-8732-45d7-858a-97f2a9f85006		deleted	\N	ssfdfsfsd	\N	video/mp4	\N	8399839	2017-11-23 17:11:23.949866	\N	\N	\N	\N	2017-11-23 17:11:23.965466	upload	54f83106-f2bf-45a8-8523-53a415c99e47
fea700ad-7abb-4dc9-8219-ec94e7d7f505	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/fea700ad-7abb-4dc9-8219-ec94e7d7f505/download/earth_zoom_in.mp4	video/mp4	sadasd	0	be62d02b-aac3-4fa9-adda-5f7055efe684		active	{"datastore_active": false}	sdffsdfsd	\N	video/mp4	\N	8399839	2017-11-23 17:13:31.382671	\N	\N	\N	\N	2017-11-23 17:13:31.399555	upload	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/c49a76a9-4a48-4785-994e-9c991b32946e/download/earth_zoom_in.mp4	video/mp4		1	ad0c12ae-80f3-437a-8f31-ce5bef87b962		active	{"datastore_active": false}	PRUEBAS	\N	video/mp4	\N	8399839	2017-11-23 17:23:12.517099	\N	\N	\N	\N	2017-11-23 17:15:23.485571	upload	54f83106-f2bf-45a8-8523-53a415c99e47
df517ee3-17b3-451e-afaf-98115f06aaef	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/df517ee3-17b3-451e-afaf-98115f06aaef/download/earth_zoom_in.mp4	video/mp4		2	2d0e5c97-33d8-47d3-9c65-f334df5365fc		active	{"datastore_active": false}	asdfadas	\N	video/mp4	\N	8399839	2017-11-23 17:23:33.208929	\N	\N	\N	\N	2017-11-23 17:23:33.228623	upload	54f83106-f2bf-45a8-8523-53a415c99e47
e0b75bf6-e19e-4a05-b145-fcf770148a89	earth_zoom_in.mp4	video/mp4		3	2d0e5c97-33d8-47d3-9c65-f334df5365fc		active	\N	Pruena 4	\N	video/mp4	\N	8399839	2017-11-23 17:25:49.820354	\N	\N	\N	\N	2017-11-23 17:25:49.842967	upload	54f83106-f2bf-45a8-8523-53a415c99e47
8eed1d60-7734-46db-91a7-e472ab7e4fcf	https://www.youtube.com/embed/jNQXAC9IVRw		Youtube first video	0	ce2b7558-924a-445d-a0be-3cfad1f498c2		active	{"datastore_active": false}	Me at the zoo	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:33:31.511199	\N	acc9dc22-eff3-486b-a715-9a69ef93ade0
2b3f434c-6db3-47af-b803-c674eecd1338	earth_zoom_in.mp4	video/mp4		1	740de3d8-633c-4f40-a252-0085125239b2		active	\N	Earth zoom in	\N	video/mp4	\N	8399839	2017-11-23 17:35:15.654452	\N	\N	\N	\N	2017-11-23 17:35:15.669692	upload	acc9dc22-eff3-486b-a715-9a69ef93ade0
1342ec64-f18e-4860-93cc-f6dd194d56ec	http://autode.sk/2zZs3JO			1	40aaa8c6-d66d-4632-bfab-bf3daad5244d		active	{"datastore_active": false}	Example 3D .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:40:23.217872	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
4ee0ec1c-c72b-4bad-be73-364a735cea5c	http://autode.sk/2zsNALP			0	40aaa8c6-d66d-4632-bfab-bf3daad5244d		active	{"datastore_active": false}	Example 2D .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:37:19.897441	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
0ce74f0d-bf35-4627-9f69-92d5c1150dff	http://autode.sk/2zyATiC			0	07d39bd8-2ebc-4e4f-9018-6edc75251e06		active	{"datastore_active": false}	Example .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-24 13:37:06.599034	\N	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b
4cc71857-8686-4182-9a0d-9848ef3168e4	running-code.ipynb			0	b19c528c-268f-43f7-987a-77da686eef9d		active	{"datastore_active": false}	example notebook	\N	\N	\N	51563	2017-11-28 19:34:41.940314	\N	\N	\N	\N	2017-11-28 19:32:29.318692	upload	bf46d212-6fde-4670-ab59-52bb38c513bc
8649545f-f1d0-49d2-b9cd-88f2593ec059	stf50_autocombustions_with_varying_phi_v2_hd.mp4	video/mp4		0	29af1387-94a1-460f-b0d1-fdfb7de377e7		active	{"datastore_active": false}	STF50 autocombustions with varying Phi	\N	video/mp4	\N	71194509	2017-12-01 12:42:20.928656	\N	\N	\N	\N	2017-11-24 13:42:36.23793	upload	54920aae-f322-4fca-bd09-cd091946632c
1e335b61-123e-4ba4-9c5b-9d1d6309dba9	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/1e335b61-123e-4ba4-9c5b-9d1d6309dba9/download/example-machine-learning-notebook.ipynb			0	2e56ef3c-2f4f-4f73-b213-4214ece22001		active	{"datastore_active": false}	Example Machine Learning notebook	\N	\N	\N	703819	2017-12-01 12:51:28.875743	\N	\N	\N	\N	2017-12-01 12:51:28.891625	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
036bcac0-c857-4bf0-bc71-1c78ed35d93a	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/036bcac0-c857-4bf0-bc71-1c78ed35d93a/download/labeled-faces-in-the-wild-recognition.ipynb			1	41602a5a-b63a-4104-ba15-52f0c1c35526		active	{"datastore_active": false}	Labeled Faces in the Wild recognition	\N	\N	\N	717993	2017-12-01 12:54:05.110953	\N	\N	\N	\N	2017-12-01 12:54:05.127144	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
e4cc8bf6-5e32-4c1f-b22e-109d47340c96	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/e4cc8bf6-5e32-4c1f-b22e-109d47340c96/download/satellite_example.ipynb			2	670dffd1-3172-40b8-8e0d-8956760a084a		active	{"datastore_active": false}	Satellite example	\N	\N	\N	7216	2017-12-01 12:55:06.657141	\N	\N	\N	\N	2017-12-01 12:55:06.67396	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
4577e551-96f8-4e13-ac81-012a866d00ac	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/4577e551-96f8-4e13-ac81-012a866d00ac/download/gw150914_tutorial.ipynb			3	ec55548e-a397-4b9c-afac-2f24518f3991		active	{"datastore_active": false}	GW150914 tutorial	\N	\N	\N	2683661	2017-12-01 12:56:06.844366	\N	\N	\N	\N	2017-12-01 12:56:06.860736	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
ec1c5422-b8ab-4401-96fb-0792dacb8e40	12-steps-to-navier-stokes.tar.gz	TAR		4	ec55548e-a397-4b9c-afac-2f24518f3991		active	\N	12 steps to Navier-Stokes	\N	application/x-tar	\N	5708395	2017-12-01 12:58:35.858976	\N	\N	\N	\N	2017-12-01 12:58:35.87733	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
\.


--
-- Data for Name: resource_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY resource_revision (id, url, format, description, "position", revision_id, continuity_id, hash, state, extras, expired_id, revision_timestamp, expired_timestamp, current, name, resource_type, mimetype, mimetype_inner, size, last_modified, cache_url, cache_last_updated, webstore_url, webstore_last_updated, created, url_type, package_id) FROM stdin;
a42f0a61-e0de-4cf6-add8-4fe21c29676a	http://download1815.mediafireuserdownload.com/edzj903mi86g/30c6acs902ing3x/samplespacelocationtrack.csv	CSV	Gathered during the year 2017	0	bffaa2dd-7e21-45e1-9c62-336b10a1381d	a42f0a61-e0de-4cf6-add8-4fe21c29676a		active	{"datastore_active": false}	\N	2017-08-08 16:50:50.836029	9999-12-31 00:00:00	\N	Data 2017	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:50:49.635222	\N	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc
a42f0a61-e0de-4cf6-add8-4fe21c29676a	http://download1815.mediafireuserdownload.com/edzj903mi86g/30c6acs902ing3x/samplespacelocationtrack.csv	CSV	Gathered during the year 2017	0	3d4c3cf2-2604-49a3-b846-bcfca91c4b22	a42f0a61-e0de-4cf6-add8-4fe21c29676a		active	\N	\N	2017-08-08 16:50:49.589423	2017-08-08 16:50:50.836029	\N	Data 2017	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:50:49.635222	\N	611ebb20-9b7b-40b5-8cdf-7cbd8657a1cc
3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	http://download1640.mediafireuserdownload.com/hf6n735anfwg/k151xmpos9ojip9/samplespacenetfavor.csv	CSV	Latest information of our services	0	ba506755-adf8-4f97-bf70-90355c658dd7	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3		active	{"datastore_active": false}	\N	2017-08-08 16:52:49.648027	9999-12-31 00:00:00	\N	Latest	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:52:48.427175	\N	903d964e-9c2c-47d2-8708-25363ef8d772
3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	http://download1640.mediafireuserdownload.com/hf6n735anfwg/k151xmpos9ojip9/samplespacenetfavor.csv	CSV	Latest information of our services	0	15c99021-e05b-4678-b035-a1e8203dd9e1	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3		active	\N	\N	2017-08-08 16:52:48.401496	2017-08-08 16:52:49.648027	\N	Latest	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:52:48.427175	\N	903d964e-9c2c-47d2-8708-25363ef8d772
0b15b724-fe12-49c9-9b17-e114c025af24	http://download2230.mediafireuserdownload.com/gsxn969vw0mg/3h6uup3epq8sb70/samplespacenormalfeature.csv	CSV	Dataset with information from September 2018 to October 2018	0	d2a0b75b-4856-4b6c-affc-729a99bbe985	0b15b724-fe12-49c9-9b17-e114c025af24		active	{"datastore_active": false}	\N	2017-08-08 16:55:28.496897	9999-12-31 00:00:00	\N	SEPT - OCT 2018	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:55:27.286294	\N	817668d7-be70-479e-92c6-c7e4e8182603
0b15b724-fe12-49c9-9b17-e114c025af24	http://download2230.mediafireuserdownload.com/gsxn969vw0mg/3h6uup3epq8sb70/samplespacenormalfeature.csv	CSV	Dataset with information from September 2018 to October 2018	0	4537cbb8-b49b-4611-9721-a775af0095fe	0b15b724-fe12-49c9-9b17-e114c025af24		active	\N	\N	2017-08-08 16:55:27.252098	2017-08-08 16:55:28.496897	\N	SEPT - OCT 2018	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:55:27.286294	\N	817668d7-be70-479e-92c6-c7e4e8182603
16f7cc6d-3d97-4072-836b-b5180ed980b5	http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv	CSV		0	1815b63f-6afc-43d0-aac9-d8a9daec8f93	16f7cc6d-3d97-4072-836b-b5180ed980b5		active	\N	\N	2017-08-08 16:57:41.818059	2017-08-08 16:57:43.111847	\N	Mobile 001	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:57:41.840862	\N	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64
16f7cc6d-3d97-4072-836b-b5180ed980b5	http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv	CSV	Description of mobile phone users	0	9280682a-0335-4e81-85d6-52933a06e3c9	16f7cc6d-3d97-4072-836b-b5180ed980b5		active	{"datastore_active": true}	\N	2017-08-09 09:04:44.592668	9999-12-31 00:00:00	\N	Mobile 001	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:57:41.840862	\N	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64
16f7cc6d-3d97-4072-836b-b5180ed980b5	http://download2158.mediafireuserdownload.com/e7sovkb1y3qg/6l4o6lv85foucxo/samplespaceproductreq.csv	CSV		0	18ca3b06-e9d5-4129-b12c-1eacc9c8de32	16f7cc6d-3d97-4072-836b-b5180ed980b5		active	{"datastore_active": false}	\N	2017-08-08 16:57:43.111847	2017-08-09 09:04:44.592668	\N	Mobile 001	\N	text/csv	\N	\N	\N	\N	\N	\N	\N	2017-08-08 16:57:41.840862	\N	4bd09dc0-9ab9-4246-8cc1-e0fe9b708c64
ea350acb-36d2-4d3c-8a9a-8684deacd13e				0	b92c6580-a7e2-4290-8714-6a929b069bce	ea350acb-36d2-4d3c-8a9a-8684deacd13e		active	\N	\N	2017-11-23 15:46:18.449887	2017-11-23 15:47:05.225944	\N	Example vid	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 15:46:18.460223	\N	c5895f45-e257-4137-9310-5155f2ec2b22
ea350acb-36d2-4d3c-8a9a-8684deacd13e	earth_zoom_in.mp4			0	c03ec2df-5924-4683-8187-ed089fc01bb8	ea350acb-36d2-4d3c-8a9a-8684deacd13e		active	\N	\N	2017-11-23 15:47:05.225944	2017-11-23 15:54:25.192438	\N	Example vid	\N	video/mp4	\N	8399839	2017-11-23 15:47:05.220516	\N	\N	\N	\N	2017-11-23 15:46:18.460223	upload	c5895f45-e257-4137-9310-5155f2ec2b22
ea350acb-36d2-4d3c-8a9a-8684deacd13e	earth_zoom_in.mp4	mp4		0	fd421030-cb68-4de2-8f11-c5e96c173b98	ea350acb-36d2-4d3c-8a9a-8684deacd13e		active	\N	\N	2017-11-23 15:54:25.192438	2017-11-23 16:16:03.560771	\N	Example vid	\N	video/mp4	\N	8399839	2017-11-23 15:47:05.220516	\N	\N	\N	\N	2017-11-23 15:46:18.460223	upload	c5895f45-e257-4137-9310-5155f2ec2b22
ea350acb-36d2-4d3c-8a9a-8684deacd13e	earth_zoom_in.mp4	dwg		0	d511ee78-7698-40f0-af4b-f77f2ebebe59	ea350acb-36d2-4d3c-8a9a-8684deacd13e		active	\N	\N	2017-11-23 16:16:03.560771	2017-11-23 16:16:22.224111	\N	Example vid	\N	video/mp4	\N	8399839	2017-11-23 15:47:05.220516	\N	\N	\N	\N	2017-11-23 15:46:18.460223	upload	c5895f45-e257-4137-9310-5155f2ec2b22
ea350acb-36d2-4d3c-8a9a-8684deacd13e	http://autode.sk/2zZs3JO	dwg		0	05868de0-c21f-4edd-8afb-40b218b9faf6	ea350acb-36d2-4d3c-8a9a-8684deacd13e		active	\N	\N	2017-11-23 16:16:22.224111	9999-12-31 00:00:00	\N	Example	\N	video/mp4	\N	8399839	2017-11-23 15:47:05.220516	\N	\N	\N	\N	2017-11-23 15:46:18.460223		c5895f45-e257-4137-9310-5155f2ec2b22
b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb	http://192.76.241.143:5000/dataset/15589e3b-0b24-48de-b724-4216f1b28a9f/resource/b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb/download/earth_zoom_in.mp4	mp4		0	b5b9f114-0ecf-4d96-bda8-0b0cde5b04d6	b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb		active	{"datastore_active": false}	\N	2017-11-23 16:44:55.762789	9999-12-31 00:00:00	\N	Prueba	\N	video/mp4	\N	8399839	2017-11-23 16:44:55.621957	\N	\N	\N	\N	2017-11-23 16:44:55.638727	upload	15589e3b-0b24-48de-b724-4216f1b28a9f
b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb	earth_zoom_in.mp4	mp4		0	62048bd6-7dec-4f73-b09b-e3a8e2ef38d1	b5aea483-3b1c-4c8e-88b1-a0745cb3cfeb		active	\N	\N	2017-11-23 16:44:55.628241	2017-11-23 16:44:55.762789	\N	Prueba	\N	video/mp4	\N	8399839	2017-11-23 16:44:55.621957	\N	\N	\N	\N	2017-11-23 16:44:55.638727	upload	15589e3b-0b24-48de-b724-4216f1b28a9f
c910c15e-4b03-42be-918a-672099d6342e	http://autode.sk/2zZs3JO	dwg		0	a35cfd73-4f2e-4fb3-aed5-a5b285bca02d	c910c15e-4b03-42be-918a-672099d6342e		active	{"datastore_active": false}	\N	2017-11-23 16:52:15.890366	9999-12-31 00:00:00	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:52:15.731348	\N	3eafe76b-5d42-43ff-98cb-248a69d3e0cc
c910c15e-4b03-42be-918a-672099d6342e	http://autode.sk/2zZs3JO	dwg		0	61319c01-1286-4756-8ee1-eb4d99eed635	c910c15e-4b03-42be-918a-672099d6342e		active	\N	\N	2017-11-23 16:52:15.723322	2017-11-23 16:52:15.890366	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:52:15.731348	\N	3eafe76b-5d42-43ff-98cb-248a69d3e0cc
3252dcf3-45be-4bd6-a353-5d5cfeef14f5	http://www.imagen.com.mx/assets/img/imagen_share.png	PNG		0	d3d16ded-e5ec-4ca5-9710-cce9eaf61cff	3252dcf3-45be-4bd6-a353-5d5cfeef14f5		active	\N	\N	2017-11-23 16:54:09.765566	2017-11-23 16:54:09.967897	\N		\N	image/png	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:54:09.774576	\N	46a43786-223c-4bd8-b4d0-ca1997e78e70
3252dcf3-45be-4bd6-a353-5d5cfeef14f5	http://www.imagen.com.mx/assets/img/imagen_share.png	PNG		0	edc363a9-dcaa-4ad2-8d16-30c2cfd6ad5e	3252dcf3-45be-4bd6-a353-5d5cfeef14f5		active	{"datastore_active": false}	\N	2017-11-23 16:54:09.967897	2017-11-23 16:54:59.028388	\N		\N	image/png	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:54:09.774576	\N	46a43786-223c-4bd8-b4d0-ca1997e78e70
3252dcf3-45be-4bd6-a353-5d5cfeef14f5	http://www.imagen.com.mx/assets/img/imagen_share.png	PNG		0	b66ffafa-45f9-4548-87d0-6c706c736eeb	3252dcf3-45be-4bd6-a353-5d5cfeef14f5		deleted	{"datastore_active": false}	\N	2017-11-23 16:54:59.028388	9999-12-31 00:00:00	\N		\N	image/png	\N	\N	\N	\N	\N	\N	\N	2017-11-23 16:54:09.774576	\N	46a43786-223c-4bd8-b4d0-ca1997e78e70
351cca2e-fa9f-4a32-a990-a42c92756cbc	earth_zoom_in.mp4	mp4		0	5f370a54-be5e-4668-bf78-b2b18fa2bc44	351cca2e-fa9f-4a32-a990-a42c92756cbc		active	\N	\N	2017-11-23 16:59:46.402036	2017-11-23 16:59:46.590922	\N	prueba	\N	video/mp4	\N	8399839	2017-11-23 16:59:46.395884	\N	\N	\N	\N	2017-11-23 16:59:46.410746	upload	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d
4ee0ec1c-c72b-4bad-be73-364a735cea5c	http://autode.sk/2zsNALP			0	469f7ad0-8cce-4220-8859-7f640494206b	4ee0ec1c-c72b-4bad-be73-364a735cea5c		active	\N	\N	2017-11-23 17:37:19.886163	2017-11-23 17:37:20.059045	\N	Example .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:37:19.897441	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
351cca2e-fa9f-4a32-a990-a42c92756cbc	earth_zoom_in.mp4	mp4		0	87ab6ae0-0d32-41e4-8446-a648e652c8db	351cca2e-fa9f-4a32-a990-a42c92756cbc		active	{"datastore_active": false}	\N	2017-11-23 17:06:26.17582	9999-12-31 00:00:00	\N	prueba	\N	video/mp4	\N	8399839	2017-11-23 17:06:26.169895	\N	\N	\N	\N	2017-11-23 16:59:46.410746	upload	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d
351cca2e-fa9f-4a32-a990-a42c92756cbc	http://192.76.241.143:5000/dataset/cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d/resource/351cca2e-fa9f-4a32-a990-a42c92756cbc/download/earth_zoom_in.mp4	mp4		0	4fc2baf4-0ca3-4ea1-9d25-597e6a6143eb	351cca2e-fa9f-4a32-a990-a42c92756cbc		active	{"datastore_active": false}	\N	2017-11-23 16:59:46.590922	2017-11-23 17:06:26.17582	\N	prueba	\N	video/mp4	\N	8399839	2017-11-23 16:59:46.395884	\N	\N	\N	\N	2017-11-23 16:59:46.410746	upload	cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d
a011526b-bd2f-4f0b-ad32-fbcc419c1814	earth_zoom_in.mp4	video/mp4		0	d74a18d9-14a3-40a4-b848-d1d9148e2102	a011526b-bd2f-4f0b-ad32-fbcc419c1814		active	\N	\N	2017-11-23 17:07:50.644253	2017-11-23 17:07:50.816393	\N	aaaaa	\N	video/mp4	\N	8399839	2017-11-23 17:07:50.637397	\N	\N	\N	\N	2017-11-23 17:07:50.654379	upload	54f83106-f2bf-45a8-8523-53a415c99e47
a011526b-bd2f-4f0b-ad32-fbcc419c1814	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4	video/mp4		0	76a15254-7ed3-4c64-94e0-4c93fd886a70	a011526b-bd2f-4f0b-ad32-fbcc419c1814		active	{"datastore_active": false}	\N	2017-11-23 17:07:50.816393	2017-11-23 17:10:49.355305	\N	aaaaa	\N	video/mp4	\N	8399839	2017-11-23 17:07:50.637397	\N	\N	\N	\N	2017-11-23 17:07:50.654379	upload	54f83106-f2bf-45a8-8523-53a415c99e47
a011526b-bd2f-4f0b-ad32-fbcc419c1814	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4	video/mp4		0	61558a1e-8f38-4eea-be11-4831ab21f9ab	a011526b-bd2f-4f0b-ad32-fbcc419c1814		deleted	{"datastore_active": false}	\N	2017-11-23 17:10:49.355305	9999-12-31 00:00:00	\N	aaaaa	\N	video/mp4	\N	8399839	2017-11-23 17:07:50.637397	\N	\N	\N	\N	2017-11-23 17:07:50.654379	upload	54f83106-f2bf-45a8-8523-53a415c99e47
79820f1e-1f3d-4254-977a-860af37e456e	earth_zoom_in.mp4	video/mp4		0	b832bb18-8732-45d7-858a-97f2a9f85006	79820f1e-1f3d-4254-977a-860af37e456e		deleted	\N	\N	2017-11-23 17:13:07.174286	9999-12-31 00:00:00	\N	ssfdfsfsd	\N	video/mp4	\N	8399839	2017-11-23 17:11:23.949866	\N	\N	\N	\N	2017-11-23 17:11:23.965466	upload	54f83106-f2bf-45a8-8523-53a415c99e47
79820f1e-1f3d-4254-977a-860af37e456e	earth_zoom_in.mp4	video/mp4		0	4609ef6f-b90f-49f1-aef7-0381acb539ba	79820f1e-1f3d-4254-977a-860af37e456e		active	\N	\N	2017-11-23 17:11:23.956824	2017-11-23 17:13:07.174286	\N	ssfdfsfsd	\N	video/mp4	\N	8399839	2017-11-23 17:11:23.949866	\N	\N	\N	\N	2017-11-23 17:11:23.965466	upload	54f83106-f2bf-45a8-8523-53a415c99e47
fea700ad-7abb-4dc9-8219-ec94e7d7f505	earth_zoom_in.mp4	video/mp4	sadasd	0	c84a2f2b-7aae-4ce0-9746-ed5ff839a497	fea700ad-7abb-4dc9-8219-ec94e7d7f505		active	\N	\N	2017-11-23 17:13:31.389751	2017-11-23 17:15:23.474621	\N	sdffsdfsd	\N	video/mp4	\N	8399839	2017-11-23 17:13:31.382671	\N	\N	\N	\N	2017-11-23 17:13:31.399555	upload	54f83106-f2bf-45a8-8523-53a415c99e47
fea700ad-7abb-4dc9-8219-ec94e7d7f505	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/fea700ad-7abb-4dc9-8219-ec94e7d7f505/download/earth_zoom_in.mp4	video/mp4	sadasd	0	be62d02b-aac3-4fa9-adda-5f7055efe684	fea700ad-7abb-4dc9-8219-ec94e7d7f505		active	{"datastore_active": false}	\N	2017-11-23 17:15:23.474621	9999-12-31 00:00:00	\N	sdffsdfsd	\N	video/mp4	\N	8399839	2017-11-23 17:13:31.382671	\N	\N	\N	\N	2017-11-23 17:13:31.399555	upload	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e				1	be62d02b-aac3-4fa9-adda-5f7055efe684	c49a76a9-4a48-4785-994e-9c991b32946e		active	\N	\N	2017-11-23 17:15:23.474621	2017-11-23 17:15:54.400598	\N	PRUEBAS	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:15:23.485571	\N	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e		video/mp4		1	54de6fec-f172-4558-8292-950fa99f513a	c49a76a9-4a48-4785-994e-9c991b32946e		active	\N	\N	2017-11-23 17:15:54.400598	2017-11-23 17:16:10.379915	\N	PRUEBAS	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:15:23.485571	\N	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e	earth_zoom_in.mp4	video/mp4		1	99077077-577e-48cc-bd73-2f28656f45f5	c49a76a9-4a48-4785-994e-9c991b32946e		active	\N	\N	2017-11-23 17:16:10.379915	2017-11-23 17:23:12.523632	\N	PRUEBAS	\N	video/mp4	\N	8399839	2017-11-23 17:16:10.374535	\N	\N	\N	\N	2017-11-23 17:15:23.485571	upload	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e	earth_zoom_in.mp4	video/mp4		1	cd6b8c3c-4df5-42a5-a76a-db925c99dbde	c49a76a9-4a48-4785-994e-9c991b32946e		active	\N	\N	2017-11-23 17:23:12.523632	2017-11-23 17:23:33.216791	\N	PRUEBAS	\N	video/mp4	\N	8399839	2017-11-23 17:23:12.517099	\N	\N	\N	\N	2017-11-23 17:15:23.485571	upload	54f83106-f2bf-45a8-8523-53a415c99e47
c49a76a9-4a48-4785-994e-9c991b32946e	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/c49a76a9-4a48-4785-994e-9c991b32946e/download/earth_zoom_in.mp4	video/mp4		1	ad0c12ae-80f3-437a-8f31-ce5bef87b962	c49a76a9-4a48-4785-994e-9c991b32946e		active	{"datastore_active": false}	\N	2017-11-23 17:23:33.216791	9999-12-31 00:00:00	\N	PRUEBAS	\N	video/mp4	\N	8399839	2017-11-23 17:23:12.517099	\N	\N	\N	\N	2017-11-23 17:15:23.485571	upload	54f83106-f2bf-45a8-8523-53a415c99e47
e0b75bf6-e19e-4a05-b145-fcf770148a89	earth_zoom_in.mp4	video/mp4		3	2d0e5c97-33d8-47d3-9c65-f334df5365fc	e0b75bf6-e19e-4a05-b145-fcf770148a89		active	\N	\N	2017-11-23 17:25:49.828161	9999-12-31 00:00:00	\N	Pruena 4	\N	video/mp4	\N	8399839	2017-11-23 17:25:49.820354	\N	\N	\N	\N	2017-11-23 17:25:49.842967	upload	54f83106-f2bf-45a8-8523-53a415c99e47
df517ee3-17b3-451e-afaf-98115f06aaef	earth_zoom_in.mp4	video/mp4		2	ad0c12ae-80f3-437a-8f31-ce5bef87b962	df517ee3-17b3-451e-afaf-98115f06aaef		active	\N	\N	2017-11-23 17:23:33.216791	2017-11-23 17:25:49.828161	\N	asdfadas	\N	video/mp4	\N	8399839	2017-11-23 17:23:33.208929	\N	\N	\N	\N	2017-11-23 17:23:33.228623	upload	54f83106-f2bf-45a8-8523-53a415c99e47
df517ee3-17b3-451e-afaf-98115f06aaef	http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/df517ee3-17b3-451e-afaf-98115f06aaef/download/earth_zoom_in.mp4	video/mp4		2	2d0e5c97-33d8-47d3-9c65-f334df5365fc	df517ee3-17b3-451e-afaf-98115f06aaef		active	{"datastore_active": false}	\N	2017-11-23 17:25:49.828161	9999-12-31 00:00:00	\N	asdfadas	\N	video/mp4	\N	8399839	2017-11-23 17:23:33.208929	\N	\N	\N	\N	2017-11-23 17:23:33.228623	upload	54f83106-f2bf-45a8-8523-53a415c99e47
8eed1d60-7734-46db-91a7-e472ab7e4fcf	https://www.youtube.com/embed/jNQXAC9IVRw		Youtube first video	0	f7063097-85a5-43cb-8b7b-c3cf3f86fe1e	8eed1d60-7734-46db-91a7-e472ab7e4fcf		active	\N	\N	2017-11-23 17:33:31.502991	2017-11-23 17:33:31.668229	\N	Me at the zoo	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:33:31.511199	\N	acc9dc22-eff3-486b-a715-9a69ef93ade0
8eed1d60-7734-46db-91a7-e472ab7e4fcf	https://www.youtube.com/embed/jNQXAC9IVRw		Youtube first video	0	ce2b7558-924a-445d-a0be-3cfad1f498c2	8eed1d60-7734-46db-91a7-e472ab7e4fcf		active	{"datastore_active": false}	\N	2017-11-23 17:33:31.668229	9999-12-31 00:00:00	\N	Me at the zoo	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:33:31.511199	\N	acc9dc22-eff3-486b-a715-9a69ef93ade0
2b3f434c-6db3-47af-b803-c674eecd1338	earth_zoom_in.mp4	video/mp4		1	740de3d8-633c-4f40-a252-0085125239b2	2b3f434c-6db3-47af-b803-c674eecd1338		active	\N	\N	2017-11-23 17:35:15.661653	9999-12-31 00:00:00	\N	Earth zoom in	\N	video/mp4	\N	8399839	2017-11-23 17:35:15.654452	\N	\N	\N	\N	2017-11-23 17:35:15.669692	upload	acc9dc22-eff3-486b-a715-9a69ef93ade0
1342ec64-f18e-4860-93cc-f6dd194d56ec	http://autode.sk/2zZs3JO			1	f4499856-fe22-47ba-9e93-ac6f2c547685	1342ec64-f18e-4860-93cc-f6dd194d56ec		active	\N	\N	2017-11-23 17:40:23.209452	2017-11-23 17:40:57.416938	\N	Example 3D .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:40:23.217872	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
1342ec64-f18e-4860-93cc-f6dd194d56ec	http://autode.sk/2zZs3JO			1	40aaa8c6-d66d-4632-bfab-bf3daad5244d	1342ec64-f18e-4860-93cc-f6dd194d56ec		active	{"datastore_active": false}	\N	2017-11-23 17:40:57.416938	9999-12-31 00:00:00	\N	Example 3D .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:40:23.217872	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
4ee0ec1c-c72b-4bad-be73-364a735cea5c	http://autode.sk/2zsNALP			0	5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5	4ee0ec1c-c72b-4bad-be73-364a735cea5c		active	{"datastore_active": false}	\N	2017-11-23 17:37:20.059045	2017-11-23 17:40:57.416938	\N	Example .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:37:19.897441	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
4ee0ec1c-c72b-4bad-be73-364a735cea5c	http://autode.sk/2zsNALP			0	40aaa8c6-d66d-4632-bfab-bf3daad5244d	4ee0ec1c-c72b-4bad-be73-364a735cea5c		active	{"datastore_active": false}	\N	2017-11-23 17:40:57.416938	9999-12-31 00:00:00	\N	Example 2D .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-23 17:37:19.897441	\N	476cdf71-1048-4a6f-a28a-58fff547dae5
0ce74f0d-bf35-4627-9f69-92d5c1150dff	http://autode.sk/2zyATiC			0	31c7be31-940b-409d-91b1-7f665f3de66a	0ce74f0d-bf35-4627-9f69-92d5c1150dff		active	\N	\N	2017-11-24 13:37:06.590149	2017-11-24 13:37:06.717505	\N	Example .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-24 13:37:06.599034	\N	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b
0ce74f0d-bf35-4627-9f69-92d5c1150dff	http://autode.sk/2zyATiC			0	07d39bd8-2ebc-4e4f-9018-6edc75251e06	0ce74f0d-bf35-4627-9f69-92d5c1150dff		active	{"datastore_active": false}	\N	2017-11-24 13:37:06.717505	9999-12-31 00:00:00	\N	Example .dwg file	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-24 13:37:06.599034	\N	ca8c20ad-77b6-46d7-a940-1f6a351d7d0b
8649545f-f1d0-49d2-b9cd-88f2593ec059		video/mp4		0	5efbd00b-0986-4ceb-8b66-5a7dde3e1586	8649545f-f1d0-49d2-b9cd-88f2593ec059		active	\N	\N	2017-11-24 13:42:36.230296	2017-11-24 13:42:36.379722	\N	Video TIB	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-24 13:42:36.23793	\N	54920aae-f322-4fca-bd09-cd091946632c
4cc71857-8686-4182-9a0d-9848ef3168e4	generate_beam_directions.ipynb			0	da855841-187d-4983-a6fe-0c3701dfb68e	4cc71857-8686-4182-9a0d-9848ef3168e4		active	\N	\N	2017-11-28 19:32:29.309289	2017-11-28 19:32:29.449516	\N	example notebook	\N	\N	\N	362347	2017-11-28 19:32:29.302457	\N	\N	\N	\N	2017-11-28 19:32:29.318692	upload	bf46d212-6fde-4670-ab59-52bb38c513bc
4cc71857-8686-4182-9a0d-9848ef3168e4	http://192.168.1.15:5000/dataset/bf46d212-6fde-4670-ab59-52bb38c513bc/resource/4cc71857-8686-4182-9a0d-9848ef3168e4/download/generate_beam_directions.ipynb			0	d22239f4-6828-4fa1-be3f-4736fc8b354d	4cc71857-8686-4182-9a0d-9848ef3168e4		active	{"datastore_active": false}	\N	2017-11-28 19:32:29.449516	2017-11-28 19:34:41.945993	\N	example notebook	\N	\N	\N	362347	2017-11-28 19:32:29.302457	\N	\N	\N	\N	2017-11-28 19:32:29.318692	upload	bf46d212-6fde-4670-ab59-52bb38c513bc
4cc71857-8686-4182-9a0d-9848ef3168e4	running-code.ipynb			0	b19c528c-268f-43f7-987a-77da686eef9d	4cc71857-8686-4182-9a0d-9848ef3168e4		active	{"datastore_active": false}	\N	2017-11-28 19:34:41.945993	9999-12-31 00:00:00	\N	example notebook	\N	\N	\N	51563	2017-11-28 19:34:41.940314	\N	\N	\N	\N	2017-11-28 19:32:29.318692	upload	bf46d212-6fde-4670-ab59-52bb38c513bc
8649545f-f1d0-49d2-b9cd-88f2593ec059		video/mp4		0	1c58622d-c7db-4a68-8693-f42da07e9c4e	8649545f-f1d0-49d2-b9cd-88f2593ec059		active	{"datastore_active": false}	\N	2017-11-24 13:42:36.379722	2017-12-01 12:42:20.934054	\N	Video TIB	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-11-24 13:42:36.23793	\N	54920aae-f322-4fca-bd09-cd091946632c
8649545f-f1d0-49d2-b9cd-88f2593ec059	stf50_autocombustions_with_varying_phi_v2_hd.mp4	video/mp4		0	29af1387-94a1-460f-b0d1-fdfb7de377e7	8649545f-f1d0-49d2-b9cd-88f2593ec059		active	{"datastore_active": false}	\N	2017-12-01 12:43:39.909055	9999-12-31 00:00:00	\N	STF50 autocombustions with varying Phi	\N	video/mp4	\N	71194509	2017-12-01 12:42:20.928656	\N	\N	\N	\N	2017-11-24 13:42:36.23793	upload	54920aae-f322-4fca-bd09-cd091946632c
8649545f-f1d0-49d2-b9cd-88f2593ec059	stf50_autocombustions_with_varying_phi_v2_hd.mp4	video/mp4		0	0489aebe-7484-4f6b-a051-9907f1b31b20	8649545f-f1d0-49d2-b9cd-88f2593ec059		active	{"datastore_active": false}	\N	2017-12-01 12:42:20.934054	2017-12-01 12:43:39.909055	\N	Video TIB	\N	video/mp4	\N	71194509	2017-12-01 12:42:20.928656	\N	\N	\N	\N	2017-11-24 13:42:36.23793	upload	54920aae-f322-4fca-bd09-cd091946632c
1e335b61-123e-4ba4-9c5b-9d1d6309dba9	example-machine-learning-notebook.ipynb			0	971f6de4-cde5-4773-9196-fe7fccb4c9ac	1e335b61-123e-4ba4-9c5b-9d1d6309dba9		active	\N	\N	2017-12-01 12:51:28.881885	2017-12-01 12:51:29.035769	\N		\N	\N	\N	703819	2017-12-01 12:51:28.875743	\N	\N	\N	\N	2017-12-01 12:51:28.891625	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
1e335b61-123e-4ba4-9c5b-9d1d6309dba9	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/1e335b61-123e-4ba4-9c5b-9d1d6309dba9/download/example-machine-learning-notebook.ipynb			0	9a2f4e77-4520-4878-b51b-359e8adcba17	1e335b61-123e-4ba4-9c5b-9d1d6309dba9		active	{"datastore_active": false}	\N	2017-12-01 12:51:29.035769	2017-12-01 12:52:47.135119	\N		\N	\N	\N	703819	2017-12-01 12:51:28.875743	\N	\N	\N	\N	2017-12-01 12:51:28.891625	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
1e335b61-123e-4ba4-9c5b-9d1d6309dba9	example-machine-learning-notebook.ipynb			0	6fc03502-641d-4cd0-96d6-e56dfb3caa62	1e335b61-123e-4ba4-9c5b-9d1d6309dba9		active	{"datastore_active": false}	\N	2017-12-01 12:52:47.135119	2017-12-01 12:54:05.117964	\N	Example Machine Learning notebook	\N	\N	\N	703819	2017-12-01 12:51:28.875743	\N	\N	\N	\N	2017-12-01 12:51:28.891625	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
1e335b61-123e-4ba4-9c5b-9d1d6309dba9	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/1e335b61-123e-4ba4-9c5b-9d1d6309dba9/download/example-machine-learning-notebook.ipynb			0	2e56ef3c-2f4f-4f73-b213-4214ece22001	1e335b61-123e-4ba4-9c5b-9d1d6309dba9		active	{"datastore_active": false}	\N	2017-12-01 12:54:05.117964	9999-12-31 00:00:00	\N	Example Machine Learning notebook	\N	\N	\N	703819	2017-12-01 12:51:28.875743	\N	\N	\N	\N	2017-12-01 12:51:28.891625	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
036bcac0-c857-4bf0-bc71-1c78ed35d93a	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/036bcac0-c857-4bf0-bc71-1c78ed35d93a/download/labeled-faces-in-the-wild-recognition.ipynb			1	41602a5a-b63a-4104-ba15-52f0c1c35526	036bcac0-c857-4bf0-bc71-1c78ed35d93a		active	{"datastore_active": false}	\N	2017-12-01 12:55:06.663794	9999-12-31 00:00:00	\N	Labeled Faces in the Wild recognition	\N	\N	\N	717993	2017-12-01 12:54:05.110953	\N	\N	\N	\N	2017-12-01 12:54:05.127144	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
e4cc8bf6-5e32-4c1f-b22e-109d47340c96	satellite_example.ipynb			2	41602a5a-b63a-4104-ba15-52f0c1c35526	e4cc8bf6-5e32-4c1f-b22e-109d47340c96		active	\N	\N	2017-12-01 12:55:06.663794	2017-12-01 12:56:06.85125	\N	Satellite example	\N	\N	\N	7216	2017-12-01 12:55:06.657141	\N	\N	\N	\N	2017-12-01 12:55:06.67396	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
036bcac0-c857-4bf0-bc71-1c78ed35d93a	labeled-faces-in-the-wild-recognition.ipynb			1	2e56ef3c-2f4f-4f73-b213-4214ece22001	036bcac0-c857-4bf0-bc71-1c78ed35d93a		active	\N	\N	2017-12-01 12:54:05.117964	2017-12-01 12:55:06.663794	\N	Labeled Faces in the Wild recognition	\N	\N	\N	717993	2017-12-01 12:54:05.110953	\N	\N	\N	\N	2017-12-01 12:54:05.127144	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
e4cc8bf6-5e32-4c1f-b22e-109d47340c96	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/e4cc8bf6-5e32-4c1f-b22e-109d47340c96/download/satellite_example.ipynb			2	670dffd1-3172-40b8-8e0d-8956760a084a	e4cc8bf6-5e32-4c1f-b22e-109d47340c96		active	{"datastore_active": false}	\N	2017-12-01 12:56:06.85125	9999-12-31 00:00:00	\N	Satellite example	\N	\N	\N	7216	2017-12-01 12:55:06.657141	\N	\N	\N	\N	2017-12-01 12:55:06.67396	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
ec1c5422-b8ab-4401-96fb-0792dacb8e40	12-steps-to-navier-stokes.tar.gz	TAR		4	ec55548e-a397-4b9c-afac-2f24518f3991	ec1c5422-b8ab-4401-96fb-0792dacb8e40		active	\N	\N	2017-12-01 12:58:35.866871	9999-12-31 00:00:00	\N	12 steps to Navier-Stokes	\N	application/x-tar	\N	5708395	2017-12-01 12:58:35.858976	\N	\N	\N	\N	2017-12-01 12:58:35.87733	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
4577e551-96f8-4e13-ac81-012a866d00ac	http://10.116.33.2:5000/dataset/1abefb2e-6a83-4004-b7db-74c34b545d2e/resource/4577e551-96f8-4e13-ac81-012a866d00ac/download/gw150914_tutorial.ipynb			3	ec55548e-a397-4b9c-afac-2f24518f3991	4577e551-96f8-4e13-ac81-012a866d00ac		active	{"datastore_active": false}	\N	2017-12-01 12:58:35.866871	9999-12-31 00:00:00	\N	GW150914 tutorial	\N	\N	\N	2683661	2017-12-01 12:56:06.844366	\N	\N	\N	\N	2017-12-01 12:56:06.860736	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
4577e551-96f8-4e13-ac81-012a866d00ac	gw150914_tutorial.ipynb			3	670dffd1-3172-40b8-8e0d-8956760a084a	4577e551-96f8-4e13-ac81-012a866d00ac		active	\N	\N	2017-12-01 12:56:06.85125	2017-12-01 12:58:35.866871	\N	GW150914 tutorial	\N	\N	\N	2683661	2017-12-01 12:56:06.844366	\N	\N	\N	\N	2017-12-01 12:56:06.860736	upload	1abefb2e-6a83-4004-b7db-74c34b545d2e
\.


--
-- Data for Name: resource_view; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY resource_view (id, resource_id, title, description, view_type, "order", config) FROM stdin;
aef02e9f-4410-408d-83ed-9b3cb93c3f3c	a42f0a61-e0de-4cf6-add8-4fe21c29676a	Data Explorer		recline_view	0	\N
4c612efb-b8c2-4231-85cc-1d999b0c2686	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	Data Explorer		recline_view	0	\N
845a4f43-77f3-4e2d-95ca-fd45b4b96398	0b15b724-fe12-49c9-9b17-e114c025af24	Data Explorer		recline_view	0	\N
31281bee-7c19-40ed-8011-138a0151beb2	16f7cc6d-3d97-4072-836b-b5180ed980b5	Data Explorer		recline_view	0	\N
2e4f4df1-f9c1-4b74-865e-df6ce4c3adae	c910c15e-4b03-42be-918a-672099d6342e	sdsdss		webpage_view	0	{"page_url": "http://autode.sk/2zZs3JO"}
2bc8b770-a8e9-49b3-ab2e-0580f084f917	3252dcf3-45be-4bd6-a353-5d5cfeef14f5	Image		image_view	0	\N
28636ceb-ac50-4952-b9c1-fdf02c02ab9f	351cca2e-fa9f-4a32-a990-a42c92756cbc	video		video_view	0	{"video_url": "http://192.76.241.143:5000/dataset/cc7e17a1-34c9-4cb5-80c9-ede21ee6c79d/resource/351cca2e-fa9f-4a32-a990-a42c92756cbc/download/earth_zoom_in.mp4"}
a567c607-7c25-466a-b237-d22bf441ee1c	a011526b-bd2f-4f0b-ad32-fbcc419c1814	preuasdas		video_view	0	{"video_url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/a011526b-bd2f-4f0b-ad32-fbcc419c1814/download/earth_zoom_in.mp4"}
69f43738-b234-455f-91ed-0e47e0872ba9	79820f1e-1f3d-4254-977a-860af37e456e	sadsdfsd		video_view	0	{"video_url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/79820f1e-1f3d-4254-977a-860af37e456e/download/earth_zoom_in.mp4"}
b1806394-de74-4cf0-9156-fb631943e07c	fea700ad-7abb-4dc9-8219-ec94e7d7f505	priernesdfssdfs	sdfsdf	video_view	0	{"video_url": "http://192.76.241.143:5000/dataset/54f83106-f2bf-45a8-8523-53a415c99e47/resource/fea700ad-7abb-4dc9-8219-ec94e7d7f505/download/earth_zoom_in.mp4"}
f6a2c456-86c1-4b79-a4bc-22fd9d8cc191	e0b75bf6-e19e-4a05-b145-fcf770148a89	Video		videoviewer	0	\N
c82b505e-ab89-4b88-ad88-cd5139496c3b	8eed1d60-7734-46db-91a7-e472ab7e4fcf	Web video view		webpage_view	1	{"page_url": "https://www.youtube.com/embed/jNQXAC9IVRw"}
77eb68fd-888c-4ffd-96d2-4193bc7ba5ad	2b3f434c-6db3-47af-b803-c674eecd1338	Video		videoviewer	0	\N
1fc870fd-2759-4555-acbf-1faedacbe3f5	4ee0ec1c-c72b-4bad-be73-364a735cea5c	Example .dwg view		webpage_view	0	{"page_url": "http://autode.sk/2zsNALP"}
112f0904-7337-49e3-8782-a868b5f906e5	1342ec64-f18e-4860-93cc-f6dd194d56ec	Example .dwg file		webpage_view	0	{"page_url": "http://autode.sk/2zZs3JO"}
3ca5593a-c5f5-403b-bbab-1c6a03ca66f6	0ce74f0d-bf35-4627-9f69-92d5c1150dff	Example CAD		webpage_view	0	{"page_url": "http://autode.sk/2zyATiC"}
7d6f355f-ea2e-4f93-900f-abad36d4c10f	8649545f-f1d0-49d2-b9cd-88f2593ec059	Video		videoviewer	0	\N
c0442c6b-9d26-4f1d-9337-75b9fecb1f14	1e335b61-123e-4ba4-9c5b-9d1d6309dba9	view		webpage_view	0	{"page_url": "https://nbviewer.jupyter.org/github/rhiever/Data-Analysis-and-Machine-Learning-Projects/blob/master/example-data-science-notebook/Example%20Machine%20Learning%20Notebook.ipynb"}
d9c34cef-7daa-46f4-a67d-32054d97662e	036bcac0-c857-4bf0-bc71-1c78ed35d93a	view		webpage_view	0	{"page_url": "http://nbviewer.jupyter.org/github/ogrisel/notebooks/blob/master/Labeled%2520Faces%2520in%2520the%2520Wild%2520recognition.ipynb"}
f89a1a2e-9994-440b-b14f-d8749d61581a	e4cc8bf6-5e32-4c1f-b22e-109d47340c96	view		webpage_view	0	{"page_url": "http://nbviewer.jupyter.org/url/unidata.github.io/python-gallery/_downloads/Satellite_Example.ipynb"}
ba5e8b5b-81f6-4561-80d1-1474f4818ff8	4577e551-96f8-4e13-ac81-012a866d00ac	view		webpage_view	0	{"page_url": "http://nbviewer.jupyter.org/urls/losc.ligo.org/s/events/GW150914/GW150914_tutorial.ipynb"}
0e3155e4-6ca5-4eb7-8241-858ac7890bc0	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_1		webpage_view	1	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/01_Step_1.ipynb"}
04b28583-eb58-4867-8d1f-bdcebf2ecb31	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_2		webpage_view	2	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/02_Step_2.ipynb"}
78268b6c-c7ff-4d57-b95d-8cf8d4beee80	ec1c5422-b8ab-4401-96fb-0792dacb8e40	CFL_Condition		webpage_view	3	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/03_CFL_Condition.ipynb"}
c2440d77-ca61-4ab0-b760-bc176a245361	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_3		webpage_view	4	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/04_Step_3.ipynb"}
c9b2715b-8e4e-4378-894c-c44f271e9b1b	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_4		webpage_view	5	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/05_Step_4.ipynb"}
3e6dcc07-9ffe-4b79-80cd-3f87cdff7375	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Array_Operations_with_NumPy		webpage_view	6	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/06_Array_Operations_with_NumPy.ipynb"}
63959a0d-6a34-4f67-9c40-a7557b750b57	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_5		webpage_view	7	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/07_Step_5.ipynb"}
c34f664a-b3b3-437b-af2c-c32b239e57f3	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_6		webpage_view	8	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/08_Step_6.ipynb"}
63960e24-5a18-426a-87df-a0dd2abaec4a	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_7		webpage_view	9	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/09_Step_7.ipynb"}
dcaf858c-fbb2-4393-9ec1-7335a8e68bfd	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_8		webpage_view	10	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/10_Step_8.ipynb"}
4aeae44e-5979-4dc3-bd21-66daf7244819	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Defining_Function_in_Python		webpage_view	11	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/11_Defining_Function_in_Python.ipynb"}
4a34d74e-8c98-4a03-a936-3a436f78e11e	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_9		webpage_view	12	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/12_Step_9.ipynb"}
c8740058-b25a-499a-a265-84050cfc54fb	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_10		webpage_view	13	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/13_Step_10.ipynb"}
eb28a98e-f096-48d3-9ec1-bd00f3a5e5f8	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_11		webpage_view	14	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/15_Step_11.ipynb"}
5c1a521b-f0f1-4ab0-be3e-a16025d38575	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Step_12		webpage_view	15	{"page_url": "http://nbviewer.ipython.org/urls/github.com/barbagroup/CFDPython/blob/master/lessons/16_Step_12.ipynb"}
87b749f5-c526-4459-a6ce-2d20632ddf5a	ec1c5422-b8ab-4401-96fb-0792dacb8e40	Quick_Python_Intro		webpage_view	0	{"page_url": "http://nbviewer.jupyter.org/github/barbagroup/CFDPython/blob/master/lessons/00_Quick_Python_Intro.ipynb"}
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY revision (id, "timestamp", author, message, state, approved_timestamp) FROM stdin;
8d1097e3-7927-4a56-a0ca-7cf63bac290b	2017-08-08 16:45:27.162981	system	Add versioning to groups, group_extras and package_groups	active	2017-08-08 16:45:27.162981
afac2a9c-773c-4441-abd5-c45d7e5c9601	2017-08-08 16:45:28.557122	admin	Admin: make sure every object has a row in a revision table	active	2017-08-08 16:45:28.557122
729f6192-b932-4413-904c-a72e21f8ef69	2017-08-08 16:46:26.136217	admin		active	\N
214d1b21-6103-4c97-9fa3-145ca5d2f7c1	2017-08-08 16:46:26.246108	admin	REST API: Create member object 	active	\N
2b61e1eb-c56d-4852-b55c-47f0e7308c6e	2017-08-08 16:50:26.684564	admin		active	\N
3d4c3cf2-2604-49a3-b846-bcfca91c4b22	2017-08-08 16:50:49.589423	admin	REST API: Update object event-information	active	\N
bffaa2dd-7e21-45e1-9c62-336b10a1381d	2017-08-08 16:50:50.836029	admin	REST API: Update object event-information	active	\N
65a08933-48aa-426b-bf8a-d11aa32dca95	2017-08-08 16:52:29.604017	admin		active	\N
15c99021-e05b-4678-b035-a1e8203dd9e1	2017-08-08 16:52:48.401496	admin	REST API: Update object services-information	active	\N
ba506755-adf8-4f97-bf70-90355c658dd7	2017-08-08 16:52:49.648027	admin	REST API: Update object services-information	active	\N
8b393d77-16b0-4e7c-b64e-63acf71345d5	2017-08-08 16:54:35.123783	admin		active	\N
4537cbb8-b49b-4611-9721-a775af0095fe	2017-08-08 16:55:27.252098	admin	REST API: Update object internet-dataset	active	\N
d2a0b75b-4856-4b6c-affc-729a99bbe985	2017-08-08 16:55:28.496897	admin	REST API: Update object internet-dataset	active	\N
dd70f0dc-ac9d-4ea3-8888-ddb077b44502	2017-08-08 16:57:30.229943	admin		active	\N
1815b63f-6afc-43d0-aac9-d8a9daec8f93	2017-08-08 16:57:41.818059	admin	REST API: Update object mobile-plans	active	\N
18ca3b06-e9d5-4129-b12c-1eacc9c8de32	2017-08-08 16:57:43.111847	admin	REST API: Update object mobile-plans	active	\N
9280682a-0335-4e81-85d6-52933a06e3c9	2017-08-09 09:04:44.592668	admin	REST API: Update object mobile-plans	active	\N
b4332ffc-49c7-4942-bdcb-2c53f2229dc1	2017-11-23 14:57:51.835359	admin		active	\N
82682f2c-fa0b-4c03-bb4e-b4b9688a30fe	2017-11-23 15:46:09.672312	admin		active	\N
b92c6580-a7e2-4290-8714-6a929b069bce	2017-11-23 15:46:18.449887	admin	REST API: Update object laala	active	\N
ac630955-9972-4f00-b6fa-13a3ca87a7dc	2017-11-23 15:46:18.641891	admin	REST API: Update object laala	active	\N
c03ec2df-5924-4683-8187-ed089fc01bb8	2017-11-23 15:47:05.225944	admin	REST API: Update object laala	active	\N
fd421030-cb68-4de2-8f11-c5e96c173b98	2017-11-23 15:54:25.192438	admin	REST API: Update object laala	active	\N
d511ee78-7698-40f0-af4b-f77f2ebebe59	2017-11-23 16:16:03.560771	admin	REST API: Update object laala	active	\N
05868de0-c21f-4edd-8afb-40b218b9faf6	2017-11-23 16:16:22.224111	admin	REST API: Update object laala	active	\N
454d15f3-840e-4b08-939e-59a7b5419c85	2017-11-23 16:44:34.681607	admin		active	\N
62048bd6-7dec-4f73-b09b-e3a8e2ef38d1	2017-11-23 16:44:55.628241	admin	REST API: Update object prueba	active	\N
b5b9f114-0ecf-4d96-bda8-0b0cde5b04d6	2017-11-23 16:44:55.762789	admin	REST API: Update object prueba	active	\N
79e552b7-ddc1-4eea-b3af-94653149dc1b	2017-11-23 16:51:07.974293	admin	REST API: Delete Package: prueba	active	\N
11460728-1a99-41d2-aa3e-21b670cecf88	2017-11-23 16:51:17.292185	admin	REST API: Delete Package: laala	active	\N
a40e9a0b-920d-4831-be14-2143eff3e1f5	2017-11-23 16:52:07.134719	admin		active	\N
61319c01-1286-4756-8ee1-eb4d99eed635	2017-11-23 16:52:15.723322	admin	REST API: Update object http-autode-sk-2zzs3jo	active	\N
a35cfd73-4f2e-4fb3-aed5-a5b285bca02d	2017-11-23 16:52:15.890366	admin	REST API: Update object http-autode-sk-2zzs3jo	active	\N
0308d025-a61d-4912-927c-b83a259af206	2017-11-23 16:54:02.990389	admin		active	\N
d3d16ded-e5ec-4ca5-9710-cce9eaf61cff	2017-11-23 16:54:09.765566	admin	REST API: Update object http-www-imagen-com-mx-assets-img-imagen_share-png	active	\N
edc363a9-dcaa-4ad2-8d16-30c2cfd6ad5e	2017-11-23 16:54:09.967897	admin	REST API: Update object http-www-imagen-com-mx-assets-img-imagen_share-png	active	\N
b66ffafa-45f9-4548-87d0-6c706c736eeb	2017-11-23 16:54:59.028388	admin	REST API: Update object http-www-imagen-com-mx-assets-img-imagen_share-png	active	\N
6b3e479d-9737-4ca7-b32d-b98bf437a60c	2017-11-23 16:55:10.759507	admin	REST API: Delete Package: http-www-imagen-com-mx-assets-img-imagen_share-png	active	\N
62396fd7-e314-4b1f-bdc8-cd3410ff795e	2017-11-23 16:55:17.143128	admin	REST API: Delete Package: http-autode-sk-2zzs3jo	active	\N
2379ec08-54f7-4f8a-9cb8-a550f3535800	2017-11-23 16:59:32.133562	admin		active	\N
5f370a54-be5e-4668-bf78-b2b18fa2bc44	2017-11-23 16:59:46.402036	admin	REST API: Update object prueba	active	\N
4fc2baf4-0ca3-4ea1-9d25-597e6a6143eb	2017-11-23 16:59:46.590922	admin	REST API: Update object prueba	active	\N
87ab6ae0-0d32-41e4-8446-a648e652c8db	2017-11-23 17:06:26.17582	admin	REST API: Update object prueba	active	\N
1d7a208f-a535-4f6d-ad3c-18d8c9866feb	2017-11-23 17:07:42.003088	admin		active	\N
d74a18d9-14a3-40a4-b848-d1d9148e2102	2017-11-23 17:07:50.644253	admin	REST API: Update object aaaa	active	\N
76a15254-7ed3-4c64-94e0-4c93fd886a70	2017-11-23 17:07:50.816393	admin	REST API: Update object aaaa	active	\N
61558a1e-8f38-4eea-be11-4831ab21f9ab	2017-11-23 17:10:49.355305	admin	REST API: Update object aaaa	active	\N
4609ef6f-b90f-49f1-aef7-0381acb539ba	2017-11-23 17:11:23.956824	admin	REST API: Update object aaaa	active	\N
b832bb18-8732-45d7-858a-97f2a9f85006	2017-11-23 17:13:07.174286	admin	REST API: Update object aaaa	active	\N
c84a2f2b-7aae-4ce0-9746-ed5ff839a497	2017-11-23 17:13:31.389751	admin	REST API: Update object aaaa	active	\N
be62d02b-aac3-4fa9-adda-5f7055efe684	2017-11-23 17:15:23.474621	admin	REST API: Update object aaaa	active	\N
54de6fec-f172-4558-8292-950fa99f513a	2017-11-23 17:15:54.400598	admin	REST API: Update object aaaa	active	\N
99077077-577e-48cc-bd73-2f28656f45f5	2017-11-23 17:16:10.379915	admin	REST API: Update object aaaa	active	\N
cd6b8c3c-4df5-42a5-a76a-db925c99dbde	2017-11-23 17:23:12.523632	admin	REST API: Update object aaaa	active	\N
ad0c12ae-80f3-437a-8f31-ce5bef87b962	2017-11-23 17:23:33.216791	admin	REST API: Update object aaaa	active	\N
2d0e5c97-33d8-47d3-9c65-f334df5365fc	2017-11-23 17:25:49.828161	admin	REST API: Update object aaaa	active	\N
b8777631-802d-4981-aa3a-b71e40e44ea9	2017-11-23 17:28:58.690985	admin	REST API: Delete Package: aaaa	active	\N
78e33def-565f-45dc-b9a4-a1dda81e1ce1	2017-11-23 17:29:52.524044	admin	REST API: Delete Package: event-information	active	\N
201d00c8-1f94-43d3-ac75-e9bfeb22a2f4	2017-11-23 17:29:52.589459	admin	REST API: Delete Package: internet-dataset	active	\N
19ac713d-48f0-48b9-9cd5-7061843bc62f	2017-11-23 17:29:52.65148	admin	REST API: Delete Package: mobile-plans	active	\N
7d60ea7c-29e6-447b-a3c6-e32ad2ccd4f9	2017-11-23 17:29:52.708328	admin	REST API: Delete Package: services-information	active	\N
ccfec652-355d-4640-b04e-9404427ece66	2017-11-23 17:29:52.793785	admin	REST API: Delete Group: china-unicom	active	\N
34c3de5f-7e58-4806-9177-733da1fca73c	2017-11-23 17:30:37.750126	admin		active	\N
6d7701f6-3ad0-4073-a1a9-262f793ac188	2017-11-24 13:40:21.970443	admin		active	\N
5ef118d1-fedc-4799-9a83-c623048d3dc5	2017-11-23 17:30:37.776018	admin	REST API: Create member object 	active	\N
935c959c-8191-4dc4-81b0-50e9e829d325	2017-11-23 17:31:36.655707	admin		active	\N
261614c5-63db-4f81-83d2-45690db30b97	2017-11-24 13:42:19.401789	admin		active	\N
6a333863-cac8-4957-9ed5-968dc91c74be	2017-11-23 17:32:08.010838	admin		active	\N
dea564f1-30b2-4e1a-85dc-f13abbd0803e	2017-11-23 17:32:40.502714	admin		active	\N
5efbd00b-0986-4ceb-8b66-5a7dde3e1586	2017-11-24 13:42:36.230296	admin	REST API: Update object example-video-2	active	\N
f7063097-85a5-43cb-8b7b-c3cf3f86fe1e	2017-11-23 17:33:31.502991	admin	REST API: Update object example-videos	active	\N
ce2b7558-924a-445d-a0be-3cfad1f498c2	2017-11-23 17:33:31.668229	admin	REST API: Update object example-videos	active	\N
1c58622d-c7db-4a68-8693-f42da07e9c4e	2017-11-24 13:42:36.379722	admin	REST API: Update object example-video-2	active	\N
740de3d8-633c-4f40-a252-0085125239b2	2017-11-23 17:35:15.661653	admin	REST API: Update object example-videos	active	\N
00277d2f-879f-426e-98e9-39839776d89d	2017-11-23 17:35:47.356658	admin		active	\N
f732828b-2166-4541-9128-f838a260ae1b	2017-11-23 17:37:00.356594	admin		active	\N
469f7ad0-8cce-4220-8859-7f640494206b	2017-11-23 17:37:19.886163	admin	REST API: Update object example-cad	active	\N
9c5af1cf-98c7-4a89-8c5d-4acc9a801b72	2017-11-28 19:31:59.859318	admin		active	\N
5d3d4988-cbf0-43e0-bb1a-8c9aee0fccd5	2017-11-23 17:37:20.059045	admin	REST API: Update object example-cad	active	\N
f4499856-fe22-47ba-9e93-ac6f2c547685	2017-11-23 17:40:23.209452	admin	REST API: Update object example-cad	active	\N
da855841-187d-4983-a6fe-0c3701dfb68e	2017-11-28 19:32:29.309289	admin	REST API: Update object test-jupyter	active	\N
40aaa8c6-d66d-4632-bfab-bf3daad5244d	2017-11-23 17:40:57.416938	admin	REST API: Update object example-cad	active	\N
f4b8e39c-ebec-4108-b18e-146f213a6a3b	2017-11-24 12:31:07.784957	admin		active	\N
d22239f4-6828-4fa1-be3f-4736fc8b354d	2017-11-28 19:32:29.449516	admin	REST API: Update object test-jupyter	active	\N
01835081-84bb-447b-92b7-cc793a8ec18a	2017-11-24 12:35:58.757075	admin	REST API: Delete Package: prueba	active	\N
39eb3d69-8ca4-477c-b7c6-7556c833986b	2017-11-24 13:36:15.8815	admin		active	\N
b19c528c-268f-43f7-987a-77da686eef9d	2017-11-28 19:34:41.945993	admin	REST API: Update object test-jupyter	active	\N
31c7be31-940b-409d-91b1-7f665f3de66a	2017-11-24 13:37:06.590149	admin	REST API: Update object example-cad-2	active	\N
07d39bd8-2ebc-4e4f-9018-6edc75251e06	2017-11-24 13:37:06.717505	admin	REST API: Update object example-cad-2	active	\N
c0d32fee-6737-4a91-920a-d8aab223e545	2017-12-01 11:56:50.587446	admin		active	\N
78462af9-3e29-41e7-b739-815aa263ff3d	2017-12-01 11:57:19.351494	admin		active	\N
beb04331-d499-485b-9369-1f57aa6f7395	2017-12-01 11:57:31.640309	admin		active	\N
f8632874-e874-4ec3-97ce-c15bffe12f28	2017-12-01 12:26:03.416187	admin	REST API: Delete Package: example-videos	active	\N
f69e3832-0198-44c5-a4f2-f52a65fe3ca2	2017-12-01 12:26:27.563253	admin		active	\N
4c6cf89c-065e-4c3e-85a0-bd6c7ed30b75	2017-12-01 12:26:42.710983	admin	REST API: Delete Package: test-jupyter	active	\N
f42bf4cf-a31c-4645-bb98-9ecbdf58d1ca	2017-12-01 12:27:24.136585	admin		active	\N
0489aebe-7484-4f6b-a051-9907f1b31b20	2017-12-01 12:42:20.934054	admin	REST API: Update object example-video-2	active	\N
29af1387-94a1-460f-b0d1-fdfb7de377e7	2017-12-01 12:43:39.909055	admin	REST API: Update object example-video-2	active	\N
91daa1ea-e394-4b70-a9e0-366b7c0b95fe	2017-12-01 12:51:12.212384	admin		active	\N
971f6de4-cde5-4773-9196-fe7fccb4c9ac	2017-12-01 12:51:28.881885	admin	REST API: Update object jupyter-notebooks	active	\N
9a2f4e77-4520-4878-b51b-359e8adcba17	2017-12-01 12:51:29.035769	admin	REST API: Update object jupyter-notebooks	active	\N
3951536e-4b6f-4e7a-add1-b55c5002dcc0	2017-12-01 12:51:37.465931	admin		active	\N
b0de1461-ba0a-4971-8682-f14af889ae40	2017-12-01 12:51:49.531837	admin		active	\N
997a3d54-bb90-4c1e-88bf-417e4c95ba21	2017-12-01 12:52:07.396644	admin		active	\N
6fc03502-641d-4cd0-96d6-e56dfb3caa62	2017-12-01 12:52:47.135119	admin	REST API: Update object jupyter-notebooks	active	\N
2e56ef3c-2f4f-4f73-b213-4214ece22001	2017-12-01 12:54:05.117964	admin	REST API: Update object jupyter-notebooks	active	\N
b08fcb64-f1a0-4de2-8a84-5e28f3922b16	2017-12-01 12:54:30.52175	admin	REST API: Update object jupyter-notebooks	active	\N
41602a5a-b63a-4104-ba15-52f0c1c35526	2017-12-01 12:55:06.663794	admin	REST API: Update object jupyter-notebooks	active	\N
670dffd1-3172-40b8-8e0d-8956760a084a	2017-12-01 12:56:06.85125	admin	REST API: Update object jupyter-notebooks	active	\N
ec55548e-a397-4b9c-afac-2f24518f3991	2017-12-01 12:58:35.866871	admin	REST API: Update object jupyter-notebooks	active	\N
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: system_info; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY system_info (id, key, value, revision_id, state) FROM stdin;
\.


--
-- Data for Name: system_info_revision; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY system_info_revision (id, key, value, revision_id, continuity_id, state, expired_id, revision_timestamp, expired_timestamp, current) FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY tag (id, name, vocabulary_id) FROM stdin;
5564f2e8-9c79-4125-a2a8-077f38a246ef	event	\N
013c0ce4-51f9-4946-94e3-8e8713360f16	users	\N
cd8f07aa-76ab-4a1a-9567-ba2b7b19779b	services	\N
8c8c1220-8129-4a02-bd2f-8e9b6529c212	internet	\N
a81cb4bd-b2c8-4fc9-9682-9be570d13072	dsl	\N
0f6bdfbd-7412-4e5c-a788-c5fec06b5dd8	mobile	\N
69a1e7a9-0a51-4267-9fb3-db0642f03959	4g	\N
\.


--
-- Data for Name: task_status; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY task_status (id, entity_id, entity_type, task_type, key, value, state, error, last_updated) FROM stdin;
4ee682be-f137-4df6-bb40-5ebd9ea7d42b	a42f0a61-e0de-4cf6-add8-4fe21c29676a	resource	datapusher	datapusher	{"job_id": "28dfd95d-bd63-41ef-87d9-8c8656bb7adb", "job_key": "d5851e36-0111-4d5e-a644-5d6bca85569d"}	complete	{}	2017-08-08 16:50:57.248282
ca174d85-770d-4f33-9e18-052ce47ed4db	3c5d05d9-773a-4f1e-a4e8-59bb4bef00b3	resource	datapusher	datapusher	{"job_id": "a6aabeef-ae87-4f09-9078-014dee28ddbe", "job_key": "fbf05172-1e69-4e29-9774-7d4c4697b144"}	complete	{}	2017-08-08 16:52:55.996468
fa10e43b-3b82-4ed8-887e-66b38f639200	0b15b724-fe12-49c9-9b17-e114c025af24	resource	datapusher	datapusher	{"job_id": "4332ca32-3d81-40eb-95ab-e0031359dc33", "job_key": "1b2df498-3248-41de-98f5-61743bb68eb5"}	complete	{}	2017-08-08 16:55:35.172834
306d446e-6b2b-443d-bb5d-62ec64960b8a	16f7cc6d-3d97-4072-836b-b5180ed980b5	resource	datapusher	datapusher	{"job_id": "60d5cfdc-51ce-48b1-8d3d-b236652a0112", "job_key": "a5c720be-e453-49db-8e86-3825677c281b"}	complete	{}	2017-08-08 16:57:49.137106
\.


--
-- Data for Name: term_translation; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY term_translation (term, term_translation, lang_code) FROM stdin;
\.


--
-- Data for Name: tracking_raw; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY tracking_raw (user_key, url, tracking_type, access_timestamp) FROM stdin;
\.


--
-- Data for Name: tracking_summary; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY tracking_summary (url, package_id, tracking_type, count, running_total, recent_views, tracking_date) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY "user" (id, name, apikey, created, about, openid, password, fullname, email, reset_key, sysadmin, activity_streams_email_notifications, state) FROM stdin;
c8775ce0-12b1-43de-82fb-5f4d738dc6d5	default	2d8395a0-913b-40f3-87be-590f9f1681a4	2017-08-08 16:45:40.229019	\N	\N	$pbkdf2-sha512$25000$GUMoZWwt5XyPcQ4BwLjXGg$.Y9cevb8ua1p7GYypkW.0d0MuGblaZTj6pvGe/9.WnWOedsnXNDTce0RFPJza1IIetLC0iW.4c.QpWy4CAgQIQ	\N	\N	\N	t	f	active
17755db4-395a-4b3b-ac09-e8e3484ca700	admin	65d55933-84a8-4739-b5a8-f3d718fd8cca	2017-08-08 16:45:41.109676	\N	\N	$pbkdf2-sha512$25000$UurdW.v9H8O4957z3nuPEQ$lT/GEKzo24HZonqFZOlh9vHYPcsJpEEyRmr2Ichys1YU2j7yWbEdso/msnSaLN3bdW7HPBjEjogHiKXKL7qbDg	\N	admin@email.com	\N	t	f	active
\.


--
-- Data for Name: user_following_dataset; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY user_following_dataset (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: user_following_group; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY user_following_group (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: user_following_user; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY user_following_user (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: vocabulary; Type: TABLE DATA; Schema: public; Owner: ckan
--

COPY vocabulary (id, name) FROM stdin;
\.


SET search_path = tiger, pg_catalog;

--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: ckan
--

COPY geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: ckan
--

COPY pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: ckan
--

COPY pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: ckan
--

COPY pagc_rules (id, rule, is_custom) FROM stdin;
\.


SET search_path = topology, pg_catalog;

--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: ckan
--

COPY topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: ckan
--

COPY layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Name: system_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('system_info_id_seq', 1, false);


--
-- Name: system_info_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan
--

SELECT pg_catalog.setval('system_info_revision_id_seq', 1, false);


--
-- Name: activity_detail activity_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY activity_detail
    ADD CONSTRAINT activity_detail_pkey PRIMARY KEY (id);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: authorization_group authorization_group_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY authorization_group
    ADD CONSTRAINT authorization_group_pkey PRIMARY KEY (id);


--
-- Name: authorization_group_user authorization_group_user_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY authorization_group_user
    ADD CONSTRAINT authorization_group_user_pkey PRIMARY KEY (id);


--
-- Name: dashboard dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY dashboard
    ADD CONSTRAINT dashboard_pkey PRIMARY KEY (user_id);


--
-- Name: group_extra group_extra_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra
    ADD CONSTRAINT group_extra_pkey PRIMARY KEY (id);


--
-- Name: group_extra_revision group_extra_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra_revision
    ADD CONSTRAINT group_extra_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: group group_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_name_key UNIQUE (name);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: group_revision group_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_revision
    ADD CONSTRAINT group_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: member_revision member_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member_revision
    ADD CONSTRAINT member_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: migrate_version migrate_version_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY migrate_version
    ADD CONSTRAINT migrate_version_pkey PRIMARY KEY (repository_id);


--
-- Name: package_extra package_extra_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra
    ADD CONSTRAINT package_extra_pkey PRIMARY KEY (id);


--
-- Name: package_extra_revision package_extra_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra_revision
    ADD CONSTRAINT package_extra_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: package package_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package
    ADD CONSTRAINT package_name_key UNIQUE (name);


--
-- Name: package package_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package
    ADD CONSTRAINT package_pkey PRIMARY KEY (id);


--
-- Name: package_relationship package_relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship
    ADD CONSTRAINT package_relationship_pkey PRIMARY KEY (id);


--
-- Name: package_relationship_revision package_relationship_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship_revision
    ADD CONSTRAINT package_relationship_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: package_revision package_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_revision
    ADD CONSTRAINT package_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: package_tag package_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag
    ADD CONSTRAINT package_tag_pkey PRIMARY KEY (id);


--
-- Name: package_tag_revision package_tag_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag_revision
    ADD CONSTRAINT package_tag_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_revision resource_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource_revision
    ADD CONSTRAINT resource_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: resource_view resource_view_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource_view
    ADD CONSTRAINT resource_view_pkey PRIMARY KEY (id);


--
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (id);


--
-- Name: system_info system_info_key_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info
    ADD CONSTRAINT system_info_key_key UNIQUE (key);


--
-- Name: system_info system_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info
    ADD CONSTRAINT system_info_pkey PRIMARY KEY (id);


--
-- Name: system_info_revision system_info_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info_revision
    ADD CONSTRAINT system_info_revision_pkey PRIMARY KEY (id, revision_id);


--
-- Name: tag tag_name_vocabulary_id_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_name_vocabulary_id_key UNIQUE (name, vocabulary_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: task_status task_status_entity_id_task_type_key_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY task_status
    ADD CONSTRAINT task_status_entity_id_task_type_key_key UNIQUE (entity_id, task_type, key);


--
-- Name: task_status task_status_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY task_status
    ADD CONSTRAINT task_status_pkey PRIMARY KEY (id);


--
-- Name: user_following_dataset user_following_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_dataset
    ADD CONSTRAINT user_following_dataset_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user_following_group user_following_group_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_group
    ADD CONSTRAINT user_following_group_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user_following_user user_following_user_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_user
    ADD CONSTRAINT user_following_user_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user user_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_name_key UNIQUE (name);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: vocabulary vocabulary_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY vocabulary
    ADD CONSTRAINT vocabulary_name_key UNIQUE (name);


--
-- Name: vocabulary vocabulary_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY vocabulary
    ADD CONSTRAINT vocabulary_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_detail_activity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_activity_detail_activity_id ON activity_detail USING btree (activity_id);


--
-- Name: idx_activity_object_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_activity_object_id ON activity USING btree (object_id, "timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_activity_user_id ON activity USING btree (user_id, "timestamp");


--
-- Name: idx_extra_grp_id_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_extra_grp_id_pkg_id ON member USING btree (group_id, table_id);


--
-- Name: idx_extra_id_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_extra_id_pkg_id ON package_extra USING btree (id, package_id);


--
-- Name: idx_extra_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_extra_pkg_id ON package_extra USING btree (package_id);


--
-- Name: idx_group_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_current ON group_revision USING btree (current);


--
-- Name: idx_group_extra_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_extra_current ON group_extra_revision USING btree (current);


--
-- Name: idx_group_extra_period; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_extra_period ON group_extra_revision USING btree (revision_timestamp, expired_timestamp, id);


--
-- Name: idx_group_extra_period_group; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_extra_period_group ON group_extra_revision USING btree (revision_timestamp, expired_timestamp, group_id);


--
-- Name: idx_group_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_id ON "group" USING btree (id);


--
-- Name: idx_group_name; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_name ON "group" USING btree (name);


--
-- Name: idx_group_period; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_period ON group_revision USING btree (revision_timestamp, expired_timestamp, id);


--
-- Name: idx_group_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_group_pkg_id ON member USING btree (table_id);


--
-- Name: idx_member_continuity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_member_continuity_id ON member_revision USING btree (continuity_id);


--
-- Name: idx_openid; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_openid ON "user" USING btree (openid);


--
-- Name: idx_package_continuity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_continuity_id ON package_revision USING btree (continuity_id);


--
-- Name: idx_package_creator_user_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_creator_user_id ON package USING btree (creator_user_id);


--
-- Name: idx_package_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_current ON package_revision USING btree (current);


--
-- Name: idx_package_extra_continuity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_continuity_id ON package_extra_revision USING btree (continuity_id);


--
-- Name: idx_package_extra_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_current ON package_extra_revision USING btree (current);


--
-- Name: idx_package_extra_package_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_package_id ON package_extra_revision USING btree (package_id, current);


--
-- Name: idx_package_extra_period; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_period ON package_extra_revision USING btree (revision_timestamp, expired_timestamp, id);


--
-- Name: idx_package_extra_period_package; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_period_package ON package_extra_revision USING btree (revision_timestamp, expired_timestamp, package_id);


--
-- Name: idx_package_extra_rev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_extra_rev_id ON package_extra_revision USING btree (revision_id);


--
-- Name: idx_package_group_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_current ON member_revision USING btree (current);


--
-- Name: idx_package_group_group_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_group_id ON member USING btree (group_id);


--
-- Name: idx_package_group_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_id ON member USING btree (id);


--
-- Name: idx_package_group_period_package_group; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_period_package_group ON member_revision USING btree (revision_timestamp, expired_timestamp, table_id, group_id);


--
-- Name: idx_package_group_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_pkg_id ON member USING btree (table_id);


--
-- Name: idx_package_group_pkg_id_group_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_group_pkg_id_group_id ON member USING btree (group_id, table_id);


--
-- Name: idx_package_period; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_period ON package_revision USING btree (revision_timestamp, expired_timestamp, id);


--
-- Name: idx_package_relationship_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_relationship_current ON package_relationship_revision USING btree (current);


--
-- Name: idx_package_resource_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_resource_id ON resource USING btree (id);


--
-- Name: idx_package_resource_rev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_resource_rev_id ON resource_revision USING btree (revision_id);


--
-- Name: idx_package_resource_url; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_resource_url ON resource USING btree (url);


--
-- Name: idx_package_tag_continuity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_continuity_id ON package_tag_revision USING btree (continuity_id);


--
-- Name: idx_package_tag_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_current ON package_tag_revision USING btree (current);


--
-- Name: idx_package_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_id ON package_tag USING btree (id);


--
-- Name: idx_package_tag_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_pkg_id ON package_tag USING btree (package_id);


--
-- Name: idx_package_tag_pkg_id_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_pkg_id_tag_id ON package_tag USING btree (tag_id, package_id);


--
-- Name: idx_package_tag_revision_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_revision_id ON package_tag_revision USING btree (id);


--
-- Name: idx_package_tag_revision_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_revision_pkg_id ON package_tag_revision USING btree (package_id);


--
-- Name: idx_package_tag_revision_pkg_id_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_revision_pkg_id_tag_id ON package_tag_revision USING btree (tag_id, package_id);


--
-- Name: idx_package_tag_revision_rev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_revision_rev_id ON package_tag_revision USING btree (revision_id);


--
-- Name: idx_package_tag_revision_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_revision_tag_id ON package_tag_revision USING btree (tag_id);


--
-- Name: idx_package_tag_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_package_tag_tag_id ON package_tag USING btree (tag_id);


--
-- Name: idx_period_package_relationship; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_period_package_relationship ON package_relationship_revision USING btree (revision_timestamp, expired_timestamp, object_package_id, subject_package_id);


--
-- Name: idx_period_package_tag; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_period_package_tag ON package_tag_revision USING btree (revision_timestamp, expired_timestamp, package_id, tag_id);


--
-- Name: idx_pkg_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_id ON package USING btree (id);


--
-- Name: idx_pkg_lname; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_lname ON package USING btree (lower((name)::text));


--
-- Name: idx_pkg_name; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_name ON package USING btree (name);


--
-- Name: idx_pkg_rev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_rev_id ON package USING btree (revision_id);


--
-- Name: idx_pkg_revision_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_revision_id ON package_revision USING btree (id);


--
-- Name: idx_pkg_revision_name; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_revision_name ON package_revision USING btree (name);


--
-- Name: idx_pkg_revision_rev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_revision_rev_id ON package_revision USING btree (revision_id);


--
-- Name: idx_pkg_sid; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_sid ON package USING btree (id, state);


--
-- Name: idx_pkg_slname; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_slname ON package USING btree (lower((name)::text), state);


--
-- Name: idx_pkg_sname; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_sname ON package USING btree (name, state);


--
-- Name: idx_pkg_srev_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_srev_id ON package USING btree (revision_id, state);


--
-- Name: idx_pkg_stitle; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_stitle ON package USING btree (title, state);


--
-- Name: idx_pkg_suname; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_suname ON package USING btree (upper((name)::text), state);


--
-- Name: idx_pkg_title; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_title ON package USING btree (title);


--
-- Name: idx_pkg_uname; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_pkg_uname ON package USING btree (upper((name)::text));


--
-- Name: idx_rating_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_rating_id ON rating USING btree (id);


--
-- Name: idx_rating_package_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_rating_package_id ON rating USING btree (package_id);


--
-- Name: idx_rating_user_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_rating_user_id ON rating USING btree (user_id);


--
-- Name: idx_resource_continuity_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_resource_continuity_id ON resource_revision USING btree (continuity_id);


--
-- Name: idx_resource_current; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_resource_current ON resource_revision USING btree (current);


--
-- Name: idx_resource_period; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_resource_period ON resource_revision USING btree (revision_timestamp, expired_timestamp, id);


--
-- Name: idx_rev_state; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_rev_state ON revision USING btree (state);


--
-- Name: idx_revision_author; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_revision_author ON revision USING btree (author);


--
-- Name: idx_tag_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_tag_id ON tag USING btree (id);


--
-- Name: idx_tag_name; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_tag_name ON tag USING btree (name);


--
-- Name: idx_user_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_user_id ON "user" USING btree (id);


--
-- Name: idx_user_name; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_user_name ON "user" USING btree (name);


--
-- Name: idx_user_name_index; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX idx_user_name_index ON "user" USING btree ((
CASE
    WHEN ((fullname IS NULL) OR (fullname = ''::text)) THEN name
    ELSE fullname
END));


--
-- Name: term; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX term ON term_translation USING btree (term);


--
-- Name: term_lang; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX term_lang ON term_translation USING btree (term, lang_code);


--
-- Name: tracking_raw_access_timestamp; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_raw_access_timestamp ON tracking_raw USING btree (access_timestamp);


--
-- Name: tracking_raw_url; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_raw_url ON tracking_raw USING btree (url);


--
-- Name: tracking_raw_user_key; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_raw_user_key ON tracking_raw USING btree (user_key);


--
-- Name: tracking_summary_date; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_summary_date ON tracking_summary USING btree (tracking_date);


--
-- Name: tracking_summary_package_id; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_summary_package_id ON tracking_summary USING btree (package_id);


--
-- Name: tracking_summary_url; Type: INDEX; Schema: public; Owner: ckan
--

CREATE INDEX tracking_summary_url ON tracking_summary USING btree (url);


--
-- Name: activity_detail activity_detail_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY activity_detail
    ADD CONSTRAINT activity_detail_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activity(id);


--
-- Name: authorization_group_user authorization_group_user_authorization_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY authorization_group_user
    ADD CONSTRAINT authorization_group_user_authorization_group_id_fkey FOREIGN KEY (authorization_group_id) REFERENCES authorization_group(id);


--
-- Name: authorization_group_user authorization_group_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY authorization_group_user
    ADD CONSTRAINT authorization_group_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: dashboard dashboard_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY dashboard
    ADD CONSTRAINT dashboard_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_extra group_extra_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra
    ADD CONSTRAINT group_extra_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id);


--
-- Name: group_extra_revision group_extra_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra_revision
    ADD CONSTRAINT group_extra_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES group_extra(id);


--
-- Name: group_extra_revision group_extra_revision_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra_revision
    ADD CONSTRAINT group_extra_revision_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id);


--
-- Name: group_extra group_extra_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra
    ADD CONSTRAINT group_extra_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: group_extra_revision group_extra_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_extra_revision
    ADD CONSTRAINT group_extra_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: group_revision group_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_revision
    ADD CONSTRAINT group_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES "group"(id);


--
-- Name: group group_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: group_revision group_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY group_revision
    ADD CONSTRAINT group_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: member member_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id);


--
-- Name: member_revision member_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member_revision
    ADD CONSTRAINT member_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES member(id);


--
-- Name: member_revision member_revision_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member_revision
    ADD CONSTRAINT member_revision_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id);


--
-- Name: member member_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: member_revision member_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY member_revision
    ADD CONSTRAINT member_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_extra package_extra_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra
    ADD CONSTRAINT package_extra_package_id_fkey FOREIGN KEY (package_id) REFERENCES package(id);


--
-- Name: package_extra_revision package_extra_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra_revision
    ADD CONSTRAINT package_extra_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES package_extra(id);


--
-- Name: package_extra package_extra_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra
    ADD CONSTRAINT package_extra_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_extra_revision package_extra_revision_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra_revision
    ADD CONSTRAINT package_extra_revision_package_id_fkey FOREIGN KEY (package_id) REFERENCES package(id);


--
-- Name: package_extra_revision package_extra_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_extra_revision
    ADD CONSTRAINT package_extra_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_relationship package_relationship_object_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship
    ADD CONSTRAINT package_relationship_object_package_id_fkey FOREIGN KEY (object_package_id) REFERENCES package(id);


--
-- Name: package_relationship_revision package_relationship_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship_revision
    ADD CONSTRAINT package_relationship_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES package_relationship(id);


--
-- Name: package_relationship package_relationship_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship
    ADD CONSTRAINT package_relationship_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_relationship_revision package_relationship_revision_object_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship_revision
    ADD CONSTRAINT package_relationship_revision_object_package_id_fkey FOREIGN KEY (object_package_id) REFERENCES package(id);


--
-- Name: package_relationship_revision package_relationship_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship_revision
    ADD CONSTRAINT package_relationship_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_relationship_revision package_relationship_revision_subject_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship_revision
    ADD CONSTRAINT package_relationship_revision_subject_package_id_fkey FOREIGN KEY (subject_package_id) REFERENCES package(id);


--
-- Name: package_relationship package_relationship_subject_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_relationship
    ADD CONSTRAINT package_relationship_subject_package_id_fkey FOREIGN KEY (subject_package_id) REFERENCES package(id);


--
-- Name: package_revision package_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_revision
    ADD CONSTRAINT package_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES package(id);


--
-- Name: package package_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package
    ADD CONSTRAINT package_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_revision package_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_revision
    ADD CONSTRAINT package_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_tag package_tag_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag
    ADD CONSTRAINT package_tag_package_id_fkey FOREIGN KEY (package_id) REFERENCES package(id);


--
-- Name: package_tag_revision package_tag_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag_revision
    ADD CONSTRAINT package_tag_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES package_tag(id);


--
-- Name: package_tag package_tag_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag
    ADD CONSTRAINT package_tag_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_tag_revision package_tag_revision_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag_revision
    ADD CONSTRAINT package_tag_revision_package_id_fkey FOREIGN KEY (package_id) REFERENCES package(id);


--
-- Name: package_tag_revision package_tag_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag_revision
    ADD CONSTRAINT package_tag_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: package_tag_revision package_tag_revision_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag_revision
    ADD CONSTRAINT package_tag_revision_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id);


--
-- Name: package_tag package_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY package_tag
    ADD CONSTRAINT package_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id);


--
-- Name: rating rating_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_package_id_fkey FOREIGN KEY (package_id) REFERENCES package(id);


--
-- Name: rating rating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: resource_revision resource_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource_revision
    ADD CONSTRAINT resource_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES resource(id);


--
-- Name: resource resource_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: resource_revision resource_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource_revision
    ADD CONSTRAINT resource_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: resource_view resource_view_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY resource_view
    ADD CONSTRAINT resource_view_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: system_info_revision system_info_revision_continuity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info_revision
    ADD CONSTRAINT system_info_revision_continuity_id_fkey FOREIGN KEY (continuity_id) REFERENCES system_info(id);


--
-- Name: system_info system_info_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info
    ADD CONSTRAINT system_info_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: system_info_revision system_info_revision_revision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY system_info_revision
    ADD CONSTRAINT system_info_revision_revision_id_fkey FOREIGN KEY (revision_id) REFERENCES revision(id);


--
-- Name: tag tag_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id);


--
-- Name: user_following_dataset user_following_dataset_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_dataset
    ADD CONSTRAINT user_following_dataset_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_dataset user_following_dataset_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_dataset
    ADD CONSTRAINT user_following_dataset_object_id_fkey FOREIGN KEY (object_id) REFERENCES package(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_group user_following_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_group
    ADD CONSTRAINT user_following_group_group_id_fkey FOREIGN KEY (object_id) REFERENCES "group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_group user_following_group_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_group
    ADD CONSTRAINT user_following_group_user_id_fkey FOREIGN KEY (follower_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_user user_following_user_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_user
    ADD CONSTRAINT user_following_user_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_user user_following_user_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan
--

ALTER TABLE ONLY user_following_user
    ADD CONSTRAINT user_following_user_object_id_fkey FOREIGN KEY (object_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

