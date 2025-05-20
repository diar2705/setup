--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

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

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    announcement_id text NOT NULL,
    course_id text NOT NULL,
    title text,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: course_staffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_staffs (
    course_id text NOT NULL,
    staff_id text NOT NULL
);


ALTER TABLE public.course_staffs OWNER TO postgres;

--
-- Name: course_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_students (
    course_id text NOT NULL,
    student_id text NOT NULL
);


ALTER TABLE public.course_students OWNER TO postgres;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id text NOT NULL,
    course_name text NOT NULL,
    semester text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    student_id text NOT NULL,
    course_id text NOT NULL,
    semester text NOT NULL,
    grade_type text NOT NULL,
    grade_value text NOT NULL,
    graded_by text,
    comments text,
    graded_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    grade_id text,
    item_id text
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- Name: homework; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.homework (
    homework_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    course_id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    workflow text NOT NULL,
    due_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.homework OWNER TO postgres;

--
-- Name: staff_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_members (
    staff_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    phone_number text NOT NULL,
    title text,
    office text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.staff_members OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    phone_number text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submissions (
    submission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    homework_id uuid NOT NULL,
    student_id text NOT NULL,
    submitted_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.submissions OWNER TO postgres;

--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

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


--
-- Data for Name: course_staffs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_staffs (course_id, staff_id) FROM stdin;
236781	112233445
234311	214213213
\.


--
-- Data for Name: course_students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_students (course_id, student_id) FROM stdin;
234311	123456789
234311	987654321
236781	123456789
236781	987654321
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, course_name, semester, description, created_at, updated_at) FROM stdin;
234311	Yearly Project	Winter_2025	The Yearly Project in Software Engineering	2025-03-02 11:05:11.18368	2025-03-02 21:06:08.216453
236781	Deep Learning	Winter_2025	Deep Learning on Computational Accelerators	2025-03-02 11:05:11.190321	2025-03-02 21:06:08.216453
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

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


--
-- Data for Name: homework; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.homework (homework_id, course_id, title, description, workflow, due_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: staff_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_members (staff_id, first_name, last_name, email, phone_number, title, office, created_at, updated_at) FROM stdin;
112233445	Sabry	Assaf	Sabry@hotmail.com	0529966309	Professor		2025-03-02 11:04:45.416686	2025-03-02 11:04:45.416686
214213213	Atheer	Alsharif	Atheer@google.com	0505500569	Software Engineer		2025-03-02 11:04:45.424663	2025-03-02 11:04:45.424663
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, first_name, last_name, email, phone_number, created_at, updated_at) FROM stdin;
123456789	Maroon	Ayoub	vMaroon@technion.ac.il	0524206699	2025-03-02 11:03:16.866018	2025-03-02 11:03:16.866018
987654321	Rick	Astley	NeverGonna@giveyou.up	0526666666	2025-03-02 11:03:16.878981	2025-03-02 11:03:16.878981
\.


--
-- Data for Name: submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submissions (submission_id, homework_id, student_id, submitted_at, updated_at) FROM stdin;
\.


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id, course_id);


--
-- Name: course_staffs course_staffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_staffs
    ADD CONSTRAINT course_staffs_pkey PRIMARY KEY (course_id, staff_id);


--
-- Name: course_students course_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_students
    ADD CONSTRAINT course_students_pkey PRIMARY KEY (course_id, student_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (student_id, course_id, semester, grade_type);


--
-- Name: homework homework_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homework
    ADD CONSTRAINT homework_pkey PRIMARY KEY (homework_id);


--
-- Name: staff_members staff_members_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_email_key UNIQUE (email);


--
-- Name: staff_members staff_members_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_phone_number_key UNIQUE (phone_number);


--
-- Name: staff_members staff_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_pkey PRIMARY KEY (staff_id);


--
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- Name: students students_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_phone_number_key UNIQUE (phone_number);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (submission_id);


--
-- Name: idx_course_staff_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_staff_course_id ON public.course_staffs USING btree (course_id);


--
-- Name: idx_course_staff_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_staff_staff_id ON public.course_staffs USING btree (staff_id);


--
-- Name: idx_course_student_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_student_course_id ON public.course_students USING btree (course_id);


--
-- Name: idx_course_student_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_student_student_id ON public.course_students USING btree (student_id);


--
-- Name: idx_grade_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_grade_course_id ON public.grades USING btree (course_id);


--
-- Name: idx_grade_semester; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_grade_semester ON public.grades USING btree (semester);


--
-- Name: idx_grade_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_grade_student_id ON public.grades USING btree (student_id);


--
-- Name: idx_homework_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_homework_course_id ON public.homework USING btree (course_id);


--
-- Name: idx_submission_homework_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_submission_homework_id ON public.submissions USING btree (homework_id);


--
-- Name: idx_submission_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_submission_student_id ON public.submissions USING btree (student_id);


--
-- Name: announcements trigger_announcements_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_announcements_updated_at BEFORE UPDATE ON public.announcements FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: courses trigger_courses_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_courses_updated_at BEFORE UPDATE ON public.courses FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: grades trigger_grades_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_grades_updated_at BEFORE UPDATE ON public.grades FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: homework trigger_homework_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_homework_updated_at BEFORE UPDATE ON public.homework FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: staff_members trigger_staff_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_staff_updated_at BEFORE UPDATE ON public.staff_members FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: students trigger_students_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_students_updated_at BEFORE UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: submissions trigger_submissions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_submissions_updated_at BEFORE UPDATE ON public.submissions FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: announcements announcements_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_staffs course_staffs_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_staffs
    ADD CONSTRAINT course_staffs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_staffs course_staffs_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_staffs
    ADD CONSTRAINT course_staffs_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff_members(staff_id) ON DELETE CASCADE;


--
-- Name: course_students course_students_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_students
    ADD CONSTRAINT course_students_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_students course_students_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_students
    ADD CONSTRAINT course_students_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: grades grades_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: grades grades_graded_by_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_graded_by_course_id_fkey FOREIGN KEY (graded_by, course_id) REFERENCES public.course_staffs(staff_id, course_id) ON DELETE CASCADE;


--
-- Name: grades grades_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.staff_members(staff_id) ON DELETE SET NULL;


--
-- Name: grades grades_student_id_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_student_id_course_id_fkey FOREIGN KEY (student_id, course_id) REFERENCES public.course_students(student_id, course_id) ON DELETE CASCADE;


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: homework homework_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homework
    ADD CONSTRAINT homework_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: submissions submissions_homework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_homework_id_fkey FOREIGN KEY (homework_id) REFERENCES public.homework(homework_id) ON DELETE CASCADE;


--
-- Name: submissions submissions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

