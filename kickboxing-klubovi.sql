--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-11-02 10:43:53

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'WIN1250';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 18182)
-- Name: osoba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.osoba (
    briskaznice integer NOT NULL,
    ime character varying(30) NOT NULL,
    prezime character varying(30) NOT NULL,
    "datumro�enja" date NOT NULL,
    oib character varying(11) NOT NULL,
    klubid integer NOT NULL
);


ALTER TABLE public.osoba OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 18195)
-- Name: �lan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."�lan" (
    uzrast character varying(10) NOT NULL,
    "te�ina" character varying(10) NOT NULL,
    spol character varying(1) NOT NULL,
    oib character varying(11) NOT NULL
);


ALTER TABLE public."�lan" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18225)
-- Name: clanosoba; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clanosoba AS
 SELECT osoba.oib,
    osoba.briskaznice,
    osoba.ime,
    osoba.prezime,
    osoba."datumro�enja",
    osoba.klubid,
    "�lan".uzrast,
    "�lan"."te�ina",
    "�lan".spol
   FROM (public.osoba
     JOIN public."�lan" USING (oib));


ALTER TABLE public.clanosoba OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 18175)
-- Name: klub; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klub (
    naziv character varying(50) NOT NULL,
    klubid integer NOT NULL,
    godinaosnivanja integer NOT NULL,
    "sjedi�te" character varying(30) NOT NULL,
    "dr�ava" character varying(30) NOT NULL,
    email character varying(50) NOT NULL
);


ALTER TABLE public.klub OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 18215)
-- Name: kickboxingklubovijson; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(row_to_json("�lan".*)) AS json_agg
           FROM (public."�lan"
             LEFT JOIN public.osoba USING (oib))
          WHERE (klub.klubid = osoba.klubid)) AS json_agg
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18220)
-- Name: kickboxingklubovijson1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson1 AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(row_to_json("�lan".*)) AS json_agg
           FROM (public."�lan"
             JOIN public.osoba USING (oib))
          WHERE (klub.klubid = osoba.klubid)) AS "�lanovi"
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson1 OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18229)
-- Name: kickboxingklubovijson2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson2 AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(clanosoba.*) AS json_agg
           FROM public.clanosoba
          WHERE (klub.klubid = clanosoba.klubid)) AS "�lanovi"
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson2 OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 18205)
-- Name: trener; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trener (
    licencado date NOT NULL,
    oib character varying(11) NOT NULL
);


ALTER TABLE public.trener OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18233)
-- Name: trenerosoba; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trenerosoba AS
 SELECT osoba.oib,
    osoba.briskaznice,
    osoba.ime,
    osoba.prezime,
    osoba."datumro�enja",
    osoba.klubid,
    trener.licencado
   FROM (public.osoba
     JOIN public.trener USING (oib));


ALTER TABLE public.trenerosoba OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18237)
-- Name: kickboxingklubovijson3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson3 AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(row_to_json(clanosoba.*)) AS json_agg
           FROM public.clanosoba
          WHERE (klub.klubid = clanosoba.klubid)) AS "�lanovi",
    ( SELECT json_agg(row_to_json(trenerosoba.*)) AS json_agg
           FROM public.trenerosoba
          WHERE (klub.klubid = trenerosoba.klubid)) AS treneri
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson3 OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 18241)
-- Name: kickboxingklubovijson4; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson4 AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(row_to_json(clanosoba.*)) AS json_agg
           FROM public.clanosoba
          WHERE (klub.klubid = clanosoba.klubid)) AS "�lanovi",
    ( SELECT json_agg(row_to_json(trenerosoba.*)) AS json_agg
           FROM public.trenerosoba
          WHERE (klub.klubid = trenerosoba.klubid)) AS trener
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson4 OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18254)
-- Name: kickboxingklubovijson5; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kickboxingklubovijson5 AS
 SELECT klub.naziv,
    klub.klubid,
    klub.godinaosnivanja,
    klub."sjedi�te",
    klub."dr�ava",
    klub.email,
    ( SELECT json_agg(row_to_json(clanosoba.*)) AS json_agg
           FROM public.clanosoba
          WHERE (klub.klubid = clanosoba.klubid)) AS "�lanovi",
    ( SELECT row_to_json(trenerosoba.*) AS row_to_json
           FROM public.trenerosoba
          WHERE (klub.klubid = trenerosoba.klubid)) AS trener
   FROM public.klub;


ALTER TABLE public.kickboxingklubovijson5 OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 18174)
-- Name: klub_klubid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.klub_klubid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.klub_klubid_seq OWNER TO postgres;

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 209
-- Name: klub_klubid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.klub_klubid_seq OWNED BY public.klub.klubid;


--
-- TOC entry 211 (class 1259 OID 18181)
-- Name: osoba_briskaznice_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.osoba_briskaznice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.osoba_briskaznice_seq OWNER TO postgres;

--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 211
-- Name: osoba_briskaznice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.osoba_briskaznice_seq OWNED BY public.osoba.briskaznice;


--
-- TOC entry 3209 (class 2604 OID 18178)
-- Name: klub klubid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klub ALTER COLUMN klubid SET DEFAULT nextval('public.klub_klubid_seq'::regclass);


