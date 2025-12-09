--
-- PostgreSQL database dump
--

\restrict xFtcvmcZi0h5aSKNMGEeyKpC6aAfZPG0kcCywQqnjlKwLT2nRbvcq6s9x0sPkHV

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'PENDING',
    'COMPLETED',
    'FAILED',
    'REFUNDED'
);


ALTER TYPE public."PaymentStatus" OWNER TO postgres;

--
-- Name: SocialPlatform; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SocialPlatform" AS ENUM (
    'FACEBOOK',
    'INSTAGRAM',
    'LINKEDIN',
    'TWITTER',
    'GITHUB',
    'YOUTUBE',
    'TIKTOK',
    'WEBSITE',
    'EMAIL',
    'PHONE',
    'ZALO',
    'TELEGRAM'
);


ALTER TYPE public."SocialPlatform" OWNER TO postgres;

--
-- Name: ViewSource; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ViewSource" AS ENUM (
    'DIRECT',
    'QR_SCAN',
    'SOCIAL_MEDIA',
    'EMAIL',
    'OTHER'
);


ALTER TYPE public."ViewSource" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id text NOT NULL,
    "profileId" text NOT NULL,
    "qrCodeUrl" text NOT NULL,
    "pngFileUrl" text,
    "pdfFileUrl" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: profile_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_views (
    id text NOT NULL,
    "profileId" text NOT NULL,
    source public."ViewSource" DEFAULT 'DIRECT'::public."ViewSource" NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    referrer text,
    "timestamp" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.profile_views OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id text NOT NULL,
    "userId" text NOT NULL,
    slug text NOT NULL,
    "fullName" text NOT NULL,
    title text,
    phone text,
    address text,
    "avatarUrl" text,
    "isPublished" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "profileUrl" text,
    "qrCodeUrl" text,
    email text
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: social_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.social_links (
    id text NOT NULL,
    "profileId" text NOT NULL,
    platform public."SocialPlatform" NOT NULL,
    url text NOT NULL,
    "displayOrder" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.social_links OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    "passwordHash" text,
    "googleId" text,
    "fullName" text NOT NULL,
    "lastLoginAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: work_experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_experiences (
    id text NOT NULL,
    "profileId" text NOT NULL,
    company text NOT NULL,
    "position" text NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone,
    description text,
    "displayOrder" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.work_experiences OWNER TO postgres;

--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
ac31daea-3364-446d-a060-d0674b8f5839	e1ca8ac247948b8e46aa77873107b78501086bd5cdf21b5613e8352540a4c341	2025-12-02 05:54:16.794047+00	20251201192712_init	\N	\N	2025-12-02 05:54:16.639713+00	1
ebfad4b1-2a47-4465-9976-d30a80b5f998	83953f0bca9eab43811f90fbacba2dea424740335a0344960892250d4a274784	2025-12-02 07:14:16.75795+00	20251202071416_add_qrcode_fields	\N	\N	2025-12-02 07:14:16.748969+00	1
23f61fed-3ba7-4c17-b251-13dedfe002c5	35e4598a509ea8ad4127cfc81091feacc8fad68be6c45a1aace2c520a7e66e68	2025-12-02 08:53:32.243497+00	20251202085332_add_profile_views	\N	\N	2025-12-02 08:53:32.198688+00	1
050027b4-0f8d-4a64-ac46-da2138bd5a23	2b86b74c8068d1705aaac9596ce96b95cd7e50c676e1bd9daf5603f41bd455ca	2025-12-02 09:40:00.875796+00	20251202094000_add_email_to_profile	\N	\N	2025-12-02 09:40:00.86616+00	1
f42b4dff-8aab-490b-bd6d-000e2059b292	c4085ab47df4bee5b96aaf6711ec6568fe61889ef7e7f1fa89636e5726cffb4b	\N	20251209024101_remove_theme	A migration failed to apply. New migrations cannot be applied before the error is recovered from. Read more about how to resolve migration issues in a production database: https://pris.ly/d/migrate-resolve\n\nMigration name: 20251209024101_remove_theme\n\nDatabase error code: 42601\n\nDatabase error:\nERROR: syntax error at or near "﻿"\n\nPosition:\n[1m  0[0m\n[1m  1[1;31m ﻿-- DropForeignKey[0m\n\nDbError { severity: "ERROR", parsed_severity: Some(Error), code: SqlState(E42601), message: "syntax error at or near \\"\\u{feff}\\"", detail: None, hint: None, position: Some(Original(1)), where_: None, schema: None, table: None, column: None, datatype: None, constraint: None, file: Some("scan.l"), line: Some(1188), routine: Some("scanner_yyerror") }\n\n   0: sql_schema_connector::apply_migration::apply_script\n           with migration_name="20251209024101_remove_theme"\n             at schema-engine/connectors/sql-schema-connector/src/apply_migration.rs:106\n   1: schema_core::commands::apply_migrations::Applying migration\n           with migration_name="20251209024101_remove_theme"\n             at schema-engine/core/src/commands/apply_migrations.rs:91\n   2: schema_core::state::ApplyMigrations\n             at schema-engine/core/src/state.rs:226	2025-12-08 19:42:08.678427+00	2025-12-08 19:41:20.985017+00	0
9360679c-fcdf-4786-a915-88eb8196568f	445793e3f58b30751ed0e99d55243bf05e1cccb6d7f8b31af1816b3502a4caae	2025-12-08 19:42:25.153626+00	20251209024101_remove_theme	\N	\N	2025-12-08 19:42:25.120641+00	1
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, "profileId", "qrCodeUrl", "pngFileUrl", "pdfFileUrl", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: profile_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profile_views (id, "profileId", source, "ipAddress", "userAgent", referrer, "timestamp") FROM stdin;
653d57b1-1f9d-413d-8e7a-a4eaf2b4355b	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-08 20:13:43.841
dd700b6e-67f9-4014-b348-61970595e822	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 04:43:09.15
44eefa4e-e64f-44ac-b673-c0b5bda59a3d	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:15.1
0f9ea609-e200-488f-a3d6-611945ea7f4f	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:39.536
20b1acf0-29a5-4953-9cfa-5136974df687	54361b23-d8b8-45a7-86b0-d9e709f3c82f	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 05:33:34.1
2f81a114-e19a-4a09-999c-a68b509ae1e2	54361b23-d8b8-45a7-86b0-d9e709f3c82f	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 05:33:34.103
aa8ab2f4-d480-43ec-914f-f63bf1acd9ba	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-08 20:13:43.845
717e998f-1b9b-42bc-95e0-d303b961f7d9	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 04:43:09.156
200be35e-08b8-4469-b85d-a89981f90201	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:15.1
0398f8b8-af6d-4891-9ee0-65b585a11291	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:20.69
d5ea187e-cc36-457d-8e6b-2deb42477b02	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:20.694
14192d81-48c5-4d3e-b24f-3a8c689dedd9	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:32:39.536
defa08dd-7662-44f8-a9ca-139f70478d62	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:09.547
1edfd16a-35c9-4832-bbdd-fa59cf3d7f0a	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:33.571
ce538759-5370-4048-bca7-1da0db316df2	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:34.252
862bfebc-b8fd-4d33-83f7-fca04753a3bc	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:34.26
6626b05d-9872-467a-a154-a473763e84ed	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:34.918
32460da2-230d-4d83-a079-5d45dd495885	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:34.923
bac58920-65b0-4517-a0b3-1f2fd0327d93	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:35.154
4f23d0ab-c01b-4540-bd9e-b60cd9531efe	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:35.333
f9e029e1-8025-45e6-8c80-6ad1377f0a18	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:35.341
585a4248-6345-4137-96a0-89c3475afdce	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/h-th-h-i	2025-12-09 05:41:06.08
86825cb5-14ff-4117-891f-e6dcc167793b	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/h-th-h-i	2025-12-09 05:41:06.084
b0576bf6-bc64-4b4b-99c4-c4a4a9c71c1c	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:09.549
6ce436f9-9421-47d7-b143-f023ed3f8562	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-08 19:33:32.979
2d2213e7-139f-459e-a827-3c520a41d033	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:33.568
1e187c31-ae7b-4ee5-a3f8-846d42136b97	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/profile-success	2025-12-09 04:46:35.153
bc241e6c-c9ee-463d-a95d-f6ee99f0b290	17eb559b-6cd3-4ec4-8622-6ce5685b5988	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-08 19:33:32.979
76b68721-4ee4-4b30-b0ac-146af16ecdaf	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:29:10.082
446d783b-b5bb-4cc9-90d4-2292553353ed	04878067-f30d-49ea-9e98-167b3b4b07dd	DIRECT	172.19.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	http://localhost:5173/dashboard	2025-12-09 05:29:10.09
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, "userId", slug, "fullName", title, phone, address, "avatarUrl", "isPublished", "createdAt", "updatedAt", "profileUrl", "qrCodeUrl", email) FROM stdin;
313530d7-407d-498a-8585-8e149788b96d	38b7a075-6d6d-43e6-aa27-0c3aa1f00b79	john-doe	John Doe	Senior Full Stack Developer	+84 123 456 789	Ho Chi Minh City, Vietnam	/avatars/john-doe.jpg	t	2025-12-02 05:54:17.928	2025-12-02 05:54:17.928	\N	\N	\N
17eb559b-6cd3-4ec4-8622-6ce5685b5988	93993b0e-f401-42e1-b54b-354749d7b3c5	nguy-n-v-n-dinh-1	Nguyễn Văn Dinh	Tiktoker	0123456789	Hưng Yên	http://localhost:3000/uploads/avatars/avatar-1765220305403-463435796.jpg	t	2025-12-08 19:33:25.23	2025-12-08 19:33:25.434	http://localhost:5173/nguy-n-v-n-dinh-1	/uploads/qrcodes/17eb559b-6cd3-4ec4-8622-6ce5685b5988.png	maikhaanh11205@gmail.com
04878067-f30d-49ea-9e98-167b3b4b07dd	93993b0e-f401-42e1-b54b-354749d7b3c5	h-th-h-i	Hồ Thế Hải	Software Enginee	0914287711	Mai Dich, Ha Noi	http://localhost:3000/uploads/avatars/avatar-1765255334734-125885915.jpg	t	2025-12-09 04:46:04.357	2025-12-09 05:32:35.482	http://localhost:5173/h-th-h-i	/uploads/qrcodes/04878067-f30d-49ea-9e98-167b3b4b07dd.png	hothehai@gmail.com
54361b23-d8b8-45a7-86b0-d9e709f3c82f	93993b0e-f401-42e1-b54b-354749d7b3c5	gag	gag	gágsg	+84914287716	an lá 2	http://localhost:3000/uploads/avatars/avatar-1765258405061-707997570.jpg	t	2025-12-09 05:33:32.674	2025-12-09 05:33:32.789	http://localhost:5173/gag	/uploads/qrcodes/54361b23-d8b8-45a7-86b0-d9e709f3c82f.png	maikhaanh11205@gmail.com
\.


--
-- Data for Name: social_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.social_links (id, "profileId", platform, url, "displayOrder", "createdAt", "updatedAt") FROM stdin;
social-1-john	313530d7-407d-498a-8585-8e149788b96d	GITHUB	https://github.com/johndoe	1	2025-12-02 05:54:17.952	2025-12-02 05:54:17.952
social-2-john	313530d7-407d-498a-8585-8e149788b96d	LINKEDIN	https://linkedin.com/in/johndoe	2	2025-12-02 05:54:17.961	2025-12-02 05:54:17.961
social-3-john	313530d7-407d-498a-8585-8e149788b96d	EMAIL	mailto:john@example.com	3	2025-12-02 05:54:17.966	2025-12-02 05:54:17.966
social-4-john	313530d7-407d-498a-8585-8e149788b96d	WEBSITE	https://johndoe.dev	4	2025-12-02 05:54:17.97	2025-12-02 05:54:17.97
00223efb-1b8e-4c82-8c63-2f3bf3b2c833	17eb559b-6cd3-4ec4-8622-6ce5685b5988	FACEBOOK	https://www.facebook.com/Khaanh112/	0	2025-12-08 19:33:25.236	2025-12-08 19:33:25.236
264936ca-f584-4de4-9f3e-65d0dde200cd	17eb559b-6cd3-4ec4-8622-6ce5685b5988	INSTAGRAM	https://www.instagram.com/khar_anh112/	1	2025-12-08 19:33:25.236	2025-12-08 19:33:25.236
afc1c994-b9b7-40ea-b4c2-23142cd5d4c8	17eb559b-6cd3-4ec4-8622-6ce5685b5988	GITHUB	https://github.com/khaanh112	2	2025-12-08 19:33:25.236	2025-12-08 19:33:25.236
1e096454-d041-405f-bcca-cd81f5d2b795	04878067-f30d-49ea-9e98-167b3b4b07dd	FACEBOOK	https://www.facebook.com/	0	2025-12-09 05:32:35.488	2025-12-09 05:32:35.488
1fc554ff-a600-42fc-9314-8e8bce594734	04878067-f30d-49ea-9e98-167b3b4b07dd	GITHUB	https://github.com/	1	2025-12-09 05:32:35.488	2025-12-09 05:32:35.488
b74a213a-cd5b-4192-8aed-6c245184759a	04878067-f30d-49ea-9e98-167b3b4b07dd	INSTAGRAM	https://www.instagram.com/	2	2025-12-09 05:32:35.488	2025-12-09 05:32:35.488
a462b2eb-e0cf-4bbf-b0b0-518b0439ea22	54361b23-d8b8-45a7-86b0-d9e709f3c82f	FACEBOOK	https://www.facebook.com/Khaanh112/	0	2025-12-09 05:33:32.678	2025-12-09 05:33:32.678
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, "passwordHash", "googleId", "fullName", "lastLoginAt", "createdAt", "updatedAt") FROM stdin;
38b7a075-6d6d-43e6-aa27-0c3aa1f00b79	testuser@example.com	$2b$10$05VR6rMIYOHZNhNqlfAblejpjomnG4FZFNhmtn5RCnfsubUvSqP46	\N	John Doe	\N	2025-12-02 05:54:17.911	2025-12-02 05:54:17.911
c939ffad-627d-4c50-9735-bbe4205ebc15	demouser@example.com	$2b$10$05VR6rMIYOHZNhNqlfAblejpjomnG4FZFNhmtn5RCnfsubUvSqP46	\N	Jane Smith	\N	2025-12-02 05:54:17.922	2025-12-02 05:54:17.922
a281c543-ecfc-40cd-8517-967885141e4b	23020006@vnu.edu.vn	$2b$10$hjH7JN.Lh7K10GxnzL5EIuI/Wgm/vBDrfimIQy0Q6EyVu.9YOKQC2	\N	Mai khả anh	2025-12-02 06:27:41.266	2025-12-02 06:25:30.642	2025-12-02 06:27:41.267
44c836f9-e76a-4fe3-932c-397cc7e00cf9	minhthudien2005@gmail.com	$2b$10$52Y0o8RVe2bI.Hmqh2euMOajZpHBzqPE2JuWnkGVF0f4v2b/3y86O	\N	Thư	2025-12-02 06:28:50.638	2025-12-02 06:28:09.525	2025-12-02 06:28:50.639
0fd1f92f-845e-4b96-b1a9-1c0782fecc5d	test999@test.com	$2b$10$07j.n5sjlpfbd9VSqpuGAODZuhANU4wKC6bJDzpKFzGSMLbA1/76i	\N	Test User	\N	2025-12-02 06:32:16.327	2025-12-02 06:32:16.327
93993b0e-f401-42e1-b54b-354749d7b3c5	maikhaanh11205@gmail.com	$2b$10$paPebHu54zGyh0auUASGyeCt4mb3d27ziwNQJ4Q0c4eogME0ME2Ju	\N	Mai khả anh	2025-12-09 05:35:45.087	2025-12-02 06:23:52.713	2025-12-09 05:35:45.088
\.


