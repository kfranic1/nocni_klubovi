PGDMP     0    -    
        
    z            postgres    15.0    15.0                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    5    postgres    DATABASE     ?   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3346                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false                       0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2            ?            1259    16518    clubs    TABLE     ?  CREATE TABLE public.clubs (
    club_name character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    phone_number character varying(20),
    instagram character varying(255),
    work_hours integer,
    rating numeric,
    music_genre character varying(255),
    bottle_service character varying(255)[],
    club_id integer NOT NULL
);
    DROP TABLE public.clubs;
       public         heap    postgres    false            ?            1259    16538    clubs_club_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.clubs_club_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.clubs_club_id_seq;
       public          postgres    false    217                       0    0    clubs_club_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.clubs_club_id_seq OWNED BY public.clubs.club_id;
          public          postgres    false    218            ?            1259    16510 	   workhours    TABLE     4  CREATE TABLE public.workhours (
    work_hours_id integer NOT NULL,
    pon time without time zone[],
    uto time without time zone[],
    sri time without time zone[],
    cet time without time zone[],
    pet time without time zone[],
    sub time without time zone[],
    ned time without time zone[]
);
    DROP TABLE public.workhours;
       public         heap    postgres    false            ?            1259    16615    out_csv    VIEW     ?  CREATE VIEW public.out_csv AS
 SELECT clubs.club_id,
    clubs.club_name,
    clubs.city,
    clubs.address,
    clubs.phone_number,
    clubs.instagram,
    clubs.rating,
    clubs.music_genre,
    clubs.bottle_service,
    workhours.pon,
    workhours.uto,
    workhours.sri,
    workhours.cet,
    workhours.pet,
    workhours.sub,
    workhours.ned
   FROM (public.clubs
     JOIN public.workhours ON ((clubs.work_hours = workhours.work_hours_id)));
    DROP VIEW public.out_csv;
       public          postgres    false    216    217    217    217    217    217    217    217    217    217    217    216    216    216    216    216    216    216            ?            1259    16610    out_json    VIEW     ?  CREATE VIEW public.out_json AS
 SELECT clubs.club_id,
    clubs.club_name,
    clubs.city,
    clubs.address,
    clubs.phone_number,
    clubs.instagram,
    clubs.rating,
    clubs.music_genre,
    clubs.bottle_service,
    workhours.work_hours
   FROM (public.clubs
     LEFT JOIN ( SELECT workhours_1.work_hours_id,
            json_agg(workhours_1.* ORDER BY ROW(workhours_1.pon, workhours_1.uto, workhours_1.sri, workhours_1.cet, workhours_1.pet, workhours_1.sub, workhours_1.ned)) AS work_hours
           FROM public.workhours workhours_1
          GROUP BY workhours_1.work_hours_id) workhours ON ((workhours.work_hours_id = clubs.work_hours)));
    DROP VIEW public.out_json;
       public          postgres    false    216    216    216    216    217    217    217    217    217    217    217    217    217    217    216    216    216    216            ?            1259    16509    workhours_work_hours_id_seq    SEQUENCE     ?   ALTER TABLE public.workhours ALTER COLUMN work_hours_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.workhours_work_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    216            s           2604    16539    clubs club_id    DEFAULT     n   ALTER TABLE ONLY public.clubs ALTER COLUMN club_id SET DEFAULT nextval('public.clubs_club_id_seq'::regclass);
 <   ALTER TABLE public.clubs ALTER COLUMN club_id DROP DEFAULT;
       public          postgres    false    218    217                      0    16518    clubs 
   TABLE DATA           ?   COPY public.clubs (club_name, city, address, phone_number, instagram, work_hours, rating, music_genre, bottle_service, club_id) FROM stdin;
    public          postgres    false    217          
          0    16510 	   workhours 
   TABLE DATA           U   COPY public.workhours (work_hours_id, pon, uto, sri, cet, pet, sub, ned) FROM stdin;
    public          postgres    false    216   ?                  0    0    clubs_club_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.clubs_club_id_seq', 10, true);
          public          postgres    false    218                       0    0    workhours_work_hours_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.workhours_work_hours_id_seq', 10, true);
          public          postgres    false    215            w           2606    16541    clubs clubs_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (club_id);
 :   ALTER TABLE ONLY public.clubs DROP CONSTRAINT clubs_pkey;
       public            postgres    false    217            u           2606    16516 %   workhours workhours_work_hours_id_key 
   CONSTRAINT     i   ALTER TABLE ONLY public.workhours
    ADD CONSTRAINT workhours_work_hours_id_key UNIQUE (work_hours_id);
 O   ALTER TABLE ONLY public.workhours DROP CONSTRAINT workhours_work_hours_id_key;
       public            postgres    false    216            x           2606    16523    clubs clubs_work_hours_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT clubs_work_hours_fkey FOREIGN KEY (work_hours) REFERENCES public.workhours(work_hours_id);
 E   ALTER TABLE ONLY public.clubs DROP CONSTRAINT clubs_work_hours_fkey;
       public          postgres    false    217    3189    216               ?  x?}??nA?ϳOaqh/t?O`{#?J??$"j?H? .3??.?T9?ԇ軤?U?!R?H?J^?????,?qj0?c?M?=??????Y??x???t!???{?kC??%	t????>[??7????n??P6%?v?z?Ih ?cq??|?]6?r?S????????+?Ҷ?g|?V?????`?54????[O?w>]???N???&?Za??0I?R???2?9X??Lq?gJ??8C.%??+$.9?x*???l?+^t"?"?р????BjC?ƶ?????Љ?q??#-Y???R??<Uzc?r??#B??!?Q?o@S??aC???P)?+Qo`????R/?HmĒ+5˧??????^??5p???<>??L??Tӑ?6z???vk/??????~E?????\(2]?TǕֲ??"%,????2?"???Z??;?څ???ԙ}Ƚ?Ƀ?B???r?na???1|?,??߆???
????O,v?H}Ȩ?)u?B?????Q8A[???(ꮥɝ???{??>?q??$iV???إ?]b?p???X???&?
S#??V??RJ???h???c??#)?CP?)?;.k?8???V?GXpb?F??m?+g,]OM??T?|ϸ??ܵ??????|???n?Ѯ4?y??'g??8??b???<_?}?|???ｂA/wnX?"Ȫ?A??G?ElCX?????9??8? ??̧      
   ?   x?3???C?j##+ ?10?0j??L??!b1~\F?4?b?h ?h?????R?:??1???)?G??
`1S?/3<aM8
?M2GF??M??9
,H?td-????pc?b?????? /?<     