--
-- TOC entry 3210 (class 2604 OID 18185)
-- Name: osoba briskaznice; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.osoba ALTER COLUMN briskaznice SET DEFAULT nextval('public.osoba_briskaznice_seq'::regclass);


--
-- TOC entry 3372 (class 0 OID 18175)
-- Dependencies: 210
-- Data for Name: klub; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klub (naziv, klubid, godinaosnivanja, "sjedi�te", "dr�ava", email) FROM stdin;
KBK KUTINA	1	1998	Kutina	Hrvatska	josip.cerovec@sk.t-com.hr
KBK IMPACT	2	2011	Na�ice	Hrvatska	stjepan.paska@gmail.com
KBK BTI	3	1997	Zabok	Hrvatska	zvonko.kar@kr.t-com.hr
KBK SPARTAN GYM	4	2006	Zagreb	Hrvatska	acopupac@gmail.com
\.


--
-- TOC entry 3374 (class 0 OID 18182)
-- Dependencies: 212
-- Data for Name: osoba; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.osoba (briskaznice, ime, prezime, "datumro�enja", oib, klubid) FROM stdin;
1	Ana	Ani�	2005-01-01	11111111111	1
2	Ivo	Ivi�	2011-02-02	22222222222	1
3	Mate	Mati�	1993-03-03	33333333333	2
4	Marija	Mari�	1980-04-04	44444444444	4
5	Petar	Petri�	1995-03-10	12345678910	3
6	Lorena	Horvat	2010-04-20	12345678911	4
7	Iva	Grgi�	2006-05-30	12345678912	4
8	Luka	Luki�	1970-06-10	12345678913	2
9	Ivan	Babi�	1965-07-21	12345678914	1
10	Nora	Novak	1985-09-09	12345678915	3
11	Marina	Petrovi�	2008-08-28	12345678920	2
12	Zoran	Kova�	2004-06-21	12345678921	3
13	Boris	Bunti�	1999-03-18	12345678922	2
14	�eljka	Mitrovi�	2005-05-10	12345678923	3
15	Nora	Stani�	2000-03-13	12345678924	4
16	Senka	Bo�i�	1994-10-10	12345678925	4
17	Marin	Erli�	2001-12-14	12345678926	1
18	Marta	Kova�i�	2007-02-19	12345678927	2
\.


--
-- TOC entry 3376 (class 0 OID 18205)
-- Dependencies: 214
-- Data for Name: trener; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trener (licencado, oib) FROM stdin;
2030-01-01	44444444444
2025-01-01	12345678913
2027-01-01	12345678914
2028-01-01	12345678915
\.


--
-- TOC entry 3375 (class 0 OID 18195)
-- Dependencies: 213
-- Data for Name: �lan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."�lan" (uzrast, "te�ina", spol, oib) FROM stdin;
Juniori	-55 kg	�	11111111111
Kadeti	-69 kg	M	22222222222
Seniori	-75 kg	M	33333333333
Seniori	-81 kg	M	12345678910
Kadeti	-37 kg	F	12345678911
Juniori	-65 kg	F	12345678912
Kadeti	-46 kg	�	12345678920
Juniori	-84 kg	M	12345678921
Seniori	-91 kg	M	12345678922
Juniori	-60 kg	�	12345678923
Seniori	-50 kg	�	12345678924
Seniori	-70 kg	�	12345678925
Seniori	-69 kg	M	12345678926
Kadeti	-55 kg	�	12345678927
\.


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 209
-- Name: klub_klubid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klub_klubid_seq', 4, true);


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 211
-- Name: osoba_briskaznice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.osoba_briskaznice_seq', 18, true);


--
-- TOC entry 3212 (class 2606 OID 18180)
-- Name: klub klub_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klub
    ADD CONSTRAINT klub_pkey PRIMARY KEY (klubid);


--
-- TOC entry 3214 (class 2606 OID 18189)
-- Name: osoba osoba_briskaznice_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT osoba_briskaznice_key UNIQUE (briskaznice);


--
-- TOC entry 3216 (class 2606 OID 18187)
-- Name: osoba osoba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT osoba_pkey PRIMARY KEY (oib);


--
-- TOC entry 3220 (class 2606 OID 18209)
-- Name: trener trener_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trener
    ADD CONSTRAINT trener_pkey PRIMARY KEY (oib);


--
-- TOC entry 3218 (class 2606 OID 18199)
-- Name: �lan �lan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."�lan"
    ADD CONSTRAINT "�lan_pkey" PRIMARY KEY (oib);


--
-- TOC entry 3221 (class 2606 OID 18190)
-- Name: osoba osoba_klubid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT osoba_klubid_fkey FOREIGN KEY (klubid) REFERENCES public.klub(klubid);


--
-- TOC entry 3223 (class 2606 OID 18210)
-- Name: trener trener_oib_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trener
    ADD CONSTRAINT trener_oib_fkey FOREIGN KEY (oib) REFERENCES public.osoba(oib);


--
-- TOC entry 3222 (class 2606 OID 18200)
-- Name: �lan �lan_oib_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."�lan"
    ADD CONSTRAINT "�lan_oib_fkey" FOREIGN KEY (oib) REFERENCES public.osoba(oib);


-- Completed on 2022-11-02 10:43:53

--
-- PostgreSQL database dump complete
--