--
-- Data for Name: work_experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_experiences (id, "profileId", company, "position", "startDate", "endDate", description, "displayOrder", "createdAt", "updatedAt") FROM stdin;
exp-1-john	313530d7-407d-498a-8585-8e149788b96d	Tech Corp	Senior Full Stack Developer	2021-01-01 00:00:00	\N	Leading development of enterprise web applications using React, Node.js, and PostgreSQL. Mentoring junior developers and implementing best practices.	1	2025-12-02 05:54:17.939	2025-12-02 05:54:17.939
exp-2-john	313530d7-407d-498a-8585-8e149788b96d	StartUp Inc	Full Stack Developer	2019-06-01 00:00:00	2020-12-31 00:00:00	Built scalable web applications and RESTful APIs. Worked with modern JavaScript frameworks and cloud infrastructure.	2	2025-12-02 05:54:17.947	2025-12-02 05:54:17.947
beab5f14-0663-4381-9a0e-f866a83928f7	17eb559b-6cd3-4ec4-8622-6ce5685b5988	UET	student	2023-08-31 17:00:00	\N	Learning university	0	2025-12-08 19:33:25.234	2025-12-08 19:33:25.234
6d60b0eb-0614-467f-95de-34815b5e4d00	04878067-f30d-49ea-9e98-167b3b4b07dd	Viettel	Software Engineer	2025-06-01 00:00:00	\N	Senior SWE	0	2025-12-09 05:32:35.485	2025-12-09 05:32:35.485
6813c660-d6ad-4882-9889-b9b2b3759054	54361b23-d8b8-45a7-86b0-d9e709f3c82f	ádgas	ádga	2025-12-01 00:00:00	\N		0	2025-12-09 05:33:32.677	2025-12-09 05:33:32.677
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: profile_views profile_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_views
    ADD CONSTRAINT profile_views_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: social_links social_links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_experiences work_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_experiences
    ADD CONSTRAINT work_experiences_pkey PRIMARY KEY (id);


