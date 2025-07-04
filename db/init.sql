-- =================================================================
--  Initialization Script for 'bettergr' and 'keycloak' Databases
-- =================================================================
-- This script runs as the main 'postgres' superuser.

-- Step 1: Create all necessary roles (users) with their passwords.
-- This is a global operation and is done first.
ALTER USER postgres WITH PASSWORD 'bettergr2425';
CREATE USER keycloak WITH PASSWORD 'keycloak';

-- Step 2: Create the additional databases.
-- The 'bettergr' database is created automatically by the POSTGRES_DB environment variable.
CREATE DATABASE keycloak;
ALTER DATABASE keycloak OWNER TO keycloak;


-- =================================================================
--  Step 3: Connect to the 'bettergr' database to restore its schema and data.
-- =================================================================
\connect bettergr postgres

--
-- Content from your original 'init.txt' for the 'bettergr' database
--
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;
ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.announcements ( announcement_id text NOT NULL, course_id text NOT NULL, title text, content text NOT NULL, created_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.announcements OWNER TO postgres;
CREATE TABLE public.course_staffs ( course_id text NOT NULL, staff_id text NOT NULL );
ALTER TABLE public.course_staffs OWNER TO postgres;
CREATE TABLE public.course_students ( course_id text NOT NULL, student_id text NOT NULL );
ALTER TABLE public.course_students OWNER TO postgres;
CREATE TABLE public.courses ( course_id text NOT NULL, course_name text NOT NULL, semester text NOT NULL, description text, created_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.courses OWNER TO postgres;
CREATE TABLE public.grades ( student_id text NOT NULL, course_id text NOT NULL, semester text NOT NULL, grade_type text NOT NULL, grade_value text NOT NULL, graded_by text, comments text, graded_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now(), grade_id text, item_id text );
ALTER TABLE public.grades OWNER TO postgres;
CREATE TABLE public.homework ( homework_id uuid DEFAULT public.uuid_generate_v4() NOT NULL, course_id text NOT NULL, title text NOT NULL, description text NOT NULL, workflow text NOT NULL, due_date timestamp without time zone NOT NULL, created_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.homework OWNER TO postgres;
CREATE TABLE public.staff_members ( staff_id text NOT NULL, first_name text NOT NULL, last_name text NOT NULL, email text NOT NULL, phone_number text NOT NULL, title text, office text, created_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.staff_members OWNER TO postgres;
CREATE TABLE public.students ( student_id text NOT NULL, first_name text NOT NULL, last_name text NOT NULL, email text NOT NULL, phone_number text NOT NULL, created_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.students OWNER TO postgres;
CREATE TABLE public.submissions ( submission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL, homework_id uuid NOT NULL, student_id text NOT NULL, submitted_at timestamp without time zone DEFAULT now(), updated_at timestamp without time zone DEFAULT now() );
ALTER TABLE public.submissions OWNER TO postgres;
COPY public.announcements (announcement_id, course_id, title, content, created_at, updated_at) FROM stdin;
1	236781	Welcome	Welcome to the Deep Learning course!	2025-03-02 11:17:26.789596	2025-03-02 11:17:26.789596
2	236781	Hw1 is out	Homework 1 is now available. The deadline is in 2 weeks.	2025-03-02 11:17:26.797604	2025-03-02 11:17:26.797604
3	236781	HW1 deadline extended	The deadline for Homework 1 has been extended for one more week.	2025-03-02 11:17:26.79885	2025-03-02 11:17:26.79885
4	236781	HW1 grades are up	The grades for Homework 1 are now available in the grades page.	2025-03-02 11:17:26.79976	2025-03-02 11:17:26.79976
5	236781	Hw2 is out	Homework 2 is now available. The deadline is in 2 weeks.	2025-03-02 11:17:26.800902	2025-03-02 11:17:26.800902
6	236781	HW2 deadline extended	The deadline for Homework 2 has been extended for one more week.	2025-03-02 11:17:26.802026	2025-03-02 11:17:26.802026
7	236781	HW2 grades are up	The grades for Homework 2 are now available in the grades page.	2025-03-02 11:17:26.803116	2025-03-02 11:17:26.803116
8	236781	Hw3 is out	Homework 3 is now available. The deadline is in 2 weeks.	2025-03-02 11:17:26.804113	2025-03-02 11:17:26.804113
9	236781	HW3 grades are up	The grades for Homework 3 are now available in the grades page.	2025-03-02 11:17:26.805304	2025-03-02 11:17:26.805304
10	236781	Exam	Good luck on the exam!	2025-03-02 11:17:26.806233	2025-03-02 11:17:26.806233
11	236781	Exam grades are up	The grades for the exam are now available.	2025-03-02 11:17:26.807254	2025-03-02 11:17:26.807254
1	234311	Welcome	Welcome to the Yearly Project course. Please make sure to read the syllabus.	2025-03-02 11:23:12.100989	2025-03-02 11:23:12.100989
2	234311	First Meetup	The first meetup will be on Monday at 10:00 AM in room 101.	2025-03-02 11:23:12.105171	2025-03-02 11:23:12.105171
3	234311	Reminder	Don't forget to submit your project proposals by the end of the week.	2025-03-02 11:23:12.105899	2025-03-02 11:23:12.105899
4	234311	Final Presentation	The final presentation will be on the last day of the semester.	2025-03-02 11:23:12.106626	2025-03-02 11:23:12.106626
5	234311	Final Project Grades	The final project grades have been posted. Please check the course website for your grade.	2025-03-02 11:23:12.107276	2025-03-02 11:23:12.107276
\.
COPY public.course_staffs (course_id, staff_id) FROM stdin;
236781	112233445
234311	214213213
\.
COPY public.course_students (course_id, student_id) FROM stdin;
234311	123456789
234311	987654321
236781	123456789
236781	987654321
\.
COPY public.courses (course_id, course_name, semester, description, created_at, updated_at) FROM stdin;
234311	Yearly Project	Winter_2025	The Yearly Project in Software Engineering	2025-03-02 11:05:11.18368	2025-03-02 21:06:08.216453
236781	Deep Learning	Winter_2025	Deep Learning on Computational Accelerators	2025-03-02 11:05:11.190321	2025-03-02 21:06:08.216453
\.
COPY public.grades (student_id, course_id, semester, grade_type, grade_value, graded_by, comments, graded_at, updated_at, grade_id, item_id) FROM stdin;
123456789	234311	Winter_2025	Final Project	95	214213213	Excellent!	2025-03-02 11:31:12.580563	2025-03-02 21:05:56.052018	1	\N
123456789	236781	Winter_2025	Exam	100	112233445	Excellent work!	2025-03-02 12:49:43.034236	2025-03-02 21:05:56.052018	2	\N
123456789	236781	Winter_2025	Exam A	93	112233445	Outstanding!	2025-03-02 11:31:12.571287	2025-03-02 21:05:56.052018	3	\N
123456789	236781	Winter_2025	HW1	95	112233445	Great job!	2025-03-02 11:31:12.556779	2025-03-02 21:05:56.052018	4	\N
123456789	236781	Winter_2025	HW2	88	112233445	Well done!	2025-03-02 11:31:12.566977	2025-03-02 21:05:56.052018	5	\N
123456789	236781	Winter_2025	HW3	92	112233445	Good effort!	2025-03-02 11:31:12.567933	2025-03-02 21:05:56.052018	6	\N
987654321	234311	Spring_2025	Final Project	93	214213213	Excellent!	2025-03-02 11:35:41.928066	2025-03-02 21:05:56.052018	7	\N
987654321	236781	Spring_2025	Exam A	90	112233445	Outstanding!	2025-03-02 11:35:41.927243	2025-03-02 21:05:56.052018	8	\N
987654321	236781	Spring_2025	HW1	89	112233445	Good job!	2025-03-02 11:35:41.917314	2025-03-02 21:05:56.052018	9	\N
987654321	236781	Spring_2025	HW2	91	112233445	Well done!	2025-03-02 11:35:41.924547	2025-03-02 21:05:56.052018	10	\N
987654321	236781	Spring_2025	HW3	87	112233445	Nice effort!	2025-03-02 11:35:41.92636	2025-03-02 21:05:56.052018	11	\N
\.
COPY public.homework (homework_id, course_id, title, description, workflow, due_date, created_at, updated_at) FROM stdin;
\.
COPY public.staff_members (staff_id, first_name, last_name, email, phone_number, title, office, created_at, updated_at) FROM stdin;
112233445	Sabry	Assaf	Sabry@hotmail.com	0529966309	Professor		2025-03-02 11:04:45.416686	2025-03-02 11:04:45.416686
214213213	Atheer	Alsharif	Atheer@google.com	0505500569	Software Engineer		2025-03-02 11:04:45.424663	2025-03-02 11:04:45.424663
\.
COPY public.students (student_id, first_name, last_name, email, phone_number, created_at, updated_at) FROM stdin;
123456789	Maroon	Ayoub	vMaroon@technion.ac.il	0524206699	2025-03-02 11:03:16.866018	2025-03-02 11:03:16.866018
987654321	Rick	Astley	NeverGonna@giveyou.up	0526666666	2025-03-02 11:03:16.878981	2025-03-02 11:03:16.878981
\.
COPY public.submissions (submission_id, homework_id, student_id, submitted_at, updated_at) FROM stdin;
\.
ALTER TABLE ONLY public.announcements ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id, course_id);
ALTER TABLE ONLY public.course_staffs ADD CONSTRAINT course_staffs_pkey PRIMARY KEY (course_id, staff_id);
ALTER TABLE ONLY public.course_students ADD CONSTRAINT course_students_pkey PRIMARY KEY (course_id, student_id);
ALTER TABLE ONLY public.courses ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_pkey PRIMARY KEY (student_id, course_id, semester, grade_type);
ALTER TABLE ONLY public.homework ADD CONSTRAINT homework_pkey PRIMARY KEY (homework_id);
ALTER TABLE ONLY public.staff_members ADD CONSTRAINT staff_members_email_key UNIQUE (email);
ALTER TABLE ONLY public.staff_members ADD CONSTRAINT staff_members_phone_number_key UNIQUE (phone_number);
ALTER TABLE ONLY public.staff_members ADD CONSTRAINT staff_members_pkey PRIMARY KEY (staff_id);
ALTER TABLE ONLY public.students ADD CONSTRAINT students_email_key UNIQUE (email);
ALTER TABLE ONLY public.students ADD CONSTRAINT students_phone_number_key UNIQUE (phone_number);
ALTER TABLE ONLY public.students ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);
ALTER TABLE ONLY public.submissions ADD CONSTRAINT submissions_pkey PRIMARY KEY (submission_id);
CREATE INDEX idx_course_staff_course_id ON public.course_staffs USING btree (course_id);
CREATE INDEX idx_course_staff_staff_id ON public.course_staffs USING btree (staff_id);
CREATE INDEX idx_course_student_course_id ON public.course_students USING btree (course_id);
CREATE INDEX idx_course_student_student_id ON public.course_students USING btree (student_id);
CREATE INDEX idx_grade_course_id ON public.grades USING btree (course_id);
CREATE INDEX idx_grade_semester ON public.grades USING btree (semester);
CREATE INDEX idx_grade_student_id ON public.grades USING btree (student_id);
CREATE INDEX idx_homework_course_id ON public.homework USING btree (course_id);
CREATE INDEX idx_submission_homework_id ON public.submissions USING btree (homework_id);
CREATE INDEX idx_submission_student_id ON public.submissions USING btree (student_id);
CREATE TRIGGER trigger_announcements_updated_at BEFORE UPDATE ON public.announcements FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_courses_updated_at BEFORE UPDATE ON public.courses FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_grades_updated_at BEFORE UPDATE ON public.grades FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_homework_updated_at BEFORE UPDATE ON public.homework FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_staff_updated_at BEFORE UPDATE ON public.staff_members FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_students_updated_at BEFORE UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
CREATE TRIGGER trigger_submissions_updated_at BEFORE UPDATE ON public.submissions FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();
ALTER TABLE ONLY public.announcements ADD CONSTRAINT announcements_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.course_staffs ADD CONSTRAINT course_staffs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.course_staffs ADD CONSTRAINT course_staffs_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff_members(staff_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.course_students ADD CONSTRAINT course_students_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.course_students ADD CONSTRAINT course_students_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_graded_by_course_id_fkey FOREIGN KEY (graded_by, course_id) REFERENCES public.course_staffs(staff_id, course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.staff_members(staff_id) ON DELETE SET NULL;
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_student_id_course_id_fkey FOREIGN KEY (student_id, course_id) REFERENCES public.course_students(student_id, course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.grades ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.homework ADD CONSTRAINT homework_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.submissions ADD CONSTRAINT submissions_homework_id_fkey FOREIGN KEY (homework_id) REFERENCES public.homework(homework_id) ON DELETE CASCADE;
ALTER TABLE ONLY public.submissions ADD CONSTRAINT submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


-- =================================================================
--  Step 4: Connect to the 'keycloak' database to restore its schema and data.
-- =================================================================
\connect keycloak keycloak

--
-- Content from your 'keycloak_dump.txt' file
--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.admin_event_entity ( id character varying(36) NOT NULL, admin_event_time bigint, realm_id character varying(255), operation_type character varying(255), auth_realm_id character varying(255), auth_client_id character varying(255), auth_user_id character varying(255), ip_address character varying(255), resource_path character varying(2550), representation text, error character varying(255), resource_type character varying(64), details_json text );
ALTER TABLE public.admin_event_entity OWNER TO keycloak;

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: org; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO keycloak;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
539f9f6a-dcf6-495e-8b37-163106090dde	\N	auth-cookie	071eec07-9d0a-411e-bf21-78c3daf9b724	843aaf52-a2f3-4d10-b574-caf696b2928a	2	10	f	\N	\N
01094e28-dc28-4fda-9bc4-3ba8abaca7dc	\N	auth-spnego	071eec07-9d0a-411e-bf21-78c3daf9b724	843aaf52-a2f3-4d10-b574-caf696b2928a	3	20	f	\N	\N
ca4fcf4a-358f-4a80-9840-a2ad8d36ab5b	\N	identity-provider-redirector	071eec07-9d0a-411e-bf21-78c3daf9b724	843aaf52-a2f3-4d10-b574-caf696b2928a	2	25	f	\N	\N
216c5b39-a41f-4857-99ed-25b23589a401	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	843aaf52-a2f3-4d10-b574-caf696b2928a	2	30	t	d958ee57-8523-4081-a4b3-b0d2973c051f	\N
f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f	\N	auth-username-password-form	071eec07-9d0a-411e-bf21-78c3daf9b724	d958ee57-8523-4081-a4b3-b0d2973c051f	0	10	f	\N	\N
a0b77cd6-88b4-4195-9edf-2860e1c5400a	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	d958ee57-8523-4081-a4b3-b0d2973c051f	1	20	t	1c079bd8-c0e6-4930-bda6-946fba0a2347	\N
c0d2ced8-6579-48c2-a0e8-1f8972f12b03	\N	conditional-user-configured	071eec07-9d0a-411e-bf21-78c3daf9b724	1c079bd8-c0e6-4930-bda6-946fba0a2347	0	10	f	\N	\N
900a98e2-6e75-4f5f-9e63-926d65c01772	\N	auth-otp-form	071eec07-9d0a-411e-bf21-78c3daf9b724	1c079bd8-c0e6-4930-bda6-946fba0a2347	0	20	f	\N	\N
f4cad826-8471-48ed-afe2-913dfdf2fe0d	\N	direct-grant-validate-username	071eec07-9d0a-411e-bf21-78c3daf9b724	c420d152-6d04-4493-a038-565dd5e1ee8c	0	10	f	\N	\N
3ef6e19d-27c3-4995-824a-1df9bc80ecc1	\N	direct-grant-validate-password	071eec07-9d0a-411e-bf21-78c3daf9b724	c420d152-6d04-4493-a038-565dd5e1ee8c	0	20	f	\N	\N
57864516-b699-44e3-abf7-1b78c96f7be1	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	c420d152-6d04-4493-a038-565dd5e1ee8c	1	30	t	76584926-5136-45cf-a016-834b49d6b40d	\N
98553301-7d08-4a6b-8795-a9951d446b2b	\N	conditional-user-configured	071eec07-9d0a-411e-bf21-78c3daf9b724	76584926-5136-45cf-a016-834b49d6b40d	0	10	f	\N	\N
d4bb0801-cf77-4b8d-be9f-7372d5d94508	\N	direct-grant-validate-otp	071eec07-9d0a-411e-bf21-78c3daf9b724	76584926-5136-45cf-a016-834b49d6b40d	0	20	f	\N	\N
82e4f9ef-d3e4-4794-b98b-dc32519441b6	\N	registration-page-form	071eec07-9d0a-411e-bf21-78c3daf9b724	e7b26792-c783-473f-87ab-86f1274a1c34	0	10	t	64574d8f-8122-4d2f-a181-cd1b089f4b04	\N
4b9e7e35-0688-4be5-bea9-32c6c3405d1f	\N	registration-user-creation	071eec07-9d0a-411e-bf21-78c3daf9b724	64574d8f-8122-4d2f-a181-cd1b089f4b04	0	20	f	\N	\N
897dd632-1e4f-43f1-8aa8-4d638ca46bc9	\N	registration-password-action	071eec07-9d0a-411e-bf21-78c3daf9b724	64574d8f-8122-4d2f-a181-cd1b089f4b04	0	50	f	\N	\N
93b70623-893c-4c8f-896a-c1b5cefed588	\N	registration-recaptcha-action	071eec07-9d0a-411e-bf21-78c3daf9b724	64574d8f-8122-4d2f-a181-cd1b089f4b04	3	60	f	\N	\N
fce58038-4e4e-4fc2-880b-c63ce658912c	\N	registration-terms-and-conditions	071eec07-9d0a-411e-bf21-78c3daf9b724	64574d8f-8122-4d2f-a181-cd1b089f4b04	3	70	f	\N	\N
2387732a-78c1-4e00-8467-873e9d8c6f66	\N	reset-credentials-choose-user	071eec07-9d0a-411e-bf21-78c3daf9b724	fc7e3485-e920-4b38-ae87-45408b29d3e3	0	10	f	\N	\N
bd4c7a4b-c780-4e88-9697-dd07545bd55b	\N	reset-credential-email	071eec07-9d0a-411e-bf21-78c3daf9b724	fc7e3485-e920-4b38-ae87-45408b29d3e3	0	20	f	\N	\N
1e842bf8-1878-4982-94bb-6071d386429f	\N	reset-password	071eec07-9d0a-411e-bf21-78c3daf9b724	fc7e3485-e920-4b38-ae87-45408b29d3e3	0	30	f	\N	\N
9906104e-a20b-4dd1-89b3-7bc6efe02480	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	fc7e3485-e920-4b38-ae87-45408b29d3e3	1	40	t	cc54aca9-5333-49f9-97d5-787dc2a8d9e5	\N
63b037bd-f254-442f-a943-2e7d1c231c16	\N	conditional-user-configured	071eec07-9d0a-411e-bf21-78c3daf9b724	cc54aca9-5333-49f9-97d5-787dc2a8d9e5	0	10	f	\N	\N
3fdc500e-13c5-4ef4-8ac6-4c5cbd80c264	\N	reset-otp	071eec07-9d0a-411e-bf21-78c3daf9b724	cc54aca9-5333-49f9-97d5-787dc2a8d9e5	0	20	f	\N	\N
4d480216-af5b-4071-84d9-ead859bf215e	\N	client-secret	071eec07-9d0a-411e-bf21-78c3daf9b724	786ed56a-0af4-445b-aeaf-daaff6b903d6	2	10	f	\N	\N
7e444638-cbb3-4029-a15d-df88ac267b62	\N	client-jwt	071eec07-9d0a-411e-bf21-78c3daf9b724	786ed56a-0af4-445b-aeaf-daaff6b903d6	2	20	f	\N	\N
9f085a8b-fbc3-460b-9908-a8302eabb27c	\N	client-secret-jwt	071eec07-9d0a-411e-bf21-78c3daf9b724	786ed56a-0af4-445b-aeaf-daaff6b903d6	2	30	f	\N	\N
115d574a-5eb3-4a0d-b154-afacfdcd2c28	\N	client-x509	071eec07-9d0a-411e-bf21-78c3daf9b724	786ed56a-0af4-445b-aeaf-daaff6b903d6	2	40	f	\N	\N
2c3263df-f489-48a4-893d-6fadc6fc1ef0	\N	idp-review-profile	071eec07-9d0a-411e-bf21-78c3daf9b724	360a664c-63d9-4c2c-afa9-d86aab6fe6f5	0	10	f	\N	eb679dd6-be19-490d-b89f-855325902054
6eecd508-c127-466c-b8bb-bf9ca1ac6060	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	360a664c-63d9-4c2c-afa9-d86aab6fe6f5	0	20	t	bb7c12e8-9c81-4eaf-aa7d-20793bf37bc6	\N
a70b2f9f-6a80-4588-a558-e16b1ae03421	\N	idp-create-user-if-unique	071eec07-9d0a-411e-bf21-78c3daf9b724	bb7c12e8-9c81-4eaf-aa7d-20793bf37bc6	2	10	f	\N	57b1c014-099a-45c7-8ae2-d17f473a1249
bd051322-1333-4d3f-be88-a2a42ddcf718	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	bb7c12e8-9c81-4eaf-aa7d-20793bf37bc6	2	20	t	3c01b24f-9413-42e8-932e-bf2869c02ead	\N
9ac5e3de-dd2a-46d2-aa77-c3dccc8d8254	\N	idp-confirm-link	071eec07-9d0a-411e-bf21-78c3daf9b724	3c01b24f-9413-42e8-932e-bf2869c02ead	0	10	f	\N	\N
f9bb5d93-ab18-43b6-b9a2-f9d26b6e2822	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	3c01b24f-9413-42e8-932e-bf2869c02ead	0	20	t	ff75d290-6d53-44f2-94a0-80bca7eb8fe9	\N
9fb28fdf-92e1-40e3-96ce-6362a00067e0	\N	idp-email-verification	071eec07-9d0a-411e-bf21-78c3daf9b724	ff75d290-6d53-44f2-94a0-80bca7eb8fe9	2	10	f	\N	\N
631d7df8-d276-4b97-bc8a-dde41a3c1934	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	ff75d290-6d53-44f2-94a0-80bca7eb8fe9	2	20	t	823676ae-4bbe-4217-bef0-b6a046c3bf86	\N
e6fbd5cf-1d55-4c24-a4ed-ec85ce988363	\N	idp-username-password-form	071eec07-9d0a-411e-bf21-78c3daf9b724	823676ae-4bbe-4217-bef0-b6a046c3bf86	0	10	f	\N	\N
3eea0814-1e01-4183-ac76-96c8680f4789	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	823676ae-4bbe-4217-bef0-b6a046c3bf86	1	20	t	f40fb760-52fd-4e95-a58a-596b651ce548	\N
ee9d72bb-eceb-48e7-b124-0aa1568fc322	\N	conditional-user-configured	071eec07-9d0a-411e-bf21-78c3daf9b724	f40fb760-52fd-4e95-a58a-596b651ce548	0	10	f	\N	\N
ea2edc76-239c-46da-8da9-92e5652a6b95	\N	auth-otp-form	071eec07-9d0a-411e-bf21-78c3daf9b724	f40fb760-52fd-4e95-a58a-596b651ce548	0	20	f	\N	\N
ab8d49e6-80ad-456c-b06a-70744510b59d	\N	http-basic-authenticator	071eec07-9d0a-411e-bf21-78c3daf9b724	e74dd530-01e0-4b90-89ae-98cba3c61faa	0	10	f	\N	\N
64c0cc14-2d5d-460d-97fd-8fa2b1182f56	\N	docker-http-basic-authenticator	071eec07-9d0a-411e-bf21-78c3daf9b724	029ab0ed-6bb5-458f-9a9c-709e7b6677cd	0	10	f	\N	\N
eb1b7796-a37e-49fb-b667-db41054d91ee	\N	auth-cookie	betterGR	c8dbd0bf-efd6-4eab-a155-a8df46e3e66f	2	0	f	\N	\N
0f812a08-ee80-4c67-af19-0830e1aa83e7	\N	auth-username-password-form	betterGR	c8dbd0bf-efd6-4eab-a155-a8df46e3e66f	0	0	f	\N	\N
d91be187-032c-4dac-8f21-e231fa7f9c9c	\N	direct-grant-validate-username	betterGR	80cbc004-0fd5-4477-b3ab-c6b22ee6d8b7	0	10	f	\N	\N
51753732-3431-45d3-b823-a51ef79ca209	\N	direct-grant-validate-password	betterGR	80cbc004-0fd5-4477-b3ab-c6b22ee6d8b7	0	20	f	\N	\N
7e3d5069-80a2-413f-bdd1-945e507a3722	\N	\N	betterGR	80cbc004-0fd5-4477-b3ab-c6b22ee6d8b7	1	30	t	81b6fe38-7df7-4540-97cf-7c8618dd8da3	\N
a8e5ea40-dff0-42e2-afa2-d55f968b7bd5	\N	conditional-user-configured	betterGR	81b6fe38-7df7-4540-97cf-7c8618dd8da3	0	10	f	\N	\N
5c1873e2-7c05-4809-a081-521eb39f8400	\N	direct-grant-validate-otp	betterGR	81b6fe38-7df7-4540-97cf-7c8618dd8da3	0	20	f	\N	\N
16117162-c090-470e-93a5-ce875b0c517b	\N	registration-page-form	betterGR	6dcbeaa0-e548-4f39-8fbd-23861b87c019	0	10	t	344d89b9-cfec-47d7-a434-823ffb03597f	\N
35ba8977-d528-4a41-a142-040dd290e93a	\N	registration-user-creation	betterGR	344d89b9-cfec-47d7-a434-823ffb03597f	0	20	f	\N	\N
2a685edb-cd29-4b92-9e0f-b271e338bc9a	\N	registration-password-action	betterGR	344d89b9-cfec-47d7-a434-823ffb03597f	0	50	f	\N	\N
9e7595ff-130e-4c44-9a92-ba6f9071ce22	\N	registration-recaptcha-action	betterGR	344d89b9-cfec-47d7-a434-823ffb03597f	3	60	f	\N	\N
b615e8ca-bd21-4c1f-a740-3b25f3ad533d	\N	registration-terms-and-conditions	betterGR	344d89b9-cfec-47d7-a434-823ffb03597f	3	70	f	\N	\N
a9ba1f9c-539c-4e4a-955a-3237bf1ccdac	\N	reset-credentials-choose-user	betterGR	b3f2d4cc-284d-44db-9578-ca37df3db3d3	0	10	f	\N	\N
66b3123d-2661-42bf-8844-eaf7efdba97a	\N	reset-credential-email	betterGR	b3f2d4cc-284d-44db-9578-ca37df3db3d3	0	20	f	\N	\N
b1d221ff-cd3b-44d4-9033-c7ad5ce98c4a	\N	reset-password	betterGR	b3f2d4cc-284d-44db-9578-ca37df3db3d3	0	30	f	\N	\N
ba3e49e1-37a3-4a81-b526-aadcb5c6918e	\N	\N	betterGR	b3f2d4cc-284d-44db-9578-ca37df3db3d3	1	40	t	85d0bb35-6d14-4086-afa9-de6e755608dd	\N
91cb7038-e9f7-4346-a2ab-650ad94de42b	\N	conditional-user-configured	betterGR	85d0bb35-6d14-4086-afa9-de6e755608dd	0	10	f	\N	\N
98eb5b84-7b5e-4236-ae9f-ba5e542fbb09	\N	reset-otp	betterGR	85d0bb35-6d14-4086-afa9-de6e755608dd	0	20	f	\N	\N
1375e980-68b5-4cd8-90e2-c53ff3e7930f	\N	client-secret	betterGR	156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	2	10	f	\N	\N
3b016721-e497-4bac-b692-2032f4371f0e	\N	client-jwt	betterGR	156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	2	20	f	\N	\N
66892521-9bce-4987-ab24-fef435e6cb6f	\N	client-secret-jwt	betterGR	156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	2	30	f	\N	\N
bb35a341-d32b-47eb-9e3d-a7181d299739	\N	client-x509	betterGR	156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	2	40	f	\N	\N
5c85bb73-e035-4753-9dc7-1d8239d3810f	\N	idp-review-profile	betterGR	07b47994-f1e1-42b7-8e80-02ae6093de96	0	10	f	\N	74ad4f3b-5e0f-4917-95e8-d826d4a3b393
b79fe745-3830-4ee4-a2c5-69b3913cb3b1	\N	\N	betterGR	07b47994-f1e1-42b7-8e80-02ae6093de96	0	20	t	5228f726-5d8f-495c-8924-69a7c6df40ef	\N
ed155caf-e931-4dc1-9632-3f3e04d23c08	\N	idp-create-user-if-unique	betterGR	5228f726-5d8f-495c-8924-69a7c6df40ef	2	10	f	\N	abefcb7d-4465-421b-bf96-b7f3a1bbb77b
2bc410b5-30e7-490d-aef5-68fa00040c6d	\N	\N	betterGR	5228f726-5d8f-495c-8924-69a7c6df40ef	2	20	t	4bac6227-b873-4354-bac5-d3399c63aec4	\N
2dde2908-6e0f-43a4-9d38-dd909a147f2d	\N	idp-confirm-link	betterGR	4bac6227-b873-4354-bac5-d3399c63aec4	0	10	f	\N	\N
49b5a884-7a00-437b-96d8-046f602961e4	\N	\N	betterGR	4bac6227-b873-4354-bac5-d3399c63aec4	0	20	t	73556544-e4a4-45df-9723-2fc695d60d1f	\N
5ae21462-2dce-43fd-a0f2-ae3f37d9142c	\N	idp-email-verification	betterGR	73556544-e4a4-45df-9723-2fc695d60d1f	2	10	f	\N	\N
39a9accf-febd-4737-8225-a6d5e60b3ef0	\N	\N	betterGR	73556544-e4a4-45df-9723-2fc695d60d1f	2	20	t	ddeefd07-04b4-4acb-8d47-f588641eeb65	\N
3c8e40ea-9554-4cee-ad6d-218a99dbaf94	\N	idp-username-password-form	betterGR	ddeefd07-04b4-4acb-8d47-f588641eeb65	0	10	f	\N	\N
04927855-84c0-4049-b2ed-3c269b8920f8	\N	\N	betterGR	ddeefd07-04b4-4acb-8d47-f588641eeb65	1	20	t	05619d7a-5674-4c5f-b247-fee72c5370ec	\N
17cc017e-53fd-4878-a1bc-90c40190b04c	\N	conditional-user-configured	betterGR	05619d7a-5674-4c5f-b247-fee72c5370ec	0	10	f	\N	\N
420a5027-780a-4c28-b6e9-38119d960f8d	\N	auth-otp-form	betterGR	05619d7a-5674-4c5f-b247-fee72c5370ec	0	20	f	\N	\N
7bd7bed0-24f1-468f-bf67-353e0b37c676	\N	\N	betterGR	07b47994-f1e1-42b7-8e80-02ae6093de96	1	50	t	fcacf552-623d-4f2d-bfa5-be8a7547226d	\N
a705db29-ed5e-4fa8-af1a-df60f4235d6f	\N	conditional-user-configured	betterGR	fcacf552-623d-4f2d-bfa5-be8a7547226d	0	10	f	\N	\N
79dc5a3c-ab9c-4a7d-8bb1-0ee5c923a544	\N	idp-add-organization-member	betterGR	fcacf552-623d-4f2d-bfa5-be8a7547226d	0	20	f	\N	\N
6b5e9fcc-84e5-4709-ab98-2379c217ffae	\N	http-basic-authenticator	betterGR	eb8122e0-d8fc-45ca-ab45-ec919ea1d3b0	0	10	f	\N	\N
ac47f79c-f3cf-4aa7-a3bb-b7325c0d499c	\N	docker-http-basic-authenticator	betterGR	16cddca9-a727-4b78-a30d-605d71c543da	0	10	f	\N	\N
b98b1081-1180-4e4c-8fdb-d9709cf52e81	\N	identity-provider-redirector	betterGR	c8dbd0bf-efd6-4eab-a155-a8df46e3e66f	2	25	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
843aaf52-a2f3-4d10-b574-caf696b2928a	browser	Browser based authentication	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
d958ee57-8523-4081-a4b3-b0d2973c051f	forms	Username, password, otp and other auth forms.	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
1c079bd8-c0e6-4930-bda6-946fba0a2347	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
c420d152-6d04-4493-a038-565dd5e1ee8c	direct grant	OpenID Connect Resource Owner Grant	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
76584926-5136-45cf-a016-834b49d6b40d	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
e7b26792-c783-473f-87ab-86f1274a1c34	registration	Registration flow	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
64574d8f-8122-4d2f-a181-cd1b089f4b04	registration form	Registration form	071eec07-9d0a-411e-bf21-78c3daf9b724	form-flow	f	t
fc7e3485-e920-4b38-ae87-45408b29d3e3	reset credentials	Reset credentials for a user if they forgot their password or something	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
cc54aca9-5333-49f9-97d5-787dc2a8d9e5	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
786ed56a-0af4-445b-aeaf-daaff6b903d6	clients	Base authentication for clients	071eec07-9d0a-411e-bf21-78c3daf9b724	client-flow	t	t
360a664c-63d9-4c2c-afa9-d86aab6fe6f5	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
bb7c12e8-9c81-4eaf-aa7d-20793bf37bc6	User creation or linking	Flow for the existing/non-existing user alternatives	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
3c01b24f-9413-42e8-932e-bf2869c02ead	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
ff75d290-6d53-44f2-94a0-80bca7eb8fe9	Account verification options	Method with which to verity the existing account	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
823676ae-4bbe-4217-bef0-b6a046c3bf86	Verify Existing Account by Re-authentication	Reauthentication of existing account	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
f40fb760-52fd-4e95-a58a-596b651ce548	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	f	t
e74dd530-01e0-4b90-89ae-98cba3c61faa	saml ecp	SAML ECP Profile Authentication Flow	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
029ab0ed-6bb5-458f-9a9c-709e7b6677cd	docker auth	Used by Docker clients to authenticate against the IDP	071eec07-9d0a-411e-bf21-78c3daf9b724	basic-flow	t	t
c8dbd0bf-efd6-4eab-a155-a8df46e3e66f	browser	Browser-based authentication	betterGR	basic-flow	t	f
80cbc004-0fd5-4477-b3ab-c6b22ee6d8b7	direct grant	OpenID Connect Resource Owner Grant	betterGR	basic-flow	t	t
81b6fe38-7df7-4540-97cf-7c8618dd8da3	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	betterGR	basic-flow	f	t
6dcbeaa0-e548-4f39-8fbd-23861b87c019	registration	Registration flow	betterGR	basic-flow	t	t
344d89b9-cfec-47d7-a434-823ffb03597f	registration form	Registration form	betterGR	form-flow	f	t
b3f2d4cc-284d-44db-9578-ca37df3db3d3	reset credentials	Reset credentials for a user if they forgot their password or something	betterGR	basic-flow	t	t
85d0bb35-6d14-4086-afa9-de6e755608dd	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	betterGR	basic-flow	f	t
156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	clients	Base authentication for clients	betterGR	client-flow	t	t
07b47994-f1e1-42b7-8e80-02ae6093de96	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	betterGR	basic-flow	t	t
5228f726-5d8f-495c-8924-69a7c6df40ef	User creation or linking	Flow for the existing/non-existing user alternatives	betterGR	basic-flow	f	t
4bac6227-b873-4354-bac5-d3399c63aec4	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	betterGR	basic-flow	f	t
73556544-e4a4-45df-9723-2fc695d60d1f	Account verification options	Method with which to verity the existing account	betterGR	basic-flow	f	t
ddeefd07-04b4-4acb-8d47-f588641eeb65	Verify Existing Account by Re-authentication	Reauthentication of existing account	betterGR	basic-flow	f	t
05619d7a-5674-4c5f-b247-fee72c5370ec	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	betterGR	basic-flow	f	t
fcacf552-623d-4f2d-bfa5-be8a7547226d	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	betterGR	basic-flow	f	t
eb8122e0-d8fc-45ca-ab45-ec919ea1d3b0	saml ecp	SAML ECP Profile Authentication Flow	betterGR	basic-flow	t	t
16cddca9-a727-4b78-a30d-605d71c543da	docker auth	Used by Docker clients to authenticate against the IDP	betterGR	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
eb679dd6-be19-490d-b89f-855325902054	review profile config	071eec07-9d0a-411e-bf21-78c3daf9b724
57b1c014-099a-45c7-8ae2-d17f473a1249	create unique user config	071eec07-9d0a-411e-bf21-78c3daf9b724
74ad4f3b-5e0f-4917-95e8-d826d4a3b393	review profile config	betterGR
abefcb7d-4465-421b-bf96-b7f3a1bbb77b	create unique user config	betterGR
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
57b1c014-099a-45c7-8ae2-d17f473a1249	false	require.password.update.after.registration
eb679dd6-be19-490d-b89f-855325902054	missing	update.profile.on.first.login
74ad4f3b-5e0f-4917-95e8-d826d4a3b393	missing	update.profile.on.first.login
abefcb7d-4465-421b-bf96-b7f3a1bbb77b	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
15d31b1d-8591-4939-bc81-366fa652552f	t	f	master-realm	0	f	\N	\N	t	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
ef2937ac-47e1-44d1-a985-68828a4465ed	t	f	broker	0	f	\N	\N	t	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
fb742c3f-a712-4fa1-88eb-a765a1928417	t	t	admin-cli	0	t	\N	\N	f	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	f	betterGR-realm	0	f	\N	\N	t	\N	f	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	0	f	f	betterGR Realm	f	client-secret	\N	\N	\N	t	f	f	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	f	realm-management	0	f	\N	\N	t	\N	f	betterGR	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
72809e17-2428-494c-a642-271f5a4ea9e7	t	f	broker	0	f	\N	\N	t	\N	f	betterGR	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
2a773145-06d2-44fe-805d-c3f01c3d6377	t	t	security-admin-console	0	t	\N	/admin/betterGR/console/	f	\N	f	betterGR	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	t	t	admin-cli	0	t	\N	\N	f	\N	f	betterGR	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	t	t	bettergr-frontend	0	t	\N	http://localhost:3000	f	http://localhost:3000	f	betterGR	openid-connect	-1	t	f	BetterGR Frontend Application	f	public	http://localhost:3000	Frontend application for accessing confidential GraphQL data	\N	t	f	t	f
267f722f-ad05-4e35-adc6-0b64d05c0137	t	t	account	0	t	\N		f		f	betterGR	openid-connect	-1	f	f		f	client-jwt			452574a1-9562-45f6-9c8f-ee2c1769298b	t	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	post.logout.redirect.uris	+
10355e4f-861d-46fb-86a7-a73b8d637d8f	post.logout.redirect.uris	+
10355e4f-861d-46fb-86a7-a73b8d637d8f	pkce.code.challenge.method	S256
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	post.logout.redirect.uris	+
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	pkce.code.challenge.method	S256
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	client.use.lightweight.access.token.enabled	true
fb742c3f-a712-4fa1-88eb-a765a1928417	client.use.lightweight.access.token.enabled	true
2a773145-06d2-44fe-805d-c3f01c3d6377	post.logout.redirect.uris	+
2a773145-06d2-44fe-805d-c3f01c3d6377	pkce.code.challenge.method	S256
2a773145-06d2-44fe-805d-c3f01c3d6377	client.use.lightweight.access.token.enabled	true
988b95b6-4208-4313-ae30-20bcadb0ee3a	client.use.lightweight.access.token.enabled	true
267f722f-ad05-4e35-adc6-0b64d05c0137	post.logout.redirect.uris	+
267f722f-ad05-4e35-adc6-0b64d05c0137	realm_client	false
267f722f-ad05-4e35-adc6-0b64d05c0137	oauth2.device.authorization.grant.enabled	false
267f722f-ad05-4e35-adc6-0b64d05c0137	oidc.ciba.grant.enabled	false
267f722f-ad05-4e35-adc6-0b64d05c0137	display.on.consent.screen	false
267f722f-ad05-4e35-adc6-0b64d05c0137	backchannel.logout.session.required	true
267f722f-ad05-4e35-adc6-0b64d05c0137	backchannel.logout.revoke.offline.tokens	false
267f722f-ad05-4e35-adc6-0b64d05c0137	client.secret.creation.time	1747241863
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	pkce.code.challenge.method	S256
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	access.token.lifespan	900
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.assertion.signature	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	user.info.response.signature.alg	RS256
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.force.post.binding	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.multivalued.roles	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.encrypt	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	oauth2.device.authorization.grant.enabled	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	backchannel.logout.revoke.offline.tokens	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.server.signature	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.server.signature.keyinfo.ext	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	use.refresh.tokens	true
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	exclude.session.state.from.auth.response	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	client_credentials.use_refresh_token	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml_force_name_id_format	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.client.signature	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	tls.client.certificate.bound.access.tokens	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	require.pushed.authorization.requests	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.authnstatement	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	display.on.consent.screen	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	id.token.as.detached.signature	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	saml.onetimeuse.condition	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	client.session.max.lifespan	10800
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	client.session.idle.timeout	1800
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	oidc.ciba.grant.enabled	false
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	backchannel.logout.session.required	true
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	realm_client	false
267f722f-ad05-4e35-adc6-0b64d05c0137	use.refresh.tokens	true
267f722f-ad05-4e35-adc6-0b64d05c0137	client_credentials.use_refresh_token	false
267f722f-ad05-4e35-adc6-0b64d05c0137	token.response.type.bearer.lower-case	false
267f722f-ad05-4e35-adc6-0b64d05c0137	tls.client.certificate.bound.access.tokens	false
267f722f-ad05-4e35-adc6-0b64d05c0137	require.pushed.authorization.requests	false
267f722f-ad05-4e35-adc6-0b64d05c0137	client.use.lightweight.access.token.enabled	false
267f722f-ad05-4e35-adc6-0b64d05c0137	client.introspection.response.allow.jwt.claim.enabled	false
267f722f-ad05-4e35-adc6-0b64d05c0137	acr.loa.map	{}
267f722f-ad05-4e35-adc6-0b64d05c0137	use.jwks.url	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
ca651735-0144-45c5-87dc-250cc37df5f4	offline_access	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect built-in scope: offline_access	openid-connect
f3369179-1936-4363-be4c-612ce66ebd81	role_list	071eec07-9d0a-411e-bf21-78c3daf9b724	SAML role list	saml
1948f5af-be4c-4aac-a7dc-cdd6cbeabff2	saml_organization	071eec07-9d0a-411e-bf21-78c3daf9b724	Organization Membership	saml
5a1ecb3f-c78e-4462-810b-1615182370bb	profile	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect built-in scope: profile	openid-connect
95e8b45b-479a-49cd-8e98-44f14fd4d8df	email	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect built-in scope: email	openid-connect
89e7dc7e-f0be-4abd-bda4-ea47d09d107a	address	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect built-in scope: address	openid-connect
d5430628-bedf-421d-a101-5d7eac80d0d5	phone	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect built-in scope: phone	openid-connect
1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	roles	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect scope for add user roles to the access token	openid-connect
aeb0d480-523d-4301-ba89-dd5e361d9f38	web-origins	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect scope for add allowed web origins to the access token	openid-connect
91570a16-8ad0-4d13-b625-95e64429d882	microprofile-jwt	071eec07-9d0a-411e-bf21-78c3daf9b724	Microprofile - JWT built-in scope	openid-connect
d405913f-0ac6-4f13-85ee-74978f89435b	acr	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
ccc21268-fbc0-49ae-af14-f270b2ac5cb0	basic	071eec07-9d0a-411e-bf21-78c3daf9b724	OpenID Connect scope for add all basic claims to the token	openid-connect
c9b851da-cf87-48cf-81f5-eee802177928	organization	071eec07-9d0a-411e-bf21-78c3daf9b724	Additional claims about the organization a subject belongs to	openid-connect
437cbe87-05c0-4b7e-8dc4-423bd1409419	offline_access	betterGR	OpenID Connect built-in scope: offline_access	openid-connect
fe568452-f2fa-4273-bffd-5e6acbb17f75	role_list	betterGR	SAML role list	saml
8fa46a9a-dae9-4a88-a40f-25cb70fb6efe	saml_organization	betterGR	Organization Membership	saml
1808ecb0-fe6b-4e49-91fa-abdd123ba07f	profile	betterGR	OpenID Connect built-in scope: profile	openid-connect
cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	email	betterGR	OpenID Connect built-in scope: email	openid-connect
4bdc090f-3e64-4332-9b1e-41a5068105be	address	betterGR	OpenID Connect built-in scope: address	openid-connect
e729b22c-95a0-41c7-8956-1f2166c34bbe	phone	betterGR	OpenID Connect built-in scope: phone	openid-connect
9a70b3e3-a9ac-41fd-8812-69a3618e8c25	roles	betterGR	OpenID Connect scope for add user roles to the access token	openid-connect
fe493385-0bd9-44a2-a096-3fe041896716	web-origins	betterGR	OpenID Connect scope for add allowed web origins to the access token	openid-connect
feadc70a-c168-4cb9-ae64-0307c033bbc6	microprofile-jwt	betterGR	Microprofile - JWT built-in scope	openid-connect
172f6dcc-8262-4b8b-bca9-0039345a39ba	acr	betterGR	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
bdfb450d-6879-4f29-a77d-2c5370c62747	basic	betterGR	OpenID Connect scope for add all basic claims to the token	openid-connect
8ffa9364-7313-4157-84cf-696b317582e3	organization	betterGR	Additional claims about the organization a subject belongs to	openid-connect
e9699b76-bd3a-4d42-8e86-4c438bb22203	account-audience	betterGR		openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
ca651735-0144-45c5-87dc-250cc37df5f4	true	display.on.consent.screen
ca651735-0144-45c5-87dc-250cc37df5f4	${offlineAccessScopeConsentText}	consent.screen.text
f3369179-1936-4363-be4c-612ce66ebd81	true	display.on.consent.screen
f3369179-1936-4363-be4c-612ce66ebd81	${samlRoleListScopeConsentText}	consent.screen.text
1948f5af-be4c-4aac-a7dc-cdd6cbeabff2	false	display.on.consent.screen
5a1ecb3f-c78e-4462-810b-1615182370bb	true	display.on.consent.screen
5a1ecb3f-c78e-4462-810b-1615182370bb	${profileScopeConsentText}	consent.screen.text
5a1ecb3f-c78e-4462-810b-1615182370bb	true	include.in.token.scope
95e8b45b-479a-49cd-8e98-44f14fd4d8df	true	display.on.consent.screen
95e8b45b-479a-49cd-8e98-44f14fd4d8df	${emailScopeConsentText}	consent.screen.text
95e8b45b-479a-49cd-8e98-44f14fd4d8df	true	include.in.token.scope
89e7dc7e-f0be-4abd-bda4-ea47d09d107a	true	display.on.consent.screen
89e7dc7e-f0be-4abd-bda4-ea47d09d107a	${addressScopeConsentText}	consent.screen.text
89e7dc7e-f0be-4abd-bda4-ea47d09d107a	true	include.in.token.scope
d5430628-bedf-421d-a101-5d7eac80d0d5	true	display.on.consent.screen
d5430628-bedf-421d-a101-5d7eac80d0d5	${phoneScopeConsentText}	consent.screen.text
d5430628-bedf-421d-a101-5d7eac80d0d5	true	include.in.token.scope
1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	true	display.on.consent.screen
1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	${rolesScopeConsentText}	consent.screen.text
1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	false	include.in.token.scope
aeb0d480-523d-4301-ba89-dd5e361d9f38	false	display.on.consent.screen
aeb0d480-523d-4301-ba89-dd5e361d9f38		consent.screen.text
aeb0d480-523d-4301-ba89-dd5e361d9f38	false	include.in.token.scope
91570a16-8ad0-4d13-b625-95e64429d882	false	display.on.consent.screen
91570a16-8ad0-4d13-b625-95e64429d882	true	include.in.token.scope
d405913f-0ac6-4f13-85ee-74978f89435b	false	display.on.consent.screen
d405913f-0ac6-4f13-85ee-74978f89435b	false	include.in.token.scope
ccc21268-fbc0-49ae-af14-f270b2ac5cb0	false	display.on.consent.screen
ccc21268-fbc0-49ae-af14-f270b2ac5cb0	false	include.in.token.scope
c9b851da-cf87-48cf-81f5-eee802177928	true	display.on.consent.screen
c9b851da-cf87-48cf-81f5-eee802177928	${organizationScopeConsentText}	consent.screen.text
c9b851da-cf87-48cf-81f5-eee802177928	true	include.in.token.scope
437cbe87-05c0-4b7e-8dc4-423bd1409419	true	display.on.consent.screen
437cbe87-05c0-4b7e-8dc4-423bd1409419	${offlineAccessScopeConsentText}	consent.screen.text
fe568452-f2fa-4273-bffd-5e6acbb17f75	true	display.on.consent.screen
fe568452-f2fa-4273-bffd-5e6acbb17f75	${samlRoleListScopeConsentText}	consent.screen.text
8fa46a9a-dae9-4a88-a40f-25cb70fb6efe	false	display.on.consent.screen
1808ecb0-fe6b-4e49-91fa-abdd123ba07f	true	display.on.consent.screen
1808ecb0-fe6b-4e49-91fa-abdd123ba07f	${profileScopeConsentText}	consent.screen.text
1808ecb0-fe6b-4e49-91fa-abdd123ba07f	true	include.in.token.scope
cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	true	display.on.consent.screen
cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	${emailScopeConsentText}	consent.screen.text
cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	true	include.in.token.scope
4bdc090f-3e64-4332-9b1e-41a5068105be	true	display.on.consent.screen
4bdc090f-3e64-4332-9b1e-41a5068105be	${addressScopeConsentText}	consent.screen.text
4bdc090f-3e64-4332-9b1e-41a5068105be	true	include.in.token.scope
e729b22c-95a0-41c7-8956-1f2166c34bbe	true	display.on.consent.screen
e729b22c-95a0-41c7-8956-1f2166c34bbe	${phoneScopeConsentText}	consent.screen.text
e729b22c-95a0-41c7-8956-1f2166c34bbe	true	include.in.token.scope
9a70b3e3-a9ac-41fd-8812-69a3618e8c25	true	display.on.consent.screen
9a70b3e3-a9ac-41fd-8812-69a3618e8c25	${rolesScopeConsentText}	consent.screen.text
9a70b3e3-a9ac-41fd-8812-69a3618e8c25	false	include.in.token.scope
fe493385-0bd9-44a2-a096-3fe041896716	false	display.on.consent.screen
fe493385-0bd9-44a2-a096-3fe041896716		consent.screen.text
fe493385-0bd9-44a2-a096-3fe041896716	false	include.in.token.scope
feadc70a-c168-4cb9-ae64-0307c033bbc6	false	display.on.consent.screen
feadc70a-c168-4cb9-ae64-0307c033bbc6	true	include.in.token.scope
172f6dcc-8262-4b8b-bca9-0039345a39ba	false	display.on.consent.screen
172f6dcc-8262-4b8b-bca9-0039345a39ba	false	include.in.token.scope
bdfb450d-6879-4f29-a77d-2c5370c62747	false	display.on.consent.screen
bdfb450d-6879-4f29-a77d-2c5370c62747	false	include.in.token.scope
8ffa9364-7313-4157-84cf-696b317582e3	true	display.on.consent.screen
8ffa9364-7313-4157-84cf-696b317582e3	${organizationScopeConsentText}	consent.screen.text
8ffa9364-7313-4157-84cf-696b317582e3	true	include.in.token.scope
e9699b76-bd3a-4d42-8e86-4c438bb22203	true	display.on.consent.screen
e9699b76-bd3a-4d42-8e86-4c438bb22203		consent.screen.text
e9699b76-bd3a-4d42-8e86-4c438bb22203	true	include.in.token.scope
e9699b76-bd3a-4d42-8e86-4c438bb22203		gui.order
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	d405913f-0ac6-4f13-85ee-74978f89435b	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	5a1ecb3f-c78e-4462-810b-1615182370bb	t
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	ca651735-0144-45c5-87dc-250cc37df5f4	f
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	91570a16-8ad0-4d13-b625-95e64429d882	f
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	c9b851da-cf87-48cf-81f5-eee802177928	f
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	d5430628-bedf-421d-a101-5d7eac80d0d5	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	d405913f-0ac6-4f13-85ee-74978f89435b	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	5a1ecb3f-c78e-4462-810b-1615182370bb	t
10355e4f-861d-46fb-86a7-a73b8d637d8f	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	ca651735-0144-45c5-87dc-250cc37df5f4	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	91570a16-8ad0-4d13-b625-95e64429d882	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	c9b851da-cf87-48cf-81f5-eee802177928	f
10355e4f-861d-46fb-86a7-a73b8d637d8f	d5430628-bedf-421d-a101-5d7eac80d0d5	f
fb742c3f-a712-4fa1-88eb-a765a1928417	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
fb742c3f-a712-4fa1-88eb-a765a1928417	d405913f-0ac6-4f13-85ee-74978f89435b	t
fb742c3f-a712-4fa1-88eb-a765a1928417	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
fb742c3f-a712-4fa1-88eb-a765a1928417	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
fb742c3f-a712-4fa1-88eb-a765a1928417	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
fb742c3f-a712-4fa1-88eb-a765a1928417	5a1ecb3f-c78e-4462-810b-1615182370bb	t
fb742c3f-a712-4fa1-88eb-a765a1928417	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
fb742c3f-a712-4fa1-88eb-a765a1928417	ca651735-0144-45c5-87dc-250cc37df5f4	f
fb742c3f-a712-4fa1-88eb-a765a1928417	91570a16-8ad0-4d13-b625-95e64429d882	f
fb742c3f-a712-4fa1-88eb-a765a1928417	c9b851da-cf87-48cf-81f5-eee802177928	f
fb742c3f-a712-4fa1-88eb-a765a1928417	d5430628-bedf-421d-a101-5d7eac80d0d5	f
ef2937ac-47e1-44d1-a985-68828a4465ed	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
ef2937ac-47e1-44d1-a985-68828a4465ed	d405913f-0ac6-4f13-85ee-74978f89435b	t
ef2937ac-47e1-44d1-a985-68828a4465ed	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
ef2937ac-47e1-44d1-a985-68828a4465ed	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
ef2937ac-47e1-44d1-a985-68828a4465ed	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
ef2937ac-47e1-44d1-a985-68828a4465ed	5a1ecb3f-c78e-4462-810b-1615182370bb	t
ef2937ac-47e1-44d1-a985-68828a4465ed	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
ef2937ac-47e1-44d1-a985-68828a4465ed	ca651735-0144-45c5-87dc-250cc37df5f4	f
ef2937ac-47e1-44d1-a985-68828a4465ed	91570a16-8ad0-4d13-b625-95e64429d882	f
ef2937ac-47e1-44d1-a985-68828a4465ed	c9b851da-cf87-48cf-81f5-eee802177928	f
ef2937ac-47e1-44d1-a985-68828a4465ed	d5430628-bedf-421d-a101-5d7eac80d0d5	f
15d31b1d-8591-4939-bc81-366fa652552f	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
15d31b1d-8591-4939-bc81-366fa652552f	d405913f-0ac6-4f13-85ee-74978f89435b	t
15d31b1d-8591-4939-bc81-366fa652552f	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
15d31b1d-8591-4939-bc81-366fa652552f	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
15d31b1d-8591-4939-bc81-366fa652552f	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
15d31b1d-8591-4939-bc81-366fa652552f	5a1ecb3f-c78e-4462-810b-1615182370bb	t
15d31b1d-8591-4939-bc81-366fa652552f	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
15d31b1d-8591-4939-bc81-366fa652552f	ca651735-0144-45c5-87dc-250cc37df5f4	f
15d31b1d-8591-4939-bc81-366fa652552f	91570a16-8ad0-4d13-b625-95e64429d882	f
15d31b1d-8591-4939-bc81-366fa652552f	c9b851da-cf87-48cf-81f5-eee802177928	f
15d31b1d-8591-4939-bc81-366fa652552f	d5430628-bedf-421d-a101-5d7eac80d0d5	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	d405913f-0ac6-4f13-85ee-74978f89435b	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	5a1ecb3f-c78e-4462-810b-1615182370bb	t
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	ca651735-0144-45c5-87dc-250cc37df5f4	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	91570a16-8ad0-4d13-b625-95e64429d882	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	c9b851da-cf87-48cf-81f5-eee802177928	f
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	d5430628-bedf-421d-a101-5d7eac80d0d5	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	bdfb450d-6879-4f29-a77d-2c5370c62747	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	fe493385-0bd9-44a2-a096-3fe041896716	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
988b95b6-4208-4313-ae30-20bcadb0ee3a	8ffa9364-7313-4157-84cf-696b317582e3	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	4bdc090f-3e64-4332-9b1e-41a5068105be	f
988b95b6-4208-4313-ae30-20bcadb0ee3a	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
72809e17-2428-494c-a642-271f5a4ea9e7	bdfb450d-6879-4f29-a77d-2c5370c62747	t
72809e17-2428-494c-a642-271f5a4ea9e7	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
72809e17-2428-494c-a642-271f5a4ea9e7	fe493385-0bd9-44a2-a096-3fe041896716	t
72809e17-2428-494c-a642-271f5a4ea9e7	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
72809e17-2428-494c-a642-271f5a4ea9e7	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
72809e17-2428-494c-a642-271f5a4ea9e7	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
72809e17-2428-494c-a642-271f5a4ea9e7	8ffa9364-7313-4157-84cf-696b317582e3	f
72809e17-2428-494c-a642-271f5a4ea9e7	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
72809e17-2428-494c-a642-271f5a4ea9e7	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
72809e17-2428-494c-a642-271f5a4ea9e7	4bdc090f-3e64-4332-9b1e-41a5068105be	f
72809e17-2428-494c-a642-271f5a4ea9e7	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	bdfb450d-6879-4f29-a77d-2c5370c62747	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	fe493385-0bd9-44a2-a096-3fe041896716	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	8ffa9364-7313-4157-84cf-696b317582e3	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	4bdc090f-3e64-4332-9b1e-41a5068105be	f
8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
2a773145-06d2-44fe-805d-c3f01c3d6377	bdfb450d-6879-4f29-a77d-2c5370c62747	t
2a773145-06d2-44fe-805d-c3f01c3d6377	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
2a773145-06d2-44fe-805d-c3f01c3d6377	fe493385-0bd9-44a2-a096-3fe041896716	t
2a773145-06d2-44fe-805d-c3f01c3d6377	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
2a773145-06d2-44fe-805d-c3f01c3d6377	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
2a773145-06d2-44fe-805d-c3f01c3d6377	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
2a773145-06d2-44fe-805d-c3f01c3d6377	8ffa9364-7313-4157-84cf-696b317582e3	f
2a773145-06d2-44fe-805d-c3f01c3d6377	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
2a773145-06d2-44fe-805d-c3f01c3d6377	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
2a773145-06d2-44fe-805d-c3f01c3d6377	4bdc090f-3e64-4332-9b1e-41a5068105be	f
2a773145-06d2-44fe-805d-c3f01c3d6377	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
267f722f-ad05-4e35-adc6-0b64d05c0137	bdfb450d-6879-4f29-a77d-2c5370c62747	t
267f722f-ad05-4e35-adc6-0b64d05c0137	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
267f722f-ad05-4e35-adc6-0b64d05c0137	fe493385-0bd9-44a2-a096-3fe041896716	t
267f722f-ad05-4e35-adc6-0b64d05c0137	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
267f722f-ad05-4e35-adc6-0b64d05c0137	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
267f722f-ad05-4e35-adc6-0b64d05c0137	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
267f722f-ad05-4e35-adc6-0b64d05c0137	8ffa9364-7313-4157-84cf-696b317582e3	f
267f722f-ad05-4e35-adc6-0b64d05c0137	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
267f722f-ad05-4e35-adc6-0b64d05c0137	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
267f722f-ad05-4e35-adc6-0b64d05c0137	4bdc090f-3e64-4332-9b1e-41a5068105be	f
267f722f-ad05-4e35-adc6-0b64d05c0137	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	fe493385-0bd9-44a2-a096-3fe041896716	t
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	4bdc090f-3e64-4332-9b1e-41a5068105be	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	e9699b76-bd3a-4d42-8e86-4c438bb22203	t
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
ca651735-0144-45c5-87dc-250cc37df5f4	9afa8303-3b34-45b0-83fe-6e0db5defacb
437cbe87-05c0-4b7e-8dc4-423bd1409419	9a798090-ed17-47cd-821a-940b36253d7c
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
3a18cc88-fa96-41e3-8b54-335b784f4957	Trusted Hosts	071eec07-9d0a-411e-bf21-78c3daf9b724	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
5bc059fa-0c1d-4e98-9049-4c4874ed913e	Consent Required	071eec07-9d0a-411e-bf21-78c3daf9b724	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
ca8ac61c-0bcd-4687-bac7-0625faa9214c	Full Scope Disabled	071eec07-9d0a-411e-bf21-78c3daf9b724	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
ca05bed9-8350-4794-b1fa-dd2322d18b93	Max Clients Limit	071eec07-9d0a-411e-bf21-78c3daf9b724	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
4f55cdcb-bda3-4952-b660-f4bc42f5272a	Allowed Protocol Mapper Types	071eec07-9d0a-411e-bf21-78c3daf9b724	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
de147ba1-4091-4fd0-8563-ae57452d27a7	Allowed Client Scopes	071eec07-9d0a-411e-bf21-78c3daf9b724	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	anonymous
2d99478b-d955-46b7-86b1-3fc77ccf9645	Allowed Protocol Mapper Types	071eec07-9d0a-411e-bf21-78c3daf9b724	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	authenticated
91b390d5-ec35-4978-bb80-f6996b5d42f4	Allowed Client Scopes	071eec07-9d0a-411e-bf21-78c3daf9b724	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	authenticated
704c4d15-d5e0-48d6-82de-2e79606b0feb	rsa-generated	071eec07-9d0a-411e-bf21-78c3daf9b724	rsa-generated	org.keycloak.keys.KeyProvider	071eec07-9d0a-411e-bf21-78c3daf9b724	\N
3e098825-646c-416e-a306-578ee9c2a546	rsa-enc-generated	071eec07-9d0a-411e-bf21-78c3daf9b724	rsa-enc-generated	org.keycloak.keys.KeyProvider	071eec07-9d0a-411e-bf21-78c3daf9b724	\N
b5574b05-211f-4e58-8eef-63b989ba6cdf	hmac-generated-hs512	071eec07-9d0a-411e-bf21-78c3daf9b724	hmac-generated	org.keycloak.keys.KeyProvider	071eec07-9d0a-411e-bf21-78c3daf9b724	\N
4a990485-eb49-4cce-940b-e98ef370585d	aes-generated	071eec07-9d0a-411e-bf21-78c3daf9b724	aes-generated	org.keycloak.keys.KeyProvider	071eec07-9d0a-411e-bf21-78c3daf9b724	\N
8f39324f-52be-4415-a589-e8ed72169705	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	071eec07-9d0a-411e-bf21-78c3daf9b724	\N
7c6865d4-5a30-47a7-9fa1-c0fddafb4c8b	rsa-generated	betterGR	rsa-generated	org.keycloak.keys.KeyProvider	betterGR	\N
21698e16-e62f-4fc1-8d7b-2bf857d5247d	rsa-enc-generated	betterGR	rsa-enc-generated	org.keycloak.keys.KeyProvider	betterGR	\N
c9ab8200-bf79-443c-96c9-b50f87be1aa0	hmac-generated-hs512	betterGR	hmac-generated	org.keycloak.keys.KeyProvider	betterGR	\N
133d2b29-14dc-4d34-9f74-fe07aa63c230	aes-generated	betterGR	aes-generated	org.keycloak.keys.KeyProvider	betterGR	\N
d6bcd9c4-bc8a-4dac-ae0a-d6021933df74	Trusted Hosts	betterGR	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
7580dfcc-b2e8-4ee7-ad79-b404b80fe0f2	Consent Required	betterGR	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
e5aea013-80cc-4d05-96cc-cf4e49462370	Full Scope Disabled	betterGR	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
f235658a-522d-4451-abea-c12b0d085ab9	Max Clients Limit	betterGR	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
8c508b65-ac44-493c-aac2-1bc7f95e4ad5	Allowed Protocol Mapper Types	betterGR	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
8032b983-80c9-4169-b6d6-50e7deb53062	Allowed Client Scopes	betterGR	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	anonymous
0504fdce-3ee3-4c8f-acd0-1d875f011235	Allowed Protocol Mapper Types	betterGR	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	authenticated
ca710653-8465-401d-a10d-e87f1bdf9ff8	Allowed Client Scopes	betterGR	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	betterGR	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
52b53cbe-8178-4a41-8605-6dfa1b6f578d	de147ba1-4091-4fd0-8563-ae57452d27a7	allow-default-scopes	true
7c957d63-5970-4c59-9f14-00d3387f2d97	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	saml-user-attribute-mapper
063864c7-ca89-4fa5-b8d9-cd6286b73e97	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
92ca972e-0a43-462f-aff9-74f9a2d1af8b	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	oidc-address-mapper
9622d8fe-13af-4ceb-bfaa-5d73111b3356	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	oidc-full-name-mapper
c28b62aa-74ec-46bd-9b37-e5c296ca8c76	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
bc6a5ede-f7eb-45ee-977c-ace61a108d16	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	saml-user-property-mapper
3cb47678-1e4e-4fc4-9516-c69bf6fc73dd	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	saml-role-list-mapper
2bd197c9-1390-450c-8296-3d84000f8c90	2d99478b-d955-46b7-86b1-3fc77ccf9645	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
19255238-d22c-4def-a9a6-41d7eeda9a6d	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	saml-user-attribute-mapper
bbe07cb9-7c8b-4c18-83da-3c887abeace3	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
33125f27-4b8d-4fe2-845a-37d40f1bdcd2	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
7b327f96-a299-47d1-a766-e4be00fb15ee	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	oidc-address-mapper
ed3e6af2-fd3d-4bd5-9d85-a20a331eaf2f	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
41ba4222-e5a8-4bc6-aa45-d6a13cbdc900	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	saml-role-list-mapper
a16d7cc8-ef09-4f1f-8761-2e97e4002424	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	saml-user-property-mapper
ee2f6366-539a-410a-a528-44a6fdbd3460	4f55cdcb-bda3-4952-b660-f4bc42f5272a	allowed-protocol-mapper-types	oidc-full-name-mapper
04b6c20a-aba0-45d2-9998-4368ddc027c8	91b390d5-ec35-4978-bb80-f6996b5d42f4	allow-default-scopes	true
ac6000e5-3b36-4d3b-b899-538bf20ca5f8	ca05bed9-8350-4794-b1fa-dd2322d18b93	max-clients	200
a2998cee-9b6f-492d-8acf-e3ed4f1b33d6	3a18cc88-fa96-41e3-8b54-335b784f4957	host-sending-registration-request-must-match	true
6ebea499-a548-457c-bb87-8d88867fe8ac	3a18cc88-fa96-41e3-8b54-335b784f4957	client-uris-must-match	true
bce59739-1256-4d70-9354-2866d1d92a6b	8f39324f-52be-4415-a589-e8ed72169705	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
a823df8e-eae3-449e-a66f-274e5ec9ce0e	4a990485-eb49-4cce-940b-e98ef370585d	priority	100
860cbb99-e262-4c08-b73c-5446bd255ce3	4a990485-eb49-4cce-940b-e98ef370585d	kid	afeedbb7-00f6-4b94-9ca1-cdf0ce6ca862
34b771e0-7312-4146-bac0-7cd3d777c690	4a990485-eb49-4cce-940b-e98ef370585d	secret	z4IVGpcTLLKxLLuMOOaG7Q
b77dc4d5-1d50-42fe-9770-bc7b88cb6491	3e098825-646c-416e-a306-578ee9c2a546	algorithm	RSA-OAEP
4061cdec-543c-4f35-9edd-60da564196bd	3e098825-646c-416e-a306-578ee9c2a546	keyUse	ENC
e64e922a-5615-4cfa-b70a-d6e5e9cfcb33	3e098825-646c-416e-a306-578ee9c2a546	certificate	MIICmzCCAYMCBgGWl4/TvzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNTAzMTkxMDA3WhcNMzUwNTAzMTkxMTQ3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCKyxHdt5XNMcPueRPh5+Y6URNRqE5uKAUP6qRbKK5grw5FoztjOszXZera39iUipQJWkeKd9U5TfgTFok/DGWsTCkfi+LZmq+Kwj6b9crCNXZu6Hr3mJ/mphXn91riP2MJlO60oIfxTTXcH/ok7x1blkL1a5KR6NEwp8B072bqDUav+djsOt8j9jgbybQ08W+W8XgruZpaJ97OHei1pDuGMTi73+Fj/MlLxPJ/Kttx1K3SK3CxAnQHqrIiAOm7XO3YFnQZ3SY3T1LZTgcLI65dVXzuduRRMCmupFO9gD6LM0FL6INiHOpcLgLm1VwlZXZM7WMwHmFCV5qr/73tMV2LAgMBAAEwDQYJKoZIhvcNAQELBQADggEBABc0Q1suKw35eSVkDgzFKH1uMyD64SqSBpoY8S585zB3RahZTLuDEbRM8585sdwDhznd6XupvpcE+zwjPpK9FX9IFg0xBSoDqDP+NZAPyt5UCbmhvCGy05/gbfT8slEGs8prkQnqq+9H1nIjUApAsxyZC1lTbIQmJMk9wUI1H7+AD2navit5m9bxR/ZgbXdrefpN+CnXbsYMbuqu9xyM7FTgDHQ7tMbaGnccwF6J/iX6nsNuI7z2mgLI/PelANCZUxesKVOBuGzynjrJPYAafOr4S7dVaJ2w6JEXwnr7VAiIeS3vE5QUjUqk4x5kkA6K+FRqbgResP/Xw2JXEMvsfBs=
18b2df2d-5ed7-4387-9507-7731f4bcbd4e	3e098825-646c-416e-a306-578ee9c2a546	privateKey	MIIEowIBAAKCAQEAissR3beVzTHD7nkT4efmOlETUahObigFD+qkWyiuYK8ORaM7YzrM12Xq2t/YlIqUCVpHinfVOU34ExaJPwxlrEwpH4vi2ZqvisI+m/XKwjV2buh695if5qYV5/da4j9jCZTutKCH8U013B/6JO8dW5ZC9WuSkejRMKfAdO9m6g1Gr/nY7DrfI/Y4G8m0NPFvlvF4K7maWifezh3otaQ7hjE4u9/hY/zJS8TyfyrbcdSt0itwsQJ0B6qyIgDpu1zt2BZ0Gd0mN09S2U4HCyOuXVV87nbkUTAprqRTvYA+izNBS+iDYhzqXC4C5tVcJWV2TO1jMB5hQleaq/+97TFdiwIDAQABAoIBABcIF7uOiXdMONKhQ6FglXM78lQXSoc7xjXxSWYvMVtYm/+w/1vkwrVDyQiaeMWS3CSpLJICd17+XJpI9RbXUc/uW4H2o/sEO6PFFBVWtld//lqX4uqkvcl36iQHh2IKrr6aTk+ptqVeRf/J9qfxCL14CT3R+g09xej9uBGE4LPEqFA2zmV9yqbamfZjgmdc/PgUBC6vE32St35VB2BZ1ejHTDtsIVP/A0uCs9hVvzQX25rOjrfEqonbjPDvfGrgPn1G+Ycy2BfRoiBFq/s+CH+Y7GGWJiDfc/kiu1VTpZcfPAzdnLSk3WhHY291MLV+Ag6OL3EHuOQjf3KNsHhVSoECgYEAwR2fOL0deI4wFoCUMy/kqbCda6TRZ7kViLg48u8izi8AwsX7jhd5cV2/jI5Vl3f5c29Ok/eN/DWbQDUp+XT2N8yKVheSjOWJZInAt1fKkh/lLK6UW7mexnGASCo5VcfGFZ0vxNZkRcI3oDPYewsEW1Ym0T3D76yf2rZXSjVAJ2ECgYEAt/0OR9NObBwHjUi5KlOjmzyZ2GTe40EepVeGouJE9LGplkVqX4FL2p/etuRp761L7TlFv++QMLwOgBWhoQRNacnSayrZW/G0/9uV362WogwZC5Cg7YVnv/h7pfIuT/lQAEn7AqG3nykQXTvY9D+GApxg1RmO9E+TmleeTlJR6GsCgYEAtfBigeIqUdokFA8vkMoedICgzzmI0F/fmd92R+pksDw4S0ibp1MWZ2gbfyDaIso1ijvjnCQu8N7QVb3AvfUjw45BBrtOps/akY32ssVTZDgIggA4ZfKLVAq7AUJGojqEtPhSePBDqDVCkvxFiCbpA+Q2zguS/ct1D2ma858XwgECgYA2cxJ92SAVSHpHqqT5zMTXVSjmbHu133i1T+DNZY8op0db7HEdkIMlUTi1AYYEY1HcA54Lvlb6xTy5VS1/HGnYi9zU0FqBJlf9fDuvdYzlqhTjYkrt4BQjMONO6gwgqNSvMTWywq830AxCu0pqhj4fma3iguzWipJRE+sKnLwWvwKBgHfn+wakiaGhZ5qGvKg85nQn4TkM+qoOkkksjZ5vgPYGI+naPzv9lh/h6AImxkM7Ce6RYhf/holiAXHjgdcxiJy6KcEjdohm3KA1euruN8i0vWpzgA926G8MYZag3BCGx4qmVY3EpG5Vcpt2VN4P/pHXnWJPnMjamXWKs299NpNZ
517e0e20-c5bf-4a63-96ed-60dfd13ff879	3e098825-646c-416e-a306-578ee9c2a546	priority	100
84f04d7b-1d77-4b3a-93b4-e36a9b347aee	b5574b05-211f-4e58-8eef-63b989ba6cdf	algorithm	HS512
a7e414d9-cc1b-40f5-adc3-50f0ca83eade	b5574b05-211f-4e58-8eef-63b989ba6cdf	priority	100
41a771eb-a1ac-48ad-a989-fc6121754cf8	b5574b05-211f-4e58-8eef-63b989ba6cdf	kid	0d9f9af0-9e98-4fb1-910a-f92fdd43c397
2cca5d97-9f4f-4c38-9ba0-9359062315f2	b5574b05-211f-4e58-8eef-63b989ba6cdf	secret	nLh-lXRmzhM7PQ4yl57orEtY_YchOI4nQFlcEK4Jl2gfYS4ZtkKMsg7Nw4AbyNGiej4sI9KB97oQhTEoPOH4ACiz64flZLb3XrsKru9rXC_Svuhlya2r2DWEU2f_0CT8OgxVZxdt3JSLN5xIM6x88Tx8jeCFIchreLExHGN-lqc
e0ae8158-b1f1-4d44-8d4f-98ef800241fd	704c4d15-d5e0-48d6-82de-2e79606b0feb	keyUse	SIG
f12488b5-95ae-4912-acff-fac9a85534c4	704c4d15-d5e0-48d6-82de-2e79606b0feb	priority	100
a6060497-14a2-4da8-b9b6-eb569f7be0b3	704c4d15-d5e0-48d6-82de-2e79606b0feb	privateKey	MIIEogIBAAKCAQEAsJMFUQaCOno60ufv+YiVvi0g0HLY8o/tSVLjbFJ6+fB/gw9zEQaH863kgS1JkiRj0V0vZnYvw8T43pEs5VRuVJFjPLGTDvyj3XJ5ds4zi+rCWmQ5g9AXECUt8/a2WEiXBPuLTEK3Thkf4BPQFkH752zCKGcs4fFPxTAGdly1jk4Vt9TZzOpzjtpZPgz7gM/c6KOMYwi55iS2BOsNQPKD+Ccv0xZcnmvVgPPzjOg2I6PHOc30FkqnoGZC81bMytk+ZctNLHlpk7YM/4t67lFNOjQe+0kE8LL8eWQ+VvicOSPeSeyW6gb/9ItpAbBWlZ0sJtApVzrLIViVsxH777MDLQIDAQABAoIBAAbt4L2zF4WLn2cAaBfu8WVoUvXV0/Ks4unHjBoySxYnhxwnDTkZUa4mivrmF+bZcRCvFfmbi2NPha6s8XSXHB9LIfhTRaCcbyJ1Er7ZTQeMG7q9XSPG6j4ddLtdWVQx67nr1HsWe9K0713KmUC5BSrUnJ1GSJTIn1HvK7RrDfWQGnUwg9bnMcptRX3IuZXpG0YfU3uifjQK83OkgHp2H+DFxmmh6nHdV6DIjEA74Rxt5J7bcRPrs3OrbCY4hgdHZZkJJ+kKB/vu1x7sWi272xZGVZ7HG/qo/Q1qAHlUnVgH+9tRSPq1C/XhCM4HicO6TF+svRNN6T7zmcJPxcy82GECgYEA6vdctzseWpbC0WEc6BfmxiITaW6omUJ8l+yU5LmX5LyT44K21yFMEPwJWxs0YSBL36uqs3Rluodb26P9KKl0vztUCAZ98T1Z+V0vO0ZuINRpOZe3zGTkLdXdIZssvvv2Bz2H3ZYqXEe/aNwBTglBfYixa6NOr4N2BXdQ/7Fi3t0CgYEAwGGCzKy8atQeX7nx0GwtGypw/JX7HFKELygmw+oFXZAvhiwkHyJD7z4ThQF90F7NtHuiONlLKpOadK8OoS41HIdPtVf1B+TeVfwIKRW56lcEyfia+8ANi8H3ChYnNTe89NSjEp2aDAzJeikAMgvpiG4hdBa7yvhMkas8QR+9aJECgYBtV8ObuTU87t+mVE0BbO4F0iG6dLac66XThVMcxYl79o3T2CaCIoqldMRd02EiucbVRavgaxBUJ12F7uCGpaUgwNkwCuVc+DIAq26pZPMm7/IvzPzJb0IIWnfXhcDi95nccLPjWFhKLVFT2N36lLAXXR9DefHKF6E6lfXpp4DdOQKBgBZmhENuzZWm006UKSr6nZnvLC7NC+s1VHzlMPZY9nz5f/8gfqg9ZimiUcWH8e1kTJF6X948tvrjKvXxOEPeTILg4pAcCMT9ikH60bxu8jHuJfmaf/lWWH1wfWJoR/JzZgYgCEjvnvNOPduCkKpDJtMi97Q7vWwZ01iW1rJCjtxxAoGASzu2cr3dY9SSniVcyMOwvuUY5lvU7k9RrLHnKinGibRzAHr8HsGObJ9ewiaULoGHsIMM3nQuMBRZC3dgPM63xKrcZsMxheP05LXHQUuRINnCV8qgjmOXcDJzVQwF7cQKFhiUmsvFnUI847sGut24GXs42t5EamBUlspendl1of4=
97749d09-7c9e-4872-b9b6-0f1654077aa5	704c4d15-d5e0-48d6-82de-2e79606b0feb	certificate	MIICmzCCAYMCBgGWl4/TFzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNTAzMTkxMDA3WhcNMzUwNTAzMTkxMTQ3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwkwVRBoI6ejrS5+/5iJW+LSDQctjyj+1JUuNsUnr58H+DD3MRBofzreSBLUmSJGPRXS9mdi/DxPjekSzlVG5UkWM8sZMO/KPdcnl2zjOL6sJaZDmD0BcQJS3z9rZYSJcE+4tMQrdOGR/gE9AWQfvnbMIoZyzh8U/FMAZ2XLWOThW31NnM6nOO2lk+DPuAz9zoo4xjCLnmJLYE6w1A8oP4Jy/TFlyea9WA8/OM6DYjo8c5zfQWSqegZkLzVszK2T5ly00seWmTtgz/i3ruUU06NB77SQTwsvx5ZD5W+Jw5I95J7JbqBv/0i2kBsFaVnSwm0ClXOsshWJWzEfvvswMtAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAEEwoymGv5KDorstQIvDqIkTOpMSYn5dMYgXHIEAS2+DulRjTP4SiaXZ1Ad69iv0IJzjGJ04uOl0W9tRjzeKRwtCV9bm/RPfYPr2oN1WlOyGRrqpvoeqDnuVzJ7ykv1wY2qbpeKvJGtIVyTG/JwcetzKqWRcLI3PekO1uV9DBvXgM31czA1qgwsQW6HoK3xzfVKfzN+ovpyRilRafiQ7ch/BY3uzjiSjl4l1bdGORA65ZfQ4EIUU0xUZIr6exuOZ5u03YX+KPbNj4oSX2XaDQCtPPge1PN0S3hHDOJlrd0VerN6VrFWheyriMbYTbVVhYEA65+nyH9/yUToWyRklzYw=
85f0263a-90f9-4ac4-b1c8-2c3cb16b883d	21698e16-e62f-4fc1-8d7b-2bf857d5247d	keyUse	ENC
e189c1ce-ead0-4fc2-a4c7-f115f270ed0a	21698e16-e62f-4fc1-8d7b-2bf857d5247d	certificate	MIICnzCCAYcCBgGWl4/YqDANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhiZXR0ZXJHUjAeFw0yNTA1MDMxOTEwMDhaFw0zNTA1MDMxOTExNDhaMBMxETAPBgNVBAMMCGJldHRlckdSMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsdlAWYKi1icAN0DaHBZr0ZDmiS7QbGCFBqFTHSUARwFruONFZDp+V/iocvRh+kZ8Xiu9JpV2U7bSd9gNtFUNfH2yv4ju7LUUzVHtZtdMQeNbx70r8AAtAQd/SNf4INpQJJNlK2wE48L7jgA1rxDGWrfAwpIGEXHdADxBz2iiTMZRsBOksxNR/7N6o6d9B1Se0u7hHnShd4yh6SA3BFvFrxwZjAzRQLgpqapW2ooPc0iYYIImuV2hD9sb6CgFV+8XZGZQETfJU3bu3gXQAb/VJ8YXL75aYrX2qfDEqKITwkfoVjuTpMJfmKRC8twxkNRg/zSMiFLTP96i3W4PT9uuEQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCRcQ8rRKfvdkNZ5MaE/KQoG6GpuxSQQ9P6DVXYkeYdXs0hx9E/OIJmlCzD9uQxi0kV14FrMXyx0hvfUOVOZmfLwENlKmBPYLqHRV94Dh5njnI8Qi/Kftlj/ksEcEtdA4KuiF3HC1HPQnabz5cZ2H1n3Bq+G1yT2gK/8ncpuYf+DlD6Bo3WO6UyXVbU7iDLYRyPfp0wu5tK1Il0Y6UwmM0QCJsDoxUqOqyC2clbbX0lYftZC6erY6Qxn3h8YN9Sz8/m9DD1zOp7/pximElESg5j6xj3LHiEeoLvc5LEyLF7N7Ls2N5mPK+f2zwwntE6HVG+azaZEervjcNqeipJJDo6
66a0f7d2-a3da-4c8e-b9cc-3b31c6c0b2a8	21698e16-e62f-4fc1-8d7b-2bf857d5247d	algorithm	RSA-OAEP
e7259410-e8a9-453f-a7fb-fde78e54ddd7	21698e16-e62f-4fc1-8d7b-2bf857d5247d	privateKey	MIIEpAIBAAKCAQEAsdlAWYKi1icAN0DaHBZr0ZDmiS7QbGCFBqFTHSUARwFruONFZDp+V/iocvRh+kZ8Xiu9JpV2U7bSd9gNtFUNfH2yv4ju7LUUzVHtZtdMQeNbx70r8AAtAQd/SNf4INpQJJNlK2wE48L7jgA1rxDGWrfAwpIGEXHdADxBz2iiTMZRsBOksxNR/7N6o6d9B1Se0u7hHnShd4yh6SA3BFvFrxwZjAzRQLgpqapW2ooPc0iYYIImuV2hD9sb6CgFV+8XZGZQETfJU3bu3gXQAb/VJ8YXL75aYrX2qfDEqKITwkfoVjuTpMJfmKRC8twxkNRg/zSMiFLTP96i3W4PT9uuEQIDAQABAoIBAAbfeHHSb0Hgu/dmqtx5rqz98TV3+QIB24zdYH2N19bmon0V+1vbjtUOJ6RZoWJZ+vsWAaH4wLE3gtFdfhoWogYfmBrNdejxOTPovfNC0BBJHbDjCfb6asLRbAUqo3d8OFX8LuVgr/Jar1IA3BI/ObXOcsU802iKgpnnD5FZCnyg/4SvnNsD2zU1jJSF8Ze3rAIxPFJGaFcwX+8P9JiFD5rHd/UqJjD2IS2n8QnaTnb9a7Zfi+m6z2VG4CPL6BIkP5n7e3yAdoOAJ3t8Bne4JSASklRWpyDJTW1Ra8RXJhwr4cVKPh5drPmCNd8KffaRIo7Jm+qf1GrU/aw59sehI8kCgYEA5Xv4etJxgH95h9oOjj82VDPHj3YDyshKvC4bPinT+AjDLoL7wuMQeOHpSX7aJlqiMtA0BQMJd88How8TRy3Lqd0sIJz0HkSnC2Nnsbem5Ono3gLx/QGTnS4hibdWZAEHRbamZzJYdMW7PoIoX4pIui1uGSmHzpNl42xuYx5ncAsCgYEAxmXsx+bk+tXuswhqbLF7yKXENZt/D++sdMfmwBEDYIAZKej64kAbg2I5iSrUvRjL3B3kGrW3cSU82wdwIcGoVtz3upuwuyq1tfZjbgh4AJgxNpb3i7r72blh0fqjG7V18YyC1kQSpsdm9RWgg4xl7700n41QrKr7SonEIua7H9MCgYEAzMxJIZtjTdD1rYatzMae/qBDLUWd9r+u6qefCmgb0lRHk9+zPOaVUbwTDNMXbnkeHYjvk7V1IqXxY9TVWIWHJ23JrsVDmyubhC9PYCvM1qfleRRZz3gzu2dq6NNkVtUQH2f0s04b4QKBqzRPQYxQgU5/3hbRK0sh98dR8EU2/KcCgYAjI/qEjckRBMN6worXJbifGX1fYWNoFzOcm6uraVgHx6itW67UVDaLVuKKASQdOj8hhcnZUUZkrAvTX8XktMB0Yj8etmTfQfldeX6zBpz6vfo5iRPflAb30XYaEyLAzatOVWz3Nqd3EuqRjnsX0c5cYE7p08XuT3qjATPUWrnaMQKBgQC1nuYqBA6cB7sy7lz3KPzUZvZ+AZItjnDlcAPBofGa/jzzD8yiRkSBTfuIh1O91mAB+pUtNPdZN6rV/i0qQooUG8AJVuSArk4Lz3hPIgITtxTA34p3zfzZ5T+VxoglQacM1T8NXOlfvKdjCq8u9ELMintIYK0jI4C+C57S8ael7g==
c486c9fd-0305-4638-b6cf-ab6a39ed3998	21698e16-e62f-4fc1-8d7b-2bf857d5247d	priority	100
72459a75-1988-42db-9334-e6bcefc242a9	c9ab8200-bf79-443c-96c9-b50f87be1aa0	kid	b9ac8a69-0f50-48cd-98bf-0ec55990ae35
eaee1332-240c-43f4-8a68-37fa993f6dcc	c9ab8200-bf79-443c-96c9-b50f87be1aa0	priority	100
92b6a47c-376a-4601-9920-e09b09a57edc	c9ab8200-bf79-443c-96c9-b50f87be1aa0	algorithm	HS512
0b7d3040-d4a9-465c-a52a-33508cdc79c9	c9ab8200-bf79-443c-96c9-b50f87be1aa0	secret	W__WuPyopWaskqBIsBTQ6ebzqUg-BcbFcfoD_adWEwG8JNUfG4XBkbgNPb3jPqQ54EmIrstyZsM3NZ2jZ1ETw1KlxCbkOKLOzXKs0PHG6TO8ZA2H19IGHk9YGQRKty4-M_c8jpUOZCDaDaa9AvCgf0FfObsVElcoamaKSp_ZnJ4
d125f8a9-3a27-4a73-9181-22d3e53aa7d9	133d2b29-14dc-4d34-9f74-fe07aa63c230	kid	ddf1fba5-8965-4829-91ff-9c4d98497600
f969dc70-2196-46f2-84e1-0d5e316fed40	133d2b29-14dc-4d34-9f74-fe07aa63c230	secret	Q1QQqlzJ86AFyQ3SYjoriw
013962e9-17e0-42d9-a8ce-18277e41d5e1	133d2b29-14dc-4d34-9f74-fe07aa63c230	priority	100
c04e6c86-efa8-44c8-bc6d-3e5a033b8e7f	7c6865d4-5a30-47a7-9fa1-c0fddafb4c8b	privateKey	MIIEowIBAAKCAQEA6FY2PIutIwrfFPV/c/w6buMyW1nz1ytM6pmYpVeJWLo3FX2NPbvkkMscKh73SHBL4COs0Y7Gro3FMqT6jNZExKpPKQy+Gl/ykTIxDEU0KgFyvjIQX4UWwl5sciUTRyXr5SwxvYqabFtq04vxGBYqEyOaLmIhuDgPptxTb4QesnY6MEG7cYgMoZQ5VfWcRb2xGsEQnhwVmzQCzwAyItJU357T6fpw0ZwjNDD4UCZ0S6nfY5ZOKkhOztBpa5hCL+0tcDNzdUQQzBKKnwhbZl9NHCAyt0R/JemFAAbX4itzlC19L/1k51BqX0vQZnXeGgM90zVaQnMnx1PY5EGGO9GuoQIDAQABAoIBAALRIZf7Gd0JSc9IJD/J+/2+SpKzr/XNTmrXmIP3P3Qo/to77YngQT3FnSrOFVxFMooAnvwRGHM6NpqA30LAL6TMukdiv+ItNgq8eS4SknhjtFysSYoSOT/uTTLdMbMuL4XScIFICXaAwq4SFhxDV+qv2OubnISw1j0T2qF6WK54wWWFJDqi7D7hDZi1LeMp3eVDsJ/2stVASc3NGeb6e36SoIKuKPzr/5vu2MyO/eP/1EQvvjzPWeRJN0e8xuloNW/h26S6WIgCCqLmtVGZVDCz2ah+8XsvJ43Aqubz/qW/NbN8c+RQDC9GhXVCBXMV8X49nWmOVPPMd+mi2iRWzW0CgYEA9T3Iy3TB/UuSXgOPW3qt6FznbW8sFY5IajprQf872ycFm8QvyKA6ukGwDBglkxo2fnmFtd/XdFSI9WXNhcNovnk60UXCJv/2LI/OAEXiesYhCmpghVCirT/BClqZX8pYGRv4GjNX1cIm2onf1NG/i45z9Z/q1kwtXOFD4cgJBK8CgYEA8oeAOultU0OL+/r0ZfkQUY8rKvcc5euuJkb3nszlmpk98Ql/F9jNXfc48KxJWV5l71hpgwWzkPKhxR6MWKu/3RzAuish8cM4G1ZcGOxmXrzqadsCSN3FT+uv74nTd8WZsWy8SqFBLMSm/eE/cIsVwJEgaD9quHhaz8tHswmU9a8CgYEAqrj7Kp+6WBGe8DG8P6u0mzjppuYoo0zsnn7SohwDWDnfDqPRu/HHUFhgLNs2dSRfYUZJzeXpAEPFIEhhfcgeB9MvHfZZBXtUrYrilpAP7PY2lCCf1s7eoIrsYL/XW7bqA3jUC7FIaTeCgspOdsIZfRaLJSfRfKOFRM5QykHN/WMCgYBr1jv59diacSpI/Ci3Pqs22IXFMOM0iDqC4oMvpMNinkigaCyOmeOWqFo1CSYECqkgZxtjGqHhDUFIuHCG7Lb+xc4b+Rm6uaa04Q1KN7K85RsFvk+hvpoBEzbDN3FDjCTucv614EVudnIZ6JGgpPcjDGRwdeIp67nVMvnKbbRCGQKBgG+d9HsK08DN0hgYpZgQTe7AgCYu+uumZIgkskYBs64DZZFycUY6PRzVAC50hhkFGnBW4CZeEGU7mtJq5RlaJRQIY/kbU5FYk/ZG5sD+daWuI3MX2Ng99IlCc2E2N5ThYDNIpUFjx7QDm2GXqw+g8cJTmShwYlEUOgvHGnwiVL0K
47717049-241f-4527-88af-b1097805e0bc	7c6865d4-5a30-47a7-9fa1-c0fddafb4c8b	certificate	MIICnzCCAYcCBgGWl4/XeDANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhiZXR0ZXJHUjAeFw0yNTA1MDMxOTEwMDhaFw0zNTA1MDMxOTExNDhaMBMxETAPBgNVBAMMCGJldHRlckdSMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6FY2PIutIwrfFPV/c/w6buMyW1nz1ytM6pmYpVeJWLo3FX2NPbvkkMscKh73SHBL4COs0Y7Gro3FMqT6jNZExKpPKQy+Gl/ykTIxDEU0KgFyvjIQX4UWwl5sciUTRyXr5SwxvYqabFtq04vxGBYqEyOaLmIhuDgPptxTb4QesnY6MEG7cYgMoZQ5VfWcRb2xGsEQnhwVmzQCzwAyItJU357T6fpw0ZwjNDD4UCZ0S6nfY5ZOKkhOztBpa5hCL+0tcDNzdUQQzBKKnwhbZl9NHCAyt0R/JemFAAbX4itzlC19L/1k51BqX0vQZnXeGgM90zVaQnMnx1PY5EGGO9GuoQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCvyIGE+5BBNr5ejh1RnjZugtp7ot/aqBrl0TNSwQm+qYKYuGW7up462gtjfnVn9P6+xgxxLhUJj0PvGhCExyDezXeLpJf17f2Si7LGUPUWi9meQUjP6cOO0NQqYO2bJNNBEJ6B1dX5kpdeDJmrfVoHtDrSIQ9ntng9NvYwT/449Pqz1RXtDlUgJVNDOQZ5YNUxnNXyK9ThoCOykEyI4wUSAeAsWfFVbPbzpPhzKROoz+7obWEnpJnR1JFXqFaXGidWFC6ic/AHdh2/lvuz4s7FFAbW+9vLzsqzbfdWkZScD2B7NGCQcMvS8MxYktSC2hlJNbOOxpU0PhVLt4mVFjoR
29ab9d8c-fd02-4ec7-9e72-5f569f0d5d7f	7c6865d4-5a30-47a7-9fa1-c0fddafb4c8b	priority	100
99748e8d-d3b1-46ab-a45e-0842a4229c00	7c6865d4-5a30-47a7-9fa1-c0fddafb4c8b	keyUse	SIG
826c2557-a489-44fc-b50a-473e033e34ea	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
b198aec1-c6d3-4395-a2d2-5251a50a46bf	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
6485f24d-7ac1-4730-a323-631e5670f7c2	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	saml-role-list-mapper
73276509-d8a6-4f1b-ac1f-bc19e2e91162	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	saml-user-property-mapper
15737ea5-4c86-4df1-b307-6cf6dc502982	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
d304582e-7dea-41b8-97b2-04e9ec31e20f	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	oidc-full-name-mapper
4545604d-f7e0-4ad4-8361-a0b334f1d6de	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	oidc-address-mapper
079c4a9e-65d9-47bb-bba2-a84f7cc4d795	8c508b65-ac44-493c-aac2-1bc7f95e4ad5	allowed-protocol-mapper-types	saml-user-attribute-mapper
946fedb9-868e-4aec-995b-f4f25750d48f	f235658a-522d-4451-abea-c12b0d085ab9	max-clients	200
a6911f1c-4ccd-49b0-bdf5-c4e118bda7d7	8032b983-80c9-4169-b6d6-50e7deb53062	allow-default-scopes	true
1e862626-9350-491f-a502-58e61bed4481	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	oidc-full-name-mapper
5ba0c837-eaf6-464c-831b-5c0a528442ed	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
8dd0b0ae-fe06-4894-b601-5d2e9505d257	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
f0f88264-ef19-4f8d-9cbb-b292a6df58f1	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
d05e4b80-ad9d-4b6d-ad60-e29d4e14642d	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	oidc-address-mapper
19ffe907-41c2-40b0-9cfd-ceead87ef3b2	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	saml-user-attribute-mapper
6b0048a7-e3b2-4857-80d2-b7f635901e17	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	saml-user-property-mapper
0bc04896-7d89-4fdf-9b5c-a5d6ebc1466e	0504fdce-3ee3-4c8f-acd0-1d875f011235	allowed-protocol-mapper-types	saml-role-list-mapper
c956f11d-d963-4f79-a38b-964a69b89f31	ca710653-8465-401d-a10d-e87f1bdf9ff8	allow-default-scopes	true
57e3f935-e55c-4e89-9f5a-05a7b7400027	d6bcd9c4-bc8a-4dac-ae0a-d6021933df74	client-uris-must-match	true
f572cfe1-f06f-438c-b750-3ebd20a0fe89	d6bcd9c4-bc8a-4dac-ae0a-d6021933df74	host-sending-registration-request-must-match	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	d5a3b411-768d-4820-a72b-09e335118712
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	531962ae-4488-4156-ac33-e51f31b2846c
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	3c573013-7481-466a-b9d1-dc2b107a6867
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	82ce4ef6-7455-4275-9000-8d228adb07ce
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	7eded58c-e76d-43f5-877b-a56efd942a4b
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	632056a3-ff23-47d7-a1da-14d6ac012c2d
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	0f9f0dfd-72ff-413b-945f-83d3f0bdeed6
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	ecafb2d2-ba49-4dd4-97af-cfb593cb58c8
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	eaa8d22d-1148-4442-853d-c655588ecc84
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	ce980754-eefc-40fd-96e1-f5e7c9c5228e
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	596cb618-fa55-4673-8af1-7e1df43715bd
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	cd2aba45-c3cd-4cf0-8ea6-2986d5bed0d5
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	5ea0d065-d5d3-4e64-91cd-85d407674e0f
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	b9d605af-f585-4e5c-a467-0840fe98ca4d
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	5b9c30a3-c734-406e-b16e-7162ffd9163b
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	fc814457-d507-464d-a284-12507fea67d3
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	2710cb61-e37b-4893-a01b-4c76d7f4134f
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	69fa8da2-e257-4fbc-8381-ed2e10cf672c
7eded58c-e76d-43f5-877b-a56efd942a4b	fc814457-d507-464d-a284-12507fea67d3
82ce4ef6-7455-4275-9000-8d228adb07ce	69fa8da2-e257-4fbc-8381-ed2e10cf672c
82ce4ef6-7455-4275-9000-8d228adb07ce	5b9c30a3-c734-406e-b16e-7162ffd9163b
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	f1937c8d-b498-404a-a9c0-4158e0a7bd66
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	ce8e5b64-e6c4-49c7-a998-765bc2d9e4c8
ce8e5b64-e6c4-49c7-a998-765bc2d9e4c8	47a532a4-9094-438f-aecf-9073f389ec2e
35aabccd-8216-4970-b6e3-d465ca6cbc59	84431bfd-bdd1-4402-b3b2-691bf2eb81dc
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	8e6b1e3c-1c0b-44f4-ae9b-20e5cf65fa47
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	9afa8303-3b34-45b0-83fe-6e0db5defacb
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	c660adb7-060e-4dd0-a8e3-7c727e39f0e6
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	bfb8fe93-586d-40c7-82ab-f34faf481354
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	470f35fe-e0ec-4272-858e-4b9431a84954
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	0f0378cd-df31-46ae-a259-d1ba9153024c
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	786d0150-f95a-41f7-8503-8b10c41ada3a
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	5da740b5-681e-48ea-a163-ebf84d84de4d
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	6b727418-322b-41eb-b8be-fe3b23ec6b4b
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	0ac7baa0-da83-4681-85dd-ddf8bd577468
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	86c3ce13-efbb-46a1-ab19-f50e68ef7206
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	e3e5c478-442a-44b3-8e6c-a93ddd485330
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	6503cc2a-43b0-4ac8-825f-e202a262823c
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	36fdd133-e339-4ab2-8c79-a7141dbea3aa
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	43338ec8-2577-4e2d-9629-862682fe849c
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	996a3780-9518-4b5a-b323-f8016606648b
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	a688e3a7-ae14-42ac-b922-b705adf187b7
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	d53ac201-23a8-4e43-9d3f-2f3ec826f2aa
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	aec4fbcf-33a0-464c-b2de-284f81828ed5
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	d6787de5-fe0e-4910-a9a9-1fb24a5d76a4
0f0378cd-df31-46ae-a259-d1ba9153024c	a688e3a7-ae14-42ac-b922-b705adf187b7
0f0378cd-df31-46ae-a259-d1ba9153024c	d6787de5-fe0e-4910-a9a9-1fb24a5d76a4
786d0150-f95a-41f7-8503-8b10c41ada3a	d53ac201-23a8-4e43-9d3f-2f3ec826f2aa
e1bb2049-e262-4626-8b8a-b620e32017e5	22f55961-f8a4-459e-85e3-cd72292a1bef
e1bb2049-e262-4626-8b8a-b620e32017e5	544c55a0-07e1-4df2-aabc-bc43cb2c9bba
e1bb2049-e262-4626-8b8a-b620e32017e5	6de51024-0b69-42fc-ae50-4ca7b974c83d
e1bb2049-e262-4626-8b8a-b620e32017e5	ee2f4cc1-d3f2-4f16-b526-a67e3db33da6
e1bb2049-e262-4626-8b8a-b620e32017e5	d94fd6f8-f503-45fc-9838-5aa64f520625
e1bb2049-e262-4626-8b8a-b620e32017e5	20c5a3d3-e04c-4c39-855d-3b090413a88d
e1bb2049-e262-4626-8b8a-b620e32017e5	9781f8c5-0826-4928-8fb7-59d175e58d5f
e1bb2049-e262-4626-8b8a-b620e32017e5	7e08b7f0-1f4f-42ff-b3e2-116c53b778f2
e1bb2049-e262-4626-8b8a-b620e32017e5	801dcb51-e260-4155-aefe-18139026d4d1
e1bb2049-e262-4626-8b8a-b620e32017e5	26c9b3ea-fcf6-45e3-abdf-d7a344b04ddf
e1bb2049-e262-4626-8b8a-b620e32017e5	1a28ac6b-b78f-4a46-aaeb-40b4a84699d9
e1bb2049-e262-4626-8b8a-b620e32017e5	b750cc8f-9f8c-48a1-88f8-ab4c5b03b9f4
e1bb2049-e262-4626-8b8a-b620e32017e5	e60d93f7-5e39-456f-9f78-ab546ba6eedc
e1bb2049-e262-4626-8b8a-b620e32017e5	9204289d-9165-452f-8b1d-299fdbcacfd6
e1bb2049-e262-4626-8b8a-b620e32017e5	e1c008a8-46c6-4d31-9dc0-4c8534a38f9d
e1bb2049-e262-4626-8b8a-b620e32017e5	f5490753-2fa0-4367-9f8b-f107f3673b8b
e1bb2049-e262-4626-8b8a-b620e32017e5	eb872b4a-3546-4154-ab95-b6c0de0de2c3
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	6e36ef14-075d-4532-aa21-bf3e3f387968
6de51024-0b69-42fc-ae50-4ca7b974c83d	9204289d-9165-452f-8b1d-299fdbcacfd6
6de51024-0b69-42fc-ae50-4ca7b974c83d	eb872b4a-3546-4154-ab95-b6c0de0de2c3
ee2f4cc1-d3f2-4f16-b526-a67e3db33da6	e1c008a8-46c6-4d31-9dc0-4c8534a38f9d
e1bb2049-e262-4626-8b8a-b620e32017e5	8fb18eea-375e-4778-8367-aa974bcfbc4c
7ad01c08-3fce-4296-bdb2-d5df593581a9	9a798090-ed17-47cd-821a-940b36253d7c
7ad01c08-3fce-4296-bdb2-d5df593581a9	02c02ad8-3d7b-4842-85ae-20d710cd5ef3
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
257eaf5b-2c30-4e79-9bfe-a1fe976780c2	\N	password	123456789	1746299508407	\N	{"value":"cCtHK/SBzVfvr1LSysxpqz96S1uDt1hNp03XpABvybo=","salt":"TJCjOlC1ZLXoFHaFenAl1w==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
472821b3-e61b-442d-8244-1d28e0852f8d	\N	password	987654321	1746299508473	\N	{"value":"vqGQi52p2LkSoQst2kz17ZVUMXlopPntxrYP+EKX+ME=","salt":"efYSiGiZC1EzgS4vjhhFuA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
099b3bb1-a73e-4404-a2da-0add9f301589	\N	password	admin-id-789	1746299508523	\N	{"value":"vWz4/o/MBCT2Rm3rWlUqx7m+5XlbLzO0PtuMrvoYid4=","salt":"8yIyQrQRonoK5SJ5Hx2sQg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
90533427-f1c5-4243-9c0c-1d854dfc6aff	\N	password	25d09a58-ae64-4012-83f1-1e786133f483	1746299509101	\N	{"value":"1onunFku4dAlOiyYz5n4u0wxhWBysRjruAe6jrFg+K8=","salt":"MvnTlT2qC9kGHmGMB68ROg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-05-03 19:11:40.743347	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	6299500319
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-05-03 19:11:40.753705	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	6299500319
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-05-03 19:11:40.792659	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.29.1	\N	\N	6299500319
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-05-03 19:11:40.797689	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6299500319
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-05-03 19:11:40.876762	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	6299500319
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-05-03 19:11:40.882556	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	6299500319
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-05-03 19:11:40.940659	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	6299500319
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-05-03 19:11:40.944072	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	6299500319
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-05-03 19:11:40.951798	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.29.1	\N	\N	6299500319
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-05-03 19:11:41.042347	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.29.1	\N	\N	6299500319
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-05-03 19:11:41.103721	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6299500319
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-05-03 19:11:41.108835	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6299500319
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-05-03 19:11:41.126012	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6299500319
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-05-03 19:11:41.13532	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.29.1	\N	\N	6299500319
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-05-03 19:11:41.136785	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-05-03 19:11:41.139013	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.29.1	\N	\N	6299500319
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-05-03 19:11:41.141304	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.29.1	\N	\N	6299500319
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-05-03 19:11:41.162457	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.29.1	\N	\N	6299500319
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-05-03 19:11:41.190151	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	6299500319
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-05-03 19:11:41.196027	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	6299500319
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-05-03 19:11:41.199725	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	6299500319
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-05-03 19:11:41.20308	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	6299500319
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-05-03 19:11:41.2689	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.29.1	\N	\N	6299500319
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-05-03 19:11:41.273438	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	6299500319
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-05-03 19:11:41.274718	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	6299500319
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-05-03 19:11:41.569544	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.29.1	\N	\N	6299500319
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-05-03 19:11:41.602168	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.29.1	\N	\N	6299500319
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-05-03 19:11:41.606077	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	6299500319
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-05-03 19:11:41.629228	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.29.1	\N	\N	6299500319
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-05-03 19:11:41.638044	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.29.1	\N	\N	6299500319
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-05-03 19:11:41.649135	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.29.1	\N	\N	6299500319
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-05-03 19:11:41.653276	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.29.1	\N	\N	6299500319
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-05-03 19:11:41.65785	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-05-03 19:11:41.660392	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	6299500319
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-05-03 19:11:41.679282	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	6299500319
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-05-03 19:11:41.684726	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.29.1	\N	\N	6299500319
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-05-03 19:11:41.688944	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6299500319
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-05-03 19:11:41.693279	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.29.1	\N	\N	6299500319
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-05-03 19:11:41.696686	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.29.1	\N	\N	6299500319
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-05-03 19:11:41.697997	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	6299500319
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-05-03 19:11:41.700081	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	6299500319
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-05-03 19:11:41.704207	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.29.1	\N	\N	6299500319
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-05-03 19:11:42.996052	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.29.1	\N	\N	6299500319
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-05-03 19:11:43.000406	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.29.1	\N	\N	6299500319
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-05-03 19:11:43.004695	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	6299500319
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-05-03 19:11:43.008704	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.29.1	\N	\N	6299500319
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-05-03 19:11:43.010047	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	6299500319
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-05-03 19:11:43.117615	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.29.1	\N	\N	6299500319
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-05-03 19:11:43.122974	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.29.1	\N	\N	6299500319
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-05-03 19:11:43.140282	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.29.1	\N	\N	6299500319
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-05-03 19:11:43.497939	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.29.1	\N	\N	6299500319
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-05-03 19:11:43.501688	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-05-03 19:11:43.505459	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.29.1	\N	\N	6299500319
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-05-03 19:11:43.508729	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.29.1	\N	\N	6299500319
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-05-03 19:11:43.51314	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.29.1	\N	\N	6299500319
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-05-03 19:11:43.517952	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.29.1	\N	\N	6299500319
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-05-03 19:11:43.558289	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.29.1	\N	\N	6299500319
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-05-03 19:11:43.896351	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.29.1	\N	\N	6299500319
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-05-03 19:11:43.909933	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.29.1	\N	\N	6299500319
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-05-03 19:11:43.9141	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	6299500319
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-05-03 19:11:43.920631	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.29.1	\N	\N	6299500319
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-05-03 19:11:43.92326	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.29.1	\N	\N	6299500319
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-05-03 19:11:43.925638	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	6299500319
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-05-03 19:11:43.927685	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	6299500319
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-05-03 19:11:43.929803	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.29.1	\N	\N	6299500319
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-05-03 19:11:43.964442	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.29.1	\N	\N	6299500319
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-05-03 19:11:43.996419	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.29.1	\N	\N	6299500319
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-05-03 19:11:44.000176	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.29.1	\N	\N	6299500319
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-05-03 19:11:44.035567	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.29.1	\N	\N	6299500319
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-05-03 19:11:44.040804	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.29.1	\N	\N	6299500319
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-05-03 19:11:44.043783	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	6299500319
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-05-03 19:11:44.050041	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6299500319
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-05-03 19:11:44.055836	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6299500319
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-05-03 19:11:44.05729	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6299500319
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-05-03 19:11:44.070286	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.29.1	\N	\N	6299500319
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-05-03 19:11:44.102926	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	6299500319
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-05-03 19:11:44.106785	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.29.1	\N	\N	6299500319
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-05-03 19:11:44.108595	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.29.1	\N	\N	6299500319
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-05-03 19:11:44.120839	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.29.1	\N	\N	6299500319
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-05-03 19:11:44.122257	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.29.1	\N	\N	6299500319
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-05-03 19:11:44.154606	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.29.1	\N	\N	6299500319
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-05-03 19:11:44.156248	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6299500319
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-05-03 19:11:44.15951	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6299500319
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-05-03 19:11:44.160528	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6299500319
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-05-03 19:11:44.190332	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6299500319
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-05-03 19:11:44.193875	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.29.1	\N	\N	6299500319
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-05-03 19:11:44.199776	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.29.1	\N	\N	6299500319
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-05-03 19:11:44.205323	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.29.1	\N	\N	6299500319
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.212001	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.29.1	\N	\N	6299500319
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.21561	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.29.1	\N	\N	6299500319
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.249046	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.256192	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.29.1	\N	\N	6299500319
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.258116	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	6299500319
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.263519	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	6299500319
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.264925	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.29.1	\N	\N	6299500319
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-05-03 19:11:44.271792	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.29.1	\N	\N	6299500319
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.354057	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.355436	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.364536	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.399899	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.401525	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.445767	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.29.1	\N	\N	6299500319
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-05-03 19:11:44.449623	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.29.1	\N	\N	6299500319
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-05-03 19:11:44.453753	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.29.1	\N	\N	6299500319
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-05-03 19:11:44.497676	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.29.1	\N	\N	6299500319
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-05-03 19:11:44.54035	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	6299500319
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-05-03 19:11:44.588643	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	6299500319
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-05-03 19:11:44.592995	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.29.1	\N	\N	6299500319
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-05-03 19:11:44.638265	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	6299500319
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-05-03 19:11:44.640275	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	6299500319
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-05-03 19:11:44.64602	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-05-03 19:11:44.649718	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.29.1	\N	\N	6299500319
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-05-03 19:11:44.657758	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	6299500319
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-05-03 19:11:44.662905	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.29.1	\N	\N	6299500319
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-05-03 19:11:44.666926	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.29.1	\N	\N	6299500319
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-05-03 19:11:44.668255	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.29.1	\N	\N	6299500319
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-05-03 19:11:44.672423	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.29.1	\N	\N	6299500319
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-05-03 19:11:44.67487	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6299500319
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-05-03 19:11:44.835559	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.29.1	\N	\N	6299500319
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-05-03 19:11:44.841186	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.29.1	\N	\N	6299500319
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-05-03 19:11:44.845075	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-05-03 19:11:44.887012	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-05-03 19:11:44.890283	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.29.1	\N	\N	6299500319
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-05-03 19:11:44.894762	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-05-03 19:11:44.896453	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:44.900183	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:44.947469	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:44.999261	128	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.047092	129	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.095726	130	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.164465	131	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.166254	132	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.205755	133	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6299500319
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.214397	134	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	6299500319
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.224403	135	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	6299500319
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.225953	136	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	6299500319
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-05-03 19:11:45.316981	137	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	6299500319
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.324842	138	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	6299500319
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.331383	139	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	6299500319
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.375349	140	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	6299500319
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.380499	141	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	6299500319
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.385515	142	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	6299500319
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.414124	143	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	6299500319
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.481584	144	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	6299500319
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.526328	145	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	6299500319
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.534949	146	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	6299500319
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-05-03 19:11:45.537905	147	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	6299500319
26.0.6-34013	keycloak	META-INF/jpa-changelog-26.0.6.xml	2025-05-03 19:11:45.543772	148	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	6299500319
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
071eec07-9d0a-411e-bf21-78c3daf9b724	ca651735-0144-45c5-87dc-250cc37df5f4	f
071eec07-9d0a-411e-bf21-78c3daf9b724	f3369179-1936-4363-be4c-612ce66ebd81	t
071eec07-9d0a-411e-bf21-78c3daf9b724	1948f5af-be4c-4aac-a7dc-cdd6cbeabff2	t
071eec07-9d0a-411e-bf21-78c3daf9b724	5a1ecb3f-c78e-4462-810b-1615182370bb	t
071eec07-9d0a-411e-bf21-78c3daf9b724	95e8b45b-479a-49cd-8e98-44f14fd4d8df	t
071eec07-9d0a-411e-bf21-78c3daf9b724	89e7dc7e-f0be-4abd-bda4-ea47d09d107a	f
071eec07-9d0a-411e-bf21-78c3daf9b724	d5430628-bedf-421d-a101-5d7eac80d0d5	f
071eec07-9d0a-411e-bf21-78c3daf9b724	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7	t
071eec07-9d0a-411e-bf21-78c3daf9b724	aeb0d480-523d-4301-ba89-dd5e361d9f38	t
071eec07-9d0a-411e-bf21-78c3daf9b724	91570a16-8ad0-4d13-b625-95e64429d882	f
071eec07-9d0a-411e-bf21-78c3daf9b724	d405913f-0ac6-4f13-85ee-74978f89435b	t
071eec07-9d0a-411e-bf21-78c3daf9b724	ccc21268-fbc0-49ae-af14-f270b2ac5cb0	t
071eec07-9d0a-411e-bf21-78c3daf9b724	c9b851da-cf87-48cf-81f5-eee802177928	f
betterGR	437cbe87-05c0-4b7e-8dc4-423bd1409419	f
betterGR	fe568452-f2fa-4273-bffd-5e6acbb17f75	t
betterGR	8fa46a9a-dae9-4a88-a40f-25cb70fb6efe	t
betterGR	1808ecb0-fe6b-4e49-91fa-abdd123ba07f	t
betterGR	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c	t
betterGR	4bdc090f-3e64-4332-9b1e-41a5068105be	f
betterGR	e729b22c-95a0-41c7-8956-1f2166c34bbe	f
betterGR	9a70b3e3-a9ac-41fd-8812-69a3618e8c25	t
betterGR	fe493385-0bd9-44a2-a096-3fe041896716	t
betterGR	feadc70a-c168-4cb9-ae64-0307c033bbc6	f
betterGR	172f6dcc-8262-4b8b-bca9-0039345a39ba	t
betterGR	bdfb450d-6879-4f29-a77d-2c5370c62747	t
betterGR	8ffa9364-7313-4157-84cf-696b317582e3	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	071eec07-9d0a-411e-bf21-78c3daf9b724	f	${role_default-roles}	default-roles-master	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	\N
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	071eec07-9d0a-411e-bf21-78c3daf9b724	f	${role_admin}	admin	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	\N
d5a3b411-768d-4820-a72b-09e335118712	071eec07-9d0a-411e-bf21-78c3daf9b724	f	${role_create-realm}	create-realm	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	\N
531962ae-4488-4156-ac33-e51f31b2846c	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_create-client}	create-client	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
3c573013-7481-466a-b9d1-dc2b107a6867	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-realm}	view-realm	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
82ce4ef6-7455-4275-9000-8d228adb07ce	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-users}	view-users	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
7eded58c-e76d-43f5-877b-a56efd942a4b	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-clients}	view-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
632056a3-ff23-47d7-a1da-14d6ac012c2d	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-events}	view-events	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
0f9f0dfd-72ff-413b-945f-83d3f0bdeed6	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-identity-providers}	view-identity-providers	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
ecafb2d2-ba49-4dd4-97af-cfb593cb58c8	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_view-authorization}	view-authorization	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
eaa8d22d-1148-4442-853d-c655588ecc84	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-realm}	manage-realm	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
ce980754-eefc-40fd-96e1-f5e7c9c5228e	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-users}	manage-users	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
596cb618-fa55-4673-8af1-7e1df43715bd	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-clients}	manage-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
cd2aba45-c3cd-4cf0-8ea6-2986d5bed0d5	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-events}	manage-events	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
5ea0d065-d5d3-4e64-91cd-85d407674e0f	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-identity-providers}	manage-identity-providers	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
b9d605af-f585-4e5c-a467-0840fe98ca4d	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_manage-authorization}	manage-authorization	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
5b9c30a3-c734-406e-b16e-7162ffd9163b	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_query-users}	query-users	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
fc814457-d507-464d-a284-12507fea67d3	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_query-clients}	query-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
2710cb61-e37b-4893-a01b-4c76d7f4134f	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_query-realms}	query-realms	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
69fa8da2-e257-4fbc-8381-ed2e10cf672c	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_query-groups}	query-groups	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
f1937c8d-b498-404a-a9c0-4158e0a7bd66	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_view-profile}	view-profile	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
ce8e5b64-e6c4-49c7-a998-765bc2d9e4c8	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_manage-account}	manage-account	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
47a532a4-9094-438f-aecf-9073f389ec2e	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_manage-account-links}	manage-account-links	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
f003d253-2c50-481f-931f-3969a1d9a792	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_view-applications}	view-applications	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
84431bfd-bdd1-4402-b3b2-691bf2eb81dc	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_view-consent}	view-consent	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
35aabccd-8216-4970-b6e3-d465ca6cbc59	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_manage-consent}	manage-consent	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
cb4f9c66-4696-4cad-932f-b5eaf1bcda9d	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_view-groups}	view-groups	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
f7f8f9ea-89ef-46db-a836-c2208999835a	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	t	${role_delete-account}	delete-account	071eec07-9d0a-411e-bf21-78c3daf9b724	843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	\N
4b5a80a2-3c12-439d-896b-8f88bd540a6c	ef2937ac-47e1-44d1-a985-68828a4465ed	t	${role_read-token}	read-token	071eec07-9d0a-411e-bf21-78c3daf9b724	ef2937ac-47e1-44d1-a985-68828a4465ed	\N
8e6b1e3c-1c0b-44f4-ae9b-20e5cf65fa47	15d31b1d-8591-4939-bc81-366fa652552f	t	${role_impersonation}	impersonation	071eec07-9d0a-411e-bf21-78c3daf9b724	15d31b1d-8591-4939-bc81-366fa652552f	\N
9afa8303-3b34-45b0-83fe-6e0db5defacb	071eec07-9d0a-411e-bf21-78c3daf9b724	f	${role_offline-access}	offline_access	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	\N
c660adb7-060e-4dd0-a8e3-7c727e39f0e6	071eec07-9d0a-411e-bf21-78c3daf9b724	f	${role_uma_authorization}	uma_authorization	071eec07-9d0a-411e-bf21-78c3daf9b724	\N	\N
7ad01c08-3fce-4296-bdb2-d5df593581a9	betterGR	f	${role_default-roles}	default-roles-bettergr	betterGR	\N	\N
bfb8fe93-586d-40c7-82ab-f34faf481354	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_create-client}	create-client	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
470f35fe-e0ec-4272-858e-4b9431a84954	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-realm}	view-realm	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
0f0378cd-df31-46ae-a259-d1ba9153024c	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-users}	view-users	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
786d0150-f95a-41f7-8503-8b10c41ada3a	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-clients}	view-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
5da740b5-681e-48ea-a163-ebf84d84de4d	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-events}	view-events	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
6b727418-322b-41eb-b8be-fe3b23ec6b4b	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-identity-providers}	view-identity-providers	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
0ac7baa0-da83-4681-85dd-ddf8bd577468	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_view-authorization}	view-authorization	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
86c3ce13-efbb-46a1-ab19-f50e68ef7206	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-realm}	manage-realm	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
e3e5c478-442a-44b3-8e6c-a93ddd485330	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-users}	manage-users	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
6503cc2a-43b0-4ac8-825f-e202a262823c	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-clients}	manage-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
36fdd133-e339-4ab2-8c79-a7141dbea3aa	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-events}	manage-events	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
43338ec8-2577-4e2d-9629-862682fe849c	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-identity-providers}	manage-identity-providers	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
996a3780-9518-4b5a-b323-f8016606648b	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_manage-authorization}	manage-authorization	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
a688e3a7-ae14-42ac-b922-b705adf187b7	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_query-users}	query-users	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
d53ac201-23a8-4e43-9d3f-2f3ec826f2aa	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_query-clients}	query-clients	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
aec4fbcf-33a0-464c-b2de-284f81828ed5	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_query-realms}	query-realms	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
d6787de5-fe0e-4910-a9a9-1fb24a5d76a4	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_query-groups}	query-groups	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
e1bb2049-e262-4626-8b8a-b620e32017e5	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_realm-admin}	realm-admin	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
22f55961-f8a4-459e-85e3-cd72292a1bef	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_create-client}	create-client	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
544c55a0-07e1-4df2-aabc-bc43cb2c9bba	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-realm}	view-realm	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
6de51024-0b69-42fc-ae50-4ca7b974c83d	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-users}	view-users	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
ee2f4cc1-d3f2-4f16-b526-a67e3db33da6	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-clients}	view-clients	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
d94fd6f8-f503-45fc-9838-5aa64f520625	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-events}	view-events	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
20c5a3d3-e04c-4c39-855d-3b090413a88d	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-identity-providers}	view-identity-providers	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
9781f8c5-0826-4928-8fb7-59d175e58d5f	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_view-authorization}	view-authorization	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
7e08b7f0-1f4f-42ff-b3e2-116c53b778f2	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-realm}	manage-realm	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
801dcb51-e260-4155-aefe-18139026d4d1	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-users}	manage-users	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
26c9b3ea-fcf6-45e3-abdf-d7a344b04ddf	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-clients}	manage-clients	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
1a28ac6b-b78f-4a46-aaeb-40b4a84699d9	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-events}	manage-events	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
b750cc8f-9f8c-48a1-88f8-ab4c5b03b9f4	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-identity-providers}	manage-identity-providers	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
e60d93f7-5e39-456f-9f78-ab546ba6eedc	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_manage-authorization}	manage-authorization	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
9204289d-9165-452f-8b1d-299fdbcacfd6	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_query-users}	query-users	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
e1c008a8-46c6-4d31-9dc0-4c8534a38f9d	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_query-clients}	query-clients	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
f5490753-2fa0-4367-9f8b-f107f3673b8b	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_query-realms}	query-realms	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
eb872b4a-3546-4154-ab95-b6c0de0de2c3	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_query-groups}	query-groups	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
6e36ef14-075d-4532-aa21-bf3e3f387968	0a1285a6-2774-4a38-be03-cf7b305bb0f2	t	${role_impersonation}	impersonation	071eec07-9d0a-411e-bf21-78c3daf9b724	0a1285a6-2774-4a38-be03-cf7b305bb0f2	\N
8fb18eea-375e-4778-8367-aa974bcfbc4c	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	t	${role_impersonation}	impersonation	betterGR	8110c48d-a1db-41d9-b405-7f9fe0ef8ab7	\N
0ef750a4-06ac-48b2-99fb-8d18f149a7ae	72809e17-2428-494c-a642-271f5a4ea9e7	t	${role_read-token}	read-token	betterGR	72809e17-2428-494c-a642-271f5a4ea9e7	\N
9a798090-ed17-47cd-821a-940b36253d7c	betterGR	f	${role_offline-access}	offline_access	betterGR	\N	\N
student-role	betterGR	f	Student role	student	betterGR	\N	\N
staff-role	betterGR	f	Staff role	staff	betterGR	\N	\N
admin-role	betterGR	f	Administrator role	admin	betterGR	\N	\N
2c843c11-eed8-4142-a4c2-e77ab9412af9	267f722f-ad05-4e35-adc6-0b64d05c0137	t	${role_delete-account}	delete-account	betterGR	267f722f-ad05-4e35-adc6-0b64d05c0137	\N
02c02ad8-3d7b-4842-85ae-20d710cd5ef3	betterGR	f	${role_uma_authorization}	uma_authorization	betterGR	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
gv1ee	26.0.8	1746299506
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
8b4b5fb1-290b-4905-9ea4-5dbedbb630a3	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	0	1749397285	{"authMethod":"openid-connect","redirectUri":"http://localhost:8080/admin/master/console/","notes":{"clientId":"a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2","iss":"http://localhost:8080/realms/master","startedAt":"1749396452","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"09fcad7e-68e0-45d4-8dd1-ae2858f65a27","response_mode":"query","scope":"openid","userSessionStartedAt":"1749396452","redirect_uri":"http://localhost:8080/admin/master/console/","state":"fcb9e914-aead-4538-aa23-c49333ce758b","code_challenge":"2gbud_p6uugIqZTzuVe4VG_Uuc1eqk6IiI0u1OPqaIA","prompt":"none","SSO_AUTH":"true"}}	local	local	4
ca02c447-19c5-428b-85ed-09ff7430de35	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	0	1749399203	{"authMethod":"openid-connect","redirectUri":"http://auth.bettergr.org:8080/admin/master/console/","notes":{"clientId":"a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2","iss":"http://auth.bettergr.org:8080/realms/master","startedAt":"1749399203","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"1ff7a551-ef62-4609-9820-ef84ff88daf5","response_mode":"query","scope":"openid","userSessionStartedAt":"1749399203","redirect_uri":"http://auth.bettergr.org:8080/admin/master/console/","state":"400af8d0-d98d-441e-b4e4-19001d2d15da","code_challenge":"grqSFZuDj0g8jcaNKDN7Aa3KDTANSFrzLFQC9fvzLso"}}	local	local	0
476c96a9-042e-46ff-a174-33b522b64c1f	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	0	1749402524	{"authMethod":"openid-connect","redirectUri":"http://auth.bettergr.org:8080/admin/master/console/","notes":{"clientId":"a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2","iss":"http://auth.bettergr.org:8080/realms/master","startedAt":"1749402524","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"b995bbe6-4e70-4952-a2e3-12d825136d4e","response_mode":"query","scope":"openid","userSessionStartedAt":"1749402524","redirect_uri":"http://auth.bettergr.org:8080/admin/master/console/","state":"52aa75d1-fa13-42d7-85fc-9682f37ade3c","code_challenge":"hJS7yA-4pTCXBe6gVGF6R0ieoZyGhfsDlk3uHqstbEw"}}	local	local	0
abb0c4f9-57e8-41b4-a20c-4e9be577596d	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	0	1749396208	{"authMethod":"openid-connect","redirectUri":"http://auth.bettergr.org:8080/admin/master/console/","notes":{"clientId":"a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2","iss":"http://auth.bettergr.org:8080/realms/master","startedAt":"1749396207","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"dfd63071-04e3-400f-95ec-abc13575b413","response_mode":"query","scope":"openid","userSessionStartedAt":"1749396207","redirect_uri":"http://auth.bettergr.org:8080/admin/master/console/","state":"d8481497-38d6-418e-ae2d-4fe9d4246386","code_challenge":"ObJCjtksAdhmEpf0B-Y4M1K5GGy-KwHjSuo7DtwNVgI"}}	local	local	1
8990191d-5042-4b09-b0cf-64f6ab970e7a	705ad0df-a1a6-4b27-882a-e8bfc28a0edf	0	1749393627	{"authMethod":"openid-connect","redirectUri":"http://localhost:3000","notes":{"clientId":"705ad0df-a1a6-4b27-882a-e8bfc28a0edf","iss":"http://auth.bettergr.org/realms/betterGR","startedAt":"1749391879","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"9ed49f90-c056-455a-b028-fd1d9004b6c2","response_mode":"fragment","scope":"openid","userSessionStartedAt":"1749391879","redirect_uri":"http://localhost:3000","state":"5fc79c49-805c-4e41-ae86-6af925cd3938","prompt":"login","code_challenge":"bY8FboWppXhU9kDRREnmUqYHhb7JJYgBCIyxRdaTi1I"}}	local	local	18
6a8350ec-56a8-4f0f-99f6-b2471adb0df6	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	0	1749392861	{"authMethod":"openid-connect","redirectUri":"http://localhost:8080/admin/master/console/#/betterGR/clients","notes":{"clientId":"a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2","iss":"http://localhost:8080/realms/master","startedAt":"1749392860","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"2c019f93-57a6-4c0d-8af4-9cd1bb53caae","response_mode":"query","scope":"openid","userSessionStartedAt":"1749392860","redirect_uri":"http://localhost:8080/admin/master/console/#/betterGR/clients","state":"29e73df1-585c-4b1c-986a-9ecff304643f","code_challenge":"cE1aD7N0khfaALIWYp_JtKTGwfkvqetTEF11B8i7Y9Y"}}	local	local	1
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
6a8350ec-56a8-4f0f-99f6-b2471adb0df6	25d09a58-ae64-4012-83f1-1e786133f483	071eec07-9d0a-411e-bf21-78c3daf9b724	1749392860	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749392860","authenticators-completed":"{\\"f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f\\":1749392860}"},"state":"LOGGED_IN"}	1749392861	\N	1
8990191d-5042-4b09-b0cf-64f6ab970e7a	123456789	betterGR	1749391879	0	{"ipAddress":"172.19.0.4","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC40Iiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749393361","authenticators-completed":"{\\"0f812a08-ee80-4c67-af19-0830e1aa83e7\\":1749393361}"},"state":"LOGGED_IN"}	1749393627	\N	19
abb0c4f9-57e8-41b4-a20c-4e9be577596d	25d09a58-ae64-4012-83f1-1e786133f483	071eec07-9d0a-411e-bf21-78c3daf9b724	1749396207	0	{"ipAddress":"172.22.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMjIuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749396207","authenticators-completed":"{\\"f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f\\":1749396207}"},"state":"LOGGED_IN"}	1749396208	\N	1
8b4b5fb1-290b-4905-9ea4-5dbedbb630a3	25d09a58-ae64-4012-83f1-1e786133f483	071eec07-9d0a-411e-bf21-78c3daf9b724	1749396452	0	{"ipAddress":"172.22.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMjIuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749396452","authenticators-completed":"{\\"f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f\\":1749396452,\\"539f9f6a-dcf6-495e-8b37-163106090dde\\":1749397284}"},"state":"LOGGED_IN"}	1749397285	\N	4
ca02c447-19c5-428b-85ed-09ff7430de35	25d09a58-ae64-4012-83f1-1e786133f483	071eec07-9d0a-411e-bf21-78c3daf9b724	1749399203	0	{"ipAddress":"172.22.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMjIuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749399203","authenticators-completed":"{\\"f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f\\":1749399203}"},"state":"LOGGED_IN"}	1749399203	\N	0
476c96a9-042e-46ff-a174-33b522b64c1f	25d09a58-ae64-4012-83f1-1e786133f483	071eec07-9d0a-411e-bf21-78c3daf9b724	1749402524	0	{"ipAddress":"192.168.240.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxOTIuMTY4LjI0MC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzNi4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1749402524","authenticators-completed":"{\\"f8c7b9b6-8528-4c5f-8624-38feaf1c7e9f\\":1749402524}"},"state":"LOGGED_IN"}	1749402524	\N	0
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
45ab7c79-1bf2-434c-815e-f0238e26f350	audience resolve	openid-connect	oidc-audience-resolve-mapper	10355e4f-861d-46fb-86a7-a73b8d637d8f	\N
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	locale	openid-connect	oidc-usermodel-attribute-mapper	a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	\N
b79e1dce-5360-49ac-84eb-20615404df91	role list	saml	saml-role-list-mapper	\N	f3369179-1936-4363-be4c-612ce66ebd81
6581456f-0735-4d3e-bad5-f6615f867bff	organization	saml	saml-organization-membership-mapper	\N	1948f5af-be4c-4aac-a7dc-cdd6cbeabff2
85abc8de-c560-40c6-bea6-ba382db61edc	full name	openid-connect	oidc-full-name-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
61279df2-3905-4035-87e9-be7f69e63b38	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
bcca526a-9c3c-47a4-a942-1d1390179e93	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	username	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
93430089-e365-4742-bce6-005e15399a77	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
46fba369-f4fd-4e2b-8a20-8ff975bd979a	website	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
f33d057b-0e99-414b-9128-933c851c62aa	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
69f93bc4-9da7-49c6-8131-ae7b773ea117	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	5a1ecb3f-c78e-4462-810b-1615182370bb
0242acd9-f6e5-46c5-a8c3-2c080eebe687	email	openid-connect	oidc-usermodel-attribute-mapper	\N	95e8b45b-479a-49cd-8e98-44f14fd4d8df
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	email verified	openid-connect	oidc-usermodel-property-mapper	\N	95e8b45b-479a-49cd-8e98-44f14fd4d8df
7a018117-04d7-4b0d-b644-d62869da0174	address	openid-connect	oidc-address-mapper	\N	89e7dc7e-f0be-4abd-bda4-ea47d09d107a
04c212c4-531f-4bb4-8c79-e10d760772ff	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	d5430628-bedf-421d-a101-5d7eac80d0d5
3282b071-16c3-47af-bc35-9c79c758e879	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	d5430628-bedf-421d-a101-5d7eac80d0d5
6291ccfe-1244-4002-bbcb-367b44749fce	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7
1f84c0a2-c83f-461e-819b-7642337d65f4	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	1a4ed92e-e6ee-4edf-b0c0-b624027e6ec7
c0131c22-2dba-46e5-9650-8f6a31f79898	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	aeb0d480-523d-4301-ba89-dd5e361d9f38
6cd241c2-885a-49ae-abc9-b3beabd9692a	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	91570a16-8ad0-4d13-b625-95e64429d882
c50e8453-baf8-4e87-8fbb-b74545ce457a	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	91570a16-8ad0-4d13-b625-95e64429d882
7b05f976-6f3d-484d-8668-3203e62084a5	acr loa level	openid-connect	oidc-acr-mapper	\N	d405913f-0ac6-4f13-85ee-74978f89435b
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	ccc21268-fbc0-49ae-af14-f270b2ac5cb0
78cfe771-8919-4166-a19c-cbef44651fc9	sub	openid-connect	oidc-sub-mapper	\N	ccc21268-fbc0-49ae-af14-f270b2ac5cb0
6819d9d3-47e9-4ad6-a640-b185cb12fa84	organization	openid-connect	oidc-organization-membership-mapper	\N	c9b851da-cf87-48cf-81f5-eee802177928
cf303131-6b20-4e70-8830-60da8408bf63	role list	saml	saml-role-list-mapper	\N	fe568452-f2fa-4273-bffd-5e6acbb17f75
2d47badf-b4fd-451a-bc11-66717e6daf02	organization	saml	saml-organization-membership-mapper	\N	8fa46a9a-dae9-4a88-a40f-25cb70fb6efe
0928cd72-9a52-455c-b667-50beb4f38315	full name	openid-connect	oidc-full-name-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
0ee5a8d4-8694-4362-aec4-868a23d38770	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
6fcf2c59-46ce-41e2-a190-4cbcc078737b	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
b8f4adda-bb9e-4f01-9940-40e6dea0377b	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
6ad29067-9c86-4af8-962c-7752c173b16e	username	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
d1cb0918-cbae-45f3-8f0b-ea803de75308	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
ef5916a8-50cf-4a7b-9eda-763dd6587049	website	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
27f50903-56e8-4d1f-a976-106123dad91f	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
962c9c61-dec6-450b-afc9-8ba04eb57066	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
74376ee8-7138-4e46-a0e3-515c0a04674e	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
375eed7d-ceac-4da4-a027-18cd349eede5	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	1808ecb0-fe6b-4e49-91fa-abdd123ba07f
9faaee08-5349-45b6-985a-1de1f60e2ff9	email	openid-connect	oidc-usermodel-attribute-mapper	\N	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c
9f52b31b-ac1b-4dc2-b1ae-15525634419a	email verified	openid-connect	oidc-usermodel-property-mapper	\N	cbabf2d4-2b6c-4ac2-bffa-1a4f4181641c
da8aaac8-03ae-4946-982a-4cff0ce2e460	address	openid-connect	oidc-address-mapper	\N	4bdc090f-3e64-4332-9b1e-41a5068105be
484f9be6-3b6a-4c31-bf4f-083a355e4af1	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	e729b22c-95a0-41c7-8956-1f2166c34bbe
0edc1610-11f1-4e77-885d-940a034e1041	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	e729b22c-95a0-41c7-8956-1f2166c34bbe
a23c2db7-3c1e-41ac-88b7-66652e1e518a	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	9a70b3e3-a9ac-41fd-8812-69a3618e8c25
cc8575c8-f20e-41cc-be7a-53d5e4728068	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	9a70b3e3-a9ac-41fd-8812-69a3618e8c25
0539086d-f51a-456a-b57d-0a5ceac9f525	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	9a70b3e3-a9ac-41fd-8812-69a3618e8c25
725416b6-3efd-49fe-bd07-aec1ff89e04e	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	fe493385-0bd9-44a2-a096-3fe041896716
05ac67dd-d7dc-4e52-b754-354aabdad0ab	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	feadc70a-c168-4cb9-ae64-0307c033bbc6
c0cd1c58-d396-44b3-ad61-4b270cf65619	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	feadc70a-c168-4cb9-ae64-0307c033bbc6
7efa7be8-a46f-449d-92b0-56769ee4b5d0	acr loa level	openid-connect	oidc-acr-mapper	\N	172f6dcc-8262-4b8b-bca9-0039345a39ba
1af7ea31-0f46-40c8-9794-8861a4a858a7	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	bdfb450d-6879-4f29-a77d-2c5370c62747
d6743f65-b27d-480f-bff6-dde7bcd6c01a	sub	openid-connect	oidc-sub-mapper	\N	bdfb450d-6879-4f29-a77d-2c5370c62747
3454e7eb-91cf-4d56-8e25-d54b523abff2	organization	openid-connect	oidc-organization-membership-mapper	\N	8ffa9364-7313-4157-84cf-696b317582e3
a565b260-7694-4d99-96c5-b28ba38b76ea	audience	openid-connect	oidc-audience-mapper	267f722f-ad05-4e35-adc6-0b64d05c0137	\N
9d29a90d-6f6b-425e-b18c-8015b9337b37	roles	openid-connect	oidc-usermodel-realm-role-mapper	267f722f-ad05-4e35-adc6-0b64d05c0137	\N
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	username as name	openid-connect	oidc-usermodel-property-mapper	267f722f-ad05-4e35-adc6-0b64d05c0137	\N
92360468-4aa3-4634-8e4a-884716e3f32d	locale	openid-connect	oidc-usermodel-attribute-mapper	2a773145-06d2-44fe-805d-c3f01c3d6377	\N
c2627150-3d87-4d89-bb8e-05e2fcb72b33	add-account-audience	openid-connect	oidc-audience-mapper	\N	e9699b76-bd3a-4d42-8e86-4c438bb22203
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	true	introspection.token.claim
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	true	userinfo.token.claim
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	locale	user.attribute
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	true	id.token.claim
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	true	access.token.claim
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	locale	claim.name
8fb918e3-ac29-4a32-8f7f-cd9ecc4ac383	String	jsonType.label
b79e1dce-5360-49ac-84eb-20615404df91	false	single
b79e1dce-5360-49ac-84eb-20615404df91	Basic	attribute.nameformat
b79e1dce-5360-49ac-84eb-20615404df91	Role	attribute.name
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	true	introspection.token.claim
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	true	userinfo.token.claim
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	username	user.attribute
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	true	id.token.claim
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	true	access.token.claim
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	preferred_username	claim.name
02fbbbd7-8d2c-4159-bcfa-02083e5ced49	String	jsonType.label
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	true	introspection.token.claim
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	true	userinfo.token.claim
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	profile	user.attribute
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	true	id.token.claim
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	true	access.token.claim
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	profile	claim.name
3ad2a5bc-aac7-48b0-a690-fac37e8153d0	String	jsonType.label
46fba369-f4fd-4e2b-8a20-8ff975bd979a	true	introspection.token.claim
46fba369-f4fd-4e2b-8a20-8ff975bd979a	true	userinfo.token.claim
46fba369-f4fd-4e2b-8a20-8ff975bd979a	website	user.attribute
46fba369-f4fd-4e2b-8a20-8ff975bd979a	true	id.token.claim
46fba369-f4fd-4e2b-8a20-8ff975bd979a	true	access.token.claim
46fba369-f4fd-4e2b-8a20-8ff975bd979a	website	claim.name
46fba369-f4fd-4e2b-8a20-8ff975bd979a	String	jsonType.label
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	true	introspection.token.claim
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	true	userinfo.token.claim
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	zoneinfo	user.attribute
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	true	id.token.claim
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	true	access.token.claim
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	zoneinfo	claim.name
4cfb13c7-7656-4ab8-ad2b-cdc47d807621	String	jsonType.label
61279df2-3905-4035-87e9-be7f69e63b38	true	introspection.token.claim
61279df2-3905-4035-87e9-be7f69e63b38	true	userinfo.token.claim
61279df2-3905-4035-87e9-be7f69e63b38	middleName	user.attribute
61279df2-3905-4035-87e9-be7f69e63b38	true	id.token.claim
61279df2-3905-4035-87e9-be7f69e63b38	true	access.token.claim
61279df2-3905-4035-87e9-be7f69e63b38	middle_name	claim.name
61279df2-3905-4035-87e9-be7f69e63b38	String	jsonType.label
69f93bc4-9da7-49c6-8131-ae7b773ea117	true	introspection.token.claim
69f93bc4-9da7-49c6-8131-ae7b773ea117	true	userinfo.token.claim
69f93bc4-9da7-49c6-8131-ae7b773ea117	locale	user.attribute
69f93bc4-9da7-49c6-8131-ae7b773ea117	true	id.token.claim
69f93bc4-9da7-49c6-8131-ae7b773ea117	true	access.token.claim
69f93bc4-9da7-49c6-8131-ae7b773ea117	locale	claim.name
69f93bc4-9da7-49c6-8131-ae7b773ea117	String	jsonType.label
85abc8de-c560-40c6-bea6-ba382db61edc	true	introspection.token.claim
85abc8de-c560-40c6-bea6-ba382db61edc	true	userinfo.token.claim
85abc8de-c560-40c6-bea6-ba382db61edc	true	id.token.claim
85abc8de-c560-40c6-bea6-ba382db61edc	true	access.token.claim
93430089-e365-4742-bce6-005e15399a77	true	introspection.token.claim
93430089-e365-4742-bce6-005e15399a77	true	userinfo.token.claim
93430089-e365-4742-bce6-005e15399a77	picture	user.attribute
93430089-e365-4742-bce6-005e15399a77	true	id.token.claim
93430089-e365-4742-bce6-005e15399a77	true	access.token.claim
93430089-e365-4742-bce6-005e15399a77	picture	claim.name
93430089-e365-4742-bce6-005e15399a77	String	jsonType.label
bcca526a-9c3c-47a4-a942-1d1390179e93	true	introspection.token.claim
bcca526a-9c3c-47a4-a942-1d1390179e93	true	userinfo.token.claim
bcca526a-9c3c-47a4-a942-1d1390179e93	nickname	user.attribute
bcca526a-9c3c-47a4-a942-1d1390179e93	true	id.token.claim
bcca526a-9c3c-47a4-a942-1d1390179e93	true	access.token.claim
bcca526a-9c3c-47a4-a942-1d1390179e93	nickname	claim.name
bcca526a-9c3c-47a4-a942-1d1390179e93	String	jsonType.label
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	true	introspection.token.claim
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	true	userinfo.token.claim
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	lastName	user.attribute
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	true	id.token.claim
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	true	access.token.claim
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	family_name	claim.name
c5ad9cdb-854b-4f97-9bb8-efb87cffa6e3	String	jsonType.label
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	true	introspection.token.claim
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	true	userinfo.token.claim
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	updatedAt	user.attribute
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	true	id.token.claim
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	true	access.token.claim
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	updated_at	claim.name
c5f87e36-fcfb-41ef-9c71-d9a24bf4a3f5	long	jsonType.label
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	true	introspection.token.claim
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	true	userinfo.token.claim
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	birthdate	user.attribute
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	true	id.token.claim
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	true	access.token.claim
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	birthdate	claim.name
cd4f3821-1f7d-4816-a06b-d15e34de3ca8	String	jsonType.label
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	true	introspection.token.claim
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	true	userinfo.token.claim
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	firstName	user.attribute
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	true	id.token.claim
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	true	access.token.claim
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	given_name	claim.name
e0cd62cb-cf87-49c7-b430-c8fb57fe0cac	String	jsonType.label
f33d057b-0e99-414b-9128-933c851c62aa	true	introspection.token.claim
f33d057b-0e99-414b-9128-933c851c62aa	true	userinfo.token.claim
f33d057b-0e99-414b-9128-933c851c62aa	gender	user.attribute
f33d057b-0e99-414b-9128-933c851c62aa	true	id.token.claim
f33d057b-0e99-414b-9128-933c851c62aa	true	access.token.claim
f33d057b-0e99-414b-9128-933c851c62aa	gender	claim.name
f33d057b-0e99-414b-9128-933c851c62aa	String	jsonType.label
0242acd9-f6e5-46c5-a8c3-2c080eebe687	true	introspection.token.claim
0242acd9-f6e5-46c5-a8c3-2c080eebe687	true	userinfo.token.claim
0242acd9-f6e5-46c5-a8c3-2c080eebe687	email	user.attribute
0242acd9-f6e5-46c5-a8c3-2c080eebe687	true	id.token.claim
0242acd9-f6e5-46c5-a8c3-2c080eebe687	true	access.token.claim
0242acd9-f6e5-46c5-a8c3-2c080eebe687	email	claim.name
0242acd9-f6e5-46c5-a8c3-2c080eebe687	String	jsonType.label
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	true	introspection.token.claim
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	true	userinfo.token.claim
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	emailVerified	user.attribute
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	true	id.token.claim
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	true	access.token.claim
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	email_verified	claim.name
c1a0319e-d307-45d9-ae05-59a4ff9f4c7a	boolean	jsonType.label
7a018117-04d7-4b0d-b644-d62869da0174	formatted	user.attribute.formatted
7a018117-04d7-4b0d-b644-d62869da0174	country	user.attribute.country
7a018117-04d7-4b0d-b644-d62869da0174	true	introspection.token.claim
7a018117-04d7-4b0d-b644-d62869da0174	postal_code	user.attribute.postal_code
7a018117-04d7-4b0d-b644-d62869da0174	true	userinfo.token.claim
7a018117-04d7-4b0d-b644-d62869da0174	street	user.attribute.street
7a018117-04d7-4b0d-b644-d62869da0174	true	id.token.claim
7a018117-04d7-4b0d-b644-d62869da0174	region	user.attribute.region
7a018117-04d7-4b0d-b644-d62869da0174	true	access.token.claim
7a018117-04d7-4b0d-b644-d62869da0174	locality	user.attribute.locality
04c212c4-531f-4bb4-8c79-e10d760772ff	true	introspection.token.claim
04c212c4-531f-4bb4-8c79-e10d760772ff	true	userinfo.token.claim
04c212c4-531f-4bb4-8c79-e10d760772ff	phoneNumber	user.attribute
04c212c4-531f-4bb4-8c79-e10d760772ff	true	id.token.claim
04c212c4-531f-4bb4-8c79-e10d760772ff	true	access.token.claim
04c212c4-531f-4bb4-8c79-e10d760772ff	phone_number	claim.name
04c212c4-531f-4bb4-8c79-e10d760772ff	String	jsonType.label
3282b071-16c3-47af-bc35-9c79c758e879	true	introspection.token.claim
3282b071-16c3-47af-bc35-9c79c758e879	true	userinfo.token.claim
3282b071-16c3-47af-bc35-9c79c758e879	phoneNumberVerified	user.attribute
3282b071-16c3-47af-bc35-9c79c758e879	true	id.token.claim
3282b071-16c3-47af-bc35-9c79c758e879	true	access.token.claim
3282b071-16c3-47af-bc35-9c79c758e879	phone_number_verified	claim.name
3282b071-16c3-47af-bc35-9c79c758e879	boolean	jsonType.label
1f84c0a2-c83f-461e-819b-7642337d65f4	true	introspection.token.claim
1f84c0a2-c83f-461e-819b-7642337d65f4	true	access.token.claim
6291ccfe-1244-4002-bbcb-367b44749fce	true	introspection.token.claim
6291ccfe-1244-4002-bbcb-367b44749fce	true	multivalued
6291ccfe-1244-4002-bbcb-367b44749fce	foo	user.attribute
6291ccfe-1244-4002-bbcb-367b44749fce	true	access.token.claim
6291ccfe-1244-4002-bbcb-367b44749fce	realm_access.roles	claim.name
6291ccfe-1244-4002-bbcb-367b44749fce	String	jsonType.label
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	true	introspection.token.claim
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	true	multivalued
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	foo	user.attribute
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	true	access.token.claim
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	resource_access.${client_id}.roles	claim.name
c041fe54-5ef4-47e4-bc5e-e148d8a8e7b4	String	jsonType.label
c0131c22-2dba-46e5-9650-8f6a31f79898	true	introspection.token.claim
c0131c22-2dba-46e5-9650-8f6a31f79898	true	access.token.claim
6cd241c2-885a-49ae-abc9-b3beabd9692a	true	introspection.token.claim
6cd241c2-885a-49ae-abc9-b3beabd9692a	true	userinfo.token.claim
6cd241c2-885a-49ae-abc9-b3beabd9692a	username	user.attribute
6cd241c2-885a-49ae-abc9-b3beabd9692a	true	id.token.claim
6cd241c2-885a-49ae-abc9-b3beabd9692a	true	access.token.claim
6cd241c2-885a-49ae-abc9-b3beabd9692a	upn	claim.name
6cd241c2-885a-49ae-abc9-b3beabd9692a	String	jsonType.label
c50e8453-baf8-4e87-8fbb-b74545ce457a	true	introspection.token.claim
c50e8453-baf8-4e87-8fbb-b74545ce457a	true	multivalued
c50e8453-baf8-4e87-8fbb-b74545ce457a	foo	user.attribute
c50e8453-baf8-4e87-8fbb-b74545ce457a	true	id.token.claim
c50e8453-baf8-4e87-8fbb-b74545ce457a	true	access.token.claim
c50e8453-baf8-4e87-8fbb-b74545ce457a	groups	claim.name
c50e8453-baf8-4e87-8fbb-b74545ce457a	String	jsonType.label
7b05f976-6f3d-484d-8668-3203e62084a5	true	introspection.token.claim
7b05f976-6f3d-484d-8668-3203e62084a5	true	id.token.claim
7b05f976-6f3d-484d-8668-3203e62084a5	true	access.token.claim
78cfe771-8919-4166-a19c-cbef44651fc9	true	introspection.token.claim
78cfe771-8919-4166-a19c-cbef44651fc9	true	access.token.claim
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	AUTH_TIME	user.session.note
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	true	introspection.token.claim
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	true	id.token.claim
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	true	access.token.claim
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	auth_time	claim.name
ac65dd07-e2b0-46ec-ae13-4d6a00285e23	long	jsonType.label
6819d9d3-47e9-4ad6-a640-b185cb12fa84	true	introspection.token.claim
6819d9d3-47e9-4ad6-a640-b185cb12fa84	true	multivalued
6819d9d3-47e9-4ad6-a640-b185cb12fa84	true	id.token.claim
6819d9d3-47e9-4ad6-a640-b185cb12fa84	true	access.token.claim
6819d9d3-47e9-4ad6-a640-b185cb12fa84	organization	claim.name
6819d9d3-47e9-4ad6-a640-b185cb12fa84	String	jsonType.label
cf303131-6b20-4e70-8830-60da8408bf63	false	single
cf303131-6b20-4e70-8830-60da8408bf63	Basic	attribute.nameformat
cf303131-6b20-4e70-8830-60da8408bf63	Role	attribute.name
0928cd72-9a52-455c-b667-50beb4f38315	true	introspection.token.claim
0928cd72-9a52-455c-b667-50beb4f38315	true	userinfo.token.claim
0928cd72-9a52-455c-b667-50beb4f38315	true	id.token.claim
0928cd72-9a52-455c-b667-50beb4f38315	true	access.token.claim
0ee5a8d4-8694-4362-aec4-868a23d38770	true	introspection.token.claim
0ee5a8d4-8694-4362-aec4-868a23d38770	true	userinfo.token.claim
0ee5a8d4-8694-4362-aec4-868a23d38770	firstName	user.attribute
0ee5a8d4-8694-4362-aec4-868a23d38770	true	id.token.claim
0ee5a8d4-8694-4362-aec4-868a23d38770	true	access.token.claim
0ee5a8d4-8694-4362-aec4-868a23d38770	given_name	claim.name
0ee5a8d4-8694-4362-aec4-868a23d38770	String	jsonType.label
27f50903-56e8-4d1f-a976-106123dad91f	true	introspection.token.claim
27f50903-56e8-4d1f-a976-106123dad91f	true	userinfo.token.claim
27f50903-56e8-4d1f-a976-106123dad91f	birthdate	user.attribute
27f50903-56e8-4d1f-a976-106123dad91f	true	id.token.claim
27f50903-56e8-4d1f-a976-106123dad91f	true	access.token.claim
27f50903-56e8-4d1f-a976-106123dad91f	birthdate	claim.name
27f50903-56e8-4d1f-a976-106123dad91f	String	jsonType.label
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	true	introspection.token.claim
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	true	userinfo.token.claim
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	gender	user.attribute
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	true	id.token.claim
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	true	access.token.claim
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	gender	claim.name
34bc46e5-9c75-4ab7-abc2-968b7ddf621a	String	jsonType.label
375eed7d-ceac-4da4-a027-18cd349eede5	true	introspection.token.claim
375eed7d-ceac-4da4-a027-18cd349eede5	true	userinfo.token.claim
375eed7d-ceac-4da4-a027-18cd349eede5	updatedAt	user.attribute
375eed7d-ceac-4da4-a027-18cd349eede5	true	id.token.claim
375eed7d-ceac-4da4-a027-18cd349eede5	true	access.token.claim
375eed7d-ceac-4da4-a027-18cd349eede5	updated_at	claim.name
375eed7d-ceac-4da4-a027-18cd349eede5	long	jsonType.label
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	true	introspection.token.claim
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	true	userinfo.token.claim
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	lastName	user.attribute
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	true	id.token.claim
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	true	access.token.claim
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	family_name	claim.name
45b70be9-be73-4c10-bfe5-8d8f1a4f331f	String	jsonType.label
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	true	introspection.token.claim
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	true	userinfo.token.claim
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	picture	user.attribute
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	true	id.token.claim
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	true	access.token.claim
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	picture	claim.name
46527658-01f2-4ec3-95b5-d4c7bdc9a40a	String	jsonType.label
6ad29067-9c86-4af8-962c-7752c173b16e	true	introspection.token.claim
6ad29067-9c86-4af8-962c-7752c173b16e	true	userinfo.token.claim
6ad29067-9c86-4af8-962c-7752c173b16e	username	user.attribute
6ad29067-9c86-4af8-962c-7752c173b16e	true	id.token.claim
6ad29067-9c86-4af8-962c-7752c173b16e	true	access.token.claim
6ad29067-9c86-4af8-962c-7752c173b16e	preferred_username	claim.name
6ad29067-9c86-4af8-962c-7752c173b16e	String	jsonType.label
6fcf2c59-46ce-41e2-a190-4cbcc078737b	true	introspection.token.claim
6fcf2c59-46ce-41e2-a190-4cbcc078737b	true	userinfo.token.claim
6fcf2c59-46ce-41e2-a190-4cbcc078737b	middleName	user.attribute
6fcf2c59-46ce-41e2-a190-4cbcc078737b	true	id.token.claim
6fcf2c59-46ce-41e2-a190-4cbcc078737b	true	access.token.claim
6fcf2c59-46ce-41e2-a190-4cbcc078737b	middle_name	claim.name
6fcf2c59-46ce-41e2-a190-4cbcc078737b	String	jsonType.label
74376ee8-7138-4e46-a0e3-515c0a04674e	true	introspection.token.claim
74376ee8-7138-4e46-a0e3-515c0a04674e	true	userinfo.token.claim
74376ee8-7138-4e46-a0e3-515c0a04674e	locale	user.attribute
74376ee8-7138-4e46-a0e3-515c0a04674e	true	id.token.claim
74376ee8-7138-4e46-a0e3-515c0a04674e	true	access.token.claim
74376ee8-7138-4e46-a0e3-515c0a04674e	locale	claim.name
74376ee8-7138-4e46-a0e3-515c0a04674e	String	jsonType.label
962c9c61-dec6-450b-afc9-8ba04eb57066	true	introspection.token.claim
962c9c61-dec6-450b-afc9-8ba04eb57066	true	userinfo.token.claim
962c9c61-dec6-450b-afc9-8ba04eb57066	zoneinfo	user.attribute
962c9c61-dec6-450b-afc9-8ba04eb57066	true	id.token.claim
962c9c61-dec6-450b-afc9-8ba04eb57066	true	access.token.claim
962c9c61-dec6-450b-afc9-8ba04eb57066	zoneinfo	claim.name
962c9c61-dec6-450b-afc9-8ba04eb57066	String	jsonType.label
b8f4adda-bb9e-4f01-9940-40e6dea0377b	true	introspection.token.claim
b8f4adda-bb9e-4f01-9940-40e6dea0377b	true	userinfo.token.claim
b8f4adda-bb9e-4f01-9940-40e6dea0377b	nickname	user.attribute
b8f4adda-bb9e-4f01-9940-40e6dea0377b	true	id.token.claim
b8f4adda-bb9e-4f01-9940-40e6dea0377b	true	access.token.claim
b8f4adda-bb9e-4f01-9940-40e6dea0377b	nickname	claim.name
b8f4adda-bb9e-4f01-9940-40e6dea0377b	String	jsonType.label
d1cb0918-cbae-45f3-8f0b-ea803de75308	true	introspection.token.claim
d1cb0918-cbae-45f3-8f0b-ea803de75308	true	userinfo.token.claim
d1cb0918-cbae-45f3-8f0b-ea803de75308	profile	user.attribute
d1cb0918-cbae-45f3-8f0b-ea803de75308	true	id.token.claim
d1cb0918-cbae-45f3-8f0b-ea803de75308	true	access.token.claim
d1cb0918-cbae-45f3-8f0b-ea803de75308	profile	claim.name
d1cb0918-cbae-45f3-8f0b-ea803de75308	String	jsonType.label
ef5916a8-50cf-4a7b-9eda-763dd6587049	true	introspection.token.claim
ef5916a8-50cf-4a7b-9eda-763dd6587049	true	userinfo.token.claim
ef5916a8-50cf-4a7b-9eda-763dd6587049	website	user.attribute
ef5916a8-50cf-4a7b-9eda-763dd6587049	true	id.token.claim
ef5916a8-50cf-4a7b-9eda-763dd6587049	true	access.token.claim
ef5916a8-50cf-4a7b-9eda-763dd6587049	website	claim.name
ef5916a8-50cf-4a7b-9eda-763dd6587049	String	jsonType.label
9f52b31b-ac1b-4dc2-b1ae-15525634419a	true	introspection.token.claim
9f52b31b-ac1b-4dc2-b1ae-15525634419a	true	userinfo.token.claim
9f52b31b-ac1b-4dc2-b1ae-15525634419a	emailVerified	user.attribute
9f52b31b-ac1b-4dc2-b1ae-15525634419a	true	id.token.claim
9f52b31b-ac1b-4dc2-b1ae-15525634419a	true	access.token.claim
9f52b31b-ac1b-4dc2-b1ae-15525634419a	email_verified	claim.name
9f52b31b-ac1b-4dc2-b1ae-15525634419a	boolean	jsonType.label
9faaee08-5349-45b6-985a-1de1f60e2ff9	true	introspection.token.claim
9faaee08-5349-45b6-985a-1de1f60e2ff9	true	userinfo.token.claim
9faaee08-5349-45b6-985a-1de1f60e2ff9	email	user.attribute
9faaee08-5349-45b6-985a-1de1f60e2ff9	true	id.token.claim
9faaee08-5349-45b6-985a-1de1f60e2ff9	true	access.token.claim
9faaee08-5349-45b6-985a-1de1f60e2ff9	email	claim.name
9faaee08-5349-45b6-985a-1de1f60e2ff9	String	jsonType.label
da8aaac8-03ae-4946-982a-4cff0ce2e460	formatted	user.attribute.formatted
da8aaac8-03ae-4946-982a-4cff0ce2e460	country	user.attribute.country
da8aaac8-03ae-4946-982a-4cff0ce2e460	true	introspection.token.claim
da8aaac8-03ae-4946-982a-4cff0ce2e460	postal_code	user.attribute.postal_code
da8aaac8-03ae-4946-982a-4cff0ce2e460	true	userinfo.token.claim
da8aaac8-03ae-4946-982a-4cff0ce2e460	street	user.attribute.street
da8aaac8-03ae-4946-982a-4cff0ce2e460	true	id.token.claim
da8aaac8-03ae-4946-982a-4cff0ce2e460	region	user.attribute.region
da8aaac8-03ae-4946-982a-4cff0ce2e460	true	access.token.claim
da8aaac8-03ae-4946-982a-4cff0ce2e460	locality	user.attribute.locality
0edc1610-11f1-4e77-885d-940a034e1041	true	introspection.token.claim
0edc1610-11f1-4e77-885d-940a034e1041	true	userinfo.token.claim
0edc1610-11f1-4e77-885d-940a034e1041	phoneNumberVerified	user.attribute
0edc1610-11f1-4e77-885d-940a034e1041	true	id.token.claim
0edc1610-11f1-4e77-885d-940a034e1041	true	access.token.claim
0edc1610-11f1-4e77-885d-940a034e1041	phone_number_verified	claim.name
0edc1610-11f1-4e77-885d-940a034e1041	boolean	jsonType.label
484f9be6-3b6a-4c31-bf4f-083a355e4af1	true	introspection.token.claim
484f9be6-3b6a-4c31-bf4f-083a355e4af1	true	userinfo.token.claim
484f9be6-3b6a-4c31-bf4f-083a355e4af1	phoneNumber	user.attribute
484f9be6-3b6a-4c31-bf4f-083a355e4af1	true	id.token.claim
484f9be6-3b6a-4c31-bf4f-083a355e4af1	true	access.token.claim
484f9be6-3b6a-4c31-bf4f-083a355e4af1	phone_number	claim.name
484f9be6-3b6a-4c31-bf4f-083a355e4af1	String	jsonType.label
0539086d-f51a-456a-b57d-0a5ceac9f525	true	introspection.token.claim
0539086d-f51a-456a-b57d-0a5ceac9f525	true	access.token.claim
a23c2db7-3c1e-41ac-88b7-66652e1e518a	true	introspection.token.claim
a23c2db7-3c1e-41ac-88b7-66652e1e518a	true	multivalued
a23c2db7-3c1e-41ac-88b7-66652e1e518a	foo	user.attribute
a23c2db7-3c1e-41ac-88b7-66652e1e518a	true	access.token.claim
a23c2db7-3c1e-41ac-88b7-66652e1e518a	realm_access.roles	claim.name
a23c2db7-3c1e-41ac-88b7-66652e1e518a	String	jsonType.label
cc8575c8-f20e-41cc-be7a-53d5e4728068	true	introspection.token.claim
cc8575c8-f20e-41cc-be7a-53d5e4728068	true	multivalued
cc8575c8-f20e-41cc-be7a-53d5e4728068	foo	user.attribute
cc8575c8-f20e-41cc-be7a-53d5e4728068	true	access.token.claim
cc8575c8-f20e-41cc-be7a-53d5e4728068	resource_access.${client_id}.roles	claim.name
cc8575c8-f20e-41cc-be7a-53d5e4728068	String	jsonType.label
725416b6-3efd-49fe-bd07-aec1ff89e04e	true	introspection.token.claim
725416b6-3efd-49fe-bd07-aec1ff89e04e	true	access.token.claim
05ac67dd-d7dc-4e52-b754-354aabdad0ab	true	introspection.token.claim
05ac67dd-d7dc-4e52-b754-354aabdad0ab	true	userinfo.token.claim
05ac67dd-d7dc-4e52-b754-354aabdad0ab	username	user.attribute
05ac67dd-d7dc-4e52-b754-354aabdad0ab	true	id.token.claim
05ac67dd-d7dc-4e52-b754-354aabdad0ab	true	access.token.claim
05ac67dd-d7dc-4e52-b754-354aabdad0ab	upn	claim.name
05ac67dd-d7dc-4e52-b754-354aabdad0ab	String	jsonType.label
c0cd1c58-d396-44b3-ad61-4b270cf65619	true	introspection.token.claim
c0cd1c58-d396-44b3-ad61-4b270cf65619	true	multivalued
c0cd1c58-d396-44b3-ad61-4b270cf65619	foo	user.attribute
c0cd1c58-d396-44b3-ad61-4b270cf65619	true	id.token.claim
c0cd1c58-d396-44b3-ad61-4b270cf65619	true	access.token.claim
c0cd1c58-d396-44b3-ad61-4b270cf65619	groups	claim.name
c0cd1c58-d396-44b3-ad61-4b270cf65619	String	jsonType.label
7efa7be8-a46f-449d-92b0-56769ee4b5d0	true	introspection.token.claim
7efa7be8-a46f-449d-92b0-56769ee4b5d0	true	id.token.claim
7efa7be8-a46f-449d-92b0-56769ee4b5d0	true	access.token.claim
1af7ea31-0f46-40c8-9794-8861a4a858a7	AUTH_TIME	user.session.note
1af7ea31-0f46-40c8-9794-8861a4a858a7	true	introspection.token.claim
1af7ea31-0f46-40c8-9794-8861a4a858a7	true	id.token.claim
1af7ea31-0f46-40c8-9794-8861a4a858a7	true	access.token.claim
1af7ea31-0f46-40c8-9794-8861a4a858a7	auth_time	claim.name
1af7ea31-0f46-40c8-9794-8861a4a858a7	long	jsonType.label
d6743f65-b27d-480f-bff6-dde7bcd6c01a	true	introspection.token.claim
d6743f65-b27d-480f-bff6-dde7bcd6c01a	true	access.token.claim
3454e7eb-91cf-4d56-8e25-d54b523abff2	true	introspection.token.claim
3454e7eb-91cf-4d56-8e25-d54b523abff2	true	multivalued
3454e7eb-91cf-4d56-8e25-d54b523abff2	true	id.token.claim
3454e7eb-91cf-4d56-8e25-d54b523abff2	true	access.token.claim
3454e7eb-91cf-4d56-8e25-d54b523abff2	organization	claim.name
3454e7eb-91cf-4d56-8e25-d54b523abff2	String	jsonType.label
9d29a90d-6f6b-425e-b18c-8015b9337b37	true	id.token.claim
9d29a90d-6f6b-425e-b18c-8015b9337b37	true	access.token.claim
9d29a90d-6f6b-425e-b18c-8015b9337b37	realm_access.roles	claim.name
9d29a90d-6f6b-425e-b18c-8015b9337b37	String	jsonType.label
9d29a90d-6f6b-425e-b18c-8015b9337b37	true	multivalued
9d29a90d-6f6b-425e-b18c-8015b9337b37	true	userinfo.token.claim
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	username	user.attribute
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	true	id.token.claim
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	true	access.token.claim
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	name	claim.name
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	String	jsonType.label
9d8cbb06-4435-4a97-ab46-906b7e5e0aa1	true	userinfo.token.claim
a565b260-7694-4d99-96c5-b28ba38b76ea	account	included.client.audience
a565b260-7694-4d99-96c5-b28ba38b76ea	true	id.token.claim
a565b260-7694-4d99-96c5-b28ba38b76ea	true	access.token.claim
a565b260-7694-4d99-96c5-b28ba38b76ea	true	userinfo.token.claim
92360468-4aa3-4634-8e4a-884716e3f32d	true	introspection.token.claim
92360468-4aa3-4634-8e4a-884716e3f32d	true	userinfo.token.claim
92360468-4aa3-4634-8e4a-884716e3f32d	locale	user.attribute
92360468-4aa3-4634-8e4a-884716e3f32d	true	id.token.claim
92360468-4aa3-4634-8e4a-884716e3f32d	true	access.token.claim
92360468-4aa3-4634-8e4a-884716e3f32d	locale	claim.name
92360468-4aa3-4634-8e4a-884716e3f32d	String	jsonType.label
c2627150-3d87-4d89-bb8e-05e2fcb72b33	account	included.client.audience
c2627150-3d87-4d89-bb8e-05e2fcb72b33	true	id.token.claim
c2627150-3d87-4d89-bb8e-05e2fcb72b33	false	lightweight.claim
c2627150-3d87-4d89-bb8e-05e2fcb72b33	true	access.token.claim
c2627150-3d87-4d89-bb8e-05e2fcb72b33	true	introspection.token.claim
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
betterGR	60	300	300	\N	\N	\N	t	f	0	betterGR	betterGR	0	\N	f	f	t	f	EXTERNAL	1800	36000	f	f	0a1285a6-2774-4a38-be03-cf7b305bb0f2	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	c8dbd0bf-efd6-4eab-a155-a8df46e3e66f	6dcbeaa0-e548-4f39-8fbd-23861b87c019	80cbc004-0fd5-4477-b3ab-c6b22ee6d8b7	b3f2d4cc-284d-44db-9578-ca37df3db3d3	156612e7-3cf3-4bb3-84a6-b9f8d9aabe57	2592000	f	900	t	f	16cddca9-a727-4b78-a30d-605d71c543da	0	f	0	0	7ad01c08-3fce-4296-bdb2-d5df593581a9
071eec07-9d0a-411e-bf21-78c3daf9b724	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	15d31b1d-8591-4939-bc81-366fa652552f	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	843aaf52-a2f3-4d10-b574-caf696b2928a	e7b26792-c783-473f-87ab-86f1274a1c34	c420d152-6d04-4493-a038-565dd5e1ee8c	fc7e3485-e920-4b38-ae87-45408b29d3e3	786ed56a-0af4-445b-aeaf-daaff6b903d6	2592000	f	900	t	f	029ab0ed-6bb5-458f-9a9c-709e7b6677cd	0	f	0	0	cafa62b0-2f1a-443f-9fc9-20763bcb86ab
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	071eec07-9d0a-411e-bf21-78c3daf9b724	
_browser_header.xContentTypeOptions	071eec07-9d0a-411e-bf21-78c3daf9b724	nosniff
_browser_header.referrerPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	no-referrer
_browser_header.xRobotsTag	071eec07-9d0a-411e-bf21-78c3daf9b724	none
_browser_header.xFrameOptions	071eec07-9d0a-411e-bf21-78c3daf9b724	SAMEORIGIN
_browser_header.contentSecurityPolicy	071eec07-9d0a-411e-bf21-78c3daf9b724	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	071eec07-9d0a-411e-bf21-78c3daf9b724	1; mode=block
_browser_header.strictTransportSecurity	071eec07-9d0a-411e-bf21-78c3daf9b724	max-age=31536000; includeSubDomains
bruteForceProtected	071eec07-9d0a-411e-bf21-78c3daf9b724	false
permanentLockout	071eec07-9d0a-411e-bf21-78c3daf9b724	false
maxTemporaryLockouts	071eec07-9d0a-411e-bf21-78c3daf9b724	0
bruteForceStrategy	071eec07-9d0a-411e-bf21-78c3daf9b724	MULTIPLE
maxFailureWaitSeconds	071eec07-9d0a-411e-bf21-78c3daf9b724	900
minimumQuickLoginWaitSeconds	071eec07-9d0a-411e-bf21-78c3daf9b724	60
waitIncrementSeconds	071eec07-9d0a-411e-bf21-78c3daf9b724	60
quickLoginCheckMilliSeconds	071eec07-9d0a-411e-bf21-78c3daf9b724	1000
maxDeltaTimeSeconds	071eec07-9d0a-411e-bf21-78c3daf9b724	43200
failureFactor	071eec07-9d0a-411e-bf21-78c3daf9b724	30
realmReusableOtpCode	071eec07-9d0a-411e-bf21-78c3daf9b724	false
firstBrokerLoginFlowId	071eec07-9d0a-411e-bf21-78c3daf9b724	360a664c-63d9-4c2c-afa9-d86aab6fe6f5
displayName	071eec07-9d0a-411e-bf21-78c3daf9b724	Keycloak
displayNameHtml	071eec07-9d0a-411e-bf21-78c3daf9b724	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	071eec07-9d0a-411e-bf21-78c3daf9b724	RS256
offlineSessionMaxLifespanEnabled	071eec07-9d0a-411e-bf21-78c3daf9b724	false
offlineSessionMaxLifespan	071eec07-9d0a-411e-bf21-78c3daf9b724	5184000
bruteForceProtected	betterGR	false
permanentLockout	betterGR	false
maxTemporaryLockouts	betterGR	0
bruteForceStrategy	betterGR	MULTIPLE
maxFailureWaitSeconds	betterGR	900
minimumQuickLoginWaitSeconds	betterGR	60
waitIncrementSeconds	betterGR	60
quickLoginCheckMilliSeconds	betterGR	1000
maxDeltaTimeSeconds	betterGR	43200
failureFactor	betterGR	30
realmReusableOtpCode	betterGR	false
defaultSignatureAlgorithm	betterGR	RS256
offlineSessionMaxLifespanEnabled	betterGR	false
offlineSessionMaxLifespan	betterGR	5184000
actionTokenGeneratedByAdminLifespan	betterGR	43200
actionTokenGeneratedByUserLifespan	betterGR	300
oauth2DeviceCodeLifespan	betterGR	600
oauth2DevicePollingInterval	betterGR	5
webAuthnPolicyRpEntityName	betterGR	keycloak
webAuthnPolicySignatureAlgorithms	betterGR	ES256,RS256
webAuthnPolicyRpId	betterGR	
webAuthnPolicyAttestationConveyancePreference	betterGR	not specified
webAuthnPolicyAuthenticatorAttachment	betterGR	not specified
webAuthnPolicyRequireResidentKey	betterGR	not specified
webAuthnPolicyUserVerificationRequirement	betterGR	not specified
webAuthnPolicyCreateTimeout	betterGR	0
webAuthnPolicyAvoidSameAuthenticatorRegister	betterGR	false
webAuthnPolicyRpEntityNamePasswordless	betterGR	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	betterGR	ES256,RS256
webAuthnPolicyRpIdPasswordless	betterGR	
webAuthnPolicyAttestationConveyancePreferencePasswordless	betterGR	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	betterGR	not specified
webAuthnPolicyRequireResidentKeyPasswordless	betterGR	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	betterGR	not specified
webAuthnPolicyCreateTimeoutPasswordless	betterGR	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	betterGR	false
cibaBackchannelTokenDeliveryMode	betterGR	poll
cibaExpiresIn	betterGR	120
cibaInterval	betterGR	5
cibaAuthRequestedUserHint	betterGR	login_hint
parRequestUriLifespan	betterGR	60
firstBrokerLoginFlowId	betterGR	07b47994-f1e1-42b7-8e80-02ae6093de96
frontendUrl	betterGR	http://auth.bettergr.org
issuer	betterGR	http://auth.bettergr.org/realms/betterGR
organizationsEnabled	betterGR	false
clientSessionIdleTimeout	betterGR	0
clientSessionMaxLifespan	betterGR	0
clientOfflineSessionIdleTimeout	betterGR	0
clientOfflineSessionMaxLifespan	betterGR	0
client-policies.profiles	betterGR	{"profiles":[]}
client-policies.policies	betterGR	{"policies":[]}
_browser_header.contentSecurityPolicyReportOnly	betterGR	
_browser_header.xContentTypeOptions	betterGR	nosniff
_browser_header.referrerPolicy	betterGR	no-referrer
_browser_header.xRobotsTag	betterGR	none
_browser_header.xFrameOptions	betterGR	SAMEORIGIN
_browser_header.contentSecurityPolicy	betterGR	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	betterGR	1; mode=block
_browser_header.strictTransportSecurity	betterGR	max-age=31536000; includeSubDomains
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
071eec07-9d0a-411e-bf21-78c3daf9b724	jboss-logging
betterGR	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	071eec07-9d0a-411e-bf21-78c3daf9b724
password	password	t	t	betterGR
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
843e3df5-4253-4c9d-a0b3-d7ca2c5beac5	/realms/master/account/*
10355e4f-861d-46fb-86a7-a73b8d637d8f	/realms/master/account/*
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	/admin/master/console/*
2a773145-06d2-44fe-805d-c3f01c3d6377	/admin/betterGR/console/*
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	http://localhost:3000/callback
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	http://localhost:3000/*
267f722f-ad05-4e35-adc6-0b64d05c0137	http://localhost:1234
267f722f-ad05-4e35-adc6-0b64d05c0137	http://localhost:3000/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
fc78a9bb-b57e-426a-ba4a-a10658ca4a80	VERIFY_EMAIL	Verify Email	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	VERIFY_EMAIL	50
cea0d8e7-2cfc-4e14-8327-078af98abb44	UPDATE_PROFILE	Update Profile	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	UPDATE_PROFILE	40
1b74b45e-cec6-45ae-8cd4-b8df75eaa8c0	CONFIGURE_TOTP	Configure OTP	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	CONFIGURE_TOTP	10
322f6d9b-0016-407c-9f1a-aeb19c8a5851	UPDATE_PASSWORD	Update Password	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	UPDATE_PASSWORD	30
a7ebb91c-e71a-4935-bff0-3aca2f3c29cf	TERMS_AND_CONDITIONS	Terms and Conditions	071eec07-9d0a-411e-bf21-78c3daf9b724	f	f	TERMS_AND_CONDITIONS	20
2f4c5254-9f3a-4809-80f0-aa9a4284ef63	delete_account	Delete Account	071eec07-9d0a-411e-bf21-78c3daf9b724	f	f	delete_account	60
2df96751-60f2-4596-bdd8-525ae19b62d6	delete_credential	Delete Credential	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	delete_credential	100
84da99ed-4039-4cc3-8adf-619284d91dc4	update_user_locale	Update User Locale	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	update_user_locale	1000
4a88fa1a-bcfb-43d5-a6b7-f48512fd2868	webauthn-register	Webauthn Register	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	webauthn-register	70
3c20b03c-5593-4f69-a3a7-9a48354fb5bc	webauthn-register-passwordless	Webauthn Register Passwordless	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	webauthn-register-passwordless	80
c4438100-8fcf-420e-9b4f-a1e7a74be22b	VERIFY_PROFILE	Verify Profile	071eec07-9d0a-411e-bf21-78c3daf9b724	t	f	VERIFY_PROFILE	90
f67de60d-e7ce-41f2-9909-369847a026f8	VERIFY_EMAIL	Verify Email	betterGR	t	f	VERIFY_EMAIL	50
dd4422e7-6e34-4030-8be0-cde3cea660f5	UPDATE_PROFILE	Update Profile	betterGR	t	f	UPDATE_PROFILE	40
079b0bd0-ca8e-405a-943f-deb49659c13a	CONFIGURE_TOTP	Configure OTP	betterGR	t	f	CONFIGURE_TOTP	10
dc632fd8-3307-4f60-9431-4956ab7ac8bf	UPDATE_PASSWORD	Update Password	betterGR	t	f	UPDATE_PASSWORD	30
eff0febf-f323-4a4d-8fd1-8a32d6a358e4	TERMS_AND_CONDITIONS	Terms and Conditions	betterGR	f	f	TERMS_AND_CONDITIONS	20
6717410b-761e-400a-935c-f77a4dfba61f	delete_account	Delete Account	betterGR	f	f	delete_account	60
7b781738-f6ba-498e-b06c-057d2e246fb6	delete_credential	Delete Credential	betterGR	t	f	delete_credential	100
ccfd9c97-1fd5-4b34-8091-86ac8cd9a386	update_user_locale	Update User Locale	betterGR	t	f	update_user_locale	1000
6e7596b5-88e1-4aa4-a2d9-54ce1100e65d	webauthn-register	Webauthn Register	betterGR	t	f	webauthn-register	70
f54ed062-533c-4e88-99c2-93ea4d51c00f	webauthn-register-passwordless	Webauthn Register Passwordless	betterGR	t	f	webauthn-register-passwordless	80
d7ddabf8-fa8f-4bd1-9b97-5e58a6a2a1a8	VERIFY_PROFILE	Verify Profile	betterGR	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
10355e4f-861d-46fb-86a7-a73b8d637d8f	ce8e5b64-e6c4-49c7-a998-765bc2d9e4c8
10355e4f-861d-46fb-86a7-a73b8d637d8f	cb4f9c66-4696-4cad-932f-b5eaf1bcda9d
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	25d09a58-ae64-4012-83f1-1e786133f483	c6f0b957-8fb0-4083-a058-98fb3fa8f827	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
123456789	user1@bettergr.com	user1@bettergr.com	f	t	\N	user1	user1	betterGR	user1	\N	\N	0
987654321	user2@bettergr.com	user2@bettergr.com	f	t	\N	user2	user2	betterGR	user2	\N	\N	0
admin-id-789	admin@bettergr.com	admin@bettergr.com	f	t	\N	admin	admin	betterGR	admin	\N	\N	0
25d09a58-ae64-4012-83f1-1e786133f483	\N	9bd0ff1e-8e0d-4e59-9953-13a3baa4ee5f	f	t	\N	\N	\N	071eec07-9d0a-411e-bf21-78c3daf9b724	admin	1746299509028	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
student-role	123456789
student-role	987654321
staff-role	admin-id-789
cafa62b0-2f1a-443f-9fc9-20763bcb86ab	25d09a58-ae64-4012-83f1-1e786133f483
618d2a57-95e4-4df5-a7fe-cc9d6bd99c32	25d09a58-ae64-4012-83f1-1e786133f483
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
a1cb0d23-ca6b-4681-a342-2bbda2e3c1f2	+
2a773145-06d2-44fe-805d-c3f01c3d6377	+
705ad0df-a1a6-4b27-882a-e8bfc28a0edf	http://localhost:3000
267f722f-ad05-4e35-adc6-0b64d05c0137	http://localhost:3000
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