--
-- Name: cards_profileId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "cards_profileId_idx" ON public.cards USING btree ("profileId");


--
-- Name: profile_views_profileId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "profile_views_profileId_idx" ON public.profile_views USING btree ("profileId");


--
-- Name: profile_views_source_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_views_source_idx ON public.profile_views USING btree (source);


--
-- Name: profile_views_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_views_timestamp_idx ON public.profile_views USING btree ("timestamp");


--
-- Name: profiles_isPublished_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "profiles_isPublished_idx" ON public.profiles USING btree ("isPublished");


--
-- Name: profiles_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profiles_slug_idx ON public.profiles USING btree (slug);


--
-- Name: profiles_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX profiles_slug_key ON public.profiles USING btree (slug);


--
-- Name: profiles_userId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "profiles_userId_idx" ON public.profiles USING btree ("userId");


--
-- Name: social_links_profileId_displayOrder_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "social_links_profileId_displayOrder_idx" ON public.social_links USING btree ("profileId", "displayOrder");


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_googleId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "users_googleId_idx" ON public.users USING btree ("googleId");


--
-- Name: users_googleId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "users_googleId_key" ON public.users USING btree ("googleId");


--
-- Name: work_experiences_profileId_displayOrder_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "work_experiences_profileId_displayOrder_idx" ON public.work_experiences USING btree ("profileId", "displayOrder");


--
-- Name: cards cards_profileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT "cards_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_views profile_views_profileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_views
    ADD CONSTRAINT "profile_views_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profiles profiles_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT "profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: social_links social_links_profileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT "social_links_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: work_experiences work_experiences_profileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_experiences
    ADD CONSTRAINT "work_experiences_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict xFtcvmcZi0h5aSKNMGEeyKpC6aAfZPG0kcCywQqnjlKwLT2nRbvcq6s9x0sPkHV

